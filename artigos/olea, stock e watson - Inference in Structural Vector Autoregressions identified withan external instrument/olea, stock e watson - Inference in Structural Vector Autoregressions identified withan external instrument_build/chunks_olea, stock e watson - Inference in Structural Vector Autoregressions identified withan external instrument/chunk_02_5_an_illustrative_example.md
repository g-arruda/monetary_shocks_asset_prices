# 5. An illustrative example

<span id="page-8-0"></span>Kilian (2009) used a 3-variable SVAR to investigate the effect of oil-supply and oil-demand shocks on oil production and oil prices. In this section we use Kilian's model and data as a simple example to illustrate the external-instrument methods discussed above. <sup>19</sup>

<span id="page-8-1"></span>The three variables in Kilian's (2009) SVAR are the percent change in global crude oil production (prod), real oil prices (prod), and a global real activity index of dry goods shipments (prod). Kilian uses these variables to identify three structural shocks – oil supply ( $e^{Supply}$ ), aggregate demand ( $e^{Ag.Demand}$ ), and oil-specific demand ( $e^{Oil-Spec.Demand}$ ) – using the Wold causal ordering ( $e^{Supply}$ ,  $e^{Ag.Demand}$ ,  $e^{Oil-Spec.Demand}$ ) in the VAR with variables ordered as (prod, prod, prod). We focus on the oil supply shock identified using the same reduced-form VAR as Kilian (2009), but with an external instrument.

We use Kilian's (2008) measure of "exogenous oil supply shocks" as the external instrument. The instrument measures shortfalls in OPEC oil production associated with wars and civil disruptions. Because this variable measures shortfalls in production, it is plausibly correlated with the structural oil supply shock  $\varepsilon^{Supply}$ , and because it measures shortfalls associated with political events such as wars in the Middle East, it is plausibly uncorrelated with the two oil demand shocks. Thus, Kilian's (2008) measure plausibly satisfies the conditions for an external instrument given in Assumption 1.

Of course, while Assumption 1 implies that the external instrument is valid, the internal validity of the SVAR depends on additional assumptions, notably (2.1) and (2.2). From (2.1), the VAR coefficients are assumed to be time-invariant, and from (2.2), the structural shocks are contemporaneous linear functions of the VAR reduced-form forecast errors:  $\varepsilon_t = \Theta_0^{-1} \eta_t$ . The recent empirical literature using SVARs to model the oil market has questioned both of these assumptions (see Stock and Watson (2016) for discussion). We are sympathetic to these concerns and to the post-Kilian (2009) literature that expands the variables in the VAR (e.g., Aastveit (2014)), and uses sign restrictions to help identify the dynamic effects of oil supply shocks in both frequentist (e.g., Kilian and Murphy (2012)) and Bayes (e.g., Baumeister and Hamilton (2018)) settings. That said, the simplicity of Kilian's (2009) 3-variable time-invariant VAR makes it an ideal framework for illustrating the use of external instruments.

<span id="page-8-2"></span>Kilian's (2009) analysis used monthly data from 1973:M1–2007:M12. The instrument, Kilian's (2008) exogenous oil supply shock series, is available from 1973:M1–2004:M9, and we use the common sample period (1973:M1–2004:M9) for the analysis. Following Kilian (2009), the VAR is estimated using p = 24 lags and a constant term. The covariance matrix W is estimated using a standard Eicker–White robust estimator (equivalently, a Newey–West HAC estimator with 0 lags). The confidence sets presented in Section 3 were based on δ-method approximations that relied on gradients of particular functions with respect to A and  $\Gamma$ . We have created a Matlab suite to implement our confidence set using

<sup>&</sup>lt;sup>19</sup> In Appendix A.7 we provide another short illustrative example where we revisit the question of whether real economic activity in the United States (measured by the Gross Domestic Product, henceforth GDP) responds to cuts in marginal tax rates. We show that the strong-instrument SVAR-IV estimate of the 1-period ahead response of GDP to a tax shock that decreases average marginal tax rates in 1% loses its statistical significance when we use the weak-instrument robust techniques introduced in the paper. The application also shows that not all the results are rendered insignificant. For example, the short-run elasticity of taxable income remains statistically above zero.

We use the common sample period for  $(y_t, z_t)$  for convenience. In principle, the entire sample period can be used to estimate the VAR parameters, and a shorter sample period used to estimate  $\Gamma$ . This entails only a modification in estimator used for the covariance matrix W in Assumption 2.

10

<span id="page-9-2"></span>analytical formulas for these gradients. We also suggest a simple bootstrap-like method that involves sampling ( $\text{vec}(\hat{A}_T)$ ,  $\hat{\Gamma}_T$ ) from an estimated normal distribution consistent with Assumption 2. Details are provided in Appendix A.4.<sup>21</sup>

**Weak-instrument diagnostics.** The statistic  $\xi_1 = T\hat{\Gamma}_{T,1}^2/\hat{W}_{\Gamma,11} = 4.4$  and the robust first-stage statistic is 9.4. Both statistics are below the Staiger-Stock value of 10, suggesting that the instrument is weak. However, because  $\xi_1 > 3.84$  (the 5%  $\chi_1^2$  critical value), the 95% Anderson-Rubin weak-instrument confidence sets for the impulse response coefficients are bounded intervals (see footnote 13).

<span id="page-9-3"></span>**Impulse response coefficients.** Fig. 1 shows the estimated impulse response coefficients and corresponding  $CS^{Plug-in}$  and  $CS^{AR}$  confidence sets. 22 The 68% weak-instrument robust  $CS^{AR}$  confidence sets essentially coincide with the strong-instrument  $CS^{Plug-in}$  intervals, but the 95%  $CS^{AR}$  confidence sets suggest considerably more uncertainty than their strong-instrument counterparts.

An important finding in Kilian (2009), was that Cholesky-identified oil supply shocks had small effects on oil prices. This is evident in panel A, which plots (in red) the estimated impulse response coefficients for the Cholesky-identified shock. The point estimates imply that a Cholesky-identified oil supply shock that increases oil supply by 1% on impact, leads to a fall in prices of 0.03% on impact and has a maximum price effect of -0.07% after four months. In contrast, the corresponding supply shock identified using the external instrument leads to fall in prices of 0.14% on impact and maximum price effect of -0.22% after four months. But, while the external-instrument identified price effects are larger than the Cholesky-identified effect, both are small in an absolute sense, and Kilian's overall conclusion of small price effects is consistent with the external-instrument estimates and associated weak-instrument robust confidence sets.

#### 6. Monte Carlo evidence

<span id="page-9-0"></span>We conduct a simple Monte Carlo exercise to analyze the coverage of the  $CS^{Plug-in}$  and  $CS^{AR}$  confidence sets. The data generating process for the Monte Carlo exercise is parameterized by the matrix of autoregressive coefficients, the matrix of contemporaneous impulse response coefficients, the variance of the structural innovations, and the joint distribution of the external instrument and target shock. We explain our choice of these parameters below.

We consider T=356 observations from a 3-dimensional vector  $Y_t$  generated by a reduced-form VAR model with reduced-form parameters  $(A, \Sigma)$  equal to those estimated from Kilian's (2008) data. The sample size matches the number of observations in Kilian's application.

For the matrix of contemporaneous impulse response coefficients,  $\Theta_0$ , we make the first column equal to  $b/\sqrt{b'\Sigma^{-1}b}$  where  $b=(1\ 1\ -1)'$ . The signs of this vector are in line with the typical interpretation of an expansionary supply shock. The remaining columns of  $\Theta_0$  are chosen to satisfy the equation  $\Theta_0\Theta_0'=\Sigma$ .

We use a linear measurement error model for the external instrument:

$$z_t = \mu_Z + \alpha \varepsilon_{1,t} + \sigma_Z \nu_t$$

The structural shocks  $\varepsilon_t = (\varepsilon_{1,t} \ \varepsilon_{2,t} \ \varepsilon_{3,t})$  and  $\nu_t$  are independent standard normal random variables. The parameters  $\mu_Z$  and  $\sigma_Z$  are chosen to match the first and second moment of Kilian's external instrument. We vary the parameter  $\alpha$  to obtain two different values of the concentration parameter  $(T\alpha)^2/Var(z_t \ \eta_{1,t})$ : 3.7 and 10.09. Our simulations, reported in Fig. 2, show that the coverage of the nominal 95%  $\delta$ -method confidence interval  $(CS^{Plug-in})$  can be as low as 85% for some horizons when the concentration parameter is small. The  $CS^{AR}$  confidence exhibits some distortion (presumably because the critical values are based on large sample approximations), but it is never below 90%. As expected, the coverage of  $CS^{Plug-in}$  improves as the concentration parameter increases.

In Appendix A.5 we also report the coverage of the bootstrap version of the  $CS^{AR}$ . There is a slight improvement in the coverage of  $CS^{AR}$  confidence set, but the difference does not seem substantial. This suggests that although there can be some gain in using critical values that are not computed explicitly using large sample formulas, improved coverage comes from choosing a weak-instrument robust procedure. Finally, we also report simulations for a sample size of T=1500. We use this to show that in a sufficiently large sample the Monte Carlo coverage of  $CS^{AR}$  essentially coincides with the nominal level.

#### 7. Conclusions

<span id="page-9-1"></span>This paper studied SVARs identified using an external instrument. The external instrument was taken to be correlated with the target shock (e.g., the short-fall of OPEC oil production is correlated with the aggregate oil supply shock) and to be uncorrelated with other shocks in the model. Standard estimators for the model's reduced-form parameters (including the

 $<sup>^{21}</sup>$  The bootstrap method is more computationally intensive than the  $\delta$ -method (because it requires re-sampling from the reduced-form parameters and constructing quantiles of a test statistic over a grid of possible values for the impulse response coefficients), but does not require computation of the gradient of the expression in Eq. (2.5). The bootstrap method proposed here, which re-samples the values of the SVAR-IV reduced-form parameters, could be replaced by any other bootstrap procedure, such as the block bootstrap for proxy SVARs proposed by Jentsch and Lunsford (2016).

In appendix A.4 we also compare the CS<sup>AR</sup> reported in Fig. 1 with its bootstrap version.

![](_page_10_Figure_4.jpeg)

**Fig. 1.** Impulse response coefficients for an oil-supply shock.

<span id="page-10-0"></span>covariance of the instrument and the reduced-form errors) are normally distributed in large samples. We provide formulas for SVAR parameters like impulse response coefficients or variance decompositions as a function of these reduced-form parameters. The analysis shows that the large-sample distribution of such SVAR-IV parameter estimators depends on

![](_page_11_Figure_3.jpeg)

![](_page_11_Figure_4.jpeg)

<span id="page-11-0"></span>**Fig. 2.** Coverage rates for nominal 95% confidence intervals. Notes: These figures show coverage rates for nominal 95% *CSPlug*-*in* and *CSAR* confidence sets for impulse responses at horizons 0–20 periods (labeled ''months'' in the figures). The SVAR design is discussed in the text. The experiments use *T* = 356 and 1000 Monte Carlo simulations.

the strength of the instrument. When the instrument is highly correlated with the target structural shock (so that the instrument is strong), standard δ-method arguments imply that SVAR parameter estimators are approximately normally distributed and the usual Wald tests and associated confidence sets have the correct size and coverage probability. However, when the external instrument is weak, the distribution of SVAR parameter estimators is not well approximated by the Normal distribution, so the usual Wald tests and confidence sets are invalid.

This paper shows that confidence sets for impulse response coefficients constructed using [Fieller](#page-12-16) [\(1944\)](#page-12-16) and [Anderson](#page-12-17) [and Rubin](#page-12-17) ([1949\)](#page-12-17) methods are valid when external instruments are weak and asymptotically coincide with the usual confidence sets when instruments are strong and the model is just identified. Thus, these weak-instrument robust confidence sets should routinely be used for impulse response coefficients identified with an external instrument. Along with our weak-instrument robust confidence sets, we suggest that practitioners report either the Wald statistic for the null hypothesis that the external instrument is irrelevant, or the heteroskedasticity-robust first-stage *F* statistic as described in Section [4.2.](#page-7-2) Large values of these statistics (e.g., above 10) suggest approximately valid coverage of standard 95% confidence intervals.

#### **Appendix A. Supplementary data**

Supplementary material related to this article can be found online at [https://doi.org/10.1016/j.jeconom.2020.05.014.](https://doi.org/10.1016/j.jeconom.2020.05.014)

### **References**

<span id="page-12-31"></span><span id="page-12-17"></span>[Aastveit, K.A., 2014. Oil price shocks in a data-rich environment. Energy Econ. 45, 268–279.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb1)

[Anderson, T., Rubin, H., 1949. Estimation of the parameters of a single equation in a complete system of stochastic equations. Ann. Math. Stat. 20,](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb2) [46–63.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb2)

<span id="page-12-26"></span>[Andrews, D.A., Stock, J.H., 2007. Inference with Weak Instruments. In: Blundell, R., Newey, W.K., Persson, T. \(Eds.\), Advances in Economics and](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb3) [Econometrics, Theory and Applications: Ninth World Congress of the Econometric Society. Cambridge University Press, pp. 122–173, Vol III.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb3) [Andrews, I., Stock, J.H., Sun, L., 2018. Weak instruments in IV regression: Theory and practice. manuscript.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb4)

<span id="page-12-33"></span><span id="page-12-14"></span>[Baumeister, C., Hamilton, J.D., 2018. Structural interpretation of vector autoregressions with incomplete identification: Revisiting the role of oil supply](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb5) [and demand shocks. manuscript.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb5)

<span id="page-12-22"></span>[Ben Zeev, N., Pappa, E., 2017. Chronicle of a war foretold: The macroeconomic effects of anticipated defense spending shocks. Econ. J. 127, 603.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb6)

<span id="page-12-21"></span><span id="page-12-16"></span>[Fieller, E.C., 1944. A fundamental formula in the statistics of biological assay, and some applications. Q. J. Pharm. Pharmacol. 17, 117–123.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb7)

[Fisher, J.D.M., Peters, R., 2010. Using stock returns to identify government spending shocks. Econ. J. 120, 414–436.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb8)

<span id="page-12-12"></span><span id="page-12-3"></span>[Gertler, M., Karadi, P., 2015. Monetary policy surprises, credit costs and economic activity. Amer. Econ. J.: Macroecon. 7, 44–76.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb9)

[Hamilton, J.D., 2003. What is an oil shock? J. Econometrics 113, 363–398.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb10)

<span id="page-12-34"></span>[Jentsch, C., Lunsford, K., 2016. Proxy SVARs: Asymptotic Theory, Bootstrap Inference, and the Effects of Income Tax Changes in the United States.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb11) [Working paper, Federal Reserve Bank of Cleveland.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb11)

<span id="page-12-27"></span>[Jentsch, C., Lunsford, K., 2019. Asymptotically Valid Bootstrap Inference for Proxy SVARs. Working paper, Federal Reserve Bank of Cleveland.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb12)

<span id="page-12-29"></span><span id="page-12-19"></span>[Jordà, Ò., 2005. Estimation and inference of impulse responses by local projections. Amer. Econ. Rev. 95 \(1\), 161–182.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb13)

[Kendall, M., Stuart, A., 1979. The Advanced Theory of Statistics, Vol. 2: Inference and Relationship. Griffin, London.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb14)

<span id="page-12-18"></span><span id="page-12-4"></span>[Kilian, L., 2008. Exogenous oil supply shocks: How big are they and how much do they matter for the U.S. economy? Rev. Econ. Stat. 90 \(2\), 216–240.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb15) [Kilian, L., 2009. Not all oil price shocks are alike: Disentangling demand and supply shocks in the crude oil market. Amer. Econ. Rev. 99 \(3\),](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb16) [1053–1069.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb16)

<span id="page-12-32"></span>[Kilian, L., Murphy, D.P., 2012. Why agnostic sign restrictions are not enough: Understanding the dynamics of oil market VAR models. J. Eur. Econom.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb17) [Assoc. 10, 1166–1188.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb17)

<span id="page-12-23"></span><span id="page-12-8"></span>[Kuttner, K.N., 2001. Monetary policy surprises and interest rates: Evidence from the fed funds futures market. J. Monetary Econ. 47, 523–544.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb18) [Lütkepohl, H., 1990. Asymptotic distributions of impulse response functions and forecast error variance decompositions of vector autoregressive](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb19) [models. Rev. Econ. Stat. 72 \(1\), 116–125.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb19)

<span id="page-12-24"></span>[Lütkepohl, H., 2007. General-to-specific or specific-to-general modelling? An opinion on current econometric terminology. J. Econometrics 137 \(1\),](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb20) [319:324.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb20)

<span id="page-12-13"></span>[Mertens, K., Montiel Olea, J.L., 2018. Marginal tax rates and income: New time series evidence. Q. J. Econ. 133 \(4\), 1803–1884.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb21)

<span id="page-12-10"></span>[Mertens, K., Ravn, M.O., 2013. The dynamic effects of personal and corporate income tax changes in the United States. Amer. Econ. Rev. 103 \(4\),](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb22) [1212–1247.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb22)

<span id="page-12-11"></span>[Mertens, K., Ravn, M.O., 2014. Fiscal policy is an expectations-driven liquidity trap. Rev. Econom. Stud. 81 \(4\), 1637–1667.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb23)

<span id="page-12-30"></span>[Montiel Olea, J., Pflueger, C., 2013. A robust test for weak instruments. J. Bus. Econom. Statist. 31, 358–369.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb24)

<span id="page-12-28"></span>[Nelson, C., Startz, R., 1990. Some further results on the exact small sample properties of the instrumental variable estimator. Econometrica 58,](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb25) [967–976.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb25)

<span id="page-12-20"></span>[Plagborg-Møller, M., Wolf, C., 2019. Local Projections and VARs Estimate the Same Impulse Responses. Princeton University, manuscript.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb26)

<span id="page-12-6"></span>[Ramey, V.A., 2011. Identifying government spending shocks: It's all in the timing. Q. J. Econ. 126, 1–50.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb27)

<span id="page-12-9"></span>[Ramey, V.A., 2016. Macroeconomic shocks and their propagation. In: Taylor, J.B., Uhlig, H. \(Eds.\), Handbook of Macroeconomics, Vol. 2A. Elsevier,](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb28) [Amsterdam.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb28)

<span id="page-12-15"></span>[Ramey, V.A., 2019. Ten years after the financial crisis: What have we learned from the renaissance in fiscal research? J. Econ. Perspect. 33 \(2\),](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb29) [89–114.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb29)

<span id="page-12-1"></span>[Ramey, V.A., Shapiro, M.D., 1998. Costly capital reallocation and the effects of government spending. In: Carnegie-Rochester Conference Series on](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb30) [Public Policy, Vol. 48. Elsevier, pp. 145–194.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb30)

<span id="page-12-0"></span>[Romer, C., Romer, D., 1989. Does monetary policy matter? A new test in the spirit of friedman and schwartz. In: NBER Macroeconomics Annual](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb31) [1989, Vol. 4. MIT Press, pp. 112–184.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb31)

<span id="page-12-2"></span>[Romer, C.D., Romer, D.H., 2004. A new measure of monetary shocks: Derivation and implications. Amer. Econ. Rev. 94.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb32)

<span id="page-12-5"></span>[Romer, C.D., Romer, D.H., 2010. The macroeconomic effects of tax changes: Estimates based on a new measure of fiscal shocks. Amer. Econ. Rev.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb33) [100, 763–801.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb33)

<span id="page-12-7"></span>[Rudebusch, G.D., 1998. Do measures of monetary policy in a VAR make sense? Internat. Econom. Rev. 39, 907–931.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb34)

<span id="page-12-25"></span>[Staiger, D., Stock, J., 1997. Instrumental variables regression with weak instruments. Econometrica 65, 557–586.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb35)

- <span id="page-13-0"></span>Stock, J.H., 2008. What Is New in Econometrics: Time Series, Lecture 7. In: Short Course Lectures, NBER Summer Institute, at [http://www.nber.org/](http://www.nber.org/minicourse_2008.html) [minicourse\\_2008.html.](http://www.nber.org/minicourse_2008.html)
- <span id="page-13-1"></span>[Stock, J.H., Watson, M.W., 2012. Disentangling the channels of the 2007-2009 recession. Brook. Pap. Econ. Act. \(1\), 81–135.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb37)
- <span id="page-13-4"></span>[Stock, J.H., Watson, M.W., 2016. Factor models and structural vector autoregressions in macroeconomics. In: Taylor, J.B., Uhlig, H. \(Eds.\), Handbook](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb38) [of Macroeconomics Vol. 2A. Elsevier, Amsterdam.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb38)
- <span id="page-13-3"></span>[Stock, J.H., Watson, M.W., 2018. Identification and estimation of dynamic causal effects in macroeconomics using external instruments. Econom. J.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb39) [128 \(May\), 917–948.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb39)
- <span id="page-13-6"></span>[Stock, J.H., Wright, J.H., 2000. GMM with weak identification. Econometrica 68 \(5\), 1055–1096.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb40)
- <span id="page-13-2"></span>[Stock, J.H., Wright, J.H., Yogo, M., 2002. A survey of weak instruments and weak identification in generalized method of moments. J. Bus. Econom.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb41) [Statist. 20 \(4\), 518–529.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb41)
- <span id="page-13-5"></span>[Stock, J.H., Yogo, M., 2005. Testing for weak instruments in linear IV regression. In: Stock, J.H., Andrews, D.W.K. \(Eds.\), Identification and Inference](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb42) [for Econometric Models: Essays in Honor of Thomas J. Rothenberg. Cambridge University Press, pp. 80–108, Ch. 5.](http://refhub.elsevier.com/S0304-4076(20)30231-1/sb42)