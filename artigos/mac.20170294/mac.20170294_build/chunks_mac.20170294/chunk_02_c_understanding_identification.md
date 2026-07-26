# C. Understanding Identification

The BP-SVAR identifies that monetary policy shocks transmit through changes in corporate spreads and that, at the same time, monetary policy systematically responds to these spreads. In this subsection, we argue that these results are driven by the BP-SVAR's identification of the *contemporaneous* response of monetary policy to corporate spreads,  $\psi_{0,cs}$ , and not by other features related to the inclusion of corporate spreads, such as the presence of lagged spreads in the VAR equations.

Specifically, we compare the BP-SVAR that includes the Baa spread with an otherwise identical model identified using a traditional Cholesky ordering of the endogenous variables that imposes  $\psi_{0,cs}=0.^{19}$  As shown in Table 1 in the online Appendix, imposing  $\psi_{0,cs}=0$  does not affect the estimate of the cumulative elasticity to corporate spreads, which is similar to the estimate reported in Table 1

<span id="page-15-0"></span><sup>&</sup>lt;sup>18</sup> Figure 2 in the online Appendix compares the prior (before observing the proxy) and the posterior distribution of the elasticities associated with the monetary policy equation for BP-VAR that includes the Baa spreads. This figure shows that the addition of the proxy to the SVAR clearly updates the posterior distribution for these parameters.

<span id="page-15-1"></span> $<sup>^{19}</sup>$  In particular, we identify a monetary policy shock by ordering the federal funds rate after IP, unemployment, and prices but before corporate spreads. This identification strategy imposes that monetary policy cannot respond contemporaneously to changes in spreads—that is,  $\psi_{0,cs} = 0$ . At the same time, this ordering is consistent with some key features documented in the BP-SVAR: (i) on impact, a monetary shock does not affect IP, unemployment, and prices although it can affect corporate spreads; and (ii) monetary policy can react contemporaneously to changes in IP, unemployment, and prices.

![](_page_16_Figure_3.jpeg)

FIGURE 3. IMPULSE RESPONSES TO A MONETARY POLICY SHOCK: CHOLESKY IDENTIFICATION

*Notes:* Each panel depicts the impulse responses of the specified variable to a one standard deviation monetary policy shock identified in the five-equation Cholesky SVAR (red solid line) and in the BP-SVAR (green dashed line). Shaded bands denote the 90 percent pointwise credible sets calculated from the Cholesky SVAR.

for the BP-SVAR. Hence, the key difference in the systematic response of monetary policy to corporate spreads between models is not in the overall response, but in its timing.

The red solid lines depicted in Figure 3 display the impulse responses of the endogenous variables to a one standard deviation monetary shock identified using the Cholesky ordering. The green dashed lines represent the median responses estimated using the BP-SVAR. Under the Cholesky identification, a monetary policy shock induces a decline in real activity, but the effects are modest. The median estimates of the drop in IP and the rise in the unemployment rate are one-half of those implied by the BP-SVAR, and zero is always well within the 90 percent credible sets. The impact response of the Baa spread, despite being unrestricted, is close to zero, and its dynamic response is also not meaningfully different from zero.

The identification of  $\psi_{0,\,cs}$  also has important implications for the propagation of other shocks in the economy, in particular those affecting corporate spreads. To examine the role of  $\psi_{0,\,cs}$ , Figure 4 displays the impulse responses of the endogenous variables to a financial shock in both the BP-SVAR and the Cholesky models.  $^{20}$  We normalize the shock to induce an exogenous increase in the Baa spread

<span id="page-16-0"></span> $<sup>^{20}</sup>$  In the Cholesky ordering, we identify the financial shock by assuming that the Baa spread is ordered last. In the BP-SVAR, we identify it by assuming that the Baa spread is ordered last within the set of non-policy variables. Note that the BP-SVAR allows the financial shock to have a contemporaneous effect on the federal funds rate, as  $\psi_{0,cs} \neq 0$ . Consequently, the financial shock cannot *directly* affect the remaining non-policy variables on impact, but it can affect them indirectly through the federal funds rate. The idea is to compare the identification of a financial shock using a "full" Cholesky to a block Cholesky, where the only difference is in the identification of the monetary shock via the proxy.

<span id="page-17-0"></span>![](_page_17_Figure_3.jpeg)

FIGURE 4. IMPULSE RESPONSES TO A FINANCIAL SHOCK: CHOLESKY IDENTIFICATION

*Notes:* Each panel depicts the impulse responses of the specified variable to a one standard deviation financial shock identified in the five-equation Cholesky SVAR (red solid line) and in the BP-SVAR (green dashed line). Shaded bands denote the 90 percent pointwise credible sets calculated from the Cholesky SVAR.

of 10 basis points in both models. In response to a financial shock in the Cholesky model, the Baa spread goes up exactly 10 basis points on impact, fully absorbing the exogenous shock, and remains above 0 for about 2 years. The real consequences of this shock are large; IP falls about 0.5 percent and the unemployment rate rises 8 basis points. The federal funds rate cannot respond contemporaneously to the shock but drops about 25 basis points after 2 years. By contrast, the real effects of a financial shock in the BP-SVAR are modest. The federal funds rate drops about eight basis points on impact. The immediately accommodative policy stance partially offsets the effects of the financial shock on the Baa spread, which increases on impact only 8 basis points, and on real activity: the fall in IP is 50 percent smaller and the rise in the unemployment rate is 25 percent smaller than in the Cholesky model. The smaller real and financial effects of the shocks induce a faster reversal of the policy stance.

The most important implication of the analysis presented in this subsection is that models that ignore (such as the four-equation BP-SVAR) or restrict to zero (such as the Cholesky SVAR shown here) the systematic response of monetary policy to corporate spreads identify a monetary policy shock that is contaminated by the endogenous response of monetary policy to spreads. Figure 4 explains why this contamination induces an attenuation of the estimated effects of monetary policy shocks. Because increases in spreads are associated with future low economic activity, monetary policy shocks identified by a rule that does not acknowledge that  $\psi_{0,cs} < 0$  are a mix of truly exogenous changes in monetary policy and negative (endogenous) movements in corporate spreads.

 $\psi_r$ 

| RELEVANCE PRIORS                      |                                                        |                           |
|---------------------------------------|--------------------------------------------------------|---------------------------|
|                                       | Baseline                                               | High relevance prior      |
| Panel A. Contemporaneous elasticities |                                                        |                           |
| $\psi_{0,cs}$                         | -1.18 [-3.11, -0.35]                                   | -1.17 [-2.21, -0.78]      |
| $\psi_{0,\pi}$                        | 0.13<br>[-0.11, 0.37]                                  | 0.09<br>[ 0.01, 0.16]     |
| $\psi_{0,\Delta_{\mathrm{y}}}$        | $ \begin{array}{c} 0.03 \\ [-0.15, 0.25] \end{array} $ | $ 0.08 \\ [-0.03, 0.15] $ |
| $\psi_{0,u}$                          | 0.23<br>[-0.67, 1.38]                                  | $ 0.28 \\ [-0.02, 0.62] $ |
| Panel B. Cumulative elasticities      |                                                        |                           |
| $\psi_{cs}$                           | -0.22 [-0.35, -0.09]                                   | -0.21 [-0.30, -0.13]      |
| $\psi_\pi$                            | $ \begin{array}{c} 0.13 \\ [-0.12, 0.39] \end{array} $ | $ 0.09 \\ [-0.00, 0.18] $ |
| $\psi_{\Delta_y}$                     | 0.06<br>[-0.14, 0.32]                                  | 0.10<br>[-0.02, 0.18]     |
| $\psi_u$                              | -0.06<br>[-0.16, 0.04]                                 | -0.07 $[-0.14, -0.01]$    |

Table 2—Coefficients in the Monetary Policy Equation: Baseline versus High Relevance Priors

*Notes:* The entries in the table denote the posterior median estimates of the contemporaneous elasticities (panel A) and the cumulative elasticities (panel B) in the monetary equation identified in five-equation BP-SVAR under the baseline (column 1) and high relevance (column 2) priors on  $\sigma_{\nu}$ . The 90 percent credible sets from the posterior distributions are reported in brackets.

0.96

[0.92, 1.01]

0.96

[0.93, 0.99]

### D. Inference under the High Relevance Prior

In this subsection, we study the effect of using the high relevance prior, focusing on the estimation of the BP-SVAR that includes the Baa spread. Recall that the benefit of using this prior is that the identified systematic component of monetary policy is associated with monetary shocks that more closely resemble the proxy than under the baseline prior.

Under the baseline estimation, the relevance indicator  $\rho$ , which measures the strength of the relationship between the proxy and the identified monetary policy shock, is 0.1 at the posterior median. Under the high-relevance prior, the posterior relevance is substantially higher, with a median value of 0.4, which translates into a correlation between the proxy and the monetary policy shock of 0.63.

Table 2 lists the impact and cumulative elasticities for the baseline (left column) and the high-relevance (right column) priors. Although the point estimates are similar, under the high-relevance prior, the uncertainty surrounding the elasticities is substantially reduced. In particular, monetary policy stabilizes movements in all the endogenous variables with high-posterior probability. Hence, the information contained in the proxy is consistent with a monetary policy rule that responds to corporate spreads beyond the conventional response to output and prices.

![](_page_19_Figure_3.jpeg)

Figure 5. Impulse Responses to a Monetary Policy Shock: High Relevance Prior

*Notes:* The solid line in each panel depicts the median impulse response of the specified variable to a one standard deviation monetary policy shock identified using the five-equation BP-VAR estimated under the high relevance prior on σν. Shaded bands note the 90 percent pointwise credible sets.

Figure 5 plots the impulse responses to a one standard deviation monetary policy shock under the high relevance prior. Consistent with the results reported in Table 2, the use of the high-relevance prior induces smaller credible sets, confirming the large real and financial effects of monetary policy shocks.

# E. *Summary of Findings and Policy Implications*

The results presented in this section show that the dynamic effects of monetary shocks on the real economy are substantially larger and more precisely estimated with the inclusion of corporate credit spreads in the VAR. The reason is that corporate credit spreads are both a conduit of changes in monetary policy to the real economy and important to quantifying the systematic response of monetary policy to economic and financial conditions. Models missing this interaction are likely to underestimate the importance of the systematic and nonsystematic components of monetary policy for business cycle analysis.

Our findings have two policy implications. The first is that, during the Great Moderation period, the systematic component of monetary policy provided more stabilization than suggested by conventional identifications. The second is that the monetary authority could have induced a large reduction in business cycle fluctuations by not deviating from the rule.

# **IV. Romer and Romer (2004) Revisited**

In the previous section, we established the presence of a crucial interdependence between monetary policy and corporate credit spreads. In this section, we build on this result to reexamine the narrative identification of monetary policy shocks of Romer and Romer (2004—henceforth, RR). We first document that the RR shocks contain the systematic response of monetary policy to corporate credit spreads. We then show the implications of this finding by estimating hybrid VARs and local projections—models that are typically used to track the effects of narrative shocks. In the online Appendix, we also report results for an estimated BP-SVAR that includes the RR shocks alongside our baseline proxy.

### A. Revisiting the Romer and Romer (2004) Identification

RR propose to identify monetary policy shocks by regressing  $\Delta f f_{\tau}$ , the intended funds rate change decided at meeting  $\tau$ , on the level of, and the revisions to, the Federal Reserve's forecasts of output and inflation. For  $\Delta f f_{\tau}$ , we use the series of intended federal funds changes updated through 2007 from Wieland and Yang (2016). We estimate the following regression:

(16) 
$$\Delta f f_{\tau} = \alpha + \beta_{cs} c s_{\tau}^{5d} + \beta_{0} f_{\tau} + \beta_{1} \tilde{u}_{\tau,0} + \sum_{i=-1}^{2} \gamma_{i} \Delta \tilde{y}_{\tau,i} + \sum_{i=-1}^{2} \phi_{i} \tilde{\pi}_{\tau,i} + \sum_{i=-1}^{2} \lambda_{i} (\Delta \tilde{y}_{\tau,i} - \Delta \tilde{y}_{\tau-1,i}) + \sum_{i=-1}^{2} \theta_{i} (\tilde{\pi}_{\tau,i} - \tilde{\pi}_{\tau-1,i}) + \varepsilon_{t},$$

where  $f_{\tau}$  is the level of the intended funds rate before any policy decision associated with meeting  $\tau$ ;  $\tilde{u}$ ,  $\tilde{y}$ , and  $\tilde{\pi}$  are the Greenbook forecasts of the unemployment rate, the real output growth, and inflation, respectively (prior to the choice of the interest rate); and the i index in the summations refers to the horizon of the forecasts. The regression includes both the level of the output and inflation forecasts and the revision from the previous meeting.

We reconstruct the RR shocks with two changes to their estimation framework. First, we include in the regression an indicator of credit spreads. Because Greenbook forecasts for credit spreads are available only starting in 1998, our instrument is instead  $cs_{\tau}^{5d}$ , the average Baa spread for the five days prior to the FOMC meeting. We denote the associated regression coefficient by  $\beta_{cs}$ . Second, we make the sample period consistent with the one used in BP-SVAR analysis.

The first column of Table 3 tabulates the results for the specification estimated with the restriction  $\beta_{cs}=0$ . In line with the results reported in RR, the estimates show that monetary policy tends to behave countercyclically and stabilizes movements in output and inflation. The  $R^2$  of the regression is 0.66, suggesting that although most of the changes in US monetary policy were taken in response to the evolution of forecasted output and inflation, it does not guarantee that the unexplained variation is exogenous to the state of the economy.

The second column of Table 3 tabulates the results for the regression that estimates  $\beta_{cs}$ . Consistent with the evidence from the BP-SVAR, we find that the

<span id="page-20-0"></span><sup>&</sup>lt;sup>21</sup> Results are robust to using the average Baa spread calculated from the first day of the month when the FOMC meeting takes place to the day prior to the meeting.

|  | Table 3— | -Determinants o | OF THE CHANGE I | N THE INTENDED | FEDERAL FUNDS RATE |
|--|----------|-----------------|-----------------|----------------|--------------------|
|--|----------|-----------------|-----------------|----------------|--------------------|

<span id="page-21-0"></span>

|                           | (1)             | (2)             |
|---------------------------|-----------------|-----------------|
| Baa spread $(\beta_{cs})$ |                 | -0.11<br>(0.05) |
| Unemployment rate         | -0.06 (0.04)    | -0.09 (0.03)    |
| Output growth             | 0.09<br>(0.02)  | 0.08<br>(0.02)  |
| Inflation                 | 0.25<br>(0.05)  | 0.21<br>(0.05)  |
| Output growth (revision)  | 0.04<br>(0.04)  | 0.02<br>(0.04)  |
| Inflation (revision)      | -0.10<br>(0.09) | -0.08 (0.09)    |
| Adjusted R <sup>2</sup>   | 0.66            | 0.68            |

Notes: The dependent variable in each specification is  $\Delta f f_\tau$ , the series of changes in the intended funds rate around FOMC meetings constructed using the methodology in Romer and Romer (2004). Column 1 reports the estimates of the OLS coefficients for the regression described in equation (16), while column 2 reports the estimated coefficients for a regression that includes corporate credit spreads. Each regression includes a constant and  $f_\tau$ . Standard errors reported in brackets are based on the heteroskedasticity- and autocorrelation-consistent asymptotic covariance matrix computed according to Newey and West (1987) with the automatic lag selection method of Newey and West (1994).

FOMC reacts to changes in the Baa spread beyond the information contained in the Greenbook forecast of output and inflation. Note,  $\beta_{cs}$  has a point estimate of -0.11 with a small standard error; all else being equal, FOMC meetings occurring in periods with elevated levels of corporate credit spreads are associated with cuts in the intended federal funds rate. This evidence shows that, for the 1994–2007 period, the standard estimates of the RR shocks are contaminated by the endogenous response of monetary policy to changes in credit spreads.

The residuals of the two regressions shown in Table 3 constitute narrative-based measures of shocks. We label the shocks constructed using regression (1) the "RR shocks" and the shocks constructed using regression (2) the "RR-CS shocks." The RR and RR-CS shocks are highly correlated (0.87), but they lead to dramatically different implications about monetary policy, as we show next.

### B. Results from Hybrid VARs

RR embed their measure of monetary policy shocks into an otherwise standard VAR by replacing the federal funds rate with the cumulated series of narrative shocks.<sup>22</sup> Thus, in hybrid VARs,  $m_t$  enters into the vector of observables and the VAR model is used simply to track the dynamic effects of the shock. Hybrid SVARs cannot be used to identify the systematic component because, as  $m_t$  is already exogenous, the associated equation cannot be interpreted as the monetary policy rule. By contrast, in proxy SVARs  $m_t$  does identify the monetary policy rule,

<span id="page-21-1"></span><sup>&</sup>lt;sup>22</sup> This hybrid VAR specification has been used also in Coibion (2012), Barakchian and Crowe (2013), and Ramey (2016).

![](_page_22_Figure_3.jpeg)

FIGURE 6. IMPULSE RESPONSES TO A MONETARY POLICY SHOCK: HYBRID VARS

*Notes:* The solid line in each panel depicts the median impulse response of the specified variable to a one standard deviation monetary policy shock identified in a hybrid VAR without the Baa spread (left column) and with the Baa spread (right column) using the cumulated RR-CS shocks as the policy variable. Shaded bands denote the associated 90 percent pointwise credible sets. The dotted lines are the median responses for the hybrid VARs that use the cumulated RR shocks.

which is important for understanding the business cycle properties of both policy and non-policy shocks.

In this section, we use hybrid VARs to trace the effects of RR and RR-CS monetary shocks. As in Section III, we estimate hybrid SVARs with and without corporate spreads.<sup>23</sup> The left column of Figure 6 shows the impulse responses to a one standard deviation monetary policy shock identified in the hybrid VARs that omit the Baa spread, while the right column shows the impulse responses for the hybrid

<span id="page-22-0"></span><sup>&</sup>lt;sup>23</sup> The hybrid VARs are estimated on IP, the unemployment rate, prices, and the Baa spreads. We also include a measure of commodity prices to increase comparability with Coibion (2012) and Ramey (2016).

VARs that include spreads. The red lines denote the posterior median response when using the RR-CS shocks, while the green dotted lines show the median response when using the RR shocks.

In both models, when using the RR-CS shocks, monetary policy induces a decline in IP and an increase in the unemployment rate comparable with those in the BP-SVAR that includes corporate spreads. Results in the hybrid VARs using the RR-CS shocks do not depend on the inclusion of the Baa spread because we control for the systematic response of monetary policy to the spread in the construction of the shock, which is external to the VAR. Thus, in the RR regression,  $\beta_{cs}$  plays a similar role as  $\psi_{0,cs}$  in the BP-SVAR. RR shocks do not have any effect on IP, the unemployment rate, and prices in the model that exclude spreads. By contrast, when spreads are included as an observable in the VAR, the difference between the responses of IP and the unemployment rate under the RR and the RR-CS shocks is smaller, even though the RR-CS shock yields a large decline in real activity. This result is consistent with the importance of the identification of the contemporaneous response of monetary policy to spreads discussed in Section IIIC.

Overall, the results from the narrative identification and the BP-SVAR share the same dependence on the inclusion of spreads in the monetary policy equation, irrespective of whether it is external to the VAR.

### C. Local Projections

To further corroborate the importance of controlling for corporate credit spreads when using the RR narrative shocks, we construct impulse responses with local projections as described in Jordà (2005). The advantage of this method is that impulse responses are not functions of the structural parameters of the VAR model, and hence are less sensitive to model misspecification. Moreover, Ramey (2016) shows that the use of local projections, as opposed to VAR models, can have a major impact on the sign and size of impulse responses to a monetary policy shock.

Local projections estimate the direct effects of a shock,  $e_t$ , on a variable  $y_{j,t}$ , by running a set of regressions:

(17) 
$$y_{j,t+h} = \beta_h^j e_t + \text{control variables}_{t-1:t-p} + \epsilon_{t+h}^j, \quad h = 0, \dots, \bar{h},$$

where h is the forecast horizon. We run local projections on the level of the federal funds rate, unemployment, and the Baa spread, and on the annualized change in IP and prices defined as  $\Delta_h y_{j,t+h} \equiv \frac{1,200}{h+1} \ln \left( \frac{y_{j,t+h}}{y_{j,t-1}} \right)$ .

In line with the analysis presented so far, we estimate two sets of local projections. The first set does not control for the endogenous response of monetary policy to corporate spreads. In these regressions, we set  $e_t$  to be the RR shock and we include as control variables 12 lags of the federal funds rate, unemployment, and the monthly change in IP and prices. The second set controls for corporate

TABLE 4—LOCAL PROJECTIONS

|                                                 | (1)             | (2)             |
|-------------------------------------------------|-----------------|-----------------|
| Panel A. Forecast horizon: Impact (zero months) |                 |                 |
| Federal funds rate                              | 0.90<br>(0.18)  | 0.88<br>(0.22)  |
| Industrial production                           | 2.99<br>(2.91)  | 3.60<br>(3.04)  |
| Unemployment                                    | 0.02<br>(0.13)  | 0.04<br>(0.10)  |
| Prices                                          | -3.31 (3.74)    | -4.13<br>(3.27) |
| Baa spread                                      | -0.02 (0.30)    | 0.33<br>(0.14)  |
| Panel B. Forecast horizon: 18 months            |                 |                 |
| Federal funds rate                              | 1.68<br>(1.07)  | 1.05<br>(0.87)  |
| Industrial production                           | 0.12<br>(1.51)  | -1.07 (1.19)    |
| Unemployment                                    | -0.18 (0.36)    | 0.22<br>(0.26)  |
| Prices                                          | 0.15<br>(0.97)  | -1.01 (1.00)    |
| Baa spread                                      | -0.18<br>(0.30) | -0.31 (0.34)    |

*Notes:* The table denotes estimates  $\hat{\beta}_0^i$  (panel A) and  $\hat{\beta}_{18}^i$  (panel B) associated with equation (17), estimated by least squares, with HAC standard errors in parentheses, where j refers to the dependent variable considered. Each row corresponds to a different dependent variable, where industrial production and prices have been expressed in annualized changes. Columns 1 and 2 report the estimates associated with  $e_t = RR_t$  and  $e_t = RR-CS_t$ , respectively. Both regressions include as controls 12 lags of the federal funds rate, the change in industrial production, the unemployment rate, and the change in the price level. The regressions associated with column 2 additionally contain 12 lags of the Baa spread as controls.

credit spreads by setting  $e_t$  to be the RR-CS shock and by including 12 lags of the Baa spreads.<sup>24</sup>

The results for the impact horizon (h=0) are tabulated in panel A of Table 4, while those for the 18-month horizon are shown in panel B. According to the first column, local projections that do not control for corporate spreads find that a 100 basis points RR shock induces an impact response of the federal funds rate of about 90 basis points and induces an immediate decline in prices. There is, however, no strong evidence of meaningful effects on IP and the unemployment rate at the 18-month horizon.

According to the second column, impulse responses based on local projections that control for the Baa spread estimate effects of monetary policy shocks that are broadly in line with the BP-SVAR and the hybrid VAR. At the point estimates, an RR-CS shock of 100 basis points induces a 1 percent decline in IP, and a

<span id="page-24-0"></span> $<sup>^{24}</sup>$  Results are robust to selecting p by maximizing the Akaike information criterion (AIC) with an upper bound of 24 lags.

22 basis points increase in the unemployment rate at the 18-month horizon.[25](#page-25-0) For comparison, in the BP-SVAR, a monetary shock of 100 basis points, about 3 times larger than the one plotted in Figure 1, would induce a 1.3 percent decline in IP and a 20 basis point increase in unemployment at the same horizon.

Overall, local projections lead to the same conclusions about the effects of monetary policy shocks as the BP-SVAR analysis. However, we note that local projections, by not specifying structural relationships among the endogenous variables, cannot be used to study the role of the systematic component of monetary policy for macroeconomic stabilization nor the importance of monetary policy shocks for business cycle fluctuations.

## **V. Robustness**

In this section, we first show that the importance of including corporate credit spreads in a monetary proxy SVAR is robust to the choice of the estimation framework. We then estimate a larger BP-SVAR model to provide a richer description of the transmission of monetary policy to the economy. Finally, we show that the response of monetary policy to corporate credit spreads can also be found by directly estimating an augmented Taylor rule.
