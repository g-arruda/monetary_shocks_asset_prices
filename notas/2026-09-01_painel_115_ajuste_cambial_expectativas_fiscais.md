# Painel conjunto: ajuste cambial e expectativas fiscais

> **SUPERADA — 2026-09-01.** Painel de 115 séries, 153 meses,
> `(r,q,p)=(5,5,4)`, `z_jk_bs_purif`, choque de +50 pb em `yield_6m`,
> horizonte 0--48 e 800 réplicas somente na célula final. O painel permanece
> experimental e não altera a produção de 111 séries, mas suas quatro novas
> respostas aparecem no manuscrito como exercício complementar. Esta nota foi
> superada pela promoção canônica para `(4,4,4)` registrada em
> `notas/2026-09-01_migracao_producao_painel_115.md`. Fonte:
> `script/fiscal_exchange_expectations.R` e
> `output/fiscal_exchange_expectations/`.

## Desenho e auditoria

Foram reestimados quatro painéis: `baseline_111`, `exchange_112`,
`expectations_114` e `exchange_expectations_115`. O bloco cambial contém
somente a linha literal “Ajuste cambial” da aba *Fluxos mensais* de
`Evodlp.xlsx`, em R$ milhões. Entre 2013-01 e 2025-09, ela é finita e coincide
com a soma de “Dívida interna indexada ao câmbio” e “Dívida externa —
metodológico” dentro da tolerância de arredondamento. “Dívida externa — outros
ajustes” não foi incluída e não integra a interpretação da IRF cambial.

A cascata sazonal usada nas extensões experimentais classificou o ajuste
cambial como não sazonal, portanto preservou a linha publicada. As três
expectativas Focus para o ano seguinte são idênticas, observação por
observação, à vintage auditada na rodada isolada de 114 séries. As quatro
adições entram em nível, com `tcode=1`. O gate do painel final confirmou 153
meses, 115 nomes únicos e nenhuma observação ausente ou não finita.

## Seleção fatorial

O Bai--Ng com padronização BLL foi refeito para `r=1,...,20` nas duas amostras.
Na amostra cheia, IC1/IC2/IC3 selecionam respectivamente:

| painel | IC1 | IC2 | IC3 |
|---|---:|---:|---:|
| baseline 111 | 5 | 5 | 20 |
| ajuste cambial 112 | 5 | 5 | 20 |
| expectativas 114 | 5 | 4 | 20 |
| conjunto 115 | 5 | **4** | 20 |

No pré-COVID, os quatro painéis selecionam `r=3/2/20` por IC1/IC2/IC3. O IC2
é a régua decisória do projeto: o painel 115 seleciona, portanto, **r=4** na
amostra cheia e **r=2** no pré-COVID. A comparação de composição permanece
deliberadamente fixada em `r=5`.

O Amengual--Watson, condicionado a `r=5` e `p=4`, seleciona `q=2` nos quatro
painéis e nas duas amostras. Esse resultado é reportado separadamente e não
substitui o `q=5` fixo do exercício. As superfícies completas estão em
`bai_ng_bll_surface.csv` e `amengual_watson_surface.csv`.

## Força e estabilidade em `(5,5,4)`

| painel | amostra | xi_mp | var. vs. baseline | F_rob,mp | var. vs. baseline | raiz máxima |
|---|---|---:|---:|---:|---:|---:|
| baseline 111 | cheia | 5,240158 | 0,00% | 10,060922 | 0,00% | 0,968126 |
| ajuste cambial 112 | cheia | 5,355034 | +2,19% | 10,295045 | +2,33% | 0,968744 |
| expectativas 114 | cheia | 5,805646 | +10,79% | 11,761132 | +16,90% | 0,969027 |
| conjunto 115 | cheia | **5,888198** | **+12,37%** | **11,936511** | **+18,64%** | **0,970092** |
| baseline 111 | pré-COVID | 7,478324 | 0,00% | 11,874945 | 0,00% | 0,992483 |
| ajuste cambial 112 | pré-COVID | 5,613978 | -24,93% | 7,110756 | -40,12% | 0,987675 |
| expectativas 114 | pré-COVID | 8,124920 | +8,65% | 13,679068 | +15,19% | 0,991812 |
| conjunto 115 | pré-COVID | **6,747499** | **-9,77%** | **9,421890** | **-20,66%** | **0,988398** |

Todas as companions são estáveis. A baseline reproduz exatamente os cinco
impactos canônicos e, a seis casas, os quatro alvos de força: `5,240158 /
10,060922` na amostra cheia e `7,478324 / 11,874945` no pré-COVID.

## IRFs do painel 115

O gate terminou as 800 réplicas com zero falhas, bandas de 68% e 90% finitas e
ordenadas e `yield_6m(h=0)=0,005`.

No impacto, o ajuste cambial cai R$ 11.816,8 milhões, com banda de 68% entre
R$ -26.635,9 e R$ -3.414,2 milhões. A resposta pontual torna-se positiva em
`h=2`, oscila nos meses seguintes e cruza zero novamente em `h=25`, enquanto a
banda de 68% abrange zero depois do impacto. Como a DLSP também cai no impacto
(-0,606 ponto do PIB, banda de 90% [-0,884; -0,393]), o sinal é compatível com
o canal mecânico pelo qual a depreciação valoriza reservas em reais e reduz a
DLSP. O exercício não mede quanto da queda da DLSP decorre do ajuste cambial.

A expectativa de DLSP cai 0,208 ponto do PIB no impacto, atinge o vale de
-0,747 em `h=8`, exclui zero pela banda de 68% até `h=20` e cruza zero em
`h=25`. A expectativa de resultado primário cai 0,052 no impacto, cruza zero
em `h=4` e atinge o pico de 0,074 em `h=16`, mas sua banda de 68% abrange zero
em todo o horizonte. A expectativa de resultado nominal cai 0,168 no impacto,
atinge o vale de -0,222 em `h=2`, exclui zero pela banda de 68% até `h=14` e
cruza zero em `h=17`.

As três expectativas fornecem evidência mista. O resultado nominal esperado se
deteriora, a DLSP esperada melhora e o resultado primário permanece impreciso.
Esse padrão pode estar associado ao prêmio de risco, mas não sustenta uma
deterioração geral da sustentabilidade fiscal nem identifica a mediação causal
entre juros, percepção fiscal e spreads soberanos.

## Veredito

**O bloco conjunto é estável e reforça a relevância na amostra cheia, mas não
justifica promover o painel.** O manuscrito apresenta suas quatro respostas
como complemento explicitamente experimental. O IC2 BLL cai de cinco para quatro fatores,
`xi_mp=5,888198` permanece abaixo de 10 e, no pré-COVID, força e primeiro
estágio recuam em relação à baseline. O ajuste cambial oferece evidência
sugestiva para o mecanismo contábil apenas no impacto. As expectativas fiscais
têm respostas mistas e não sustentam deterioração geral da sustentabilidade.
