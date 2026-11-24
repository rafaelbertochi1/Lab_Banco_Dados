/* ============================================================================
   Entrega 4 - Usuario DW (Data Warehouse / BI)
   Executar conectado como SYS (ou SYSTEM), depois do 05_historico.sql.
   O DW so le os dados do APP: recebe SELECT nas tabelas operacionais e nas
   tabelas de historico, e guarda as stages (views materializadas) no proprio
   esquema, separado da aplicacao (APP) e da auditoria (APP_AUDIT).
   ============================================================================ */
alter session set "_ORACLE_SCRIPT" = TRUE;

CREATE USER DW IDENTIFIED BY DW
QUOTA UNLIMITED ON USERS;
GRANT CONNECT, RESOURCE TO DW;
GRANT CREATE VIEW, CREATE MATERIALIZED VIEW TO DW;

-- Leitura das tabelas operacionais
GRANT SELECT ON APP.ATENDIMENTO TO DW;
GRANT SELECT ON APP.PAGAMENTO_ATENDIMENTO TO DW;
GRANT SELECT ON APP.CLIENTE TO DW;
GRANT SELECT ON APP.FUNCIONARIO TO DW;
GRANT SELECT ON APP.FORMA_PAGAMENTO TO DW;
GRANT SELECT ON APP.MOTIVO_DESCONTO TO DW;
GRANT SELECT ON APP.CAIXA_DIARIO TO DW;

-- Leitura das tabelas de historico
GRANT SELECT ON APP.H_ATENDIMENTO TO DW;
GRANT SELECT ON APP.H_PAGAMENTO_ATENDIMENTO TO DW;
GRANT SELECT ON APP.H_CLIENTE TO DW;
GRANT SELECT ON APP.H_FUNCIONARIO TO DW;
GRANT SELECT ON APP.H_FORMA_PAGAMENTO TO DW;
GRANT SELECT ON APP.H_MOTIVO_DESCONTO TO DW;
GRANT SELECT ON APP.H_CAIXA_DIARIO TO DW;
