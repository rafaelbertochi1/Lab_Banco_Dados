"""
Gera o dashboard do DW (dashboard.html) e os prints em PNG.

Fluxo:
  1. Exportar as stages do esquema DW para dados/*.csv (SELECT * FROM STAGE_...).
  2. python gerar_dashboard.py
     -> dashboard.html (abre no navegador, com tooltips)
     -> prints/*.png (pagina inteira e um print por painel)

Requer: pip install playwright && python -m playwright install chromium
"""
import csv
import json
from pathlib import Path

from playwright.sync_api import sync_playwright

BASE = Path(__file__).parent
DADOS = BASE / "dados"
PRINTS = BASE / "prints"


def ler(nome):
    with open(DADOS / f"{nome}.csv", encoding="utf-8") as f:
        linhas = list(csv.DictReader(f))
    for linha in linhas:
        for chave, valor in linha.items():
            try:
                linha[chave] = float(valor)
            except ValueError:
                pass
    return linhas


def main():
    dados = {
        "mensal": sorted(ler("STAGE_FATURAMENTO_MENSAL"), key=lambda r: r["MES"]),
        "pagamento": sorted(ler("STAGE_FORMA_PAGAMENTO"), key=lambda r: -r["VALOR_TOTAL"]),
        "frequencia": sorted(ler("STAGE_FREQUENCIA_CLIENTE"), key=lambda r: r["MIN_VISITAS"]),
        "horario": sorted(ler("STAGE_HORARIO_PICO"), key=lambda r: r["FAIXA_HORARIO"]),
    }
    modelo = (BASE / "dashboard_modelo.html").read_text(encoding="utf-8")
    html = modelo.replace("/*__DADOS__*/null", json.dumps(dados, ensure_ascii=False))
    destino = BASE / "dashboard.html"
    destino.write_text(html, encoding="utf-8")

    PRINTS.mkdir(exist_ok=True)
    with sync_playwright() as p:
        navegador = p.chromium.launch()
        pagina = navegador.new_page(viewport={"width": 1440, "height": 900}, device_scale_factor=2)
        pagina.goto(destino.as_uri())
        pagina.wait_for_timeout(300)
        pagina.screenshot(path=str(PRINTS / "00_dashboard_completo.png"), full_page=True)
        paineis = {
            "01_JOAO_faturamento_mensal": "#painel-mensal",
            "02_GABRIELA_forma_pagamento": "#painel-pagamento",
            "03_ARTHUR_frequencia_clientes": "#painel-frequencia",
            "04_RAFAEL_horario_pico": "#painel-horario",
        }
        for arquivo, seletor in paineis.items():
            pagina.locator(seletor).screenshot(path=str(PRINTS / f"{arquivo}.png"))
        navegador.close()
    print("ok:", destino, "e", len(paineis) + 1, "prints em", PRINTS)


if __name__ == "__main__":
    main()
