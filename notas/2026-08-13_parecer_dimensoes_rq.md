# Parecer sobre as dimensões `(r,q)` do DFM

> **SUPERSEDED em 2026-08-13 pela
> [`decisão conjunta de painel e dimensões`](2026-08-13_decisao_conjunta_painel_dimensoes.md).**
> Esta nota preserva a auditoria do painel canônico de
> 106 séries no vintage 2013-01 a 2025-09, com `p=6`, `z_jk_bs_purif`, choque
> de +50 pb em `yield_6m`, 800 réplicas e semente 123. A amostra completa é o
> alvo da seleção, enquanto a janela pré-COVID entra apenas como robustez
> temporal. Os cálculos auxiliares foram executados com os módulos correntes do
> projeto e estão arquivados em
> [`diagnostics/rq_dimension_audit/`](../diagnostics/rq_dimension_audit/).
> Nenhum artefato de produção ou arquivo do paper foi alterado. A recomendação
> `(5,4)` não deve ser usada como decisão corrente porque o painel de 106 séries
> foi descartado como universo decisório; sua reprodução continua válida para
> aquele painel e vintage.

## Premissas, verificações e incertezas antes do veredito

- A decisão é para a **amostra completa** do painel canônico de 106 séries,
  2013-01 a 2025-09. A janela pré-COVID não recebe peso simétrico na seleção.
- A grade de 104 a 123 séries mede apenas sensibilidade à composição, pois até
  seu `baseline` tem 104 séries após remover `juros_cdi` e `asset_mlcx`.
- Mantiveram-se `p=6`, `z_jk_bs_purif`, choque de +50 pb em `yield_6m`, 800
  réplicas, semente 123 e bandas de 68% e 90%, conforme a
  [especificação corrente](../registro/pendencias.md#especificação-corrente).
- As datas mensais são exatas. O painel tem 153 observações na amostra completa
  e 84 na pré-COVID, com 106 séries finitas, nenhuma variância de primeira
  diferença nula, nenhuma data duplicada e recorte anterior à diferenciação.
- A célula canônica `(7,6)` reproduziu o RDS vigente ponto a ponto e banda a
  banda, com diferença máxima zero.
- A auditoria cruzada usou R e NumPy, mas não Stata. A construção dos painéis
  foi exportada pelo R e os critérios foram reimplementados em NumPy.
- O `cumsum` das ações permanece aberto, de modo que o Ibovespa não é usado
  além de `h=6` nem decide o ranking.

## Veredito

**A recomendação é `(r,q)=(5,4)`, com confiança média, como especificação
principal. `(7,6)` fica como robustez pré-especificada e `(7,7)` não deve
substituí-la.** Na amostra completa, o mínimo BLL/AW é `(5,3)`, mas sua Wald
MOSW é `xi_mp=3,42`, abaixo de 3,84. A vizinha admissível mais próxima é
`(5,4)`, com `xi_mp=4,77`. A raiz pré-COVID de 0,9979 e a variação das formas
entre janelas reduzem a confiança, mas não redefinem a dimensão principal.

O procedimento BLL/AW é válido para o painel canônico sob `p=6` e `q<=r`, com
ressalvas de implementação. As 128 escolhas experimentais foram reproduzidas
em R e NumPy, e a maior diferença foi `5,95e-14`, abaixo de `atol=1e-10` e
`rtol=1e-9`. As funções reutilizáveis não verificam explicitamente
desvio-padrão nulo, `max_q=15` permite em princípio `q>r` e a filtragem AW usa
equações normais, que falharam por SVD em uma célula experimental com `p=12`.
Esses problemas não alteraram os mínimos canônicos nem qualquer célula
principal com `p=6`.

## Auditoria BLL/AW

| etapa | status | evidência | impacto e correção mínima |
|---|---|---|---|
| Recorte antes da diferença | Passa | O produtor recorta em [`factor_selection_drop_blocks.R`](../script/panel_composition_factor_selection_drop_blocks.R#L54) e só então chama os critérios. A reprodução confirmou 153 e 84 meses. | Não há vazamento do pós-2019 para a janela pré-COVID. |
| Primeira diferença | Passa | `diff(X)` aparece em [`factor_estimation.R`](../R/modeling/factor_estimation.R#L57) para Bai-Ng e na [rotina AW](../R/modeling/factor_estimation.R#L171). | A transformação é coerente com a seleção BLL para painel não estacionário. |
| Remoção da média das diferenças | Passa com ressalva | A rotina calcula `ΔX-colMeans(ΔX)`. Essa operação remove o drift médio nas diferenças, mas não é numericamente idêntica, em amostra finita, ao detrending OLS dos níveis. A extração de fatores faz o segundo passo separadamente em [`factor_estimation.R`](../R/modeling/factor_estimation.R#L307). | A documentação não deve chamar as duas operações de equivalentes exatas. |
| Escala por `sd(ΔX)` | Passa nos dados, falha na guarda | A implementação está em [`factor_estimation.R`](../R/modeling/factor_estimation.R#L59). Todas as escalas atuais são finitas e positivas. | A função deve abortar se `sd<=0` ou não for finito. A ausência da guarda não afetou os mínimos atuais. |
| PCA e `V(r)` | Passa | A rotina faz PCA sem nova centralização, reconstrói o posto `r` e calcula `V=sum(e²)/(NT)` em [`factor_estimation.R`](../R/modeling/factor_estimation.R#L69). | A fórmula e a orientação `T x N` estão corretas. |
| Penalidades IC1 a IC3 | Passa | As penalidades estão em [`factor_estimation.R`](../R/modeling/factor_estimation.R#L85) e a busca usa `r=1,...,20`. | `r=0` é excluído por convenção e deve ser declarado. IC3 escolhe 20 nas 128 células, um mínimo de fronteira que não recomenda `r=20`. |
| Filtragem AW por VAR(6) | Passa na especificação principal | A rotina extrai os `r` fatores e projeta cada série em constante e seis defasagens em [`factor_estimation.R`](../R/modeling/factor_estimation.R#L184). O produtor fixa `p=6` em [`factor_selection_drop_blocks.R`](../script/panel_composition_factor_selection_drop_blocks.R#L15). | A regressão por equações normais deve ser substituída por QR ou SVD. |
| IC2 nos resíduos e seleção de `q` | Passa com ressalva | O IC2 é aplicado aos resíduos em [`factor_estimation.R`](../R/modeling/factor_estimation.R#L202), e o produtor impõe `q<=r`. | A chamada em `model_alessi.R` deve trocar `max_q=15` por `max_q=r`. `q=0` é excluído por convenção. |
| Estacionariedade complementar | Passa como diagnóstico | Na amostra completa, ADF rejeita raiz unitária em 88 de 106 séries e PP em 106. Na pré-COVID, as contagens são 77 e 102, com quatro séries sem rejeição nos dois testes. | O baixo poder em 84 meses não invalida automaticamente o painel diferenciado, mas os quatro casos devem ser reportados. |
| Replicação independente | Passa | As 128 escolhas coincidem. As diferenças máximas são `2,00e-15` nos critérios BN, `1,33e-15` nos critérios AW, `5,86e-14` nos autovalores BN e `5,95e-14` nos autovalores AW. | A tolerância registrada é `|R-Py| <= 1e-10 + 1e-9 max(|R|,|Py|)`. |

As fórmulas foram confrontadas com
[Bai e Ng (2002)](https://onlinelibrary.wiley.com/doi/pdf/10.1111/1468-0262.00273),
[Amengual e Watson (2007)](https://www.princeton.edu/~mwatson/papers/Amengual_Watson_JBES_2007.pdf)
e a padronização para painéis não estacionários de
[Barigozzi, Lippi e Luciani](https://conference.nber.org/confer/2016/SI2016/EFFE/Barigozzi_Lippi_Luciani.pdf).

### Conflito entre `p=6` e `p=12`

O produtor experimental usa `p=6` e `max_q=r`, enquanto
[`model_alessi.R`](../script/model_alessi.R#L28) chama AW com `p=12` e
`max_q=15`. A estimação de produção continua em `(7,6,6)`, como mostra a
[chamada principal](../script/model_alessi.R#L155), de modo que existe uma
divergência entre o diagnóstico legado e a especificação corrente.

No painel canônico, essa divergência não muda os resultados. A amostra completa
permanece em `(5,3)` e a pré-COVID em `(2,2)` nas quatro combinações formadas
por `p` igual a 6 ou 12 e limite de `q` igual a `r` ou 15. A ampliação do limite
para 15 também não escolheu `q>r` em qualquer painel experimental, embora esse
resultado empírico não torne a chamada teoricamente admissível.

A escolha de `p` altera a sensibilidade à composição. Passar de 6 para 12
mudou `q` em 42 das 63 células completas nas quais as duas rotinas terminaram,
mas não mudou nenhuma das 64 células pré-COVID. Uma célula full,
`drop_setor_externo__expectativas__eua`, falhou nas duas convenções de limite
com `p=12` e erro da rotina `dgesdd`.

A falha decorre do uso de `solve(Z'Z)`, que é numericamente frágil. `p=6` deve
ser a convenção decisória porque coincide com o VAR de produção e foi fixado
antes da comparação. O diagnóstico com `p=12` deve ser tratado como legado ou
sensibilidade até que a regressão AW use QR ou SVD e verifique o posto.

## Validação da grade experimental

A validação executável passou nas 2.304 células, formadas por 64 painéis, duas
amostras e 18 pares. As células têm chaves únicas, valores finitos, `q<=r`,
`N` entre 104 e 123 e nenhuma falha. O manifesto também confirma a ausência de
`juros_cdi` e `asset_mlcx`, a presença das 128 tabelas e a reprodução exata do
`baseline`, conforme os testes em
[`validate_panel_composition_rq_grid_drop_blocks.R`](../script/validate_panel_composition_rq_grid_drop_blocks.R#L35).

A grade não seleciona a dimensão canônica porque seu `baseline` é o painel de
106 séries menos as duas quase-duplicatas. A construção em
[`experimental_panel.R`](../R/identification/experimental_panel.R#L383) produz
104 séries nesse caso, de modo que a grade informa apenas a sensibilidade à
composição.

## Comparação das candidatas no painel canônico

`xi_mp` é a Wald MOSW na inovação fatorial implícita de `yield_6m`, calculada
com os controles do VAR em
[`factor_space_diagnostics.R`](../R/identification/factor_space_diagnostics.R#L72).
`F_rob,mp` é HC1. Todos os modelos têm raiz menor que um, e as 8.000 réplicas
bootstrap terminaram sem falhas.

| `(r,q)` | `xi_mp` full/pre | `F_rob,mp` full/pre | raiz full/pre | `xi>3,84` full/pre | sinais corretos full/pre | bandas 68 full/pre | bandas 90 full/pre | RMSE full/pre | decisão |
|---|---:|---:|---:|:---:|---:|---:|---:|---:|---|
| `(2,2)` | 6,44 / 2,88 | 16,15 / 3,86 | 0,9702 / 0,9773 | sim / não | 28/28 / 28/28 | 28 / 28 | 28 / 28 | 0,143 | distante do mínimo full, com alerta pré-COVID |
| `(5,3)` | 3,42 / 5,24 | 4,16 / 3,83 | 0,9655 / 0,9979 | não / sim | 27/28 / 28/28 | 22 / 22 | 16 / 17 | 0,609 | mínimo full, mas falha na relevância full |
| `(5,4)` | 4,77 / 7,89 | 6,85 / 6,96 | 0,9655 / 0,9979 | sim / sim | 24/28 / 24/28 | 23 / 22 | 18 / 15 | 1,554 | recomendada, com confiança média |
| `(7,6)` | 7,65 / 11,53 | 7,95 / 6,26 | 0,9747 / 0,9960 | sim / sim | 25/28 / 26/28 | 21 / 6 | 17 / 1 | 0,909 | robustez principal |
| `(7,7)` | 10,92 / 11,55 | 12,75 / 6,19 | 0,9747 / 0,9960 | sim / sim | 23/28 / 26/28 | 21 / 6 | 21 / 1 | 1,016 | não domina `(7,6)` |

As contagens cobrem 28 pontos fixados em `h=0,...,6` para `yield_6m`,
`yield_2y`, `yield_5y` e `asset_ibov`. As bandas de 68% são evidência
sugestiva, enquanto apenas as bandas de 90% sustentam a expressão
“estatisticamente significativo”. O RMSE é a média, entre as cinco variáveis,
do RMSE full e pré-COVID normalizado em `h=0,...,6`, de modo que ele funciona
como diagnóstico e não como função-objetivo. O câmbio é um canal *soft*, pois a
resposta de impacto é positiva nas dez células, mas não penaliza o ranking.

| `(r,q)` | DI 2a full/pre, pb | DI 5a full/pre, pb | Ibov full/pre, pp | BRL/USD full/pre |
|---|---:|---:|---:|---:|
| `(2,2)` | 93,4 / 86,4 | 110,6 / 108,5 | -10,02 / -5,86 | 0,187 / 0,154 |
| `(5,3)` | 157,6 / 106,8 | 219,6 / 144,5 | -23,96 / -16,20 | 0,521 / 0,209 |
| `(5,4)` | 114,1 / 82,6 | 141,0 / 102,8 | -7,43 / -14,21 | 0,373 / 0,113 |
| `(7,6)` | 108,0 / 67,3 | 117,0 / 67,1 | -2,41 / -6,98 | 0,228 / 0,102 |
| `(7,7)` | 86,0 / 67,3 | 89,0 / 67,1 | -1,31 / -6,98 | 0,157 / 0,102 |

O impacto de `yield_6m` é mecanicamente 50 pb em todas as células. O número 10
não é tratado como crítico MOSW porque é uma referência convencional herdada
de outras estatísticas de primeiro estágio. O valor 3,84 é o quantil de 5% de
`chi²(1)` para a nulidade de relevância nessa direção e se relaciona, no
contexto SVAR-IV, à limitação do conjunto AR. Esse valor não garante cobertura
das bandas operacionais do DFM, como permite delimitar a discussão de
[Montiel Olea, Stock e Watson](https://www.princeton.edu/~mwatson/papers/JOE_Publication_SVARIV.pdf).

## Regra reproduzível para o apêndice

1. Fixar a amostra completa como alvo principal e tratar a janela pré-COVID
   apenas como robustez temporal. Fixar também o painel canônico, `p=6`, o
   instrumento e a normalização antes de examinar as IRFs.
2. Em cada janela, recortar a amostra, calcular `ΔX`, subtrair `mean(ΔX)` e
   dividir por `sd(ΔX)`. A rotina deve abortar se encontrar valor não finito ou
   escala não positiva.
3. Calcular IC1 a IC3 para `r=1,...,20`, selecionar `r` por IC2 e registrar os
   três critérios, inclusive mínimos de fronteira.
4. Extrair os `r` componentes, filtrar cada série por constante e seis
   defasagens dos fatores com least squares por QR ou SVD, e aplicar IC2 aos
   resíduos para `q=1,...,r`.
5. Registrar o mínimo da amostra completa como referência de seleção e o
   mínimo pré-COVID apenas como diagnóstico. Avaliar somente as cinco
   candidatas fixadas antes da comparação.
6. Na amostra completa, excluir células instáveis, numericamente inválidas ou
   com `xi_mp<=3,84`. Esse limiar testa relevância nula e não força suficiente
   para validar as bandas. Resultados pré-COVID qualificam a confiança, mas
   não redefinem a dimensão principal.
7. Entre as células restantes, minimizar `|r-5|+|q-3|`. A estabilidade
   pré-COVID, a coerência econômica fixada antes da estimação e a parcimônia
   entram apenas em empates ou na qualificação da confiança.
8. Reportar `(7,6)` como robustez congelada e `(7,7)` como vizinha. A regra não
   reotimiza por `xi_mp`, `F`, contagem de bandas ou forma das IRFs.

A regra elimina `(5,3)` por relevância insuficiente na amostra completa. Entre
as demais candidatas relevantes no full, as distâncias ao mínimo `(5,3)` são 1
para `(5,4)`, 4 para `(2,2)`, 5 para `(7,6)` e 6 para `(7,7)`.

## Parágrafo sugerido para o paper

> A amostra completa é o alvo primário da seleção dimensional. Nela, os
> critérios BLL-standardized Bai-Ng e Amengual-Watson indicam `(r,q)=(5,3)`,
> mas essa célula tem `xi_mp=3,42`, de modo que não rejeita a nulidade de
> relevância na direção de `yield_6m` ao nível de 5%. Entre as candidatas
> fixadas antes da comparação e numericamente estáveis, a vizinha mais próxima
> que rejeita essa nulidade é `(5,4)`, adotada como especificação principal. A
> janela pré-COVID é usada apenas como robustez temporal, e `(7,6)` permanece
> como robustez da especificação congelada anteriormente. `(7,7)` produz
> `xi_mp` maior, mas não é escolhida porque seu ganho se concentra na força do
> instrumento. As bandas de 68% são lidas como evidência sugestiva e as de 90%
> como evidência estatisticamente significativa.

## Riscos e teste adicional

A raiz 0,9979 de `(5,4)` pré-COVID torna as formas de médio prazo frágeis, e a
estabilidade entre amostras é menor que em `(7,6)`. A Wald `xi_mp=4,77` full
rejeita a nulidade, mas está perto de 3,84. O `cumsum` das ações impede usar as
trajetórias acionárias de médio prazo, IC3 permanece no limite e o produtor AW
continua numericamente frágil fora da convenção principal.

O teste adicional necessário antes de trocar a produção é uma sensibilidade
temporal fixada previamente para `(5,4)`, `(7,6)` e `(7,7)`, com finais anuais
de 2019 a 2025. O teste deve registrar `xi_mp`, raiz máxima e as cinco IRFs em
`h=0,...,6`, sem escolher o melhor corte. A troca para `(5,4)` depende de a
quase-raiz unitária e a instabilidade não estarem concentradas em um único
final de amostra.

As correções de implementação são separadas da decisão dimensional. A rotina
deve impor `max_q=r`, substituir `solve(Z'Z)` por QR ou SVD com verificação de
posto e adicionar guardas de escala. Depois dessas correções, as 128 células
com `p=6` e a sensibilidade com `p=12` devem ser reproduzidas sem alterar
valores esperados apenas para obter aprovação.

## Limites

A auditoria não executou uma terceira linguagem, não refez a construção diária
do instrumento e não demonstrou a validade teórica das bandas sob instrumento
fraco. Esses limites impedem afirmar que a inferência é uniformemente válida,
mas não impedem comparar as dimensões sob o pipeline vigente.
