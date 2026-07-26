# Por que algumas IRFs ficam "dentadas" — diagnóstico

> **ℹ️ VINTAGE ANTIGO — banner de 2026-07-26.** Escrita sob `z_jk_purif` × (6,5), vintage
> pré-refresh, mas **o mecanismo não depende do instrumento nem de (r,q)**: raízes complexas de
> 3-4 meses do VAR(6) sobre séries de baixa comunalidade. p=6 segue em produção e a recomendação
> de não suavizar ex-post continua valendo. A mais durável do lote de 07-12.


**Data:** 2026-07-12
**Pergunta:** algumas IRFs da spec de produção (`z_jk_purif` × `yield_6m`,
r=6, q=5, p=6) aparecem serrilhadas. É problema de parametrização do DFM/VAR
ou outra coisa?

**Resposta curta:** não é erro de especificação. O serrilhado tem dois
mecanismos identificados e quantificados: (1) concentra-se nas séries de
**baixa comunalidade** (ações, IPCA headline), cujas IRFs oscilam em torno de
zero *dentro das bandas*; (2) vem das **raízes complexas de ciclo curto
(3-4 meses) do VAR(6) de fatores** — consequência direta da escolha p=6, que
é o trade-off deliberado do projeto (padrão AK), não um defeito. As IRFs das
variáveis centrais do paper (curva, crédito, atividade) são lisas. Nenhuma
mudança na spec de produção é recomendada.

---

## Mecanismo 1: baixa comunalidade

Índice de rugosidade por variável (média|Δ²IRF|/sd do caminho, h=0..48, de
`irf_coherence_h.csv`) cruzado com a comunalidade da série no DFM (R² do
componente comum no painel BLL-padronizado):

**Spearman(rugosidade, comunalidade) = −0.50** (n = 52).

| mais dentadas | rugosidade | comunalidade | | mais lisas | rugosidade | comunalidade |
|---|---|---|---|---|---|---|
| ind_bens_capital | 0.35 | 0.11 | | yield_3m | 0.046 | 0.81 |
| asset_imat | 0.30 | ≈0 | | credit_outstanding | 0.046 | 0.71 |
| asset_ibov | 0.28 | 0.10 | | credito_industria_total | 0.042 | 0.70 |
| asset_mlcx | 0.28 | 0.15 | | credito_pessoa_fisica | 0.040 | 0.91 |
| ind_transformacao | 0.26 | 0.11 | | credito_comercio | 0.037 | 0.82 |
| asset_imob | 0.26 | 0.29 | | credito_agro | 0.036 | 0.91 |
| price_ipca | 0.25 | ≈0 | | credito_construcao | 0.036 | 0.73 |

A IRF de uma série no DFM é `Λ_i × IRF(fatores)`. Quando a série tem
comunalidade ≈ 0.1 (ações, IPCA headline), `Λ_i` é pequeno e estimado com
ruído: a IRF resultante é uma combinação instável que oscila em torno de
zero. Crucialmente, **essas oscilações são internas às bandas** — nas ações,
nenhum horizonte pós-h1 é significativo; o serrilhado é ruído visual, não
sinal econômico. As séries com comunalidade alta (0.7-0.9) têm IRFs lisas.

## Mecanismo 2: raízes de ciclo curto do VAR(p) de fatores

Espectro do companion (r=6, q=5) por ordem de defasagem p, e rugosidade
média por grupo (IRFs pontuais, nboot=0):

| | p=3 | p=6 (produção) | p=12 |
|---|---|---|---|
| rugosidade ações | 0.20 | 0.26 | 0.59 |
| rugosidade curva | 0.02 | 0.06 | 0.21 |
| rugosidade crédito | 0.02 | 0.04 | 0.18 |
| rugosidade atividade | 0.08 | 0.20 | 0.24 |
| rugosidade preços | 0.14 | 0.24 | 0.61 |
| raízes com período < 6m (módulo > 0.5) | 4 (máx 0.52) | 19 (máx 0.82) | 45 (máx 0.95) |
| máx \|autovalor\| | 0.979 | 0.980 | 0.994 |

- A rugosidade é **monotônica em p** em todos os grupos. O VAR(6) tem pares
  complexos com módulo 0.82 e períodos de **3.2 e 3.8 meses** — são eles que
  produzem o zigue-zague dos primeiros ~12 meses (decai como 0.82^h). Com
  p=3 essas raízes caem para módulo ≈ 0.51 (meia-vida < 1 mês — praticamente
  invisíveis); com p=12 sobem para 0.95 (oscilação de 4 meses quase
  persistente + máx autovalor 0.994, beirando a não-estacionariedade do
  companion).
- As raízes dominantes do sistema são de ciclo longo em qualquer p
  (0.98 @ ~116 meses, 0.96 @ ~57, 0.90 @ ~28 — tendência e ciclo de
  negócios): a dinâmica econômica relevante não depende das raízes curtas.

## Veredito e recomendação

O serrilhado é o preço conhecido de p=6 defasagens mensais em 147 obs
(sobre-ajuste parcial de ruído mensal de alta frequência), amplificado
visualmente nas séries que os fatores mal explicam. **Não é defeito de
identificação nem de (r, q)** — a identificação por instrumento externo atua
só no impacto (`H = Z'η/Z'Z`); a propagação vem do VAR de fatores, igual
para todas as variáveis.

Recomendações (nenhuma mudança na produção):

1. **Manter p=6.** Reduzir para p=3 alisaria, mas arriscaria subestimar a
   dinâmica (e a defasagem de transmissão de 12-24 meses é o objeto do
   paper); p=6 é o padrão AK e a sensibilidade T7 do instrumento já cobre
   p ∈ {3, 6, 12}.
2. **Para o paper**: plotar as variáveis centrais (curva, crédito,
   atividade, núcleos — todas lisas); onde uma série de baixa comunalidade
   entrar (Ibov), a leitura econômica é o impacto (significativo) — o
   pós-h2 é ruído dentro das bandas, e uma nota de rodapé basta.
3. **Não suavizar IRFs ex-post** (splines/médias móveis): esconderia a
   incerteza real e não é prática na literatura de proxy-SVAR.

## Reprodução

Script efêmero (scratchpad, não versionado): estima `estimate_dfm(r=6, q=5,
p ∈ {3,6,12})` + `run_stage2_cell(nboot=0)` e imprime rugosidade por grupo e
espectro do companion. Comunalidade: projeção do painel `Z` (BLL) nos
loadings estáticos. Fontes: `output/irf/irf_coherence_h.csv`,
`R/modeling/factor_estimation.R`, `R/modeling/impulse_responde.R`.
