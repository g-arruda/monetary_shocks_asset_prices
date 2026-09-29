# O VAR mensal do Anexo B sob a escala COVID de Lenza-Primiceri

> **CURRENT — 2026-09-27, branch `feature/unidades-nativas`.** Rodada de diagnóstico. A produção
> não muda: o smoke test do `CLAUDE.md` saiu bit-idêntico, e o θ̂ do VAR fatorial foi reproduzido
> byte a byte nos cinco `p`. Números de `output/het/het_conditions.csv`,
> `het_variance_ratios.csv`, `het_var_theta.csv` e `het_var_theta_multistart.csv`, escritos por
> `script/het_conditions.R`. Fecha o item do Tema D aberto em 2026-09-24.

## 1. O que o item pedia

Até hoje o Sistema 2 de `script/het_conditions.R` (DI, câmbio BRL/USD e CDS de 5 anos no painel
mensal, `p = 4`, constante e tendência) era estimado por MQO. O `Qr` rodava pelo GLS do `svars`
sobre o VAR, com `fit_het_cv(y, p = 4, "both")`. A linha fatorial, por outro lado, lê as inovações
padronizadas `u_t/s_t` do DFM de produção. Logo, as duas linhas mensais do Anexo B diferiam também
no tratamento da COVID. O desenho, decidido pelo autor em 2026-09-24:
- cada VAR tem θ próprio, um por vértice (3, 6 e 12 meses), estimado por verossimilhança
  concentrada (B5) com `t*` = 2020-03, s̄ ≥ 1 e ρ ∈ [0, 1], e não usa o θ̂ do VAR fatorial;
- o `Qr` roda sobre `u_t/s_t` pelo caminho da linha fatorial (`p = 1`, `inert_lag = TRUE`);
- a versão sem tratamento passa pelo mesmo caminho com `s = 1`, para que a diferença seja só a
  escala;
- as duas versões aparecem lado a lado no paper (revertido pelo autor no mesmo dia, §6);
- a linha diária e o benchmark `ibc5_fx_cds_level_trend_p4` ficam sem escala.

## 2. Código

- `estimate_var_wls(data, p, type, s = 1)` ganhou `type`, obrigatório, com `"const"` ou `"both"`
  como em `vars::VAR()`. Com `"both"`, a tendência `p + 1, …, T` entra depois da constante e também
  é dividida por `s_t`, como em (B2). O divisor de `covariance_matrix` passou a `n_eff − ncol(RHS)`,
  o mesmo inteiro de antes com `"const"`. `estimate_covid_theta()` ganhou o mesmo `type`, e todas
  as chamadas do VAR fatorial passam `type = "const"`: `estimate_dfm()`,
  `covid_volatility_theta.R` e os dois validadores.
- As três guardas de θ̂, que estavam inline em `script/covid_volatility_theta.R`, viraram
  `verify_covid_theta()` em `R/modeling/factor_estimation.R`: a condição de primeira ordem em t* e
  t*+1, o perfil em ρ e o multi-start de 750 inícios. O script do θ̂ fatorial e o het passam a
  chamá-la, e o código inline saiu. **Prova de fidelidade:** com o script do θ̂ fatorial rodado de
  novo, `covid_volatility_theta.csv`, `covid_volatility_multistart.csv` e os oito arquivos de
  `theta_by_p/` saíram byte-idênticos.
- `validate_covid_volatility.R` ganhou o S11. `type = "both"` reproduz `lm.wfit` com a tendência
  ponderada, e em `s = 1` os resíduos de `vars::VAR(type = "both")`, ambos a 1e-10. Os sete
  validadores passam.
- No script het, θ é estimado sobre `y` dividido pelo desvio dos resíduos MQO, coluna a coluna.
  θ̂ é invariante a essa reescala, e a divisão só impede que a regra de início de LP (média entre
  séries das variações absolutas) leia o CDS em pontos-base sozinho. É o mesmo condicionamento que
  `fit_het_cv()` já aplica. A WLS final roda nos dados em unidade original.
- O sistema sem tratamento manteve o nome `"Tres observaveis de GRG (VAR)"`, porque
  `het_rigobon/02_irf.R:224` o usa como chave. O tratado é `"Tres observaveis de GRG (VAR, escala
  COVID)"`, com Holm próprio.

## 3. θ̂ por vértice

| vértice | s̄0 | s̄1 | s̄2 | ρ | meia-vida de s_t − 1 | LR contra s = 1 | meses equivalentes subponderados |
|---|---|---|---|---|---|---|---|
| 3 meses | 4,481 | 1,921 | 2,271 | 0,940 | 11,3 | 60,9 | 23,9 |
| 6 meses | 4,857 | 1,342 | 2,351 | 0,943 | 11,8 | 68,5 | 25,3 |
| 12 meses | 4,839 | 1,608 | 2,280 | 0,950 | 13,5 | 65,8 | 27,4 |
| VAR fatorial (produção) | 6,611 | 12,468 | 1,760 | 0,944 | 12,0 | 223,9 | 19,1 |

- Nos três VARs o pico é março de 2020 (variância ≈ 20 a 24 vezes), e abril recebe pouca escala
  (≈ 1,8 a 3,7 vezes). No VAR fatorial é o contrário: abril, com ≈ 155 vezes, domina março, com ≈ 44
  vezes. Março de 2020 é mês C (Copom em 18/03), e abril é NC.
- **Aqui (B5) tem um único máximo.** Nos três vértices, os 750 inícios terminam em θ̂ (distância
  relativa máxima 4,7e-4) e nenhum passa dele (folga máxima 5e-12). No VAR fatorial havia três
  máximos locais (`2026-09-24_otimo_global_theta`). Sete, sete e três inícios param com o código 52
  do L-BFGS-B (busca linear anormal), já em cima de θ̂.
- Todos os componentes ficam abaixo de 40/3, e a grade de inícios, a mesma do VAR fatorial, cobre a
  caixa. O escalar difere de um em 70 dos 162 meses de resíduo, e em 2025-12 ainda vale 1,02 a 1,04.

## 4. Resultado

`Qr` de `λ₁ = λ₂`, com e sem a correção de curtose, 107 meses C e 54 NC (161):

| sistema | vértice | `a` | λ̂₁ (EP) | λ̂₂ (EP) | `Qr` | p | `Qr` s/ corr. | p | det_ratio |
|---|---|---|---|---|---|---|---|---|---|
| VAR, s = 1 | 3m | 2,18 | 2,33 (0,55) | 2,05 (0,48) | 0,11 | 0,948 | 0,15 | 0,927 | 0,019 |
| VAR, s = 1 | 6m | 2,66 | 2,69 (0,64) | 2,19 (0,52) | 0,25 | 0,881 | 0,39 | 0,823 | 0,023 |
| VAR, s = 1 | 12m | 2,28 | 2,38 (0,56) | 2,15 (0,51) | 0,06 | 0,970 | 0,09 | 0,955 | 0,012 |
| VAR, escala LP | 3m | 1,99 | 2,13 (0,50) | 1,92 (0,45) | 0,07 | 0,965 | 0,10 | 0,953 | 0,011 |
| VAR, escala LP | 6m | 2,32 | 2,34 (0,55) | 1,83 (0,43) | 0,39 | 0,824 | 0,54 | 0,764 | 0,013 |
| VAR, escala LP | 12m | 2,10 | 2,13 (0,50) | 1,92 (0,45) | 0,07 | 0,966 | 0,10 | 0,953 | 0,007 |

Razão de variância C/NC (DI, BRL/USD, CDS):

| vértice | s = 1 | escala LP |
|---|---|---|
| 3m | 2,18 / 1,64 / 2,06 | 1,99 / 1,27 / 1,92 |
| 6m | 2,66 / 1,65 / 2,19 | 2,32 / 1,24 / 1,89 |
| 12m | 2,28 / 1,56 / 2,16 | 2,10 / 1,21 / 1,91 |

**Veredito: o tratamento não muda o diagnóstico.** O VAR tratado não rejeita `λ₁ = λ₂` em nenhum
vértice, e o `p` mínimo é 0,824 (6 meses). Nenhuma hipótese da sequência rejeita a 10%. O
tratamento aproxima da rejeição o par `λ₂ = λ₃`, cujo `p` cai de 0,448 / 0,495 / 0,522 com `s = 1`
para 0,104 / 0,217 / 0,237, e não o par `λ₁ = λ₂`, que decide a coluna. A escala tira variância
dos meses C, porque março de
2020 é C. As três razões caem, e a do câmbio cai mais (de ≈ 1,6 para ≈ 1,2). As três seguem acima
de 1, e λ̂₁ e λ̂₂ continuam a menos de um erro-padrão um do outro. O determinante normalizado fica
em 0,007 a 0,013, ou seja, as covariâncias dos dois regimes continuam quase proporcionais, que é o
modo de falha nomeado por Rigobon.

A §3.3 (`sec:identificacao`, `paper_anpec.tex:240`) não muda. A frase "No painel mensal, em que as
variâncias das três séries sobem juntas, ela não vale em nenhum vértice" continua verdadeira nas
duas versões.

## 5. O deslocamento do caminho s = 1, declarado

A linha sem tratamento publicada até hoje vinha de outro caminho: GLS do `svars` sobre o VAR `p = 4`
com constante e tendência, com 162 meses (108 C / 54 NC). Pelo caminho comum ela passa a MQO, com os
resíduos testados como inovações e 161 meses (107 C / 54 NC):

| vértice | `a` | λ̂₁ | λ̂₂ | p (corr.) | det_ratio |
|---|---|---|---|---|---|
| 3m | 2,26 → 2,18 | 2,51 → 2,33 | 2,36 → 2,05 | 0,988 → 0,948 | −0,026 → 0,019 |
| 6m | 2,98 → 2,66 | 3,07 → 2,69 | 2,59 → 2,19 | 0,917 → 0,881 | 0,057 → 0,023 |
| 12m | 2,52 → 2,28 | 2,85 → 2,38 | 2,44 → 2,15 | 0,931 → 0,970 | 0,030 → 0,012 |

As razões do câmbio e do CDS também caem, de 1,85/1,86/1,74 para 1,64/1,65/1,56 e de 2,42/2,59/2,59
para 2,06/2,19/2,16. O veredito não muda com o caminho. O mês perdido é 2012-07, um mês C. A troca
do GLS por regime pelo MQO mexe nos coeficientes do VAR e, com eles, nas duas covariâncias. As
linhas diárias e a fatorial dos quatro CSVs saíram idênticas às versionadas, e o
`daily_changes.csv` também.

## 6. Paper

- A primeira versão pôs as duas lado a lado, com um bloco a mais em cada tabela. **O autor recusou
  no mesmo dia:** o VAR mensal do paper é só o tratado, com o tratamento dito na nota, sob o título
  de antes ("Mensal, VAR em nível").
- **No mesmo dia, as duas tabelas do Anexo B viraram uma**, por decisão do autor. `tab:het_variance`
  saiu, e suas três razões de variância (DI, BRL/USD, CDS) tomaram o lugar da coluna `a` de
  `tab:het_frequency`, que agora tem dez colunas e o título "Razão de variância e teste da condição
  de posto". O motivo: a §3.3 diz que no diário só a variância do DI sobe e que no mensal as três
  sobem juntas, e só as colunas do câmbio e do CDS sustentam isso. A linha fatorial fica sem razões.
  As notas se fundiram. A nota única diz as séries e a origem em `goncalves2025`, define a razão, os
  λ e o `Qr`, dá as contagens diárias e o Holm, e depois o painel mensal com 107/54, a explicação dos
  161 de 162 e o tratamento: o VAR recebe o tratamento da COVID do VAR dos fatores, a reescala da
  equação \ref{eq:5b} com θ estimado pela equação \ref{eq:5c} em cada vértice, e a série é o resíduo
  dividido por $s_t$. Em seguida vêm a linha fatorial ("nos mesmos 161 meses do VAR"), a frase da não
  decomposição e a janela. A §3.3 trocou "nas tabelas do Anexo B" por "na tabela do Anexo B", e o
  anexo seguinte passou a Tabela 4.
- A versão `s = 1` continua sendo escrita por `het_conditions.R` e fica nos CSVs e nesta nota (§4 e
  §5), fora do paper.
- O paper compila sem erro nem overfull.

## 7. O que fica

- O benchmark `ibc5_fx_cds_level_trend_p4` segue sem escala. O Sistema 2, que herdava dele janela,
  `p` e determinísticos, agora diverge dele na escala.
- `het_rigobon/02_irf.R` lê o veredito de `"Tres observaveis de GRG (VAR)"`, que agora vem do
  caminho s = 1. A pasta é quarentena e não foi rodada de novo.
