/* ============================================================================
   Historico de atendimentos - schema APP
   Executar depois do 03_dados.sql, conectado como APP.
   Exclui os atendimentos ate julho/2026. O trigger TG_HATD copia cada linha
   excluida para H_ATENDIMENTO, com a data de entrada (HATD_DT_ENTRADA).
   ============================================================================ */
DELETE FROM "APP"."ATENDIMENTO" WHERE "ATD_DT_ATENDIMENTO" < DATE '2026-08-01';

COMMIT;
