# `het_rigobon/` — identificação por heterocedasticidade, rodada exploratória

> **CURRENT — 2026-09-22.** Pasta auto-contida, reduzida a três vertentes nesta data
> por decisão do autor. Importa `R/` em modo leitura, lê o painel semanal que
> `script/het_conditions.R` escreve, e escreve só em `het_rigobon/output/`.
> `03_atenuacao.R`, de 2026-09-22, é **diagnóstico aritmético**, não vertente: mede
> a diluição temporal prevista ao lado da razão mensal observada e não produz IRF.
>
> **A identificação por heterocedasticidade segue abandonada para o artigo**
> (decisão de 2026-08-17). Nada aqui entra no paper como corroboração, perna de
> robustez ou estimativa alternativa sem decisão separada do autor.

## Onde mora o quê

O **diagnóstico é código vivo**, não fica nesta pasta: a condição de identificação é
testada em `script/het_conditions.R`, porque a §3.3 e o Anexo B a publicam. O que fica aqui é o que
**não** entra no artigo — o confronto com os números publicados de GRG e as funções de
resposta.

## O teste é o do pacote `svars`

Desde 2026-09-22 a bateria é só a do pacote. Rigobon (2003) enuncia **uma** condição de
identificação, a de posto, eq. (6), e diz que ela falha se e somente se as covariâncias
dos dois regimes forem proporcionais. Na forma multivariada isso é a distinção entre os
autovalores de `Λ` em `Σ_NC = BB'`, `Σ_C = BΛB'`. O estimador é
`svars:::IdentifyVolatility()` e o teste é o `Qr` sequencial de Lütkepohl, Meitz,
Netšunajev e Saikkonen (2021), `svars:::cv_ident_test()` — o que `id.cv()` reporta com
dois regimes.

**Saíram da bateria** o teste de proporcionalidade de Mauchly, o gap λ₁−λ₂, a razão ao
longo da direção principal, a participação rank-1 e o placebo de permutação. Eram
construção do projeto, não da literatura.

⚠ **`svars::id.cv()` não é chamado diretamente.** Seu caminho para um indicador de regime
recorrente está quebrado: `R/id.cv.R:177` seleciona as linhas de reunião com `u[SB, ]`, e
chegar nesse ramo exige `SB` numérico (`:149`), então um vetor 0/1 indexa por posição e a
covariância do regime com reunião volta como a primeira linha repetida. A estimativa
colapsa para `Λ = I` sem aviso. `fit_het_cv()` chama o estimador como o próprio `id.cv()`
o chama internamente, com os índices de regime de `id.cv.R:277-278`. As guardas são que
`Λ` reproduz os autovalores generalizados de `(Σ_C, Σ_NC)` e que `BB'` e `BΛB'`
reproduzem as covariâncias por regime.

## As séries são as de GRG, nos dois lados

⚠ **Correção de 2026-09-22.** O conjunto que o projeto chamava de "linha diária publicada"
— DI de 3 meses, DI de 2 anos, Ibovespa e câmbio — **não é o de GRG**. A Tabela 1 deles traz
o DI (1m, 3m, 6m, 12m), o *breakeven* de inflação (1, 2, 3 e 5 anos), o câmbio BRL/USD e o
**CDS soberano de 5 anos**. Sem Ibovespa, sem vértice de 2 anos. Os dois sistemas — diário e
mensal — passaram a usar as séries deles.

A quarta série de GRG, a expectativa, é um diferencial entre títulos indexados e nominais.
O projeto só tem a medida do Focus, que é *survey* — eles dizem "market-based (not survey
data)" — e cuja variação diária é exatamente zero em 23% dos dias, porque o Focus sai uma
vez por semana. Ela fica fora, e a lacuna fica declarada. Construir o breakeven de NTN-B e
LTN é uma rodada de dados, registrada como pendência.

O vértice do DI entra como célula, porque é a dimensão em que os próprios GRG variam e
porque no diário ele decide.

## Veredito

**1. A réplica diária bate com GRG.** As razões de variância reproduzem as deles uma a uma
(DI 6m 3,45 contra 3,40; câmbio 0,98 contra 0,92; CDS 0,89 contra 0,85), e o ponto publicado
cai no IC de 95% nas seis células comparáveis de câmbio e CDS. O câmbio sai menor em módulo
(−3,08% contra −5,10% por 100 p.b. no vértice de 3 meses) e as janelas móveis explicam por
quê: o coeficiente cresce em módulo ao longo do tempo nos dois painéis, e esta amostra começa
em 2010.

**1b. O CDS de GRG fecha, e a réplica bate nele.** A Tabela 5 traz −0,03 / −0,05 / −0,11 nos
vértices de 3, 6 e 12 meses, **em ponto percentual** — −3 / −5 / −11 p.b., o de 12 meses com
t ≈ 2,2. A prosa deles diz que o CDS "não parece ser afetado"; a tabela traz um fechamento.
A réplica dá −11,96 p.b. em 3 meses e −10,37 em 12.
⚠ A unidade do CDS em GRG é **inferida, não declarada** — dois testes de escala, ambos
documentados em `_common.R`.

**2. As mesmas três séries identificam no diário e não identificam no mensal.** O teste `Qr`
rejeita `λ₁ = λ₂` no diário, no vértice de 3 meses (p 0,0033, λ₁ 7,55 contra 1,36). O VAR
mensal nas **mesmas três séries** não rejeita em nenhum vértice (p 0,917 a 0,988): os dois
maiores autovalores praticamente coincidem (2,51 contra 2,36) e o determinante normalizado
de eq. (6) cai de 40,8 para −0,03. É proporcionalidade, o modo de falha que Rigobon aponta.
As cinco inovações fatoriais não rejeitam a 5% (p 0,0761).

**3. O que separa as duas linhas não está separado.** Do diário para o mensal mudam a
frequência **e** o objeto medido — janela de anúncio contra variação de calendário — ao
mesmo tempo, e nada mede uma sem a outra. ⚠ A única agregação mensal é a do painel, a
última cotação do mês de referência; o objeto que somava as janelas Qua→Qui dentro do mês
foi retirado em 2026-09-22 por decisão do autor, com todos os seus números.

**4. Na célula identificada o sinal é o de GRG, nas duas séries.** Um aperto de 50 p.b.
**fecha** o CDS 4,2 p.b. e **aprecia** o real 1,53%, contra +30,5 p.b. e +3,23% do proxy de
produção. O VAR mensal **não está identificado em nenhum vértice** e seu ponto não é
interpretável — com λ₁ ≈ λ₂ a coluna é arbitrária, e é por isso que o vértice de 3 meses
devolve −80 p.b. de CDS. As inovações fatoriais dão +9,6 p.b. e +1,52%, o sinal do DFM, mas
também não rejeitam a 5%.

⚠ **O vértice decide, no diário.** De 3 para 6 e 12 meses p vai de 0,0033 a 0,0844 e 0,1474
— a razão de variância do DI cai com a maturidade nos próprios GRG (4,53 / 3,40 / 2,33), e o
teste perde junto.

⚠ **A correção de curtose do teste decide o caso diário.** Com excesso de curtose de 12,7 no
regime sem reunião, ela divide a estatística por 4,9. Sem ela as três células diárias
rejeitariam. A corrigida é a válida — é o ponto de LMNS (2021) —, mas as duas juntas são o
que distingue um sistema sem rotação de covariância de um cujas caudas custaram potência ao
teste. Os dois números estão em `output/het/het_conditions.csv` (`qr_12` e `qr_12_nk`).

## Arquivos

| arquivo | o que é |
|---|---|
| `_common.R` | importa `R/` em modo leitura, caminhos, constantes e os números publicados de GRG |
| `01_daily_grg.R` | confronto com as Tabelas 1, 4/5 e 8 de GRG, no painel semanal reconstruído |
| `02_irf.R` | as funções de resposta das três vertentes, com bandas de bootstrap dentro de regime |
| `03_atenuacao.R` | diagnóstico da agregação: diluição prevista `1 + (r_d − 1)/n` contra a razão mensal observada, e o mesmo estimador sobre a variação mensal; não produz IRF |
| `output/01_daily_grg.md`, `output/02_irf.md`, `output/03_atenuacao.md` | relatórios congelados em 2026-09-24: os scripts não os escrevem mais, e os números estão nos CSVs abaixo |
| `output/daily_changes_rebuilt.csv` | o painel semanal 2010--2025, 9 séries |
| `output/grg_*.csv` | razões de variância, coeficientes e janelas móveis; `grg_rolling.csv` traz também a janela 2010:2024 do câmbio, a mais próxima da amostra de GRG |
| `output/irf_daily.csv`, `irf_var.csv`, `irf_factors.csv` | trajetórias das três vertentes, com `identificado` (o `Qr` de `λ₁ = λ₂` rejeita a 5%) |
| `output/irf_impact_*.csv` | impactos lado a lado, contra o proxy de produção, com o mesmo veredito |
| `output/irf_comparison.pdf` | het contra proxy nas quatro séries |
| `output/03_atenuacao.csv` | a tabela de diluição das cinco séries, com a razão dos resíduos do VAR(4) mensal |
| `output/03_atenuacao_qr.csv` | o `Qr` do mesmo estimador sobre a variação mensal, `p = 1` |

## Como rodar

```bash
Rscript script/het_conditions.R    # o diagnostico, codigo vivo: tem de rodar primeiro
Rscript het_rigobon/01_daily_grg.R
Rscript het_rigobon/02_irf.R
Rscript het_rigobon/03_atenuacao.R
```

## Guardas que abortam

- Rota de covariância e forma IV de Rigobon–Sack batendo a `1e-10` (01).
- A grade semanal não perdendo nenhuma reunião do Copom (01).
- `Λ` reproduzindo os autovalores generalizados de `(Σ_C, Σ_NC)` a `1e-4` relativo.
- `BB'` e `BΛB'` reproduzindo as covariâncias por regime.
- Nas vertentes já branqueadas, a defasagem sendo formalidade: correlação entre resíduo e
  série acima de 0,98.
- A raiz máxima do DFM igual à de produção a `1e-12` (02).
- O `rawimp` construído na pasta reproduzindo o ponto de `compute_irf_dfm()` — desvio
  medido: **0** exato (02).

## O que a rodada deliberadamente não fez

- **Não** acrescentou ramo `identification = "het"` a `compute_irf_dfm()` ou `main_sdfm()`;
  `.claude/rules/identification.md` guarda esse núcleo.
- **Não** usou os conjuntos Anderson–Rubin, que são específicos do proxy (pedem `Γ = η'Z`).
  No lugar ficam as bandas de bootstrap dentro de regime, que são o que Rigobon faz.
- **Não** manteve a quarta vertente (VAR sobre a soma mensal das variações Qua→Qui), nem a
  decomposição do mecanismo de agregação, nem — desde 2026-09-22 — o escalar que ainda
  media a soma mensal. A comparação antes/depois sobrevive como a linha diária contra a
  linha do painel mensal, em `output/het/het_conditions.csv`. `03_atenuacao.R` mede a
  diluição prevista e a razão mensal lado a lado, mas **não** atribui a queda da condição
  à agregação temporal nem à variação de calendário: para onde o número aponta, não segue
  afirmação.
- **Não** manteve o Ibovespa nem o vértice de 2 anos nos sistemas, porque GRG não os usam.
  O Ibovespa continua reportado par a par no confronto com as tabelas deles, como série
  **extra** e não como série de GRG — é a célula inconveniente e não pode sumir.
- **Não** tocou em `paper/`, `output/irf/` ou em qualquer figura do artigo.
