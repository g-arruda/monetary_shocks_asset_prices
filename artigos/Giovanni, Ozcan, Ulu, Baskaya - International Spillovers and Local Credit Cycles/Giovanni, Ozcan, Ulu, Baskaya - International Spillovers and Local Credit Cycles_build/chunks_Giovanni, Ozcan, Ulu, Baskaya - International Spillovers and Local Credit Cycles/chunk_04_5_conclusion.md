## 5. CONCLUSION

The results in this paper provide evidence on an important (yet overlooked) transmission mechanism for domestic regulators to consider when designing macro prudential policies to slow down credit growth during episodes of capital inflows: it is not enough to limit the foreign currency borrowing for agents in an economy by imposing a capital control. Lower borrowing costs also fuel *local currency* borrowing if domestic banks can fund themselves cheaply in the international financial markets. Furthermore, lower borrowing costs can drive a credit boom in spite of the collateral constraints staying intact during capital inflow bonanzas.

Our result on collateral constraints being insensitive to the GFC sheds light on the need for new macro models. The traditional macro-finance model perspective, in an international setting, is one where external shocks affect the collateral constraint and propagate to the economy. Our evidence shows that external shocks affect risk premia, and which then propagate to the economy by-passing collateral constraints. This finding requires another class of models that highlight the role of risk premia – and how they may vary at the micro level – to study the transmission of both domestic and international financial shocks.

Acknowledgments. We would like to thank four anonymous referees, the editor (Veronica Guerrieri), Koray Alper, Olivier Blanchard, Anusha Chari, Stijn Claessens, Gita Gopinath, Pierre-Olivier Gourinchas, Alberto Martin, Arnauld Mehl, Benoit Mojon, Romain Rancière, Hélène Rey, Jesse Schreger, Hyun Song Shin, and participants at numerous conferences and seminars for their helpful comments. We thank Eda Gulsen who provided phenomenal research assistance. We also thank Galina Hale and Camille Minoau for the data on syndicated loans. The views expressed herein are those of the authors and not necessarily those of the Central Bank of the Republic of Turkey or the Federal Reserve Bank of New York. Di Giovanni gratefully acknowledges the Spanish Ministry of Economy and Competitiveness, through the Severo Ochoa Programme for Centres of Excellence in R&D (SEV-2015-0563) for financial support. Kalemli-Ozcan gratefully acknowledges support from NSF Grant No. 2018623. The data underlying this article cannot be

<span id="page-31-0"></span>shared publicly due to the sensitive nature of the administrative data sources. All replication material are available at https://zenodo.org/record/4608093#.YFDIXWRKjzc.

#### **Data Availability Statement**

The publicly available macroeconomics and financial data and all code underlying this research are available on Zenodo at http://doi.org/10.5281/zenodo.4733035.

The confidential bank-level and loan-level data used in this paper are provided by the Central Bank of the Republic of Turkey. These data must be sourced directly from the CBRT and are proprietary. Researchers should get permission from the CBRT. The data can only be accessed via the CBRT. For your inquiries, please fill out the question form at:

https://tcmb.gov.tr/wps/wcm/connect/en/tcmb+en/main+menu/about+the+bank/contact+us/for+your+questions

#### **APPENDIX**

#### A. REGRESSION DETAILS

## A.1. Aggregate implications of reduced-form regressions

There is a natural aggregation exercise to undertake to examine the economic significance of our micro estimates on overall credit growth. In particular, ignoring the other control variables and intercept coefficients (i.e. fixed effects), we can write the VIX-predicted Loan variable from estimating (1) as

$$\log(\widehat{\text{Loan}}_{f,b,d,q}) = \widehat{\beta}\log(\text{VIX}_{q-1}), \tag{A.1}$$

where  $\hat{\beta}$  is the estimated coefficient. First, differentiate both sides of (A.1), and then multiply this equation by  $w_{f,b,d,q-1}$ , which is a firm-bank-denomination loan share viz. total loans in a given lagged quarter, such that  $\sum w_{f,b,d,q-1} = 1$  by definition. These manipulations yield

$$w_{f,b,d,q-1}\operatorname{dlog}(\widehat{\operatorname{Loan}_{f,b,d,q}}) = w_{f,b,d,q-1}\widehat{\beta}\operatorname{dlog}(\operatorname{VIX}_{q-1}), \tag{A.2}$$

so.

$$w_{f,b,d,q-1} \left(\frac{\widehat{\Delta \text{Loan}}}{\text{Loan}}\right)_{f,b,d,q} = w_{f,b,d,q-1} \widehat{\beta} \left(\frac{\Delta \text{VIX}}{\text{VIX}}\right)_{q-1},$$
 (A.3)

where (A.3) comes from rewriting the change in logs from (A.2) as a growth rate, and  $(\widehat{\frac{\Delta \text{Loan}}{\text{Loan}}})_{f,b,d,q}$  is the predicted growth rate in Loan between quarter q-1 and q, while  $(\frac{\Delta \text{VIX}}{\text{VIX}})_{q-1}$  is the growth rate of VIX between quarter q-2 and q-1. Next, summing (A.3) over  $\{f,b,d\}$  in a given quarter q, we have

$$\left(\frac{\Delta \widehat{\mathrm{Agg. Loan}}}{\mathrm{Agg. Loan}}\right)_{q} = \widehat{\beta} \left(\frac{\Delta \mathrm{VIX}}{\mathrm{VIX}}\right)_{q-1}, \tag{A.4}$$

which yields a relationship between aggregate credit growth (Agg. Loan), the growth rate of the VIX variable and the estimated micro estimate  $\hat{\beta}$ .

**A.1.1.** Importance of internationally connected banks. To quantify the importance of large internationally connected banks in transmitting the GFC to the domestic credit market, we use the point estimates from Table 9, column (3), which is based on regression specification 2 where we drop the firm×quarter fixed effects, and use macro controls instead. Ignoring these controls and the bank controls for brevity, the regression equation can be summarized as:

$$\log Y_{f,b,d,q} = \alpha_{f,b} + \lambda \operatorname{Trend}_q + \beta_1 \operatorname{VIX}_{q-1} + \beta_2 (\operatorname{Noncore}_b \times \log \operatorname{VIX}_{q-1}) + \vartheta_{f,b,d,q}.$$

Given the estimates of  $\beta_1$  and  $\beta_2$ , we then follow the same procedure as for the macro regression above, based on weights for high non-core banks (*HNC*) and low non-core banks (*LNC*). To begin, we predict individual loan growths based on bank type and weight these growth rates:

$$w_{f,b,d,q-1} \left(\frac{\widehat{\Delta \text{Loan}}}{\text{Loan}}\right)_{f,b,d,q} = w_{f,b,d,q-1}^{HNC}(\widehat{\beta}_1 + \widehat{\beta}_2) \left(\frac{\Delta \text{VIX}}{\text{VIX}}\right)_{q-1} + w_{f,b,d,q-1}^{LNC} \widehat{\beta}_1 \left(\frac{\Delta \text{VIX}}{\text{VIX}}\right)_{q-1}.$$

35. Note that the point estimates on the interaction between the non-core ratio and log(VIX) with and without fixed effects in columns (3) and (4) are not statistically different.

<span id="page-32-0"></span>![](_page_32_Figure_4.jpeg)

Loan growth comparison of corporate sector and whole economy, 2003–13

Notes: This figure plots the year-on-year loan growth rate each quarter of our sample of firms ('Firms') with that of for the whole economy ("Firms + Non-Firms"). All values are nominal. Source: authors' calculations based on official credit register data, CBRT.

![](_page_32_Figure_7.jpeg)

FIGURE A2
Extensive and intensive margins of lending, 2003–13

Notes: This figure plots the share of loans due to Extensive (new loans) and Intensive (continuing loans) margins relative to total loans outstanding in a given period. Source: authors' calculations based on official credit register data, CBRT.

We next sum over the  $\{f, b, d\}$  in a given quarter q:

$$\left(\frac{\Delta \widehat{\mathrm{Agg. Loan}}}{\mathrm{Agg. Loan}}\right)_{q} = \sum w_{q-1}^{HNC}(\widehat{\beta}_{1} + \widehat{\beta}_{2}) \left(\frac{\Delta \mathrm{VIX}}{\mathrm{VIX}}\right)_{q-1} + \sum w_{q-1}^{LNC} \widehat{\beta}_{1} \left(\frac{\Delta \mathrm{VIX}}{\mathrm{VIX}}\right)_{q-1}$$

<span id="page-33-0"></span>

| Turkish and foreign macroeconomic and financial quarterly summary statistics, 2005–15 |      |        |        |           |       |        |        |  |
|---------------------------------------------------------------------------------------|------|--------|--------|-----------|-------|--------|--------|--|
|                                                                                       | Obs. | Mean   | Median | Std. Dev. | IQR   | Min.   | Max.   |  |
| log(VIX)                                                                              | 44   | 2.957  | 2.913  | 0.368     | 0.566 | 2.401  | 4.071  |  |
| log(Capital inflows)                                                                  | 44   | 18.25  | 18.61  | 0.926     | 0.730 | 15.92  | 19.22  |  |
| CA/GDP                                                                                | 44   | -5.144 | -5.379 | 2.227     | 2.637 | -9.803 | -1.303 |  |
| Real GDP Growth (q-o-q)                                                               | 44   | 0.012  | 0.012  | 0.022     | 0.017 | -0.059 | 0.048  |  |
| Inflation (q-o-q, annualized)                                                         | 44   | 0.089  | 0.069  | 0.066     | 0.073 | -0.013 | 0.322  |  |
| $\Delta e_{TRY/USD,t}$ (q-on-q)                                                       | 44   | 0.006  | 0.001  | 0.066     | 0.058 | -0.104 | 0.271  |  |
| CBRT overnight rate                                                                   | 44   | 0.188  | 0.183  | 0.113     | 0.118 | 0.067  | 0.517  |  |

TABLE A1
Turkish and foreign macroeconomic and financial quarterly summary statistics, 2003–13

Notes: This table presents summary statistics for quarterly Turkish and world macroeconomic and financial data. All real variables are deflated using 2003 as the base year. Turkish macroeconomic data are sourced from the CBRT. Turkish real GDP growth, inflation, and exchange rate changes viz. the USD are all quarter-on-quarter. The VIX and the CBRT overnight rate are quarterly averages. 'IQR' stands for the interquartile range. Turkish capital inflows are in real Turkish lira. The CA/GDP variable measures the quarterly Turkish current account relative to GDP, while log(Capital inflows) is the natural logarithm of gross real capital inflows into Turkey in 2003 TRY.

TABLE A2
Baseline regression horse race with MP shocks, 2003–13

|                        | Panel A. Nominal interest rate |                | Panel B. L | oan volume |
|------------------------|--------------------------------|----------------|------------|------------|
|                        | (1)                            | (2)            | (3)        | (4)        |
| log(VIX)               | 0.020***                       | 0.021***       | -0.141***  | -0.134***  |
| _                      | (0.003)                        | (0.003)        | (0.027)    | (0.025)    |
| U.S. MP shock (FF4)    | -0.030*                        |                | -0.411***  |            |
|                        | (0.015)                        |                | (0.138)    |            |
| U.S. MP shock (MP1)    |                                | -0.010         |            | -0.159***  |
| • • •                  |                                | (0.006)        |            | (0.053)    |
| FX                     | -0.074***                      | $-0.074^{***}$ | 0.583***   | 0.583***   |
|                        | (0.003)                        | (0.003)        | (0.012)    | (0.012)    |
| Domestic policy rate   | 0.212***                       | 0.209***       | 0.197      | 0.151      |
| • •                    | (0.025)                        | (0.026)        | (0.261)    | (0.259)    |
| Observations           | 13,445,548                     | 13,445,548     | 13,445,548 | 13,445,548 |
| R-squared              | 0.777                          | 0.777          | 0.835      | 0.835      |
| Macro controls & trend | Yes                            | Yes            | Yes        | Yes        |
| Bank controls          | Yes                            | Yes            | Yes        | Yes        |
| Bank×firm F.E.         | Yes                            | Yes            | Yes        | Yes        |

Notes: This table presents results for the OLS regressions including monetary policy shocks using quarterly data for all loans. Panel A uses the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. MP is a monetary policy shock based on current future contracts, FF4 is a monetary policy shocks based on future contracts that are 3-months out. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0). Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and \*\*\* indicates significance at the 1% level, \*\* at the 5% level, and \* at the 10% level.

to obtain the aggregate quarterly growth rate. We then repeat this aggregation using only the HNC bank sample, and take the average of this HNC growth rate over the sample to the average of the overall aggregate growth rate:

$$\frac{\operatorname{Avg}\left\{\sum w_{q-1}^{HNC}(\widehat{\beta}_1+\widehat{\beta}_2)\left(\frac{\Delta \operatorname{VIX}}{\operatorname{VIX}}\right)_{q-1}\right\}}{\operatorname{Avg}\left\{\left(\frac{\Delta \operatorname{Agg. Loan}}{\operatorname{Agg. Loan}}\right)_q\right\}}.$$

This ratio is equal to 0.95, thus highlighting the important contribution of internationally connected banks in transmitting the GFC to domestic credit market growth.<sup>36</sup>

36. If we instead use the non-core interaction coefficient estimate for  $\hat{\beta}_2$  and firm-bank sample from column (4) for the fixed effects regression, the ratio drops to 0.86, which is still economically large.

TABLE A3

Baseline regressions split by exporters and non-exporters, 2003–13

<span id="page-34-0"></span>

|                          | Panel A. Nominal interest rate |               |                   | P          | anel B. Loan v | olume             |
|--------------------------|--------------------------------|---------------|-------------------|------------|----------------|-------------------|
|                          | All (1)                        | Exporters (2) | Non-exporters (3) | All (4)    | Exporters (5)  | Non-exporters (6) |
| log(VIX)                 | 0.019***                       | 0.013***      | 0.020***          | -0.067**   | -0.096***      | -0.0697**         |
|                          | (0.003)                        | (0.002)       | (0.003)           | (0.027)    | (0.019)        | (0.027)           |
| FX                       | -0.069***                      | -0.072***     | -0.065***         | 0.576***   | 0.709***       | 0.396***          |
|                          | (0.003)                        | (0.003)       | (0.003)           | (0.010)    | (0.014)        | (0.011)           |
| Domestic policy rate     | 0.214***                       | 0.167***      | 0.222***          | 0.117      | 0.382**        | 0.150             |
|                          | (0.026)                        | (0.025)       | (0.032)           | (0.301)    | (0.152)        | (0.337)           |
| GDP growth               | -0.063*                        | -0.124***     | -0.054            | 0.199***   | 0.481**        | 0.201             |
|                          | (0.035)                        | (0.043)       | (0.039)           | (0.321)    | (0.235)        | (0.328)           |
| Inflation                | -0.015                         | -0.008        | -0.016            | 0.037      | -0.015         | 0.041             |
|                          | (0.017)                        | (0.012)       | (0.019)           | (0.121)    | (0.086)        | (0.124)           |
| XR change                | -0.046***                      | -0.028*       | -0.048***         | 0.037      | 0.253***       | 0.036             |
|                          | (0.010)                        | (0.016)       | (0.011)           | (0.124)    | (0.086)        | (0.127)           |
| Observations             | 18,345,853                     | 1,482,138     | 16,780,935        | 18,345,853 | 1,482,138      | 16,780,935        |
| R-squared                | 0.781                          | 0.687         | 0.789             | 0.831      | 0.705          | 0.823             |
| Macro controls and trend | Yes                            | Yes           | Yes               | Yes        | Yes            | Yes               |
| Bank controls            | Yes                            | Yes           | Yes               | Yes        | Yes            | Yes               |
| Bank×firm F.E.           | Yes                            | Yes           | Yes               | Yes        | Yes            | Yes               |

Notes: This table presents results for the OLS regressions for 1 split by exporting stats using quarterly data for all loans. Panel A uses the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firmbank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0). Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and \*\*\* indicates significance at the 1% level, \*\* at the 5% level, and \* at the 10% level.

TABLE A4
Baseline regressions for domestic-activity loans only, 2003–13

|                           | Panel A. Nominal interest rate |           |           | Panel B. Loan volume |           |           |
|---------------------------|--------------------------------|-----------|-----------|----------------------|-----------|-----------|
|                           | (1)                            | (2)       | (3)       | (4)                  | (5)       | (6)       |
| log(VIX)                  | 0.014***                       | 0.016***  |           | -0.051*              | -0.084*** |           |
|                           | (0.003)                        | (0.003)   |           | (0.027)              | (0.026)   |           |
| $NonCore \times log(VIX)$ | 0.020***                       | 0.016***  | 0.015***  | -0.068***            | -0.042*** | -0.036**  |
|                           | (0.004)                        | (0.004)   | (0.004)   | (0.016)              | (0.014)   | (0.018)   |
| FX                        | -0.067***                      | -0.068*** | -0.068*** | 0.519***             | 0.505***  | 0.524***  |
|                           | (0.003)                        | (0.003)   | (0.003)   | (0.011)              | (0.011)   | (0.012)   |
| Observations              | 17,860,010                     | 8,089,175 | 8,089,175 | 17,860,010           | 8,089,175 | 8,089,175 |
| R-squared                 | 0.783                          | 0.760     | 0.858     | 0.826                | 0.803     | 0.873     |
| Macro controls and trend  | Yes                            | Yes       | No        | Yes                  | Yes       | No        |
| Bank controls             | Yes                            | Yes       | No        | Yes                  | Yes       | No        |
| Bank×firm F.E.            | Yes                            | Yes       | Yes       | Yes                  | Yes       | Yes       |
| Firm×quarter F.E.         | No                             | No        | Yes       | No                   | No        | Yes       |

Notes: This table presents results for the OLS regressions for 1 split by using a subset of loans that are used only for domestic activity (i.e., not exporting or importing activity) using quarterly data. Panel A uses the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0). Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and \*\*\* indicates significance at the 1% level, \*\* at the 5% level, and \* at the 10% level.

TABLE A5 *Baseline regression industry checks: VIX and VIX*×*sector dummy coefficients, 2003–13*

<span id="page-35-0"></span>

|          |                     | Panel A. Nominal interest rate |                     | Panel B. Loan volume |
|----------|---------------------|--------------------------------|---------------------|----------------------|
| Industry | (1)<br>log(VIX)     | (2)<br>log(VIX)×Dsec           | (3)<br>log(VIX)     | (4)<br>log(VIX)×Dsec |
| 1A       | 0.021∗∗∗            | −0.015∗∗∗                      | −0.071∗∗            | 0.022                |
|          | (0.003)             | (0.003)                        | (0.027)             | (0.018)              |
| 2B       | 0.019∗∗∗            | −0.008∗∗∗                      | −0.067∗∗            | 0.028                |
|          | (0.003)             | (0.002)                        | (0.027)             | (0.031)              |
| 3C       | 0.019∗∗∗            | 0.005∗∗∗                       | −0.067∗∗            | −0.050∗∗∗            |
|          | (0.003)             | (0.001)                        | (0.027)             | (0.014)              |
| 4D       | 0.019∗∗∗            | 0.001                          | −0.056∗             | −0.042∗∗∗            |
|          | (0.003)             | (0.002)                        | (0.028)             | (0.012)              |
| 5E       | 0.019∗∗∗            | −0.003                         | −0.067∗∗            | −0.027               |
|          | (0.003)             | (0.002)                        | (0.027)             | (0.025)              |
| 6F       | 0.019∗∗∗            | 0.003∗∗                        | −0.065∗∗            | −0.024∗              |
|          | (0.003)             | (0.002)                        | (0.027)             | (0.013)              |
| 10G      | 0.016∗∗∗            | 0.010∗∗∗                       | −0.059∗∗            | −0.030∗∗∗            |
|          | (0.003)             | (0.001)                        | (0.028)             | (0.010)              |
| 11H      | 0.019∗∗∗            | 0.005∗∗∗                       | −0.068∗∗            | 0.028                |
|          | (0.003)             | (0.001)                        | (0.027)             | (0.024)              |
| 12I      | 0.019∗∗∗            | 0.002                          | −0.071∗∗∗           | 0.049∗               |
|          | (0.003)             | (0.002)                        | (0.026)             | (0.025)              |
| 13J      | 0.019∗∗∗            | 0.003                          | −0.067∗∗            | 0.034                |
|          | (0.003)             | (0.002)                        | (0.027)             | (0.021)              |
| 14K      | 0.019∗∗∗            | 0.001                          | −0.067∗∗            | 0.020                |
|          | (0.003)             | (0.001)                        | (0.027)             | (0.013)              |
| 16L      | 0.019∗∗∗            | −0.004                         | −0.067∗∗            | 0.250∗∗∗             |
|          | (0.003)             | (0.003)                        | (0.027)             | (0.064)              |
| 17M      | 0.019∗∗∗            | 0.002                          | −0.067∗∗            | 0.043                |
|          | (0.003)             | (0.001)                        | (0.027)             | (0.027)              |
| 18N      | 0.019∗∗∗            | 0.002∗∗                        | −0.067∗∗            | 0.023                |
|          |                     |                                |                     |                      |
|          | (0.003)<br>0.019∗∗∗ | (0.001)<br>−0.003∗∗∗           | (0.027)<br>−0.069∗∗ | (0.021)<br>0.069∗∗∗  |
| 19O      |                     |                                |                     |                      |
|          | (0.003)<br>0.019∗∗∗ | (0.001)<br>0.007∗∗∗            | (0.027)<br>−0.067∗∗ | (0.021)              |
| 20P      |                     |                                |                     | 0.016                |
|          | (0.003)<br>0.019∗∗∗ | (0.002)                        | (0.027)<br>−0.067∗∗ | (0.023)              |
| 21Q      |                     | 0.008                          |                     | −0.096               |
|          | (0.003)             | (0.009)                        | (0.027)             | (0.117)              |

*Notes:* This table presents results for the OLS regressions for [1,](#page-16-0) including a sector dummy, D*sec*, interacted with log(VIX) sector-by-sector. The sector codes refer to the following industries: 1A: Agriculture, hunting and forestry; 2B: Fishing; 3C: Mining and quarrying; 4D: Manufacturing; 5E: Electricity, gas and water supply; 6F: Construction; 10G: Wholesale and retail trade; repair of motor vehicles, motorcycles and personal and household goods; 11H: Hotels and restaurants; 12I: Transport, storage and communication; 13J: Financial intermediation; 14K: Real estate, renting and business activities; 16L: Public administration and defense; compulsory social security; 17M: Education; 18N: Health and social work; 19O: Other community, social and personal service activities; 20P: Activities of households; 21Q: Extra-territorial orgs. and bodies.

TABLE A6
Baseline regression sample checks: sample splits and OLS versus WLS, VIX coefficient only, 2003–13

<span id="page-36-0"></span>

|                                         | Panel                          | Panel A. OLS                   |                                | Panel B. WLS                   |              |  |
|-----------------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------|--|
| Sample                                  | $\frac{\log(1+i)}{(1)}$        | log(Loan)                      | $\frac{\log(1+i)}{(3)}$        | log(Loan)<br>(4)               | Observations |  |
| All loans                               | 0.018***                       | -0.061**                       | 0.019***                       | -0.060**                       | 19,982,267   |  |
| Loans>5K TL                             | (0.003)<br>0.018***<br>(0.003) | (0.028)<br>-0.067**<br>(0.027) | (0.003)<br>0.019***<br>(0.003) | (0.028)<br>-0.067**<br>(0.027) | 18,345,853   |  |
| Loans>5K TL and<br>Firm×quarter FE      | 0.019***<br>(0.002)            | -0.095***<br>(0.025)           | 0.020*** (0.002)               | -0.067**<br>(0.027)            | 8,573,782    |  |
| Loans>5K TL and<br>Firm×bank×quarter FE | 0.013***<br>(0.002)            | -0.095***<br>(0.025)           | 0.013***<br>(0.002)            | -0.059**<br>(0.024)            | 832,138      |  |

Notes: This table presents results for the OLS regressions for 1 either based on OLS (Panel A) or on WLS (Panel B) using the log of banks' total assets as weights. Regression samples are run as either: (i) All loans: 19,982,267 observations, (ii) truncating the sample at 5,000 Turkish lira (5K TRY): 18,345,853 observations; (iii) truncating the sample and restricting to firm-bank-quarter observations for firms that borrow from multiple banks in a given quarter: 8,573,782 observations, and (iv) truncating the sample and restricting to firm-bank-quarter observations for firm-bank pairs that have loans in both FX and TRY in a given quarter: 832,138 observations. \*\*\* indicates significance at the 1% level, \*\* at the 5% level, and \* at the 10% level.

TABLE A7

Baseline regression robustness checks: VIX coefficient only, 2003–13

| Robustness        | $\log(1+i) \tag{1}$ | log(Loan) (2) |
|-------------------|---------------------|---------------|
| Risk aversion VIX | 0.011***            | -0.049***     |
|                   | (0.002)             | (0.015)       |
| Short Mat.        | 0.017***            | -0.092***     |
|                   | (0.002)             | (0.019)       |
| Long Mat.         | 0.021***            | -0.044        |
|                   | (0.004)             | (0.029)       |
| No Crisis         | 0.018***            | -0.063**      |
|                   | (0.003)             | (0.027)       |
| Private banks     | 0.026***            | -0.105***     |
|                   | (0.003)             | (0.026)       |

*Notes:* This table presents results for the OLS regressions for 1 for different robustness checks. The robustness checks are: (i) using the risk aversion component of VIX as extracted by Bekaert et al. (2013)—we would like to thank Marie Horoeva for providing us with an updated series; (ii) using short-term maturity (one year or less) loans; (iii) using long-term maturity (more than one year); (iv) dropping the crisis period from the regressions; (v) restricting the sample to firm-bank pairs for private banks only. Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and \*\*\* indicates significance at the 1% level, \*\* at the 5% level, and \* at the 10% level.

<span id="page-37-0"></span>TABLE A8 *The global financial cycle, borrowing costs and loan volumes: the role of banks' non-core liabilities in transmitting the GFC, splitting banks by non-core quartiles*

|                          | Panel A. Nominal interest rate |           |           | Panel B. Loan volume |           |           |
|--------------------------|--------------------------------|-----------|-----------|----------------------|-----------|-----------|
|                          | (1)                            | (2)       | (3)       | (4)                  | (5)       | (6)       |
| log(VIX)                 | 0.005                          | 0.008∗∗∗  |           | −0.009               | −0.029    |           |
|                          | (0.004)                        | (0.003)   |           | (0.034)              | (0.036)   |           |
| NonCore×log(VIX) (Q2)    | 0.003                          | 0.001     | −0.001    | −0.039∗              | −0.050∗∗  | −0.010    |
|                          | (0.004)                        | (0.003)   | (0.003)   | (0.020)              | (0.020)   | (0.021)   |
| NonCore×log(VIX) (Q3)    | 0.014∗∗∗                       | 0.010∗∗∗  | 0.008∗∗∗  | −0.061∗              | −0.067∗∗  | −0.025    |
|                          | (0.003)                        | (0.002)   | (0.002)   | (0.032)              | (0.031)   | (0.029)   |
| NonCore×log(VIX) (Q4)    | 0.044∗∗∗                       | 0.034∗∗∗  | 0.030∗∗∗  | −0.151∗∗∗            | −0.127∗∗∗ | −0.075∗∗  |
|                          | (0.007)                        | (0.005)   | (0.006)   | (0.032)              | (0.031)   | (0.031)   |
| FX                       | −0.069∗∗∗                      | −0.070∗∗∗ | −0.069∗∗∗ | 0.576∗∗∗             | 0.577∗∗∗  | 0.602∗∗∗  |
|                          | (0.003)                        | (0.003)   | (0.003)   | (0.010)              | (0.011)   | (0.012)   |
| Observations             | 18,345,853                     | 8,573,782 | 8,573,782 | 18,345,853           | 8,573,782 | 8,573,782 |
| R-squared                | 0.785                          | 0.761     | 0.857     | 0.831                | 0.803     | 0.870     |
| Macro controls and trend | Yes                            | Yes       | No        | Yes                  | Yes       | No        |
| Bank controls            | Yes                            | Yes       | No        | Yes                  | Yes       | No        |
| Bank×firm F.E.           | Yes                            | Yes       | Yes       | Yes                  | Yes       | Yes       |
| Firm×quarter F.E.        | No                             | No        | Yes       | No                   | No        | Yes       |

*Notes:* This table presents results for the OLS regressions for [2](#page-18-0) using quarterly data for all loans. Panel A uses the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. Non-core Q2-Q4 is a 0/1 dummy indicating whether a bank is in the second, third, or fourth interquartile range bin of banks defined by their average non-core liabilities ratio over the sample period, where a higher quartile indicates a larger ratio. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0), and firm×quarter effects are included in all specifications. Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and ∗∗∗ indicates significance at the 1% level, ∗∗ at the 5% level, and <sup>∗</sup> at the 10% level.

<span id="page-38-0"></span>TABLE A9 *The global financial cycle, borrowing costs and loan volumes: the failure of UIP at the loan level, loans with maturity of twelve months only*

|                          | (1)       | (2)       | (3)                            | (4)     |
|--------------------------|-----------|-----------|--------------------------------|---------|
|                          |           |           | Panel A. Nominal interest rate |         |
| log(VIX)                 | 0.027∗∗∗  | 0.031∗∗∗  |                                |         |
|                          | (0.003)   | (0.003)   |                                |         |
| FX×log(VIX)              | −0.018∗∗∗ | −0.020∗∗∗ | −0.012∗                        | −0.011  |
|                          | (0.004)   | (0.004)   | (0.006)                        | (0.007) |
| FX                       | −0.006    | 0.000     | −0.026                         | −0.029  |
|                          | (0.012)   | (0.011)   | (0.019)                        | (0.022) |
| Observations             | 520,190   | 17,321    | 17,321                         | 3,590   |
| R-squared                | 0.826     | 0.810     | 0.919                          | 0.812   |
| Macro controls & trend   | Yes       | Yes       | No                             | No      |
| Bank controls            | Yes       | Yes       | Yes                            | No      |
| Bank×firm F.E.           | Yes       | Yes       | Yes                            | Yes     |
| Firm×quarter F.E.        | No        | No        | Yes                            | No      |
| Bank×firm×quarter F.E.   | No        | No        | No                             | Yes     |
|                          |           |           | Panel B. Loan volume           |         |
| log(VIX)                 | −0.059∗∗∗ | −0.076∗∗∗ |                                |         |
|                          | (0.019)   | (0.020)   |                                |         |
| FX×log(VIX)              | −0.057∗∗  | −0.043    | −0.059                         | −0.121  |
|                          | (0.028)   | (0.032)   | (0.169)                        | (0.191) |
| FX                       | 0.652∗∗∗  | 0.599∗∗∗  | 0.613                          | 0.836   |
|                          | (0.088)   | (0.101)   | (0.510)                        | (0.574) |
| Observations             | 520,190   | 17,321    | 17,321                         | 3,590   |
| R-squared                | 0.880     | 0.859     | 0.908                          | 0.999   |
| Macro controls and trend | Yes       | Yes       | No                             | No      |
| Bank controls            | Yes       | Yes       | Yes                            | No      |
| Bank×firm F.E.           | Yes       | Yes       | Yes                            | Yes     |
| Firm×quarter F.E.        | No        | No        | Yes                            | No      |
| Bank×firm×quarter F.E.   | No        | No        | No                             | Yes     |

*Notes:* This table presents results for the OLS regressions for [3](#page-20-0) using quarterly data for loans having only 12-months maturity. Panel A uses the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0), and the macroeconomic controls and time trend of Table [8](#page-17-0) are included in columns (1)–(2) when firm×quarter effects are excluded, and the bank-level characteristics of Table [8](#page-17-0) are included in columns (1)–(3) when bank×quarter effects are excluded . Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and ∗∗∗ indicates significance at the 1% level, ∗∗ at the 5% level, and <sup>∗</sup> at the 10% level.

#### <span id="page-39-0"></span>REFERENCES

- AKINCI, O. and QUERALTO, A. (2019), "Exchange Rate Dynamics and Monetary Spillovers with Imperfect Financial Markets" (Federal Reserve Bank of New York Staff Reports 849).
- BASKAYA, Y. S., DI GIOVANNI, J., ¸S. KALEMLI-ÖZCAN, et al., (2017), "Capital Flows and the International Credit Channel", *Journal of International Economics*, **108**, S15–S22.
- BASU, S., BOZ, E., GOPINATH, G. et al., (2020), "Integrated Monetary and Financial Policies for Small Open Economies" (Mimeo, International Monetary Fund).
- BEKAERT, G., HOEROVA, M. and LO DUCA, M. (2013), "Risk, Uncertainty and Monetary Policy", *Journal of Monetary Economics*, **60**, 771–788.
- BERNANKE, B. S. and GERTLER, M. (1989), "Agency Costs, Net Worth and Business Fluctuations", *American Economic Review*, **79**, 14–31.
- , and GILCHRIST, S. (1999), "The Financial Accelerator in a Quantitative Business Cycle Framework", in Taylor, J. B. and Woodford, M. (eds) *Handbook of Macroeconomics*, Vol. 1 of *Handbooks in Economics* (Elsevier) 1341–1393.
- BRÄUNING, F. and IVASHINA, V. (2018), "U.S. Monetary Policy and Emerging Market Credit Cycles", *Journal of Monetary Economics*, **112**, 57–76.
- BRUNO, V. and SHIN, H. S. (2015a), "Cross-Border Banking and Global Liquidity", *Review of Economic Studies*, **82**, 535–564.
- and , (2015b), "Capital Flows and the Risk-Taking Channel of Monetary Policy", *Journal of Monetary Economics*, **71**, 119–132.
- CABALLERO, R. and KRISHNAMURTHY, A. (2001), "International and Domestic Collateral Constraints in a Model of Emerging Market Crises", *Journal of Monetary Economics*, **48**, 513–548.
- CALVO, G. A., (1998), "Capital Flows and Capital-market Crises: The Simple Economics of Sudden Stops", *Journal of Applied Economics*, **1**, 35–54.
- CENTRAL BANK OF THE REPUBLIC OF TURKEY, (2017), "Bank-Level [data set]" Last accessed 4 March 2017. , "Credit Registry [data set]," 2017. Last accessed 4 March 2017.
- CERUTTI, E., CLAESSENS, S. and PUY, D. (2015), "Push Factors and Capital Flows to Emerging Markets: Why Knowing Your Lender Matters More Than Fundamentals" (IMF Working Paper No. 15/127).
- CETORELLI, N. and GOLDBERG, L. S. (2011), "Global Banks and International Shock Transmission: Evidence from the Crisis", *IMF Economic Review*, **59**, 41–76.
- CHODOROW-REICH, G. (2014), "The Employment Effects of Credit Market Disruptions: Firm-level Evidence from the 2008–9 Financial Crisis", *Quarterly Journal of Economics*, **129**, 1–59.
- COIMBRA, N. and REY, H. (2017), "Financial Cycles with Heterogeneous Intermediaries" (NBER Working Paper No. 23245).
- COOLEY, T., MARIMON, R. and QUADRINI, V. (2004), "Aggregate Consequences of Limited Enforceability", *Journal of Political Economy*, **112**, 817–847.
- DI GIOVANNI, J., KALEMLI-ÖZCAN, ¸S., FATIH ULU, M. et al., (2021), "Macroeconomic and Financial [data set]" Zenodo. https://doi.org/10.5281/zenodo.4733035.
- FORBES, K. J. and WARNOCK, F. E. (2012), "Capital Flow Waves: Surges, Stops, Flight, and Retrenchment", *Journal of International Economics*, **88**, 235–251.
- FOSTEL, A. and GEANAKOPLOS, J. (2015), "Leverage and Default in Binomial Economies: A Complete Characterization", *Econometrica*, **83**, 2191–2229.
- FRATZSCHER, M., LO DUCA, M. and STRAUB, R. (2018), "On the International Spillovers of US Quantitative Easing", *Economic Journal*, **128**, 330–377.
- GERTLER, M. and KARADI, P. (2015), "Monetary Policy Surprises, Credit Costs, and Economic Activity", *American Economic Journal: Macroeconomics*, **7**, 44–76.
- GOPINATH, G. and STEIN, J. C. (2017), "Banking, Trade, and the Making of a Dominant Currency" (Mimeo, Harvard University).
- , ¸S. KALEMLI-ÖZCAN, KARABARBOUNIS, L. et al., (2012), "Capital Allocation and Productivity in South Europe", *Quarterly Journal of Economics*, **132**, 1915–1967.
- GUERRIERI, V. and LORENZONI, G. (2017), "Credit Crises, Precautionary Savings, and the Liquidity Trap", *Quarterly Journal of Economics*, **132**, 1427–1467.
- HAHM, J.-H., SHIN, H. S. and SHIN, K. (2013), "Non-core Bank Liabilities and Financial Vulnerability", *Journal of Money, Credit and Banking*, **45**, 3–36.
- IVASHINA, V., SCHARFSTEIN, D. S. and STEIN, J. C. (2015), "Dollar Funding and the Lending Behavior of Global Banks", *Quarterly Journal of Economics*, **130**, 1241–1281.
- JIMÉNEZ, G., ONGENA, S., PEYDRÓ, J.-L. et al., (2014), "Hazardous Times for Monetary Policy: What Do Twenty-Three Million Bank Loans Say About the Effects of Monetary Policy on Credit Risk-Taking?", *Econometrica*, **82**, 463–505.
- JORDÀ, Ò., SCHULARICK, M., TAYLOR, A. M. et al., (2017), "Global Financial Cycles and Risk Premiums" (Mimeo, SF Fed, University of Bonn, and U.C. Davis).
- KALEMLI-ÖZCAN, ¸S., (2019), "U.S. Monetary Policy and International Risk Spillovers" Forthcoming in the Jackson Hole Conference Proceedings Federal Reserve Bank of Kansas City.

- <span id="page-40-0"></span>and VARELA, L. (2019), "Exchange Rate and Interest Rate Disconnect: The Role of Capital Flows and Risk Premia" (Mimeo, University of Maryland and LSE).
- KHAN, A. and THOMAS, J. (2013), "Credit Shocks and Aggregate Fluctuations in an Economy with Production Heterogeneity", *Journal of Political Economy*, **121**, 1055–1107.
- KHWAJA, A. I. and MIAN, A. (2008), "Tracing the Impact of Bank Liquidity Shocks: Evidence from an Emerging Market", *American Economic Review*, **98**, 1413–1442.
- KIYOTAKI, N. and MOORE, J. (1997), "Credit Cycles", *Journal of Political Economy*, **105**, 211–248.
- MENDOZA, E. G. (2010), "Sudden Stops, Financial Crises, and Leverage", *American Economic Review*, **100**, 1941–1966.
- MIRANDA-AGRIPPINO, S. and REY, H. (2018), "US Monetary Policy and the Global Financial Cycle" (NBER Working Paper No. 21722).
- MORAIS, B., J.-L. PEYDRÓ, and RUIZ, C. (2019), "The International Bank Lending Channel of Monetary Policy Rates and QE: Credit Supply, Reach-for-Yield, and Real Effects", *Journal of Finance*, February 2019, **74**, 55–90.
- PETERSEN, M. A. (2009), "Estimating Standard Errors in Finance Panel Data Sets: Comparing Approaches", *Review of Financial Studies*, **22**, 435–480.
- REINHART, C. M. and ROGOFF, K. S. (2009), *This Time Is Different: Eight Centuries of Financial Folly* (Princeton, NJ: Princeton University Press).
- REY, H., (2013), "Dilemma not Trilemma: The Global Financial Cycle and Monetary Policy Independence" (Jackson Hole Conference Proceedings, Federal Reserve Bank of Kansas City).
- SALOMAO, J. and VARELA, L. (2016), "Exchange Rate Exposure and Firm Dynamics" (Mimeo, University of Minnesota and University of Houston).