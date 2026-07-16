## B. *Results from the Simple VAR*

To show how our external instruments approach works, we first present results from the simple VAR that includes the log industrial production, the log consumer price index, the one-year government bond rate as the policy indicator, and the GZ excess bond premium. Roughly speaking, the latter is the component of spread between an index of rates of return on corporate securities and a similar maturity government bond rate that is left after the component due to default risk is removed. As such, it is possibly interpretable as a pure measure of the spread between yields on private versus public debt that is due to financial market frictions. The inclusion of the excess bond premium allows us to clearly illustrate that our external instruments approach is particularly useful when examining the response of financial as well economic variables to exogenous monetary policy surprises.

We choose the excess bond premium as the financial indicator in the simple VAR for two reasons. First, as GZ show, the excess bond premium has strong forecasting ability for economic activity, outperforming every other financial indicator. Accordingly, this variable may provide a convenient summary of much of the information from variables left out of the VAR that may be relevant to economic activity. Second, we are ultimately interested in examining the response of credit costs to monetary policy surprises. As we show, it is fairly straightforward to evaluate the response of the excess bond premium against the conventional theory of monetary policy transmission, particularly since the measure cleans off default considerations.

[Figure 1](#page-17-0) shows the impulse responses of both the economic and financial variables is the simple VAR. The left panels show the case where money shocks are identified using external instruments. For comparison, the right panels show the case using a standard Cholesky identification. In each case, the panels report the estimated impulse responses along with 95 percent confidence bands, computed using bootstrapping methods.[13](#page-16-0)

<span id="page-16-0"></span><sup>13</sup>Similarly to Mertens and Ravn (2013), we are using wild bootstrap that generates valid confidence bands under heteroskedasticity and strong instruments. The estimation errors related to the instrumental variable

<span id="page-17-0"></span>![](_page_17_Figure_3.jpeg)

FIGURE 1. ONE-YEAR RATE SHOCK WITH EXCESS BOND PREMIUM

We begin with the external instruments case. As noted earlier, we use the three month ahead funds rate future surprise FF4 to identify monetary policy shock. As a check to ensure that this instrument is valid, we report the *F*-statistic from the first stage regression of the one-year bond rate residual on FF4. We find an *F*-value of 21 and half. We also compute a robust *F*-statistic (which allows for heteroskedasticity) of 17.5. Both values are safely above the threshold suggested by Stock et al. (2002) to rule out a reasonable likelihood of a weak instruments problem.

As the top left panel shows, a one standard deviation surprise monetary tightening induces a roughly 25 basis point increase in the one-year government bond rate. Consistent with conventional theory, there is a significant decline in industrial production that reaches a trough roughly a year and a half after the shock. Similarly consistent with standard theory, there is a small decline in the consumer price index that is not statistically significant. Note that in contrast to the Cholesky identification, we do not impose zero restrictions on the contemporaneous responses of output and inflation. The identification of the monetary policy shock is entirely due to the external instrument.

regression is incorporated in the reported confidence bands, because both stages of the estimation are included in the bootstrapping procedure. Thereby, we avoid any potential "generated regressor" problem.

The GZ excess bond premium increases on impact roughly 10 basis points, an amount which is statistically significant. The spread further remains elevated at roughly 7 basis points for roughly another half year. As we elaborate in the next section, this increase in the excess bond premium following the monetary tightening is consistent with a credit channel effect on borrowing costs: It cannot be explained simply by an increase in bankruptcy probabilities since default premia have been cleaned off the measure.

Critical for obtaining these results is our use of external instruments to identify monetary shocks, as comparison with the case of the Cholesky identification scheme makes clear. Under the Cholesky scheme we consider, the one-year rate is ordered second to last and the excess bond premium last. Given these identifying restrictions, the central bank adjustment of the one-year rate can have an immediate impact on the excess bond premium. But contemporaneous innovations in the excess bond premium do not affect how the central bank manipulates the one-year rate. By assumption, any information in the innovation to the excess bond premium that is relevant to the central bank's decision is already contained in the innovations to industrial production and the CPI. Finally, as in the standard Cholesky case, the central bank can respond to news about output and prices within the period but can affect these variables only with a lag.

As Figure 1 shows, how well a pure monetary policy surprise is identified under the Cholesky scheme is questionable. While the one-year rate increases, both industrial production and the CPI display "puzzles": The monetary policy shock induces a modest but statistically significant increase in each variable. Though the point estimate of industrial productions eventually falls, the decline is not statistically significant.

The behavior of the excess bond premium illustrates the problem with the identification. In response to the surprise monetary tightening, this spread exhibits a statistically significant decline of several basis points. The decline in the spread is inconsistent with theory, which would suggest if anything just the opposite. More likely, there is a problem with the identifying restrictions. It appears the central bank is responding at least in part to the information contained in the excess bond premium. The below trend value of the premium is consistent with a strong economy, which induces the central bank to tighten. The resulting output and price puzzles are consistent with this interpretation. Accordingly, the restriction that the central bank does not respond to innovations in the excess bond premium either directly of indirectly (by responding to variables outside the VAR, which are correlated with the premium) does not appear to be reasonable. Conversely, it is not reasonable to assume that the excess bond premium cannot respond instantly to a monetary shock. Thus, we conclude that the conventional timing restrictions used in monetary VARs do not work well in circumstances like the one here, where both financial and real variables are present. By contrast, our external instruments approach appears well suited for this kind of environment.

# C. The Response of Credit Costs to a Monetary Surprise: Facts and Interpretation

We are now able to address the central question of the paper: namely, how credit costs respond to exogenous surprises in monetary policy. We do so by examining the

responses of various credit spreads, various government bond yields, and the federal funds rate. We then use this information to construct the response of overall credit costs for different classes of securities along with a decomposition of the movement of these costs between: variation in

- • the expected path of short rates;
- • term premia; and
- • credit spreads.

We present a sequence of VARs rather than a single one that includes all the variables. Because interest rates of varying maturity are highly correlated, including all at once would lead to a problem of multi-collinearity as well as over-parametrization. Accordingly, we begin with a baseline VAR that includes economic activity variables, a variety of credit spreads, and the one-year government bond rate, which we again take as the policy indicator. We choose this specification as our baseline because it appears reasonably robust to subsample splits and the inclusion of additional variables. We then consider a sequence of VARs which adds an additional interest rate to the baseline specification. As we show in the online Appendix, the behavior of the variables in the baseline is essentially invariant to the inclusion of the additional interest rates in the subsequent VARs. Thus, in effect, the subsequent VARs reveal the behavior of the additional interest rate, holding constant the behavior of the variables in the baseline.

We include six variables in the baseline specification: industrial production; the consumer price index; the one-year government bond rate; the excess bond premium, the mortgage spread, and the commercial paper spread. It is the extension of the model of Figure 1 with the addition of the latter two spreads. The three spread variables reflect (components of) credit costs for three significant financial markets. The excess bond premium is relevant to the cost of long term credit in the nonfarm business sector. The mortgage spread is relevant to the cost of housing finance. Finally, the three-month commercial paper spread is relevant to the cost of short term business credit, as well as the cost of financing consumer durables.

As earlier, we start with FF4 as the instrument to identify monetary policy surprises. As was the case with the simple VAR, the *F*-statistics from the first stage regressions are safely in the region where a weak instruments problem is very unlikely. We also explore other policy indicator and instrument combinations.

[Figure 2](#page-20-0) shows the responses of the variables in the baseline to a one standard deviation contractionary monetary policy surprise. The one-year rate increases roughly 20 basis points on impact and then reverts back to trend after roughly a year. There is a significant and fairly rapid drop in industrial output that begins after several months and reaches a trough after roughly 18. The CPI declines steadily, though this decline is not significant. Associated with the output decline is a significant increase, both statistically and quantitatively, in each of the credit spreads. The excess bond premium increases 8 basis points on impact and remains at that level for roughly eight months before returning to trend. The mortgage spread increases only 2 to 3 points on impact but then increases sharply to 7 points above trend after two months. Finally, the commercial paper spread increases roughly 5 basis points on

<span id="page-20-0"></span>![](_page_20_Figure_3.jpeg)

Figure 2. One-Year Rate Shock with Corporate and Mortgage Premia

impact for roughly four to five months. We discuss shortly the implications for the movements in these spreads for overall credit costs.

[Figure 3](#page-21-0) reports the responses of various market interest rates. As we discussed earlier, the responses are calculated by adding each interest rate to the baseline VAR, one at a time. For convenience, we also report the response of the one-year government bond rate from the baseline VAR. The federal funds rate increases significantly upon impact. The increase of roughly 18 points matches the rise in the two-year rate. Both interest rates revert to trend after roughly eight months. This decline is consistent with the quick and sharp contraction in industrial production, presuming the central bank typically reduces short-term rates as the economy weakens. The response of the longer maturity government bond rates is largely consistent with the HFI analysis presented in Table 1. The two-, five-, and ten-year rates increase significantly upon impact but by smaller amounts as the maturity lengthens. Interestingly, all the interest rates revert to trend after about eight months. Finally, also consistent with the HFI analysis in Table 1, the five-by-five forward does not respond significantly upon impact to the surprise tightening. This suggests that the movement in market reflects some combination of expected movements in short rates less than five years out and/or movement in term premia. We turn to this issue in a moment.

<span id="page-21-0"></span>![](_page_21_Figure_3.jpeg)

Figure 3. One-Year Rate Shock: Response of Other Interest Rates

As we discussed earlier, what matters for monetary policy transmission is the behavior of real rates. Further, HFI analysis using TIPS data suggests that virtually all the movement in nominal rates following a monetary policy surprise reflects movements in real rates, with relatively little impact on inflation[. Figure 4](#page-22-0) shows that our VAR analysis confirms this result. The left panels report the responses of both the real and nominal two-, five-, and ten-year government bonds rates to a surprise monetary tightening. The right panels report the corresponding breakeven inflation rates. The real interest rate is computed using the response of the nominal rate and expected inflation, the latter calculated from the impulse response of the price level.[14](#page-21-1) As the figure shows, real rates move with nominal rates virtually one-for-one. There is a tiny decline in breakeven inflation rates at the different horizons. The declines are marginally significant upon impact at the five- and ten-year horizons, but otherwise insignificant.

We now turn to the question of how overall credit costs respond to monetary policy and what are the factors that underlie the movement in these costs. To address this issue, [Figure 5](#page-23-0) presents a decomposition of the response of interest rates to the tight money shock. Each of the top four panels reports the response of a government bond rate along with the response of its respective term premium. We calculate the

<span id="page-21-1"></span><sup>14</sup>In particular, we use the price level responses in each corresponding seven variable VARs including the particular nominal rate (not shown). Extending the number of variables introduces minor variations in the estimated price level responses relative to the baseline 6 variable VAR presented on Figure 2, but it does not influence our qualitative conclusions.

<span id="page-22-0"></span>![](_page_22_Figure_3.jpeg)

Figure 4. One-Year Rate Shock: Response of Real Rates and Breakeven Inflation Rates

latter using equation (4), which equates the nominal rate to the sum of the term premium and the expected path of short rates. We use the impulse response of the short rate to compute the latter.

As the figure shows, for the two-year, five-year, and ten-year maturities, virtually all the rate increase is due to the term premium, with no impact of the path of expected short rates. Even for the one-year rate, most of the movement, roughly 80 percent, is due to a term premium effect. That the strong term premium effects arise is not surprising given the behavior of short rates. As we noted earlier, short rates quickly revert to trend following a tight money shock due to the weakening of the economy. It is true that the term premium effects dissipate quickly and are not statistically significant for the ten-year government bond rate. Nonetheless, they are significant on impact for the five-year rate and at least three to four months for the one- and two-year rates.

The bottom two panels of Figure 5 report a similar decomposition of the response of private credit costs, except allowing for a component due to the movement in credit spreads. In particular, each panel reports the response of the combined excess premium for each security along with the overall response of the rate. It is first worth noting that the responses of the corporate bond rates and mortgages are relatively substantial. A roughly 20 basis point increase in the one-year government bond rate leads to a roughly 15 basis point increase in the corporate bond rate and 7 basis point

<span id="page-23-0"></span>![](_page_23_Figure_3.jpeg)

Figure 5. One-Year Rate Shock: Response of Term Premia and Excess Premia

increase in the mortgage rate. In each case virtually all the movement in rates is due the excess premium, defined as the sum of the credit spread and the term premium. Again, the relatively transitory response of short rates account for the negligible impact of expected short rates on credit costs.

It is of course possible that a component of the term premium response is due to the VAR forecast of short rates not accurately mirroring true market expectations. It could be the case that following a contractionary monetary policy shock, market expectations of the path of interest rates exceed our VAR model's implied path. One possible reason for this overreaction could be that private individuals fail to anticipate the decline in short rates that accompanies the subsequent recession. In this instance, the overreaction of expectations could explain the rise in interest rates across the yield curve, with little or no movement in term premia.

We explore this issue including a survey measure of private sector expectations into our baseline VAR.[15](#page-23-1) In particular, we use the Blue Chip Economic Indicators survey, which collects expectations of key market analysts every month since 1983:3 on various interest rates over the subsequent five to six quarters. To facilitate comparison with our baseline one-year policy indicator, we create a one-year constant maturity expectation from the projected path of the federal funds rates. This rate

<span id="page-23-1"></span><sup>15</sup>Nakamura and Steinsson (2013) similarly use survey data to explore term premium effects of monetary policy shocks.

![](_page_24_Figure_3.jpeg)

Figure 6. One-Year Rate Shock: Response of Private Sector Expectations, 1979–2012

measures the average short-term interest rate over the subsequent year expected by the private sector.[16](#page-24-0) The survey does not collect interest rate expectations beyond six quarters, so to get estimates on the expected path further out, we use our VAR model. In particular, we generate estimates for future expectations by obtaining the VAR implied path of our yearly expectations measure. For average expectations over the two-year horizon, for example, we take the average of the current one-year expectation and its VAR implied level one year ahead. For the average five- and ten-year expectations, analogously, we take the current and the one to four and one to nine year ahead implied rates, respectively.

Figure 6 shows the estimated effects of the monetary policy shock on the average short-term rate expectations over one-, two-, five-, and ten-year horizons. We compare these expectations to similar averages obtained from the "riskless" federal funds rate path of our baseline VAR and to the similar maturity Treasury Bond rates. For the one- and two-year horizons, there is some evidence that market expectations overreact. Their responses exceed the corresponding VAR implied average policy rate, which lies slightly below confidence bands around the path of expectation. Though they also fall short of the corresponding Treasury rate responses, implying, even after correcting for expectations, a small term premium effect. On the other

<span id="page-24-0"></span><sup>16</sup>To obtain a yearly measure, we need implied expectations for the last months in the current quarter and the first months in the 4. quarter ahead. For the current quarter, we are using realized rates to filter out expectations for the remaining months and assume constant monthly expectations during the 4. quarter ahead.

hand, the uncertainty surrounding the estimates of the path of expectations makes it very hard to reach definitive conclusions about whether some kind of market over-reaction of beliefs (relative to the VAR prediction) could account for the response of term premia at the one- and two-year horizons. At the five- and ten-year horizons, however, market expectations measures line up closely with the implied VAR measures. This suggests that the term premia responses of the five- and ten-year rates are unlikely to be explained by an overreaction of private sector beliefs.

It is important to add that even absent a significant term premium response, our results suggest that the impact of monetary policy on credit costs is stronger than a frictionless model would predict due to sizable effects in credit spreads. We note also that borrowers cannot escape these effects on excess premia for longer term credit by switching to short term since the spread for short-term securities (the commercial spread) increases as well, as Figure 4 shows.

We next turn to the issue of the role of forward guidance. A conceptually nice way to assess the importance of forward guidance would be to follow GSS by isolating the component of the instrument set that reflects surprises in future rates that are orthogonal to surprises in the current rate. This component, which GSS refer to as the "path" factor then in principle captures the effect of pure shocks to forward guidance. The residual component which GSS refer to as the "target factor" captures shocks associated with movement in the current target rate. Unfortunately, this decomposition between target and path factors leads to instruments that are too weak in the context of our external instruments setup to credibly identify pure surprises to forward guidance.

Accordingly, to get a sense of the importance of forward guidance, we opt for the following indirect approach: We replace the one-year government bond rate with the federal funds rate in our baseline VAR. We also replace the three month ahead futures rate surprises with the contemporaneous surprise in fed fund futures. Roughly speaking, the funds rate instrumented by FF1 is likely to capture less persistent variation in short-term rates than is the one-year rate instrumented by FF4. The results from the HFI analysis in Table 1 are consistent with this interpretation: the one-year rate instrumented by FF4 has a stronger effect on longer term interest rates than does the funds rate instrumented by FF1. This suggests the latter may incorporate a greater degree of forward guidance than the former.

Figure 7 reports the response of the system to a tight money shock in the case with the funds rate as the policy indicator. For comparison, we also report the response of our baseline VAR with the one-year rate as the policy indicator. We normalize the size of the shock so that the response of the funds rate is quantitatively the same as in the baseline case. Overall, the pure funds rate shock has weaker impact on both economic and financial variables than in the case where the innovation in the one-year rate (instrumented by FF4) incorporates the policy surprise. The contraction in output is more than 50 percent smaller and the fall in the CPI is similarly smaller relative to the baseline. In each case, further, the response of the variable in the baseline lies below the 95 percent confidence interval for the funds rate shock. In addition the response of credit spreads and long term interest rates is significantly weaker in response to the funds rate shock relative to the baseline one-year rate shock. Overall, the results are consistent with the impact of the monetary policy surprise increasing

<span id="page-26-0"></span>![](_page_26_Figure_3.jpeg)

F: 25.16; Robust F: 14.04;  $R^2$ : 8.95 percent; Adjusted  $R^2$ : 8.59 percent

FIGURE 7. FORWARD GUIDANCE: FEDERAL FUNDS VERSUS ONE-YEAR RATE SHOCK

in the relative degree of forward guidance that underlies the shock (holding constant the change in the current funds rate).<sup>17</sup>

We conclude with three robustness exercises. First, we replace the one-year rate as the policy indicator, with the two-year rate instrumented by the full GSS set of futures rate surprises. As we noted earlier, the latter is our conceptually preferred policy indicator/instrument variables combination. While concern over weak instruments kept us from using this combination in the baseline VAR, it is useful to assess its performance relative to the baseline. Figure 8 reports the impulse responses of the main variables in our baseline framework for this case. We normalize the two-year

<span id="page-26-1"></span><sup>&</sup>lt;sup>17</sup>Our results are robust to restricting the identification sample to the precrisis period (1991:1-2008:6). This dissolves potential concerns that by using the three month futures surprise (FF4) as instrument, we implicitly overweigh the postcrisis sample, when these rates can be expected to exhibit excess volatility over the current month futures surprises (FF1) as a result of more prevalent forward guidance shocks. In particular, high frequency responses reported in Table 1 are robust to excluding the postcrisis period from the sample. Furthermore, qualitative conclusions drawn from Figure 7 remain intact if we restrict the sample used for identification to the precrisis period. Results are available from the authors upon request.

<span id="page-27-0"></span>![](_page_27_Figure_3.jpeg)

Figure 8. Two-Year Rate Shock with a Full Set of GSS Instruments

rate shock so that it produces the same movement in the one-year rate as does the shock in the baseline case. Overall, despite the potential weak instruments problem, the two-year rate shock produces responses of the economic variables that are very similar to the baseline. If anything, the two-year rate shock has a slightly stronger effect, though the differences are not significantly different. The stronger effects are consistent with the two-year rate shock having a greater degree of forward guidance, as confirmed by the HFI analysis in Table 2.

Next, we show that our results are not dependent on including the crisis period in the sample. [Figure 9](#page-28-0) repeats the baseline exercise with a sample that is truncated at 2008:6. As the figure shows, a surprise monetary tightening produces responses of the economic and financial variables that are very similar to the baseline. The drop in output is a bit smaller relative to the baseline, though it remains statistically significant.[18](#page-27-1)

<span id="page-27-1"></span><sup>18</sup>Including a zero restriction on the contemporaneous output response enhances the decline.

<span id="page-28-0"></span>![](_page_28_Figure_3.jpeg)

Figure 9. One-Year Rate Shock, 1979–2008

Finally, we address the issue of whether our measure of monetary policy surprises is truly exogenous. Romer and Romer (2000) have argued that news on FOMC dates could reflect the Fed's superior ability to forecast economic activity, as opposed to orthogonal policy surprises. To support this contention, they show that Federal Reserve "Greenbook" forecasts consistently outperform private sector forecasts. We address this issue in two ways. First, following Barakchian and Crowe (2013) we construct a measure of the Fed's "private information" by taking the difference between the Greenbook forecast and the private sector forecast of the same economic activity variable, where we use the Blue Chip Economic Indicators Survey to measure the latter. Then we regress our measure of monetary policy surprises on this private information measure to determine the variation in the former explained by the latter. Second, we then use the residuals from this regression to construct a new measure of policy surprises that eliminates the component that may be due to the Fed's private information. We then repeat the VAR analysis using this "purified" measure of policy surprises. We note that the Greenbook data is only available through 2007 and only for scheduled FOMC dates. We thus limit the sample used for the identification of monetary policy shock accordingly.

| Variables                                    | FF1<br>(1)                      | FF4<br>(2)                      | ED4 (3)                         |  |
|----------------------------------------------|---------------------------------|---------------------------------|---------------------------------|--|
| $\pi$                                        | 0.0227**<br>(2.161)             | 0.0145**<br>(2.109)             | 0.0152<br>(1.611)               |  |
| dy                                           | 0.0166*<br>(1.724)              | 0.0209***<br>(3.077)            | 0.0256***<br>(3.072)            |  |
| $\Delta\pi$                                  | -0.0289** (-2.387)              | $-0.0178* \ (-1.925)$           | -0.0185 $(-1.528)$              |  |
| $\Delta dy$                                  | $-0.00663 \ (-1.309)$           | $-0.00755* \\ (-1.881)$         | -0.00627 $(-1.033)$             |  |
| Observations $R^2$<br>F-statistic prob $> F$ | 141<br>0.108<br>2.175<br>0.0751 | 141<br>0.155<br>3.243<br>0.0141 | 141<br>0.135<br>3.368<br>0.0116 |  |

Table 4—Effects of Private Information on Tight Window Monetary Policy Surprise (1991–2007)

*Note:* Robust *t*-statistics in parentheses.

Table 4 reports the results from regressions of surprises in interest rate futures on measures of the Fed's private information. The three dependent variables we consider are the surprises (on FOMC dates) in: the current month's fed funds future rate (FF1); the three month ahead fed funds future rate FF4; and the year ahead three month Eurodollar rate (ED4). The four independent variables include the Fed's private information for current inflation  $\pi$ , for current output growth dy, and for the change in each of these variables from the previous meeting,  $\Delta \pi$  and  $\Delta dy$ . In each case, the private information variables are statistically significant but explain only a small fraction of the variation in the policy surprise. In particular, the private information variables account for only 15 percent of the surprise variation in our baseline instrument FF4 and slightly less of the surprise variation in the other instruments. Thus, we conclude that the Fed's private information cannot account for the overall variation in our policy surprises measures.

We next turn to the VAR analysis. We first "clean" our measure of policy surprises of the Fed's private measure by using the residuals from the regression for FF4 in Table 4 as our new instrument. In principle, these residuals capture variation in the surprise in FF4 on FOMC dates that is orthogonal to the Fed's private information. Figure 10 then reports the effect of a surprise monetary tightening using the "purified" measure of policy shocks. As one might expect, the effect of the surprise tightening is stronger than in the baseline: the fall in output and inflation is larger and the increases in spreads is greater. For example, private information that the economy is stronger than the public expects is likely to cause the Fed to raise rates more than expected, leading to procyclical movement in output and the policy indicator. By cleaning off the private information, it is possible to isolate the contractionary

<sup>\*\*\*</sup>Significant at the 1 percent level.

<sup>\*\*</sup>Significant at the 5 percent level.

<sup>\*</sup>Significant at the 10 percent level.

<span id="page-29-0"></span><sup>&</sup>lt;sup>19</sup> Adding additional lags of these variables does not improve predictability.

<span id="page-30-0"></span>![](_page_30_Figure_3.jpeg)

Figure 10. One-Year Rate Shock with Instruments without the Fed's Private Information, 1979–2012

effects of the policy tightening. A caveat, however, having to limit the sample due to the availability of the Greenbook forecast data implies that in contrast to our baseline case we cannot confidently rule out a problem of weak instruments[.20](#page-30-1)

## **IV. Conclusion**

Conventional VAR analysis of monetary shocks typically finds that relatively modest and transitory increases in short-term interest rates lead to significant contractions in output. We reexamine this issue using an external instruments identification approach borrowing insights from the high frequency identification literature of Kuttner (2001) and Gürkaynak, Sack, and Swanson (2005). The approach facilitates analyzing the joint response of financial and real variables to monetary

<span id="page-30-1"></span><sup>20</sup>The large effects of the cleaned surprise measure is partly coming from our method of shock normalization. In particular, we normalize the impulse responses to reflect similar effects on the monetary policy indicator variable in the first three months. The cleaned surprise measure implies significantly smaller effects on the monetary policy indicator, and only slightly larger effects on prices, economic activity, and premia. As the normalization increases the monetary policy shock size, these responses also get amplified.

policy shocks and also allows for incorporating innovations in forward guidance into the measure of the shock. A key finding is that there is an enhanced movement in credit costs from the policy shock due to the response of term premia and credit costs. The response of credit costs is thus significantly larger than inspection of the short-rate response alone would suggest. These kinds of phenomena are absent in standard models of monetary policy transmission.

Overall, our results suggest a need to incorporate term premium and credit spread effects in the modeling of monetary policy transmission. One example of this approach, is Gertler and Karadi (2013) who extend a conventional sticky price monetary DSGE model to allow for limited participation in financial markets and limits to arbitrage. Within this framework a monetary tightening can produce increase in both term premia and credit spreads broadly consistent with the evidence in this paper. A byproduct of limited participation/limited arbitrage is that asset supplies affect asset prices, opening up a role for quantitative easing. There are other approaches as well worth pursuing.

## REFERENCES

**Bagliano, Fabio C., and Carlo A. Favero.** 1999. "Information from financial markets and VAR measures of monetary policy." *European Economic Review* 43 (4–6): 825–37.

**Barakchian, S. Mahdi, and Christopher Crowe.** 2013. "Monetary policy matters: Evidence from new shocks data." *Journal of Monetary Economics* 60 (8): 950–66.

**Bernanke, Ben S., and Alan S. Blinder.** 1992. "The Federal Funds Rate and the Channels of Monetary Transmission." *American Economic Review* 82 (4): 901–21.

**Bernanke, Ben S., and Mark Gertler.** 1995. "Inside the Black Box: The Credit Channel of Monetary Policy Transmission." *Journal of Economic Perspectives* 90 (4): 27–48.

**Bernanke, Ben S., Mark Gertler, and Simon Gilchrist.** 1999. "The Financial Accelerator in a Quantitative Business Cycle Framework." In *Handbook of Macroeconomics,* Vol. 1, edited by J. B. Taylor and M. Woodford, 1341–93. Amsterdam: North Holland.

**Bernanke, Ben S., Vincent R. Reinhart, and Brian P. Sack.** 2004. "Monetary Policy Alternatives at the Zero Bound: An Empirical Assessment." *Brookings Papers on Economic Activity* 34 (2): 1–100.

**Boivin, Jean, Michael T. Kiley, and Frederic S. Mishkin.** 2010. "How has the monetary transmission mechanism evolved over time?" In *Handbook of Monetary Economics,* Vol. 3, edited by Benjamin M. Friedman and Michael Woodford, 369–422. Amsterdam: North Holland.

**Brunnermeier, Markus K., and Yuliy Sannikov.** 2011. "The I theory of money." [http://scholar.prince](http://scholar.princeton.edu/sites/default/files/i_theory_0.pdf)[ton.edu/sites/default/files/i\\_theory\\_0.pdf.](http://scholar.princeton.edu/sites/default/files/i_theory_0.pdf)

**Campbell, Jeffrey R., Charles L. Evans, Jonas D. M. Fisher, Alejandro Justiniano.** 2012. "Macroeconomic effects of federal reserve forward guidance." *Brookings Papers on Economic Activity* 42 (1): 1–80.

**Christiano, Lawrence J., Martin Eichenbaum, and Charles L. Evans.** 1996. "The Effects of Monetary Policy Shocks: Evidence from the Flow of Funds." *Review of Economics and Statistics* 78 (1): 16–34.

**Christiano, Lawrence J., Martin Eichenbaum, and Charles L. Evans.** 2005. "Nominal rigidities and the dynamic effects of a shock to monetary policy." *Journal of Political Economy* 113 (1): 1–45.

**Christiano, Lawrence J., Roberto Motto, and Massimo Rostagno.** 2014. "Risk Shocks." *American Economic Review* 104 (1): 27–65.

**Clarida, Richard, Jordi Galí, and Mark Gertler.** 2000. "Monetary policy rules and macroeconomic stability: Evidence and some theory." *Quarterly Journal of Economics* 115 (1): 147–80.

**Cochrane, John H., and Monika Piazzesi.** 2002. "The Fed and Interest Rates—A High-Frequency Identification." *American Economic Review* 92 (2): 90–95.

**Drechsler, Itamar, Alexi Savov, and Philipp Schnabl.** 2014. "A Model of Monetary Policy and Risk Premia." National Bureau of Economic Research (NBER) Working Paper 20141.

**Faust, Jon, Eric T. Swanson, and Jonathan H. Wright.** 2004. "Identifying VARs based on high frequency futures data." *Journal of Monetary Economics* 51 (6): 1107–31.

**Gertler, Mark, and Peter Karadi.** 2011. "A model of unconventional monetary policy." *Journal of Monetary Economics* 58 (1): 17–34.

- **Gertler, Mark, and Peter Karadi.** 2013. "QE 1 vs. 2 vs. 3...: A Framework for Analyzing Large-Scale Asset Purchases as a Monetary Policy Tool." *International Journal of Central Banking* 90 (1): 5–53.
- **Gertler, Mark, and Peter Karadi.** 2015. "Monetary Policy Surprises, Credit Costs, and Economic Activity: Dataset." *American Economic Journal: Macroeconomics*. [http://dx.doi.org/10.1257/](http://dx.doi.org/10.1257/mac.20130329) [mac.20130329](http://dx.doi.org/10.1257/mac.20130329).
- **Gilchrist, Simon, and Egon Zakrajšek.** 2012. "Credit spreads and business cycle fluctuations." *American Economic Review* 102 (4): 1692–1720.
- **Gürkaynak, Refet S., Brian Sack, and Eric T. Swanson.** 2005. "Do Actions Speak Louder than Words? The Response of Asset Prices to Monetary Policy Actions and Statements." *International Journal of Central Banking* 1 (1): 55–93.
- **Gürkaynak, Refet S., Brian Sack, and Jonathan H. Wright.** 2007. "The U.S. Treasury yield curve: 1961 to the present." *Journal of Monetary Economics* 54 (8): 2291–2304.
- **Gürkaynak, Refet S., Brian Sack, and Jonathan H. Wright.** 2010. "The TIPS Yield Curve and Inflation Compensation." *American Economic Journal: Macroeconomics* 2 (1): 70–92.
- **Hamilton, James D.** 2008. "Daily monetary policy shocks and new home sales." *Journal of Monetary Economics* 55 (7): 1171–90.
- **Hamilton, James D.** 2009. "Daily Changes in Fed Funds Futures Prices." *Journal of Money, Credit and Banking* 41 (4): 567–82.
- **Hanson, Samuel G., and Jeremy C. Stein.** 2012. "Monetary policy and long-term real rates." Finance and Economics Discussion Series (FEDS) Discussion Paper 2012–46.
- **Kuttner, Kenneth N.** 2001. "Monetary policy surprises and interest rates: Evidence from the Fed funds futures market." *Journal of Monetary Economics* 47 (3): 523–44.
- **Mertens, Karel, and Morten O. Ravn.** 2013. "The Dynamic Effects of Personal and Corporate Income Tax Changes in the United States." *American Economic Review* 103 (4): 1212–47.
- **Nakamura, Emi, and Jón Steinsson.** 2013. "High Frequency Identification of Monetary Non-Neutrality." National Bureau of Economic Research (NBER) Working Paper 19260.
- **Piazzesi, Monika, and Eric T. Swanson.** 2008. "Futures prices as risk-adjusted forecasts of monetary policy." *Journal of Monetary Economics* 550 (4): 677–91.
- **Romer, Christina D., and David H. Romer.** 2000. "Federal Reserve Information and the Behavior of Interest Rates." *American Economic Review* 90 (3): 429–57.
- **Romer, Christina D. and David H. Romer.** 2004. "A New Measure of Monetary Shocks: Derivation and Implications." *American Economic Review* 94 (3): 1055–84.
- **Rudebusch, Glenn D.** 1998. "Do Measures of Monetary Policy in a VAR Make Sense?" *International Economic Review* 39 (4): 907–31.
- **Smets, Frank, and Rafael Wouters.** 2007. "Shocks and Frictions in US Business Cycles: A Bayesian DSGE Approach." *American Economic Review* 970 (3): 586–606.
- **Stock, James H., and Mark W. Watson.** 2012. "Disentangling the channels of the 2007–09 recession." *Brookings Papers on Economic Activity* 42 (1): 81–135.
- **Stock, James H., Jonathan H. Wright, and Motohiro Yogo.** 2002. "A survey of weak instruments and weak identification in generalized method of moments." *Journal of Business & Economic Statistics* 20 (4): 518–29.
- **Swanson, Eric T., and John C. Williams.** 2014. "Measuring the Effect of the Zero Lower Bound on Medium–and Longer–Term Interest Rates." *American Economic Review* 104 (10): 3154–85*.*