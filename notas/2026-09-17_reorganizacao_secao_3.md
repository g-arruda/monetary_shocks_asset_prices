# A §3 reorganizada em quatro subseções e migrada para a produção corrente

> **CURRENT — 2026-09-17.** Rodada editorial no `paper/paper_anpec.tex`. Nada foi reestimado.
> O único código executado foi `script/instrument.R`, para apurar o `R²` da regressão
> pré-evento de Bauer-Swanson sob a janela corrente, e ele reproduziu as 8 variantes
> bit a bit.
> - Painel de produção de 115 séries, 2012-03 a 2025-12, `(r, q, p) = (5, 5, 4)`, 162 inovações.
> - **Fecha, só na §3**, as duas lacunas que `CLAUDE.md` declarava abertas contra a produção:
>   a janela e a inferência. §4, §5 e as duas legendas *wild bootstrap* seguem uma vintage atrás.
> - Escrita na branch `feature/lp-volatilidade-producao`, por cima da migração de
>   `2026-09-17_volatilidade_covid_producao`.

## 1. O que a §3 era

Seis subseções que não seguiam a lógica do estimador, com 2.656 palavras, 28% do corpo:

| | subseção | problema |
|---|---|---|
| 3.1 | O Modelo de Fatores Dinâmicos Estruturais | modelo, escala de Lenza-Primiceri e padronização no mesmo lugar, com a escala entrando antes da representação MA |
| 3.2 | Base de Dados | janela 2013:01--2025:09, 149 inovações |
| 3.3 | Identificação por instrumento externo | argumento do vértice de 6 meses, primeira metade |
| 3.4 | Construção do instrumento | argumento do vértice de 6 meses, segunda metade |
| 3.5 | Seleção de `(r, q)` e estimação | toco de três parágrafos, nenhum deles seleção |
| 3.6 | Relevância do instrumento | força, conjuntos AR e ressalvas sob um título só |

**A contradição numérica era de duas vintages.** O ¶1 da 3.6 dizia `ξ_mp = 6,85` e
`F_rob = 11,77`, e o ¶2, do mesmo objeto, `F_rob = 10,06` e `ξ_mp = 5,24`. O ¶3 e a
`tab:first_stage` usavam a série antiga, 4,26 → 3,56 → 5,24. A 3.2 declarava 149 inovações
enquanto a 3.5 contava 162. A migração de 2026-09-17 atualizara o ¶1 e deixara o resto.

## 2. O que a §3 é

Quatro subseções, 2.179 palavras, na ordem pedida pelo autor:

1. **Modelo e estimação.** Equações (4)-(6), representação MA (7), padronização por `s_iy`,
   o VAR dos fatores com a reescala (5b), a ML de θ, o WLS, e um parágrafo de seleção de
   `(r, q, p)`. A cadeia de estimação aparece inteira e em ordem pela primeira vez.
2. **Base de dados.** 115 séries, 2012-03 a 2025-12, 166 observações, 162 inovações.
3. **Identificação e construção do instrumento.** As condições da proxy, a normalização e o
   vértice de 126 du num parágrafo só, e as três camadas de construção.
4. **Relevância do instrumento e inferência.** As duas estatísticas de força, a `tab:first_stage`,
   e os conjuntos Anderson-Rubin. O título deixa de mentir sobre o que a subseção contém.

**O conteúdo novo é a verossimilhança concentrada**, equação (5c), na notação do próprio paper:

```
ℓ(θ) = −(T_e·r/2)(1 + log 2π) − r·Σ_t log s_t(θ) − (T_e/2)·log|Σ̂(θ)|
```

com `Σ̂(θ) = T_e⁻¹ Σ_t û_t(θ)û_t(θ)'/s_t(θ)²` e `T_e = T − p`. Fiel a
`R/modeling/factor_estimation.R:593-595`. A prosa diz que β e Σ entram pelos estimadores
condicionais a θ, que o segundo termo é o jacobiano da reescala, e que a maximização é
restrita a `s̄ ≥ 1` e `ρ ∈ [0,1]`. Antes, o paper dava θ̂ sem dizer como θ̂ fora obtido.

## 3. Os números migrados

| onde | antes | agora | fonte |
|---|---|---|---|
| janela | 2013:01--2025:09, 153 obs, 149 inov. | 2012:03--2025:12, 166 obs, 162 inov. | `registro/metodo.md` |
| reuniões do Copom | 95 | 102 | `data/processed/copom_event_diagnostics.csv` |
| classificação JK | 62 / 33 (34,7%) | 67 / 35 (34,3%) | idem, coluna `jk_monetary_bs` |
| `R²` da regressão BS | 0,024 | **0,022** | `script/instrument.R`, rodado nesta sessão |
| `ξ_mp` por camada, cheia | 4,26 → 3,56 → 5,24 | 6,68 → 6,16 → 6,85 | `output/instrument/mosw_strength_grid.csv` |
| `ξ_mp` por camada, pré-COVID | 6,58 → 6,40 → 7,48 | 6,66 → 6,32 → 8,64 | idem |
| `F_rob` por camada, cheia | 5,48 → 4,17 → 10,06 | 9,37 → 7,89 → 11,77 | idem |
| `F_rob` por camada, pré-COVID | 6,66 → 6,16 → 11,87 | 7,79 → 6,95 → 13,81 | idem |
| meses com `z ≠ 0` | 87 / 90 / 60 | 95 / 99 / 65 | `output/instrument/instrument_diagnostics_report.md` |
| `β̂ × 10⁴`, EP, `p` | 0,734 / 0,314 / 0,021 | 0,718 / 0,235 / 0,003 (bruta) | idem |
| legenda de `tab:first_stage` | `n = 149` e `n = 80` | `n = 162` e `n = 90` | `mosw_strength_grid.md` |

**A leitura qualitativa das camadas não mudou**, e isso é o que permite migrar o número sem
reescrever a interpretação: a ortogonalização baixa `ξ_mp` e o filtro de sinal o eleva, nas
duas janelas e nas duas estatísticas.

**`script/instrument.R` é idempotente.** As 11 saídas em `data/processed/` conferem por
`md5sum` contra o estado commitado. O `R²` de 0,024 vinha de
`instrument_construction_sweep.md`, rodado em 2026-08-25 sob a janela antiga, com 586
quintas-feiras válidas e 92 dias de Copom contra 638 e 102 hoje.

## 4. Os três blocos de prosa defensiva que saíram

Decisão do autor, sob a regra de que a prosa reporta e não se defende:

- **A nota que mapeava `y_t → F_t` em Lenza-Primiceri.** Quem lê DFM entende que o VAR é dos
  fatores e que `n` vira `r`.
- **A troca `c_j' = s_jy Λ_j'`, `c_mp'`, e a nota pondo a equação de MOSW ao lado da do DFM.**
  Mesma razão. A §3.4 agora diz que a inferência são os conjuntos AR de Montiel Olea, Stock e
  Watson obtidos por inversão de teste, e para por aí.
- **O parágrafo de ressalvas da antiga 3.6**, sobre a covariância `plug-in` condicionar em
  `Λ`, `s_iy` e `θ̂`, e sobre o gate `hac_dim < T`. O leitor que sabe que o tratamento está no
  VAR dos fatores infere o condicionamento, e `(r,q) = (8,8)` é célula abandonada.

Saíram também a nota com a aplicação ao petróleo de MOSW, que duplicava a §2, e as orações que
defendiam a versão *poor man's* do filtro contra a versão principal de Jarociński-Karadi. A nota
do *poor man's* ficou com o que ela reporta: qual versão foi implementada, e que o filtro é
aplicado aos resíduos da ortogonalização e não às surpresas brutas.

**O gate `hac_dim < T` continua valendo no código e nos artefatos.** O que saiu foi a prosa do
paper, não a regra. Nenhuma banda pré-COVID pode ser publicada e nenhum número de `(8,8)` pode
aparecer como inferência, porque as duas células continuam barradas.

## 5. O que ficou para trás

§4, §5, `output/irf/irf_section.md` e as duas legendas que dizem *wild bootstrap* seguem na
janela 2013:01--2025:09 e descrevem as figuras como pintadas. `script/fig_section5.R` e
`script/fig_weak_iv.R` continuam abortando sem `--repaint-paper-figures`. A rodada editorial
que fecha isso não está agendada.

Os dois parágrafos comentados que o autor mantinha na §3, sobre não-fundamentalidade
(`villaverde`) e sobre relevância não estabelecer validade, foram preservados nas posições
equivalentes da nova estrutura.

## 6. Verificação

- `latexmk -g -pdf` compila em 26 páginas, sem erro, sem aviso e sem referência indefinida.
- `md5sum -c` nas 11 saídas de `data/processed/` depois de `script/instrument.R`: todas OK.
- `grep` por `5,24`, `10,06`, `4,26`, `3,56`, `149`, `95 reuniões`, `2013` e `0,024` dentro da
  §3 volta vazio.
- `paper/references.bib` não recebeu chave nova. A única diferença contra o `HEAD` é a entrada
  `lenzaprimiceri`, que veio da migração anterior.
