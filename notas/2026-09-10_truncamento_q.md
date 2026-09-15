# Truncamento `q < r`: inofensivo antes da COVID, distorce depois

> **CURRENT — 2026-09-10.** Rodada feita sob a produção corrente:
> - painel de 115 séries `drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, `(r,q,p)=(5,5,4)`, `z_jk_bs_purif` × `yield_6m`, choque de +50 pb;
> - branch `feature/poda-correlacao-painel`, commit `7cd9511`, depois mergeada em `main`;
> - código novo: `script/q_truncation.R`, que só chama funções que já existiam; nada em `R/` mudou;
> - saídas geradas em `output/factors/`: `q_truncation.{md,pdf}` e `q_truncation_{cells,directions,paths,containment}.csv`;
> - **em 2026-09-14** o script ganhou a janela-célula `cheia_p4_lp`, a cheia com a volatilidade COVID de Lenza-Primiceri. As linhas das três células desta nota saem idênticas nos CSVs, e a leitura conjunta daqui não muda. A célula nova está em `notas/2026-09-14_inferencia_volatilidade_covid_q.md`.
>
> **A produção não muda.** A rodada responde a uma pergunta de defesa da especificação: se `q = r = 5` se sustenta diante do `q = 2` de Amengual-Watson.

## 1. A pergunta

Alessi-Kerssenfischer (2019, nota 4) fixam `q = r` porque, com instrumento externo, os resultados seriam "virtually identical whether or not q < r", e a Figura A3 do apêndice deles mostra isso. Neste painel a premissa não pode ser só citada:
- Amengual-Watson dá `q = 2` em `r = 5` (`notas/2026-09-10_poda_correlacao_painel.md`);
- `(5,2)` e `(5,3)` têm ξ_mp de 2,339 e 2,105, abaixo de 3,84, e o conjunto de Anderson-Rubin a 95% sai ilimitado.

Stock-Watson (2016, §7.2) enfrentam o mesmo conflito com dados americanos. Amengual-Watson seleciona 3 choques dinâmicos para qualquer número de fatores estáticos entre 3 e 8 (§6.3.1), e eles, que usam 8, fixam `q = r` "to err on the side of over-specifying the space of innovations so that they span the space of the reduced number of shocks of interest".

A rodada testa se, aqui, impor `q < r` é inofensivo, como em AK, ou se descarta as direções em que o instrumento está.

## 2. Desenho

Três janelas-célula, todas com `r = 5` e `q` de 2 a 5:

| célula | janela | `p` | inferência |
|---|---|---|---|
| `cheia_p4` | 2012-03 a 2025-12 | 4 | AR 68/90 na referência `q = 5` (produção) |
| `pre_p4` | 2012-03 a 2019-12 | 4 | só pontual: o AR é bloqueado (`hac_dim` 135 ≥ T = 90) |
| `pre_p2` | 2012-03 a 2019-12 | 2 | AR 68/90 na referência `q = 5` (`hac_dim` 85 < T = 92) |

**T1, suficiência do subespaço retido.** `estimate_dynamic_factors()` retém os `q` primeiros autovetores de `cov(u)`. Com `q` choques e instrumento válido, z é ortogonal às direções descartadas. O teste é o Wald conjunto de z contra as direções `q+1` a 5 das inovações de `q = 5`, com χ²(5 − q) e nível de 5%.

**T2, invariância.** `containment_vs_production()` sobre as 115 séries, h = 0 a 48, contra a referência `q = 5` da mesma janela. A regra é a pré-registrada da função:
- *imaterial* se a trajetória fica dentro da banda de 90% em todo h e `cor_path` > 0,95;
- *material* se sai da banda ou troca o sinal em h = 0;
- *parcial* no resto.

**Leitura conjunta.** "O truncamento é inofensivo antes da COVID e distorce depois" vale se as duas condições se cumprem:
- (i) T1 não rejeita em nenhum `q` nas duas células pré-COVID e rejeita em algum `q` na cheia;
- (ii) em `q` = 3 e 4, a maioria das 115 séries sai *imaterial* em `pre_p2` e não em `cheia_p4`.

⚠ **As regras não são pré-registradas no sentido estrito.** Foram escritas depois de uma passada exploratória no mesmo dia, em pasta temporária, que já tinha mostrado os p-valores de T1 e a sobreposição das IRFs pré-COVID em `p = 4`. O que esta rodada acrescenta é o registro:
- as bandas AR pré-COVID;
- a contagem sobre as 115 séries;
- os auto-testes.

**Destaque.** Tabela e figura mostram `yield_6m`, `yield_2y`, `cambio_usd`, `cds_5y`, `price_ipca` e `ibc_br`, por decisão do autor. O Ibovespa ficou fora só do destaque. Ele segue no CSV de trajetórias e nas contagens (§5).

## 3. Resultados

**Força e T1:**

| célula | ξ_mp em `q` = 5 / 4 / 3 / 2 | p de T1 em `q` = 2 / 3 / 4 |
|---|---|---|
| `cheia_p4` | 6,057 / 4,359 / 2,105 / 2,339 | **0,051 / 0,039 / 0,015** |
| `pre_p4` | 8,643 / 8,803 / 8,819 / 4,905 | 0,216 / 0,528 / 0,483 |
| `pre_p2` | 6,482 / 6,556 / 6,498 / 3,958 | 0,558 / 0,954 / 0,842 |

**T2**, séries imateriais / parciais / materiais entre as 115, com a mediana de `cor_path` entre parênteses:

| `q` | `pre_p2` | `cheia_p4` |
|---|---|---|
| 4 | 115 / 0 / 0 (0,9999) | 0 / 21 / 94 (0,629) |
| 3 | 115 / 0 / 0 (1,000) | 0 / 0 / 115 (0,334) |
| 2 | 100 / 10 / 5 (0,986) | 0 / 0 / 115 (0,344) |

**Impacto (h = 0) no destaque**, nas unidades de `irf_point_matrix`:

| série | `pre_p2`, `q` = 5 / 4 / 3 / 2 | `cheia_p4`, `q` = 5 / 4 / 3 / 2 |
|---|---|---|
| `cds_5y` | 31,6 / 31,9 / 31,7 / 36,8 | 29,9 / 47,2 / 126,9 / 118,9 |
| `price_ipca` | −0,261 / −0,263 / −0,263 / −0,150 | −0,044 / −0,071 / −0,209 / +0,109 |
| `cambio_usd` | 0,058 / 0,060 / 0,063 / 0,086 | 0,134 / 0,267 / 0,534 / 0,453 |
| `yield_2y` | 0,0069 / 0,0069 / 0,0069 / 0,0073 | 0,0070 / 0,0090 / 0,0154 / 0,0150 |
| `ibc_br` | −0,415 / −0,417 / −0,409 / −0,907 | −0,630 / −0,990 / −2,649 / −2,569 |

Na cheia, `q = 3` multiplica o impacto do CDS por 4,2 e, em `q = 2`, o IPCA troca de sinal no impacto. O denominador de normalização (`impact_mp_pre`) de `q = 3` é 0,24 do de `q = 5`, o que responde por um fator de cerca de 4 dessas ampliações.

**Mecanismo.** Direções de `cov(u)` em `q = 5`, em `q_truncation_directions.csv`:
- **Na cheia**, as direções 4 e 5 somam 14,8% da variância das inovações e 76% da covariância entre z e a inovação da `yield_6m`, com Wald de z de 4,22 e 5,88.
- **O peso de 2020 na cheia.** As direções 1 e 2 tiram 24% e 32% da sua soma de quadrados de 2020-03 a 2020-12, que são 6,2% dos meses. A direção 2 (indústria e trabalho) responde por 37% da variância da inovação da `yield_6m` e tem Wald de z de 0,12.
- **Na pré-COVID**, a direção 1 é a da curva, câmbio e CDS: a curva tem 19% a 21% da sua pegada, e ela carrega 53% a 58% daquela covariância. As direções 4 e 5 carregam perto de zero.

## 4. Veredito

**Leitura conjunta sustentada.** As duas condições se cumprem.
- **T1:** não rejeita na pré-COVID e rejeita em `q` = 3 e 4 na cheia; em `q = 2`, p = 0,051.
- **Invariância de AK:** vale nas 115 séries em `q` = 3 e 4 na pré-COVID, e em nenhuma na cheia.

## 5. O Ibovespa

Saiu do destaque por decisão do autor, e a leitura é a mesma das demais séries.
- **Na cheia** sai *material* em `q` = 2, 3 e 4, com impacto de −23,4 e −24,0 em `q` = 2 e 3 contra −1,00 em `q = 5`.
- **Em `pre_p2`** sai *imaterial* nos três, com −4,84 / −4,30 / −4,88 em `q` = 4 / 3 / 2 contra −4,87 em `q = 5`.

## 6. O que isso permite dizer

- **Que `q = r` segue Stock-Watson (2016, §7.2) e AK.** A justificativa é que o truncamento por variância é uma restrição que a identificação por instrumento externo não exige e que, nesta amostra, descarta as direções em que o instrumento está.
- **Que antes da COVID a invariância de AK se reproduz neste painel.** Com bandas AR, as 115 séries saem *imateriais* em `q` = 3 e 4.
- **Que o `q = 2` de Amengual-Watson não contradiz o choque monetário.** O critério conta os choques dominantes em variância e não diz que o choque monetário não exista.

## 7. O que não se pode dizer

- **Que Amengual-Watson sustenta `q = 5`.**
- **Que as IRFs são invariantes a `q` na amostra cheia.** Nem a célula `(5,4)`, com conjunto limitado, passa: 0 das 115 séries imateriais, com mediana de `cor_path` de 0,63.
- **Que T1 rejeita `q = 2` a 5%.** O p-valor é 0,051.
- **Que a comparação pré-COVID com bandas está na especificação de produção.** Ela está em `p = 2`; em `p = 4` só há pontos, e a figura mostra `q` = 3, 4 e 5 sobrepostos.
- **Que as bandas de `pre_p2` são folgadas por mérito.** A covariância AR de `pre_p2` usa 85 momentos em 92 observações, e bandas largas facilitam a contenção. Por isso a mediana de `cor_path`, que não depende da largura da banda, vai ao lado: 0,9999 e 1,000.

## 8. Notas técnicas

**Conjuntos AR só nas referências.**
- A guarda de `compute_irf_dfm()` exige que o ponto re-derivado pelo AR coincida com o de `ident_ext_instr()` a 1e-10 absoluto.
- Em `(5,3)` na cheia, o desvio foi 1,16e-10, numa célula com respostas da ordem de 10: o desvio relativo é de cerca de 1e-11.
- A guarda não foi alterada. O script constrói conjuntos só em `q = 5`, que é o que T2 lê, e a limitação das alternativas sai de ξ_mp > κ.
- Ficou um item aberto no Tema E de `registro/pendencias.md`.

**O ponto de normalização é um `singleton`.** O conjunto AR da `yield_6m` em h = 0 é {0,005} em todas as células, inclusive na produção (`output/irf/irf_coherence_h.csv`). A frase do `CLAUDE.md` de que as 5635 células de produção saem `interval` vale para 5634; a restante é esse singleton.

**Auto-testes:**
- o ponto e as bandas 68/90 da produção reproduzem `irf_coherence_h.csv` a 1e-10;
- ξ_mp de `cheia_p4` e `pre_p4` reproduz `mosw_strength_grid.csv` a 1e-8, e o `xi_den` do AR bate com o Wald;
- o ξ reconstruído a partir das `q` primeiras direções reproduz o de cada célula `q` a 1e-8, o que prova que T1 lê as mesmas direções que o modelo retém;
- os conjuntos das referências são intervalos, exceto o singleton da normalização;
- a `yield_6m` vale 0,005 em h = 0 em todas as células;
- duas execuções seguidas dão CSVs e md bit-idênticos.

## 9. O que não foi feito

- O tratamento explícito da COVID (Lenza-Primiceri 2022), que é a objeção previsível à leitura da §4.
- Os critérios de `q` baseados no espectro (Hallin-Liška 2007, Onatski 2010).
- Os conjuntos AR nas células alternativas e na pré-COVID em `p = 4`.
- O texto do paper, que fica para a rodada editorial já aberta no Tema A.
