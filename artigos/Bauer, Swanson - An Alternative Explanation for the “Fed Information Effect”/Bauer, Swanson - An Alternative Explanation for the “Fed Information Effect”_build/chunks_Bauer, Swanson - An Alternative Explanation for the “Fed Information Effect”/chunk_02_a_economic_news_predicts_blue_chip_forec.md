## A. Economic News Predicts Blue Chip Forecast Revisions

We first verify that economic news is a strong predictor of Blue Chip forecast revisions. This is not surprising, but it is nevertheless important to determine which economic data releases are particularly important for explaining Blue Chip forecast revisions in unemployment, GDP, and inflation. We run regressions of the form

(6) 
$$BCrev_t = \alpha + \beta' news_t + \varepsilon_t$$

where t indexes months containing an FOMC announcement and  $BCrev_t$  denotes the revision in the Blue Chip consensus forecast of a given variable over month t.

| TABLE 2—ECONOM | IC NEWS PREDICT | S BLUE CHIP | FORECAST REVISIONS |
|----------------|-----------------|-------------|--------------------|
|                |                 |             |                    |

| Blue Chip forecast revision:                      | Unemployment rate (1) | Real GDP growth (2) | CPI inflation (3) |
|---------------------------------------------------|-----------------------|---------------------|-------------------|
| Macroeconomic news                                |                       |                     |                   |
| Unemployment surprise                             | 0.308<br>(0.037)      | -0.010 (0.074)      | 0.027 $(0.045)$   |
| Payrolls surprise                                 | -0.121 (0.056)        | -0.100 $(0.110)$    | -0.127 (0.067)    |
| GDP surprise                                      | -0.020 (0.013)        | 0.064<br>(0.026)    | 0.010<br>(0.016)  |
| BBK index                                         | -0.047 (0.008)        | 0.031<br>(0.016)    | 0.008<br>(0.010)  |
| Change in core CPI inflation from 6 mos. previous | -0.025 (0.009)        | -0.016 (0.019)      | 0.032<br>(0.011)  |
| Expectation of core CPI release                   | 0.157<br>(0.098)      | -0.361 (0.196)      | 0.200<br>(0.119)  |
| Core CPI surprise                                 | 0.097<br>(0.071)      | -0.187<br>(0.140)   | 0.209<br>(0.085)  |
| Financial news                                    |                       |                     |                   |
| $\Delta \log$ S&P500                              | -0.212 (0.085)        | 0.620<br>(0.167)    | 0.009<br>(0.102)  |
| $\Delta$ yield curve slope                        | -0.023 (0.011)        | -0.012 (0.022)      | 0.013<br>(0.014)  |
| $\Delta$ log pcommodity                           | -0.111<br>(0.104)     | 0.145<br>(0.206)    | 0.429<br>(0.126)  |
| $R^2$                                             | 0.64                  | 0.40                | 0.31              |

Notes: Estimated coefficients  $\beta$  and  $R^2$  from regressions  $BCrev_t = \alpha + \beta'news_t + \varepsilon_t$ , where t indexes months,  $BCrev_t$  denotes the one-month change in the Blue Chip consensus forecast for the next three quarters for the variable listed in each column, and  $news_t$  contains the measures of economic news listed in each row. The surprise in a macroeoconomic data release is the released value minus the market expectation of that release from just a few days prior. The BBK index summarizes all major macroeconomic data releases that month and is from Brave et al. (2019). Sample: all months containing an FOMC announcement from 1/1990 to 6/2019 (N=217 observations). Each regression also includes a constant, time trend, and the previous month's Blue Chip forecast revisions; coefficients for those variables (and results for alternative estimation samples) are reported in online Appendix B. Bootstrapped standard errors in parentheses. See notes to Table 1 and text for details.

While one can also perform regression (6) on a sample including all months (which produces essentially identical results), we focus here on revisions around FOMC announcements because that is the sample in regressions (2) and (3), which have the omitted variable problem.

Results are reported in Table 2 for our full sample, January 1990 to June 2019 (results for other samples are very similar and are provided in online Appendix B). The table reports results for Blue Chip forecast revisions in the unemployment rate in the first column, real GDP growth in the second column, and the CPI inflation rate in the third column. The parsimonious set of macroeconomic data releases, lagged macroeconomic variables (an example of "old news"), and financial market news in the table balances the simplicity of a relatively small set of predictors against the need to have good explanatory power for the Blue Chip forecast revisions. Each regression also includes a constant, a time trend (which is important for inflation), and one lag of the Blue Chip forecast revisions for unemployment, GDP, and inflation, as suggested by the evidence in Coibion and Gorodnichenko (2012, 2015); these coefficients are not reported in Table 2 in the interest of space and simplicity,

but are provided in online Appendix B. Bootstrapped standard errors using 50,000 bootstrap replications are reported in parentheses beneath each coefficient estimate.

For macroeconomic data releases, we include the surprise component of the unemployment rate and nonfarm payrolls releases from the beginning of month t, the surprise component of the GDP release from the end of month t-1, and the surprise component of the core CPI release from the second week of month t. 17 Note that the data releases for unemployment, nonfarm payrolls, and inflation in month t are for the values of those variables in month t-1, while data for GDP pertains to the previous quarter. The surprise component of each release is calculated as the actual value of the data release minus the market expectation just prior to the release, as measured by the Money Market Services survey of market participants. 18 We only include a given release in the regression if it predates the FOMC monetary policy announcement that month, as in Figure 2, although our results are not sensitive to this restriction. 19 Data for GDP is released at the end of month t-1, so it is an example of "old economic news" in Figure 2, but consistent with Coibion and Gorodnichenko (2012, 2015), it is nevertheless an important explanatory variable for Blue Chip forecast revisions, especially for GDP. We also include a more comprehensive measure of economic news released in month t, the "big data" business cycle indicator of Brave, Butters, and Kelley (2019, henceforth, BBK), which incorporates the information from all of the major macroeconomic data releases each month to come up with a single index of economic activity.<sup>20</sup>

For lagged macroeconomic indicators, we include two measures of inflation: the market expectation of the upcoming core CPI inflation release, as measured by the Money Market Services survey, and the change in the most recent six-month core CPI inflation rate from the same rate six months earlier—i.e.,  $\left(\left(\log \text{CPIX}_{t-2} - \log \text{CPIX}_{t-8}\right) - \left(\log \text{CPIX}_{t-8} - \log \text{CPIX}_{t-14}\right)\right) * 200$ .

For financial market news, we include the change in the natural log of the S&P500 stock price index, the change in the yield curve slope (in percentage points), and the change in the natural log of an index of commodity prices, all measured from 13 weeks before the FOMC announcement to the day before the FOMC announcement.<sup>21</sup> The 13-week window for these changes predates the beginning of

<sup>&</sup>lt;sup>17</sup>The unemployment rate is in percentage points, the core CPI inflation rate is the percentage point change from the previous month, GDP is the annualized percentage point change in real GDP from the previous quarter, and nonfarm payrolls is the change in employment from the previous month in thousands of workers (which we divide by 1,000 to put on a similar scale to the other variables). Interestingly, news about the core CPI is a much better predictor of Blue Chip CPI inflation forecast revisions than news about headline CPI, despite the fact that the Blue Chip forecast is for headline CPI inflation.

<sup>&</sup>lt;sup>18</sup> See Andersen and Bollerslev (1998) and Gürkaynak, Sack, and Swanson (2005a) for additional discussion and details regarding the Money Market Services expectations data.

<sup>&</sup>lt;sup>19</sup> If there are multiple FOMC announcements in a given month, then we require all macroeconomic and financial news variables to be known as of the date of the first announcement in that month.

 $<sup>^{20}</sup>$  We use the BBK index for month t-1, which is computed using data released in month t and is reported by the Chicago Fed at the beginning of month t+1. Thus, some of the macroeconomic data releases underlying the BBK index will typically post-date the FOMC announcement in month t; this is not a problem in regression (6), but a Fed information effect could manifest itself in our regressions involving FOMC monetary policy surprises through the BBK index if FOMC announcements reveal information about upcoming macroeconomic data releases later in month t. All of our results below, however, are robust to the exclusion of the BBK index.

<sup>&</sup>lt;sup>21</sup> The yield curve slope is the 10-year constant-maturity Treasury yield minus the 3-month constant-maturity Treasury yield. The change in the log commodity price index is the change in the log Bloomberg total commodity price index BCOM minus 0.4 times the change in the log Bloomberg agricultural commodity price index BCOMAG. (When these two commodity price indexes are entered into the Blue Chip CPI forecast regression

month t, so it includes old economic news as well as a component that post-dates the Blue Chip forecast (see Figure 2); in the interest of space and simplicity, we do not separate out these two components in Table 2, but both components are typically significant when the total is and they are reported separately in online Appendix B.

The results in Table 2 confirm that these measures of economic news are powerful predictors of monthly Blue Chip forecast revisions. The  $R^2$  values range from 31 percent to 64 percent. The coefficients in the table generally have the expected signs and many of them are highly statistically significant: for example, a one percentage point surprise increase in the unemployment rate leads to an upward revision in the Blue Chip forecast for unemployment over the next three quarters of about 0.3 percentage points; a one percentage point surprise increase in real GDP leads to an upward revision in the GDP forecast of about 0.06 percentage points; and a one percentage point surprise increase in core CPI inflation leads to an upward revision in the CPI inflation forecast of about 0.2 percentage points. Stock prices and commodity prices are also highly statistically significant predictors, with a ten percent increase in stock prices (commodity prices) leading to an upward revision in the Blue Chip GDP forecast (CPI inflation forecast) of about 0.06 percentage points (0.04 percentage points).

## B. Economic News Predicts Monetary Policy Surprises

We next show that economic news is correlated with the high-frequency monetary policy surprises in regressions (2) and (3). We run regressions of the form

(7) 
$$mps_t = \alpha + \beta' news_t + \varepsilon_t,$$

where t indexes FOMC announcements,  $mps_t$  is a high-frequency measure of the monetary policy surprise in a narrow window of time around the FOMC announcement (either the target factor, the path factor, or the NS surprise), and  $news_t$  denotes the vector of economic news measures described above.

Table 3 reports results from this regression for our full sample, January 1990 to June 2019 (results for other samples are very similar and are provided in online Appendix B). Results for the target factor are reported in the first column, the path factor in the second column, and the NS surprise in the third column. Bootstrapped standard errors using 50,000 bootstrap replications are reported in parentheses beneath each coefficient estimate.

Many coefficients in Table 3 are statistically significant and the  $\mathbb{R}^2$  range from 12 to 20 percent. The stock market and commodity prices are especially strong predictors of upcoming monetary policy surprises, while the yield curve slope, nonfarm payrolls release, and GDP release are also important. The signs of these coefficients are intuitive: economic news about higher output or inflation predicts tighter monetary policy. The monetary policy surprises are measured in percentage points,

separately, both are highly statistically significant with a coefficient ratio of about -0.4, suggesting the composite index defined here.)

 $<sup>^{22}</sup>$ This response to GDP surprises may seem small, but recall that the GDP release is old news and many Blue Chip forecasters likely have already incorporated it into their forecasts by the beginning of month t.

<sup>&</sup>lt;sup>23</sup> For the yield curve slope, a lower 3-month Treasury yield predicts a subsequent monetary policy easing.

Core CPI surprise

Financial news

 $R^2$ 

 $\Delta \log \text{S\&P500}$ 

 $\Delta$  yield curve slope

 $\Delta$  log pcommodity

<span id="page-17-0"></span>Target Monetary policy surprise: Path NS surprise (1) (2)(3) Macroeconomic news Unemployment surprise -0.010-0.020-0.013(0.044)(0.029)(0.023)Payrolls surprise 0.125 0.018 0.070 (0.067)(0.045)(0.036)GDP surprise 0.003 0.015 0.008 (0.016)(0.011)(0.009)BBK index 0.003 0.0000.001 (0.008)(0.006)(0.005)Change in core CPI inflation 0.004 0.009 0.006 from 6 mos. previous (0.011)(0.008)(0.006)Expectation of core CPI release -0.1240.081 -0.029

(0.101)

0.042

(0.081)

0.155

(0.095)

-0.022

(0.013)

0.076

(0.107)

0.12

(0.069)

0.079

(0.055)

0.150

(0.064)

(0.009)

0.171

(0.072)

0.15

-0.011

(0.054)

0.054

(0.044)

0.141

(0.052)

-0.015

(0.007)

0.110

(0.058)

0.20

TABLE 3—ECONOMIC NEWS PREDICTS HIGH-FREQUENCY MONETARY POLICY SURPRISES

*Notes:* Estimated coefficients  $\beta$  and  $R^2$  from regressions  $mps_t = \alpha + \beta'news_t + \varepsilon_t$ , where t indexes months,  $mps_t$  denotes the 30-minute window measure of the monetary policy surprise listed in each column, and  $news_t$  contains the measures of economic news listed in each row. Sample: all months containing an FOMC announcement from 1/1990 to 6/2019 (N=217 observations); results for other samples are very similar and are provided in online Appendix B. Bootstrapped standard errors in parentheses. See notes to Tables 1 and 2 and text for details.

so a one percentage point upward surprise in GDP predicts a roughly 1.5 basis point surprise tightening in the path factor, while a ten percent increase in the stock market predicts a roughly 1.5 basis point surprise tightening in each of the three columns. This predictability of monetary policy surprises echoes similar findings by Miranda-Agrippino (2017); Cieslak (2018); Karnaukh and Vokata (2022), and Sastry (2021) (although those authors do not consider the omitted variables problem that we are studying in this section).

The predictability in Table 3 is much more surprising than that in Table 2, because the high-frequency monetary policy surprises all post-date the economic news in the table. Under the standard assumption of Full Information Rational Expectations (FIRE), financial markets should incorporate all publicly available information up to the time that trades take place. With FIRE, the only reason that high-frequency monetary policy surprises—that is, interest rate changes—could be predictable is if risk premia are time-varying, which Miranda-Agrippino (2017) argues is the case for results like those in Table 3. However, Piazzesi and Swanson (2008) and Schmeling et al. (2021) estimate that risk premia in these short-term interest rate futures and monetary policy surprises are small, while Cieslak (2018) argues that they would have to be implausibly large to explain the estimated degree of predictability in the

data and that a risk premium interpretation is inconsistent with a variety of other financial market evidence.

Instead, we view a more plausible explanation as being that financial market participants did not satisfy the FIRE assumption. In particular, Cieslak (2018) and Schmeling et al. (2021) provide extensive evidence that financial markets did not have full information about the Fed's monetary policy reaction function and in fact underestimated ex ante how responsive the Fed would be to the economy. This would lead to ex post predictability of monetary policy surprises as seen in Table 3, even if those surprises were unpredictable ex ante, as we show in detail in the simple model of Section V, below.

We also provide direct evidence of violations of FIRE in online Appendix C that is consistent with the view that market participants underestimated the responsiveness of the Fed to the economy. We use survey forecast errors for the federal funds rate from the Blue Chip Financial Forecasts survey. Under FIRE, these survey forecast errors should be unpredictable with information observed at the time the forecast is made. Instead, we find that they are strongly predictable using the same right-hand-side variables as in Table 3, with  $R^2$  above 20 percent for all forecast horizons. These results complement and extend the evidence in Cieslak (2018) and Schmeling et al. (2021), and suggest that deviations from FIRE are quantitatively important for the monetary policy surprise predictability in Table 3.

However, regardless of the reason, the crucial point for our analysis in this section is that the high-frequency monetary policy surprises in the Fed information effect regressions (2) and (3) are correlated with the omitted economic news variables, which leads to an omitted variables bias in those regressions.
