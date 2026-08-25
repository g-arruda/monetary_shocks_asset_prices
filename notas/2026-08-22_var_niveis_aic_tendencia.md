# VAR pequeno em níveis com AIC e tendência linear

**Data:** 2026-08-22
**Vintage:** produção corrente do benchmark VAR do paper
**Produtor:** `script/model_var.R`
**Artefatos:** `output/var/var_benchmark_lag_criteria.csv`,
`output/var/svar_iv_weak_robust.{csv,md}`,
`output/var/svar_iv_weak_robust_diag.csv` e `paper/fig_weak_iv_main.pdf`

## Especificação

O benchmark `ibc5_fx_cds_level_trend_p2` estima IBC-Br, IPCA, yield de seis
meses, câmbio BRL/USD e CDS soberano de cinco anos em nível. Cada equação inclui
constante e tendência linear. O instrumento é `z_jk_bs_purif`, e o choque é
normalizado para elevar o yield de seis meses em 50 pontos-base no impacto.

AIC e BIC comparam `p=1,...,12` sobre as mesmas 141 observações. O AIC seleciona
`p=2`, enquanto o BIC seleciona `p=1`; a produção segue o AIC. A implementação
manual coincide com `vars::VARselect(type = "both")` com desvio máximo de
`2,31e-14` e com uma implementação independente com desvio zero.

## Resultados e gates

O VAR(2) deixa 151 resíduos alinhados ao instrumento, dos quais 61 correspondem
a meses com instrumento não nulo. A estatística na direção de normalização é
`xi_mp=6,797335`, e a maior raiz da matriz companion é `0,965424`. A
normalização produz `B_1[yield_6m]=0,005` exatamente, e a identidade
`IRF_h=C_hB_1` vale na precisão da máquina.

O caminho Anderson--Rubin/MOSW publica conjuntos de 68% e 90% com NW(0). Nas
370 células de variável, horizonte e nível de cobertura, 368 conjuntos são
intervalos e os dois conjuntos do yield no impacto são singletons impostos
pela normalização. A validação preserva o fixture oficial de Montiel Olea,
Stock e Watson no caso com constante e estende o gate da célula brasileira à
tendência linear e aos dois critérios de ordem.

## Decisão

Esta rodada substitui integralmente o benchmark estacionário anterior no
código, nos artefatos, na figura e no paper. Não cria célula de sensibilidade,
não soma respostas entre horizontes e não altera a inferência do DFM.
