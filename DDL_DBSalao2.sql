--------------------------------------------------------
--  Arquivo criado - terça-feira-setembro-29-2026   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence SEQ_ATENDIMENTO
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."SEQ_ATENDIMENTO"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_ATENDIMENTO_LOG
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."SEQ_ATENDIMENTO_LOG"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 505 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_CAIXA_DIARIO
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."SEQ_CAIXA_DIARIO"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_CLIENTE
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."SEQ_CLIENTE"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_FORMA_PAGAMENTO
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."SEQ_FORMA_PAGAMENTO"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_FUNCIONARIO
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."SEQ_FUNCIONARIO"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_MOTIVO_DESCONTO
--------------------------------------------------------

   CREATE SEQUENCE  "SYSTEM"."SEQ_MOTIVO_DESCONTO"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Table ATENDIMENTO
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."ATENDIMENTO" 
   (	"ID_ATENDIMENTO" NUMBER(10,0), 
	"DATA_ATENDIMENTO" DATE, 
	"DATA_PAGAMENTO" DATE, 
	"TIPO" VARCHAR2(30 BYTE), 
	"ID_CLIENTE" NUMBER(10,0), 
	"ID_FUNCIONARIO" NUMBER(10,0), 
	"TOTAL_SERVICO" NUMBER(10,2) DEFAULT 0, 
	"QTD_SERVICO" NUMBER(5,0) DEFAULT 0, 
	"TOTAL_PRODUTOS" NUMBER(10,2) DEFAULT 0, 
	"QTD_PRODUTO" NUMBER(5,0) DEFAULT 0, 
	"TOTAL_PACOTES" NUMBER(10,2) DEFAULT 0, 
	"QTD_PACOTES" NUMBER(5,0) DEFAULT 0, 
	"TOTAL_VALE_PRESENTE" NUMBER(10,2) DEFAULT 0, 
	"QTD_VALE_PRESENTE" NUMBER(5,0) DEFAULT 0, 
	"TOTAL_CREDITO_CLIENTE" NUMBER(10,2) DEFAULT 0, 
	"TOTAL_DESCONTOS" NUMBER(10,2) DEFAULT 0, 
	"ID_MOTIVO" NUMBER(10,0), 
	"TOTAL_GERAL" NUMBER(10,2) DEFAULT 0, 
	"COMENTARIO_FECHAMENTO" VARCHAR2(500 BYTE), 
	"COMENTARIO_ESTORNO" VARCHAR2(500 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table ATENDIMENTO_LOG
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."ATENDIMENTO_LOG" SHARING=METADATA 
   (	"ID_LOG" NUMBER(10,0), 
	"DATA_EXCLUSAO" DATE DEFAULT SYSDATE, 
	"USUARIO_BD" VARCHAR2(60 BYTE) DEFAULT USER, 
	"ID_ATENDIMENTO" NUMBER(10,0), 
	"DATA_ATENDIMENTO" DATE, 
	"DATA_PAGAMENTO" DATE, 
	"TIPO" VARCHAR2(30 BYTE), 
	"ID_CLIENTE" NUMBER(10,0), 
	"ID_FUNCIONARIO" NUMBER(10,0), 
	"TOTAL_SERVICO" NUMBER(10,2), 
	"QTD_SERVICO" NUMBER(5,0), 
	"TOTAL_PRODUTOS" NUMBER(10,2), 
	"QTD_PRODUTO" NUMBER(5,0), 
	"TOTAL_PACOTES" NUMBER(10,2), 
	"QTD_PACOTES" NUMBER(5,0), 
	"TOTAL_VALE_PRESENTE" NUMBER(10,2), 
	"QTD_VALE_PRESENTE" NUMBER(5,0), 
	"TOTAL_CREDITO_CLIENTE" NUMBER(10,2), 
	"TOTAL_DESCONTOS" NUMBER(10,2), 
	"ID_MOTIVO" NUMBER(10,0), 
	"TOTAL_GERAL" NUMBER(10,2), 
	"COMENTARIO_FECHAMENTO" VARCHAR2(500 BYTE), 
	"COMENTARIO_ESTORNO" VARCHAR2(500 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table CAIXA_DIARIO
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."CAIXA_DIARIO" 
   (	"ID_CAIXA" NUMBER(10,0), 
	"DATA_MOVIMENTO" DATE, 
	"ABERTURA_CAIXA" NUMBER(10,2) DEFAULT 0, 
	"RECEBIDO_DINHEIRO" NUMBER(10,2) DEFAULT 0, 
	"TROCO" NUMBER(10,2) DEFAULT 0, 
	"DESPESAS_DINHEIRO" NUMBER(10,2) DEFAULT 0, 
	"TOTAL_DINHEIRO" NUMBER(10,2) DEFAULT 0, 
	"SANGRIA" NUMBER(10,2) DEFAULT 0, 
	"SALDO_CAIXA" NUMBER(10,2) DEFAULT 0, 
	"RECEBIDO_OUTRAS_FORMAS" NUMBER(10,2) DEFAULT 0, 
	"DESPESAS_OUTRAS_FORMAS" NUMBER(10,2) DEFAULT 0
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table CLIENTE
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."CLIENTE" 
   (	"ID_CLIENTE" NUMBER(10,0), 
	"NOME_CLIENTE" VARCHAR2(150 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table FORMA_PAGAMENTO
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."FORMA_PAGAMENTO" 
   (	"ID_FORMA" NUMBER(10,0), 
	"DESCRICAO" VARCHAR2(30 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table FUNCIONARIO
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."FUNCIONARIO" 
   (	"ID_FUNCIONARIO" NUMBER(10,0), 
	"NOME_FUNCIONARIO" VARCHAR2(100 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table MOTIVO_DESCONTO
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."MOTIVO_DESCONTO" 
   (	"ID_MOTIVO" NUMBER(10,0), 
	"DESCRICAO" VARCHAR2(200 BYTE)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for Table PAGAMENTO_ATENDIMENTO
--------------------------------------------------------

  CREATE TABLE "SYSTEM"."PAGAMENTO_ATENDIMENTO" 
   (	"ID_ATENDIMENTO" NUMBER(10,0), 
	"ID_FORMA" NUMBER(10,0), 
	"VALOR" NUMBER(10,2)
   ) PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SYSTEM" ;
--------------------------------------------------------
--  DDL for View MVIEW_EVALUATIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."MVIEW_EVALUATIONS" ("RUNID", "MVIEW_OWNER", "MVIEW_NAME", "RANK", "STORAGE_IN_BYTES", "FREQUENCY", "CUMULATIVE_BENEFIT", "BENEFIT_TO_COST_RATIO") AS 
  select
  t1.runid# as runid,
  summary_owner AS mview_owner,
  summary_name AS mview_name,
  rank# as rank,
  storage_in_bytes,
  frequency,
  cumulative_benefit,
  benefit_to_cost_ratio
from SYSTEM.MVIEW$_ADV_OUTPUT t1, SYSTEM.MVIEW$_ADV_LOG t2, SYS.ALL_USERS u
where
  t1.runid# = t2.runid# and
  u.username = t2.uname and
  u.user_id = userenv('SCHEMAID') and
  t1.output_type = 1
order by t1.rank#;

   COMMENT ON TABLE "SYSTEM"."MVIEW_EVALUATIONS"  IS 'This view gives DBA access to summary evaluation output'
;
--------------------------------------------------------
--  DDL for View MVIEW_EXCEPTIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."MVIEW_EXCEPTIONS" ("RUNID", "OWNER", "TABLE_NAME", "DIMENSION_NAME", "RELATIONSHIP", "BAD_ROWID") AS 
  select
  t1.runid# as runid,
  owner,
  table_name,
  dimension_name,
  relationship,
  bad_rowid
from SYSTEM.MVIEW$_ADV_EXCEPTIONS t1, SYSTEM.MVIEW$_ADV_LOG t2, SYS.ALL_USERS u
where
  t1.runid# = t2.runid# and
  u.username = t2.uname and
  u.user_id = userenv('SCHEMAID');

   COMMENT ON TABLE "SYSTEM"."MVIEW_EXCEPTIONS"  IS 'This view gives DBA access to dimension validation results'
;
--------------------------------------------------------
--  DDL for View MVIEW_FILTER
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."MVIEW_FILTER" ("FILTERID", "SUBFILTERNUM", "SUBFILTERTYPE", "STR_VALUE", "NUM_VALUE1", "NUM_VALUE2", "DATE_VALUE1", "DATE_VALUE2") AS 
  select
      a.filterid# as filterid,
      a.subfilternum# as subfilternum,
      decode(a.subfiltertype,1,'APPLICATION',2,'CARDINALITY',3,'LASTUSE',
                             4,'FREQUENCY',5,'USER',6,'PRIORITY',7,'BASETABLE',
                             8,'RESPONSETIME',9,'COLLECTIONID',10,'TRACENAME',
                             11,'SCHEMA','UNKNOWN') AS subfiltertype,
      a.str_value,
      to_number(decode(a.num_value1,-999,NULL,a.num_value1)) AS num_value1,
      to_number(decode(a.num_value2,-999,NULL,a.num_value2)) AS num_value2,
      a.date_value1,
      a.date_value2
   from system.mview$_adv_filter a, system.mview$_adv_log b, SYS.ALL_USERS u
   WHERE a.filterid# = b.runid#
   AND b.uname = u.username
   AND u.user_id = userenv('SCHEMAID');

   COMMENT ON TABLE "SYSTEM"."MVIEW_FILTER"  IS 'Workload filter records'
;
--------------------------------------------------------
--  DDL for View MVIEW_FILTERINSTANCE
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."MVIEW_FILTERINSTANCE" ("RUNID", "FILTERID", "SUBFILTERNUM", "SUBFILTERTYPE", "STR_VALUE", "NUM_VALUE1", "NUM_VALUE2", "DATE_VALUE1", "DATE_VALUE2") AS 
  select
      a.runid# as runid,
      a.filterid# as filterid,
      a.subfilternum# as subfilternum,
      decode(a.subfiltertype,1,'APPLICATION',2,'CARDINALITY',3,'LASTUSE',
                             4,'FREQUENCY',5,'USER',6,'PRIORITY',7,'BASETABLE',
                             8,'RESPONSETIME',9,'COLLECTIONID',10,'TRACENAME',
                             11,'SCHEMA','UNKNOWN') AS subfiltertype,
      a.str_value,
      to_number(decode(a.num_value1,-999,NULL,a.num_value1)) AS num_value1,
      to_number(decode(a.num_value2,-999,NULL,a.num_value2)) AS num_value2,
      a.date_value1,
      a.date_value2
   from system.mview$_adv_filterinstance a;

   COMMENT ON TABLE "SYSTEM"."MVIEW_FILTERINSTANCE"  IS 'Workload filter instance records'
;
--------------------------------------------------------
--  DDL for View MVIEW_LOG
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."MVIEW_LOG" ("ID", "FILTERID", "RUN_BEGIN", "RUN_END", "TYPE", "STATUS", "MESSAGE", "COMPLETED", "TOTAL", "ERROR_CODE") AS 
  select
      m.runid# as id,
      m.filterid# as filterid,
      m.run_begin,
      m.run_end,
      decode(m.run_type,1,'EVALUATE',2,'EVALUATE_W',3,'RECOMMEND',
                      4,'RECOMMEND_W',5,'VALIDATE',6,'WORKLOAD',
                      7,'FILTER','UNKNOWN') AS type,
      decode(m.status,0,'UNUSED',1,'CANCELLED',2,'IN_PROGRESS',3,'COMPLETED',
                    4,'ERROR','UNKNOWN') AS status,
      m.message,
      m.completed,
      m.total,
      m.error_code
   from system.mview$_adv_log m, sys.all_users u
   where m.uname = u.username
   and   u.user_id = userenv('SCHEMAID');

   COMMENT ON TABLE "SYSTEM"."MVIEW_LOG"  IS 'Advisor session log'
;
--------------------------------------------------------
--  DDL for View MVIEW_RECOMMENDATIONS
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."MVIEW_RECOMMENDATIONS" ("RUNID", "ALL_TABLES", "FACT_TABLES", "GROUPING_LEVELS", "QUERY_TEXT", "RECOMMENDATION_NUMBER", "RECOMMENDED_ACTION", "MVIEW_OWNER", "MVIEW_NAME", "STORAGE_IN_BYTES", "PCT_PERFORMANCE_GAIN", "BENEFIT_TO_COST_RATIO") AS 
  select
  t1.runid# as runid,
  t1.from_clause as all_tables,
  fact_tables,
  grouping_levels,
  query_text,
  rank# as recommendation_number,
  action_type as recommended_action,
  summary_owner as mview_owner,
  summary_name as mview_name,
  storage_in_bytes,
  pct_performance_gain,
  benefit_to_cost_ratio
from SYSTEM.MVIEW$_ADV_OUTPUT t1, SYSTEM.MVIEW$_ADV_LOG t2, SYS.ALL_USERS u
where
  t1.runid# = t2.runid# and
  u.username = t2.uname and
  u.user_id = userenv('SCHEMAID') and
  t1.output_type = 0
order by t1.rank#;

   COMMENT ON TABLE "SYSTEM"."MVIEW_RECOMMENDATIONS"  IS 'This view gives DBA access to summary recommendations'
;
--------------------------------------------------------
--  DDL for View MVIEW_WORKLOAD
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."MVIEW_WORKLOAD" ("WORKLOADID", "IMPORT_TIME", "QUERYID", "APPLICATION", "CARDINALITY", "RESULTSIZE", "LASTUSE", "FREQUENCY", "OWNER", "PRIORITY", "QUERY", "RESPONSETIME") AS 
  select
  a.collectionid# as workloadid,
  a.collecttime as import_time,
  a.queryid# as queryid,
  a.application,
  a.cardinality,
  a.resultsize,
  a.qdate as lastuse,
  a.frequency,
  a.uname as owner,
  a.priority,
  a.sql_text as query,
  a.exec_time as responsetime
from SYSTEM.MVIEW$_ADV_WORKLOAD A, SYSTEM.MVIEW$_ADV_LOG B, SYS.ALL_USERS D
WHERE a.collectionid# = b.runid#
AND b.uname = d.username
AND d.user_id = userenv('SCHEMAID');

   COMMENT ON TABLE "SYSTEM"."MVIEW_WORKLOAD"  IS 'This view gives DBA access to shared workload'
;
--------------------------------------------------------
--  DDL for View PRODUCT_PRIVS
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."PRODUCT_PRIVS" ("PRODUCT", "USERID", "ATTRIBUTE", "SCOPE", "NUMERIC_VALUE", "CHAR_VALUE", "DATE_VALUE", "LONG_VALUE") AS 
  SELECT PRODUCT, USERID, ATTRIBUTE, SCOPE,
         NUMERIC_VALUE, CHAR_VALUE, DATE_VALUE, LONG_VALUE
  FROM SQLPLUS_PRODUCT_PROFILE
  WHERE USERID = 'PUBLIC' OR
        USERID LIKE SYS_CONTEXT('USERENV','CURRENT_USER')
;
  GRANT READ ON "SYSTEM"."PRODUCT_PRIVS" TO PUBLIC;
--------------------------------------------------------
--  DDL for View SCHEDULER_JOB_ARGS
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."SCHEDULER_JOB_ARGS" ("OWNER", "JOB_NAME", "ARGUMENT_NAME", "ARGUMENT_POSITION", "ARGUMENT_TYPE", "VALUE", "ANYDATA_VALUE", "OUT_ARGUMENT") AS 
  SELECT "OWNER","JOB_NAME","ARGUMENT_NAME","ARGUMENT_POSITION","ARGUMENT_TYPE","VALUE","ANYDATA_VALUE","OUT_ARGUMENT" FROM sys.all_scheduler_job_args
;
  GRANT SELECT ON "SYSTEM"."SCHEDULER_JOB_ARGS" TO "SELECT_CATALOG_ROLE";
--------------------------------------------------------
--  DDL for View SCHEDULER_PROGRAM_ARGS
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."SCHEDULER_PROGRAM_ARGS" ("OWNER", "PROGRAM_NAME", "ARGUMENT_NAME", "ARGUMENT_POSITION", "ARGUMENT_TYPE", "METADATA_ATTRIBUTE", "DEFAULT_VALUE", "DEFAULT_ANYDATA_VALUE", "OUT_ARGUMENT") AS 
  SELECT "OWNER","PROGRAM_NAME","ARGUMENT_NAME","ARGUMENT_POSITION","ARGUMENT_TYPE","METADATA_ATTRIBUTE","DEFAULT_VALUE","DEFAULT_ANYDATA_VALUE","OUT_ARGUMENT" FROM sys.all_scheduler_program_args
;
  GRANT SELECT ON "SYSTEM"."SCHEDULER_PROGRAM_ARGS" TO "SELECT_CATALOG_ROLE";
--------------------------------------------------------
--  DDL for View VW_ANALISE_FORMAS_PAGAMENTO
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."VW_ANALISE_FORMAS_PAGAMENTO" ("FORMA_PAGAMENTO", "QTD_TRANSACOES", "VALOR_TOTAL", "PERCENTUAL_PARTICIPACAO") AS 
  SELECT
    fp.descricao AS Forma_Pagamento,
    COUNT(*) AS Qtd_Transacoes,
    SUM(pa.valor) AS Valor_Total,
    ROUND(100 * SUM(pa.valor) / SUM(SUM(pa.valor)) OVER (), 2) AS Percentual_Participacao
FROM pagamento_atendimento pa
JOIN forma_pagamento fp ON pa.id_forma = fp.id_forma
GROUP BY fp.descricao
ORDER BY Valor_Total DESC
;
--------------------------------------------------------
--  DDL for View VW_CLI_NOVOS_VELHOS
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."VW_CLI_NOVOS_VELHOS" ("MES", "ATENDIMENTOS_CLIENTES_NOVOS", "ATENDIMENTOS_CLIENTES_RECORRENTES", "PERCENTUAL_CLIENTES_NOVOS") AS 
  WITH primeira_visita AS (
    SELECT id_cliente, MIN(data_atendimento) AS data_primeira_visita
    FROM atendimento
    WHERE tipo = 'Pagamento'
    GROUP BY id_cliente
)
SELECT
    TO_CHAR(a.data_atendimento, 'YYYY-MM') AS Mes,
    SUM(CASE WHEN TO_CHAR(a.data_atendimento, 'YYYY-MM') = TO_CHAR(pv.data_primeira_visita, 'YYYY-MM')
             THEN 1 ELSE 0 END) AS Atendimentos_Clientes_Novos,
    SUM(CASE WHEN TO_CHAR(a.data_atendimento, 'YYYY-MM') <> TO_CHAR(pv.data_primeira_visita, 'YYYY-MM')
             THEN 1 ELSE 0 END) AS Atendimentos_Clientes_Recorrentes,
    ROUND(100 * SUM(CASE WHEN TO_CHAR(a.data_atendimento, 'YYYY-MM') = TO_CHAR(pv.data_primeira_visita, 'YYYY-MM')
                         THEN 1 ELSE 0 END) / COUNT(*), 2) AS Percentual_Clientes_Novos
FROM atendimento a
JOIN primeira_visita pv ON pv.id_cliente = a.id_cliente
WHERE a.tipo = 'Pagamento'
GROUP BY TO_CHAR(a.data_atendimento, 'YYYY-MM')
ORDER BY Mes
;
--------------------------------------------------------
--  DDL for View VW_COMPARACAO_3PERIODOS
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."VW_COMPARACAO_3PERIODOS" ("PERIODO", "MESES", "QTD_ATENDIMENTOS", "CLIENTES_ATENDIDOS", "FATURAMENTO_TOTAL", "FATURAMENTO_MEDIO_MENSAL", "TICKET_MEDIO") AS 
  SELECT
    Periodo,
    COUNT(DISTINCT Mes) AS Meses,
    COUNT(*) AS Qtd_Atendimentos,
    COUNT(DISTINCT id_cliente) AS Clientes_Atendidos,
    SUM(total_geral) AS Faturamento_Total,
    ROUND(SUM(total_geral) / COUNT(DISTINCT Mes), 2) AS Faturamento_Medio_Mensal,
    ROUND(AVG(total_geral), 2) AS Ticket_Medio
FROM (
    SELECT
        CASE
            WHEN a.data_atendimento < DATE '2025-09-01' THEN '1 - jan a ago/2025'
            WHEN a.data_atendimento < DATE '2026-03-01' THEN '2 - set/2025 a fev/2026'
            ELSE '3 - mar a ago/2026'
        END AS Periodo,
        TO_CHAR(a.data_atendimento, 'YYYY-MM') AS Mes,
        a.id_cliente,
        a.total_geral
    FROM atendimento a
    WHERE a.tipo = 'Pagamento'
)
GROUP BY Periodo
ORDER BY Periodo
;
--------------------------------------------------------
--  DDL for View VW_DESCONTO_MOTIVO
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."VW_DESCONTO_MOTIVO" ("MOTIVO_DESCONTO", "QTD_ATENDIMENTOS_COM_DESCONTO", "VALOR_TOTAL_DESCONTADO", "DESCONTO_MEDIO", "PERCENTUAL_SOBRE_RECEITA_BRUTA") AS 
  SELECT
    m.descricao AS Motivo_Desconto,
    COUNT(a.id_atendimento) AS Qtd_Atendimentos_Com_Desconto,
    SUM(ABS(a.total_descontos)) AS Valor_Total_Descontado,
    ROUND(AVG(ABS(a.total_descontos)), 2) AS Desconto_Medio,
    ROUND(100 * SUM(ABS(a.total_descontos)) /
          (SELECT SUM(total_servico + total_produtos + total_pacotes + total_vale_presente)
           FROM atendimento WHERE tipo = 'Pagamento'), 2) AS Percentual_Sobre_Receita_Bruta
FROM atendimento a
JOIN motivo_desconto m ON a.id_motivo = m.id_motivo
WHERE a.tipo = 'Pagamento'
GROUP BY m.descricao
ORDER BY Valor_Total_Descontado DESC
;
--------------------------------------------------------
--  DDL for View VW_FATURAMENTO_DIA_SEMANA
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."VW_FATURAMENTO_DIA_SEMANA" ("DIA_NUM", "DIA_SEMANA", "QTD_ATENDIMENTOS", "FATURAMENTO_TOTAL", "TICKET_MEDIO") AS 
  SELECT
    TO_CHAR(a.data_atendimento, 'D') AS Dia_Num,
    TRIM(TO_CHAR(a.data_atendimento, 'DAY', 'NLS_DATE_LANGUAGE=PORTUGUESE')) AS Dia_Semana,
    COUNT(*) AS Qtd_Atendimentos,
    SUM(a.total_geral) AS Faturamento_Total,
    ROUND(AVG(a.total_geral), 2) AS Ticket_Medio
FROM atendimento a
WHERE a.tipo = 'Pagamento'
GROUP BY TO_CHAR(a.data_atendimento, 'D'), TRIM(TO_CHAR(a.data_atendimento, 'DAY', 'NLS_DATE_LANGUAGE=PORTUGUESE'))
ORDER BY Dia_Num
;
--------------------------------------------------------
--  DDL for View VW_FATURAMENTO_FUNCIONARIO
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."VW_FATURAMENTO_FUNCIONARIO" ("FUNCIONARIO", "QTD_ATENDIMENTOS", "FATURAMENTO_GERADO", "TICKET_MEDIO", "PERCENTUAL_DO_FATURAMENTO_TOTAL", "RANKING") AS 
  SELECT
    f.nome_funcionario AS Funcionario,
    COUNT(a.id_atendimento) AS Qtd_Atendimentos,
    SUM(a.total_geral) AS Faturamento_Gerado,
    ROUND(AVG(a.total_geral), 2) AS Ticket_Medio,
    ROUND(100 * SUM(a.total_geral) / SUM(SUM(a.total_geral)) OVER (), 2) AS Percentual_do_Faturamento_Total,
    RANK() OVER (ORDER BY SUM(a.total_geral) DESC) AS Ranking
FROM atendimento a
JOIN funcionario f ON a.id_funcionario = f.id_funcionario
WHERE a.tipo = 'Pagamento'
GROUP BY f.nome_funcionario
ORDER BY Ranking
;
--------------------------------------------------------
--  DDL for View VW_FATURAMENTO_MENSAL
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."VW_FATURAMENTO_MENSAL" ("MES_REFERENCIA", "QTD_ATENDIMENTOS", "FATURAMENTO_TOTAL", "TICKET_MEDIO") AS 
  SELECT
    TRUNC(a.data_atendimento, 'MONTH') AS Mes_Referencia,
    COUNT(*) AS Qtd_Atendimentos,
    SUM(a.total_geral) AS Faturamento_Total,
    ROUND(AVG(a.total_geral), 2) AS Ticket_Medio
FROM atendimento a
WHERE a.tipo = 'Pagamento'
GROUP BY TRUNC(a.data_atendimento, 'MONTH')
ORDER BY Mes_Referencia
;
--------------------------------------------------------
--  DDL for View VW_RECEITA_CATEGORIA
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."VW_RECEITA_CATEGORIA" ("CATEGORIA", "VALOR", "PERCENTUAL_RECEITA") AS 
  SELECT
    categoria,
    valor,
    ROUND(100 * valor / SUM(valor) OVER (), 2) AS Percentual_Receita
FROM (
    SELECT 'Servicos'      AS categoria, SUM(total_servico)      AS valor FROM atendimento WHERE tipo = 'Pagamento'
    UNION ALL
    SELECT 'Produtos',            SUM(total_produtos)      FROM atendimento WHERE tipo = 'Pagamento'
    UNION ALL
    SELECT 'Pacotes',             SUM(total_pacotes)       FROM atendimento WHERE tipo = 'Pagamento'
    UNION ALL
    SELECT 'Vale-Presente',       SUM(total_vale_presente) FROM atendimento WHERE tipo = 'Pagamento'
)
ORDER BY valor DESC
;
--------------------------------------------------------
--  DDL for View VW_RETORNO_CLIENTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE NONEDITIONABLE VIEW "SYSTEM"."VW_RETORNO_CLIENTE" ("ID_CLIENTE", "CLIENTE", "ULTIMA_VISITA", "DIAS_SEM_VISITAR", "VALOR_TOTAL_HISTORICO") AS 
  SELECT
    c.id_cliente,
    c.nome_cliente AS Cliente,
    MAX(a.data_atendimento) AS Ultima_Visita,
    TRUNC((SELECT MAX(data_atendimento) FROM atendimento) - MAX(a.data_atendimento)) AS Dias_Sem_Visitar,
    SUM(a.total_geral) AS Valor_Total_Historico
FROM atendimento a
JOIN cliente c ON a.id_cliente = c.id_cliente
WHERE a.tipo = 'Pagamento'
GROUP BY c.id_cliente, c.nome_cliente
HAVING MAX(a.data_atendimento) < ADD_MONTHS((SELECT MAX(data_atendimento) FROM atendimento), -3)
ORDER BY Valor_Total_Historico DESC
;
--------------------------------------------------------
--  DDL for Trigger TRG_ATENDIMENTO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_ATENDIMENTO_BI" 
BEFORE INSERT ON atendimento
FOR EACH ROW
 WHEN (NEW.id_atendimento IS NULL) BEGIN
    :NEW.id_atendimento := seq_atendimento.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_ATENDIMENTO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_ATENDIMENTO_CALC_TOTAL
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_ATENDIMENTO_CALC_TOTAL" 
BEFORE INSERT OR UPDATE ON atendimento
FOR EACH ROW
BEGIN
    :NEW.total_geral := NVL(:NEW.total_servico, 0)
                       + NVL(:NEW.total_produtos, 0)
                       + NVL(:NEW.total_pacotes, 0)
                       + NVL(:NEW.total_vale_presente, 0)
                       + NVL(:NEW.total_descontos, 0);
END;
/
ALTER TRIGGER "SYSTEM"."TRG_ATENDIMENTO_CALC_TOTAL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_ATENDIMENTO_LOG_DEL
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_ATENDIMENTO_LOG_DEL" 
AFTER DELETE ON atendimento FOR EACH ROW 
BEGIN 
    INSERT INTO atendimento_log (
        id_log, data_exclusao, usuario_bd,
        id_atendimento, data_atendimento, data_pagamento, tipo,
        id_cliente, id_funcionario, total_servico, qtd_servico,
        total_produtos, qtd_produto, total_pacotes, qtd_pacotes,
        total_vale_presente, qtd_vale_presente, total_credito_cliente,
        total_descontos, id_motivo, total_geral, comentario_fechamento, comentario_estorno
    ) VALUES (
        seq_atendimento_log.NEXTVAL, SYSDATE, USER,
        :OLD.id_atendimento, :OLD.data_atendimento, :OLD.data_pagamento, :OLD.tipo,
        :OLD.id_cliente, :OLD.id_funcionario, :OLD.total_servico, :OLD.qtd_servico,
        :OLD.total_produtos, :OLD.qtd_produto, :OLD.total_pacotes, :OLD.qtd_pacotes,
        :OLD.total_vale_presente, :OLD.qtd_vale_presente, :OLD.total_credito_cliente,
        :OLD.total_descontos, :OLD.id_motivo, :OLD.total_geral, :OLD.comentario_fechamento, :OLD.comentario_estorno
    ); 
END; 

/
ALTER TRIGGER "SYSTEM"."TRG_ATENDIMENTO_LOG_DEL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_CAIXA_DIARIO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_CAIXA_DIARIO_BI" 
BEFORE INSERT ON caixa_diario
FOR EACH ROW
 WHEN (NEW.id_caixa IS NULL) BEGIN
    :NEW.id_caixa := seq_caixa_diario.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_CAIXA_DIARIO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_CLIENTE_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_CLIENTE_BI" 
BEFORE INSERT ON cliente
FOR EACH ROW
 WHEN (NEW.id_cliente IS NULL) BEGIN
    :NEW.id_cliente := seq_cliente.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_CLIENTE_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_FORMA_PAGAMENTO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_FORMA_PAGAMENTO_BI" 
BEFORE INSERT ON forma_pagamento
FOR EACH ROW
 WHEN (NEW.id_forma IS NULL) BEGIN
    :NEW.id_forma := seq_forma_pagamento.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_FORMA_PAGAMENTO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_FUNCIONARIO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_FUNCIONARIO_BI" 
BEFORE INSERT ON funcionario
FOR EACH ROW
 WHEN (NEW.id_funcionario IS NULL) BEGIN
    :NEW.id_funcionario := seq_funcionario.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_FUNCIONARIO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_MOTIVO_DESCONTO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_MOTIVO_DESCONTO_BI" 
BEFORE INSERT ON motivo_desconto
FOR EACH ROW
 WHEN (NEW.id_motivo IS NULL) BEGIN
    :NEW.id_motivo := seq_motivo_desconto.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_MOTIVO_DESCONTO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_PAGAMENTO_VALOR_CHECK
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_PAGAMENTO_VALOR_CHECK" 
BEFORE INSERT OR UPDATE ON pagamento_atendimento
FOR EACH ROW
BEGIN
    IF :NEW.valor IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'O valor do pagamento n��o pode ser nulo.');
    END IF;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_PAGAMENTO_VALOR_CHECK" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_ATENDIMENTO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_ATENDIMENTO_BI" 
BEFORE INSERT ON atendimento
FOR EACH ROW
 WHEN (NEW.id_atendimento IS NULL) BEGIN
    :NEW.id_atendimento := seq_atendimento.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_ATENDIMENTO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_ATENDIMENTO_CALC_TOTAL
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_ATENDIMENTO_CALC_TOTAL" 
BEFORE INSERT OR UPDATE ON atendimento
FOR EACH ROW
BEGIN
    :NEW.total_geral := NVL(:NEW.total_servico, 0)
                       + NVL(:NEW.total_produtos, 0)
                       + NVL(:NEW.total_pacotes, 0)
                       + NVL(:NEW.total_vale_presente, 0)
                       + NVL(:NEW.total_descontos, 0);
END;
/
ALTER TRIGGER "SYSTEM"."TRG_ATENDIMENTO_CALC_TOTAL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_ATENDIMENTO_LOG_DEL
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_ATENDIMENTO_LOG_DEL" 
AFTER DELETE ON atendimento FOR EACH ROW 
BEGIN 
    INSERT INTO atendimento_log (
        id_log, data_exclusao, usuario_bd,
        id_atendimento, data_atendimento, data_pagamento, tipo,
        id_cliente, id_funcionario, total_servico, qtd_servico,
        total_produtos, qtd_produto, total_pacotes, qtd_pacotes,
        total_vale_presente, qtd_vale_presente, total_credito_cliente,
        total_descontos, id_motivo, total_geral, comentario_fechamento, comentario_estorno
    ) VALUES (
        seq_atendimento_log.NEXTVAL, SYSDATE, USER,
        :OLD.id_atendimento, :OLD.data_atendimento, :OLD.data_pagamento, :OLD.tipo,
        :OLD.id_cliente, :OLD.id_funcionario, :OLD.total_servico, :OLD.qtd_servico,
        :OLD.total_produtos, :OLD.qtd_produto, :OLD.total_pacotes, :OLD.qtd_pacotes,
        :OLD.total_vale_presente, :OLD.qtd_vale_presente, :OLD.total_credito_cliente,
        :OLD.total_descontos, :OLD.id_motivo, :OLD.total_geral, :OLD.comentario_fechamento, :OLD.comentario_estorno
    ); 
END; 

/
ALTER TRIGGER "SYSTEM"."TRG_ATENDIMENTO_LOG_DEL" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_CAIXA_DIARIO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_CAIXA_DIARIO_BI" 
BEFORE INSERT ON caixa_diario
FOR EACH ROW
 WHEN (NEW.id_caixa IS NULL) BEGIN
    :NEW.id_caixa := seq_caixa_diario.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_CAIXA_DIARIO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_CLIENTE_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_CLIENTE_BI" 
BEFORE INSERT ON cliente
FOR EACH ROW
 WHEN (NEW.id_cliente IS NULL) BEGIN
    :NEW.id_cliente := seq_cliente.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_CLIENTE_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_FORMA_PAGAMENTO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_FORMA_PAGAMENTO_BI" 
BEFORE INSERT ON forma_pagamento
FOR EACH ROW
 WHEN (NEW.id_forma IS NULL) BEGIN
    :NEW.id_forma := seq_forma_pagamento.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_FORMA_PAGAMENTO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_FUNCIONARIO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_FUNCIONARIO_BI" 
BEFORE INSERT ON funcionario
FOR EACH ROW
 WHEN (NEW.id_funcionario IS NULL) BEGIN
    :NEW.id_funcionario := seq_funcionario.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_FUNCIONARIO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_MOTIVO_DESCONTO_BI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_MOTIVO_DESCONTO_BI" 
BEFORE INSERT ON motivo_desconto
FOR EACH ROW
 WHEN (NEW.id_motivo IS NULL) BEGIN
    :NEW.id_motivo := seq_motivo_desconto.NEXTVAL;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_MOTIVO_DESCONTO_BI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TRG_PAGAMENTO_VALOR_CHECK
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "SYSTEM"."TRG_PAGAMENTO_VALOR_CHECK" 
BEFORE INSERT OR UPDATE ON pagamento_atendimento
FOR EACH ROW
BEGIN
    IF :NEW.valor IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'O valor do pagamento n��o pode ser nulo.');
    END IF;
END;
/
ALTER TRIGGER "SYSTEM"."TRG_PAGAMENTO_VALOR_CHECK" ENABLE;
