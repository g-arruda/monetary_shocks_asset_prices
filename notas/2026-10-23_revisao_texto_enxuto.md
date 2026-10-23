# Revisão de texto: prosa enxuta e sem defensiva

> **CURRENT — 2026-10-23.** Branch `feature/auditoria-janelas-copom`, **não mergeada**. Revê a prosa de
> `2026-10-23_versao_integrada` e das rodadas de 10-20 a 10-23.
> - Só `paper/paper.tex` e o registro mudam. Nada foi reestimado, e nenhum número entrou ou saiu do `.tex`.
> - Pedido do autor: a prosa da versão integrada estava prolixa e defensiva, e fatos triviais se repetiam ao
>   longo do texto. A revisão usou a skill `como_escrever` em sete blocos. Cada bloco foi rascunhado no chat
>   com o original ao lado e só foi ao `.tex` depois do ok.

## 1. Decisões do autor em 23-10

| tema | decisão |
|---|---|
| escopo | o texto novo desde `main` (b0a3a10) e os parágrafos antigos que repetem os mesmos pontos (§1, §3.3 ¶1 e §3.4) |
| repetição | no corpo e nos anexos, cada fato e cada ressalva ficam completos uma vez, na seção própria; resumo, introdução e conclusão podem repetir em versão curta para prender o leitor |
| resumo e conclusão | catchy, com o achado na frente; o resumo vai a 150–200 palavras |
| item 5 do e-mail de 19-10 | a frase "consistente com uma transmissão associada ao risco, mas não identifica que o risco cause a depreciação" fica só na §4.2 |
| ressalvas pedidas pelo orientador (12-10 e 19-10) | ficam uma vez no corpo, comprimidas |
| defesa que ninguém pediu | sai |
| cortes que o autor decidiu um a um | a última frase do Anexo B, a última da §3.3 ¶1 e o "Ambas projetam…" da §3.4 saem; a §5.2 passa a dois parágrafos |

O autor corrigiu a regra no meio da rodada: "uma vez" vale para o corpo, não para a introdução e a
conclusão, que às vezes precisam se repetir para cativar o leitor.

## 2. Onde fica cada fato

| fato | completo em | versão curta em |
|---|---|---|
| ponte (trajetória diária e forma reduzida mensal) | Anexo E | resumo, §1 ¶3, §4.2 e §6 ¶1 |
| leitura do item 5 | §4.2, fim do parágrafo de significância | nenhum |
| condição de posto nas séries de goncalves2025 | §3.3 ¶1 (5% nos três vértices, Holm só no de 3 meses, curtose) e Anexo B | resumo, §1 ¶8 e §6 ¶5, com o vértice e a curtose |
| resultados menos favoráveis | §5.2, §5.3 e Anexo E (surpresa bruta) | §6 ¶4, em cinco frases que remetem à §5 e ao Anexo E |
| sete reuniões de janela mais longa e sensibilidade de 104 | os dois rodapés da §3.3 | uma frase em cada um dos Anexos B, E e F |

Os parágrafos da §1 renumeram: ¶1 gancho, ¶2 achado, ¶3 ponte, ¶4 contribuição, ¶5 SDFM, ¶6 instrumento,
¶7 painel, ¶8 goncalves2025, ¶9 roteiro.

## 3. O que saiu

**Ressalvas pedidas, agora uma vez no corpo:**
- Holm descrito como controle das 18 comparações pontuais, num rodapé de uma frase na §5.2;
- "não comprova a exogeneidade e pode refletir pouca precisão", na §5.2;
- o VIX em h0, a limitação do MSCI e o $p$ do EPU, na §5.2;
- a regra dos extremos fixada antes de ver os resultados e a inferência inconclusiva sem indicar resposta
  nula, na §5.3;
- o preenchimento por zero sem supor choque nulo, com o tratamento no momento e na variância, no rodapé da
  §3.3;
- o 10 como referência convencional, na §3.4;
- a janela ampliada que incorpora outras notícias, no Anexo F;
- sinal e dinâmica em vez de magnitude, e a mudança de sinal que não pode ser datada, no Anexo E.

**Defesa sem pedido, cortada:**
- "fixados antes de ver os resultados" nos horizontes dos placebos, no texto e na legenda da
  `tab:placebos_holm`;
- "em parte porque a ordem as seleciona pelo peso em Γ̂";
- "sem validar a exogeneidade do instrumento", no EPU;
- "e não um limiar que classifica o instrumento";
- "Do primeiro mês em diante, a ortogonalização não restringe a resposta do VIX";
- "sem confirmá-la", no Anexo E;
- "Entre os painéis diário e mensal mudam juntos a frequência e o objeto medido…", no Anexo B;
- "adotar essa identificação exigiria abandonar a representação fatorial", na §3.3;
- "Ambas projetam o instrumento… a Wald tenda a valores menores em amostras finitas", na §3.4;
- "e suas janelas incorporam um dia a mais de notícias", no rodapé das sete reuniões.

**Repetição e forma:**
- Saem de §1 e §6 o detalhe dos 5% e de Holm, que fica na §3.3.
- Saem as duas ocorrências de "mais robusta" da §1, a frase da §1 ¶3 que repetia o ¶2 e a última frase do
  ¶3 da conclusão, um paralelismo negativo que repetia a primeira.
- O roteiro da §1 tem duas frases.
- As duas primeiras frases do ¶2 da §1, que diziam o mesmo fato duas vezes, viram uma.
- A §4.2 põe os intervalos de significância na ordem do horizonte. O original juntava o sétimo mês à
  apreciação.

**Ficam por decisão anterior (23-10):** o título, o "dominates" do resumo, o "domina" e a frase da dominância
fiscal da introdução, e o "esse canal de prêmio de risco opera em paralelo" da conclusão.

## 4. Verificação

- `pdflatex` → `bibtex` → `pdflatex` ×2: 37 páginas, sem erro, sem overfull nem underfull, sem referência
  indefinida. O aviso `TS1/aer` já existia.
- **Números.** Um script compara os números do `.tex` em `HEAD` e na árvore de trabalho, e nenhum entrou ou
  saiu.
- **Rótulos e chaves.** Os conjuntos de `\label` e de chaves citadas são idênticos aos de `HEAD`.
- **Palavras.** O corpo, do resumo à §6, vai de 9211 para 8405 palavras, e para 8355 com o ¶1 da seção 5. Os Anexos B–F, com as tabelas, vão
  de 3326 para 3174. O resumo vai de 293 para 200.
- **Contagem de linhas com as frases repetidas**, de `HEAD` para agora:

| padrão | antes | depois |
|---|---|---|
| "não identific" / "not identify" | 4 | 1 |
| "antes de ver os resultados" | 3 | 1 |
| "não indica resposta nula" | 2 | 1 |
| "não comprova" / "sem validar" | 2 | 1 |
| "mais robust" | 2 | 0 |
| "aparecem também fora" / "also appear outside" | 4 | 4 |
| "sete reuniões" | 4 | 4 |
| "correção de curtose" / "kurtosis" | 3 | 4 |

As três últimas linhas ficam por desenho: a ponte é eco curto na introdução, na conclusão e no resumo, cada
anexo diz em uma frase como trata as sete reuniões, e a curtose entrou na §3.3, a casa do fato diário, como
pede o CLAUDE.md.
- `grep` por "exclui zero", "sincron", "frequência dos dados", "além disso", "adicionalmente", "vale
  destacar", "notavelmente" e travessão: 0 fora de comentários.

## 5. O ¶1 da introdução, a pedido do autor depois da rodada

O gancho sobre a UIP ficou fora do escopo inicial, porque não era novo nem se repetia, e foi revisto depois,
a pedido do autor.
- Saíram "constitui um dos temas centrais da macroeconomia", "ocupa posição de destaque", "desempenhar papel
  relevante", os dois pontos de "não é exclusivo de contextos de dominância fiscal:" e a sigla UIP, que o
  texto em português não define.
- O autor escolheu manter uma frase de abertura curta antes da paridade descoberta: "O canal cambial é um dos
  canais pelos quais a política monetária afeta o crédito, as expectativas e a atividade." A alternativa era
  abrir direto pela previsão da paridade descoberta.
- A citação de `dalgicozhan2026` e o mecanismo ficam. A última frase termina na paridade descoberta, e o
  "essa previsão" do ¶2 continua se referindo a ela.

## 6. O que fica aberto

- ⚠ `\autoref` e as legendas continuam imprimindo "Figure/Table" (item já aberto em `pendencias.md`).
