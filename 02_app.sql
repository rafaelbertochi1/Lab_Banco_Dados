--------------------------------------------------------
--  Schema APP - Sistema de Gestao de Salao (Cachearia)
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Sequence SEQ_ATD
--------------------------------------------------------

   CREATE SEQUENCE  "APP"."SEQ_ATD"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 694 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_CLI
--------------------------------------------------------

   CREATE SEQUENCE  "APP"."SEQ_CLI"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 91197797 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_CXD
--------------------------------------------------------

   CREATE SEQUENCE  "APP"."SEQ_CXD"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 235 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_FPG
--------------------------------------------------------

   CREATE SEQUENCE  "APP"."SEQ_FPG"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 8 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_FUN
--------------------------------------------------------

   CREATE SEQUENCE  "APP"."SEQ_FUN"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 4 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Sequence SEQ_MTD
--------------------------------------------------------

   CREATE SEQUENCE  "APP"."SEQ_MTD"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 5 NOCACHE  ORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
--------------------------------------------------------
--  DDL for Table ATENDIMENTO
--------------------------------------------------------

  CREATE TABLE "APP"."ATENDIMENTO"
   (	"ATD_ID" NUMBER(10,0),
	"ATD_DT_ATENDIMENTO" DATE,
	"ATD_DT_PAGAMENTO" DATE,
	"ATD_TIPO" VARCHAR2(30),
	"ATD_CLI_ID" NUMBER(10,0),
	"ATD_FUN_ID" NUMBER(10,0),
	"ATD_TOTAL_SERVICO" NUMBER(10,2),
	"ATD_QTD_SERVICO" NUMBER(5,0),
	"ATD_TOTAL_PRODUTOS" NUMBER(10,2),
	"ATD_QTD_PRODUTO" NUMBER(5,0),
	"ATD_TOTAL_PACOTES" NUMBER(10,2),
	"ATD_QTD_PACOTES" NUMBER(5,0),
	"ATD_TOTAL_VALE_PRESENTE" NUMBER(10,2),
	"ATD_QTD_VALE_PRESENTE" NUMBER(5,0),
	"ATD_TOTAL_CREDITO_CLIENTE" NUMBER(10,2),
	"ATD_TOTAL_DESCONTOS" NUMBER(10,2),
	"ATD_MTD_ID" NUMBER(10,0),
	"ATD_TOTAL_GERAL" NUMBER(10,2),
	"ATD_COMENTARIO_FECHAMENTO" VARCHAR2(500),
	"ATD_COMENTARIO_ESTORNO" VARCHAR2(500)
   ) ;
--------------------------------------------------------
--  DDL for Table CAIXA_DIARIO
--------------------------------------------------------

  CREATE TABLE "APP"."CAIXA_DIARIO"
   (	"CXD_ID" NUMBER(10,0),
	"CXD_DT_MOVIMENTO" DATE,
	"CXD_ABERTURA_CAIXA" NUMBER(10,2),
	"CXD_RECEBIDO_DINHEIRO" NUMBER(10,2),
	"CXD_TROCO" NUMBER(10,2),
	"CXD_DESPESAS_DINHEIRO" NUMBER(10,2),
	"CXD_TOTAL_DINHEIRO" NUMBER(10,2),
	"CXD_SANGRIA" NUMBER(10,2),
	"CXD_SALDO_CAIXA" NUMBER(10,2),
	"CXD_RECEBIDO_OUTRAS_FORMAS" NUMBER(10,2),
	"CXD_DESPESAS_OUTRAS_FORMAS" NUMBER(10,2)
   ) ;
--------------------------------------------------------
--  DDL for Table CLIENTE
--------------------------------------------------------

  CREATE TABLE "APP"."CLIENTE"
   (	"CLI_ID" NUMBER(10,0),
	"CLI_NOME" VARCHAR2(150)
   ) ;
--------------------------------------------------------
--  DDL for Table FORMA_PAGAMENTO
--------------------------------------------------------

  CREATE TABLE "APP"."FORMA_PAGAMENTO"
   (	"FPG_ID" NUMBER(10,0),
	"FPG_DESCRICAO" VARCHAR2(30)
   ) ;
--------------------------------------------------------
--  DDL for Table FUNCIONARIO
--------------------------------------------------------

  CREATE TABLE "APP"."FUNCIONARIO"
   (	"FUN_ID" NUMBER(10,0),
	"FUN_NOME" VARCHAR2(100)
   ) ;
--------------------------------------------------------
--  DDL for Table MOTIVO_DESCONTO
--------------------------------------------------------

  CREATE TABLE "APP"."MOTIVO_DESCONTO"
   (	"MTD_ID" NUMBER(10,0),
	"MTD_DESCRICAO" VARCHAR2(200)
   ) ;
--------------------------------------------------------
--  DDL for Table PAGAMENTO_ATENDIMENTO
--------------------------------------------------------

  CREATE TABLE "APP"."PAGAMENTO_ATENDIMENTO"
   (	"PGA_ATD_ID" NUMBER(10,0),
	"PGA_FPG_ID" NUMBER(10,0),
	"PGA_VALOR" NUMBER(10,2)
   ) ;
--------------------------------------------------------
--  DDL for Table H_ATENDIMENTO
--------------------------------------------------------

  CREATE TABLE "APP"."H_ATENDIMENTO"
   (	"HATD_ID" NUMBER(10,0),
	"HATD_DT_ATENDIMENTO" DATE,
	"HATD_DT_PAGAMENTO" DATE,
	"HATD_TIPO" VARCHAR2(30),
	"HATD_CLI_ID" NUMBER(10,0),
	"HATD_FUN_ID" NUMBER(10,0),
	"HATD_TOTAL_SERVICO" NUMBER(10,2),
	"HATD_QTD_SERVICO" NUMBER(5,0),
	"HATD_TOTAL_PRODUTOS" NUMBER(10,2),
	"HATD_QTD_PRODUTO" NUMBER(5,0),
	"HATD_TOTAL_PACOTES" NUMBER(10,2),
	"HATD_QTD_PACOTES" NUMBER(5,0),
	"HATD_TOTAL_VALE_PRESENTE" NUMBER(10,2),
	"HATD_QTD_VALE_PRESENTE" NUMBER(5,0),
	"HATD_TOTAL_CREDITO_CLIENTE" NUMBER(10,2),
	"HATD_TOTAL_DESCONTOS" NUMBER(10,2),
	"HATD_MTD_ID" NUMBER(10,0),
	"HATD_TOTAL_GERAL" NUMBER(10,2),
	"HATD_COMENTARIO_FECHAMENTO" VARCHAR2(500),
	"HATD_COMENTARIO_ESTORNO" VARCHAR2(500),
	"HATD_DT_ENTRADA" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table H_CAIXA_DIARIO
--------------------------------------------------------

  CREATE TABLE "APP"."H_CAIXA_DIARIO"
   (	"HCXD_ID" NUMBER(10,0),
	"HCXD_DT_MOVIMENTO" DATE,
	"HCXD_ABERTURA_CAIXA" NUMBER(10,2),
	"HCXD_RECEBIDO_DINHEIRO" NUMBER(10,2),
	"HCXD_TROCO" NUMBER(10,2),
	"HCXD_DESPESAS_DINHEIRO" NUMBER(10,2),
	"HCXD_TOTAL_DINHEIRO" NUMBER(10,2),
	"HCXD_SANGRIA" NUMBER(10,2),
	"HCXD_SALDO_CAIXA" NUMBER(10,2),
	"HCXD_RECEBIDO_OUTRAS_FORMAS" NUMBER(10,2),
	"HCXD_DESPESAS_OUTRAS_FORMAS" NUMBER(10,2),
	"HCXD_DT_ENTRADA" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table H_CLIENTE
--------------------------------------------------------

  CREATE TABLE "APP"."H_CLIENTE"
   (	"HCLI_ID" NUMBER(10,0),
	"HCLI_NOME" VARCHAR2(150),
	"HCLI_DT_ENTRADA" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table H_FORMA_PAGAMENTO
--------------------------------------------------------

  CREATE TABLE "APP"."H_FORMA_PAGAMENTO"
   (	"HFPG_ID" NUMBER(10,0),
	"HFPG_DESCRICAO" VARCHAR2(30),
	"HFPG_DT_ENTRADA" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table H_FUNCIONARIO
--------------------------------------------------------

  CREATE TABLE "APP"."H_FUNCIONARIO"
   (	"HFUN_ID" NUMBER(10,0),
	"HFUN_NOME" VARCHAR2(100),
	"HFUN_DT_ENTRADA" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table H_MOTIVO_DESCONTO
--------------------------------------------------------

  CREATE TABLE "APP"."H_MOTIVO_DESCONTO"
   (	"HMTD_ID" NUMBER(10,0),
	"HMTD_DESCRICAO" VARCHAR2(200),
	"HMTD_DT_ENTRADA" DATE
   ) ;
--------------------------------------------------------
--  DDL for Table H_PAGAMENTO_ATENDIMENTO
--------------------------------------------------------

  CREATE TABLE "APP"."H_PAGAMENTO_ATENDIMENTO"
   (	"HPGA_ATD_ID" NUMBER(10,0),
	"HPGA_FPG_ID" NUMBER(10,0),
	"HPGA_VALOR" NUMBER(10,2),
	"HPGA_DT_ENTRADA" DATE
   ) ;
--------------------------------------------------------
--  DDL for Trigger TG_HATD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_HATD" BEFORE
    UPDATE OR DELETE ON atendimento
    FOR EACH ROW
BEGIN
    insert into h_atendimento values (:old.atd_id, :old.atd_dt_atendimento, :old.atd_dt_pagamento, :old.atd_tipo,
        :old.atd_cli_id, :old.atd_fun_id, :old.atd_total_servico, :old.atd_qtd_servico,
        :old.atd_total_produtos, :old.atd_qtd_produto, :old.atd_total_pacotes, :old.atd_qtd_pacotes,
        :old.atd_total_vale_presente, :old.atd_qtd_vale_presente, :old.atd_total_credito_cliente,
        :old.atd_total_descontos, :old.atd_mtd_id, :old.atd_total_geral,
        :old.atd_comentario_fechamento, :old.atd_comentario_estorno, sysdate);
END;
/
ALTER TRIGGER "APP"."TG_HATD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_SEQ_ATD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_SEQ_ATD" BEFORE
    INSERT ON atendimento
    FOR EACH ROW
BEGIN
    :new.atd_id := seq_atd.nextval;
END;

/
ALTER TRIGGER "APP"."TG_SEQ_ATD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_HCXD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_HCXD" BEFORE
    UPDATE OR DELETE ON caixa_diario
    FOR EACH ROW
BEGIN
    insert into h_caixa_diario values (:old.cxd_id, :old.cxd_dt_movimento, :old.cxd_abertura_caixa,
        :old.cxd_recebido_dinheiro, :old.cxd_troco, :old.cxd_despesas_dinheiro, :old.cxd_total_dinheiro,
        :old.cxd_sangria, :old.cxd_saldo_caixa, :old.cxd_recebido_outras_formas,
        :old.cxd_despesas_outras_formas, sysdate);
END;
/
ALTER TRIGGER "APP"."TG_HCXD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_SEQ_CXD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_SEQ_CXD" BEFORE
    INSERT ON caixa_diario
    FOR EACH ROW
BEGIN
    :new.cxd_id := seq_cxd.nextval;
END;

/
ALTER TRIGGER "APP"."TG_SEQ_CXD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_HCLI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_HCLI" BEFORE
    UPDATE OR DELETE ON cliente
    FOR EACH ROW
BEGIN
    insert into h_cliente values (:old.cli_id, :old.cli_nome, sysdate);
END;
/
ALTER TRIGGER "APP"."TG_HCLI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_SEQ_CLI
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_SEQ_CLI" BEFORE
    INSERT ON cliente
    FOR EACH ROW
BEGIN
    :new.cli_id := seq_cli.nextval;
END;

/
ALTER TRIGGER "APP"."TG_SEQ_CLI" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_HFPG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_HFPG" BEFORE
    UPDATE OR DELETE ON forma_pagamento
    FOR EACH ROW
BEGIN
    insert into h_forma_pagamento values (:old.fpg_id, :old.fpg_descricao, sysdate);
END;
/
ALTER TRIGGER "APP"."TG_HFPG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_SEQ_FPG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_SEQ_FPG" BEFORE
    INSERT ON forma_pagamento
    FOR EACH ROW
BEGIN
    :new.fpg_id := seq_fpg.nextval;
END;

/
ALTER TRIGGER "APP"."TG_SEQ_FPG" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_HFUN
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_HFUN" BEFORE
    UPDATE OR DELETE ON funcionario
    FOR EACH ROW
BEGIN
    insert into h_funcionario values (:old.fun_id, :old.fun_nome, sysdate);
END;
/
ALTER TRIGGER "APP"."TG_HFUN" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_SEQ_FUN
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_SEQ_FUN" BEFORE
    INSERT ON funcionario
    FOR EACH ROW
BEGIN
    :new.fun_id := seq_fun.nextval;
END;

/
ALTER TRIGGER "APP"."TG_SEQ_FUN" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_HMTD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_HMTD" BEFORE
    UPDATE OR DELETE ON motivo_desconto
    FOR EACH ROW
BEGIN
    insert into h_motivo_desconto values (:old.mtd_id, :old.mtd_descricao, sysdate);
END;
/
ALTER TRIGGER "APP"."TG_HMTD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_SEQ_MTD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_SEQ_MTD" BEFORE
    INSERT ON motivo_desconto
    FOR EACH ROW
BEGIN
    :new.mtd_id := seq_mtd.nextval;
END;

/
ALTER TRIGGER "APP"."TG_SEQ_MTD" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TG_HPGA
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TRIGGER "APP"."TG_HPGA" BEFORE
    UPDATE OR DELETE ON pagamento_atendimento
    FOR EACH ROW
BEGIN
    insert into h_pagamento_atendimento values (:old.pga_atd_id, :old.pga_fpg_id, :old.pga_valor, sysdate);
END;
/
ALTER TRIGGER "APP"."TG_HPGA" ENABLE;
--------------------------------------------------------
--  Constraints for Table ATENDIMENTO
--------------------------------------------------------

  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_DT_ATENDIMENTO" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_TIPO" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_CLI_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_FUN_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_TOTAL_SERVICO" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_QTD_SERVICO" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_TOTAL_PRODUTOS" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_QTD_PRODUTO" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_TOTAL_PACOTES" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_QTD_PACOTES" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_TOTAL_VALE_PRESENTE" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_QTD_VALE_PRESENTE" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_TOTAL_CREDITO_CLIENTE" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_TOTAL_DESCONTOS" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" MODIFY ("ATD_TOTAL_GERAL" NOT NULL ENABLE);
  ALTER TABLE "APP"."ATENDIMENTO" ADD CONSTRAINT "PK_ATD" PRIMARY KEY ("ATD_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "APP"."ATENDIMENTO" ADD CONSTRAINT "CK_ATD_TIPO" CHECK ("ATD_TIPO" IN ('Pagamento','Estorno')) ENABLE;
--------------------------------------------------------
--  Constraints for Table CAIXA_DIARIO
--------------------------------------------------------

  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_DT_MOVIMENTO" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_ABERTURA_CAIXA" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_RECEBIDO_DINHEIRO" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_TROCO" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_DESPESAS_DINHEIRO" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_TOTAL_DINHEIRO" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_SANGRIA" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_SALDO_CAIXA" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_RECEBIDO_OUTRAS_FORMAS" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" MODIFY ("CXD_DESPESAS_OUTRAS_FORMAS" NOT NULL ENABLE);
  ALTER TABLE "APP"."CAIXA_DIARIO" ADD CONSTRAINT "PK_CXD" PRIMARY KEY ("CXD_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "APP"."CAIXA_DIARIO" ADD CONSTRAINT "UQ_CXD_DT_MOVIMENTO" UNIQUE ("CXD_DT_MOVIMENTO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table CLIENTE
--------------------------------------------------------

  ALTER TABLE "APP"."CLIENTE" MODIFY ("CLI_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."CLIENTE" MODIFY ("CLI_NOME" NOT NULL ENABLE);
  ALTER TABLE "APP"."CLIENTE" ADD CONSTRAINT "PK_CLI" PRIMARY KEY ("CLI_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table FORMA_PAGAMENTO
--------------------------------------------------------

  ALTER TABLE "APP"."FORMA_PAGAMENTO" MODIFY ("FPG_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."FORMA_PAGAMENTO" MODIFY ("FPG_DESCRICAO" NOT NULL ENABLE);
  ALTER TABLE "APP"."FORMA_PAGAMENTO" ADD CONSTRAINT "PK_FPG" PRIMARY KEY ("FPG_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "APP"."FORMA_PAGAMENTO" ADD CONSTRAINT "UQ_FPG_DESCRICAO" UNIQUE ("FPG_DESCRICAO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table FUNCIONARIO
--------------------------------------------------------

  ALTER TABLE "APP"."FUNCIONARIO" MODIFY ("FUN_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."FUNCIONARIO" MODIFY ("FUN_NOME" NOT NULL ENABLE);
  ALTER TABLE "APP"."FUNCIONARIO" ADD CONSTRAINT "PK_FUN" PRIMARY KEY ("FUN_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "APP"."FUNCIONARIO" ADD CONSTRAINT "UQ_FUN_NOME" UNIQUE ("FUN_NOME")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table MOTIVO_DESCONTO
--------------------------------------------------------

  ALTER TABLE "APP"."MOTIVO_DESCONTO" MODIFY ("MTD_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."MOTIVO_DESCONTO" MODIFY ("MTD_DESCRICAO" NOT NULL ENABLE);
  ALTER TABLE "APP"."MOTIVO_DESCONTO" ADD CONSTRAINT "PK_MTD" PRIMARY KEY ("MTD_ID")
  USING INDEX  ENABLE;
  ALTER TABLE "APP"."MOTIVO_DESCONTO" ADD CONSTRAINT "UQ_MTD_DESCRICAO" UNIQUE ("MTD_DESCRICAO")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table PAGAMENTO_ATENDIMENTO
--------------------------------------------------------

  ALTER TABLE "APP"."PAGAMENTO_ATENDIMENTO" MODIFY ("PGA_ATD_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."PAGAMENTO_ATENDIMENTO" MODIFY ("PGA_FPG_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."PAGAMENTO_ATENDIMENTO" MODIFY ("PGA_VALOR" NOT NULL ENABLE);
  ALTER TABLE "APP"."PAGAMENTO_ATENDIMENTO" ADD CONSTRAINT "PK_PGA" PRIMARY KEY ("PGA_ATD_ID", "PGA_FPG_ID")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table H_ATENDIMENTO
--------------------------------------------------------

  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_DT_ATENDIMENTO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_TIPO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_CLI_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_FUN_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_TOTAL_SERVICO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_QTD_SERVICO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_TOTAL_PRODUTOS" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_QTD_PRODUTO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_TOTAL_PACOTES" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_QTD_PACOTES" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_TOTAL_VALE_PRESENTE" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_QTD_VALE_PRESENTE" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_TOTAL_CREDITO_CLIENTE" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_TOTAL_DESCONTOS" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_TOTAL_GERAL" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" MODIFY ("HATD_DT_ENTRADA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_ATENDIMENTO" ADD CONSTRAINT "PK_HATD" PRIMARY KEY ("HATD_ID", "HATD_DT_ENTRADA")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table H_CAIXA_DIARIO
--------------------------------------------------------

  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_DT_MOVIMENTO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_ABERTURA_CAIXA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_RECEBIDO_DINHEIRO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_TROCO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_DESPESAS_DINHEIRO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_TOTAL_DINHEIRO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_SANGRIA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_SALDO_CAIXA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_RECEBIDO_OUTRAS_FORMAS" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_DESPESAS_OUTRAS_FORMAS" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" MODIFY ("HCXD_DT_ENTRADA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CAIXA_DIARIO" ADD CONSTRAINT "PK_HCXD" PRIMARY KEY ("HCXD_ID", "HCXD_DT_ENTRADA")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table H_CLIENTE
--------------------------------------------------------

  ALTER TABLE "APP"."H_CLIENTE" MODIFY ("HCLI_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CLIENTE" MODIFY ("HCLI_NOME" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CLIENTE" MODIFY ("HCLI_DT_ENTRADA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_CLIENTE" ADD CONSTRAINT "PK_HCLI" PRIMARY KEY ("HCLI_ID", "HCLI_DT_ENTRADA")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table H_FORMA_PAGAMENTO
--------------------------------------------------------

  ALTER TABLE "APP"."H_FORMA_PAGAMENTO" MODIFY ("HFPG_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_FORMA_PAGAMENTO" MODIFY ("HFPG_DESCRICAO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_FORMA_PAGAMENTO" MODIFY ("HFPG_DT_ENTRADA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_FORMA_PAGAMENTO" ADD CONSTRAINT "PK_HFPG" PRIMARY KEY ("HFPG_ID", "HFPG_DT_ENTRADA")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table H_FUNCIONARIO
--------------------------------------------------------

  ALTER TABLE "APP"."H_FUNCIONARIO" MODIFY ("HFUN_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_FUNCIONARIO" MODIFY ("HFUN_NOME" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_FUNCIONARIO" MODIFY ("HFUN_DT_ENTRADA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_FUNCIONARIO" ADD CONSTRAINT "PK_HFUN" PRIMARY KEY ("HFUN_ID", "HFUN_DT_ENTRADA")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table H_MOTIVO_DESCONTO
--------------------------------------------------------

  ALTER TABLE "APP"."H_MOTIVO_DESCONTO" MODIFY ("HMTD_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_MOTIVO_DESCONTO" MODIFY ("HMTD_DESCRICAO" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_MOTIVO_DESCONTO" MODIFY ("HMTD_DT_ENTRADA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_MOTIVO_DESCONTO" ADD CONSTRAINT "PK_HMTD" PRIMARY KEY ("HMTD_ID", "HMTD_DT_ENTRADA")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Constraints for Table H_PAGAMENTO_ATENDIMENTO
--------------------------------------------------------

  ALTER TABLE "APP"."H_PAGAMENTO_ATENDIMENTO" MODIFY ("HPGA_ATD_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_PAGAMENTO_ATENDIMENTO" MODIFY ("HPGA_FPG_ID" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_PAGAMENTO_ATENDIMENTO" MODIFY ("HPGA_VALOR" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_PAGAMENTO_ATENDIMENTO" MODIFY ("HPGA_DT_ENTRADA" NOT NULL ENABLE);
  ALTER TABLE "APP"."H_PAGAMENTO_ATENDIMENTO" ADD CONSTRAINT "PK_HPGA" PRIMARY KEY ("HPGA_ATD_ID", "HPGA_FPG_ID", "HPGA_DT_ENTRADA")
  USING INDEX  ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table ATENDIMENTO
--------------------------------------------------------

  ALTER TABLE "APP"."ATENDIMENTO" ADD CONSTRAINT "FK_ATD_CLI" FOREIGN KEY ("ATD_CLI_ID")
	  REFERENCES "APP"."CLIENTE" ("CLI_ID") ENABLE;
  ALTER TABLE "APP"."ATENDIMENTO" ADD CONSTRAINT "FK_ATD_FUN" FOREIGN KEY ("ATD_FUN_ID")
	  REFERENCES "APP"."FUNCIONARIO" ("FUN_ID") ENABLE;
  ALTER TABLE "APP"."ATENDIMENTO" ADD CONSTRAINT "FK_ATD_MTD" FOREIGN KEY ("ATD_MTD_ID")
	  REFERENCES "APP"."MOTIVO_DESCONTO" ("MTD_ID") ENABLE;
--------------------------------------------------------
--  Ref Constraints for Table PAGAMENTO_ATENDIMENTO
--------------------------------------------------------

  ALTER TABLE "APP"."PAGAMENTO_ATENDIMENTO" ADD CONSTRAINT "FK_PGA_FPG" FOREIGN KEY ("PGA_FPG_ID")
	  REFERENCES "APP"."FORMA_PAGAMENTO" ("FPG_ID") ENABLE;
