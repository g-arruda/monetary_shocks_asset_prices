# Confound soberano: o mesmo teste, agora em CDS 5a diário

> ⚠ **Os testes B e D foram removidos em 2026-08-10** de
> `script/jk_sovereign_confound.R`, e a seção correspondente desta nota saiu
> junto. O que a regra de três vias mediu nesta rodada foi o argumento que matou
> o teste, e nada disso é reproduzível ou citável; quem precisar do registro
> recorre ao histórico do git. Em troca, o teste C ganhou na mesma data um
> terceiro degrau, a máscara re-derivada nos resíduos ortogonalizados das duas
> pernas (`z_jk_bs_norisk_mask`), que fecha a objeção do council de 2026-08-10
> contra o "por completo" de §5.2. Razão do corte em
> [`historico_decisoes.md` §2.4](../../registro/historico_decisoes.md).
>
> **CURRENT no resto.** Escrita em 2026-08-09 sob a produção corrente:
> `z_jk_bs_purif` ×
> `yield_6m`, r=7, q=6, p=6, painel de 106 séries (vintage 07-24), ξ_mp 10,43
> full / 12,22 pré-COVID. Corpo gerado em
> `output/instrument/jk_sovereign_confound.{csv,md}` e
> `jk_sovereign_irf_overlay.pdf`. Substitui a seção "Lacuna
> declarada" de [`2026-07-31_confound_soberano_jk`](2026-07-31_confound_soberano_jk.md),
> que segue válida em todo o resto. **Nenhum script toca esta nota.**

## O que mudou e por que importa

O teste de 07-31 rodou em **EMBI+** porque não havia CDS 5a diário no repositório.
`data/raw/CDS 5y.xlsx` (Bloomberg, `BRAZIL CDS USD SR 5Y D14 Corp`, diário 2001-10 a
2026-08) fechou a lacuna. Não é substituição cosmética de proxy — é a resposta a
uma objeção específica que o desenho anterior deixava aberta.

| | EMBI+ | CDS 5a |
|---|---|---|
| pares Qua→Qui de Copom | 94/95 | **95/95** |
| variações exatamente zero (painel de eventos) | **8,3%** | **0,5%** |
| menor variação não-nula exprimível | **1,000 pb** | **0,005 pb** |
| cor. com Ibov no mesmo dia | −0,508 | **−0,580** |
| cor. com S&P no mesmo dia | −0,498 | **−0,541** |

O EMBI+ é publicado com duas casas em pontos percentuais. Notícia de risco menor
que um ponto-base é arredondada a zero, e **erro de medida clássico na variável
dependente não enviesa o coeficiente — mas arredondamento e cotação parada
reduzem a covariância medida e derrubam o R²**, que é o que se vê: o mesmo
controle não-Copom dá R² 0,130 no EMBI contra **0,218** no CDS. Um parecerista
podia dizer que o nulo do teste A era artefato de medida. Com o CDS não pode.

**Ordem de olhar, declarada.** O EMBI foi olhado primeiro e sua regra de leitura
foi fixada antes dos números dele. O CDS chegou depois e é julgado pela **mesma
função** (`verdict_for()` em `jk_sovereign_confound.R`), sem regra nova. O
veredito do EMBI é o de 07-31, inalterado.

## A — o veredito não muda, e o teste ficou mais afiado

**Interação `x:1(jk_bs)`, a estatística que decide** (contaminação exigiria
coeficiente **positivo** com `p_boot < 0,10` — o dia retido carregando *mais*
risco por unidade de surpresa que um dia comum):

| proxy | coef | t | p_boot |
|---|---|---|---|
| CDS 5a (Qua→Qui) | **−0,191** | −1,67 | 0,170 |
| EMBI+ (Qua→Qui) | **−0,182** | −1,94 | 0,092 |
| BRL/USD | −0,036 | −2,17 | 0,068 |
| Slope DI | −0,228 | −0,75 | 0,492 |
| DI ~10a | −0,616 | −1,88 | 0,119 |

Negativa nas **cinco** proxies da janela do evento. **Veredito idêntico nas duas:
confound não detectado na frequência diária.**

Por conjunto de dias, é aqui que o CDS mede o que o EMBI não conseguia:

| | não-Copom (controle) | 62 retidos | Copom rejeitados |
|---|---|---|---|
| **CDS 5a** | 0,436 (t 4,35; R² 0,218) | **0,140** (t 2,86; **p 0,003**) | −0,285 (t −1,75; p 0,010) |
| EMBI+ | 0,326 (t 3,97; R² 0,130) | 0,099 (t 1,74; p 0,109) | 0,019 (t 0,18; p 0,899) |

Três leituras, e a segunda **endurece uma ressalva em vez de aliviá-la**:

1. **O dia retido carrega ~3,1× menos risco por unidade de surpresa que uma
   quinta comum** (0,140 contra 0,436). É a mesma conclusão de 07-31, medida com
   mais precisão.
2. **⚠ Mas o coeficiente nos 62 dias agora é claramente não-nulo** (p_boot
   **0,003**, contra 0,109 do EMBI). A ressalva obrigatória de 07-31 — "a
   afirmação é *menos risco que um dia comum*, **não** *zero risco*" — deixa de
   ser cautela de rodapé e vira **fato medido**. Escrever "sem risco soberano"
   em qualquer lugar do paper seria falso.
3. Os dias que o filtro **rejeita** carregam risco com sinal **negativo** e
   significativo (−0,285, p 0,010), enquanto o conjunto Copom inteiro é nulo
   (−0,004). O filtro não está desprezando ruído: ele separa dois regimes de
   sinal oposto.

**A janela do dia seguinte confirma na proxy melhor.** Qui→Sex: CDS **+0,190
(p 0,048)**, EMBI +0,248 (p 0,025). A resposta *defasada* do risco à surpresa é
real e não é artefato de alinhamento — as duas séries estão alinhadas no mesmo
dia (`cor_t` domina `cor_{t−1}` nas quatro séries de mercado, nas duas proxies).

## C — o resultado mais forte da rodada

Ortogonalizar `e_di_bs` ao risco diário contemporâneo é um **limite inferior**:
política move spread soberano legitimamente, então isso super-remove.

| variante | RHS | R² | ξ_mp full | ξ_mp pré-COVID |
|---|---|---|---|---|
| produção | — | — | 10,43 | 12,22 |
| `z_jk_bs_norisk` | EMBI + BRL | 0,127 | 10,72 | 8,18 |
| **`z_jk_bs_norisk_cds`** | **+ CDS** | **0,154** | **12,68** | **9,93** |

O limite inferior mais severo é também **o instrumento mais forte da rodada** —
22% acima da produção. Todas as manchetes seguem sig90 e o câmbio praticamente
não se move (0,139 contra 0,150 da produção; CDS 26,3 contra 29,1; EMBI 0,175
contra 0,200). Se a máscara estivesse selecionando risco soberano, retirar o
risco contemporâneo destruiria o instrumento. Ele melhora.

`z_jk_bs_norisk` foi **congelado de propósito** na definição de 07-31 e reproduz
ξ_mp = 10,72 exato — é o auto-teste de que a entrada do CDS não vazou para a
variante antiga.

*(Seção removida em 2026-08-10 junto com o teste que a produzia. Os números
não são mais reproduzíveis e não devem ser citados; o registro fica no
histórico do git e a razão do corte em `registro/historico_decisoes.md`
§2.4.)*

## O que não mudou

- **Nada de produção foi modificado.** `build_variants.R`, `instrument.R`,
  `instrumentos_mensais.csv` e `DEFAULT_VARIANT` estão intocados, e as variantes
  ortogonalizadas ao risco são construídas em memória.
- Os cinco auto-testes passam: painel diário contra `copom_event_diagnostics.csv`
  (máx |dif| 1,42e-14, máscaras idênticas), ξ_mp de produção 10,43/12,22,
  `z_jk_bs_norisk` 10,72, smoke test h0 exato, e o novo cruzamento do CDS diário
  contra o `cds_5y` mensal do painel (**cor 0,9994** em 156 meses, vendors
  diferentes) — que é o que torna o teste diário e a IRF mensal de `cds_5y`
  objetos comensuráveis em vez de homônimos.

## Mudança de infraestrutura: `p_boot` agora reproduz

Todas as células do wild bootstrap tiravam de **um único fluxo de RNG**, então
inserir uma proxy deslocava o `p_boot` de toda célula posterior: acrescentar o
CDS moveu o do EMBI de 0,108 para 0,092 com coeficiente e `t` **bit-idênticos**.
Isso é defeito de reprodutibilidade, não resultado, e ia se repetir na próxima
proxy. Agora cada célula é semeada pela própria identidade
(`wild_coef_test(key = )`) e o valor não depende do que rodou antes — verificado
rodando duas vezes, com os sete `p_boot` idênticos.

Custo: os `p_boot` publicados em 07-31 são resorteados (erro-padrão ~0,007 com
2.000 sorteios). Coeficientes, erros-padrão HC1, `t`, R² e todas as IRFs são
determinísticos e **não mudaram** — e é o **sinal** da interação que decide o
veredito.
