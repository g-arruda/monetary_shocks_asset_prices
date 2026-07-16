# Rigobon & Sack (2004) — "The impact of monetary policy on asset prices"

Journal of Monetary Economics 51 (2004) 1553–1575. Recebido 15/05/2003, aceito 05/02/2004. JEL: E44, E47, E52.
Versão working paper com resultados adicionais: NBER WP #8794 (Rigobon & Sack, 2002).

Extração estruturada (protocolo split-pdf-md, 3 chunks lidos em 2026-07-16). Foco: template empírico para substituir identificação event-study/proxy por identification through heteroskedasticity no projeto Brasil (regimes Copom-day vs non-Copom-day em DI futuro / IBOV / BRL).

**Aviso de OCR (marker):** na Table 1, as covariâncias das ações com a policy rate em dias F aparecem sem sinal (1.60, 2.02, 1.35), mas o texto afirma explicitamente que a relação é **negativa** nos policy dates — o sinal de menos foi perdido pelo OCR. O mesmo vale para SP500/NASDAQ na Table 5 (7.19, 10.06 etc. correspondem a −7.19, −10.06 da Table 2). A significância do teste de O.I. da Table 2 está ilegível no OCR ("2 . 4"); pelo painel 1-day da Table 5 (mesma estimação GMM) o valor é 0.997.

## 1. Research question

Como preços de ativos (índices de ações, eurodollar futures, Treasury yields) respondem a mudanças na política monetária? O problema central é que OLS/event-study sofre de (i) simultaneidade — a taxa curta reage aos preços de ativos via policy reaction function — e (ii) omitted variables — notícias macro movem simultaneamente juros e ativos. O paper desenvolve um estimador baseado na heteroskedasticidade dos policy shocks em dias de FOMC/testimony, que identifica a resposta sob hipóteses muito mais fracas que o event-study, e usa a diferença entre os dois estimadores para **testar** (e medir o viés d)as hipóteses do event-study. É o "outro lado" de Rigobon & Sack (2003, QJE), que estimou a resposta da política ao mercado acionário (parâmetro beta).

## 2. Audience

Macro monetária empírica e macro-finance: a literatura event-study de choques monetários (Cook & Hahn 1989; Kuttner 2001; Cochrane & Piazzesi 2002; Bernanke & Kuttner 2003; Bomfim 2003; Thorbecke 1997), pesquisadores de bancos centrais (transmissão via asset prices), econometristas interessados em identification through heteroskedasticity (Rigobon 2003 REStat; Wright 1928; King-Sentana-Wadhwani 1994; Sentana & Fiorentini 2001; Klein & Vella 2000a,b), e participantes de mercado (risk management).

## 3. Method

### 3.1 Modelo estrutural (Section 2)

Sistema simultâneo em dados diários (first differences):

- Eq. (1) — policy reaction function: `Delta i_t = beta*Delta s_t + gamma*z_t + eps_t`
- Eq. (2) — asset price equation:     `Delta s_t = alpha*Delta i_t + z_t + eta_t`

onde `Delta i_t` = variação da taxa curta, `Delta s_t` = variação do preço do ativo, `eps_t` = monetary policy shock, `eta_t` = asset price shock, `z_t` = common shock (escalar por simplicidade; generaliza para vetor). Hipóteses mantidas: `eps`, `eta`, `z` sem correlação serial, mutuamente não correlacionados (a não-correlação entre choques estruturais é a única hipótese **não testável** no setup — footnote 13). Parâmetro de interesse: **alpha**. A policy reaction function (1) é explicitamente permitida — beta != 0 é a fonte da simultaneidade, não uma violação. Dinâmica: adicionar lags a (1)-(2) e trabalhar com resíduos de forma reduzida de um VAR dá resultados quase idênticos (footnote 8 e Section 4.4).

### 3.2 Viés do event-study (Eq. 3)

OLS em (2) tem média:

```
E[alpha_hat] = alpha + (1 - alpha*beta) * [beta*sigma_eta + (beta+gamma)*sigma_z]
                                          / [sigma_eps + beta^2*sigma_eta + (beta+gamma)^2*sigma_z]   (3)
```

(sigma_x = variância do choque x). Viés de simultaneidade se `beta != 0` e `sigma_eta > 0`; viés de omitted variables se `gamma != 0` e `sigma_z > 0`.

O event-study (OLS nos dias de FOMC/policy moves, seguindo Cook & Hahn 1989) só é consistente sob **near identification** (Fisher 1976):

- (4) `sigma_eps >> sigma_z`
- (5) `sigma_eps >> sigma_eta`

i.e., o viés só vai a zero quando `sigma_eps/sigma_eta -> inf` e `sigma_eps/sigma_z -> inf`. Com razões finitas, algum viés permanece, e a literatura event-study não oferece evidência sobre a magnitude. Nota (footnote 3): as hipóteses do event-study ficam mais plausíveis quanto menor a janela (intraday), mas o paper explora exatamente os vieses com **dados diários**.

**Direção do viés** (Section 4): para ações, choques `eta` (mercado → juros na mesma direção, beta > 0) e `z` (notícias de atividade) induzem correlação positiva entre `Delta i` e `Delta s` ⇒ viés **para cima (em direção a zero)** em `alpha_es` ⇒ event-study **subestima** (em módulo) a queda das ações. Para yields, choques comuns movem taxas curtas e longas na mesma direção ⇒ viés **para cima** ⇒ event-study **superestima** a resposta da curva, crescentemente com a maturidade (explica em parte o "puzzle" de Cochrane & Piazzesi de longas respondendo demais).

### 3.3 Identificação por heteroskedasticidade (Section 3)

Dois subsamples, F (policy dates) e ~F (non-policy dates), com **parâmetros alpha, beta, gamma estáveis** entre os regimes (condição necessária) e:

- (6) `sigma_eps^F > sigma_eps^~F`   — a variância do policy shock **sobe** nos policy dates
- (7) `sigma_eta^F = sigma_eta^~F`  — asset price shock homoskedástico entre regimes
- (8) `sigma_z^F  = sigma_z^~F`     — common shocks homoskedásticos entre regimes

Só se exige aumento da importância **relativa** do policy shock — os demais choques continuam ocorrendo nos dias F, apenas com a mesma intensidade. Contraste com event-study: identifica alpha pela **mudança** do viés da Eq. (3) quando sigma_eps muda, em vez de exigir que o **nível** do viés vá a zero. O event-study é o caso-limite do estimador het quando o shift de variância é infinito.

Forma reduzida de (1)-(2):

```
Delta i_t = (1/(1-alpha*beta)) * [ (beta+gamma)*z_t + beta*eta_t + eps_t ]
Delta s_t = (1/(1-alpha*beta)) * [ (1+alpha*gamma)*z_t + eta_t + alpha*eps_t ]
```

Matrizes de covariância por regime, Omega_F e Omega_~F (2x2 em [Delta i, Delta s]); a diferença é rank-1:

```
Delta Omega = Omega_F - Omega_~F
            = (sigma_eps^F - sigma_eps^~F)/(1-alpha*beta)^2 * [ 1     alpha   ]
                                                              [ alpha alpha^2 ]     (9)
```

### 3.4 Estimador VC / IV (Section 3.1)

Estimadores amostrais: `Omega_hat_F = (1/T_F) sum_t delta_t^F Delta x_t Delta x_t'` (idem ~F), com `Delta x_t = [Delta i_t, Delta s_t]'` e dummies de regime `delta_t^F`, `delta_t^~F`. De (9):

```
alpha_het^i = Delta Omega_hat_12 / Delta Omega_hat_11     (10)
alpha_het^s = Delta Omega_hat_22 / Delta Omega_hat_12     (11)
```

(terceiro estimador `sqrt(Delta Omega_hat_22 / Delta Omega_hat_11)` = média geométrica dos dois; não usado. Eq. (10) também aparece independentemente em Ellingsen & Soderstrom 2001.)

**Formulação IV equivalente:** empilhando `Delta i = [Delta i_F', Delta i_~F']'` e `Delta s = [Delta s_F', Delta s_~F']'` (T_F + T_~F observações), definem-se os instrumentos **com o subsample ~F trocado de sinal**:

```
w_i = [ Delta i_F' , -Delta i_~F' ]'
w_s = [ Delta s_F' , -Delta s_~F' ]'
```

e então IV padrão de `Delta s` sobre `Delta i`:

```
alpha_het^i = (w_i' Delta i)^{-1} (w_i' Delta s)    (12)
alpha_het^s = (w_s' Delta i)^{-1} (w_s' Delta s)    (13)
```

Substituindo os instrumentos: `alpha_het^i = (Delta i_F' Delta s_F - Delta i_~F' Delta s_~F) / (Delta i_F' Delta i_F - Delta i_~F' Delta i_~F)` — idêntico a (10); análogo para (13) = (11). Se T_F != T_~F, dividir instrumentos e variáveis por sqrt do número de datas de cada subsample (footnote 10). Intuição de validade: `w_i` correlaciona com `Delta i_t` porque o subsample F pesa mais (heteroskedasticidade de eps), mas não correlaciona com `eta_t` e `z_t` porque esses são homoskedásticos — os dois subsamples se cancelam. Appendix A: prova de validade dos instrumentos; Appendix B: consistência mesmo com heteroskedasticidade temporal geral dos outros choques, desde que a volatilidade do policy shock responda pelo shift da covariância nos policy dates (+ condições de regularidade).

**Event-study como caso particular:**

```
alpha_es = (Delta i_F' Delta i_F)^{-1} (Delta i_F' Delta s_F)    (14)
```

(10)-(11) convergem para (14) quando o shift de variância é infinitamente grande (a mudança de variância converge para a própria variância nos policy dates).

Implementação prática: foco em (10) por simplicidade; estimado por **three-stage least squares (3SLS)** para toda uma classe de ativos de uma vez (todos os índices, ou toda a curva), o que permite testes de hipótese conjuntos. Vantagem do IV: roda em qualquer pacote e herda toda a asymptotics de IV (distribuição do coeficiente).

**Weak identification (footnote 11):** sob a null de que há heteroskedasticidade, (10)-(11) têm distribuições bem definidas; **sem** heteroskedasticidade, o denominador tem massa positiva em zero e o estimador não é well-behaved (cita Staiger, Stock & Watson 1997). No sample deles a heteroskedasticidade é grande o suficiente (Delta Omega longe de zero).

### 3.5 Estimador GMM (Section 3.2)

(9) contém 3 restrições (vech de matriz 2x2 simétrica) para 2 parâmetros: alpha e `lambda := (sigma_eps^F - sigma_eps^~F)/(1-alpha*beta)^2` (grau de heteroskedasticidade; espera-se lambda significativo). Momentos `E[b_t] = 0` com

```
b_t = vech( ( (T/T_F)*delta_t^F - (T/T_~F)*delta_t^~F ) * Delta x_t Delta x_t'
            - lambda * [1 alpha]'[1 alpha] )
```

e estimação por

```
{alpha_het^gmm, lambda_hat} = argmin [sum_t b_t]' W_T [sum_t b_t]
```

com weighting matrix ótima `W_T` = inversa da covariância estimada dos momentos, obtida em two-step (primeiro passo com identidade). Para uma classe de N ativos, empilham-se os momentos: 3N condições. (Implementação sugerida pelo referee anônimo e por James Hamilton.)

### 3.6 Testes de hipótese (Section 3.3)

1. **Overidentifying restrictions** (3 momentos, 2 parâmetros ⇒ 1 restrição por ativo):

```
delta_oir = T * [sum_t b_t]' Sigma^{-1} [sum_t b_t]  -->d  chi2_n
```

(Sigma = covariância estimada dos momentos; n = nº de restrições sobreidentificadoras). Rejeição ⇒ ou algum choque não-policy ficou mais volátil nos policy dates (viola (7)/(8)), ou parâmetros instáveis entre regimes.

2. **Validade do event-study — Hausman (1978) test:** sob (4)-(5) o event-study é consistente **e eficiente** e o het é consistente mas ineficiente; se (4)-(5) falham, só o het permanece consistente:

```
delta_es,iv = |alpha_het^i - alpha_es|' * M_es,iv^{-1} * |alpha_het^i - alpha_es|  -->d  F_{N, T-1}
M_es,iv = Var(alpha_het^i) - Var(alpha_es)
```

(vetores empilhados da classe de ativos; a variância da diferença é a diferença das variâncias pela eficiência do ES sob a null). Estatística análoga `delta_es,gmm` para o estimador GMM. Estatística significativa ⇒ event-study viesado / near-identification não vale.

## 4. Data

- **Período:** 03/01/1994 a 26/11/2001, dados **diários** (mudanças diárias close-to-close; footnote 3 enquadra o exercício como vieses "when daily data are used"). Justificativa do início em 1994: a partir daí a maioria das ações de política ocorre em reuniões do FOMC; nos 5 anos anteriores só ~1/4 dos policy moves caíam em datas de FOMC (timing incerto inviabiliza o split de regimes).
- **Policy dates (regime F):** dias de reunião do FOMC **+** dias do semi-annual monetary policy testimony do Chairman ao Congresso (ex-"Humphrey-Hawkins", acompanha o Monetary Policy Report). 78 policy dates, dos quais **5 descartados por feriados** nos mercados (feriado 1-2 dias antes impede o first difference) ⇒ 73 utilizáveis. Footnote 7: conjunto poderia ser ampliado (discursos de membros do FOMC), não é feito.
- **Non-policy dates (regime ~F):** o dia **imediatamente anterior** a cada policy date ⇒ T_F = T_~F por construção (igualdade não é necessária); minimiza efeitos de variação temporal das variâncias. Footnote 16: pouca notícia de política nesses dias (blackout informal do FOMC). Robustez: 2 dias anteriores (ok) e 5 dias (rejeita — ver Findings).
- **Policy rate:** taxa do **nearest-to-expire eurodollar futures contract** (liquida na 3-month eurodollar deposit rate; horizonte varia de 0 a 3 meses conforme o timing da reunião — footnote 17, cita Gurkaynak et al. 2002). Move-se apenas com o componente **surpresa**; menos contaminada por timing shocks que o current-month fed funds futures de Kuttner (2001).
- **Ativos:** ações — DJIA, S&P 500, Nasdaq, Wilshire 5000; Treasury constant-maturity yields (H.15 do Fed) — 6m, 1y, 2y, 5y, 10y, 30y; eurodollar futures (CME) com vencimentos trimestrais de 6m a 5y à frente.
- **Unidades:** stocks em variação percentual diária (pontos percentuais); yields em basis points diários (Table 1). Coeficientes: para stocks, % por 1 p.p. de surpresa; para taxas, p.p. por p.p. (pass-through).
- **Detalhe de especificação (footnote 20):** para eurodollar futures e Treasuries a variável dependente é o **slope** (taxa do ativo menos policy rate), não o nível — estimar em nível quase rejeita as overidentifying restrictions, possivelmente porque a variância de term premia também sobe em dias de FOMC; se esse fator afeta todas as maturidades por igual, o modelo em slopes preserva as restrições.

### Table 1 — segundos momentos por regime (std. dev.; covariância com a policy rate)

| Variável | sd ~F | sd F | cov ~F | cov F |
|---|---|---|---|---|
| Policy rate | 2.62 | 5.26 | — | — |
| S&P 500 | 0.88 | 0.99 | 0.20 | −1.60* |
| Nasdaq | 1.63 | 1.71 | 0.08 | −2.02* |
| DJIA | 0.89 | 0.92 | 0.51 | −1.35* |
| i6mo | 4.79 | 5.80 | 6.13 | 25.89 |
| i1y | 3.64 | 6.54 | 7.47 | 29.57 |
| i2y | 3.83 | 7.25 | 7.58 | 31.43 |
| i5y | 3.90 | 7.75 | 7.29 | 31.73 |
| i10y | 3.95 | 7.10 | 7.22 | 26.38 |
| i30y | 3.89 | 6.00 | 6.36 | 18.01 |

\* sinal negativo restaurado a partir do texto (OCR perdeu o "−"); o texto: sem relação discernível ações-juros em ~F, relação **negativa** emerge em F; para Treasuries a covariância é positiva nos dois regimes e **salta** em F. A sd da policy rate dobra (2.62 → 5.26 bps), i.e., variância ~4x.

## 5. Statistical/numerical methods

- Identification through heteroskedasticity (Rigobon 2003 REStat) em sistema simultâneo bivariado com common shocks; regimes definidos por calendário institucional (FOMC/testimony), não estimados.
- Estimador VC (razões de elementos de Delta Omega_hat, eqs. 10-11) ≡ IV com instrumentos sign-flipped por regime (eqs. 12-13); implementado via **3SLS** por classe de ativos.
- **GMM** two-step com weighting matrix ótima, 3N condições de momento, parâmetros (alpha_1..alpha_N, lambda); ganho de eficiência marginal sobre IV (SEs ligeiramente menores).
- Testes: J-test de overidentification (chi2), Hausman ES vs het (F_{N,T-1}), ambos por classe de ativos.
- Inferência IV: asymptotics padrão de IV ("all of the properties of IV estimators apply"). Sem bootstrap no paper.
- Weak identification: reconhecida via footnote 11 (Staiger-Stock-Watson 1997) — denominador com massa em zero se não houver heteroskedasticidade; sem teste formal de first-stage strength (pré-data a literatura moderna de weak IV para esse estimador).
- Alternativa VAR: análise sobre resíduos de forma reduzida de VAR com lags — resultados quase idênticos (não reportados).

## 6. Findings

### Table 2 — Stocks (coef. = % por 1 p.p.; SE entre parênteses)

| Índice | alpha_het^i (IV) | alpha_het^gmm | alpha_es |
|---|---|---|---|
| S&P 500 | −6.81 (2.83) | −7.19 (1.82) | −5.78 (1.98) |
| Wilshire 5000 | −6.50 (2.77) | −6.91 (1.77) | −5.61 (1.94) |
| Nasdaq | −9.42 (5.01) | −10.06 (2.92) | −6.64 (3.53) |
| DJIA | −4.85 (2.82) | −5.39 (1.97) | −5.16 (1.91) |

Testes (significância): delta_oir ilegível no OCR [≈0.997 pela Table 5, 1-day]; delta_es,iv = 0.721; delta_es,gmm = 0.455.

Leitura: **+25 bp na taxa de 3 meses ⇒ S&P −1.7%, Nasdaq −2.4%** (Nasdaq maior — cash flows mais distantes, mais sensível ao desconto; DJIA menor). Estimativas het quase sempre **maiores em módulo** que ES (viés para cima/zero no ES), mas o Hausman **não rejeita** as hipóteses do event-study para ações. GMM ≈ IV; overidentification aceita com folga.

### Table 3 — Eurodollar futures (p.p. por p.p.; slope specification)

| Contrato | alpha_het^i | alpha_het^gmm | alpha_es |
|---|---|---|---|
| ED 1qr | 1.227 (0.082) | 1.137 (0.129) | 1.195 (0.066) |
| ED 2qr | 1.349 (0.117) | 1.105 (0.200) | 1.335 (0.102) |
| ED 3qr | 1.353 (0.139) | 0.978 (0.261) | 1.359 (0.123) |
| ED 4qr | 1.264 (0.150) | 0.845 (0.279) | 1.279 (0.133) |
| ED 5qr | 1.185 (0.151) | 0.766 (0.274) | 1.202 (0.134) |
| ED 6qr | 1.075 (0.150) | 0.661 (0.283) | 1.116 (0.132) |
| ED 7qr | 0.998 (0.152) | 0.593 (0.295) | 1.059 (0.133) |
| ED 8qr | 0.925 (0.152) | 0.511 (0.284) | 1.006 (0.132) |
| ED 12qr | 0.739 (0.154) | 0.346 (0.274) | 0.856 (0.130) |
| ED 16qr | 0.663 (0.156) | 0.266 (0.261) | 0.784 (0.128) |
| ED 20qr | 0.613 (0.159) | 0.214 (0.268) | 0.752 (0.130) |

Testes: delta_oir = 0.486; delta_es,iv = 0.925; **delta_es,gmm = 0.004** (rejeita ES via GMM).

Padrão: resposta **acumula nos primeiros trimestres** (>1 — expectativa de continuação do movimento) e decai com o horizonte (reversão esperada). Het < ES em toda a curva, diferença crescente na maturidade.

### Table 4 — Treasury yields (p.p. por p.p.; slope specification)

| Maturidade | alpha_het^i | alpha_het^gmm | alpha_es |
|---|---|---|---|
| 6m | 0.876 (0.115) | 0.471 (0.130) | 0.875 (0.065) |
| 1y | 0.756 (0.093) | 0.276 (0.127) | 0.849 (0.072) |
| 2y | 0.790 (0.112) | 0.155 (0.116) | 0.873 (0.092) |
| 5y | 0.930 (0.126) | 0.125 (0.139) | 0.977 (0.107) |
| 10y | 0.611 (0.137) | 0.008 (0.102) | 0.727 (0.114) |
| 30y | 0.352 (0.136) | −0.133 (0.083) | 0.493 (0.109) |

Testes: delta_oir = 0.155; delta_es,iv = 0.293; **delta_es,gmm = 0.000** (rejeita ES via GMM).

Curva sobe com efeito **decrescente na maturidade** (10y e 30y bem menores); GMM ainda mais inclinada (10y ≈ 0). Het < ES, diferenças grandes nas longas ⇒ viés para cima do ES explica parte do puzzle de Cochrane-Piazzesi.

### Table 5 — Robustez de janela (GMM; 1-day / 2-day / 5-day non-policy windows)

Seleção (point (SE)): SP500 −7.19 (1.81) / −9.80 (1.70) / −12.43 (1.50)*; NASDAQ −10.06 (2.92) / −14.13 (3.10) / −17.94 (2.92)* [*sinais restaurados]; O.I. stocks: 0.997 / 0.240 / **0.000**. i6mo 0.471/0.952/1.097; i2y 0.155/0.599/1.440; i5y 0.125/0.655/1.616; i10y 0.008/0.288/1.487; O.I. Treasuries: 0.155 / 0.044 / **0.002**. ED1qr 1.137/1.202/1.543; ED8qr 0.511/0.587/1.466; ED16qr 0.266/0.367/1.216; O.I. ED: 0.486 / 0.266 / **0.021**.

Leitura: 2-day window qualitativamente similar (com alguma instabilidade nos Treasuries); **5-day window rejeita as overidentifying restrictions** para stocks e bonds — a frequência semanal quebra a homoskedasticidade dos outros choques (ou a estabilidade dos parâmetros), o que também explica a instabilidade dos pontos. Lição: manter a janela diária estreita.

### Outras robustezas

- Lags / resíduos de VAR: resultados quase idênticos.
- Medida alternativa de choque (current-month **fed funds futures**, à la Kuttner): respostas menores em geral (ruído de timing shocks); diferenças ES vs het persistem com o mesmo sinal, mas menores — o eurodollar de 3m tem horizonte mais longo, agravando endogeneidade/omitted variables. Resultados no NBER WP #8794.

### Conclusão sobre o viés do event-study

Viés modesto mas sistemático: ES **subestima** o impacto negativo em ações e **superestima** o impacto positivo na curva de juros (crescente na maturidade). Estatisticamente: não rejeitado para ações (Hausman IV e GMM), rejeitado para futures/Treasuries via GMM (0.004 / 0.000) mas não via IV (0.925 / 0.293) — evidência mista. Independentemente da significância, o estimador het, por exigir hipóteses mais fracas, "likely provides a more accurate measure".

## 7. Contributions

1. Novo estimador da resposta de asset prices à política monetária via identification through heteroskedasticity com regimes de calendário (FOMC/testimony), sob hipóteses (6)-(8) muito mais fracas que a near-identification (4)-(5) do event-study.
2. Demonstração formal de que o event-study é o **caso-limite** do estimador het (shift infinito de variância) e derivação da expressão exata do viés OLS/ES (Eq. 3), com direção assinada por classe de ativo.
3. Dupla implementação prática: IV com instrumentos sign-flipped (roda em qualquer pacote, asymptotics padrão) e GMM eficiente com teste de overidentification embutido.
4. Primeiro **teste estatístico** das hipóteses do event-study (Hausman het vs ES) — ausente da literatura apesar do uso disseminado.
5. Números de referência: 25 bp ⇒ S&P −1.7%, Nasdaq −2.4%; pass-through >1 no curto prazo da curva decaindo para ~0 em 10-30y (GMM); reinterpretação do puzzle de Cochrane-Piazzesi como viés de omitted variables.

## 8. Replication feasibility

**Alta.** Dados públicos: Treasury CMT yields do H.15 (Federal Reserve), eurodollar futures da CME (histórico comercial), índices de ações padrão, calendário de FOMC/testimonies público. Sem repositório de código/dados mencionado (padrão da época), mas os estimadores são fórmulas fechadas (10)-(13) + GMM two-step padrão — reimplementáveis em poucas linhas. Detalhes que a replicação deve respeitar: (i) amostra 1994-2001 e exclusão de 5 feriados; (ii) non-policy = dia anterior; (iii) policy rate = nearest eurodollar future; (iv) slope specification para taxas (footnote 20); (v) 3SLS/momentos empilhados por classe. Resultados extras no NBER WP #8794. Appendices A (validade dos instrumentos) e B (consistência sob heteroskedasticidade temporal) não estão nos chunks do corpo principal.

## 9. Mapeamento para o projeto (Brasil)

- O `script/instrument_het.R` do projeto (Rigobon-Sack 2003/2004 + GRG 2025) usa exatamente a lógica (6)-(8): regime C = quarta de Copom, NC = demais dias, com `Sigma_C - Sigma_NC` rank-1 e `b_1 = sqrt(lambda_1) v_1` — a versão multivariada de (9). O teste de proporcionalidade/rank-1 (het_rank_test*.csv) é o análogo do delta_oir.
- A escolha ~F = dia imediatamente anterior e a lição da Table 5 (janela de 5 dias quebra (7)-(8)) sustentam a janela Wed→Thu estreita do projeto.
- Footnote 11 = a ponte para a preocupação de weak identification (denominador de (10) com massa em zero sem heteroskedasticidade) — no projeto, coberta por ξ_mp / F factor-space.
- A direção do viés ES (atenuação em ações, inflação da resposta em yields longos) é o argumento-template para justificar o pivot de event-study/proxy para het no texto do paper.
