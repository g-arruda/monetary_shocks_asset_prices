# Diagnóstico da convergência rápida das IRFs do VAR pequeno

**Data:** 2026-08-22
**Objeto:** painel de respostas a impulso do único VAR pequeno ativo,
`ibc5_fx_cds_stat_p1`, com variação por horizonte mensal `h = 0,...,36` e por
cinco variáveis observáveis.

## Conclusão

A hipótese de trabalho é confirmada com uma ressalva importante. A convergência
não segue `1/h` e não há sinal de erro de orientação, normalização ou
serialização. No VAR(1) estimado, a resposta é exatamente

\[
IRF_h=A^hB_1.
\]

As cinco raízes de `A` têm módulo inferior a um. A dominante é a raiz real
`0,683593374`, com meia-vida de `1,822` mês; as demais têm módulos `0,281075`,
`0,187729` e `0,026166` e desaparecem ainda mais depressa. Como a raiz
dominante tem projeção não nula sobre as cinco respostas, todas as razões
`IRF_h/IRF_{h-1}` convergem numericamente para `0,683593374`. Em `h = 36`, a
razão coincide com essa raiz nas casas exibidas para as cinco variáveis.

A ressalva é que cada IRF é uma soma de modos, e não uma única exponencial nos
primeiros meses. Cancelamentos fortes produzem mudanças de sinal e corcovas no
IBC-Br, no IPCA e no câmbio. Por isso, a frase correta é “dinâmica matricial
geométrica com mistura modal”, não “cada curva é uma exponencial simples desde
o impacto”.

## Reconstrução e gates numéricos

A reconstrução usou diretamente `production_spec()`, `olea_rform_var()`,
`mosw_rform_cov()` e `mosw_svar_iv()` sobre os dados correntes, sem modificar
código ou outputs. A ordem das variáveis foi
`{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}`; as linhas de `A` são as
equações e as colunas são as variáveis defasadas. O vetor de impacto reconstruído
foi:

| variável | elemento de `B_1` |
|---|---:|
| `ibc_br` | -0,637275452 |
| `price_ipca` | -0,056818963 |
| `yield_6m` | 0,005000000 |
| `cambio_usd` | 0,092674234 |
| `cds_5y` | 20,119319361 |

Os gates confirmaram:

- 153 meses no painel, 152 observações após as transformações e 151 resíduos;
- alinhamento exato do instrumento com esses 151 resíduos, dos quais 61 têm
  `z_jk_bs_purif` não nulo;
- `p = 1` como mínimo do BIC literal de Olea na amostra comum de `T = 140`;
- normalização exata de +50 pb: `B_1[yield_6m] = 0,005`;
- estabilidade: `max |lambda| = 0,683593374 < 1`;
- `max |A^h B_1 - C_h B_1| = 0` na precisão da máquina;
- desvio máximo de `3,55e-15` entre a reconstrução e os pontos do CSV
  `output/var/svar_iv_weak_robust.csv`;
- desvio máximo de `2,44e-15` entre a soma dos modos próprios e a IRF.

Esses resultados também confirmam que não houve transposição acidental de `A`,
troca da ordem das séries, desalinhamento do instrumento ou perda da
normalização na gravação do CSV.

## Espectro e decomposição modal

| raiz | módulo | meia-vida (meses) | leitura |
|---:|---:|---:|---|
| 0,683593374 | 0,683593374 | 1,822 | modo dominante e cauda comum |
| 0,278198356 ± 0,040109221i | 0,281074857 | 0,546 | par complexo muito amortecido |
| -0,187728686 | 0,187728686 | 0,414 | modo alternante curto |
| -0,026166272 | 0,026166272 | 0,190 | praticamente desaparece após o impacto |

O modo dominante responde por aproximadamente 99,9% da soma das contribuições
em valor absoluto em `h = 12` para IBC-Br, IPCA e yield; por 99,0% no câmbio e
99,96% no CDS. Isso explica por que a razão de cada resposta converge para a
mesma raiz.

Nos primeiros horizontes, entretanto, há cancelamentos relevantes. A medida
`1 - |soma dos modos| / soma |modos|` é 85,9% para o IPCA e 65,2% para o câmbio
no impacto; para o IPCA ainda é 81,4% em `h = 1`. Em `h = 3`, permanece em
27,0% no IPCA e 40,7% no câmbio. Esses cancelamentos explicam:

- o IBC-Br passar de queda no impacto para pequena alta em `h = 1`;
- o IPCA passar de `-0,0568` no impacto para uma corcova positiva, com pico em
  `h = 2`;
- o câmbio quase zerar e ficar ligeiramente negativo em `h = 4--5` antes de a
  cauda dominante aparecer.

Não são desvios da lei do VAR: são a soma de cinco sequências geométricas com
sinais e fases diferentes.

## `1/h` contra decaimento geométrico

Foram ajustadas, por mínimos quadrados e sem intercepto, duas formas aos pontos
de cada IRF: `a/(h+1)` e `b lambda^h`. Na janela completa, a razão entre o erro
quadrático médio normalizado do ajuste hiperbólico e o do geométrico foi 5,82
no IBC-Br, 1,21 no IPCA, 3,66 no yield, 6,10 no câmbio e 20,57 no CDS. O IPCA é
o caso difícil porque muda de sinal e forma uma corcova; uma única exponencial
também é uma aproximação incompleta no início.

Na cauda `h = 6--36`, onde os modos rápidos já se dissiparam, a vantagem do
ajuste geométrico se torna decisiva: as mesmas razões de erro são 32,5; 262,8;
1.748,3; 22,1; e 261,7. Além disso, uma sequência proporcional a `1/(h+1)`
teria razão sucessiva `h/(h+1)`, que tende a um. Aqui as razões observadas
tendem a `0,683593374`. Essa diferença assintótica rejeita diretamente a
interpretação `1/h`.

## Resumo por variável

“Convergência virtual” é o primeiro horizonte após o qual a resposta permanece
dentro de 1% do seu próprio pico absoluto. A razão de cauda é a mediana de
`|IRF_h/IRF_{h-1}|` em `h = 6,...,12`. A meia-vida efetiva usa a exponencial
ajustada em `h = 6--36`; a meia-vida assintótica do sistema é 1,822 mês para
todas as séries.

| variável | impacto, escala da figura | razão `h1/h0` | razão de cauda | meia-vida efetiva | convergência virtual | explicação |
|---|---:|---:|---:|---:|---:|---|
| IBC-Br | -0,6421% da média | -0,092 | 0,672 | 1,66 mês | h=7 | reversão inicial por mistura modal; cauda dominada pela raiz 0,684 |
| IPCA | -0,0568 p.p. ao mês | -0,648 | 0,685 | 1,84 mês | h=16 | já entra em nível; cancelamento inicial gera a corcova e prolonga o critério relativo |
| DI 6 meses | +50,0 pb | 0,427 | 0,684 | 1,82 mês | h=10 | trajetória mais limpa; o modo dominante já responde por 94,3% em h=3 |
| câmbio BRL/USD | +2,2539% da média | 0,403 | 0,625 | 1,37 mês | h=3 | cancelamentos quase anulam h=2--5; a razão chega a 0,6835 em h=18 |
| CDS 5 anos | +20,1193 pb | 0,300 | 0,685 | 1,85 mês | h=6 | modos rápidos explicam a queda inicial; a raiz dominante assume a cauda |

## Por que as antigas curvas acumuladas iam para um teto

Para qualquer VAR(1) estável,

\[
\sum_{j=0}^{h} A^jB_1
= (I-A^{h+1})(I-A)^{-1}B_1
\longrightarrow (I-A)^{-1}B_1.
\]

Portanto, “a resposta da variação mensal vai rapidamente a zero” e “a resposta
implícita do nível vai rapidamente a um teto” são duas representações da mesma
dinâmica estável. Aplicando apenas como diagnóstico algébrico a soma aos pontos
correntes, os limites implícitos são:

| série diferenciada | teto implícito, escala da figura | entrada permanente em faixa de 1% |
|---|---:|---:|
| IBC-Br | -0,4311% da média | h=8 |
| DI 6 meses | +104,30 pb | h=10 |
| câmbio BRL/USD | +3,3379% da média | h=2 |
| CDS 5 anos | +29,9109 pb | h=7 |

O IPCA não pertence a essa tabela: ele já entra em nível e sua IRF corrente não
deve ser acumulada. Também não se somaram os limites dos conjuntos AR. Somar
pontos é uma identidade linear; somar extremos de conjuntos obtidos por
inversão de testes não produz um conjunto de confiança válido.

As antigas figuras acumuladas pertenciam a uma vintage superada, em que o IPCA
também era diferenciado, os pontos eram somados e havia wild bootstrap. Seus
tetos numéricos específicos dependiam da matriz e do vetor de impacto daquela
especificação. A identidade geométrica explica o formato histórico sem
reativar aquela especificação nem reinterpretar seus intervalos.

## O que determina a rapidez

1. **Raízes pequenas — causa mecânica principal.** A maior é 0,684 e as outras
   desaparecem em menos de um mês de meia-vida. Essa é a razão direta para a
   curta persistência.
2. **`p = 1` — representação selecionada, não explicação suficiente.** O BIC
   seleciona uma defasagem, o que reduz a dinâmica a `A^h`, mas um VAR(1) pode
   ter raiz próxima de um. Sem estimar uma especificação contrafactual — fora
   do escopo e vedada como nova sensibilidade ativa — não se pode dizer que
   `p = 1` causou raízes pequenas.
3. **Primeiras diferenças — determinam o objeto econômico.** Em IBC-Br, yield,
   câmbio e CDS, a IRF corrente é resposta da variação mensal; a resposta
   implícita do nível é sua soma. Diferenciar não obriga o VAR a ter raiz 0,684,
   mas torna natural que a variação volte a zero enquanto o nível converge.
4. **Cancelamentos — determinam o formato variável a variável.** Eles explicam
   por que câmbio e IBC-Br parecem convergir ainda mais depressa e por que o
   IPCA leva mais tempo pelo critério de 1% apesar da mesma cauda assintótica.

## Blindspot Report

**Output:** painel de respostas `C_h B_1` do VAR observável; unidade de variação:
horizonte mensal, variável e modo próprio.
**Date:** 2026-08-22

### Vice 1: The Unexplained Feature

- **Object and unit of variation:** IRFs pontuais em cinco variáveis ao longo de
  `h = 0,...,36`.
- **Hardest feature to explain, stated as a feature:** o IPCA muda de sinal,
  atinge uma corcova positiva em `h = 2` e é a única série para a qual uma
  exponencial simples melhora pouco sobre `1/(h+1)` na janela completa.
- **Explanation attempted:** o IPCA tem cancelamento modal de 85,9% no impacto e
  81,4% em `h = 1`; depois de `h = 6`, o ajuste geométrico supera o hiperbólico
  por fator 262,8 e a razão converge para 0,683593.
- **Resolved?** yes — **DONE**.
- **Findings:** mudanças de sinal no IBC-Br e no câmbio também são explicadas
  pela decomposição. Todos os pontos, inclusive essas feições, reproduzem o CSV
  canônico na precisão da máquina.

### Vice 2: The Convenient Absence

- **Missing checks identified:** não há contrafactual de ordem de defasagem
  nesta auditoria; logo, não se atribui causalmente a rapidez a `p = 1`. As
  matrizes da vintage acumulada superada não são usadas para reproduzir seus
  tetos específicos.
- **Missing subgroups:** não se investigam subsamples, regimes ou assimetrias;
  eles não são necessários para a identidade dinâmica, mas seriam necessários
  para alegar estabilidade da persistência entre regimes.
- **Unexplained N changes:** nenhum. As perdas 153 → 152 → 151 decorrem,
  respectivamente, da transformação estacionária e da única defasagem.
- **Findings:** as ausências limitam atribuições causais sobre a escolha de `p`
  e comparações numéricas com vintages, não o diagnóstico algébrico atual —
  **FLAG** para qualquer redação que vá além disso.

### Virtue 1: The Unasked Question

- **Heterogeneity opportunities:** a velocidade aparente difere mais por
  projeção e cancelamento modal do que por persistência assintótica.
- **Mechanism evidence:** as razões sucessivas e as participações modais separam
  dinâmica sistêmica comum de formato específico de cada variável.
- **Secondary findings:** a convergência mais lenta do IPCA pelo critério de 1%
  não indica uma raiz própria mais persistente; decorre da pequena resposta
  inicial produzida por cancelamento.
- **Findings:** a decomposição oferece uma linguagem mais precisa que “as IRFs
  morrem rápido” — **DONE**.

### Virtue 2: The Unexploited Strength

- **Undersold design features:** a implementação vigente contém gates internos
  de estabilidade, orientação, normalização e identidade `C_hB_1`; a auditoria
  externa os reproduz contra o CSV.
- **Unused falsification tests:** a comparação assintótica das razões é uma
  falsificação direta de `1/h`: sob a hipótese hiperbólica a razão tenderia a
  um, mas converge para 0,683593.
- **Positioning opportunities:** a conexão entre respostas de diferenças e
  tetos de níveis resolve a aparente contradição visual entre figuras correntes
  e históricas sem ressuscitar inferência superada.
- **Findings:** a explicação pode ser feita inteiramente com álgebra do VAR e
  artefatos existentes — **DONE**.

### Ruling

[ ] CLEAR — proceed to interpretation. No vices found; virtues noted for consideration.
[x] CONDITIONAL — proceed but acknowledge open questions explicitly. Vices flagged but manageable.
[ ] HOLD — do not interpret or publish until flagged vices are resolved.

O veredito é **CONDITIONAL** apenas para impedir duas extrapolações: dizer que
`p = 1` causou a baixa persistência e tratar os tetos históricos como números
da especificação corrente. Para a conclusão estreita — dinâmica geométrica de
um VAR(1) estável, não `1/h` nem bug — o diagnóstico é conclusivo.
