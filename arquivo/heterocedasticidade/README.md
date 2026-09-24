# `arquivo/heterocedasticidade/` — identificação por heterocedasticidade

**Abandonada em 2026-08-17, por decisão do autor.** A produção segue com uma
única identificação, o **proxy externo** `z_jk_bs_purif`. O resultado negativo
passou a ser reportado no paper em 2026-09-01, sem reativar a rota como
especificação ou robustez.

> **Vintage corrente do diagnóstico mensal:** desde 2026-09-21 ela **não está
> mais aqui**, e desde 2026-09-22 a estatística é outra. O diagnóstico roda na
> produção `(5,5,4)` sob a escala de Lenza-Primiceri por `script/het_conditions.R`
> e `R/identification/het_tests.R`, e o teste é o `Qr` sequencial de Lütkepohl et
> al. (2021) do pacote `svars`, não mais o teste de proporcionalidade de Mauchly.
> **Todo valor-p desta pasta é descontinuado**, não apenas antigo. Os artefatos
> vivos ficam em `output/het/` e a nota é `notas/2026-09-22_condicao_het_svars.md`.
> O que
> esta pasta guarda é a vintage anterior: painel de 115 séries, `(r,q,p)=(4,4,4)`,
> reestimado em 2026-09-01, e a réplica diária de quatro variáveis, cuja fixture
> foi copiada para `output/validation/het_daily_changes_referee2.csv` para que
> nenhum caminho vivo leia de `arquivo/`.
>
> **A identificação continua morta.** O que voltou ao código foi a bateria de
> testes; `ident_het_regimes()` e `het_shock_extraction.R` seguem removidos, e
> nenhuma IRF sai desse ramo.

## Veredito

Reprovada em **duas frentes**, com dois anos de calendário de projeto entre elas:

1. **Como instrumento** (`z_het*`, Rigobon-Sack 2003) — abandonada em
   **2026-07-16**. As quatro variantes `z_het*` nunca entraram na produção.
2. **Como identificação primária** (Rigobon 2003 sobre as inovações do
   factor-VAR) — abandonada em **2026-08-01** no objeto mensal e definitivamente
   em 2026-08-17. Na reestimação de 2026-09-01, **zero das 450 células válidas
   identificam**. No desenho de calendário, a célula corrente produz
   `LR/p_boot=38,36/0,0559` na amostra completa e `13,34/0,2754` no pré-COVID;
   nenhuma das 100 células sobrevive à correção de Holm.

**A leitura que sobrevive:** a heterocedasticidade que identifica no diário
(Rigobon-Sack) não se transporta para o objeto mensal. ⚠ Desde 2026-09-22 o
projeto não atribui essa falha à agregação temporal: entre o diário e o mensal
mudam a frequência e o tipo de variação ao mesmo tempo, e nada separa as duas.
Sem coluna separável não há
direção monetária, e por isso **nunca houve estágio de IRF** neste ramo — qualquer
IRF ali seria número sem identificação atrás.

**Ponta solta declarada e nunca tentada:** heterocedasticidade *condicional*
(GARCH-SVAR, Lanne-Saikkonen 2007 / Normandin-Phaneuf 2004), que dispensa datas
de regime. É outro ramo, não Rigobon; nunca foi tentado, ainda que o `svars`
esteja instalado desde 2026-09-22 para o teste de identificação.

## O que permanece aqui

| pasta | conteúdo |
|---|---|
| `registro/historico_decisoes_secao1.md` | corpo integral da antiga §1 de `registro/historico_decisoes.md` — a fonte detalhada |
| `output/het/` | artefatos da reestimação de 2026-09-01 — grade do gate, veredito por célula, datas de quebra, superfície e relatório |
| `notas/` | `2026-08-01_robustez_heterocedasticidade.md` — a nota citável da rodada mensal |
| `_instrucoes/` | `Heteroscedasticidade.md`, `plano_reimplementacao_het.md` |

O código exclusivamente dedicado à rota foi removido do repositório em
2026-09-01. Ele permanece recuperável pelo histórico Git, e em **2026-09-21 a
metade de diagnóstico foi recuperada** de `9c25fee^` e portada para a API
corrente, em `R/identification/het_tests.R` e `script/het_conditions.R`, que em
2026-09-22 foi reescrito sobre o estimador e o teste do pacote `svars`. A correspondência
externa e sua réplica Python ficaram intactas porque pertencem ao registro
verbatim do parecer, não ao código ativo do projeto.

## Material relacionado que ficou fora desta pasta

Por serem de conteúdo misto ou verbatim, seguem em `arquivo/`:

- [`../relatorio/2026-04-25_blindspot_het_instrument.md`](../relatorio/2026-04-25_blindspot_het_instrument.md)
- [`../relatorio/2026-04-26_blindspot_validation.md`](../relatorio/2026-04-26_blindspot_validation.md)
- [`../relatorio/council_2026-05-05.md`](../relatorio/council_2026-05-05.md)
- [`../relatorio/correspondence/referee2/`](../relatorio/correspondence/referee2/) — réplica NumPy do bloco Rigobon-Sack e os dois rounds do Referee 2

`R/identification/validation_tests.R` **continua vivo** no repositório: a suíte
T1-T8 foi escrita para `z_het_jk`, mas as funções são agnósticas ao instrumento.

## Referências

- Rigobon (2003, *RES*); Rigobon & Sack (2003 *QJE*; 2004 *JME*)
- Stock & Watson (2018, *EJ*) §4.7
- Lanne & Lütkepohl (2008) — teste de rank para ΔΣ
- Gonçalves, Rodrigues & Genta (2025, IMF WP/25/48) — aplicação ao Brasil em
  frequência diária. **Esta continua citada no paper**: é evidência alheia com
  que o artigo dialoga, não a estratégia deste projeto.
