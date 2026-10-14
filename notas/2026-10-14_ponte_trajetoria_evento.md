# Ponte (a): trajetória acumulada de câmbio e CDS após o anúncio do Copom

> **CURRENT — 2026-10-14.** Ponte (a) do e-mail do orientador de 12-10
> (`email/email_professor_12-10_19h40.md`, item 2a). Branch `feature/focus-horizonte-fixo`, **não
> mergeada**.
> - **Regra commitada antes de rodar** (`0b08071`), no cabeçalho de `script/event_trajectory.R`:
>   horizontes, contagem, janelas, amostra, estimação e leitura.
> - **Rodada em `4d9c02e`.** Antes da primeira saída, dois erros de código foram corrigidos sem mudar a
>   regra:
>   - `meetings.csv` já trazia `e_di_bs`, e o join com o arquivo de eventos a duplicava;
>   - dentro de `tibble()`, o EP escalado encobria o da inclinação, e t e p saíam errados.
>
>   A guarda contra o passo 2 passou a conferir também o p-valor.
> - **Decisões do autor em 14-10, antes de rodar:**
>   - câmbio só do Yahoo `BRL=X`, nunca a PTAX;
>   - CDS sempre com fechamento às 17h de Nova York;
>   - horizontes contados pelas cotações de cada mercado;
>   - amostra comum de 101 reuniões;
>   - só a forma reduzida, na surpresa ortogonalizada.
> - Nada foi reestimado. O instrumento, o painel, `R/` e `data/` ficaram intocados.

## 1. O desenho

- **Variável:** a k-ésima cotação posterior ao anúncio menos a última anterior, com k = 1, 5, 10 e 20
  (os horizontes do e-mail). k conta as cotações do próprio mercado, e k = 1 é a primeira posterior.
- **Câmbio.** Yahoo `BRL=X`, de `yahoo_pre` até a linha k − 1 posições depois de `yahoo_post`
  (`output/copom_timing/meetings.csv`).
  - As cotações são as da noite, cinco por semana, inclusive em feriados brasileiros.
  - A variação vai em R$ por US$, a unidade do `cambio_usd` do DFM, e em %.
- **CDS.** Fechamento às 17h de Nova York, de `cds_pre_ny17` até a linha k − 1 posições depois de
  `cds_post_ny17`, em p.b.
  - Em 27 das 102 reuniões, o fechamento de quarta às 17h de NY vem depois do anúncio. Nelas, a janela
    começa na cotação anterior à quarta, e em k = 1 vai da véspera à quarta.
  - Nas outras 75, vai de quarta a quinta.
- **Amostra.** São 101 reuniões em todos os horizontes. Sai a de 2025-12-10, porque o Yahoo do
  repositório termina em 2025-12-31 e ela não tem a 20ª cotação.
- **Calendário** (`paths.csv`):

  | k | dias corridos desde a quarta | k-ésima cotação no mês seguinte ao da quarta (câmbio / CDS, de 101) |
  |---|---|---|
  | 1 | 0–1 | 3 / 5 |
  | 5 | 6–7 | 26 / 24 |
  | 10 | 13–14 | 47 / 51 |
  | 20 | 27–28 | 89 / 92 |

- **Sobreposição.** Nenhuma janela de 20 cotações passa da cotação anterior ao anúncio da reunião
  seguinte. O menor intervalo entre reuniões é de 35 dias.
- **Estimação.** Variação na `e_di_bs`, com constante e EP HC1, por +50 p.b. de surpresa
  ortogonalizada. Os intervalos são de Wald, a 90 e 95%. Sem normalização pelo DI, e portanto sem
  primeiro estágio.

## 2. Resultados

`output/event_trajectory/regressions.csv`, amostra comum de 101 reuniões, por +50 p.b. de surpresa
ortogonalizada.

**Câmbio, R$ por US$**

| k | efeito | 90% | 95% | p | significância |
|---|---|---|---|---|---|
| 1 | −0,029 | [−0,057; −0,001] | [−0,062; +0,004] | 0,086 | 90% |
| 5 | −0,025 | [−0,084; +0,033] | [−0,096; +0,045] | 0,477 | não a 90% |
| 10 | +0,048 | [−0,033; +0,128] | [−0,048; +0,143] | 0,331 | não a 90% |
| 20 | **+0,122** | [+0,029; +0,215] | [+0,011; +0,233] | **0,031** | **95%** |

**Câmbio, %**

| k | efeito | 90% | 95% | p | significância |
|---|---|---|---|---|---|
| 1 | −0,66 | [−1,24; −0,09] | [−1,35; +0,02] | 0,058 | 90% |
| 5 | −0,69 | [−1,93; +0,56] | [−2,17; +0,80] | 0,366 | não a 90% |
| 10 | +1,00 | [−0,84; +2,83] | [−1,19; +3,19] | 0,373 | não a 90% |
| 20 | +2,40 | [+0,09; +4,70] | [−0,36; +5,15] | 0,088 | 90% |

**CDS de 5 anos, p.b.**

| k | efeito | 90% | 95% | p | significância |
|---|---|---|---|---|---|
| 1 | −1,2 | [−7,9; +5,4] | [−9,1; +6,7] | 0,759 | não a 90% |
| 5 | −0,5 | [−22,3; +21,2] | [−26,4; +25,3] | 0,968 | não a 90% |
| 10 | **+16,5** | [+3,3; +29,8] | [+0,8; +32,3] | **0,040** | **95%** |
| 20 | +19,9 | [−1,9; +41,8] | [−6,1; +45,9] | 0,133 | não a 90% |

- O R² vai de 0,00004 (CDS em k = 5) a 0,046.
- O EP do CDS em k = 5 (13,2) é maior que em k = 10 (8,1).

## 3. k = 1 contra o passo 2

- **Câmbio.** Nas 102 reuniões, −R$ 0,0288 (p 0,088), igual ao `output/daily_event/regressions.csv` do
  passo 2 a 1e-10 em coeficiente, EP e p (guarda do script). Nas 101, −R$ 0,0290 (p 0,086).
- **CDS.** Nas 102, −1,24 p.b. (p 0,757) às 17h de NY, contra −0,49 (p 0,903) de quarta a quinta no
  passo 2. As duas janelas diferem nas 27 reuniões da seção 1.

## 4. Leitura pela regra

Regra do cabeçalho, fixada antes de rodar.
- **Câmbio: caso (i).** Em R$, o ponto é negativo em k = 1 e 5 e positivo em k = 10 e 20, e é
  significante a 95% em k = 20. A depreciação aparece na trajetória diária até 20 cotações.
  - Em %, o ponto de k = 20 é significante a 90% e não a 95%.
- **CDS: caso (i).** O ponto é negativo em k = 1 e 5, sem significância a 90%, e positivo em k = 10 e
  20. É significante a 95% em k = 10, e em k = 20 não é significante a 90%.
- Os quatro horizontes foram lidos um a um, sem teste conjunto. As janelas se aninham, então os testes
  não são independentes.

## 5. ⚠ Conta exploratória, fora da regra e não versionada

Depois de ver os resultados, uma conta no scratchpad mediu a influência de cada reunião (dfbeta) nos
horizontes significantes. **Não é resultado da rodada.**
- **Câmbio em k = 20.**
  - Nenhuma reunião sozinha move o ponto em mais de 0,033: a que mais move é a de 2022-03-16, com
    surpresa −20,5 p.b.
  - Sem a de 2020-03-18, o ponto é 0,117 (p 0,043).
- **CDS.**
  - A reunião de 2020-03-18 puxa o coeficiente para baixo: a surpresa é +23,4 p.b., e o CDS cai 158 p.b.
    até k = 5 e 90 até k = 20.
  - Sem ela, o CDS é positivo e significante a 95% em k = 5 (+12,0, p 0,008), k = 10 (+20,7, p 0,003) e
    k = 20 (+27,7, p 0,014).
- Tirar reuniões não está na regra. Para entrar na entrega, essa conta precisa de regra própria fixada
  antes, como a do passo 3.

## 6. O que pode e o que não pode ser dito

- **Pode** (a significância segue a seção 2):
  - Com o Yahoo e a surpresa ortogonalizada, +50 p.b. de surpresa vêm com o real apreciando R$ 0,029,
    da última cotação antes do anúncio à primeira depois, significante a 90%.
  - Até a 20ª cotação, cerca de quatro semanas depois, o real deprecia R$ 0,122, significante a 95%
    (2,40%, significante a 90%).
  - O CDS não responde de forma significante a 90% até a 5ª cotação. Até a 10ª, alarga 16,5 p.b.,
    significante a 95%. Até a 20ª, +19,9 p.b., não significante a 90%.
  - A troca de sinal do câmbio já aparece na trajetória diária posterior ao evento, antes de passar à
    frequência mensal ou ao DFM.
- **Não pode:**
  - Comparar magnitudes com o DFM. O DFM normaliza por +50 p.b. da `yield_6m` de fim de mês, e aqui a
    normalização é +50 p.b. de surpresa.
  - Datar a troca de sinal. Em k = 5 e k = 10 o câmbio não é significante a 90%, e entre k = 1 e k = 20
    não há outro horizonte estimado.
  - Ler como resposta zero os horizontes não significantes: k = 5 e 10 do câmbio, e k = 1, 5 e 20 do
    CDS.
  - Atribuir a reversão a um mecanismo. A janela de 20 cotações acumula quatro semanas de notícias, e a
    forma reduzida só diz o quanto a variação acumulada se correlaciona com a surpresa.
  - Dizer que o CDS fecha às 17h de Nova York. É decisão do autor sobre um horário que nem o arquivo nem
    os dados fixam (nota `2026-10-13_ponte_horarios_copom`, seção 5).
  - Tratar a hora da cotação do Yahoo como declarada. Ela é inferida (nota
    `2026-10-13_cambio_yahoo_convencao`, seção 1).
  - Citar a conta da seção 5 como resultado.

## 7. O que muda com as respostas do orientador (e-mail de 14-10)

- **Câmbio (pergunta 1).** Fica o Yahoo, por decisão do autor de 14-10. Se a janela mudar, rodar de novo
  `copom_timing.R`, `daily_event.R` e `event_trajectory.R`, que leem a janela de `meetings.csv`.
- **CDS (pergunta 2).** 17h de Nova York, por decisão do autor. Se o orientador indicar outro horário,
  o item reabre.
- **As 9 reuniões (pergunta 3).** Se entrarem, mudam o instrumento e a base, e tudo roda de novo.
- **Em aberto.** O passo 2 (`daily_event.R`) e a linha diária do Anexo B (`het_conditions.R`) ainda
  usam o CDS de quarta a quinta. Pela decisão de 14-10, passam às 17h de NY. É item aberto no Tema B.

## 8. O que mudou

- `script/event_trajectory.R`, novo, escreve `output/event_trajectory/`:
  - `paths.csv`, uma linha por reunião × série × k;
  - `regressions.csv`, uma linha por resposta × k × amostra, com k = 1 também nas 102.
- Nada em `R/`, `data/`, no instrumento ou na produção. O smoke test não se aplica.
