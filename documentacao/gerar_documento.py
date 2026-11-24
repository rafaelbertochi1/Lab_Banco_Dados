"""
Gera o PDF do documento do projeto a partir de documento_projeto.html.

  python gerar_documento.py
    -> Documento_Projeto_Grupo5_Entrega4.pdf

Requer: pip install playwright && python -m playwright install chromium
"""
from pathlib import Path

from playwright.sync_api import sync_playwright

BASE = Path(__file__).parent
SAIDA = BASE / "Documento_Projeto_Grupo5_Entrega4.pdf"
RODAPE = (
    '<div style="width:100%;font:8px Segoe UI,sans-serif;color:#85837d;padding:0 16mm;'
    'display:flex;justify-content:space-between">'
    "<span>Grupo 5 · Sistema de Gestão de Salão · Entrega 4</span>"
    '<span><span class="pageNumber"></span> / <span class="totalPages"></span></span></div>'
)


def main():
    with sync_playwright() as p:
        navegador = p.chromium.launch()
        pagina = navegador.new_page()
        pagina.goto((BASE / "documento_projeto.html").as_uri())
        pagina.wait_for_load_state("networkidle")
        pagina.pdf(path=str(SAIDA), format="A4", print_background=True,
                   display_header_footer=True, header_template="<span></span>", footer_template=RODAPE,
                   margin={"top": "18mm", "bottom": "18mm", "left": "16mm", "right": "16mm"})
        navegador.close()
    print("ok:", SAIDA.name)


if __name__ == "__main__":
    main()
