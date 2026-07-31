# **IX. Empirical Example**

To illustrate some of the differences between standard and bias-corrected methods, this section studies a macroeconomic VAR model based on Bernanke and Gertler (1995). The estimated VAR is based on monthly data for the logarithm of industrial production, the logarithm of the consumer price index excluding shelter, the logarithm of commodity prices, and the federal funds rate (in percent), in that order. Each equation of the system includes 12 lags of each variable and an intercept. The sample period is January 1965 through December 1993.19 Figure 7 plots the responses of industrial production, consumer prices (excluding shelter), and the federal funds rate to an unanticipated 1% increase in the federal funds rate. It also shows the upper and lower bounds of the standard bootstrap interval, the asymptotic interval, the bootstrap-after-bootstrap interval, and the Monte Carlo integration interval at the nominal 95% level. The time horizon is 48 months.

One of the key facts in the VAR literature is that a monetary tightening is followed by a sustained decline in output and in the price level. This finding is based on econometric analysis using standard error bands. Figure 7 shows that only the first part of this statement is supported

<sup>19</sup> All data are from CitiBase. The series codes are IP, PRXHS, PWIMSA, and FYFF.

by the bootstrap-after-bootstrap interval. In the left panel, all methods suggest a significant if temporary decline in output in response to the interest rate increase. Differences in the duration of that decline may be as large as 7 months, but the basic pattern is robust. In contrast, in the middle panel results are substantively different across methods. While the bias-corrected interval includes zero for all time horizons, all other intervals suggest a significant negative response of the price level at horizons higher than about 36 months. This example clearly illustrates that using the bias-corrected bootstrap interval can change the way we interpret economic data, even for fairly large samples. It also demonstrates that accounting for bias and skewness need not invalidate the usefulness of VAR analysis in general. The differences between intervals need not always be as spectacular as in the middle panel, and they are rarely so unanimous. For example, consider the short-lived spike in the federal funds rate following a monetary tightening in the right panel. Judging by the bootstrap-after-bootstrap interval, this response is no longer significant after 11 months. However, the Monte Carlo integration interval and the delta method interval show another significant spike at 14 through 16 months. Moreover, about three years after the shock, the standard bootstrap interval falls below zero for 9 months, and the delta method interval turns negative after 48 months.

## **X. Concluding Remarks**

Bias-corrected bootstrap confidence intervals explicitly account for the bias and skewness of the small-sample distribution of the impulse response estimator, while retaining asymptotic validity in stationary autoregressions. Monte Carlo simulations for a wide range of bivariate models show that in small samples the bias-corrected bootstrap interval tends to be more accurate than traditional asymptotic, bootstrap, and Monte Carlo integration intervals. This conclusion appears to be robust to changes in sample size, persistence, lag length, and the shape of the impulse response function. The improved coverage content of the bias-corrected interval does not come at the expense of excessively long intervals. In fact, in some cases the bootstrap-after-bootstrap interval is shorter on average than the Monte Carlo integration interval. These results hold for VAR models estimated in levels, as deviations from a linear time trend, and in first differences. Additional simulations for cointegrated processes and random walk processes estimated in levels established that for reasonable sample sizes the bias-corrected bootstrap interval dominates its competitors even in nonstationary models. Including an additional time trend in the regression tends to worsen the coverage performance of all methods considerably, especially if the true model is nonstationary, but the relative performance is almost always preserved. An empirical example demonstrated that the bias-corrected bootstrap method may lead to economic interpretations of the data that are substantively different from standard methods.

The computational cost of implementing the bootstrapafter-bootstrap method is higher than that for traditional methods, but not unreasonable. For example, constructing the intervals for a standard quarterly VAR(4) system with linear time trend like the one considered by Runkle (1987) takes about 30 minutes on a Pentium 100. Asymptotic bias corrections can further reduce the computational burden of the bias-corrected bootstrap method, but currently exist only for VAR models without deterministic time trends. While the bias-corrected bootstrap interval represents a significant improvement over traditional intervals, its accuracy tends to deteriorate in borderline stationary processes. I discuss possible explanations for this phenomenon, and conjecture that it may be ameliorated by higher order bias corrections. The results of this paper call for further theoretical work to explain the success of bias-corrected bootstrap methods in small samples. In addition, further simulation evidence for much larger VAR systems containing four to eight variables would be useful. Currently nothing is known about the small-sample performance of confidence intervals in such large systems. While the simulation results in this paper are suggestive, they are limited to bivariate systems. Current research also addresses the usefulness of parametric assumptions in resampling and the effects of lag order uncertainty on inference about impulse response estimates.

#### REFERENCES

- Andrews, Donald W. K., ''Exactly Median-Unbiased Estimation of First Order Autoregressive/Unit Root Models,'' *Econometrica* 61 (Jan. 1993), 139–165.
- Andrews, Donald W. K., and Hong-Yuan Chen, ''Approximately Median-Unbiased Estimation of Autoregressive Models,'' *Journal of Business and Economic Statistics* 12 (Apr. 1994), 187–204.
- Basawa, I. V., A. K. Mallik, W. P. Cormick, J. H. Reeves, and R. L. Taylor, ''Bootstrapping Unstable First-Order Autoregressive Processes,'' *Annals of Statistics* 19 (June 1991), 1098–1101.
- Bernanke, Ben S., and Mark Gertler, ''Inside the Black Box: The Credit Channel of Monetary Policy Transmission,'' *Journal of Economic Perspectives* 9 (Fall 1995), 27–48.
- Bose, Arup, ''Edgeworth Correction by Bootstrap in Autoregressions,'' *Annals of Statistics* 16 (Dec. 1988), 1709–1722.
- Campbell, John Y., and N. Gregory Mankiw, ''Are Output Fluctuations Transitory?'' *Quarterly Journal of Economics* 102 (Nov. 1987), 857–880.
- Cooley, Thomas F., and Lee E. Ohanian, ''The Cyclical Behavior of Prices,'' *Journal of Monetary Economics* 28 (Aug. 1991), 25–60.
- Doan, Thomas A., *RATS User's Manual,* Version 3.10 (Evanston, IL: VAR Econometrics, 1990).
- Efron, Bradley, *The Jackknife, the Bootstrap, and Other Resampling Plans* (Philadelphia, PA: Society for Industrial and Applied Mathematics, 1982).
- Efron, Bradley, and Robert J. Tibshirani, *An Introduction to the Bootstrap* (New York: Chapman and Hall, 1993).
- Fackler, James S., ''Federal Credit, Private Credit, and Economic Activity,'' *Journal of Money, Credit, and Banking* 22 (Nov. 1990), 444–464.
- Friedman, Benjamin M., and Kenneth N. Kuttner, ''Money, Income, Prices, and Interest Rates,'' *American Economic Review* 82 (June 1992), 472–492.
- Griffiths, William, and Helmut Lu¨tkepohl, ''Confidence Intervals for Impulse Responses from VAR Models: A Comparison of Asymptotic Theory and Simulation Approaches,'' manuscript, Institut fu¨r Statistik und O¨ konometrie, Humboldt-Universita¨t, Berlin (1993).
- Hall, Peter, *The Bootstrap and Edgeworth Expansion* (New York: Springer, 1992).
- Lu¨tkepohl, Helmut, ''Asymptotic Distributions of Impulse Response Functions and Forecast Error Variance Decompositions of Vector Autoregressive Models,'' this REVIEW 72 (Feb. 1990), 116–125.
- Lu¨tkepohl, Helmut, and Hans-Eggert Reimers, ''Impulse Response Analysis of Cointegrated Systems,'' *Journal of Economic Dynamics and Control* 16 (Jan. 1992), 53–78.
- Mittnik, Stefan, and Peter A. Zadrozny, ''Asymptotic Distributions of Impulse Responses, Step Responses, and Variance Decompositions of Estimated Linear Dynamic Models,'' *Econometrica* 61 (July 1993), 857–870.
- Nicholls, D. F., and A. L. Pope, ''Bias in the Estimation of Multivariate Autoregressions,''*Australian Journal of Statistics* 30A (May 1988), 296–309.
- Phillips, Peter C. B., ''Impulse Response and Forecast Error Variance Asymptotics in Nonstationary VAR's,'' Cowles Foundation Discussion Paper 1102 (June 1995).
- Pope, Alun L., ''Small Sample Bias Problems in Time Series,'' unpublished M.Sc. Thesis, Australian National University (1987).
- ——— ''Biases of Estimators in Multivariate Non-Gaussian Autoregressions,'' *Journal of Time Series Analysis* 11 (1990), 249–258.
- Rudebusch, Glenn D., ''Trends and Random Walks in Macroeconomic Time Series: A Re-Examination,'' *International Economic Review* 33 (Aug. 1992), 661–680.
- ——— ''The Uncertain Unit Root in Real GNP,'' *The American Economic Review* 83 (Mar. 1993), 264–272.
- Runkle, David E., ''Vector Autoregression and Reality,'' *Journal of Business and Economic Statistics* 5 (Oct. 1987), 437–442.
- Shaman, Paul, and Robert A. Stine, ''The Bias of Autoregressive Coefficient Estimators,'' *Journal of the American Statistical Association* 83 (Sept. 1988), 842–848.
- Sims, Christopher A., ''Comment,'' *Journal of Business and Economic Statistics* 5 (Oct. 1987), 443–449.

"Interpreting the Macroeconomic Time Series Facts: The Effects of Monetary Policy," European Economic Review 36 (June 1992), 975-1011.

Sims, Christopher A., and Tao Zha, "Error Bands for Impulse Responses,"

manuscript, Yale University (1995). Stine, Robert A., "Estimating Properties of Autoregressive Forecasts," Journal of the American Statistical Association 82 (Dec. 1987), 1072–1078.

Stock, James H., "Cointegration, Long-Run Comovements, and Long-Horizon Forecasting," manuscript, Kennedy School of Govern-

ment, Harvard University (1995).

Tjøstheim, Dag, and Jostein Paulsen, "Bias of Some Commonly-Used Time Series Estimates," Biometrika 70 (Aug. 1983), 389–399.

### **APPENDIX**

Define  $\beta = \text{vec}(B_1, \dots, B_p)$ . From Pope (1990),  $E(\hat{\beta} - \beta) = b(\hat{\beta})/T + O(T^{-3/2})$ , where  $\hat{\beta}$  denotes the OLS estimator. Let  $\hat{\beta}^*$  denote the corresponding bootstrap OLS estimator. Then  $\hat{\beta} = \hat{\beta} - b(\hat{\beta})/T$  and  $\hat{\beta}^* = \hat{\beta}$  $\hat{\beta}^* - b(\hat{\beta}^*)/T$ . Assuming that b is a continuous and smooth function with bounded derivatives of first and second order,  $b(\hat{\beta})^*/T = b(\hat{\beta})/T +$ 

 $O_P(T^{-3/2})$  by the following argument:

$$\frac{1}{T}[b(\hat{\beta}) - b(\hat{\beta}^*)] = \frac{1}{T}[b(\hat{\beta}) - b(\tilde{\beta})] + \frac{1}{T}[b(\tilde{\beta}) - b(\hat{\beta}^*)].$$
 A.1

A Taylor series expansion for the *j*th element of  $b(\hat{\beta}^*)$  about  $\tilde{\beta}$  for j = 1,  $2, \ldots, N^2 p$  implies

$$b_{j}(\hat{\beta}^{*}) = b_{j}(\tilde{\beta}) + b_{j}'(\hat{\beta}^{*} - \tilde{\beta}) + \frac{1}{2}(\hat{\beta}^{*} - \tilde{\beta})'b_{j}''(\tilde{\beta})(\hat{\beta}^{*} - \tilde{\beta})$$
 A.2

where  $\hat{\beta}^* \leq \overline{\beta} \leq \tilde{\beta}$ . The higher order terms of the expansion can be dropped, provided b is a sufficiently smooth function in its argument. Substituting equation (A.2) into equation (A.1), we obtain

$$\frac{1}{T}[b(\hat{\beta}) - b(\hat{\beta}^*)] = O_P(T^{-2}) + O_P(T^{-3/2}) = O_P(T^{-3/2})$$
 A.1'

where  $b(\hat{\beta}) - b(\tilde{\beta}) = O_p(T^{-1})$  by  $\tilde{\beta} - \hat{\beta} = O_p(T^{-1})$  and where  $b(\tilde{\beta}) - b(\hat{\beta}^*) = O_p(T^{-1/2})$  by  $\hat{\beta}^* - \tilde{\beta} = O_p(T^{-1/2})$ . Abstracting from simulation error, these results carry over to bootstrap bias estimates.