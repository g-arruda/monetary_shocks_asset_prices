# Gate de não-gaussianidade — inovações fatoriais η

Gerado por `script/nongaussian_gate.R` em 2026-08-17.
Especificação: r = 5, q = 5, p = 6; painel 2013-07-01 a 2025-09-01.

GMR (2017) e LMS (2017) identificam `C` apenas se **no máximo uma** das q
inovações estruturais for gaussiana (Comon 1994; Eriksson-Koivunen 2004;
GMR Prop. 2a). Este é o pré-requisito da rota inteira.

## Momentos e testes de normalidade

| janela | componente | T | assimetria | curtose | JB | p (JB) | p (Shapiro-Wilk) |
|---|---|---:|---:|---:|---:|---:|---:|
| full | eta_1 | 147 | -1.152 | 11.374 | 461.97 | 0.0000 | 0.0000 |
| full | eta_2 | 147 | 0.515 | 3.944 | 11.95 | 0.0025 | 0.0446 |
| full | eta_3 | 147 | -0.084 | 4.349 | 11.32 | 0.0035 | 0.0719 |
| full | eta_4 | 147 | -1.253 | 7.165 | 144.68 | 0.0000 | 0.0000 |
| full | eta_5 | 147 | -0.406 | 4.213 | 13.05 | 0.0015 | 0.0716 |
| pre_covid | eta_1 |  78 | 0.662 | 4.435 | 12.39 | 0.0020 | 0.0090 |
| pre_covid | eta_2 |  78 | 0.466 | 3.501 | 3.64 | 0.1624 | 0.4218 |
| pre_covid | eta_3 |  78 | 0.378 | 4.416 | 8.38 | 0.0152 | 0.0378 |
| pre_covid | eta_4 |  78 | -0.941 | 4.042 | 15.03 | 0.0005 | 0.0009 |
| pre_covid | eta_5 |  78 | 0.326 | 4.045 | 4.93 | 0.0851 | 0.0679 |

## Veredito

- **Full sample:** 0 de 5 componentes **não** rejeitam normalidade a 5%.
- **Pré-COVID:** 2 de 5 componentes não rejeitam normalidade a 5%.

O painel completo **passa** o gate (no máximo um gaussiano).

Na janela **pré-COVID** a situação é qualitativamente pior (2 de 5 gaussianos): a rota não-gaussiana **não existe** ali. A não-gaussianidade do painel é dirigida pela COVID. É justamente a janela em que o proxy é relativamente mais forte, então as duas identificações não podem ser comparadas nessa amostra.

## Onde vive a direção monetária do proxy

O que o paper precisa identificado é a **coluna monetária**, não `C` inteira.
Decomposição da direção de impacto do proxy `H = (Z'η)/(Z'Z)`, normalizada:

| componente | h_j | h_j² | rejeita normalidade (full) |
|---|---:|---:|---|
| eta_1 | -0.451 | 0.203 | sim |
| eta_2 | 0.840 | 0.706 | sim |
| eta_3 | 0.172 | 0.030 | sim |
| eta_4 | 0.248 | 0.062 | sim |
| eta_5 | -0.011 | 0.000 | sim |

- Massa no span **não-gaussiano**: **1.000**
- Massa no span **quase-gaussiano**: **0.000**

A direção monetária está majoritariamente no subespaço identificado, o que sustenta estimá-la por ICA apesar da não-identificação parcial de `C`. A evidência que fecha o argumento é o erro-padrão da coluna e sua estabilidade entre partidas do otimizador, abaixo.

## Ajuste PML no full sample (diagnóstico de identificação)

- Pseudo-densidades: 5 misturas de gaussianas distintas e assimétricas (A.5), sigma = 0.40, 0.62, 0.85, 1.08, 1.30
- Log-verossimilhança pseudo: -1003.31
- Partidas: 100; convergiram: 100; **no melhor ótimo: 1**
- Distância do melhor ao segundo ótimo: **0.0600** unidades de log-lik (T = 147)
- **cond(A) = 4.947e+01** — cresce sem limite conforme o conjunto identificado degenera

### Estabilidade da coluna monetária entre partidas

O objetivo tem muitos ótimos locais, então estabilidade só significa algo
**condicionada a a partida ter chegado perto do máximo**: uma partida a 10
unidades de log-verossimilhança do ótimo é falha do otimizador, não evidência
sobre o conjunto identificado. Cada `C` é alinhada à vencedora antes de comparar.

| tolerância em log-lik | partidas | max\|ΔC[,mp]\| | cosseno mínimo |
|---:|---:|---:|---:|
| 0.5 | 3 | 0.0154 | 0.9997 |
| 2.0 | 3 | 0.0154 | 0.9997 |
| 5.0 | 21 | 0.7318 | 0.6366 |
| 10.0 | 77 | 0.7318 | 0.5565 |

Estabilidade por coluna entre as partidas a menos de 2 unidades do ótimo:

| coluna | max\|ΔC[,j]\| | rejeita normalidade |
|---|---:|---|
| 1 (monetária) | 0.0154 | sim |
| 2 | 0.0609 | sim |
| 3 | 0.0527 | sim |
| 4 | 0.0605 | sim |
| 5 | 0.0656 | sim |

Rotulagem pelo proxy — o `z` **não** identifica aqui, só nomeia:

- Coluna escolhida: **1**; |cor(ε_j, z)| = 0.270
- Segunda colocada: 0.230; folga = **0.040**
- Correlações completas: 0.270, 0.036, 0.230, 0.048, 0.054

Erro-padrão assintótico (Prop. 4) da coluna monetária, elemento a elemento:

| elemento | estimativa | erro-padrão | t |
|---|---:|---:|---:|
| c[1,1] | -0.074 | 0.064 | -1.16 |
| c[2,1] | -0.532 | 0.056 | -9.44 |
| c[3,1] | 0.063 | 0.069 | 0.92 |
| c[4,1] | -0.766 | 0.043 | -17.63 |
| c[5,1] | -0.346 | 0.067 | -5.17 |

> Se a coluna monetária tem erros-padrão apertados e dispersão desprezível
> entre partidas, ela está identificada mesmo com `C` não estando por inteiro,
> e a identificação não-gaussiana pode ser reportada como resultado de primeira
> ordem. Caso contrário, o vale plano do bloco gaussiano contaminou a coluna e
> a rota só serve como checagem qualitativa de sinal.

