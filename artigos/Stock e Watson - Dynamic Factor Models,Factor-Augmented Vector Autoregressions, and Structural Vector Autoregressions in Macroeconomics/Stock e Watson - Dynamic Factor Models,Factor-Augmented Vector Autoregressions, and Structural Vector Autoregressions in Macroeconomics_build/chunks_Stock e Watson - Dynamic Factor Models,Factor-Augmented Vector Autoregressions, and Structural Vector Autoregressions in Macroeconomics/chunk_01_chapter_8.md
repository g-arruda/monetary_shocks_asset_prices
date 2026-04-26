# CHAPTER 8

# Dynamic Factor Models, Factor-Augmented Vector Autoregressions, and Structural Vector Autoregressions in Macroeconomics☆

#### J.H. Stock\*,{ , M.W. Watson†,{

\* Harvard University, Cambridge, MA, United States

# Contents

| 1. |     | Introduction                                                               | 418 |
|----|-----|----------------------------------------------------------------------------|-----|
| 2. |     | DFMs: Notation and Summary of Econometric Methods                          | 421 |
|    | 2.1 | The DFM                                                                    | 421 |
|    |     | 2.1.1 Dynamic Form of the DFM                                              | 422 |
|    |     | 2.1.2 Static (Stacked) Form of the DFM                                     | 424 |
|    |     | 2.1.3 Normalization of the Factors                                         | 425 |
|    |     | 2.1.4 Low-Frequency Movements, Unit Roots, and Cointegration               | 427 |
|    | 2.2 | DFMs: A Brief Review of Early Literature                                   | 428 |
|    | 2.3 | Estimation of the Factors and DFM Parameters                               | 429 |
|    |     | 2.3.1 Nonparametric Methods and Principal Components Estimation            | 429 |
|    |     | 2.3.2 Parametric State-Space Methods                                       | 431 |
|    |     | 2.3.3 Hybrid Methods and Data Pruning                                      | 432 |
|    |     | 2.3.4 Missing Data and Mixed Data Sampling Frequencies                     | 433 |
|    |     | 2.3.5 Bayes Methods                                                        | 434 |
|    | 2.4 | Determining the Number of Factors                                          | 435 |
|    |     | 2.4.1 Estimating the Number of Static Factors r                            | 435 |
|    |     | 2.4.2 Estimating the Number of Dynamic Factors q                           | 436 |
|    | 2.5 | Breaks and Time-Varying Parameters                                         | 437 |
|    |     | 2.5.1 Robustness of PC to Limited Instability                              | 437 |
|    |     | 2.5.2 Tests for Instability                                                | 438 |
|    |     | 2.5.3 Incorporating Time-Varying Factor Loadings and Stochastic Volatility | 439 |
| 3. |     | DFMs for Macroeconomic Monitoring and Forecasting                          | 440 |
|    | 3.1 | Macroeconomic Monitoring                                                   | 441 |
|    |     | 3.1.1 Index Construction                                                   | 441 |

The Woodrow Wilson School, Princeton University, Princeton, NJ, United States

The National Bureau of Economic Research, Cambridge, MA, United States

<sup>☆</sup> Replication files and the Supplement are available on Watson's Website, which also includes links to a suite of software for estimation and inference in DFMs and structural DFMs built around the methods described in this chapter.

|    | 3.1.2 Nowcasting                                                              | 442 |
|----|-------------------------------------------------------------------------------|-----|
|    | 3.2<br>Forecasting                                                            | 443 |
| 4. | Identification of Shocks in Structural VARs                                   | 443 |
|    | 4.1<br>Structural Vector Autoregressions                                      | 445 |
|    | 4.1.1 VARs, SVARs, and the Shock Identification Problem                       | 445 |
|    | 4.1.2 Invertibility                                                           | 449 |
|    | 4.1.3 Unit Effect Normalization                                               | 451 |
|    | 4.1.4 Summary of SVAR Assumptions.                                            | 453 |
|    | 4.2<br>Contemporaneous (Short-Run) Restrictions                               | 454 |
|    | 4.2.1 System Identification                                                   | 454 |
|    | 4.2.2 Single Shock Identification                                             | 454 |
|    | 4.3<br>Long-Run Restrictions                                                  | 455 |
|    | 4.3.1 System Identification                                                   | 455 |
|    | 4.3.2 Single Shock Identification                                             | 456 |
|    | 4.3.3 IV Interpretation of Long-Run Restrictions                              | 456 |
|    | 4.3.4 Digression: Inference in IV Regression with Weak Instruments            | 458 |
|    | 4.3.5 Inference Under Long-Run Restrictions and Weak Instruments              | 459 |
|    | 4.4<br>Direct Measurement of the Shock                                        | 460 |
|    | 4.5<br>Identification by Heteroskedasticity                                   | 461 |
|    | 4.5.1 Identification by Heteroskedasticity: Regimes                           | 461 |
|    | 4.5.2 Identification by Heteroskedasticity: Conditional Heteroskedasticity    | 462 |
|    | 4.5.3 Instrumental Variables Interpretation and Potential Weak Identification | 463 |
|    | 4.6<br>Inequality (Sign) Restrictions                                         | 464 |
|    | 4.6.1 Inequality Restrictions and Computing an Estimate of the Identified Set | 465 |
|    | 4.6.2 Inference When H Is Set Identified                                      | 466 |
|    | 4.7<br>Method of External Instruments                                         | 470 |
| 5. | Structural DFMs and FAVARs                                                    | 471 |
|    | 5.1<br>Structural Shocks in DFMs and the Unit Effect Normalization            | 473 |
|    | 5.1.1 The SDFM                                                                | 473 |
|    | 5.1.2 Combining the Unit Effect and Named Factor Normalizations               | 473 |
|    | 5.1.3 Standard Errors for SIRFs                                               | 476 |
|    | 5.2<br>Factor-Augmented Vector Autoregressions                                | 477 |
| 6. | A Quarterly 200+ Variable DFM for the United States                           | 478 |
|    | 6.1<br>Data and Preliminary Transformations                                   | 479 |
|    | 6.1.1 Preliminary Transformations and Detrending                              | 479 |
|    | 6.1.2 Subset of Series Used to Estimate the Factors                           | 483 |
|    | 6.2<br>Real Activity Dataset and Single-Index Model                           | 483 |
|    | 6.3<br>The Full Dataset and Multiple-Factor Model                             | 488 |
|    | 6.3.1 Estimating the Factors and Number of Factors                            | 488 |
|    | 6.3.2 Stability                                                               | 491 |
|    | 6.4<br>Can the Eight-Factor DFM Be Approximated by a Low-Dimensional VAR?     | 493 |
| 7. | Macroeconomic Effects of Oil Supply Shocks                                    | 496 |
|    | 7.1<br>Oil Prices and the Macroeconomy: Old Questions, New Answers            | 496 |
|    | 7.2<br>Identification Schemes                                                 | 499 |
|    | 7.2.1 Identification by Treating Oil Prices Innovations as Exogenous          | 500 |
|    | 7.2.2 Kilian (2009) Identification                                            | 502 |

|    | 7.3        | Comparison SVAR and Estimation Details                      | 503 |
|----|------------|-------------------------------------------------------------|-----|
|    |            | 7.3.1 Comparison SVAR                                       | 503 |
|    |            | 7.3.2 Summary of SDFM Estimation Steps                      | 504 |
|    | 7.4        | Results:<br>"Oil Price Exogenous"<br>Identification         | 504 |
|    | 7.5        | Results: Kilian (2009) Identification                       | 507 |
|    |            | 7.5.1 Hybrid FAVAR-SDFM                                     | 507 |
|    |            | 7.5.2 Results                                               | 508 |
|    | 7.6        | Discussion and Lessons                                      | 513 |
| 8. |            | Critical Assessment and Outlook                             | 514 |
|    | 8.1        | Some Recommendations for Empirical Practice                 | 514 |
|    |            | 8.1.1 Variable Selection and Data Processing                | 514 |
|    |            | 8.1.2 Parametric vs Nonparametric Methods                   | 514 |
|    |            | 8.1.3 Instability                                           | 515 |
|    |            | 8.1.4 Additional Considerations for Structural Analysis     | 515 |
|    | 8.2        | Assessment                                                  | 516 |
|    |            | 8.2.1 Do a Small Number of Factors Describe the Comovements |     |
|    |            | of Macro Variables?                                         | 516 |
|    |            | 8.2.2 Do DFMs Improve Forecasts and Nowcasts?               | 516 |
|    |            | 8.2.3 Do SDFMs Provide Improvements Over SVARs?             | 517 |
|    |            | Acknowledgments                                             | 517 |
|    | References |                                                             | 517 |

## Abstract

This chapter provides an overview of and user's guide to dynamic factor models (DFMs), their estimation, and their uses in empirical macroeconomics. It also surveys recent developments in methods for identifying and estimating SVARs, an area that has seen important developments over the past 15 years. The chapter begins by introducing DFMs and the associated statistical tools, both parametric (state-space forms) and nonparametric (principal components and related methods). After reviewing two mature applications of DFMs, forecasting and macroeconomic monitoring, the chapter lays out the use of DFMs for analysis of structural shocks, a special case of which is factor-augmented vector autoregressions (FAVARs). A main focus of the chapter is how to extend methods for identifying shocks in structural vector autoregression (SVAR) to structural DFMs. The chapter provides a unification of SVARs, FAVARs, and structural DFMs and shows both in theory and through an empirical application to oil shocks how the same identification strategies can be applied to each type of model.

## Keywords

State-space models, Structural vector autoregressions, Factor-augmented vector autoregressions, Principal components, Large-model forecasting, Nowcasting, Structural shocks

## JEL Classification Codes

C32, C38, C55, E17, E37, E47

# 1. INTRODUCTION

The premise of dynamic factor models (DFMs) is that the common dynamics of a large number of time series variables stem from a relatively small number of unobserved (or latent) factors, which in turn evolve over time. Given the extraordinary complexity and regional and sectoral variation of large modern economies, it would seem surprising a priori that such a simple idea would have much empirical support. Remarkably, it does.

[Fig. 1](#page-4-0) shows a key result for a single-factor DFM fit to 58 quarterly US real activity variables (sectoral industrial production (IP), sectoral employment, sales, and National Income and Product Account (NIPA) series); the details are discussed in [Section 6.](#page-63-0) A single common factor for these series was estimated using principal components analysis, a least-squares method for estimating the unobserved factors nonparametrically discussed in [Section 2](#page-6-0). The figure shows the detrendeda four-quarter growth rates of four measures of aggregate economic activity (real Gross Domestic Product (GDP), total nonfarm employment, IP, and manufacturing and trade sales), along with the fitted value from a regression of the quarterly growth rate of each series on the single common factor. None of the four series plotted in [Fig. 1](#page-4-0) were used to estimate the factor: although disaggregated NIPA variables like consumption of durables, of nondurables, and of services were used, total consumption, GDP, and other high-level aggregates were not. As can be seen in the figure, the single factor explains a large fraction of the four-quarter variation in these four series. For these four series, the R<sup>2</sup> s of the four-quarter fits range from 0.73 for GDP to 0.92 for employment. At the same time, the estimated factor does not equal any one of these series, nor does it equal any one of the 58 series used to construct it.

DFMs have several appealing properties that drive the large body of research on methods and applications of DFMs in macroeconomics. First, as [Fig. 1](#page-4-0) suggests and as is discussed in more detail later, empirical evidence supports their main premise: DFMs fit the data. The idea that a single index describes the comovements of many macroeconomics variables arguably dates at least to [Burns and Mitchell \(1946\),](#page-104-0) and additional early references are discussed in [Section 2](#page-6-0).

Second, as is discussed in the next section, the key DFM restriction of a small number of latent factors is consistent with standard dynamic equilibrium macroeconomic theories.

Third, techniques developed in the past 15 years have allowed DFMs to be estimated using large datasets, with no practical or computational limits on the number of variables. Large datasets are now readily available,<sup>b</sup> and the empirical application in this chapter uses a 207-variable DFM. Estimation of the factors, DFM parameters, and structural DFM impulse response functions (IRFs) takes only a few seconds. Forecasts based on large

<sup>a</sup> Following [Stock and Watson \(2012a\)](#page-109-0) and as discussed in [Section 6.1](#page-64-0), the trends in the growth rates were

estimated using a biweight filter with a bandwidth of 100 quarters; the displayed series subtract off these trends. <sup>b</sup> For example, [McCracken and Ng \(2015\)](#page-108-0) have compiled an easily downloaded large monthly macroeconomic dataset for the United States (FRED-MD), which is available through the Federal Reserve Bank of St. Louis FRED data tool at [https://research.stlouisfed.org/econ/mccracken/fred-databases/.](https://research.stlouisfed.org/econ/mccracken/fred-databases/)

<span id="page-4-0"></span>![](_page_4_Figure_0.jpeg)

Fig. 1 Detrended four-quarter growth rates of US GDP, industrial production, nonfarm employment, and manufacturing and trade sales (solid line), and the common component (fitted value) from a singlefactor DFM (dashed line). The factor is estimated using 58 US quarterly real activity variables. Variables all measured in percentage points.

DFMs have rich information sets but still involve a manageably small number of predictors, which are the estimates of the latent factors, and do so without imposing restrictions such as sparsity in the original variables that are used by some machine learning algorithms. As a result, DFMs have been the main "big data" tool used over the past 15 years by empirical macroeconomists.

Fourth, DFMs are well suited to practical tasks of professional macroeconomists such as real-time monitoring, including construction of indices from conceptually similar noisy time series.

Fifth, because of their ability to handle large numbers of time series, high-dimensional DFMs can accommodate enough variables to span a wide array of macroeconomic shocks. Given a strategy to identify one or more structural shocks, a structural DFM can be used to estimate responses to these structural shocks. The use of many variables to span the space of the shocks mitigates the "invertibility problem" of structural vector autoregressions (SVARs), in which a relatively small number of variables measured with error might not be able to measure the structural shock of interest.

The chapter begins in [Section 2](#page-6-0) with an introduction to structural dynamic factor models (SDFMs) and methods for estimating DFMs, both parametric (state-space methods) and nonparametric (principal components and related least-squares methods). This discussion includes extensions to data irregularities, such as missing observations and mixed observation frequencies, and covers recent work on detecting breaks and other forms of instability in DFMs.

The chapter then turns to a review of the main applications of DFMs. The first, macroeconomic monitoring and forecasting, is covered in [Section 3](#page-25-0). These applications are mature and many aspects have been surveyed elsewhere, so the discussion is relatively brief and references to other surveys are provided.

[Sections 4 and 5](#page-28-0) examine estimation of the effects of structural shocks. One of the main themes of this chapter is that the underlying identification approaches of SVARs carry over to structural DFMs. This is accomplished through two normalizations, which we call the unit effect normalization for SVARs and the named factor normalization for DFMs. These normalizations set the stage for a unified treatment, provided in these sections, of structural DFMs, factor-augmented VARs (FAVARs), and SVARs.

The basic approaches to identification of structural shocks are the same in SVARs, FAVARs, and SDFMs. [Section 4](#page-28-0) therefore surveys the identification of structural shocks in SVARs. This area has seen much novel work over the past 10 years. [Section 4](#page-28-0) is a stand-alone survey of SVAR identification that can be read without reference to other sections of this chapter and complements [Ramey \(2016\)](#page-108-0). [Section 4](#page-28-0) discusses another of the main themes of this chapter: as modern methods for identification of structural shocks in SVARs become more credible, they raise the risk of relying on relatively small variations in the data, which in turn means that they can be weakly identified. As in applications with microdata, weak identification can distort statistical inference using both Bayes and frequentist methods. [Section 4](#page-28-0) shows how weak identification can arise in various SVAR identification strategies.

<span id="page-6-0"></span>[Section 5](#page-56-0) shows how these SVAR identification schemes extend straightforwardly to SDFMs and FAVARs. [Section](#page-56-0) 5 also develops another main theme of this chapter that structural DFMs, FAVARs, and SVARs are a unified suite of tools with fundamentally similar structures that differ in whether the factors are treated as observed or unobserved. By using a large number of variables and treating the factors as unobserved, DFMs "average out" the measurement error in individual time series, and thereby improve the ability to span the common macroeconomic structural shocks.

[Sections 6 and 7](#page-63-0) turn to an empirical illustration using an eight-factor, 207-variable DFM. [Section 6](#page-63-0) works through the estimation of the DFM, first using only the real activity variables to construct a real activity index, then using all the variables.

[Section 7](#page-81-0) uses the 207-variable DFM to examine the effect of oil market shocks on the US economy. The traditional view is that unexpected large increases in oil prices have large and negative effects on the US economy and have preceded many postwar US recessions [\(Hamilton, 1983, 2009](#page-106-0)). Subsequent work suggests, however, that since the 1980s oil shocks have had a smaller impact (eg, [Hooker, 1996;](#page-106-0) [Edelstein and Kilian,](#page-105-0) [2009](#page-105-0); [Blanchard and Galı´, 2010](#page-104-0)), and moreover that much of the movement in oil prices is due to demand shocks, not oil supply shocks (eg, [Kilian, 2009\)](#page-107-0). We use a single large DFM to illustrate how SVAR identification methods carry over to structural DFMs and to FAVARs, and we compare structural DFM, FAVAR, and SVAR results obtained using two different methods to identify oil market shocks. The structural DFM results are consistent with the main finding in the modern literature that oil supply shocks explain only a fraction of the variation in oil prices and explain a very small fraction of the variation in major US macroeconomic variables since the mid-1980s.

In [Section 8,](#page-99-0) we step back and assess what has been learned, at a high level, from the large body of work on DFMs in macroeconomics. These lessons include some practical recommendations for estimation and use of DFMs, along with some potential pitfalls.

There are several recent surveys on aspects of DFM analysis which complement this chapter. [Bai and Ng \(2008\)](#page-103-0) provide a technical survey of the econometric theory for principal components and related DFM methods. [Stock and Watson \(2011\)](#page-109-0) provide an overview of the econometric methods with a focus on applications. [Banbura et al.](#page-103-0) [\(2013\)](#page-103-0) survey the use of DFMs for nowcasting. The focus of this chapter is DFMs in macroeconomics and we note, but do not go into, the vast applications of factor models and principal components methods in fields ranging from psychometrics to finance to big data applications in the natural and biological sciences and engineering.

# 2. DFMs: NOTATION AND SUMMARY OF ECONOMETRIC METHODS

# 2.1 The DFM

The DFM represents the evolution of a vector of N observed time series, Xt, in terms of a reduced number of unobserved common factors which evolve over time, plus uncorrelated disturbances which represent measurement error and/or idiosyncratic dynamics of the individual series. There are two ways to write the model. The dynamic form <span id="page-7-0"></span>represents the dependence of  $X_t$  on lags (and possibly leads) of the factors explicitly, while the static form represents those dynamics implicitly. The two forms lead to different estimation methods. Which form is more convenient depends on the application.

The DFM is an example of the much larger class of state-space or hidden Markov models, in which observable variables are expressed in terms of unobserved or latent variables, which in turn evolve according to some lagged dynamics with finite dependence (ie, the law of motion of the latent variables is Markov). What makes the DFM stand out for macroeconometric applications is that the complex comovements of a potentially large number of observable series are summarized by a small number of common factors, which drive the common fluctuations of all the series.

Unless stated explicitly otherwise, observable and latent variables are assumed to be second-order stationary and integrated of order zero; treatment of unit roots, low-frequency trends, and cointegration are discussed in Section 2.1.4. In addition, following convention all data series are assumed to be transformed to have unit standard deviation.

Throughout this chapter, we use lag operator notation, so that  $a(L) = \sum_{i=0}^{\infty} a_i L^i$ , where L is the lag operator, and  $a(L)X_t = \sum_{i=0}^{\infty} a_i X_{t-i}$ .

#### 2.1.1 Dynamic Form of the DFM

The DFM expresses a  $N \times 1$  vector  $X_t$  of observed time series variables as depending on a reduced number q of unobserved or latent factors  $f_t$  and a mean-zero idiosyncratic component  $e_t$ , where both the latent factors and idiosyncratic terms are in general serially correlated. The DFM is,

$$X_t = \lambda(\mathbf{L})f_t + e_t \tag{1}$$

$$f_t = \Psi(\mathbf{L})f_{t-1} + \eta_t \tag{2}$$

where the lag polynomial matrices  $\lambda(L)$  and  $\Psi(L)$  are  $N \times q$  and  $q \times q$ , respectively, and  $\eta_t$  is the  $q \times 1$  vector of (serially uncorrelated) mean-zero innovations to the factors. The idiosyncratic disturbances are assumed to be uncorrelated with the factor innovations at all leads and lags, that is,  $Ee_t\eta'_{t-k} = 0$  for all k. In general,  $e_t$  can be serially correlated. The ith row of  $\lambda(L)$ , the lag polynomial  $\lambda_i(L)$ , is called the dynamic factor loading for the ith series,  $X_{it}$ .

The term  $\lambda_i(L)f_t$  in (1) is the *common component* of the *i*th series. Throughout this chapter, we treat the lag polynomial  $\lambda(L)$  as one sided. Thus the common component of each series is a distributed lag of current and past values of  $f_t$ .

The idiosyncratic disturbance  $e_t$  in (1) can be serially correlated. If so, models (1) and (2) are incompletely specified. For some purposes, such as state-space estimation discussed later, it is desirable to specify a parametric model for the idiosyncratic dynamics. A simple and tractable model is to suppose that the *i*th idiosyncratic disturbance,  $e_{it}$ , follows the univariate autoregression,

<sup>&</sup>lt;sup>c</sup> If  $\lambda(L)$  has finitely many leads, then because  $f_t$  is unobserved the lag polynomial can without loss of generality be rewritten by shifting  $f_t$  so that  $\lambda(L)$  is one sided.

$$e_{it} = \delta_i(\mathbf{L})e_{it-1} + \nu_{it},\tag{3}$$

<span id="page-8-0"></span>where  $\nu_{it}$  is serially uncorrelated.

#### 2.1.1.1 Exact DFM

If the idiosyncratic disturbances  $e_t$  are uncorrelated across series, that is,  $Ee_{it}e_{js} = 0$  for all t and s with  $i \neq j$ , then the model is referred to as the exact dynamic factor model.

In the exact DFM, the correlation of one series with another occurs only through the latent factors  $f_t$ . To make this precise, suppose that the disturbances  $(e_t, \eta_t)$  are Gaussian. Then (1) and (2) imply that,

$$E[X_{it}|X_{t}^{-i}, f_{t}, X_{t-1}^{-i}, f_{t-1}, \dots] = E[\lambda_{i}(L)f_{t} + e_{it}|X_{t}^{-i}, f_{t}, X_{t-1}^{-i}, f_{t-1}, \dots]$$

$$= E[\lambda_{i}(L)f_{t}|X_{t}^{-i}, f_{t}, X_{t-1}^{-i}, f_{t-1}, \dots]$$

$$= \lambda_{i}(L)f_{t},$$

$$(4)$$

where the superscript "-i" denotes all the series other than i. Thus the common component of  $X_{it}$  is the expected value of  $X_{it}$  given the factors and all the other variables. The other series  $X_t^{-i}$  have no explanatory power for  $X_{it}$  given the factor.

Similarly, in the exact DFM with Gaussian disturbances, forecasts of the *i*th series given all the variables and the factors reduce to forecasts given the factors and  $X_{it}$ . Suppose that  $e_{it}$  follows the autoregression (3) and that  $(\nu_t, \eta_t)$  are normally distributed. Under the exact DFM,  $E\nu_{it}\nu_{jt}=0$ ,  $i\neq j$ . Then

$$E[X_{it+1}|X_t, f_t, X_{t-1}, f_{t-1}, \dots] = E[\lambda_i(L)f_{t+1} + e_{it+1}|X_t, f_t, X_{t-1}, f_{t-1}, \dots]$$

$$= \alpha_i^f(L)f_t + \delta_i(L)X_{it},$$
(5)

where 
$$\alpha_i^f(L) = \lambda_{i0} \Psi(L) - \delta_i(L) \lambda_i(L) + L^{-1} (\lambda_i(L) - \lambda_0)$$
.

If the disturbances  $(e_t, \eta_t)$  satisfy the exact DFM but are not Gaussian, then the expressions in (4) and (5) have interpretations as population linear predictors.

Eqs. (4) and (5) summarize the key dimension reduction properties of the exact DFM: for the purposes of explaining contemporaneous movements and for making forecasts, once you know the values of the factors, the other series provide no additional useful information.

#### 2.1.1.2 Approximate DFM

The assumption that  $e_t$  is uncorrelated across series is unrealistic in many applications. For example, data derived from the same survey might have correlated measurement error,

d Substitute (2) and (3) into (1) to obtain,  $X_{it+1} = \lambda_{i0}(\boldsymbol{\varPsi}(L)f_t + \eta_{t+1}) + \sum_j \lambda_{ij}f_{t-j+1} + \delta_i(L)e_{it} + \nu_{it+1}$ . Note that  $\sum_j \lambda_{ij}f_{t-j+1} = L^{-1}(\lambda_i(L) - \lambda_{i0})f_t$  and that  $\delta_i(L)e_{it} = \delta_i(L)(X_{it} - \lambda_i(L)f_t)$ . Then  $X_{it+1} = \lambda_{i0}(\boldsymbol{\varPsi}(L)f_t + \eta_{t+1}) + L^{-1}(\lambda_i(L) - \lambda_{i0})f_t + \delta_i(L)(X_{it} - \lambda_i(L)f_t) + \nu_{it+1}$ . Eq. (5) obtains by collecting terms and taking expectations.

<span id="page-9-0"></span>and multiple series for a given sector might have unmodeled sector-specific dynamics. Chamberlain and Rothschild's (1983) approximate factor model allows for such correlation, as does the theoretical justification for the econometric methods discussed in Section 2.2. For a discussion of the technical conditions limiting the dependence across the disturbances in the approximate factor model, see Bai and Ng (2008).

Under the approximate DFM, the final expressions in (4) and (5) would contain additional terms reflecting this limited correlation. Concretely, the forecasting Eq. (5) could contain some additional observable variables relevant for forecasting series  $X_{it}$ . In applications, this potential correlation is best addressed on a case-by-case basis.

#### 2.1.2 Static (Stacked) Form of the DFM

The *static*, or *stacked*, form of the DFM rewrites the dynamic form (1) and (2) to depend on *r static factors*  $F_t$  instead of the q dynamic factors  $f_t$ , where  $r \ge q$ . This rewriting makes the model amenable to principal components analysis and to other least-squares methods.

Let p be the degree of the lag polynomial matrix  $\lambda(L)$  and let  $F_t = (f'_t, f'_{t-1}, ..., f'_{t-p})$  denote an  $r \times 1$  vector of so-called "static" factors—in contrast to the "dynamic" factors  $f_t$ . Also let  $\Lambda = (\lambda_0, \lambda_1, ..., \lambda_p)$ , where  $\lambda_h$  is the  $N \times q$  matrix of coefficients on the hth lag in  $\lambda(L)$ . Similarly, let  $\Phi(L)$  be the matrix consisting of 1s, 0s, and the elements of  $\Psi(L)$  such that the vector autoregression in (2) is rewritten in terms of  $F_t$ . With this notation the DFM (1) and (2) can be rewritten,

$$X_t = \Lambda F_t + e_t \tag{6}$$

$$F_t = \Phi(L)F_{t-1} + G\eta_t, \tag{7}$$

where  $G = \begin{bmatrix} I_q & 0_{q \times (r-q)} \end{bmatrix}'$ .

As an example, suppose that there is a single dynamic factor  $f_t$  (so q = 1), that all  $X_{it}$  depend only on the current and first lagged values of  $f_t$ , and that the VAR for  $f_t$  in (2) has two lags, so  $f_t = \Psi_1 f_{t-1} + \Psi_2 f_{t-2} + \eta_t$ . Then the correspondence between the dynamic and static forms for  $X_{it}$  is,

$$X_{it} = \lambda_{i0} f_t + \lambda_{i1} f_{t-1} + e_{it} = \begin{bmatrix} \lambda_{i0} & \lambda_{i1} \end{bmatrix} \begin{bmatrix} f_t \\ f_{t-1} \end{bmatrix} + e_{it} = \Lambda_i F_t + e_{it},$$
 (8)

$$F_{t} = \begin{bmatrix} f_{t} \\ f_{t-1} \end{bmatrix} = \begin{bmatrix} \boldsymbol{\Psi}_{1} & \boldsymbol{\Psi}_{2} \\ 1 & 0 \end{bmatrix} \begin{bmatrix} f_{t-1} \\ f_{t-2} \end{bmatrix} + \begin{bmatrix} 1 \\ 0 \end{bmatrix} \boldsymbol{\eta}_{t} = \boldsymbol{\Phi} F_{t-1} + G \boldsymbol{\eta}_{t}, \tag{9}$$

where the first expression in (8) writes out the equation for  $X_{it}$  in the dynamic form (1),  $\Lambda_i = [\lambda_{i0} \ \lambda_{i1}]$  is the *i*th row of  $\Lambda$ , and the final expression in (8) is the equation for  $X_{it}$  in the static form (6). The first row in Eq. (9) is the evolution equation of the dynamic factor in (2) and the second row is the identity used to express (2) in first-order form.

In the static form of the DFM, the common component of the *i*th variable is  $\Lambda_i F_t$ , and the idiosyncratic component is  $e_{it}$ .

<span id="page-10-0"></span>With the additional assumptions that the idiosyncratic disturbance follows the autoregression (3) and that the disturbances ( $\nu_t$ ,  $\eta_t$ ) are Gaussian, the one step ahead forecast of the *i*th variable in the static factor model is,

$$E[X_{it+1}|X_t, F_t, X_{t-1}, F_{t-1}, \dots] = \alpha_i^F(L)F_t + \delta_i(L)X_{it}, \tag{10}$$

where  $\alpha_i^F = \Lambda_i \Phi(L) - \delta_i(L) \Lambda_i$ . If the disturbances are non-Gaussian, the expression is the population linear predictor.

The forecasting Eq. (10) is the static factor model counterpart of (5). In both forms of the DFM, the forecast using all the series reduces to a distributed lag of the factors and the individual series. The VAR (7) for  $F_t$  can be written in companion form by stacking the elements of  $F_t$  and its lags, resulting in a representation in which the stacked factor follows a VAR(1), in which case only current values of the stacked vector of factors enter (10).

Multistep ahead forecasts can be computed either by a direct regression onto current and past  $F_t$  and  $X_{it}$ , or by iterating forward the AR model for  $e_{it}$  and the VAR for  $F_t$  (Eqs. (3) and (7)).

In general, the number of static factors r exceeds the number of dynamic factors q because  $F_t$  consists of stacked current and past  $f_t$ . When r > q, the static factors have a dynamic singularity, that is, q - r linear combinations of  $F_t$  are perfectly predictable from past  $F_t$ . In examples (8) and (9), there is a single dynamic factor and two static factors, and the perfectly predictable linear combination is  $F_{2t} = F_{1t-1}$ .

When the numbers of static and dynamic factors are estimated using macroeconomic data, the difference between the estimated values of r and q is often small, as is the case in the empirical work reported in Section 6. As a result, some applications set r = q and G = I in (7). Alternatively, if q < r, the resulting covariance matrix of the static factor innovations, that is, of  $F_t - \Phi(L)F_{t-1} = G\eta_t$ , has rank q, a constraint that can be easily imposed in the applications discussed in this chapter.

#### 2.1.3 Normalization of the Factors

Because the factors are unobserved, they are identified only up to arbitrary normalizations. We first consider the static DFM, then the dynamic DFM.

In the static DFM, the space spanned by  $F_t$  is identified, but  $F_t$  itself is not identified:  $\Lambda F_t = (\Lambda Q^{-1})$  ( $QF_t$ ), where Q is any invertible  $r \times r$  matrix. For many applications, including macro monitoring and forecasting, it is necessary only to identify the space spanned by the factors, not the factors themselves, in which case Q in the foregoing expression is irrelevant. For such applications, the lack of identification is resolved by imposing a mathematically convenient normalization. The two normalizations discussed in this chapter are the "principal components" normalization and the "named factor" normalization.

#### <span id="page-11-0"></span>2.1.3.1 Principal Components Normalization

Under this normalization, the columns of  $\Lambda$  are orthogonal and are scaled to have unit norm:

$$N^{-1}\Lambda'\Lambda = I_r$$
 and  $\Sigma_F$  diagonal ("principal components" normalization) (11)

where  $\Sigma_F = E(F_t F_t')$ .

The name for this normalization derives from its use in principal components estimation of the factors. When the factors are estimated by principal components, additionally the diagonal elements of  $\Sigma_F$  are weakly decreasing.

#### 2.1.3.2 Named Factor Normalization

An alternative normalization is to associate each factor with a specific variable. Thus this normalization "names" each factor. This approach is useful for subsequent structural analysis, as discussed in Section 5 for structural DFMs, however it should be stressed that the "naming" discussed here is only a normalization that by itself it has no structural content.

Order the variables in  $X_t$  so that the first r variables are the naming variables. Then the "named factor" normalization is,

$$\Lambda^{NF} = \begin{bmatrix} I_r \\ \Lambda_{r+1:n}^{NF} \end{bmatrix}, \quad \Sigma_F \text{ is unrestricted ("named factor" normalization)}. \tag{12}$$

Under the named factor normalization, the factors are in general contemporaneously correlated.<sup>e</sup>

The named factor normalization aligns the factors and variables so that the common component of  $X_{1t}$  is  $F_{1t}$ , so that an innovation to  $F_{1t}$  increases the common component of  $X_{1t}$  by one unit and thus increases  $X_{1t}$  by one unit. Similarly, the common component of  $X_{2t}$  is  $F_{2t}$ , so the innovation to the  $F_{2t}$  increases  $X_{2t}$  by one unit.

For example, suppose that the first variable is the price of oil. Then the normalization (12) equates the innovation in the first factor with the innovation in the common component of the oil price. The innovation in the first factor and the first factor itself therefore can be called the oil price factor innovation and the oil price factor.

The named factor normalization entails an additional assumption beyond the principal components normalization, specifically, that matrix of factor loadings on the first r variables (the naming variables) is invertible. That is, let  $\Lambda_{1:r}$  denote the  $r \times r$  matrix of factor loadings on the first r variables in the principal components normalization. Then  $\Lambda_{r+1:N}^{NF} = \Lambda_{1:r}^{-1}\Lambda_{r+1:N}$ . Said differently, the space of innovations of the first r common components must span the space of innovations of the static factors. In practice, the naming variables must be sufficiently different from each other, and sufficiently representative

<sup>&</sup>lt;sup>e</sup> Bai and Ng (2013) refer to (11) and (12) normalizations as the PC1 and PC3 normalizations, respectively, and also discuss a PC2 normalization in which the first  $r \times r$  block of  $\Lambda$  is lower triangular.

<span id="page-12-0"></span>of groups of the other variables, that the innovations to their common components span the space of the factor innovations. This assumption is mild and can be satisfied by suitable choice of the naming variables.

#### 2.1.3.3 Timing Normalization in the Dynamic Form of the DFM

In the dynamic form of the DFM, an additional identification problem arises associated with timing. Because  $\lambda(L)f_t = [\lambda(L)q(L)^{-1}][q(L)f_t]$ , where q(L) is an arbitrary invertible  $q \times q$  lag polynomial matrix, a DFM with factors  $f_t$  and factor loadings  $\lambda(L)$  is observationally equivalent to a DFM with factors q(L)  $f_t$  and factor loadings  $\lambda(L)q(L)^{-1}$ . This lack of identification can be resolved by choosing q variables on which  $f_t$  loads contemporaneously, without leads and lags, that is, for which  $\lambda_i(L) = \lambda_{i0}$ .

## 2.1.4 Low-Frequency Movements, Unit Roots, and Cointegration

Throughout this chapter, we assume that  $X_t$  has been preprocessed to remove large low-frequency movements in the form of trends and unit roots. This is consistent with the econometric theory for DFMs which presumes series that are integrated of order zero (I(0)).

In practice, this preprocessing has two parts. First, stochastic trends and potential deterministic trends arising through drift are removed by differencing the data. Second, any remaining low-frequency movements, or long-term drifts, can be removed using other methods, such as a very low-frequency band-pass filter. We use both these steps in the empirical application in Sections 6 and 7, where they are discussed in more detail.

If some of the variables are cointegrated, then transforming them to first differences loses potentially important information that would be present in the error correction terms (that is, the residual from a cointegrating equation, possibly with cointegrating coefficients imposed). Here we discuss two different treatments of cointegrated variables, both of which are used in the empirical application of Sections 6 and 7.

The first approach for handling cointegrated variables is to include the first difference of some of the variables and error correction terms for the others. This is appropriate if the error correction term potentially contains important information that would be useful in estimating one or more factors. For example, suppose some of the variables are government interest rates at different maturities, that the interest rates are all integrated of order 1 (I(1)), that they are all cointegrated with a single common I(1) component, and the spreads also load on macro factors. Then including the first differences of one rate and the spreads allows using the spread information for estimation of their factors.

The second approach is to include all the variables in first differences and not to include any spreads. This induces a spectral density matrix among these cointegrated variables that is singular at frequency zero, however that frequency zero spectral density matrix is not estimated when the factors are estimated by principal components. This approach is appropriate if the first differences of the factors are informative for the common trend but the cointegrating residuals do not load on common factors. For example,

<span id="page-13-0"></span>in the empirical example in [Sections 7 and 8](#page-81-0), multiple measures of real oil prices are included in first differences. While there is empirical evidence that these oil prices, for example Brent and WTI, are cointegrated, there is no a priori reason to believe that the WTI-Brent spread is informative about broad macro factors, and rather that spread reflects details of oil markets, transient transportation and storage disruptions, and so forth. This treatment is discussed further in [Section 7.2.](#page-84-0)

An alternative approach to handling unit roots and cointegration is to specify the DFM in levels or log levels of some or all of the variables, then to estimate cointegrating relations and common stochastic trends as part of estimating the DFM. This approach goes beyond the coverage of this chapter, which assumes that variables have been transformed to be I(0) and trendless. [Banerjee and Marcellino \(2009\)](#page-103-0)and [Banerjee et al. \(2014,](#page-103-0) [2016\)](#page-103-0) develop a factor-augmented error correction model (FECM) in which the levels of a subset of the variables are expressed as cointegrated with the common factors. The discussion in this chapter about applications and identification extends to the FECM.

# 2.2 DFMs: A Brief Review of Early Literature

Factor models have a long history in statistics and psychometrics. The extension to DFMs was originally developed by [Geweke \(1977\)](#page-106-0) and [Sargent and Sims \(1977\)](#page-109-0), who estimate the model using frequency-domain methods. [Engle and Watson \(1981, 1983\)](#page-105-0) showed how the DFM can be estimated by maximum likelihood using time-domain state-space methods. An important advantage of the time domain over the frequency-domain approach is the ability to estimate the values of the latent factor using the Kalman filter. [Stock and Watson \(1989\)](#page-109-0) used these state-space methods to develop a coincident real activity index as the estimated factor from a four-variable monthly model, and [Sargent \(1989\)](#page-109-0) used analogous state-space methods to estimate the parameters of a six-variable real business cycle model with a single common structural shock.

Despite this progress, these early applications had two limitations. The first was computational: estimation of the parameters by maximum likelihood poses a practical limitation on the number of parameters that can be estimated, and with the exception of the single-factor 60-variable system estimated by [Quah and Sargent \(1993\),](#page-108-0) these early applications had only a handful of observable variables and one or two latent factors. The second limitation was conceptual: maximum likelihood estimation requires specifying a full parametric model, which in practice entails assuming that the idiosyncratic components are mutually independent, and that the disturbances are normally distributed, a less appealing set of assumptions than the weaker ones in [Chamberlain and Rothschild's](#page-104-0) [\(1983\)](#page-104-0) approximate DFM.f For these reasons, it is desirable to have methods that can

<sup>f</sup> This second limitation was, it turns out, more perceived than actual if the number of series is large. [Doz](#page-105-0) [et al. \(2012\)](#page-105-0) show that state-space Gaussian quasi-maximum likelihood is a consistent estimator of the space spanned by the factors under weak assumptions on the error distribution and that allow limited correlation of the idiosyncratic disturbances.

<span id="page-14-0"></span>handle many series and higher dimensional factor spaces under weak conditions on distributions and correlation among the idiosyncratic terms.

The state-space and frequency-domain methods exploit averaging both over time and over the cross section of variables. The key insight behind the nonparametric methods for estimation of DFMs, and in particular principal components estimation of the factors, is that, when the number of variables is large, cross-sectional variation alone can be exploited to estimate the space spanned by the factors. Consistency of the principal components (PC) estimator of  $F_t$  was first shown for T fixed and  $N \to \infty$  in the exact factor model, without lags or any serial correlation, by Connor and Korajczyk (1986). Forni and Reichlin (1998) formalized the cross-sectional consistency of the unweighted crosssectional average for a DFM with a single factor and nonzero average factor loading dynamics. Forni et al. (2000) showed identification and consistency of the dynamic PC estimator of the common component (a frequency-domain method that entails two-sided smoothing). Stock and Watson (2002a) proved consistency of the (time domain) PC estimator of the static factors under conditions along the lines of Chamberlain and Rothschild's (1983) approximate factor model and provided conditions under which the estimated factors can be treated as observed in subsequent regressions. Bai (2003) derived limiting distributions for the estimated factors and common components. Bai and Ng (2006a) provided improved rates for consistency of the PC estimator of the factors. Specifically, Bai and Ng (2006a) show that as  $N \to \infty$ ,  $T \to \infty$ , and  $N^2/T \rightarrow \infty$ , the factors estimated by principal components can be treated as data (that is, the error in estimation of the factors can be ignored) when they are used as regressors.

#### 2.3 Estimation of the Factors and DFM Parameters

The parameters and factors of the DFM can be estimated using nonparametric methods related to principal components analysis or by parametric state-space methods.

### 2.3.1 Nonparametric Methods and Principal Components Estimation

Nonparametric methods estimate the static factors in (6) directly without specifying a model for the factors or assuming specific distributions for the disturbances. These approaches use cross-sectional averaging to remove the influence of the idiosyncratic disturbances, leaving only the variation associated with the factors.

The intuition of cross-sectional averaging is most easily seen when there is a single factor. In this case, the cross-sectional average of  $X_t$  in (6) is  $\bar{X}_t = \overline{\Lambda}F_t + \bar{e}_t$ , where  $\bar{X}_t$ ,  $\overline{\Lambda}$ , and  $\bar{e}_t$ , denote the cross-sectional averages  $\bar{X}_t = N^{-1} \sum_{i=1}^N X_{it}$ , etc. If the cross-sectional correlation among  $\{e_{it}\}$  is limited, then by the law of large numbers  $\bar{e}_t \stackrel{p}{\longrightarrow} 0$ , that is,  $\bar{X}_t - \overline{\Lambda}F_t \stackrel{p}{\longrightarrow} 0$ . Thus if  $\overline{\Lambda} \neq 0$ ,  $\bar{X}_t$  estimates  $F_t$  up to scale. With more than one factor, this argument carries through using multiple weighted averages of  $X_t$ . Specifically, suppose that  $N^{-1}\Lambda'\Lambda$  has a nonsingular limit; then the weighted average

<span id="page-15-0"></span> $N^{-1}\Lambda'X_t$  satisfies  $N^{-1}\Lambda'X_t - N^{-1}\Lambda'\Lambda F_t \xrightarrow{p} 0$ , so that  $N^{-1}\Lambda'X_t$  asymptotically spans the space of the factors. The weights  $N^{-1}\Lambda$  are infeasible because  $\Lambda$  is unknown, however principal components estimation computes the sample version of this weighted average.

#### 2.3.1.1 Principal Components Estimation

Principal components solve the least-squares problem in which  $\Lambda$  and  $F_t$  in (6) are treated as unknown parameters to be estimated:

$$\min_{F_1, \dots, F_T, \Lambda} V_r(\Lambda, F), \text{ where } V_r(\Lambda, F) = \frac{1}{NT} \sum_{t=1}^T (X_t - \Lambda F_t)'(X_t - \Lambda F_t), \tag{13}$$

subject to the normalization (11). Under the exact factor model with homogeneous idiosyncratic variances and factors treated as parameters, (13) is the Gaussian maximum likelihood estimator (Chamberlain and Rothschild, 1983). If there are no missing data, then the solution to the least-squares problem (13) is the PC estimator of the factors,  $\hat{F}_t = N^{-1} \hat{\Lambda}' X_t$ , where  $\hat{\Lambda}$  is the matrix of eigenvectors of the sample variance matrix of  $X_t$ ,  $\hat{\Sigma}_X = T^{-1} \sum_{t=1}^T X_t X_t'$ , associated with the r largest eigenvalues of  $\hat{\Sigma}_X$ .
