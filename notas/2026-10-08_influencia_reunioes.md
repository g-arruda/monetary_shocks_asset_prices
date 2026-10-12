# Influência das reuniões do Copom sobre a identificação

> **NÚMEROS SUPERADOS em 2026-10-12** por
> [`2026-10-12_msci_emergentes`](2026-10-12_msci_emergentes.md), seção 5. A série `msci` do painel
> passou da ação da MSCI Inc. ao índice MSCI de emergentes, e o passo rodou de novo sobre a base
> reestimada. As cinco e as dez reuniões mais influentes são as mesmas, e o desenho e a leitura desta
> nota seguem valendo. Sem as 5, ξ_mp vai a 3,54. Sem as 10, vai a 1,82, e o câmbio sem as 5 perde a
> significância a 90% em h5.

> **CURRENT — 2026-10-08.** Passo 3/5 do plano do orientador de 03-10
> (`email/email_professor_03-10_11h31.md`), no desenho do item 3 do e-mail de 08-10
> (`email/email_professor_08-10_15h15.md`). Branch `feature/focus-horizonte-fixo`, **não mergeada**,
> sobre a base do passo 0 (nota `2026-10-03_focus_horizonte_fixo`).
> - Produção da branch: `z_bs_purif`, `(r,q,p) = (5,5,4)`, escala COVID de Lenza-Primiceri com θ̂ do
>   painel a horizonte fixo, +50 p.b. em `yield_6m`, NW(0). A produção não muda: ponto e conjuntos de
>   80/90% saem `identical()` ao cache `output/irf/irf_coherence_cell.rds`.
> - Decisão do autor em 10-08, tomada antes de rodar: a exclusão de reuniões com movimentos extremos de
>   VIX, S&P 500 ou Brent fica para uma rodada própria, com a regra definida antes. Esta nota cobre só
>   a influência.
> - Script: `script/meeting_influence.R`. Saídas em `output/meeting_influence/`. Nada no `.tex` nem em
>   `paper/img/`.

## 1. Como a exclusão é feita

O e-mail pede que, se a implementação não corresponder ao desenho, o autor mande antes um resumo de
como os momentos e os testes AR são calculados. A implementação corresponde, e esta seção serve de
resumo.

- **O momento.** Γ = (1/T) Σ_t η_t z_t, com η_t = u_t/s_t as cinco inovações do VAR dos fatores
  divididas pela escala COVID e T = 162 (2012-07 a 2025-12). Sob a escala nada é centrado, como no Γ
  de MOSW (`SVARIV.m:128`). Com `q = r`, a resposta da série j em h é 0,005 · e_j'C_h Γ / d0'Γ, e só Γ
  depende do instrumento. O conjunto AR inverte o teste de MOSW sobre a covariância conjunta de vec(A)
  e Γ (`mosw_rform_cov()`, `ar_dfm_moments()`), e `ar_statistic()` dá o p-valor em zero.
- **Fixos.** Fatores, cargas, coeficientes do VAR, θ̂ e inovações são os da amostra completa. Os
  resíduos Bauer-Swanson das outras reuniões são os da regressão nas 102 reuniões, que não é refeita.
- **Excluir uma reunião.** O instrumento mensal é a soma dos resíduos BS das reuniões do mês, e é zero
  nos meses sem reunião. Excluir a reunião i é subtrair o resíduo dela da soma do seu mês. Nenhum mês
  sai: T continua 162 e os meses continuam na ordem do calendário, de modo que a variância HAC nunca
  junta meses não consecutivos. A produção usa NW(0), sem defasagem, mas o mesmo valeria para qualquer
  truncagem.
- **Duas reuniões no mesmo mês.** Não há nenhum caso na amostra (102 reuniões em 102 meses). O código
  subtrai só a reunião escolhida mesmo assim.
- **Centralização e residualização.** São as da produção. Na covariância de Γ e em ξ_mp, z é
  residualizado nos regressores do VAR dos fatores divididos por s_t (a correção `Shat` de
  `CovAhat_Sigmahat_Gamma.m`). F_rob é a regressão HC1 da inovação de `yield_6m` em z, com os mesmos
  regressores.
- **Ordem das reuniões.** O EP de cada componente na amostra completa é √(W2_kk/T). A influência da
  reunião i é max_k |Γ_k^(−i) − Γ_k| / EP_k, sobre os cinco componentes. É diagnóstico de influência,
  não teste de significância.
- ⚠ **Três reuniões não entram em Γ.** As de 2012-03-08, 2012-04-19 e 2012-05-31 caem antes da primeira
  inovação, 2012-07, porque `p = 4` consome os quatro primeiros meses. A influência delas é zero exato e
  elas ficam fora da ordem. A ordem cobre 99 reuniões.

Guardas do script:
- a produção sai igual ao cache, e os conjuntos de 95% de câmbio e CDS saem iguais aos do passo 1;
- as somas mensais dos resíduos reproduzem o instrumento;
- cada exclusão individual muda o instrumento em exatamente um mês;
- fora da janela, Γ, respostas e força ficam iguais;
- em cada uma das 105 células, o Wald de `diagnose_instrument_in_factor_space()` é igual ao ξ_mp dos
  conjuntos;
- nas exclusões conjuntas, o ponto do caminho AR é igual ao de `ident_ext_instr()`, e o p-valor abaixo
  de 1 − nível equivale à significância lida da topologia do conjunto.

## 2. A ordem das reuniões

**Nenhuma exclusão individual muda o sinal nem a força de forma relevante.** Nas 99 exclusões:
- câmbio em h0 de 0,126 a 0,175 R$/US$ (produção 0,146), em h1 de 0,156 a 0,225 (0,180), em h3 de
  0,146 a 0,216 (0,172);
- CDS em h0 de 28,9 a 42,0 p.b. (33,9), em h1 de 31,5 a 45,5 (37,1), em h3 de 29,1 a 40,9 (34,0);
- ξ_mp de 5,52 a 7,61 (6,80) e F_rob de 6,49 a 9,76 (8,28). Toda exclusão individual deixa ξ_mp acima
  de 3,84, nenhuma o leva a 10, e em 44 das 99 ele sobe.

As dez mais influentes (câmbio em R$/US$, CDS em p.b.; surpresa é o resíduo BS, em p.b.):

| ordem | reunião (quinta) | surpresa | influência | comp. | câmbio h0 | h1 | h3 | CDS h0 | h1 | h3 | ξ_mp | F_rob |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| — | produção | | | | 0,146 | 0,180 | 0,172 | 33,9 | 37,1 | 34,0 | 6,80 | 8,28 |
| 1 | 2018-05-17 | 21,8 | 0,644 | 1 | 0,141 | 0,156 | 0,146 | 28,9 | 31,5 | 29,1 | 5,93 | 7,10 |
| 2 | 2022-03-17 | −20,5 | 0,590 | 5 | 0,126 | 0,160 | 0,164 | 31,0 | 34,5 | 33,2 | 7,61 | 9,76 |
| 3 | 2021-10-28 | 33,3 | 0,568 | 2 | 0,175 | 0,223 | 0,204 | 41,2 | 44,9 | 38,6 | 6,15 | 6,81 |
| 4 | 2016-01-21 | −25,6 | 0,544 | 4 | 0,170 | 0,225 | 0,216 | 42,0 | 45,5 | 40,9 | 5,52 | 6,57 |
| 5 | 2013-04-18 | −33,3 | 0,544 | 3 | 0,151 | 0,181 | 0,173 | 33,6 | 36,5 | 33,7 | 6,09 | 7,26 |
| 6 | 2024-12-12 | 25,6 | 0,449 | 4 | 0,143 | 0,187 | 0,181 | 36,2 | 39,7 | 36,1 | 5,52 | 6,49 |
| 7 | 2021-03-18 | 29,0 | 0,345 | 1 | 0,128 | 0,157 | 0,154 | 31,3 | 34,2 | 32,0 | 5,98 | 7,47 |
| 8 | 2017-01-12 | −29,7 | 0,325 | 2 | 0,137 | 0,163 | 0,157 | 30,7 | 34,1 | 31,5 | 6,12 | 7,42 |
| 9 | 2023-08-03 | −18,5 | 0,272 | 3 | 0,147 | 0,183 | 0,179 | 34,8 | 37,8 | 35,2 | 7,19 | 9,06 |
| 10 | 2018-06-21 | −6,6 | 0,235 | 5 | 0,138 | 0,174 | 0,171 | 33,3 | 36,5 | 34,2 | 7,09 | 8,62 |

Cada linha traz o valor **sem** a reunião. As maiores mudanças de câmbio e CDS vêm de 2021-10-28
(+0,029 R$/US$ e +7,2 p.b. no impacto) e de 2016-01-21 (+0,024 e +8,0), cuja exclusão aumenta as duas
respostas, e de 2022-03-17 (−0,020) e 2018-05-17 (−5,1 p.b. no CDS), cuja exclusão as reduz. A ordem
acompanha em boa parte o tamanho da surpresa: nove das dez estão entre as 14 maiores em valor absoluto.
A exceção é 2018-06-21, 50ª em tamanho (−6,6 p.b.). Como ΔΓ = −e_i η_t / T, uma surpresa pequena num
mês de inovação grande também pesa. O componente que dá o máximo varia: os cinco aparecem entre as dez.

`ranking.csv` traz as 102 reuniões, com as cinco razões |ΔΓ_k|/EP_k, as respostas, as mudanças e a
força.

## 3. Exclusão conjunta das 5 e das 10 mais influentes

**Força.** d0'Γ é o momento de normalização e Σz² a soma de quadrados do instrumento nos 162 meses,
ambos relativos à produção. ξ_mp = T (d0'Γ)² / (d0'W2 d0).

| célula | ξ_mp | F_rob | d0'Γ | Σz² | conjunto de 90% limitado | de 95% |
|---|---|---|---|---|---|---|
| produção | 6,80 | 8,28 | 1 | 1 | sim | sim |
| sem as 5 | 3,59 | 3,78 | 0,46 | 0,74 | sim | não |
| sem as 10 | 2,01 | 1,86 | 0,19 | 0,55 | não | não |

As dez reuniões são 10% das 99 e 45% da soma de quadrados do instrumento, e carregam 81% do momento
de normalização. As cinco são 26% da soma de quadrados e 54% do momento. Sem as cinco, ξ_mp fica
abaixo de 3,84: os conjuntos de 95% deixam de ser limitados. Sem as dez, fica abaixo de 2,71, e os de
90% também deixam.

**Câmbio BRL/USD (R$/US$): ponto e p-valor AR da resposta zero**

| h | produção | p | sem as 5 | p | sem as 10 | p |
|---|---|---|---|---|---|---|
| 0 | 0,146 | 0,013 | 0,189 | 0,083 | 0,070 | 0,678 |
| 1 | 0,180 | 0,030 | 0,242 | 0,080 | 0,160 | 0,457 |
| 3 | 0,172 | 0,039 | 0,235 | 0,075 | 0,222 | 0,271 |
| 6 | 0,120 | 0,104 | 0,182 | 0,102 | 0,163 | 0,299 |
| 12 | 0,027 | 0,642 | 0,096 | 0,279 | 0,061 | 0,654 |
| 24 | −0,077 | 0,253 | −0,014 | 0,872 | −0,048 | 0,738 |

**CDS 5 anos (p.b.): ponto e p-valor AR da resposta zero**

| h | produção | p | sem as 5 | p | sem as 10 | p |
|---|---|---|---|---|---|---|
| 0 | 33,9 | 0,015 | 42,5 | 0,068 | 36,5 | 0,343 |
| 1 | 37,1 | 0,021 | 46,3 | 0,063 | 40,9 | 0,292 |
| 3 | 34,0 | 0,033 | 42,0 | 0,071 | 47,1 | 0,185 |
| 6 | 26,1 | 0,084 | 34,5 | 0,101 | 36,4 | 0,197 |
| 12 | 9,0 | 0,457 | 20,4 | 0,240 | 16,9 | 0,484 |
| 24 | −15,0 | 0,260 | −2,5 | 0,884 | −8,7 | 0,766 |

**Conjuntos sem as 5.** Os de produção estão na nota do passo 1 (`2026-10-05_precisao_ar`). Sem as dez,
todo conjunto de câmbio e CDS é a reta inteira, a 90 e a 95%.

| série | h | 90% | 95% |
|---|---|---|---|
| câmbio | 0 | [0,026; 0,555] | ℝ |
| câmbio | 1 | [0,036; 0,752] | (−∞; −0,792] ∪ [−0,278; ∞) |
| câmbio | 3 | [0,046; 0,708] | (−∞; −0,763] ∪ [−0,224; ∞) |
| câmbio | 6 | [−0,002; 0,531] | ℝ |
| câmbio | 12 | [−0,125; 0,393] | ℝ |
| câmbio | 24 | [−0,295; 0,274] | ℝ |
| CDS | 0 | [9,6; 141,1] | (−∞; −233,6] ∪ [−17,7; ∞) |
| CDS | 1 | [13,1; 141,8] | (−∞; −210,2] ∪ [−17,0; ∞) |
| CDS | 3 | [10,2; 116,7] | ℝ |
| CDS | 6 | [−0,3; 84,4] | ℝ |
| CDS | 12 | [−25,4; 63,7] | ℝ |
| CDS | 24 | [−62,9; 50,1] | ℝ |

De h0 a h36 (`joint_fx_cds.csv`):
- **produção:** câmbio significante a 90% em h0–h5 e a 95% em h0–h3; CDS a 90% em h0–h6 e a 95% em
  h0–h4;
- **sem as 5:** câmbio significante a 90% em h0–h5 e CDS em h0–h4, os conjuntos de 90% são todos
  intervalos e mais largos, e nenhum dos dois é significante a 95% em horizonte algum;
- **sem as 10:** nenhum dos dois é significante a 90% nem a 95%.

No painel inteiro, nos seis horizontes da tabela (689 pares testados), os pares significantes a 90%
vão de 294 a 122 e a 0, e a 95% de 185 a 7 e a 0. `joint_table.csv` traz as 115 séries.

## 4. Leitura

- **Direção e magnitude ficam.** O câmbio e o CDS mantêm o sinal em h0, h1 e h3, os horizontes
  medidos, em cada exclusão individual, e de h0 a h6 nas duas conjuntas. A magnitude fica na mesma
  ordem de grandeza da produção. Sem as dez, o impacto
  do câmbio cai à metade (0,070 contra 0,146), mas h1 e h3 ficam em 0,160 e 0,222.
- **Precisão e relevância não ficam.** A força do instrumento se concentra em poucas reuniões. Nenhuma
  pesa sozinha, e ξ_mp individual não cai abaixo de 5,52. Juntas, cinco levam a relevância abaixo do
  limiar dos conjuntos de 95%, e dez abaixo do de 90%. Sem as dez, os dados não informam o sinal da
  resposta de câmbio e CDS.
- **O critério combinado em 03-10.** Ele trata o caso em que "poucos eventos determinam o resultado"
  como motivo para investigar antes de submeter, e não trata inversões pontuais com grande incerteza
  como invalidação. Aqui não há inversão: o que depende de poucos eventos é a significância. A decisão
  é do autor e do orientador.
- **Excluir as mais influentes não é neutro.** A ordem escolhe as reuniões de maior |e_i η_t|, que são
  as que carregam Γ. Tirá-las reduz a força em parte por construção, porque um instrumento de alta
  frequência concentra a informação nas surpresas grandes. O exercício mede essa concentração, como o
  e-mail pede. Não mostra que essas reuniões estejam contaminadas. A ordem é por tamanho da mudança e
  não por direção: entre as dez estão 2022-03-17, 2023-08-03 e 2018-06-21, cuja exclusão individual
  eleva ξ_mp.
- ⚠ **Sem as 5, os pontos crescem** (câmbio 0,189 contra 0,146 no impacto, CDS 42,5 contra 33,9). O
  momento de normalização cai a 46% e o numerador cai menos. Quando o denominador encolhe, parte da
  magnitude maior é aritmética, não economia.
- ⚠ A 95%, sem as 5, os conjuntos de câmbio em h1 e h3 e de CDS em h0 e h1 são `two_rays`, a união de
  duas semirretas. Zero fica dentro, então nenhum é significante.

## 5. O que fica de fora

- **A exclusão por movimentos extremos de VIX, S&P 500 ou Brent.** Por decisão do autor, ela é um item
  aberto à parte (`pendencias.md`, Tema B), com a regra definida antes de rodar e sem selecionar
  reuniões por câmbio ou CDS.
- **Reestimação.** Pelo desenho do e-mail, nem os fatores nem a ortogonalização BS são reestimados sem
  as reuniões.
- **O que o e-mail dispensa.** Não há limiar de "influente", nem exclusões sequenciais, nem conjuntos
  AR por reunião.
- **Outras truncagens.** Só NW(0), a de produção, foi rodada. A exclusão preserva o calendário, então
  outra truncagem caberia sem mudar o código.

## 6. Arquivos

- `output/meeting_influence/ranking.csv`: uma linha por reunião, com ordem, data, mês, `in_window`,
  surpresa, influência e componente, |ΔΓ_k|/EP_k, câmbio e CDS em h0/h1/h3 com as mudanças, ξ_mp e
  F_rob com as mudanças.
- `output/meeting_influence/joint_table.csv`: produção, sem as 5 e sem as 10, as 115 séries nos seis
  horizontes, conjuntos de 90 e 95% com tipo e significância, e o p-valor AR em zero.
- `output/meeting_influence/joint_fx_cds.csv`: câmbio e CDS de h0 a h36, nas mesmas três células.
- `output/meeting_influence/joint_strength.csv`: reuniões excluídas, ξ_mp, F_rob, d0'Γ, Σz² e se os
  conjuntos são limitados.

`tidy_ar_sets()` saiu de `script/ar_precision.R` para `R/identification/weak_iv_ar.R`, porque os dois
scripts a usam. Os CSVs de `output/ar_precision/` saíram byte-idênticos ao serem rerodados,
`validate_mosw_ar.R` passa e o smoke test da branch fica bit-idêntico.
