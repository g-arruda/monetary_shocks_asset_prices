# Gate de não-gaussianidade — inovações fatoriais η

Gerado por `script/nongaussian_gate.R` em 2026-07-27.
Especificação: r = 7, q = 6, p = 6; painel 2013-07-01 a 2025-09-01.

GMR (2017) e LMS (2017) identificam `C` apenas se **no máximo uma** das q
inovações estruturais for gaussiana (Comon 1994; Eriksson-Koivunen 2004;
GMR Prop. 2a). Este é o pré-requisito da rota inteira.

## Momentos e testes de normalidade

| janela | componente | T | assimetria | curtose | JB | p (JB) | p (Shapiro-Wilk) |
|---|---|---:|---:|---:|---:|---:|---:|
| full | eta_1 | 147 | 1.155 | 8.190 | 197.67 | 0.0000 | 0.0000 |
| full | eta_2 | 147 | -0.493 | 5.063 | 32.02 | 0.0000 | 0.0014 |
| full | eta_3 | 147 | 0.952 | 7.360 | 138.62 | 0.0000 | 0.0000 |
| full | eta_4 | 147 | 0.118 | 3.928 | 5.62 | 0.0602 | 0.0231 |
| full | eta_5 | 147 | -0.088 | 2.593 | 1.20 | 0.5475 | 0.6684 |
| full | eta_6 | 147 | -0.087 | 2.837 | 0.35 | 0.8401 | 0.9322 |
| pre_covid | eta_1 |  80 | 0.135 | 3.616 | 1.51 | 0.4702 | 0.5130 |
| pre_covid | eta_2 |  80 | 0.035 | 2.850 | 0.09 | 0.9556 | 0.5317 |
| pre_covid | eta_3 |  80 | -0.158 | 2.450 | 1.34 | 0.5116 | 0.3014 |
| pre_covid | eta_4 |  80 | 0.859 | 5.229 | 26.40 | 0.0000 | 0.0025 |
| pre_covid | eta_5 |  80 | -0.176 | 2.434 | 1.48 | 0.4775 | 0.5270 |
| pre_covid | eta_6 |  80 | -0.327 | 3.051 | 1.44 | 0.4875 | 0.6246 |

## Veredito

- **Full sample:** 3 de 6 componentes **não** rejeitam normalidade a 5%.
- **Pré-COVID:** 5 de 6 componentes não rejeitam normalidade a 5%.

O painel completo **falha** o gate em sentido estrito: com 3 componentes indistinguíveis de gaussianos, `C` fica identificada apenas a menos de uma rotação arbitrária dentro desse subespaço de dimensão 3. Os demais componentes seguem identificados — a não-identificação é **parcial**, confinada ao bloco gaussiano.

Na janela **pré-COVID** a situação é qualitativamente pior (5 de 6 gaussianos): a rota não-gaussiana **não existe** ali. A não-gaussianidade do painel é dirigida pela COVID. É justamente a janela em que o proxy é mais forte (ξ_mp 12,22), então as duas identificações não podem ser comparadas nessa amostra.

## Onde vive a direção monetária do proxy

O que o paper precisa identificado é a **coluna monetária**, não `C` inteira.
Decomposição da direção de impacto do proxy `H = (Z'η)/(Z'Z)`, normalizada:

| componente | h_j | h_j² | rejeita normalidade (full) |
|---|---:|---:|---|
| eta_1 | 0.489 | 0.239 | sim |
| eta_2 | 0.139 | 0.019 | sim |
| eta_3 | -0.633 | 0.401 | sim |
| eta_4 | -0.503 | 0.253 | **não** |
| eta_5 | -0.295 | 0.087 | **não** |
| eta_6 | -0.014 | 0.000 | **não** |

- Massa no span **não-gaussiano**: **0.660**
- Massa no span **quase-gaussiano**: **0.340**

A direção monetária está majoritariamente no subespaço identificado, o que sustenta estimá-la por ICA apesar da não-identificação parcial de `C`. A evidência que fecha o argumento é o erro-padrão da coluna e sua estabilidade entre partidas do otimizador, abaixo.

## Ajuste PML no full sample (diagnóstico de identificação)

- Pseudo-densidades: 6 misturas de gaussianas distintas e assimétricas (A.5), sigma = 0.40, 0.58, 0.76, 0.94, 1.12, 1.30
- Log-verossimilhança pseudo: -1209.30
- Partidas: 100; convergiram: 100; **no melhor ótimo: 1**
- Distância do melhor ao segundo ótimo: **0.2189** unidades de log-lik (T = 147)
- **cond(A) = 3.706e+01** — cresce sem limite conforme o conjunto identificado degenera

### Estabilidade da coluna monetária entre partidas

O objetivo tem muitos ótimos locais, então estabilidade só significa algo
**condicionada a a partida ter chegado perto do máximo**: uma partida a 10
unidades de log-verossimilhança do ótimo é falha do otimizador, não evidência
sobre o conjunto identificado. Cada `C` é alinhada à vencedora antes de comparar.

| tolerância em log-lik | partidas | max\|ΔC[,mp]\| | cosseno mínimo |
|---:|---:|---:|---:|
| 0.5 | 4 | 0.0552 | 0.9956 |
| 2.0 | 12 | 0.0552 | 0.9956 |
| 5.0 | 31 | 0.3795 | 0.8300 |
| 10.0 | 76 | 0.7355 | 0.6366 |

Estabilidade por coluna entre as partidas a menos de 2 unidades do ótimo:

| coluna | max\|ΔC[,j]\| | rejeita normalidade |
|---|---:|---|
| 1 (monetária) | 0.0552 | sim |
| 2 | 0.3295 | sim |
| 3 | 0.5086 | sim |
| 4 | 0.4674 | **não** |
| 5 | 0.5105 | **não** |
| 6 | 0.1626 | **não** |

Rotulagem pelo proxy — o `z` **não** identifica aqui, só nomeia:

- Coluna escolhida: **1**; |cor(ε_j, z)| = 0.209
- Segunda colocada: 0.170; folga = **0.039**
- Correlações completas: 0.209, 0.170, 0.087, 0.038, 0.039, 0.145

Erro-padrão assintótico (Prop. 4) da coluna monetária, elemento a elemento:

| elemento | estimativa | erro-padrão | t |
|---|---:|---:|---:|
| c[1,1] | 0.671 | 0.051 | 13.17 |
| c[2,1] | 0.515 | 0.064 | 8.07 |
| c[3,1] | -0.038 | 0.063 | -0.61 |
| c[4,1] | -0.228 | 0.071 | -3.21 |
| c[5,1] | -0.386 | 0.067 | -5.75 |
| c[6,1] | 0.286 | 0.073 | 3.94 |

> Se a coluna monetária tem erros-padrão apertados e dispersão desprezível
> entre partidas, ela está identificada mesmo com `C` não estando por inteiro,
> e a identificação não-gaussiana pode ser reportada como resultado de primeira
> ordem. Caso contrário, o vale plano do bloco gaussiano contaminou a coluna e
> a rota só serve como checagem qualitativa de sinal.

