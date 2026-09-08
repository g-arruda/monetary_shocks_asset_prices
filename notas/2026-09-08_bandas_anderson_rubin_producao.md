# Conjuntos Anderson-Rubin como inferência operacional do DFM

> **CURRENT — 2026-09-08.** Escrita sob a produção corrente: painel de 115
> séries, 2012-03--2025-12, `(r,q,p)=(5,5,4)`, `z_jk_bs_purif` × `yield_6m`,
> choque de +50 pb. Substitui o wild bootstrap como inferência do DFM e supera,
> para esse fim, o que a `2026-08-10_bandas_anderson_rubin` dizia — aquela nota
> continua SUPERSEDED, é de outra vintage `(7,6,6)` com 106 séries e seus
> números não são portáveis. **O paper e `output/irf/irf_section.md` não foram
> tocados** e seguem descrevendo bandas de bootstrap. Corpo gerado:
> `output/irf/ar_bands.{csv,md}`, `ar_bands_summary.csv`,
> `ar_bands_overlay.pdf`. Código: `R/identification/weak_iv_ar.R`,
> `script/ar_bands.R`, `script/validate_mosw_ar.R`.

## Decisão

Por decisão do autor, os conjuntos Anderson-Rubin voltaram e passaram a ser a
inferência operacional do DFM, **no lugar** do wild bootstrap. Isso reverte a
retirada de 2026-08-12. A condição de reabertura registrada em
`historico_decisoes.md` §7 — uma derivação que incorpore a estimação fatorial,
ou reamostragem com cobertura demonstrada — **não foi cumprida**, e a decisão foi
tomada assim mesmo. O §7 guarda a reversão junto com o parecer contrário; esta
nota registra os números.

`production_spec()$inference` é a única autoridade e
`compute_irf_dfm(inference=)` o único interruptor. O default do argumento
continua `"bootstrap"`, de propósito: cinco chamadores vivem em `diagnostics/`,
que não é editável, e precisam manter as bandas contra as quais foram escritos.

## O que voltou, e o que é novo

Não é o código retirado. É a fusão de duas metades que nunca estiveram juntas:

- do módulo retirado (`61e2225`), a generalização `Load`/`Inner`/`d0`, que
  permite mirar o espaço de fatores. Num DFM estático a dinâmica é um VAR nos
  `r` fatores com uma equação de medida acoplada, e a resposta identificada volta
  a ser uma razão de duas formas lineares em `Γ`:
  `λ_{j,h} = scale·(e_j' C_h Γ)/(d0' Γ)`, com
  `C_h = diag(sy) Λ B_h K K'` e `d0 = C_0' e_mp`. A lógica de Fieller carrega
  inteira; a generalização troca o vetor coordenado `e_nvar` pelo vetor geral
  `d0`, e o par `(Γ, e_j)` dentro do Kronecker pelo par `(K K' Γ, sy_j Λ_j)`;
- do módulo VAR-only atual, `solve_quadratic_le_zero()`, que resolve a
  desigualdade por completo. O defeito de classificação que a auditoria de
  2026-08-12 chamou de Prioridade 0 não existe mais.

`d0` deixou de ser argumento: ele é lido da fatia de impacto,
`deriv$C[nvar, , 1]`, que num VAR de observáveis é exatamente `e_nvar` porque
`C_0 = I`. Nenhum argumento distingue os dois casos, e `validate_mosw_ar.R`
confere isso com desvio 0.

Os códigos de transformação passam pelos limites porque `cumimp_transform()` é
monótona crescente em cada um: o código 1 é a identidade, o 6 é `×100`, o 4 é
`(exp(x)−1)×100`. Os que acumulam (2 e 5) usam o **ramo cumulativo** da
inversão, nunca acumulação posterior dos limites; o código 3, que acumula duas
vezes, aborta.

## Validação

| objeto | desvio |
|---|---|
| caminho VAR contra o fixture do petróleo, 68% e 95% | ≤ 1,2e-11 (inalterado) |
| `Load = Inner = I` contra o caminho default (derivadas, limites, `dm_se`, `xi_den`) | **exatamente 0** |
| `d0` contra `e_norm` no VAR | **exatamente 0** |
| ramo cumulativo contra a soma corrida do não-cumulativo | **exatamente 0** |
| ponto AR do DFM contra `ident_ext_instr` | < 1e-10, com parada dura |
| impacto da produção contra `production_spec_impact_smoke.csv` | 9,99e-16 |
| `xi_den` contra `mosw_strength_grid.csv` | 7,51e-12 |

A última linha merece atenção: `xi_den = T·den²/(d0'W₂d0)` sai do bloco `W₂` da
covariância de MOSW, enquanto a grade calcula `xi_mp` por
`compute_factor_space_wald()` com os lags residualizados. São dois caminhos
independentes para o mesmo 6,057014.

## Produção: os conjuntos são limitados

`(5,5,4)`, amostra cheia, `T = 162`, `hac_dim = 135`, `W` de 105 × 105,
ξ_mp = 6,057014. O coeficiente de `λ²` é `T·den² − κ·d0'W₂d0`, constante entre
células, logo o conjunto é limitado em **todos** os horizontes se e somente se
ξ_mp > κ. Com κ = 0,989 / 2,706 / 3,841, as **5.635 células saem `interval`** nos
três níveis (mais o singleton da normalização). Nenhuma semirreta, nenhum
conjunto vazio, nenhuma reta.

O prêmio de instrumento fraco — razão de largura AR / delta-method, que isola a
correção porque as duas bandas compartilham derivada, `W` e condicionamento — é
**1,101 a 68%, 1,382 a 90% e 1,751 a 95%**, quase constante entre séries
(mínimo 1,09, máximo 2,06 a 95%). Ele é quase constante porque a fraqueza mora
no denominador comum da normalização, `d0'Γ`, não no numerador de cada série.

No impacto, a 90%, o fato central do paper sobrevive:

| série | ponto | AR 90% | sig90 |
|---|---|---|---|
| `cambio_usd` | 0,1342 | [0,073; 0,262] | sim |
| `embi_perc` | 0,2433 | [0,096; 0,527] | sim |
| `cds_5y` | 29,91 | [14,674; 60,763] | sim |
| `asset_ibov` | −0,9965 | [−7,902; 4,263] | não |
| `price_ipca` | −0,0436 | [−0,387; 0,104] | não |

A assimetria em torno do ponto vai a 2,08 no câmbio e 2,03 no CDS — uma banda de
Wald vale 1 por construção, e é isso que a inversão acrescenta.

## `(5,2)`: a demonstração que o orientador pediu

Sugestão 5/5 do email de 2026-09-04. Com ξ_mp = 2,339, abaixo de 2,706 e de
3,841, `ahat < 0` e o conjunto deixa de ser limitado:

| nível | topologia |
|---|---|
| 68% | 5.634 `interval` (ξ_mp = 2,34 > 0,989) |
| 90% | 3.429 `two_rays`, 2.205 `real_line` |
| 95% | 852 `two_rays`, 4.782 `real_line` |

No impacto, a 90%, o câmbio sai `(−Inf; −2,701] ∪ [0,258; Inf)` e o CDS
`(−Inf; −760,4] ∪ [64,7; Inf)`. Não é uma banda larga: é a ausência de banda. A
figura recorta a faixa vermelha na escala do painel de produção justamente para
mostrar que ela não delimita nada. `ar_bands_overlay.pdf`.

## O que a troca move — inclusive contra ela

Nas 58 séries pontuadas por `irf_coherence_check.R`, contra a rodada de
bootstrap imediatamente anterior:

| | bootstrap | AR |
|---|---|---|
| sig68 total | 1.021 | 1.897 |
| sig90 total | 329 | 364 |
| sig68, h ≤ 12 | 416 | 461 |
| **sig90, h ≤ 12** | **256** | **159** |

**A leitura honesta não é "o AR aperta" nem "o AR afrouxa".** Nas 115 séries, o
conjunto AR é **mais largo** que a banda de bootstrap em toda faixa de horizonte
(razão mediana 1,40 no impacto, 1,10 a 1,32 nas demais). No horizonte curto isso
se traduz no que se espera: a 90%, h ≤ 12 tem 319 células significativas sob AR
contra 393 sob bootstrap. É o prêmio de instrumento fraco cobrando.

O que inverte o sinal agregado é o horizonte longo. A 90%, de h = 25 em diante o
bootstrap não declara **nenhuma** célula significativa e o AR declara 179. A
razão está na localização, não na largura: a banda percentil do bootstrap se
desloca em relação ao ponto conforme o horizonte cresce — o DGP reestima o VAR
fatorial quase unitário a cada réplica — enquanto o conjunto AR contém o ponto
por construção (0 violações em 5.635 células; a banda de bootstrap a 68% exclui
o próprio ponto em 37). Em `fiscal_primary_balance` a h = 30, o ponto é 4.401,
o AR 68% é [1.641; 7.906] e o bootstrap 68% é [−890; 5.711].

⚠ **Isso interage com uma proibição vigente.** O ganho de significância está
quase todo em h > 12, onde a reversão de médio prazo e a persistência quase
unitária do VAR fatorial são o mesmo objeto. Nada aqui autoriza citar as células
longas novas como evidência separada dessa dinâmica.

Os vereditos de coerência mudam em 6 das 58 séries, todos por afrouxamento da
régua `wrong_sig90`: `credit_outstanding`, `credito_pessoa_fisica` e
`trab_tx_desemprego` saem de `incoerente` para `parcial`; `ibc_br`,
`ind_automoveis` e `vendas_servicos` sobem de `coerente` para `coerente_forte`.
Contagem: `coerente_forte` 25 → 28, `coerente` 3 → 0, `incoerente` 8 → 5,
`parcial` 1 → 4.

## O que a troca custa

Três coisas, e nenhuma delas foi contornada.

1. **A janela pré-COVID perdeu a inferência.** Com 90 inovações ela não sustenta
   a covariância de MOSW em `p = 4`: `hac_dim = 135 ≥ 90`. O ξ_mp pré-COVID de
   8,643436 continua válido como diagnóstico de força; o que sumiu foi a banda,
   que o wild bootstrap produzia. Só caberia em `p ≤ 2`.
2. **`r = q = 8` ficou incompatível com a inferência de produção.** É a sugestão
   4/5 do orientador e não roda em `p = 4`: `hac_dim = 336 ≥ 162`. Só cabe em
   `p = 1` (144). Adotar `(8,8)` como principal passa a exigir, junto, decidir a
   inferência daquela célula.
3. **O condicionamento continua lá.** A covariância plug-in trata `Λ`, `K`, `M` e
   `sy` como conhecidos. O Monte Carlo do parecer de 2026-08-12 (2.000 réplicas,
   semente 20260812) mediu o custo: cobertura de impacto de **78,1%--83,4% com
   fatores estimados**, contra 86,7%--88,3% com fatores observados. Esse número
   não foi refutado, foi aceito.

Em nenhum dos dois primeiros casos o código tenta pseudo-inversa, bootstrap
substituto ou qualquer fallback: a célula aborta e é reportada barrada.

## Congelamentos

`script/fig_section5.R` e `script/fig_weak_iv.R` escrevem em `paper/` e passaram
a abortar sem `--repaint-paper-figures`. O motivo é concreto: o cache
`irf_coherence_cell.rds` agora carrega conjuntos AR, e as legendas do paper
dizem *wild bootstrap*. Em `fig_weak_iv_main.pdf` o problema é maior — o
contraste que a legenda anuncia é bootstrap-no-DFM contra AR-no-VAR, e os dois
lados são AR agora. Repintar é decisão editorial, não re-execução; a rodada está
aberta no Tema A de `pendencias.md`.
