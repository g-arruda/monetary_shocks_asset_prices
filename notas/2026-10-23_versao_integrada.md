# Versão integrada: resumo, introdução e conclusão coerentes com a ponte

> **CURRENT — 2026-10-23.** Passo 4 de `registro/pendencias.md`, itens "Versão integrada" e "Ressalvas da
> linha diária no resumo". Branch `feature/auditoria-janelas-copom`, **não mergeada**.
> - Nada foi reestimado, e só `paper/paper.tex` e o registro mudam. Os números novos vêm do cache
>   (`output/irf/irf_coherence_cell.rds` e `irf_coherence_h.csv`). As afirmações de significância da
>   conclusão vêm da `tab:influencia`, da `tab:ponte`, da `tab:placebos_holm` e do parágrafo do Anexo E.
> - A fonte é o e-mail do orientador de 19-10 (item 5 e último parágrafo) e o de 12-10 (item 5). A
>   §4.2 já tinha a frase do item 5 desde 22-10 e não mudou.
> - Cada trecho foi rascunhado no chat e só foi ao `.tex` depois do ok do autor.

## 1. Decisões do autor em 23-10, antes de escrever

| tema | decisão |
|---|---|
| ponte na introdução | no fim do 2º parágrafo, sem números |
| ponte na conclusão | no fim do 1º parágrafo, sem números, com o DFM e o evento diário lado a lado |
| ponte no resumo | uma frase, sem números |
| resultados menos favoráveis | parágrafo novo na conclusão, depois do dos demais resultados |
| atividade negativa e NFSP primária positiva | na conclusão, e no resumo uma oração sem números |
| "sincronia" (resumo, introdução, conclusão) | trocada por fato descritivo |
| regra de JK na introdução | sai, e a frase passa a ter as duas camadas e a relevância e a força como na §3.4 |
| ressalvas da linha diária | resolvidas nesta rodada, com os fatos e sem atribuir a divergência |
| frases causais | a linguagem do item 5 entra só na conclusão |
| fase positiva das ações | na própria frase da conclusão |
| desemprego e ocupação | um parágrafo novo no fim da §4.5, sem mexer na figura, e a conclusão remete a ele |
| roteiro da introdução | corrigido para §5 Robustez e §6 conclusão, sem citar os anexos |
| `\renewcommand` de Figura/Tabela | fora desta rodada, continua como ⚠ aberto |

Depois de ver os rascunhos, o autor aceitou as três propostas que estavam em aberto:
- a primeira frase do 2º parágrafo da introdução e a do 1º parágrafo da conclusão passam a afirmar o fato,
  sem dizer que o risco causa a depreciação;
- sai inteira a última frase do parágrafo de goncalves2025 na conclusão, "sem autorizar a heterocedasticidade
  como estratégia alternativa";
- o desemprego entra como parágrafo próprio.

Ficam como estavam: o título, o "dominates" do resumo, o "domina" e a frase da dominância fiscal da
introdução, a §4.2, e o "esse canal de prêmio de risco opera em paralelo" da conclusão.

## 2. O que mudou no `.tex`

**Resumo.**
- Entra a ponte, depois de "This joint response points to…".
- "Before reversing in close synchrony" passa a dizer que os pontos da curva, do câmbio e do risco mudam de
  sinal com poucos meses de diferença.
- Entra uma oração sobre a atividade abaixo de zero nos três anos e o déficit primário maior no médio prazo.
- A frase do het passa a dizer que a condição vale no diário, com p que sobe com o vértice e depende da
  correção de curtose, e falha no mensal. "Pointing to frequency and identification strategy" sai.

**Introdução.**
- A primeira frase do 2º parágrafo diz que o aperto deprecia a moeda e eleva o prêmio de risco.
- A "estreita sincronia" vira os pontos mudando de sinal em meses próximos.
- No fim do parágrafo entra a ponte: a apreciação na 1ª cotação é imprecisa e não é significante a 90%. A
  depreciação e o CDS ficam significantes em cotações posteriores, o CDS antes. A forma reduzida mensal tem
  pontos positivos. A leitura do item 5 fecha o parágrafo.
- A frase do instrumento perde o JK e o "complementar ao F robusto". Passa a ter as duas camadas, o primeiro
  estágio, ξ_mp e os conjuntos AR limitados nos dois níveis.
- O parágrafo de goncalves2025 passa aos fatos: a condição vale no diário a 5% nos três vértices, e com Holm só
  no de 3 meses, e depende da correção de curtose. No mensal, não vale em vértice nenhum nem nas inovações
  fatoriais. A frase "frequência dos dados e estratégia de identificação" sai.
- No roteiro, a §5 passa a ser a robustez (VAR, placebos, influência e extremos) e a §6 a conclusão.

**§4.5, parágrafo novo antes da `fig:atividade`.** Fala do desemprego e da ocupação da PNAD Contínua, que
a figura não mostra:

| série | impacto | depois | significância a 90% |
|---|---|---|---|
| desemprego (SGS 24369, p.p.) | −0,12 | vale de −0,19 em h6, positivo a partir de h18, 0,25 em h36 | h0–h6 e h36 |
| população ocupada (SGS 28543, mil pessoas) | +246 | 399 em h6, negativa a partir de h19 | só h0 |

**Conclusão.**
- **1º parágrafo.** "Incompatível… regime em que o aumento da taxa piora a percepção" vira "difícil de
  reconciliar com o canal tradicional". No fim entra a ponte, que termina na leitura do item 5.
- **2º parágrafo.** A "reversão altamente sincronizada" passa a dizer que curva, BRL/USD, EMBI+ e CDS mudam
  de sinal em h15 ou h16. O ramo negativo é significante a 90% só nos últimos meses na curva e no risco, e
  só a 80% no câmbio, o que indica direção e magnitude.
- **3º parágrafo.**
  - "O mercado de trabalho responde com defasagem" sai. Entram as horas caindo no impacto, o desemprego
    caindo até h6 e a ocupação subindo no impacto.
  - Entram a atividade abaixo de zero nos três anos e a NFSP primária positiva (déficit maior), significante a
    90% a partir de h21.
  - As ações passam a não ser significantes a 80% no impacto, com a fase positiva significante a 90% em
    parte dos meses nos sete índices.
- **Parágrafo novo**, depois do 3º, com quatro resultados menos favoráveis:
  - a surpresa bruta, significante a 90% e não a 95% em h0;
  - a influência: sem as 5 reuniões, o câmbio não é significante a 90% em h0–h2, e sem as 10 a inferência é
    inconclusiva, o que não indica resposta nula;
  - os extremos: o CDS fica estável, o câmbio perde magnitude e precisão, e as três maiores quedas são de
    reuniões do Brent;
  - os placebos: Holm não rejeita, o que não comprova exogeneidade, e o MSCI sem ajuste é significante a 95%
    em h1 e h3, como limitação. O VIX em h0 não é independente da ortogonalização.
- **goncalves2025.** O `\citep` sai dos parênteses. Entram os mesmos fatos da introdução, e no mensal os
  autovalores do VAR praticamente coincidem. A frase de atribuição sai.
- **Política.** A primeira frase fica. "A credibilidade fiscal… condiciona a direção" e "oferece uma
  explicação alternativa" saem, e o parágrafo diz que a depreciação vem junto com a alta do risco, o que é
  consistente com o risco pesando ao lado do diferencial de juros.

## 3. O que pode e o que não pode ser dito

- Pode dizer que a depreciação e a alta do CDS em horizontes posteriores aparecem também fora do DFM, o que é
  consistente com uma transmissão associada ao risco. Não pode dizer que o risco causa a depreciação.
- Pode dizer que os cruzamentos de zero da curva, do BRL/USD, do EMBI+ e do CDS ficam em h15–h16. Não pode
  chamar a reversão de "sincronizada" nem dizer que ela é significante ao cruzar. Do câmbio, de h8 a h25,
  nenhum horizonte é significante a 80%.
- Pode dizer que a taxa de desemprego cai e a ocupação sobe no curto prazo. ⚠ São números inconvenientes para
  a leitura de contração e ficam no texto.
- Não pode atribuir a divergência com goncalves2025 à frequência nem à estratégia de identificação. A
  proibição de 2026-09-22 continua.

## 4. Verificação

- `pdflatex` + `bibtex` + `pdflatex` ×2: 39 páginas, sem erro, sem overfull nem underfull. Os avisos de
  versão de PDF das figuras e o `TS1/aer` já existiam.
- `grep` em `paper.tex`:
  - "synchrony", "frequency and identification", "frequência dos dados", "exclui zero", "excludes zero",
    "complementar ao F" e "estatisticamente significativa" dão 0;
  - "sincron" sobra só na linha comentada antiga da conclusão;
  - "defasagem" sobra só no Anexo B e no Anexo E, no sentido técnico;
  - `jarocinski2020` sobra só na revisão de literatura e no rodapé da §3.3.
- O desemprego e a ocupação conferem com `irf_point_matrix` do cache: −0,1216, −0,1878, 0,0140 e 0,2528 em
  h0, h6, h18 e h36, e 246,4, 398,6 e −15,1 em h0, h6 e h19.

## 5. O que fica aberto

- ⚠ `\autoref` e as legendas continuam imprimindo "Figure/Table". Vira item próprio em `pendencias.md`.
- A "Tabela antigo × novo" deixa de depender da versão integrada.
