# Composição h-a-h da IRF: blocos de crédito e ativos financeiros

> **⚠️ SUPERADA — banner de 2026-07-26.** Escrita sob `z_jk_purif` × (6,5), vintage pré-refresh e
> **antes da correção de tcode dos índices B3** (`asset_*` eram tratados como nível, não retorno).
> **Sobrevive:** o mapeamento de literatura (BG95/GG94 para crédito, Bonomo-Martins para
> direcionado) e o diagnóstico de que a janela de scoring dos spreads ICC estava errada, não o prior.
> **Morreu:** todas as magnitudes. O impacto de −8,9% no Ibov que a nota interpreta longamente é
> nulo duas vezes (novo primário + correção de tcode: hoje −1,67%, sem significância a 90%), e a
> expansão inicial do crédito **agregado** não se confirma em (7,6) — é fenômeno setorial.
> Números correntes: `output/irf/irf_section.md` §5.2 e §5.4.


**Data:** 2026-07-12
**Especificação:** `z_jk_purif` × `yield_6m`, r=6, q=5, p=6, full sample,
choque +50bp, wild bootstrap nboot=800 (seed 123), bandas 68/90, h=0..48.
**Fontes:** `output/irf/irf_coherence_{h,summary}.csv` (re-rodado hoje com as
5 variáveis de crédito setorial adicionadas; seed reproduz as 47 anteriores —
spot-check `price_ipca` h4 = +0.2077 e `asset_ibov` h0 = −0.0893 idênticos).
O objeto da estimação agora fica salvo em `output/irf/irf_coherence_cell.rds`.

**Pergunta:** as respostas de crédito e de ativos financeiros fazem sentido
econômico, ponto a ponto no horizonte? Têm suporte na literatura?

**Resposta curta:** sim, com mais suporte do que os vereditos automáticos
sugerem. Os quatro padrões centrais — (i) expansão breve e significativa do
crédito PJ antes da contração defasada, (ii) compressão inicial dos spreads
seguida de abertura significativa em h19-30, (iii) amplificação do repasse ao
longo da curva de juros, e (iv) queda de ações concentrada no impacto — são
todos previstos ou documentados na literatura de canal de crédito e de
transmissão monetária. As duas anomalias reais são de *magnitude* (ações) e
de *janela de avaliação* (spreads), não de sinal ou mecanismo.

---

## 1. Curva de juros (yield_3m … yield_10y, juros_cdi/selic)

Trajetória (pontos, proporção decimal; +0.005 = +50bp):

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | sig |
|---|---|---|---|---|---|---|---|---|
| yield_3m | +0.0027 | +0.0031 | +0.0020 | +0.0001 | −0.0013 | −0.0055 | −0.0065 | CI90 h0-1 |
| yield_6m | +0.0050 | (mecânica: normalização) | | | | | | |
| yield_1y | +0.0077 | +0.0080 | +0.0062 | +0.0014 | −0.0019 | −0.0065 | −0.0061 | CI90 h0-3 |
| yield_2y | +0.0105 | +0.0102 | +0.0081 | +0.0021 | −0.0021 | −0.0062 | −0.0049 | CI90 h0-3 |
| yield_5y | +0.0122 | +0.0110 | +0.0088 | +0.0025 | −0.0022 | −0.0052 | −0.0033 | CI90 h0-7 |
| yield_10y | +0.0112 | +0.0100 | +0.0081 | +0.0024 | −0.0021 | −0.0045 | −0.0027 | CI90 h0-7 |
| juros_cdi | +0.0002 | +0.0001 | −0.0004 | −0.0006 | −0.0011 | −0.0044 | −0.0059 | nunca |
| juros_selic | +0.0002 | +0.0001 | −0.0004 | −0.0006 | −0.0011 | −0.0044 | −0.0059 | nunca |

**Leitura h-a-h.** O repasse no impacto é *crescente com a maturidade*:
+27bp (3m) < +50bp (6m) < +77bp (1y) < +105bp (2y) < +122bp (5y), com leve
recuo em 10y (+112bp). O trecho longo mantém CI90 até h7. A curva inteira
decai monotonicamente, cruza zero em h≈13-18 e fica levemente negativa
(CI68 no trecho longo em h35-38) — o ciclo de flexibilização subsequente.

**Faz sentido? Com uma qualificação importante.** Nos EUA o padrão canônico é
o oposto: Kuttner (2001) e Gürkaynak-Sack-Swanson (2005) encontram repasse
*decrescente* com a maturidade (expectativas ancoradas: o longo mal se move).
Aqui o longo amplifica. Isso não é defeito — é o assinatura de prêmio de
risco em economia emergente com fragilidade fiscal: o mesmo choque que sobe
a Selic esperada abre EMBI (+46bp) e CDS (+56bp) com CI90 em h0-h7 (ver §4),
e o prêmio de risco carrega o trecho longo da curva. É o mecanismo de
Blanchard (2004) para o Brasil de 2002-03 e a leitura de dominância fiscal
do benchmark GRG (2025) já adotada no projeto. A consistência *interna* é
forte: amplificação da curva longa, depreciação cambial e abertura de risco
soberano são três faces do mesmo canal, e as três têm CI90 no impacto.
O recuo 5y→10y também é coerente: no muito longo prazo pesa a expectativa de
normalização.

**CDI/Selic** (+2bp, nunca significativos): atenuação ~25× já documentada
(`justificativa_uso_yield-6m.md`) — o overnight médio-mensal não capta a
surpresa de 6m dentro do mês do choque. Limitação de medida, não de
identificação; os vereditos `incoerente` desses dois são artefato conhecido.

## 2. Ações (8 índices)

| var | h0 | h1 | h3 | h6 | h12 | h24 | sig do impacto |
|---|---|---|---|---|---|---|---|
| asset_ibov | −8.9% | (sig68 h0-1) | +1.0% | −0.2% | +1.0% | +0.8% | CI90 h0 |
| asset_smll | −10.4% | (sig68 h0-1) | −0.2% | −1.0% | +0.6% | +0.6% | CI90 h0-1 |
| asset_idiv | −9.0% | (sig68 h0-1) | +0.3% | −0.7% | +0.8% | +1.5% | CI90 h0-1 |
| asset_imob | −10.9% | (sig68 h0-1) | +0.6% | −0.4% | +0.9% | +0.5% | CI90 h0 |
| asset_ifix | −3.8% | (sig68 h0-1) | −0.9% | −0.8% | −0.2% | −0.4% | CI90 h0-1 |
| asset_mlcx | −8.8% | (sig68 h0-1) | +0.8% | −0.3% | +0.9% | +0.6% | CI90 h0 |
| asset_ifnc | −11.2% | (sig68 h0-1) | +0.4% | −0.8% | +1.0% | +1.7% | CI90 h0-1 |
| asset_imat | −4.7% | (sig90 h0) | +2.5% | +1.2% | +1.2% | +0.2% | CI90 h0; **CI68 + em h2-9** |

(valores em log-pontos ≈ %; tcode 1 — painel já em log)

**Leitura h-a-h.** Todo o bloco cai no impacto com significância (CI90 em
6 de 8; CI68 nos demais), permanece negativo com CI68 em h1, e reverte a ≈0
de h2 em diante, **sem nenhum horizonte positivo significativo** (exceto
imat, ver abaixo). É repricing imediato e completo — exatamente o que a
hipótese de mercados eficientes prevê para um ativo forward-looking: o preço
salta para o novo nível no mês do choque e daí segue passeio aleatório. O
veredito `incoerente` de ibov/imob/mlcx é artefato da régua de share na
janela h0-h6 (exige sinal negativo persistente que teoria nenhuma prevê para
*nível* de preço de ação); a previsão econômica nítida — queda significativa
no impacto — é atendida por todos.

**Suporte na literatura — sinal e timing: sim; magnitude: borda superior.**
Bernanke-Kuttner (2005): +25bp de surpresa → S&P −1%; Gürkaynak-Sack-Swanson
(2005) atribuem a maior parte ao fator *path*. Aqui: −9% no Ibovespa por
+50bp normalizado no vértice de 6m. Três atenuantes antes de ler como
excesso: (i) o choque é um deslocamento *persistente* da política (surpresa
de 6m ≈ fator path, não o target de 1 dia de BK) — GSS mostram que o path
move ações muito mais que o target; (ii) a resposta é mensal e de equilíbrio
geral (inclui o câmbio +5% e o risco soberano +50bp, que amplificam o
desconto), não janela de 1 dia de event study; (iii) beta de EM. Ainda
assim, −9% por 50bp está acima dos event studies brasileiros de dia de
Copom (ordem de 1-2% por 100bp de surpresa). Registrar no §5 como magnitude
de borda superior com essa decomposição — não como violação.

**Cortes transversais informativos (todos coerentes com teoria):**
- **ifnc (bancos) tem a maior queda (−11.2%)** e reversão com ponto positivo
  em h24 (+1.7%, n.s.): English-Van den Heuvel-Zakrajšek (2018) documentam
  queda de ações de bancos em surpresas de alta (perda de duration domina no
  impacto) com recomposição posterior via margem de juros. Mesmo formato.
- **imat (exportadoras) é o único índice que sobe com significância (CI68,
  h2-h9)** após a queda de impacto: a depreciação de +5% do BRL (canal de
  dominância fiscal) melhora receita em moeda local de exportadoras. A
  classificação `ambiguous` estava certa, e o dado resolve a ambiguidade na
  direção do canal cambial.
- **ifix (imobiliário de renda) cai menos (−3.8%) e é o único que nunca
  cruza zero** (negativo em todo h=0..48, CI90 h0-1): ativo de duration com
  aluguéis contratados — reprecifica como renda fixa longa, devagar e
  persistente. Único `coerente_forte` do bloco, e com razão.
- **smll (small caps, −10.4%) > mlcx (large caps, −8.8%)**: small caps mais
  sensíveis a condições financeiras (Gertler-Gilchrist 1994, análogo
  acionário). Diferença pequena mas na direção certa.

## 3. Crédito (estoques e spreads)

Estoques (log-pontos ×100 ≈ %; tcode 4 — resposta em nível acumulado):

| var | h0 | h3 | h6 | h12 | h24 | h36 | h48 | trough (h) | sig |
|---|---|---|---|---|---|---|---|---|---|
| credit_outstanding | +0.43 | +0.43 | +0.37 | −0.08 | −0.63 | −0.87 | −0.73 | −0.88 (38) | CI90 + h0-2 |
| credito_pessoa_fisica | +0.01 | +0.00 | −0.01 | −0.15 | −0.29 | −0.63 | −0.70 | −0.73 (43) | nunca |
| credito_comercio | +0.48 | +0.78 | +0.80 | −0.23 | −1.62 | −1.57 | −0.94 | −1.72 (29) | CI90 + h1 |
| credito_transporte | +1.97 | +2.04 | +1.80 | +0.22 | −1.48 | −1.61 | −0.84 | pico +2.37 (1) | CI90 + h0-6 |
| credito_industria_total | +0.88 | +1.18 | +1.03 | +0.07 | −1.19 | −1.21 | −0.72 | −1.30 (30) | CI90 + h0-4 |
| credito_agro | +0.89 | +1.23 | +1.16 | −0.07 | −1.47 | −1.63 | −1.01 | −1.69 (32) | CI90 + h0-3 |
| credito_construcao | +0.02 | +0.47 | +0.43 | −0.28 | −1.45 | −1.80 | −1.57 | −1.82 (39) | CI68 + h1 apenas |

**Leitura h-a-h.** O padrão dominante em TODOS os estoques PJ: **expansão
significativa (CI90) em h0-h6, cruzamento de zero em h≈10-14, contração com
vale em h≈29-43** (−0.7 a −1.8%), esta última sem significância (as bandas
alargam no horizonte longo). Pessoa física é a exceção: nenhuma alta
inicial, declínio lento e monotônico.

**Isso é o resultado com MELHOR suporte de literatura da nota.** A expansão
inicial do crédito PJ após aperto monetário é um fato estilizado clássico:
Bernanke-Gertler (1995, JEP) documentam que o crédito total *sobe* nos
primeiros trimestres após um aperto; Gertler-Gilchrist (1994, QJE) mostram
que a dívida de curto prazo de firmas (sobretudo grandes) *cresce* — firmas
sacam linhas de crédito pré-aprovadas para financiar capital de giro e
estoques involuntários quando o fluxo de caixa aperta. A contração vem
depois, quando linhas vencem e bancos reprecificam — a defasagem de 1-2 anos
até o vale (aqui h≈30) é exatamente a cronologia de BG95. E o corte
transversal confirma o mecanismo: **pessoa física — que não tem linha de
capital de giro para sacar — não exibe a alta inicial** e cai desde h6.
O veredito `incoerente` do credito_transporte (alta CI90 invade a janela
h6-36 da régua) e os `parcial` são, de novo, régua — a janela deveria
começar em h≈12 para estoques PJ; a economia está certa.

**Crédito direcionado (agro, construção) — prior Bonomo-Martins (2016)
parcialmente confirmado, com nuance.** A previsão era transmissão atenuada
em setores dominados por crédito direcionado. **Construção confirma
integralmente**: é o estoque *mais lento* (cruza zero só em h10, vale mais
tardio do bloco em h39) e o *único sem expansão inicial significativa nem
contração significativa* — funding SFH/poupança a taxas reguladas isola o
setor do ciclo da Selic. **Agro não confirma**: responde como os setores de
crédito livre (alta CI90 h0-h3, vale −1.7 em h32). Plausível: o custo do
crédito rural equalizado ainda referencia a Selic via equalização do Plano
Safra, e a fração livre do funding agro cresceu na amostra 2013-25. Nuance
que vale nota de rodapé no §5, não reprovação do prior.

**Spreads ICC — o achado da sessão anterior fica mais interessante:**

| var | h0 | h3 | h6 | h12 | h19-h30 | pico | sig |
|---|---|---|---|---|---|---|---|
| spread_icc_juridica | −0.03 | −0.07 | −0.07 | −0.005 | positivo | +0.08 (h25) | **CI90 − h0-4; CI68 + h19-30** |
| spread_icc_fisica | +0.000 | −0.04* | −0.03 | +0.02 | positivo | +0.13 (h25) | CI68 − h2-7; **CI68 + h19-29** |

(*fisica: compressão em h2-h7 com CI68)

**Leitura h-a-h revisada.** A régua (janela h0-12, sinal +) via só a
compressão inicial e reprovava. O caminho completo conta outra história em
duas fases: (1) **compressão significativa em h0-h7** — o custo de captação
(CDI) sobe instantaneamente enquanto a taxa média da *carteira* (ICC é
estoque, não concessão) reprecifica devagar → o spread medido comprime
mecanicamente; (2) **abertura com CI68 em h19-h30, pico em h25** — quando a
carteira já reprecificou e a inadimplência do ciclo aperta, o prêmio de
risco domina. A fase 2 é o financial accelerator de Bernanke-Gertler (1995)
e a resposta positiva e defasada de spreads de Gilchrist-Zakrajšek (2012) /
Gertler-Karadi (2015, excess bond premium). **O prior não estava errado; a
janela estava.** A pendência do ICC pode ser fechada com essa leitura — o
teste com spread de concessões novas continua desejável (deve mostrar
abertura já no curto prazo), mas deixa de ser bloqueante.

## 4. Risco soberano (complemento do bloco financeiro)

| var | h0 | h3 | h6 | h12 | h24 | h31-37 | sig |
|---|---|---|---|---|---|---|---|
| embi_perc | +0.46pp | +0.35 | +0.30 | +0.08 | −0.14 | negativo | CI90 + h0-7; CI68 − h33-36 |
| cds_5y | +56bp | +47 | +38 | +12 | −13 | negativo | CI90 + h0-7; CI68 − h31-37 |

(cds_5y em escala de painel ×100: 5604 = 56bp)

**Leitura.** Abertura forte e significativa no impacto (canal de dominância
fiscal — aperto piora a dinâmica da dívida no curto prazo: Blanchard 2004;
GRG 2025), decaimento monotônico, e **fechamento abaixo do baseline com
CI68 em h≈31-37** — quando a desinflação e o ciclo de flexibilização
melhoram o prêmio. A reversão significativa do médio prazo é um detalhe novo
(a checagem anterior só olhava o impacto) e é internamente consistente com a
curva de juros ficando negativa com CI68 nos mesmos horizontes (h35-38).

## 5. Balanço: o que entra no §5 do paper

1. **Sólido com literatura:** expansão-então-contração do crédito PJ
   (BG95/GG94) com PF sem alta inicial; spreads em duas fases com
   accelerator defasado (GZ12/GK15); repricing de impacto em ações com
   cortes transversais coerentes (ifnc/English et al; imat/canal cambial;
   ifix/duration; smll>mlcx); amplificação da curva longa + risco soberano +
   câmbio como faces do prêmio fiscal (Blanchard 2004, GRG 2025).
2. **Reportar com qualificação:** magnitude do impacto acionário (−9% Ibov
   por +50bp) — borda superior; decompor via path-shock + GE mensal + EM.
3. **Limitação de medida (não reprovar):** CDI/Selic atenuados; vereditos
   `incoerente` de ações e transporte são artefato de janela da régua.
4. **Direcionado:** construção confirma Bonomo-Martins; agro não — rodapé.

## Regua vs economia — ajustes sugeridos (não aplicados)

Se a tabela de coerência for refinada no futuro: janela de estoques PJ
h12-36 (não h6-36); spreads ICC janela h12-36 (não h0-12); ações avaliadas
só em h0-h1. Não aplicado agora para não reescrever a régua depois de ver o
resultado — os vereditos automáticos ficam como estão e a leitura econômica
vive nesta nota e no adendo do report.

## Arquivos

- `output/irf/irf_coherence_{h,summary}.csv` (52 vars, re-run 2026-07-12)
- `output/irf/irf_coherence_cell.rds` (novo — objeto da estimação salvo)
- `output/irf/irf_coherence_report.md` (adendo 2026-07-12b)
- `output/irf/irf_coherence_plots.pdf` (inclui página credito_setorial)
