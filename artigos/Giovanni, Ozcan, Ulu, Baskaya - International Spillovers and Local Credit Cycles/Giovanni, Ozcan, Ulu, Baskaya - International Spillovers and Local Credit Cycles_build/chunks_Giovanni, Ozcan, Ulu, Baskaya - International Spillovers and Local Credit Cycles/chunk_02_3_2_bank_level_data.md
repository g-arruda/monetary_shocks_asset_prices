## 3.2. *Bank-level data*

Turkey, like many major emerging markets, has a bank dominated financial sector: in 2014, banks held 86% of the country's financial assets and roughly 90% of total financial liabilities. The past decade has witnessed a doubling of bank deposits and assets, while loans have increased five-fold. Our baseline analysis uses quarterly bank balance sheet data from Turkey for the 2003–13 period. The data are collected at the monthly level, and we use March, June, September, and December reports. All banks operating within Turkey are required to report their balance sheets as well as extra items to the regulatory and supervisory authorities—such as the CBRT and the Banking Regulation and Supervision Agency (BRSA)—by the end of the month.

even if the initial loan withdrawal is less than the amount. We therefore winsorize the collateral-to-loan ratio at a value of 200% to match an upper-bound used by the banks. Further, note that the book and market values of the collateral are the same since we observe each loan and collateral posted only once in a given month given our focus on new issuances.

|              | Obs. | Mean  | Median                  | Std. Dev. | Min.  | Max.  |
|--------------|------|-------|-------------------------|-----------|-------|-------|
|              |      |       | Panel A. All banks      |           |       |       |
| Assets/GDP   | 11   | 0.775 | 0.744                   | 0.189     | 0.548 | 1.105 |
| Loans/GDP    | 11   | 0.377 | 0.368                   | 0.167     | 0.146 | 0.668 |
| Deposits/GDP | 11   | 0.461 | 0.458                   | 0.095     | 0.342 | 0.603 |
|              |      |       | Panel B. Domestic banks |           |       |       |
| Assets/GDP   | 11   | 0.683 | 0.650                   | 0.127     | 0.532 | 0.901 |
| Loans/GDP    | 11   | 0.321 | 0.312                   | 0.128     | 0.140 | 0.544 |
| Deposits/GDP | 11   | 0.410 | 0.407                   | 0.060     | 0.334 | 0.492 |
|              |      |       | Panel C. Foreign banks  |           |       |       |
| Assets/GDP   | 11   | 0.092 | 0.094                   | 0.064     | 0.013 | 0.205 |
| Loans/GDP    | 11   | 0.056 | 0.056                   | 0.040     | 0.006 | 0.124 |
| Deposits/GDP | 11   | 0.051 | 0.051                   | 0.036     | 0.007 | 0.112 |

TABLE 5 *Banking sector quarterly summary statistics, based on official bank-level balance sheet data, 2003–13*

*Notes:* This table presents summary statistics on bank-level variables using quarterly data pooled over 2003–13 for all banks (Panel A), domestic banks (Panel B), and foreign banks (Panel C). The ratios are based on the banking sector's total assets, loans, and deposits relative to GDP, respectively. The sector variables are created by aggregating the official bank balance sheet data for the end of the year. All data are sourced from the CBRT.

Table 5 presents summary statistics based on end-of-year values for the banking sector as a whole for all banks (Panel A), domestic banks (Panel B), and foreign banks (Panel C). Looking at the total banking sector level in Panel A, we see that on average over the sample period the sector's assets represented approximately 78% of GDP, loans 38%, and deposits 46%. Looking at the same statistics in panels B and C, we see that domestic banks dominate overall banking activity relative to foreign banks. This is an important fact to note and makes Turkey different than other large emerging markets (*e.g.* Mexico), where foreign banks play a larger role in the banking sector. Specifically, over the 2003–13 period there are 45 banks, of which 28 are commercial (domestic and foreign), 14 are investment and development, and 5 are branches of foreign banks.<sup>15</sup> Our sample of banks varies between 35 and 43 throughout the period since we focus on banks that are active in the corporate loan market and this number changes from period to period.

Table [6](#page-12-0) presents summary statistics based on end-of-quarter values both at the bank level for all banks (Panel A), domestic banks (Panel B), and foreign banks (Panel C), and summarize the banking variables we include in our regressions. These variables, like others used in the article, are winsorized at the 1% level. There is quite a bit of variation in bank size (as measured by total assets), the capital ratio, the leverage ratio, the non-core ratio, liquidity ratio, and return on assets (ROA) across banks and over time. In comparing domestic and foreign banks, we see that domestic banks are larger on average as well as having a larger leverage ratio. Meanwhile, foreign banks have larger non-core, liquidity and capital ratios on average. It is also instructive to look at the standard deviations of the bank variable across both bank groups, which reveal that the distributions of the various bank characteristics overlap across the domestic and foreign bank groups.

**3.2.1. Understanding non-core liabilities.** Finally, we compare bank-level variables across groups of banks that we split into "low" and "high" non-core banks in Table [7.](#page-13-0) We do

<sup>15.</sup> Note that in the aftermath of the 2001 crisis, the weak capital structure of the Turkish banks resulted in a number of takeovers. As a result, in the 2000–04 period, a total of 25 banks were taken over by Deposit-Insurance Fund, SDIF. Our sample begins at the end of this period, where the majority of takeovers were completed.

TABLE 6 *Bank-level quarterly summary statistics, based on official bank-level balance sheet data, 2003–13*

<span id="page-12-0"></span>

|                        | Obs.  | Mean  | Median                  | Std. Dev. | Min.  | Max.  |
|------------------------|-------|-------|-------------------------|-----------|-------|-------|
|                        |       |       | Panel A. All banks      |           |       |       |
| log(total real assets) | 1,685 | 14.40 | 14.47                   | 2.230     | 8.466 | 18.33 |
| Non-core ratio         | 1,685 | 0.298 | 0.226                   | 0.224     | 0.000 | 0.907 |
| Liquidity ratio        | 1,685 | 0.400 | 0.335                   | 0.217     | 0.017 | 0.960 |
| Capital ratio          | 1,685 | 0.145 | 0.138                   | 0.044     | 0.064 | 0.198 |
| Leverage ratio         | 1,685 | 0.776 | 0.862                   | 0.198     | 0.007 | 0.984 |
| ROA                    | 1,685 | 0.012 | 0.010                   | 0.010     | 0.000 | 0.033 |
|                        |       |       | Panel B. Domestic banks |           |       |       |
| log(total real assets) | 1,092 | 14.79 | 14.76                   | 2.222     | 10.19 | 18.33 |
| Non-core ratio         | 1,092 | 0.260 | 0.212                   | 0.194     | 0.000 | 0.907 |
| Liquidity ratio        | 1,092 | 0.353 | 0.315                   | 0.189     | 0.017 | 0.960 |
| Capital ratio          | 1,092 | 0.141 | 0.130                   | 0.044     | 0.064 | 0.198 |
| Leverage ratio         | 1,092 | 0.776 | 0.870                   | 0.206     | 0.038 | 0.984 |
| ROA                    | 1,092 | 0.012 | 0.010                   | 0.010     | 0.000 | 0.033 |
|                        |       |       | Panel C. Foreign banks  |           |       |       |
| log(total real assets) | 593   | 13.70 | 13.71                   | 2.066     | 8.466 | 17.15 |
| Non-core ratio         | 593   | 0.368 | 0.277                   | 0.257     | 0.000 | 0.907 |
| Liquidity ratio        | 593   | 0.485 | 0.448                   | 0.238     | 0.055 | 0.948 |
| Capital ratio          | 593   | 0.153 | 0.153                   | 0.043     | 0.064 | 0.198 |
| Leverage ratio         | 593   | 0.776 | 0.847                   | 0.183     | 0.007 | 0.964 |
| ROA                    | 593   | 0.012 | 0.010                   | 0.010     | 0.000 | 0.033 |
|                        |       |       |                         |           |       |       |

*Notes:* This table presents summary statistics on bank-level variables using quarterly data pooled over the 2003–13 for all banks (Panel A), domestic banks (Panel B), and foreign banks (Panel C). Total Assets are in nominal terms; the Non-core Ratio is non-core liabilities over total liabilities; the Liquidity Ratio is liquid assets over total assets; the Capital Ratio is equity over total assets; the Leverage Ratio is total liabilities over total assets; and ROA is the return on total assets. Non-core liabilities = Payables to money market + Payables to securities + Payables to banks + Funds from Repo + Securities issued (net). All data are sourced from the CBRT.

this as the non-core variable is our key variable to proxy access to international markets that will be used in our difference-in-differences regressions below. In particular, we construct a noncore liabilities ratio, where the denominator is total liabilities that is defined as deposits (core funding) + non-core funding. Non-core liabilities equals Payables to money market + Payables to securities + Payables to banks + Funds from Repo + Securities issued (net). We then create a time-invariant dummy that split banks into low and high non-core groups, where the dummy is defined by comparing a bank's average non-core ratio to the overall sample's median. A low non-core bank has a mean below the sample median, while a high non-core bank has a mean greater than or equal to the median. As can be seen in Figure [2,](#page-13-0) banks with high non-core liabilities are the ones that borrow internationally since a large part of these liabilities are in foreign currency.<sup>16</sup>

Note that high and low non-core banks can either be domestic or foreign banks.<sup>17</sup> Comparing the two groups in Table [7,](#page-13-0) it is interesting to first note that the low non-core banks are larger on average, as well as having larger leverage ratios than the high non-core bank sample.<sup>18</sup> This fact, in part, motivates some further robustness regressions we run below. Meanwhile, high non-core banks have somewhat larger liquidity and capital ratios than the low non-core sample, and the ROA is about the same across both groups on average. What is important for our purposes is the

<sup>16.</sup> Turkish banks' liabilities to each other are in TRY.

<sup>17.</sup> The two non-core groups are quite balanced along the domestic/foreign bank split, with the low non-core sample having 63% of the banks being domestic, while the high non-core sample is composed of 64% of domestic banks.

<sup>18.</sup> Notice that leverage ratios are based on total liabilities and high non-core banks can have high leverage in terms of short-term liabilities since non-core funding is mostly short-term.

<span id="page-13-0"></span>

|                        | P    | Panel A. Low non-core |           |      | Panel B. High non-core |           |  |
|------------------------|------|-----------------------|-----------|------|------------------------|-----------|--|
|                        | Obs. | Mean                  | Std. Dev. | Obs. | Mean                   | Std. Dev. |  |
| log(total real assets) | 721  | 15.40                 | 2.189     | 964  | 13.66                  | 1.952     |  |
| Non-core ratio         | 721  | 0.157                 | 0.085     | 964  | 0.404                  | 0.237     |  |
| Liquidity ratio        | 721  | 0.346                 | 0.185     | 964  | 0.440                  | 0.230     |  |
| Capital ratio          | 721  | 0.130                 | 0.039     | 964  | 0.157                  | 0.044     |  |
| Leverage ratio         | 721  | 0.817                 | 0.192     | 964  | 0.745                  | 0.197     |  |
| ROA                    | 721  | 0.011                 | 0.009     | 964  | 0.013                  | 0.011     |  |

TABLE 7
Bank-level summary statistics by non-core grouping, 2003–13

Notes: This table presents summary statistics on bank-level variables using quarterly data pooled over 2003–13 for "low" non-core banks (Panel A) and "high" non- banks (Panel B. A low non-core bank has a mean non-core ratio below the sample median, while a high non-core bank has a mean greater than or equal to the median. Total Assets are in nominal terms; the Non-core Ratio is non-core liabilities over total liabilities; the Liquidity Ratio is liquid assets over total assets; the Capital Ratio is equity over total assets; the Leverage Ratio is total liabilities over total assets; and ROA is the return on total assets. Non-core liabilities = Payables to money market + Payables to securities + Payables to banks + Funds from Repo + Securities issued (net). All data are sourced from the CBRT.

![](_page_13_Figure_6.jpeg)

FIGURE 2
Composition of non-core liabilities of banks

Notes: This figure plots the break down of non-core liabilities of the Turkish banking sector using pooled quarterly data over 2004–13. Panel (a) presents the breakdown across five sub-groups: (i) payables to the money market, (ii) payables to banks, (iii) securities issued, (iv) payables to the securities market, and (v) Repos. Panel (b) further breaks down payables to banks (ii) by currency shares. Source: CBRT

time-series relation between non-core liabilities and foreign financing (capital flows). As shown in Figures 3 and 4, domestic banks' non-core liabilities move together with capital flows (both total and banking sector), whereas foreign banks' do not.

### 3.3. Macro-level data

Figure 5 plots Turkey's credit growth (Loans/GDP Growth) and current account position (CA/GDP) against log(VIX) and Turkish capital inflows in panels (a) and (b), respectively. Movements in the VIX tend to be negatively correlated with Turkey's credit growth, and positively correlated with the current account balance (a fall in the current account implies an *increase* in net capital inflows). The loan-to-GDP growth fluctuates between 5 and 10% quarterly during our sample. Looking at a more direct measure of capital inflows to Turkey, we see that this measure

<span id="page-14-0"></span>![](_page_14_Figure_4.jpeg)

FIGURE 3
Capital inflows and non-core liabilities

*Notes:* This figure plots the median bank non-core ratio and the logarithm of total capital inflows over time, where panel (a) presents the median domestic bank, and panel (b) presents the median foreign bank. *Source:* CBRT.

![](_page_14_Figure_7.jpeg)

FIGURE 4
Banking inflows and non-core liabilities

Notes: This figure plots the median bank non-core ratio and logarithm of banking inflows over time, where panel (a) presents the median domestic bank and panel (b) presents the median foreign bank. Source: CBRT.

is positively correlated to Turkey's credit growth, while negatively correlated with its current account. These correlations are consistent with the story as described for VIX in the introduction.

Firms' direct external borrowing is very limited in Turkey and hence banks are the key intermediary of capital flows. As Figure 6 shows, the external corporate bond issuance is negligible as a percentage of GDP, whereas banks' external borrowing is as high as 40% of GDP at the end of our sample period.

Table A1 presents summary statistics for the quarterly Turkish and global macroeconomic and financial variables that we use as controls in our regressions, as well as measures of global financial conditions. All real variables are deflated using 2003 as the base year. The Turkish macroeconomic data are taken from the CBRT. VIX and the Turkish overnight rate are quarterly averages. There is substantial quarterly variation in all these variables over the sample period, which is crucial for our identification strategy.

<span id="page-15-0"></span>![](_page_15_Figure_3.jpeg)

FIGURE 5
Capital flows, VIX, and credit growth in Turkey, 2004–13

Notes: These figures plot Turkey's Loans/GDP and CA/GDP ratios over time with (a) log(VIX) and (b) Turkish capital inflows (in 2003 TRY). Turkey's Loans/GDP, CA/GDP, and Capital inflows are sourced from the CBRT, and VIX is the period average. Four-quarter moving averages are plotted for all variables but log(VIX).

![](_page_15_Figure_6.jpeg)

FIGURE 6
Banks and firms external borrowing, 2005–13

Notes: This figure plots the external liabilities of banks and external corporate bond issuance as a ratio to GDP. Source: CBRT.

#### 4. EMPIRICAL FACTS

#### 4.1. Fact 1: macro regressions for the GFC, credit growth, and loan rates

We begin with "macro" regressions, which regress the nominal interest rate (1) and the loan principal outstanding (Loan) on our measure of the GFC, log(VIX). Regressions are weighted-least squares, where weights are time series mean of the natural logarithm of a bank's total assets.<sup>19</sup>

<span id="page-16-0"></span>The standard errors are double clustered at the firm and time levels.<sup>20</sup> We run

$$\begin{split} \log \mathbf{Y}_{f,b,d,q} = & \alpha_{f,b} + \lambda \mathrm{Trend}_q + \beta \log \mathrm{VIX}_{q-1} + \delta \mathrm{FX}_{f,b,d,q} + \Theta_1 i_{q-1} + \Theta_2 \Delta \log(\mathrm{GDP}_{q-1}) \\ & + \Theta_3 \mathrm{Inflation}_{q-1} + \Theta_4 \Delta \log(\mathrm{XR}_{q-1}) + \Theta_5 \mathbf{Bank}_{b,q-1} + \varepsilon_{f,b,d,q}, \end{split} \tag{1}$$

where  $Y_{f,b,d,q}$  is either  $Loans_{f,b,d,q}$  or one plus the nominal interest rate  $(1+i_{f,b,d,q})$ , for a given firm-bank (f,b) pair in a given currency denomination (d) and quarter (q),  $\alpha_{f,b}$  is a firm×bank fixed effect, which controls for unobserved firm and bank-level time-invariant heterogeneity, and  $Trend_q$  is a linear trend variable. FX is a dummy variable that is equal to 1 if the firm-bank loan observation is in foreign currency, and 0 if it is in Turkish lira. We use the VIX index in logs as the proxy for GFC. Using firm×bank fixed effects allows us to identify from within firm-bank variation comparing given firm—bank pairs over time.

The firm-bank level interest rates will be a function of the domestic policy rates  $(i_{q-1})$  plus the firm risk premium. If UIP holds, the domestic policy rate is equal to the sum of the foreign interest rate and the expected exchange rate change. We include the domestic policy rate directly, as we later document a UIP violation. We control for macro fundamentals in every specification, proxied by GDP growth, inflation and fluctuations in the exchange rate (XR). We also add under **Bank**, a set of bank characteristics that control for bank heterogeneity, including log(assets), capital ratio, liquidity ratio, non-core liabilities ratio, and return on total assets (ROA). These variables are standard in the literature and importantly include the inverse of banks' leverage (*i.e.* the capital ratio), which has been highlighted as responding to global financial conditions and wealth effects arising from exchange rate and asset price changes (*e.g.* Bruno and Shin, 2015a,b), thus allowing banks to expand their lending. We lag all the controls.

Table 8 presents the results for regression (1) for all firm-bank relationships, as well as splitting the sample between domestic and foreign banks. The estimated coefficient for the effect of VIX on the interest rate in panel A for all banks, 0.019, for all banks implies a 1 percentage point fall in the average borrowing rate resulting from a fall in log(VIX) equal to its interquartile range over the sample period. The baseline micro estimates of the elasticity of domestic loan growth with respect to changes in VIX is -0.067. We use this estimated VIX coefficient to quantify the effect of movements in VIX on aggregate credit growth. Appendix A.1 provides an aggregation equation, which shows how to use the micro estimates to draw implications for aggregate credit growth over the cycle. We can explain on average 43% of observed cyclical aggregate loan growth to the corporate sector.<sup>22</sup>

There are some interesting differences when looking at the estimated coefficients on log(VIX) in the domestic and foreign bank sub-samples. First, while the interest rate coefficients in panel A are positive and highly significant for both the domestic and foreign bank sub-samples, the coefficient estimated in the domestic bank sample is almost twice as large as that of the foreign bank sample, 0.22 versus 0.12. Therefore, it appears that Turkish domestic banks are more responsive to the GFC than foreign ones operating in Turkey. This difference is even more striking when turning to the loan-VIX elasticities estimated in panel B. Here, the coefficient

<sup>20.</sup> Petersen (2009) shows that the best practice is to cluster at both levels, or if the number of clusters is small in one dimension, then use a fixed effect for that dimension and cluster on the other dimension, where more clusters are available.

<sup>21.</sup> We will explicitly control time-varying firm risk premium in our difference-in-differences framework below; here only the average level of firm riskiness is controlled through the use of firm fixed effects.

<sup>22.</sup> We apply (A.4) using  $\hat{\beta} = -0.067$  and the observed change in log(VIX) to obtain predicted aggregate loan growth. We then divide this series by the linearly detrended series of *actual* aggregate credit growth, and take the average of this ratio to arrive at 43%.

TABLE 8 *The global financial cycle, borrowing costs, and loan volumes*

<span id="page-17-0"></span>

|                          | Panel A. Nominal interest rate<br>Bank sample |            |           | Panel B. Loan volume<br>Bank sample |            |          |
|--------------------------|-----------------------------------------------|------------|-----------|-------------------------------------|------------|----------|
|                          | All                                           | Domestic   | Foreign   | All                                 | Domestic   | Foreign  |
|                          | (1)                                           | (2)        | (3)       | (4)                                 | (5)        | (6)      |
| log(VIX)                 | 0.019∗∗∗                                      | 0.022∗∗∗   | 0.012∗∗∗  | −0.067∗∗                            | −0.073∗∗∗  | 0.0366   |
|                          | (0.003)                                       | (0.003)    | (0.003)   | (0.027)                             | (0.024)    | (0.040)  |
| FX                       | −0.069∗∗∗                                     | −0.066∗∗∗  | −0.065∗∗∗ | 0.576∗∗∗                            | 0.612∗∗∗   | 0.367∗∗∗ |
|                          | (0.003)                                       | (0.003)    | (0.003)   | (0.010)                             | (0.013)    | (0.025)  |
| Domestic policy rate     | 0.214∗∗∗                                      | 0.255∗∗∗   | 0.145∗∗∗  | 0.117                               | 0.165      | −0.506   |
|                          | (0.026)                                       | (0.031)    | (0.028)   | (0.301)                             | (0.297)    | (0.319)  |
| GDP growth               | −0.063∗                                       | −0.059     | −0.117∗∗∗ | 0.199                               | 0.197      | 0.703    |
|                          | (0.035)                                       | (0.042)    | (0.041)   | (0.321)                             | (0.318)    | (0.488)  |
| XR change                | −0.046∗∗∗                                     | −0.056∗∗∗  | −0.014    | 0.037                               | 0.061      | −0.275   |
|                          | (0.010)                                       | (0.013)    | (0.016)   | (0.124)                             | (0.130)    | (0.141)  |
| Inflation                | −0.015                                        | −0.019     | −0.012    | 0.037                               | 0.066      | −0.072∗  |
|                          | (0.017)                                       | (0.022)    | (0.008)   | (0.121)                             | (0.122)    | (0.071)  |
| Observations             | 18,345,853                                    | 13,490,892 | 905,024   | 18,345,853                          | 13,490,892 | 905,024  |
| R-squared                | 0.781                                         | 0.720      | 0.831     | 0.831                               | 0.810      | 0.825    |
| Macro controls and trend | Yes                                           | Yes        | Yes       | Yes                                 | Yes        | Yes      |
| Bank controls            | Yes                                           | Yes        | Yes       | Yes                                 | Yes        | Yes      |
| Bank×firm F.E.           | Yes                                           | Yes        | Yes       | Yes                                 | Yes        | Yes      |

*Notes:* This table presents results for the OLS regressions for [\(1\)](#page-16-0) using quarterly data. Panel A, columns (1)-(3) use the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firm-bank as the dependent variable for the full bank sample, domestic banks, and foreign banks, respectively. Panel B, columns (4)-(6) use the natural logarithm of total loans between a firm-bank as the dependent variable for the full bank sample, domestic banks, and foreign banks, respectively. VIX is the lagged quarterly average. FX is a 0/1 dummy indicating whether a loan is in foreign currency ( = 1) or domestic ( = 0), the domestic rate is the quarterly average overnight rate, GDP growth is real quarterly, XR change is the quarterly Turkish lira/U.S. dollar exchange rate change, and inflation is quarterly CPI changes. A linear time trend is also included as a regressor. Furthermore, the lagged values of the following bank-level characteristics are also controlled for (not reported): log(assets), capital ratio, liquidity ratio, non-core liabilities ratio, and return on total assets (ROA). Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and ∗∗∗ indicates significance at the 1% level, ∗∗ at the 5% level, and <sup>∗</sup> at the 10% level.

on log(VIX) is negative and strongly significant for domestic banks, while it's actually slightly positive and statistically insignificant for foreign banks. These results point to the crucial role that *domestic* banks playing in transmitting the GFC to the Turkish credit market, a result that differs drastically from the literature that focuses on the role of foreign banks in transmitting foreign monetary policy (*e.g.* [Morais](#page-40-0) *et al.*, [2019\)](#page-40-0).<sup>23</sup>

*Demand and supply factors: capital inflows and the GFC.* The GFC, as proxied by VIX, is strongly correlated with Turkish capital inflows as Figure [5](#page-15-0) depicts. A natural question then arises as to whether the correlation between VIX and capital inflows is picking up demand, supply, or both. The regressions in Table 8 control for macro demand factors, such as domestic GDP growth. However, it is also insightful to look at the log(VIX) coefficient in the interest rate regressions. If movements in VIX were in fact picking up local demand factors, we would expect loan interest rates to be *negatively* correlated with VIX. For example, imagine that VIX

<sup>23.</sup> We have also run regressions including both the VIX and measures of monetary policy shocks [\(Gertler and Karadi](#page-39-0), [2015](#page-39-0)) in Table [A2.](#page-33-0) The regressions show that the coefficients on log(VIX) remain strongly significant. Further, the coefficients on the monetary policy shocks, FF4 or MP1, in the interest rate regressions are either barely significant or not significant at all. Meanwhile, the coefficients for these variables in loan volume regressions are highly significant and of the expected sign.

<span id="page-18-0"></span>falls as global conditions improve and Turkish firms react by beginning to demand more credit (which banks in part finance by borrowing from abroad), we would then expect there to be an upward pressure on lending rates given increased demand, holding banks' supply constant. This would generate a negative correlation between rates and VIX, which is counterfactual to our regression results. If, on the other hand, a fall in VIX is associated with an improvement in global financial conditions and allows Turkish banks to access foreign capital more cheaply, these banks can then offer loans at a lower interest rate in the domestic credit market. This in turn implies a *positive* correlation between VIX and lending rates as we find in panel A of Table [8.](#page-17-0) Note that under both a demand or supply scenario we would expect the same signed coefficient between VIX and loan volume—negative as our regressions show. Following this logic, our first set of regressions, therefore, point to the GFC impacting the domestic credit market from the supply side, as domestic banks tap global capital markets to finance domestic lending at lower costs.<sup>24</sup>

The estimation of [\(1\)](#page-16-0) may still suffer from omitted demand variable, especially at the firmlevel and thus be biased. We therefore next turn to exploiting bank heterogeneity in their access to foreign capital in a difference-in-differences regression setup, which allows us to explicitly control for time-varying firm demand and firm credit risk.<sup>25</sup>

# 4.2. *Fact 2: non-core regressions*

To further identify the spillovers from global financing conditions into the domestic credit market via supply-driven capital inflows, we explore the variation in banks' exposure to international financial markets and how this exposure affects the *pricing* of loans, fully accounting for firm time-varying characteristics and demand for credit. To focus on how the difference in banks' reliance on financing via non-traditional (or wholesale) funding impacts their behaviour over the GFC, we use banks' non-core liabilities. We construct a non-core ratio, which is non-core liabilities divided by total liabilities, where non-core liabilities are defined Section [3.](#page-5-0) We estimate

$$\log Y_{f,b,d,q} = \alpha_{f,b} + \alpha_{f,q} + \zeta (\text{Non-core}_b \times \log \text{VIX}_{q-1}) + \delta_1 \text{FX}_{f,b,d,q} + \epsilon_{f,b,d,q}, \tag{2}$$

where α*<sup>f</sup>* ,*<sup>q</sup>* is a firm×quarter fixed effect, controlling for firms' credit demand. Non-core*<sup>b</sup>* is a time-invariant dummy variable, for whether a bank has a high non-core liabilities ratio or not, where a bank is assigned a 1 for "high" if its average non-core ratio over time is larger than the median of all banks' non-core over the sample; otherwise, it receives a zero for a "low" non-core bank.26

- 24. We have also run a regression of Turkish capital inflows on log(VIX) and the macroeconomic variables used in [\(1\)](#page-16-0), augmented for Turkish consumer confidence, which is available from 2004 onwards—the regression thus uses 39 observations in total. This estimated coefficient on log(VIX) is −1.493 and significant at the 1% level. Meanwhile, while the coefficient on consumer confidence is positive, as would be expected for a capital inflows demand variable, it is not significant, nor are the rest of the macroeconomic variables.
- 25. We have also explored the sensitivity of our baseline estimates to firms' direct exposure to the global economy by running regressions splitting the sample between exporters and non-exporters in Table [A3.](#page-34-0) The interest rate-VIX elasticity is indeed smaller for exporters, and larger for the loan volume regressions pointing to potential demand effects being picked up by VIX. However, note that the coefficients remain strongly significant and are the same sign as for the non-exporters regressions. Furthermore, exporters make up less than ten percent of our sample of loans. We have also run the regression based on loans that are earmarked for domestic-activity only (i.e., are not used for exporting or importing activity according to loan records) in Table [A4.](#page-34-0) Results are robust compared to using all loans. We also explore the sensitivity of the VIX coefficient across sectors in Table [A5.](#page-35-0) The coefficients on log(VIX) do not vary very much across sectors. Finally, we have run our baseline regressions given different sample cuts and other robustness checks in Tables [A6](#page-36-0) and [A7,](#page-36-0) respectively. All results are robust.
- 26. We have also run regressions allowing for the slope on the trend variable to be heterogeneous across groups and results are robust.

<span id="page-19-0"></span>TABLE 9

The global financial cycle, borrowing costs, and loan volumes: the role of banks' non-core liabilities in transmitting the GFC

|                           | Panel A    | A. Nominal inte | rest rate | Panel B. Loan volume |           |           |
|---------------------------|------------|-----------------|-----------|----------------------|-----------|-----------|
|                           | (1)        | (2)             | (3)       | (4)                  | (5)       | (6)       |
| log(VIX)                  | 0.014***   | 0.015***        |           | -0.050*              | -0.085*** |           |
| _                         | (0.003)    | (0.002)         |           | (0.026)              | (0.024)   |           |
| $NonCore \times log(VIX)$ | 0.019***   | 0.015***        | 0.014***  | -0.068***            | -0.041*** | -0.038**  |
|                           | (0.004)    | (0.004)         | (0.003)   | (0.016)              | (0.014)   | (0.017)   |
| FX                        | -0.069***  | -0.070***       | -0.069*** | 0.576***             | 0.577***  | 0.601***  |
|                           | (0.003)    | (0.003)         | (0.003)   | (0.010)              | (0.011)   | (0.012)   |
| Observations              | 18,345,853 | 8,573,782       | 8,573,782 | 18,345,853           | 8,573,782 | 8,573,782 |
| R-squared                 | 0.782      | 0.759           | 0.856     | 0.831                | 0.806     | 0.870     |
| Macro controls and trend  | Yes        | Yes             | No        | Yes                  | Yes       | No        |
| Bank controls             | Yes        | Yes             | No        | Yes                  | Yes       | No        |
| Bank×firm F.E.            | Yes        | Yes             | Yes       | Yes                  | Yes       | Yes       |
| Firm×quarter F.E.         | No         | No              | Yes       | No                   | No        | Yes       |

Notes: This table presents results for the OLS regressions for (2) using quarterly data for all loans. Panel A uses the natural logarithm of one plus the weighted-average of nominal interest rates for loans between a firm-bank as the dependent variable. Panel B uses the natural logarithm of total loans between a firm-bank as the dependent variable. VIX is the lagged quarterly average. Non-core is a 0/1 dummy indicating whether a bank is in the "low" (= 0) or "high" (= 1) bin of banks defined by their average non-core liabilities ratio over the sample period. FX is a 0/1 dummy indicating whether a loan is in foreign currency (= 1) or domestic (= 0), and firm×quarter effects are included in all specifications. Regressions are all weighted-least square, where weights are equal to the time-series average of the log of the bank's total assets, and standard errors are double clustered at the firm and quarter levels, and \*\*\* indicates significance at the 1% level. \*\* at the 5% level, and \* at the 10% level.

Table 9 shows that banks with higher non-core liabilities respond more to movements in VIX in their loan pricing and also in loan issuances. During periods of low VIX, high non-core banks decrease their borrowing rates more. The estimated coefficient on the interaction between VIX and the non-core dummy is 0.013 when including firm×quarter effects in column (2), which is almost as large as the estimated elasticity of 0.019 between the interest rate and VIX in the macro regression of Table 8. Therefore, the relative differential in changes in interest rates for high non-core banks given movements in the GFC is economically large, and high non-core banks are responsible for a significant part of the aggregate effect.

We further run the interaction regression including VIX on its own without firm×quarter effect to recover the VIX-only coefficient in column (1). In this case, the estimated coefficient on VIX is slightly lower (0.015) than the one in the macro regressions, while the coefficient on the interaction between the non-core dummy and VIX is almost the same (0.015) as in the regression with firm×quarter effects. Given this regression, the estimated interest rate-VIX elasticity for high non-core banks is double (0.015+0.015=0.03) that of low non-core banks (0.015). We can use the estimated coefficients for the loan volume regressions and the aggregation accounting exercise as described in Appendix A.1 to gauge the importance of high non-core banks in explaining aggregate credit growth over the sample period. Specifically, we take the ratio of the calculated average aggregate loan growth using the coefficients for VIX and the interacted non-core coefficient for high non-core banks to the average aggregate loan growth calculated for all banks, and find this ratio to be 0.95.<sup>27</sup>

<sup>27.</sup> This number drops to approximately 0.86 if we use the (smaller) sample that contains only multiple firm-bank observations, as in column (4) of Table 9. Table A8 presents regressions where we define non-core dummies based on the quartiles of the non-core distribution, where banks with larger non-core ratios appear in higher quartiles. We define the quartile dummies by first computing the average non-core ratios for banks over the time series and then compare these

<span id="page-20-0"></span>We have also investigated the cyclical properties of potential changing firm-bank relationships across the low and high non-core banks to ensure that our results are not driven by selection bias. To do so, we calculate the net count of these relationships each period, where a negative count means relatively more relationships of a given firm with low non-core than high non-core banks as a ratio of total relationships. First, it is interesting to note that the ratio is always negative, which implies that on average firms tend to have more relationships with low non-core banks, where the ratio gets more negative over time. Second, there is some correlation between the ratio and log(VIX) over time, but this cyclicality is mainly driven by Turkish lira loans. Furthermore, the correlation is slightly negative, which would imply that during boom times (*i.e.* low VIX), firms tend to form more relationships with high non-core banks. If anything, this could bias our results towards zero, as more firms borrowing from high non-core banks would also imply a greater chance of low-quality firms asking for loans, and thus high non-core banks would tend to charge *higher*, not lower interest rates during boom periods, which may imply why the point estimate of the interaction term in column (3) increases slightly once we control for firm×quarter effects.

To summarize, internationally exposed banks (as proxied by the high levels of non-core liability ratio) play a dominant role in explaining our overall aggregate results. This result combined with the fact that we are able to control for time-varying firm characteristics including firms' credit demand and credit risk in these specifications gives us further confidence that the macro regressions above are capturing the causal impact of GFC on the domestic credit market.
