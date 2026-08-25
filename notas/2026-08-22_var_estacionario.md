# Benchmark VAR estacionário em primeiras diferenças

> **SUPERADA em 2026-08-22.** Esta nota documenta a especificação em que todas
> as séries eram diferenciadas, as respostas eram somadas por horizonte e a
> incerteza combinava wild bootstrap e Anderson--Rubin. O benchmark corrente é
> a tradução do caminho de Montiel Olea et al., com IPCA em nível, demais
> séries em diferença, respostas `C_h B_1` e somente conjuntos AR. Ver
> [`2026-08-22_var_olea_estacionario`](2026-08-22_var_olea_estacionario.md).
> O restante desta nota é preservado como vintage histórica.

> **CURRENT.** Rodada de 2026-08-22. Proxy `z_jk_bs_purif`, normalização em
> `yield_6m` a +50 pontos-base, amostra 2013-01--2025-09. O único benchmark
> VAR ativo é `ibc5_cds_d1_p1`, estimado nas primeiras diferenças com uma
> defasagem. As IRFs pontuais, as réplicas do wild bootstrap e os objetos da
> inferência Anderson--Rubin/MOSW são acumulados para representar respostas em
> nível. A produção DFM permanece inalterada.

## Decisão

O benchmark anterior foi estimado em séries não estacionárias e deixou de ser
um objeto admissível para comparação. Ele não permanece como sensibilidade e
nenhum artefato ativo compara a especificação antiga à atual. As notas de
2026-07-31, 2026-08-18 e 2026-08-20 foram preservadas como registro histórico,
mas seus banners as classificam como superadas e inválidas.

O sistema corrente contém IBC-Br, IPCA, yield de 6 meses, câmbio USD/BRL e CDS
soberano de cinco anos. A estimação usa as primeiras diferenças dessas cinco
séries e `p = 1`. A soma das respostas entre o impacto e cada horizonte devolve
o efeito em nível nas unidades nativas. A acumulação ocorre antes dos
percentis do bootstrap e antes da propagação da covariância e da inversão do
teste Anderson--Rubin.

## Estacionariedade

O ADF usa constante e seleção AIC entre até quatro defasagens. O Phillips--
Perron usa a estatística Z-tau com constante e quatro defasagens curtas. Os
dois testes rejeitam raiz unitária a 5% em todas as primeiras diferenças.

| série | lag ADF | ADF | valor crítico 5% | PP Z-tau | valor crítico 5% |
|---|---:|---:|---:|---:|---:|
| `ibc_br` | 4 | -6,6205 | -2,8800 | -9,8925 | -2,8806 |
| `price_ipca` | 1 | -11,1632 | -2,8800 | -17,8319 | -2,8806 |
| `yield_6m` | 2 | -3,0118 | -2,8800 | -6,5923 | -2,8806 |
| `cambio_usd` | 1 | -8,3349 | -2,8800 | -9,3312 | -2,8806 |
| `cds_5y` | 1 | -8,8496 | -2,8800 | -11,6287 | -2,8806 |

A tabela completa está em
`output/var/var_benchmark_unit_root.csv`.

## Seleção de defasagens

As ordens de 1 a 12 foram comparadas na mesma amostra de 140 observações. A
implementação manual de Olea usa
`log|Sigma_p| + 2 K^2 p/T` no AIC e
`log|Sigma_p| + log(T) K^2 p/T` no BIC. A reprodução de
`vars::VARselect` acrescenta os `K` interceptos à penalização. O maior desvio
entre a implementação manual e o pacote foi `1,78e-15`.

AIC e BIC de Olea selecionam `p = 1`. AIC, HQ e BIC de `vars` também
selecionam `p = 1` na célula principal. A tabela completa para as doze ordens
está em `output/var/var_benchmark_lag_criteria.csv`.

Nas seis sensibilidades, HQ e BIC selecionam uma defasagem em todas. O AIC
seleciona três defasagens nas células com câmbio e indústria e nos dois
sistemas de cinco variáveis com indústria. Seleciona duas nas outras três
células. O relatório não oculta essa divergência. A ordem comum permanece em
uma defasagem, escolhida por HQ e BIC e fixada para manter comparabilidade entre
as composições.

## Gates numéricos

- A raiz máxima é `0,6107` na célula principal e fica abaixo de `0,599` nas
  seis sensibilidades.
- O impacto acumulado de `yield_6m` é exatamente `0,005` no benchmark.
- Os 185 pontos da célula principal entre `h = 0` e `h = 36` coincidem entre
  os caminhos Anderson--Rubin e bootstrap até `7,11e-15`.
- O módulo MOSW passou contra o código oficial em quatro blocos de 63 células
  e nos dez casos degenerados do oráculo da auditoria.
- A serialização mantém os tipos dos conjuntos e os sinais dos limites
  infinitos. Nesta rodada, as 3.441 células são 3.420 intervalos e 21
  singletons de normalização. Não ocorreu conjunto ilimitado, desconexo ou em
  semirreta.

O wild bootstrap do benchmark usa 800 réplicas e teve zero falhas. A correção
de Kilian ficou indefinida porque a equação de Lyapunov foi numericamente
singular, com `rcond = 1,48e-12`. O driver emitiu o aviso e usou os coeficientes
OLS não corrigidos no DGP do bootstrap. Essa ressalva permanece no relatório
gerado e deve acompanhar qualquer leitura das bandas.

## Resultados de impacto

Na célula principal, `xi_var = 6,189`, o F robusto é `10,384` e a raiz máxima
é `0,6107`. Em escala de apresentação, o câmbio deprecia 2,2052%, com conjunto
Anderson--Rubin de 90% `[1,0233%; 4,6011%]`. O CDS abre 20,0811 pontos-base,
com conjunto `[11,1591; 41,3420]`. Os dois conjuntos ficam acima de zero. Os
pontos correspondentes do DFM são 3,8410% e 32,5417 pontos-base. A comparação
é descritiva, pois os conjuntos do VAR não cobrem as respostas do DFM.

Nas seis sensibilidades, o câmbio, o CDS e o EMBI+ têm conjuntos de 90%
inteiramente positivos no impacto. O resultado é mais uniforme que na vintage
inválida, mas não testa a validade da proxy. Os dois modelos usam o mesmo
instrumento, que continua sendo o elo comum da identificação.

## Produtores e consumidores

- `R/modeling/production_spec.R` declara a única célula de benchmark.
- `R/modeling/var_proxy.R` estima o VAR, acumula pontos e réplicas e calcula os
  critérios de defasagem.
- `R/identification/weak_iv_ar.R` acumula respostas e derivadas antes da
  propagação da covariância e da inversão do teste.
- `script/model_var.R` produz o benchmark, os testes de raiz unitária e a
  tabela completa de seleção de defasagens.
- `script/model_var_weak_iv.R` produz as sete células de inferência robusta.
- `script/fig_weak_iv.R` exige a igualdade dos 185 pontos antes de escrever
  `paper/fig_weak_iv_main.pdf`.
- `paper/paper_anpec.tex` consome apenas esta vintage.

Artefatos correntes: `output/var/var_benchmark_*`,
`output/var/svar_iv_weak_robust*` e `paper/fig_weak_iv_main.pdf`.
