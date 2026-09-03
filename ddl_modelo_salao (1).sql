/* ============================================================================
   LABORATÓRIO DE BANCO DE DADOS - ENTREGA 1 (PARCIAL)
   Modelo Relacional - Sistema de Gestão de Salão (Cachearia)
   DDL: Tabelas, Sequences e Triggers
   Dialeto: Oracle PL/SQL
   ============================================================================
   Ordem de execução: sequences -> tabelas (pais antes de filhas) -> triggers
   ============================================================================ */


/* ============================================================================
   1. SEQUENCES
   Uma sequence por tabela com chave primária artificial (surrogate key),
   usada pelas triggers de auto-incremento no INSERT.
   ============================================================================ */

CREATE SEQUENCE seq_cliente
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_funcionario
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_motivo_desconto
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_forma_pagamento
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_atendimento
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE SEQUENCE seq_caixa_diario
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

/* PAGAMENTO_ATENDIMENTO não recebe sequence: sua chave primária é composta
   (id_atendimento, id_forma), herdada das tabelas relacionadas. */


/* ============================================================================
   2. TABELAS
   ============================================================================ */

-- ----------------------------------------------------------------------------
-- 2.1 CLIENTE
-- ----------------------------------------------------------------------------
CREATE TABLE cliente (
    id_cliente      NUMBER(10)      NOT NULL,
    nome_cliente    VARCHAR2(150)   NOT NULL,
    CONSTRAINT pk_cliente PRIMARY KEY (id_cliente)
);

-- ----------------------------------------------------------------------------
-- 2.2 FUNCIONARIO
-- ----------------------------------------------------------------------------
CREATE TABLE funcionario (
    id_funcionario      NUMBER(10)      NOT NULL,
    nome_funcionario    VARCHAR2(100)   NOT NULL,
    CONSTRAINT pk_funcionario PRIMARY KEY (id_funcionario),
    CONSTRAINT uq_funcionario_nome UNIQUE (nome_funcionario)
);

-- ----------------------------------------------------------------------------
-- 2.3 MOTIVO_DESCONTO
-- ----------------------------------------------------------------------------
CREATE TABLE motivo_desconto (
    id_motivo       NUMBER(10)      NOT NULL,
    descricao       VARCHAR2(200)   NOT NULL,
    CONSTRAINT pk_motivo_desconto PRIMARY KEY (id_motivo),
    CONSTRAINT uq_motivo_desconto_descricao UNIQUE (descricao)
);

-- ----------------------------------------------------------------------------
-- 2.4 FORMA_PAGAMENTO
-- ----------------------------------------------------------------------------
CREATE TABLE forma_pagamento (
    id_forma        NUMBER(10)      NOT NULL,
    descricao       VARCHAR2(30)    NOT NULL,
    CONSTRAINT pk_forma_pagamento PRIMARY KEY (id_forma),
    CONSTRAINT uq_forma_pagamento_descricao UNIQUE (descricao)
);

-- ----------------------------------------------------------------------------
-- 2.5 ATENDIMENTO
-- ----------------------------------------------------------------------------
CREATE TABLE atendimento (
    id_atendimento          NUMBER(10)      NOT NULL,
    data_atendimento        DATE            NOT NULL,
    data_pagamento          DATE,
    tipo                    VARCHAR2(30)    NOT NULL,
    id_cliente              NUMBER(10)      NOT NULL,
    id_funcionario          NUMBER(10)      NOT NULL,
    total_servico           NUMBER(10,2)    DEFAULT 0   NOT NULL,
    qtd_servico             NUMBER(5)       DEFAULT 0   NOT NULL,
    total_produtos          NUMBER(10,2)    DEFAULT 0   NOT NULL,
    qtd_produto             NUMBER(5)       DEFAULT 0   NOT NULL,
    total_pacotes           NUMBER(10,2)    DEFAULT 0   NOT NULL,
    qtd_pacotes             NUMBER(5)       DEFAULT 0   NOT NULL,
    total_vale_presente     NUMBER(10,2)    DEFAULT 0   NOT NULL,
    qtd_vale_presente       NUMBER(5)       DEFAULT 0   NOT NULL,
    total_credito_cliente   NUMBER(10,2)    DEFAULT 0   NOT NULL,
    total_descontos         NUMBER(10,2)    DEFAULT 0   NOT NULL,
    id_motivo               NUMBER(10),
    total_geral             NUMBER(10,2)    DEFAULT 0   NOT NULL,
    comentario_fechamento   VARCHAR2(500),
    comentario_estorno      VARCHAR2(500),
    CONSTRAINT pk_atendimento PRIMARY KEY (id_atendimento),
    CONSTRAINT fk_atendimento_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente),
    CONSTRAINT fk_atendimento_funcionario FOREIGN KEY (id_funcionario)
        REFERENCES funcionario (id_funcionario),
    CONSTRAINT fk_atendimento_motivo FOREIGN KEY (id_motivo)
        REFERENCES motivo_desconto (id_motivo),
    CONSTRAINT ck_atendimento_tipo CHECK (tipo IN ('Pagamento','Estorno'))
);

-- ----------------------------------------------------------------------------
-- 2.6 PAGAMENTO_ATENDIMENTO (tabela associativa: normaliza as colunas de
--     pagamento que estavam "largas" no relatório original em pares
--     atendimento/forma de pagamento -> valor)
-- ----------------------------------------------------------------------------
CREATE TABLE pagamento_atendimento (
    id_atendimento  NUMBER(10)      NOT NULL,
    id_forma        NUMBER(10)      NOT NULL,
    valor           NUMBER(10,2)    NOT NULL,
    CONSTRAINT pk_pagamento_atendimento PRIMARY KEY (id_atendimento, id_forma),
    CONSTRAINT fk_pagamento_atendimento FOREIGN KEY (id_atendimento)
        REFERENCES atendimento (id_atendimento),
    CONSTRAINT fk_pagamento_forma FOREIGN KEY (id_forma)
        REFERENCES forma_pagamento (id_forma)
);

-- ----------------------------------------------------------------------------
-- 2.7 CAIXA_DIARIO (fechamento diário; independente de ATENDIMENTO, pois tem
--     granularidade diferente - 1 registro por dia)
-- ----------------------------------------------------------------------------
CREATE TABLE caixa_diario (
    id_caixa                    NUMBER(10)      NOT NULL,
    data_movimento               DATE            NOT NULL,
    abertura_caixa                NUMBER(10,2)    DEFAULT 0 NOT NULL,
    recebido_dinheiro             NUMBER(10,2)    DEFAULT 0 NOT NULL,
    troco                          NUMBER(10,2)    DEFAULT 0 NOT NULL,
    despesas_dinheiro              NUMBER(10,2)    DEFAULT 0 NOT NULL,
    total_dinheiro                 NUMBER(10,2)    DEFAULT 0 NOT NULL,
    sangria                        NUMBER(10,2)    DEFAULT 0 NOT NULL,
    saldo_caixa                    NUMBER(10,2)    DEFAULT 0 NOT NULL,
    recebido_outras_formas         NUMBER(10,2)    DEFAULT 0 NOT NULL,
    despesas_outras_formas         NUMBER(10,2)    DEFAULT 0 NOT NULL,
    CONSTRAINT pk_caixa_diario PRIMARY KEY (id_caixa),
    CONSTRAINT uq_caixa_diario_data UNIQUE (data_movimento)
);


/* ============================================================================
   3. TRIGGERS
   ============================================================================ */

-- ----------------------------------------------------------------------------
-- 3.1 Triggers de auto-incremento (BEFORE INSERT) — associam cada sequence
--     à respectiva chave primária, dispensando o valor no INSERT.
-- ----------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_cliente_bi
BEFORE INSERT ON cliente
FOR EACH ROW
WHEN (NEW.id_cliente IS NULL)
BEGIN
    :NEW.id_cliente := seq_cliente.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_funcionario_bi
BEFORE INSERT ON funcionario
FOR EACH ROW
WHEN (NEW.id_funcionario IS NULL)
BEGIN
    :NEW.id_funcionario := seq_funcionario.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_motivo_desconto_bi
BEFORE INSERT ON motivo_desconto
FOR EACH ROW
WHEN (NEW.id_motivo IS NULL)
BEGIN
    :NEW.id_motivo := seq_motivo_desconto.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_forma_pagamento_bi
BEFORE INSERT ON forma_pagamento
FOR EACH ROW
WHEN (NEW.id_forma IS NULL)
BEGIN
    :NEW.id_forma := seq_forma_pagamento.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_atendimento_bi
BEFORE INSERT ON atendimento
FOR EACH ROW
WHEN (NEW.id_atendimento IS NULL)
BEGIN
    :NEW.id_atendimento := seq_atendimento.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_caixa_diario_bi
BEFORE INSERT ON caixa_diario
FOR EACH ROW
WHEN (NEW.id_caixa IS NULL)
BEGIN
    :NEW.id_caixa := seq_caixa_diario.NEXTVAL;
END;
/


-- ----------------------------------------------------------------------------
-- 3.2 Trigger de regra de negócio: recalcula automaticamente o total_geral
--     do atendimento a partir dos totais de serviço, produto, pacote,
--     vale-presente e descontos, garantindo consistência mesmo se o
--     aplicativo cliente não enviar o total pronto.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_atendimento_calc_total
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


-- ----------------------------------------------------------------------------
-- 3.3 Trigger de auditoria/validação: impede que o valor de um pagamento
--     detalhado (PAGAMENTO_ATENDIMENTO) seja nulo ou que a soma dos
--     pagamentos de um atendimento ultrapasse um valor absurdo (regra de
--     integridade adicional, além das constraints declarativas).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_pagamento_valor_check
BEFORE INSERT OR UPDATE ON pagamento_atendimento
FOR EACH ROW
BEGIN
    IF :NEW.valor IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'O valor do pagamento não pode ser nulo.');
    END IF;
END;
/


-- ----------------------------------------------------------------------------
-- 3.4 Trigger de log simples: registra em uma tabela de auditoria sempre que
--     um atendimento for excluído (rastreabilidade de estornos/remoções).
-- ----------------------------------------------------------------------------
CREATE TABLE atendimento_log (
    id_log          NUMBER(10)      NOT NULL,
    id_atendimento  NUMBER(10)      NOT NULL,
    data_exclusao   DATE            DEFAULT SYSDATE NOT NULL,
    usuario_bd      VARCHAR2(60)    DEFAULT USER    NOT NULL,
    CONSTRAINT pk_atendimento_log PRIMARY KEY (id_log)
);

CREATE SEQUENCE seq_atendimento_log
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

CREATE OR REPLACE TRIGGER trg_atendimento_log_del
AFTER DELETE ON atendimento
FOR EACH ROW
BEGIN
    INSERT INTO atendimento_log (id_log, id_atendimento, data_exclusao, usuario_bd)
    VALUES (seq_atendimento_log.NEXTVAL, :OLD.id_atendimento, SYSDATE, USER);
END;
/

/* ============================================================================
   FIM DO SCRIPT
   ============================================================================ */
