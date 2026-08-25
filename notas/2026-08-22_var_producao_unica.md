# VAR pequeno: produção única e conjuntos AR de 68%/90%

> **CURRENT.** Rodada de 2026-08-22. `script/model_var.R`, proxy
> `z_jk_bs_purif`, normalização em `yield_6m` a +50 pontos-base, amostra
> 2013-01--2025-09. A única célula ativa é `ibc5_fx_cds_stat_p1`; o DFM e sua
> inferência permanecem inalterados.

## Decisão

As seis sensibilidades do VAR pequeno foram removidas. Elas foram construídas
antes de o BIC de `bicaic.m` e os testes de estacionariedade definirem a
especificação atual e não permanecem como robustez. A célula de produção contém
`{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}`: IPCA em nível e as demais
séries em primeira diferença.

O BIC literal de Olea, calculado em amostra comum de 140 observações, seleciona
`p=1`. A forma reduzida segue `RForm_VAR.m`; há um único impacto
`B_1=0,005 Gamma/Gamma_yield`, e a resposta no horizonte `h` é `C_h B_1`, sem
soma entre horizontes. A companion tem raiz máxima `0,683593` e o diagnóstico
de relevância é `xi_var=6,02492`.

## Inferência e artefatos

O CSV canônico contém os conjuntos Anderson--Rubin/MOSW de 68% e 90%, com
Newey--West de ordem zero: 184 intervalos e um singleton de normalização em
cada nível. A figura `paper/fig_weak_iv_main.pdf` sobrepõe a faixa de 90% em
azul-claro e a de 68% em azul-escuro. No impacto, o câmbio responde `0,0927`
(conjunto AR de 90% `[0,0429; 0,1970]`) e o CDS responde `20,1193` pontos-base
(`[11,3231; 41,4271]`).

`script/validate_mosw_ar.R` continua validando o algoritmo contra os conjuntos
de 68% e 95% fornecidos pelo fixture oficial; isso não altera os níveis
publicados da produção. Os artefatos produzidos são
`output/var/{var_benchmark_unit_root,var_benchmark_lag_criteria}.csv`,
`output/var/svar_iv_weak_robust.{csv,md}`,
`output/var/svar_iv_weak_robust_diag.csv` e `paper/fig_weak_iv_main.pdf`.

Os conjuntos cobrem respostas do VAR observável, nunca as respostas do DFM, e
robustez a instrumento fraco não estabelece a validade da proxy comum.
