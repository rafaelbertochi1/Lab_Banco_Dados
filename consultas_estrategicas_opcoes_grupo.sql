/* Consultas Estratégicas - Opções para escolha do grupo
   Sistema de Gestão de Salão (Cachearia)
   Períodos da base: 1 = jan a ago/2025 | 2 = set/2025 a fev/2026 | 3 = mar a ago/2026 */


/*
### 1. (Frequência de Clientes)
*Objetivo Estratégico:* Entender quantas clientes voltam ao salão e quanto
cada grupo de frequência representa no faturamento. Mostra se a receita
depende de clientes fiéis ou de clientes que vêm uma única vez.
- *Consulta SQL Sugerida:*
*/
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
/*
- *Impacto:* Se uma minoria de clientes frequentes concentra boa parte do
faturamento, vale investir em fidelização (pacotes, lembretes de retorno)
em vez de gastar só com captação de clientes novas.
*/


/*
### 2. (Ciclo de Retorno das Clientes)
*Objetivo Estratégico:* Descobrir de quantos em quantos dias cada cliente
costuma voltar e prever a data da próxima visita. Considera apenas clientes
com 3 visitas ou mais, para a média ser confiável.
- *Consulta SQL Sugerida:*
*/
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
/*
- *Impacto:* Permite um contato ativo perto da data prevista (mensagem de
lembrete ou oferta), aumentando a chance de a cliente voltar no ritmo dela
em vez de esquecer ou trocar de salão.
*/


/*
### 3. (Matriz de Clientes: Recência x Frequência)
*Objetivo Estratégico:* Separar a carteira em 4 grupos cruzando há quanto
tempo a cliente não vem (recência) com quantas vezes ela já veio
(frequência). A data de referência é o último atendimento da base.
- *Consulta SQL Sugerida:*
*/
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
/*
- *Impacto:* Cada grupo pede uma ação diferente: manter as fiéis ativas,
converter as pouco frequentes, resgatar as fiéis em risco antes que virem
inativas. O grupo "Fieis em risco" é o mais urgente.
*/


/*
### 4. (Atendimentos Pagos com Crédito, por Período)
*Objetivo Estratégico:* Medir quanto da operação é consumo de crédito
pré-existente das clientes (pacotes pagos antes), ou seja, atendimentos que
não trazem dinheiro novo no dia.
- *Consulta SQL Sugerida:*
*/
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
/*
- *Impacto:* Um percentual alto indica que o caixa do dia a dia depende de
vendas antigas de pacotes. Se ele sobe e as vendas de pacotes novas não
acompanham, o salão atende mais sem receber mais.
*/


/*
### 5. (Retenção entre Períodos)
*Objetivo Estratégico:* Das clientes atendidas em um período, quantas
voltaram no período seguinte. Mede a fidelização ao longo do tempo.
Observação: precisa da base com todos os períodos carregados.
- *Consulta SQL Sugerida:*
*/
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
/*
- *Impacto:* Uma taxa de retenção caindo de um período para o outro indica
perda de clientes da base, e explica quedas de faturamento mesmo quando o
salão continua captando clientes novas.
*/


/*
### 6. (Fluxo do Caixa por Mês: Entradas x Saídas)
*Objetivo Estratégico:* Comparar, mês a mês, o que entrou no caixa com as
despesas pagas, a partir do fechamento diário (CAIXA_DIARIO).
Observação: as saídas são todas as despesas lançadas no caixa (no banco
elas ficam negativas, por isso o ABS); podem incluir repasses e retiradas,
não só custos operacionais.
- *Consulta SQL Sugerida:*
*/
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
/*
- *Impacto:* Meses em que as saídas passam das entradas mostram pressão de
caixa e ajudam a planejar reservas para os meses mais fracos.
*/


/*
### 7. (Conciliação: Caixa x Pagamentos Registrados)
*Objetivo Estratégico:* Conferir, mês a mês, se o valor recebido nos
fechamentos de caixa bate com a soma dos pagamentos registrados nos
atendimentos, e contar quantos dias tiveram divergência.
Observação: pagamentos com valor negativo (pré-pago consumido e troco) são
ajustes, não entrada de dinheiro, por isso ficam fora da soma.
- *Consulta SQL Sugerida:*
*/
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
/*
- *Impacto:* É uma consulta de controle: comprova que o dinheiro registrado
nos atendimentos é o mesmo que foi conferido no caixa. Qualquer mês com
diferença diferente de zero aponta fechamento faltando ou lançamento a
revisar.
*/


/*
### 8. (Pagamentos Fora do Dia do Atendimento)
*Objetivo Estratégico:* Identificar atendimentos que só foram pagos em um
dia posterior ao atendimento, ou seja, contas que ficaram em aberto.
- *Consulta SQL Sugerida:*
*/
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
/*
- *Impacto:* Mostra se o salão está deixando clientes saírem sem pagar e
quanto tempo leva para receber. Casos repetidos com a mesma cliente pedem
uma política de pagamento no ato.
*/
