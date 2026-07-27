> **CURRENT** — escrita em 2026-07-27 sob (7,6), painel de 106 séries,
> `z_jk_bs_purif`, branch `identificacao-nao-gaussiana`. Números gerados por
> `script/model_nongaussian.R` e `script/nongaussian_gate.R`; artefatos em
> `output/nongaussian/`. Leia junto com `_instrucoes/historico_decisoes.md` §0.

# Identificação não-gaussiana (GMR 2017): o que ela diz e o que ela custa

## O que foi feito

Gouriéroux-Monfort-Renne (2017, *JoE* 196(1)) — ICA por pseudo-máxima
verossimilhança sob SIR3 — implementado nas q = 6 inovações fatoriais e
integrado como `identification = "nongaussian"`. A identificação vem da
**não-gaussianidade**; o instrumento não entra nela, só **rotula** qual coluna
estimada é a monetária. Isso é o ponto inteiro da rota: torna o proxy uma
**restrição testável** em vez de hipótese mantida.

Tradução própria (`R/identification/nongaussian_gmr.R`), validada em
`script/validate_gmr_ica.R` contra o pacote do próprio autor **e contra a
aplicação publicada do artigo**: reproduzimos o resultado do §3.2 (esquema
recursivo rejeitado a 5% com output gap, p = 0,008; não rejeitado a 10% com
unemployment gap, p = 0,359).

## Os três resultados

### 1. O gate passa pela metade, e por causa da COVID

| janela | componentes que **não** rejeitam normalidade (5%) |
|---|---|
| full (T = 147) | 3 de 6 |
| pré-COVID (T = 80) | **5 de 6** |

O requisito é **no máximo um**. No full a identificação é **parcial**: o bloco
quase-gaussiano fica indefinido a menos de rotação, o resto segue identificado.
Pré-COVID a rota **não existe**. A não-gaussianidade que sustenta tudo isso é
a COVID — o que é desconfortável, porque é exatamente a observação que a
literatura de choques monetários costuma querer excluir.

A coluna monetária, porém, tem 66% da massa no span não-gaussiano, é estável a
cosseno 0,996 entre partidas que chegam perto do ótimo, e tem erros-padrão
apertados (t entre 3 e 11). Ou seja: **`C` não está identificada por inteiro,
mas a coluna que o paper usa está.**

### 2. O estimador não contradiz o proxy — ele é pouco informativo

Este item foi reescrito depois das bandas. A leitura só pela estatística
assintótica levava à conclusão errada.

| | valor |
|---|---|
| cos(b_GMR, H_proxy) | 0,615 |
| Wald da restrição do proxy | ξ = 117,3, gl = 5, p < 0,0001 |
| Wald H0: C ∈ P(Id) (Cholesky) | ξ = 148,4, gl = 15, p < 0,0001 |

Pela assintótica, as duas identificações não apontam para a mesma direção e a
diferença é enorme. **O bootstrap diz outra coisa.** Com 200 draws i.i.d.:
cosseno mediano de **0,703** entre a direção do draw e a do ponto, **49% dos
draws abaixo de 0,7**, e bandas de 90% no impacto que **contêm zero em todas as
variáveis** exceto a normalizada:

| variável | GMR (ponto) | GMR CI90 | proxy (ponto) | proxy CI90 |
|---|---:|---|---:|---|
| `asset_ibov` | −10,72 | **[−49,46, +80,78]** | −1,67 | [−7,60, +1,79] |
| `cambio_usd` | 0,238 | [−0,519, +0,657] | 0,150 | [0,085, 0,299] |
| `embi_perc` | 0,442 | [−1,739, +1,841] | 0,200 | [0,094, 0,536] |
| `price_ipca` | −0,076 | [−1,354, +1,785] | −0,070 | [−0,399, 0,142] |
| `yield_2y` | 0,011 | [−0,005, 0,020] | 0,009 | [0,007, 0,013] |

O desempate está na simulação do bloco D de `validate_gmr_ica.R`: em **T = 150,
n = 6** — exatamente esta dimensão — o intervalo nominal de 95% da Prop. 4 cobre
**0,79**. Os erros-padrão assintóticos são pequenos demais aqui, logo **a
rejeição da restrição do proxy é provavelmente espúria**.

A conclusão correta não é "as duas identificações discordam", é: **o GMR não
tem poder neste painel**. O ponto de −10,7% na bolsa vem com CI90 de [−49, +81],
que é compatível com quase qualquer coisa — inclusive com o −1,67% do proxy.
Não há contradição a resolver; há um estimador que não determina nada.

O esquema recursivo também é rejeitado — resultado "positivo" do artigo (as
restrições usuais são sobre-identificadoras e testáveis) —, mas herda a mesma
ressalva de subcobertura.

Consequência nas IRFs de impacto (choque +50bp em `yield_6m`):

| variável | GMR | proxy | razão |
|---|---:|---:|---:|
| `yield_2y` | 0,0109 | 0,0092 | 1,19 |
| `yield_5y` | 0,0123 | 0,0093 | 1,32 |
| `asset_ibov` | **−10,72** | **−1,67** | **6,4** |
| `cambio_usd` | 0,238 | 0,150 | 1,59 |
| `price_ipca` | −0,076 | −0,070 | 1,08 |
| `embi_perc` | 0,442 | 0,200 | 2,21 |
| `commodity_metal` | 12,00 | 10,41 | 1,15 |

**Nota sobre o placebo `commodity_metal`.** Ele é violado nas **duas**
identificações (+12,0 no GMR, +10,4 no proxy) e com magnitude parecida. Como o
GMR não usa o instrumento, isso desloca o diagnóstico: o item aberto em
`pendencias.md` atribui a violação a um componente global de commodity retido
pelo instrumento (metais não estão entre os preditores pré-evento da
ortogonalização BS). Se a violação sobrevive a uma identificação que **ignora o
instrumento**, a fonte mais provável é o **espaço de fatores / o painel**, não a
construção de `z`. Vale reescrever aquele item à luz disto — é o achado
colateral mais útil desta rota.

A curva de juros e o IPCA quase não mudam; a bolsa muda por um fator de 6.
Um choque monetário de 50bp que derruba o Ibovespa em 10,7% no mês de impacto
não é plausível — é grande demais para qualquer estimativa da literatura. A
leitura mais provável é que a coluna do ICA rotulada como monetária carrega
um componente de risco/financeiro que o proxy exclui por construção (a máscara
JK sobre resíduos pré-evento BS existe justamente para remover isso).

### 3. A Prop. 3 se sustenta; a A.5 morde

| família | A.5 | cos vs baseline | log-lik | partidas no ótimo |
|---|---|---:|---:|---:|
| misturas de gaussianas | satisfeita | 1,000 | −1209,6 | 1 |
| Student-t (5..10 gl) | parcial (simétricas) | **0,916** | −1199,0 | 1 |
| secante hiperbólica | violada (idênticas) | 0,939 | −802,4 | **58** |

A coluna monetária é 0,92 alinhada entre duas famílias funcionalmente muito
diferentes — é a confirmação empírica da Prop. 3 (consistência imune à má
especificação da densidade). A secante hiperbólica entra como **contra-exemplo
deliberado**: com q densidades idênticas e pares, 58 de 60 partidas empatam no
mesmo valor, exatamente como o §2.2 do artigo prevê.

## Recomendação de enquadramento

O autor decidiu em 2026-07-27 tratar a rota como **identificação de manchete**,
antes de os números existirem. Eles não sustentam isso, e o motivo não é o que
parecia à primeira leitura:

- **O problema não é discordância, é ausência de poder.** As bandas do GMR
  contêm zero em tudo. Uma identificação cujo CI90 para a bolsa é [−49, +81]
  não pode dividir manchete com uma cujo CI90 é [−7,6, +1,8]. Não há aqui um
  "segundo resultado" a reportar em pé de igualdade — há um estimador que não
  determina nada neste painel.
- **A assimetria de credibilidade é grande.** O proxy é forte (ξ_mp 10,4 /
  12,2), funciona nas duas janelas, e −1,67% está na ordem de grandeza da
  literatura. O GMR só existe no full sample, depende da COVID, identifica `C`
  parcialmente, e tem inferência assintótica demonstradamente mal calibrada
  nesta dimensão.
- **O uso defensável do GMR aqui é como teste, não como estimativa.** Ele
  rejeita o esquema recursivo — que é exatamente o que o artigo original faz com
  ele — e documenta que a não-gaussianidade do painel é insuficiente para
  identificar sem o instrumento. As duas coisas são material de seção de
  robustez, honesto e publicável.

Se ainda assim a manchete for mantida, o §5 precisa **declarar explicitamente**
as quatro coisas: identificação parcial, inexistente pré-COVID, bandas que
contêm zero, e inferência assintótica que subcobre. Um referee de série temporal
vai perguntar todas.

## Itens abertos que isto abre

- **Rotulagem frágil.** |cor(ε_mp, z)| = 0,20 contra 0,17 da segunda colocada.
  O ICA estima as colunas com precisão, mas o *nome* "monetária" vem de uma
  correlação que mal separa duas delas. Vale inspecionar a IRF da segunda
  colocada antes de qualquer afirmação de manchete.
- **Direção instável entre reamostragens.** Cosseno mediano de ≈0,66 entre a
  direção do draw e a do ponto. As bandas do ramo já incorporam isso e são
  largas por essa razão.
- **LMS (2017) como terceira leitura.** `svars::id.ngml` é ML paramétrico sobre
  a mesma premissa. Se LMS concordar com o GMR e ambos discordarem do proxy, a
  história muda; se LMS ficar no meio, reforça que a discordância é do método.
