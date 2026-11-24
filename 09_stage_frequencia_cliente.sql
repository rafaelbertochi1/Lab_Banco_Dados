/* ============================================================================
   Entrega 4 - STAGE DE FREQUENCIA DE CLIENTES
   Responsavel: Arthur Cavalcante e Silva
   Executar conectado como DW, depois do 06_dw.sql.
   Agrupa as clientes pela quantidade de visitas (dias diferentes com
   atendimento pago), juntando a base atual com o historico de atendimentos.
   ============================================================================ */

--- View Dinamica ---
CREATE OR REPLACE VIEW "VW_STAGE_FREQUENCIA_CLIENTE" AS
SELECT
    CASE
        WHEN v.qtd_visitas = 1 THEN '1 visita'
        WHEN v.qtd_visitas = 2 THEN '2 visitas'
        WHEN v.qtd_visitas <= 5 THEN '3 a 5 visitas'
        ELSE '6 ou mais'
    END AS faixa_frequencia,
    MIN(v.qtd_visitas) AS min_visitas,
    COUNT(*) AS qtd_clientes,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_clientes,
    SUM(v.valor_total) AS faturamento,
    ROUND(100 * SUM(v.valor_total) / SUM(SUM(v.valor_total)) OVER (), 2) AS pct_faturamento,
    ROUND(SUM(v.valor_total) / COUNT(*), 2) AS valor_medio_por_cliente
FROM (
    SELECT
        r.cli_id,
        COUNT(DISTINCT r.dt_atendimento) AS qtd_visitas,
        SUM(r.total_geral) AS valor_total
    FROM (
        SELECT atd_id AS id, atd_dt_atendimento AS dt_atendimento, atd_tipo AS tipo, atd_cli_id AS cli_id,
               atd_total_geral AS total_geral
        FROM APP.ATENDIMENTO
        UNION ALL
        SELECT id, dt_atendimento, tipo, cli_id, total_geral
        FROM (
            SELECT h.hatd_id AS id, h.hatd_dt_atendimento AS dt_atendimento, h.hatd_tipo AS tipo, h.hatd_cli_id AS cli_id,
                   h.hatd_total_geral AS total_geral,
                   ROW_NUMBER() OVER (PARTITION BY h.hatd_id ORDER BY h.hatd_dt_entrada DESC) AS versao
            FROM APP.H_ATENDIMENTO h
            WHERE NOT EXISTS (SELECT 1 FROM APP.ATENDIMENTO a WHERE a.atd_id = h.hatd_id)
        )
        WHERE versao = 1
    ) r
    WHERE r.tipo = 'Pagamento'
    GROUP BY r.cli_id
) v
GROUP BY
    CASE
        WHEN v.qtd_visitas = 1 THEN '1 visita'
        WHEN v.qtd_visitas = 2 THEN '2 visitas'
        WHEN v.qtd_visitas <= 5 THEN '3 a 5 visitas'
        ELSE '6 ou mais'
    END;


---View Materializada ---
CREATE MATERIALIZED VIEW "STAGE_FREQUENCIA_CLIENTE"
(
    "FAIXA_FREQUENCIA",
    "MIN_VISITAS",
    "QTD_CLIENTES",
    "PCT_CLIENTES",
    "FATURAMENTO",
    "PCT_FATURAMENTO",
    "VALOR_MEDIO_POR_CLIENTE"
)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
AS
SELECT
    CASE
        WHEN v.qtd_visitas = 1 THEN '1 visita'
        WHEN v.qtd_visitas = 2 THEN '2 visitas'
        WHEN v.qtd_visitas <= 5 THEN '3 a 5 visitas'
        ELSE '6 ou mais'
    END AS faixa_frequencia,
    MIN(v.qtd_visitas) AS min_visitas,
    COUNT(*) AS qtd_clientes,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_clientes,
    SUM(v.valor_total) AS faturamento,
    ROUND(100 * SUM(v.valor_total) / SUM(SUM(v.valor_total)) OVER (), 2) AS pct_faturamento,
    ROUND(SUM(v.valor_total) / COUNT(*), 2) AS valor_medio_por_cliente
FROM (
    SELECT
        r.cli_id,
        COUNT(DISTINCT r.dt_atendimento) AS qtd_visitas,
        SUM(r.total_geral) AS valor_total
    FROM (
        SELECT atd_id AS id, atd_dt_atendimento AS dt_atendimento, atd_tipo AS tipo, atd_cli_id AS cli_id,
               atd_total_geral AS total_geral
        FROM APP.ATENDIMENTO
        UNION ALL
        SELECT id, dt_atendimento, tipo, cli_id, total_geral
        FROM (
            SELECT h.hatd_id AS id, h.hatd_dt_atendimento AS dt_atendimento, h.hatd_tipo AS tipo, h.hatd_cli_id AS cli_id,
                   h.hatd_total_geral AS total_geral,
                   ROW_NUMBER() OVER (PARTITION BY h.hatd_id ORDER BY h.hatd_dt_entrada DESC) AS versao
            FROM APP.H_ATENDIMENTO h
            WHERE NOT EXISTS (SELECT 1 FROM APP.ATENDIMENTO a WHERE a.atd_id = h.hatd_id)
        )
        WHERE versao = 1
    ) r
    WHERE r.tipo = 'Pagamento'
    GROUP BY r.cli_id
) v
GROUP BY
    CASE
        WHEN v.qtd_visitas = 1 THEN '1 visita'
        WHEN v.qtd_visitas = 2 THEN '2 visitas'
        WHEN v.qtd_visitas <= 5 THEN '3 a 5 visitas'
        ELSE '6 ou mais'
    END;

COMMENT ON MATERIALIZED VIEW "STAGE_FREQUENCIA_CLIENTE" IS 'Clientes e faturamento por faixa de frequencia de visitas (base atual + historico)';


--- Consulta das transformacoes STAGE FREQUENCIA CLIENTE ---
SELECT
    faixa_frequencia,
    qtd_clientes,
    pct_clientes,
    faturamento,
    pct_faturamento,
    valor_medio_por_cliente
FROM
    STAGE_FREQUENCIA_CLIENTE
ORDER BY
    min_visitas;
