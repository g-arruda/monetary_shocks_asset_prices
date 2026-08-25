# Diagnóstico contrafactual do VAR pequeno em níveis

**Data:** 2026-08-22
**Objeto:** respostas a impulso do sistema
`{ibc_br, price_ipca, yield_6m, cambio_usd, cds_5y}` estimado integralmente em
níveis, com `z_jk_bs_purif`, normalização de +50 pb em `yield_6m` e ordem
selecionada pelo BIC literal de Montiel Olea et al.
**Status:** exercício diagnóstico; não substitui nem reabre o benchmark ativo
`ibc5_fx_cds_stat_p1`.

## Resultado principal

O BIC em amostra comum seleciona `p = 1`, mas o VAR em níveis não apresenta a
convergência rápida do benchmark estacionário. A matriz estimada tem um par de
raízes complexas

\[
0{,}995073 \pm 0{,}024969i,
\qquad |\lambda|=0{,}995386,
\]

cujo envelope tem meia-vida de `149,9` meses e período de `250,4` meses. A
dinâmica é geometricamente amortecida, mas quase unitária e oscilatória. Não é
proporcional a `1/h`, nem pode ser bem resumida por uma única exponencial real
na cauda.

A estatística solicitada de força do instrumento é

\[
\boxed{\xi_{mp}=5{,}849952}.
\]

No código do VAR observável, a mesma estatística aparece com o rótulo
`xi_var`; ela é calculada na direção que normaliza `yield_6m`, com NW(0). Fica
abaixo de 10 e ligeiramente abaixo do valor `6,024922` do benchmark estacionário
ativo. Isso é diagnóstico de relevância, não teste de validade da proxy.

## Seleção de defasagens

O BIC foi calculado para `p = 1,...,12` com as mesmas `T = 141` observações em
cada ordem:

\[
BIC(p)=\log|\widehat\Sigma_p|+
\frac{\log(T)N^2p}{T}.
\]

| p | BIC de Olea | diferença para o mínimo |
|---:|---:|---:|
| 1 | **-9,830227** | 0,000000 |
| 2 | -9,747307 | 0,082920 |
| 3 | -9,158936 | 0,671291 |
| 4 | -8,647567 | 1,182660 |
| 5 | -8,135994 | 1,694233 |
| 6 | -7,590517 | 2,239710 |
| 7 | -6,962348 | 2,867879 |
| 8 | -6,255961 | 3,574266 |
| 9 | -5,645255 | 4,184973 |
| 10 | -5,369690 | 4,460537 |
| 11 | -4,860778 | 4,969450 |
| 12 | -4,261344 | 5,568883 |

Logo, a resposta à pergunta de seleção é `p = 1`. A separação para `p = 2` é
positiva, porém pequena (`0,0829`); isso não muda o argmin, mas desaconselha
tratar a escolha como evidência esmagadora.

## Estacionariedade: o bloqueador substantivo

Os testes já vigentes para as séries em nível mostram:

| variável | ADF | PP Z-tau | ADF rejeita a 5%? | PP rejeita a 5%? |
|---|---:|---:|:---:|:---:|
| `ibc_br` | -1,1970 | -1,1971 | não | não |
| `price_ipca` | -5,2780 | -6,8823 | sim | sim |
| `yield_6m` | -2,3430 | -1,0456 | não | não |
| `cambio_usd` | -1,5589 | -1,4356 | não | não |
| `cds_5y` | -2,8172 | -2,8620 | não | não |

O valor crítico é próximo de `-2,88`. Assim, somente `price_ipca` é
estacionário em nível pelos dois testes. Quatro das cinco séries não rejeitam
raiz unitária. O fato de a raiz estimada da companion ficar numericamente
abaixo de um não rehabilita o modelo: `0,995386` é precisamente o tipo de
quase-raiz unitária difícil de distinguir de um em uma amostra curta.

## Gates e força do instrumento

- amostra em níveis: 153 meses;
- amostra comum do BIC: 141 observações;
- ordem selecionada: `p = 1`;
- resíduos alinhados ao instrumento: 152;
- meses com instrumento não nulo: 61;
- normalização: `B_1[yield_6m] = 0,005` exatamente;
- `xi_mp = 5,849951983` com NW(0);
- raiz máxima: `0,995386248`;
- desvio entre pontos SVAR-IV e pontos usados na inversão AR: `1,78e-15`;
- desvio em `IRF_h = C_hB_1`: zero na precisão da máquina.

Não há sinal de erro de orientação, alinhamento ou normalização. O problema do
VAR em níveis é econométrico e dinâmico, não de implementação.

## Raízes e persistência

| raiz | módulo | meia-vida | período |
|---:|---:|---:|---:|
| 0,995073 ± 0,024969i | 0,995386 | 149,9 meses | 250,4 meses |
| 0,939582 | 0,939582 | 11,12 meses | — |
| 0,784525 | 0,784525 | 2,86 meses | — |
| 0,515998 | 0,515998 | 1,05 mês | — |

Em `h = 120`, o par quase unitário já responde por mais de 93,8% da soma das
contribuições modais em todas as variáveis; em `h = 240`, sua participação
supera 99,95%. A cauda correta é, portanto, uma senoide amortecida com envelope
`0,995386^h`, não uma exponencial real monotônica.

## Respostas por variável

“Convergência permanente” é o primeiro horizonte após o qual a resposta nunca
mais ultrapassa 1% do próprio pico absoluto. Ela foi procurada até `h = 1200`,
porque `h = 36` e até `h = 240` truncam o ciclo quase unitário.

| variável | impacto, escala da figura | razão `h1/h0` | razão mediana absoluta h24–60 | convergência permanente a 1% | leitura |
|---|---:|---:|---:|---:|---|
| IBC-Br | -0,6115% da média | 0,955 | 0,980 | h=578 | queda muito persistente; o par lento domina gradualmente |
| IPCA | -0,0154 p.p. ao mês | 0,245 | 0,904 | h=82 | projeção muito pequena no par lento; converge antes das demais |
| DI 6 meses | +50,0 pb | 0,929 | 1,034 | h=613 | cruza zero e reaparece por causa do ciclo amortecido |
| câmbio BRL/USD | +1,8838% da média | 0,925 | 0,993 | h=667 | resposta oscila; não permanece próxima de zero nos horizontes usuais |
| CDS 5 anos | +18,0670 pb | 0,919 | 0,943 | h=283 | queda inicial seguida de cauda oscilatória lenta |

Alguns pontos tornam o truncamento visível. O yield cai de 50 pb no impacto
para 1,10 pb em `h = 36`, mas chega a `-7,43` pb em `h = 82`, `+3,75` pb em
`h = 180` e ainda está em `+2,57` pb em `h = 240`. O câmbio passa de +1,88% no
impacto para -0,12% em `h = 36`, volta a +0,28% em `h = 120` e está em -0,15%
em `h = 240`. Interpretar apenas a figura até `h = 36` como convergência seria
incorreto.

## `1/h` contra dinâmica geométrica

Na janela `h = 0--36`, uma exponencial real simples tem erro normalizado menor
que `a/(h+1)` nas cinco respostas. O erro hiperbólico dividido pelo geométrico
é aproximadamente 23,9 no IBC-Br, 1,53 no IPCA, 10,2 no yield, 4,46 no câmbio
e 20,5 no CDS.

Esse resultado não autoriza uma extrapolação por `lambda^h` real. Entre
`h = 24--120`, a vantagem diminui porque a raiz dominante é complexa e as
respostas mudam de sinal. O teste formal mais informativo é a decomposição
exata:

\[
IRF_h = \sum_k d_k\lambda_k^h,
\]

com a cauda governada por

\[
0{,}995386^h\{a\cos(0{,}02509h)+b\sin(0{,}02509h)\}.
\]

Logo, o VAR em níveis continua sendo geométrico no sentido de potências da
companion, mas sua envoltória quase não decai dentro da amostra. Uma lei `1/h`
não descreve essa dinâmica.

## Comparação com o benchmark estacionário ativo

| diagnóstico | VAR estacionário ativo | VAR contrafactual em níveis |
|---|---:|---:|
| BIC seleciona | p=1 | p=1 |
| amostra comum do BIC | T=140 | T=141 |
| `xi_mp`/`xi_var` | 6,024922 | 5,849952 |
| maior módulo | 0,683593 | 0,995386 |
| meia-vida dominante | 1,82 mês | 149,9 meses |
| estacionariedade das entradas | satisfeita pela transformação declarada | falha em 4 de 5 séries |

A diferença de persistência não vem da ordem — ambas escolhem `p = 1`. Vem da
estimação em níveis de séries que carregam tendências estocásticas. Esse é o
resultado discriminante do exercício.

## Blindspot Report

**Output:** IRFs contrafactuais de um VAR observável em níveis; unidade de
variação: horizonte mensal, variável e modo próprio.
**Date:** 2026-08-22

### Vice 1: The Unexplained Feature

- **Object and unit of variation:** cinco IRFs de `h = 0` até `h = 1200`, com
  decomposição pelas cinco raízes da companion.
- **Hardest feature to explain, stated as a feature:** as respostas parecem
  próximas de zero em torno de `h = 36`, mas yield e câmbio reaparecem e mudam
  de sinal em horizontes posteriores.
- **Explanation attempted:** o par complexo de módulo 0,995386 produz um ciclo
  amortecido de 250,4 meses; `h = 36` cobre apenas 14% desse período.
- **Resolved?** yes — **DONE** como álgebra; **FLAG** para interpretação
  econômica, porque o período excede a amostra.
- **Findings:** a convergência visual de curto horizonte é efeito de fase e
  cancelamento, não desaparecimento permanente da resposta.

### Vice 2: The Convenient Absence

- **Missing checks identified:** uma figura restrita a `h <= 36` omite a
  reaparição das respostas; testes de raiz unitária precisam acompanhar todo
  resultado em nível.
- **Missing subgroups:** não foram estimados regimes ou subamostras, e não há
  comprimento amostral para observar sequer um ciclo do modo dominante.
- **Unexplained N changes:** nenhum. O BIC usa 141 observações comuns; o VAR(1)
  usa 152 resíduos, uma observação a mais que o benchmark diferenciado.
- **Findings:** a ausência decisiva é informação temporal suficiente para
  identificar com credibilidade um ciclo de 250 meses — **FLAG**.

### Virtue 1: The Unasked Question

- **Heterogeneity opportunities:** o IPCA converge em `h = 82` porque quase não
  carrega o modo lento, enquanto as outras respostas permanecem materialmente
  expostas por 283–667 meses.
- **Mechanism evidence:** como as duas especificações selecionam `p = 1`, a
  diferença entre raízes 0,684 e 0,995 isola o papel das transformações e das
  tendências estocásticas, não da ordem de defasagem.
- **Secondary findings:** o BIC de `p = 1` vence `p = 2` por apenas 0,0829.
- **Findings:** o contrafactual explica por que o benchmark estacionário retorna
  rapidamente a zero — **DONE**.

### Virtue 2: The Unexploited Strength

- **Undersold design features:** orientação, alinhamento do instrumento,
  normalização e identidade `C_hB_1` passam exatamente também no contrafactual.
- **Unused falsification tests:** estender a IRF até cobrir o período modal
  falsifica a leitura de “convergência em h=36”.
- **Positioning opportunities:** o contraste fornece uma demonstração interna
  de por que a decisão de estacionarizar o VAR pequeno é substantiva.
- **Findings:** o exercício negativo reforça a especificação ativa, sem
  convertê-lo em sensibilidade publicável — **DONE**.

### Ruling

[ ] CLEAR — proceed to interpretation. No vices found; virtues noted for consideration.
[ ] CONDITIONAL — proceed but acknowledge open questions explicitly. Vices flagged but manageable.
[x] HOLD — do not interpret or publish until flagged vices are resolved.

O veredito é **HOLD** para qualquer uso substantivo ou inferencial do VAR em
níveis. Seus números podem ser reportados apenas como contrafactual diagnóstico:
quatro séries falham nos testes de raiz unitária, a raiz dominante é quase
unitária e o ciclo inferido é mais longo que a amostra.
