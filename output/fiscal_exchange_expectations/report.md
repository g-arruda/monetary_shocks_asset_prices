# Painel experimental de 115 séries

> **EXPERIMENTAL — 2026-09-01.** A produção de 111 séries, o manuscrito e os artefatos canônicos permanecem inalterados.

## Desenho e auditoria

O exercício compara `baseline_111`, `exchange_112`, `expectations_114` e `exchange_expectations_115`, sempre com `(r,q,p)=(5,5,4)`, `z_jk_bs_purif`, choque de +50 pb em `yield_6m` e horizonte 0--48. Somente o painel final recebeu 800 réplicas wild bootstrap (semente 123).

A linha literal "Ajuste cambial" cobre 153 meses em R$ milhões e coincide com a soma das duas sublinhas publicadas; a diferença máxima é 0.000e+00. A linha externa "outros ajustes" não entra no painel nem na interpretação.
A cascata sazonal classificou o ajuste cambial como `nao_sazonal`. As três expectativas são bit-idênticas à vintage auditada no experimento de 114 séries.

## Seleção, força e estabilidade

No painel 115, o Bai--Ng IC2 BLL seleciona **r=4** na amostra cheia e **r=2** no pré-COVID. A estimação comparativa permanece fixada em `r=5`.
O Amengual--Watson, condicionado a `r=5` e `p=4`, seleciona **q=2** na amostra cheia e **q=2** no pré-COVID; o resultado é reportado separadamente e não altera o `q=5` fixo.
Amostra cheia: **xi_mp=5.888198**, **F_rob,mp=11.936511**, raiz máxima **0.970092** e estabilidade `TRUE`.
Pré-COVID: **xi_mp=6.747499**, **F_rob,mp=9.421890**, raiz máxima **0.988398** e estabilidade `TRUE`.

| painel | amostra | xi_mp | var. xi | F_rob,mp | var. F | raiz | estável |
|---|---|---:|---:|---:|---:|---:|:---:|
| `baseline_111` | full | 5.240158 | +0.00% | 10.060922 | +0.00% | 0.968126 | sim |
| `baseline_111` | pre_covid | 7.478324 | +0.00% | 11.874945 | +0.00% | 0.992483 | sim |
| `exchange_112` | full | 5.355034 | +2.19% | 10.295045 | +2.33% | 0.968744 | sim |
| `exchange_112` | pre_covid | 5.613978 | -24.93% | 7.110756 | -40.12% | 0.987675 | sim |
| `expectations_114` | full | 5.805646 | +10.79% | 11.761132 | +16.90% | 0.969027 | sim |
| `expectations_114` | pre_covid | 8.124920 | +8.65% | 13.679068 | +15.19% | 0.991812 | sim |
| `exchange_expectations_115` | full | 5.888198 | +12.37% | 11.936511 | +18.64% | 0.970092 | sim |
| `exchange_expectations_115` | pre_covid | 6.747499 | -9.77% | 9.421890 | -20.66% | 0.988398 | sim |

## Gate e respostas das séries adicionadas

O gate concluiu 800 réplicas, com 0 falhas, bandas finitas e ordenadas e `yield_6m(h=0)=0.005000`.

| série | h | ponto | banda 68% | banda 90% | exclui zero a 90% |
|---|---:|---:|---:|---:|:---:|
| `dlsp_exchange_adjustment` | 0 | -11816.780409 | [-26635.949276; -3414.177091] | [-36503.002538; 4904.381915] | não |
| `dlsp_exchange_adjustment` | 6 | 3553.311050 | [-6148.432064; 14666.461842] | [-13561.875158; 22911.559885] | não |
| `dlsp_exchange_adjustment` | 12 | 8445.706946 | [-1498.470430; 17142.896580] | [-8252.411675; 25408.811217] | não |
| `dlsp_exchange_adjustment` | 24 | 745.823824 | [-4614.103158; 15040.391917] | [-12441.218665; 22974.040383] | não |
| `dlsp_exchange_adjustment` | 36 | -7525.426175 | [-10006.421681; 6950.765131] | [-16766.477208; 15207.552209] | não |
| `dlsp_exchange_adjustment` | 48 | -7791.047411 | [-10162.426687; 2814.641982] | [-14941.498063; 9231.406720] | não |
| `expect_focus_fiscal_dlsp_ny` | 0 | -0.208366 | [-0.408990; -0.041440] | [-0.530596; 0.071891] | não |
| `expect_focus_fiscal_dlsp_ny` | 6 | -0.722364 | [-1.085254; -0.236602] | [-1.300853; -0.013823] | sim |
| `expect_focus_fiscal_dlsp_ny` | 12 | -0.650820 | [-1.173099; -0.311501] | [-1.470176; -0.058052] | sim |
| `expect_focus_fiscal_dlsp_ny` | 24 | -0.028737 | [-0.582136; 0.165746] | [-0.888437; 0.404367] | não |
| `expect_focus_fiscal_dlsp_ny` | 36 | 0.356751 | [-0.156773; 0.523816] | [-0.387194; 0.805430] | não |
| `expect_focus_fiscal_dlsp_ny` | 48 | 0.355132 | [-0.064446; 0.484031] | [-0.230527; 0.710209] | não |
| `expect_focus_fiscal_primary_balance_ny` | 0 | -0.052464 | [-0.098285; 0.010552] | [-0.139985; 0.054168] | não |
| `expect_focus_fiscal_primary_balance_ny` | 6 | 0.026982 | [-0.107850; 0.082750] | [-0.181346; 0.151711] | não |
| `expect_focus_fiscal_primary_balance_ny` | 12 | 0.068648 | [-0.061798; 0.124273] | [-0.132329; 0.188269] | não |
| `expect_focus_fiscal_primary_balance_ny` | 24 | 0.057813 | [-0.034492; 0.101412] | [-0.091277; 0.165667] | não |
| `expect_focus_fiscal_primary_balance_ny` | 36 | 0.008648 | [-0.057209; 0.066995] | [-0.103136; 0.117749] | não |
| `expect_focus_fiscal_primary_balance_ny` | 48 | -0.022035 | [-0.065824; 0.047823] | [-0.120839; 0.087721] | não |
| `expect_focus_fiscal_nominal_balance_ny` | 0 | -0.167926 | [-0.245939; -0.081163] | [-0.300096; -0.027089] | sim |
| `expect_focus_fiscal_nominal_balance_ny` | 6 | -0.191383 | [-0.383885; -0.110536] | [-0.470164; -0.002252] | sim |
| `expect_focus_fiscal_nominal_balance_ny` | 12 | -0.084511 | [-0.329639; -0.034039] | [-0.466299; 0.037929] | não |
| `expect_focus_fiscal_nominal_balance_ny` | 24 | 0.107974 | [-0.132152; 0.138932] | [-0.270281; 0.223215] | não |
| `expect_focus_fiscal_nominal_balance_ny` | 36 | 0.140575 | [-0.027062; 0.197371] | [-0.141509; 0.314755] | não |
| `expect_focus_fiscal_nominal_balance_ny` | 48 | 0.077635 | [-0.045462; 0.154801] | [-0.143991; 0.273911] | não |

Uma resposta negativa do ajuste cambial junto à queda da DLSP é compatível com o canal mecânico cambial, mas não constitui decomposição completa da variação da DLSP. Apenas exclusão de zero pela banda de 90% é descrita como significativa; a banda de 68% fornece evidência sugestiva.

As superfícies completas de seleção, a comparação dos quatro painéis, as IRFs e os gates estão nos CSVs desta pasta.
