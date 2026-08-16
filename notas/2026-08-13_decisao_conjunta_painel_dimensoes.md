# Decisão conjunta de painel e dimensões `(r,q)`

> **SUPERSEDED em 2026-08-13.** A recomendação de 123 séries em `(4,3)` foi
> substituída pela migração deliberada para o painel de 111 séries
> `drop_setor_externo__eua__credito__imoveis` em `(5,5)`. A grade, os
> contrastes e os quatro bootstraps desta nota permanecem como proveniência
> histórica. Decisão corrente em
> [`2026-08-13_migracao_producao_painel_111_r5q5`](2026-08-13_migracao_producao_painel_111_r5q5.md).

> **CURRENT, decisão metodológica, 2026-08-13.** A amostra completa escolhe;
> a pré-COVID apenas qualifica confiança. A rodada usa `p=6`,
> `z_jk_bs_purif`, choque de +50 pb em `yield_6m`, 800 réplicas e semente 123.
> Código e artefatos:
> [`diagnostics/rq_block_dimension_audit/`](../diagnostics/rq_block_dimension_audit/).
> **A produção e o paper ainda não foram migrados:** continuam em 106 séries e
> `(7,6)` até uma rodada posterior deliberada.

## Veredito

O painel metodologicamente recomendado é o
`conjunto_completo_sem_duplicatas`, com **123 séries**, e a dimensão é
**`(r,q)=(4,3)`**. Isso elimina `juros_cdi` e `asset_mlcx`, mantém os seis
blocos candidatos e preserva `yield_6m`. Nenhum bloco atingiu a regra para
remoção. O painel de 106 séries deixa, portanto, de ser o universo decisório,
embora siga sendo a especificação técnica de produção até a migração.

No painel final, o mínimo BLL/AW full é `(4,2)`. Essa célula não passa o gate
de relevância; a primeira admissível no ranking fixado é `(4,3)`, a distância
Manhattan 1, com `xi_mp=5,0511`, `F_rob,mp=8,4230`, raiz máxima 0,9626 e 23 de
28 sinais hard corretos em `h=0,...,6`. Na pré-COVID, reestimada apenas depois
da escolha full, a mesma célula tem `xi_mp=10,7846`, `F_rob,mp=13,1335`, raiz
0,9927 e permanece estável. O RMSE normalizado médio das cinco IRFs entre as
janelas é 1,5176; isso reduz a confiança temporal, mas não redefine a escolha.

## Cobertura e ranking por painel

A grade full contém exatamente **2.304 células**: 64 painéis vezes os 36 pares
`r=1,...,8`, `q=1,...,r`. As 1.152 células que coincidem com a grade anterior
reproduzem `xi_mp` a `1e-10`. Depois dos gates de finitude, estabilidade e
`xi_mp>3,84`, há uma decisão única em cada painel. As 64 escolhas completas,
com BLL/AW, raiz, sinais, força, diagnóstico pré-COVID e estabilidade, estão em
[`panel_dimension_decisions.csv`](../diagnostics/rq_block_dimension_audit/output/panel_dimension_decisions.csv);
o ranking das 2.304 células está em
[`panel_dimension_ranking.csv`](../diagnostics/rq_block_dimension_audit/output/panel_dimension_ranking.csv).

| dimensão escolhida | painéis |
|---|---:|
| `(4,3)` | 26 |
| `(3,3)` | 8 |
| `(4,1)` | 8 |
| `(4,2)` | 6 |
| `(5,1)` | 6 |
| `(5,2)` | 5 |
| `(3,2)` | 4 |
| `(5,4)` | 1 |

As 64 escolhas foram então reestimadas na pré-COVID: 51 mantêm
`xi_mp>3,84` e 55 têm raiz menor que um. Esses números são diagnóstico de
confiança, não uma segunda seleção.

## Contrastes dos seis blocos

Cada linha resume 32 pares fatoriais que diferem apenas pela presença do
bloco. Uma vitória exige melhorar ao menos quatro dos seis critérios e piorar
no máximo um. A remoção exigiria pelo menos 24 vitórias da exclusão e no máximo
oito da inclusão.

| bloco | vitórias exclusão | vitórias inclusão | sem vencedor | decisão |
|---|---:|---:|---:|---|
| fiscal | 3 | 1 | 28 | manter |
| setor externo | 0 | 3 | 29 | manter |
| expectativas | 2 | 4 | 26 | manter |
| EUA | 8 | 2 | 22 | manter |
| crédito | 2 | 0 | 30 | manter |
| imóveis | 5 | 0 | 27 | manter |

O bloco EUA é o mais próximo do limiar; inverter sua decisão produz o painel
alternativo `drop_eua`, com 118 séries e dimensão escolhida `(4,3)`. A tabela
com os 192 contrastes e os seis comparadores célula a célula está em
[`block_contrasts.csv`](../diagnostics/rq_block_dimension_audit/output/block_contrasts.csv).

## Bootstrap finalista

Foram estimadas quatro células distintas: painel final em `(4,3)`, sua segunda
dimensão `(3,2)`, `(7,6)` no painel final e `drop_eua (4,3)`. Todas concluíram
800 réplicas com zero falhas, raiz full menor que um, bandas ordenadas e
normalização exata de +50 pb. Nenhuma produziu banda de 90% inteiramente no
sentido contrário ao previsto para as três taxas e o Ibovespa em
`h=0,...,6`; por isso não houve fallback da dimensão principal.

| painel e dimensão | `xi_mp` full | `F_rob,mp` | raiz full | falhas |
|---|---:|---:|---:|---:|
| final `(4,3)` | 5,051 | 8,423 | 0,9626 | 0 |
| final `(3,2)` | 4,257 | 6,642 | 0,9764 | 0 |
| final `(7,6)` | 4,741 | 4,632 | 0,9732 | 0 |
| `drop_eua (4,3)` | 5,281 | 9,011 | 0,9694 | 0 |

Na célula principal, o impacto de `yield_2y` é 0,00821, com banda de 90%
[0,00659; 0,01149], e o de `yield_5y` é 0,00870 [0,00653; 0,01385]. O
Ibovespa cai 0,476 ponto percentual, mas a banda de 90% inclui zero
[-8,48; 2,10]. O câmbio sobe 0,219 [0,135; 0,335] nas unidades do painel e
permanece canal `soft`, sem penalizar o ranking de sinais.

## Limites e próxima ação

Esta rodada decide composição e dimensão; não valida uniformemente as bandas
sob instrumento fraco e não corrige o `cumsum` acionário. A grade também
expôs um defeito do helper de fatores dinâmicos para `q=1<r`: `diag(x)` trata
o escalar como dimensão. A auditoria usa uma compatibilidade local com matriz
1 por 1, sem alterar `R/modeling/factor_estimation.R`.

A próxima ação é uma migração deliberada do pipeline para as 123 séries e
`(4,3)`, com regeneração dos artefatos de produção, smoke test das cinco
variáveis, sincronização das notas de resultado e só então atualização do
paper. Até lá, os números desta nota são decisão experimental auditada, não
resultados canônicos do artigo.
