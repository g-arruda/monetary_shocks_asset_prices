# `arquivo/heterocedasticidade/` — identificação por heterocedasticidade

**Abandonada em 2026-08-17, por decisão do autor.** Nada aqui é executado pelo
pipeline de produção nem citado pelo paper. A produção segue com uma única
identificação: o **proxy externo** `z_jk_bs_purif`.

> ⚠️ **Não reproduz contra o painel atual.** Parte deste material é anterior ao
> refresh de vintage de 2026-07-24 (106 séries) e à migração de 2026-08-13 para o
> painel de 111 séries em `(5,5)`. Os artefatos de instrumento anteriores a
> 2026-05-07 estão **100× fora de escala** pelo bug de unit scaling do
> `yield_6m`. Trate os números como história, não como referência.

## Veredito

Reprovada em **duas frentes**, com dois anos de calendário de projeto entre elas:

1. **Como instrumento** (`z_het*`, Rigobon-Sack 2003) — abandonada em
   **2026-07-16**. As quatro variantes `z_het*` nunca entraram na produção.
2. **Como identificação primária** (Rigobon 2003 sobre as inovações do
   factor-VAR) — abandonada em **2026-08-01** no objeto mensal e definitivamente
   em 2026-08-17. **Zero das 252 células identificam.** O placebo de permutação
   não distingue os labels do calendário (p_perm 0,26–0,86) e a
   proporcionalidade Σ_C ~ Σ_NC nunca é rejeitada. A única heterocedasticidade do
   painel mensal é a da COVID/ciclo de aperto, e ela é **fator de escala comum**,
   não separação de regimes — `volatilidade_juros` não rejeita proporcionalidade
   em nenhuma das 56 células.

**A leitura que sobrevive:** a heterocedasticidade que identifica no diário
(Rigobon-Sack) não sobrevive à agregação mensal. Sem coluna separável não há
direção monetária, e por isso **nunca houve estágio de IRF** neste ramo — qualquer
IRF ali seria número sem identificação atrás.

**Ponta solta declarada e nunca tentada:** heterocedasticidade *condicional*
(GARCH-SVAR, Lanne-Saikkonen 2007 / Normandin-Phaneuf 2004), que dispensa datas
de regime. É outro ramo, não Rigobon; `svars` não está instalado.

## O que está aqui

| pasta | conteúdo |
|---|---|
| `registro/historico_decisoes_secao1.md` | corpo integral da antiga §1 de `registro/historico_decisoes.md` — a fonte detalhada |
| `R/identification/` | `het_primary.R` (regimes mensais sobre η), `het_tests.R`, `het_shock_extraction.R` (bloco diário Rigobon-Sack) |
| `script/` | `het_robustness.R` (gate de 252 células), `instrument_het.R`, `instrument_validation.R`, `het_primary_feasibility.R`, `het_episode_feasibility.R`, `validate_het_primary_sim.R` |
| `output/het/` | 10 artefatos da última rodada — grade do gate, veredito por célula, datas de quebra, superfície |
| `notas/` | `2026-08-01_robustez_heterocedasticidade.md` — a nota citável da rodada mensal |
| `_instrucoes/` | `Heteroscedasticidade.md`, `plano_reimplementacao_het.md` |

**Contagens não são memorizáveis.** As células que passavam as duas condições em
nível bruto eram 21 no painel de 106 séries e 24 no de 111 — leia sempre de
`output/het/het_robustness.md`, nunca de memória. Nenhuma sobrevive à correção
mais leniente.

## Material relacionado que ficou fora desta pasta

Por serem de conteúdo misto ou verbatim, seguem em `arquivo/`:

- [`../relatorio/2026-04-25_blindspot_het_instrument.md`](../relatorio/2026-04-25_blindspot_het_instrument.md)
- [`../relatorio/2026-04-26_blindspot_validation.md`](../relatorio/2026-04-26_blindspot_validation.md)
- [`../relatorio/council_2026-05-05.md`](../relatorio/council_2026-05-05.md)
- [`../relatorio/correspondence/referee2/`](../relatorio/correspondence/referee2/) — réplica NumPy do bloco Rigobon-Sack e os dois rounds do Referee 2

`R/identification/validation_tests.R` **continua vivo** no repositório: a suíte
T1-T8 foi escrita para `z_het_jk`, mas as funções são agnósticas ao instrumento.

## Referências

- Rigobon (2003, *RES*); Rigobon & Sack (2003 *QJE*; 2004 *JME*)
- Stock & Watson (2018, *EJ*) §4.7
- Lanne & Lütkepohl (2008) — teste de rank para ΔΣ
- Gonçalves, Rodrigues & Genta (2025, IMF WP/25/48) — aplicação ao Brasil em
  frequência diária. **Esta continua citada no paper**: é evidência alheia com
  que o artigo dialoga, não a estratégia deste projeto.
