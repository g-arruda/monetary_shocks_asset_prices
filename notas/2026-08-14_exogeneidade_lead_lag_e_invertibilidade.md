# Exogeneidade lead-lag: de quem é a condição, e o que ela testa de fato

> **CURRENT.** Rodada de 2026-08-14 sob a produção de 111 séries
> `drop_setor_externo__eua__credito__imoveis`, `(r,q,p) = (5,5,6)`,
> `z_jk_bs_purif` × `yield_6m`. Script: `diagnostics/01_exogeneidade.R`
> (§1.7 acrescentado nesta rodada). Saída nova:
> `diagnostics/output/t1_7_invertibilidade_granger.csv`. As demais tabelas
> `t1_*` saíram **idênticas** às da rodada anterior — o bloco novo é aditivo e
> entra depois de todos os outros, preservando o consumo da semente.

## 1. A pergunta e o veredito

`registro/pendencias.md` mantinha aberto, desde 2026-08-13, o item de que
`paper_anpec.tex:250` enunciava apenas a condição de exogeneidade
**contemporânea** enquanto `01_exogeneidade.R` já rodava um teste de **leads**
sem lastro citado, aberto a partir da leitura de Braun & Brüggemann. A dúvida
registrada era de procedência: Stock-Watson ou Braun-Brüggemann?

**Veredito, em três partes:**

1. A condição é de **Stock & Watson (2018)**, com nome próprio. Braun &
   Brüggemann é bayesiano e não a fornece.
2. A condição lead-lag **não é exigida pelo estimador de produção**. Ela é da
   LP-IV; o proxy-DFM aqui é SVAR-IV, que paga em invertibilidade.
3. Portanto a perna de **leads não testa exogeneidade — testa invertibilidade**,
   e o teste canônico dessa hipótese, que SW rodam na Tabela 2 deles, **não
   existia no repositório**. Foi implementado nesta rodada e **não rejeita**.

## 2. Procedência: SW sim, BB não

Em Stock & Watson (2018, *EJ* 128, 917--948), §1.3, a **Condição LP-IV** tem três
itens, e o terceiro é `E(ε_{t+j} Z_t') = 0` para `j ≠ 0`, que os autores chamam
literalmente de *lead–lag exogeneity* — o termo aparece na introdução, na §1.3 e
na conclusão. Eles separam as duas metades: a de defasagens é *"restrictive and
strong"*, a de leads é *"generally not restrictive"* quando `Z_t` só contém
variáveis realizadas em `t` ou antes.

**Braun & Brüggemann (BoE Staff WP 961)** não é a fonte. O arcabouço deles é um
B-model aumentado estimado por MCMC (proposta de Arias et al. 2018), e o teste de
exogeneidade do instrumento é um **Bayes factor por Savage-Dickey** sobre
`φ₁ = 0`, uma exclusão **contemporânea** sobre `Φ = E(m_t ε_t')`. Eles assumem
invertibilidade explicitamente (§2.1) e descartam a rota de *lead-lag dynamics*
de Noh (2017) e Plagborg-Møller & Wolf. Além de não fornecer a condição, a
inferência deles não se acopla ao wild bootstrap deste projeto.

Lastro conferido texto a texto, tudo em `artigos/`:

| perna | fonte | chave |
|---|---|---|
| condição lead-lag | SW (2018), Condição LP-IV (iii) | `stockwatson2018` |
| forma testável da metade de **defasagens** | SW: *"Z_t should be unforecastable in a regression of Z_t on lags of Y_t"* | `stockwatson2018` |
| defasagens, segunda fonte | Mertens & Ravn (2013), §V.C | `mertensravn2013` |
| motivo substantivo da purificação | Bauer & Swanson (2023), eq. 7 / Tabela 3 | `bauer2023` |
| **teste de Granger / invertibilidade** | SW §3 remark (iv) + Tabela 2, linha *"VAR Z-GC test"* (Forni-Gambetti 2014) | `stockwatson2018` |

**Nenhuma chave nova** — as quatro já estavam no `.bib` e três já eram citadas no
corpo. O orçamento de 25 chaves fica intacto.

**Descartado com motivo:** *Angelini, Cavaliere & Fanelli* (2024, *J.
Econometrics* 238(2)) enuncia só a exogeneidade contemporânea, e o "teste de
exogeneidade" deles é informal — correlação do proxy com uma série de choque
vinda de outro estudo. A contribuição é um **pré-teste de relevância**, não de
exogeneidade. Não serve de lastro aqui, mas virou item aberto próprio.
⚠ A pasta em `artigos/` grafa "panelli"; o terceiro autor é **Fanelli**.

## 3. O que o estimador de produção realmente exige

SW separam as duas listas, e a diferença não é de grau:

| | relevância | exog. contemporânea | lead-lag | invertibilidade |
|---|---|---|---|---|
| **Condição SVAR-IV** (§2.1) | ✔ | ✔ | — | **exigida** |
| **Condição LP-IV** (§1.3) | ✔ | ✔ | **exigida** | — |

Sobre o SVAR-IV, SW escrevem: *"it does not require lead–lag exogeneity. But to
be valid, this method requires invertibility."*

**Este projeto é SVAR-IV.** `R/modeling/impulse_responde.R:71-73` calcula
`H <- crossprod(Z_mat, rsh_mean0) / crossprod(Z_mat)`, momento puramente
contemporâneo sobre as inovações fatoriais, sem controles de defasagem — o
comentário na linha 98 do próprio arquivo já registra isso. E não precisa deles:
`η_t` é por construção o resíduo da projeção de `F_t` nas suas defasagens, de
modo que uma correlação de `z_t` com `ε_{t-1}` vive no span das defasagens de `F`
e já foi expurgada; choques futuros nunca entram em `η_t`. A propagação vem da
companion, não de momentos de IV em `t+h`.

**Mas é troca, não desconto.** O Theorem 1 de SW — que eles chamam de *"no free
lunch"* — mostra que, se `z` depende de choques defasados e defasagens de `Y`
entram como controle, a LP-IV⊥ vale **se e somente se** a Condição SVAR-IV vale
**e** o sistema é invertível. As duas rotas gastam o mesmo orçamento de
hipóteses, distribuído diferente.

Isso já estava escrito no paper. `paper_anpec.tex:188-192` enuncia a distinção
inteira, inclusive o fecho de que os fatores são o caminho para a invertibilidade
"com a ressalva de que ampliar o número de variáveis não a garante". **A ressalva
era uma promessa que o paper nunca testou** — e é essa lacuna que o §1.7 fecha.

## 4. O que foi rodado

### 4.1 Pernas que já existiam (números correntes, `(5,5)`)

Todas com Wald HC1 e `p` por wild bootstrap sob a nula, 2.000 réplicas.

| bloco | `n` | `k` | `R²` | `p_boot` |
|---|---|---|---|---|
| `z` sobre defasagens dos fatores, L=6 | 147 | 30 | 0,263 | **0,400** |
| idem, L=3 | 150 | 15 | 0,116 | 0,492 |
| idem, L=1 | 152 | 5 | 0,044 | 0,619 |
| `z` sobre `η` defasado, L=6 | 141 | 30 | 0,266 | 0,631 |
| idem, L=3 | 144 | 15 | 0,079 | 0,926 |
| **`z` sobre `η` em LEAD, L=3** | 144 | 15 | 0,076 | **0,711** |
| **`z` sobre `η` em LEAD, L=6** | 141 | 30 | 0,154 | **0,971** |
| bloco externo em retorno, L=6 | 146 | 30 | 0,239 | 0,749 |
| bloco externo em retorno, L=3 | 149 | 15 | 0,135 | 0,199 |

**O bootstrap não é decoração.** Na perna de fatores L=6 o `p` assintótico é
**0,0067** e o de bootstrap é **0,400**. Lido pela assintótica, o instrumento
falharia a exogeneidade retrospectiva a 1%; lido pelo desenho correto para um `z`
censurado em zero, não falha. Esta é a justificativa empírica da escolha que a
§5.1 já declara.

### 4.2 Teste novo: `z` Granger-causa os fatores? (§1.7)

Réplica do que SW rodam na Tabela 2 deles. Para cada uma das `r = 5` equações do
VAR de fatores, F conjunto de que os coeficientes das `L` defasagens de `z` são
nulos, mantendo as `p = 6` defasagens de todos os fatores irrestritas. `p` por
wild bootstrap sob H0 com os resíduos da regressão **restrita**, e Holm sobre as
cinco equações dentro de cada `L`.

Regra fixada antes dos números: **L = p = 6 decide**, casando com a ordem do
próprio VAR; L = 3 é sensibilidade; rejeita se algum `p` de Holm ficar abaixo de
0,05.

| `L` | equação | `F_rob` | `p_asym` | `p_boot` | `p_holm` |
|---|---|---|---|---|---|
| 6 | F1 | 0,769 | 0,596 | 0,594 | 1,000 |
| 6 | F2 | 1,307 | 0,260 | 0,324 | 1,000 |
| 6 | F3 | 1,031 | 0,409 | 0,431 | 1,000 |
| 6 | F4 | 0,919 | 0,484 | 0,560 | 1,000 |
| 6 | F5 | 1,059 | 0,392 | 0,490 | 1,000 |
| 3 | F1 | 0,245 | 0,864 | 0,857 | 1,000 |
| 3 | **F2** | 2,492 | **0,064** | **0,085** | 0,425 |
| 3 | F3 | 1,871 | 0,139 | 0,143 | 0,570 |
| 3 | F4 | 0,641 | 0,590 | 0,583 | 1,000 |
| 3 | F5 | 1,201 | 0,313 | 0,379 | 1,000 |

**Veredito: não-causalidade de Granger não rejeitada.** Em L=6 nenhuma equação
chega perto; o menor `p_boot` é 0,324. Em L=3 a equação de F2 é a única que
flerta com rejeição — `p_asym` 0,064 e `p_boot` 0,085 — e não sobrevive a Holm
(0,425). A condição necessária de invertibilidade sobrevive nas duas
especificações.

**Auto-teste.** Com `X_free` vazio, `robust_subset_test` reproduz
`robust_joint_test` em `F_rob` e `R²` (`stopifnot` no corpo do bloco, passa). É o
mesmo padrão de conferência que `fomc_coincidence.R` usou ao extrair
`wild_coef_test`.

## 5. Ressalvas — todas obrigatórias ao escrever

- **Não-rejeição não estabelece invertibilidade.** É teste de condição
  **necessária**. SW, §3 remark (iv): *"second moments of Y alone cannot
  distinguish invertible from non-invertible processes"* — toda a implicação
  testável vem de momentos que envolvem `Z`.
- **Potência baixa, e isso corta a favor da hipótese nula.** Em L=6 são 30
  regressores livres e 6 testados com `n = 147`. Um teste desenhado assim rejeita
  pouco; a não-rejeição é informativa apenas na medida em que o desenho tinha
  chance de detectar algo.
- **Nenhuma simulação de tamanho foi rodada.** O auto-teste é de equivalência
  algébrica, não de calibragem — não se verificou que `p_boot` é uniforme sob a
  nula neste desenho. Afirmar cobertura correta seria ir além do que foi medido.
- **O `R²` alto das equações (0,92 a 0,996) não diz nada sobre o teste.** Os
  fatores entram em nível e são persistentes, então as próprias defasagens
  explicam quase tudo por construção. O objeto do teste é o bloco de `z`.
- **A ressalva inconveniente sobrevive.** `cambio_usd` defasado continua sendo a
  única variável do bloco externo abaixo de 0,10: `p_boot` **0,064** em retornos
  L=6 e 0,101 em níveis L=6. E as defasagens de câmbio **não** estão entre os
  preditores pré-evento da ortogonalização Bauer-Swanson.
- **Predizibilidade não invalida o proxy-SVAR.** Mertens & Ravn (2013, §V.C) são
  explícitos: *"As long as the proxies correlate contemporaneously with
  unanticipated tax shocks and are otherwise orthogonal to other contemporaneous
  shocks, predictability of the proxies does not violate the identifying
  assumptions."* Eles testam Granger non-causality assim mesmo e purificam o
  proxy por regressão em defasagens como robustez — que é exatamente o papel da
  camada Bauer-Swanson aqui. O teste é sobre a **qualidade** do instrumento, não
  sobre a consistência do estimador.

## 6. Consequências para o texto

- A §3.3 (`:250`) deve enunciar as condições como sendo a **Condição SVAR-IV**,
  dizer que a lead-lag da LP-IV é mais forte e não é exigida, e nomear a
  invertibilidade como o preço — remetendo à §2, que já faz o argumento.
- A §5.1 hoje descreve cinco especificações, **todas de defasagem**, e não
  reporta nem as duas pernas de `η` defasado nem as duas de lead. Deve reportá-las,
  atribuir a metade retrospectiva a SW e Bauer-Swanson com o ponto de
  Mertens-Ravn, e ganhar um parágrafo **rotulado** dizendo que a perna de leads e
  o teste de Granger medem invertibilidade, não exogeneidade.
- Nada de tabela nova: a §5 é prosa com IC90, por instrução do autor.

## 7. O que fica aberto

- **Correlações canônicas VAR pequeno × espaço de fatores.** SW medem isso na
  Tabela 5 do capítulo do *Handbook* (`hom_var_approx.m`, agora disponível em
  `codigos_externos/codigo_sw/`), em nível e em resíduos. É a sustentação direta
  da afirmação de `paper_anpec.tex:238`, hoje apoiada só indiretamente pela
  comparação de IRFs do `model_var.R`. **Não existe no repositório.**
  Complementar ao Granger: a correlação canônica pergunta se o VAR pequeno gera o
  espaço dos fatores; o Granger pergunta se `z` traz informação que o passado do
  VAR de fatores não tem.
- **`amengual_watson()` é tradução sem `validate_*.R`.** A função em
  `R/modeling/factor_estimation.R:168` já rodou em 64 painéis × 2 amostras e é
  ela que sustenta o registro de que o critério automático escolhe `q = 2..3`,
  contra o `q = 5` de produção. Como o critério **discorda** da produção, a
  fidelidade da tradução deixa de ser detalhe: o código de referência de SW
  (`amengual_watson.m`) agora está disponível e permite fechar a lacuna com
  fixture em `output/validation/`, como já foi feito para HAC, GMR e MOSW.
- **LP-IV** (Tema B) é o destino natural desta perna. Rodada a LP-IV, a
  comparação LP-IV × SVAR-IV é o teste de Hausman de invertibilidade da §3 de SW
  — mais forte que o de Granger, porque incide sobre a IRF e não sobre poder
  preditivo.
- **Pré-teste de relevância de Angelini-Cavaliere-Fanelli**, robusto a proxy
  censurada em zero, que é o desenho da máscara JK.
