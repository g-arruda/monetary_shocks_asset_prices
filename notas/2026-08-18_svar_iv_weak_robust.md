# O sinal sobrevive à inferência weak-IV; a magnitude do DFM, não

> **SUPERADA/INVÁLIDA — VAR estimado em séries não estacionárias.** Rodada de 2026-08-18. Proxy `z_jk_bs_purif`, normalização em
> `yield_6m` a +50 pb (0,005), amostra completa 2013-01 a 2025-09, 60 meses com
> surpresa não-nula dentro dos 147 (ou 149) meses de resíduo. **Nenhum fator é
> estimado aqui:** o objeto é um proxy-SVAR de observáveis, e é justamente por
> isso que ele admite inferência robusta a instrumento fraco.
> Conjuntos de confiança Anderson-Rubin/MOSW por inversão de teste, analíticos,
> sem bootstrap. Cinco células: três VARs de 4 variáveis em `p = 6`
> (fidelidade a Alessi-Kerssenfischer, mesma célula de `script/model_var.R`) e
> dois VARs conjuntos de 5 variáveis em `p = 4` (o §37.2 do checklist).
> Módulo novo `R/identification/weak_iv_ar.R`; driver `script/model_var_weak_iv.R`;
> validação `script/validate_mosw_ar.R`.
> Saídas: `output/var/svar_iv_weak_robust.{csv,md}` e
> `svar_iv_weak_robust_diag.csv`.
> **Produção não muda.** O smoke test do `CLAUDE.md` reproduz bit a bit
> (`0.0050000000000000001` / `0.0074300592008910019` / `0.0077611464176508358` /
> `-1.7226766564462794` / `0.15792806572512938`), e o ponto do VAR cruza com
> `output/var/var_benchmark_irf.csv` a **4,26e-14**.

## 1. A pergunta e o veredito

Prioridade 1 do julgamento de `relatorio/checklist_problemas_sdfm_weak_iv.md`
(§12, §36-41). A produção tem `ξ_mp = 6,27` na amostra cheia, abaixo da
referência convencional de 10, e a única inferência do DFM é o wild bootstrap
68/90 — que, como diz o §17, **não** transforma uma razão fracamente
identificada num estimador regular. O checklist pede que se estime, com a
**mesma** proxy, um modelo onde a teoria weak-IV robust existe, e se reporte
conjuntos de confiança por inversão.

**Veredito, em cinco partes:**

1. **O sinal do risco soberano sobrevive em toda especificação.** No impacto,
   `cds_5y` e `embi_perc` rejeitam `H₀: IRF(0) ≤ 0` a 90% nas **três**
   especificações em que aparecem. Nenhum conjunto AR do bloco-manchete é
   ilimitado: as 858 células da saída são 843 intervalos limitados e 15
   singletons, e os 15 são a célula de normalização.
2. **O câmbio depende da especificação, e essa é a variável inconveniente.** No
   impacto, `cambio_usd` **não** rejeita no VAR de 4 variáveis
   (AR90 `[-0,0150; 0,0970]`, ponto 0,0466), mas rejeita nos dois VARs
   conjuntos de 5 variáveis (`[0,0235; 0,160]` com CDS, `[0,0522; 0,194]` com
   EMBI). Duas de três.
3. **O prêmio de instrumento fraco é modesto e cai inteiramente sobre o
   câmbio.** No mesmo VAR, mesma proxy, mesmos dados, o conjunto AR é
   **1,20 a 2,02×** mais largo que a banda de 90% do wild bootstrap (mediana
   **1,422**), e o veredito de exclusão de zero coincide em **11 de 15** pares.
   As **quatro** discordâncias são **todas** `cambio_usd`, e todas na direção
   de o bootstrap declarar significância que o AR não sustenta.
4. **A magnitude do DFM não sobrevive; o sinal sim.** O ponto do DFM cai dentro
   do conjunto AR do VAR pequeno em **8 de 15** pares. As sete exceções são as
   **cinco** de `cds_5y` e as duas primeiras de `cambio_usd`. Isso **não** é
   teste do DFM — o conjunto é de confiança para a IRF *do VAR* — mas é a
   medida de quanto os dois modelos discordam em magnitude na mesma
   normalização.
5. **E o bloco core não é só ruído**, contra o que o §36.5 previa:
   `ind_transformacao` **cai** no impacto com o conjunto excluindo zero em 4 das
   5 células, e a corcova de `price_ipca` em `h = 4` reaparece em 2 delas. Ver
   §6.

## 2. Por que isto é legítimo aqui e não era no DFM

O Anderson-Rubin foi retirado do DFM em 2026-08-12
(`registro/historico_decisoes.md` §7) por **duas** razões, e só a primeira
desaparece aqui.

A primeira era teórica: a covariância plug-in condicionava em fatores,
loadings, escalas e espaço dinâmico **estimados**, e não havia teoria que
cobrisse esses objetos gerados sob proxy localmente fraca. Num VAR de
observáveis ela não existe — `(vec(A), Γ)` são os únicos objetos estimados, e
são exatamente o par que `WHat` cobre. Por isso o módulo novo **não** restaura a
generalização `Load`/`Inner`/`d0` do código retirado, que era o que permitia
apontá-lo ao espaço de fatores: a assinatura aceita um seletor de **coordenada**,
e o mau uso no DFM fica impossível por construção em vez de por convenção.

A segunda era um defeito de solver, e essa é o trabalho novo. A classificação de
`MSWfunction.m:119-151` usa desigualdades estritas e não tem tolerância, então
`a = 0` (caso linear), `a = b = 0` (caso constante) e `Δ = 0` (tangência) caem
todos no ramo residual "reta toda". O auditor externo refutou **quatro** linhas
do oráculo por isso (`pareceres/2026-08-12_auditoria_anderson_rubin_dfm.md:216-226`).
`solve_quadratic_le_zero()` resolve a desigualdade por completo, com tolerância
relativa à escala dos coeficientes e raízes na forma estável
`q = -(b + sign(b)√Δ)/2`, e acerta os **dez** casos do oráculo — os cinco que
refutavam a rotina retirada inclusive.

**A célula de normalização é a demonstração disso em dado real.** Em
`(nvar, h = 0)` vale algebricamente `chat = scale²·ahat` e `bhat = -2·scale·ahat`,
logo `Δ = 0` exatamente e o conjunto AR é o singleton `{scale}`. É por isso que o
código oficial sobrescreve os limites à mão (`MSWfunction.m:156-158`): a cascata
deles não sabe exprimir tangência. O solver novo classifica essa célula como
`singleton` em `{1}` nos quatro blocos do petróleo e em `{0,005}` nas cinco
células de produção, **sem** correção manual.

## 3. Validação: 4 × 63 células do código oficial

`script/validate_mosw_ar.R` roda contra `output/validation/olea_oil_fixture.rds`,
que sobreviveu ao corte de 2026-08-12 e carrega a saída AR inteira da aplicação
do petróleo de Kilian (2009) — `ahat`, `bhat`, `chat`, `casedummy`,
`MSWlbound/ubound`, limites de delta-method, IRF e erro-padrão plug-in — em 68 e
95, cumulativo e não.

| objeto | desvio |
|---|---|
| forma reduzida reestimada (`eta`, `AL`) | 8,4e-11 / 2,4e-12 |
| `mosw_marep` vs transcrição literal de `MARep.m` | 8,3e-16 |
| `WHat` (relativo) | 2,4e-13 |
| `Gamma` | 7,8e-13 |
| `Waldstat` (ξ₁ = 4,398794) | 1,6e-13 |
| coeficientes, limites MSW, delta-method e plug-in, pior dos 4 blocos | **1,1e-11** |
| `casedummy` divergente | **0 de 62**, nos quatro blocos |

O fixture tem `casedummy == 1` nas 63 células, então a parte A **não exercita
nenhum ramo degenerado** — é a parte B, as dez triplas sintéticas do oráculo,
que fecha a condição de reabertura do §7. Também roda uma transcrição literal
de `MARep.m` para conferir `mosw_marep`, no mesmo padrão de
`script/validate_hac_kernel.R`.

## 4. A especificação do checklist é inviável em `p = 6`, e isso é resultado

O §37.2 pede `Y = [DI_{6m}, FX, CDS, π, y]'`. Em `p = 6` isso não roda, pelo
critério dos próprios autores: o momento HAC de `CovAhat_Sigmahat_Gamma.m` tem
dimensão `n²p + n·m + n·k` e precisa ser **menor** que `T`.

| célula | n | p | dim HAC | T | viável |
|---|---|---|---|---|---|
| 4 variáveis, AK | 4 | 6 | **104** | 147 | sim |
| 5 variáveis, conjunta | 5 | 4 | **110** | 149 | sim |
| 5 variáveis, `p = 6` (§37.2 literal) | 5 | 6 | **160** | 147 | **não** |

`mosw_rform_cov()` aborta com a conta impressa se a condição falhar, em vez de
devolver uma `WHat` singular. A secundária roda em `p = 4`, e a comparação
`p = 6` contra `p = 4` fica confundida com `n = 4` contra `n = 5` — declarado,
não escondido.

## 5. Os números

`ξ` na direção da normalização, e a comparação com o DFM:

| célula | n | p | ξ_var | F_rob | max\|λ\| |
|---|---|---|---|---|---|
| `ak4_p6:cambio_usd` | 4 | 6 | **10,231** | 18,951 | 0,9669 |
| `ak4_p6:cds_5y` | 4 | 6 | 8,952 | 20,230 | 0,9621 |
| `ak4_p6:embi_perc` | 4 | 6 | 7,911 | 18,410 | 0,9603 |
| `joint5_cds_p4` | 5 | 4 | 7,163 | 18,607 | 0,9932 |
| `joint5_embi_p4` | 5 | 4 | 6,898 | 17,140 | 0,9918 |
| *DFM de produção* | — | 6 | *6,271* | *10,121* | *0,9649* |

**As cinco células são mais fortes que o DFM na mesma direção**, e uma
(`cambio_usd`) passa de 10. Todas passam de 3,84, que é por que nenhum conjunto
AR sai ilimitado. A leitura correta disso é estreita: o VAR pequeno tem `q = n`
inovações contra as 5 do DFM, então a mesma proxy explica uma fração maior de um
espaço menor — é aritmética de dimensão, não evidência de que a proxy seja melhor.

Impacto (`h = 0`), conjunto AR de 90%:

| variável | especificação | ponto | conjunto AR 90% | rejeita `≤ 0` |
|---|---|---|---|---|
| `cambio_usd` | 4 var, `p=6` | 0,0466 | `[-0,0150; 0,0970]` | **não** |
| `cambio_usd` | 5 var CDS, `p=4` | 0,0782 | `[0,0235; 0,1600]` | sim |
| `cambio_usd` | 5 var EMBI, `p=4` | 0,1002 | `[0,0522; 0,1940]` | sim |
| `cds_5y` | 4 var, `p=6` | 13,998 | `[4,009; 25,334]` | sim |
| `cds_5y` | 5 var, `p=4` | 11,803 | `[1,757; 22,800]` | sim |
| `embi_perc` | 4 var, `p=6` | 0,1414 | `[0,0483; 0,2812]` | sim |
| `embi_perc` | 5 var, `p=4` | 0,1123 | `[0,0290; 0,2430]` | sim |

Em `h = 0..4`, rejeitam a 90%: **7 de 15** na de 4 variáveis, **4 de 10** na
conjunta com CDS, **9 de 10** na conjunta com EMBI. Por variável na de 4
variáveis: `cambio_usd` 1 de 5, `cds_5y` 2 de 5, `embi_perc` 4 de 5 — e
estender para `h = 0..12` não acrescenta nenhuma rejeição.

O DFM, para comparação na mesma normalização: `cambio_usd` 0,158,
`cds_5y` 32,54, `embi_perc` 0,262, os três sig90 no impacto. A razão
DFM/VAR no impacto é **3,4×** no câmbio, **2,3×** no CDS e **1,9×** no EMBI —
coerente com a razão mediana de 2,32 que
`notas/2026-07-31_benchmark_var_vs_dfm.md` já tinha medido no impacto, e que
aquela nota atribuiu ao desenho, não a defeito.

## 6. O bloco core, que o §36.5 previu largo e não é só isso

O §36.5 do checklist antecipa que os conjuntos venham informativos no bloco
financeiro e largos demais em atividade, inflação e crédito, e diz que esse
resultado seria bom para o artigo. **É quase o que acontece, com duas exceções
que precisam ser reportadas porque não são as previstas.**

Nas cinco células, em `h = 0..4` e a 90%, o bloco core produz **seis** conjuntos
que excluem zero, de 50 possíveis:

- **`ind_transformacao` no impacto, em 4 das 5 células**, sempre com sinal
  **negativo** e sempre por pouco: `[-3,214; -0,087]`, `[-3,772; -0,067]`,
  `[-3,573; -0,097]`, `[-4,253; -0,255]`. A quinta (`ak4_p6:cds_5y`) não exclui,
  `[-2,962; 0,153]`. É queda de atividade no impacto identificada sob inferência
  robusta a instrumento fraco — a favor da leitura contracionista, e não algo
  que o checklist previa.
- **`price_ipca` em `h = 4`, em 2 das 5 células**, com sinal **positivo**:
  `[0,014; 0,184]` e `[0,012; 0,191]`. É a corcova de preços que
  `notas/2026-08-18_precos_cross_instrumento.md` já mediu no DFM e que a §4.5
  descreve sem chamar de *price puzzle*; ela reaparece num sistema de quatro
  variáveis, sem fatores, e sobrevive à inferência weak-IV em duas células.

Fora esses seis, os 44 conjuntos restantes do core contêm zero, e nenhum
horizonte `h ≥ 1` de `ind_transformacao` exclui. A leitura do §36.5 continua
valendo em substância — a precisão está concentrada no impacto e no bloco
financeiro —, mas escrever "os conjuntos são largos demais em atividade e
inflação" seria falso no impacto e no `h = 4` do IPCA.

⚠ O bloco core é o **mesmo** conjunto de três variáveis repetido em cinco
sistemas que compartilham dados e proxy. As cinco células de
`ind_transformacao` no impacto **não** são cinco evidências independentes, e
nenhuma correção de múltiplos testes foi aplicada a nada nesta rodada.

## 7. A redação que isto autoriza, e a que não autoriza

Sob o §36.2 do checklist, e com a regra de leitura fixada **antes** dos números
(rejeita `H₀: IRF(h) ≤ 0` a 5% unilateral quando o conjunto AR de 90% está
contido em `(0, ∞)`; conjunto que contém `-∞` nunca rejeita):

**Autorizado, para o risco soberano:** *o padrão central de abertura do risco
soberano no impacto é robusto à inferência weak-IV numa especificação
alternativa de menor dimensão, e a coincidência não vem de bandas mais
generosas — o conjunto AR é 1,4× mais largo que o bootstrap e ainda assim
exclui zero.*

**Autorizado, para o câmbio, mas só assim:** *a depreciação no impacto rejeita
`IRF ≤ 0` nas especificações conjuntas de cinco variáveis, mas não na de quatro,
onde o conjunto AR de 90% contém zero por pouco (`[-0,0150; 0,0970]`).* O
câmbio é a única variável onde a inferência weak-IV robust muda o veredito em
relação ao wild bootstrap, e as quatro discordâncias da tabela de comparação são
todas dele.

**Proibido:** dizer que o SVAR **prova** que o SDFM está certo (§36.2). O SVAR
não valida a dinâmica do SDFM; dá evidência independente sobre o mesmo fato
empírico, num sistema com informação muito menor.

**Proibido:** ler não-rejeição como invalidação do SDFM. O VAR de 4 variáveis
sofre missing information, que é a motivação inteira do desenho de fatores. O
que a não-rejeição do câmbio mata é a alegação de **precisão**, não a estimativa.

**Proibido:** apresentar isto como resposta à objeção fiscal. §39: weak-IV
robustness **não é** validade do instrumento. SVAR e SDFM usam a **mesma**
proxy, então uma proxy contaminada por notícia fiscal erra nos dois, junto e na
mesma direção. Esta rodada responde ao referee que diz "a proxy é fraca". O que
diz "a proxy é fiscal" continua endereçado pelo leave-one-out e pelo preditor
fiscal predeterminado, os dois abertos no Tema B.

## 8. Ressalvas que não somem

- ⚠ **A comparação `p = 6` × `p = 4` está confundida com `n = 4` × `n = 5`.** As
  duas mudam juntas porque a restrição de dimensão não permite separá-las nesta
  amostra. Nenhuma diferença entre as duas especificações pode ser atribuída a
  `p` ou a `n` isoladamente.
- ⚠ **O VAR conjunto de 5 variáveis é quase instável**, `max|λ| = 0,993` contra
  0,960-0,967 nos de 4. Não é explosivo, mas está mais perto da fronteira, e
  `ibc_br` já produziu um VAR explosivo neste repositório
  (`notas/2026-07-31_benchmark_var_vs_dfm.md`).
- ⚠ **A dimensão do momento HAC é 104 contra `T = 147`**, razão 0,71 — pior que
  a da aplicação do petróleo dos autores (231 contra 356, razão 0,65). A `WHat`
  é não-singular mas é estimada com folga pequena, e nenhuma simulação de
  tamanho foi rodada nesta amostra.
- ⚠ **`ξ_var > ξ_mp` nas cinco células não é evidência de que a proxy seja mais
  forte** do que se pensava; é consequência de o VAR ter menos inovações que o
  DFM. Não usar como argumento sobre o instrumento.
- ⚠ **`NWlags = 0` (Eicker-White)** em todas as células, como toda estatística
  de força do repositório. A agregação mensal de produção é a soma dentro do
  mês, que não induz MA(1); um esquema à Gertler-Karadi exigiria Bartlett.

## 9. O que fica aberto

- A **§5 do paper** não foi escrita. A tabela e a leitura acima precisam virar
  uma subseção `sec:weak_iv`, e o item está no Tema A de `pendencias.md`.
- O **LP-IV weak-robust** do §37.3 do checklist não foi rodado. Só agora tem
  consumidor: se o câmbio rejeitar no LP-IV, a discordância entre as duas
  especificações de VAR ganha um terceiro voto. Item novo no Tema B.
- A comparação com o bootstrap é feita **só na célula de 4 variáveis**, porque é
  a única que `output/var/var_benchmark_irf.csv` cobre. As conjuntas de 5
  variáveis não têm contraparte de bootstrap, e rodá-la custaria as ~15 minutos
  de `model_var.R`.
