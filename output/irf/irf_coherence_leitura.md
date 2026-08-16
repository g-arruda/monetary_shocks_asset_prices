# Coerência das IRFs

> **CURRENT em 2026-08-13.** Leitura autoral do painel de 111 séries em
> `(r,q,p)=(5,5,6)`. O corpo automático está em
> `irf_coherence_report.md`, e as fontes numéricas são
> `irf_coherence_h.csv` e `irf_coherence_summary.csv`.

## Resultado da régua

| classe | número de variáveis |
|---|---:|
| coerente forte | 18 |
| coerente | 8 |
| parcial | 2 |
| incoerente | 9 |
| ambígua | 14 |
| placebo aceito | 3 |
| canal *soft* | 4 |

A curva é o bloco com maior precisão no curto prazo. Todos os seis vértices,
incluindo a normalização de 6 meses, têm sinal positivo e banda de 90% acima
de zero no impacto. Na atividade, indústria de transformação, bens duráveis,
horas trabalhadas e IBC-Br caem com banda de 90%; PIB, serviços e duas séries
de trabalho não seguem a mesma trajetória, o que amplia o grupo incoerente.

No crédito, a expansão de curto prazo seguida por reversão leva cinco séries à
classe incoerente. O núcleo EX0 agora é parcial, não incoerente. As três séries
fiscais e as quatro de expectativas entram pela primeira vez na produção e são
tratadas como ambíguas, sem restrição de sinal imposta ex ante.

Os quatro canais *soft*, BRL/USD, BRL/EUR, EMBI+ e CDS, violam o sinal da
previsão convencional e excluem zero a 90% no impacto. Essa violação é o
resultado econômico do artigo, mas a régua não a usa para pontuar coerência
porque o sinal teórico depende do regime de prêmio de risco. Os três placebos
externos passam.

## Limite da leitura de médio prazo

O par complexo dominante da matriz *companion* tem módulo 0,964858. A
reconstrução espectral bate a IRF de produção com erro máximo de `9,66e-13`.
Ao retirar o par dominante e recolocar as trajetórias em escala comum, nenhum
dos 14 vales muda de sinal e 13 mantêm mais de metade da magnitude. Portanto,
ao contrário da produção anterior, a reversão não é explicada isoladamente
por esse par; ela continua sendo uma propriedade da dinâmica conjunta e não
uma confirmação independente de mecanismo econômico.

## Força e inferência

Na célula de produção, `xi_mp/F_rob,mp=6,27085/10,12054` na amostra completa e
`10,99268/9,74746` pré-COVID. As duas réguas dão evidência mista em sentidos
opostos. A janela pré-COVID tem raiz máxima 1,000202 e é marginalmente
instável. As bandas de 68% e 90% continuam sendo a inferência operacional do
projeto; 68% não é descrita como significância e nenhum resultado
Anderson--Rubin é operacional.
