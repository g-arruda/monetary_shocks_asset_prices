# **Proof.** See Appendix. -

It is important to mention that if the number of true regimes is smaller than the number of regimes used in the estimation, then the system of equations does not satisfy the rank condition. In other words, there are not enough independent equations to identify the system. It should be clear that in those cases the estimates are inconsistent, and the confidence intervals are infinitely large.

The two cases analyzed in this section are probably the most common forms of misspecification. However, they are not exhaustive. Depending on the particular application in which the identification is used, and the possible misspecification problems that could be encountered, the consistency of the methodology should be explored further.

#### **V. Latin American Sovereign Debt**

This section applies the previous methodology to estimating the contemporaneous relationship between sovereign bonds in Latin America. The data consist of the daily yields for Argentina, Brazil, and Mexico between January 1994 and December 2001 obtained from the Emerging Markets Bond Index Plus (EMBI) constructed by J. P. Morgan. The EMBI country indices track total returns for traded external debt instruments in emerging markets, which for these countries are mainly Brady bonds. The indices are computed by simulating holding a portfolio with the weights determined by risk, market capitalization, liquidity considerations, and collateral characteristics of the particular bonds. The yields are computed relative to U.S. bonds with similar duration.

From the identification point of view, it should be clear that, for example, if Mexican shocks affect Argentina (for instance, through trade), then Argentinean shocks should influence Mexico, too. Moreover, these bonds are traded in the same market. Consequently, shocks to market participants are common to all the sovereign bonds. This means that the prices of the sovereign bonds are determined simultaneously and suffer from common unobservable shocks.

In this case, the traditional identification assumptions are difficult to defend: (i) it is not reasonable to assume exclusion restrictions in one direction and not in the other one, as has already been argued; (ii) it does not make sense to assume that one transmission is positive while the other one is negative (thus no sign restrictions can be imposed); (iii) moreover, there are no good reasons to assume that the shocks to one country are more persistent than the shocks to the other one (therefore, long-run restrictions cannot be enforced); and (iv) finally, it is difficult to substantiate an assumption about the relative importance of idiosyncratic shocks across the countries. This leaves the problem of identification unsolved with the standard procedures.

In figure 2, the three indices are shown. The yields are measured in basis points.

Table 1 computes the simple yearly correlations in the sample. Note that from 1994 to 1999 the correlations are high (even though they start to fall in 1999). Brady bonds are dollaror foreign-denominated debts, so exchange rate risks are excluded from them. Furthermore, the data used in this case are the stripped yields; hence, movements in U.S. rates cannot be the source of this large comovement. These yields capture, mainly, country risk. The fact that they are so highly correlated is what has motivated most of the literature on contagion.9

The objectives of this section are twofold: First, estimate consistently the contemporaneous coefficients across these three countries. The data display important heteroskedasticity, which allows us to implement the procedure developed here to estimate the contemporaneous coefficients *A* and . <sup>10</sup> Second, determine whether there has been a shift in the coefficients after mid-1999. Observe that the correlations dropped substantially in the later part of the sample. Market participants have explained the decoupling as the result of two events: the Brazilian and Mexican movement toward inflation targeting (after the first quarter of 1999), and the upgrade to investment grade of Mexico in March of 2000.11 It should be expected, then, that these changes in the market structure will have implications for the parameter stability of the model proposed. In other words, the overidentifying restrictions should be rejected when the later part of the sample is included in the estimation.

<sup>9</sup> Brazil has fewer than half the observations in 1994, so it is excluded from that year.

<sup>10</sup> In these data there exists both conditional and unconditional heteroskedasticity (see Edwards, 1998, and Edwards & Susmel, 2000). In this paper, most of the arguments are developed assuming unconditional heteroskedasticity. However, similar arguments are easily extended to the case in which only conditional heteroskedasticity exists.

<sup>11</sup> It is well known that correlation coefficients are biased in the presence of heteroskedasticity. The standard procedures to adjust the correlation coefficient, however, cannot be used in this case; they work only if the variables are not subject to simultaneous-equation or omitted variable problems. But that is the essence of the problem solved in this paper. See Ronn (1998) for the original adjustment in the correlation coefficient. See Boyer, Gibson, and Loretan (1999), Forbes and Rigobon (2002), and Loretan and English (2000) for generalizations of Ronn's result.

FIGURE 2.—YIELDS ON SOVEREIGN DEBT: ARGENTINA, BRAZIL, AND MEXICO

![](_page_8_Figure_3.jpeg)

Source: J. P. Morgan.

#### A. Measuring the Contemporaneous Relationship

Assume the yields are described by the following model:

$$A \begin{Bmatrix} Arg_t \\ Bra_t \\ Mex_t \end{Bmatrix} = c + \phi(L) \begin{Bmatrix} Arg_t \\ Bra_t \\ Mex_t \end{Bmatrix} + \phi US_t$$

$$+ \Phi(L)US_t + \begin{Bmatrix} \xi_{Arg,t} \\ \xi_{Bra,t} \\ \xi_{Mex_t} \end{Bmatrix} + \Gamma_{Z_t},$$
(18)

TABLE 1.—SIMPLE CORRELATIONS OF STRIPPED YIELDS

|      | Correlation (%) |         |         |  |  |  |
|------|-----------------|---------|---------|--|--|--|
| Year | Arg-Mex         | Arg–Bra | Bra-Mex |  |  |  |
| 1994 | 82.3            |         |         |  |  |  |
| 1995 | 78.3            | 78.9    | 80.4    |  |  |  |
| 1996 | 88.2            | 90.7    | 92.7    |  |  |  |
| 1997 | 92.2            | 94.5    | 83.1    |  |  |  |
| 1998 | 95.1            | 94.1    | 98.7    |  |  |  |
| 1999 | 83.6            | 73.4    | 94.2    |  |  |  |
| 2000 | 12.2            | 67.5    | 66.7    |  |  |  |
| 2001 | -37.0           | 39.5    | 13.1    |  |  |  |
|      |                 |         |         |  |  |  |

where  $Arg_t$ ,  $Bra_t$  and  $Mex_t$  are the yields on the sovereign bonds from Argentina, Brazil, and Mexico, respectively.  $US_t$  is the return on a 10-year U.S. government bond. The matrices Aand  $\Gamma$  are the parameters of interest,  $\phi$  is the contemporaneous effect of U.S. interest rates on emerging market interest rates, and  $\phi(L)$  and  $\Phi(L)$  are lags. The shocks in equation (18) are assumed to be contemporaneously uncorrelated, serially uncorrelated, and with covariance matrices  $\Omega_s^{\varepsilon}$  and  $\Omega_s^{\varepsilon}$  in regime s.

The reduced form is

$$\begin{cases}
Arg_t \\
Bra_t \\
Mex_t
\end{cases} = A^{-1}c + A^{-1}\phi(L) \begin{cases}
Arg_t \\
Bra_t \\
Mex_t
\end{cases} + A^{-1}\phi US_t + A^{-1}\Phi(L)US_t + \nu_t,$$

where the reduced-form residuals  $v_t$  satisfy

$$A\nu_{t} = \begin{cases} \xi_{Arg,t} \\ \xi_{Bra,t} \\ \xi_{Mex,t} \end{cases} + \Gamma z_{t}. \tag{19}$$

TABLE 2.—TRANQUIL AND CRISIS WINDOWS

| Definition of the Windows | Start      | End        |
|---------------------------|------------|------------|
| Tranquil periods          | 1994-05-01 | 1994-12-18 |
|                           | 1995-03-02 | 1997-05-31 |
|                           | 1998-01-01 | 1998-06-30 |
|                           | 1998-11-01 | 1999-01-12 |
|                           | 1999-03-01 | 2000-02-28 |
|                           | 2000-06-01 | 2000-09-30 |
| Mexican crisis            | 1994-12-19 | 1995-03-01 |
| Asian crises              | 1997-06-01 | 1998-01-31 |
| Russian crisis            | 1998-08-01 | 1998-10-31 |
| Brazilian devaluation     | 1999-01-13 | 1999-02-28 |
| Mexico's upgrade          | 2000-03-01 | 2000-05-31 |
| Argentinean crisis        | 2000-10-01 | 2001-12-31 |

The reduced-form residuals share the same contemporaneous relationship as the returns. Equation (19) is equivalent to the model developed in equations (9) to (12). The next step is then to determine the volatility regimes.

The recent international crises are a natural framework to define the regimes. These international crises have been associated with large and persistent increases in volatility. Since 1994, one upgrade and five major crises have occurred: (i) The Mexican crisis started in December 19, 1994, when the fixed exchange rate was abandoned. The end of the crisis has been dated around March 31, 1995 when the markets calmed down after the U.S. bailout. (ii) The South East Asian crises started with the speculative attack against Thailand (June 1997) and ended after the Korean crisis (January 1998). (iii) The Russian crisis started with a massive drop in Russian bond prices at the beginning of August of 1998 and lasted until the end of October after the LTCM rescue was organized by the Fed. (iv) Brazil devalued its currency in early January of 1999, and markets returned to normal relatively fast. (v) Mexico was upgraded in March of 2000; thus, the period from the beginning of March until the end of May is considered a crisis period even though that was good news. (vi) Finally, it can be claimed that Argentina's problems started in late 2000. So, for the purpose of the estimation, the Argentinean crisis runs from October 2000 until the end of the data set. The tranquil periods are considered to be the rest of the observations. In table 2 the windows are summarized.

In table 3 the variance-covariance matrix of each of the subsamples is shown. The first column shows the period of interest, and the next six columns show the different moments from the reduced-form matrix. The first six rows in the table give the covariance matrices of the tranquil periods, the next six rows give the crisis subsamples, and the last six rows are the relative changes in the moments: the moments during the crisis periods relative to the tranquil periods that precede them.

As can be seen, the crises led to considerable increases in the variances and covariances for all three countries. The Mexican devaluation resulted in a variance for Mexico almost 35 times higher than during tranquil periods, as well as a large variance for Argentina. The Asian crises had a smaller effect, but still the variances increased in three to five times. The Russian collapse had perhaps the largest overall effect; all volatilities increased more than 15 times. The Brazilian devaluation had a small effect on almost all of the moments. The upgrade of Mexico, on the other hand, reduced the overall volatility. Brazil and Mexico's variances were one-fifth of those prevailing before the Mexican upgrade, and Argentina also showed improvements in this dimension. Finally, the Argentinean crisis led to a massive increase in volatility for Argentina and Brazil, but a small one for Mexico.

The model has three endogenous variables (*N* 3) and one common shock (*K* 1). Thus, the catch-up constraint (14) is satisfied. Moreover, according to equation (13), at least four regimes are needed to identify the system. There-

TABLE 3.—VARIANCE-COVARIANCE MATRIX FOR EACH WINDOW

|                       | Variables (%) |              |         |              |              |         |  |
|-----------------------|---------------|--------------|---------|--------------|--------------|---------|--|
| Window                | V (Arg)       | C (Arg, Mex) | V (Mex) | C (Arg, Bra) | C (Mex, Bra) | V (Bra) |  |
| Tranquil Periods      | 0.684         | 0.120        | 0.159   | 0.396        | 0.350        | 2.471   |  |
|                       | 0.150         | 0.102        | 0.108   | 0.083        | 0.082        | 0.071   |  |
|                       | 0.160         | 0.129        | 0.123   | 0.248        | 0.214        | 0.415   |  |
|                       | 0.286         | 0.217        | 0.239   | 0.539        | 0.308        | 2.198   |  |
|                       | 1.078         | 0.914        | 0.988   | 1.463        | 1.629        | 3.088   |  |
|                       | 0.050         | 0.020        | 0.090   | 0.010        | 0.044        | 0.041   |  |
| Mexican Crisis        | 4.642         | 4.766        | 5.547   | 2.466        | 2.665        | 1.432   |  |
| Asian Crises          | 1.102         | 0.601        | 0.344   | 1.192        | 0.652        | 1.309   |  |
| Russian Crisis        | 5.630         | 3.261        | 2.511   | 5.327        | 3.872        | 6.222   |  |
| Brazilian Devaluation | 0.725         | 0.546        | 0.442   | 1.158        | 0.881        | 2.068   |  |
| Mexico's Upgrade      | 0.521         | 0.297        | 0.226   | 0.450        | 0.316        | 0.486   |  |
| Argentinean Crisis    | 96.262        | 1.202        | 0.122   | 6.127        | 0.055        | 1.871   |  |
| Mexican Crisis        | 6.8           | 39.6         | 34.8    | 6.2          | 7.6          | 0.6     |  |
| Asian Crises          | 7.3           | 5.9          | 3.2     | 14.3         | 8.0          | 18.4    |  |
| Russian Crisis        | 35.2          | 25.2         | 20.4    | 21.5         | 18.1         | 15.0    |  |
| Brazilian Devaluation | 2.5           | 2.5          | 1.8     | 2.1          | 2.9          | 0.9     |  |
| Mexico's Upgrade      | 0.5           | 0.3          | 0.2     | 0.3          | 0.2          | 0.2     |  |
| Argentinean Crisis    | 1937.6        | 60.9         | 1.4     | 585.8        | 1.3          | 45.7    |  |

The six columns on the right show the estimated second moment between the stripped yields of Argentina, Brazil, and Mexico.

fore, the system is just identified when, for example, two crises and two periods of tranquility are considered. If additional crises are included, the system is overidentified.

Five different subsamples are used for the estimation. The first subsample includes the Mexican and Asian crises and their respective tranquil periods. This is a just-identified system and is denoted as MA. The next four subsamples add successively a tranquil period and a crisis period: MAR adds the Russian collapse, MARB includes Brazil, MARBU appends the upgrade of Mexico, and MARBUA uses the entire sample. The maintained assumption is that the coefficients across all samples are constant. The first subsample is the control group and is compared with the next four, where the system of equations is overidentified.

In the estimation procedure first, a VAR is run on the log of the yields to remove the effects of serial correlation and of the variation in international interest rates (here the U.S. 10-year rates). Second, once the subsamples are defined, the covariance matrix in each of them is computed. Third, those covariance matrices are used in the GMM estimation of the contemporaneous coefficients. The standard errors are computed by bootstrapping. The residuals in each of the regimes are bootstrapped to obtained a distribution of covariance matrices. In the application, 500 replications were used.

The results are summarized in table 4. The first column indicates which crises were included in the estimation. The next three pairs of columns contain the estimates of the contemporaneous coefficients in each of the equations: Argentina, Brazil, and Mexico. For example, the second column contains the estimate of the Brazilian coefficient in the Argentinean equation. This is a measure of the direct propagation of the shocks from Brazil to Argentina. The third column contains the coefficient on Mexico's yields in the Argentinean equation. The next pairs of columns represent the Brazilian and Mexican equations, respectively. The last three columns contain the coefficients of the common shock. Remember that these coefficients are estimated up to a normalization, and in this case it was decided to set the coefficient of Argentina equal to 1. Hence, the coefficients of interest are the Mexican and Brazilian ones. They indicate how sensitive these countries are to common shocks relative to Argentina. For each coefficient, the first entry is the point estimate, the second one is the standard deviation computed in the bootstrap, and the third one is the *t*statistic.

The interpretation of the results is easier if the coefficients are analyzed individually across the different subsamples. The first equation is the Argentinean reaction to Brazilian and Mexican shocks. Notice that the estimates from Brazil are not statistically different from 0 (in all five subsamples). Interestingly, however, the coefficients increase from almost 0 to around 30% for those samples that include the Brazilian devaluation. On the other hand, the Mexican coefficient is always significant (and usually larger in magnitude too). The point estimate of the Mexican coefficient falls when the later part of the sample is included. Market participants have conjectured that the upgrade of Mexico has disentangled it from the rest of Latin America. If this is correct, then the drop in the point estimates goes in the right direction. The question is whether the fall is large enough to yield a rejection of the overidentifying restrictions. The tests of parameter stability are performed on all the coefficients at the same time and they are discussed below.

The Brazilian equation shows that Argentina and Mexico have, roughly, the same effect on Brazil. The coefficients of Argentina move from 17% to a maximum of 39%, and the coefficients on Mexican innovations run from a minimum of 15% to a maximum of 24%, although very few of the coefficients are statistically different from zero. The only subsamples in which the coefficients are significantly different from zero are MAR and MARBUA.

TABLE 4.—POINT ESTIMATES OF CONTEMPORANEOUS COEFFICIENTS Shock Arg's Eq. Bra's Eq. Mex's Eq. Common Shock Bra Mex Arg Mex Arg Bra Arg Bra Mex MA 0.0513 0.4071 0.1764 0.2297 0.0965 0.3949 1.00 1.0273 1.8795 0.1890 0.0895 0.1312 0.0579 0.1892 0.3022 0.3428 0.6529 0.27 4.55 1.34 3.97 0.51 1.31 3.00 2.88 MAR 0.0298 0.4105 0.3957 0.1530 0.3623 0.0169 1.00 0.6622 0.6370 0.1535 0.0647 0.1443 0.0646 0.1018 0.1227 0.2250 0.2377 0.19 6.35 2.74 2.37 3.56 0.14 2.94 2.68 MARB 0.3674 0.2954 0.2711 0.2147 0.7011 0.1108 1.00 0.7676 0.5246 0.3230 0.1342 0.4740 0.2814 0.6641 0.6914 0.9263 1.2044 1.14 2.20 0.57 0.76 1.06 0.16 0.83 0.44 MARBU 0.2792 0.3257 0.2044 0.2436 0.5944 0.2111 1.00 0.8824 0.2891 0.3977 0.1571 0.4825 0.2438 0.6040 0.6471 0.8033 1.1509 0.70 2.07 0.42 1.00 0.98 0.33 1.10 0.25 MARBUA 0.3609 0.3117 0.2310 0.2221 0.0889 0.1443 1.00 0.9499 1.2591 0.1900 0.0761 0.0447 0.0327 0.0653 0.1607 0.3279 0.4167 1.90 4.10 5.17 6.79 1.36 0.90 2.90 3.02

Standard deviations obtained from bootstrapping (500 replications).

TABLE 5.—*F*-TESTS FOR ALL THREE SPECIFICATIONS

| Comparison | Original | Short   | No Common |
|------------|----------|---------|-----------|
|            | Windows  | Windows | Shock     |
| MA-MAR     | 1.42     | 0.93    | 64.23     |
|            | 18.59%   | 48.87%  | 0.00%     |
| MA-MARB    | 2.82     | 1.26    | 17.89     |
|            | 0.45%    | 26.45%  | 0.00%     |
| MA-MARBU   | 2.49     | 1.00    | 8.14      |
|            | 1.18%    | 43.69%  | 0.00%     |
| MA-MARBUA  | 8.17     | 33.04   | 368.64    |
|            | 0.00%    | 0.00%   | 0.00%     |

Standard deviations obtained from bootstrapping (500 replications).

The coefficients from estimating the Mexican equation suggest that, in general, Argentina and Brazil have a small effect on Mexican sovereign debt yields. There is only one significant coefficient, which is found in the MAR sample.

Finally, the common shock coefficients are significantly different from 0 in almost all the subsamples. It can be claimed not only that common shocks to Argentina have a much smaller effect on Brazil and Mexico, but also that those common negative shocks to Argentina are associated with positive shocks in Brazil and Mexico.12

The next step is to determine the stability of these coefficients. Under the null hypothesis that the estimates are stable, the coefficients are consistently estimated in all the subsamples. However, under the alternative that they are not stable, the estimated coefficients are biased and the standard *F*-test should be rejected. The estimates from the different subsamples (MAR, MARB, MARBU, and MARBUA) are compared with those of MA. To compute the *F*-tests it is important to take into account the fact that different estimates share subsamples. For example, the estimate from MAR shares samples with MA, and in the bootstrap those common draws were maintained. Hence, the *F*-tests are calculated numerically. The results are summarized in table 5. The first column shows the *F*-values and the *p*-values for this exercise. The other columns are the results of similar tests in other specifications discussed later. The *F*-value for the MA-MAR comparison is 1.42, which is not significantly different from 0. When Brazil is included, the *F*-test is 2.82, and when the upgrade is also incorporated it is 2.49. Both are statistically different from 0. Notice that when the whole sample (MARBUA) is compared with the MA sample, the rejection is very strong—the *F*-value is 8.17.

The model is overidentified when the Russian crisis is included in the estimation. However, even though the point estimates change, they are not statistically different from those obtained in the MA sample. If the true parameters were unstable, then the estimates should have been different. The reason is that further rotations in the residuals cannot be explained by changes in volatility alone, and the estimates are biased. Obviously, there is a question about the power of the test in these circumstances. Nevertheless, the fact that the stability of parameters is rejected when the Brazilian crisis, then the Mexican upgrade, and then the Argentinean crisis are added to the estimation suggests that the procedure has sufficient power to reject. Furthermore, according to the observations made by market participants, we might have expected that rejections were more likely in the later part of the sample.

# *B. Robustness*

In this section, we perform two robustness checks. First, the definition of the crisis windows is modified to evaluate the sensitivity of the procedure. Second, the model is estimated without common shocks to show the importance of including them in the specification.

# *Change in Crisis Windows*

In this section, the crisis windows are shortened to evaluate the robustness of the results. Table 6 shows the old and new crises windows. The changes correspond to the following events: During the Mexican crisis the shorter sample concentrates mainly on the devaluation and lack of rollover in the bond market. The period of the bailout discussion in the U.S. Congress is excluded. For the Asian crises, only the Hong Kong collapse is studied. The Russian crisis period is restricted to exclude both the LTCM problems in September and the Brazilian speculative attack in October. The Mexican upgrade remains the same. The Argentinean crisis studies the April and May 2001 hikes in the Argentinean rates. During this period, concerns about the sustainability of the currency board were raised. The market calmed down in June of that year. The tranquil periods are the same as those defined above. The rest of the data are dropped.

Table 7 shows the results from the estimation. The point estimates are very similar to those obtained in the previous estimation. Actually, it is impossible to reject the hypothesis that these estimates are the same as those from table 4, sample by sample. The largest *F*-value is obtained when the two MARBUA estimates are compared, and it is only 0.32. Given the discussion from section 4, these results should have been expected. Small perturbations in the definition of the windows should continue to produce consistent estimates.

TABLE 6.—NEW CRISIS WINDOWS

|                                                                                                                     |                                                                                  | Old                                                                              | New                                                                              |                                                                                  |  |
|---------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------|--|
| Window                                                                                                              | Beginning                                                                        | End                                                                              | Beginning                                                                        | End                                                                              |  |
| Mexican crisis<br>Asian crises<br>Russian crisis<br>Brazilian devaluation<br>Mexico's upgrade<br>Argentinean crisis | 1994-12-19<br>1997-06-01<br>1998-08-01<br>1999-01-13<br>2000-03-01<br>2000-10-01 | 1995-03-01<br>1998-01-31<br>1998-10-31<br>1999-02-28<br>2000-05-31<br>2001-12-31 | 1994-12-19<br>1997-10-01<br>1998-08-01<br>1999-01-13<br>2000-03-01<br>2001-04-01 | 1995-01-31<br>1997-11-01<br>1998-08-31<br>1999-01-31<br>2000-05-31<br>2001-05-15 |  |

<sup>12</sup> Market participants have noted an important "flight to quality" among emerging-market instruments. The negative signs on of the coefficients in table 4 confirm this intuition.

TABLE 7.—POINT ESTIMATES OF CONTEMPORANEOUS COEFFICIENTS

|        | Arg's Eq.                |                          | Bra's Eq.                |                          | Mex's Eq.                |                          | Common Shock |                          |                          |
|--------|--------------------------|--------------------------|--------------------------|--------------------------|--------------------------|--------------------------|--------------|--------------------------|--------------------------|
| Shock  | Bra                      | Mex                      | Arg                      | Mex                      | Arg                      | Bra                      | Arg          | Bra                      | Mex                      |
| MA     | 0.0019<br>0.2351<br>0.01 | 0.4265<br>0.1074<br>3.97 | 0.2367<br>0.1876<br>1.26 | 0.2054<br>0.0859<br>2.39 | 0.0844<br>0.1717<br>0.49 | 0.3692<br>0.2369<br>1.56 | 1.00         | 0.8761<br>0.3630<br>2.41 | 2.0223<br>0.5697<br>3.55 |
| MAR    | 0.1404<br>0.2757<br>0.51 | 0.3912<br>0.1034<br>3.78 | 0.5217<br>0.2751<br>1.90 | 0.0958<br>0.1207<br>0.79 | 0.2657<br>0.2877<br>0.92 | 0.1304<br>0.3259<br>0.40 | 1.00         | 0.6552<br>0.6766<br>0.97 | 1.1686<br>0.7119<br>1.64 |
| MARB   | 0.4900<br>0.3378<br>1.45 | 0.2786<br>0.1183<br>2.36 | 0.4234<br>0.2527<br>1.68 | 0.1394<br>0.1153<br>1.21 | 0.3144<br>0.2136<br>1.47 | 0.1887<br>0.3644<br>0.52 | 1.00         | 2.1843<br>2.6686<br>0.82 | 2.7492<br>2.6653<br>1.03 |
| MARBU  | 0.5104<br>0.3273<br>1.56 | 0.2707<br>0.1177<br>2.30 | 0.3848<br>0.2487<br>1.55 | 0.1562<br>0.1108<br>1.41 | 0.2782<br>0.3498<br>0.80 | 0.2222<br>0.4546<br>0.49 | 1.00         | 2.2127<br>2.5376<br>0.87 | 2.6640<br>2.4002<br>1.11 |
| MARBUA | 0.5869<br>0.2142<br>2.74 | 0.2510<br>0.0776<br>3.23 | 0.2518<br>0.0541<br>4.66 | 0.2173<br>0.0475<br>4.57 | 0.0554<br>0.0688<br>0.80 | 0.3287<br>0.1861<br>1.77 | 1.00         | 2.3644<br>2.1435<br>1.10 | 2.9338<br>2.4639<br>1.19 |

Crisis windows are smaller. Standard deviations obtained from bootstrapping (500 replications).

Therefore, the interpretation of the equations is very similar to the one from the previous exercise; the only difference is that some of these coefficients seem to be estimated with less precision. In the Argentinean equation, Brazil's coefficient is small before the Brazilian devaluation, and it increases to around 50% after the devaluation. It is not significant in the early samples, but significant for the MARBUA sample (this is the only coefficient that is significant in this exercise but was not in the previous one). Mexico has estimates that are very close to the earlier ones. The Brazilian and Mexican equations are close to the ones from table 4. Finally, the common shocks are very similar.

The *F*-tests comparing estimates across the different subsamples were performed in this exercise as well. The results are shown in the second column (short windows) of table 5. In this case the power of the test is much smaller than in the previous exercise. The test is rejected only when MARBUA and MA are compared. For the other three cases the *F*-tests take values smaller than 1.26.

# *No Common Unobservable Shocks*

The final case estimates the model assuming that there are no common shocks. The purpose is to show the importance of heteroskedastic common shocks in the estimation of the model. The windows are the same as those defined in table 2. It should be expected that this model will be rejected, and the results below confirm so.

Sovereign bonds are subject to important common shocks, such as wealth shocks to market participants, margin calls, and risk preference shocks. Several of the recent theories of contagion are based on the existence of these types of shocks. Calvo (1999) provides perhaps the most prominent example of these theories.

In table 8, the results from the estimates are shown. The structure of the table is the same as before. Most of the coefficients are larger and more precisely estimated. The test that these coefficients are the same as those from table 4 is rejected in three out of the five subsamples. For example, the *F*-test of comparing the two MA samples is 3.64, for the MAR-MAR is 2.37, and for the two MAR-BUAs is 2.28. In the other two cases (MARB-MARB and MARBU-MARBU) the hypothesis is not rejected.

Furthermore, the overidentifying restrictions reject this model. As can be seen in the fourth column (no common shock) of table 5, *F*-tests comparing MA with the other four samples always reject at very high levels of confidence.

These results suggest that the rotation of the residuals observed in the data cannot be explained by changes in the variance of the structural shocks alone. In the absence of heteroskedastic common shocks, different structural coefficients are required to explain the rotations of the residuals during the Mexican, Asian, and Russian tranquil and crisis periods.

TABLE 8.—POINT ESTIMATES OF CONTEMPORANEOUS COEFFICIENTS

|        | Arg's Eq. |        | Bra's Eq. |        | Mex's Eq. |        |  |  |
|--------|-----------|--------|-----------|--------|-----------|--------|--|--|
| Shock  | Bra       | Mex    | Arg       | Mex    | Arg       | Bra    |  |  |
| MA     | 0.7480    | 0.1669 | 0.2123    | 0.2200 | 0.5548    | 0.2105 |  |  |
|        | 0.1465    | 0.0673 | 0.2054    | 0.0810 | 0.0811    | 0.0757 |  |  |
|        | 5.11      | 2.48   | 1.03      | 2.72   | 6.84      | 2.78   |  |  |
| MAR    | 0.4784    | 0.2672 | 0.5841    | 0.0728 | 0.3236    | 0.3905 |  |  |
|        | 0.1631    | 0.0676 | 0.1065    | 0.0524 | 0.0900    | 0.0959 |  |  |
|        | 2.93      | 3.95   | 5.49      | 1.39   | 3.60      | 4.07   |  |  |
| MARB   | 0.5238    | 0.2500 | 0.5494    | 0.0942 | 0.4511    | 0.2156 |  |  |
|        | 0.1486    | 0.0626 | 0.1050    | 0.0517 | 0.0713    | 0.0820 |  |  |
|        | 3.53      | 3.99   | 5.23      | 1.82   | 6.32      | 2.63   |  |  |
| MARBU  | 0.5433    | 0.2429 | 0.5251    | 0.1042 | 0.4302    | 0.2412 |  |  |
|        | 0.1612    | 0.0638 | 0.1187    | 0.0559 | 0.0760    | 0.0859 |  |  |
|        | 3.37      | 3.81   | 4.42      | 1.87   | 5.66      | 2.81   |  |  |
| MARBUA | 0.7633    | 0.1824 | 0.3233    | 0.1850 | 0.2665    | 0.4012 |  |  |
|        | 0.0834    | 0.0453 | 0.0694    | 0.0397 | 0.0611    | 0.0756 |  |  |
|        | 9.15      | 4.03   | 4.66      | 4.66   | 4.36      | 5.31   |  |  |

No common shocks. Standard deviations obtained from bootstrapping (500 replications).

Other robustness tests were performed, but for brevity their results are not reported in detail. First, in the VAR, the U.S. interest rate was excluded from the specification. The main change in this case is that the coefficients on the common shock become more precise and they are usually positive and significantly different from zero. However, the point estimates of the contemporaneous coefficients are very close to the ones found here. Second, the tranquil periods were treated together or separately. Again, the estimates change very little and are not statistically different from those in table 4. However, in this case there are fewer combinations of subsamples where the overidentification tests can be run. Finally, the first-step regression was changed and run in levels, in differences, in logs, and in returns, and similar conclusions were found. The main difference is that, when the regression is run in levels, almost all contemporaneous coefficients are statistically significant.

# **VI. Conclusions**

This paper discusses a procedure to solve the problem of estimation in simultaneous-equation models. The methodology is based on the heteroskedasticity of the structural shocks, and it can be used when there are no acceptable instruments, or when the standard identification assumptions (exclusion restrictions, long-run constraints, and so on) cannot be justified.

It is shown that if the structural shocks have a known correlation (0 in this case) and if the parameters are stable, then the heteroskedasticity in the structural shocks increases the number of equations, allowing us to solve the problem of identification. This intuition was introduced by Philip Wright in 1928. He indicated that an increase in the variance of the shocks in one of the equations reduces the bias in the OLS estimates of the other one. This paper generalizes that intuition and provides the conditions to identify the system fully.

The two main results from the paper are: First, propositions 1 and 2 state the circumstances where the order and rank conditions for identification are obtained. The order condition requires three assumptions: (i) the structural shocks must have zero correlation; (ii) the structural parameters must be stable across regimes; (iii) and there must exist at least two regimes of different variances. Several macroeconomic and finance applications satisfy these conditions. For example, most macro applications in which VAR and recursive identifications are used have already imposed these assumptions. The paper also discusses the case in which the zero correlation on the structural shocks is relaxed by including common unobservable shocks in the specification.

Second, in section IV, it is shown that consistent estimates are obtained even if the heteroskedasticity is incorrectly specified. When the true data display heteroskedasticity and the regimes are misspecified, then if the misspecified covariance matrices satisfy the rank condition, the estimates are consistent.

This paper applies the methodology to measure the contemporaneous relationship across emerging-market sovereign-bond yields. The recent international financial crises are a natural framework to apply the procedure. The crises have been associated with sizable and persistent shifts in volatility for almost all countries in the sample. The estimates suggest that there are strong linkages among Argentina, Brazil, and Mexico, even after controlling for common shocks. Furthermore, as is shown, parameter stability is rejected in the later part of the sample—that is, after Brazil and Mexico moved to inflation targeting and after Mexican debt was upgraded to investment grade. However, it was not rejected in the early part of the sample.

In this paper, the estimation of a multivariate system of equations was performed relying exclusively on heteroskedasticity. However, it should be clear that standard identification assumptions can be used together with this procedure to ameliorate the problems of estimation in simultaneous-equation models. Thus, it is imperative to restate the limitation on this procedure: parameter stability is fundamental. If the finance or macro application can justify changes in second moments with stable coefficients, then heteroskedasticity, as described here, can be used. Several of those applications have already imposed such restrictions, but it is essential to understand that this is an underlying assumption of the methodology. Future research should extend this procedure to deal with some forms of parameter instability, such as nonlinear models.

# REFERENCES

Blanchard, O., and D. Quah, "The Dynamic Effects of Aggregate Demand and Aggregate Supply Disturbances," *American Economic Review,* 79 (1989), 659–673.

Boyer, B. H., M. S. Gibson, and M. Loretan, "Pitfalls in Tests for Changes in Correlations," Federal Reserve Board, IFS discussion paper no. 597R (1999).

Calvo, G., "Contagion in Emerging Markets: When Wall Street is a Carrier," University of Maryland mimeograph (1999).

Caporale, G. M., A. Cipollini, and P. Demetriades, "Monetary Policy and the Exchange Rate During the Asian Crisis: Identification through Heteroskedasticity," CEMFE mimeograph (2002a).

Caporale, G. M., A. Cipollini, and N. Spagnolo, "Testing for Contagion: A Conditional Correlation Analysis," CEMFE mimeograph (2002b).

Chen, S., and S. Khan, "*n*-Consistent Estimation of Heteroskedastic Sample Selection Models," University of Rochester mimeograph (1999).

Dungey, M., and V. L. Martin, "Contagion across Financial Markets: An Empirical Assessment," Australian National University mimeograph (2001).

Edwards, S., "Interest Rate Volatility, Capital Controls, and Contagion," NBER working paper no. 6756 (1998).

Edwards, S., and R. Susmel, "Interest Rate Volatility and Contagion in Emerging Markets: Evidence from the 1990's," UCLA mimeograph (2000).

Fisher, F. M., *The Identification Problem in Econometrics, 2nd ed.* (New York: Robert E. Krieger, 1976).

Forbes, K., and R. Rigobon, "No Contagion, Only Interdependence: Measuring Stock Market Co-movements," *Journal of Finance,* 57:5 (2002), 2223–2261.

Haavelmo, T., "Methods of Measuring the Marginal Propensity to Consume," *Journal of the American Statistical Association* 42 (1947), 105–122.

King, M., E. Sentana, and S. Wadhwani, "Volatility and Links between National Stock Markets," *Econometrica*, 62 (1994), 901–933.

Klein, R., and F. Vella, "Employing Heteroskedasticity to Identify and Estimate Triangular Semiparametric Models," Rutgers mimeograph (2000a).

"Identification and Estimation of the Binary Treatment Model under Heteroskedasticity," Rutgers mimeograph (2000b).

Koopmans, T., H. Rubin, and R. Leipnik, "Measuring the Equation Systems of Dynamic Economics" (pp. 53–237), in Cowles Commission for Research in Economics (Ed.), Statistical Inference in Dynamic Economic Models (New York: John Wiley and Sons, 1950)

Loretan, M., and W. B. English, "Evaluation Correlation Breakdowns during Periods of Market Volatility," Federal Reserve Board mimeograph (2000).

Rigobon, R., "A Simple Test for Stability of Linear Models under Heteroskedasticity, Omitted Variable, and Endogenous Variable Problems," MIT mimeograph, http://web.mit.edu/rigobon/www/ (2000).

— "The Curse of Non-Investment Grade Countries," Journal of Development Economics, 69:2 (2002), 423–449.

Rigobon, R., and B. Sack, "Measuring the Reaction of Monetary Policy to the Stock Market," *Quarterly Journal of Economics* 118:2 (2003), 639–669.

"The Impact of Monetary Policy on Asset Prices," NBER working paper no. 8794 (2002).

Ronn, E., "The Impact of Large Changes in Asset Prices on Intra-market Correlations in the Stock and Bond Markets," mimeo (1998).

Rothenberg, T. J., and P. A. Ruud, "Simultaneous Equations with Covariance Restrictions," *Journal of Econometrics* 44:1–2 (1990), 25–39.

Sentana, E., "Identification of Multivariate Conditionally Heteroskedastic Factor Models." LSE, FMG discussion paper no. 139 (1992).

Sentana, E., and G. Fiorentini, "Identification, Estimation and Testing of Conditional Heteroskedastic Factor Models," *Journal of Econo*metrics 102:2 (2001), 143–164.

Shapiro, M. D., and M. W. Watson, *Sources of Business Cycle Fluctua*tions (Cambridge, MA: MIT Press, 1988).

Wright, P. G., *The Tariff on Animal and Vegetable Oils* (New York: Macmillan, 1928).

#### APPENDIX A

## **Proofs of Propositions**

#### 1. Proof of Proposition 1

Identification is achieved if equation (5) has real solutions. A real solution requires

$$\begin{split} (\omega_{11,1}\omega_{22,2} - \omega_{22,1}\omega_{11,2})^2 - 4(\omega_{11,1}\omega_{12,2} - \omega_{12,1}\omega_{11,2}) \\ \times (\omega_{12,1}\omega_{22,2}22,2 - \omega_{22,1}\omega_{12,2}) > 0. \end{split}$$

After some algebra this is found to be equal to

$$(\omega_{11,2}^2\omega_{22,2}^2)(\theta_{11} - \theta_{22})^2 - [2\omega_{11,2}\omega_{22,2}\omega_{12,2}^2] \times [2(\theta_{11} - \theta_{12})(\theta_{12} - \theta_{22})] > 0,$$

where  $\theta_{11} = \omega_{11,1}/\omega_{11,2}$ ,  $\theta_{12} = \omega_{12,1}/\omega_{12,2}$ , and  $\theta_{22} = \omega_{22,1}/\omega_{22,2}$ . A sufficient condition for this inequality to be positive is

$$\omega_{11,2}^2\omega_{22,2}^2-2\omega_{11,2}\omega_{22,2}\omega_{12,2}^2>0,$$

$$(\theta_{11} - \theta_{22})^2 - 2(\theta_{11} - \theta_{12})(\theta_{12} - \theta_{22}) > 0.$$

The first inequality is satisfied because of the positive definiteness of the covariance matrix:

$$\omega_{11,2}\omega_{22,2}(\omega_{11,2}\omega_{22,2}-2\omega_{12,2}^2)>0.$$

The second inequality is found, after some algebra, to be equivalent to

$$(\theta_{11} - \theta_{12})^2 + (\theta_{22} - \theta_{12})^2 > 0$$
,

which is always positive. Therefore, if the coefficients in the quadratic equation are different from 0, then the two roots are real.

The last requirement is to show when the quadratic equation does not have infinite solutions. This requires that either

$$\omega_{11,1}\omega_{22,2} - \omega_{22,1}\omega_{11,2} \neq 0$$

or

$$\omega_{11.1}\omega_{12.2} - \omega_{12.1}\omega_{11.2} \neq 0.$$

Given the model generating the data, these two assumptions are not satisfied if the heteroskedasticity leads to a proportional change of both structural shocks' variances—in other words, if  $\Omega_2 = a\Omega_1$  for some scalar a. This is the only case in which the quadratic equation (5) has infinite solutions.

Note that if  $\Omega_2 = a\Omega_1$  then  $\det(\Omega_2 - a\Omega_1) = 0$ , which can be tested by computing whether or not  $\det[\Omega_2 - (\omega_{11,2}/\omega_{11,1})\Omega_1] = 0$ . By construction this is equivalent to asking if the covariance of the normalized difference is equal to zero:

$$\omega_{11,1}\omega_{12,2} - \omega_{11,2}\omega_{12,1} \stackrel{?}{=} 0.$$

The small-sample properties of this statistic are better than those of the determinant, and in the empirical section this is the one that is used to check the rank condition.

#### 1.a Consistency

Consistent estimates of both covariance matrices imply that the estimate of  $\alpha$  solves the following quadratic equation:

$$(\omega_{11,1}\omega_{12,2} - \omega_{12,1}\omega_{11,2})\hat{\alpha}^2 - (\omega_{11,1}\omega_{22,2} - \omega_{22,1}\omega_{11,2})\hat{\alpha} + (\omega_{12,1}\omega_{22,2}22,2 - \omega_{22,1}\omega_{12,2}) = 0,$$

where

$$\begin{split} &\times \left[ (\beta^2 \sigma_{\eta,1}^2 + \sigma_{\varepsilon,1}^2) (\beta \sigma_{\eta,2}^2 + \alpha \sigma_{\varepsilon,2}^2) \right. \\ &- (\beta \sigma_{\eta,1}^2 + \alpha \sigma_{\varepsilon,1}^2) (\beta^2 \sigma_{\eta,2}^2 + \sigma_{\varepsilon,2}^2) \right], \\ &\omega_{11,1} \omega_{22,2} - \omega_{22,1} \omega_{11,2} = \frac{1}{(1 - \alpha \beta)^2} \\ &\times \left[ (\beta^2 \sigma_{\eta,1}^2 + \sigma_{\varepsilon,1}^2) (\sigma_{\eta,2}^2 + \alpha^2 \sigma_{\varepsilon,2}^2) \right. \\ &- (\sigma_{\eta,1}^2 + \alpha^2 \sigma_{\varepsilon,1}^2) (\beta^2 \sigma_{\eta,2}^2 + \sigma_{\varepsilon,2}^2) \right], \\ &\omega_{12,1} \omega_{22,2} - \omega_{22,1} \omega_{12,2} = \frac{1}{(1 - \alpha \beta)^2 22} \\ &\times \left[ (\beta \sigma_{\eta,1}^2 + \alpha \sigma_{\varepsilon,1}^2) (\sigma_{\eta,2}^2 + \alpha^2 \sigma_{\varepsilon,2}^2) \right. \\ &- (\sigma_{\eta,1}^2 + \alpha^2 \sigma_{\varepsilon,1}^2) (\beta \sigma_{\eta,2}^2 + \alpha \sigma_{\varepsilon,2}^2) \right], \end{split}$$

 $\omega_{11,1}\omega_{12,2} - \omega_{12,1}\omega_{11,2} = \frac{1}{(1-\alpha\beta)^2}$ 

which after some algebra are reduced to

$$\begin{split} \omega_{11,1}\omega_{12,2} - \omega_{12,1}\omega_{11,2} &= \frac{1}{1-\alpha\beta} \left[ -\beta\sigma_{\eta,1}^2\sigma_{\varepsilon,2}^2 + \beta\sigma_{\varepsilon,1}^2\sigma_{\eta,2}^2 \right], \\ \omega_{11,1}\omega_{22,2} - \omega_{22,1}\omega_{11,2} &= \frac{1}{1-\alpha\beta} \left[ -\sigma_{\eta,1}^2\sigma_{\varepsilon,2}^2 (1+\alpha\beta) + \sigma_{\varepsilon,1}^2\sigma_{\eta,2}^2 (1+\alpha\beta) \right], \\ \omega_{12,1}\omega_{22,2} - \omega_{22,1}\omega_{12,2} &= \frac{1}{1-\alpha\beta} \left[ -\alpha\sigma_{\eta,1}^2\sigma_{\varepsilon,2}^2 + \alpha\sigma_{\varepsilon,1}^2\sigma_{\eta,2}^2 \right]. \end{split}$$

Hence, the two solutions to the quadratic equation are

$$\hat{\alpha} = \frac{\left[ (1 + \alpha \beta) \pm (1 - \alpha \beta) \right] \left[ -\sigma_{\eta,1}^2 \sigma_{\varepsilon,2}^2 + \sigma_{\varepsilon,1}^2 \sigma_{\eta,2}^2 \right]}{2\beta \left[ -\sigma_{\eta,1}^2 \sigma_{\varepsilon,2}^2 + \sigma_{\varepsilon,1}^2 \sigma_{\eta,2}^2 \right]},$$

where, under the assumption that the rank condition is satisfied [equation (6) or (7)], the solution of the system of equations is

$$\hat{\alpha} = \frac{(1 + \alpha \beta) \pm (1 - \alpha \beta)}{2\beta}$$

where one solution is  $\hat{\alpha} = \alpha$  and the other one is  $\hat{\alpha} = 1/\beta$ , which are the two permutations of the system of equations. Thus, if  $\sigma_{\eta,1}^2$ ,  $\sigma_{\varepsilon,2}^2$ ,  $\sigma_{\varepsilon,1}^2$ , and  $\sigma_{\eta,2}^2$  are consistently estimated from the data, the consistency of  $\alpha$  is assured. But consistent estimates of the structural variances are indeed obtained from consistent estimates of the reduced-form covariance matrices if the system is linear, the parameters are stable, and the residuals have finite variances.

Furthermore, observe that  $\hat{\alpha}$  is consistent if the relative variances of the structural shocks shift:

$$-\sigma_{\eta,1}^2\sigma_{\varepsilon,2}^2+\sigma_{\varepsilon,1}^2\sigma_{\eta,2}^2\neq 0\quad \Rightarrow\quad \frac{\sigma_{\eta,1}^2}{\sigma_{\varepsilon,1}^2}\neq \frac{\sigma_{\eta,2}^2}{\sigma_{\varepsilon,2}^2},$$

which is the generalization of Philip Wright's (1928) intuition.

#### 2. Proof of Proposition 2

Note that the proposition states a necessary condition, but not a sufficient one. Thus it is stating an order condition. From equation (9), the number of equations is given by the covariance matrix in each regime. This provides N(N+1)/2 equations in each state. The total number of unknowns is as follows: The matrix  $A_{N\times N}$  has N(N-1) parameters; the matrix  $\Gamma_{N\times K}$  has K(N-1) parameters; the number of variances of the common shocks in each state is KS (K variances times S regimes), and the number of the variances of the structural shocks in each regime is NS (N variances times S regimes). Identification, then, requires

$$S \cdot \frac{N(N+1)}{2} \ge N(N-1) + K(N-1) + SK + SN,$$

$$S \ge 2 \frac{(N+K)(N-1)}{N^2-N-2K}$$
.

The inequality (13) indicates the minimum number of states required to obtain identification. Finally, in order for (13) to make sense, there is a minimum number of endogenous variables, which is given by

$$N^2 - N - 2K > 0$$
.

#### 3. Proof of Proposition 3

After some algebra the two covariance matrices can be written in terms of the underlying variances:

$$\Omega_{\mathit{rl}} = \frac{1}{(1-\alpha\beta)^2} \left[ \begin{array}{ccc} \beta^2 \sigma_{\eta,\mathit{rl}}^2 + \sigma_{\varepsilon,\mathit{rl}}^2 & \beta \sigma_{\eta,\mathit{rl}}^2 + \alpha \sigma_{\varepsilon,\mathit{rl}}^2 \\ & & \sigma_{\eta,\mathit{rl}}^2 + \alpha^2 \sigma_{\varepsilon,\mathit{rl}}^2 \end{array} \right],$$

$$\Omega_{r2} = \frac{1}{(1-\alpha\beta)^2} \begin{bmatrix} \beta^2 \sigma_{\eta,r2}^2 + \sigma_{\varepsilon,r2}^2 & \beta \sigma_{\eta,r2}^2 + \alpha \sigma_{\varepsilon,r2}^2 \\ & & \sigma_{\eta,r2}^2 + \alpha^2 \sigma_{\varepsilon,r2}^2 \end{bmatrix},$$

where

$$\begin{split} \sigma_{\eta,r1}^2 &= \lambda_{r1} \sigma_{\eta,1}^2 + (1 - \lambda_{r1}) \sigma_{\eta,2}^2 \text{ and } \sigma_{\epsilon,r1}^2 \\ &= \lambda_{r1} \sigma_{\epsilon,1}^2 + (1 - \lambda_{r1}) \sigma_{\epsilon,2}^2, \end{split} \tag{A1}$$

$$\sigma_{\eta,r2}^2 = (1 - \lambda_{r2})\sigma_{\eta,1}^2 + \lambda_{r2}\sigma_{\eta,2}^2 \text{ and } \sigma_{\epsilon,r2}^2$$

$$= (1 - \lambda_{r2})\sigma_{\epsilon,1}^2 + \lambda_{r2}\sigma_{\epsilon,2}^2.$$
(A2)

Given that the original heteroskedasticity satisfied the rank condition  $(\sigma_{\eta,1}^2\sigma_{\epsilon,2}^2 - \sigma_{\eta,2}^2\sigma_{\epsilon,1}^2 \neq 0)$ , there are two questions to answer: (i) in which circumstances the misspecified model satisfies the rank condition, and (ii) in which circumstances the estimates are consistent. After some algebra,  $\Omega_{r1}$  and  $\Omega_{r2}$  are seen to satisfy equation (6) if and only if

$$\sigma_{\eta,r_1}^2 \sigma_{\epsilon,r_2}^2 \neq \sigma_{\eta,r_2}^2 \sigma_{\epsilon,r_1}^2$$
.

Substituting by the definitions of the variances [equations (A-1) and (A-2)], the rank condition is not satisfied if and only if

$$\lambda_{r1} = 1 - \lambda_{r2}.$$

In other words, the rank condition is not satisfied if the windows are so badly specified that they imply the same weights on the true regimes. Thus, the two computed matrices are identical.

Assume the rank condition is satisfied; then the question is whether the solution of the new system of equations is consistent. Substituting equations (A-1) and (A-2) into equation (5), the estimated  $\hat{\alpha}$  solves

$$\frac{\Phi\beta}{(1-\alpha\beta)^3} \left[ \hat{\alpha}^2 - \left( \frac{1}{\beta} + \alpha \right) \hat{\alpha} + \frac{\alpha}{\beta} \right] = 0, \tag{A3}$$

where

$$\Phi = (\sigma_{n,1}^2 \sigma_{\epsilon,2}^2 - \sigma_{n,2}^2 \sigma_{\epsilon,1}^2)(1 - \lambda_{r1} - \lambda_{r2}).$$

Note that if we assume that the original heteroskedasticity satisfies the rank condition, and that  $\lambda_{r1} \neq 1 - \lambda_{r2}$ , then  $\Phi$  is different from zero. Hence, equation (A-3) solves exactly the same quadratic equation as the well-specified model. Thus consistency is assured if the covariance matrix is consistently estimated. The two solutions are  $\alpha$  and  $1/\beta$ . Therefore, if the regimes are misspecified and the system satisfies the rank condition, then the estimates are consistent.

#### 4. Proof of Proposition 4

The first assumption in the proposition is to guarantee that the original system can be identified if the heteroskedasticity is well specified. In the ill-specified model, identification is achieved if the relative volatilities change. This is equivalent to

$$\delta_{n,r_1} \neq \delta_{n,r_2} \text{ or } \delta_{\epsilon,r_1} \neq \delta_{\epsilon,r_2}.$$
 (A4)

Equation (A-4) indeed guarantees that the two estimated covariance matrices are different. In other words, it guarantees that the order condition will be satisfied; there is heteroskedasticity in the estimated model.

The next question is, as before, what are the conditions for consistency. Substituting into equation (5) for the computed covariance matrices ( $\Omega_{r1}$  and  $\Omega_{r2}$ ), the estimated  $\hat{\alpha}$  satisfies

$$\frac{\sigma_{\eta,0}^2 \sigma_{\epsilon,0}^2 \Phi \beta}{(1-\alpha\beta)^3} \left[ \hat{\alpha}^2 - \left( \frac{1}{\beta} + \alpha \right) \hat{\alpha} + \frac{\alpha}{\beta} \right] = 0, \tag{A5}$$

where

$$\Phi = (1 + \delta_{\epsilon,r1})(1 + \delta_{\eta,r2}) - (1 + \delta_{\epsilon,r2})(1 + \delta_{\eta,r1}).$$

Note that if  $\Phi$  is different from zero, then  $\hat{\alpha}$  solves the same quadratic equation as the original model.  $\Phi$  is different from zero if the condition (A-4) is satisfied and

$$\frac{\delta_{\eta,r1}}{\delta_{\eta,r2}} \neq \frac{\delta_{\epsilon,r1}}{\delta_{\epsilon,r2}}.$$
 (A6)

This condition indicates that the change in the variances across the misspecified regimes cannot be proportional. In other words, it is equivalent to the rank condition discussed before. Again, the two roots solving equation (A-5) are  $\alpha$  and  $1/\beta$ .

In summary, even though the assumed form of the heteroskedasticity implies a smaller number of regimes than those exhibited in the data, the system is identified and its estimates are consistent if and only if the order and rank conditions are satisfied by the misspecified matrices.
