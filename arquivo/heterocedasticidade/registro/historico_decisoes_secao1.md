# Identificação por heterocedasticidade — corpo integral

> **Rota abandonada em 2026-08-17.** Este arquivo é a §1 de
> `registro/historico_decisoes.md` na íntegra, movida para cá quando a
> estratégia foi abandonada. Código em `../R/` e `../script/`, artefatos em
> `../output/het/`, notas em `../notas/`.

---

## 1. Identificação por heterocedasticidade — abandonada em duas frentes

### 1.1 Como instrumento (`z_het*`, Rigobon-Sack 2003)

**Construída e validada, depois demovida.** SVAR diário sobre pares Qua→Qui
(DI_3m, DI_2y, IBOV, BRL), regimes C = quarta de Copom / NC = demais,
`b_1 = sqrt(λ_1) v_1` do autopar dominante de `Σ_C − Σ_NC`, choque diário
recuperado por projeção GLS Mertens-Ravn (2013), agregação mensal. Quatro
variantes (`z_het`, `z_het_jk`, `z_het_3var`, `z_het_jk_3var`).

Passou por auditoria externa completa (referee2 rounds 1 e 2, réplica em
Python batendo em 6+ casas) e pela suíte T1-T8 de validação (placebo, máscara
aleatória, sub-período, correlação, anti-JK, curva F(k), sensibilidade AR,
QLR de Andrews).

**Por que morreu:** força no espaço dos fatores. Sob a régua rigorosa ξ_mp
(Montiel Olea-Stock-Watson), `z_het_3var` chega a **0,45 no full em (7,6)** e
`z_het` a 1,95 — contra 10,43 do `z_jk_bs_purif`. A F legada (max-F ou F contra
a inovação AR do `yield_6m`) mascarava isso: `z_het` tinha F(y6m AR) ≈ 7,6 com
F(DFM) ≈ 1,5. Lição transferível: **as três Fs legadas podem discordar por uma
ordem de grandeza da estatística que realmente governa a projeção**
`H = (Z'η)/(Z'Z)`.

- 2026-05-08 — `DEFAULT_VARIANT` trocado de `z_het_jk_3var` para `z_jk_purif`.
- 2026-07-15 — decisão editorial: het fora do paper, pipeline como diagnóstico interno.
- 2026-07-26 — código arquivado em `arquivo/`, artefatos apagados.

**Achado que sobrevive:** A3 (constância de `B_d`) sustentada —
cos(b_1_pré, b_1_pós) = 1,000 com norm_ratio 0,687; a direção da coluna de
impacto é estável, só a magnitude cai 31% pós-2020. E o segundo autopar `b_2`
tem perfil de *tilt* (curto sobe, longo cai), consistente com forward guidance
quando A2 falha em DI_2y — descritor, nunca usado como segundo instrumento.

### 1.2 Como identificação primária (Rigobon 2003 nas inovações fatoriais)

**Pivô de 2026-07-16, reprovado no mesmo dia, nas duas variantes.** A motivação
era boa: o Copom anuncia ~18h30, depois do fechamento, e a janela Qua→Qui de
~24h fragiliza a exclusion restriction do proxy (crítica Rigobon-Sack 2004 ao
event-study). O código foi implementado e validado por simulação
(`validate_het_primary_sim.R`: cos 0,994, tamanho do J 4,5%, poder 85,5%), e o
ramo proxy ficou byte-idêntico ao de produção.

| variante | desenho | veredito |
|---|---|---|
| **Calendário** | regimes = meses com/sem Copom; 16 células (r,q) | **Reprovada.** Placebo de permutação p entre 0,26 e 0,86; proporcionalidade `Σ_C ∝ Σ_NC` nunca rejeitada ⇒ A1/rank condition inexistentes na frequência mensal |
| **Episódio (BPSS 2021)** | S2 pré/pós-2020 + partição fina S4; 4 células | **Reprovada.** A volatilidade se move como **fator de escala comum**; autovalores generalizados indistinguíveis (gap mínimo 0,04-0,19); a coluna com o loading de `yield_6m` tem λ ≈ 1 |

**Leitura:** a heterocedasticidade que identifica no diário (Rigobon-Sack)
simplesmente não sobrevive à agregação mensal — a variância muda de nível, não
de composição. Isso é um resultado sobre a frequência, não sobre o método.

**Reavaliada e CONFIRMADA em 2026-08-01, com evidência muito mais forte.**
`script/het_robustness.R` → `output/het/`, nota
`notas/2026-08-01_robustez_heterocedasticidade.md`. O veredito acima foi
produzido **antes** do refresh de vintage de 2026-07-24 e da migração para
`(7,6)` — o mesmo refresh que devolveu ξ_mp 10,43 ao proxy —, então re-rodar não
era teimosia. Grade de `p ∈ {5..8} × q ∈ {5..8} × r ∈ {7,8}` (com `q ≤ r`) ×
`{full, pre_covid}` = **252 células**, com **5 desenhos de regime**: os dois de
2026-07-16 mais três novos (`intensidade_z` = tercil superior de |z|;
`volatilidade_juros` = quartil superior da volatilidade realizada do DI 6m
diário; `quebra_livre` = quebra com data varrida). **Quatro coisas para não
re-derivar:**

- **Zero células identificam, e não é severidade de correção.** Sob Holm *dentro*
  de cada desenho × janela (28 testes em vez de 252) o número continua zero nos
  cinco desenhos. `calendario` rejeita proporcionalidade em **0%** das células nas
  duas janelas — a conclusão de 07-16 não era artefato de `(r,q,p)`.
- **Uma segunda condição necessária falha em separado:** os autovalores
  generalizados não são distintos (gap relativo mínimo com mediana **0,11-0,17**
  por desenho). Sem coluna separável não há direção monetária, então **o estágio
  de IRF não roda** — qualquer IRF ali seria número sem identificação atrás.
- **O desenho que explica tudo é novo.** `volatilidade_juros` concentra o regime
  C no pós-2020 (`share_C` 0,478 contra 0,051 antes) e **não rejeita
  proporcionalidade em nenhuma das 56 células**: o surto pós-2020 é **fator de
  escala comum**. A varredura livre de `quebra_livre` *encontra* 2020-2022 em 25
  das 28 células da janela cheia. A única heterocedasticidade do painel mensal é
  a da COVID/ciclo de aperto, e ela é de escala.
- **Não citar as 21 células** que passam as duas condições em nível bruto: 17
  estão em `q = 5` (menor valor da grade), todas na janela cheia, e nenhuma
  sobrevive à correção mais leniente. É fragilidade de especificação.

**Consequência editorial:** existe agora uma resposta documentada à pergunta "por
que não identificar por heterocedasticidade?", mas ela **não é corroboração** — a
seção de robustez não pode escrever que uma identificação alternativa confirma o
proxy com base nisto. Escopo travado por decisão do autor em 2026-08-01: **objeto
mensal apenas**, perna diária permanece arquivada.

**Ponta solta declarada:** heterocedasticidade *condicional* (GARCH-SVAR,
Lanne-Saikkonen 2007 / Normandin-Phaneuf 2004) dispensa datas de regime e é a
rota com melhor chance de produzir IRF mensal. **Não foi tentada** — é outro ramo,
não Rigobon, e `svars` não está instalado.

Decisão do autor no mesmo dia: **abandonar qualquer identificação por
instrumento/proxy** e escolher uma nova primária. Essa decisão foi **revertida
em 2026-07-24**: o refresh de vintage devolveu força ao proxy (ξ_mp > 10 nas
duas janelas em (7,6)) e a produção seguiu no proxy-SVAR. A nota
`notas/2026-07-24_auditoria_analise_gemini.md` foi escrita durante essa
janela de 8 dias e ainda carrega a premissa antiga.

**Itens LEVE que morreram junto:** guard de sign-flip em
`het_shock_extraction.R:208`; alinhamento de NA handling entre
`validate_variance_split` (por coluna, n_C=104) e `extract_shock_rigobon_sack`
(complete.cases, n_C=97); documentar `MAX_GAP_DAYS` no nível do script.

---
