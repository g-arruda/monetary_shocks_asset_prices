# Auditoria adversarial das bandas Anderson–Rubin do DFM-IV

## 1. Veredito executivo

**Classificação final: 4. Confiança: alta (0,90).** A classe 4 decorre da regra de decisão predefinida: a rotina genérica de inversão não resolve corretamente casos degenerados da quadrática. Ela transforma termos lineares, conjunto vazio e singleton tangente em toda a reta e é numericamente instável quando o coeficiente quadrático é quase nulo. Esse defeito é **Demonstrado** por comparação com a desigualdade original. Não atingiu as bandas publicadas: nas 31.158 células não normalizadas, os coeficientes estão no caso regular de intervalo limitado; as seis células de normalização são sobrescritas como singleton. Sem esse defeito, o estado substantivo seria classe 3.

A identidade entre a IRF do código e a razão observável usada na estatística AR é **Demonstrada**, condicionando-se em fatores, loadings, escalas e rotação estimados. Uma implementação Python independente reproduz as 10.388 respostas pontuais e as bandas de 90% dos dois recortes até erro numérico ou arredondamento do CSV. Gradientes, acumulação, sinais, escala, permutações e rotações também passam.

A validade incondicional depois de estimar fatores, loadings, escalas e o subespaço dinâmico é **Não demonstrada**. MOSW exige normalidade conjunta dos estimadores reduzidos que entram na razão; a covariância implementada trata os objetos de mensuração como fixos. A literatura encontrada até agosto de 2026 não fornece teorema uniforme que una fatores estimados, instrumento localmente fraco e inversão da razão observável. No Monte Carlo, a cobertura de impacto cai para 78,1%–83,4% com fatores estimados, contra 86,7%–88,3% com fatores observados. Isso é evidência falsificadora da aproximação plug-in, não prova geral de invalidade.

O resultado que mudaria o veredito seria: corrigir e testar a inversão degenerada; e apresentar um teorema aplicável ou um procedimento de inferência que incorpore a estimação fatorial sob identificação fraca.

## 2. Escopo, linha de base e cadeia de custódia

O objeto auditado é o estado do repositório em 12 de agosto de 2026, incluindo as alegações não commitadas no paper. Nenhum código, dado, fixture ou resultado de produção foi alterado. O script 'script/ar_bands.R' não foi executado contra 'output/'; a reestimação foi feita em memória e os auxiliares ficaram em '/tmp/ar_audit'. Esta auditoria acrescenta somente este parecer.

| Item | Registro |
|---|---|
| Commit | 61e222543ac9fa0de18036923401be17d256480b |
| Estado inicial e final | M HANDOFF.md; M paper/paper_anpec.tex; M registro/pendencias.md |
| R / Python | 4.3.3 / 3.12.12 |
| Amostra completa | 2013-01 a 2025-09; 153 observações antes das defasagens; \(T=147\) inovações |
| Amostra pré-pandemia | 84 observações antes das defasagens; \(T=78\) inovações |
| Dimensões | \(N=106,\ r=7,\ q=6,\ p=6\) |
| Normalização | yield_6m, impacto \(+0{,}005\) |
| Instrumento | z_jk_bs_purif |
| Semente | 20260812 |

Hashes SHA-256 centrais:

| Arquivo | SHA-256 |
|---|---|
| R/identification/weak_iv_ar.R | d7b4113f1b98a4e28ae458ad2cf0840da55eed2503ce7aa4ded6d5f45f7fab53 |
| R/modeling/impulse_responde.R | f50b14871b674b240aa0fd0ccb94c3748e3f20eabc95aeedc0f14623d2657637 |
| R/modeling/factor_estimation.R | a27375d4c90be3f6aa3bdb03584a7d5f46c318bf28af5471b465010c5a3a1302 |
| script/ar_bands.R | 5b15ce617b61dc34660b319054d44478f270950b6f4c39f44ac5dd9044e22dab |
| script/validate_mosw_ar.R | e18242259e4368e4126ae7d724b38d8304a55a8671374a56060b577338d72406 |
| output/irf/ar_bands.csv | 3be18d74732fe5ca46e81388fb97294781a2a9555a1d8180ed341997e7c6edd5 |
| notas/2026-08-10_bandas_anderson_rubin.md | b652b1467d2b8997dfbd658b72d0f5fc78aa386ef9e107f0c30dd7827568ecbf |
| paper/paper_anpec.tex | 50d9cacaf72ccf36e36431e8a68c419c470d5902019305d4006c0295e9dda90c |

Foram lidos README.md, registro/metodo.md, registro/pendencias.md, registro/historico_decisoes.md e script/README.md. O código e seus artefatos serviram como objeto de reprodução, não como validação externa. Essa separação é **Demonstrada** pela implementação independente descrita adiante.

## 3. Reconstrução do estimando e equivalência algébrica

Seja \(Y_t\in\mathbb R^N\) o painel padronizado segundo BLL e \(F_t\in\mathbb R^r\) seus componentes principais. O módulo fatorial estima

\[
Y_t=\Lambda F_t+e_t,\qquad
F_t=A_1F_{t-1}+\cdots+A_pF_{t-p}+u_t.
\]

Escreva \(A=[A_1,\ldots,A_p]\in\mathbb R^{r\times rp}\), \(P_\ell\in\mathbb R^{r\times r}\) para a resposta do VAR, com \(P_0=I_r\), e

\[
\widehat\Sigma_u=T^{-1}\sum_tu_tu_t',\qquad
\widehat\Sigma_uK=KD,\qquad M=D^{1/2}.
\]

As \(q\) inovações dinâmicas são \(\eta_t=M^{-1}K'u_t\), e a resposta não identificada das observáveis é

\[
R_h=\operatorname{diag}(s_y)\Lambda P_hKM.
\]

Com \(z=(z_1,\ldots,z_T)'\), a rotina de instrumento externo calcula

\[
H=\frac{z'\eta}{z'z}
=M^{-T}K'\frac{\sum_tu_tz_t}{z'z}.
\]

Defina \(L=\operatorname{diag}(s_y)\Lambda\), \(Q=KK'\), \(\Gamma_u=T^{-1}\sum_tz_tu_t\) e \(e_{mp}=e_{\text{yield\_6m}}\). Como \(M\) é diagonal, simétrica e não singular no resultado estimado,

\[
R_hH=LP_hKMM^{-T}K'\frac{T}{z'z}\Gamma_u
=LP_hQ\frac{T}{z'z}\Gamma_u.
\]

Normalizar o impacto monetário em \(0{,}005\) cancela o escalar comum \(T/(z'z)\):

\[
\boxed{
IRF_{j,h}=0{,}005\,
\frac{e_j'LP_hQ\Gamma_u}
     {e_{mp}'LQ\Gamma_u}}
\tag{1}
\]

Essa é exatamente a resposta antes das transformações por tcode. Para tcode 2, o código acumula \(P_0+\cdots+P_h\) e multiplica por 100; para tcode 4, aplica \(100[\exp(IRF)-1]\) depois da inversão.

O cancelamento é **Sustentado sob hipóteses**. Ele requer a mesma amostra em \(u,\eta,z\); \(M=M'\) inversível; colunas ortonormais de \(K\); denominador não nulo; e \(L,K,s_y\) condicionados como fixos. Se outro estimador usar \(M\) não simétrico, \(MM^{-T}=I\) não vale.

Na amostra completa, o denominador é 0.00508986541827; na pré-pandemia, 0.00255595165581. A reconstrução de (1) para 106 séries e horizontes 0–48 difere de res$irfs em no máximo \(6{,}08\times10^{-9}\) e \(4{,}16\times10^{-9}\), respectivamente. A equivalência do estimando é **Demonstrada**.

## 4. Tradução MOSW → MATLAB → VAR dos fatores → observáveis

A vetorização é por colunas. Em particular, vec(AL) empilha as colunas de \(A=[A_1,\ldots,A_p]\), como MATLAB e R.

| Papel | MOSW/MATLAB | Implementação | Dimensão completa | Limite da equivalência |
|---|---|---|---:|---|
| Estado reduzido | \(y_t\) observado | fator estimado \(F_t\) | \(153\times7\) | A estimação de \(F_t\) é etapa adicional |
| VAR | \(A=[A_1,\ldots,A_p]\) | AL | \(7\times42\) | Mesma ordem de defasagens e colunas |
| Regressor | constante e lags | X | \(147\times43\) | Intercepto mais \(rp=42\) regressoras |
| Inovação | \(u_t\) | resíduo do VAR fatorial | \(147\times7\) | O intercepto torna a média residual zero |
| Proxy | \(Z_t\in\mathbb R^k\) | z_jk_bs_purif | \(147\times1\) | \(k=1\), após alinhamento |
| Proxy-inovação | \(\Gamma=T^{-1}\sum z_tu_t'\) | Gamma_u | \(7\times1\) | Convenção interna usa coluna |
| Parâmetros VAR | \(\operatorname{vec}(A)\) | vec(AL) | \(294\times1\) | \(r^2p=294\) |
| Covariância VAR | \(W_1\) | bloco superior de WHat | \(294\times294\) | MOSW CovAhat |
| Covariância cruzada | \(W_{12}\) | bloco cruzado | \(294\times7\) | Covariância AL–Gamma |
| Covariância de Gamma | \(W_2\) | bloco inferior | \(7\times7\) | \(k=1\) |
| Projeção dinâmica | ausente no SVAR observado | \(Q=KK'\) | \(7\times7\) | Condicionada como fixa |
| Mensuração | identidade no fixture | \(L=\operatorname{diag}(s_y)\Lambda\) | \(106\times7\) | Condicionada como fixa |
| MA dos fatores | \(B_h\) ou \(P_h\) | Phi[[h+1]] | \(7\times7\) | Recursão do VAR |
| Mapa observável | seleção no VAR | \(C_h=LP_hQ\) | \(106\times7\) | Leva Gamma às observáveis |
| Normalização | razão pela variável-alvo | \(d_0'=e_{mp}'LQ\) | \(1\times7\) | Horizonte zero |

O fixture MATLAB substitui \(L=I\) e \(Q=I\). Ele verifica MOSW para um SVAR observado de dimensão sete; não verifica a passagem por PCA, loadings, escalas e \(K\). A equivalência computacional entre níveis é **Sustentada sob hipóteses**; a equivalência estatística incondicional é **Não demonstrada**.

## 5. Gradientes, covariância e quadrática AR

Para \(h\geq1\), escreva a companheira como \(\mathcal A\), o seletor do primeiro bloco como \(J=[I_r,0,\ldots,0]\), a resposta dos fatores como \(B_m=J\mathcal A^mJ'\in\mathbb R^{r\times r}\), e \(S_\ell=(\mathcal A^\ell J')'=J(\mathcal A^\ell)'\in\mathbb R^{r\times rp}\). A resposta-base é \(g_{j,h}=e_j'LB_hQ\Gamma_u\). Com vec por colunas, suas derivadas são:

\[
\bar D_{a,j,h}
=\sum_{m=0}^{h-1}
\left[(\Gamma_u'QS_{h-1-m})\otimes(e_j'LB_m)\right]
\in\mathbb R^{1\times294},
\tag{2}
\]

\[
\bar D_{g,j,h}=e_j'LB_hQ\in\mathbb R^{1\times7}.
\tag{3}
\]

Em \(h=0\), \(\bar D_a=0\) e \(\bar D_g=e_j'LQ\). Com \(s=0{,}005\), a implementação usa \(D_a=s\bar D_a\), \(D_g=s\bar D_g\) e \(n=D_g\Gamma_u=sg_{j,h}\). Para resposta acumulada, somam-se \(g,\bar D_a,\bar D_g\) de zero a \(h\) antes dessa escala. Diferenças finitas centrais, passo \(10^{-6}\), deram erros máximos de \(4{,}07\times10^{-14}\) e \(1{,}64\times10^{-14}\). Gradientes, escala e ordem das transpostas são **Demonstrados**.

mosw_rform_cov() constrói

\[
W=\begin{bmatrix}W_1&W_{12}\\W_{12}'&W_2\end{bmatrix}
\in\mathbb R^{301\times301}.
\]

\(W_1\) cobre vec(AL), \(W_2\) cobre \(\Gamma_u\), e \(W_{12}\) preserva sua covariância. A rotina traduz CovAhat, CovAGammahat e CovGammahat do fixture, incorpora HAC e a correção de Kilian nos pontos declarados. Não contém derivadas de \(\Lambda,s_y,K,M\) ou dos fatores. É a covariância exata dos parâmetros reduzidos apenas condicionalmente a esses objetos.

O rastreamento funcional, conferido expressão por expressão, é:

| Objeto | Origem operacional | Correspondente auditado |
|---|---|---|
| \(\Lambda,s_y,F\) | R/modeling/factor_estimation.R | PCA e padronização BLL |
| \(A,u,K,M,\eta\) | módulos de estimação fatorial e VAR | VAR dos fatores, autodecomposição de \(\widehat\Sigma_u\) |
| Resposta \(LB_hKM\) | R/modeling/impulse_responde.R | MA dos fatores levada às observáveis |
| \(\Gamma_u,W_1,W_{12},W_2\) | mosw_rform_cov() em R/identification/weak_iv_ar.R | GammaHat, CovAhat, CovAGammahat, CovGammahat do MATLAB |
| \(D_a,D_g\) | mosw_response_derivatives() e escala em mosw_ar_bounds() | Diferenciais (2)–(3), depois multiplicados por \(s\) |
| \(d_0,n,d\) | script/ar_bands.R ao montar cada célula | Linha de normalização, numerador e denominador da razão |
| \(a,b,c,\Delta\) | mosw_ar_bounds() | Expansão da estatística AR |
| Limites e topologia | mosw_ar_bounds() | Solução de \(a\lambda^2+b\lambda+c\leq0\) |
| Acumulação e escala final | script/ar_bands.R e impulse_responde.R | tcode 2 e tcode 4 |

Para testar \(H_0:\lambda_{j,h}=\lambda\), defina \(n=D_g\Gamma_u=s\,e_j'LB_hQ\Gamma_u\), \(d=d_0'\Gamma_u\), \(d_0'=e_{mp}'LQ\), e \(k=\chi^2_{1,1-\alpha}\). A desigualdade é \(a\lambda^2+b\lambda+c\leq0\), com

\[
a=Td^2-kd_0'W_2d_0,
\]
\[
b=-2Tnd+2kD_aW_{12}d_0+2kD_gW_2d_0,
\]
\[
c=Tn^2-k\left(D_aW_1D_a'
+2D_aW_{12}D_g'+D_gW_2D_g'\right).
\]

Os coeficientes coincidem com a expansão direta do teste AR delta-linearizado. A quadrática é **Sustentada sob hipóteses** para \((\operatorname{vec}A,\Gamma_u)\) e \(W\), condicionado em \(L,Q,s_y\); não é a covariância integral da resposta DFM quando a mensuração é estimada.

## 6. Validações executadas e reprodução independente

Comandos executados, sempre a partir da raiz:

~~~text
Rscript script/validate_mosw_ar.R
Rscript script/validate_olea_kilian.R
Rscript script/validate_hac_kernel.R
Rscript /tmp/ar_audit_export.R
python3 /tmp/ar_audit_independent.py
python3 /tmp/ar_audit_monte_carlo.py --replications 500 --seed 20260812
python3 /tmp/ar_audit_monte_carlo.py --replications 2000 --seed 20260812
~~~

| Verificação | Resultado | Demonstra | Não demonstra |
|---|---|---|---|
| Fixture MOSW/MATLAB | erro relativo de \(W\): \(4{,}915\times10^{-14}\); erro de \(\Gamma\): \(4{,}441\times10^{-16}\); Wald 4.398794; pior erro de coeficientes, limites e \(\Delta\): \(1{,}7\times10^{-11}\) | Fidelidade com transformações identidade | Mensuração por fatores estimados; degenerações |
| Kilian/Olea | desvio de eta: \(8{,}36\times10^{-11}\); de AL: \(2{,}44\times10^{-12}\); \(\xi_1=4{,}399\); \(F_{HC1}=9{,}438\) | Correção e força no fixture | Cobertura das IRFs observáveis |
| Kernel HAC | igualdade exata nos lags 0–8; bloco Gamma relativo \(2{,}582\times10^{-10}\) em NW(8) | Kernel e largura usados | Otimalidade da largura; generated regressors |
| Python, completa | resposta: \(6{,}075\times10^{-9}\); banda 90%: \(4{,}998\times10^{-4}\) | Estimando, \(W\), quadrática e escala final | Teorema de cobertura |
| Python, pré-pandemia | resposta: \(4{,}158\times10^{-9}\); banda 90%: \(4{,}999\times10^{-4}\) | Idem no segundo recorte | Idem |

Os erros próximos de \(5\times10^{-4}\) nas bandas decorrem da impressão do CSV: o pior limite é 17834.037 contra 17834.03650017. O erro relativo é inferior a \(3\times10^{-8}\). No nível de 90%, todas as 5.193 células não normalizadas de cada amostra foram reconhecidas como intervalos limitados. Em ambas as janelas, o impacto de yield_6m é exatamente \(+0{,}005\); sinais e escalas das demais séries coincidem com res$irfs, e essa célula é singleton.

Não havia MATLAB nem Octave instalados. A comparação com MATLAB é estática e mediada pelo fixture versionado. O Python não chama nem reutiliza as rotinas R/MATLAB, mas lê matrizes primitivas reestimadas em R. A concordância computacional do caminho atual é **Demonstrada**. A independência integral desde o painel bruto é **Evidência parcial**, pois a PCA/VAR não foi reimplementada em Python.

## 7. Casos degenerados, denominador fraco e invariâncias

A rotina atual classifica apenas por desigualdades estritas:

~~~text
a > 0 e Delta > 0  -> intervalo
a < 0 e Delta > 0  -> duas semirretas
a > 0 e Delta < 0  -> vazio
caso contrário      -> toda a reta
~~~

O oráculo resolve diretamente \(a\lambda^2+b\lambda+c\leq0\), com tolerância \(10^{-12}\) relativa a \(\max(1,|a|,|b|,|c|)\), e tolerância análoga para \(\Delta\):

| Caso | Solução exata | Rotina atual | Conclusão |
|---|---|---|---|
| \(a>0,\Delta>0\) | intervalo | intervalo | **Demonstrado** |
| \(a<0,\Delta>0\) | duas semirretas | duas semirretas | **Demonstrado** |
| \(a=0,b>0\) | semirreta à esquerda | toda a reta | **Refutado** |
| \(a=0,b<0\) | semirreta à direita | toda a reta | **Refutado** |
| \(a=b=0,c>0\) | vazio | toda a reta | **Refutado** |
| \(a>0,\Delta=0\) | singleton | toda a reta | **Refutado** |
| \(a<0,\Delta=0\) | toda a reta | toda a reta | **Demonstrado** |
| \(a=b=0,c<0\) | toda a reta | toda a reta | **Demonstrado** |
| \(a=10^{-14}\), linear na escala | semirreta | intervalo numericamente distante | **Refutado** |

O caso regular vazio \(a>0,\Delta<0\) existe no código; o vazio exatamente degenerado não. A falta de tolerância torna a topologia sensível a arredondamento. É uma incorreção lógica da API, embora dormente nos resultados publicados.

Reduzindo artificialmente o denominador, o oráculo mostrou a transição esperada. Com multiplicador 1, \(\xi_1=10{,}4308\), \(a=2{,}820\times10^{-3}\) e intervalo; com multiplicadores 0,5, 0,2, 0,05 e zero, \(\xi_1\) cai para 2,608, 0,417, 0,026 e aproximadamente zero, \(a<0\), e surgem duas semirretas. O vínculo força–topologia no caso regular é **Demonstrado**.

Para uma mudança inversível \(F_t^*=SF_t\), foram transformados conjuntamente

\[
A_\ell^*=SA_\ell S^{-1},\quad L^*=LS^{-1},\quad
Q^*=SQS^{-1},\quad \Gamma_u^*=S\Gamma_u,
\]

além de \(X,\eta,W\). Os erros máximos foram:

| Transformação | Resposta | Limite inferior | Limite superior |
|---|---:|---:|---:|
| Sinais | 0 | \(1{,}30\times10^{-8}\) | \(1{,}33\times10^{-8}\) |
| Permutação | \(3{,}37\times10^{-11}\) | \(1{,}68\times10^{-8}\) | \(2{,}54\times10^{-8}\) |
| Rotação ortogonal | \(6{,}00\times10^{-11}\) | \(2{,}72\times10^{-8}\) | \(3{,}78\times10^{-8}\) |
| Escala diagonal geral | \(4{,}82\times10^{-11}\) | \(1{,}74\times10^{-8}\) | \(2{,}54\times10^{-8}\) |
| Sinal de \(z\) | 0 | 0 | 0 |

A invariância é **Demonstrada** quando todos os objetos e covariâncias são transformados consistentemente. Isso não autoriza rotacionar somente os fatores ou \(K\).

## 8. Conciliação entre CSV, relatório, nota e paper

output/irf/ar_bands.csv contém \(106\times49\times3\times2=31.164\) linhas:

- 31.158 células não normalizadas no caso regular \(a>0,\Delta>0\), todas limitadas;
- seis células yield_6m, \(h=0\), uma por nível e amostra, impostas como \([0{,}005,0{,}005]\) e rotuladas ar_case = 1.

“31.164 conjuntos limitados” é **Demonstrado**. “31.164 ocorrências algébricas do caso 1” é **Refutado**: seis são singletons sobrescritos. O fixture contém 63 observações em cada um de quatro blocos — casedummy_68, casedummy_95 e versões acumuladas —, mas todos os indicadores são caso 1. A frase do apêndice segundo a qual as classificações coincidem “nas 63 células dos quatro casos possíveis” é **Refutada**: são quatro blocos, não quatro topologias.

Na amostra completa e banda de 90%, o bootstrap marca 92 das 106 séries no impacto ao incluir a normalização, ou 91 ao excluí-la. Dessas 91, quatro perdem a exclusão de zero pela banda AR, restando 87. A contagem 91 → 87 do paper é **Demonstrada**, desde que se explicite a exclusão de yield_6m; o relatório gerado que parte de 92 inclui essa célula.

A nota de 10 de agosto interpreta a diferença de largura AR/bootstrap como custo de ignorar incerteza dos fatores. Isso é **Não demonstrado**: também mudam linearização, resampling, correção de viés, componente idiossincrático e comportamento sob instrumento fraco. Uma razão de larguras não identifica a contribuição marginal da PCA.

A frase do paper de que os intervalos são válidos “sob qualquer força do primeiro estágio” é **Sustentada sob hipóteses** apenas para o modelo reduzido observado e MOSW. Sem “condicional aos fatores, loadings, escalas e subespaço estimados”, é **Não demonstrada** para o DFM completo.

## 9. Monte Carlo mínimo

O DGP usa \(r=7,q=6,p=6,N=106,T=150\), VAR estável, \(K\) de posto seis, proxy fraca (correlação 0,12) ou moderada (0,26) e quatro observáveis: normalização e três respostas representativas. Foram comparados fatores observados; PCA/loadings com erro idiossincrático independente; e PCA/loadings com dependência transversal moderada (0,18). Avaliaram-se \(h=0,6,12\) e cobertura nominal de 90%.

A rodada inicial de 500 replicações mostrou discrepâncias materiais e cruzou o limiar predefinido; elevou-se então para 2.000. A inversão usou o oráculo. Perto de 90%, o erro-padrão Monte Carlo é 0,67 ponto percentual.

| Regime | Força | Cobertura de impacto, três observáveis | Mín.–média–máx. nos nove pares | Conjuntos limitados |
|---|---|---:|---:|---:|
| Fatores observados | moderada | 87,05%–87,75% | 87,05%–95,23%–99,90% | 76,38% |
| Fatores observados | fraca | 86,65%–88,30% | 86,65%–95,64%–100,00% | 33,14% |
| Estimados, erro independente | moderada | 79,55%–80,70% | 79,55%–91,34%–99,55% | 88,95% |
| Estimados, erro independente | fraca | 80,80%–83,05% | 80,80%–92,94%–99,70% | 41,55% |
| Estimados, dependência transversal | moderada | 78,10%–80,30% | 78,10%–91,25%–99,45% | 82,45% |
| Estimados, dependência transversal | fraca | 81,25%–83,40% | 81,25%–93,13%–99,85% | 37,65% |

A normalização tem cobertura unitária em \(h=0\) por construção e não informa validade. Em \(h=6,12\), a inversão tende a ser conservadora; a subcobertura concentra-se no impacto. Mesmo com fatores observados, a aproximação finita fica 1,7–3,4 pontos abaixo do nominal. Estimar fatores acrescenta cerca de cinco a nove pontos de perda.

O Monte Carlo é **Evidência parcial** contra o plug-in nas dimensões do projeto. Não prova falha assintótica, não cobre toda a classe não estacionária e não reproduz cada autocovariância brasileira. Serve como possível falsificação: a incerteza omitida não é automaticamente desprezível em \(N=106,T\approx150\).

## 10. Literatura, hipóteses e respostas ao orientador

| Fonte | Resultado e regime | Correspondência | Hipótese não verificada |
|---|---|---|---|
| [Montiel Olea, Stock e Watson (2021), DOI 10.1016/j.jeconom.2020.05.014](https://www.princeton.edu/~mwatson/papers/JOE_Publication_SVARIV.pdf) | A Proposição 1 permite relevância local a zero e usa normalidade conjunta \(\sqrt T\) dos estimadores reduzidos observados e consistência de \(\Omega\). O conjunto é limitado quando a força excede o crítico. | Mapeia \(A,\Gamma,W\) condicionais. | Não contém PCA, \(\Lambda,s_y,K\) estimados nem uniformidade da razão observável. |
| [Bai (2003), DOI 10.1111/1468-0262.00392](https://onlinelibrary.wiley.com/doi/abs/10.1111/1468-0262.00392) | Taxas e limites para fatores, loadings e componentes comuns quando \(N,T\to\infty\), admitindo dependência sob condições. | Fundamenta consistência de partes fatoriais. | Não trata proxy localmente fraca, normalização ou AR. |
| [Bai e Ng (2006), DOI 10.1111/j.1468-0262.2006.00696.x](https://deepblue.lib.umich.edu/items/1ff8f636-8953-4a57-a1c2-8598c9301c1c) | Inferência em regressões fator-aumentadas; o erro fatorial depende das taxas relativas. | Mostra a relevância de generated regressors. | Resultado pointwise não implica uniformidade fraca ou denominador estimado. |
| [Gonçalves e Perron (2014), DOI 10.1016/j.jeconom.2014.04.015](https://ideas.repec.org/a/eee/econom/v182y2014i1p156-173.html) | Quando \(\sqrt T/N\) não desaparece, erro fatorial pode entrar no limite; bootstrap de duas etapas deve reproduzir dependência idiossincrática transversal. | Diretamente relevante à omissão de \(\Lambda,F\). | Não é proxy-SVAR fraco nem razão AR. |
| [Barigozzi, Lippi e Luciani (2021), DOI 10.1016/j.jeconom.2020.05.004](https://ideas.repec.org/a/eee/econom/v221y2021i2p455-482.html) | Consistência de fatores, loadings, choques, VECM e IRFs em DFM \(I(1)\). | Apoia o DFM não estacionário plug-in. | Não demonstra cobertura uniforme sob proxy fraca. |
| [Barigozzi, arXiv 2211.01921](https://arxiv.org/abs/2211.01921) | Equivalências PCA/OLS sob \(\sqrt N/T\to0\) e \(\sqrt T/N\to0\). | Expõe taxas potencialmente suficientes. | No projeto, \(\sqrt T/N\approx0{,}114\) e \(\sqrt N/T\approx0{,}070\); números finitos não verificam limites nem uniformidade. |
| [Jentsch e Lunsford (2022), DOI 10.1080/07350015.2021.1990770](https://ideas.repec.org/a/taf/jnlbes/v40y2022i4p1876-1891.html) | Bootstrap residual em blocos e conjuntos AR robustos à força; o [working paper](https://www.clevelandfed.org/-/media/project/clevelandfedtenant/clevelandfedsite/publications/working-papers/2019/wp-1908-asymptotically-valid-bootstrap-inference-for-proxy-svars-pdf.pdf) alerta que wild bootstrap pode ser mal dimensionado. | Sugere rota no VAR observado. | Não incorpora estimação fatorial. |
| [Stock e Watson (2018), NBER 24216](https://www.nber.org/papers/w24216) | Condições e estimadores de SVAR com instrumentos externos. | Fundamenta identificação por proxy. | Não resolve generated factors sob fraqueza. |
| [Angelini, Cavaliere e Fanelli (2024), DOI 10.1016/j.jeconom.2023.105604](https://www.sciencedirect.com/science/article/pii/S0304407623003202) | Inferência com proxies fracas e instrumentos fortes para choques não alvo. | Confirma necessidade de tratamento explícito. | Desenho e instrumentos não são os do projeto; não há PCA. |
| [Brignone, Franconi e Mazzali, versão 22-03-2026](https://arxiv.org/abs/2307.06145) | Proxy-DFM e ganhos informacionais em respostas estruturais. | Referência mais próxima de proxy + DFM. | Não foi localizado teorema de cobertura AR uniforme com fatores estimados. |

A busca até agosto de 2026 não encontrou teorema publicado que cubra simultaneamente fatores/loadings e \(K\) estimados, proxy localmente fraca, denominador estimado, resposta observável e inversão uniforme. Ausência na busca não prova inexistência: a conclusão bibliográfica é **Evidência parcial**. A alegação de que essas fontes provam diretamente o procedimento atual é **Não demonstrada**.

Condições como \(\sqrt T/N\to0\) podem remover termos em expansões pointwise. Não se transportam automaticamente para uma razão com denominador localmente pequeno: um \(o_p(1)\) longe de zero pode ser de primeira ordem na vizinhança fraca. O projeto também não verificou uniformidade, eigengaps, dependência transversal e taxas suficientes para \(L,Q,s_y\). O mapeamento integral exigido para classe 2 não existe.

**Pergunta 1 — A adaptação MOSW ao DFM é algébrica e computacionalmente correta?**

**Resposta:** **Sustentado sob hipóteses.** Sim, condicionando em \(L,Q\), rotação, escalas e amostra. A razão, os gradientes, \(W\), a quadrática e as transformações reproduzem o resultado atual. Há, porém, erro demonstrado na inversão degenerada; ele não altera as células publicadas.

**Pergunta 2 — As bandas têm cobertura de 90% para as IRFs observáveis depois de estimar os fatores?**

**Resposta:** **Não demonstrado.** MOSW valida a etapa reduzida observada sob suas hipóteses. O código omite da covariância a influência de \(F,\Lambda,s_y,K\), não há teorema mapeado ao regime fraco completo e o Monte Carlo mostra subcobertura material no impacto. A redação defensável é “bandas AR condicionais à extração fatorial estimada”.

## 11. Alegações finais e correções prioritárias

| Alegação | Veredito | Base |
|---|---|---|
| A IRF AR e res$irfs têm o mesmo estimando | **Demonstrado** | Identidade (1) e erro máximo \(6{,}08\times10^{-9}\) |
| \(M\) e \(T/(z'z)\) sempre cancelam | **Sustentado sob hipóteses** | Mesmo desenho, \(M\) simétrico/inversível e denominador não nulo |
| Gradientes de \(A\) e \(\Gamma_u\) estão corretos | **Demonstrado** | Derivação e diferenças finitas |
| WHat reproduz MOSW/MATLAB no SVAR observado | **Demonstrado** | Fixture, erro relativo \(4{,}915\times10^{-14}\) |
| WHat é a covariância integral da resposta DFM | **Refutado** | Omite \(\Lambda,s_y,K,F\) estimados |
| A quadrática é correta nos casos regulares | **Sustentado sob hipóteses** | Expansão, fixture e oráculo |
| A inversão cobre todos os degenerados | **Refutado** | Falhas linear, vazio, singleton e quase linear |
| As bandas publicadas são reproduzíveis | **Demonstrado** | Python independente e reestimação em memória |
| O erro degenerado alterou ar_bands.csv | **Refutado** | 31.158 casos regulares e seis singletons sobrescritos |
| Há 31.164 conjuntos limitados | **Demonstrado** | Contagem do CSV |
| Há 31.164 casos algébricos regulares | **Refutado** | Seis normalizações impostas |
| O fixture testa as quatro topologias | **Refutado** | Quatro blocos, todos caso 1 |
| A contagem 91 → 87 está correta | **Demonstrado** | Exclui yield_6m; incluindo-a, 92 → 88 |
| A razão de larguras mede incerteza fatorial | **Não demonstrado** | Procedimentos diferem em várias dimensões |
| Há invariância a sinais, ordem e rotação | **Demonstrado** | Transformações conjuntas e \(W\) refeito |
| MOSW prova cobertura depois da PCA | **Refutado** | Teorema não contém generated factors |
| O plug-in é aceitável em \(N=106,T\approx150\) | **Evidência parcial** | Monte Carlo adverso, sem prova geral |
| Pode-se dizer “válido sob qualquer força” sem qualificação | **Não demonstrado** | Lacuna fatorial e evidência finita |
| Classificação global pela regra dada | **Demonstrado: classe 4** | Inversão incorreta em degenerações |

Correções priorizadas, não aplicadas:

1. **Prioridade 0 — inversão.** Substituir o classificador por solucionador completo e tolerante à escala, cobrindo termos lineares, constante, \(\Delta=0\), singleton, vazio, toda a reta e quase degeneração. Testar contra a desigualdade direta, sem atualizar fixtures apenas para fazê-los passar.
2. **Prioridade 0 — redação.** Qualificar a validade como condicional; trocar “quatro casos possíveis” por “quatro blocos do fixture, todos regulares”; registrar 31.158 intervalos mais seis singletons; explicitar a exclusão da normalização em 91 → 87.
3. **Prioridade 1 — inferência fatorial.** Derivar a influência conjunta de \((A,\Gamma_u,L,Q,s_y)\) sob o DFM não estacionário ou implementar procedimento de duas etapas/blocos que reestime fatores e preserve dependência idiossincrática. Avaliar cobertura sob proxy localmente fraca.
4. **Prioridade 1 — bootstrap principal.** Auditar separadamente o wild bootstrap à luz de Jentsch–Lunsford; bandas AR condicionais não validam automaticamente o bootstrap comparado.
5. **Prioridade 2 — transparência.** Guardar sementes, tolerâncias, conjuntos não limitados e distâncias de \(a,\Delta\) a zero; distinguir conjunto limitado, caso regular e normalização imposta.

Nenhuma correção foi aplicada. As bandas atuais são reproduzíveis e não foram atingidas pelo erro degenerado, mas a cobertura incondicional continua aberta. A confiança no diagnóstico algébrico/computacional é alta; a extrapolação do Monte Carlo ao DGP brasileiro tem confiança moderada. Um teorema que cubra diretamente a razão observável com fatores estimados — ou evidência de cobertura de procedimento de duas etapas em desenhos adversariais — poderia elevar o veredito depois de corrigida a inversão.
