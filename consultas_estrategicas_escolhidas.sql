/* Consultas Estratégicas - Já escolhidas
   Sistema de Gestão de Salão (Cachearia)
   Períodos da base: 1 = jan a ago/2025 | 2 = set/2025 a fev/2026 | 3 = mar a ago/2026 */


/*
### 1. (Horário de Pico)
*Objetivo Estratégico:* Descobrir em quais horários do dia o salão mais
atende e mais fatura, para organizar a agenda e a escala nos horários de
maior movimento.
Observação: a hora usada é a do fechamento da conta (data_pagamento), não a
da chegada da cliente.
- *Consulta SQL Sugerida:*
*/
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
/*
- *Impacto:* Mostra os horários que concentram o movimento, para reforçar a
equipe e evitar filas nesses momentos, e os horários vazios, que podem
receber promoções ou agendamentos de serviços mais longos.
*/


/*
### 2. (Comparação entre Períodos)
*Objetivo Estratégico:* Comparar os três períodos da base lado a lado
(atendimentos, clientes, faturamento e ticket médio) para saber se o salão
está crescendo ou caindo. A média mensal deixa a comparação justa, já que o
primeiro período tem 8 meses e os outros dois têm 6.
Observação: precisa da base com todos os períodos carregados.
- *Consulta SQL Sugerida:*
*/
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
ORDER BY Periodo;
/*
- *Impacto:* Mostra a tendência do negócio entre os períodos. Uma queda na
média mensal ou no número de clientes indica onde agir primeiro, e as
outras consultas (frequência, retenção) ajudam a explicar o motivo.
*/
