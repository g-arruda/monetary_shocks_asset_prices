# Índice das notas

**Revisado em 2026-09-02.** A nota de produção DFM corrente é
[`2026-09-02_producao_inicio_2012_03`](2026-09-02_producao_inicio_2012_03.md);
a rodada mais recente do benchmark é
[`2026-08-22_var_niveis_aic_tendencia`](2026-08-22_var_niveis_aic_tendencia.md).
Notas anteriores preservam decisões e diagnósticos que não dependem do painel,
mas seus números do DFM não devem ser citados sem reestimação.

**Diagnóstico por heterocedasticidade reestimado:**
[`2026-09-01_heterocedasticidade_frequencia`](2026-09-01_heterocedasticidade_frequencia.md)
registra a orientação do professor, a comparação diária/mensal e a grade
mensal corrente de 115 séries. A condição de posto não é satisfeita na
frequência mensal; a rota permanece fora da produção.

**Produção corrente (desde 2026-09-26):** proxy-SVAR com `z_bs_purif` × `yield_6m`, sem o filtro
JK, conjuntos AR de 80/90%, painel de 115 séries
`drop_setor_externo__eua__credito__imoveis_fiscal_expectations`, 2012-03--2025-12,
`(r,q,p)=(5,5,4)` sob a escala COVID de Lenza-Primiceri, `xi_mp=7,018990` full / `6,836682`
pré-COVID. A construção veio da branch `feature/bs-copom-surpresas-macro`, promovida para `main`
no mesmo dia; ver `2026-09-26_producao_bs_purif_bandas_80_90` e
`2026-09-26_migracao_paper_bs_purif`. Bai--Ng BLL seleciona IC1=5, IC2=5 e IC3=20; `q=r=5` e `p=4`
é herdado da vintage anterior. Ver `registro/pendencias.md`
(o que está aberto) e `registro/historico_decisoes.md` (o que já foi tentado).

**Seleção de `r` por estimadores alternativos (2026-09-10):**
[`2026-09-10_selecao_fatores_ah_abc`](2026-09-10_selecao_fatores_ah_abc.md)
roda Ahn-Horenstein (ER/GR) e Alessi-Barigozzi-Capasso na mesma base BLL da
superfície Bai--Ng de produção. ER = GR = 2 e ABC-IC*₁ = 9, com pouca
estabilidade; o veredito pré-registrado é misto. Audita o pacote
`factorselect`, que diverge dos papers no GR e no ABC. Não altera a produção.

**Poda do painel por correlação (2026-09-10):**
[`2026-09-10_poda_correlacao_painel`](2026-09-10_poda_correlacao_painel.md)
poda o painel de produção por ligação completa em |ρ| ≥ 0,90 nas primeiras
diferenças e refaz Bai--Ng, AH, ABC e Amengual--Watson. Saem 9 das 115 séries.
Bai--Ng IC2 cai de 5 para 3 e o `q` fica em 2. Pelos vereditos pré-registrados,
a divergência *aumenta* e a hipótese de subestimação sai *contrária*. Não
altera a produção, e o painel podado não tem ξ_mp nem IRF.

**Truncamento `q < r` (2026-09-10):**
[`2026-09-10_truncamento_q`](2026-09-10_truncamento_q.md)
testa se o truncamento `q < r` em `r = 5` descarta o choque monetário. Na
pré-COVID, a invariância de Alessi-Kerssenfischer se reproduz: 115 das 115
séries saem imateriais em `q` = 3 e 4, com bandas AR em `p = 2`. Na amostra
cheia, nenhuma sai, e o instrumento está nas direções descartadas (p = 0,051,
0,039 e 0,015). As regras foram escritas depois de uma passada exploratória.
Não altera a produção.

**Volatilidade COVID de Lenza-Primiceri (2026-09-14):**
[`2026-09-14_volatilidade_covid_lenza_primiceri`](2026-09-14_volatilidade_covid_lenza_primiceri.md)
implementa, sem estimar, a escala de volatilidade comum de Lenza-Primiceri
(2022, Apêndice B) no VAR dos fatores. O tratamento vem desligado por padrão,
e assim o objeto de produção sai `identical()` ao de `main`. Ligado, só o ponto
roda: AR, ξ_mp, bootstrap e Kilian abortam. A nota registra as decisões fora do
artigo e as de parametrização, todas pendentes com o autor. Não altera a
produção.

**Volatilidade COVID: decisões e θ por máxima verossimilhança (2026-09-14):**
[`2026-09-14_estimacao_theta_volatilidade_covid`](2026-09-14_estimacao_theta_volatilidade_covid.md)
registra as decisões do autor:
- `t*` = 2020-03;
- s̄ ≥ 1 e ρ ∈ [0,1];
- inovações padronizadas;
- sem centragem sob WLS, fiel ao Γ de MOSW.

Sem o piso s̄ ≥ 1, a verossimilhança é ilimitada. θ̂ = (6,61; 12,47; 1,76; 0,944): a
volatilidade excedente tem meia-vida de 12 meses, e cerca de 19 meses-equivalentes perdem
peso. O perfil em ρ tem um segundo máximo em ρ = 0, 2,6 log-pontos abaixo. Nenhuma IRF
tratada foi calculada, e a produção não muda.

**Volatilidade COVID: inferência e sensibilidade a `q` na cheia ajustada (2026-09-14):**
[`2026-09-14_inferencia_volatilidade_covid_q`](2026-09-14_inferencia_volatilidade_covid_q.md)
deriva os conjuntos AR e o ξ_mp sob o tratamento. Com inovações padronizadas, o
WLS é o OLS da regressão transformada, e a covariância de MOSW vale nela sem
mudança, com θ̂ tratado como conhecido. Refaz T1 e T2 do truncamento `q < r`
na cheia tratada (passo 3/4) e a tabela `q = 2,…,5` das 20 variáveis da
narrativa (passo 4/4). Não há veredito: o autor lê as IRFs a olho. A produção
não muda.
**A escala de volatilidade COVID entra em produção (2026-09-17):**
[`2026-09-17_volatilidade_covid_producao`](2026-09-17_volatilidade_covid_producao.md)
liga o tratamento de Lenza-Primiceri no VAR dos fatores e o descreve na §3.1 do
paper. ξ_mp sobe de 6,057014 para 6,847997 na cheia, F_rob de 9,625428 para
11,765250, e todos os conjuntos da §5 seguem `interval` a 68/90%. A pré-COVID
**não muda**, porque nela `s_t = 1` em todo mês — os contrastes entre janelas
seguem contrastes de janela, não de estimador. Sob a escala, `r >= 7` é
explosivo na cheia. Supersede o "sem veredito" de 09-14.

**A §3 do paper reorganizada e migrada (2026-09-17):**
[`2026-09-17_reorganizacao_secao_3`](2026-09-17_reorganizacao_secao_3.md)
troca as seis subseções da metodologia por quatro, na ordem modelo e estimação,
dados, identificação e instrumento, relevância e inferência, e migra a §3 inteira
para a produção corrente: 2012-03 a 2025-12, 166 observações, 162 inovações,
102 reuniões, `R²` de Bauer-Swanson 0,022, `tab:first_stage` refeita. Fecha
**só na §3** as duas lacunas contra a produção, a de janela e a de inferência.
Escreve a verossimilhança concentrada que estima θ, que faltava, e corta três
blocos de prosa defensiva por decisão do autor. Rodada editorial: nada foi
reestimado.

**A condição de identificação por heterocedasticidade reduzida ao teste do `svars` (2026-09-22):**
[`2026-09-22_condicao_het_svars`](2026-09-22_condicao_het_svars.md)
**CURRENT.** A bateria de cinco estatísticas do projeto foi **retirada** e substituída pelo
teste do pacote `svars`, e os dois sistemas passaram a usar **as séries de GRG**: DI, câmbio
BRL/USD e CDS soberano de 5 anos. ⚠ O que o projeto chamava de "linha diária publicada"
(DI 3m, DI 2a, Ibovespa, câmbio) **não era o conjunto deles** — GRG não usam Ibovespa nem o
vértice de 2 anos. A quarta série deles, expectativa de inflação, é *breakeven* de títulos,
que o projeto não tem (só Focus, survey, com 23% de variações diárias exatamente zero); a
lacuna fica declarada. Rigobon (2003) enuncia **uma** condição, a de posto, que falha se e
somente se as covariâncias forem proporcionais; testada pelo `Qr` sequencial de Lütkepohl
et al. (2021). **As mesmas três séries identificam no diário e não no mensal**: diário
rejeita no vértice de 3 meses (`Qr` 11,43, p 0,0033, λ₁ 7,55 contra 1,36), e o VAR mensal
não rejeita em nenhum vértice (p 0,917 a 0,988), com λ₁ ≈ λ₂ e determinante de eq. (6)
caindo de 40,8 para −0,03 — proporcionalidade. ⚠ **As duas diferenças entre as linhas — a
frequência e a troca da janela de anúncio pela variação de calendário — não estão
separadas**, e nenhuma afirmação pode atribuir a queda a uma delas: o objeto que somava as
janelas Qua→Qui dentro do mês foi **retirado por decisão do autor** no fim da rodada, e a
única agregação mensal é a do painel, a última cotação do mês de referência. Inovações
fatoriais, p 0,0761. ⚠ **O vértice decide no diário** (0,0033 / 0,0844 / 0,1474, acompanhando
a queda da razão de variância do DI com a maturidade em GRG) e ⚠ **a correção de curtose
também** (÷4,9; sem ela as três células diárias rejeitariam). ⚠ `svars::id.cv()` **não pode
ser chamado direto** — seu ramo de indicador recorrente está quebrado e colapsa para `Λ = I`
em silêncio. Nas IRFs em quarentena, a célula identificada **fecha** o CDS 4,2 p.b. e
**aprecia** o real 1,53% — o sinal de GRG nas duas séries; o VAR mensal não identifica e seu
ponto não é interpretável. **A afirmação de que a agregação temporal vira o sinal foi
revertida do registro, e a afirmação oposta — de que ela não é o obstáculo — saiu junto com
a linha somada que a sustentava.** §5.1, `tab:het_frequency`, resumo PT/EN, introdução, §2 e
conclusão reescritos.
A rota het segue **abandonada** para o artigo.


**Auditoria do estimador `svars` e atenuação mensal (2026-09-22):**
[`2026-09-22_auditoria_het_cv`](2026-09-22_auditoria_het_cv.md)
confere `fit_het_cv()` contra o próprio `svars::id.cv()` num caso com quebra
contígua, padronizado: `Λ`, a tabela `Qr` e `BB'` idênticos, e o colapso do
`id.cv()` nas unidades cruas fixado como o motivo da padronização. Entra a 7ª
trava, `script/validation/validate_het_cv.R`, cuja identidade
`Qr_nk/fator = Qr` a `8,9e-15` prova que o `qr_without_kurtosis()` carrega a
curtose do pacote (convenção `TB`): κ e fator de curtose mudam na 3ª casa
(12,6735/2,2525 → 12,6435/2,2949; 4,8459 → 4,8773), `Qr` e `p` não. O
diagnóstico de quarentena `het_rigobon/03_atenuacao.R` mede a diluição temporal
prevista contra a razão mensal observada (DI 3m 1,220 contra 1,381; DI 12m 1,080
contra 2,686; CDS 0,997 contra 2,274): a diluição sozinha preveria razões
próximas de 1 e o observado excede em todas as séries, mas **nada atribui a queda
da condição à agregação temporal nem à variação de calendário**. Declara ainda
os testes conjuntos da linha fatorial — `λ₁=…=λ₄` p 0,0208 e `λ₁=…=λ₅` p 0,0127
rejeitam a 5%, contra `λ₁=λ₂` p 0,0761, que é o par que decide a coluna — e a
distinção de estimadores: a réplica da Tabela 5 de GRG é o `01_daily_grg.R`
(diferença de covariâncias = IV), não o `fit_het_cv()`. Nada reestimado na
produção; os cinco impactos do smoke test saíram bit-idênticos.

**Placebos na §5.2 e o teste do EPU na base de 111 (2026-10-22, branch `feature/auditoria-janelas-copom`):**
[`2026-10-22_placebos_secao_5`](2026-10-22_placebos_secao_5.md)
**CURRENT na branch, não mergeada.** Dois itens do passo 3. O instrumento e as IRFs não mudam.
- **§5.2 Placebos.** Subseção nova, entre o VAR e a influência. O parágrafo da §3.3 saiu. Holm não rejeita
  nada. Sem ajuste, o MSCI de emergentes cai e é significante em h0, h1, h3 e h6, como limitação, e o VIX
  em h6. O EPU não é significante em horizonte nenhum.
- **EPU na regressão BS.** O p = 0,54 era das 102 reuniões e foi reproduzido. Nas 111: −0,051 (EP 0,047),
  p 0,275.
- **VIX em h0.** Em média, 46% dos dias do mês do impacto caem na janela de `pre_vix`.
- **Anexo D.** `tab:placebos_holm` com p e p de Holm. A `fig:placebos` fica sem marcadores e com conjuntos
  descritos como pontuais.

**CDS estreito contra ampliado, influência, extremos e surpresa bruta no texto (2026-10-22, branch `feature/auditoria-janelas-copom`):**
[`2026-10-22_cds_janelas_influencia_extremos`](2026-10-22_cds_janelas_influencia_extremos.md)
**CURRENT na branch, não mergeada; nada reestimado.** Dois itens do passo 3.
- **Anexo F.** O parágrafo do CDS ganha a comparação estreita × ampliada, Wald de 90% por +50 p.b. de
  surpresa: −0,8 contra +7,7, significante a 90% nas 111 e não na de 104. Ganha também os 156 feriados dos
  EUA com cotação e a limitação de 28/11/2013.
- **§5.** Duas subseções. A 5.2 tem a `tab:influencia` e a prosa por sinal e significância: sem as 10,
  inconclusivo; sem as 5 e sem os 14 extremos, o câmbio perde os 90% no impacto; o CDS fica estável. As três
  exclusões que mais baixam o câmbio são do Brent.
- **Anexo E.** Uma frase diz que a surpresa bruta no DFM é significante a 90% e não a 95%.
- ⚠ O e-mail de 12-10 diz "não significantes a 90%" para a bruta, e os dados dizem 95%.

**Os 22 marcadores `[conferir]` e a leitura da trajetória diária (2026-10-22, branch `feature/auditoria-janelas-copom`):**
[`2026-10-22_conferir_e_trajetoria_diaria`](2026-10-22_conferir_e_trajetoria_diaria.md)
**CURRENT na branch, não mergeada; nada reestimado.** O passo 2 e o item da trajetória diária do passo 3.
- **Marcadores.** As 22 frases reescritas no lugar, sem marcador: o IPCA do DFM sobe no impacto e fica
  positivo até h7, os sinais do VAR coincidem em 4 de 5, a ortogonalização reduz ξ_mp e F_rob, e a
  conclusão fica só com o câmbio significante a 90% de h0 a h6.
- **Trajetória diária.** Leitura sem números num parágrafo novo no fim do Anexo E, e uma frase na §4.2 com
  a leitura do item 5 do e-mail de 19-10 e o ponteiro para a `fig:ponte` e a `tab:ponte`.
- ⚠ `\autoref` e as legendas imprimem "Figure/Table": os `\renewcommand` de `bd3a52c` ficaram em
  `paper_anpec.tex`.

**Os números do artigo na base de 111 e a amostra do instrumento na §3.3 e na §3.4 (2026-10-21, branch `feature/auditoria-janelas-copom`):**
[`2026-10-21_artigo_base_111`](2026-10-21_artigo_base_111.md)
**CURRENT na branch, não mergeada; a produção não muda.** Os dois itens do passo 2.
- **§3.3 e §3.4.** As 7 janelas de quarta a sexta e a sensibilidade de 104 com z = 0 em dois rodapés; a
  §3.4 em relevância, força e limitação dos conjuntos, com a equação de ξ_mp em rodapé. O rodapé do JK foi
  refeito com a célula estimada em `instrument_layers_irf.R`: 67 de 111 reuniões, ξ_mp 7,28 → 4,94.
- **Números.** §3.4, §4, §5, Anexo D, e só números e datas no resumo, na introdução e na conclusão.
- ⚠ 22 marcadores `[conferir]` em vermelho onde a afirmação virou: o IPCA do DFM sobe no impacto (+0,020),
  a ortogonalização reduz ξ_mp, os sinais do VAR coincidem em 4 de 5, e a apreciação cambial é
  significante só a 80%. Reescritos em 10-22 (`2026-10-22_conferir_e_trajetoria_diaria`).

**Convenções temporais no Anexo F e o CDS em feriados dos EUA (2026-10-21, branch `feature/auditoria-janelas-copom`):**
[`2026-10-21_convencoes_temporais_feriados_cds`](2026-10-21_convencoes_temporais_feriados_cds.md)
**CURRENT na branch, não mergeada; nada reestimado.** Os dois itens do passo 1 do e-mail de 19-10.
- **Feriados.** O CDS cota em todos os 156 dias úteis de feriado da NYSE ou do Fed de 2012-03 a 2025-12
  (`output/copom_timing/cds_us_holidays.csv`). A única cotação inteira entre eles é a de 28/11/2013.
- **Anexo F.** Os horários do anúncio, do DI, do Yahoo e do CDS, com `tab:horarios` e as fontes em três
  rodapés com URL. A §3.3 aponta para ele num rodapé. ⚠ Por decisão do autor, o Yahoo e o CDS vão como
  fato, sem a palavra "hipótese", embora nenhum dos dois horários seja documentado pelo provedor.

**As saídas que estavam na base de 102 rodam na de 111 (2026-10-20, branch `feature/auditoria-janelas-copom`):**
[`2026-10-20_saidas_base_111`](2026-10-20_saidas_base_111.md)
**CURRENT na branch, não mergeada; a produção não muda.** Rodam de novo a força, os diagnósticos, a
precisão, o VAR, os anexos, as figuras de `paper/img/`, os placebos e a influência. Decisão do autor de
20-10: na regra dos extremos, as 9 reuniões recuperadas vão de quarta a sexta (`cb24156`).
- **Força.** `tab:first_stage`: 7,69 / 10,85 na bruta e 7,28 / 9,34 na ortogonalizada. ⚠ O F_rob da bruta
  passa de 10.
- **VAR.** Câmbio e CDS quase iguais. ⚠ O IBC-Br só é significante no impacto.
- **Placebos.** Holm não rejeita (menor p ajustado 0,632). O EPU não é significante em horizonte algum.
- **Influência.** 14 reuniões marcadas, 3 delas das 7 de feriado no Brasil. ⚠ Sem as 5 mais influentes e
  sem os extremos, o câmbio deixa de ser significante a 90% no impacto, e o CDS fica. Sem as 10, a
  inferência é inconclusiva.

**Conferências do e-mail de 18-10 e a ponte nas convenções corrigidas (2026-10-18, branch `feature/auditoria-janelas-copom`):**
[`2026-10-18_conferencias_ponte`](2026-10-18_conferencias_ponte.md)
**CURRENT na branch, não mergeada; nada em `R/` nem na produção mudou.**
- **Yahoo.** A data da linha é a data UTC de um carimbo sempre às 00:00 de Londres (carimbos baixados da
  API, iguais ao arquivo em 4163 linhas). A janela larga pelas datas vira segunda → quarta à noite nas 48
  reuniões de inverno europeu; nenhuma estimativa a usa.
- **CDS.** A ampliada da 179ª vai até 02/12/2013 porque falta a sexta 29/11. O 205,0 de 28/11 fica, com a
  limitação. Na produção a ampliada dá +7,7 p.b., significante a 90%, e a estreita −0,8.
- **Ponte na produção (111).** Câmbio −0,024 na 1ª cotação (⚠ não significante a 90%), +0,104 na 20ª
  (95%), +0,118 e +0,244 na forma reduzida mensal, +0,125 no DFM; o CDS sobe a partir da 10ª cotação.
- A sensibilidade de 104 segue com z = 0 nos 7 meses (decisão do autor de 18-10).

**Auditoria das janelas do Copom, e-mail de 17-10 (2026-10-17, branch `feature/auditoria-janelas-copom`):**
[`2026-10-17_auditoria_janelas_copom`](2026-10-17_auditoria_janelas_copom.md)
**CURRENT na branch, não mergeada; a produção da branch passa às 111 reuniões.**
- **Tabela.** O anúncio vira um intervalo onde só há o término da ata. Cada cotação das 9 é pré, pós ou
  ambígua, com margem de 30 min (regra `8edc3a2`). O DI é o último negócio, até 18h00 desde 2019, e antes
  até 18h15, limite do segmento. Yahoo e CDS são hipóteses. O CDS ampliado é a estreita mais uma variação
  de cada lado e contém o anúncio nas 9. As quatro contas do orientador batem.
- **Comparação**, janela cheia, câmbio e CDS em h0:

  | base | câmbio | CDS | ξ_mp |
  |---|---|---|---|
  | 102, anterior | 0,145 | 33,5 | 6,66 |
  | 104, sensibilidade | 0,136 | 32,4 | 6,55 |
  | 111, produção | 0,125 | 30,6 | 7,28 |

  Câmbio e CDS são significantes a 90% nas três. Pré-COVID, o ξ_mp da produção é 4,87 (5,60 na de 102).
- As saídas a jusante foram para a base de 111 em 10-20 (`2026-10-20_saidas_base_111`).

**Janela ampliada do CDS nas duas leituras e datas para a Bloomberg, passo 2 (2026-10-16, branch `feature/focus-horizonte-fixo`):**
[`2026-10-16_janela_ampliada_cds_bloomberg`](2026-10-16_janela_ampliada_cds_bloomberg.md)
**CURRENT na branch, não mergeada.** Nada reestimado, nenhuma regressão lê as janelas novas.
- **CDS.** As duas leituras de "a janela ampliada, com as duas mudanças adjacentes", às 17h de NY, para as
  111: a larga, da cotação anterior à quarta à primeira depois dela pelas datas (terça a quinta em todas),
  e a estreita mais uma variação de cada lado (`cds_wide*` em `meetings.csv`). Esperam a resposta do
  orientador.
- **Bloomberg.** 8 datas escolhidas pelo autor (maior |ΔDI| por regime do anúncio e horário europeu, 6 no
  inverno europeu), com os horários do anúncio, só o que o orientador pediu.
- Saídas antigas iguais valor a valor; `daily_event.R`, `event_trajectory.R` e `monthly_reduced_form.R`
  byte-idênticos.

**Conferência 1/4: as 9 reuniões fora das 102, e-mail de 14-10 (2026-10-15, branch `feature/focus-horizonte-fixo`):**
[`2026-10-15_conferencia_reunioes_fora`](2026-10-15_conferencia_reunioes_fora.md)
**CURRENT na branch, não mergeada.** Nada reestimado, instrumento intocado.
- **Desenho.** Por decisão do autor, as "afetadas" são as 9. Para cada uma: anúncio e status, feriado,
  motivo, e as janelas de DI, PTAX, Yahoo (convenção e larga, da linha de terça à de quinta) e CDS às 17h
  de NY, com duração em dias, cotações e horas onde há horário. A janela ampliada do CDS ficou fora e vai
  como pergunta ao orientador.
- **Motivos.** 7 pela quinta feriado no Brasil, sem DI nem PTAX: a janela vai de quarta a sexta, num
  pregão, com o mesmo contrato. 2 de Thanksgiving só pelo filtro de S&P 500, VIX e Brent, com DI, PTAX,
  Yahoo e CDS na quinta.
- ⚠ A 175ª tem +37 p.b. e contrato a 152 d.u., acima do percentil 95 das 102.
- `meetings.csv` ganhou a PTAX, o Yahoo largo, o contrato do DI e o status do anúncio para as 111.

**Ponte (b): forma reduzida mensal de câmbio e CDS na surpresa agregada, sem fatores, e-mail de 12-10 (2026-10-14, branch `feature/focus-horizonte-fixo`):**
[`2026-10-14_ponte_mensal_forma_reduzida`](2026-10-14_ponte_mensal_forma_reduzida.md)
**CURRENT na branch, não mergeada.** Regra commitada antes de rodar (`e19a754`).
- **Desenho.** As 162 inovações do DFM, h = 0 e 1, surpresas ortogonalizada e bruta. Séries do painel
  (câmbio média do Yahoo, CDS fim de mês do Investing) e a outra agregação dos diários (câmbio de fim de
  mês alinhado à `yield_6m`, CDS média do Bloomberg). Três amostras para os meses com z = 0.
- **Por +50 p.b. de surpresa ortogonalizada,** séries do painel: câmbio +R$ 0,145 no mês e +0,293 até o
  seguinte, CDS +41,3 e +43,0 p.b., tudo significante a 95%. Pela regra, a depreciação aparece no mensal
  sem fatores.
- ⚠ O câmbio de fim de mês dá +0,115 e +0,158, não significante a 90%. As amostras não mudam nada.
- ⚠ Por +50 p.b. de `yield_6m`, o primeiro estágio tem F 9,30. Câmbio 0,078/0,158 e CDS 22,3/23,2,
  contra 0,145/0,179 e 33,5/36,9 do DFM.
- Documenta fim de mês contra média e como entram os meses sem reunião. A regressão IV escalar do passo 2
  passou a `fit_reduced_form_iv()` em `R/identification/weak_iv_ar.R`.

**Ponte (a): trajetória acumulada de câmbio e CDS após o anúncio do Copom, e-mail de 12-10 (2026-10-14, branch `feature/focus-horizonte-fixo`):**
[`2026-10-14_ponte_trajetoria_evento`](2026-10-14_ponte_trajetoria_evento.md)
**CURRENT na branch, não mergeada.** Regra commitada antes de rodar (`0b08071`).
- **Desenho.** Da última cotação antes do anúncio à 1ª, 5ª, 10ª e 20ª depois, contadas no próprio
  mercado. Câmbio do Yahoo (nunca a PTAX) e CDS às 17h de NY, por decisão do autor. 101 reuniões.
  Forma reduzida na surpresa ortogonalizada, HC1.
- **Câmbio, por +50 p.b.** −R$ 0,029 na 1ª cotação (significante a 90%); +R$ 0,122 até a 20ª,
  significante a 95% (2,40%, significante a 90%). Pela regra, a troca de sinal já aparece na trajetória
  diária. ⚠ Não é significante a 90% em k = 5 e 10, e a troca não fica datada.
- **CDS.** +16,5 p.b. até a 10ª cotação, significante a 95%; nos outros horizontes, não significante a
  90%.
- ⚠ Uma conta exploratória fora da regra (sem 2020-03-18) não é resultado. O passo 2 e o Anexo B ainda
  usam o CDS de quarta a quinta.

**Câmbio diário do Yahoo pela convenção do anúncio: evento diário, conferência e Anexo B (2026-10-13, branch `feature/focus-horizonte-fixo`):**
[`2026-10-13_cambio_yahoo_convencao`](2026-10-13_cambio_yahoo_convencao.md)
**CURRENT na branch, não mergeada.** Por decisão do autor, todo o câmbio diário passa ao Yahoo
`BRL=X`, da última cotação antes do anúncio à primeira depois. O instrumento e a produção não mudam.
- **Hora.** A linha datada d traz a cotação da noite (20h no verão europeu, 21h–22h no inverno), o
  que é inferido, não declarado. Na quarta, ela vem depois do anúncio em 96 das 102 reuniões. ⚠ A
  leitura de 10-05 ("45 de inverno deslocadas") estava errada: a janela pelas datas perde o anúncio
  nas 51 de verão.
- **Evento diário.** −R$ 0,037 (0,80%, p 0,012) na bruta; ⚠ −R$ 0,029 (0,66%, p 0,088) na
  ortogonalizada, que perde os 95%. Substitui o R$ 0,048 da PTAX. CDS e DFM não mudam.
- **Anexo B, diário.** `Qr` p 0,002, 0,064 e 0,081 (eram 0,003, 0,084 e 0,147). ⚠ A razão de
  variância do câmbio vai de 1,04 a 0,69. O VAR mensal não muda. ⚠ Na base da branch, a linha fatorial
  não rejeita nada a 10%.
- **Fim de mês.** Nas 4 reuniões de verão, a primeira cotação posterior entra na média do mês da
  reunião, e a surpresa no seguinte.

**Ponte, conferência: horários do dia do Copom e janelas de DI, câmbio e CDS, e-mail de 12-10 (2026-10-13, branch `feature/focus-horizonte-fixo`):**
[`2026-10-13_ponte_horarios_copom`](2026-10-13_ponte_horarios_copom.md)
**Câmbio superado no mesmo dia** por `2026-10-13_cambio_yahoo_convencao`: a janela cambial passou da
PTAX ao Yahoo pela convenção. As seções 4 e 6 (a PTAX) e a frase da seção 7 sobre o câmbio do painel
nas reuniões de fim de mês estão superadas. O resto vale.
**CURRENT na branch, não mergeada.** Nada reestimado, instrumento intocado. O anúncio é datado reunião
a reunião pelas atas do BCB, e a regra dos testes do CDS foi commitada antes de rodar (`5048a09`).
- **Anúncio.** 19h19–20h55 até jun/2016, 18h00–18h20 até out/2020, 18h30–19h12 depois.
- **Janelas.** As do DI (fechamento a fechamento) e da PTAX (13h a 13h) cumprem a convenção nas 102
  reuniões. ⚠ A do CDS (quarta a quinta) só cumpre com fechamento em Londres; com Nova York falha em
  27 (17h) a 77 (18h). O teste do horário deu inconclusivo: a condição de Londres falha nos dois
  regimes, e a de Nova York só vale no verão americano.
- **Reuniões e meses.** ⚠ 9 das 111 reuniões ficam fora (7 quintas de feriado no Brasil, 2 de
  Thanksgiving), e seus meses entram com z = 0. A 175ª tem +37 p.b. Nas 7 reuniões de fim de mês a
  surpresa vai ao mês seguinte, coerente com a `yield_6m` de fim de mês.

**Exclusão por movimentos extremos de VIX, S&P 500 ou Brent, passo 3/5, parte 2, do plano de 03-10 (2026-10-12, branch `feature/focus-horizonte-fixo`):**
[`2026-10-12_exclusao_extremos`](2026-10-12_exclusao_extremos.md)
**Números superados em 2026-10-20** por `2026-10-20_saidas_base_111`, nas 111 reuniões; a regra, com a
emenda das 9 recuperadas (`cb24156`), e a leitura seguem valendo.
**CURRENT na branch, não mergeada, sobre a base de 10-12.** Regra fixada e commitada antes de rodar
(`2cad8bd`): sai a reunião em que a variação log de quarta a quinta do S&P 500, do VIX ou do Brent
passa, em módulo, do percentil 95 dos pregões de 2012-03 a 2025-12. A exclusão é a da influência, só
no momento Γ.
- **Marcadas.** 11 reuniões, 5 por série; S&P 500 e VIX marcam juntos quatro, o Brent marca cinco
  só dele. Três estão entre as dez mais influentes.
- **Resultado.** ξ_mp 6,66 → 5,67, conjuntos limitados a 95%. CDS estável (32,0 contra 33,5 p.b. no
  impacto), significante a 95% em h0, h1 e h3. ⚠ O câmbio cai 26% no impacto (0,145 → 0,107) e perde
  os 95% em todo horizonte; segue significante a 90% em h0–h4. Nenhum ponto do painel sai do conjunto
  de 90% de produção.
- **Leitura.** A queda do câmbio vem mais das reuniões marcadas pelo Brent, no sentido oposto ao que a
  leitura registrada atribui a esse canal, e das que mais pesam em Γ. ⚠ Pela letra da regra, a
  condição da verificação de terça a quarta se cumpre no câmbio; rodá-la é decisão do autor.

**A `msci` vira o índice MSCI de emergentes, e os passos 0 a 4 rodam de novo (2026-10-12, branch `feature/focus-horizonte-fixo`):**
[`2026-10-12_msci_emergentes`](2026-10-12_msci_emergentes.md)
**Números dos passos 1 a 4 superados em 2026-10-20** por `2026-10-20_saidas_base_111`; a construção da
`msci` segue valendo.
**CURRENT na branch, não mergeada.** A série `msci` do painel era a ação da MSCI Inc. e passa a ser o
índice MSCI Emerging Markets (código 891800, preço em dólares, fim de mês). Ele vem da própria MSCI,
pelo estágio de rede `msci`, com a base congelada: as outras 114 séries saem bit-idênticas. Os números
correntes dos passos 0 a 4 estão nesta nota, e o desenho continua nas notas de cada passo.
- **Base.** θ̂ reestimado. ξ_mp vai de 6,80 a 6,66 na completa e de 5,50 a 5,60 na pré-COVID, e
  Bai-Ng, AIC e BIC não mudam. No impacto, câmbio 0,146 → 0,145 e CDS 33,9 → 33,5 p.b. Fora da `msci`,
  nenhum ponto sai do conjunto de 90% antigo. Os pares significantes a 90% vão de 1051 a 1132, 82 dos
  ganhos em h25–h36.
- **Passos 1 a 3.** Câmbio e CDS seguem significantes a 95% no impacto. ⚠ O CDS deixa de ser em h2
  (p 0,051), e ξ_mp com NW(12) fica em 9,79. As 5 e as 10 reuniões mais influentes são as mesmas.
  Sem as 10, ξ_mp vai a 1,82.
- **Passo 4.** Holm nos 18 testes não rejeita a 10% (menor p ajustado 0,575). ⚠ Sem ajuste, o índice
  de emergentes cai 27,5 pontos no impacto e 27,3 em h1, e h1 rejeita a 5% (p 0,032). A rodada não
  separa o peso do Brasil no índice, uma piora comum aos emergentes e uma contaminação.

**Placebos com Holm, passo 4/5 do plano de 03-10 (2026-10-09, branch `feature/focus-horizonte-fixo`):**
[`2026-10-09_placebos_holm`](2026-10-09_placebos_holm.md)
**Números superados em 2026-10-12** por `2026-10-12_msci_emergentes` e **em 2026-10-20** por
`2026-10-20_saidas_base_111`. O desenho segue valendo. O p = 0,54 é das 102 reuniões e foi superado em
2026-10-22 por `2026-10-22_placebos_secao_5` (0,275 nas 111).
**CURRENT na branch, não mergeada, sobre a base do passo 0.** A produção não muda e nada é reestimado:
os p-valores AR da resposta zero vêm da tabela do passo 1, conferida contra o cache.
- **Holm.** Nos 18 testes (VIX, `msci` e EPU dos EUA em h = 0, 1, 3, 6, 12, 24), nenhum rejeita a 10%
  depois do ajuste (menor p ajustado 0,983). Sem ajuste, rejeitam a 10% a `msci` em h3 e h6 e o VIX em h6.
- **Ortogonalização.** Só o VIX entra, como tendência de 65 pregões até a quarta, com coeficiente
  −0,025 (p 0,92). A restrição não é contemporânea. Em h0 o mês do VIX se sobrepõe à janela.
- **p = 0,54.** H0 β_EPU = 0 na regressão BS do DI com `pre_epu`, t HC1 −0,61. Lê-se como ausência de
  evidência de poder preditivo naquela especificação.
- ⚠ A série `msci` é a ação da MSCI Inc. (NYSE: MSCI), não o índice MSCI de emergentes que o paper
  nomeia. Ela está no painel de produção desde antes desta rodada. Sem ela, Holm nos 12 testes também
  não rejeita.

**Influência das reuniões, passo 3/5 do plano de 03-10 (2026-10-08, branch `feature/focus-horizonte-fixo`):**
[`2026-10-08_influencia_reunioes`](2026-10-08_influencia_reunioes.md)
**Números superados em 2026-10-12** por `2026-10-12_msci_emergentes` e **em 2026-10-20** por
`2026-10-20_saidas_base_111`; o desenho segue valendo.
**CURRENT na branch, não mergeada, sobre a base do passo 0.** A produção não muda. Desenho do e-mail
de 08-10: fatores, VAR e inovações fixos, e cada reunião sai só do momento Γ entre instrumento e
inovações, com T = 162 e o calendário intactos.
- **Uma a uma.** Nenhuma exclusão muda sinal ou força: câmbio no impacto de 0,126 a 0,175 (0,146), CDS
  de 28,9 a 42,0 p.b. (33,9), ξ_mp de 5,52 a 7,61 (6,80).
- **Juntas.** Sem as 5 mais influentes, ξ_mp 3,59 e F_rob 3,78. Câmbio e CDS continuam significantes a
  90% (h0–h5 e h0–h4), mas não a 95%. Sem as 10, ξ_mp 2,01, e todo conjunto de câmbio e CDS é a reta
  inteira. As 10 carregam 81% do momento de normalização com 45% da soma de quadrados do instrumento.
- ⚠ A significância depende de poucas reuniões; a direção e a magnitude, não. A ordem escolhe as
  reuniões que carregam Γ, então parte da queda é por construção.
- ⚠ Três reuniões de 2012 caem antes da primeira inovação e não entram em Γ: a ordem cobre 99.

`tidy_ar_sets()` mudou de `script/ar_precision.R` para `weak_iv_ar.R`.

**Evento diário, passo 2/5 do plano de 03-10 (2026-10-05, branch `feature/focus-horizonte-fixo`):**
[`2026-10-05_evento_diario`](2026-10-05_evento_diario.md)
**Câmbio superado em 2026-10-13** por `2026-10-13_cambio_yahoo_convencao`: o câmbio diário passou
da PTAX ao Yahoo pela convenção (−R$ 0,037, p 0,012, na bruta; −R$ 0,029, p 0,088, na ortogonalizada,
que perde os 95%). CDS e DFM não mudam. ⚠ A leitura de que o Yahoo está "deslocado um pregão no inverno
europeu (45 das 102)" estava errada: a cotação é da noite, e a janela pelas datas perde o anúncio nas
51 reuniões de verão.
**Números do DFM superados em 2026-10-12** por `2026-10-12_msci_emergentes`; as regressões diárias
saíram byte-idênticas.
**CURRENT na branch, não mergeada, sobre a base do passo 0.** A produção não muda.
- **Dia do Copom.** As regressões cobrem 102 reuniões, com HC1. +50 p.b. de surpresa vem com o real
  apreciando R$ 0,048 (1,04%), significante a 95% com a surpresa bruta e com a ortogonalizada (p 0,019
  e 0,021). O CDS não é significante a 90% (+0,9 e −0,5 p.b.).
- **Primeiro estágio.** É a identidade na bruta e tem F 656 na ortogonalizada. O efeito por +50 p.b. no
  DI de 6 meses tem o ponto da forma reduzida, e o conjunto AR fica igual ou quase igual ao de Wald.
- **Etapa.** O câmbio só troca de sinal no DFM mensal (+0,099 com a bruta, +0,146 na produção). A
  passagem muda frequência, janela, normalização, medida e modelo juntos, e nada a decompõe.
- ⚠ O câmbio diário é a PTAX (estágio `ptax`). O Yahoo `BRL=X` está deslocado um pregão no inverno
  europeu (45 das 102 reuniões) e alimenta a linha diária do Anexo B (item novo no Tema D).

**Precisão, passo 1/5 do plano de 03-10 (2026-10-05, branch `feature/focus-horizonte-fixo`):**
[`2026-10-05_precisao_ar`](2026-10-05_precisao_ar.md)
**Números superados em 2026-10-12** por `2026-10-12_msci_emergentes` e **em 2026-10-20** por
`2026-10-20_saidas_base_111`; o desenho segue valendo.
**CURRENT na branch, não mergeada, sobre a base do passo 0.** A produção não muda.
- **95%.** Câmbio e CDS são significantes a 95% no impacto (p 0,013 e 0,015), até h3 e h4.
- **Pré-COVID.** Em `p = 4` não há conjunto (`hac_dim` 135 e `par_dim` 120 contra T = 90). Na célula
  `p = 2` (ξ_mp 5,64), os dois são significantes a 95% de h0 a h11. O ponto de `p = 4` sai do conjunto
  de `p = 2` de h10 a h22.
- **Autocorrelação.** O momento de ξ_mp e os dos testes de câmbio e CDS em zero não têm autocorrelação
  até h12.
- **Newey-West.** De 1 a 3 defasagens o impacto não muda. De 4 a 12 os conjuntos encolhem até 24,5% e
  ξ_mp vai a 10,01, sem licença para dizer que o instrumento fica forte.
- ⚠ O impacto pré-COVID do câmbio em `p = 4` é 0,121 na base nova, contra 0,056 na de `main`.

Novas em `weak_iv_ar.R`: `ar_dfm_moments()` e `ar_statistic()`.

**Focus a horizonte fixo, passo 0/5 do plano de 03-10 (2026-10-03, branch `feature/focus-horizonte-fixo`):**
[`2026-10-03_focus_horizonte_fixo`](2026-10-03_focus_horizonte_fixo.md)
**Números da base superados em 2026-10-12** por `2026-10-12_msci_emergentes`; a construção das Focus
e a comparação com `main` seguem valendo.
**CURRENT na branch, não mergeada.** As seis Focus "ano seguinte" passam à aproximação de horizonte
fixo de 12 meses de Dovern, Fritsche e Slacalek (2012), com o timing da Focus: `(12 − m)/12` no ano
corrente (DFS contam o mês da pesquisa e dão `(13 − m)/12`). O caso base `(5,5,4)` foi reestimado,
com θ̂ novo. Câmbio R$ 0,141 → 0,146 e CDS 34,0 → 33,9 p.b. no impacto, e nenhum ponto das duas sai
do conjunto de 90% antigo. A reversão de h28–h36 deixa de excluir zero a 90% e continua a 80%. Os
pares significativos a 90% caem de 1588 para 1051, 488 das perdas em h25–h36. ξ_mp 7,02 → 6,80
completa e 6,84 → 5,50 pré-COVID. ⚠ O IPCA fica positivo em h1 e h3–h7. ⚠ O EPU dos EUA deixa de
violar o placebo, e VIX e MSCI de emergentes passam a violar. ⚠ A Focus PIB a horizonte fixo tem
impacto −0,306, maior que o da "ano seguinte" (−0,189), e não a metade que a carga sem janeiros da
nota de 10-01 dava para a série antiga.

**DBGG e Focus PIB na janela pré-COVID (2026-10-01, `main`):**
[`2026-10-01_precovid_dbgg_focus_pib`](2026-10-01_precovid_dbgg_focus_pib.md)
**CURRENT.** Diagnóstico do item 3 do e-mail do orientador de 30-09, sem frase no `.tex` por
decisão do autor. `script/precovid_divergence.R` separa a carga de cada série do VAR e do choque.
A **Focus PIB** pré-COVID é forte por causa da troca de ano-alvo em janeiro: jan/2016 é 63% da soma
de quadrados das suas diferenças nessa janela, e a carga estimada sem os meses de janeiro põe a
resposta inteira dentro do conjunto de produção (0 de 37 fora, contra 5). O vale inicial da
**DBGG** de produção vem dos meses de 2020–22 (101% da covariância entre ΔDBGG e ΔDI 6m). Com a
carga dos meses pré-COVID ele some (mínimo −0,056 contra −0,428), e a alta de longo prazo fica.
Zerar as surpresas de janeiro leva o câmbio pré-COVID de 0,056 a 0,141 (razão sobre a produção de
0,40 a 0,81). ⚠ Na produção, a carga da Focus PIB sem janeiros dá metade da resposta da §4
(−0,091 contra −0,189). As cinco Focus "ano seguinte" têm de 36% a 79% da variação em janeiro.

**Rodapé sobre a saída do filtro JK (2026-09-30, branch `feature/robustez-pandemia`):**
[`2026-09-30_nota_filtro_jk`](2026-09-30_nota_filtro_jk.md)
**CURRENT.** O último item do e-mail do orientador de 28-09. Um rodapé na §3.4 registra que o filtro
de sinal reduz ξ_mp de 7,02 para 5,01 (pré-COVID, 6,84 para 4,73) e F_rob de 8,62 para 7,59 (8,31
para 7,78), que nenhum ponto com o filtro sai do conjunto de 90% de produção (0/4255), e que os
conjuntos ficam 1,32 vez mais largos na mediana, com os pares significativos a 90% caindo de 1587
para 856. A §1 e os dois resumos, que o commit `6e0bc00` tinha devolvido à descrição com o filtro,
voltaram à redação de 2026-09-26. ⚠ Com o filtro, o impacto no Ibovespa passa a excluir zero
(−8,17%), em parte por construção; o rodapé não o carrega.

**Robustez à pandemia no Anexo C (2026-09-30, branch `feature/robustez-pandemia`):**
[`2026-09-30_robustez_pandemia`](2026-09-30_robustez_pandemia.md)
**CURRENT.** Os dois itens do e-mail do orientador de 28-09. `script/pandemic_sensitivity.R`
escreve `fig:lp_sensibilidade` (`q` de 2 a 5 na amostra completa, com a reescala à esquerda e
por MQO à direita, uma linha de painéis por série) e
`fig:precovid_sensibilidade` (produção contra a janela pré-COVID, em ponto), com um rodapé na
§3.1, uma frase na §3.4 e nenhum número no corpo. No mesmo dia as cinco figuras do Anexo C
passaram a desenhar as mesmas oito séries (DI de 6 meses e 2 anos, BRL/USD, CDS, Focus PIB, IPCA
12 meses e Selic, DBGG; seção 6 da nota). Nelas, 4, 26 e 26 de 296 pontos de `q = 4`, 3 e 2 saem
do conjunto de 90% de `q = 5` com a reescala, contra 44, 132 e 154 sem ela. ⚠ Com a reescala as
respostas ainda se movem com `q` (câmbio fora de h0 a h9 e DBGG de h0 a h7 em `q ≤ 3`, com o
impacto da DBGG trocando de sinal). Em `q = 5` nenhum ponto de MQO sai do conjunto de 90% da
produção (0/4255). Na pré-COVID, curva e risco soberano ficam dentro do conjunto. ⚠ O câmbio sai
no impacto (R$ 0,056 contra 0,141), a DBGG tem o sinal oposto, e 1407 dos 4255 pontos do painel
saem, em 103 das 115 séries: a leitura de médio prazo da §4 não se repete nessa janela, e
IBC-Br, IPCA e Ibovespa, fora da figura desde a troca, ficam só na nota. ⚠ Ponto contra conjunto
da amostra completa não é teste de igualdade.

**O placebo EPU dos EUA e o controle de incerteza (2026-09-29, só na branch `feature/placebo-epu`):**
`notas/2026-09-29_placebo_epu.md` existe apenas na branch, que o autor manteve aberta e sem merge.
É o teste pedido pelo orientador em 28-09. A tendência pré-evento do EPU diário dos EUA entra na
regressão BS e não prevê a surpresa (p 0,543), e o EPU segue significativo a 90% em h1–h3 (h1
+11,52, [0,66; 31,31]). Desfecho "limitação reconhecida": o controle não foi adotado, a produção de
`main` não mudou, e desde 2026-09-30 a §3.3 declara a violação em quatro linhas, com a
`fig:placebos` no Anexo D.

**VAR mensal do Anexo B sob a escala COVID (2026-09-27, branch `feature/unidades-nativas`):**
[`2026-09-27_het_var_escala_covid`](2026-09-27_het_var_escala_covid.md)
O VAR mensal de DI, câmbio e CDS das tabelas de heterocedasticidade passa a ter duas versões, MQO e
MQP sob a escala de Lenza-Primiceri com θ próprio por vértice. As duas chegam ao `Qr` pelo caminho
da linha fatorial, com 161 meses. O tratado não rejeita `λ₁ = λ₂` em nenhum vértice (p 0,965 /
0,824 / 0,966), e as três variâncias seguem subindo juntas. A §3.3 não muda. Por decisão do
autor, o paper traz só o VAR tratado, com o tratamento na nota, a versão MQO fica nos CSVs, e as
duas tabelas do Anexo B viraram uma, `tab:het_frequency`, com as três razões de variância.
A versão sem tratamento se deslocou pela troca de caminho (p 0,988 / 0,917 / 0,931 → 0,948 / 0,881 / 0,970).
Nesses VARs, (B5) tem um só máximo. As guardas de θ̂ viraram `verify_covid_theta()`, e o θ̂ fatorial
saiu byte-idêntico.

**Séries em nível na própria unidade (2026-09-27, branch `feature/unidades-nativas`):**
[`2026-09-27_unidades_nativas`](2026-09-27_unidades_nativas.md)
Sem reestimação. A divisão pela média amostral sai das figuras e da prosa, por decisão do autor.
O câmbio passa a R$ por unidade de moeda (BRL/USD R$ 0,141/US$ no impacto, antes 3,53%), e os
índices de atividade passam a pontos do índice. BRL/CNY, BRL/INR e BRL/ARS saem da §4.2. Muda
uma comparação entre séries no h36 da §4.5, e um rótulo errado da `fig:weak_iv_main` foi
corrigido. ⚠ O BRL/ARS responde no impacto mais que o próprio nível do fim da amostra.

**Paper migrado para a produção da branch (2026-09-26, promovido para `main` no mesmo dia):**
[`2026-09-26_migracao_paper_bs_purif`](2026-09-26_migracao_paper_bs_purif.md)
**O `.tex` segue a produção corrente, em `main` desde o fast-forward de 2026-09-26.** O filtro JK sai
do paper inteiro, por decisão do autor: §2, §3.3, a linha 3 da `tab:first_stage`, a coluna do
Ibovespa da `tab:bs_ortogonalizacao` e a camada JK da `fig:instrumento_camadas`. A §3 passa a
ξ_mp 7,02/6,84 e F_rob 8,62/8,31, com a regressão BS nas 102 reuniões (`R²` 0,124). As legendas passam
a 80/90%. A §4 e a §5 foram re-derivadas do cache, com 143 e 20 números conferidos por script. Sete
passagens foram reescritas, entre elas o ajuste cambial, que contém zero a 80% no impacto, os sete
índices negativos no impacto e o câmbio, que volta a excluir zero a 90% em h32–h36. Fora da §4,
mudaram só números e frases falsas, e o item do Tema A de absorver a leitura da §4 segue aberto.

**Produção sem o filtro JK e bandas de 80/90% (2026-09-26, promovida para `main` no mesmo dia):**
[`2026-09-26_producao_bs_purif_bandas_80_90`](2026-09-26_producao_bs_purif_bandas_80_90.md)
**Branch `feature/bs-copom-surpresas-macro`: código, outputs e figuras migrados; o `.tex` migrou no
mesmo dia, em `2026-09-26_migracao_paper_bs_purif`.** O
instrumento de produção passa a `z_bs_purif`, a surpresa ortogonalizada sem o filtro de sinal, e as
bandas passam a 80/90%, como em AK; o benchmark VAR acompanha. ξ_mp de produção 7,02 na cheia e 6,84
na pré-COVID, F_rob 8,62 e 8,31. Todos os conjuntos `interval` a 80 e 90%. BRL/USD 3,53% e CDS
+34,0 p.b. no impacto. ⚠ O placebo EPU dos EUA viola a 90% em h1–h3.

**Ortogonalização Bauer-Swanson com a lista da Tabela 3, mais S&P 500 e VIX (2026-09-26, promovida para `main` no mesmo dia):**
[`2026-09-26_bs_lista_tabela3_externas`](2026-09-26_bs_lista_tabela3_externas.md)
**Branch `feature/bs-copom-surpresas-macro`: construção escolhida pelo autor, paper não migrado.
Superada no mesmo dia quanto à camada de produção: o filtro JK saiu, e os números de produção com
ele (5,01 / 4,73) passaram a ser os de uma camada alternativa.** A
regressão das 102 reuniões fica com os análogos brasileiros da Tabela 3: tendências de Ibovespa,
inclinação do DI e Brent, mais o bloco macro. Somam-se S&P 500 e VIX. As revisões Focus, que eram da
Tabela 2, e o câmbio saem. O `R²` do DI é 0,124 e a Wald não rejeita (p 0,122). O ξ_mp de produção
fica em 5,01 na cheia e 4,73 na pré-COVID. Todos os conjuntos seguem `interval`, e nenhum ponto das
oito séries da §4 sai do conjunto de 90% de `main`. Mudam três leituras da §4: IPCA, Ibovespa no
impacto e resultado primário. A promoção está aberta no Tema D.

**Ortogonalização Bauer-Swanson só nas reuniões, com surpresas macro (2026-09-25, branch):**
[`2026-09-25_bs_copom_surpresas_macro`](2026-09-25_bs_copom_surpresas_macro.md)
**Superada em 2026-09-26 quanto à lista de preditores; seguem valendo a amostra, os dados e o
bloco macro.** A regressão pré-evento passa a ser
estimada como a Tabela 3 de BS: 102 reuniões, só constante, mais as surpresas de IPCA e PIB (primeira
divulgação), a aceleração do núcleo e o IPCA esperado. A surpresa do Copom é previsível (Wald
p 0,009, `R²` 0,273), sobretudo pela revisão Focus da Selic. Com esse componente sai a força: ξ_mp
de produção cai de 6,85 para 1,78, e os conjuntos de 90% ficam ilimitados. A promoção é decisão
aberta no Tema D.

**Anexo D: a tabela de Bauer-Swanson e as respostas por camada do instrumento (2026-09-25):**
[`2026-09-25_anexo_d_instrumento`](2026-09-25_anexo_d_instrumento.md)
**CURRENT.** O Anexo D é novo e o corpo não o cita, por decisão do autor. A
`tab:bs_ortogonalizacao` segue a Tabela 3 de Bauer-Swanson, com as regressões
pré-anúncio do DI e do Ibovespa, EP HC1 e 638 quintas-feiras. A Wald conjunta não
rejeita: p 0,131 no DI e 0,326 no Ibovespa. Na `fig:instrumento_camadas`, as três
camadas da `tab:first_stage` desenham a mesma forma, e nenhum ponto das duas camadas sem
filtro sai do conjunto de 90% da produção. ⚠ O filtro JK troca o sinal do impacto do
Ibovespa por construção (+0,2% → −1,5%).

**Sensibilidade a `p` no Anexo C e θ̂ reestimado (2026-09-25):**
[`2026-09-25_p_sensibilidade_anexo`](2026-09-25_p_sensibilidade_anexo.md)
**CURRENT.** A `fig:p_sensibilidade` cobre `p = 2..6`, com `r = q = 5` e θ reestimado em
cada `p`. Todos os pontos ficam dentro do conjunto de 90% de `p = 4`, e todos os
companions são estáveis. A trava da condição de primeira ordem barrou `p = 5`, porque o
`ndeps` padrão do `optim` para antes do máximo. O autor escolheu `ndeps = 1e-6` em todo
`p`, e θ̂ de produção mudou na 4ª–5ª casa: ξ_mp 6,847997 → 6,848035, IRFs até 8e-5 da
escala. Nenhum número do paper mudou.

**O ótimo global de θ̂ confirmado (2026-09-24):**
[`2026-09-24_otimo_global_theta`](2026-09-24_otimo_global_theta.md)
**CURRENT.** Um multi-start de 750 inícios na caixa inteira de (B5) virou trava de
`covid_volatility_theta.R`, que passa a gravar também
`covid_volatility_multistart.csv`. Nenhum início termina acima de θ̂, e θ̂ sai
byte-idêntico. Há três máximos: θ̂ (137 inícios), o ρ = 0 já conhecido (−2,62, 368
inícios) e uma crista nova no piso s̄2 = 1, onde ρ não é identificado (−4,79, 245
inícios). ⚠ Nenhum início com ρ0 ≤ 0,4 chega a θ̂. O estimador de um início só
dependia do ρ0 = 0,8 da regra de LP.

**`q = r` justificado na §3.1 e a sensibilidade a `q` no Anexo C (2026-09-24):**
[`2026-09-24_q_sensibilidade_anexo`](2026-09-24_q_sensibilidade_anexo.md)
**CURRENT.** A §3.1 defende `q = r` em duas frases, ancorada em Stock-Watson (2016)
e AK, com Amengual-Watson citado (24 de 25 chaves). O Anexo C traz a figura de
`q = 2,…,5` na produção, oito séries até h36, escrita por
`q_sensitivity.R --window=cheia` e guardada contra `irf_coherence_h.csv`. O texto
não cita números, por decisão do autor. Os números ficam na nota: em h ≤ 36, 16,
5 e 4 das 20 séries ficam inteiras na banda de 90%, e o Ibovespa tem impacto 8,6
vezes o de produção em `q = 3`. ⚠ O modelo sem LP e o mecanismo do truncamento
ficam fora do paper.

**A §4 do paper migrada, com as oito figuras repintadas (2026-09-24):**
[`2026-09-24_migracao_secao_4`](2026-09-24_migracao_secao_4.md)
**CURRENT.** Fecha a sincronização aberta em 2026-09-08: a §4 sai do cache de
produção, as oito figuras são repintadas com conjuntos Anderson--Rubin e
`script/fig_section5.R` perde a trava `--repaint-paper-figures`. Nada reestimado;
os 140 números da prosa batem com o cache, e a contradição com a §5.2 some
(BRL/USD 3,23%, CDS 30,5 p.b.). A leitura muda em cinco blocos: todos os vértices
da curva têm pico em h3 e cruzam zero entre h14 e h16; **o IBC-Br não fica
positivo em 36 meses** (90% de h6 a h24); **o IPCA não fica positivo em nenhum
horizonte**; curva e risco soberano ainda estão no vale em h36. ⚠ Dois números
inconvenientes entram no texto: a fase positiva das ações é significativa a 90%
em cinco índices, e o impacto em nenhum; a NFSP primária fica positiva e
significativa de h18 a h32. Fora da §4, só números e datas no resumo, na
introdução e na conclusão; as frases de argumento que a leitura nova enfraquece
ficaram para o autor (Tema A).

**A §5 do paper migrada, com a §5.1 reestimada e a §5.3 excluída (2026-09-21):**
[`2026-09-21_migracao_secao_5`](2026-09-21_migracao_secao_5.md)
leva a §5 para a produção corrente e fecha a metade §5 da sincronização aberta
em 2026-09-08. A §5.2 ganha os cinco impactos novos (IBC-Br −0,66% e −0,73%,
BRL/USD +3,23% e +2,02%, CDS +30,5 e +15,7 p.b.), o parágrafo de defasagens
**invertido** — os dois modelos agora usam a mesma janela e `p=4` — e a
persistência reescrita horizonte por horizonte, porque os conjuntos de 90% não
são blocos contíguos. Entra o número inconveniente: **o VAR tem *price puzzle* a
90% e o DFM não**. `fig:weak_iv_main` repintada, com a legenda em Anderson--Rubin
nos dois modelos. A §5.1 é reestimada em `(5,5,4)` sob a escala LP com inovações
padronizadas: o veredito **não muda** — 0 de 37 células sobrevivem a Holm — mas o
`p_boot` de produção é marginal, 0,0508, e o assintótico da mesma estatística
rejeitaria. ⚠ **A §4 passou a contradizer a §5** em BRL/USD e CDS: a §4 era a
errada, e foi migrada em 2026-09-24.

**Fidelidade a Lenza-Primiceri: o que o artigo autoriza (2026-09-16):**
[`2026-09-16_fidelidade_lenza_primiceri`](2026-09-16_fidelidade_lenza_primiceri.md)
audita a rodada de 09-14 contra o artigo, equação por equação, e classifica cada
decisão em FIEL, EXTRAPOLAÇÃO, ENGENHARIA ou DIVERGÊNCIA. Implementado é o
Apêndice B, e só ele: (B2) sem `Ω^{-1}`, (B4) com divisor `T − p`. **Nenhum item
cai em DIVERGÊNCIA** — os doze de EXTRAPOLAÇÃO têm justificativa registrada. Os
que mais pesam: a escala entra só no VAR dos fatores, e `Λ̂` e `sy` seguem
estimados no painel sem tratamento; a inferência AR/MOSW é ancorada em MOSW,
porque o artigo não cobre weak-IV; e o plug-in em θ̂ não tem o argumento de ordem
menor disponível, já que θ̂ não é consistente. Rodada documental: nada foi
estimado, nada foi rodado, a produção não muda.

**Teste experimental superado:**
[`2026-09-01_painel_115_ajuste_cambial_expectativas_fiscais`](2026-09-01_painel_115_ajuste_cambial_expectativas_fiscais.md)
reestima em conjunto a baseline e os painéis de 112, 114 e 115 séries. No
painel final, o IC2 BLL seleciona `r=4`, `xi_mp/F_rob,mp =
5,888198/11,936511` e a raiz é 0,970092; o ajuste cambial cai no impacto, mas
só exclui zero na banda de 68%. Não altera a produção, e o paper apresenta as
quatro novas respostas como exercício complementar explicitamente experimental.

[`2026-09-01_decomposicao_contabil_dlsp`](2026-09-01_decomposicao_contabil_dlsp.md)
audita a planilha de fluxos da DLSP e bloqueia a estimação: a identidade de
sete fluxos omite a linha externa “outros ajustes”. Não altera a produção nem
o paper.

[`2026-09-01_teste_expectativas_fiscais`](2026-09-01_teste_expectativas_fiscais.md)
acrescenta três expectativas fiscais Focus apenas em painel alternativo. Não
altera a especificação de produção nem o paper.

**Leitura dos rótulos históricos:** `CURRENT` em uma nota anterior descreve a
validade da conclusão que a coluna final preserva, não a vintage de produção.
Toda linha escrita sob `p=6`, `(5,5,6)`, `(7,6)` ou o painel de 106 séries é
histórica para números do DFM. A única produção DFM corrente é a linha
`2026-09-02_producao_inicio_2012_03`; a comparação VAR(2)/VAR(6) é uma sensibilidade
separada do benchmark observável.

## Convenção

- Nome: `YYYY-MM-DD_assunto.md`, data em que a rodada foi feita.
- Banner no topo com o veredito, o vintage do dado e o script que produziu.
- Nota é **append-only**. Quando um resultado é superado, a nota velha ganha um
  banner de superada apontando para a nova — não se apaga nem se reescreve.
- Nota fica aqui. Log de sessão fica em `progress_logs/`. Parecer recebido fica
  em `pareceres/`. Nunca o contrário.

**2026-09-30:** `paper/paper_anpec.tex` passou a se chamar `paper/paper.tex`, e
as figuras `paper/fig_*.pdf` foram para `paper/img/`. As notas abaixo seguem
com os caminhos antigos; o mapa está em `registro/mapa_renomeacoes.md`.

**2026-09-18:** o wild bootstrap e a correção de Kilian saíram do código.
`script/ar_bands.R`, `script/fomc_coincidence.R` e `R/instrument/event_tests.R`
foram para `arquivo/`. Toda nota que descreve bandas de bootstrap do DFM, ou
que manda rodar um desses scripts, descreve código que não roda mais contra
`R/`. As saídas continuam em `output/`. O `(5,2)` ilimitado de
`2026-09-08_bandas_anderson_rubin_producao` é do modelo sem tratamento: sob a
escala COVID de produção, `(5,2)` tem ξ_mp 5,124 e é limitado a 68, 90 e 95%.

**2026-09-17:** a auditoria de `script/` e `R/` mudou de lugar vários scripts
citados nas notas abaixo:
- 25 scripts de rodadas fechadas foram para `arquivo/script/` (entre eles
  `jk_sovereign_confound.R`, `xi_mp_robustness.R`, `irf_spec_*.R`, `p_selection.R`,
  `q_selection.R`, `factor_stationarity.R`, `asset_representation.R`,
  `price_cross_instrument.R`, os `fiscal_*` e a família `panel_composition*`);
- os `validate_*.R` vivos foram para `script/validation/`;
- `q_narrative_overlay_{covid,precovid_p2}.R` viraram
  `script/q_sensitivity.R --window=cheia|pre_covid`.

As saídas **não** se moveram: todo caminho `output/…` citado nas notas continua
válido. O mapa completo está em `registro/mapa_renomeacoes.md`.

**2026-08-11:** esta pasta era `relatorio/working-notes/` até a adoção do
esqueleto `/newproject`; os councils foram para `pareceres/` e `_instrucoes/`
virou `registro/`. Só os caminhos mudaram — nenhum conteúdo de nota foi tocado.

**2026-08-02:** o `tex/` citado nas notas abaixo foi arquivado em
`arquivo/tex/` — o paper canônico é `paper/paper_anpec.tex`. As
referências a `tex/main.tex:<linha>` nas células da tabela continuam
apontando para o mesmo conteúdo, só que sob `arquivo/tex/`.

**Rodada de auditoria DFM-IV (07-28), fora desta pasta:** o deliverable é
`diagnostics/diagnostico_dfm.md` (Tarefas 0-7 de `prompt_auditoria_dfm_iv.md`).
Dois resultados dele contradizem notas antigas e valem para **toda** a pasta:
(i) o **placebo `commodity_metal` não está violado** — o IC-Br é em R$ e herda o
câmbio; o índice em US$ passa 25/25 horizontes. Qualquer nota que o trate como
caveat de exogeneidade está morta nesse ponto. (ii) `cds_5y`, `msci` e
`sp500_vix` entravam **100× inflados** por locale (bug B1, corrigido) — números
de CDS anteriores a 07-28 estão fora de escala por duas ordens de grandeza.

**Rota não-gaussiana (07-27) — ABANDONADA em 2026-08-17.** Implementada,
validada contra a aplicação publicada do GMR, e **empiricamente sem poder** neste
painel — a agregação do DFM destrói os momentos de ordem superior que o ICA
precisa (rejeição de JB cai de 88,7% nas séries para 50,0% em `eta`). Mesmo
mecanismo que derrubou a heterocedasticidade. Qualquer método futuro que
identifique por momentos de ordem superior a 2 nas inovações **mensais** vai bater
na mesma parede — métodos assim têm de rodar em frequência diária, sobre
observáveis, não sobre `eta`. As duas notas da rota estão em
`arquivo/nao_gaussiana/notas/`.

**Rota por heterocedasticidade (08-01) — ABANDONADA em 2026-08-17.** A parede
acima está **medida**, e o segundo momento não escapa dela. A nota, em
`arquivo/heterocedasticidade/notas/2026-08-01_robustez_heterocedasticidade.md`, roda
Rigobon (2003) no DFM mensal em **252 células × 5 desenhos** e nenhuma identifica;
o surto de volatilidade pós-2020 é **fator de escala comum** (levanta todas as
variâncias sem girar a covariância), enquanto o **mesmo teste rejeita com folga no
painel diário** (LR 135,1, p_boot 0,005). Isto é o que fecha o benchmark GRG: o
desacordo de sinal do câmbio é de **frequência**, não de identificação.

**Inferência robusta a IV fraco — a distinção de 08-18 caiu em 09-08.**
*No DFM (09-08, CURRENT):* **os conjuntos Anderson-Rubin de 68% e 90% são a
inferência operacional do DFM, no lugar do wild bootstrap.** Decisão do autor,
que reverte a retirada de 08-12 **sem** cumprir a condição de reabertura ali
registrada: a covariância plug-in continua condicionando em `Λ`, `K`, `M` e `sy`
estimados, e o Monte Carlo do parecer de 08-12 (cobertura de impacto
78,1%--83,4% com fatores estimados) segue de pé como medida do custo. O que foi
resolvido foi o outro defeito, o da classificação dos casos degenerados. Ver
`2026-09-08_bandas_anderson_rubin_producao` e `historico_decisoes.md` §7.
Duas restrições nasceram com a troca: `hac_dim < T` barra `(8,8)` em `p=4` e a
**janela pré-COVID inteira**, que passou a não ter banda nenhuma.
*A nota de 08-10 continua SUPERSEDED*: é outra vintage `(7,6,6)` com 106 séries,
e nenhum de seus números é portável para a produção corrente — inclusive o
sentido da comparação com o bootstrap, que lá saía mais estreito e aqui sai mais
largo em toda faixa de horizonte.
*No VAR de observáveis (08-22, CURRENT):* inalterado. O único benchmark ativo
usa as cinco séries em nível, constante e tendência linear, `p=2` pelo AIC comum
e publica `C_h B_1`, sem soma por horizonte. Ver
`2026-08-22_var_niveis_aic_tendencia`. `R/identification/weak_iv_ar.R` deixou de
ser VAR-only e serve aos dois modelos, com `Load`/`Inner` recaindo na identidade
no caminho do VAR — **os dois usarem AR não os torna o mesmo objeto** nem
transfere cobertura de um para o outro.

| nota | data | validade da conclusão | escrita sob | o que sobrevive |
|---|---|---|---|---|
| [`2026-10-22_placebos_secao_5`](2026-10-22_placebos_secao_5.md) | 10-22 | **CURRENT na branch `feature/auditoria-janelas-copom`, não mergeada; instrumento e IRFs intocados** | e-mails de 03-10 (passo 4), 08-10, 12-10 (item 4) e 19-10 (item 5); decisões do autor de 22-10 (§5.2 própria, §3.3 sem placebos, `tab:placebos_holm` no Anexo D, Holm sem `\cite`, rodapé Holm × Wald, figura sem marcadores, pontos lidos só por significância) | Tudo, na branch: `pre_epu` nas 111, −0,051 (0,047), p 0,275, contra 0,543 nas 102, reproduzido; sobreposição do VIX em h0 de 46% (mediana 52%, 7 zeros); Holm sem rejeição. ⚠ fora da família, o MSCI é significante a 90% em h4, h7 e h35–h42, e o VIX em h2 e h5; ⚠ as oito figuras da §4 mudam só nos metadados |
| [`2026-10-22_cds_janelas_influencia_extremos`](2026-10-22_cds_janelas_influencia_extremos.md) | 10-22 | **CURRENT na branch `feature/auditoria-janelas-copom`, não mergeada; nada reestimado** | e-mails de 19-10 (itens 4 e 5) e 12-10 (item 1); decisões do autor de 22-10 (CDS no Anexo F com Wald de 90%, §5 em duas subseções, 5.2 com tabela e prosa sem números, bruta numa frase do Anexo E) | Tudo, na branch: CDS estreito −0,8 [−6,6; 5,0] e ampliado +7,7 [0,7; 14,7] nas 111, ampliado não significante a 90% na de 104; `tab:influencia` (ξ_mp 7,28 / 4,82 / 2,36 / 6,00); 3 maiores quedas individuais do câmbio do Brent; bruta significante a 90% e não a 95%. ⚠ e-mail de 12-10 diz 90% para a bruta |
| [`2026-10-22_conferir_e_trajetoria_diaria`](2026-10-22_conferir_e_trajetoria_diaria.md) | 10-22 | **CURRENT na branch `feature/auditoria-janelas-copom`, não mergeada; nada reestimado; `.tex` sem marcadores** | e-mail de 19-10 (item 1, e item 5 na §4.2); decisões do autor de 22-10 (leitura no fim do Anexo E sem números, frase na §4.2, F_rob sem número na §3.4, conclusão sem a apreciação, picos empatados com os dois horizontes) | Tudo, na branch: as 22 reescritas; câmbio na trajetória diária não significante a 90% na 1ª, na 5ª e na 10ª cotação e significante a 95% na 20ª; CDS a 95% na 10ª e só a 90% na 20ª; agregação alternativa com o câmbio não significante a 90%; ⚠ `\autoref` em inglês |
| [`2026-10-21_artigo_base_111`](2026-10-21_artigo_base_111.md) | 10-21 | **CURRENT na branch `feature/auditoria-janelas-copom`, não mergeada; produção intocada; `.tex` na base de 111, com 22 marcadores `[conferir]` reescritos em 10-22** | e-mails de 19-10 (item 3) e 12-10 (item 1); decisões do autor de 21-10 (rodapés na §3.3, §3.4 em três parágrafos, JK reestimado, resumo/introdução/conclusão só números, marcadores onde a afirmação vira) | Tudo, na branch: `tab:first_stage` na de 111; JK 67 de 111, pares significantes 1390 → 1122; IPCA do DFM +0,020 no impacto; BRL/USD significante a 90% em h0–h6 e só a 80% em h26–h36; CDS e EMBI+ a 90% em h35–h36 |
| [`2026-10-20_saidas_base_111`](2026-10-20_saidas_base_111.md) | 10-20 | **CURRENT na branch `feature/auditoria-janelas-copom`, não mergeada; produção intocada; `paper/img/` na base de 111, `.tex` desde 10-21 (`2026-10-21_artigo_base_111`)** | e-mail de 19-10; decisões do autor de 20-10 (influência e placebos rodam de novo; extremos de quarta a sexta nas 9 recuperadas, `cb24156`); "antes" é a vintage de 10-12 ou a de `main` | Tudo, na branch: `tab:first_stage` 7,69 / 10,85 (bruta) e 7,28 / 9,34; ξ_mp pré-COVID 4,87, NW(12) 10,54; VAR câmbio 0,096 e CDS 21,1 em h0; Holm sem rejeição (menor p ajustado 0,632), EPU não significante; 14 extremos; sem as 5 ξ_mp 4,82, sem as 10 2,36, sem os extremos 6,00. ⚠ câmbio sem significância a 90% no impacto sem as 5 e sem os extremos; ⚠ IBC-Br do VAR só no impacto; ⚠ F_rob da bruta acima de 10; ⚠ Juneteenth de 2024 de terça a quinta |
| [`2026-10-18_conferencias_ponte`](2026-10-18_conferencias_ponte.md) | 10-18 | **CURRENT na branch `feature/auditoria-janelas-copom`, não mergeada; produção intocada** | e-mail de 18-10; decisões do autor de 18-10 (z = 0 mantido na de 104, ponte em 111 e 104, janela larga do Yahoo só explicada, carimbos baixados); Yahoo e CDS como hipóteses | Tudo, na branch: carimbos do Yahoo e a data UTC da linha; CDS de 26/11 a 02/12/2013 e as cotações inteiras; estreita −0,8 contra ampliada +7,7 (90%); as 5 ambíguas; ξ_mp; fontes do DI1; ponte em 111 e 104 (câmbio −0,024 → +0,104 na 20ª cotação, +0,118/+0,244 mensal, +0,125 DFM); ⚠ a apreciação na 1ª cotação deixa de ser significante a 90% |
| [`2026-10-17_auditoria_janelas_copom`](2026-10-17_auditoria_janelas_copom.md) | 10-17 | **CURRENT na branch `feature/auditoria-janelas-copom`, não mergeada; produção da branch com as 111 reuniões** | e-mail de 17-10; decisões do autor de 17-10 (as 111 na produção e a de 104 como sensibilidade, ambígua a ≤ 30 min, meses excluídos a zero, Ibovespa na janela do DI, filtro removido); Yahoo e CDS como hipóteses | Tudo, na branch: classificação pré/pós/ambígua das 9; grade do DI1; CDS ampliado; câmbio 0,145 / 0,136 / 0,125 e CDS 33,5 / 32,4 / 30,6 em h0 nas bases de 102 / 104 / 111, significantes a 90% nas três; ξ_mp 6,66 / 6,55 / 7,28; ξ_mp pré-COVID 4,87 na produção; as saídas a jusante foram para a base de 111 em 10-20 (`2026-10-20_saidas_base_111`) |
| [`2026-10-16_janela_ampliada_cds_bloomberg`](2026-10-16_janela_ampliada_cds_bloomberg.md) | 10-16 | **CURRENT na branch `feature/focus-horizonte-fixo`, não mergeada; nada reestimado, nenhuma regressão** | CDS às 17h de NY; Yahoo pela hora inferida; decisões do autor de 16-10 (datas, só os horários do anúncio, um e-mail, CDS ampliado pronto) | Tudo, na branch: as duas leituras da janela ampliada do CDS em `meetings.csv` e na tabela das 9, à espera do orientador; 8 datas e os horários do anúncio para a Bloomberg; ⚠ nada lê `d_cds_wide`/`d_cds_wide3` como resposta |
| [`2026-10-15_conferencia_reunioes_fora`](2026-10-15_conferencia_reunioes_fora.md) | 10-15 | **CURRENT na branch `feature/focus-horizonte-fixo`, não mergeada; nada reestimado, instrumento intocado** | as 9 reuniões fora das 102; anúncio pelas atas; DI `CloseRate`, PTAX 10h–13h, Yahoo pela hora inferida (convenção) e pelas datas das linhas de terça a quinta (larga), CDS às 17h de NY; decisões do autor de 15-10 antes de rodar | Tudo, na branch: 7 caem pela quinta feriado no Brasil (DI e PTAX de quarta a sexta, um pregão, mesmo contrato), 2 de Thanksgiving só pelo filtro de S&P 500, VIX e Brent; anúncio documentado nas 5 desde 2016-07, limite inferior nas 4 anteriores; Yahoo e CDS cotam nos 9 feriados; ⚠ 175ª com +37 p.b. e contrato a 152 d.u.; ⚠ janela ampliada do CDS fora, à espera do orientador |
| [`2026-10-13_cambio_yahoo_convencao`](2026-10-13_cambio_yahoo_convencao.md) | 10-13 | **CURRENT na branch `feature/focus-horizonte-fixo`, não mergeada; instrumento e produção intocados; `.tex` não migrado** | 102 reuniões, Yahoo `BRL=X` pela hora da cotação (`load_yahoo_brl()`), janela da última cotação antes do anúncio à primeira depois, por decisão do autor tomada depois de ver as contas; Anexo B com o mesmo câmbio, semanas sem reunião da noite de terça à de quarta; base do passo 0 com o índice de emergentes | Tudo, na branch: −R$ 0,037 (p 0,012) na bruta e −R$ 0,029 (p 0,088) na ortogonalizada; `Qr` diário 0,002/0,064/0,081; razão do câmbio 0,69; a leitura do horário do Yahoo de 10-05 corrigida |
| [`2026-10-13_ponte_horarios_copom`](2026-10-13_ponte_horarios_copom.md) | 10-13 | **CURRENT na branch `feature/focus-horizonte-fixo`, não mergeada, exceto o câmbio, superado no mesmo dia por `2026-10-13_cambio_yahoo_convencao`; nada reestimado, instrumento intocado** | 111 reuniões de 2012-03 a 2025-12, anúncio pelas atas do BCB (estágio `copom_atas`); DI `CloseRate`, PTAX 10h–13h, CDS Bloomberg `PX_LAST` sob as hipóteses NY 17h e 18h; regra do CDS commitada antes de rodar (`5048a09`) | Tudo, na branch: anúncio 19h19–20h55 até jun/2016, 18h00–18h20 até out/2020, 18h30–19h12 depois; DI e PTAX cumprem a convenção nas 102; diferença entre fechamento e ajuste da quarta não acompanha a notícia (p 0,55); ⚠ CDS de quarta a quinta só cumpre com Londres, com NY falha em 27 (17h) a 77 (18h) das 102; teste do horário inconclusivo; ⚠ 9 reuniões fora (7 feriados no Brasil, 2 Thanksgiving), meses com z = 0, a 175ª com +37 p.b.; 7 reuniões de fim de mês vão ao mês seguinte, coerente com a `yield_6m` |
| [`2026-10-12_exclusao_extremos`](2026-10-12_exclusao_extremos.md) | 10-12 | **NÚMEROS SUPERADOS em 10-20 por `2026-10-20_saidas_base_111` (111 reuniões, 9 de quarta a sexta); regra e leitura seguem valendo; branch não mergeada** | base de 10-12 (`msci` o índice de emergentes), `z_bs_purif`, `(5,5,4)`, escala LP, NW(0); regra commitada antes de rodar (`2cad8bd`); exclusão só em Γ, fatores, VAR e inovações fixos, T = 162 | Tudo, na branch: 11 reuniões marcadas pelo percentil 95 da \|variação\| de quarta a quinta (5 por série; S&P 500 e VIX juntos em 4; Brent em 5 só dele; 3 entre as dez mais influentes); ξ_mp 6,66 → 5,67, F_rob 8,07 → 7,66, conjuntos limitados a 95%; CDS estável e significante a 95% em h0, h1 e h3; ⚠ câmbio 0,145 → 0,107 no impacto, sem significância a 95% em horizonte algum, a 90% em h0–h4; 0/689 pontos fora do conjunto de 90% de produção; a queda do câmbio vem mais das reuniões do Brent, no sentido oposto ao da leitura registrada; ⚠ a condição da verificação de terça a quarta se cumpre no câmbio, decisão do autor |
| [`2026-10-12_msci_emergentes`](2026-10-12_msci_emergentes.md) | 10-12 | **CURRENT quanto à construção da `msci`; números dos passos 1 a 4 superados em 10-20 por `2026-10-20_saidas_base_111`; branch não mergeada** | base do passo 0 com a `msci` sendo o índice MSCI Emerging Markets (MSCI 891800, preço em USD, fim de mês) no lugar da ação da MSCI Inc.; θ̂ reestimado (7,51; 14,88; 1,42; 0,967); `z_bs_purif`, `(5,5,4)`, escala LP, NW(0); linha de base `2348852` | Tudo, na branch: as outras 114 séries bit-idênticas; ξ_mp 6,66 / 5,60, F_rob 8,07 / 5,16; Bai-Ng 5, 5, 18, AIC 4, BIC 2; câmbio 0,145 e CDS 33,5 no impacto, significantes a 95% (p 0,015 / 0,017); fora da `msci` nenhum ponto fora do conjunto antigo; 1051 → 1132 pares significantes a 90%; mesmas 5 e 10 reuniões mais influentes, sem as 10 ξ_mp 1,82; Holm nos 18 placebos sem rejeição (menor p ajustado 0,575). ⚠ sem ajuste o índice de emergentes cai no impacto e em h1 (−27,5 / −27,3 pontos, h1 p 0,032); ⚠ CDS deixa de ser significante a 95% em h2 (p 0,051); ⚠ ξ_mp com NW(12) 9,79; ⚠ `main` segue com a ação |
| [`2026-10-09_placebos_holm`](2026-10-09_placebos_holm.md) | 10-09 | **NÚMEROS SUPERADOS em 10-12 por `2026-10-12_msci_emergentes` e em 10-20 por `2026-10-20_saidas_base_111`; p = 0,54 (102 reuniões) superado em 10-22 por `2026-10-22_placebos_secao_5`; desenho e ortogonalização seguem valendo; branch não mergeada** | base do passo 0, `z_bs_purif`, `(5,5,4)`, escala LP, NW(0); p-valores AR em zero de `output/ar_precision/table.csv`; Holm a 10% | Tudo, na branch: Holm nos 18 testes de VIX, `msci` e EPU dos EUA em h = 0, 1, 3, 6, 12, 24 não rejeita nada (menor p ajustado 0,983); sem ajuste, `msci` h3 e h6 (p 0,055) e VIX h6 (p 0,088) a 10%; só o VIX entra na ortogonalização, pré-evento, coeficiente −0,025 (p 0,92); p = 0,54 é H0 β_EPU = 0 na regressão BS do DI. ⚠ em h0 o mês do VIX se sobrepõe à janela pré-evento; ⚠ `msci` é a ação da MSCI Inc., não o índice de emergentes, e está no painel de produção |
| [`2026-10-08_influencia_reunioes`](2026-10-08_influencia_reunioes.md) | 10-08 | **NÚMEROS SUPERADOS em 10-12 por `2026-10-12_msci_emergentes` e em 10-20 por `2026-10-20_saidas_base_111`; desenho e leitura seguem valendo; branch não mergeada** | base do passo 0, `z_bs_purif`, `(5,5,4)`, escala LP, NW(0); fatores, VAR e inovações da amostra completa fixos; cada reunião sai só de Γ, T = 162 | Tudo, na branch: ordem por max_k \|ΔΓ_k\|/EP_k nas 99 reuniões que entram em Γ; uma a uma, câmbio h0 0,126–0,175, CDS 28,9–42,0, ξ_mp 5,52–7,61; sem as 5 mais influentes ξ_mp 3,59 / F_rob 3,78, câmbio e CDS significantes a 90% e não a 95%; sem as 10 ξ_mp 2,01 / F_rob 1,86, nenhum conjunto de câmbio e CDS limitado; as 10 carregam 81% de d0'Γ. ⚠ a significância depende de poucas reuniões, em parte por construção da ordem; ⚠ três reuniões de 2012 antes da primeira inovação |
| [`2026-10-05_evento_diario`](2026-10-05_evento_diario.md) | 10-05 | **Câmbio superado em 10-13 por `2026-10-13_cambio_yahoo_convencao` (PTAX → Yahoo pela convenção; o horário do Yahoo da seção 1 estava errado); regressões do CDS valem; números do DFM superados em 10-12 por `2026-10-12_msci_emergentes`; branch não mergeada** | 102 reuniões do Copom 2012-03--2025-12, `delta_di` e `e_di_bs` de `main`; PTAX 13h → 13h, CDS Bloomberg; DFMs da base do passo 0 com `z_bruto` e `z_bs_purif` | Tudo, na branch: real aprecia R$ 0,048 (1,04%) por +50 p.b. no dia, significante a 95% com as duas surpresas (p 0,019 / 0,021); CDS não significante a 90%; primeiro estágio identidade / F 656; o câmbio só troca de sinal no DFM (+0,099 / +0,146), passagem não decomposta. ⚠ no CDS o ponto troca de sinal na ortogonalização (+0,9 → −0,5), sem significância; ⚠ Yahoo `BRL=X` deslocado um pregão no inverno europeu, atinge a linha diária do Anexo B |
| [`2026-10-05_precisao_ar`](2026-10-05_precisao_ar.md) | 10-05 | **NÚMEROS SUPERADOS em 10-12 por `2026-10-12_msci_emergentes` e em 10-20 por `2026-10-20_saidas_base_111`; desenho e leitura seguem valendo; branch não mergeada** | base do passo 0 (Focus a horizonte fixo), `z_bs_purif`, `(5,5,4)`, escala LP; pré-COVID 2012-03--2019-12 por MQO em `p = 2` e `p = 4` | Tudo, na branch: câmbio e CDS significantes a 95% no impacto (p 0,013 / 0,015), até h3 / h4; 458 pares significantes a 95% no painel; pré-COVID `p = 2` com ξ_mp 5,64, significantes a 95% em h0–h11; `p = 4` barrado; momentos sem autocorrelação até h12; NW 1–3 não muda o impacto, NW 4–12 estreita até 24,5% e leva ξ_mp a 10,01. ⚠ ponto `p = 4` fora do conjunto `p = 2` em h10–h22; ⚠ impacto pré-COVID do câmbio 0,121 na base nova, contra 0,056 |
| [`2026-10-03_focus_horizonte_fixo`](2026-10-03_focus_horizonte_fixo.md) | 10-03 | **CURRENT quanto à construção das Focus e à comparação com `main`; números da base superados em 10-12 por `2026-10-12_msci_emergentes`; branch não mergeada** | painel com as seis Focus anuais a horizonte fixo de 12 meses; `z_bs_purif`, `(5,5,4)`, escala LP com θ̂ reestimado (7,46; 15,01; 1,44; 0,966), conjuntos AR 80/90 | Tudo, na branch: câmbio 0,141 → 0,146 e CDS 34,0 → 33,9 no impacto, 0/37 pontos fora do conjunto antigo; ponta longa (h25–h36) perde os 90% no painel (1588 → 1051 pares), mantém os 80%; ξ_mp 6,80 / 5,50; Bai-Ng 5, 5, 18; AIC 4, BIC 2. ⚠ IPCA positivo em h1, h3–h7; ⚠ placebos VIX e MSCI EM violam, EPU EUA não; ⚠ anexos, figuras do paper, `het_conditions` e `precovid_divergence` seguem na base antiga |
| [`2026-10-01_precovid_dbgg_focus_pib`](2026-10-01_precovid_dbgg_focus_pib.md) | 10-01 | **CURRENT — diagnóstico; produção e `.tex` intocados** | produção de 2026-09-26 (`z_bs_purif`, `(5,5,4)`, escala LP, conjuntos AR 80/90) e pré-COVID 2012-03--2019-12 por MQO | Tudo: Focus PIB pré-COVID forte pela troca de ano-alvo em janeiro (jan/2016 = 63% da soma de quadrados; carga sem janeiros 0/37 fora do conjunto); vale da DBGG de produção vindo de 2020–22 (101% da covariância com o DI 6m; carga pré-COVID tira o vale); câmbio pré-COVID 0,056 → 0,141 sem as surpresas de janeiro. Blocos de carga são diagnóstico, sem conjunto. ⚠ A Focus PIB da §4 cai à metade com a carga sem janeiros (−0,189 → −0,091); cinco Focus "ano seguinte" com 36–79% da variação em janeiro |
| [`2026-09-30_nota_filtro_jk`](2026-09-30_nota_filtro_jk.md) | 09-30 | **CURRENT — rodada de texto; nada reestimado** | produção de 2026-09-26 (`z_bs_purif`, `(5,5,4)`, escala LP, conjuntos AR 80/90); branch `feature/robustez-pandemia` | Tudo: o rodapé da §3.4 sobre o filtro JK (ξ_mp 7,02 → 5,01 e 6,84 → 4,73; F_rob 8,62 → 7,59 e 8,31 → 7,78; 0/4255 pontos fora do conjunto de 90% de produção; conjuntos 1,32 vez mais largos; pares significativos a 90% 1587 → 856); a §1 e os resumos de volta à redação de 09-26. ⚠ Com o filtro o impacto no Ibovespa exclui zero (−8,17%, [−28,4; −3,0]), em parte por construção; o resumo em inglês ainda traz "3.64%" |
| [`2026-09-30_robustez_pandemia`](2026-09-30_robustez_pandemia.md) | 09-30 | **CURRENT — rodada de apêndice; produção intocada** | produção de 2026-09-26 (`z_bs_purif`, `(5,5,4)`, escala LP, conjuntos AR 80/90); branch `feature/robustez-pandemia` | Tudo: as cinco figuras do Anexo C desenham desde esta data as mesmas oito séries (DI 6 meses e 2 anos, BRL/USD, CDS, Focus PIB, IPCA 12 meses e Selic, DBGG), por decisão do autor, o que torna as figuras das notas de 09-24, 09-25 e 09-26 diferentes das do paper; `q` de 2 a 5 com e sem a reescala na amostra completa, com 4/26/26 de 296 pontos de `q` = 4/3/2 fora do conjunto de 90% de `q = 5` nas oito séries com a reescala e 44/132/154 sem ela (painel: 151/420/408 contra 589/1651/1805 de 4255); ⚠ com a reescala o câmbio sai de h0 a h9 e a DBGG de h0 a h7 em `q ≤ 3`, e o impacto da DBGG troca de sinal; em `q = 5`, MQO com 0/4255 pontos fora do conjunto de 90% da produção (raiz 0,970090); `p` e camadas do instrumento com 0/296 fora nas oito séries novas; pré-COVID em ponto (raiz 0,993359) com curva e risco soberano dentro do conjunto. ⚠ Câmbio pré-COVID fora no impacto (R$ 0,056 contra 0,141); DBGG pré-COVID com o sinal oposto, fora em 22 dos 37 horizontes; 1407/4255 pontos fora, em 103 das 115 séries; IBC-Br, IPCA, Ibovespa e DLSP, fora da figura, saem em 12 a 21 dos 37 horizontes. ⚠ Ponto pré-COVID sem inferência (`hac_dim` 135 ≥ 90); ficar dentro do conjunto não é teste de igualdade |
| [`2026-09-27_het_var_escala_covid`](2026-09-27_het_var_escala_covid.md) | 09-27 | **CURRENT — diagnóstico; produção intocada** | produção de 2026-09-26 (`(5,5,4)`, escala LP), painel mensal 2012-03--2025-12, 107 C / 54 NC; branch `feature/unidades-nativas` | Tudo: θ̂ por vértice (s̄0 ≈ 4,5–4,9, ρ ≈ 0,94–0,95, máximo único em 750 inícios); o VAR tratado não rejeita `λ₁ = λ₂` (p 0,824–0,966); razões C/NC 1,99–2,32 no DI, 1,21–1,27 no câmbio e 1,89–1,92 no CDS; o deslocamento declarado da linha sem tratamento pela troca de caminho (GLS `p = 4`, 162 meses → MQO com resíduos como inovações, 161 meses). ⚠ Com o tratamento, `λ₂ = λ₃` cai a p 0,104 no vértice de 3 meses |
| [`2026-09-27_unidades_nativas`](2026-09-27_unidades_nativas.md) | 09-27 | **CURRENT — rodada de apresentação; nada reestimado** | produção de 2026-09-26 (`z_bs_purif`, `(5,5,4)`, escala LP, conjuntos AR 80/90); branch `feature/unidades-nativas` | Tudo: o fim da divisão pela média amostral; a tabela antes/depois de cada número da prosa; a comparação entre séries que mudou no h36 da §4.5; o rótulo corrigido da `fig:weak_iv_main`. ⚠ BRL/ARS: impacto de R$ 0,0063/peso, acima do nível do fim da amostra (0,0038) |
| [`2026-09-26_migracao_paper_bs_purif`](2026-09-26_migracao_paper_bs_purif.md) | 09-26 | **CURRENT — o paper segue a produção; feita na branch, promovida para `main` em 2026-09-26** | painel 115, 2012-03--2025-12, `(5,5,4)`, escala LP, `z_bs_purif`, conjuntos AR 80/90; branch `feature/bs-copom-surpresas-macro`; sem reestimação | O que mudou no `.tex`, seção por seção; o filtro JK fora do paper inteiro; as sete passagens da §4 reescritas; a auditoria de 143 + 20 números contra o cache. |
| [`2026-09-26_producao_bs_purif_bandas_80_90`](2026-09-26_producao_bs_purif_bandas_80_90.md) | 09-26 | **CURRENT — é a produção desde a promoção para `main` em 2026-09-26; `.tex` migrado no mesmo dia (`2026-09-26_migracao_paper_bs_purif`)** | painel 115, 2012-03--2025-12, `(5,5,4)`, escala LP, `z_bs_purif`, conjuntos AR 80/90; branch `feature/bs-copom-surpresas-macro` | Tudo: a produção sem filtro JK, ξ_mp 7,02 / 6,84, F_rob 8,62 / 8,31, todos os conjuntos `interval` a 80 e 90%; os impactos novos (BRL/USD 3,53%, CDS +34,0 p.b.); o VAR em 80/90% com `xi_var` 7,19; o ponto novo é a camada `z_bs_purif` anterior, a 0. ⚠ Placebo EPU dos EUA viola a 90% em h1–h3 |
| [`2026-09-26_bs_lista_tabela3_externas`](2026-09-26_bs_lista_tabela3_externas.md) | 09-26 | **CURRENT quanto à construção, promovida para `main` em 2026-09-26; superada no mesmo dia quanto à camada de produção (sem JK desde `2026-09-26_producao_bs_purif_bandas_80_90`)** | painel 115, 2012-03--2025-12, `(5,5,4)`, escala LP, conjuntos AR 68/90; branch `feature/bs-copom-surpresas-macro` | A regressão pré-evento com os análogos da Tabela 3 (Ibovespa, inclinação do DI, Brent, bloco macro) mais S&P 500 e VIX; `R²` do DI 0,124, Wald p 0,122; ξ_mp de produção 5,01 cheia e 4,73 pré-COVID; todos os conjuntos `interval`; 0 de 296 pontos das oito séries da §4 fora do conjunto de 90% de `main`; o que a promoção migra (§5). ⚠ S&P e VIX em 65 pregões não tratam a super quarta (34 das 102 reuniões). ⚠ A lista foi fixada depois de medir a variante com a revisão da Selic. ⚠ Os placebos externos (EPU dos EUA h1–h6, MSCI emergentes h2–h8, VIX h0) ficam significativos a 90%, o que não acontecia em `main`; causa não investigada |
| [`2026-09-25_bs_copom_surpresas_macro`](2026-09-25_bs_copom_surpresas_macro.md) | 09-25 | **BRANCH — superada em 09-26 quanto à lista de preditores; amostra, dados e bloco macro seguem valendo** | painel 115, 2012-03--2025-12, `(5,5,4)`, escala LP, conjuntos AR 68/90; branch `feature/bs-copom-surpresas-macro` | Tudo, como medição: a surpresa do Copom é previsível nas reuniões (Wald p 0,005 sem o bloco macro, 0,009 com ele); o bloco macro não é significativo em conjunto (p 0,159); ξ_mp de produção 1,78 na cheia e 3,22 na pré-COVID; os conjuntos de 90% ficam `real_line`/`two_rays`; os impactos crescem com o denominador menor. ⚠ Esta lista nunca foi promovida; a promovida em 2026-09-26 é a de `2026-09-26_bs_lista_tabela3_externas`. ⚠ Quatro divulgações caem na quinta do Copom. ⚠ Não foi testado se a queda sobrevive sem a revisão da Selic |
| [`2026-09-25_anexo_d_instrumento`](2026-09-25_anexo_d_instrumento.md) | 09-25 | **CURRENT — rodada de apêndice; tabela nova, respostas sob o θ̂ de 09-25** | `paper/paper_anpec.tex` sob a produção de 115 séries, 2012-03--2025-12, `(5,5,4)`, escala LP, conjuntos AR 68/90 | Tudo: a `tab:bs_ortogonalizacao` como análoga da Tabela 3 de Bauer-Swanson (HC1, 638 quintas, Wald p 0,131/0,326); a `fig:instrumento_camadas` com 0/4255 pontos alternativos fora do conjunto de 90%; os impactos por camada. ⚠ O sinal do Ibovespa troca com o filtro JK, por construção. ⚠ A amostra da regressão são todas as quintas válidas, não só as semanas de reunião |
| [`2026-09-25_p_sensibilidade_anexo`](2026-09-25_p_sensibilidade_anexo.md) | 09-25 | **CURRENT — θ̂ de produção reestimado (`ndeps = 1e-6`); nenhum número do paper mudou** | painel 115, 2012-03--2025-12, `(r,q) = (5,5)`, `p = 2..6`, escala LP | Tudo: o diagnóstico da trava em `p = 5`; θ̂ por `p`; o θ̂ novo (6,611488; 12,468194; 1,760038; 0,943951); ξ_mp 6,848035, F_rob 11,765564, raiz 0,983676; os impactos do smoke test; a figura com todos os pontos dentro do conjunto de 90% de `p = 4` |
| [`2026-09-24_otimo_global_theta`](2026-09-24_otimo_global_theta.md) | 09-24 | **CURRENT — θ̂ confirmado como máximo global; produção não mudou** (⚠ θ̂ reestimado com gradiente mais fino em 09-25, ver `2026-09-25_p_sensibilidade_anexo`) | painel 115, 2012-03--2025-12, `(r,p) = (5,4)`, `t*` = 2020-03, s̄ ≥ 1, ρ ∈ [0,1] | Tudo: o multi-start de 750 inícios como trava de `covid_volatility_theta.R`, com a tabela em `covid_volatility_multistart.csv`; nenhum início acima de θ̂ (+3,8e-7, precisão do otimizador); os três máximos, θ̂, ρ = 0 (−2,6211) e a crista no piso s̄2 = 1 (−4,7925, máximo local fraco só para ρ < 0,8346); θ̂ byte-idêntico, smoke test e `validate_production_spec.R` inalterados; os dois mutantes pegos. ⚠ Nenhum início com ρ0 ≤ 0,4 chega a θ̂: o estimador de um início só dependia do ρ0 = 0,8 de LP. ⚠ Grade finita e um otimizador só. ⚠ Os θ por vértice do item D não estão cobertos |
| [`2026-09-24_q_sensibilidade_anexo`](2026-09-24_q_sensibilidade_anexo.md) | 09-24 | **CURRENT — rodada editorial; produção não reestimada** | `paper/paper_anpec.tex` sob a produção de 115 séries, 2012-03--2025-12, `(5,5,4)`, escala LP, conjuntos AR 68/90 | Tudo: a defesa de `q = r` na §3.1 (Stock-Watson 2016 §7.2, AK nota 4, Amengual-Watson citado); o Anexo C com `fig:q_sensibilidade`; a guarda de `q = 5` contra `irf_coherence_h.csv`; e os números em h ≤ 36, que o paper não cita. ⚠ Em `q ≤ 3` os impactos de câmbio, CDS e Ibovespa se ampliam, de modo que a defesa não é a insensibilidade. ⚠ O modelo sem LP e o T1 da `cheia_p4_lp`, que não rejeita a 5%, ficam fora do paper |
| [`2026-09-24_migracao_secao_4`](2026-09-24_migracao_secao_4.md) | 09-24 | **CURRENT — rodada editorial; nada reestimado** | `paper/paper_anpec.tex` sob a produção de 115 séries, 2012-03--2025-12, `(5,5,4)`, escala LP, conjuntos AR 68/90 | Tudo: a §4 inteira, as oito figuras e suas legendas na vintage de produção; a tabela das cinco trajetórias que mudaram de forma (curva, câmbio e risco, atividade, preços, ações); as seis frases de banda que ficaram falsas e foram reescritas; as correções de número e data no resumo, na introdução e na conclusão. ⚠ A fase positiva das ações e a NFSP primária positiva em h18–h32 são significativas a 90% e estão no texto. ⚠ As frases de argumento do resumo e da conclusão que a leitura nova enfraquece seguem abertas no Tema A |
| [`2026-09-17_reorganizacao_secao_3`](2026-09-17_reorganizacao_secao_3.md) | 09-17 | **CURRENT — rodada editorial; nada reestimado** | `paper/paper_anpec.tex` sob a produção de 115 séries, 2012-03--2025-12, `(5,5,4)`; branch `feature/lp-volatilidade-producao` | Sobrevivem: a §3 em quatro subseções (modelo e estimação, base de dados, identificação e construção do instrumento, relevância do instrumento e inferência); a migração número a número da janela, das 102 reuniões, da classificação 67/35 e da `tab:first_stage`; o `R²` de 0,022 apurado por `script/instrument.R`, que reproduziu as 11 saídas de `data/processed/` bit a bit; e a verossimilhança concentrada (5c), fiel a `factor_estimation.R:593-595`, que antes não existia no paper. ⚠ **Só a §3 migrou**: §4, §5, `irf_section.md` e as duas legendas *wild bootstrap* seguem em 2013:01--2025:09 e descrevem as figuras como pintadas. ⚠ Saíram por decisão do autor as duas ressalvas dos conjuntos AR (covariância `plug-in` e gate `hac_dim < T`), a nota `y_t → F_t` de Lenza-Primiceri e a troca `c_j' = s_jy Λ_j'` com a nota de MOSW. **O gate segue valendo no código e nos artefatos**: nenhuma banda pré-COVID e nenhum `(8,8)` podem ser publicados como inferência. |
| [`2026-09-17_volatilidade_covid_producao`](2026-09-17_volatilidade_covid_producao.md) | 09-17 | **CURRENT — o tratamento é produção** | painel 115, 2012-03--2025-12, `(5,5,4)` sob a escala LP; branch `feature/lp-volatilidade-producao` | Sobrevivem: o veredito de viabilidade (ξ_mp 6,847997 cheia, F_rob 11,765250, raiz 0,983677, 2841/2842 conjuntos `interval` por nível); a prova de que a pré-COVID é idêntica tratada ou não, porque `s_t = 1` em todos os seus meses; o roteamento por argumento obrigatório em `run_stage2_cell()`; e a instabilidade de `r >= 7` na cheia (raiz 1,001362 e 1,001318). ⚠ **Viabilidade não é leitura**: a §4 do paper ficou fora por decisão do autor, e a leitura econômica das IRFs tratadas não foi feita. ⚠ O ótimo global de θ̂, que esta nota deixou não confirmado, foi confirmado em 2026-09-24 (`2026-09-24_otimo_global_theta`). ⚠ `ar_bands.R` e `irf_spec_stage2.R` ficam OLS de propósito; seus alvos não devem ser sincronizados com `mosw_strength_grid.csv`. |
| [`2026-09-16_fidelidade_lenza_primiceri`](2026-09-16_fidelidade_lenza_primiceri.md) | 09-16 | **CURRENT — auditoria de fidelidade; nada estimado** | artigo em `artigos/Lenza - How to estimate a vector autoregression after March 2020/`; rodada auditada sob painel 115, 2012-03--2025-12, `(r,p) = (5,4)`; `main`, após `f858fe5` | Sobrevive o mapeamento equação-por-equação e a classificação nas quatro caixas mais a declarada (a★): 8 FIEL, 2 (a★), 12 EXTRAPOLAÇÃO, 8 ENGENHARIA, **0 DIVERGÊNCIA**. Sustentam-se: o ramo implementado é o Apêndice B, exclusivamente; a escala entra só no VAR dos fatores (`factor_estimation.R:946` contra `:950`), de modo que `Λ̂` e `sy` seguem sem tratamento e multiplicam toda IRF; θ̂ sai do objetivo da (B5) exatamente, mas numa caixa que o artigo não fixa, com piso `s̄ ≥ 1` idêntico ao `setpriors_covid.m:225-226` dos autores; e a forma estimada difere da do artigo — ŝ2 = 1,76 contra ≈20, ρ̂ = 0,944 contra ≲0,8, meia-vida 12,01 meses, 70 dos 162 meses com `s_t` ≠ 1 e 19,07 meses-equivalentes reponderados. ⚠ **Zero DIVERGÊNCIA afirma que a justificativa existe, não que esteja certa:** o plug-in em θ̂ não dispõe do argumento de ordem menor, porque θ̂ não é consistente (`…estimacao_theta…:90-104`), e nenhuma das três saídas — teoria limite com θ incidental, AR conjunto em (β,θ), ou integrar θ como o corpo do artigo — foi tentada. ⚠ A diferença do segundo máximo em ρ = 0 tem duas leituras legítimas: **2,6211** contra o máximo livre (a das notas) e **2,6088** contra o máximo da grade. ⚠ O segundo momento não centrado de `factor_estimation.R:964-966` é **inerte em `q = r`** (`:791-796`), logo não age na célula de referência. Não altera a produção e não supersede as três notas de 09-14. |
| [`2026-09-14_inferencia_volatilidade_covid_q`](2026-09-14_inferencia_volatilidade_covid_q.md) | 09-14 | **CURRENT; sem veredito, leitura do autor pendente** | painel 115, 2012-03--2025-12, `(r,p) = (5,4)`, θ̂ da nota abaixo; branch `feature/volatilidade-covid-lp` | Sobrevivem a derivação da inferência AR e do ξ_mp sob WLS e sua validação: θ neutro reproduz a produção a 1,5e-13, e os sete mutantes foram pegos. Também os números de T1, T2 e da tabela `q = 2,…,5` na cheia tratada, que são descritivos. |
| [`2026-09-14_estimacao_theta_volatilidade_covid`](2026-09-14_estimacao_theta_volatilidade_covid.md) | 09-14 | **CURRENT; θ estimado, nenhuma IRF tratada** | painel 115, 2012-03--2025-12, `(r,p) = (5,4)`; branch `feature/volatilidade-covid-lp` | Sobrevivem: as decisões do autor para `t*`, os limites de θ, `innovations` e a centragem; θ̂ por (B5), com o perfil em ρ; a prova de que sem o piso s̄ ≥ 1 não há máximo; o H e o K não centrados sob WLS; e a validação, com os quatro mutantes novos pegos. A inferência sob tratamento saiu na nota acima. |
| [`2026-09-14_volatilidade_covid_lenza_primiceri`](2026-09-14_volatilidade_covid_lenza_primiceri.md) | 09-14 | **CURRENT como implementação; a centragem foi superada pela nota acima** | painel 115, 2012-03--2025-12, `(5,5,4)`; branch `feature/volatilidade-covid-lp`, commits `ed316ad` e `815350a` | Sobrevivem o código do tratamento (B2/B4/B5 no VAR dos fatores) e sua validação: θ neutro reproduz a produção bit a bit, e os nove mutantes foram pegos. Também as decisões fora do artigo e a lista do que falta. Não existe número de IRF tratada. |
| [`2026-09-08_bandas_anderson_rubin_producao`](2026-09-08_bandas_anderson_rubin_producao.md) | 09-08 | **CURRENT — inferência do DFM** | painel 115, 2012-03--2025-12, `(5,5,4)`, `z_jk_bs_purif`; **paper e `irf_section.md` não tocados** | Tudo. Os conjuntos AR passam a ser a inferência operacional **no lugar** do wild bootstrap, por decisão do autor que reverte 08-12 sem cumprir a condição de reabertura. Produção: ξ_mp = 6,057014 por caminho independente (bloco `W2` de MOSW contra `compute_factor_space_wald`, desvio 7,5e-12), **5.635/5.635 células `interval`** a 68/90/95%, prêmio de IV fraco 1,101/1,382/1,751 sobre o delta-method. O fato central sobrevive no impacto a 90%: câmbio [0,073; 0,262], EMBI+ [0,096; 0,527], CDS [14,67; 60,76]; Ibovespa e IPCA não. `(5,2)` com ξ_mp = 2,339 é limitado **só a 68%** — a 90% saem 3.429 pares de semirretas e 2.205 retas, que é a demonstração pedida na sugestão 5/5 do orientador. Validação: `Load = Inner = I` recai no MOSW original com desvio **exatamente 0**; ponto AR bate com `ident_ext_instr` com parada dura em 1e-10. ⚠ **A troca não é uniforme e o agregado engana:** o conjunto AR é **mais largo** que a banda de bootstrap em toda faixa de horizonte (1,10 a 1,40), e a 90% h ≤ 12 perde significância (319 células contra 393); o ganho agregado vem de h > 12, onde o bootstrap não declara nada porque sua banda percentil **se desloca** do ponto — o AR contém o ponto por construção, o bootstrap a 68% o exclui em 37 células. **Não citar as células longas novas como evidência separada da reversão de médio prazo.** ⚠ Nas 58 séries pontuadas, sig90 em h ≤ 12 cai de 256 para 159 e sig68 sobe de 1.021 para 1.897; seis vereditos mudam, todos por afrouxamento de `wrong_sig90`. ⚠ **Três custos:** a janela pré-COVID perdeu a inferência (`hac_dim` 135 ≥ 90); `r=q=8` ficou incompatível com a inferência de produção em `p=4` (336 ≥ 162), o que atinge a sugestão 4/5 do orientador; e o condicionamento em fatores estimados continua, com o custo de cobertura que o parecer de 08-12 mediu. Sem pseudo-inversa e sem fallback: célula barrada é reportada barrada. `script/fig_section5.R` e `script/fig_weak_iv.R` foram congelados atrás de `--repaint-paper-figures`. Código: `R/identification/weak_iv_ar.R`, `script/ar_bands.R` → `output/irf/ar_bands.*` |
| [`2026-09-02_producao_inicio_2012_03`](2026-09-02_producao_inicio_2012_03.md) | 09-02 | **CURRENT — produção DFM** | painel 115, 2012-03--2025-12, `(5,5,4)`, `z_jk_bs_purif`, 800 bootstraps, semente 123 | IC1/IC2/IC3 BLL selecionam 5/5/20; 162 inovações, `xi_mp/F_rob=6,057014/9,625428`, raiz 0,970090; pré-COVID com 90 inovações. Zero falhas, bandas finitas/ordenadas e normalização exata. Paper e figuras seguem na vintage anterior. |
| [`2026-09-01_painel_115_ajuste_cambial_expectativas_fiscais`](2026-09-01_painel_115_ajuste_cambial_expectativas_fiscais.md) | 09-01 | **CURRENT como experimento conjunto; não promocional** | painéis 111/112/114/115, `(5,5,4)`, 800 réplicas somente no painel 115 | IC2 BLL seleciona `r=4` no painel 115 cheio; `xi_mp/F_rob,mp=5,888198/11,936511`, raiz 0,970092. Ajuste cambial cai R$ 11,8 bilhões no impacto e exclui zero apenas a 68%; compatível com canal mecânico, sem decomposição completa. Expectativas fiscais têm resposta mista. A produção fica intacta, e o paper usa as quatro respostas como complemento experimental. |
| [`2026-08-30_pitch_revisao_literatura`](2026-08-30_pitch_revisao_literatura.md) | 08-30 | **CURRENT como recomendação editorial** | produção `(5,5,4)` tomada como dada; leitura do paper, dos registros e da literatura; nenhuma estimação e nenhum `.tex` alterado | O canal de risco é o pitch principal; o mecanismo de Blanchard é a comparação brasileira direta; dominância fiscal permanece hipótese não identificada. A decomposição do wedge de UIP decide o título, e a decomposição da curva decide a atribuição ao prêmio de prazo. |
| [`2026-08-25_sincronizacao_secoes_3_5_p4`](2026-08-25_sincronizacao_secoes_3_5_p4.md) | 08-25 | **CURRENT como registro textual** | conferência documental da produção `(5,5,4)`; nenhuma estimação | Fontes, números e limites editoriais usados para sincronizar as Seções 3--5, o relatório de IRFs e a documentação viva. |
| [`2026-08-24_migracao_dfm_p4`](2026-08-24_migracao_dfm_p4.md) | 08-24 | **HISTÓRICA — superada pela amostra 2012-03--2025-12** | painel 111, `(5,5,4)`, `z_jk_bs_purif`, 800 bootstraps, semente 123 | `p=4` pelo AIC 8,073207 em amostra comum `T=141`, com BIC em `p=2`; VAR fatorial estimado com intercepto apenas. 149 inovações, `xi_mp/F_rob=5,240158/10,060922`, raiz 0,968126; pré-COVID 80, `7,478324/11,874945`, raiz 0,992483. Zero falhas, bandas finitas e normalização exata. |
| [`2026-08-24_var_p2_vs_p6`](2026-08-24_var_p2_vs_p6.md) | 08-24 | **CURRENT como sensibilidade; não altera a produção** | cinco séries em nível, constante e tendência linear, `z_jk_bs_purif`, +50 pb em `yield_6m`, `h=0,...,36`; VAR(2) canônico e VAR(2)/VAR(6) em 147 resíduos comuns; `script/var_lag_comparison.R` | Na amostra comum, o VAR(6) reduz o logdet (`-11,755` para `-12,981`), mas AIC/BIC preferem o VAR(2) e os parâmetros sobem de 60 para 160. Ambos são estáveis. Yield, câmbio e CDS preservam trajetórias próximas; IPCA e sobretudo IBC-Br são mais sensíveis. AR/MOSW é indisponível no VAR(6), pois `hac_dim=190 >= T=147`; nenhuma diferença pontual é tratada como significativa. |
| [`2026-08-22_var_niveis_aic_tendencia`](2026-08-22_var_niveis_aic_tendencia.md) | 08-22 | **CURRENT** | cinco séries em nível, constante e tendência linear, `p=2` pelo AIC comum, pontos `C_h B_1`, AR 68%/90% com NW(0) | AIC seleciona `p=2`, BIC seleciona `p=1`; `xi_mp=6,797335`, raiz máxima `0,965424`. Validação contra implementação independente, `vars::VARselect` e fixture oficial. |
| [`2026-08-22_var_producao_unica`](2026-08-22_var_producao_unica.md) | 08-22 | **SUPERADA** | célula de produção com IPCA em nível, demais séries em diferença; `p=1`; pontos `C_h B_1`; AR 68%/90% com NW(0) | Preserva a produção imediatamente anterior à decisão de migrar o benchmark para níveis, AIC e tendência linear. |
| [`2026-08-22_var_olea_estacionario`](2026-08-22_var_olea_estacionario.md) | 08-22 | **SUPERADA** | sete células com IBC-Br; AR 68%/95% com NW(0) | Preserva a rodada anterior à decisão de retirar as sensibilidades e trocar o nível superior da apresentação. |
| [`2026-08-22_var_estacionario`](2026-08-22_var_estacionario.md) | 08-22 | **SUPERADA** | cinco observáveis em primeiras diferenças, `p=1`, respostas acumuladas, wild bootstrap e AR | Preservada como vintage histórica da especificação substituída integralmente pela tradução de Olea. Números e artefatos de bootstrap não são citáveis. |
| [`2026-08-20_weak_iv_figura_36m`](2026-08-20_weak_iv_figura_36m.md) | 08-20 | **SUPERADA/INVÁLIDA — VAR estimado em séries não estacionárias** | vintage histórica | Somente a regra de que conjuntos AR do VAR não cobrem pontos do DFM. Números e especificação não são citáveis. |
| [`2026-08-20_weak_iv_ibc_br`](2026-08-20_weak_iv_ibc_br.md) | 08-20 | **SUPERADA/INVÁLIDA — VAR estimado em séries não estacionárias** | vintage histórica | Somente a escolha de composição com IBC-Br. Números e especificação não são citáveis. |
| [`2026-08-18_svar_iv_weak_robust`](2026-08-18_svar_iv_weak_robust.md) | 08-18 | **SUPERADA/INVÁLIDA — VAR estimado em séries não estacionárias** | vintage histórica | Somente a validação do módulo MOSW e do solucionador de conjuntos. Números e especificação não são citáveis. |
| [`2026-08-18_q_checagem_figura_a3`](2026-08-18_q_checagem_figura_a3.md) | 08-18 | **HISTÓRICA, condicionada a `p=6`** | painel 111, `r=5`, `p=6`, quatro células de `q`, 800 réplicas | A sensibilidade de `q` não foi imaterial na escala normalizada, mas a rodada não representa a produção em `p=4`. A decisão de `q` permanece aberta e exige reavaliação na célula corrente. |
| [`2026-08-18_ordem_sugerida_pendencias`](2026-08-18_ordem_sugerida_pendencias.md) | 08-18 | **CURRENT enquanto os 18 itens não fecharem** | os 18 itens abertos de `registro/pendencias.md` em 2026-08-18, logo após o julgamento de `relatorio/checklist_problemas_sdfm_weak_iv.md`; **nota de planejamento, nenhuma estimação, nenhum `.tex` tocado** | A regra de sequenciamento, que não envelhece: **decisão de produção antes do congelamento do texto** — migrar o resumo e depois mudar `q`, `p` ou o painel custa a reescrita duas vezes. A numeração das seis fases envelhece a cada item fechado; a lista viva é o `Índice de itens abertos` do próprio `pendencias.md` |
| [`2026-08-18_precos_cross_instrumento`](2026-08-18_precos_cross_instrumento.md) | 08-18 | **HISTÓRICA para magnitudes, condicionada a `(5,5,6)`** | painel 111, `(5,5,6)`, três instrumentos aninhados, duas janelas | Sobrevive a conclusão qualitativa de que a resposta dos preços não nasce de uma única camada do instrumento. Magnitudes, força e estabilidade não representam a produção em `p=4`. |
| [`2026-08-18_varredura_p`](2026-08-18_varredura_p.md) | 08-18 | **CURRENT** | painel 111, `(r,q) = (5,5)`, `z_jk_bs_purif` × `yield_6m`, amostra completa, 800 réplicas, semente 123; grade pré-registrada `p ∈ {2,3,4,6}`, quatro células; `script/p_selection.R`, novo | **O impacto não se move com `p`.** Pela regra fixada antes de olhar, **26 de 30** pares (variável × `p`) saem *imateriais*, 4 *parciais* e **nenhum material**; `share_in90 = 1` nos 30 pares, tanto em `h ≤ 36` quanto em `h ≤ 12`. Curva, câmbio, EMBI+ e CDS excluem zero a 90% no impacto nas **quatro** células; a magnitude fica entre `−6,5%` e `+11,7%` da produção no bloco-manchete. **A reversão de médio prazo se move** — `yield_6m` cruza de volta em `h = 22` sob `p = 6` e em `h = 15` sob `p = 2`, `cambio_usd` em 12 contra 9 — de modo que o item **fecha corroborando a §4**, que já a descreve como dinâmica conjunta sensível a `p`. **Corrige a própria pendência:** BIC e HQ selecionam `p = 2`, não `p = 1` (AIC `p = 4`), e o mesmo erro estava em `factor_stationarity.R:100`; recomputados em amostra comum, os argmins não mudam. ⚠ **Números inconvenientes:** `p = 6` é a célula **mais forte** da grade (ξ_mp 6,27 contra 5,16-5,77), o que é fato reportado e não justificativa, já que a §3.5 proíbe escolher dimensão por força; nenhuma das quatro alcança ξ_mp ≥ 10; a contagem de horizontes sig90 em `h ≤ 12` se move (câmbio 7 em `p=6` contra 4 em `p=3`); e `asset_ibov` perde até **80%** do impacto sem sair da banda, porque a banda do bloco acionário é larga demais para discriminar. Produção intocada |
| [`2026-08-17_selecao_q_e_fidelidade_amengual_watson`](2026-08-17_selecao_q_e_fidelidade_amengual_watson.md) | 08-17 | **HISTÓRICA, condicionada a `p=6`; questão de `q` aberta** | painel 111, `r=5`, `p=6`, 800 réplicas | A tradução de Amengual--Watson foi validada, mas os números de força e IRF pertencem à vintage em `p=6`. Sobrevive a necessidade de fundamentar `q` na produção corrente. |
| [`2026-08-14_exogeneidade_lead_lag_e_invertibilidade`](2026-08-14_exogeneidade_lead_lag_e_invertibilidade.md) | 08-14 | **HISTÓRICA para números, atual na interpretação do teste** | painel 111, `(5,5,6)`, 2.000 réplicas | Sobrevive a distinção conceitual entre exogeneidade lead-lag e invertibilidade. Os valores correntes em `p=4` estão nos diagnósticos regenerados e na nota de sincronização de 08-25. |
| [`2026-08-13_migracao_producao_painel_111_r5q5`](2026-08-13_migracao_producao_painel_111_r5q5.md) | 08-13 | **SUPERADA por `p=4`; histórica para `(5,5,6)`** | painel 111, `(5,5,6)`, `z_jk_bs_purif`, 800 bootstraps, semente 123 | Migração completa do default; `r=5` por Bai--Ng IC2, `q=5` provisório; `xi_mp/F_rob,mp=6,27085/10,12054` full e `10,99268/9,74746` pré-COVID; raiz pré-COVID 1,0002017; zero falhas e normalização exata |
| [`2026-08-13_decisao_conjunta_painel_dimensoes`](2026-08-13_decisao_conjunta_painel_dimensoes.md) | 08-13 | **SUPERSEDED como decisão** | 64 painéis sem `juros_cdi`/`asset_mlcx`, 2.304 células full, 64 diagnósticos pré-COVID, 192 contrastes e quatro bootstraps de 800 réplicas | A grade e os bootstraps permanecem como proveniência; a recomendação de 123 séries `(4,3)` foi substituída pela produção de 111 séries `(5,5)` |
| [`2026-08-13_parecer_dimensoes_rq`](2026-08-13_parecer_dimensoes_rq.md) | 08-13 | **SUPERSEDED** | painel canônico de 106 séries, amostra completa como alvo, pré-COVID como robustez, `p=6`, `z_jk_bs_purif`, 800 bootstraps por célula | A reprodução BLL/AW e os resultados permanecem válidos para o painel de 106 séries, mas a recomendação `(5,4)` foi substituída porque esse painel deixou de ser o universo decisório |
| [`2026-08-13_selecao_fatores_blocos_fatoriais`](2026-08-13_selecao_fatores_blocos_fatoriais.md) | 08-13 | **HISTÓRICA, experimental e condicionada a `p=6`** | 64 painéis sem as duas quase-duplicatas × duas amostras; Bai--Ng BLL `r=1..20`, Amengual--Watson IC2 com `p=6`; sem ξ_mp, bootstrap ou IRFs | Os critérios automáticos **não** recomendam `(8,8)`: full tem `r_IC2=3..5`, `q_AW=2..3`; pré-COVID dá **(2,2) em 64/64**. IC3 bate o limite `r=20` em 128/128 e não é recomendação operacional. A seleção não muda produção nem substitui os demais critérios de desenho |
| [`2026-08-13_grade_rq_fatorial_sem_duplicatas`](2026-08-13_grade_rq_fatorial_sem_duplicatas.md) | 08-13 | **HISTÓRICA, experimental e condicionada a `p=6`** | 64 painéis em memória sem `juros_cdi`/`asset_mlcx` × duas amostras × 18 pares `(r,q)`, `p=6`, `z_jk_bs_purif`; sem bootstrap ou IRFs | **2.304/2.304** DFM de ponto completaram, sem falhas, N=104--123 e exclusão confirmada das quase-duplicatas. O `baseline` reproduz exatamente a célula anterior `drop_near_duplicates` `(7,6,6)`: **ξ_mp 7,9418 full / 9,6900 pré-COVID**. A grade mede só sensibilidade de ξ_mp; não seleciona especificação pelo maior valor e não muda produção |
| [`2026-08-13_grade_experimental_rq`](2026-08-13_grade_experimental_rq.md) | 08-13 | **HISTÓRICA, experimental e condicionada a `p=6`** | nove painéis em memória × duas amostras, `r ∈ {5..8}`, `q ∈ {3..8}`, `q ≤ r`, `p=6`, `z_jk_bs_purif`; sem bootstrap ou IRFs | **324/324** DFM de ponto completaram, sem falhas e sem pares inadmissíveis. A referência baseline `(7,6,6)` reproduz **ξ_mp 7,65 full / 11,53 pré-COVID**. A grade mede apenas sensibilidade de força à dimensão fatorial: não seleciona especificação pelo maior ξ_mp e não modifica produção |
| [`2026-08-13_teste_experimental_composicao_painel`](2026-08-13_teste_experimental_composicao_painel.md) | 08-13 | **SUPERSEDED como decisão** | nove painéis em memória, `(7,6)`, `z_jk_bs_purif`, 153 meses; produção intocada | As estimações permanecem válidas, mas a conclusão de manter 106 séries caiu quando painel e dimensão passaram a ser escolhidos conjuntamente |
| [`2026-08-13_proposta_composicao_painel`](2026-08-13_proposta_composicao_painel.md) | 08-13 | **PROPOSTA** | painel corrente de 106 séries, `(7,6)`, `z_jk_bs_purif`; nenhuma alteração de produção | A força depende do bloco da curva, não de uma duplicata isolada. Registra cinco classes para teste, condições financeiras externas, setor externo real, situação fiscal, expectativas macroeconômicas e condições de crédito bancário, e fixa a regra de não selecionar variantes pelo maior `xi_mp` |
| [`2026-08-13_blocos_ausentes_do_painel`](2026-08-13_blocos_ausentes_do_painel.md) | 08-13 | **PROPOSTA** | painel de 106 séries, `(7,6)`, `z_jk_bs_purif`; **nada rodado, nada acrescentado, nenhum `.tex` tocado** | **Catálogo operacional** das classes ausentes — a terceira perna do trio de 08-13: a proposta dá o *protocolo*, a medição dá o *diagnóstico*, esta dá *quais séries, com que código e cobertura*. Códigos consultados na API do BCB/FRED em 08-13 quanto a existência, frequência e cobertura — **nunca quanto a efeito**, e os **nomes não são de fonte autoritativa** (a página de metadados do SGS é JS e não respondeu). **Nenhuma candidata SGS trunca a amostra** (todas mensais de 2010-01 ou 2011-03 até 2025-09). Fiscal (**13762** DBGG, **4513** DLSP, **4649** primário, este muda de sinal e não pode ser logado) é a lacuna que fecha a distância entre o que o paper afirma — dominância fiscal — e o que o painel mede. Expectativas Focus: `fetch_olinda()` já existe e `ExpectativasMercadoAnuais` responde para Selic/PIB/Câmbio; insumo já no repo, usado só na purificação. Bloco americano FRED verificado (`DGS10`, `FEDFUNDS`, `DTWEXBGS`, `T10Y2Y`, todos desde 2012-01). ⚠ **Dois achados de verificação que evitam erro silencioso:** (i) **`SP500` do FRED tem janela móvel e começa em 2016-08-15** — entraria truncando o painel em **43 meses** via `drop_na()`, e é desnecessária porque `data/raw/investing/external_factors_daily.csv` já traz o nível do S&P de **2012-01-03 a 2026-01-30** (Yahoo `^GSPC`), o que torna a pendência do §5.1 uma questão de agregação, não de download; (ii) o bloco do BP vem em **triplas `saldo = crédito − débito` que fecham exatamente** (verificado: 22701 = 22702 − 22703; 22707 = 22708 − 22709; 22710 = 22711 − 22712), e há **duas triplas de bens quase gêmeas** cuja distinção eu **não** consegui estabelecer — confirmar no SGS. Regra de desenho derivada da nota de medição: como a padronização BLL dá variância 1 a cada série, **peso de bloco = contagem de colunas**, então blocos novos vão de 3 a 4 séries e **nunca as três pernas de uma identidade** (vale também para `T10Y2Y = DGS10 − DGS2`). Crédito bancário (**21082** inadimplência, **20714** taxa média) é a classe de maior risco de sobrepeso — duas séries agregadas, não uma família por modalidade. Imóveis (**21340** IVG-R) entra por último e sem caso forte: `price_incc` tem comunalidade 0,056 |
| [`2026-08-13_composicao_do_painel`](2026-08-13_composicao_do_painel.md) | 08-13 | **CURRENT** | (7,6), `z_jk_bs_purif`, painel de 106 séries; baseline do script reproduz 7,65/11,53; **nenhuma IRF, nenhum bootstrap, nada em produção modificado, nenhum `.tex` tocado** | Tudo. **Par de medição da nota de proposta acima** — mesma data, caminhos de código independentes, e os números onde se sobrepõem batem exatamente (sem os 7 itens de juros: ξ_mp 1,24 / F 0,95 nas duas; sem as 2 quase-duplicatas: 7,94 nas duas). A proposta define o protocolo das classes a **acrescentar**; esta mede o painel que **já existe**. Separa três perguntas que estavam misturadas sob "o painel é sensível". **(i) Fragilidade a séries individuais não existe:** nas 105 remoções uma-a-uma ξ_mp fica em [5,21; 8,33] full e [8,80; 14,76] pré-COVID, **zero painéis abaixo de 3,84**. **(ii) A dependência é de bloco e é a curva:** sem os cinco vértices ≠ `yield_6m`, ξ_mp = **1,09** (AR ilimitado); em contraste, remover **28 séries de atividade real melhora** ξ_mp (8,08) e remover as 14 de trabalho quase não mexe (7,43). Tamanho de bloco não prevê importância — prevê se o bloco mede o que o instrumento move. **(iii) A dominância é real e medida:** ações têm 8 séries e **1,74 dimensões efetivas** (sobrepeso 2,17× à la Boivin-Ng 2006) e ficam com **39,0% de F4**; câmbio 5→1,59, curva 6→1,64, indústria 12→3,21. Quatro pares com \|ρ\| > 0,95 em diferenças, dois deles a mesma série duas vezes (`juros_selic`×`juros_cdi` **0,9997**, ρ em nível 1,0000, dimensão efetiva do bloco exatamente 1,00; `asset_ibov`×`asset_mlcx` 0,9963). Atribuição fator a fator: F1 = 31,8% indústria + 25,7% trabalho, F5 = 59,9% preços, **F7 = 51,3% EPU**. ⚠ **A leitura de que "r=7 é pago pelo EPU" foi testada e refutada** — sem o bloco EPU o IC2 segue 5 e ξ_mp(7,6) cai só de 7,65 para 7,24; não escrever a versão forte. **A sensibilidade percebida vive na re-ponderação por atacado**, não na realização: painéis balanceados por teto de bloco dão 4,05-7,87 full e **todos superam a produção no pré-COVID** (11,8-16,8), com não-monotonicidade em N que é ruído de re-rotação. Comunalidade mediana 0,533, **16 séries abaixo de 0,20**. Lacunas com código SGS verificado contra a API: **fiscal ausente por completo** (13762 DBGG, 4513 DLSP, 4649 primário) embora a interpretação dos resultados seja de dominância fiscal; reservas (3546); inadimplência (21082), taxa média de crédito (20714), IVG-R (21340); Focus e DGS2 **já estão no repo**, usados só na purificação. ⚠ Códigos de balança comercial e transações correntes **não confirmados** (22708 e 22885 são plausíveis para mais de uma série). **As recomendações foram verificadas quanto a existência e frequência, nunca quanto a efeito** — o protocolo de teste é o da nota de proposta. Código: `script/panel_composition.R` → `output/panel/` |
| [`2026-08-12_correcao_fim_mes_curva`](2026-08-12_correcao_fim_mes_curva.md) | 08-12 | **SUPERSEDED como produção** | (7,6), `z_jk_bs_purif`, painel corrigido de 106 séries | A correção dos 25 meses no arquivo e 23 na amostra permanece válida; magnitudes, bandas e força foram substituídas pela produção de 111 séries `(5,5)` |
| [`2026-08-10_coincidencia_fomc`](2026-08-10_coincidencia_fomc.md) | 08-10 | **CURRENT nos testes 0-3; o teste 4 saiu do código** | (7,6), `z_jk_bs_purif`, vintage 106 séries; fecha o item 10 (Fase 2) do roadmap e a Objeção 1 do council de 08-10 | Tudo. **Confound FOMC não detectado**, pela regra fixada antes dos números. Fecha a única ameaça do council sem registro prévio no repo, e o defeito de origem era um `else`: `data/raw/fomc_dates.csv` nunca existiu, `script/instrument.R` caía em vetor vazio, e a flag `fomc_coincide` era **identicamente FALSE desde que foi escrita** — agora `load_fomc_dates()` **aborta** e `run_all.R` declara o arquivo requisito duro. Datas vêm de `R/data_download/fomc_dates.R`, que **enumera** as páginas de arquivo a partir de `fomc_historical_year.htm` em vez de hard-codar anos (110 datas em 2013-2025, 4 `stopifnot`, exceção documentada de 2020 = 7 agendadas). **A exposição é MAIOR do que o council estimou** — 24 dos 62 dias retidos (38,7%) e **35,5% de Σ\|z\|**, 8 dos top-20, 7 de 8 reuniões em 2025 — o que torna o nulo mais informativo, não menos. **Dois números invertem o sinal da suspeita:** nos **35 dias em que Copom e FOMC caem no mesmo dia** o bloco americano explica **0,5%** da variância da surpresa (F 0,09, p_boot 0,921), o **menor** R² da tabela; e o maior (0,108) está nos **33 dias que o filtro rejeita** — o filtro descarta preferencialmente o dia carregado de notícia americana, mesmo padrão do CDS em 08-09, agora com o regime nomeado. Interações nulas (× 1(fomc) p_boot 0,466; × 1(jk_bs) 0,511). **Quantifica a distinção máscara-vs-valores** que o item 5 do roadmap exigia: ortogonalizar valores custa **0,21** de ξ_mp, re-derivar a máscara custa outros **2,50** — o bloco global explica 0,76% de `e_di_bs` mas **24,7%** de `e_ibov_bs`. **⚠ E o denominador de normalização foi medido, não suposto:** `denom_vs_prod` é 0,730 em `z_jk_us` e 0,856 em `z_jk_bs_glob`, onde parte da magnitude maior **é** aritmética. Timing: a notícia do Fed cai antes da janela na perna de **taxa** (UST 2a 5,00 bp Ter→Qua vs 3,00 Qua→Qui) mas **não** na de ações (S&P 0,54% vs **0,74%**) — o argumento de horário cobre parte da ameaça, não toda. Nada em produção modificado (8 colunas `z_*` bit-idênticas); nenhum `.tex` tocado ⚠ **Corte de 2026-08-10:** o teste 4 (divisão em metades com/sem FOMC) foi removido do script junto com a terceira perna da regra de veredito, que era a única a consumi-lo. A perna **havia passado** e a cláusula de poder não foi acionada, então retirá-la só torna a regra mais permissiva e o veredito não muda (`max |dif| = 0` em toda linha sobrevivente). **Nada do que esse teste produziu é reproduzível ou citável.** Ver `historico_decisoes.md` §2.4 |
| [`2026-08-10_bandas_anderson_rubin`](2026-08-10_bandas_anderson_rubin.md) | 08-10 | **SUPERSEDED em 08-12; a rota reabriu em 09-08, esta nota não** | (7,6), `z_jk_bs_purif`, vintage 106 séries; implementação e artefatos retirados | **Nada é operacional.** Preservada como evidência histórica da tentativa plug-in. A rota AR para o DFM voltou em 2026-09-08 e é produção, mas **por outra implementação e em outra vintage**: os números desta nota não são portáveis, a começar pelo sentido da comparação com o bootstrap (aqui AR mais estreito, na produção corrente mais largo) e por ξ_mp 10,43 contra 6,06. Usar `2026-09-08_bandas_anderson_rubin_producao`. Ver `registro/historico_decisoes.md` §7 |
| [`2026-08-10_roadmap_pos_council`](2026-08-10_roadmap_pos_council.md) | 08-10 | **CURRENT, exceto item 11 SUPERSEDED** | síntese de `pendencias.md` (rev. 08-10) + `pareceres/council_2026-08-10.md`; **nota de planejamento, nenhuma estimação, nenhum `.tex` tocado** | Tudo exceto o item 11. A implementação Anderson-Rubin ali descrita foi retirada em 2026-08-12; as demais fases e decisões permanecem correntes |
| [`2026-08-09_confound_soberano_cds`](2026-08-09_confound_soberano_cds.md) | 08-09 | **CURRENT nos testes A e C; B e D saíram do código** | (7,6), `z_jk_bs_purif`, vintage 106 séries; fecha a lacuna de dado de 07-31 | Tudo. Roda o teste S1 na proxy que faltava: `data/raw/CDS 5y.xlsx` (Bloomberg, `BRAZIL CDS USD SR 5Y D14 Corp`, diário). **O veredito não muda em nenhuma das duas proxies** — interação `x:1(jk_bs)` **negativa nas cinco** séries da janela do evento (CDS −0,191 p 0,170; EMBI −0,182 p 0,092; BRL −0,036 p 0,068). **O CDS é medida estritamente melhor** — 95/95 pares Copom contra 94/95, **0,5%** de variações exatamente zero contra **8,3%**, menor variação exprimível **0,005 pb contra 1,000 pb**, correlação mais forte com o mercado no mesmo dia nas quatro séries — o que **mata a objeção de que o nulo do EMBI era atenuação por arredondamento**. **⚠ Mas endurece uma ressalva:** nos 62 dias retidos o coeficiente do CDS é **claramente não-nulo** (0,140, p_boot **0,003**, contra 0,099/p 0,109 do EMBI), então "menos risco que um dia comum, **não** zero risco" passa de cautela a fato medido. Achado novo: os dias **rejeitados** pelo filtro carregam risco com sinal **negativo** e significativo (−0,285, p 0,010) — o filtro separa dois regimes de sinal oposto, não desprezа ruído. **O resultado mais forte é o teste C:** ortogonalizar ao risco diário incluindo CDS dá ξ_mp **12,68** full (contra 10,72 só-EMBI e 10,43 da produção), o limite inferior mais severo sendo também o instrumento mais forte, com câmbio 0,139 vs 0,150. Auto-teste novo: CDS diário × `cds_5y` mensal do painel, **cor 0,9994** em 156 meses. Infra: `p_boot` agora semeado por célula e reproduz entre rodadas; os de 07-31 são resorteados (coef/`t`/R²/IRFs inalterados). Nada em produção foi modificado. **Escrito no paper em 2026-08-09** como §5.2 de `paper/paper_anpec.tex` (`sec:confound`), reescrita em 2026-08-10 sobre os testes A e C ⚠ **Corte de 2026-08-10:** os testes B (três vias) e D (tabela datada) foram removidos do script, e o que a regra de três vias mediu nesta rodada foi o argumento que matou B. **Nada do que eles produziram é reproduzível ou citável.** Em troca, o teste C ganhou a **máscara re-derivada** nos resíduos ortogonalizados das duas pernas (`z_jk_bs_norisk_mask`, ξ_mp 5,57 full contra 12,68 só-valores, 50 dos 62 dias sobrevivem), que fecha a objeção do council contra o "por completo" de §5.2. Ver `historico_decisoes.md` §2.4 |
| [`2026-08-02_lacunas_revisao_literatura`](2026-08-02_lacunas_revisao_literatura.md) | 08-02 | **CURRENT** | `paper/paper_anpec.tex` §2, pós-corte de material residual; **nota de escrita, nenhuma estimação** | Tudo. Dois conceitos centrais do artigo (dominância fiscal, UIP) aparecem no abstract/introdução/conclusão sem citação de origem própria na Seção 2 — o único elo de dominância fiscal é `goncalves2025`, o trabalho que a **rejeita**. `BEKAERT2013771` foi movido para a Seção 2 nesta rodada; `BERNANKE19991341` segue sem contraparte. **Achado lateral não corrigido:** a citação de `BEKAERT2013771` na Seção 4 o descreve como estudo cross-country, mas o paper (Bekaert-Hoerova-Lo Duca 2013) é sobre o VIX americano — possível imprecisão fora do escopo desta nota |
| [`2026-08-01_tier_list_robustez`](2026-08-01_tier_list_robustez.md) | 08-01 | **PARCIALMENTE SUPERADA** | (7,6), `z_jk_bs_purif`, vintage 106 séries; **nota de triagem — nenhuma estimação nova, nenhum `.tex` tocado** | A hierarquia geral de robustez permanece como registro de planejamento. O benchmark VAR que ela classificava foi invalidado em 2026-08-22 e não sobrevive como evidência. Para esse objeto, usar somente `2026-08-22_var_olea_estacionario`. |
| [`2026-08-01_robustez_heterocedasticidade`](../arquivo/heterocedasticidade/notas/2026-08-01_robustez_heterocedasticidade.md) **(arquivada)** | 08-01 | **CURRENT** | (7,6), `z_jk_bs_purif`, vintage 106 séries; escopo mensal por decisão do autor | Tudo. Responde a "a identificação por heterocedasticidade corrobora o proxy?" com **não é possível responder, porque a identificação não existe na frequência mensal** — e a demonstração é muito mais forte que a de 07-16: **252 células** (`p ∈ {5..8} × q ∈ {5..8} × r ∈ {7,8}`, `q ≤ r`, × 2 janelas) × **5 desenhos de regime**, três deles novos. **Zero identificam, e não é severidade de correção**: sob Holm *interno* ao desenho (28 testes, não 252) continua zero nos cinco. **Duas condições necessárias falham em separado** — posto (`calendario` rejeita em **0%** das células nas duas janelas, mediana 0,56/0,45, confirmando 07-16 como não-artefato de spec) e **distinção dos autovalores generalizados** (gap relativo mediano **0,11-0,17**, corte 0,20). **Nenhuma IRF foi produzida, de propósito**: sem coluna separável o número não teria identificação atrás. **O desenho que explica é novo:** `volatilidade_juros` concentra o regime C no pós-2020 (`share_C` **0,478 contra 0,051**) e **não rejeita proporcionalidade em nenhuma das 56 células** — o surto pós-2020 é **fator de escala comum**, não mudança de composição; e a varredura livre de `quebra_livre` *encontra* 2020-2022 em 25 das 28 células da janela cheia. **⚠ Não citar as 21 células** que passam as duas condições em nível bruto: **17 estão em `q = 5`** (menor da grade), todas na janela cheia, nenhuma sobrevive à correção mais leniente — é fragilidade de especificação. **Fecha a pendência do benchmark GRG sem estimar nada**: a réplica em Python do referee2 sobre os **nossos** dados diários dá o real **apreciando 4,53% por 100bp**, **dentro do IC 95% do GRG** ([−6,57; −3,63]), e o teste de proporcionalidade dá **LR 135,1, p_boot 0,005** no diário contra nenhuma rejeição em 252 células mensais — o desacordo de sinal do câmbio é de **frequência e propagação, não de identificação**. **Variável inconveniente a reportar junto:** o mesmo `b_1` diário dá IBOV **+2,83%** por 100bp (sinal errado), participação espectral 0,0015 — ações não identificadas naquele sistema. **Não pode ser escrito como corroboração.** Ponta solta declarada: GARCH-SVAR (het *condicional*) não foi tentada. Nada em produção foi alterado |
| [`2026-08-01_robustez_identificacao`](../arquivo/nao_gaussiana/notas/2026-08-01_robustez_identificacao.md) **(arquivada)** | 08-01 | **CURRENT** | (7,6), `z_jk_bs_purif`, vintage 106 séries, GMR reestimado com nboot=800 e 200 partidas | Tudo. Responde a "as IRFs de het e não-gaussiana corroboram as do instrumento?". **A pergunta junta três coisas:** a het **primária** seria identificação alternativa e **nunca produziu uma IRF** (reprovada no gate em 07-16: `Σ_C ∝ Σ_NC` nunca rejeitada em 20 células, placebo p 0,26-0,86 — a variância mensal muda de nível, não de composição); a het como **instrumento** produziu IRFs que corroboram bem (`z_het_jk` em (7,6) full: yield_2y +0,00846 vs +0,00916 da produção, câmbio +0,1255 vs +0,1498) mas **é o mesmo proxy-SVAR com outro `z`**; só a **não-gaussiana** cruza a hipótese identificadora. **Veredito do GMR: corrobora o curto prazo em direção, não em inferência.** Concordância de sinal **0,971** nas 140 células sig90 do proxy (todas h ≤ 12), razão de magnitude mediana **1,11**, e **1,000 em curva de juros (35), câmbio/risco soberano (16) e preços (19)**. **O único bloco que falha é atividade (0,733)** — as 4 discordâncias do painel inteiro estão nele. Fora disso: 0,246 em h 13-24 e 0,363 em h 25-48 nas células só-sig68, então **nada de médio prazo é corroborado**. **O GMR não determina nada por conta própria** — 1 célula sig90 (a normalização) contra 140, bandas 5,4× mais largas, ponto do proxy dentro do CI90 em **100% das 5.194 células**. **O número publicado no `results.md` estava selecionado**: as 8 manchete dão 8/8 no impacto, o painel de 106 dá 0,660. **⚠ O teste do nulo derruba a manchete como afirmação estatística** (`script/nongaussian_labelling.R`): sob **2.000 direções aleatórias** normalizadas ao mesmo choque de +50bp, a concordância mediana nas sig90 já é **0,786** e **um quarto delas iguala ou supera a coluna rotulada** (p = 0,179); no bloco da curva o nulo tem mediana **exatamente 1,000**, porque normalizar na taxa força a curva a co-mover. A métrica **satura** — isso não prova que o GMR não corrobora, prova que **concordância de sinal não é evidência de que corrobora**. Sobrevive o **não-contradiz** (ponto do proxy dentro do CI90 em 100% das células) e a **rejeição do esquema recursivo** (ξ = 149,3). **Rotulagem sem `z` testada e o resultado é ruim**: as quatro regras **discordam** — R0 (`\|cor(ε,z)\|`) e R3 (FEVD do bloco da curva) escolhem a coluna 2, mas R1 (impacto em `yield_6m`) e R2 (FEVD de `yield_6m`) escolhem a **coluna 1, que concorda só 0,600 e responde com um quinto da magnitude**. A coluna que melhor corrobora (3: 1,000 nas sig90, 0,907 global) **nenhuma regra escolhe**. Fecha a pendência `pendencias.md:751-754` com resposta negativa: **a coluna monetária não é bem definida sem o instrumento neste painel**. Sugestivo mas nunca significativo: a coluna 2 é a melhor das seis em razão de magnitude (1,11× contra 1,8× de uma direção típica, p = 0,125) e em cosseno com a direção do proxy (0,620 vs mediana 0,315, p = 0,134). **Dois defeitos de processo corrigidos:** o cache era de safra anterior ao painel (3 séries ×100: `cds_5y`, `msci`, `sp500_vix` — invariante para sinal/cobertura) e o run de produção **não achava o ótimo do gate** (logLik −1209,61 com 60 partidas contra −1209,30; agora −1208,60 com 200). Bandas **não** estreitaram com 4× mais draws, como previsto. Nada em produção foi alterado; nenhum `.tex` tocado |
| [`2026-07-31_acoes_representacao`](2026-07-31_acoes_representacao.md) | 07-31 | **CURRENT** | (7,6), `z_jk_bs_purif`, vintage 106 séries | Tudo. Responde ao item "ações entram como retorno acumulado" do council review de 07-31. **O resultado nulo do bloco acionário é MECÂNICO**: em log-nível o bloco vai de **0 para 39** células sig90 (28 em nível simples), **todas em h=0-5**, em **7 dos 8** índices. O ponto dobra e a banda encolhe — Ibovespa −1,67 [−7,77; 1,76] → **−3,68 [−8,70; −0,86]**; IMOB −2,89 → −6,52; proxy de \|t\| em h=0 de **0,676 para 1,826**. **A banda inflada era inteiramente o `cumsum`**, provado no mesmo modelo: a célula `prod_nocum` reproduz o ponto de produção após cumular a **0,00e+00** mas não a banda; razão h36/h0 nos 8 índices **10,46 → 0,84**. **O pico de +20,3% em h≈24 era erro acumulado** — o comentário de `arquivo/tex/main.tex:445` (arquivado) estava certo, e o nível remove o artefato na origem (h24 +20,26 → +1,40); a armadilha de pontuação do benchmark VAR deixa de existir. **O resto do modelo não se mexe**: 79 dos 92 pares sig90 sobrevivem, manchetes não-acionárias quase idênticas. **⚠ O preço:** log-nível custa força — ξ_mp **10,43 → 8,94** no full (abaixo de 10) e **pré-COVID quebra** (ξ_mp 3,91, companion **explosiva 1,0030**). A variante fiel a AK é a **mais fraca**: nível simples mantém ξ_mp 10,23. **Decisão do autor: o log-nível fica de lado** (`historico_decisoes.md` §3.1) e só o `cumsum` será corrigido — e **isso não recupera o bloco**: 1 célula sig90 de 392, **0 de 8 em h=0**, invariante por construção (em h=0 o `cumsum` é no-op). O que a correção entrega é limpeza de artefato: razão de banda 10,46 → 0,38, fim do pico falso de +20,3%, e sig68 em h≤12 de **19 para 35**. Nada muda na produção |
| [`2026-07-31_benchmark_var_vs_dfm`](2026-07-31_benchmark_var_vs_dfm.md) | 07-31 | **SUPERADA/INVÁLIDA — VAR estimado em séries não estacionárias** | vintage histórica | A extração do motor VAR permanece como proveniência de código. Números, figuras e conclusões econométricas não são citáveis. |
| [`2026-07-31_estacionariedade_fatores`](2026-07-31_estacionariedade_fatores.md) | 07-31 | **HISTÓRICA para a decomposição VAR(6)** | `(7,6,6)`, painel de 106 séries | A evidência sobre integração dos fatores pertence àquela vintage. A atribuição da reversão ao par complexo dominante não se transfere à produção em `p=4`, cuja raiz dominante é real. |
| [`2026-07-31_confound_soberano_jk`](2026-07-31_confound_soberano_jk.md) | 07-31 | **CURRENT nos testes A e C; B e D saíram do código** | (7,6), `z_jk_bs_purif`, vintage 106 séries | Tudo. Responde ao item mais grave do council review de 07-31. **A acusação não se sustenta**: num dia comum a variação de DI carrega risco (coef 0,326, R² 0,13); nos 62 dias retidos cai para 0,099 (R² 0,04) e no câmbio some — as interações são **negativas** nas quatro proxies da janela do evento. Ortogonalizar ao risco diário mantém ξ_mp (10,72 vs 10,43) e todas as manchetes sig90. Nada muda na produção ⚠ **Corte de 2026-08-10:** os testes B (três vias) e D (tabela datada) foram removidos do script e `jk_sovereign_days.csv` foi apagado. **Nada do que eles produziram é reproduzível ou citável.** Ver `historico_decisoes.md` §2.4 |
| [`2026-07-27_robustez_xi_mp_e_construcao`](2026-07-27_robustez_xi_mp_e_construcao.md) | 07-27 | **CURRENT** | (7,6), `z_jk_bs_purif`, vintage 106 séries | Tudo. **Nenhuma decisão de produção mudou** — o exercício confirmou a construção herdada. ξ_mp: conjunto AR limitado sob qualquer amostra a menos de um mês (0/147 abaixo de 3,84), mas "bandas convencionais valem" é marginal (24/147 abaixo de 10); NW(0) é conservador. Vértice: 126 du **não** é o argmax, mas as diferenças são menores que o ruído LOO, e **os 13 vértices dão a mesma IRF** (overlay A4). Agregação GK colapsa ξ_mp para 0,30, como previsto antes de rodar — `yield_6m` é de fim de mês, e a nota 11 do GK condiciona a ponderação a indicador de média mensal |
| [`2026-07-27_identificacao_nao_gaussiana_gmr`](../arquivo/nao_gaussiana/notas/2026-07-27_identificacao_nao_gaussiana_gmr.md) **(arquivada)** | 07-27 | **tese válida, números superados** | (7,6), `z_jk_bs_purif`, **nboot 200 / 60 partidas, pré-fix B1** | A tese sobrevive e ficou mais forte: GMR implementado e validado contra a aplicação publicada, **o estimador não tem poder neste painel**, a rejeição assintótica da restrição do proxy é espúria (Prop. 4 subcobre 0,79 em T=150, n=6), o gate só passa no full sample por causa da COVID, e serve como **teste**, não como estimativa. **Não cite os valores:** aquela corrida não alcançava o ótimo do gate (logLik −1209,61 vs −1209,30) e rotulava a coluna 6, e o cache era anterior ao fix B1 (`cds_5y`, `msci`, `sp500_vix` 100× errados). Números correntes em [`2026-08-01_robustez_identificacao`](../arquivo/nao_gaussiana/notas/2026-08-01_robustez_identificacao.md) |
| [`2026-07-24_avaliacao_5_artigos_robustez`](2026-07-24_avaliacao_5_artigos_robustez.md) | 07-24 (+ adendos até 07-27) | **parcialmente superada** | (7,6), `z_jk_bs_purif` | Corpo + Adendos 1-3: o toolkit **ACF (2024)** segue aberto e intocado, e o `IdSS` é mesmo o código de referência do GMR — **mas está quebrado para n ≥ 4**. **Caiu o Adendo 4**: recomendava acoplar o GMR, que foi implementado em 07-27 e não tem poder. O veredito de venue (**ANPEC**) sobrevive |
| [`2026-07-24_auditoria_analise_gemini`](2026-07-24_auditoria_analise_gemini.md) | 07-24 | premissa corrigida | (6,5), pré-refresh | A refutação técnica (F conjunta não é a estatística que governa; ξ_mp é). **Não vale** o enquadramento de "proxy abandonado", nem a recomendação P1, nem o ajuste conexo de P4 ("incluir um preditor de metais na purificação") — o placebo que o motivava não está violado |
| [`2026-07-15_auditoria_identificacao_vs_alessi`](2026-07-15_auditoria_identificacao_vs_alessi.md) | 07-15 | superseded | (6,5)/(8,8), pré-refresh | A verificação do port R↔MATLAB (5/5) — independente de spec e vintage. É a referência de fidelidade do projeto |
| [`2026-07-15_sweep_instrumentos_irf`](2026-07-15_sweep_instrumentos_irf.md) | 07-15 | superseded | 6 instr. × 3 (r,q), pré-refresh | **Relevância ≠ validade**: a inversão da curva é ortogonal à força do instrumento. Derruba a afirmação central da nota de 07-11 |
| [`2026-07-15_reacao_por_variavel`](2026-07-15_reacao_por_variavel.md) | 07-15 | superseded | idem, pré-tcode-fix | A escolha de instrumento quase não move as IRFs; **a amostra é que dirige tudo**. Linhas `asset_*` fora de escala |
| [`2026-07-15_irf_rq_candidates`](2026-07-15_irf_rq_candidates.md) | 07-15 | superseded (auto-marcada) | `z_jk_bs_purif`, pré-refresh | Recomendou (7,6), que **virou produção em 07-24** por outro motivo. As "Ressalvas para periódico" seguem abertas |
| [`2026-07-14_auditoria_fidelidade_jk_bs`](2026-07-14_auditoria_fidelidade_jk_bs.md) | 07-14 | conclusão adotada | (6,5), pré-refresh | *A força mora na máscara, não nos valores* — **confirmado independentemente em 07-26**. Justifica o instrumento primário; alimenta §3.4 + Apêndice B |
| [`2026-07-14_ordem_purificacao_jk`](2026-07-14_ordem_purificacao_jk.md) | 07-14 | decisão revertida | (6,5), pré-refresh | O mecanismo da máscara 2020-03-19 e o descarte de `z_jk_raw_purif_local`. A recomendação "default fica" durou 24h |
| [`2026-07-12_irf_dentadas`](2026-07-12_irf_dentadas.md) | 07-12 | vintage antigo | `z_jk_purif` (6,5) | O mecanismo inteiro (raízes complexas de 3-4 meses do VAR(6) × baixa comunalidade). Não depende de instrumento nem de (r,q) |
| [`2026-07-12_price_puzzle_ipca`](2026-07-12_price_puzzle_ipca.md) | 07-12 | **SUPERSEDED** por [`2026-08-18_precos_cross_instrumento`](2026-08-18_precos_cross_instrumento.md) | `z_jk_purif` (6,5) | Nada de numérico. A rodada de 08-18 **contradiz** o ponto 2 (o filtro de sinal atenua a corcova, não é neutro) e o ponto 3 (o pré-COVID não é negativo em todos os horizontes). Sobrevive a leitura de literatura do §5 |
| [`2026-07-12_irf_credito_ativos_financeiros`](2026-07-12_irf_credito_ativos_financeiros.md) | 07-12 | superseded | `z_jk_purif` (6,5), pré-tcode-fix | O mapeamento de literatura e o diagnóstico da janela de scoring dos spreads. **Todas as magnitudes morreram** |
| [`2026-07-11_varredura_irf`](2026-07-11_varredura_irf.md) | 07-11 | **contraditada** | `z_jk_purif` (6,5) | A taxonomia das três Fs (§2) e o desenho do grid. **"F ≥ 10 ⇒ sinais certos" é falso** — ver a nota de 07-15 |

## Fora desta pasta

- `pareceres/2026-07-15_auditoria_fidelidade_instrumento.md` — versão
  completa da auditoria de fidelidade; é o documento que motivou a troca de
  instrumento primário. Mesmo vintage antigo, mesma conclusão viva.
- `registro/estrutura_paper_v2.md` — roteiro seção-a-seção do paper com o mapa
  artefato → seção.

## Movidas para `arquivo/` com as rotas abandonadas (2026-08-17)

Três notas saíram de `notas/` quando as duas estratégias de identificação foram
abandonadas. Continuam citáveis, no novo caminho:

| nota | destino |
|---|---|
| `2026-07-27_identificacao_nao_gaussiana_gmr.md` | `arquivo/nao_gaussiana/notas/` |
| `2026-08-01_robustez_identificacao.md` | `arquivo/nao_gaussiana/notas/` |
| `2026-08-01_robustez_heterocedasticidade.md` | `arquivo/heterocedasticidade/notas/` |

## Arquivadas em `arquivo/relatorio/`

Todas do track de heterocedasticidade, abandonado como instrumento em 2026-07-16
e por inteiro em 2026-08-17. Preservadas porque documentam resultados negativos;
nenhuma descreve a identificação corrente.

| arquivo | o que era |
|---|---|
| `2026-04-25_blindspot_het_instrument.md` | Ruling condicional sobre `z_het_jk`; propunha reposicionar o paper em torno de identificação por variância |
| `2026-04-26_blindspot_validation.md` | Auditoria da suíte T1-T4; apontou que a F do JK fica *no* percentil 99 das máscaras aleatórias |
| `correspondence/referee2/2026-04-25_round1_report.md` | Referee interno round 1 — *Minor Revisions* sobre o bloco het |
| `correspondence/referee2/2026-04-26_round2_report.md` | Round 2 — *Accept*. Contém o único achado não-het reaproveitado: janelas não-contíguas exigem residualização AR full-sample antes do subset (registrado em `historico_decisoes.md` §4) |
| `correspondence/referee2/replication/` | Réplica NumPy do bloco Rigobon-Sack + CSVs de saída (10 arquivos) |
