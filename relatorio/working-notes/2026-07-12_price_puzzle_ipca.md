# O "price puzzle" do IPCA na IRF de produção: diagnóstico

> **⚠️ SUPERADA — banner de 2026-07-26.** Escrita sob `z_jk_purif` × (6,5), vintage pré-refresh.
> **A conclusão não se sustenta com os números atuais.** A nota fecha o diagnóstico afirmando que a
> corcova do IPCA "nunca é significativa a 90%"; na rodada (7,6) o headline é **sig90 em h5**, o
> núcleo ex0 é sig90 em h2 e h4-8 (e virou `incoerente`), e o DW é sig90 em h4-5 e h7.
> **Sobrevive como hipótese, não como resultado:** o argumento de que a corcova é amostral
> (composição 2021-22) depende da comparação cross-instrumento e do sumiço pre-COVID, que foram
> construídos no vintage antigo e **não reproduzem**. Re-rodar sob (7,6) é item aberto em
> `_instrucoes/pendencias.md`. Até lá o §5.5 não afirma que a corcova é amostral.


**Data:** 2026-07-12
**Pergunta:** na IRF de produção (`z_jk_purif` × `yield_6m` × r=6, q=5, full
sample, +50bp), o IPCA é positivo em h=0, cai levemente, volta a subir e só se
aproxima de zero por volta de h=12–20. Isso é algo visto empiricamente, ou é
erro de identificação?

**Resposta curta:** não é erro de identificação. É (i) uma corcova
estatisticamente indistinguível de zero, (ii) universal entre os 8 instrumentos
(inclusive os het, de origem completamente distinta), e (iii) exclusiva do
full sample — com a mesma identificação, a janela pre-COVID mostra desinflação
de sinal correto em todos os horizontes. O padrão é o *price puzzle*
transitório amplamente documentado na literatura, amplificado aqui pela
composição amostral 2021–22.

Nenhuma estimação nova foi rodada para este diagnóstico: toda a evidência já
estava em `output/irf/` (coerência ponto a ponto + varredura de especificações
+ células stage-2 bootstrapped).

---

## 1. O segmento positivo não é significativo

Fonte: `output/irf/irf_coherence_h.csv` (produção, wild bootstrap nboot=800,
seed 123). Unidades nativas do painel.

| h | ponto | CI68 | CI90 | sig? |
|---|---|---|---|---|
| 0 | +0.105 | [−0.094, +0.257] | [−0.242, +0.386] | não |
| 4 (pico) | +0.208 | [+0.072, +0.369] | [−0.009, +0.592] | CI68 apenas |
| 8 | +0.150 | [+0.020, +0.287] | [−0.046, +0.436] | CI68 apenas |
| 12 | +0.027 | [−0.079, +0.148] | [−0.150, +0.265] | não |
| 21 | −0.003 | cruza zero | — | não |
| 30 (mín.) | −0.043 | [−0.186, +0.017] | [−0.319, +0.083] | não |
| 48 | +0.051 | [−0.042, +0.133] | [−0.111, +0.240] | não |

- A **CI90 contém zero em todos os h = 0..48**. A CI68 só exclui zero em
  h=4–8.
- Estatisticamente, "o IPCA sobe" não é um fato deste modelo: é uma corcova
  que o bootstrap mal distingue de zero, seguida de desinflação leve
  (h=21–40) igualmente imprecisa. Veredito da régua de coerência: `parcial`
  (share 54%, primeiro h de sinal correto = 21), sem nenhum `wrong_sig90`.

## 2. A corcova é universal entre instrumentos — não é o z_jk_purif

Fonte: `output/irf/spec_sweep_irf_long.csv`, células (r=6, q=5) × yield_6m.
Resposta do IPCA em h=6 e h=24 (pontos; sem bootstrap no stage 1):

| instrumento | full h6 | full h24 | pre_covid h6 | pre_covid h24 |
|---|---|---|---|---|
| z_bruto | +0.099 | −0.005 | −0.146 | −0.197 |
| z_bruto_purif | +0.122 | −0.003 | −0.144 | −0.198 |
| z_jk | +0.148 | −0.020 | −0.172 | −0.145 |
| **z_jk_purif** | **+0.166** | **−0.020** | **−0.173** | **−0.152** |
| z_het | +0.159 | +0.002 | −0.122 | −0.120 |
| z_het_jk | +0.038 | −0.020 | −0.003 | −0.127 |
| z_het_3var | +0.179 | +0.155 | −0.135 | −0.206 |
| z_het_jk_3var | +0.074 | −0.004 | −0.088 | −0.130 |

Duas leituras decisivas:

- **Full sample: todos os 8 instrumentos produzem a corcova em h6** —
  inclusive os quatro het, identificados por heteroscedasticidade
  (Rigobon-Sack), que não compartilham nem o timing Copom nem o desenho GK/JK
  com o z_jk_purif. Um erro de identificação específico do instrumento não
  sobrevive a esse teste.
- **O filtro JK não reduz a corcova** (z_bruto h6 = +0.10 vs z_jk_purif
  h6 = +0.17). Se a corcova fosse contaminação por *information shocks*
  (Jarociński-Karadi 2020), o filtro de sinal deveria atenuá-la — não atenua.
  Essa hipótese fica descartada.

## 3. Com a MESMA identificação, o puzzle desaparece pre-COVID

Fonte: `output/irf/irf_spec_pre_covid_r6q5_z_jk_purif.rds` (stage 2,
bootstrap nboot=800). IPCA:

| h | ponto | CI68 | sig? |
|---|---|---|---|
| 0 | −0.090 | [−0.262, +0.114] | não |
| 6 | −0.173 | [−0.269, +0.023] | não |
| 9 (pico) | −0.208 | [−0.230, +0.033] | não |
| 12 | −0.162 | [−0.200, +0.061] | não |
| 24 | −0.152 | [−0.161, +0.052] | não |

- **Negativo em todos os horizontes** — desinflação de formato de livro-texto
  (gradual, pico em h≈9, persistente), embora não significativa (n=78 meses).
- Crucial: pre-COVID é a janela onde o instrumento é **mais forte**
  (F factor-space = 15.4 vs 10.1 no full). Se `H = Z'η/(Z'Z)` estivesse
  projetando o shock errado, o puzzle deveria aparecer justamente onde a
  identificação é melhor. Ocorre o oposto.

**Conclusão dos itens 2–3:** a corcova é um fenômeno da *amostra* (2020–25),
não do *método*. O mecanismo é conhecido: em 2021–22 a Selic subiu de 2% para
13,75% *enquanto* o IPCA acelerava por choques de oferta, commodities e
fiscal — comovimento positivo juros×inflação que o full sample carrega e que
nenhum dos 8 instrumentos consegue (nem deveria) apagar do reduced form.

## 4. Núcleos limpos desinflacionam mesmo no full sample

Fonte: `output/irf/irf_coherence_summary.csv` (produção, full):

| medida | share sinal correto (h12–48) | veredito |
|---|---|---|
| price_core_ipca_ex1 | 84% | coerente_forte (CI68 de h≈15) |
| price_ipca_difusao | 92% | coerente |
| price_inpc | 78% | parcial |
| price_ipca (headline) | 54% | parcial |
| price_core_ipca_dw | 49% | incoerente |
| price_core_ipca_ex0 | 0% | incoerente |

O canal de desinflação existe no full sample — aparece nas medidas menos
contaminadas por administrados/alimentos/energia (ex1, difusão). O headline é
a medida mais ruidosa do bloco.

## 5. Isso é visto empiricamente? Sim — extensamente

- **Sims (1992)** batizou o *price puzzle*: preços sobem após aperto monetário
  em VARs recursivos. É a anomalia mais documentada da literatura de VAR
  monetário.
- **Ramey (2016, Handbook of Macroeconomics)**: o CPI fica flat ou levemente
  positivo por 12–24 meses em quase todos os esquemas de identificação
  modernos — *inclusive* Gertler-Karadi (2015) com instrumento externo
  high-frequency. Resposta negativa significativa de preços é a exceção, não
  a regra, mesmo nos papers de referência.
- **Brasil**: Minella (2003) e Céspedes, Lima & Maka (2008) reportam price
  puzzle em VARs pós-Real; é um resultado recorrente na literatura doméstica.
- **Alessi-Kerssenfischer (2019)**: o argumento do paper-base é que info sets
  grandes (DFM) *atenuam* puzzles de omissão de informação. Aqui o padrão é
  consistente: a corcova é n.s. (atenuada) e desaparece na janela sem o
  confundidor COVID.

Um headline que só cruza zero perto de h≈20, com bandas largas, está dentro
da norma empírica para modelos bem identificados.

## 6. Framing recomendado para o paper (§5)

1. Reportar o IPCA headline com a leitura honesta: corcova transitória
   **não significativa** (CI90 sempre contém zero), desinflação de sinal
   correto de h≈21 em diante; citar o price puzzle (Sims 1992; Ramey 2016)
   e a composição amostral 2021–22.
2. Robustez central: **pre-COVID (6,5) o IPCA é negativo em todos os
   horizontes com a mesma identificação** — o puzzle é amostral, não
   estrutural.
3. Usar **ex1 como medida de preço primária** (coerente_forte no full
   sample), com difusão como corroboração; reportar ex0/dw com a leitura da
   nota de coerência.
4. Não tratar como falha de identificação: a evidência cross-instrumento ×
   cross-janela descarta contaminação por info shocks e erro de projeção.

## Arquivos-fonte

- `output/irf/irf_coherence_h.csv`, `irf_coherence_summary.csv` (produção)
- `output/irf/spec_sweep_irf_long.csv`, `spec_sweep_cells.csv` (grade 320)
- `output/irf/irf_spec_pre_covid_r6q5_z_jk_purif.rds` (stage 2 bootstrapped)
