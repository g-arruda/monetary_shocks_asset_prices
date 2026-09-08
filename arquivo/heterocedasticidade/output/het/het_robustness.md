# Robustez: identificacao por heterocedasticidade (Rigobon 2003) no DFM mensal

Gerado por `script/het_robustness.R` em 2026-09-01. **Corpo gerado — nao editar a mao.**

## O que este exercicio responde

A secao de robustez do paper varia a receita do instrumento, o `(r,q)` e a janela,
mas nenhum item varia a **identificacao**. Aqui a identificacao de Rigobon (2003) e
rodada sobre o mesmo objeto do paper — o DFM mensal — para verificar se ela aponta
na mesma direcao do proxy.

## Regra de leitura, fixada antes dos numeros

- Familia de 450 celulas com status `ok`; correcao de Holm sobre a familia inteira.
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
| calendario | 100 | 0.320 | 0.282 | 0.038 | 0.020 | 0 | 0 | 0.336 | 0.154 | 0.445 | 32 | 0 |
| episodio_s2 |  50 | 0.426 | 0.331 | 0.068 | 0.000 | 0 | 0 | 0.347 | 0.160 | 0.323 | 16 | 0 |
| intensidade_z | 100 | 0.192 | 0.156 | 0.002 | 0.130 | 0 | 0 | 0.392 | 0.161 | 0.425 | 37 | 0 |
| quebra_livre | 100 | 0.084 | 0.110 | 0.004 | 0.230 | 0 | 0 | 0.383 | 0.179 | 0.545 | 42 | 0 |
| volatilidade_juros | 100 | 0.148 | 0.523 | 0.146 | 0.000 | 0 | 0 | 0.411 | 0.148 | 0.420 | 32 | 0 |

## Celula de producao (r=4, q=4, p=4, full)

| desenho | n_C | n_NC | lambda_1 | rank1_share | p_placebo | p_prop_boot | veredito |
|---|---|---|---|---|---|---|---|
| calendario | 99 |  50 | 4.7647 | 0.308 | 0.458 | 0.056 | fails |
| episodio_s2 | 69 |  80 | 6.9779 | 0.618 | 0.414 | 0.347 | fails |
| intensidade_z | 50 |  99 | 4.5191 | 0.354 | 0.545 | 0.004 | fails |
| volatilidade_juros | 37 | 112 | 13.7881 | 0.618 | 0.057 | 0.226 | fails |
| quebra_livre | 67 |  82 | 7.4568 | 0.629 | 0.347 | 0.269 | fails |

## Onde as rejeicoes vivem (janela)

| desenho | janela | n | frac p_prop < .05 | mediana p_prop | rank1 | gap autovalores |
|---|---|---|---|---|---|---|
| calendario | full | 50 | 0.040 | 0.162 | 0.317 | 0.134 |
| calendario | pre_covid | 50 | 0.000 | 0.546 | 0.370 | 0.180 |
| episodio_s2 | full | 50 | 0.000 | 0.331 | 0.347 | 0.160 |
| intensidade_z | full | 50 | 0.180 | 0.093 | 0.400 | 0.166 |
| intensidade_z | pre_covid | 50 | 0.080 | 0.267 | 0.384 | 0.156 |
| quebra_livre | full | 50 | 0.100 | 0.155 | 0.383 | 0.165 |
| quebra_livre | pre_covid | 50 | 0.360 | 0.071 | 0.380 | 0.213 |
| volatilidade_juros | full | 50 | 0.000 | 0.466 | 0.421 | 0.111 |
| volatilidade_juros | pre_covid | 50 | 0.000 | 0.561 | 0.397 | 0.203 |

## O regime C e uma regra de politica ou a variancia da COVID?

Composicao do regime C na celula de producao, antes e a partir de 2020:

| desenho | era | C | NC | share_C |
|---|---|---|---|---|
| calendario | 2020+ | 46 | 23 | 0.667 |
| calendario | pre2020 | 53 | 27 | 0.662 |
| episodio_s2 | 2020+ | 69 |  0 | 1.000 |
| episodio_s2 | pre2020 |  0 | 80 | 0.000 |
| intensidade_z | 2020+ | 27 | 42 | 0.391 |
| intensidade_z | pre2020 | 23 | 57 | 0.287 |
| quebra_livre | 2020+ | 67 |  2 | 0.971 |
| quebra_livre | pre2020 |  0 | 80 | 0.000 |
| volatilidade_juros | 2020+ | 33 | 36 | 0.478 |
| volatilidade_juros | pre2020 |  4 | 76 | 0.050 |

## Veredito

**Nenhuma celula da grade identifica**, e o veredito nao depende da severidade da
correcao: sob Holm dentro de cada desenho x janela (50 testes em vez de 450) o
numero de celulas aprovadas continua **zero** em todos os desenhos. As rejeicoes
brutas a 5% que aparecem em `intensidade_z`, `quebra_livre` e `episodio_s2` sao
artefato de multiplicidade sobre celulas fortemente dependentes (mesmo painel,
especificacoes aninhadas).

**Uma segunda condicao necessaria e avaliada em separado.** Rejeitar
proporcionalidade diz que as matrizes de covariancia diferem; identificar uma
COLUNA exige ainda que os autovalores generalizados sejam **distintos**
(Rigobon 2003; Lanne-Lutkepohl 2008). O gap relativo minimo tem mediana entre
0.15 e 0.18 por desenho — abaixo do corte de 0.20 usado aqui — e a mediana
nunca o alcanca, embora 159 das 450 celulas individuais o superem.
Cruzando as duas condicoes em nivel BRUTO (sem correcao alguma):
38 celulas rejeitam proporcionalidade, 159 tem autovalores distintos, e
**28 satisfazem as duas** — das quais 6 estao em `q = 5`, o menor valor da
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

