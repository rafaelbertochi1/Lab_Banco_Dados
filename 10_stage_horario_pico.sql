/* ============================================================================
   Entrega 4 - STAGE DE HORARIO DE PICO
   Responsavel: Rafael Bertochi Figueiredo
   Executar conectado como DW, depois do 06_dw.sql.
   Movimento e faturamento por hora do dia, juntando a base atual com o
   historico de atendimentos. A hora usada e a do fechamento da conta
   (data de pagamento), nao a da chegada da cliente.
   ============================================================================ */

--- View Dinamica ---
CREATE OR REPLACE VIEW "VW_STAGE_HORARIO_PICO" AS
SELECT
    TO_CHAR(r.dt_pagamento, 'HH24') || 'h' AS faixa_horario,
    COUNT(*) AS qtd_atendimentos,
    SUM(r.total_geral) AS faturamento,
    ROUND(AVG(r.total_geral), 2) AS ticket_medio,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_atendimentos,
    ROUND(100 * SUM(r.total_geral) / SUM(SUM(r.total_geral)) OVER (), 2) AS pct_faturamento
FROM (
    SELECT atd_id AS id, atd_dt_pagamento AS dt_pagamento, atd_tipo AS tipo, atd_total_geral AS total_geral
    FROM APP.ATENDIMENTO
    UNION ALL
    SELECT id, dt_pagamento, tipo, total_geral
    FROM (
        SELECT h.hatd_id AS id, h.hatd_dt_pagamento AS dt_pagamento, h.hatd_tipo AS tipo, h.hatd_total_geral AS total_geral,
               ROW_NUMBER() OVER (PARTITION BY h.hatd_id ORDER BY h.hatd_dt_entrada DESC) AS versao
        FROM APP.H_ATENDIMENTO h
        WHERE NOT EXISTS (SELECT 1 FROM APP.ATENDIMENTO a WHERE a.atd_id = h.hatd_id)
    )
    WHERE versao = 1
) r
WHERE r.tipo = 'Pagamento'
  AND r.dt_pagamento IS NOT NULL
GROUP BY TO_CHAR(r.dt_pagamento, 'HH24');


---View Materializada ---
CREATE MATERIALIZED VIEW "STAGE_HORARIO_PICO"
(
    "FAIXA_HORARIO",
    "QTD_ATENDIMENTOS",
    "FATURAMENTO",
    "TICKET_MEDIO",
    "PCT_ATENDIMENTOS",
    "PCT_FATURAMENTO"
)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
AS
SELECT
    TO_CHAR(r.dt_pagamento, 'HH24') || 'h' AS faixa_horario,
    COUNT(*) AS qtd_atendimentos,
    SUM(r.total_geral) AS faturamento,
    ROUND(AVG(r.total_geral), 2) AS ticket_medio,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_atendimentos,
    ROUND(100 * SUM(r.total_geral) / SUM(SUM(r.total_geral)) OVER (), 2) AS pct_faturamento
FROM (
    SELECT atd_id AS id, atd_dt_pagamento AS dt_pagamento, atd_tipo AS tipo, atd_total_geral AS total_geral
    FROM APP.ATENDIMENTO
    UNION ALL
    SELECT id, dt_pagamento, tipo, total_geral
    FROM (
        SELECT h.hatd_id AS id, h.hatd_dt_pagamento AS dt_pagamento, h.hatd_tipo AS tipo, h.hatd_total_geral AS total_geral,
               ROW_NUMBER() OVER (PARTITION BY h.hatd_id ORDER BY h.hatd_dt_entrada DESC) AS versao
        FROM APP.H_ATENDIMENTO h
        WHERE NOT EXISTS (SELECT 1 FROM APP.ATENDIMENTO a WHERE a.atd_id = h.hatd_id)
    )
    WHERE versao = 1
) r
WHERE r.tipo = 'Pagamento'
  AND r.dt_pagamento IS NOT NULL
GROUP BY TO_CHAR(r.dt_pagamento, 'HH24');

COMMENT ON MATERIALIZED VIEW "STAGE_HORARIO_PICO" IS 'Atendimentos e faturamento por hora do dia (base atual + historico)';


--- Consulta das transformacoes STAGE HORARIO PICO ---
SELECT
    faixa_horario,
    qtd_atendimentos,
    faturamento,
    ticket_medio,
    pct_atendimentos,
    pct_faturamento
FROM
    STAGE_HORARIO_PICO
ORDER BY
    faixa_horario;
