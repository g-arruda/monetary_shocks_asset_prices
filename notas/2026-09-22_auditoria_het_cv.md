# Auditoria do estimador `svars` e o tamanho da atenuação mensal

> **CURRENT — 2026-09-22.** Rodada de auditoria e de travas. Nada foi reestimado
> na produção; nenhum número publicado muda.
> - `fit_het_cv()` foi conferido contra o artigo e **validado contra o próprio
>   `svars::id.cv()`** num caso em que o caminho público funciona: `Λ`, a tabela
>   `Qr` e `BB'` idênticos. Entra `script/validation/validate_het_cv.R` (7ª trava).
> - `qr_without_kurtosis()` passa a carregar a fórmula de curtose **do pacote**
>   (convenção `TB`), não a dos contadores; muda a 3ª casa de κ e o fator de
>   curtose, nada mais.
> - Novo `het_rigobon/03_atenuacao.R`: põe a diluição temporal prevista ao lado
>   da razão mensal observada. **Não atribui a queda da condição a nenhuma das
>   duas diferenças.**
> - Duas declarações que faltavam: os testes conjuntos da linha fatorial e a
>   distinção entre o estimador do `svars` e o IV de GRG.

## O que foi auditado, e contra o quê

`R/identification/het_tests.R` (`fit_het_cv()`, `regime_indicator()`,
`rigobon_rank_stat()`, `qr_without_kurtosis()`), `script/het_conditions.R` e as
três vertentes de `het_rigobon/`, contra Rigobon (2003), a Tabela 5 de
Gonçalves-Rodrigues-Genta (2025) e o fonte do `svars` 1.3.12 (R e C++).

## O que confere

- **O encanamento é fiel.** `TB = Tob − n_C + 1` entra no C++ só como peso e
  denominador — `(TB − 1) = n_NC` e `Tob − TB + 1 = n_C` —, e `Regime1/2`
  (0-based) tratam o regime intercalado linha a linha; o caminho público do
  indicador 0/1 do `id.cv()` está quebrado de fato (`u[SB, ]` indexa por
  posição). O `cv_ident_test()` é o teste que o `id.cv()` reporta com dois
  regimes, e a correção de curtose e a fórmula do `Qr` conferem.
- **Medição nova (H1-H3 da trava).** Num caso em que o caminho público do
  `id.cv()` funciona — quebra contígua em 2020-03, dados padronizados, `p=4` —
  `fit_het_cv()` reproduz `Λ` (`max |dΛ| = 0`), a tabela `Qr` (`max |dQr| = 0`) e
  `BB'` (`max rel = 0`). Nas unidades cruas o `id.cv()` colapsa a `Λ = I`
  (`max |Λ − I| = 0`): é o condicionamento que obriga a padronização interna,
  agora fixado. E `Qr_nk / fator = Qr` a `8,9e-15`, a identidade que prova que o
  diagnóstico carrega a curtose do pacote.
- **O sinal diário é o de GRG.** Pelo estimador deles (`01_daily_grg.R`,
  diferença de covariâncias = IV): câmbio −3,08% no vértice de 3 meses e CDS
  −11,96 p.b. por 100 p.b. — mesmos sinais e dentro do IC dos −5,10% e −3/−5/−11
  p.b. da Tabela 5. Pelo `fit_het_cv()` a célula diária identificada dá
  −1,53% e −4,16 p.b. por 50 p.b., também o sinal deles.
- **O DFM é a célula de produção** (raiz 0,9836766921623673) e o `rawimp` local
  reproduz o ponto do proxy com desvio 0; o smoke test da especificação de
  produção saiu bit-idêntico.

## O que mudou

**1. Curtose do pacote.** `qr_without_kurtosis()` usava `n_NC` e `n_NC − 4` onde
o `cv_ident_test()` usa `TB = n_NC + 1` e `TB − 4`. Reproduzida a convenção do
pacote, que é a que a identidade acima mede: na célula diária de 3 meses κ passa
de 12,6735/2,2525 para **12,6435/2,2949** e o fator de 4,8459 para **4,8773**;
o `Qr` corrigido (11,434) e o sem correção (55,768, que não depende de κ) não se
movem. A §5.1 escreve "divide a estatística por 4,9" e continua correta.

**2. `output/het/*` regenerado.** Só `kappa_NC`, `kappa_C` e `fator_curtose`
mudaram; `Qr`, `p`, `λ`, `det` e contagens são os mesmos.

**3. Atenuação mensal** (`het_rigobon/03_atenuacao.R`, quarentena). Com
`n = 20,64` dias úteis por mês, a diluição de pura frequência preveria
`1 + (r_d − 1)/n`:

| Série | razão Qua→Qui | previsto | razão mensal | excesso |
|---|---|---|---|---|
| DI 3 meses | 5,545 | 1,220 | 1,381 | 0,161 |
| DI 6 meses | 2,891 | 1,092 | 2,068 | 0,977 |
| DI 12 meses | 2,650 | 1,080 | 2,686 | 1,606 |
| CDS 5 anos | 0,928 | 0,997 | 2,274 | 1,278 |
| Câmbio BRL/USD | 1,026 | 1,001 | 1,485 | 0,484 |

O mesmo estimador sobre a variação mensal das três séries (p=1) dá `Qr` 1,336
(p 0,513), contra 11,434 (p 0,0033) no diário e 0,025 (p 0,988) no VAR mensal em
nível. **A leitura é aritmética:** a diluição sozinha preveria razões mensais
próximas de 1; o observado excede em todas, e no CDS a direção troca (diária
abaixo de 1, mensal acima de 2) — meses de Copom são meses voláteis em todas as
séries. O excesso mistura contaminação de calendário, dinâmica intra-mês e a
construção da série. **Nada no paper ou no registro pode atribuir a queda da
condição a uma das duas diferenças** (decisão de 2026-09-22, mantida).

## Declarações que passam a valer

- **Linha fatorial.** O `Qr` de `λ₁ = λ₂` não rejeita (p 0,0761) e é ele que
  decide a coluna líder; mas os conjuntos `λ₁=…=λ₄` (p 0,0208) e `λ₁=…=λ₅`
  (p 0,0127) **rejeitam a 5%** — há rotação de covariância no sistema, só não
  entre os dois maiores. A tabela completa está em `output/het/het_qr_tests.csv`;
  a §5.1 reporta o par, que é o teste da identificação da coluna.
- **`svars` não é o IV de GRG.** A réplica da Tabela 5 é o `01_daily_grg.R`
  (diferença de covariâncias, equivalente à forma IV deles). O `fit_het_cv()`
  estima o sistema multivariado de Rigobon (2003) com dois regimes e sem choque
  comum; o ponto diário não é uma segunda réplica da Tabela 5, ainda que os
  sinais coincidam. Sob choque comum heterocedástico (`K ≥ 1`), a Proposição 2
  de Rigobon exigiria mais regimes — com `N = 3` e `K = 1`, `S ≥ 4`, e não 2.
- **Ressalvas menores.** O determinante normalizado de eq. (6) é reportado como
  descritivo — Rigobon prefere a estatística (7) em amostra pequena, e a decisão
  é o `Qr`. E o `var_mp` do CSV é o rótulo da posição da coluna, não a
  identidade do choque; no mensal de 3 meses ele sai `cds_5y` sem que isso diga
  nada sobre qual choque é o monetário.

## Guardas

- As **7 travas** de `script/validation/` passam, código de saída 0, incluindo a
  nova; o smoke test da produção saiu bit-idêntico aos cinco valores de
  `CLAUDE.md`; `fit_het_cv()` e `qr_without_kurtosis()` não são importados por
  nenhum script de produção — só por `het_conditions.R` e `het_rigobon/`.
- A trava nova falharia antes do ajuste de κ: `55,768/4,8459 = 11,508 ≠ 11,434`.

## Arquivos

| arquivo | o que mudou |
|---|---|
| `R/identification/het_tests.R` | `qr_without_kurtosis()` com a convenção `TB` do pacote; docstring e comentário de regra |
| `script/validation/validate_het_cv.R` | novo: H1-H3 contra o `id.cv()` (Λ, `Qr`, `BB'`, colapso cru, identidade `Qr_nk/fator`) |
| `het_rigobon/03_atenuacao.R`, `output/03_atenuacao.{csv,md}` | novo: diluição prevista vs observada, sem atribuição |
| `output/het/het_conditions.{csv,md}`, `daily_changes.csv` | regenerados; só κ e fator de curtose mudam |
| `script/README.md` | 6→7 travas, entrada da nova |
| `het_rigobon/README.md` | `03_atenuacao.R` na tabela e no roteiro; a nota de não atribuição |

A rota het segue **abandonada** para o artigo (2026-08-17).
