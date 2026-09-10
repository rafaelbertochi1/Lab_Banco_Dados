/* ============================================================================
   Arquivo de Criação de Views Analíticas do Salão
   
   Descrição: Script com 8 views analíticas para análise de dados do sistema
             de gestão de salão (Cachearia). Essas views fornecem insights
             sobre faturamento, clientes, descontos e performance.
   
 
   Views criadas:
   1. VW_ANALISE_FORMAS_PAGAMENTO - Análise de formas de pagamento
   2. VW_CLI_NOVOS_VELHOS - Clientes novos vs recorrentes
   3. VW_DESCONTO_MOTIVO - Descontos por motivo
   4. VW_FATURAMENTO_DIA_SEMANA - Faturamento por dia da semana
   5. VW_FATURAMENTO_FUNCIONARIO - Faturamento por funcionário
   6. VW_FATURAMENTO_MENSAL - Faturamento total mês a mês
   7. VW_RECEITA_CATEGORIA - Receita por categoria
   8. VW_RETORNO_CLIENTE - Clientes inativos e faturamento
   ============================================================================ */

/* ============================================================================
   1. ANÁLISE DE FORMAS DE PAGAMENTO
   Mostra a distribuição de valores e quantidade de transações por forma de pagamento.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_ANALISE_FORMAS_PAGAMENTO AS
SELECT
    fp.descricao AS Forma_Pagamento,
    COUNT(*) AS Qtd_Transacoes,
    SUM(pa.valor) AS Valor_Total,
    ROUND(100 * SUM(pa.valor) / SUM(SUM(pa.valor)) OVER (), 2) AS Percentual_Participacao
FROM pagamento_atendimento pa
JOIN forma_pagamento fp ON pa.id_forma = fp.id_forma
GROUP BY fp.descricao
ORDER BY Valor_Total DESC;

/* ============================================================================
   2. CLIENTES NOVOS VS RECORRENTES
   Identifica primeira visita e separa clientes novos de recorrentes por mês.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_CLI_NOVOS_VELHOS AS
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
ORDER BY Mes;

/* ============================================================================
   3. DESCONTOS POR MOTIVO
   Mostra impacto financeiro dos descontos segmentado por motivo.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_DESCONTO_MOTIVO AS
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
ORDER BY Valor_Total_Descontado DESC;


/* ============================================================================
   4. FATURAMENTO POR DIA DA SEMANA
   Identifica padrões de consumo ao longo da semana.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_FATURAMENTO_DIA_SEMANA AS
SELECT
    TO_CHAR(a.data_atendimento, 'D') AS Dia_Num,
    TRIM(TO_CHAR(a.data_atendimento, 'DAY', 'NLS_DATE_LANGUAGE=PORTUGUESE')) AS Dia_Semana,
    COUNT(*) AS Qtd_Atendimentos,
    SUM(a.total_geral) AS Faturamento_Total,
    ROUND(AVG(a.total_geral), 2) AS Ticket_Medio
FROM atendimento a
WHERE a.tipo = 'Pagamento'
GROUP BY TO_CHAR(a.data_atendimento, 'D'), TRIM(TO_CHAR(a.data_atendimento, 'DAY', 'NLS_DATE_LANGUAGE=PORTUGUESE'))
ORDER BY Dia_Num;

/* ============================================================================
   5. FATURAMENTO POR FUNCIONÁRIO
   Ranqueia funcionários por produtividade e faturamento gerado.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_FATURAMENTO_FUNCIONARIO AS
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
ORDER BY Ranking;

/* ============================================================================
   6. FATURAMENTO MENSAL
   Acompanhamento de faturamento e ticket médio mês a mês.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_FATURAMENTO_MENSAL AS
SELECT
    TRUNC(a.data_atendimento, 'MONTH') AS Mes_Referencia,
    COUNT(*) AS Qtd_Atendimentos,
    SUM(a.total_geral) AS Faturamento_Total,
    ROUND(AVG(a.total_geral), 2) AS Ticket_Medio
FROM atendimento a
WHERE a.tipo = 'Pagamento'
GROUP BY TRUNC(a.data_atendimento, 'MONTH')
ORDER BY Mes_Referencia;

/* ============================================================================
   7. RECEITA POR CATEGORIA
   Desagrega receita por tipo de serviço/produto (Serviços, Produtos, etc).
   ============================================================================ */
CREATE OR REPLACE VIEW VW_RECEITA_CATEGORIA AS
SELECT
    categoria,
    valor,
    ROUND(100 * valor / SUM(valor) OVER (), 2) AS Percentual_Receita
FROM (
    SELECT 'Servicos'	   AS categoria, SUM(total_servico)	 AS valor FROM atendimento WHERE tipo = 'Pagamento'
    UNION ALL
    SELECT 'Produtos',		  SUM(total_produtos)	   FROM atendimento WHERE tipo = 'Pagamento'
    UNION ALL
    SELECT 'Pacotes',		  SUM(total_pacotes)	   FROM atendimento WHERE tipo = 'Pagamento'
    UNION ALL
    SELECT 'Vale-Presente',	  SUM(total_vale_presente) FROM atendimento WHERE tipo = 'Pagamento'
)
ORDER BY valor DESC;

/* ============================================================================
   8. CLIENTES INATIVOS (RETORNO)
   Identifica clientes que não visitam há mais de 3 meses (oportunidade CRM).
   ============================================================================ */
CREATE OR REPLACE VIEW VW_RETORNO_CLIENTE AS
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
ORDER BY Valor_Total_Historico DESC;

/* ============================================================================
   FIM DO SCRIPT - Todas as views foram criadas com sucesso!
   ============================================================================ */
COMMIT;
