/* ============================================================================
   Arquivo de Criação de Views Analíticas do Salão - Parte 2

   Descrição: Script com 10 views analíticas sobre períodos, horários,
             frequência e retenção de clientes, crédito e caixa do sistema
             de gestão de salão (Cachearia).

   Períodos da base: 1 = jan a ago/2025 | 2 = set/2025 a fev/2026 |
                     3 = mar a ago/2026

   Views criadas:
   Rafael
   1.  VW_HORARIO_PICO_RAFAEL        - Faturamento por horário do dia
   2.  VW_COMPARACAO_PERIODOS_RAFAEL - Comparação entre os três períodos
   Opções para escolha do grupo
   3.  VW_FREQUENCIA_CLIENTES        - Clientes por faixa de frequência
   4.  VW_CICLO_RETORNO_CLIENTE      - Intervalo médio entre visitas
   5.  VW_MATRIZ_RECENCIA_FREQUENCIA - Segmentos de clientes
   6.  VW_ATEND_CREDITO_PERIODO      - Atendimentos pagos com crédito
   7.  VW_RETENCAO_PERIODOS          - Clientes que voltam no período seguinte
   8.  VW_FLUXO_CAIXA_MENSAL         - Entradas x saídas do caixa por mês
   9.  VW_CONCILIACAO_CAIXA          - Caixa x pagamentos registrados
   10. VW_PAGAMENTOS_FORA_DO_DIA     - Contas pagas depois do atendimento
   ============================================================================ */

/* ============================================================================
   1. HORÁRIO DE PICO (Rafael)
   Atendimentos e faturamento por hora de fechamento da conta.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_HORARIO_PICO_RAFAEL AS
SELECT
    TO_CHAR(a.data_pagamento, 'HH24') || 'h' AS Faixa_Horario,
    COUNT(*) AS Qtd_Atendimentos,
    SUM(a.total_geral) AS Faturamento_Total,
    ROUND(AVG(a.total_geral), 2) AS Ticket_Medio,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS Percentual_Atendimentos
FROM atendimento a
WHERE a.tipo = 'Pagamento'
GROUP BY TO_CHAR(a.data_pagamento, 'HH24')
ORDER BY Faixa_Horario;

/* ============================================================================
   2. COMPARAÇÃO ENTRE PERÍODOS (Rafael)
   Atendimentos, clientes, faturamento e média mensal de cada período.
   Etapa 1 (WITH): etiqueta cada atendimento com o seu período.
   Etapa 2 (SELECT): agrupa por período e faz as contas.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_COMPARACAO_PERIODOS_RAFAEL AS
WITH atendimentos_por_periodo AS (
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
SELECT
    Periodo,
    COUNT(DISTINCT Mes) AS Meses,
    COUNT(*) AS Qtd_Atendimentos,
    COUNT(DISTINCT id_cliente) AS Clientes_Atendidos,
    SUM(total_geral) AS Faturamento_Total,
    ROUND(SUM(total_geral) / COUNT(DISTINCT Mes), 2) AS Faturamento_Medio_Mensal,
    ROUND(AVG(total_geral), 2) AS Ticket_Medio
FROM atendimentos_por_periodo
GROUP BY Periodo
ORDER BY Periodo;

/* ============================================================================
   3. FREQUÊNCIA DE CLIENTES
   Clientes e faturamento por faixa de número de visitas.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_FREQUENCIA_CLIENTES AS
WITH visitas_cliente AS (
    SELECT
        a.id_cliente,
        COUNT(DISTINCT a.data_atendimento) AS qtd_visitas,
        SUM(a.total_geral) AS valor_total
    FROM atendimento a
    WHERE a.tipo = 'Pagamento'
    GROUP BY a.id_cliente
)
SELECT
    CASE
        WHEN qtd_visitas = 1 THEN '1 visita'
        WHEN qtd_visitas = 2 THEN '2 visitas'
        WHEN qtd_visitas <= 5 THEN '3 a 5 visitas'
        ELSE '6 ou mais'
    END AS Faixa_Frequencia,
    COUNT(*) AS Qtd_Clientes,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS Percentual_Clientes,
    SUM(valor_total) AS Faturamento,
    ROUND(100 * SUM(valor_total) / SUM(SUM(valor_total)) OVER (), 2) AS Percentual_Faturamento
FROM visitas_cliente
GROUP BY
    CASE
        WHEN qtd_visitas = 1 THEN '1 visita'
        WHEN qtd_visitas = 2 THEN '2 visitas'
        WHEN qtd_visitas <= 5 THEN '3 a 5 visitas'
        ELSE '6 ou mais'
    END
ORDER BY MIN(qtd_visitas);

/* ============================================================================
   4. CICLO DE RETORNO DAS CLIENTES
   Intervalo médio entre visitas e próxima visita prevista (3+ visitas).
   ============================================================================ */
CREATE OR REPLACE VIEW VW_CICLO_RETORNO_CLIENTE AS
WITH visitas AS (
    SELECT DISTINCT a.id_cliente, a.data_atendimento
    FROM atendimento a
    WHERE a.tipo = 'Pagamento'
),
intervalos AS (
    SELECT
        id_cliente,
        data_atendimento,
        data_atendimento - LAG(data_atendimento) OVER (PARTITION BY id_cliente ORDER BY data_atendimento) AS dias_desde_anterior
    FROM visitas
)
SELECT
    c.nome_cliente AS Cliente,
    COUNT(*) AS Qtd_Visitas,
    ROUND(AVG(i.dias_desde_anterior)) AS Intervalo_Medio_Dias,
    MAX(i.data_atendimento) AS Ultima_Visita,
    MAX(i.data_atendimento) + ROUND(AVG(i.dias_desde_anterior)) AS Proxima_Visita_Prevista
FROM intervalos i
JOIN cliente c ON c.id_cliente = i.id_cliente
GROUP BY c.id_cliente, c.nome_cliente
HAVING COUNT(*) >= 3
ORDER BY Intervalo_Medio_Dias;

/* ============================================================================
   5. MATRIZ DE CLIENTES: RECÊNCIA X FREQUÊNCIA
   Quatro segmentos de clientes a partir do último atendimento da base.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_MATRIZ_RECENCIA_FREQUENCIA AS
WITH perfil AS (
    SELECT
        a.id_cliente,
        (SELECT MAX(data_atendimento) FROM atendimento) - MAX(a.data_atendimento) AS dias_sem_visitar,
        COUNT(DISTINCT a.data_atendimento) AS qtd_visitas,
        SUM(a.total_geral) AS valor_total
    FROM atendimento a
    WHERE a.tipo = 'Pagamento'
    GROUP BY a.id_cliente
)
SELECT
    CASE
        WHEN dias_sem_visitar <= 90 AND qtd_visitas >= 3 THEN '1 - Fieis ativas'
        WHEN dias_sem_visitar <= 90 THEN '2 - Ativas pouco frequentes'
        WHEN qtd_visitas >= 3 THEN '3 - Fieis em risco'
        ELSE '4 - Inativas'
    END AS Segmento,
    COUNT(*) AS Qtd_Clientes,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS Percentual_Clientes,
    SUM(valor_total) AS Faturamento_Historico,
    ROUND(AVG(valor_total), 2) AS Valor_Medio_Por_Cliente
FROM perfil
GROUP BY
    CASE
        WHEN dias_sem_visitar <= 90 AND qtd_visitas >= 3 THEN '1 - Fieis ativas'
        WHEN dias_sem_visitar <= 90 THEN '2 - Ativas pouco frequentes'
        WHEN qtd_visitas >= 3 THEN '3 - Fieis em risco'
        ELSE '4 - Inativas'
    END
ORDER BY Segmento;

/* ============================================================================
   6. ATENDIMENTOS PAGOS COM CRÉDITO, POR PERÍODO
   Quanto da operação é consumo de crédito pré-existente das clientes.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_ATEND_CREDITO_PERIODO AS
SELECT
    Periodo,
    COUNT(*) AS Qtd_Atendimentos,
    SUM(CASE WHEN total_credito_cliente > 0 THEN 1 ELSE 0 END) AS Atendimentos_Com_Credito,
    ROUND(100 * SUM(CASE WHEN total_credito_cliente > 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS Percentual_Com_Credito,
    SUM(total_credito_cliente) AS Valor_Credito_Utilizado
FROM (
    SELECT
        CASE
            WHEN a.data_atendimento < DATE '2025-09-01' THEN '1 - jan a ago/2025'
            WHEN a.data_atendimento < DATE '2026-03-01' THEN '2 - set/2025 a fev/2026'
            ELSE '3 - mar a ago/2026'
        END AS Periodo,
        a.total_credito_cliente
    FROM atendimento a
    WHERE a.tipo = 'Pagamento'
)
GROUP BY Periodo
ORDER BY Periodo;

/* ============================================================================
   7. RETENÇÃO ENTRE PERÍODOS
   Clientes de um período que voltaram no período seguinte.
   Precisa da base com todos os períodos carregados.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_RETENCAO_PERIODOS AS
WITH cliente_periodo AS (
    SELECT DISTINCT
        a.id_cliente,
        CASE
            WHEN a.data_atendimento < DATE '2025-09-01' THEN 1
            WHEN a.data_atendimento < DATE '2026-03-01' THEN 2
            ELSE 3
        END AS periodo
    FROM atendimento a
    WHERE a.tipo = 'Pagamento'
)
SELECT
    'Periodo ' || atual.periodo || ' para Periodo ' || (atual.periodo + 1) AS Transicao,
    COUNT(DISTINCT atual.id_cliente) AS Clientes_No_Periodo,
    COUNT(DISTINCT seguinte.id_cliente) AS Voltaram_No_Seguinte,
    ROUND(100 * COUNT(DISTINCT seguinte.id_cliente) / COUNT(DISTINCT atual.id_cliente), 2) AS Taxa_Retencao
FROM cliente_periodo atual
LEFT JOIN cliente_periodo seguinte
    ON seguinte.id_cliente = atual.id_cliente
   AND seguinte.periodo = atual.periodo + 1
WHERE atual.periodo < 3
GROUP BY atual.periodo
ORDER BY atual.periodo;

/* ============================================================================
   8. FLUXO DO CAIXA POR MÊS
   Entradas x saídas do fechamento diário. As saídas ficam negativas no
   banco (por isso o ABS) e podem incluir repasses e retiradas.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_FLUXO_CAIXA_MENSAL AS
SELECT
    TO_CHAR(cx.data_movimento, 'YYYY-MM') AS Mes,
    COUNT(*) AS Dias_Com_Caixa,
    SUM(cx.recebido_dinheiro + cx.recebido_outras_formas) AS Total_Entradas,
    SUM(ABS(cx.despesas_dinheiro) + ABS(cx.despesas_outras_formas)) AS Total_Saidas,
    SUM(cx.recebido_dinheiro + cx.recebido_outras_formas)
      - SUM(ABS(cx.despesas_dinheiro) + ABS(cx.despesas_outras_formas)) AS Saldo_Do_Mes,
    ROUND(100 * SUM(ABS(cx.despesas_dinheiro) + ABS(cx.despesas_outras_formas))
          / NULLIF(SUM(cx.recebido_dinheiro + cx.recebido_outras_formas), 0), 2) AS Percentual_Saidas_Sobre_Entradas
FROM caixa_diario cx
GROUP BY TO_CHAR(cx.data_movimento, 'YYYY-MM')
ORDER BY Mes;

/* ============================================================================
   9. CONCILIAÇÃO: CAIXA X PAGAMENTOS REGISTRADOS
   Recebido no caixa x soma dos pagamentos, por mês. Pagamentos negativos
   (pré-pago consumido e troco) são ajustes e ficam fora da soma.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_CONCILIACAO_CAIXA AS
WITH pagamentos_dia AS (
    SELECT
        TRUNC(a.data_pagamento) AS dia,
        SUM(pa.valor) AS valor_pago
    FROM pagamento_atendimento pa
    JOIN atendimento a ON a.id_atendimento = pa.id_atendimento
    WHERE pa.valor > 0
    GROUP BY TRUNC(a.data_pagamento)
),
caixa_dia AS (
    SELECT
        cx.data_movimento AS dia,
        cx.recebido_dinheiro + cx.recebido_outras_formas AS recebido
    FROM caixa_diario cx
)
SELECT
    TO_CHAR(COALESCE(c.dia, p.dia), 'YYYY-MM') AS Mes,
    SUM(NVL(c.recebido, 0)) AS Recebido_No_Caixa,
    SUM(NVL(p.valor_pago, 0)) AS Pagamentos_Registrados,
    SUM(NVL(c.recebido, 0)) - SUM(NVL(p.valor_pago, 0)) AS Diferenca,
    SUM(CASE WHEN ABS(NVL(c.recebido, 0) - NVL(p.valor_pago, 0)) >= 0.01 THEN 1 ELSE 0 END) AS Dias_Com_Divergencia
FROM caixa_dia c
FULL OUTER JOIN pagamentos_dia p ON p.dia = c.dia
GROUP BY TO_CHAR(COALESCE(c.dia, p.dia), 'YYYY-MM')
ORDER BY Mes;

/* ============================================================================
   10. PAGAMENTOS FORA DO DIA DO ATENDIMENTO
   Atendimentos pagos em um dia posterior ao atendimento.
   ============================================================================ */
CREATE OR REPLACE VIEW VW_PAGAMENTOS_FORA_DO_DIA AS
SELECT
    c.nome_cliente AS Cliente,
    a.data_atendimento AS Data_Atendimento,
    a.data_pagamento AS Data_Pagamento,
    TRUNC(a.data_pagamento) - a.data_atendimento AS Dias_Ate_Pagar,
    a.total_geral AS Valor
FROM atendimento a
JOIN cliente c ON c.id_cliente = a.id_cliente
WHERE a.tipo = 'Pagamento'
  AND TRUNC(a.data_pagamento) > a.data_atendimento
ORDER BY Dias_Ate_Pagar DESC;

/* ============================================================================
   FIM DO SCRIPT
   ============================================================================ */
