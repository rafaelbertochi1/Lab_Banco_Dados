"""
Gera os PDFs da documentacao a partir de documento_projeto.html.

  python gerar_documento.py
    -> Documento_Projeto_Grupo5.pdf  (documento completo)
    -> Termo_de_Entrega.pdf          (so o termo, para imprimir e assinar)

Depois de assinar e fotografar, salve nesta pasta e rode de novo:
  termo_assinado.jpg  -> substitui o termo em branco na secao 8
  foto_entrega.jpg    -> substitui o quadro reservado na secao 9

Requer: pip install playwright && python -m playwright install chromium
"""
import re
from pathlib import Path

from playwright.sync_api import sync_playwright

BASE = Path(__file__).parent
RODAPE = (
    '<div style="width:100%;font:8px Segoe UI,sans-serif;color:#85837d;padding:0 16mm;'
    'display:flex;justify-content:space-between">'
    "<span>Grupo 5 · Sistema de Gestão de Salão · Entrega 4</span>"
    '<span><span class="pageNumber"></span> / <span class="totalPages"></span></span></div>'
)


def trocar(html, marca, novo):
    return re.sub(rf"<!--{marca}-->.*?<!--/{marca}-->", novo, html, flags=re.S)


def main():
    html = (BASE / "documento_projeto.html").read_text(encoding="utf-8")

    termo = re.search(r"<!--TERMO-->(.*?)<!--/TERMO-->", html, flags=re.S).group(1)
    if (BASE / "termo_assinado.jpg").exists():
        html = trocar(html, "TERMO", '<figure><img src="termo_assinado.jpg"><figcaption>Termo de entrega assinado.</figcaption></figure>')
    if (BASE / "foto_entrega.jpg").exists():
        html = trocar(html, "FOTO", '<figure><img src="foto_entrega.jpg"><figcaption>Foto da entrega do projeto.</figcaption></figure>')

    final = BASE / "_documento_final.html"
    final.write_text(html, encoding="utf-8")

    # Termo avulso: reaproveita o <head> (estilos) do documento
    cabeca = html.split("<body>")[0]
    avulso = BASE / "_termo.html"
    avulso.write_text(f"{cabeca}<body><section>{termo}</section></body></html>", encoding="utf-8")

    with sync_playwright() as p:
        navegador = p.chromium.launch()
        pagina = navegador.new_page()
        pagina.goto(final.as_uri())
        pagina.wait_for_load_state("networkidle")
        pagina.pdf(path=str(BASE / "Documento_Projeto_Grupo5.pdf"), format="A4", print_background=True,
                   display_header_footer=True, header_template="<span></span>", footer_template=RODAPE,
                   margin={"top": "18mm", "bottom": "18mm", "left": "16mm", "right": "16mm"})
        pagina.goto(avulso.as_uri())
        pagina.wait_for_load_state("networkidle")
        pagina.pdf(path=str(BASE / "Termo_de_Entrega.pdf"), format="A4", print_background=True,
                   margin={"top": "18mm", "bottom": "18mm", "left": "16mm", "right": "16mm"})
        navegador.close()
    final.unlink()
    avulso.unlink()
    print("ok: Documento_Projeto_Grupo5.pdf e Termo_de_Entrega.pdf")


if __name__ == "__main__":
    main()
