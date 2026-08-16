# Infraestrutura de download das candidatas ao painel

> Gerado por `Rscript script/download.R --candidates-only` em 2026-08-13.
> Estes arquivos não integram `data/raw/raw_data.csv` e não alteram o painel de produção.

## Séries coletadas

| bloco | código/ID | nome oficial | fonte | unidade | frequência na fonte | arquivo | produtor | ressalva |
|---|---|---|---|---|---|---|---|---|
| fiscal | 13762 | Dívida bruta do governo geral (% PIB) - Metodologia utilizada a partir de 2008 | BCB/SGS | Percentual | mensal | data/raw/panel_candidates/sgs_13762.csv | R/data_download/bcb.R | Série corrente; o SGS não permite reconstruir o vintage disponível em tempo real. |
| fiscal | 4513 | Dívida Líquida do Setor Público (% PIB) - Total - Setor público consolidado | BCB/SGS | Percentual | mensal | data/raw/panel_candidates/sgs_4513.csv | R/data_download/bcb.R | Série corrente; o SGS não permite reconstruir o vintage disponível em tempo real. |
| fiscal | 4649 | NFSP sem desvalorização cambial - Fluxo mensal corrente - Resultado primário - Total - Setor público consolidado | BCB/SGS | Milhões de reais | mensal | data/raw/panel_candidates/sgs_4649.csv | R/data_download/bcb.R | Muda de sinal e não admite log; série corrente sem reconstrução de vintage em tempo real. |
| setor_externo | 23079 | Transações Correntes acumulado em 12 meses em relação ao PIB - mensal | BCB/SGS | Percentual | mensal | data/raw/panel_candidates/sgs_23079.csv | R/data_download/bcb.R | Escolhida em vez do saldo mensal 22701 para manter o bloco pequeno. |
| setor_externo | 22708 | Exportação de bens - Balanço de Pagamentos - mensal | BCB/SGS | Milhões de dólares americanos | mensal | data/raw/panel_candidates/sgs_22708.csv | R/data_download/bcb.R | Total de bens no BPM6; o saldo 22707 é excluído para evitar identidade exata. |
| setor_externo | 22709 | Importação de bens - Balanço de Pagamentos - mensal | BCB/SGS | Milhões de dólares americanos | mensal | data/raw/panel_candidates/sgs_22709.csv | R/data_download/bcb.R | Total de bens no BPM6; o saldo 22707 é excluído para evitar identidade exata. |
| setor_externo | 3546 | Reservas internacionais - Total - mensal | BCB/SGS | US$ (milhões) | mensal | data/raw/panel_candidates/sgs_3546.csv | R/data_download/bcb.R | Conceito liquidez; nível mensal. |
| expectativas | FOCUS_IPCA12M | Expectativa Focus para IPCA suavizado nos próximos 12 meses | BCB/Focus Olinda | Percentual | diária | data/raw/panel_candidates/focus_ipca12m.csv | R/data_download/focus_fred.R | Última mediana publicada dentro de cada mês; sem revisão retrospectiva. |
| expectativas | FOCUS_SELIC_NY | Expectativa Focus para Selic no fim do ano seguinte | BCB/Focus Olinda | Percentual ao ano | diária | data/raw/panel_candidates/focus_selic_ny.csv | R/data_download/focus_fred.R | Última mediana publicada dentro de cada mês para horizonte de ano seguinte. |
| expectativas | FOCUS_PIB_NY | Expectativa Focus para PIB Total no ano seguinte | BCB/Focus Olinda | Variação percentual anual | diária | data/raw/panel_candidates/focus_pib_ny.csv | R/data_download/focus_fred.R | Última mediana publicada dentro de cada mês para horizonte de ano seguinte. |
| expectativas | FOCUS_CAMBIO_NY | Expectativa Focus para câmbio no fim do ano seguinte | BCB/Focus Olinda | R$/US$ | diária | data/raw/panel_candidates/focus_cambio_ny.csv | R/data_download/focus_fred.R | Última mediana publicada dentro de cada mês para horizonte de ano seguinte. |
| eua | DGS10 | Market Yield on U.S. Treasury Securities at 10-Year Constant Maturity, Quoted on an Investment Basis | Federal Reserve Board via FRED | Percentual | diária | data/raw/panel_candidates/fred_DGS10.csv | R/data_download/focus_fred.R | Última observação disponível dentro de cada mês. |
| eua | FEDFUNDS | Federal Funds Effective Rate | Federal Reserve Board via FRED | Percentual | mensal | data/raw/panel_candidates/fred_FEDFUNDS.csv | R/data_download/focus_fred.R | Média mensal de observações diárias publicada pela fonte. |
| eua | DTWEXBGS | Nominal Broad U.S. Dollar Index | Federal Reserve Board via FRED | Índice jan/2006=100 | diária | data/raw/panel_candidates/fred_DTWEXBGS.csv | R/data_download/focus_fred.R | Última observação disponível dentro de cada mês. |
| credito | 21082 | Inadimplência da carteira de crédito - Total | BCB/SGS | Percentual | mensal | data/raw/panel_candidates/sgs_21082.csv | R/data_download/bcb.R | Agregado; não abre modalidades de crédito. |
| credito | 20714 | Taxa média de juros das operações de crédito - Total | BCB/SGS | Percentual ao ano | mensal | data/raw/panel_candidates/sgs_20714.csv | R/data_download/bcb.R | Agregado; não abre modalidades de crédito. |
| imoveis | 21340 | Índice de Valores de Garantia de Imóveis Residenciais Financiados (IVG-R) | BCB/SGS | Índice | mensal | data/raw/panel_candidates/sgs_21340.csv | R/data_download/bcb.R | Candidata única do bloco imobiliário. |

## Insumos existentes reutilizados

| bloco | código/ID | nome oficial | fonte | unidade | frequência na fonte | arquivo | produtor | ressalva |
|---|---|---|---|---|---|---|---|---|
| eua | DGS2 | Market Yield on U.S. Treasury Securities at 2-Year Constant Maturity, Quoted on an Investment Basis | Federal Reserve Board via FRED | Percentual | diária | data/raw/fred_dgs2.csv | R/data_download/focus_fred.R | Reutilizar o arquivo diário existente; não baixar uma duplicata candidata. |
| eua | ^GSPC | S&P 500 Index | Yahoo Finance | Índice | diária | data/raw/investing/external_factors_daily.csv | R/data_download/external_factors.R | Reutilizar a coluna sp500 com cobertura integral; SP500 do FRED é proibido. |

## Exclusões e bloqueios

| bloco | código/ID | nome | status | motivo |
|---|---|---|---|---|
| eua | T10Y2Y | 10-Year Treasury Constant Maturity Minus 2-Year Treasury Constant Maturity | deliberadamente excluída | Diferença linear exata entre DGS10 e DGS2. |
| eua | SP500 | S&P 500 | deliberadamente excluída | Cobertura começa em 2016-08 e truncaria 43 meses; Yahoo ^GSPC já existe. |
| setor_externo | 22701 | Transações correntes - mensal - saldo | deliberadamente excluída | 23079 foi escolhida para representar transações correntes sem ampliar o bloco. |
| setor_externo | 22702 | Transações correntes - mensal - receita | deliberadamente excluída | Perna da identidade 22701 = 22702 - 22703; 23079 representa transações correntes. |
| setor_externo | 22703 | Transações correntes - mensal - despesa | deliberadamente excluída | Perna da identidade 22701 = 22702 - 22703; 23079 representa transações correntes. |
| setor_externo | 22707 | Balança comercial - Balanço de Pagamentos - saldo | deliberadamente excluída | Identidade exata 22707 = 22708 - 22709. |
| setor_externo | 22710 | Balança comercial - mercadorias em geral - Balanço de Pagamentos - mensal - saldo | deliberadamente excluída | Identidade exata 22710 = 22711 - 22712; a infraestrutura seleciona o total de bens 22708/22709. |
| setor_externo | 22711/22712 | Exportações/importações de bens - mercadorias em geral | deliberadamente excluída | Subcomponentes de mercadorias em geral; 22708/22709 são os totais de bens selecionados. |
| setor_externo | termos_de_troca | Termos de troca FUNCEX | bloqueada por ambiguidade de definição | A nota não fixa série, unidade, endpoint nem tratamento. |
| setor_externo | atividade_chinesa | Indicador de atividade chinesa | bloqueada por ambiguidade de definição | A nota não define indicador ou fonte oficial. |
| credito | modalidades_credito | Taxas, captação e risco por modalidade | deliberadamente excluída | Família ampla violaria o princípio de blocos pequenos e sobrepesaria crédito. |

## Limitação de vintage fiscal

Os arquivos SGS fiscais contêm a vintage corrente recuperada na data de execução. O produtor público
consultado não fornece a sequência de vintages disponível em tempo real para cada mês de referência;
portanto, esta infraestrutura não autoriza interpretar essas séries como informação conhecida no mês.

## Validações embutidas

Antes de gravar, o subestágio confirma os metadados SGS na fonte oficial, exige exatamente 153 meses
de 2013-01 a 2025-09, datas únicas, valores finitos e ausência de lacunas. Focus usa a última publicação
dentro de cada mês. A validação independente é `Rscript script/validate_candidate_downloads.R`.
