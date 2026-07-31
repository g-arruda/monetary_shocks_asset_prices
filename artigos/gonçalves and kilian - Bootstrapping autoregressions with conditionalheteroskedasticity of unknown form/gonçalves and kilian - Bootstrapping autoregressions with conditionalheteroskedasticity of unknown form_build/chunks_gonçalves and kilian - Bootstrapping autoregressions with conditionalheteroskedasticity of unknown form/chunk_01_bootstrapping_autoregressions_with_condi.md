![](_page_0_Picture_0.jpeg)

Available online at www.sciencedirect.com

![](_page_0_Picture_2.jpeg)

JOURNAL OF Econometrics

Journal of Econometrics 123 (2004) 89-120

www.elsevier.com/locate/econbase

# Bootstrapping autoregressions with conditional heteroskedasticity of unknown form

Sílvia Gonçalves<sup>a,\*,1</sup>, Lutz Kilian<sup>b,c</sup>

<sup>a</sup>CIRANO, CIREQ and Département de Sciences Économiques, Université de Montréal, C.P. 6128, succ. Centre-Ville, Montréal, Canada OC H3C 3J7

<sup>b</sup>CEPR and Department of Economics, University of Michigan, Ann Arbor, MI 48109-1220, USA <sup>c</sup>Directorate General Research, European Central Bank, Kaiserstrasse 29, 60311 Frankfurt am Main, Germany

Accepted 1 August 2003

#### Abstract

Conditional heteroskedasticity is an important feature of many macroeconomic and financial time series. Standard residual-based bootstrap procedures for dynamic regression models treat the regression error as i.i.d. These procedures are invalid in the presence of conditional heteroskedasticity. We establish the asymptotic validity of three easy-to-implement alternative bootstrap proposals for stationary autoregressive processes with martingale difference errors subject to possible conditional heteroskedasticity of unknown form. These proposals are the fixed-design wild bootstrap, the recursive-design wild bootstrap and the pairwise bootstrap. In a simulation study all three procedures tend to be more accurate in small samples than the conventional large-sample approximation based on robust standard errors. In contrast, standard residual-based bootstrap methods for models with i.i.d. errors may be very inaccurate if the i.i.d. assumption is violated. We conclude that in many empirical applications the proposed robust bootstrap procedures should routinely replace conventional bootstrap procedures for autoregressions based on the i.i.d. error assumption.

© 2003 Elsevier B.V. All rights reserved.

JEL classification: C15; C22

Keywords: Bootstrap; Wild bootstrap; Autoregressions; Conditional heteroskedasticity

<sup>\*</sup> Corresponding author. Département de Sciences Économiques, Université de Montréal, CP 6128, succ. Centre-Ville, Montréal Canada QC H3C 3J7.

<sup>&</sup>lt;sup>1</sup> Financial support from FRSC (Fonds de Recherche sur la Société et la Culture) and SSHRCC (Social Sciences and Humanities Research Council of Canada) is gratefully acknowledged.

# 1. Introduction

There is evidence of conditional heteroskedasticity in the residuals of many estimated dynamic regression models in 1nance and in macroeconomics (see, e.g., Engle, 1982; Bollerslev, 1986; Weiss, 1988). This evidence is particularly strong for regressions involving monthly, weekly and daily data. Standard residual-based bootstrapmethods of inference for autoregressions treat the error term as independent and identically distributed (i.i.d.) and are invalidated by conditional heteroskedasticity. In this paper, we analyze two main proposals for dealing with conditional heteroskedasticity of unknown form in autoregressions.

The 1rst proposal is very easy to implement. It involves an application of the wild bootstrap(WB) to the residuals of the dynamic regression model. The WB method allows for regression errors that follow martingale [di5erence sequenc](#page-30-0)[es \(m.d.s.\)](#page-31-0) [with](#page-31-0) possible conditional heteroskedasticity. We investigate both the 1xed-design and the recursive-design implementation of the WB for autoregressions. We prove their 1rst-order asymptotic validity for the autoregressive parameters (and smooth functions thereof) under fairly general conditions including, for example, stationary ARCH, GARCH and stochastic volatility error proces[ses \(see, e.g](#page-31-0)., [Bollerslev](#page-31-0), 1986; [Shephard,](#page-31-0) [1996\).](#page-30-0)

There are several fundamental di5erences between this paper and earlier work on the WB in regression models. First, existing theoretical work has largely focused on providing 1rst- and second-order theoretical justi1cation for the wild bootstrap in the classical linear regression model (see, e.g., Wu, 1986; Liu, 1988; Mammen, 1993; Davidson an[d Flachaire, 2001\). Second, th](#page-30-0)e [previous literature has ma](#page-30-0)inly focused on the problem of unconditional heteroskedas[ticity in cross-s](#page-31-0)ections, whereas we focus on the problem of conditional heteroskedasticity in time series. Third, much of the earlier work has dealt with models restricted under the null hypothesis of a test, whereas we focus on the construction of bootstrapcon1dence intervals from unrestricted regression models (see Davidson and Flachaire, 2001; Godfrey and Orme, 2001).

The work most closely related to ours is Kreiss (1997). Kreiss established the asymp[totic validity o](#page-31-0)f a 1xed-design WB for stationary autoregressions with known 1nite lag order when the error term exhibits a speci1c form of conditional heteroskedasticity. We provide a generalization of this result to m.d.s. errors with possible conditional heteroskedasticity of unknown form. Our results cover as special cases the N-GARCH, t-GARCH and asymmetric GARCH models, as well as stochastic volatility models. Kreiss (1997) also proposed a recursive-design WB, under the name of "modi1ed wild bootstrap", but he did not establish the consistency of this bootstrap proposal for autoregressive processes with conditional heteroskedasticity. We prove the 1rst-order asymptotic validity of the recursive-design WB for 1nite-order autoregressions with m.d.s. errors subject to possible conditional heteroskedasticity of unknown form. The proof holds under slightly stronger assumptions than the proof for the 1xed-design WB.

Tentative simulation evidence shows that the recursive-design WB scheme works well in practice for a wide range of models of conditional heteroskedasticity. In contrast, conventional residual-based resampling schemes for autoregressions based on the i.i.d. error assumption may be very inaccurate in the presence of conditional heteroskedasticity. Moreover, the accuracy of the recursive-design WB method is comparable to that of the recursive-design i.i.d. bootstrap when the true errors are i.i.d. The recur[sive-design WB m](#page-30-0)ethod is typically more accurate in small samples than the 1xed-design WB method. It also tends to be more accurate than the Gaussian large-sample approximation based on robust standard errors.

The second proposal for dealing with conditional heteroskedasticity of unknown form involves the pairwise resampling of the observations. This method was originally suggested by Freedman (1981) for cross-sectional models. We establish the asymptotic validity of this method in the autoregressive context and compare its perf[ormance to](#page-30-0) [that of the](#page-30-0) 1xed-design and of the recursive-design WB. The pairwise bootstrap is less eMcient than the residual-based WB, but—like the 1xed-design WB—it remains valid for a broader range of GARCH processes than the recursive-design WB, including EGARCH, AGARCH and GJR-GARCH processes, which have been proposed speci1 cally to capture asymmetric responses to shocks in asset returns (see, e.g., Engle and Ng (1993) for a review). We 1nd in Monte Carlo simulations that the pairwise bootstrap is typically more accurate than the 1xed-design WB meth[od, but in small sample](#page-30-0)s tends to be somewhat less accurate than the recursive-design WB when the data are persistent. For large samples these di5erences vanish, and the pairwise bootstrap is as accurate as the recursive-design WB.

A third proposal for dealing with conditional heteroskedasticity of unknown form is the resampling of blocks of autoregressive residuals (see, e.g., Berkowitz et al., 2000). No formal theoretical results exist that would justify such a bootstrap proposal. We do not consider this proposal for two reasons. First, in the context of a well-speci1ed parametric model this proposal involves a loss of eMciency relative to the WB because it allows for serial correlation in the error term in addition to conditional heteroskedasticity. Second, the residual-based block bootstraprequires the choice of an additional tuning parameter in the form of the block size. In practice, results may be sensitive to the choice of block size. Although there are data-dependent rules for block size selection, these procedures are very computationally intensive and little is known about their accuracy in small samples. In contrast, the methods we propose are no more computationally burdensome than the standard residual-based algorit[hm](#page-4-0) and very easy to implement.

The paper is organized as follo[ws.](#page-10-0) In Section 2 we provide empirical evidence that casts doubt on the use of the i.i.d. error assumption for autoregressions, and we highlig[ht](#page-17-0) [t](#page-17-0)he limitations of existing bootstrapand asymptotic methods of inference when the autoregressive errors are conditionally heteroskedastic. In Section 3 we describe the bootstrapalgorithms and state our main theoretical results. Details of the proofs are relegated to the appendix. In Section 4, we provide some tentative simulation evidence for the small-sample performance of alternative bootstrap proposals. We conclude in Section 5.

# 2. Evidence against the assumption of i.i.d. errors

Standard residual-based bootstrapmethods of inference for dynamic regression models treat the error term as i.i.d. The i.i.d. assumption does not follow naturally from

<span id="page-3-0"></span>Table 1 Approximate 1nite-sample p-values of the Engle (1982) LM test of the No-ARCH(q) hypothesis (in percent) for monthly autoregressions

| Real T-bill rate                                                                                              | 0.08 | 0.18 | 0.29 | 0.37 |
|---------------------------------------------------------------------------------------------------------------|------|------|------|------|
| Federal funds rate                                                                                            | 3.37 | 0.45 | 0.71 | 0.94 |
| Percent change in oil price                                                                                   | 2.39 | 3.77 | 5.25 | 4.60 |
|                                                                                                               |      |      |      |      |
| Source: Based on 20 000 bootstrap replications under i.i.d. error null hypothesis. All data have been 1ltered |      |      |      |      |
| by a univariate AR model, the lag order of which has been selected by the AIC subject to an upper bound       |      |      |      |      |
| of 12 lags.                                                                                                   |      |      |      |      |

*Source*: Based on 20 000 bootstrap replications under i.i.d. error null hypothesis. All data have been 1ltered by a univariate AR model, the lag order of which has been selected by the AIC subject to an upper bound of 12 lags.

economic [models. Nevertheless, in many cases](#page-30-0) it has proved convenient for theoretical purposes to treat the error term of dynamic regression models as i.i.d. [This would](#page-30-0) [be of l](#page-30-1)ittle concern if actual data were well represented by models with i.i.d. errors. Unfor[tunately, this is](#page-31-0) not [the case in many empirical](#page-30-0) studies. One approach in applied work has been simply to ignore the problem and to treat the error term as i.i.d. (see, e.g., Goetzmann and Jorion, 1993, 1995). An alternative approach has been to impose a parametric model of conditional heteroskedasticity. For example, Bollerslev (1986) models inOation as an autoregressive process with GARCH(1,1) errors. Similarly, Hodrick (1992) and Bekaert and Hodrick (2001) [postulate](#page-31-0) a VAR model with conditionally Gaussian GARCH(1,1) errors. This approach is not without risks. First, it is not clear whether the class of GARCH models adequately captures the conditional heteroskedasticity in the data. Second, even when the class of GARCH models is ap[propriate, in practice,](#page-30-0) t[he precise form of the GARCH mode](#page-30-0)l will be unknown and di5erent speci1cations may yield di5erent results (see [Wolf, 2000](#page-31-0)). Further diMculties arise in the multivariate case. For multivariate GARCH models it is often diMcult to obtain reliable numerical estimates of the GARCH parameters. In response, researchers typically impose ad hoc restrictions on the covariance structure of the model (see, e.g., Bollerslev et al., 1988; Bollerslev, 1990; Bekaert et al., 1997) that call into question the theoretical validity of the estimates (see Ledoit et al., 2001). For these reasons, we argue for a nonparametric treatment of conditional heter[oskedasticity](#page-30-0) [in dynamic](#page-30-0) [regres](#page-30-0)sion models.

Whereas the failure of the i.i.d. assumption is well-documented in empirical 1nance, it is less well known that many monthly macroeconomic variables also exhibit evidence of conditional heteroskedasticity. In fact, both t[he ARCH an](#page-30-0)d the GARCH model were originally motivated by macroeconometric applications (see Engle, 1982; Bollerslev, 1986). The workhorse model of empirical macroeconomics is the linear autoregression. Table 1 illustrates that the errors of monthly autoregressions typically cannot be treated as i.i.d. It shows the results of LM tests of the null of no ARCH in the errors of six univariate monthly autoregressive models (see Engle, 1982). The data are the growth rate of U.S. industrial output, M1 growth, CPI inOation, the real 3-month T-Bill rate, the <span id="page-4-0"></span>nominal Federal Funds rate and the percent change in the price of oil. The data source is FRED, the sample period 1959.1–2001.8, and the autoregressive lag orders have been selected by the AIC. The LM tests strongly reject the assumption of conditional homoskedasticity for the errors of the AR models. Similar results are obtained for a fixed number of 12 lags or of 24 lags.

The evidence of non-i.i.d. errors in Table 1 is important because many methods of inference developed for smooth functions of autoregressive parameters (such as impulse responses) do not allow for conditional heteroskedasticity. For example, standard residual-based bootstrap methods for autoregressions rely on the i.i.d. error assumption and are invalid in the presence of conditional heteroskedasticity, as we will show in the next section. Similarly, the grid bootstrap of Hansen (1999) is based on the assumption of an autoregression with i.i.d. errors. Likewise, standard asymptotic methods for inference in autoregressions rely if not on the i.i.d. assumption, then on the assumption of conditional homoskedasticity. For example, the closed-form solutions for the asymptotic normal approximation of impulse response distributions proposed by Lütkepohl (1990) are based on the assumption of conditional homoskedasticity and hence will be inconsistent in the presence of conditional heteroskedasticity.

In this paper we study several easy-to-implement bootstrap methods that allow inference in autoregressions with possible conditional heteroskedasticity of unknown form. Unlike the standard residual-based bootstrap for models with i.i.d. innovations these bootstrap methods remain valid under the much weaker assumption of m.d.s. innovations, and they do not require the researcher to take a stand on the existence or specific form of conditional heteroskedasticity. For expository purposes we focus on univariate autoregressive models. Analogous results for the multivariate case are possible at the cost of additional notation.

## 3. Theory

Let  $(\Omega, \mathcal{F}, P)$  be a probability space and  $\{\mathcal{F}_t\}$  a sequence of increasing  $\sigma$ -fields of  $\mathcal{F}$ . The sequence of martingale differences  $\{\varepsilon_t, t \in \mathbb{Z}\}$  is defined on  $(\Omega, \mathcal{F}, P)$ , where each  $\varepsilon_t$  is assumed to be measurable with respect to  $\mathcal{F}_t$ . We observe a sample of data  $\{y_{-p+1}, \ldots, y_0, y_1, \ldots, y_n\}$  from the following data generating process (DGP) for the time series  $y_t$ ,

$$\phi(L)y_t = \varepsilon_t, \tag{3.1}$$

where  $\phi(L) = 1 - \phi_1 L - \phi_2 L^2 - \dots - \phi_p L^p$ ,  $\phi_p \neq 0$ , is assumed to have all roots outside the unit circle and the lag order p is finite and known.  $\phi = (\phi_1, \dots, \phi_p)'$  is the parameter of interest, which we estimate by ordinary least squares (OLS) using observations 1 through n:

$$\hat{\phi} = \left(n^{-1} \sum_{t=1}^{n} Y_{t-1} Y'_{t-1}\right)^{-1} n^{-1} \sum_{t=1}^{n} Y_{t-1} y_{t},$$

<span id="page-5-0"></span>where  $Y_{t-1} = (y_{t-1}, \dots, y_{t-p})'$ . In this paper we focus on bootstrap confidence intervals for  $\phi$  that are robust to the presence of conditional heteroskedasticity of unknown form in the innovations  $\{\varepsilon_t\}$ . More specifically, we assume the following condition:

#### Assumption A.

- (i)  $E(\varepsilon_t|\mathscr{F}_{t-1})=0$ , almost surely, where  $\mathscr{F}_{t-1}=\sigma(\varepsilon_{t-1},\varepsilon_{t-2},\ldots)$  is the  $\sigma$ -field generated by  $\{\varepsilon_{t-1}, \varepsilon_{t-2}, \ldots\}$ .
  - (ii)  $E(\varepsilon_t^2) = \sigma^2 < \infty$ .
- (iii)  $\lim_{n\to\infty} n^{-1} \sum_{t=1}^n \mathrm{E}(\varepsilon_t^2 | \mathscr{F}_{t-1}) = \sigma^2 > 0$  in probability. (iv)  $\tau_{r,s} \equiv \sigma^{-4} \mathrm{E}(\varepsilon_t^2 \varepsilon_{t-r} \varepsilon_{t-s})$  is uniformly bounded for all  $t,r \ge 1, \ s \ge 1; \ \tau_{r,r} > 0$ 
  - (v)  $\lim_{n\to\infty} n^{-1} \sum_{t=1}^n \varepsilon_{t-r} \varepsilon_{t-s} \mathrm{E}(\varepsilon_t^2 | \mathscr{F}_{t-1}) = \sigma^4 \tau_{r,s}$  in probability for any  $r \geqslant 1$ ,  $s \geqslant 1$ . (vi)  $\mathrm{E}|\varepsilon_t|^{4r}$  is uniformly bounded, for some r > 1.

Assumption A replaces the usual i.i.d. assumption on the errors  $\{\varepsilon_t\}$  by the less restrictive martingale difference sequence assumption. In particular, Assumption A allows for dependent, but uncorrelated errors. It does not impose conditional homoskedasticity on the sequence  $\{\varepsilon_t\}$ , although it requires  $\{\varepsilon_t\}$  to be covariance stationary. Assumption A covers a variety of conditionally heteroskedastic models such as ARCH, GARCH, EGARCH and stochastic volatility models (see, e.g. Deo (2000), who shows that a stronger version of Assumption A is satisfied for stochastic volatility and GARCH models). Assumptions (iv) and (v) restrict the fourth-order cumulants of  $\varepsilon_t$ .

Recently, Kuersteiner (2001) derived the asymptotic distribution of efficient instrumental variables estimators in the context of ARMA models with martingale difference errors that are strictly stationary and ergodic, and that satisfy a summability condition on the fourth-order cumulants. His result also applies to the OLS estimator in the AR model as a special case. In Theorem 3.1, we provide an alternative derivation of the asymptotic distribution of the OLS estimator of the AR model under the slightly less restrictive Assumption A. We use Kuersteiner's (2001) notation to characterize the asymptotic covariance matrix of  $\hat{\phi}$ . Using  $\phi^{-1}(L) = \sum_{j=0}^{\infty} \psi_j L^j$ , we let  $b_j = (\psi_{j-1}, \dots, \psi_{j-p})'$  with  $\psi_0 = 1$  and  $\psi_j = 0$  for j < 0. The coefficients  $\psi_j$  satisfy the recursion  $\psi_s - \phi_1 \psi_{s-1} - \cdots - \phi_p \psi_{s-p} = 0$  for all s > 0 and  $\psi_0 = 1$ . We let  $\Rightarrow$  denote convergence in distribution throughout.

**Theorem 3.1.** Under Assumption A,  $\sqrt{n}(\hat{\phi} - \phi) \Rightarrow N(0, C)$ , where

$$C = A^{-1}BA^{-1}$$
.

$$A = \sigma^2 \sum_{j=1}^{\infty} b_j b'_j$$
 and  $B = \sigma^4 \sum_{i=1}^{\infty} \sum_{j=1}^{\infty} b_i b'_j \tau_{i,j}$ .

The asymptotic covariance matrix of  $\hat{\phi}$  is of the traditional "sandwich" form, where  $A = \mathbb{E}(n^{-1}\sum_{t=1}^n Y_{t-1}Y_{t-1}')$  and  $B = Var(n^{-1/2}\sum_{t=1}^n Y_{t-1}\varepsilon_t)$ . Under conditional homoskedasticity,  $B = \sigma^2 A$ . In particular, by application of the law of iterated expectations, we have that  $\tau_{i,i} \equiv \sigma^{-4}\mathbb{E}(\varepsilon_t^2 \varepsilon_{t-i}^2) = \sigma^{-4}\mathbb{E}(\varepsilon_{t-i}^2 \mathbb{E}(\varepsilon_t^2 | \mathscr{F}_{t-1})) = \sigma^{-4}\mathbb{E}(\varepsilon_{t-i}^2 \sigma^2) =$  1 for all  $i=1,2,\ldots$ . Similarly, we can show that  $\tau_{i,j}=0$  for all  $i\neq j$ . Thus, for instance in the AR(1) case, the asymptotic variance of  $\hat{\phi}=\hat{\phi}_1$  simplifies to  $C=(\sigma^2\sum_{i=0}^{\infty}\psi_i^2)^{-2}(\sigma^4\sum_{i=0}^{\infty}\psi_i^2)=1-\phi_1^2$ .

The validity of any bootstrap method in the context of autoregressions with conditional heteroskedasticity depends crucially on the ability of the bootstrap to allow consistent estimation of the asymptotic covariance matrix C. The standard residual-based bootstrap method fails to do so by not correctly mimicking the behavior of the fourth-order cumulants of  $\varepsilon_t$  in the conditionally heteroskedastic case, as we now show. Let  $\hat{\varepsilon}_t^*$  be resampled with replacement from the centered residuals. The standard residual-based bootstrap builds  $y_t^*$  recursively from  $\hat{\varepsilon}_t^*$  according to

$$y_t^* = Y_{t-1}^{*'} \hat{\phi} + \hat{\varepsilon}_t^*, \quad t = 1, ..., n,$$

where  $Y_{t-1}^* = (y_{t-1}^*, \dots, y_{t-p}^*)'$ , given appropriate initial conditions. The recursive-design i.i.d. bootstrap analogues of A and B are  $A_{\mathrm{riid}}^* = n^{-1} \sum_{t=1}^n \mathrm{E}^*(Y_{t-1}^*Y_{t-1}^{*\prime})$  and  $B_{\mathrm{riid}}^* = Var^*(n^{-1/2} \sum_{t=1}^n Y_{t-1}^* \hat{\varepsilon}_t^*)$ , respectively. Because  $\hat{\varepsilon}_t^*$  is i.i.d.  $(0, \hat{\sigma}^2)$ , where  $\hat{\sigma}^2 = n^{-1} \sum_{t=1}^n (\hat{\varepsilon}_t - \bar{\varepsilon})^2$ ,  $\hat{\varepsilon}_t^*$  and  $Y_{t-1}^*$  are (conditionally) independent, and

$$B_{\text{riid}}^* = n^{-1} \sum_{t=1}^n E^*(Y_{t-1}^* Y_{t-1}^{*'} \ \hat{\varepsilon}_t^{*2}) = n^{-1} \sum_{t=1}^n E^*(Y_{t-1}^* Y_{t-1}^{*'}) \ E^*(\hat{\varepsilon}_t^{*2}) = \hat{\sigma}^2 A_{\text{riid}}^*.$$

Thus, the bootstrap analogue of C,  $C^*_{\text{riid}} \equiv A^{*-1}_{\text{riid}} B^*_{\text{riid}} A^{*-1}_{\text{riid}} = \hat{\sigma}^2 A^{*-1}_{\text{riid}}$ , converges in probability to  $\sigma^2 A^{-1}$ , implying that the limiting distribution of the recursive i.i.d. bootstrap is  $N(0,\sigma^2 A^{-1})$ . As Theorem 3.1 shows,  $\sigma^2 A^{-1}$ , however, is *not* the correct asymptotic covariance matrix of  $\hat{\phi}$  without imposing further conditions, e.g., that  $\varepsilon_t$  is conditionally homoskedastic. In the general, conditionally heteroskedastic case, B depends on  $\sigma^4 \tau_{i,j}$ . The recursive-design i.i.d. bootstrap implies  $E^*(\hat{\varepsilon}^*_{t-i}\hat{\varepsilon}^*_{t-j}\hat{\varepsilon}^{*2}_t) = \hat{\sigma}^4$  when i=j and zero otherwise, and thus implicitly sets  $\tau_{i,j}=1$  for i=j and  $\tau_{i,j}=0$  for  $i\neq j$ .

Given the failure of the standard-residual based bootstrap, we are interested in establishing the first-order asymptotic validity of three alternative bootstrap methods in this environment. Two of the bootstrap methods we study rely on an application of the wild bootstrap (WB). The WB has been originally developed by Wu (1986), Liu (1988) and Mammen (1993) in the context of static linear regression models with (unconditionally) heteroskedastic errors. We consider both a recursive-design and a fixed-design version of the WB. The third method is a natural generalization of the pairwise bootstrap for linear regression first suggested by Freedman (1981) for cross-sectional data.

#### 3.1. Recursive-design wild bootstrap

The recursive-design WB is a simple modification of the usual recursive-design bootstrap method for autoregressions (see, e.g., Bose, 1988) which consists of replacing Efron's i.i.d. bootstrap by the wild bootstrap when bootstrapping the errors of the AR model. More specifically, the recursive-design WB bootstrap generates a pseudo time series  $\{y_t^*\}_{t=1}^n$  according to the autoregressive process:

$$y_t^* = Y_{t-1}^{*\prime} \hat{\phi} + \hat{\varepsilon}_t^*, \quad t = 1, \dots, n,$$

where  $\hat{\varepsilon}_t^* = \hat{\varepsilon}_t \eta_t$ , with  $\hat{\varepsilon}_t = \hat{\phi}(L) y_t$ , and where  $\eta_t$  is an i.i.d. sequence with mean zero and variance one such that  $E^* |\eta_t|^4 \leq \Delta < \infty$ . We let  $y_t^* = 0$  for all  $t \leq 0$ . Kreiss (1997) suggested this method in the context of autoregressive models with i.i.d. errors, but did not investigate its theoretical justification in more general models. Here, we will provide conditions for the asymptotic validity of the recursive-design WB proposal for finite-order autoregressive processes with possibly conditionally heteroskedastic errors.

Establishing the validity of the recursive-design WB requires a strengthening of Assumption A. Specifically, we need Assumption A' below in order to ensure convergence of the bootstrap estimator of the asymptotic covariance matrix C to its correct limit. In contrast, the fixed-design WB and the pairwise bootstrap to be discussed later are valid under the less restrictive Assumption A.

#### Assumption A'.

- (iv')  $E(\varepsilon_t^2 \varepsilon_{t-r} \varepsilon_{t-s}) = 0$  for all  $r \neq s$ , for all  $t, r \geqslant 1$ ,  $s \geqslant 1$ .
- (vi')  $E|\varepsilon_t|^{4r}$  is uniformly bounded for some  $r \ge 2$  and for all t.

Assumption A' restricts the class of conditionally heteroskedastic autoregressive models in two dimensions. First, Assumption A'(iv') requires  $\tau_{r,s} = 0$  for all  $r \neq s$ . Milhøj (1985) shows that this assumption is satisfied for the ARCH(p) model with innovations having a symmetric distribution. Bollerslev (1986) and He and Teräsvirta (1999) extend the argument to the GARCH(p,q) case. In addition, Deo (2000) shows that this assumption is satisfied by certain stochastic volatility models. Assumption A'(iv') excludes some non-symmetric parametric models such as asymmetric EGARCH. Second, we now require the existence of at least eight moments for the martingale difference sequence  $\{\varepsilon_t\}$  as opposed to only 4r moments, for some r > 1, as in Assumption A. A similar moment condition was used by Kreiss (1997) in his Theorem 4.3, which shows the validity of the recursive-design WB for possibly infinite-order AR processes with i.i.d. innovations.

The strengthening of Assumption A is crucial to showing the asymptotic validity of the recursive-design WB in the martingale difference context. In particular, conditional on the data, and given the independence of  $\{\eta_t\}$ ,  $\{Y_{t-1}^*\hat{\epsilon}_t^*, \mathscr{F}_t^*\}$  can be shown to be a vector m.d.s., where  $\mathscr{F}_t^* = \sigma(\eta_t, \eta_{t-1}, \ldots, \eta_1)$ . We use Assumption A'(vi') to ensure convergence of  $n^{-1}\sum_{t=1}^n Y_{t-1}^*Y_{t-1}^{*'}\hat{\epsilon}_t^{*2}$  to  $B_{\text{rwb}}^* \equiv Var^*(n^{-1/2}\sum_{t=1}^n Y_{t-1}^*\hat{\epsilon}_t^*)$ , thus verifying one of the conditions of the CLT for m.d.s. Assumption A'(iv') ensures convergence of the recursive-design WB variance  $B_{\text{rwb}}^*$  to the correct limiting variance of  $n^{-1/2}\sum_{t=1}^n Y_{t-1}\varepsilon_t$ . More specifically, letting  $Y_{t-1}^* \equiv \sum_{j=1}^{t-1} \hat{b}_j\hat{\epsilon}_{t-j}^*$  with  $\hat{b}_j \equiv (\hat{\psi}_{j-1}, \ldots, \hat{\psi}_{j-p})'$ ,  $\hat{\psi}_0 = 1$  and  $\hat{\psi}_j = 0$  for j < 0, it follows by direct evaluation that

$$B_{\text{rwb}}^* = n^{-1} \sum_{t=1}^n \sum_{j=1}^{t-1} \sum_{i=1}^{t-1} \hat{b}_j \hat{b}_i' \mathbf{E}^* (\hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_{t-i}^* \hat{\varepsilon}_t^{*2}),$$

where  $E^*(\hat{\varepsilon}_{t-j}^*\hat{\varepsilon}_{t-i}^*\hat{\varepsilon}_t^{*2}) = \hat{\varepsilon}_{t-i}^2\hat{\varepsilon}_t^2$  for i=j and zero otherwise. We can rewrite  $B_{\text{rwb}}^*$  as  $\sum_{j=1}^{n-1} \hat{b}_j \hat{b}_j' \eta^{-1} \sum_{t=1+j}^n \hat{\varepsilon}_t^2 \hat{\varepsilon}_{t-j}^2$ , which converges in probability to  $\tilde{B} \equiv \sum_{j=1}^{\infty} b_j b_j' \sigma^4 \tau_{jj}$  under Assumption A. Without Assumption A'(iv') an asymptotic bias term appears in the estimation of  $B \equiv \sigma^4 \sum_{i=1}^{\infty} \sum_{j=1}^{\infty} b_i b_j' \tau_{i,j}$ , which is equal to  $-\sigma^4 \sum_{i\neq j} b_i b_j' \tau_{i,j}$ .

<span id="page-8-0"></span>Assumption A'(iv') sets  $\tau_{i,j}$  equal to zero for  $i \neq j$ , and thus ensures that the recursive-design WB consistently estimates B.

Theorem 3.2 formally establishes the asymptotic validity of the recursive-design WB for finite-order autoregressions with conditionally heteroskedastic errors. Let  $\hat{\phi}_{\text{rwb}}^*$  denote the recursive-design WB OLS estimator, i.e.,  $\hat{\phi}_{\text{rwb}}^* = (n^{-1} \sum_{t=1}^n Y_{t-1}^* Y_{t-1}^*)^{-1} n^{-1} \sum_{t=1}^n Y_{t-1}^* y_t^*$ .

**Theorem 3.2.** Under Assumption A strengthened by Assumption A'(iv') and (vi'), it follows that

$$\sup_{x \in \mathbb{R}^p} |P^*(\sqrt{n}(\hat{\phi}^*_{\text{rwb}} - \hat{\phi}) \leqslant x) - P(\sqrt{n}(\hat{\phi} - \phi) \leqslant x)| \stackrel{P}{\to} 0,$$

where  $P^*$  denotes the probability measure induced by the recursive-design WB.

# 3.2. Fixed-design wild bootstrap

The fixed-design WB generates  $\{y_t^*\}_{t=1}^n$  according to the equation

$$y_t^* = Y_{t-1}' \hat{\phi} + \hat{\varepsilon}_t^*, \quad t = 1, \dots, n,$$
 (3.2)

where  $\hat{\varepsilon}_t^* = \hat{\varepsilon}_t \eta_t$ ,  $\hat{\varepsilon}_t = \hat{\phi}(L) y_t$ , and where  $\eta_t$  is an i.i.d. sequence with mean zero and variance one such that  $E^* |\eta_t|^{2r} \leq \Delta < \infty$ , for some r > 1. The fixed-design WB estimator is  $\hat{\phi}_{\text{fwb}}^* = (n^{-1} \sum_{t=1}^n Y_{t-1} Y_{t-1}')^{-1} n^{-1} \sum_{t=1}^n Y_{t-1} y_t^*$ . The fixed-design WB corresponds to a regression-type bootstrap method in that (3.2) is a fixed-design regression model, conditional on the original sample. A similar "fixed-regressor bootstrap" has also been proposed by Hansen (2000) in the context of testing for structural change in regression models. The fixed-design WB was originally suggested by Kreiss (1997). Kreiss' (1997) Theorem 4.2 proves the first-order asymptotic validity of the fixed-design WB for finite-order autoregressions with conditional heteroskedasticity of a specific form. More specifically, he postulates a DGP of the form  $y_t = \sum_{i=1}^p \phi_i y_{t-i} + \sigma(y_{t-1})v_t$ , where  $v_t$  is i.i.d. (0,1) with finite fourth moment. The i.i.d. assumption on the rescaled innovations  $v_t$  is violated if for instance the conditional moments of  $v_t$  depend on past observations. We prove the first-order asymptotic validity of the fixed-design WB of Kreiss (1997) under a broader set of regularity conditions, namely Assumption A.

**Theorem 3.3.** *Under Assumption* A,

$$\sup_{x \in \mathbb{R}^p} \left| P^*(\sqrt{n}(\hat{\phi}_{\text{fwb}}^* - \hat{\phi}) \leqslant x) - P(\sqrt{n}(\hat{\phi} - \phi) \leqslant x) \right| \stackrel{P}{\to} 0,$$

where  $P^*$  denotes the probability measure induced by the fixed-design WB.

In contrast to the recursive-design WB, the ability of the fixed-design WB to estimate consistently the variance, and hence the limiting distribution, of  $\hat{\phi}$  does not require a strengthening of Assumption A. Specifically, the variance of the limiting conditional bootstrap distribution of  $\hat{\phi}_{\text{fwb}}^*$  is given by  $A_{\text{fwb}}^{*-1}B_{\text{fwb}}^*A_{\text{fwb}}^{*-1}$ , where  $A_{\text{fwb}}^* = n^{-1}\sum_{t=1}^n Y_{t-1}Y_{t-1}'$  and  $B_{\text{fwb}}^* \equiv Var^*(n^{-1/2}\sum_{t=1}^n Y_{t-1}\hat{\varepsilon}_t^*) = n^{-1}\sum_{t=1}^n Y_{t-1}Y_{t-1}'\hat{c}_t^2$ .

<span id="page-9-0"></span>Under Assumption A one can show that  $A_{\text{fwb}}^* \xrightarrow{P} A$  and  $B_{\text{fwb}}^* \xrightarrow{P} B$ , thus ensuring that  $A_{\text{fwb}}^{*-1} B_{\text{fwb}}^* A_{\text{fwb}}^{*-1} \xrightarrow{P} A^{-1} B A^{-1} \equiv C$ .

# 3.3. Pairwise bootstrap

Another bootstrap method that captures the presence of conditional heteroskedasticity in autoregressive models consists of bootstrapping "pairs", or tuples, of the dependent and the explanatory variables in the autoregression. This method is an extension of Freedman's (1981) bootstrap method for the correlation model to the autoregressive context. In the AR(p) model, it amounts to resampling with replacement from the set of tuples  $(y_t, Y'_{t-1}) = (y_t, y_{t-1}, \dots, y_{t-p}), t = 1, \dots, n$ . Let  $\{(y_t^*, Y_{t-1}^{*'}) = (y_t^*, y_{t-1}^*, \dots, y_{t-p}^*), t = 1, \dots, n\}$  be an i.i.d. resample from this set. Then the pairwise bootstrap estimator is defined by  $\hat{\phi}_{pb}^* = (n^{-1} \sum_{t=1}^n Y_{t-1}^* Y_{t-1}^{*'})^{-1} n^{-1} \sum_{t=1}^n Y_{t-1}^* y_t^*$ . The bootstrap analogue of  $\phi$  is  $\hat{\phi}$ , since  $\hat{\phi}$  is the parameter value that minimizes  $E^*[(y_t^* - Y_{t-1}^{*'}\phi)^2]$ . The following theorem establishes the asymptotic validity of the pairwise bootstrap for the AR(p) process with m.d.s. errors satisfying Assumption A.

**Theorem 3.4.** Under Assumption A, it follows that

$$\sup_{x \in \mathbb{R}^p} |P^*(\sqrt{n}(\hat{\phi}_{pb}^* - \hat{\phi}) \leqslant x) - P(\sqrt{n}(\hat{\phi} - \phi) \leqslant x)| \stackrel{P}{\to} 0,$$

where  $P^*$  denotes the probability measure induced by the pairwise bootstrap.

## 3.4. Asymptotic validity of bootstrapping the studentized slope parameter

Corollary 3.1 below establishes the asymptotic validity of bootstrapping the *t-statistic* for the elements of  $\phi$ . To conserve space, we let  $\hat{\phi}^*$  denote the OLS estimator of  $\phi$  obtained under any of the three robust bootstrap resampling schemes studied above. Similarly, we use  $(y_t^*, Y_{t-1}^{*\prime})$  to denote bootstrap data in general. In particular, we implicitly set  $Y_{t-1}^* = Y_{t-1}$  for the fixed-design WB.

For a typical element  $\phi_j$  a bootstrap percentile-t confidence interval is based on  $t_{\hat{\phi}_j^*} = \sqrt{n}(\hat{\phi}_j^* - \hat{\phi}_j)/\sqrt{\hat{C}_{jj}^*}$ , the bootstrap analogue of the t-statistic  $t_{\hat{\phi}_j} = \sqrt{n}(\hat{\phi}_j - \phi_j)/\sqrt{\hat{C}_{jj}}$ . In the context of (conditional) heteroskedasticity,  $\hat{C}_{jj}$  and  $\hat{C}_{jj}^*$  are the heteroskedasticity-consistent variance estimators evaluated on the original and on the bootstrap data, respectively. Specifically, for the bootstrap t-statistic let

$$\hat{C}^* = \hat{A}^{*-1} \hat{B}^* \hat{A}^{*-1}, \quad \text{with}$$

$$\hat{A}^* = n^{-1} \sum_{t=1}^n Y_{t-1}^* Y_{t-1}^{*\prime} \quad \text{and} \quad \hat{B}^* = n^{-1} \sum_{t=1}^n Y_{t-1}^* Y_{t-1}^{*\prime} \ \tilde{\varepsilon}_t^{*2},$$

where  $\tilde{\varepsilon}_t^* = y_t^* - \hat{\phi}^{*\prime} Y_{t-1}^*$  are the bootstrap residuals.

<span id="page-10-0"></span>**Corollary 3.1.** Assume Assumption A holds. Then, for the fixed-design WB and the pairwise bootstrap, it follows that

$$\sup_{x \in \mathbb{R}} \left| P^*(t_{\hat{\phi}_j^*} \leqslant x) - P(t_{\hat{\phi}_j} \leqslant x) \right| \xrightarrow{P} 0, \quad j = 1, \dots, p.$$

If Assumption A is strengthened by Assumption A'(iv') and (vi'), then the above result also holds for the recursive-design WB.

#### 4. Simulation evidence

In this section, we study the accuracy of the bootstrap approximation proposed in Section 3 for sample sizes of interest in applied work. We focus on the AR(1) model as the leading example of an autoregressive process. The DGP is  $y_t = \phi_1 y_{t-1} + \varepsilon_t$  with  $\phi_1 \in \{0, 0.9\}$ . In our simulation study we allow for GARCH(1,1) errors of the form  $\varepsilon_t = \sqrt{h_t} v_t$ , where  $v_t$  is i.i.d. N(0,1) and  $h_t = \omega + \alpha \varepsilon_{t-1}^2 + \beta h_{t-1}$ ,  $t=1,\ldots,n$ . We normalize the unconditional variance of  $\varepsilon_t$  to one. In addition to conditional N(0,1) innovations we also consider GARCH models with conditional  $t_5$ -errors (suitably normalized to have unit variance). For  $\beta = 0$  this model reduces to an ARCH(1) model. For  $\alpha = 0$  and  $\beta = 0$  the error sequence reduces to a sequence of (possibly non-Gaussian) i.i.d errors. We allow for varying degrees of volatility persistence modeled as GARCH processes with  $\alpha + \beta \in \{0, 0.5, 0.95, 0.99\}$ . The parameter settings for  $\alpha$  and  $\beta$  are similar to settings found in applied work. In addition, we consider AR(1) models with exponential GARCH errors (EGARCH), asymmetric GARCH errors (AGARCH) and with the GJR-GARCH errors proposed by Glosten et al. (1993). Our parameter settings are based on Engle and Ng (1993).

Finally, we also consider the stochastic volatility model  $\varepsilon_t = v_t \exp(h_t)$  with  $h_t = \lambda h_{t-1} + 0.5u_t$ , where  $|\lambda| < 1$  and  $(u_t, v_t)$  is a sequence of independent bivariate normal random variables with zero mean and covariance matrix  $diag(\sigma_u^2, 1)$ . This model is a m.d.s. model and satisfies Assumption A. We follow Deo (2000) in postulating the values (0.936, 0.424) and (0.951, 0.314) for  $(\lambda, \sigma_u)$ . These are values obtained by Shephard (1996) by fitting this stochastic volatility model to real exchange rate data.

We generate repeated trials of length  $n \in \{50, 100, 200, 400\}$  from these processes and conduct bootstrap inference based on the fitted AR(1) model for each trial. All fitted models include an intercept. For the recursive-design bootstrap methods, we generate the start-up values by randomly drawing observations with replacement from the original data set (see, e.g. Berkowitz and Kilian, 2000). The number of Monte Carlo trials is 10,000 with 999 bootstrap replications each. The fixed-design and recursive-design WB involve applying the WB to the residuals of the fitted model. Recall that the WB innovation is  $\hat{\varepsilon}_t^* = \hat{\varepsilon}_t \eta_t$ , with  $\hat{\varepsilon}_t = y_t - \hat{\phi}_0 - \hat{\phi}_1 y_{t-1}$ , where  $\eta_t$  is an i.i.d. sequence with mean zero and variance one such that  $E^* |\eta_t|^4 \le \Delta < \infty$ . In practice, there are several choices for  $\eta_t$  that satisfy these conditions. In the baseline simulations we use  $\eta_t \sim N(0,1)$ . Our results are robust to alternative choices, as will be shown at the end of this section.

We are interested in studying the coverage accuracy of nominal 90% symmetric percentile-t bootstrap confidence intervals for the slope parameter  $\phi_1$ . We also considered equal-tailed percentile-t intervals, but found that symmetric percentile-t intervals of the form

$$\left(\hat{\phi}_1 - t_{0.9}^* n^{-1/2} \sqrt{\hat{C}_{11}}, \hat{\phi}_1 + t_{0.9}^* n^{-1/2} \sqrt{\hat{C}_{11}}\right),\,$$

where  $\Pr(|t_{\hat{\phi}_1^*}| \leq t_{0.9}^*) = 0.9$ , virtually always were slightly more accurate. Unlike the percentile interval, the construction of the bootstrap-t interval requires the use of an estimate of the standard error. We use the heteroskedasticity-robust estimator of the covariance proposed by Nicholls and Pagan (1983) based on work by Eicker (1963) and White (1980):

$$(X'X)^{-1}X' diag(\hat{\varepsilon}_t^2)X(X'X)^{-1},$$

where *X* denotes the regressor matrix of the AR model. We also experimented with several modified robust covariance estimators (see MacKinnon and White, 1985; Chesher and Jewitt, 1987; Davidson and Flachaire, 2001). For our sample sizes, none of these estimators performed better than the basic estimator proposed by Nicholls and Pagan (1983). Finally, virtually identical results were obtained based on WB bootstrap standard error estimates. The latter approach involves a nested bootstrap loop and is not recommended for computational reasons. As a benchmark we also include the coverage rates of the Gaussian large-sample approximation based on Nicholls–Pagan robust standard errors.

The simulation results are in Tables 2–5. Starting with the results for N-GARCH errors in Table 2, several broad tendencies emerge. First, the accuracy of the standard recursive-design bootstrap procedure based on i.i.d. resampling of the residuals is high when the model errors are truly i.i.d., but can be very poor in the presence of N-GARCH. In the latter case, accuracy tends to deteriorate for large n. Second, for sample sizes of 100 or larger, conventional large-sample approximations based on robust standard errors tend to be more accurate than the recursive-design i.i.d. bootstrap in the presence of N-GARCH, but less accurate for models with i.i.d. errors. In either case, the coverage rates may be substantially below the nominal level. Third, all three robust bootstrap methods tend to be more accurate than the i.i.d. bootstrap or the conventional Gaussian approximation, when the errors are conditionally heteroskedastic. Fourth, for persistent processes, the accuracy of the recursive-design WB is typically higher than that of the pairwise bootstrap. For large n these differences vanish and both methods are about equally accurate. The accuracy of the recursive-design wild bootstrap is comparable to that of the recursive-design i.i.d. bootstrap for models with i.i.d. errors. The fixed-design WB is typically less accurate than the recursive-design WB and the pairwise bootstrap, although the discrepancies diminish for large n.

The results for the AR(1) model with  $t_5$ -GARCH errors in Table 3 are qualitatively similar, except that the accuracy of the recursive-design i.i.d. bootstrap tends to be even lower than for N-GARCH processes. In Table 4 we explore a number of additional models of conditional heteroskedasticity that have been used primarily to model returns in empirical finance. The results for the stochastic volatility model

<span id="page-12-0"></span>Table 2 Coverage rates of nominal 90% symmetric percentile-t intervals for  $\phi_1$ : AR(1)-N-GARCH model

| n   | $\phi_1$ | $\alpha + \beta$ | α    | β    | Recursive i.i.d. | Recursive<br>WB | Fixed<br>WB | Pairwise | Robust SE<br>Gaussian |
|-----|----------|------------------|------|------|------------------|-----------------|-------------|----------|-----------------------|
| 50  | 0        | 0                | 0    | 0    | 89.1             | 90.1            | 89.0        | 88.9     | 86.0                  |
|     |          | 0.5              | 0.5  | 0    | 77.5             | 88.9            | 87.9        | 89.5     | 84.8                  |
|     |          | 0.95             | 0.3  | 0.65 | 81.4             | 89.2            | 88.5        | 89.4     | 85.2                  |
|     |          | 0.99             | 0.2  | 0.79 | 84.1             | 89.5            | 88.7        | 89.2     | 85.5                  |
|     |          | 0.99             | 0.05 | 0.94 | 88.6             | 90.1            | 89.2        | 88.8     | 86.0                  |
|     | 0.9      | 0                | 0    | 0    | 83.9             | 83.2            | 78.7        | 79.7     | 76.0                  |
|     |          | 0.5              | 0.5  | 0    | 80.4             | 84.4            | 80.5        | 82.0     | 76.6                  |
|     |          | 0.95             | 0.3  | 0.65 | 80.1             | 84.0            | 80.5        | 81.4     | 76.8                  |
|     |          | 0.99             | 0.2  | 0.79 | 80.8             | 83.6            | 80.2        | 80.7     | 76.1                  |
|     |          | 0.99             | 0.05 | 0.94 | 83.7             | 83.3            | 79.0        | 79.6     | 75.7                  |
| 00  | 0        | 0                | 0    | 0    | 89.7             | 90.2            | 89.4        | 89.5     | 88.0                  |
|     |          | 0.5              | 0.5  | 0    | 73.6             | 89.3            | 88.5        | 89.3     | 86.1                  |
|     |          | 0.95             | 0.3  | 0.65 | 77.2             | 89.6            | 88.8        | 89.5     | 86.7                  |
|     |          | 0.99             | 0.2  | 0.79 | 80.6             | 90.1            | 89.4        | 89.4     | 86.8                  |
|     |          | 0.99             | 0.05 | 0.94 | 88.7             | 90.4            | 89.6        | 89.6     | 87.9                  |
|     | 0.9      | 0                | 0    | 0    | 87.4             | 87.5            | 84.8        | 84.0     | 82.5                  |
|     |          | 0.5              | 0.5  | 0    | 82.7             | 87.8            | 85.0        | 85.5     | 82.7                  |
|     |          | 0.95             | 0.3  | 0.65 | 81.5             | 87.9            | 85.6        | 85.3     | 82.5                  |
|     |          | 0.99             | 0.2  | 0.79 | 83.1             | 87.8            | 85.5        | 85.1     | 82.6                  |
|     |          | 0.99             | 0.05 | 0.94 | 86.9             | 87.5            | 85.0        | 84.2     | 82.3                  |
| 200 | 0        | 0                | 0    | 0    | 89.6             | 90.5            | 89.9        | 89.7     | 89.2                  |
|     |          | 0.5              | 0.5  | 0    | 70.7             | 89.3            | 88.5        | 89.4     | 87.2                  |
|     |          | 0.95             | 0.3  | 0.65 | 72.9             | 89.4            | 88.9        | 89.2     | 87.3                  |
|     |          | 0.99             | 0.2  | 0.79 | 76.4             | 89.7            | 89.0        | 89.6     | 87.8                  |
|     |          | 0.99             | 0.05 | 0.94 | 87.9             | 90.4            | 89.6        | 89.6     | 88.9                  |
|     | 0.9      | 0                | 0    | 0    | 89.3             | 88.9            | 87.0        | 87.1     | 86.4                  |
|     |          | 0.5              | 0.5  | 0    | 83.6             | 88.6            | 87.0        | 88.1     | 86.7                  |
|     |          | 0.95             | 0.3  | 0.65 | 79.9             | 89.4            | 88.3        | 88.1     | 86.5                  |
|     |          | 0.99             | 0.2  | 0.79 | 81.2             | 89.8            | 88.5        | 88.5     | 86.9                  |
|     |          | 0.99             | 0.05 | 0.94 | 88.0             | 89.3            | 87.3        | 87.3     | 86.4                  |
| 400 | 0        | 0                | 0    | 0    | 90.3             | 90.8            | 90.6        | 90.2     | 89.8                  |
|     |          | 0.5              | 0.5  | 0    | 68.5             | 90.0            | 89.4        | 89.9     | 88.3                  |
|     |          | 0.95             | 0.3  | 0.65 | 68.6             | 90.2            | 89.8        | 90.0     | 88.4                  |
|     |          | 0.99             | 0.2  | 0.79 | 72.2             | 90.6            | 90.0        | 90.0     | 88.7                  |
|     |          | 0.99             | 0.05 | 0.94 | 87.4             | 90.8            | 90.3        | 90.0     | 89.7                  |
|     | 0.9      | 0                | 0    | 0    | 90.0             | 89.7            | 88.3        | 88.6     | 88.2                  |
|     |          | 0.5              | 0.5  | 0    | 83.4             | 89.3            | 88.2        | 89.6     | 88.5                  |
|     |          | 0.95             | 0.3  | 0.65 | 76.2             | 89.5            | 88.8        | 89.5     | 88.2                  |
|     |          | 0.99             | 0.2  | 0.79 | 76.8             | 89.7            | 89.0        | 89.6     | 88.6                  |
|     |          | 0.99             | 0.05 | 0.94 | 87.9             | 89.7            | 88.6        | 89.0     | 88.5                  |

are qualitatively the same as for N-GARCH and t-GARCH. For the other three models, we find that there is little to choose between the recursive-design WB and the pairwise bootstrap. Their coverage probability for small samples and highly persistent

<span id="page-13-0"></span>Table 3 Coverage rates of nominal 90% symmetric percentile-t intervals for  $\phi_1$ : AR(1)- $t_5$ -GARCH model

| n   | $\phi_1$ | $\alpha + \beta$ | α    | β    | Recursive i.i.d. | Recursive<br>WB | Fixed<br>WB  | Pairwise | Robust SE<br>Gaussian |
|-----|----------|------------------|------|------|------------------|-----------------|--------------|----------|-----------------------|
| 50  | 0        | 0                | 0    | 0    | 90.6             | 89.1            | 88.2         | 89.5     | 86.0                  |
|     |          | 0.5              | 0.5  | 0    | 75.5             | 87.6            | 86.3         | 89.4     | 83.1                  |
|     |          | 0.95             | 0.3  | 0.65 | 80.9             | 88.2            | 86.9         | 89.5     | 83.9                  |
|     |          | 0.99             | 0.2  | 0.79 | 83.5             | 88.4            | 87.3         | 89.1     | 84.2                  |
|     |          | 0.99             | 0.05 | 0.94 | 89.5             | 89.1            | 87.9         | 89.4     | 85.9                  |
|     | 0.9      | 0                | 0    | 0    | 84.5             | 83.8            | 80.0         | 81.1     | 77.4                  |
|     |          | 0.5              | 0.5  | 0    | 79.5             | 84.3            | 81.0         | 83.0     | 77.4                  |
|     |          | 0.95             | 0.3  | 0.65 | 79.4             | 84.4            | 80.8         | 82.9     | 77.2                  |
|     |          | 0.99             | 0.2  | 0.79 | 80.7             | 84.3            | 80.3         | 82.5     | 76.9                  |
|     |          | 0.99             | 0.05 | 0.94 | 84.3             | 83.6            | 80.0         | 81.0     | 76.9                  |
| 100 | 0        | 0                | 0    | 0    | 90.3             | 89.7            | 89.0         | 89.5     | 88.0                  |
|     |          | 0.5              | 0.5  | 0    | 70.6             | 88.0            | 87.8         | 89.0     | 84.8                  |
|     |          | 0.95             | 0.3  | 0.65 | 75.3             | 88.7            | 88.3         | 88.9     | 86.1                  |
|     |          | 0.99             | 0.2  | 0.79 | 78.1             | 89.0            | 88.7         | 88.8     | 86.4                  |
|     |          | 0.99             | 0.05 | 0.94 | 88.3             | 89.5            | 89.2         | 89.2     | 87.8                  |
|     | 0.9      | 0                | 0    | 0    | 88.6             | 88.0            | 84.0         | 85.5     | 82.7                  |
|     |          | 0.5              | 0.5  | 0    | 82.3             | 88.7            | 85.3         | 86.9     | 83.2                  |
|     |          | 0.95             | 0.3  | 0.65 | 81.4             | 88.7            | 85.4         | 86.1     | 83.2                  |
|     |          | 0.99             | 0.2  | 0.79 | 82.3             | 88.2            | 85.3         | 85.9     | 83.4                  |
|     |          | 0.99             | 0.05 | 0.94 | 87.3             | 87.9            | 84.4         | 85.0     | 83.0                  |
| 200 | 0        | 0                | 0    | 0    | 90.6             | 90.3            | 89.5         | 89.6     | 88.8                  |
|     | Ü        | 0.5              | 0.5  | 0    | 66.2             | 88.8            | 88.0         | 89.8     | 85.5                  |
|     |          | 0.95             | 0.3  | 0.65 | 70.6             | 89.1            | 88.5         | 89.6     | 86.9                  |
|     |          | 0.99             | 0.2  | 0.79 | 74.1             | 89.4            | 88.9         | 89.8     | 87.2                  |
|     |          | 0.99             | 0.05 | 0.94 | 87.2             | 90.1            | 88.8         | 89.4     | 88.0                  |
|     | 0.9      | 0                | 0    | 0    | 89.4             | 89.0            | 87.2         | 87.2     | 86.6                  |
|     | 0.5      | 0.5              | 0.5  | 0    | 80.7             | 89.4            | 87.7         | 89.0     | 86.6                  |
|     |          | 0.95             | 0.3  | 0.65 | 77.3             | 88.8            | 88.1         | 88.4     | 86.8                  |
|     |          | 0.99             | 0.2  | 0.79 | 78.7             | 89.0            | 87.9         | 88.2     | 86.6                  |
|     |          | 0.99             | 0.05 | 0.94 | 87.6             | 89.1            | 87.2         | 87.4     | 86.4                  |
| 400 | 0        | 0                | 0    | 0    | 90.1             | 90.1            | 89.3         | 90.1     | 88.8                  |
| 100 | Ü        | 0.5              | 0.5  | 0    | 61.2             | 89.3            | 87.7         | 90.5     | 85.9                  |
|     |          | 0.95             | 0.3  | 0.65 | 64.6             | 89.8            | 88.5         | 90.4     | 87.0                  |
|     |          | 0.99             | 0.2  | 0.79 | 68.4             | 89.7            | 89.1         | 90.3     | 87.8                  |
|     |          | 0.99             | 0.05 | 0.75 | 84.6             | 90.1            | 89.7         | 90.4     | 88.9                  |
|     | 0.9      | 0.99             | 0.03 | 0.54 | 89.5             | 89.5            | 88.6         | 88.7     | 88.4                  |
|     | 0.7      | 0.5              | 0.5  | 0    | 79.2             | 89.9            | 88.4         | 89.9     | 87.7                  |
|     |          | 0.95             | 0.3  | 0.65 | 72.5             | 89.7            | 88.8         | 90.3     | 87.8                  |
|     |          | 0.99             | 0.3  | 0.03 | 74.0             | 89.6            | 89.0         | 89.8     | 88.1                  |
|     |          | 0.99             | 0.2  | 0.79 | 85.6             | 89.6            | 89.0<br>88.8 | 89.8     | 88.3                  |

data tends to be too low, but consistently higher than that of any alternative method. In all other cases, both methods are highly accurate. Neither the recursive-design i.i.d. bootstrap nor the conventional Gaussian approximation perform well. The high

Table 4 Coverage rates of nominal 90% symmetric percentile-t intervals for  $\phi_1$ 
