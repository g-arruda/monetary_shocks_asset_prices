# Robustez: identificacao por heterocedasticidade (Rigobon 2003) no DFM mensal

Gerado por `script/het_robustness.R` em 2026-08-01. **Corpo gerado — nao editar a mao.**

## O que este exercicio responde

A secao de robustez do paper varia a receita do instrumento, o `(r,q)` e a janela,
mas nenhum item varia a **identificacao**. Aqui a identificacao de Rigobon (2003) e
rodada sobre o mesmo objeto do paper — o DFM mensal — para verificar se ela aponta
na mesma direcao do proxy.

## Regra de leitura, fixada antes dos numeros

- Familia de 252 celulas com status `ok`; correcao de Holm sobre a familia inteira.
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
| calendario | 56 | 0.441 | 0.546 | 0.104 | 0.000 | 0 | 0 | 0.292 | 0.112 | 0.249 | 10 | 0 |
| episodio_s2 | 28 | 0.044 | 0.066 | 0.010 | 0.250 | 0 | 0 | 0.348 | 0.162 | 0.343 | 10 | 0 |
| intensidade_z | 56 | 0.339 | 0.069 | 0.006 | 0.446 | 0 | 0 | 0.322 | 0.166 | 0.380 | 21 | 0 |
| quebra_livre | 56 | 0.238 | 0.120 | 0.006 | 0.286 | 0 | 0 | 0.375 | 0.157 | 0.433 | 19 | 0 |
| volatilidade_juros | 56 | 0.101 | 0.306 | 0.094 | 0.000 | 0 | 0 | 0.373 | 0.167 | 0.312 | 16 | 0 |

## Celula de producao (r=7, q=6, p=6, full)

| desenho | n_C | n_NC | lambda_1 | rank1_share | p_placebo | p_prop_boot | veredito |
|---|---|---|---|---|---|---|---|
| calendario | 98 |  49 | 0.8356 | 0.316 | 0.300 | 0.359 | fails |
| episodio_s2 | 69 |  78 | 1.1252 | 0.326 | 0.092 | 0.098 | fails |
| intensidade_z | 49 |  98 | 1.0629 | 0.314 | 0.382 | 0.024 | fails |
| volatilidade_juros | 37 | 110 | 1.9340 | 0.370 | 0.025 | 0.130 | fails |
| quebra_livre | 46 | 101 | 1.1740 | 0.369 | 0.300 | 0.068 | fails |

## Onde as rejeicoes vivem (janela)

| desenho | janela | n | frac p_prop < .05 | mediana p_prop | rank1 | gap autovalores |
|---|---|---|---|---|---|---|
| calendario | full | 28 | 0.000 | 0.564 | 0.314 | 0.111 |
| calendario | pre_covid | 28 | 0.000 | 0.451 | 0.284 | 0.129 |
| episodio_s2 | full | 28 | 0.250 | 0.066 | 0.348 | 0.162 |
| intensidade_z | full | 28 | 0.893 | 0.037 | 0.302 | 0.147 |
| intensidade_z | pre_covid | 28 | 0.000 | 0.388 | 0.382 | 0.192 |
| quebra_livre | full | 28 | 0.429 | 0.065 | 0.368 | 0.156 |
| quebra_livre | pre_covid | 28 | 0.143 | 0.218 | 0.391 | 0.162 |
| volatilidade_juros | full | 28 | 0.000 | 0.202 | 0.405 | 0.157 |
| volatilidade_juros | pre_covid | 28 | 0.000 | 0.493 | 0.314 | 0.184 |

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
| quebra_livre | 2020+ | 46 | 23 | 0.667 |
| quebra_livre | pre2020 |  0 | 78 | 0.000 |
| volatilidade_juros | 2020+ | 33 | 36 | 0.478 |
| volatilidade_juros | pre2020 |  4 | 74 | 0.051 |

## Veredito

**Nenhuma celula da grade identifica**, e o veredito nao depende da severidade da
correcao: sob Holm dentro de cada desenho x janela (28 testes em vez de 252) o
numero de celulas aprovadas continua **zero** em todos os desenhos. As rejeicoes
brutas a 5% que aparecem em `intensidade_z`, `quebra_livre` e `episodio_s2` sao
artefato de multiplicidade sobre celulas fortemente dependentes (mesmo painel,
especificacoes aninhadas).

**Uma segunda condicao necessaria e avaliada em separado.** Rejeitar
proporcionalidade diz que as matrizes de covariancia diferem; identificar uma
COLUNA exige ainda que os autovalores generalizados sejam **distintos**
(Rigobon 2003; Lanne-Lutkepohl 2008). O gap relativo minimo tem mediana entre
0.11 e 0.17 por desenho — abaixo do corte de 0.20 usado aqui — e a mediana
nunca o alcanca, embora 76 das 252 celulas individuais o superem.
Cruzando as duas condicoes em nivel BRUTO (sem correcao alguma):
48 celulas rejeitam proporcionalidade, 76 tem autovalores distintos, e
**21 satisfazem as duas** — das quais 17 estao em `q = 5`, o menor valor da
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

