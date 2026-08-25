# Weak-IV, Caso 1: IBC-Br no lugar da indústria

> **SUPERADA/INVÁLIDA — VAR estimado em séries não estacionárias.** Rodada de 2026-08-20. Proxy `z_jk_bs_purif`, normalização em
> `yield_6m` a +50 pb (0,005), amostra 2013-01--2025-09, Eicker-White
> (`NWlags = 0`) e conjuntos Anderson--Rubin/MOSW analíticos. A célula conjunta
> IBC-Br + CDS é agora o **VAR de produção**, para robustez weak-IV e contraste
> com o DFM. Produção DFM intocada; isto não testa a validade do instrumento.

## Desenho

`script/model_var.R` e `script/model_var_weak_iv.R` usam como benchmark
`ibc5_cds_p4`. As seis demais células do driver weak-IV permanecem como
sensibilidades. Na troca de atividade, `ibc_br` **substitui**, sem se somar a,
`ind_transformacao`; `price_ipca`, `yield_6m`, a proxy, a normalização e a
amostra permanecem fixos.

| célula | variáveis | p | dimensão HAC / T |
|---|---|---:|---:|
| `ibc4_p6:cambio_usd` | `{ibc_br, price_ipca, yield_6m, cambio_usd}` | 6 | 104 / 147 |
| `ibc5_cds_p4` | `{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}` | 4 | 110 / 149 |

O VAR conjunto de cinco variáveis fica em `p = 4`: em `p = 6`, a dimensão HAC
seria 160 para 147 observações efetivas. A comparação entre as células de
quatro e cinco variáveis ainda confunde número de variáveis e defasagens; a
comparação causal aqui é IBC-Br contra indústria dentro de cada desenho.

## Gates antes da leitura

| célula | xi_var | F robusto | max\|lambda\| | conjunto AR 95% limitado |
|---|---:|---:|---:|---|
| `ibc4_p6:cambio_usd` | 11,446 | 22,060 | 0,9974 | sim |
| `ibc5_cds_p4` | 7,151 | 18,215 | 0,9905 | sim |

As duas raízes são inferiores a um; não há resultado explosivo que interrompa
a interpretação. Os auto-testes passaram nas sete células: `yield_6m(h=0) =
0,005` exatamente, o ponto de cada IRF coincide com o VAR convencional sob
`nboot = 0`, todo ponto pertence ao seu próprio conjunto e os conjuntos de
68%, 90% e 95% são aninhados. A validação independente do módulo MOSW contra o
fixture oficial e os dez casos degenerados também passou em
`script/validate_mosw_ar.R`.

O benchmark convencional foi reestimado com 800 réplicas e zero réplicas
falhas. A correção de Kilian, porém, ficou indefinida porque a equação de
Lyapunov é numericamente singular (`rcond = 1,62e-16`); por isso o bootstrap
usou coeficientes não corrigidos no DGP. O aviso está preservado em
`output/var/var_benchmark.md`, e não deve ser omitido se a comparação entrar no
corpo do artigo.

## Impacto: IBC-Br versus indústria

Conjunto AR de 90% no impacto. `sim` aplica a regra pré-fixada de rejeição de
`H0: IRF(0) <= 0`, isto é, conjunto inteiramente positivo.

| desenho | atividade | câmbio | CDS 5a |
|---|---|---|---|
| 4 variáveis, `p=6` | indústria | 0,0466 [−0,0150; 0,0970] — não | — |
| 4 variáveis, `p=6` | IBC-Br | **0,0588 [0,0049; 0,1077] — sim** | — |
| 5 variáveis, `p=4` | indústria | **0,0782 [0,0235; 0,1603] — sim** | **11,764 [1,765; 22,756] — sim** |
| 5 variáveis, `p=4` | IBC-Br | **0,0771 [0,0227; 0,1567] — sim** | **11,764 [0,703; 24,423] — sim** |

O IBC-Br próprio cai no ponto (−0,445 no VAR de quatro e −0,435 no conjunto),
mas seus conjuntos de 90% incluem zero: [−1,140; 0,036] e [−1,348; 0,087]. Não
há base para uma alegação de precisão sobre atividade.

## Decisão e leitura

O resultado central de curto prazo sobrevive à troca limpa de proxy de
atividade. A abertura de CDS é praticamente idêntica no VAR conjunto (11,764
nos dois desenhos) e continua com conjunto AR positivo; a depreciação cambial
também permanece positiva no conjunto. No VAR de quatro variáveis, a troca para
IBC-Br torna positivo o limite inferior cambial (0,0049), enquanto a célula
industrial continha zero.

Por decisão desta rodada, `ibc5_cds_p4` é o benchmark do VAR: contém no mesmo
sistema as duas variáveis headline e usa uma medida ampla de atividade. Com o
mesmo instrumento e normalização, o DFM tem impacto maior em quatro das cinco
séries no contraste de ponto; câmbio e CDS são 2,05 e 2,77 vezes o ponto do VAR
no impacto. Isto sustenta uma comparação de informação entre DFM e VAR pequeno,
não uma prova do DFM nem evidência nova sobre a validade de `z_jk_bs_purif`.

Os artefatos completos estão em `output/var/svar_iv_weak_robust.csv`,
`output/var/svar_iv_weak_robust_diag.csv` e
`output/var/svar_iv_weak_robust.md`; o último identifica explicitamente a
substituição de atividade.
