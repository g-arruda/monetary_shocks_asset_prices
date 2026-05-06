## <span id="page-12-0"></span>2.3 Test of the identification assumptions

Variance tests allow us to check if the identifying assumptions just discussed are valid. According to expression (5), the variance of  $\Delta i_t$  should be higher in subset C than in subset NC and, following (6), there should be no such difference in variances for the explained variables  $\Delta \pi_t^e$ ,  $\Delta_t$  and  $\Delta E_t$ .

Table 1 shows the ratio between variances in set C and set N for all variables used, along with a 99% confidence interval.

The variances for  $\Delta i_t$  differ markedly across the subsamples. For  $\Delta \pi_t^e$ ,  $\Delta_t$  and  $\Delta E_t$ , conversely, we cannot reject the null of equal variances. The exception is the 2-year inflation expectations. Hence the identifying conditions hold in most cases and, accordingly, the instrumental variables strategy employed should be able to identify true causal effects.

Table 1: Variance tests using TNC > TC

<span id="page-13-2"></span>

|                |              | Ratio of variances | 99% CI       |
|----------------|--------------|--------------------|--------------|
| $\Delta i$     | Maturity 12m | 2.33               | [1.65; 3.42] |
|                | Maturity 6m  | 3.40               | [2.42; 4.99] |
|                | Maturity 3m  | 4.53               | [3.21; 6.65] |
|                | Maturity 1m  | 5.25               | [3.73; 7.69] |
| $\Delta \pi^e$ | 1 year       | 1.23               | [0.88; 1.81] |
|                | 2 years      | 1.59               | [1.13; 2.34] |
|                | 3 years      | 1.33               | [0.95; 1.96] |
|                | 5 years      | 1.11               | [0.79; 1.63] |
|                |              |                    |              |
| $\Delta E$     |              | 0.92               | [0.65; 1.35] |
| $\Delta risk$  |              | 0.85               | [0.60; 1.24] |

Notes: The table displays tests of the identification assumptions based on Rigobon's (2003) methodology. Specifically, we check for differences in variances across set C (weeks with Copom meeting) and set N (weeks without Copom meeting), using daily data between September 2009 and August 2024. The middle column of the table shows the ratio between variances in set C and in set N. The last column presents the 95% confidence interval for this ratio. We show statistics for the change in nominal interest rates ( $\Delta i$ ), the change in inflation expectations ( $\Delta \pi^e$ ), and the percentage change in the BRL/USD exchange rate ( $\Delta E$ ).  $\Delta i$  is measured by changes in interbank deposit rate. We use three maturities: 1 year, 6 months and 3 months. Inflation expectations are measured taking the difference between inflation linked and non-inflation linked government bonds. In this case, we calculate the variance ratio for 1, 2 and 5-year maturities: For all variables, differences were computed between Wednesday's and Thursday's values in **every week** within our sample.

### <span id="page-13-0"></span>3 Results

## <span id="page-13-1"></span>3.1 OLS: whole sample and "event study"

Figures 2 and 3 below show, respectively, the correlation pattern between  $\Delta i$  and  $\Delta \pi^e$  for the whole sample and for the dates of Copom meetings only (as in the case study literature).

A naive interpretation of the correlation pattern displayed on the left chart in table 2 might lead to the conclusion that increases in interest rates backfire: inflation expectations increase with positive interest rate surprises. And even when looking at Copom meetings only (chart on the right), one would not be able to conclude that tightenings lead to lower inflation expectations. The slope, though negative, is not statistically significant. Thus an event-study strategy would suggest no impact of monetary policy on inflation expectations.

<span id="page-14-0"></span>![](_page_14_Figure_0.jpeg)

Figure 2: Full Sample

Figure 3: Only Copom meetings

Table 2: From naive OLS to case study coefficient

We next report OLS estimates of  $\Delta \pi^e$  on  $\Delta i$  for the whole sample. Table 3 displays the results for four different measures of changes in inflation expectations and four different measures of changes in interest rates: 1 month, 3 months, 6 months and 1 year. All coefficients are *positive*.

Table 3: OLS estimates: full sample and case study

<span id="page-14-1"></span>

|                      | Interest rate measure = $\Delta $ ß |          |          |           |  |  |
|----------------------|-------------------------------------|----------|----------|-----------|--|--|
|                      | 1 month                             | 3 months | 6 months | 12 months |  |  |
| Full Sample $\beta$  | 0.16*                               | 0.25***  | 0.24***  | 0.21***   |  |  |
| (se)                 | (0.07)                              | (0.05)   | (0.03)   | (0.02)    |  |  |
| Copom Sample $\beta$ | -0.13                               | -0.09    | -0.02    | +0.01     |  |  |
| (se)                 | (0.11)                              | (0.09)   | (0.06)   | (0.05)    |  |  |

Notes: This table displays OLS regression results of changes in inflation expectations ( $\Delta\pi^e$ ) against changes in nominal interest rates ( $\Delta i$ ). Constants are included but not reported. We use daily data from Brazilian assets between September 2009 and December 2024.  $\Delta\pi^e$  is computed as the difference between Wednesday's and Thursday's observations. We run regressions using different measures of monetary shocks but always the same y-variable,  $\Delta\pi^e_{1year}$ . Numbers in parentheses are Newey-West standard errors.

These results were already hinted at in the correlation charts above. The positive and statistically significant coefficients in the first row could be hastily (and mistakenly) interpreted as evidence of the tight money paradox. The second row suggests this to be likely due to endogeneity – market future interest rates increase when expected inflation

increases – but if we were to stop at the case study regression, the verdict would still be very unfavorable to monetary policy: no impact on inflation expectations.

In the next subsection, we present the IV estimations exploiting the data's heteroskedasticity. Using this technique, we uncover a strong and consistent **textbook-like** impact of monetary policy on inflation expectations and the exchange rate.

## <span id="page-15-0"></span>**3.2 Effect of monetary surprises on inflation expectations using IV**

The main IV results are shown in Table [4.](#page-15-2) Now all estimates are negative and display small standard-errors (majority of p-values are smaller than 1%). Positive interest rate surprises at different maturities are associated with lower inflation expectations at all horizons.

Table 4: IV through heteroskedasticity estimates

<span id="page-15-2"></span>

|                     | Δ𝜋<br>Dependent variable =<br>𝑒 |                    |                    |                    |
|---------------------|---------------------------------|--------------------|--------------------|--------------------|
|                     | 1 year                          | 2 years            | 3 years            | 5 years            |
| Δ<br>𝑖<br>(1 month) | -0.27***<br>(0.07)              | -0.64***<br>(0.07) | -0.69***<br>(0.08) | -0.67***<br>(0.07) |
| Δ<br>𝑖              | -0.26***                        | -0.60***           | -0.69***           | -0.69***           |
| (3 months)<br>Δ     | (0.07)<br>-0.21***              | (0.06)<br>-0.45*** | (0.07)<br>-0.53*** | (0.07)<br>-0.67*** |
| 𝑖<br>(6 months)     | (0.05)                          | (0.05)             | (0.06)             | (0.08)             |
| Δ                   | -0.20***                        | -0.43***           | -0.50***           | -0.53***           |
| 𝑖<br>(12 months)    | (0.06)                          | (0.07)             | (0.07)             | (0.06)             |
| N                   | 768                             | 768                | 768                | 768                |

Notes: This table displays IV regression results of changes in inflation expectations (Δ ) against changes in nominal interest rates (Δ) using four measures of expectations and also changes in interest rates at four different maturities.

<span id="page-15-1"></span>In terms of magnitudes, using Table [4](#page-15-2) a 100 basis point surprise in the interest rate leads to a reduction of between 0.2 to 0.3 percentage points in the 1-year ahead measure of inflation expectations.

## **3.3 Effect of monetary surprises on CDS and the exchange rate**

We now evaluate the impact of monetary shocks on the exchange rate and a risk measure. In theory, an increase in interest rates could lead to a currency depreciation via higher probability of default. The results of the previous subsection indicate that even if that were to be true, monetary tightenings would still bring down inflation expectations.

IV Regressions featuring both <sup>Δ</sup> and <sup>Δ</sup> as the dependent variable do not lend credence to the "higher rates leading to depreciation via increased risk" story. Positive interest rate surprises cause an appreciation of the Brazilian currency (the Real) against the U.S. dollar (and do not seem to affect the CDS either).

<span id="page-16-1"></span>

|             |          | Interest rate measure = | Δß       |           |
|-------------|----------|-------------------------|----------|-----------|
|             | 1 month  | 3 months                | 6 months | 12 months |
| Δ           | -5.64*** | -5.10***                | -3.93*** | -3.42***  |
| 𝐸<br>(se)   | (0.91)   | (0.75)                  | (0.63)   | (0.69)    |
| Δ           | 0.01     | -0.03                   | -0.05    | -0.11*    |
| 𝐶𝐷𝑆<br>(se) | (0.06)   | (0.05)                  | (0.04)   | (0.05)    |

Table 5: Exchange rate and Risk: IV estimates

Notes: This table displays IV results using the same technique as before. We report the coefficients using the 5-year CDS. The results with changes in 1-year CDS are available upon request.

## <span id="page-16-0"></span>**3.4 Robustness tests**

We test the robustness of our results through three additional checks[14](#page-16-2). First, in Table [6](#page-17-0) we present the results when, instead of using market measures of inflation expectations, we resort to expected inflation from the Central Bank's survey with market participants. Specifically, models are run using the average of 12 months ahead inflation expectation reported by all survey participants (top row) and only the from the top 5 forecasters (bottom row). The benefit of using this measure is that it is not contaminated by the risk premia. The disadvantage, as mentioned before, is its weekly frequency.

Reassuringly, the results obtained using Brazilian securities are also borne out using survey data instead. Out of 8 entries in Table [6,](#page-17-0) only one is not statistically significant. Interestingly, coefficients are larger in the upper row, which uses the median of all survey respondents.

The second robustness exercise consists of excluding episodes with very large swings in expected inflation. Specifically, we exclude all Δ above the percentile 0.95 and below

<span id="page-16-2"></span><sup>14</sup>Here, we report results for two measures of interest rate surprises only: 12m and 3m

Table 6: Using survey measure of  $\pi^e$ 

<span id="page-17-0"></span>

|                            |          | Interest rate measure = $\Delta $ ß |          |           |  |  |
|----------------------------|----------|-------------------------------------|----------|-----------|--|--|
|                            | 1 month  | 3 months                            | 6 months | 12 months |  |  |
| $\Delta\pi^e_{survey}$     | -0.60*** | -0.54***                            | -0.43*** | -0.36***  |  |  |
| (se)                       | (0.17)   | (0.13)                              | (0.11)   | (0.12)    |  |  |
| $\Delta\pi^e_{surveytop5}$ | -0.25*** | -0.20***                            | -0.13**  | -0.09     |  |  |
| (se)                       | (0.10)   | (0.08)                              | (0.06)   | (0.07)    |  |  |

Notes: This table displays the results of monetary policy shocks on inflation expectations reported by market participants to the CB. The first row includes all participants; the second row includes forecasts from the top-5 forecasters only.

percentile 0.05. This reduces the sample to 689 observations and makes it harder to identify the impact of monetary policy since variability in the variable of interest is curtailed.

Table 7: Excluding changes in inflation above P(95) and below P(05)

<span id="page-17-1"></span>

| $\Delta i$ used | $\Delta \pi^e 1y$ | $\Delta \pi^e 2y$ | $\Delta \pi^e 3y$ | $\Delta \pi^e 5y$ | $\frac{\Delta E}{E}$ |
|-----------------|-------------------|-------------------|-------------------|-------------------|----------------------|
| 3 months        | -0.07*            | -0.47***          | -0.59***          | -0.61***          | -2.00**              |
| (se)            | (0.04)            | (0.05)            | (0.04)            | (0.06)            | (0.69)               |
| 12 months       | -0.12***          | -0.39***          | -0.46***          | -0.46***          | -0.94*               |
| (se)            | (0.03)            | (0.05)            | (0.04)            | (0.05)            | (0.48)               |

Number of observations is now 689.

The third test focuses on sub-samples. We report results for six different 10-year moving windows with start dates in 2009, 2010, 2011, 2012, 2013 and 2014. We use the 3-month interest rate in all specifications. Out of the 18 entries in Table 8, only one is borderline significant. Moreover, over time monetary policy effectiveness seems to have increased judging by the second and third rows.

Table 8: Moving window IV regressions: 3m interest rates

<span id="page-17-2"></span>

|                      | 2009:2019 | 2010:2020 | 2011:2021 | 2012:2022 | 2013:2023 | 2014:2024 |
|----------------------|-----------|-----------|-----------|-----------|-----------|-----------|
| $\Delta \pi^e 1y$    | -0.25 *** | -0.13 *** | -0.17 **  | -0.18 **  | -0.21 **  | -0.19 *   |
| (se)                 | 0.06      | 0.05      | 0.08      | 0.09      | 0.10      | 0.11      |
| $\Delta \pi^e 5y$    | -0.61 *** | -0.56 *** | -0.79 *** | -0.81 *** | -0.85 *** | -0.91 *** |
| (se)                 | 0.06      | 0.06      | 0.09      | 0.10      | 0.11      | 0.13      |
| $\frac{\Delta E}{E}$ | -2.85 *** | -3.67 *** | -5.50 *** | -5.90 *** | -7.70 *** | -8.79 *** |
| (se)                 | 0.73      | 0.73      | 0.97      | 1.06      | 1.25      | 1.40      |

Finally, there is a significant number of instances in which the Copom meeting coincides with FOMC Meetings in the US: 32 from 2009 to the end of 2024. If variables

that are potentially relevant to explain inflation expectations in Brazil, such as commodity prices, display higher variance on the days of FOMC that are also Copom days, a bias could be introduced to our estimates. Our fourth robustness exercise hence consists of dropping those common dates from the sample.

<span id="page-18-1"></span>The new C-subsample now has 90 data points, whereas the NC-subsample is kept unchanged. Results presented in Table [9](#page-18-1) show this paper's main message remains in this smaller sample.

Table 9: Dropping FOMC dates

|                  | Δ<br>Δ𝜋<br>𝑒 and<br>𝐸                              |          |          |          |          |  |  |  |
|------------------|----------------------------------------------------|----------|----------|----------|----------|--|--|--|
|                  | 𝐸<br>1 year<br>2 years<br>3 years<br>5 years<br>FX |          |          |          |          |  |  |  |
| Δ                | -0.35***                                           | -0.82*** | -0.89*** | -0.82*** | -5.90*** |  |  |  |
| 𝑖<br>(3 month)   | (0.07)                                             | (0.08)   | (0.08)   | (0.08)   | (0.95)   |  |  |  |
| Δ                | -0.27.***                                          | -0.65*** | -0.72*** | -0.71*** | -4.98*** |  |  |  |
| 𝑖<br>(12 months) | (0.08)                                             | (0.11)   | (0.12)   | (0.11)   | (1.03)   |  |  |  |
| N                | 736                                                | 736      | 736      | 736      | 736      |  |  |  |

Notes: This table displays IV regression results of changes in inflation expectations and the exchange rate against changes in nominal interest rates. The methodology is always Rigobon's identification through heteroskedasticity, but the sample is smaller because we drop days in which the Copom meeting coincides with the FOMC.

## <span id="page-18-0"></span>**4 Final remarks**

The large and thriving literature on HFI of monetary policy shocks has two important missing parts. First, it is too US-centric (with few exceptions). Arguably, some emerging economies' characteristics can impair monetary transmission, such as shallow credit markets, lack of fiscal credibility, risk premia, etc. Second, inflation expectations have been largely neglected, though they are a crucial determinant of actual inflation in both theoretical and empirical work. This paper bridges these two gaps by using data from an emerging economy to assess the impact of monetary surprises on inflation expectations.

The resurgence of models featuring characteristics of the FTPL also sparked a renewed interest in the unpleasant arithmetic logic of Sargent and Wallace (1981). Can monetary policy backfire if fiscal policy is active and debt is elevated? We do not find systematic evidence of that using data from Brazil.

## **References**

Andolfatto, D. (2021). "Is It Time for Some Unpleasant Monetarist Arithmetic?" *Federal Reserve Bank of St. Louis Review*, vol. 103(3), pages 315-332, July.

Ayres, J.; Garcia, M.; Guillen, D.; Kehoe, P. J. (2022). "The case of Brazil." Kehoe, T. J.; Nicolini, J. P. (eds.) *A Monetary and Fiscal History of Latin America, 1960-2017*. University of Minnesota Press.

Bauer, M. Swanson, E. (2022). "A Reassessment of Monetary Policy Surprises and High-Frequency Identification", *NBER Working Papers* 29939, National Bureau of Economic Research.

Bauer, M. Swanson, E. (2023). "An Alternative Explanation for the Fed Information Effect", *American Economic Review*, vol 113, pages 664-700.

Bhattacharya, J.; Noritaka K. (2002). "Tight money policies and inflation revisited." *Canadian Journal of Economics*, vol. 35(2), pages 185-217, May.

Bianchi, Francesco Melosi, Leonardo, 2019. "The dire effects of the lack of monetary and fiscal coordination," *Journal of Monetary Economics*, Elsevier, vol. 104(C), pages 1-22.

Blanchard, O. (2005). "Fiscal Dominance and Inflation Targeting: Lessons from Brazil." Giavazzi, F.; Goldfajn, I.; Herrera, S. (eds.) *Inflation Targeting, Debt, and the Brazilian Experience, 1999 to 2003*. Cambridge: MIT Press.

Bloomberg (2009-2024a). "Anbima Brazil Govt Bond Fixed Rate 1 Year - BZAD1Y Index." Brazilian Financial and Capital Markets Association.

Bloomberg (2009-2024b). "Anbima Brazil Govt Bond Fixed Rate 2 Year - BZAD2Y Index." Brazilian Financial and Capital Markets Association.

Bloomberg (2009-2024c). "Anbima Brazil Govt Bond Fixed Rate 3 Year - BZAD3Y Index." Brazilian Financial and Capital Markets Association.

Bloomberg (2009-2024d). "Anbima Brazil Govt Bond IPCA Rate 1 Year - BZAA1Y Index." Brazilian Financial and Capital Markets Association.

Bloomberg (2009-2024e). "Anbima Brazil Govt Bond IPCA Rate 2 Year - BZAA2Y Index." Brazilian Financial and Capital Markets Association.

Bloomberg (2009-2024f). "Anbima Brazil Govt Bond IPCA Rate 3 Year - BZAA4Y Index." Brazilian Financial and Capital Markets Association.

BM&FBOVESPA (2009-2024a). "Swap DI x pré 180 dias (nominal yield curve)." Brazilian Financial and CapitalMarkets Association. The daily data is available for download at

[https://www.b3.com.br/pt\\_br/market-data-e-indices/servicos-de-dados/mark](https://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenciais-bm-fbovespa/)et[data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenc](https://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenciais-bm-fbovespa/)iais[bm-fbovespa/](https://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenciais-bm-fbovespa/).

BM&FBOVESPA (2009-2024b). "Swap DI x pré 360 dias (nominal yield curve)." Brazilian Financial and CapitalMarkets Association. The daily data is available for download at [https://www.b3.com.br/pt\\_br/market-data-e-indices/servicos-de-dados/mark](https://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenciais-bm-fbovespa/)et[data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenc](https://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenciais-bm-fbovespa/)iais[bm-fbovespa/](https://www.b3.com.br/pt_br/market-data-e-indices/servicos-de-dados/market-data/consultas/mercado-de-derivativos/precos-referenciais/taxas-referenciais-bm-fbovespa/).

Brazilian Financial and Capital Markets Association (2009-2024a). "Term Structure and Break Even Inflation (IPCA): 1-Year Break Even Inflation (252 Business Days)." Brazilian Financial and Capital Markets Association. The daily data is available for download at [https://www.anbima.com.br/pt\\_br/informar/curvas-de-juros](https://www.anbima.com.br/pt_br/informar/curvas-de-juros-fechamento.htm)[fechamento.htm](https://www.anbima.com.br/pt_br/informar/curvas-de-juros-fechamento.htm) and the API to build the database is available at [https://developers.](https://developers.anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-value-(vna)) [anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-va](https://developers.anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-value-(vna))lue- [\(vna\)](https://developers.anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-value-(vna)).

Brazilian Financial and Capital Markets Association (2009-2024b). "Term Structure and Break Even Inflation (IPCA): 2-Year Break Even Inflation (504 Business Days)." Brazilian Financial and Capital Markets Association. The daily data is available for download at [https://www.anbima.com.br/pt\\_br/informar/curvas-de-juros](https://www.anbima.com.br/pt_br/informar/curvas-de-juros-fechamento.htm)[fechamento.htm](https://www.anbima.com.br/pt_br/informar/curvas-de-juros-fechamento.htm) and the API to build the database is available at [https://developers.](https://developers.anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-value-(vna)) [anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-va](https://developers.anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-value-(vna))lue- [\(vna\)](https://developers.anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-value-(vna)).

Brazilian Financial and Capital Markets Association (2009-2024c). "Term Structure and Break Even Inflation (IPCA): 3-Year Break Even Inflation (726 Business Days)." Brazilian Financial and Capital Markets Association. The daily data is available for download at [https://www.anbima.com.br/pt\\_br/informar/curvas-de-juros](https://www.anbima.com.br/pt_br/informar/curvas-de-juros-fechamento.htm)[fechamento.htm](https://www.anbima.com.br/pt_br/informar/curvas-de-juros-fechamento.htm) and the API to build the database is available at [https://developers.](https://developers.anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-value-(vna)) [anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-va](https://developers.anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-value-(vna))lue- [\(vna\)](https://developers.anbima.com.br/en/precos-indices/apis-de-precos/titulos-publicos/#face-value-(vna)).

Central Bank of Brazil (2014). "Breaking the Break-even Inflation Rate." Inflation Report, December 2014.

Cesa-Bianchi, A.; Thwaites, G.; Vicondoa, A. (2020). "Monetary policy transmission in the United Kingdom: A high frequency identification approach." textitEuropean Economic Review, vol. 123, 103375.

Checo, A.; Grigoli,F. and Sandri, D (2024). "Monetary Policy Transmission in Emerging Markets: Proverbial Concerns, New Evidence," *BIS WP 1170*.

Coibion, Olivier, Yuriy Gorodnichenko, and Tiziano Ropele (2020). "Inflation Expectations and Firm Decisions: New Causal Evidence" *Quarterly Journal of Economics*, vol. 135(1), 165–219.

Favero, C. A.; Giavazzi, F. (2005). "Inflation Targeting and Debt: Lessons from Brazil." Giavazzi, F.; Goldfajn, I.; Herrera, S. (eds.) *Inflation Targeting, Debt, and the Brazilian Experience, 1999 to 2003*. Cambridge: MIT Press.

Getler, M; Karadi, P. (2015). "Monetary Policy Surprises, Credit Costs, and Economic Activity", *American Economic Journal: Macroeconomics*, vol 7, pages 44-76.

Goncalves, C.; Guimaraes, B. (2011). "Monetary policy, default risk and the exchange rate in Brazil." *Revista Brasileira de Economia*

Loyo, E. (1999). "Tight Money Paradox on the Loose: a Fiscalist Hyperinflation." *Harvard Kennedy School, unpublished manuscript*, August.

Miranda-Agrippino, S.; Ricco, G. (2021). "The transmission of monetary policy shocks." *American Economic Journal: Macroeconomics*, vol 13, pages 74-107.

Nakamura, E.; Steinsson, J. (2018). "High-Frequency Identification of Monetary Non-Neutrality: The Information Effect." *The Quarterly Journal of Economics, Volume 133, Issue 3, Pages 1283–1330.*

Rigobon, R. (2003). "Identification through Heteroskedasticity." *Review of Economics and Statistics*, vol. 85(4), pages 777-792, November.

Rigobon, R.; Sack, B. (2004). "The impact of monetary policy on asset prices." *Journal of Monetary Economics*, vol. 51(8), pages 1553-1575, November.

Sargent, T.; Silber, W. (2022). "Inflation, Deficits and Paul Volcker." *Wall Street Journal*, March 3, 2022.

Sargent, T. J.; Wallace, N. (1981). "Some unpleasant monetarist arithmetic." *Quarterly Review*, Federal Reserve Bank of Minneapolis, vol. 5(Fall).

Sims, C. A. (2011). "Stepping on a rake: The role of fiscal policy in the inflation of the 1970s." *European Economic Review*, vol. 55(1), pages 48-56, January.

SGS Banco Central do Brasil (2009-2021). "Exchange rate - Free - United States Dollar (sale) - 1." Banco Central do Brasil. The data is available for download at [https://www3.](https://www3.bcb.gov.br/sgspub/localizarseries/localizarSeries.do?method=prepararTelaLocalizarSeries) [bcb.gov.br/sgspub/localizarseries/localizarSeries.do?method=prepararTelaLocalizarSeries](https://www3.bcb.gov.br/sgspub/localizarseries/localizarSeries.do?method=prepararTelaLocalizarSeries) (accessed August 6, 2021).

Uribe, M. (2016). "Is the Monetarist Arithmetic Unpleasant?" NBER Working Paper 22866, National Bureau of Economic Research.

Werning, I. (2021). "Recalculating Sargent and Wallace's Unpleasant Arithmetic using Interest Rates." MIT.

World Economic Outlook Database (2009-2019). "General government gross debt, percent of GDP." International Monetary Fund. The data is available for download at <https://www.imf.org/en/Publications/WEO/weo-database/2022/April> (accessed Feb 1, 2022).