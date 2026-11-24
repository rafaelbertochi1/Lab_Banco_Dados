/* ============================================================================
   Entrega 4 - STAGE DE FATURAMENTO MENSAL
   Responsavel: Joao Vitor Dornelas Correa
   Executar conectado como DW, depois do 06_dw.sql.
   Junta os atendimentos atuais (APP.ATENDIMENTO) com os que ja foram para o
   historico (APP.H_ATENDIMENTO). Do historico entra so a ultima versao de cada
   atendimento que nao existe mais na tabela atual.
   ============================================================================ */

--- View Dinamica ---
CREATE OR REPLACE VIEW "VW_STAGE_FATURAMENTO_MENSAL" AS
SELECT
    TO_CHAR(r.dt_atendimento, 'YYYY-MM') AS mes,
    COUNT(*) AS qtd_atendimentos,
    COUNT(DISTINCT r.cli_id) AS clientes_atendidos,
    SUM(r.total_geral) AS faturamento,
    ROUND(AVG(r.total_geral), 2) AS ticket_medio,
    SUM(ABS(r.total_descontos)) AS total_descontos,
    ROUND(100 * SUM(r.total_geral) / SUM(SUM(r.total_geral)) OVER (), 2) AS pct_faturamento_total
FROM (
    SELECT atd_id AS id, atd_dt_atendimento AS dt_atendimento, atd_tipo AS tipo, atd_cli_id AS cli_id,
           atd_total_geral AS total_geral, atd_total_descontos AS total_descontos
    FROM APP.ATENDIMENTO
    UNION ALL
    SELECT id, dt_atendimento, tipo, cli_id, total_geral, total_descontos
    FROM (
        SELECT h.hatd_id AS id, h.hatd_dt_atendimento AS dt_atendimento, h.hatd_tipo AS tipo, h.hatd_cli_id AS cli_id,
               h.hatd_total_geral AS total_geral, h.hatd_total_descontos AS total_descontos,
               ROW_NUMBER() OVER (PARTITION BY h.hatd_id ORDER BY h.hatd_dt_entrada DESC) AS versao
        FROM APP.H_ATENDIMENTO h
        WHERE NOT EXISTS (SELECT 1 FROM APP.ATENDIMENTO a WHERE a.atd_id = h.hatd_id)
    )
    WHERE versao = 1
) r
WHERE r.tipo = 'Pagamento'
GROUP BY TO_CHAR(r.dt_atendimento, 'YYYY-MM');


---View Materializada ---
CREATE MATERIALIZED VIEW "STAGE_FATURAMENTO_MENSAL"
(
    "MES",
    "QTD_ATENDIMENTOS",
    "CLIENTES_ATENDIDOS",
    "FATURAMENTO",
    "TICKET_MEDIO",
    "TOTAL_DESCONTOS",
    "PCT_FATURAMENTO_TOTAL"
)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
AS
SELECT
    TO_CHAR(r.dt_atendimento, 'YYYY-MM') AS mes,
    COUNT(*) AS qtd_atendimentos,
    COUNT(DISTINCT r.cli_id) AS clientes_atendidos,
    SUM(r.total_geral) AS faturamento,
    ROUND(AVG(r.total_geral), 2) AS ticket_medio,
    SUM(ABS(r.total_descontos)) AS total_descontos,
    ROUND(100 * SUM(r.total_geral) / SUM(SUM(r.total_geral)) OVER (), 2) AS pct_faturamento_total
FROM (
    SELECT atd_id AS id, atd_dt_atendimento AS dt_atendimento, atd_tipo AS tipo, atd_cli_id AS cli_id,
           atd_total_geral AS total_geral, atd_total_descontos AS total_descontos
    FROM APP.ATENDIMENTO
    UNION ALL
    SELECT id, dt_atendimento, tipo, cli_id, total_geral, total_descontos
    FROM (
        SELECT h.hatd_id AS id, h.hatd_dt_atendimento AS dt_atendimento, h.hatd_tipo AS tipo, h.hatd_cli_id AS cli_id,
               h.hatd_total_geral AS total_geral, h.hatd_total_descontos AS total_descontos,
               ROW_NUMBER() OVER (PARTITION BY h.hatd_id ORDER BY h.hatd_dt_entrada DESC) AS versao
        FROM APP.H_ATENDIMENTO h
        WHERE NOT EXISTS (SELECT 1 FROM APP.ATENDIMENTO a WHERE a.atd_id = h.hatd_id)
    )
    WHERE versao = 1
) r
WHERE r.tipo = 'Pagamento'
GROUP BY TO_CHAR(r.dt_atendimento, 'YYYY-MM');

COMMENT ON MATERIALIZED VIEW "STAGE_FATURAMENTO_MENSAL" IS 'Faturamento, atendimentos e ticket medio por mes (base atual + historico)';


--- Consulta das transformacoes STAGE FATURAMENTO MENSAL ---
SELECT
    mes,
    qtd_atendimentos,
    clientes_atendidos,
    faturamento,
    ticket_medio,
    total_descontos,
    pct_faturamento_total
FROM
    STAGE_FATURAMENTO_MENSAL
ORDER BY
    mes;
