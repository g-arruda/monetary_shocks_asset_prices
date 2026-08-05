# Identificação por heterocedasticidade no DFM mensal — e a reconciliação com Gonçalves-Rodrigues-Genta

> **CURRENT (2026-08-01).** Vintage de 106 séries, produção `(r=7, q=6, p=6)`,
> proxy `z_jk_bs_purif`. Escrita à mão; o corpo gerado por script está em
> `output/het/het_robustness.md` e é sobrescrito a cada rodada — **não** editar
> aquele arquivo. Artefatos: `output/het/het_{gate_grid,verdict,distribution,
> by_window,era_mix,break_dates,both_conditions_raw}.csv` + `het_gate_surface.pdf`.
> Código: `script/het_robustness.R`, `R/identification/het_{primary,tests}.R`.

## 1. O que se perguntou e o que se achou

A pergunta do autor: a identificação por heterocedasticidade à la Rigobon (2003)
produz respostas **no mesmo sentido** do instrumento externo? Se sim, vira seção
de robustez e serve para confrontar GRG (2025), que usa essa identificação em
dados **diários** num sistema pequeno.

**Resposta: não é possível responder, porque a identificação não existe na
frequência mensal.** E esse "não existe" agora tem uma demonstração mais forte
do que a de 2026-07-16: falha em **duas condições necessárias independentes**,
em **252 células** de especificação e **5 desenhos de regime**, dos quais três
nunca haviam sido testados.

O escopo foi fixado pelo autor em 2026-08-01: **objeto diário abandonado**, fica
o DFM mensal. A perna diária permanece em `arquivo/`.

## 2. Por que re-rodar não foi teimosia

O veredito de 2026-07-16 (`historico_decisoes.md` §1.2) foi produzido **antes**
do refresh de vintage de 2026-07-24 (106 séries) e **antes** da migração para
`(7,6)`. Foi exatamente esse refresh que devolveu força ao proxy — ξ_mp saiu de
fraco para 10,43. Não havia como saber, sem rodar, se ele também mexia no gate
het. Além disso o script arquivado só variava `p ∈ {6,3}` e dois desenhos de
regime.

**A causa diagnosticada, que motivou os desenhos novos:** com 8 reuniões por ano
o desenho de calendário rotula **102 meses C contra 51 NC** neste painel — dois
terços da amostra é "tratada", contra 97/524 no diário — e a notícia de política
ainda é diluída em ~21 pregões. Os dois efeitos empurram `Σ_C − Σ_NC` para zero
**por construção do desenho**, não por ausência de heterocedasticidade.

## 3. A grade

`p ∈ {5,6,7,8} × q ∈ {5,6,7,8} × r ∈ {7,8}` com `q ≤ r` (restrição estrutural:
o espaço dinâmico não excede o estático), × `{full, pre_covid}` = 56 células,
com um DFM em cache por célula reusado pelos 5 desenhos. 252 células com status
`ok` (as 28 de `episodio_s2 × pre_covid` são indisponíveis por construção — a
quebra de 2020 está fora da janela).

Cinco desenhos de regime:

| desenho | regra | novo? | livre de instrumento? |
|---|---|---|---|
| `calendario` | meses com/sem Copom | não (reproduz 07-16) | sim |
| `episodio_s2` | pré/pós-2020 (BPSS) | não (reproduz 07-16) | sim |
| `intensidade_z` | tercil superior de \|z\| | **sim** | **não** |
| `volatilidade_juros` | quartil superior da vol. realizada do DI 6m diário | **sim** | sim |
| `quebra_livre` | quebra de volatilidade em data **varrida** | **sim** | sim |

Detalhe metodológico que importa: o placebo é **permutação** para desenhos
dispersos e **rotação circular** para os contíguos (`episodio_s2`,
`quebra_livre`). Permutar livremente um desenho contíguo destrói a contiguidade
que o desenho impõe e devolve um p-valor anticonservador. `het_strength_stats`
ganhou o argumento `placebo` para isso.

**Multiplicidade fixada antes de rodar:** veredito primário é a distribuição de
p-valores, não o mínimo; célula isolada só conta se sobreviver a Holm sobre a
família **e** replicar na outra janela; toda a grade vai para o CSV.

## 4. As duas condições que falham

### 4.1 Condição de posto (Rigobon 2003, Prop. 1)

Nenhuma célula sobrevive. E **o veredito não depende da severidade da correção**:
sob Holm *dentro* de cada desenho × janela (28 testes em vez de 252) o número de
aprovações continua **zero** em todos os cinco desenhos.

As rejeições brutas a 5% existem e não devem ser escondidas — `intensidade_z`
rejeita em **89,3%** das células da janela cheia (mediana 0,037), `quebra_livre`
em 42,9%, `episodio_s2` em 25%. Mas as células são fortemente dependentes (mesmo
painel, especificações aninhadas), então 89% de 28 células não são 25 evidências
independentes; e nenhuma sobrevive à correção mais leniente possível.

`calendario` rejeita em **0%** das células nas duas janelas (mediana 0,56 e
0,45). **A conclusão de 2026-07-16 está confirmada no vintage atual e em toda a
grade `(p,q)`** — não era artefato de especificação.

### 4.2 Distinção dos autovalores (Lanne-Lütkepohl 2008)

Rejeitar proporcionalidade diz que as matrizes diferem; identificar uma **coluna**
exige ainda autovalores generalizados **distintos**. O gap relativo mínimo tem
mediana de **0,11 a 0,17** por desenho, contra o corte de 0,20 usado aqui.

Cruzando as duas condições **em nível bruto, sem correção alguma** — a leitura
mais generosa que o dado admite: 48 células rejeitam proporcionalidade, 76 têm
autovalores distintos, e **21 satisfazem as duas**. Dessas 21, **17 estão em
`q = 5`** — o menor valor da grade — e todas na janela cheia. Depois da correção
interna ao desenho sobram **zero**. Concentração em uma única dimensão dinâmica é
assinatura de fragilidade de especificação, não de identificação.

Por isso o estágio de IRF **não roda**. Sem coluna separável não há direção
monetária a extrair, e qualquer IRF produzida ali seria um número sem
identificação por trás — exatamente o erro que a rodada GMR ensinou a não
cometer.

## 5. O achado que explica tudo: escala, não composição

`volatilidade_juros` é o desenho mais informativo do conjunto, e ele é novo.
Ele concentra o regime C no pós-2020 — `share_C` de **0,478** contra **0,051**
antes — e mesmo assim **não rejeita proporcionalidade em nenhuma das 56
células**, nas duas janelas.

Isto é: o surto de volatilidade pós-2020 é um **fator de escala comum**. Levanta
todas as variâncias juntas sem girar a matriz de covariância. É a mesma leitura
que a análise de episódio arquivada em 2026-07-16 já dera, agora demonstrada por
um desenho que ataca o problema por outro lado.

Corolário para `quebra_livre`: a varredura livre da data de quebra **encontra**
2020-2022 (25 das 28 células da janela cheia; 2022-10 em 11 delas, 2021-10 em 6).
Ou seja, a única heterocedasticidade que o painel mensal tem é a da COVID e do
ciclo de aperto — e ela é de escala. Rotular essa coluna de "monetária" seria
nomear a variância da pandemia.

## 6. A reconciliação com GRG — que não exigiu estimar nada

GRG (2025) identifica por heterocedasticidade em dados **diários** (mudanças
Qua→Qui, regime C = semana com Copom) num sistema pequeno, e acha que um aperto
de 100bp **aprecia** o real em 3,4% a 5,6% conforme a maturidade. O DFM mensal
deste paper acha **depreciação** de 3,64% por +50bp, isto é ~+7,3% por 100bp.
Sinal oposto.

Três peças, todas já existentes no repositório, fecham a discussão:

1. **A réplica em Python do referee2** (`arquivo/relatorio/correspondence/referee2/replication/referee2_py_b1.csv`),
   sobre os **nossos próprios dados diários**, dá `b_1 = {DI_3m +6,07; DI_2y
   +13,60; IBOV +0,17; BRL −0,275}`. Normalizado por +100bp no DI_3m: o real
   **aprecia 4,53%** — dentro do IC de 95% do GRG na mesma maturidade
   ([−6,57; −3,63], ponto −5,10). **A identificação diária replica o GRG.**
2. **O gate diário passa com folga.** O mesmo teste de proporcionalidade que não
   rejeita em nenhuma célula mensal dá **LR = 135,1, p_boot = 0,005** no painel
   diário (97 C / 524 NC). Roda como self-test T2b de `het_robustness.R`.
3. **`jk_sovereign_confound.R` já havia mostrado o mesmo por outro caminho**: os
   31 dias classificados "política" foram selecionados por **apreciação** do BRL
   no mesmo dia e ainda assim entregam **depreciação** mensal (+0,129 contra
   0,150).

**Conclusão: o desacordo com o GRG não é de identificação, é de frequência e
propagação.** Mesma economia, mesmo período, mesmo método → mesma resposta no
diário. O sinal se inverte na agregação mensal, e é isso que o paper mede.

### A variável inconveniente

O mesmo `b_1` diário dá **IBOV +2,83% por 100bp** — ações *subindo* num aperto,
sinal teoricamente errado. Não é rodapé: é o quarto autovalor do sistema de 4
variáveis, com participação de **0,0015** no espectro. O bloco de ações é
essencialmente **não identificado** naquele sistema diário. A leitura honesta é
que o het diário identifica bem o bloco de juros/câmbio e não diz nada confiável
sobre ações — o que, aliás, é consistente com o GRG não reportar ações.

## 7. O que pode e o que não pode ser escrito

**Pode:**
- que a identificação por heterocedasticidade foi testada **no objeto do paper**,
  em 252 especificações e 5 desenhos, e que ela **não é viável na frequência
  mensal** — com as duas condições necessárias e o diagnóstico de escala;
- que a grade **remove a saída** "vocês não procuraram na especificação certa":
  o resultado é plano em `(p,q)` e o desenho de calendário rejeita em 0% das
  células nas duas janelas;
- que o desacordo de sinal do câmbio com o GRG é de **frequência**, com a
  evidência diária citada de material arquivado;
- que isso **justifica o desenho do paper**: um DFM mensal precisa de instrumento
  externo porque a heterocedasticidade que identifica no diário não sobrevive à
  agregação.

**Não pode:**
- chamar isso de **corroboração**. Nenhuma IRF foi produzida por het; não há
  concordância de sinal a reportar, porque não há coluna identificada;
- dizer que "a identificação alternativa confirma o proxy". A única identificação
  alternativa que produz IRF continua sendo a GMR não-gaussiana, e aquela só
  sustenta afirmações de **não-discriminação** (`2026-08-01_robustez_identificacao.md`);
- usar as 21 células que passam as duas condições em nível bruto como evidência.
  17 delas estão em `q = 5` e nenhuma sobrevive à correção mais leniente.

## 8. Ponta solta, declarada

Identificação por heterocedasticidade **condicional** — GARCH-SVAR
(Lanne-Saikkonen 2007; Normandin-Phaneuf 2004) — não precisa de datas de regime
e explora *clustering* de volatilidade em vez de contraste entre blocos. É a
rota com melhor chance de produzir IRF mensal, e **não foi tentada**: é outro
ramo, não Rigobon, e `svars` não está instalado. Fica como decisão do autor, não
como trabalho feito.
