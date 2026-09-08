# Decomposição contábil da DLSP

> **BLOQUEADA — 2026-09-01.** A planilha `data/raw/DLSP/Evodlp.xlsx`, aba
> *Fluxos mensais*, não permite estimar o painel experimental de 118 séries
> sob a identidade de sete fluxos inicialmente definida. A produção DFM e
> `paper/paper_anpec.tex` permanecem inalterados. Fonte:
> `script/fiscal_dlsp_decomposition.R` e
> `output/fiscal_dlsp_decomposition/`.

## Auditoria da fonte

A planilha fornece os sete fluxos mensais do setor público consolidado em R$
milhões entre 2013-01 e 2025-09: variação da DLSP, NFSP, resultado primário,
juros nominais, ajuste cambial, reconhecimento de dívidas e privatizações. A
linha de resultado primário coincide com a SGS 4649 em toda a amostra. A maior
diferença em módulo é R$ 0,0128 milhão e a correlação é 1, o que é compatível
com arredondamento na planilha.

A identidade inicialmente prevista não fecha. A diferença máxima entre
`ΔDLSP` e `NFSP + ajuste cambial + reconhecimento de dívidas + privatizações`
é R$ 46.211 milhões. A diferença coincide com a linha separada “Dívida externa
— outros ajustes2/”, que não está incluída na linha “Ajuste cambial”. Quando
essa linha é acrescentada ao lado direito, o maior resíduo cai para R$
0,00000108 milhão.

## Veredito

O exercício não produziu seleção BLL, diagnóstico de força, estabilidade,
IRFs ou bootstrap, porque tratar a linha agregada “Ajuste cambial” como se ela
absorvesse “outros ajustes” atribuiria um componente contábil distinto ao
canal cambial. A sublinha foi preservada em
`exchange_adjustment_sublines_audit.csv`, mas não foi acrescentada ao painel.

Para retomar o exercício é preciso decidir se “Dívida externa — outros
ajustes2/” entra na identidade contábil apenas como termo de reconciliação ou
se integra o objeto econômico que será chamado de ajuste cambial. Essa decisão
altera o objeto a ser interpretado e não foi tomada nesta rodada.
