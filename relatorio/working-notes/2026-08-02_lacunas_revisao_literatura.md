# Lacunas na revisão de literatura (Seção 2)

**Nota de escrita, não de estimação.** Nenhum script foi rodado, nenhuma estimativa
muda. Levantamento feito depois do corte de material residual da Seção 2
(`texto_anpec/paper_anpec.tex`, mesma sessão), cruzando cada `\cite{}` usado no
resto do artigo contra a lista de citações da revisão de literatura.

## 1. Conceitos centrais do artigo sem embasamento bibliográfico próprio

### Dominância fiscal

O termo aparece no abstract, duas vezes na introdução (a interpretação central dos
resultados) e na conclusão. A única citação ligada a ele em todo o artigo é
`goncalves2025` — que é o trabalho que **rejeita** a hipótese para o Brasil. O
leitor nunca recebe a origem do conceito nem uma referência que o estabeleça
independentemente do resultado que o testa. A Seção 2 não tem parágrafo sobre
dominância fiscal ou sustentabilidade da dívida como restrição à política
monetária. Candidatos óbvios não citados: Sargent & Wallace (1981), ou a aplicação
direta ao Brasil em Blanchard (2004), "Fiscal Dominance and Inflation Targeting:
Lessons from Brazil".

### Paridade descoberta de juros (UIP)

É o conceito do título do artigo ("Uncovered Interest Parity, Inverted"), aparece
no abstract e duas vezes na introdução e na conclusão. Nenhuma citação da
literatura de falha de UIP aparece em lugar nenhum do artigo — nem o *forward
premium puzzle* (Fama 1984), nem a literatura de prêmio de risco cambial/*carry
trade* (ex.: Lustig & Verdelhan). É a lacuna mais exposta do artigo, porque é a
própria moldura do título e nunca é sustentada por uma referência.

## 2. Citações usadas fora da Seção 2 sem contraparte na revisão de literatura

### `BEKAERT2013771` — resolvido nesta rodada

Citado só na Seção 4 (câmbio e risco soberano), documentando o elo entre política
monetária e precificação de risco. Adicionado à Seção 2 nesta edição, no parágrafo
dos modelos teóricos (depois de `castelnuovo` e `Cooley`), como confirmação
empírica da previsão teórica de repasse da política monetária ao preço de ativos.

**Nota lateral, corrigida em rodada posterior (2026-08-02, mesma data).** A citação
na Seção 4 (linha 334) descrevia `BEKAERT2013771` como um estudo "para um conjunto
amplo de países". Lido o artigo inteiro via skill `split-pdf-md` (Bekaert, Hoerova &
Lo Duca, 2013, *Journal of Monetary Economics*, "Risk, uncertainty and monetary
policy") para confirmar: é um SVAR de um único país (EUA) — Fed funds rate,
VIX/S&P500 decomposto em aversão a risco e incerteza, produção industrial, CPI/PPI
— sob Cholesky, restrição de longo prazo e duas identificações de alta frequência
via Fed funds futures; nenhuma dimensão cross-country em nenhuma das seis
robustness checks. A frase foi corrigida para "para os Estados Unidos"; a Seção 2
(linha 182, ver acima) já estava correta desde a adição.

### `BERNANKE19991341` — ainda em aberto

Citado só na Seção 4 (crédito), sobre o alargamento tardio dos spreads via
acelerador financeiro. Sem contraparte na Seção 2, cujo parágrafo de canais
teóricos cobre só `castelnuovo` e `Cooley`. Não endereçado nesta rodada.

## 3. Citações técnicas fora da Seção 2 — não são lacunas

`bai-ng`, `barigozzi2016non`, `goncalveskilian2004`, `kilian1998small`,
`sax2018seasonal`, `svensson1994estimating`, e desde esta edição `stockwatson2018`
(agora introduzido pela primeira vez na Metodologia, linhas 246/248, onde o
instrumento do artigo é de fato definido). São citações de método e dado
(padronização, bootstrap, correção de viés, ajuste sazonal, curva de juros,
arcabouço proxy-SVAR), não de revisão de literatura, e não pertencem à Seção 2.
