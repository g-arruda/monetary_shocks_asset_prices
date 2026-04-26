## 5.2 Factor-Augmented Vector Autoregressions

Originally developed by Bernanke et al. (2005), FAVARs model some of the factors as observed variables while the remaining factors are unobserved. The FAVAR thus imposes restrictions on the DFM, specifically, that one or more of the factors is measured without error by one or more of the observable variables. Accordingly, SVAR identification methods with the unit effect normalization carry over directly to FAVARs.

The FAVAR model can be represented in two ways. The first is as a DFM with parametric restrictions imposed. For simplicity, consider the case of a single observed factor  $\widetilde{F}_t$  which is measured without error by the variable  $Y_t$ , r unobserved factors  $F_t$ , and order the variable observing  $\widetilde{F}_t$  first. Then the structural FAVAR model is,

$$\begin{pmatrix} Y_t \\ X_t \end{pmatrix} = \begin{pmatrix} 1 & 0_{1 \times r} \\ \Lambda \end{pmatrix} \begin{pmatrix} \widetilde{F}_t \\ F_t \end{pmatrix} + \begin{pmatrix} 0 \\ u_t \end{pmatrix}, \tag{62}$$

$$F_t^+ = \Phi(L)F_{t-1}^+ + G\eta_t \text{ where } F_t^+ = \begin{pmatrix} \widetilde{F}_t \\ F_t \end{pmatrix}, \tag{63}$$

$$\eta_t = H\varepsilon_t. \tag{64}$$

Thus, the FAVAR model combines the unit effect normalization on the factor loadings in (12) with the assumption that there is no idiosyncratic component for the variable observing  $\widetilde{F}_t$ .

The second, more common representation of the FAVAR model makes the substitution  $Y_t = \widetilde{F}_t$  (from the first line of (62)), so that  $Y_t$  is included as a factor directly:

$$X_t = \Lambda \begin{pmatrix} Y_t \\ F_t \end{pmatrix} + u_t \tag{65}$$

$$F_t^+ = \boldsymbol{\Phi}(\mathbf{L})F_{t-1}^+ + G\boldsymbol{\eta}_t, \text{ where } F_t^+ = \begin{pmatrix} Y_t \\ F_t \end{pmatrix}, \tag{66}$$

$$\eta_t = H\varepsilon_t. \tag{67}$$

With this substitution, the SDFM identification problem becomes the SVAR identification problem, where the VAR is now in terms of  $(Y_t \ F_t')$ . The factors and factor loadings can be estimated by least squares; if there are overidentifying restrictions on  $\Lambda$ , they can be imposed using restricted least squares as in Section 2.3.1<sup>aa</sup>.

As an illustration, consider Bernanke et al.'s (2005) FAVAR application of the "slow-R-fast" identification scheme for monetary policy shocks. This original FAVAR application achieves two goals. First, by including a large number of variables, it addresses

Additional details about implementing this restricted least squares approach are provided in the discussion of the empirical application in Section 7.3.

<span id="page-63-0"></span>the omitted variable problem of low-dimensional VARs and in particular aims to resolve the so-called "price puzzle" of monetary VARs (see Ramey, 2016, this Handbook). Second, the joint modeling of these many variables permits estimating internally consistent SIRFs for an arbitrarily large list of variables of interest.

In the slow-R-fast scheme, monetary policy shocks or news/financial shocks are assumed not to affect slow-moving variables like output, employment, and price indices within a period, monetary policy responds within a period to shocks to slow-moving variables but not to news or financial shocks, and fast-moving variables (like asset prices) respond to all shocks, including news/financial shocks that are reflected only in those variables. Let "s" and "f" denote slow/fast-moving variables, innovations, and shocks, order the slow-moving variables first in  $X_t$ , and (departing from the convention earlier) order the slow-moving innovations and factors first, followed by the observable factor ( $Y_t = R_t$ , the Fed funds rate), then the fast-moving factors and innovations. Then the Bernanke et al. (2005) implementation of the slow-R-fast identification scheme is,

$$\begin{pmatrix} X_t^s \\ X_t^f \end{pmatrix} = \begin{pmatrix} \Lambda_{ss} & 0 & 0 \\ \Lambda_{fs} & \Lambda_{fr} & \Lambda_{ff} \end{pmatrix} \begin{pmatrix} F_t^s \\ r_t \\ F_t^f \end{pmatrix} + e_t$$
 (68)

$$\Phi(L) \begin{pmatrix} F_t^s \\ r_t \\ F_t^f \end{pmatrix} = \begin{pmatrix} \eta_t^S \\ \eta_t^r \\ \eta_t^f \end{pmatrix}, \text{ and}$$
 (69)

$$\begin{pmatrix} \eta_t^S \\ \eta_t^r \\ \eta_t^f \end{pmatrix} = \begin{pmatrix} H_{ss} & 0 & 0 \\ H_{rs} & 1 & 0 \\ H_{fs} & H_{fr} & H_{ff} \end{pmatrix} \begin{pmatrix} \varepsilon_t^S \\ \varepsilon_t^r \\ \varepsilon_t^f \end{pmatrix}. \tag{70}$$

This scheme imposes overidentifying restrictions on  $\Lambda$  in (68), and those restrictions can be imposed by restricted principal components as in Section 2.3.1.

#### 6. A QUARTERLY 200+ VARIABLE DFM FOR THE UNITED STATES

Sections 6 and 7 illustrate the methods in the previous section using a 207-variable DFM estimated using quarterly data, primarily for the US economy. This section describes the reduced-form DFM: the number of factors, its fit, and its stability. Section 7 uses the reduced-form DFM to estimate structural DFMs that estimate the effect of oil market shocks on the economy under various identification schemes.

bb For additional discussion of the slow-R-fast scheme, see Christiano et al. (1999).

# <span id="page-64-0"></span>6.1 Data and Preliminary Transformations

The data are quarterly observations on 207 time series, consisting of real activity variables, prices, productivity and earnings, interest rates and spreads, money and credit, asset and wealth variables, oil market variables, and variables representing international activity. The series are listed by category in Table 1, and a full list is given in the Data Appendix. Data originally available monthly were converted to quarterly by temporal averaging. Real activity variables and several other variables are seasonally adjusted. The dataset updates and extends the dataset used in [Stock and Watson \(2012a\)](#page-109-0); the main extension is that the dataset used here includes [Kilian's \(2009\)](#page-107-0) international activity measure and data on oil market, which are used in the analysis in the next section of the effects of oil market shocks on the economy. The full span of the dataset is 1959Q1-2014Q4. Only 145 of the 207 series are available for this full period.

From this full dataset, a subset was formed using the 86 real activity variables in the first four categories in Table 1; this dataset will be referred to as the "real activity dataset." Of the real activity variables, 75 are available over the full sample.

The dataset is described in detail in the Data Appendix.

## 6.1.1 Preliminary Transformations and Detrending

The data were subject to four preliminary transformations. First, the DFM framework summarized in [Section 2](#page-6-0) and the associated theory assumes that the variables are second-order stationary. For this reason, each series was transformed to be approximately

Table 1 Quarterly time series in the full dataset

|      | Category                                                   | Number<br>of series | Number of series used<br>for factor estimation |
|------|------------------------------------------------------------|---------------------|------------------------------------------------|
| (1)  | NIPA                                                       | 20                  | 12                                             |
| (2)  | Industrial<br>production                                   | 11                  | 7                                              |
| (3)  | Employment<br>and<br>unemployment                          | 45                  | 30                                             |
| (4)  | Orders,<br>inventories,<br>and<br>sales                    | 10                  | 9                                              |
| (5)  | Housing<br>starts<br>and<br>permits                        | 8                   | 6                                              |
| (6)  | Prices                                                     | 37                  | 24                                             |
| (7)  | Productivity<br>and<br>labor<br>earnings                   | 10                  | 5                                              |
| (8)  | Interest<br>rates                                          | 18                  | 10                                             |
| (9)  | Money<br>and<br>credit                                     | 12                  | 6                                              |
| (10) | International                                              | 9                   | 9                                              |
| (11) | Asset<br>prices,<br>wealth,<br>and<br>household<br>balance | 15                  | 10                                             |
|      | sheets                                                     |                     |                                                |
| (12) | Other                                                      | 2                   | 2                                              |
| (13) | Oil<br>market<br>variables                                 | 10                  | 9                                              |
|      | Total                                                      | 207                 | 139                                            |

Notes: The real activity dataset consists of the variables in the categories 1–4.

integrated of order zero, for example real activity variables were transformed to growth rates, interest rates were transformed to first differences, and prices were transformed to first differences of rates of inflation. The decisions about these transformations were guided by unit root tests combined with judgment, and all similar series within a category were subject to the same transformation (for example, all measures of employment were transformed to growth rates). Selected cointegrating relations were imposed by including error correction terms. Specifically, interest rate spreads are modeled as integrated of order zero.

Second, a small number of outliers were removed. Third, following [Stock and Watson](#page-109-0) [\(2012a\),](#page-109-0) the long-term mean of each series was removed using a biweight filter with bandwidth of 100 quarters. This step is nonstandard and is discussed in the next subsection. Fourth, after these transformations, the series were standardized to have unit standard deviation.

The Data Appendix provides more details on these steps, including the preliminary transformation of each series.

#### 6.1.1.1 Removing Low-Frequency Trends

Recent research has documented that there has been a long-term slowdown in the mean growth rate of GDP over the postwar period, see [Stock andWatson \(1996, 2012a\)](#page-109-0), [Council](#page-105-0) [of Economic Advisers \(2013\),](#page-105-0) and [Gordon \(2014, 2016\).](#page-106-0) Although there is debate over the cause or causes of this slowdown, it is clear that long-term demographic shifts play an important role. The entry of women into the US labor force during the 1970–90s increased the growth rate of the labor force, and thus increased the growth rate of full-employment GDP, and the aging and retirement of the workforce are now decreasing the labor force participation rate ([Aaronson et al., 2014](#page-102-0) and references therein). The net effect of these demographic shifts is a reduction in the annual growth rate of GDP due to supply side demographics of approximately one percentage point from the early 1980s to the present. This long-term slowdown is present in many NIPA aggregates and in theory could appear in long-term trends in other series as well, such as interest rates.

These long-term trends, while important in their own right, are relevant to the exercise here for reasons that are technical but nonetheless important. These trends pose two specific problems. First, if the trends are ignored and the series, say employment growth and GDP growth, are modeled as stationary, then because these persistent components are small, the empirically estimated model will be mean reverting. However, the underlying causes of the trends, such as demographics, do not suggest mean reversion. Thus ignoring these long-term trends introduces misspecification errors into forecasts and other reduced-form exercises. Second, structural analysis that aims to quantify the response of macroeconomic variables to specific shocks generally focus on shocks that have transitory effects on GDP growth, such as monetary shocks, demand shocks, or oil supply shocks. Ignoring long-term trends by modeling growth rates as mean reverting introduces specification error in the dynamics of VARs and DFMs: the reduced-form IRFs confound the responses to these transitory shocks with the slowly unfolding trends arising from other sources.

In principal one could model these long-term trends simultaneously with the other factors, for example by adopting a random walk drift term as a factor appearing in the growth rate of some series. This approach has the advantage of explicitly estimating the low-frequency trends simultaneously with the rest of the DFM, however it has the disadvantage of requiring time series models for these trends, thereby introducing the possibility of parametric specification error. Because the purpose of the DFM analysis in this and the next section—and more generally in the vast bulk of the VAR and DFM literature—is analysis and forecasting over short—to medium-horizons (say, up to 4 years), a simpler and arguably more robust approach is simply to remove the low-frequency trends and to estimate the time series model using detrended growth rates.

For these reasons, we detrend all the series prior to estimating the DFM. Although the decline in these growth rates has been persistent, neither the underlying reasons for the declines nor visual inspection of the trends (eg, as displayed in Stock and Watson, 2012a; Gordon, 2014) suggest that they follow a linear trend, so that linear detrending is not appropriate.

The specific detrending method used here follows Stock and Watson (2012a). First, the series is transformed to being approximately integrated of order zero as discussed earlier, for example employment is transformed to employment growth. Second, the trend of each transformed series (for example, employment growth) is estimated nonparametrically using a biweight low-pass filter, with a bandwidth of 100 quarters. cc

Fig. 2 compares the biweight filter to three other filters that could be used to estimate the low-frequency trend: an equal-weighted moving average filter with 40 leads and lags (ie, an 81-quarter centered moving average), the Hodrick and Prescott (1997) filter with the conventional quarterly tuning parameter (1600), and the Baxter and King (1999) lowpass bandpass filter with a passband of 200 quarters, truncated to  $\pm 100$  lags. Each of these filters is linear, so that the estimated trend is  $w(L)x_t$  where  $x_t$  is the original series (eg, employment growth) and where w(L) generically denotes the filter. Fig. 2A plots the weights of these filters in the time domain and Fig. 2B plots the spectral gain of these filters dd

As can be seen in these figures, the biweight filter is very similar to the Baxter–King lowpass filter. It is also comparable to the equal-weight moving average filter of  $\pm 40$  quarters, however the biweight filter avoids the noise induced by the sharp cutoff of the moving average filter (these higher frequency components in the moving average filter are evident in the ripples at higher frequencies in the plot of its gain in Fig. 2B). In contrast, all three of these filters focus on much lower frequencies than the Hodrick and

Tukey's biweight filter w(L) is two sided with  $w_j = c(1 - (j/B)^2)^2$  for  $|j| \le B$  and |j| = 0 otherwise, where B is the bandwidth and c is a normalization constant such that w(1) = 1.

For filter w(L), the estimated trend is  $w(L)x_t$  and the detrended series is  $x_t - w(L)x_t$ . The spectral gain of the filter w(L) is  $||w(e^{i\omega})||$ , where  $||\cdot||$  is the complex norm.

<span id="page-67-0"></span>![](_page_67_Figure_2.jpeg)

Fig. 2 Lag weights and spectral gain of trend filters. Notes: The biweight filter uses a bandwidth (truncation parameter) of 100 quarters. The bandpass filter is a 200-quarter low-pass filter truncated after 100 leads and lags [\(Baxter and King, 1999](#page-103-0)). The moving average is equal-weighted with 40 leads and lags. The [Hodrick and Prescott \(1997\)](#page-106-0) filter uses 1600 as its tuning parameter.

Prescott filter, which places most of its weight on lags of 15 quarters. The biweight filter estimates trends at multidecadal frequencies, whereas the Hodrick and Prescott trend places considerable weight on fluctuations with periods less than a decade.

The biweight filter needs to be modified for observations near the beginning and end of the sample. One approach would be to estimate a time series model for each series, use forecasts from that model to pad the series at end points, and to apply the filter to this padded series. This approach corresponds to estimating the conditional expectation of the filtered series at the endpoints, given the available data. However, doing so requires estimating a model which raises the problems discussed earlier, which our approach to trend removal aims to avoid: if the trends are ignored when the model is estimated, then the long-term forecasts revert to the mean and this mean reversion potentially introduces misspecification into the trend estimation, but alternatively specifying the trends as part of the model introduces potential parametric misspecification. Instead, the approach used here is to truncate the filter, renormalize, and apply the modified filter directly to the available data for observations within a bandwidth of the ends of the sample. ee

#### 6.1.2 Subset of Series Used to Estimate the Factors

The data consist of series at multiple levels of aggregation and as a result some of the series equal, or nearly equal, the sum of disaggregated component series. Although the aggregation identity does not hold in logarithms, in the context of the DFM, the idiosyncratic term of the logarithm of higher-level aggregates is highly correlated with the share weighted average of the idiosyncratic term of the logarithms of its disaggregated components. For this reason, when the disaggregated components series are available, the disaggregated components are used to estimate the factors but the higher-level aggregate series are not used.

For example, the dataset contains total IP, IP of final products, IP of consumer goods, and seven sectoral IP measures. The first three series are constructed from the seven sectoral IP series in the dataset, so the idiosyncratic terms of the three aggregates are collinear with those of the seven disaggregated components. Consequently, only the seven disaggregated sectoral IP series are used to estimate the factors.

The aggregates not used for estimating the factors include GDP, total consumption, total employment and, as just stated, total IP. In all, the elimination of aggregates leaves 139 series in the full dataset for estimation of the factors. For the real activity dataset, eliminating aggregates leave 58 disaggregate series for estimating the factor. Table 1 provides the number of series used to estimate the factors by category.

# 6.2 Real Activity Dataset and Single-Index Model

The first step is to determine the number of static factors in the real activity dataset. Fig. 3 shows three scree plots computed using the 58 disaggregate series in the real activity dataset: using the full dataset and using subsamples split in 1984, a commonly used estimate of the Great Moderation break date. Table 2 (panel A) summarizes statistics related to the number of factors: the marginal  $R^2$  of the factors (that is, the numerical values of the first bar in Fig. 3), the Bai and Ng (2002)  $IC_{p2}$  information criterion, and the Ahn and Horenstein (2013) eigenvalue ratio.

For example, suppose observation t is m < B periods from the end of the sample, where B is the bandwidth. Then the estimated trend at date t is  $\sum_{i=-B}^{m} w_i x_{t+i} / \sum_{i=-B}^{m} w_i$ , where  $w_i$  is the weight at lag i of the unadjusted two-sided filter.

<span id="page-69-0"></span>![](_page_69_Figure_2.jpeg)

Fig. 3 Scree plot for real activity dataset: full sample, pre-1984, and post-1984.

First consider the full-sample estimates. As seen in Fig. 3, the dominant contribution to the trace  $R^2$  of the 58 subaggregates comes from the first factor which explains fully 38.5% of the variance of the 58 series. Still, there are potentially meaningful contributions to the trace  $R^2$  by the second and possibly higher factors: the marginal  $R^2$  for the second factor over the full sample is 10.3%, for the third is 4.4%, and the total  $R^2$  for the first five is 59.4%, a large increase over the 38.5% explained by the first factor alone. This suggests at least one, but possibly more, factors in the real activity dataset. The Bai and Ng (2002)  $IC_{p2}$  criterion estimates three factors, while the Ahn–Horenstein ratio estimates one factor. Unfortunately, such ambiguity is typical, and in such cases judgment must be exercised, and that judgment depends on the purpose to which the DFM is used.

Fig. 1 (shown in Section 1) plots the four-quarter growth rate of GDP, IP, nonfarm employment, and manufacturing and trade sales along with their common components estimated using the single static factor. <sup>ff</sup> Of these, only manufacturing and trade sales were used to estimate the factors, the remaining series being aggregates for which component disaggregated series are in the dataset. Evidently, the full-sample single factor explains the variation of these series at annual through business cycle frequencies.

Fig. 4 presents estimates of the four-quarter growth in GDP and its common components computed using the full sample with 1, 3, and 5 factors (the single-factor common component also appears in Fig. 1). The common component of GDP has an  $R^2$  of 0.73 with a single factor, which increases to 0.88 for five factors. Inspection

The common component of four-quarter growth is the four-quarter growth of the common component of the series. For the *i*th series, this common component is  $\hat{\Lambda}_i(\hat{F}_t + \hat{F}_{t-1} + \hat{F}_{t-2} + \hat{F}_{t-3})$ , where  $\hat{F}_t$  and  $\hat{\Lambda}_i$  are, respectively, the principal components estimator of the factors and the *i*th row of the estimated factor loadings.

<span id="page-70-0"></span>Table 2 Statistics for estimating the number of static factors
(A) Real activity dataset (N = 58 disaggregates used for estimating factors)

| Number of static factors | Trace R <sup>2</sup> | Marginal trace R <sup>2</sup> | BN-IC <sub>p2</sub> | AH-ER |
|--------------------------|----------------------|-------------------------------|---------------------|-------|
| 1                        | 0.385                | 0.385                         | -0.398              | 3.739 |
| 2                        | 0.489                | 0.103                         | -0.493              | 2.338 |
| 3                        | 0.533                | 0.044                         | -0.494              | 1.384 |
| 4                        | 0.565                | 0.032                         | -0.475              | 1.059 |
| 5                        | 0.595                | 0.030                         | -0.458              | 1.082 |

#### (B) Full dataset (N = 139 disaggregates used for estimating factors)

| Number of static factors | Trace R <sup>2</sup> | Marginal trace R <sup>2</sup> | BN-IC <sub>p2</sub> | AH-ER |
|--------------------------|----------------------|-------------------------------|---------------------|-------|
| 1                        | 0.215                | 0.215                         | -0.183              | 2.662 |
| 2                        | 0.296                | 0.081                         | -0.233              | 1.313 |
| 3                        | 0.358                | 0.062                         | -0.266              | 1.540 |
| 4                        | 0.398                | 0.040                         | -0.271              | 1.368 |
| 5                        | 0.427                | 0.029                         | -0.262              | 1.127 |
| 6                        | 0.453                | 0.026                         | -0.249              | 1.064 |
| 7                        | 0.478                | 0.024                         | -0.235              | 1.035 |
| 8                        | 0.501                | 0.024                         | -0.223              | 1.151 |
| 9                        | 0.522                | 0.021                         | -0.205              | 1.123 |
| 10                       | 0.540                | 0.018                         | -0.185              | 1.057 |

### (C) Amenguel-Watson estimate of number of dynamic factors: BN- $IC_{pi}$ values, full dataset (N = 139)

| No. of             | Number of static factors |        |        |        |        |        |        |        |        |        |
|--------------------|--------------------------|--------|--------|--------|--------|--------|--------|--------|--------|--------|
| dynamic<br>factors | 1                        | 2      | 3      | 4      | 5      | 6      | 7      | 8      | 9      | 10     |
| 1                  | -0.098                   | -0.071 | -0.072 | -0.068 | -0.069 | -0.065 | -0.064 | -0.064 | -0.064 | -0.060 |
| 2                  |                          | -0.085 | -0.089 | -0.087 | -0.089 | -0.084 | -0.084 | -0.084 | -0.085 | -0.080 |
| 3                  |                          |        | -0.090 | -0.088 | -0.091 | -0.088 | -0.088 | -0.086 | -0.086 | -0.084 |
| 4                  |                          |        |        | -0.077 | -0.080 | -0.075 | -0.075 | -0.073 | -0.072 | -0.069 |
| 5                  |                          |        |        |        | -0.064 | -0.060 | -0.062 | -0.057 | -0.055 | -0.052 |
| 6                  |                          |        |        |        |        | -0.045 | -0.043 | -0.040 | -0.037 | -0.036 |
| 7                  |                          |        |        |        |        |        | -0.024 | -0.022 | -0.020 | -0.018 |
| 8                  |                          |        |        |        |        |        |        | -0.002 | 0.000  | 0.003  |
| 9                  |                          |        |        |        |        |        |        |        | 0.021  | 0.023  |
| 10                 |                          |        |        |        |        |        |        |        |        | 0.044  |

Notes: BN- $IC_{p2}$  denotes the Bai and Ng (2002)  $IC_{p2}$  information criterion. AH-ER denotes the Ahn and Horenstein (2013) ratio of (i+1)th to ith eigenvalues. The minimal BN- $IC_{p2}$  entry in each column, and the maximal Ahn-Horenstein ratio entry in each column, is the respective estimate of the number of factors and is shown in bold. In panel C, the BN- $IC_{p2}$  values are computed using the covariance matrix of the residuals from the regression of the variables onto lagged values of the column number of static factors, estimated by principal components.

<span id="page-71-0"></span>![](_page_71_Figure_2.jpeg)

Fig. 4 Four-quarter GDP growth (black) and its common component based on 1, 3, and 5 static factors: real activity dataset.

of the fits for all series suggests that the factors beyond the first serve mainly to explain movements in some of the disaggregate series.

In principle, there are at least three possible reasons why there might be more than one factor among these real activity series.

The first possible reason is that there could be a single dynamic factor that manifests as multiple static factors; in the terminology of [Section 2](#page-6-0), perhaps q¼1, r>1, and G in [\(7\)](#page-9-0) has fewer rows than columns. As discussed in [Section 2,](#page-6-0) it is possible to estimate the number of dynamic factors given the number of static factors, and applying the [Amengual and](#page-102-0) [Watson \(2007\)](#page-102-0) test to the real activity dataset, with three static factors, estimates that there is a single dynamic factor. That said, the contribution to the trace R<sup>2</sup> of possible additional dynamic factors remains large in an economic sense, so the estimate of a single dynamic factor is suggestive but not conclusive.

The second possible reason is that these series move in response to multiple structural shocks, and that their responses to those shocks are sufficiently different that the innovations to their common components span the space of more than one aggregated shock.

The third reason, discussed in [Section 2](#page-6-0), is that structural instability could lead to spuriously large numbers of static factors; for example, if there is a single factor in both the first and second subsamples but a large break in the factor loadings, then the full-sample PC would find two factors, one estimating the first-subsample factor (and being noise in the second subsample), the other estimating the second-subsample factor.

<span id="page-72-0"></span>The three scree plots in [Fig. 3](#page-69-0) does not, however, show evidence of such instability. The scree plots are remarkably stable over the two subsamples and in particular the trace R<sup>2</sup> of the first factor is essentially the same whether the factor is computed over the full sample (38.5%), the pre-1984 subsample (41.1%), or the post-1984 subsample (38.7%). Consistent with this stability, the [Bai and Ng \(2002\)](#page-103-0) criterion estimates two factors in the first subsample, three in the second, and three in the combined sample.

Fig. 5 provides additional evidence on this stability by plotting the four-quarter growth of the first estimated factor (the first principal component) computed over the full dataset and computed over the pre- and post-1984 subsamples. These series are nearly indistinguishable visually and the correlations between the full-sample estimate and the pre- and post-1984 estimates are high (both exceed 0.99). Thus [Figs. 3](#page-69-0)–5 point to stability of the single-factor model. We defer formal tests for stability to the analysis of the larger DFM based on the full dataset.

Taken together, these results suggest that the first estimated factor (first principal component) based on the full dataset is a good candidate for an index of quarterly real economic activity.

Of course, other variables, such as financial variables, are useful for forecasting and nowcasting real activity. Moreover, while multiple macro shocks plausibly affect the movements of these real variables, the series in the real activity dataset provide only responses to those shocks, not more direct measures, so for an analysis of structural shocks one would want to expand the dataset so that the space of factor innovations more

![](_page_72_Figure_6.jpeg)

Fig. 5 First factor, real activity dataset: full sample, 1959–84, and 1984–2014.

plausibly spans the space of structural shocks. For example, one would want to include interest rates, which are responsive to monetary policy shocks, measures of oil prices and oil production, which are responsive to oil supply shocks, and measures of inflation, which would respond to both cost and demand shocks.

## 6.3 The Full Dataset and Multiple-Factor Model

## 6.3.1 Estimating the Factors and Number of Factors

Fig. 6A is the scree plot for the full dataset with up to 10 factors, and Table 2 (panel B) reports statistics related to estimating the number of factors. The Bai and Ng (2002) criterion chooses four factors, while the Ahn–Horenstein criterion chooses one factor. Compared to the real activity dataset, the first factor explains less of the variation and the decline in higher factors is not as sharp: the marginal  $R^2$  of the fourth factor is 0.040, dropping only to 0.024 for the eighth factor. Under the assumption of anywhere between three and eight static factors, the Amengual and Watson (2007) test selects three dynamic factors (Table 2, panel C), only one less than the four static factors chosen by the Bai and Ng (2002) criterion. As is the case for the static factors, the decline in the marginal  $R^2$  for the dynamic factors is gradual so the evidence on the number of dynamic factors is not clear cut.

Table 3 presents two different measures of the importance of the factors in explaining movements in various series. The first statistic, in columns A, is the  $R^2$  of the common component for the models with 1, 4, and 8 factors; this statistic measures the variation in the series due to contemporaneous variation in the factor. According to the contemporaneous measure in columns A, the first factor explains large fractions of the variation in the growth of GDP and employment, but only small fractions of the variation in prices and financial variables. The second through fourth factors explain the variation in headline inflation, oil prices, housing starts, and some financial variables. The fifth through eighth factors explain much of the variation in labor productivity, hourly compensation, the term spread, and exchange rates. Thus, the additional factors that would be chosen by the Bai and Ng criterion explain substantial fractions of the variation in important classes of series.

Columns B of Table 3 presents a related measure: the fraction of the four quarters ahead forecast error variance due to the dynamic factors, for 1, 4, and 8 dynamic factors, computed under the assumption of eight static factors. For some series, including housing starts, the Ted spread, and stock prices, the fifth through eighth dynamic factors explain substantial fractions of their variation at the four-quarter horizon. Thus both

Use (6) and (7) to write  $X_t = \Lambda \Phi(L)^{-1} G \eta_t + e_t$ . Then the h-period ahead forecast error is  $\operatorname{var}\left(\Lambda \sum_{i=0}^{h-1} \Phi_i G \eta_{t-i}\right) + \operatorname{var}(e_t \mid e_{t-h}, e_{t-h-1}, \ldots)$ , and the fraction of the h-step forecast error variance explained by the dynamic factors is the ratio of the first term in this expression to the total. The term  $\operatorname{var}(e_t \mid e_{t-h}, e_{t-h-1}, \ldots)$  is computed using an AR(4).

<span id="page-74-0"></span>![](_page_74_Figure_2.jpeg)

Fig. 6 (A) Scree plot for full dataset: full sample, pre-1984, and post-1984. (B) Cumulative R<sup>2</sup> as a function of the number of factors, 94-variable balanced panel.

blocks of [Table 3](#page-75-0) suggest that these higher factors, both static and dynamic, capture common innovations that are important for explaining some categories of series.

The scree plot in Fig. 6A and the statistics in [Tables 2 and 3](#page-70-0) point to a relatively small number of factors—between 4 and 8 factors—describing a large amount of the variation in these series. This said, a substantial amount of the variation remains, and it is germane to ask whether that remaining variation is from idiosyncratic disturbances or whether

<span id="page-75-0"></span>Table 3 Importance of factors for selected series for various numbers of static and dynamic factors: full dataset DFM

|                                                  | A.   | R2 of<br>common<br>component     |      | B. Fraction of four<br>quarters ahead forecast<br>error variance due to<br>common component<br>Number of dynamic<br>factors<br>q<br>with<br>r58 static<br>factors |      |      |  |
|--------------------------------------------------|------|----------------------------------|------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------|------|------|--|
|                                                  |      | Number of static<br>factors<br>r |      |                                                                                                                                                                   |      |      |  |
| Series                                           | 1    | 4                                | 8    | 1                                                                                                                                                                 | 4    | 8    |  |
| Real<br>GDP                                      | 0.54 | 0.65                             | 0.81 | 0.39                                                                                                                                                              | 0.77 | 0.83 |  |
| Employment                                       | 0.84 | 0.92                             | 0.93 | 0.79                                                                                                                                                              | 0.86 | 0.90 |  |
| Housing<br>starts                                | 0.00 | 0.52                             | 0.67 | 0.49                                                                                                                                                              | 0.51 | 0.75 |  |
| Inflation<br>(PCE)                               | 0.05 | 0.51                             | 0.64 | 0.34                                                                                                                                                              | 0.66 | 0.67 |  |
| Inflation<br>(core<br>PCE)                       | 0.02 | 0.13                             | 0.17 | 0.24                                                                                                                                                              | 0.34 | 0.41 |  |
| Labor<br>productivity<br>(NFB)                   | 0.02 | 0.30                             | 0.59 | 0.12                                                                                                                                                              | 0.46 | 0.54 |  |
| Real<br>hourly<br>labor<br>compensation<br>(NFB) | 0.00 | 0.25                             | 0.70 | 0.19                                                                                                                                                              | 0.67 | 0.71 |  |
| Federal<br>funds<br>rate                         | 0.25 | 0.41                             | 0.54 | 0.52                                                                                                                                                              | 0.54 | 0.62 |  |
| Ted-spread                                       | 0.26 | 0.59                             | 0.61 | 0.18                                                                                                                                                              | 0.33 | 0.59 |  |
| year–3<br>Term<br>spread<br>(10<br>month)        | 0.00 | 0.36                             | 0.72 | 0.32                                                                                                                                                              | 0.38 | 0.63 |  |
| Exchange<br>rates                                | 0.01 | 0.22                             | 0.70 | 0.05                                                                                                                                                              | 0.60 | 0.68 |  |
| Stock<br>prices<br>(SP500)                       | 0.06 | 0.49                             | 0.73 | 0.14                                                                                                                                                              | 0.29 | 0.79 |  |
| Real<br>money<br>supply<br>(MZ)                  | 0.00 | 0.25                             | 0.34 | 0.15                                                                                                                                                              | 0.24 | 0.29 |  |
| Business<br>loans                                | 0.11 | 0.49                             | 0.51 | 0.13                                                                                                                                                              | 0.16 | 0.23 |  |
| Real<br>oil<br>prices                            | 0.04 | 0.68                             | 0.70 | 0.40                                                                                                                                                              | 0.66 | 0.71 |  |
| Oil<br>production                                | 0.09 | 0.10                             | 0.12 | 0.01                                                                                                                                                              | 0.04 | 0.12 |  |

there are small remaining correlations across series that could be the result of small, higher factors. [Fig. 6B](#page-74-0) shows the how the trace R<sup>2</sup> increases with the number of principal components, for up to 60 principal components. The key question is whether these higher factors represent common but small fluctuations or, alternatively, are simply the consequence of estimation error, idiosyncratic disturbances, or correlated survey sampling noise because multiple series are derived in part from the same survey instrument. There is a small amount of work investigating the information content in the higher factors. [De Mol et al. \(2008\)](#page-105-0) find that Bayesian shrinkage methods applied to a large number of series closely approximate principal components forecasts using a small number of factors. Similarly, [Stock](#page-110-0) [and Watson \(2012b\)](#page-110-0) use empirical Bayes methods to incorporate information in higher factors and find that for many series forecasts using this information do not improve on forecasts using a small number of factors. [Carrasco and Rossi \(forthcoming\)](#page-104-0) use shrinkage methods to examine whether the higher factors improve forecasts. [Onatski \(2009, 2010\)](#page-108-0) develops theory for factor models with many weak factors. Although the vast bulk of the literature is consistent with the interpretation that variation in macroeconomic data are associated with a small number of factors, the question of the information content of higher factors remains open and merits additional research.

The choice of the number of factors depends on the application at hand. For forecasting real activity, the sampling error associated with additional factors could outweigh their predictive contribution. In contrast, for the structural DFM analysis in [Section 7](#page-81-0) we will use eight factors because it is important that the factor innovations span the space of the structural shocks and the higher factors capture variation.

## 6.3.2 Stability

[Table 4](#page-77-0) summarizes various statistics related to the subsample stability of the four- and eight-factor models estimated on the full dataset. [Table 4](#page-77-0) (panel A) summarizes results for equation-by-equation tests of stability. The Chow test is the Wald statistic testing the hypothesis that the factor loadings are constant in a given equation, against the alternative that they have different values before and after the Great Moderation break date of 1984q4 ([Stock and Watson, 2009; Breitung and Eickmeier, 2011,](#page-109-0) [Section 3](#page-25-0)). The Quandt likelihood ratio (QLR) version allows for an unknown break date and is the maximum value of the Chow statistic (the sup-Wald statistic) for potential breaks in the central 70% of the sample, see [Breitung and Eickmeier \(2011\)](#page-104-0) for additional discussion. In both the Chow and QLR tests, the full-sample estimate of the factors is used as regressors. The table reports the fraction of the series that rejects stability at the 1%, 5%, and 10% significance levels.hh [Table 4](#page-77-0) (panel B) reports a measure of the magnitude of the break, the correlation between the common component computed over a subsample and over the full sample, where the two subsamples considered are the pre- and post-1984 periods. [Table 4](#page-77-0) (panel C) breaks down the results in [Table 4](#page-77-0) (panels A and B) by category of series.

The statistics in [Table](#page-77-0) 4 all point to a substantial amount of instability in the factor loadings. More than half the series reject stability at the 5% level for a break in 1984 in the four-factor model, and nearly two-thirds reject in the eight-factor model. As seen in [Table 4](#page-77-0) (panel C), the finding of a break in the factor loadings in 1984 is widespread across categories of series. Rejection rates are even higher for the QLR test of stability of the factor loadings.

A reasonable worry is that these rejection rates are overstated because the tests are oversized, and Monte Carlo evidence in [Breitung and Tenhofen \(2011\)](#page-104-0) suggests that the size distortions could be large if the idiosyncratic disturbances are highly serially correlated. For this reason, it is also useful to check if the instability is large in an economic sense.

One such measure of the magnitude of the instability is whether the common component estimated over a subsample is similar to the full-sample common component. As shown in [Table 4](#page-77-0) (panel B), for at least half the series, the common components estimated

hh Results are reported for the 176 of the 207 series with at least 80 quarterly observations in both the pre- and post-1984 subsamples.

<span id="page-77-0"></span>Table 4 Stability tests for the four- and eight-factor full dataset DFMs (A) Fraction of rejections of stability null hypothesis

|      |              |                                                                                |                                          | QLR test                                                                                                                        |
|------|--------------|--------------------------------------------------------------------------------|------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|
|      |              |                                                                                |                                          |                                                                                                                                 |
|      |              |                                                                                |                                          | 0.62                                                                                                                            |
|      | 0.54         |                                                                                |                                          | 0.77                                                                                                                            |
|      | 0.63         |                                                                                |                                          | 0.83                                                                                                                            |
|      |              |                                                                                |                                          |                                                                                                                                 |
|      |              |                                                                                |                                          | 0.94                                                                                                                            |
|      |              |                                                                                |                                          | 0.98                                                                                                                            |
|      | 0.72         |                                                                                |                                          | 0.98                                                                                                                            |
|      |              |                                                                                |                                          |                                                                                                                                 |
|      |              |                                                                                |                                          |                                                                                                                                 |
| 5%   | 25%          | 50%                                                                            | 75%                                      | 5%                                                                                                                              |
|      |              |                                                                                |                                          |                                                                                                                                 |
|      |              |                                                                                |                                          | 1.00                                                                                                                            |
| 0.45 | 0.83         | 0.95                                                                           | 0.97                                     | 0.99                                                                                                                            |
|      |              |                                                                                |                                          |                                                                                                                                 |
|      |              |                                                                                |                                          | 0.99                                                                                                                            |
| 0.43 | 0.80         | 0.94                                                                           | 0.97                                     | 0.99                                                                                                                            |
|      |              |                                                                                |                                          |                                                                                                                                 |
|      | 0.65<br>0.57 | 0.39<br>0.55<br>0.65<br>0.89<br>0.83<br>(C) Results by category (four factors) | Chow test (1984q4 break)<br>0.96<br>0.92 | (B) Distribution of correlations between full- and split-sample common components<br>Percentile of distribution<br>0.99<br>0.97 |

Median correlation between full- and split-sample common

|                                         | Number<br>Fraction of Chow test |                        |         | components |  |  |
|-----------------------------------------|---------------------------------|------------------------|---------|------------|--|--|
| Category                                | of series                       | rejections for 5% test | 1959–84 | 1985–2014  |  |  |
| NIPA                                    | 20                              | 0.50                   | 0.98    | 0.96       |  |  |
| Industrial<br>production                | 10                              | 0.50                   | 0.98    | 0.97       |  |  |
| Employment<br>and                       | 40                              | 0.40                   | 0.99    | 0.99       |  |  |
| unemployment                            |                                 |                        |         |            |  |  |
| Orders,<br>inventories,<br>and<br>sales | 10                              | 0.80                   | 0.98    | 0.96       |  |  |
| Housing<br>starts<br>and<br>permits     | 8                               | 0.75                   | 0.96    | 0.91       |  |  |
| Prices                                  | 35                              | 0.49                   | 0.88    | 0.90       |  |  |
| Productivity<br>and<br>labor            | 10                              | 0.80                   | 0.92    | 0.67       |  |  |
| earnings                                |                                 |                        |         |            |  |  |
| Interest<br>rates                       | 12                              | 0.33                   | 0.98    | 0.94       |  |  |
| Money<br>and<br>credit                  | 9                               | 0.89                   | 0.93    | 0.89       |  |  |
| International                           | 3                               | 0.00                   | 0.97    | 0.97       |  |  |
| Asset<br>prices,<br>wealth,<br>and      | 12                              | 0.58                   | 0.95    | 0.92       |  |  |
| household<br>balance<br>sheets          |                                 |                        |         |            |  |  |
| Other                                   | 1                               | 1.00                   | 0.95    | 0.91       |  |  |
| Oil<br>market<br>variables              | 6                               | 0.83                   | 0.79    | 0.79       |  |  |

Notes: These results are based on the 176 series with data available for at least 80 quarters in both the pre- and post-84 samples. The Chow tests in (A) and (C) test for a break in 1984q4.

<span id="page-78-0"></span>using the two subsample factor loadings are highly correlated. For a substantial portion of the series, however, there is a considerable difference between the full-sample and subsample estimates of the common components. Indeed, for 5% of the series, the correlation between the common component estimated post-1984 and the common component estimated over the full sample is less than 50% for both the four- and eight-factor models.

Interestingly, when broken down by category, for some categories, most of the subsample and full-sample common components are highly correlated [\(Table 4](#page-77-0) (panel C), final two columns). This is particularly true for the real activity variables, a finding consistent with the stability of the common component shown in [Fig. 5](#page-72-0) for the single factor from the real activity dataset. However, for some categories the subsample and full-sample common components are quite different, with median within-category correlations of less than 0.9 in at least one subsample for prices, productivity, money and credit, and oil market variables.

On net, [Table 4](#page-77-0) points to substantial instability in the DFM. One model of this instability, consistent with the results in the table, is that there was a break around 1984, consistent with empirical results in [Stock and Watson \(2009\)](#page-109-0), [Breitung and](#page-104-0) [Eickmeier \(2011\),](#page-104-0) and Chen [et al. \(2014\).](#page-104-0) However, the results in [Table 4](#page-77-0) could also be consistent with more complicated models of time variation.
