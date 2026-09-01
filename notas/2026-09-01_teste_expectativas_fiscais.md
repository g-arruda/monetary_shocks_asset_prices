# Teste das expectativas fiscais Focus

> **EXPERIMENTAL — 2026-09-01.** Esta nota descreve um painel alternativo e
> não altera a produção DFM, os artefatos canônicos ou `paper/paper_anpec.tex`.
> Fonte: `script/fiscal_expectations.R`; vintage Focus baixada nesta data.

## Desenho

O painel de produção de 111 séries foi comparado a um painel de 114, que soma
as medianas Focus anuais para o ano seguinte de DLSP, resultado primário e
resultado nominal. Para cada mês, a observação é a última publicação do mês.
As três séries entram em nível, sem log. DLSP maior significa deterioração
esperada; resultados primário e nominal mais negativos também.

A comparação fixa `(r,q,p)=(5,5,4)`, `z_jk_bs_purif`, `yield_6m` e choque de
+50 pb, nas amostras cheia e pré-COVID. A grade `(r,q)`, a seleção BLL e
Amengual--Watson e a bootstrap de 800 réplicas são registradas em
`output/fiscal_expectations/`.

## Resultado

A baseline reproduz `xi_mp=5,240158` e `F_rob,mp=10,060922` na amostra cheia.
O painel aumentado é estável e eleva esses números a `5,805646` e `11,761132`;
na pré-COVID, eleva ξ de `7,478324` a `8,124920`. O BLL IC2 seleciona `r=4`
no painel aumentado, mas a comparação deliberadamente mantém `r=5`.

O gate de bootstrap passou: 800 réplicas, zero falhas, bandas finitas e
ordenadas, e `yield_6m(h=0)=0,005`. A expectativa de DLSP cai e exclui zero
na banda de 90% em h=12. A de resultado nominal cai e exclui zero em h=0 e
h=6. A expectativa de resultado primário não exclui zero a 90% nos horizontes
reportados. Pelas convenções de sinal, os dois primeiros achados não sustentam
deterioração fiscal esperada após o choque.

## Veredito

**Sugestivo, não promocional.** A expansão não traz instabilidade nem reduz a
força, mas ξ permanece abaixo de 10, logo bandas bootstrap convencionais devem
ser lidas com cautela. O resultado não justifica mudar o painel de produção e
é contrário à narrativa de deterioração fiscal esperada no horizonte curto.
