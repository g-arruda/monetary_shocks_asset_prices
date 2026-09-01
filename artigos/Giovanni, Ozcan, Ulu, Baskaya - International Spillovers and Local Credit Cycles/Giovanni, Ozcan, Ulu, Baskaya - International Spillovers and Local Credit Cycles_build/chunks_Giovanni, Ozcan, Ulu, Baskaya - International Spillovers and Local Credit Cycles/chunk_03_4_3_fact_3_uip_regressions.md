# 4.3. *Fact 3: UIP regressions*

In the previous tables, we have shown that FX loans have a large price differential over local currency loans, where the size of this price differential is 7 percentage points on average, as given by the estimated coefficient on the FX dummy. We next ask whether this price differential also moves with the GFC using a difference-in-differences regression setting. We run the following for regression for interest rates and loan volumes:

$$\log \mathbf{Y}_{f,b,d,q} = \alpha_{f,b,q} + \rho(\mathbf{F}\mathbf{X}_{f,b,d,q} \times \log \mathbf{V}\mathbf{I}\mathbf{X}_{q-1}) + \delta \mathbf{F}\mathbf{X}_{f,b,d,q} + u_{f,b,d,q}. \tag{3}$$

Table [10](#page-21-0) presents the results for these regressions, where we include the following timevarying fixed effects on top of firm×bank in order from column (1) to column (4): no time effects (columns 1 and 2), firm×quarter, and firm×bank×quarter.<sup>28</sup> First, in looking at panel A, in all the specifications, the average price differential between FX and local currency loans remains at 7 percentage point when evaluated at the sample mean of log(VIX). More interestingly, during high-VIX episodes, this differential gets larger, where FX loans are 8 percentage points cheaper during high VIX episodes, whereas they are only 6 percentage points cheaper during low VIX episodes based on the interquartile range of log(VIX). This result implies that local currency borrowing becomes *relatively* cheaper during low VIX episodes relative to the average differential between FX and local currency loans.

However, in looking at column (3) and (4) of panel A, we also see that the average effect of FX becomes less significant. First, when we control for time-varying firm demand and risk via

values to the different percentiles of the overall distribution across banks and over time. We include the interaction of log(VIX) with dummy variables denoting the second, third, and fourth quartiles (Q2, Q3, and Q4, respectively), where the first quartile interaction and quartiles dummies are dropped given collinearity. Notably, the Q3 and Q4 interactions are significant, with the Q4 interaction coefficient being significantly larger (in absolute value) for both the interest rate and loan regressions. These results are not surprising given that the non-core distribution is skewed across banks.

28. It is important to note that while we use loans of differing maturities in these regressions, estimation based on loans with a maturity of *only* twelve months deliver similar results—see Table [A9.](#page-38-0)

TABLE 10
The global financial cycle, borrowing costs and loan volumes: the failure of UIP at the loan level

<span id="page-21-0"></span>

|                          | (1)        | (2)          | (3)                | (4)      |
|--------------------------|------------|--------------|--------------------|----------|
|                          |            | Panel A. Nom | inal interest rate |          |
| log(VIX)                 | 0.020***   | 0.022***     |                    |          |
|                          | (0.003)    | (0.003)      |                    |          |
| $FX \times log(VIX)$     | -0.013***  | -0.014***    | -0.013**           | -0.012*  |
|                          | (0.004)    | (0.004)      | (0.005)            | (0.007)  |
| FX                       | -0.032***  | -0.028**     | -0.030*            | -0.034   |
|                          | (0.012)    | (0.013)      | (0.017)            | (0.020)  |
| Observations             | 18,345,853 | 8,573,782    | 8,573,782          | 832,138  |
| R-squared                | 0.781      | 0.759        | 0.855              | 0.749    |
| Macro controls and trend | Yes        | Yes          | No                 | No       |
| Bank controls            | Yes        | Yes          | Yes                | No       |
| Bank×firm F.E.           | Yes        | Yes          | Yes                | Yes      |
| Firm×quarter F.E.        | No         | No           | Yes                | No       |
| Bank×firm×quarter F.E.   | No         | No           | No                 | Yes      |
|                          |            | Panel B. L   | oan volume         |          |
| log(VIX)                 | -0.066**   | -0.097***    |                    |          |
|                          | (0.028)    | (0.026)      |                    |          |
| $FX \times log(VIX)$     | -0.011     | 0.000        | 0.002              | 0.0006   |
|                          | (0.020)    | (0.021)      | (0.023)            | (0.028)  |
| FX                       | 0.607***   | 0.577***     | 0.596***           | 0.625*** |
|                          | (0.061)    | (0.065)      | (0.073)            | (0.088)  |
| Observations             | 18,345,853 | 8,573,782    | 8,573,782          | 832,138  |
| R-squared                | 0.831      | 0.806        | 0.870              | 0.714    |
| Macro controls and trend | Yes        | Yes          | No                 | No       |
| Bank controls            | Yes        | Yes          | Yes                | No       |
| Bank×firm F.E.           | Yes        | Yes          | Yes                | Yes      |
| Firm×quarter F.E.        | No         | No           | Yes                | No       |
| Bank×firm×quarter F.E.   | No         | No           | No                 | Yes      |

Notes: This table presents results for the OLS regressions for (3) using quarterly data for all loans. Panel A uses the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0), and the macroeconomic controls and time trend of Table 8 are included in columns (1)–(2) when firm xquarter effects are excluded, and the bank-level characteristics of Table 8 are included in columns (1)–(3) when bank xquarter effects are excluded. Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and \*\*\* indicates significance at the 1% level, \*\* at the 5% level, and \* at the 10% level.

firm×quarter effects in column (3), the significance of the FX coefficient drops to 10%. Next, when we include bank×firm×quarter effects in column (4), the coefficients become insignificant. The cyclical effect captured by the variable FX×log(VIX) becomes borderline significant. This specification in column (4) reduces the sample size considerably given that identification of the FX coefficients is now only coming from firm-bank pairs that borrow in multiple currencies in a given quarter. That is, for the same firm borrowing from the same bank over time in different currencies, there is no UIP deviation. These fixed effects also control for both bank and firm time-varying risk, bank heterogeneity in access to finance, supply/demand, as well as any time time-varying unobserved heterogeneity, like firm-bank matching being non-random over the cycle.

Although this sample is restrictive, it is the ideal sample to test for UIP at the micro level. In theory, it is possible that a given firm can default on its FX loan obligations and not on its Turkish lira loans upon a depreciation of the Turkish lira. In the data, it seems to be the case that a *given* bank does not price this risk differentially at the loan level for a *given firm* over time. This

![](_page_22_Figure_4.jpeg)

FIGURE 7
The global financial cycle and FX loan shares

Notes: This figure plots the aggregate FX share of loans and our proxy for the GFC over time: (a) the detrended FX share and log(VIX), and (b) the detrended and levels of the FX share. Sources: CBRT and author's calculations.

result shows the critical role of firm risk and bank heterogeneity that are both controlled in this specification.

The loan volume results in panel B differ from the interest rate regressions. In particular, while the FX coefficient remains significant throughout, indicating the fact that loans in foreign currency are in larger amounts on average, the interaction of FX and log(VIX) is insignificant throughout. This is surprising since one might expect that firms would take advantage of relatively lower rates on TRY loans during the boom phase of the GFC and increase their Turkish lira borrowing.

One potential explanation for this fact is the following: during the boom phase of the GFC, Turkish banks are able to more cheaply fund themselves in dollars/euros and therefore would have an incentive to increase lending in FX. At the same time, as we show above, there is a falling risk premium on the Turkish lira, which implies that banks can offer TRY loans with better terms. Thus, banks also have an incentive to increase lending in domestic currency. After drilling down to the micro data, our results show that these two effects offset each other so that the loan composition does not change at the firm-bank level over the GFC.

In the aggregate data, however, we observe that the share of foreign currency loans falls and the share of Turkish lira loans rises during the boom phase of GFC and vice versa as Turkish lira loans become cheaper, consistent with a declining UIP risk premium. The comovement of the FX share and the GFC is shown in Figure 7a, which plots the detrended share of FX loans together with log(VIX). This relationship does not appear in our micro estimates in Table 10, but can be rationalized in the aggregate. Although the two offsetting effects we mention above – Turkish banks borrowing in FX and lending in FX and also lending in TRY due to declining UIP risk premium – are both present in the aggregate data, there are also firms who borrow only in local currency in the aggregate data. These firms make up 63% of the sample. In the difference-in-differences regressions that use the FX dummy to identify the differential pricing and amounts, these firms will not provide any information to identify a differential effect over the cycle since they always borrow only in one currency. In fact, if we plot the level of FX share of loans (instead of detrended), as shown in Figure 7b, this share declines over time during our sample period since most of our sample period coincides with the boom phase of the GFC, where borrowing in TRY was cheaper for the average firm.

To understand what type of bank heterogeneity is driving the UIP deviations, we run another difference-in-differences regression. In Table 11, we interact the FX dummy with a dummy that

<span id="page-23-0"></span>TABLE 11 *The global financial cycle, borrowing costs and loan volumes: the failure of UIP at the loan level and the role of banks' non-core liabilities in transmitting the GFC*

|                          |            | Panel A. Nominal interest rate |         |            | Panel B. Loan bolume |          |
|--------------------------|------------|--------------------------------|---------|------------|----------------------|----------|
|                          | (1)        | (2)                            | (3)     | (4)        | (5)                  | (6)      |
| log(VIX)                 | 0.015∗∗∗   |                                |         | −0.049∗    |                      |          |
|                          | (0.003)    |                                |         | (0.027)    |                      |          |
| FX×NonCore×log(VIX)      | −0.017∗∗∗  | −0.012∗∗∗                      | −0.009∗ | 0.037∗∗    | −0.022               | −0.073∗∗ |
|                          | (0.004)    | (0.003)                        | (0.004) | (0.015)    | (0.017)              | (0.032)  |
| FX×log(VIX)              | −0.009∗∗   | −0.009                         | −0.010  | −0.017     | 0.007                | 0.021    |
|                          | (0.004)    | (0.006)                        | (0.007) | (0.020)    | (0.026)              | (0.031)  |
| NonCore×log(VIX)         | 0.021∗∗∗   | 0.016∗∗∗                       |         | −0.071∗∗∗  | −0.035∗              |          |
|                          | (0.004)    | (0.004)                        |         | (0.016)    | (0.019)              |          |
| FX×NonCore               | 0.049∗∗∗   | 0.032∗∗∗                       | 0.018   | −0.144∗∗∗  | 0.038                | 0.195∗∗  |
|                          | (0.013)    | (0.011)                        | (0.014) | (0.048)    | (0.053)              | (0.095)  |
| FX                       | −0.043∗∗∗  | −0.040∗∗                       | −0.038∗ | 0.638∗∗∗   | 0.587∗∗∗             | 0.569∗∗∗ |
|                          | (0.012)    | (0.018)                        | (0.022) | (0.062)    | (0.080)              | (0.097)  |
| Observations             | 18,345,853 | 8,573,782                      | 832,138 | 18,345,853 | 8,573,782            | 832,138  |
| R-squared                | 0.783      | 0.856                          | 0.750   | 0.831      | 0.870                | 0.714    |
| Macro controls and trend | Yes        | No                             | No      | Yes        | No                   | No       |
| Bank controls            | Yes        | Yes                            | No      | Yes        | Yes                  | No       |
| Bank×firm F.E.           | Yes        | Yes                            | Yes     | Yes        | Yes                  | Yes      |
| Firm×quarter F.E.        | No         | Yes                            | No      | No         | Yes                  | No       |
| Bank×firm×quarter F.E.   | No         | No                             | Yes     | No         | No                   | Yes      |

*Notes:* This table presents results for the OLS regressions for [\(3\)](#page-20-0) using quarterly data for all loans. Panel A uses the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. NonCore is a 0/1 dummy indicating whether a bank is in the "low" (= 0) or "high" (= 1) bin of banks defined by their average non-core liabilities ratio over the sample period. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0), and the macroeconomic controls and time trend of Table [8](#page-17-0) are included in columns (1)–(2) when firm×quarter effects are excluded, and the bank-level characteristics of Table [8](#page-17-0) are included in columns (1)–(3) when bank×quarter effects are excluded . Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and ∗∗∗ indicates significance at the 1% level, ∗∗ at the 5% level, and <sup>∗</sup> at the 10% level.

differentiates between high and low non-core banks to see the role played by bank heterogeneity. We see that high non-core banks play a key role in the differential pricing of FX and Turkish lira loans. These banks price FX loans higher during low VIX periods and lower during high VIX periods, driving the UIP deviations at the firm and loan levels. The differential pricing by non-core banks again disappears when we focus on the within variation for the same bank-same firm pair in the last column of this table. When we calculate the total effect of the FX dummy and/or the non-core variable, we again find the quantitative importance of non-core banks in differential pricing and supply of credit as before. Overall, these results suggest that what is important is bank heterogeneity in terms of access to international funding as differential pricing comes from the variation in non-core liabilities.

Consistent with the findings on differential pricing, panel B shows that high non-core banks supply less FX loans during boom periods of the GFC (low VIX) and supply more FX loans during busts. Notice that this effect is estimated by the FX×Non-core×log(VIX) variable, and the coefficient's sign inverts in the last column once we control for firm and bank time-varying heterogeneity, which allows us to focus on the same firm-bank pair. As we have already shown, there is no differential pricing between FX and TRY loans in this unique sub-sample. And in this sample, a bank supplying more FX loans to a firm during booms—even in the absence of differential pricing – is natural as the high non-core banks tap international markets for FX currency. For the total effects our results from the general sample and the unique sample are similar. Total effects are calculated using estimates from both FX×Non-core×log(VIX) and FX×Non-core, when we evaluate the total effect in moving from the 75th to 25th percentile of log(VIX) (*i.e.* capturing a boom period). These regressions also demonstrate the importance of the cyclicality in the differential loan pricing that comoves with VIX. If we focus only on the average effect estimated from FX×Non-core, we see that non-core banks supply less FX loans when time-varying firm and bank heterogeneity are not controlled for and they supply more FX loans when we account for such heterogeneity. Clearly the former result is spurious as it captures the credit demand effect, since during booms when firms' demand for credit increases, there will be more demand for local currency credit, creating a spurious negative correlation with the supply of FX credit. Once these effects are controlled for, we find that high non-core banks supply more FX credit during normal times (on average) as they fund themselves in FX in the international capital markets. This normal time finding combined with our novel finding that non-core banks supply more TRY loans relative to FX loans during the boom phase of the GFC has important policy implications that we discuss in the conclusion.

# 4.4. *Risk-taking channels*

Before moving on to studying the collateral channel at the loan level, that is our Fact 4, we consider other possible channels through which the GFC may impact domestic credit market conditions, focusing on potential risk-taking by banks.

*Risk-taking channel: maturity transformation.* The first set of regressions, presented in Table [12,](#page-25-0) examines whether high non-core banks affect lending conditions via some form of maturity transformation. In particular, we augment our baseline non-core regression specification [\(2\)](#page-18-0) with a further interaction with a dummy variable based on the maturity of loans, called ST. This variable is assigned value of 1 if loans mature in less than one year, and a zero otherwise. Given that we are interested in investigating maturity transformation, we construct firm-bankquarter measures of interest rates and loan volumes based only on *new loan issuances* over a given quarter rather than using the stock of all existing loans like all the regressions we have run. This is important as maturity at *origination* is the key variable to understand whether or not there is any maturity transformation over the GFC.

Table [12](#page-25-0) presents two specifications in panels A and B: one with only bank×firm fixed effects, and then one augmented with firm×quarter fixed effects. First, in looking at the coefficients on ST in columns (1) and (3), we see that short-term loans have higher interest rates and are smaller on average. However, these differentials disappear once controlling for the time-varying firm-level fixed effects in columns (2) and (4), as these effects pick up firm risk. More interestingly, we next focus on the potential of maturity transformation over the cycle by looking at the differential impacts in loan growth in panel B. In particular, regardless of the specification, we see that high non-core banks issue less short-term loans on average than low non-core banks (the Noncore×ST coefficient is negative), and that this differential becomes larger during boom phases of the GFC: a positive coefficient on the Non-core×ST×log(VIX) variable implies that when VIX falls, high non-core banks provide even less short-term loans (or more short-term loans during high VIX episodes). This result can be interpreted that high non-core banks take more "risk" by providing more long-term loans during the boom phase of GFC as such loans entail higher default risk. Notice that, in terms of pricing, high non-core banks offer lower rates for loans of any maturity, which is why there is not any differential price effect between short-term and long-term loans.

<span id="page-25-0"></span>TABLE 12 *The global financial cycle, borrowing costs and loan volumes: the role of banks' non-core liabilities in transmitting the GFC via maturity transformation*

|                          |           | Panel A. Nominal interest rate |           | Panel B. Loan volume |
|--------------------------|-----------|--------------------------------|-----------|----------------------|
|                          | (1)       | (2)                            | (3)       | (4)                  |
| log(VIX)                 | 0.021∗∗∗  |                                | −0.148∗∗∗ |                      |
|                          | (0.006)   |                                | (0.024)   |                      |
| NonCore×log(VIX)         | 0.035∗∗∗  | 0.012∗                         | −0.090∗∗∗ | −0.245∗∗∗            |
|                          | (0.005)   | (0.006)                        | (0.033)   | (0.043)              |
| NonCore×ST×log(VIX)      | −0.0003   | 0.005                          | 0.137∗∗∗  | 0.265                |
|                          | (0.008)   | (0.008)                        | (0.051)   | (0.063)              |
| ST×log(VIX)              | −0.007    | 0.004                          | 0.030     | −0.014               |
|                          | (0.009)   | (0.011)                        | (0.025)   | (0.038)              |
| NonCore×ST               | 0.011     | −0.007                         | −0.284∗   | −0.690∗∗∗            |
|                          | (0.025)   | (0.025)                        | (0.166)   | (0.206)              |
| ST                       | 0.058∗    | 0.021                          | −0.322∗∗∗ | −0.195               |
|                          | (0.031)   | (0.035)                        | (0.078)   | (0.117)              |
| FX                       | −0.079∗∗∗ | −0.076∗∗∗                      | 0.553∗∗∗  | 0.522∗∗∗             |
|                          | (0.004)   | (0.004)                        | (0.013)   | (0.016)              |
| Observations             | 7,246,294 | 3,452,343                      | 7,246,294 | 3,452,343            |
| R-squared                | 0.641     | 0.777                          | 0.719     | 0.817                |
| Bank×firm F.E.           | Yes       | Yes                            | Yes       | Yes                  |
| Macro controls and trend | Yes       | No                             | Yes       | No                   |
| Bank controls            | Yes       | No                             | Yes       | No                   |
| Firm×quarter F.E.        | No        | Yes                            | No        | Yes                  |

*Notes:* This table presents results for the OLS regressions for [\(2\)](#page-18-0) using quarterly data for all *new loan issuances* and augmented with an interaction for the maturity of loans. Panel A uses the natural logarithm of one plus the weightedaverage of nominal interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. NonCore is a 0/1 dummy indicating whether a bank is in the "low" (= 0) or "high" (= 1) bin of banks defined by their average non-core liabilities ratio over the sample period. ST is a 0/1 dummy indicating whether a loan between a firm-bank pair is short-term (= 1) or long-term (= 0), a loan is is short-term if it's i maturity is less than one year in the given quarter. We aggregate all new loan issuances based on these criteria between a firm-bank pair in a quarter to create the dependent variables. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0), and the macroeconomic controls and time trend of Table [8](#page-17-0) are included in columns (1) when firm×quarter effects are excluded, and the bank-level characteristics of Table [8](#page-17-0) are included. Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and ∗∗∗ indicates significance at the 1% level, ∗∗ at the 5% level, and <sup>∗</sup> at the 10% level.

*Risk-taking channel: leverage and size.* The role of bank heterogeneity in driving *aggregate* credit market conditions has recently been shown to be important in the closed-economy literature by [Coimbra and Rey](#page-39-0) [\(2017\)](#page-39-0), who show how this heterogeneity plays a role in driving credit cycles via a risk-taking channel. Their model emphasizes that heterogeneity in bank leverage can create systemic risk when there is a funding cost shock to banks. We therefore also run horse race regressions including banks' non-core and leverage ratios, as well as bank size, interacted with log(VIX) in Table [13](#page-26-0) for interest rates (Panel A) and loan volumes (Panel B), including firm×quarter fixed effects. The leverage and size variables are based on dummy variables, where like the non-core dummy, we define low and high groups based on banks' average of these variables relative to the sample median of each variable.

First, columns (1) and (4) include the non-core and leverage variables together and show that the non-core interaction remains strongly significant while the leverage ratio interaction is insignificant. Second, columns (2) and (5) include the non-core and bank size variables together and show that the non-core coefficients remain significant. The size interaction is also significant and indicates that larger banks decreasing lending rates more than smaller banks during low VIX

<span id="page-26-0"></span>TABLE 13

The global financial cycle, borrowing costs and loan volumes: the role of banks' non-core liabilities in transmitting the GFC, a horse race with bank leverage and size

|                          | Panel .   | A. Nominal inte | erest rate | Pa        | nel B. Loan vol | ume       |
|--------------------------|-----------|-----------------|------------|-----------|-----------------|-----------|
|                          | (1)       | (2)             | (3)        | (4)       | (5)             | (6)       |
| NonCore×log(VIX)         | 0.014***  | 0.015***        | 0.016***   | -0.038**  | -0.040**        | -0.042**  |
| -                        | (0.003)   | (0.004)         | (0.004)    | (0.018)   | (0.017)         | (0.017)   |
| Leverage × log(VIX)      | -0.003    |                 | -0.011***  | 0.020     |                 | 0.040     |
|                          | (0.002)   |                 | (0.003)    | (0.029)   |                 | (0.026)   |
| $Size \times log(VIX)$   |           | 0.014***        | 0.015***   |           | -0.034*         | -0.036**  |
|                          |           | (0.004)         | (0.004)    |           | (0.018)         | (0.017)   |
| FX                       | -0.069*** | -0.069***       | -0.069***  | 0.601***  | 0.602***        | 0.602***  |
|                          | (0.003)   | (0.003)         | (0.003)    | (0.012)   | (0.012)         | (0.012)   |
| Observations             | 8,573,782 | 8,573,782       | 8,573,782  | 8,573,782 | 8,573,782       | 8,573,782 |
| R-squared                | 0.856     | 0.856           | 0.856      | 0.870     | 0.870           | 0.870     |
| Macro controls and trend | No        | No              | No         | No        | No              | No        |
| Bank controls            | Yes       | Yes             | Yes        | Yes       | Yes             | Yes       |
| Bank×firm F.E.           | Yes       | Yes             | Yes        | Yes       | Yes             | Yes       |
| Firm×quarter F.E.        | Yes       | Yes             | Yes        | Yes       | Yes             | Yes       |

Notes: This table presents results for the OLS regressions for (2) using quarterly data for all loans and augmented with further bank variable interactions. Panel A uses the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. Non-core is a 0/1 dummy indicating whether a bank is in the "low" (= 0) or "high" (= 1) bin of banks defined by their average non-core liabilities ratio over the sample period. Leverage is a 0/1 dummy indicating whether a bank is in the "low" (= 0) or "high" (= 1) bin of banks defined by their leverage ratio over the sample period. Size is a 0/1 dummy indicating whether a bank is in the "low" (= 0) or "high" (= 1) bin of banks defined by their size as measured by log(assets) over the sample period. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0), and the macroeconomic controls and time trend of Table 8 are included in columns (1)-(2) and (4)-(5) when firm×quarter effects are excluded, and the bank-level characteristics of Table 8 are included. Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and \*\*\* indicates significance at the 1% level, \*\* at the 5% level, and \* at the 10% level.

periods (column 2), and offer larger loans during these periods as well (column 5).<sup>29</sup> Finally, columns (3) and (6) includes all three bank variables interacted with log(VIX). The results are similar to the other estimation results. The coefficient on the leverage-VIX interaction term for the interest rate regressions in column (3) is now significant. The leverage coefficient for the loan volume regressions is still insignificant. The robustness of the non-core results points to a new source of heterogeneity to consider for open-economy models. In particular, these set of results are consistent with the risk-taking channel via the decline in funding costs relaxing banks specific financing constraints, where differences in banks' risk-taking behaviour are captured by levels of non-core liabilities, and not just solely leverage or size.

*Risk-taking channel: the exchange rate.* Finally, we explore the possibility that the risk-taking channel works via an international price channel, whereby fluctuations in the exchange rate affect the net worth of borrowers and relax the leverage constraint of lenders (*e.g.* Bruno and Shin, 2015b). In particular, an appreciation of the domestic currency vis-à-vis the USD improves domestic firms' balance sheets, allowing lenders to lend more to these borrowers.<sup>30</sup>

The mechanism is relevant for domestic firms who have debt in U.S. dollars since the shock is on the nominal exchange rate. We control for exchange rate fluctuations in our regressions, but

<sup>29.</sup> The bank size-loan volume result is consistent with results in Baskava et al. (2017).

<sup>30.</sup> The mechanism can also work via lender's balance sheet by increasing lending capacity. However, in our case, there is no currency mismatch on Turkish banks' balance sheets.

<span id="page-27-0"></span>there might still be an interaction effect where such fluctuations affect certain banks and firms as envisioned by the models. Although these models have firms directly borrowing from global banks, we can still test for this possible channel in our setup where firms borrow from domestic banks, which in turn borrow from international markets, since firms can also borrow in foreign currency from domestic banks.<sup>31</sup>

We run a triple interaction specification, which interacts a dummy variable indicating whether a bank is either a low or a high leverage bank on average throughout the sample with a measure of the FX share of a firm's liabilities, and (1) the log change of the Turkish lira-U.S. dollar exchange rate, or (2) a dummy variable for a depreciation episode of the lira viz. the U.S. dollar, or (3) a dummy variable for an appreciation episode of the lira viz. the US dollar.<sup>32</sup>

Since the firm-level balance sheet data are not broken down by currency, we construct a proxy for the FX share using the currency composition of firms' loans in the credit register. In particular, we calculate the FX share of loans for each firm over the sample, and divide firms into low and high FX share bins, based on the median in the whole sample of firms. Therefore, a firm with an average FX share of loans higher than the sample median is assigned a one, while a firm with a lower share is assigned a zero.

Table [14](#page-28-0) presents results for these regressions using quarterly data, where we use aggregate loans for a given firm-bank pair in a quarter as in our benchmark regressions. We present specifications that control for both firm×quarter and bank×quarter effects. Panel A presents results for the nominal interest rate, and panel B for loan volumes. Looking across all specifications we never see a significant coefficient. Therefore, the exchange rate risk-taking channel cannot explain the reduction in borrowing costs and increased lending we have seen in our above regressions. One potential reason for this non-result is the fact that the changes in the exchange rate were not very large during our sample period.

# 4.5. *Fact 4: collateral regressions*

We want to understand how financial constraints relax during the boom phase of the GFC and tighten during the bust. In our data, we observe the posted collateral so rather than proxying for financial constraints by a firm's net worth as is common in the literature,<sup>33</sup> we can use the actual collateral posted for a loan at its issuance, and measure whether its relationship with loan pricing and volume moves with the GFC. The collateral measure also helps us to link our results to the theoretical literature on firm heterogeneity and collateral constraints.

We estimate a loan-level version of our previous regressions using monthly data on *new* loan originations. These regressions allow us to control for all time-varying heterogeneity at the bank and firm levels, including the possibility of a non-random match between firms and banks with the help of firm×bank×month fixed effects. The regression specification is

$$\log Y_{f,b,l,m} = \varrho_{f,b,m} + \beta_1 \text{Collateral}_{f,b,l,m} + \beta_2 (\text{Collateral}_{f,b,l,m} \times \log \text{VIX}_{m-1}) + \beta_3 \text{FX}_{f,b,l,m} + e_{f,b,l,m},$$

$$(4)$$

where we change the *q* subscript to *m* for variables that vary at a monthly level, and focus on both loan volume and the interest rate as the endogenous variables for a given loan *l*. Collateral*<sup>f</sup>* ,*b*,*l*,*<sup>m</sup>*

<sup>31.</sup> As discussed above, Turkish corporate borrowing from foreign banks inside or outside the country and firms' direct external bond issuance are minimal.

<sup>32.</sup> A depreciation period is one where the exchange rate change is in the top quartile of the distribution over the sample. An appreciation period is one where the exchange rate change is in the bottom quartile of the distribution over the sample.

<sup>33.</sup> See [Cooley](#page-39-0) *et al.* [\(2004](#page-39-0)), [Khan and Thomas](#page-40-0) [\(2013\)](#page-40-0), [Gopinath](#page-39-0) *et al.* [\(2017](#page-39-0)), for example.

TABLE 14

The global financial cycle, borrowing costs and loan volumes: exchange rates and risk taking

<span id="page-28-0"></span>

|                                                                             | Panel A              | A. Nominal int       | terest rate          | Pan                 | el B. Loan vo       | lume                |
|-----------------------------------------------------------------------------|----------------------|----------------------|----------------------|---------------------|---------------------|---------------------|
|                                                                             | (1)                  | (2)                  | (3)                  | (4)                 | (5)                 | (6)                 |
| ${\text{Leverage}_b \times \text{FXshare}_f \times \Delta \log(\text{XR})}$ | -0.009<br>(0.008)    |                      |                      | -0.054<br>(0.099)   |                     |                     |
| $Leverage_b \times FX share_f \times Depreciation$                          |                      | -0.002 (0.001)       |                      |                     | -0.025 (0.019)      |                     |
| $Leverage_b \times FX share_f \times Appreciation$                          |                      | , ,                  | -0.001 (0.001)       |                     | ,                   | -0.018 (0.021)      |
| FX                                                                          | -0.070***<br>(0.003) | -0.070***<br>(0.003) | -0.070***<br>(0.003) | 0.603***<br>(0.012) | 0.603***<br>(0.012) | 0.603***<br>(0.012) |
| Observations<br>R-squared                                                   | 8,573,712<br>0.883   | 8,573,712<br>0.883   | 8,573,712<br>0.883   | 8,573,712<br>0.872  | 8,573,712<br>0.872  | 8,573,712<br>0.872  |
| Bank×firm F.E.                                                              | Yes                  | Yes                  | Yes                  | Yes                 | Yes                 | Yes                 |
| Firm×quarter F.E. Bank×quarter F.E.                                         | Yes<br>Yes           | Yes<br>Yes           | Yes<br>Yes           | Yes<br>Yes          | Yes<br>Yes          | Yes<br>Yes          |

Notes: This table presents results for the risk-taking channel regressions using quarterly data for all loans. Panel A uses use the natural logarithm of the weighted average of nominal real interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. Leverage is a 0/1 dummy indicating whether a bank is in the "low" (= 0) or "high" (= 1) bin of banks defined by their leverage ratio over the sample period. FXshare $_f$  is a 0/1 dummy variable indicating whether a firm is in the "low" (= 0) or "high" (= 1) bin of firms defined by their share of loans in foreign currency denomination over the sample period. Log(XR) is the log level of the lagged TRY/US dollar nominal exchange rate;  $\delta$ log(XR) is the lagged log change of the TRY/US dollar nominal exchange rate; Depreciation is 0/1 dummy variable indicating whether the period is a depreciation episode (= 1) or not (= 0), where a depreciation period is one where the exchange rate change is in the top quartile of the distribution over the sample; and Appreciation is 0/1 dummy variable indicating whether the period is a depreciation episode (= 1) or not (= 0), where an appreciation period is one where the exchange rate change is in the bottom quartile of the distribution over the sample. Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and \*\*\* indicates significance at the 1% level, \*\* at the 5% level, and \* at the 10% level.

measures the collateral-to-loan ratio at the initiation of the loan, and  $\varrho_{f,b,m}$  is a firm×bank×month effect that captures time-varying firm and bank-level unobserved factors at the monthly level. Notice that with these fixed effects, we solely identify from changes in the amount of new loans and their interest rates for a given firm-bank pair. Hence, in our most stringent specification, we do not allow firms to switch banks and vice versa for banks. This helps assuage the concern of biased results due to time-varying selection effects at the firm-bank level. Since we use data on *new* loan issuances to run these regressions, we only see each loan once and thus exploit changes in rates and volume of each new loan from month to month to identify the impact of loan riskiness/collateral, conditional on all other time-varying firm and bank factors.

Table 15 presents our results, where we first demean both the collateral ratio and log(VIX) before running the regressions. As shown in panel A, the collateral ratio coefficient is significant and has a negative sign in all columns; that is, there is a negative relationship between the collateral ratio and the price of a loan. To the best of our knowledge, although there are theories that predict a negative relation between posted collateral and the loan rate,<sup>34</sup> our paper is the first to provide evidence on this relationship. It is also interesting to note that this relationship does not vary with VIX once we control for the unobserved time-varying firm-bank effects in columns (4). In other words, once we focus on the same firm borrowing from the same bank over time, the relationship between the collateral posted and a loan's interest rate does not respond to the GFC, as proxied by movements in log(VIX).

<span id="page-29-0"></span>TABLE 15 *The global financial cycle, borrowing costs and loan volumes: loan-level borrowing constraints for new loan issuances*

|                          | (1)        | (2)                            | (3)                  | (4)       |
|--------------------------|------------|--------------------------------|----------------------|-----------|
|                          |            | Panel A. Nominal interest rate |                      |           |
| log(VIX)                 | 0.036∗∗∗   |                                |                      |           |
|                          | (0.004)    |                                |                      |           |
| Collateral/Loan          | −0.011∗∗∗  | −0.012∗∗∗                      | −0.019∗∗∗            | −0.020∗∗∗ |
|                          | (0.003)    | (0.003)                        | (0.005)              | (0.005)   |
| Collateral/Loan×log(VIX) | −0.026∗∗∗  | −0.012∗∗∗                      | −0.013∗∗∗            | −0.002    |
|                          | (0.003)    | (0.003)                        | (0.002)              | (0.004)   |
| FX                       | −0.073∗∗∗  | −0.075∗∗∗                      | −0.069∗∗∗            | −0.070∗∗∗ |
|                          | (0.002)    | (0.002)                        | (0.002)              | (0.002)   |
| Observations             | 10,016,550 | 10,016,368                     | 6,383,626            | 5,358,324 |
| R-squared                | 0.653      | 0.742                          | 0.885                | 0.898     |
| Bank×firm F.E.           | Yes        | Yes                            | Yes                  | No        |
| Bank×month F.E.          | No         | Yes                            | No                   | No        |
| Firm×month F.E.          | No         | No                             | Yes                  | No        |
| Bank×firm×month F.E.     | No         | No                             | No                   | Yes       |
|                          |            |                                | Panel B. Loan volume |           |
| log(VIX)                 | −0.075∗∗∗  |                                |                      |           |
|                          | (0.015)    |                                |                      |           |
| Collateral/Loan          | 0.017      | −0.007                         | 0.023                | 0.041     |
|                          | (0.014)    | (0.017)                        | (0.032)              | (0.030)   |
| Collateral/Loan×log(VIX) | 0.013      | 0.040                          | 0.045∗               | 0.061     |
|                          | (0.025)    | (0.026)                        | (0.023)              | (0.041)   |
| FX                       | 0.403∗∗∗   | 0.395∗∗∗                       | 0.401∗∗∗             | 0.456∗∗∗  |
|                          | (0.012)    | (0.011)                        | (0.021)              | (0.023)   |
| Observations             | 10,016,550 | 10,016,368                     | 6,383,626            | 5,358,324 |
| R-squared                | 0.679      | 0.684                          | 0.798                | 0.806     |
| Bank×firm F.E.           | No         | No                             | No                   | No        |
| Bank×month F.E.          | No         | Yes                            | No                   | No        |
| Firm×month F.E.          | No         | No                             | Yes                  | No        |
| Bank×firm×month F.E.     | No         | No                             | No                   | Yes       |

*Notes:* This table presents results for regressions using monthly data at the loan level at the origination date for the collateral regressions for [\(4\)](#page-27-0). All variables are measured at the loan level, VIX is the lagged end-of-month value. The Collateral/Loan variable is the collateral posted at the time of issuance of the new loan. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0). We demean both the collateral ratio and log(VIX). Panel A presents results for the nominal interest rate. Panel B presents results for the natural logarithm of the loan value. Column (1) includes the standard macroeconomic controls and a time trend, column (2) includes bank×month fixed effects, column (3) includes firm×month fixed effects, and column (4) includes bank×firm×month fixed effects. The regressions further include fixed effects for (i) bank defined risk weights, (ii) sectoral activity of loan, and (iii) maturity levels. Standard errors are double clustered at the firm and month levels, and ∗∗∗ indicates significance at the 1% level, ∗∗ at the 5% level, and <sup>∗</sup> at the 10% level.

In panel B, we investigate whether or not collateral constraints relax during episodes of low VIX-high capital inflows. We find no significant relationship between the collateral-to-loan ratio and loan volumes in all columns. Furthermore, we also find no relationship between collateral ratio and credit volumes during high and low VIX episodes. These results suggest that credit growth during low VIX episodes is driven by low interest rates, regardless of collateral values.

To test whether or not credit growth is mainly driven by lower rates or higher collateral values, we regress loan volumes on both interest rates and posted collateral in the same regression. This regression allows us to examine the correlation between loan volumes, interest rates and the collateral ratio jointly. Table [16](#page-30-0) presents these results. The coefficient on the interest rate is negative and strongly significant, as we would expect given previous results if the loan growth is being driven by supply-driven GFC capital inflows and a fall in the risk premium faced by

<span id="page-30-0"></span>TABLE 16

The global financial cycle and loan volumes: loan-level borrowing constraints vs. borrowing costs for new loan issuances

|                                      | (1)        | (2)        | (3)       | (4)       |
|--------------------------------------|------------|------------|-----------|-----------|
| log(1+i)                             | -1.936***  | -2.350***  | -2.512*** | -2.453*** |
|                                      | (0.076)    | (0.074)    | (0.121)   | (0.136)   |
| Collateral/Loan                      | 0.003      | -0.035***  | -0.024    | -0.011    |
|                                      | (0.010)    | (0.012)    | (0.019)   | (0.018)   |
| FX                                   | 0.262***   | 0.219***   | 0.229***  | 0.285***  |
|                                      | (0.013)    | (0.013)    | (0.020)   | (0.022)   |
| Observations                         | 10,016,550 | 10,016,368 | 6,383,626 | 5,358,324 |
| R-squared                            | 0.684      | 0.690      | 0.801     | 0.809     |
| Bank×firm F.E.                       | Yes        | Yes        | Yes       | No        |
| Bank×month F.E.                      | No         | Yes        | No        | No        |
| Firm×month F.E.                      | No         | No         | Yes       | No        |
| $Bank{\times}firm{\times}month~F.E.$ | No         | No         | No        | Yes       |

Notes: This table presents results for regressions using monthly data at the loan level at the origination date for the collateral regressions for (4). All variables are measured at the loan level, where  $\log(1+i)$  is the loan nominal interest rate, the Collateral/Loan variable is the collateral posted at the time of issuance of the new loan; FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0). We demean both the collateral ratio. Column (1) includes the standard macroeconomic controls and a time trend, column (2) includes bank×month fixed effects, column (3) includes firm×month fixed effects, and column (4) includes bank×firm×month fixed effects. The regressions further include fixed effects for (i) bank defined risk weights, (ii) sectoral activity of loan, and (iii) maturity levels. Standard errors are double clustered at the firm and month levels, and \*\*\* indicates significance at the 1% level, \*\* at the 5% level, and \* at the 10% level.

domestic banks, and which is passed on to firms. Meanwhile, the coefficient on the collateral ratio is never significant once we control for time-varying firm-level fixed effects.
