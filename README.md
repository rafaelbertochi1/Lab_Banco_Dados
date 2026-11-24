# Laboratório de Banco de Dados · Grupo 5

Sistema de Gestão de Salão (Cachearia): banco Oracle com esquemas de aplicação (APP), auditoria (APP_AUDIT) e BI (DW).

Integrantes: Arthur Cavalcante e Silva, Gabriela Silveira Lima, João Vitor Dornelas Correa e Rafael Bertochi Figueiredo.

## Ordem de execução dos scripts

| Script | Conectado como | O que faz |
|---|---|---|
| `01_usuarios.sql` | SYS | Cria os usuários APP e APP_AUDIT |
| `02_app.sql` | APP | Tabelas, chaves, tabelas de histórico `H_*` e triggers |
| `03_app_audit.sql` | APP_AUDIT | Tabela AUDITORIA, procedure e triggers de auditoria |
| `04_dados.sql` | APP | Carga dos três períodos |
| `05_historico.sql` | APP | Move os atendimentos até jul/2026 para o histórico |
| `06_dw.sql` | SYS | Cria o usuário DW (leitura no APP) |
| `07_stage_faturamento_mensal.sql` | DW | Stage do João |
| `08_stage_forma_pagamento.sql` | DW | Stage da Gabriela |
| `09_stage_frequencia_cliente.sql` | DW | Stage do Arthur |
| `10_stage_horario_pico.sql` | DW | Stage do Rafael |

## Pastas

- `entrega4/`: prints da entrega 4 (4A usuário DW, 4B views dinâmicas, 4C views materializadas, 4D consultas).
- `dashboards/`: dashboard das stages (`dashboard.html`), prints e o script que gera tudo a partir de `dados/*.csv`.
- `documentacao/`: documento do projeto (`Documento_Projeto_Grupo5_Entrega4.pdf`), gerado a partir de `documento_projeto.html` com `python gerar_documento.py`.
