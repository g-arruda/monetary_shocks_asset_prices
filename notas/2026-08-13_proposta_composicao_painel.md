# Proposta de ampliação da composição do painel

> **PROPOSTA, 2026-08-13.** Esta nota registra uma pauta para diagnósticos de
> composição do painel. O vintage corrente contém 106 séries entre 2013-01 e
> 2025-09, e a especificação de produção continua sendo `(r, q, p) = (7, 6,
> 6)` com `z_jk_bs_purif` e normalização em `yield_6m`. Nenhuma série, fator,
> instrumento ou resultado de produção foi alterado. A evidência vem de
> `diagnostics/output/t3_*`, do painel processado e de reestimações de ponto
> sem bootstrap feitas nesta data.

## Motivo

O painel já cobre atividade, trabalho, indústria, preços, crédito, moeda,
câmbio, curva de juros, risco, ações e incerteza. A auditoria de duplicatas
encontra apenas dois pares com correlação em primeiras diferenças acima de
0,98, e retirá-los eleva `xi_mp` de 7,65 para 7,94. Portanto, duplicação
literal não explica a relevância moderada da especificação corrente.

A composição ainda é concentrada na margem financeira. Os oito itens de juros
correspondem a 7,5% do painel, mas respondem por 26,4% da carga quadrática do
segundo componente principal. Ao retirar os sete itens de juros distintos de
`yield_6m`, `xi_mp` cai de 7,65 para 1,24 e o primeiro estágio HC1 cai de 7,95
para 0,95. O resultado é esperado em parte, pois o instrumento mede surpresa
de DI e o choque é normalizado em `yield_6m`, mas mostra que a força depende da
representação da curva e não dos grandes blocos reais. Retirar trabalho,
indústria, preços ou crédito não reduz `xi_mp`.

Nenhuma série isolada explica a força. A retirada individual de `yield_1y` e
`yield_2y` reduz `xi_mp` para 5,21 e 5,55, respectivamente. As retiradas de
`epu_brazil`, `epu_germany` e `epu_us` também reduzem a estatística, mas o
resultado não autoriza excluir ou selecionar séries por esse critério. Ele
apenas define onde o teste de composição deve procurar dependência excessiva.

## Cinco classes a testar

As cinco classes abaixo criam contrapesos econômicos para a concentração na
curva. Cada classe deve entrar primeiro como bloco separado e com cobertura da
amostra inteira, nunca como conjunto de controles no estágio de identificação.

### 1. Condições financeiras externas

Adicionar nível ou retorno do S&P 500, índice do dólar, Treasury americano de
dois anos e, se houver série mensal com cobertura integral, um índice de
condições financeiras globais. O painel contém VIX, MSCI, EMBI+ e CDS, mas não
contém nível do S&P 500. A ausência já é uma pendência do teste de placebo e
limita a separação entre notícia global, aperto americano e choque doméstico.

### 2. Setor externo real

Adicionar volumes ou valores reais de exportações e importações, termos de
troca e uma medida mensal de atividade chinesa. Essas séries permitem que o
fator externo distinga demanda por exportações, preços de commodities e
condições financeiras globais, que hoje aparecem em poucos preços de mercado.

### 3. Situação fiscal

Adicionar resultado primário, dívida pública e necessidade de financiamento
do setor público em frequência mensal. EMBI+ e CDS medem o preço do risco
soberano, mas não medem diretamente o fundamento fiscal que pode anteceder
esse preço. A inclusão deve respeitar a data de divulgação disponível em cada
mês para não introduzir informação posterior na série mensal.

### 4. Expectativas macroeconômicas

Adicionar expectativas Focus para IPCA, Selic e PIB no horizonte de doze
meses. O projeto já usa previsões Focus na purificação pré-evento do
instrumento, mas elas não pertencem ao painel de fatores. Como expectativas
podem separar reação a notícia de inflação, crescimento e política, devem ser
testadas como bloco próprio e sem usar observações revisadas posteriores ao
mês de referência.

### 5. Condições de crédito bancário

Adicionar inadimplência, taxas de concessão por modalidade, spreads bancários
e custo de captação. O painel contém estoques de crédito e dois spreads ICC,
mas essa cobertura não separa quantidade de crédito, preço do empréstimo e
risco de balanço. O bloco novo deve privilegiar medidas agregadas para não
substituir uma concentração da curva por uma concentração de modalidades de
crédito.

## Protocolo antes de qualquer mudança de produção

Cada classe deve ser testada em variante isolada e em uma variante conjunta
pré-definida. A comparação deve conservar a amostra 2013-01 a 2025-09, aplicar
o mesmo tratamento de transformações e registrar fonte, data de divulgação e
cobertura de cada série. Séries que reduzam a amostra, que dependam de revisão
posterior ou que não tenham definição econômica distinta devem ficar fora.

A avaliação deve reportar `xi_mp` e `F_rob,mp`, cargas e comunalidade por
bloco, e IRFs de `yield_6m`, `yield_2y`, `yield_5y`, `asset_ibov` e
`cambio_usd`. A escolha não pode ser feita pelo maior `xi_mp`. A pergunta é se
a força e as respostas relevantes sobrevivem quando a curva deixa de ser a
única fonte organizada de informação financeira e externa, não qual adição
produz a estatística mais alta.
