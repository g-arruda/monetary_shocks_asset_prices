# Diagnóstico contrafactual do VAR em níveis com AIC e tendência linear

**Data:** 2026-08-22
**Objeto:** VAR observável em níveis para
`{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}`, com constante e tendência
linear em cada equação, ordem escolhida por AIC, instrumento
`z_jk_bs_purif`, NW(0) e normalização de +50 pb em `yield_6m`.
**Status:** diagnóstico contrafactual; não altera nem reabre o benchmark ativo.

## Conclusão

Com tendência linear, o AIC seleciona **`p = 2`**. A estatística de força do
instrumento é

\[
\boxed{\xi_{mp}=6{,}797335}.
\]

O sistema estimado é estável, com maior módulo `0,965424`, mas permanece muito
mais persistente que o benchmark estacionário ativo. A raiz dominante é um par
complexo, com meia-vida de `19,70` meses e período de `82,95` meses. Assim, as
respostas têm uma cauda geometricamente amortecida e oscilatória. Elas não
seguem `1/h` e tampouco são bem resumidas por uma exponencial real monotônica.

A inclusão da tendência reduz fortemente a raiz máxima em relação ao VAR em
níveis sem tendência (`0,995386 -> 0,965424`) e eleva a força
(`5,849952 -> 6,797335`). Entretanto, não resolve o problema de
estacionariedade: com ADF e PP especificados com tendência, quatro das cinco
séries ainda não rejeitam raiz unitária.

## Convenção do AIC e validação

Todas as ordens `p = 1,...,12` foram estimadas sobre as mesmas `T = 141`
observações. Cada equação contém constante e tendência linear. O critério usado
é o mesmo de `vars::VARselect(type = "both")`:

\[
AIC(p)=\log|\widehat\Sigma_p|+
\frac{2}{T}\left(pN^2+2N\right).
\]

O termo `2N` conta constante e tendência nas `N = 5` equações. Como esse termo
é comum a todas as ordens, incluí-lo muda o nível do AIC, mas não seu argmin. A
implementação manual coincide com `vars::VARselect` com desvio máximo de
`2,84e-14`.

| p | log-determinante | parâmetros penalizados | AIC | diferença para o mínimo |
|---:|---:|---:|---:|---:|
| 1 | -11,069877 | 35 | -10,573423 | 0,269442 |
| 2 | -11,693929 | 60 | **-10,842865** | 0,000000 |
| 3 | -11,929678 | 85 | -10,724004 | 0,118861 |
| 4 | -12,269933 | 110 | -10,709649 | 0,133216 |
| 5 | -12,623592 | 135 | -10,708699 | 0,134166 |
| 6 | -12,938349 | 160 | -10,668845 | 0,174020 |
| 7 | -13,190205 | 185 | -10,566092 | 0,276773 |
| 8 | -13,371421 | 210 | -10,392697 | 0,450168 |
| 9 | -13,604073 | 235 | -10,270740 | 0,572125 |
| 10 | -14,254804 | 260 | -10,566860 | 0,276004 |
| 11 | -14,630944 | 285 | -10,588391 | 0,254474 |
| 12 | -14,925881 | 310 | -10,528718 | 0,314147 |

O AIC escolhe inequivocamente `p = 2`, embora `p = 3--5` fiquem relativamente
próximos, com diferenças entre 0,119 e 0,134.

## Força do instrumento e gates

Na notação do módulo do VAR observável, a estatística aparece como `xi_var`; na
direção de normalização monetária solicitada, ela é a mesma
`xi_mp = 6,797335214`. O cálculo usa `yield_6m`, NW(0), 151 resíduos e 61 meses
com instrumento não nulo.

- amostra em níveis: 153 meses;
- amostra comum do AIC: 141 observações;
- ordem selecionada: `p = 2`;
- resíduos da estimação final: 151;
- observações com instrumento não nulo: 61;
- normalização: `B_1[yield_6m] = 0,005` exatamente;
- `xi_mp = 6,797335`;
- maior raiz: `0,965423695`;
- identidade `IRF_h = C_hB_1`: desvio zero na precisão da máquina.

O valor de `xi_mp` permanece abaixo de 10. Ele é um diagnóstico de relevância
do instrumento na direção de normalização, não um teste da validade da proxy.

## Testes de raiz unitária com tendência

O ADF usa tendência, constante e seleção AIC entre até quatro defasagens. O PP
usa Z-tau com tendência. Os valores críticos de 5% são aproximadamente `-3,43`
no ADF e `-3,44` no PP.

| variável | ADF | PP Z-tau | ADF rejeita a 5%? | PP rejeita a 5%? |
|---|---:|---:|:---:|:---:|
| `ibc_br` | -1,8734 | -1,7463 | não | não |
| `price_ipca` | -5,3041 | -6,8928 | sim | sim |
| `yield_6m` | -2,3429 | -1,0648 | não | não |
| `cambio_usd` | -2,5880 | -2,1933 | não | não |
| `cds_5y` | -3,1089 | -3,0644 | não | não |

Somente `price_ipca` rejeita raiz unitária pelos dois testes. A tendência
determinística não torna IBC-Br, yield, câmbio ou CDS estacionários em torno de
uma tendência linear.

## Espectro da companion do VAR(2)

| raiz ou par | módulo | meia-vida | período |
|---:|---:|---:|---:|
| 0,962656 ± 0,073054i | 0,965424 | 19,70 meses | 82,95 meses |
| 0,931382 | 0,931382 | 9,75 meses | — |
| 0,741177 | 0,741177 | 2,31 meses | — |
| 0,406653 ± 0,170992i | 0,441141 | 0,85 mês | 15,79 meses |
| 0,221293 | 0,221293 | 0,46 mês | — |
| -0,167355 ± 0,061866i | 0,178424 | 0,40 mês | 2,25 meses |
| 0,160385 | 0,160385 | 0,38 mês | — |

Em `h = 60`, o par dominante já explica aproximadamente 77% da soma das
contribuições modais no IBC-Br, 96% no IPCA, 99% no yield, 95% no câmbio e 95%
no CDS. Em `h = 120`, sua participação fica entre 81% e 99,7%. As diferenças
entre variáveis nos primeiros horizontes decorrem de projeções e cancelamentos,
não de raízes distintas.

## Respostas por variável

“Convergência permanente” é o primeiro horizonte após o qual a resposta nunca
mais excede 1% do seu pico absoluto. A busca foi feita até `h = 1200` para não
confundir passagem temporária por zero com convergência.

| variável | impacto, escala da figura | pico absoluto | razão `h1/h0` | convergência permanente a 1% |
|---|---:|---:|---:|---:|
| IBC-Br | -0,7031% da média | -0,7031% em h=0 | 0,686 | h=71 |
| IPCA | -0,0187 p.p. | +0,0537 p.p. em h=3 | -1,366 | h=127 |
| DI 6 meses | +50,0 pb | +73,33 pb em h=6 | 1,266 | h=141 |
| câmbio BRL/USD | +1,9580% da média | +2,8870% em h=1 | 1,474 | h=122 |
| CDS 5 anos | +18,8585 pb | +21,9656 pb em h=1 | 1,165 | h=102 |

A tendência e a segunda defasagem geram amplificação inicial em quatro das
cinco respostas. O yield normalizado em +50 pb cresce até +73,33 pb em `h = 6`,
cruza zero entre `h = 24` e `h = 36`, chega a -18,64 pb em `h = 48` e volta a
+3,86 pb em `h = 84`. O câmbio passa de +2,89% em `h = 1` para -0,98% em
`h = 24` e retorna a +0,25% em `h = 60`. Esse formato é coerente com o par
complexo dominante.

## `1/h` contra dinâmica geométrica

Na janela `h = 0--36`, uma exponencial real simples ajusta melhor que
`a/(h+1)` nas cinco respostas, mas a vantagem é modesta em IBC-Br, IPCA e
câmbio. A razão entre os erros normalizados hiperbólico e geométrico é 1,23;
1,14; 2,62; 1,27; e 3,69, respectivamente, para IBC-Br, IPCA, yield, câmbio e
CDS.

Na cauda, uma exponencial real também é incompleta porque o modo dominante é
complexo. A representação correta é a soma finita dos modos da companion:

\[
IRF_h=J A_c^h J'B_1=\sum_k d_k\lambda_k^h,
\]

com envelope dominante aproximadamente

\[
0{,}965424^h
\{a\cos(0{,}07575h)+b\sin(0{,}07575h)\}.
\]

Logo, o decaimento é geométrico e oscilatório, não hiperbólico. A inclusão da
tendência não restaura a convergência em poucos meses vista no VAR
estacionário.

## Comparação entre os três exercícios

| diagnóstico | estacionário ativo | níveis, BIC, sem tendência | níveis, AIC, com tendência |
|---|---:|---:|---:|
| ordem | p=1 | p=1 | **p=2** |
| critério | BIC | BIC | AIC |
| `xi_mp` | 6,024922 | 5,849952 | **6,797335** |
| maior módulo | 0,683593 | 0,995386 | **0,965424** |
| meia-vida dominante | 1,82 mês | 149,9 meses | **19,7 meses** |
| período dominante | — | 250,4 meses | **83,0 meses** |

Como critério e determinísticos mudaram simultaneamente, esta comparação não
identifica separadamente quanto da diferença vem do AIC e quanto vem da
tendência. Ela responde apenas ao contrafactual conjunto solicitado.

## Blindspot Report

**Output:** IRFs contrafactuais de um VAR(2) em níveis com constante e tendência;
unidade de variação: horizonte mensal, variável e modo próprio.
**Date:** 2026-08-22

### Vice 1: The Unexplained Feature

- **Object and unit of variation:** cinco respostas até `h = 1200`, com dez
  raízes da companion.
- **Hardest feature to explain, stated as a feature:** yield, câmbio e CDS
  aumentam depois do impacto e mudam de sinal antes de convergir.
- **Explanation attempted:** a segunda defasagem e o par dominante complexo
  geram amplificação e oscilação; a decomposição modal reproduz exatamente as
  trajetórias.
- **Resolved?** yes — **DONE** algebricamente; **FLAG** economicamente, porque
  quatro entradas continuam não estacionárias.
- **Findings:** um painel truncado em `h = 36` mostraria a primeira reversão,
  mas não o ciclo completo de 83 meses.

### Vice 2: The Convenient Absence

- **Missing checks identified:** o exercício conjunto não separa o efeito de
  trocar BIC por AIC do efeito de adicionar a tendência; isso exigiria as duas
  células cruzadas adicionais.
- **Missing subgroups:** não há subamostras ou regimes, e o exercício não foi
  autorizado como nova grade de sensibilidade.
- **Unexplained N changes:** nenhum. O AIC usa `T = 141` comum; o VAR(2) final
  perde duas observações e deixa 151 resíduos.
- **Findings:** a atribuição causal da mudança a “AIC” ou “tendência” isoladamente
  permanece **FLAG**; o contrafactual conjunto está identificado.

### Virtue 1: The Unasked Question

- **Heterogeneity opportunities:** o IBC-Br converge em 71 meses, enquanto o
  yield leva 141, apesar do mesmo espectro; projeções modais explicam a diferença.
- **Mechanism evidence:** a tendência absorve parte da persistência de baixíssima
  frequência, mas não elimina as raízes unitárias indicadas por ADF/PP.
- **Secondary findings:** `xi_mp` melhora para 6,80, porém continua abaixo de 10.
- **Findings:** o exercício separa “estabilidade numérica da companion” de
  “estacionariedade defensável das séries” — **DONE**.

### Virtue 2: The Unexploited Strength

- **Undersold design features:** o AIC manual é validado contra
  `vars::VARselect`, e os gates de instrumento, normalização e IRF passam sem
  alterar o pipeline.
- **Unused falsification tests:** os ADF/PP com tendência falsificam a leitura
  de que uma tendência determinística basta para tornar o sistema admissível.
- **Positioning opportunities:** o contraste mostra que a convergência rápida do
  benchmark ativo não é produto de `p = 1`; ela depende da estacionarização.
- **Findings:** o contrafactual negativo reforça a escolha ativa — **DONE**.

### Ruling

[ ] CLEAR — proceed to interpretation. No vices found; virtues noted for consideration.
[ ] CONDITIONAL — proceed but acknowledge open questions explicitly. Vices flagged but manageable.
[x] HOLD — do not interpret or publish until flagged vices are resolved.

O veredito é **HOLD** para uso substantivo ou inferencial. O exercício pode ser
reportado como diagnóstico: AIC + tendência seleciona `p = 2`, produz
`xi_mp = 6,797335` e reduz a raiz dominante para 0,965424, mas não torna quatro
das cinco séries estacionárias.
