# SUPERADA — substituída por `2026-08-22_var_producao_unica.md`

# VAR pequeno estacionário pela tradução de Montiel Olea et al.

> **CURRENT.** Rodada de 2026-08-22. `script/model_var.R`, proxy
> `z_jk_bs_purif`, normalização em `yield_6m` a +50 pontos-base, amostra
> 2013-01--2025-09. A produção é `ibc5_fx_cds_stat_p1`. O DFM e sua inferência
> permanecem inalterados.

## Decisão e escopo

O caminho ativo do VAR pequeno passa a ser a tradução metodológica de
`codigos_externos/codigo_olea/`. O driver anterior, baseado no motor VAR de
Alessi--Kerssenfischer, no wild bootstrap, na correção de Kilian e na soma das
respostas, foi retirado deste benchmark. A única inferência do VAR observável é
a inversão Anderson--Rubin/MOSW com Newey--West de ordem zero. Esses conjuntos
cobrem respostas do VAR, nunca respostas do DFM, e robustez a instrumento fraco
não estabelece a validade da proxy comum aos dois modelos.

“Sem choque acumulativo” tem aqui sentido preciso. Existe um único vetor de
impacto,

\[
B_1=0{,}005\frac{\Gamma}{\Gamma_{\mathrm{yield}}},
\]

e a resposta publicada no horizonte `h` é `C_h B_1`, não a soma das respostas
entre zero e `h`.

## Especificação estacionária

As sete células têm o núcleo `{ibc_br, price_ipca, yield_6m}`. O IPCA fica em
nível; IBC-Br, yield de 6 meses, câmbio, CDS e EMBI+ entram em primeira
diferença. Todas são alinhadas pela observação inicial perdida, deixando 152
meses para a seleção e a estimação.

| célula | identificador | variáveis adicionais |
|---|---|---|
| Produção | `ibc5_fx_cds_stat_p1` | câmbio + CDS |
| S1 | `ibc4_fx_stat_p1` | câmbio |
| S2 | `ibc4_cds_stat_p1` | CDS |
| S3 | `ibc4_embi_stat_p1` | EMBI+ |
| S4 | `ibc5_fx_embi_stat_p1` | câmbio + EMBI+ |
| S5 | `ibc5_cds_embi_stat_p1` | CDS + EMBI+ |
| S6 | `ibc6_all_stat_p1` | câmbio + CDS + EMBI+ |

O ADF usa constante e seleção AIC entre até quatro defasagens. O Phillips--
Perron usa Z-tau, constante e quatro defasagens curtas. Em nível, ambos
rejeitam raiz unitária no `price_ipca`: ADF `-5,2781` e PP `-6,8820`, contra
valor crítico próximo de `-2,88`. Por isso o IPCA permanece em nível. No EMBI,
os testes em nível divergem: ADF `-2,7160` não rejeita, enquanto PP `-2,9420`
rejeita; a série é diferenciada. Depois da transformação, ADF e PP rejeitam a
5% para as outras cinco séries. A tabela completa, incluindo os testes em nível
e depois da transformação, está em
`output/var/var_benchmark_unit_root.csv`.

## Seleção de defasagens e forma reduzida

Para `p=1,...,12`, a tradução de `bicaic.m` usa a mesma amostra de `T=140`:

\[
\operatorname{BIC}(p)=\log|\widehat\Sigma_p|
+\frac{\log(T)N^2p}{T}.
\]

O BIC seleciona `p=1` nas sete células. Uma transcrição literal e independente
do laço de `bicaic.m` reproduz todos os valores sem desvio na precisão exibida.
A tabela completa está em `output/var/var_benchmark_lag_criteria.csv`.

A tradução de `RForm_VAR.m` põe a constante na primeira coluna, estima todas as
equações conjuntamente por OLS e calcula
`Sigma = eta eta'/T`. O alinhamento com o instrumento deixa 151 resíduos, dos
quais 61 têm instrumento não nulo. A maior raiz da companion é `0,683593` na
produção e varia entre `0,660409` e `0,685160` nas sensibilidades, sempre abaixo
de um.

## Validação contra o código oficial

`script/validate_mosw_ar.R` reconstrói a aplicação oficial de petróleo a partir
do fixture versionado. Os maiores desvios foram `2,28e-12` em `AL`, `9,00e-11`
em `eta`, `1,71e-13` em `Sigma`, `6,39e-13` em `Gamma`, `2,67e-13` relativo em
`WHat` e `2,01e-15` nos coeficientes MA. Os pontos SVAR-IV diferem no máximo
`1,62e-12`; cada um também coincide exatamente, na precisão da máquina, com
`C_h B_1`.

Os conjuntos AR reproduzem o fixture a 68% e 95%. O maior desvio é `1,18e-11`.
O solucionador separado acerta os dez casos do oráculo: intervalo, duas
semirretas, vazio, reta inteira, singleton e as duas semirretas simples. A
tolerância é relativa à escala dos coeficientes; a versão superada usava uma
escala mínima igual a um e transformava intervalos numericamente pequenos em
singletons falsos.

## Resultados

Na produção, `xi_var=6,02492`. O impacto do yield é exatamente `0,005`, ou 50
pontos-base. Em escala de apresentação, a variação contemporânea do câmbio é
`2,2539%` da média amostral, com conjunto AR de 95% `[0,7405%; 6,6322%]`; a
variação do CDS é `20,1193` pontos-base, com conjunto `[9,3965; 57,8484]`.
Ambos excluem zero apenas no impacto. Em `h=1`, os conjuntos já contêm zero.

Nas sensibilidades, todas as respostas-manchete de impacto também têm conjunto
de 95% inteiramente positivo: câmbio em S1, S4 e S6; CDS em S2, S5 e S6; EMBI+
em S3, S4, S5 e S6. Isso é evidência sobre esses VARs observáveis, não uma
validação da proxy nem uma banda para o DFM.

Cada nível de confiança contém 1.214 intervalos e sete singletons, estes apenas
na normalização. A rodada não gerou conjunto vazio, ilimitado ou desconexo, mas
o CSV e o round-trip preservam literalmente `Inf`, `-Inf`, `NA` e o tipo do
conjunto quando esses casos ocorrem. A fonte canônica dos pontos e conjuntos é
`output/var/svar_iv_weak_robust.csv`; os diagnósticos estão em
`output/var/svar_iv_weak_robust_diag.csv`.

## Produtores e consumidores

- `R/modeling/production_spec.R` declara transformações, células, rótulos,
  `p=1`, níveis AR 68%/95% e NW(0).
- `R/modeling/var_proxy.R` traduz `RForm_VAR.m` e `bicaic.m`.
- `R/identification/weak_iv_ar.R` traduz MA, impacto, covariância, derivadas e
  inversão AR, restrita ao VAR observável.
- `script/model_var.R` é o único driver do benchmark.
- `script/fig_weak_iv.R` lê somente o CSV canônico e mostra ponto, zero e
  conjunto AR de 95%.
- `paper/paper_anpec.tex` consome apenas esta vintage.
