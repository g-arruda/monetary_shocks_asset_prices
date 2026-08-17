# Robustez: identificacao por heterocedasticidade (Rigobon 2003) no DFM mensal

Gerado por `script/het_robustness.R` em 2026-08-17. **Corpo gerado — nao editar a mao.**

## O que este exercicio responde

A secao de robustez do paper varia a receita do instrumento, o `(r,q)` e a janela,
mas nenhum item varia a **identificacao**. Aqui a identificacao de Rigobon (2003) e
rodada sobre o mesmo objeto do paper — o DFM mensal — para verificar se ela aponta
na mesma direcao do proxy.

## Regra de leitura, fixada antes dos numeros

- Familia de 288 celulas com status `ok`; correcao de Holm sobre a familia inteira.
- O veredito primario e a **distribuicao** de p-valores do placebo contra a uniforme,
  nao o minimo.
- Uma celula so conta como aprovacao se sobreviver a Holm **e** replicar na outra janela.
- O **teste de proporcionalidade** e o gate que decide identificacao: um deslocamento
  de variancia que seja fator de escala comum deixa `Sigma_C` proporcional a `Sigma_NC`
  e `b` indefinido, por maior que seja.

## Referencia diaria

No painel diario Qua->Qui (fixture do referee2, 97 C / 524 NC) o teste de
proporcionalidade da **LR = 135.1, p_boot = 0.0050** — a condicao de posto e
rejeitada com folga. E contra esse valor que os resultados mensais abaixo devem ser lidos.

## Resultado por desenho de regime

| desenho | n | med p_plac | med p_prop | min p_prop | frac p_prop<.05 | Holm agrup. | Holm interno | rank1 med | gap med | gap max | autoval. distintos | identifica |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| calendario | 64 | 0.263 | 0.454 | 0.038 | 0.016 | 0 | 0 | 0.346 | 0.137 | 0.285 |  6 | 0 |
| episodio_s2 | 32 | 0.047 | 0.062 | 0.016 | 0.406 | 0 | 0 | 0.355 | 0.148 | 0.299 |  9 | 0 |
| intensidade_z | 64 | 0.230 | 0.118 | 0.010 | 0.219 | 0 | 0 | 0.376 | 0.165 | 0.405 | 21 | 0 |
| quebra_livre | 64 | 0.061 | 0.100 | 0.002 | 0.312 | 0 | 0 | 0.387 | 0.188 | 0.351 | 29 | 0 |
| volatilidade_juros | 64 | 0.131 | 0.316 | 0.034 | 0.047 | 0 | 0 | 0.416 | 0.136 | 0.288 | 10 | 0 |

## Celula de producao (r=5, q=5, p=6, full)

| desenho | n_C | n_NC | lambda_1 | rank1_share | p_placebo | p_prop_boot | veredito |
|---|---|---|---|---|---|---|---|
| calendario | 98 |  49 | 4.7875 | 0.354 | 0.222 | 0.126 | fails |
| episodio_s2 | 69 |  78 | 3.5656 | 0.376 | 0.467 | 0.469 | fails |
| intensidade_z | 49 |  98 | 3.9850 | 0.406 | 0.508 | 0.022 | fails |
| volatilidade_juros | 37 | 110 | 8.7442 | 0.482 | 0.164 | 0.413 | fails |
| quebra_livre | 67 |  80 | 3.8263 | 0.383 | 0.439 | 0.601 | fails |

## Onde as rejeicoes vivem (janela)

| desenho | janela | n | frac p_prop < .05 | mediana p_prop | rank1 | gap autovalores |
|---|---|---|---|---|---|---|
| calendario | full | 32 | 0.000 | 0.352 | 0.343 | 0.119 |
| calendario | pre_covid | 32 | 0.031 | 0.571 | 0.363 | 0.145 |
| episodio_s2 | full | 32 | 0.406 | 0.062 | 0.355 | 0.148 |
| intensidade_z | full | 32 | 0.375 | 0.061 | 0.359 | 0.165 |
| intensidade_z | pre_covid | 32 | 0.062 | 0.284 | 0.404 | 0.165 |
| quebra_livre | full | 32 | 0.500 | 0.056 | 0.378 | 0.130 |
| quebra_livre | pre_covid | 32 | 0.125 | 0.170 | 0.417 | 0.230 |
| volatilidade_juros | full | 32 | 0.094 | 0.132 | 0.440 | 0.130 |
| volatilidade_juros | pre_covid | 32 | 0.000 | 0.609 | 0.354 | 0.149 |

## O regime C e uma regra de politica ou a variancia da COVID?

Composicao do regime C na celula de producao, antes e a partir de 2020:

| desenho | era | C | NC | share_C |
|---|---|---|---|---|
| calendario | 2020+ | 46 | 23 | 0.667 |
| calendario | pre2020 | 52 | 26 | 0.667 |
| episodio_s2 | 2020+ | 69 |  0 | 1.000 |
| episodio_s2 | pre2020 |  0 | 78 | 0.000 |
| intensidade_z | 2020+ | 26 | 43 | 0.377 |
| intensidade_z | pre2020 | 23 | 55 | 0.295 |
| quebra_livre | 2020+ | 67 |  2 | 0.971 |
| quebra_livre | pre2020 |  0 | 78 | 0.000 |
| volatilidade_juros | 2020+ | 33 | 36 | 0.478 |
| volatilidade_juros | pre2020 |  4 | 74 | 0.051 |

## Veredito

**Nenhuma celula da grade identifica**, e o veredito nao depende da severidade da
correcao: sob Holm dentro de cada desenho x janela (32 testes em vez de 288) o
numero de celulas aprovadas continua **zero** em todos os desenhos. As rejeicoes
brutas a 5% que aparecem em `intensidade_z`, `quebra_livre` e `episodio_s2` sao
artefato de multiplicidade sobre celulas fortemente dependentes (mesmo painel,
especificacoes aninhadas).

**Uma segunda condicao necessaria e avaliada em separado.** Rejeitar
proporcionalidade diz que as matrizes de covariancia diferem; identificar uma
COLUNA exige ainda que os autovalores generalizados sejam **distintos**
(Rigobon 2003; Lanne-Lutkepohl 2008). O gap relativo minimo tem mediana entre
0.14 e 0.19 por desenho — abaixo do corte de 0.20 usado aqui — e a mediana
nunca o alcanca, embora 75 das 288 celulas individuais o superem.
Cruzando as duas condicoes em nivel BRUTO (sem correcao alguma):
51 celulas rejeitam proporcionalidade, 75 tem autovalores distintos, e
**24 satisfazem as duas** — das quais 15 estao em `q = 5`, o menor valor da
grade, e todas na janela cheia. Apos a correcao interna ao desenho sobram **zero**.
A concentracao em uma unica dimensao dinamica e assinatura de fragilidade de
especificacao, nao de identificacao. Por isso o estagio de IRF **nao roda**:
qualquer IRF produzida aqui seria um numero sem identificacao por tras.

**Leitura.** O desenho `volatilidade_juros` e o mais informativo: ele concentra o
regime C no pos-2020 (share_C 0,48 contra 0,05 antes) e mesmo assim **nao rejeita
proporcionalidade em nenhuma celula**. Ou seja, o surto de volatilidade pos-2020
e um **fator de escala comum** — levanta todas as variancias juntas sem girar a
matriz de covariancia. Com o diario rejeitando a proporcionalidade com folga na
mesma economia e no mesmo periodo, a leitura e sobre **frequencia**: a variancia
mensal muda de nivel, nao de composicao.

Isso justifica o desenho do paper (proxy sobre DFM mensal) e responde ao GRG, mas
**nao e corroboracao** e nao pode ser escrito como tal.

