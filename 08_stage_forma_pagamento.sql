/* ============================================================================
   Entrega 4 - STAGE DE FORMAS DE PAGAMENTO
   Responsavel: Gabriela Silveira Lima
   Executar conectado como DW, depois do 06_dw.sql.
   Junta os pagamentos atuais (APP.PAGAMENTO_ATENDIMENTO) com os que ja foram
   para o historico (APP.H_PAGAMENTO_ATENDIMENTO). Pagamentos com valor
   negativo (pre-pago consumido e troco) sao ajustes e ficam fora.
   ============================================================================ */

--- View Dinamica ---
CREATE OR REPLACE VIEW "VW_STAGE_FORMA_PAGAMENTO" AS
SELECT
    f.fpg_descricao AS forma_pagamento,
    COUNT(*) AS qtd_transacoes,
    SUM(r.valor) AS valor_total,
    ROUND(AVG(r.valor), 2) AS valor_medio,
    MAX(r.valor) AS maior_pagamento,
    ROUND(100 * SUM(r.valor) / SUM(SUM(r.valor)) OVER (), 2) AS pct_valor_recebido
FROM (
    SELECT pga_atd_id AS atd_id, pga_fpg_id AS fpg_id, pga_valor AS valor
    FROM APP.PAGAMENTO_ATENDIMENTO
    UNION ALL
    SELECT atd_id, fpg_id, valor
    FROM (
        SELECT h.hpga_atd_id AS atd_id, h.hpga_fpg_id AS fpg_id, h.hpga_valor AS valor,
               ROW_NUMBER() OVER (PARTITION BY h.hpga_atd_id, h.hpga_fpg_id ORDER BY h.hpga_dt_entrada DESC) AS versao
        FROM APP.H_PAGAMENTO_ATENDIMENTO h
        WHERE NOT EXISTS (SELECT 1 FROM APP.PAGAMENTO_ATENDIMENTO p
                          WHERE p.pga_atd_id = h.hpga_atd_id AND p.pga_fpg_id = h.hpga_fpg_id)
    )
    WHERE versao = 1
) r
JOIN APP.FORMA_PAGAMENTO f ON f.fpg_id = r.fpg_id
WHERE r.valor > 0
GROUP BY f.fpg_descricao;


---View Materializada ---
CREATE MATERIALIZED VIEW "STAGE_FORMA_PAGAMENTO"
(
    "FORMA_PAGAMENTO",
    "QTD_TRANSACOES",
    "VALOR_TOTAL",
    "VALOR_MEDIO",
    "MAIOR_PAGAMENTO",
    "PCT_VALOR_RECEBIDO"
)
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
AS
SELECT
    f.fpg_descricao AS forma_pagamento,
    COUNT(*) AS qtd_transacoes,
    SUM(r.valor) AS valor_total,
    ROUND(AVG(r.valor), 2) AS valor_medio,
    MAX(r.valor) AS maior_pagamento,
    ROUND(100 * SUM(r.valor) / SUM(SUM(r.valor)) OVER (), 2) AS pct_valor_recebido
FROM (
    SELECT pga_atd_id AS atd_id, pga_fpg_id AS fpg_id, pga_valor AS valor
    FROM APP.PAGAMENTO_ATENDIMENTO
    UNION ALL
    SELECT atd_id, fpg_id, valor
    FROM (
        SELECT h.hpga_atd_id AS atd_id, h.hpga_fpg_id AS fpg_id, h.hpga_valor AS valor,
               ROW_NUMBER() OVER (PARTITION BY h.hpga_atd_id, h.hpga_fpg_id ORDER BY h.hpga_dt_entrada DESC) AS versao
        FROM APP.H_PAGAMENTO_ATENDIMENTO h
        WHERE NOT EXISTS (SELECT 1 FROM APP.PAGAMENTO_ATENDIMENTO p
                          WHERE p.pga_atd_id = h.hpga_atd_id AND p.pga_fpg_id = h.hpga_fpg_id)
    )
    WHERE versao = 1
) r
JOIN APP.FORMA_PAGAMENTO f ON f.fpg_id = r.fpg_id
WHERE r.valor > 0
GROUP BY f.fpg_descricao;

COMMENT ON MATERIALIZED VIEW "STAGE_FORMA_PAGAMENTO" IS 'Valor recebido e transacoes por forma de pagamento (base atual + historico)';


--- Consulta das transformacoes STAGE FORMA PAGAMENTO ---
SELECT
    forma_pagamento,
    qtd_transacoes,
    valor_total,
    valor_medio,
    maior_pagamento,
    pct_valor_recebido
FROM
    STAGE_FORMA_PAGAMENTO
ORDER BY
    valor_total DESC;
