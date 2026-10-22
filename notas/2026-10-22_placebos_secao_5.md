# Placebos na §5.2 e o teste do EPU na base de 111

> **CURRENT — 2026-10-22.** Dois itens do passo 3 de `registro/pendencias.md`: "Placebos na §3.3 e
> `fig:placebos`" e "Escrever o p = 0,54 do teste do EPU". Vêm dos e-mails de 03-10 (passo 4), 08-10
> (item 4), 12-10 (item 4) e 19-10 (item 5). Branch `feature/auditoria-janelas-copom`, **não mergeada**.
> - **O que não mudou.**
>   - O instrumento e as IRFs.
>   - `instrument.R` rodou de novo só para gravar os preditores BS em `copom_event_diagnostics.csv`. Os
>     cinco arquivos do instrumento saíram com o mesmo md5, as colunas que já existiam são idênticas e
>     `validate_production_spec.R` passa.
>   - Em `output/placebo_holm/`, `table.csv` e `orthogonalization.csv` saíram sem diferença.
> - **Decisões do autor em 22-10, antes de escrever.**
>   - Os placebos vão numa subseção própria, §5.2 Placebos (`sec:placebos`), entre o VAR e a influência,
>     que passa a 5.3. O parágrafo de placebos da §3.3 sai inteiro.
>   - A tabela dos 18 testes vai no Anexo D, depois da `fig:placebos`, com as colunas série, h, p e p de
>     Holm.
>   - O p do EPU vai numa frase do parágrafo, reestimado nas 111.
>   - As ressalvas do MSCI e do VIX em h0 vão no parágrafo, e a do VIX leva a fração recalculada nas 111.
>   - Holm é nomeado sem `\cite`, porque o orçamento é de 25 chaves.
>   - A diferença entre Holm e o Wald conjunto por série vai em rodapé.
>   - A `fig:placebos` perde os marcadores.
>   - O texto lê os pontos sem ajuste só pelo nível de significância. Os p ficam na tabela.
> - ⚠ O p = 0,54 era das 102 reuniões. Nas 111, o p é 0,275 (seção 1).
> - ⚠ `fig_section5.R` reescreveu também as oito figuras da §4. Elas mudam só nos metadados do PDF, e a
>   rasterização é idêntica. O hook barra `git restore`, então elas ficam modificadas na árvore de
>   trabalho.

## 1. O EPU na regressão BS

O teste é o da branch `feature/placebo-epu` (nota `2026-09-29_placebo_epu`, só naquela branch).
- `pre_epu` = 100 × (log da média do EPU diário dos EUA nos 91 dias corridos até a quarta − log da média
  nos 91 dias anteriores).
- O preditor entra como décimo na regressão BS da surpresa do DI de 6 meses.
- H0: o coeficiente é zero, teste t com EP HC1.

A parte C de `script/placebo_holm.R` monta a fórmula com os preditores de `bs_orthogonalization.csv`.
- Guard: sem `pre_epu`, o ajuste reproduz os coeficientes de produção a 1e-10.
- O `lm()` usa `na.fail`, de modo que nenhuma reunião sai em silêncio.
- O insumo é `data/raw/epu/us_daily_policy_uncertainty.csv`, baixado em 09-29 pela branch do EPU. O
  download foi trazido para o `download_macro_news.R` desta branch, mas não rodou de novo.

| amostra | coeficiente (EP HC1) | t | p | R² com `pre_epu` |
|---|---|---|---|---|
| 102 reuniões, como na branch do EPU | −0,028 (0,046) | −0,61 | 0,543 | 0,128 |
| 111 reuniões, produção | −0,051 (0,047) | −1,10 | 0,275 | 0,107 (0,094 sem) |

- **Conferência das 102.** São as 111 menos as 7 janelas de quarta a sexta e as 2 quartas de véspera de
  Ação de Graças, 2013-11-27 e 2015-11-25. Rodou no scratch, sem commit, e reproduz a branch nos três
  decimais. A construção de `pre_epu` é, portanto, a mesma.
- **Leitura nas 111.** Na especificação, não há evidência de que a tendência do EPU antes da reunião
  preveja a surpresa. O teste olha uma variável, numa janela, pela média condicional, e não valida a
  exogeneidade.
- `output/placebo_holm/epu_predictive.csv` guarda estimativa, EP, t, p, n e R² com e sem o EPU.

## 2. A sobreposição do VIX em h0

O VIX do painel é o fechamento do mês, então a resposta em h0 cobre o mês do instrumento, isto é, o mês
da primeira sessão do DI depois do anúncio. Os dias desse mês até o fechamento da quarta caem dentro da
janela de 65 pregões de `pre_vix`. Quando a quarta cai no mês anterior, a sobreposição é zero.

A parte D de `script/placebo_holm.R` grava, por reunião, a fração dos dias corridos do mês até a quarta,
inclusive (`output/placebo_holm/vix_h0_overlap.csv`).

| amostra | média | mediana | reuniões com zero | máximo |
|---|---|---|---|---|
| 102 | 45,5% | 50% | 7 | — |
| 111 | 46,0% | 51,6% | 7 | 96,8% |

- Nas 102, a definição em dias corridos reproduz a nota `2026-10-09_placebos_holm` (seção 3): 45%,
  mediana 50% e 7 zeros. Em dias úteis, a média seria 46,0%, e a de 10-09 era 45%. Isso aponta para dias
  corridos.
- Nas 111, o coeficiente de `pre_vix` é 0,012 (p 0,95), conforme a nota `2026-10-20_saidas_base_111`,
  seção 4. A restrição pesa pouco na prática.

## 3. O texto

- **§3.3.** O parágrafo de placebos saiu. A §3.3 termina no parágrafo da ortogonalização.
- **§5.2 Placebos**, um parágrafo:
  - aponta para a `fig:placebos` e a `tab:placebos_holm`, no Anexo D;
  - dá o teste AR de resposta nula em h = 0, 1, 3, 6, 12 e 24, horizontes fixados antes, com Holm nos
    18 testes;
  - lê o resultado: nenhuma rejeição depois do ajuste, o que não comprova exogeneidade e pode refletir
    pouca precisão;
  - sem ajuste, o MSCI cai e é significante a 95% em h1 e h3 e a 90% em h0 e h6, o VIX é significante a
    90% em h6, e o EPU não é significante em nenhum dos seis horizontes;
  - traz a limitação do MSCI (peso do Brasil, repercussão do choque, notícias comuns aos emergentes);
  - traz o VIX em h0, com 46%, e diz que de h1 em diante não há restrição;
  - traz o EPU como décima notícia, com p 0,275.
- **Rodapé da §5.2.**
  - Holm controla a probabilidade de ao menos uma rejeição falsa entre as 18 comparações pontuais e usa
    os próprios p do teste AR.
  - Não é um Wald conjunto, que testaria de uma vez todos os horizontes de uma série, levando em conta a
    correlação entre eles.
- **Anexo D.**
  - A legenda da `fig:placebos` diz que os conjuntos são pontuais por horizonte, sem correção para
    múltiplos horizontes, e aponta para a tabela.
  - A `tab:placebos_holm`, nova, tem 18 linhas com série, h, p e p de Holm, digitadas de
    `output/placebo_holm/table.csv`.
- A §5 tem agora três subseções: 5.1 Benchmark VAR, 5.2 Placebos e 5.3 Reuniões influentes e movimentos
  externos extremos.
- `paper.tex` compila sem erro, sem referência indefinida e sem overfull. O aviso de fonte TS1/aer vem do
  "1º" do rodapé da §3.3 e é anterior a esta rodada.

## 4. O código

- `script/download_macro_news.R`: o download do EPU diário dos EUA, trazido da branch do EPU. O
  `run_all.R` lista o arquivo entre os produtos do estágio `macro_news`.
- `script/instrument.R`: `copom_event_diagnostics.csv` leva também `pre_*` e `news_*`. Os leitores do
  arquivo (`daily_event.R`, `event_trajectory.R`, `monthly_reduced_form.R`, `meeting_influence.R`,
  `copom_timing.R` e `validate_production_spec.R`) selecionam colunas pelo nome.
- `script/placebo_holm.R`: as partes C e D.
- `script/fig_section5.R`: saem os marcadores de significância, que só a figura de placebos usava, junto
  com a coluna `mark_sig90`, o argumento de `irf_panel()` e a coluna `sig`.

## 5. O que fica de fora

- ⚠ Fora dos seis horizontes da família, o cache `irf_coherence_cell.rds` dá outros pontos significantes a
  90%:
  - MSCI de emergentes: h4 e h7, negativos, e de h35 em diante, positivos (h35–h42; a figura vai até h36);
  - VIX: h2 e h5;
  - EPU: nenhum.

  O texto não os menciona, e a pendência não os pedia. Como diz o e-mail de 08-10, a contagem deles não é
  evidência conjunta.
- Wald conjunto por série e bandas simultâneas, que o e-mail de 08-10 dispensa.
- A resposta ao orientador.
