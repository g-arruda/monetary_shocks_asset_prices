## (a) AR(1)-EGARCH model (Engle and Ng, 1993)

DGP: 
$$y_t = \phi_1 y_{t-1} + \varepsilon_t$$
,  $\varepsilon_t = h_t^{1/2} v_t$ ,  $ln(h_t) = -0.23 + 0.9 ln(h_{t-1}) + 0.25[|v_{t-1}^2| - 0.3v_{t-1}]$   
 $v_t \sim N(0, 1)$ 

| n   | $\phi_1$ | Recursive i.i.d. | Recursive<br>WB | Fixed<br>WB | Pairwise | Robust SE<br>Gaussian |
|-----|----------|------------------|-----------------|-------------|----------|-----------------------|
| 50  | 0        | 79.4             | 88.7            | 88.2        | 89.6     | 85.3                  |
|     | 0.9      | 79.5             | 84.6            | 81.2        | 82.3     | 77.4                  |
| 100 | 0        | 73.8             | 90.0            | 89.3        | 89.4     | 86.1                  |
|     | 0.9      | 80.1             | 87.4            | 85.1        | 86.6     | 83.3                  |
| 200 | 0        | 68.7             | 89.7            | 89.1        | 90.0     | 87.3                  |
|     | 0.9      | 78.3             | 88.7            | 87.4        | 88.6     | 86.6                  |
| 400 | 0        | 63.8             | 89.8            | 89.1        | 90.2     | 88.0                  |
|     | 0.9      | 74.5             | 89.3            | 88.3        | 89.4     | 88.2                  |

#### (b) AR(1)-AGARCH model (Engle, 1990)

DGP: 
$$y_t = \phi_1 y_{t-1} + \varepsilon_t$$
,  $\varepsilon_t = h_t^{1/2} v_t$ ,  $h_t = 0.0216 + 0.6896 h_{t-1} + 0.3174 [\varepsilon_{t-1} - 0.1108]^2$   
 $v_t \sim N(0, 1)$ 

| n   | $\phi_1$ | Recursive i.i.d. | Recursive<br>WB | Fixed<br>WB | Pairwise | Robust SE<br>Gaussian |
|-----|----------|------------------|-----------------|-------------|----------|-----------------------|
| 50  | 0        | 80.7             | 89.2            | 88.4        | 89.8     | 85.6                  |
|     | 0.9      | 80.3             | 84.5            | 81.2        | 82.6     | 77.4                  |
| 100 | 0        | 74.8             | 89.8            | 89.3        | 89.5     | 86.2                  |
|     | 0.9      | 79.8             | 87.4            | 85.6        | 86.5     | 83.8                  |
| 200 | 0        | 68.5             | 90.0            | 89.3        | 90.0     | 87.5                  |
|     | 0.9      | 76.5             | 88.9            | 87.8        | 88.7     | 86.8                  |
| 400 | 0        | 62.0             | 89.8            | 89.1        | 89.8     | 87.9                  |
|     | 0.9      | 68.8             | 89.3            | 88.6        | 90.0     | 88.2                  |

#### (c) AR(1)-GJR GARCH model (Glosten et al., 1993)

DGP: 
$$y_t = \phi_1 y_{t-1} + \varepsilon_t$$
,  $\varepsilon_t = h_t^{1/2} v_t$ ,  $h_t = 0.005 + 0.7 h_{t-1} + 0.28[|\varepsilon_{t-1}| - 0.23\varepsilon_{t-1}]^2$   
 $v_t \sim N(0, 1)$ 

| n   | $\phi_1$ | Recursive i.i.d. | Recursive<br>WB | Fixed<br>WB | Pairwise | Robust SE<br>Gaussian |
|-----|----------|------------------|-----------------|-------------|----------|-----------------------|
| 50  | 0        | 81.8             | 89.3            | 88.5        | 90.0     | 85.8                  |
|     | 0.9      | 80.0             | 84.4            | 81.4        | 82.3     | 77.4                  |
| 100 | 0        | 75.8             | 90.2            | 89.6        | 89.3     | 86.2                  |
|     | 0.9      | 79.7             | 87.7            | 85.4        | 86.3     | 83.6                  |
| 200 | 0        | 70.1             | 90.2            | 89.5        | 89.9     | 87.8                  |
|     | 0.9      | 77.2             | 89.0            | 87.8        | 89.0     | 87.0                  |
| 400 | 0        | 64.1             | 90.1            | 89.5        | 90.2     | 88.5                  |
|     | 0.9      | 70.5             | 89.6            | 88.9        | 90.2     | 88.8                  |

<span id="page-15-0"></span>Table 4
Contd.
(d) AR(1)-stochastic volatility model (Shephard, 1996)

| n   | $\phi_1$ | λ     | $\sigma_u$ | Recursive i.i.d. | Recursive<br>WB | Fixed<br>WB | Pairwise | Robust SE<br>Gaussian |
|-----|----------|-------|------------|------------------|-----------------|-------------|----------|-----------------------|
| 50  | 0        | 0.936 | 0.424      | 82.3             | 88.0            | 87.2        | 89.3     | 85.8                  |
|     |          | 0.951 | 0.314      | 84.9             | 89.9            | 87.8        | 89.4     | 85.8                  |
|     | 0.9      | 0.936 | 0.424      | 80.5             | 84.4            | 80.7        | 83.0     | 77.4                  |
|     |          | 0.951 | 0.314      | 82.0             | 83.9            | 80.2        | 81.8     | 77.4                  |
| 100 | 0        | 0.936 | 0.424      | 78.2             | 89.5            | 88.8        | 89.7     | 86.2                  |
|     |          | 0.951 | 0.314      | 81.5             | 89.8            | 88.9        | 89.6     | 86.2                  |
|     | 0.9      | 0.936 | 0.424      | 82.0             | 87.7            | 85.7        | 86.3     | 83.6                  |
|     |          | 0.951 | 0.314      | 83.5             | 87.6            | 85.1        | 85.8     | 83.6                  |
| 200 | 0        | 0.936 | 0.424      | 73.0             | 89.7            | 89.0        | 89.4     | 87.8                  |
|     |          | 0.951 | 0.314      | 78.1             | 89.7            | 89.2        | 89.6     | 87.4                  |
|     | 0.9      | 0.936 | 0.424      | 79.6             | 89.2            | 87.5        | 88.4     | 87.0                  |
|     |          | 0.951 | 0.314      | 82.2             | 89.0            | 87.5        | 88.0     | 87.0                  |
| 400 | 0        | 0.936 | 0.424      | 69.3             | 89.8            | 89.2        | 90.0     | 88.5                  |
|     |          | 0.951 | 0.314      | 74.7             | 90.0            | 89.5        | 89.6     | 88.5                  |
|     | 0.9      | 0.936 | 0.424      | 76.4             | 89.7            | 89.0        | 89.4     | 88.8                  |
|     |          | 0.951 | 0.314      | 79.9             | 89.5            | 88.7        | 89.2     | 88.8                  |

accuracy of the recursive-design WB even for EGARCH, AGARCH and GJR-GARCH error processes is surprising, given its lack of theoretical support for these DGPs. Apparently, the failure of the sufficient conditions for the asymptotic validity of the recursive-design WB method has little effect on its performance in small samples. Fortunately, applications in finance, for which such asymmetric volatility models have been developed, invariably involve large sample sizes, conditions under which pairwise resampling is just as accurate as the recursive-design WB and theoretically justified.

We conclude this section with a sensitivity analysis of the effect that the choice of  $\eta_t$  has on the performance of the wild bootstrap. To conserve space, we focus on the recursive-design WB only. In the baseline simulations we used  $\eta_t \sim N(0,1)$ . Table 5 shows additional results based on the two-point distribution  $\eta_t = -(\sqrt{5} - 1)/2$  with probability  $p = (\sqrt{5} + 1)/(2\sqrt{5})$  and  $\eta_t = (\sqrt{5} + 1)/2$  with probability 1 - p, as proposed by Mammen (1993), and the two-point distribution  $\eta_t = 1$  with probability 0.5 and  $\eta_t = -1$  with probability 0.5, as proposed by Liu (1988). The DGPs involve N-GARCH errors as in Table 2. The baseline results for  $\eta_t \sim N(0,1)$  are also included for comparison. Table 5 shows that the coverage results are remarkably robust to the choice of  $\eta_t$ . Moreover, none of the three WB resampling schemes clearly dominates the others.

Given the computational costs of the simulation study, we have chosen to focus on a stylized autoregressive model, but have explored a wide range of conditionally heteroskedastic errors. Although our simulation results are necessarily tentative, they suggest that the recursive-design WB for autoregressions should replace conventional

<span id="page-16-0"></span>Table 5 Coverage rates of nominal 90% symmetric percentile-t intervals for  $\phi_1$ : AR(1)-N-GARCH model

|     | $\phi_1$ | $\alpha + \beta$ | α    | β    | Alternativ | ve recursive-de | esign WB schemes |
|-----|----------|------------------|------|------|------------|-----------------|------------------|
|     |          |                  |      |      | N(0,1)     | Mammen          | Liu              |
| 50  | 0        | 0                | 0    | 0    | 90.1       | 89.2            | 88.9             |
|     |          | 0.5              | 0.5  | 0    | 88.9       | 88.9            | 88.6             |
|     |          | 0.95             | 0.3  | 0.65 | 89.2       | 88.9            | 88.7             |
|     |          | 0.99             | 0.2  | 0.79 | 89.5       | 89.1            | 88.8             |
|     |          | 0.99             | 0.05 | 0.94 | 90.1       | 89.1            | 88.7             |
|     | 0.9      | 0                | 0    | 0    | 83.2       | 83.8            | 84.3             |
|     |          | 0.5              | 0.5  | 0    | 84.4       | 85.2            | 85.4             |
|     |          | 0.95             | 0.3  | 0.65 | 84.0       | 84.0            | 84.6             |
|     |          | 0.99             | 0.2  | 0.79 | 83.6       | 83.7            | 84.3             |
|     |          | 0.99             | 0.05 | 0.94 | 83.3       | 83.7            | 84.3             |
| 100 | 0        | 0                | 0    | 0    | 90.2       | 90.0            | 89.4             |
|     |          | 0.5              | 0.5  | 0    | 89.3       | 89.3            | 88.7             |
|     |          | 0.95             | 0.3  | 0.65 | 89.6       | 89.4            | 89.2             |
|     |          | 0.99             | 0.2  | 0.79 | 90.1       | 89.4            | 89.1             |
|     |          | 0.99             | 0.05 | 0.94 | 90.4       | 89.8            | 89.4             |
|     | 0.9      | 0                | 0    | 0    | 87.5       | 87.0            | 87.3             |
|     |          | 0.5              | 0.5  | 0    | 87.8       | 87.9            | 88.1             |
|     |          | 0.95             | 0.3  | 0.65 | 87.9       | 87.2            | 87.6             |
|     |          | 0.99             | 0.2  | 0.79 | 87.8       | 87.4            | 87.9             |
|     |          | 0.99             | 0.05 | 0.94 | 87.5       | 87.1            | 87.4             |
| 00  | 0        | 0                | 0    | 0    | 90.5       | 90.3            | 89.9             |
|     |          | 0.5              | 0.5  | 0    | 89.3       | 89.3            | 89.0             |
|     |          | 0.95             | 0.3  | 0.65 | 89.4       | 89.6            | 89.2             |
|     |          | 0.99             | 0.2  | 0.79 | 89.7       | 89.8            | 89.4             |
|     |          | 0.99             | 0.05 | 0.94 | 90.4       | 90.0            | 89.6             |
|     | 0.9      | 0                | 0    | 0    | 88.9       | 88.9            | 89.0             |
|     | 0.5      | 0.5              | 0.5  | 0    | 88.6       | 89.5            | 89.7             |
|     |          | 0.95             | 0.3  | 0.65 | 89.4       | 89.5            | 89.5             |
|     |          | 0.99             | 0.2  | 0.79 | 89.8       | 89.5            | 89.7             |
|     |          | 0.99             | 0.05 | 0.94 | 89.3       | 89.4            | 89.4             |
| 00  | 0        | 0                | 0    | 0    | 90.8       | 90.4            | 90.1             |
|     | Ü        | 0.5              | 0.5  | 0    | 90.0       | 89.9            | 89.6             |
|     |          | 0.95             | 0.3  | 0.65 | 90.2       | 90.0            | 89.7             |
|     |          | 0.99             | 0.2  | 0.79 | 90.6       | 90.2            | 89.8             |
|     |          | 0.99             | 0.05 | 0.94 | 90.8       | 90.3            | 90.2             |
|     | 0.9      | 0                | 0    | 0    | 89.7       | 90.0            | 89.7             |
|     | 0.5      | 0.5              | 0.5  | 0    | 89.3       | 90.2            | 90.2             |
|     |          | 0.95             | 0.3  | 0.65 | 89.5       | 90.0            | 90.2             |
|     |          | 0.99             | 0.2  | 0.79 | 89.7       | 90.1            | 90.1             |
|     |          | 0.99             | 0.05 | 0.75 | 89.7       | 90.0            | 90.0             |

recursive design i.i.d. bootstrap methods in many applications. The pairwise bootstrap provides a suitable alternative when sample sizes are at least moderately large and the possibility of asymmetric forms of GARCH is a practical concern. Even for moderate

<span id="page-17-0"></span>sample sizes the accuracy of the pairwise bootstrap is slightly higher than that of the 1xed-design bootstrap.

# 5. Concluding remarks

The aim of the paper has been to extend the range of applications of autoregressive bootstrapmethods in empirical 1nance and macroeconometrics. We analyzed the theoretical properties of three bootstrap procedures for stationary autoregressions that are robust to conditional heteroskedasticity of unknown form: the 1xed-design WB, the recursive-design WB and the pairwise bootstrap. Throughout the paper, we established conditions for the 1rst-order asymptotic validity of these bootstrap procedures. We did not attempt to address the issue of the existence of higher-order asymptotic re1nements provided by the bootstrap approximation. Arguments aimed at proving asymptotic re1nements require the existence of an Edgeworth expansion for the distribution [of the estimator o](#page-31-0)f interest. Establishing the existence of such an Edgeworth expansion is beyond the scope of this paper. Moreover, the quality of the 1nite-sample approximation provided by analytic Edgeworth expansions often is poor and less accurate than bootstrap approximations. Thus, Edgeworth expansions in general are imperfect guides to the relative accuracy of alternative bootstrapmethods (see HPardle et al., 2001). Indeed, preliminary simulation evidence indicates that wild bootstrapmethods based on two-point distributions, which may be expected to yield asymptotic re1nements in our context, do not perform systematically better than the 1rst-order accurate methods studied in this paper. Nevertheless, we found that the robust bootstrap approximation is typically more accurate in small samples than the usual 1rst-order asymptotic approximation based on robust standard errors. Our simulation results also highlighted the dangers of incorrectly modelling the error term in dynamic regression models as i.i.d. We found that conventional residual-based bootstrapmethods may be very inaccurate in the presence of conditional heteroskedasticity.

Based on the theoretical and simulation results in this paper, no single bootstrap method for dealing with conditional heteroskedasticity of unknown form will be optimal in all cases. The recursive-design WB seems best suited for applications in empirical macroeconomics. This method performs well, whether the error term of the autoregression is i.i.d. or conditionally heteroskedastic, but it lacks theoretical justi1cation for some forms of asymmetric GARCH that have 1gured prominently in the literature on high-frequency returns. When the sample size is at least moderately large and asymmetric forms of GARCH are a practical concern, the pairwise bootstrap method provides a suitable alternative. The 1xed-design WB has the same theoretical justi1catio[n as the pairwise bootstrap for](#page-31-0) parametric models, but appears to be less accurate in practice.

There are several interesting extensions of the approach taken in this paper. One possible extension is the development of bootstrap methods for conditionally heteroskedastic stationary autoregressions of possibly in1nite order. This extension is considered in Gon\*calves and Kilian (2003). Another useful extension would be to establish the validity of the recursive-design WB for regression parameters in I(1) autoregressions that can be written in terms of zero mean stationary regressors, generalizing recent work by Inoue and Kilian (2002) on I(1) autoregressive models with i.i.d. errors. Yet another useful extension would be to establish the asymptotic validity of robust versions of the grid bootstrap of Hansen (1999). These extensions are nontrivial and left for future research.
