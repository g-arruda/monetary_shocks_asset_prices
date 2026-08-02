# O DFM é mesmo "mais forte e mais rápido" que um VAR pequeno?

> **CURRENT.** Escrita em 2026-07-31 sob a produção corrente: `z_jk_bs_purif` ×
> `yield_6m`, r=7, q=6, p=6, painel de 106 séries (vintage 07-24), 153 meses.
> Corpo gerado e números em `output/var/var_benchmark.md` + três CSVs e quatro
> PDFs, produzidos por `script/model_var.R`. **2026-08-02: `tex/main.tex` foi
> arquivado em `arquivo/tex/main.tex`; `texto_anpec/paper_anpec.tex` é o
> paper canônico e já não faz a afirmação que esta nota corrige (ver
> `_instrucoes/pendencias.md`, Tema A).** Esta nota é escrita à mão e nenhum
> script a toca.**

## A acusação

Council review de 2026-07-31, levantada por dois críticos independentes
(`relatorio/council_2026-07-31.md:23,73`). A introdução (`tex/main.tex:183`)
afirma que os efeitos sobre preços de ativos são "mais fortes e rápidos do que a
literatura baseada em modelos de menor dimensão tipicamente encontra". **Isso é o
resultado de Alessi-Kerssenfischer, não algo estimado aqui** — e o bloco de
ações, onde a comparação seria mais visível, é nulo a 90% em todos os 49
horizontes.

## Duas correções de premissa

**1. "A ferramenta já está pronta no repo" não era verdade.** O
`script/model_var.R` do disco (último commit `9d8fa3d`, 2026-03-18) **não
rodava**, com três erros fatais independentes: `compute_irf_var_proxy` era
chamada com `var_data=`/`p_var=`, ausentes da assinatura; o corpo esperava um
objeto `vars::VAR` e recebia a lista de `var_est_ols`; e pedia a coluna
`producao_transformacao`, que não existe no painel (o nome é
`ind_transformacao`). Além disso normalizava em `juros_selic` — o controle
negativo documentado —, truncava a amostra em 2024-12, passava `tcode = NULL`
(o `asset_ibov` não acumulava) e não gravava nada em disco.

**As peças de baixo nível, porém, eram tradução fiel** e foram mantidas sem
alteração: companion e potências MA contra `VARest.m:17-30`, denominador de
`SIGMA` (`T−p−pk−1`) contra `VARest_boot.m:36`, Rademacher `1−2·(runif>0.5)`,
Kilian só no DGP, re-estimação por réplica. **Quebrou só a cola.** O motor foi
extraído para `R/modeling/var_proxy.R` e a cópia local de `kilian_correction`
apagada em favor da de `factor_estimation.R` — as duas foram conferidas e
batem a **5,6e-17**.

**2. O código de Alessi-Kerssenfischer fixa o desenho, e vale ler antes.**
`codigo_alessi-mark/MAIN_VARloop.m` é o benchmark, e o que ele determina:

- 4 variáveis, 3 core + 1 resposta, um VAR por resposta (`:11-12`);
- **o core é {atividade, preços, taxa de médio prazo} e a taxa é também o alvo
  de normalização** — `RUN_MAIN_US.m:7-9` tem
  `corevars = {INDPRO, CPIAUCSL, 2year_rate}` com `opts.mpind = corevars(3)`.
  **AK nunca normaliza em taxa overnight**, o que é uma segunda razão,
  independente da força do instrumento, para não usar `juros_selic` aqui;
- `tcode` vai para a identificação, **subsetado** ao VAR (`:28`), e `cumimp`
  roda dentro do `IdentExtInstr`, no ponto e em cada réplica;
- a `varlist` é a lista de preços de ativos do paper, união de três grupos de
  figura, **sem vértices de curva**;
- AK guarda também as respostas **core** de cada VAR (`:6,22`) e as sobrepõe
  contra o painel único do DFM (`MAIN_plotfigs.m:49-71`);
- a figura é duas colunas, VAR à esquerda e DFM à direita, com **`linkaxes`**
  (`MAIN_plotfigs.m:1-46`). O eixo y compartilhado é o ponto inteiro: é o que
  torna "mais forte" e "banda mais estreita" visíveis em vez de afirmados.

O que foi rodado segue isso: core `{ind_transformacao, price_ipca, yield_6m}`,
18 VARs, p=6, h=48, nboot=800, seed=123, bandas 68/90, amostra até 2025-09 — a
spec de `irf_coherence_check.R`. Desvio declarado: AK reporta percentis
5/10/90/95 (90% e 80%); aqui 68/90, para casar com o `.rds` em cache.

Quatro auto-testes passam: `yield_6m` normaliza em **0,005 exato nos 18 VARs**
(desvio máximo 0); o lado DFM lido do `.rds` reproduz `irf_coherence_h.csv` em
882 linhas a 7,1e-15 no ponto e 1,4e-14 nas bandas; `var_est_ols` reproduz um
VAR(2) construído à mão a 0; e o smoke test do `CLAUDE.md` continua exato
(0,005 / 0,009164 / 0,009274 / −1,672583 / 0,149756).

## ⚠ A régua estava errada, e foi a figura que denunciou

**Declarado porque muda o veredito.** A regra fixada antes dos números era
*mais forte = |IRF_DFM(pico)| > |IRF_VAR(pico)|*. Sob ela o placar era
**18 de 18**, razão mediana 2,51, e 7,66 no bloco de ações. Parecia ótimo demais.

Ao olhar `var_benchmark_acoes.pdf` ficou visível o que a tabela escondia: **o
extremo global do DFM tem sinal oposto ao do impacto em 8 das 18 respostas — e
são exatamente as 8 ações.** O `asset_ibov` sai de −1,67 no impacto, cruza zero
por volta de h=5 e chega a **+20,3 em h=24**, enquanto o VAR pequeno fica
negativo o tempo todo (−2,46 em h=9). A razão de 8,22 comparava uma **alta** de
médio prazo com uma **queda**. Não é o mesmo objeto.

A régua passou a ser (i) a **razão de impacto**, que é o mesmo objeto nos dois
modelos e concorda em sinal em 18 de 18, e (ii) o **pico de mesmo sinal** — o
extremo dentro do primeiro trecho contíguo em que a resposta conserva o sinal de
h=0. O pico bruto continua tabelado, com bandeira de sinal, para quem quiser
conferir.

Há uma segunda razão para desconfiar do pico bruto, e ela vem da nota irmã de
hoje: o extremo de médio prazo do DFM **é** a oscilação do par complexo
dominante — apagar o par inverte o vale em 12 de 14 séries. Pontuar o DFM por um
pico em h=23-48 seria pontuá-lo onde não há evidência independente.

## O placar, com a régua corrigida

| | todas (18) | ações (8) |
|---|---|---|
| DFM mais forte **no impacto** | **16 de 18** (razão mediana **2,32**) | 7 de 8 (**2,98**) |
| DFM mais forte **no pico de mesmo sinal** | **16 de 18** (razão mediana **1,61**) | 7 de 8 (**1,31**) |
| DFM mais **rápido** | **9 de 18** | **7 de 8** |
| banda de 68% do DFM mais **estreita** no impacto | **0 de 18** (razão mediana **4,35**) | 0 de 8 (4,71) |
| mesmo sinal no impacto | **18 de 18** | 8 de 8 |
| células sig90 | DFM **37**, VAR **266** | DFM **0**, VAR **132** |

### "Mais forte" se sustenta, com magnitude menor do que a alegada

16 de 18 no impacto e no pico de mesmo sinal, razão mediana **2,32** no impacto e
**1,61** no pico. É um fator de 1,6 a 2,3, não a ordem de grandeza que a régua
contaminada sugeria. **As duas exceções entram na tabela:** `asset_imat` (razão
0,487 no impacto, 0,103 no pico — o VAR é bem mais forte) e
`price_core_ipca_ex0` (0,562). No pico de mesmo sinal a segunda exceção é
`spread_icc_juridica`, com razão 0,997, empate técnico.

### "Mais rápido" só vale no bloco que dá título ao paper

**9 de 18 no conjunto — moeda ao ar.** Mas **7 de 8 nas ações**: o DFM põe o pico
de mesmo sinal em **h=1** e reverte por volta de h=5, enquanto o VAR pequeno leva
h=3 a h=9 para chegar ao seu. A afirmação defensável é estreita e é justamente a
do título: *no bloco de ações* o DFM acha uma resposta mais forte e mais rápida.
Fora dele, "mais rápido" não se sustenta e não deve ser escrito.

### O preço: bandas 4,35× mais largas, e o resultado nulo é do DFM

**Em nenhuma das 18 respostas a banda de 68% do DFM é mais estreita no impacto.**
A razão mediana é **4,35**. E o placar de significância é o oposto do que a
palavra "stronger" sugere: **37 células sig90 no DFM contra 266 no VAR**; no
bloco de ações, **0 contra 132** (68 delas em h ≤ 12). O VAR pequeno acha
resposta acionária significativa; o DFM, não.

Isso não é contradição — é o trade-off do desenho. O DFM estima 7 fatores e um
`Λ` de 106×7 e reestima tudo em cada réplica do bootstrap, então a incerteza de
estimação que ele **propaga** é muito maior. O VAR de 4 variáveis é preciso
porque é pequeno, e a próxima seção mostra a que custo.

## O achado que mais favorece o DFM não é nenhum dos dois

É o diagnóstico do próprio AK (`MAIN_plotfigs.m:49-71`): **as respostas das
variáveis core não são estáveis entre os VARs.** A mesma variável, sob o mesmo
choque, responde diferente conforme qual seja a quarta variável do sistema:

| core | h | mín | mediana | máx | amplitude |
|---|---|---|---|---|---|
| `ind_transformacao` | 0 | −1,185 | −0,746 | −0,232 | **0,952** |
| `ind_transformacao` | 6 | −0,411 | +0,007 | +0,508 | **0,919** |
| `price_ipca` | 0 | −0,063 | −0,032 | **+0,025** | 0,089 |
| `yield_6m` | 12 | 0,0038 | 0,0076 | 0,0086 | 0,0048 |

Na produção industrial a **amplitude entre os 18 VARs excede a própria mediana em
módulo** — trocar a quarta variável muda a resposta de impacto mais do que ela
vale. No IPCA o **sinal inverte**. E o `yield_6m` em h=12, que é a variável de
política e está em todos os 18 sistemas, varia 63% da mediana. Isso é exatamente
o argumento do conjunto de informação que motiva o DFM, e aqui ele está medido
neste painel em vez de citado.

**Complemento:** o VAR com `ibc_br` é **explosivo** (max |λ| = 1,008) e a
correção de Kilian não encontra `delta` que o estabilize. São 25 parâmetros por
equação em 147 observações. Um dos 18 sistemas não é sequer estacionário.

## O que este exercício NÃO mostra

- **Não testa "contra a literatura".** Com a identificação mantida fixa
  (`z_jk_bs_purif` nos dois lados), testa **DFM contra VAR pequeno**. A
  literatura de menor dimensão identifica por Cholesky. Para sustentar a frase
  de `tex/main.tex:183` como está escrita seria preciso uma variante recursiva —
  decisão do autor em 2026-07-31 foi não fazer.
- **Não mostra que o DFM é mais preciso.** É o contrário: bandas 4,35× mais
  largas e 37 células sig90 contra 266.
- **Não valida o médio prazo do DFM.** O pico bruto foi descartado justamente
  por cair onde a análise espectral diz não haver evidência independente.

## Consequência para o `tex`

A frase da introdução precisa mudar. Escrita como está, ela é **metade sustentada
e metade refutada**, e a metade refutada é visível em uma tabela. A versão
defensável, com os números deste exercício:

> No bloco de ativos o modelo de fatores estima respostas de impacto **1,6 a 2,3
> vezes maiores** que as de um VAR de quatro variáveis identificado pelo **mesmo**
> instrumento, e, nas ações, mais rápidas — pico em h=1 contra h=3 a h=9. A
> contrapartida é precisão: as bandas do DFM são cerca de **4 vezes** mais largas,
> e o resultado nulo do bloco acionário a 90% é do modelo grande, não do pequeno.

E o argumento mais forte a acrescentar é o da instabilidade: as respostas das
variáveis core do VAR pequeno variam, entre especificações, mais do que a própria
magnitude que estimam.

## Aberto daqui

- **Redigir isso no `tex`**, e reescrever `tex/main.tex:183`. Bloqueado pelo item
  "§5 Robustez está inteira comentada".
- **Variante Cholesky**, se o autor quiser sustentar a comparação "com a
  literatura" e não só "com um VAR pequeno". Custo marginal baixo — é a mesma
  estimação com outro `B0`.
- **Incidental, não corrigido:** `kilian_correction` em `factor_estimation.R`
  testa a inversibilidade da equação de Lyapunov por `|det| < 1e-12` numa matriz
  576×576 (ou 1764×1764 no DFM). O determinante de uma matriz desse tamanho
  subborda para zero mesmo bem-condicionada, então o ramo do `ginv` é
  **sempre** tomado e imprime aviso. O resultado é numericamente correto
  (`ginv` = inversa quando não-singular; conferido a 5,6e-17), só é mais lento e
  ruidoso. Vale um item de higiene, não uma mudança silenciosa.
