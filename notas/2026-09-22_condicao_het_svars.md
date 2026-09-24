# A condição de identificação por heterocedasticidade, reduzida ao teste do `svars`

> **CURRENT — 2026-09-22.** Rodada de método e de registro. A bateria de cinco
> estatísticas que o projeto usava para a `tab:het_frequency` foi **retirada** e
> substituída pelo teste do pacote `svars`; a §5.1, a `tab:het_frequency`, o resumo
> nas duas línguas, a §2 e a conclusão foram reescritos contra o que ele diz.
> - Painel de produção de 115 séries, 2012-03 a 2025-12, `(r,q,p) = (5,5,4)`, escala
>   de volatilidade COVID de Lenza-Primiceri.
> - **A identificação por heterocedasticidade segue fora da produção.** Esta rodada
>   mexe no *diagnóstico* que a §5.1 publica e nas IRFs exploratórias em quarentena.
> - **A única agregação mensal é a do painel** — última cotação do mês de referência.
>   A soma das janelas Qua→Qui dentro do mês foi retirada no fim da rodada, e com ela
>   a afirmação de que a agregação temporal não era o obstáculo.
> - Superou `2026-09-01_heterocedasticidade_frequencia` e a §5.1 de
>   `2026-09-21_migracao_secao_5`.

## O que motivou

A bateria anterior tinha cinco números — teste de proporcionalidade de Mauchly, gap
λ₁−λ₂, razão de variância ao longo da direção principal, participação rank-1 e placebo
de permutação. Nenhum deles é o que a literatura roda.

Rigobon (2003) enuncia **uma** condição de identificação, a de posto, equação (6):

```
det| Ω̂₂ − (ω₁₁,₂/ω₁₁,₁)·Ω̂₁ | ≠ 0
```

e diz, no Apêndice A, que ela falha **se e somente se** as matrizes de covariância dos
dois regimes forem proporcionais. Os cinco números do projeto colapsavam nisso:
proporcionalidade **é** a condição de posto, o gap λ₁−λ₂ é a mesma condição em outra
formalização, `ratio_dir` é o λ de Rigobon–Sack, `rank1_share` é a restrição
sobreidentificadora de Rigobon–Sack *sem o teste*, e o placebo não está em nenhum dos
dois artigos.

Decisão do autor: usar **apenas os testes do pacote `svars`**, reportar ao lado a condição
de posto antes e depois da agregação para mensal, e — correção feita no mesmo dia, depois
que o autor apontou o erro — construir **os dois** sistemas sobre as séries de GRG. Uma
terceira decisão, ainda no mesmo dia, fixou **qual** agregação mensal existe: a do próprio
painel, a última cotação do mês de referência, e nenhuma outra (§ abaixo).

⚠ **O conjunto que o projeto chamava de "séries publicadas" não era o de GRG.** A linha
diária publicada até 2026-09-21 usava DI de 3 meses, DI de 2 anos, Ibovespa e câmbio. GRG
não usam Ibovespa nem o vértice de 2 anos: a Tabela 1 deles traz o DI (1m, 3m, 6m, 12m), o
*breakeven* de inflação (1, 2, 3 e 5 anos), o câmbio BRL/USD e o **CDS soberano de 5 anos**.
O conjunto antigo era construção do projeto, e chamá-lo de "séries de GRG" foi erro meu.
A quarta série deles, a expectativa, é um diferencial de títulos que este projeto não tem —
só a medida do Focus, que é *survey* (eles dizem "market-based (not survey data)") e cuja
variação diária é exatamente zero em 23% dos dias. Ela fica fora, e a lacuna fica declarada.

## O que o pacote faz, e o que precisou de cuidado

`svars` 1.3.12 (Lange, Dalheimer, Herwartz e Maxand, JSS 97(5)) implementa identificação
por mudança de volatilidade citando Rigobon (2003). `id.cv()` estima `B` e `Λ` em
`Σ₁ = BB'`, `Σ₂ = BΛB'` por máxima verossimilhança com iteração GLS. **Com dois regimes o
teste que ele reporta é o `cv_ident_test`** — a estatística sequencial `Qr` de Lütkepohl,
Meitz, Netšunajev e Saikkonen (2021), `H₀: λ_{s+1} = … = λ_{s+r}`, χ² com
`gl = ½(r+2)(r−1)` e correção de curtose. O Wald par a par da informação de Fisher só
entra no caso de três regimes.

⚠ **O caminho público de `id.cv()` para um regime recorrente está quebrado.** O regime do
Copom não é uma quebra estrutural, é um indicador que se repete. `id.cv()` tem um ramo
para isso, mas `R/id.cv.R:177` seleciona as linhas de reunião com `u[SB, ]`, e chegar
nesse ramo exige `SB` numérico (`:149`) — então um vetor 0/1 indexa **por posição** e a
covariância do regime com reunião volta como a primeira linha repetida. A estimativa
colapsa para `Λ = I` sem nenhum aviso. Medido: com o VAR mensal, `Λ = (1,1,1,1)` contra
autovalores generalizados verdadeiros de (2,77; 2,01; 1,18; 0,89).

A saída foi chamar o estimador como o próprio `id.cv()` o chama internamente, com os
índices 0-based que ele constrói em `id.cv.R:277-278`, fornecendo a covariância do regime
com reunião. Isso é `fit_het_cv()`, em `R/identification/het_tests.R`. Duas guardas:

- `Λ` tem de reproduzir os autovalores generalizados de `(Σ_C, Σ_NC)` a `1e-4` relativo.
  Com dois regimes e sem restrições a solução de máxima verossimilhança **é** o
  diagonalizador simultâneo do par, então esta é uma checagem exata. Medido: `5,6e-06`.
- `BB'` e `BΛB'` têm de reproduzir as covariâncias por regime. O colapso descrito acima
  deixa esse desvio em torno de 0,6; o ajuste correto deixa em `3e-05`.

⚠ **Condicionamento numérico.** Com as unidades cruas do painel os desvios-padrão dos
resíduos varrem quatro ordens de grandeza (juros em decimais, CDS em pontos-base) e a
iteração GLS diverge, devolvendo `Λ = I`. As colunas entram divididas pelo desvio-padrão
do resíduo e `B` volta multiplicado. `Λ` é invariante a reescalonamento diagonal, então
nenhuma estatística reportada muda.

## O resultado

`script/het_conditions.R` roda o teste nas três séries de GRG, nas duas frequências e nos
três vértices que o projeto consegue construir, na mesma janela de produção.

| Sistema | Vértice | n_C/n_NC | λ₁ | λ₂ | `Qr` | p | det eq. (6) |
|---|---|---|---|---|---|---|---|
| Diário (DI, câmbio, CDS 5a) | 3 meses | 102/553 | 7,55 | 1,36 | 11,43 | **0,0033** | 40,8 |
| Diário | 6 meses | 102/553 | 4,06 | 1,36 | 4,95 | 0,0844 | 4,0 |
| Diário | 12 meses | 102/553 | 3,63 | 1,40 | 3,83 | 0,1474 | 2,4 |
| VAR mensal, **as mesmas três** | 3 meses | 108/54 | 2,51 | 2,36 | 0,03 | 0,9878 | **−0,03** |
| VAR mensal | 6 meses | 108/54 | 3,07 | 2,59 | 0,17 | 0,9166 | 0,06 |
| VAR mensal | 12 meses | 108/54 | 2,85 | 2,44 | 0,14 | 0,9305 | 0,03 |
| Cinco inovações fatoriais | — | 107/54 | 4,03 | 1,68 | 5,15 | 0,0761 | — |

**As mesmas três séries identificam no diário e não identificam no mensal.** No vértice de
3 meses o sistema diário rejeita `λ₁ = λ₂` com p 0,0033, e λ₁ é 7,55 contra 1,36. No painel
mensal os dois maiores autovalores praticamente coincidem em todo vértice, e o determinante
normalizado de eq. (6) cai de 40,8 para −0,03 — **proporcionalidade**, que é exatamente o
modo de falha que Rigobon aponta.

### A única agregação mensal é a do painel

⚠ **Decisão do autor, 2026-09-22, tomada depois de a rodada rodar.** A comparação
"antes e depois" tinha uma segunda linha mensal construída somando as janelas Qua→Qui
dentro do mês de calendário. **Esse objeto foi retirado.** A única agregação mensal que
existe é a do painel de produção: a **última cotação do mês de referência** nos vértices
do DI (`script/download.R:149`) e no CDS (`:309`), e a média mensal no câmbio
(`R/data_download/exchange.R:103`).

O que a comparação passa a ser é a linha diária contra a linha do painel mensal, nas
mesmas três séries e no mesmo vértice:

| Vértice | Objeto | a | det eq. (6) normalizado | `Qr` | p |
|---|---|---|---|---|---|
| 3 meses | variação Qua→Qui | 5,54 | 40,8 | 11,43 | **0,0033** |
| 3 meses | painel mensal | 2,26 | −0,03 | 0,02 | 0,9878 |
| 6 meses | variação Qua→Qui | 2,84 | 4,0 | 4,95 | 0,0844 |
| 6 meses | painel mensal | 2,98 | 0,06 | 0,17 | 0,9166 |
| 12 meses | variação Qua→Qui | 2,66 | 2,4 | 3,83 | 0,1474 |
| 12 meses | painel mensal | 2,52 | 0,03 | 0,14 | 0,9305 |

O determinante é reportado normalizado por `det(Σ_NC)`, o que o torna invariante às
unidades de cada série e a qualquer reescalonamento diagonal. Sem isso um determinante
medido no painel mensal não seria comparável a um medido em variações semanais, e a
leitura lado a lado seria artefato de escala.

**O que esta tabela não diz.** Entre as duas linhas mudam **duas** coisas ao mesmo tempo:
a frequência de observação e o objeto medido, que deixa de ser a variação da janela de
anúncio e passa a ser a variação de calendário da série. Nada aqui separa uma da outra, e
nenhuma afirmação do paper ou do registro pode atribuir a queda a uma das duas. A rodada
anterior atribuía — dizia que a agregação temporal **não** era o obstáculo e que a
variação de calendário era — apoiada na linha somada que agora não existe.

**Números descontinuados**, que não voltam como estatística reportada: a linha da soma no
mês de calendário em cada vértice — a 3 meses a = 8,735, det normalizado 74,65, `Qr` 6,73,
p 0,0346; a 6 meses 34,4 e 0,1051; a 12 meses 18,0 e 0,2549.

**A regra mista não muda o veredito.** O câmbio do painel é média mensal, não última
cotação. Refazendo o sistema mensal com o câmbio também em fim de mês — a regra "último
valor" uniforme nas três séries — p vai a 0,5445 / 0,8362 / 0,5703 nos vértices de 3, 6 e
12 meses, e o determinante normalizado fica em 0,10 / −0,13 / −0,33. Continua sem rejeitar
em nenhum vértice, e continua a ordens de grandeza do 40,8 diário. Checagem de sessão, não
publicada.

### Duas sensibilidades que precisam viajar junto

⚠ **O vértice decide, no diário.** De 3 para 6 e 12 meses, p vai de 0,0033 a 0,0844 e
0,1474. Não é acaso: a razão de variância do DI cai com a maturidade nos próprios GRG
(4,53 / 3,40 / 2,33 na Tabela 1 deles), e o teste perde junto. Não é possível apresentar a
linha diária sem dizer em que vértice ela vale. No mensal nenhum vértice chega perto.

⚠ **A correção de curtose do teste decide o caso diário.** O `Qr` divide pela curtose média
dos resíduos em cada regime, que é o ponto de Lütkepohl et al. (2021): sem ela a aproximação
qui-quadrado não vale sob não-normalidade e o teste rejeita demais. Com excesso de curtose
de 12,7 no regime sem reunião, a correção divide a estatística por 4,9. Sem ela, **as três
células diárias rejeitariam**. A corrigida é a válida; as duas estão em
`output/het/het_conditions.md`.

## As funções de resposta, em quarentena

`het_rigobon/02_irf.R` constrói as respostas das três vertentes com bandas por
reamostragem dentro de regime, 500 réplicas, que é o que Rigobon faz na seção empírica.
Impacto de um aperto de 50 p.b., com banda de 90%:

| Série | Diário, 3m (identificado) | Diário, 6m | VAR mensal (sem identificação) | Fatorial | Proxy |
|---|---|---|---|---|---|
| Câmbio BRL/USD (%) | **−1,53** | −1,28 | −4,02 (3m) / +0,93 (6m) | +1,52 | +3,23 |
| CDS 5 anos (p.b.) | **−4,16** | −4,11 | −80,5 (3m) / −1,10 (6m) | +9,60 | +30,5 |

Na célula identificada o real **aprecia** e o CDS **fecha** — o sinal de GRG nas duas
séries, contra depreciação e alargamento no proxy de produção. O VAR mensal **não está
identificado em nenhum vértice**, e o ponto dele não é interpretável: com λ₁ ≈ λ₂ a coluna
é arbitrária, e é por isso que o vértice de 3 meses devolve −80 p.b. de CDS. As inovações
fatoriais carregam o sinal do DFM, mas também não rejeitam a 5%. Respostas sem
identificação são impressas como tais e não podem ser lidas como direção e magnitude.

## A réplica de GRG segue valendo

`het_rigobon/01_daily_grg.R` não mudou de veredito. As razões de variância reproduzem as
deles uma a uma e o ponto publicado cai no IC de 95% nas seis células de câmbio e CDS. O
câmbio sai menor em módulo (−3,08% contra −5,10% por 100 p.b. no vértice de 3 meses), e as
janelas móveis explicam por quê: o coeficiente cresce em módulo ao longo do tempo nos dois
painéis, e esta amostra começa em 2010.

**O CDS de GRG fecha, não é nulo.** A Tabela 5 deles traz −3 / −5 / −11 p.b. por 100 p.b.
nos vértices de 3, 6 e 12 meses, o longo com t ≈ 2,2, ainda que a prosa diga que o CDS
"não parece ser afetado". A réplica dá −11,96 e −10,37 p.b. ⚠ A unidade é **inferida**, não
declarada, por dois testes de escala documentados em `het_rigobon/_common.R`. A §2 do
artigo, que repetia "não apresenta resposta sistemática", foi corrigida nesta rodada.

## O que saiu, e não volta como estatística reportada

Cinco números e tudo que se apoiava neles:

- teste de proporcionalidade de Mauchly (`p_boot` 0,0508, LR 135,1290, varredura de 37
  células com Holm);
- gap λ₁−λ₂ e o critério de 0,20;
- `ratio_dir` (1,96 / 3,73 / 1,74) e `rank1_share` com seu valor sob H₀;
- placebo de permutação.

Saiu também o conjunto de séries que o projeto chamava de "linha diária publicada" —
DI de 2 anos e Ibovespa não são de GRG — e a **quarta vertente** da rodada de 2026-09-21 — o
VAR sobre a soma mensal das variações Qua→Qui — e toda a decomposição do mecanismo de
agregação que só ela sustentava: a separação dentro/entre semanas, a réplica de uma semana
por mês, o termo de contagem de semanas e a sensibilidade ao início da amostra. **A
afirmação de que a agregação temporal vira o sinal foi revertida do registro.**

E saiu, por decisão do autor no fim da mesma rodada, **a soma das janelas Qua→Qui dentro do
mês de calendário**, que era o que restava daquela vertente: os números dela estão listados
como descontinuados na seção da agregação, acima. Com ela sai também a afirmação
**oposta** — a de que a agregação temporal *não* é o obstáculo e a variação de calendário
*é*. Nenhuma das duas tem medida que a sustente agora, e o paper não afirma nem uma nem a
outra.

## Arquivos

| arquivo | o que mudou |
|---|---|
| `R/identification/het_tests.R` | reescrito sobre o estimador e o teste do `svars`; entram `fit_het_cv()`, `regime_indicator()`, `rigobon_rank_stat()`, `het_column_closed_form()`, `qr_without_kurtosis()` e `build_weekly_changes()`; saem as cinco estatísticas retiradas |
| `script/het_proportionality.R` → `script/het_conditions.R` | único produtor da `tab:het_frequency`; escreve `output/het/het_conditions*` e o painel diário |
| `het_rigobon/` | reduzida a três vertentes; `het_rank1.R` apagado, `01_daily_grg.R` e `02_irf.R` reescritos |
| `paper/paper_anpec.tex` | §5.1 e `tab:het_frequency` reescritas; resumo PT/EN, introdução, §2 e conclusão ajustados — nenhum deles atribui a queda da condição à agregação nem à variação de calendário |
| `paper/references.bib` | `lutkepohl2021` e `lange2021` (23 chaves citadas, orçamento 25) |

## Guardas

- Os cinco impactos de produção saíram bit-idênticos; as seis checagens de
  `script/validation/` passam.
- `Λ` reproduz os autovalores generalizados de `(Σ_C, Σ_NC)`: desvio relativo máximo
  `6,1e-06` nos sete sistemas.
- O `rawimp` local reproduz o ponto de `compute_irf_dfm()`: desvio **0** exato.
- DFM na célula de produção, raiz máxima `0.9836766921623673`.
- Rota de covariância e forma IV de Rigobon–Sack batendo a `1e-10` nas células de GRG.

## Dependência nova

`svars` 1.3.12, com `copula` e o pacote R `gsl`. `gsl` exige os cabeçalhos da GSL do
sistema, que não estavam instalados; foram extraídos de `libgsl-dev` para um prefixo local
só para a compilação. O `copula.so` resultante liga contra a `libgsl.so.27` do sistema, que
já existia, então o prefixo não é necessário depois. Se `library(svars)` falhar num clone
novo, é esse o passo a repetir.
