# 5. Conclusions

It is well known that, with Gaussian errors, every invertible model has multiple observationally equivalent non-invertible representations, so if one is to distinguish among them, some external information must be brought to bear. One approach is to assume that the shocks are independent and non-Gaussian, and to exploit higher order moment restrictions to identify the causal structure (Lanne and Saikkonen, 2013; Gospodinov and Ng, 2015; Gourieroux et al., 2017). A second approach is to use a priori informative priors (Plagborg-Møller, 2016b). Here, we have shown that there is a third approach, which is to use an external instrument. Through an external instrument, additional information can be brought to bear to identify dynamic causal effects. Under a lead–lag exogeneity condition, the external instrument identifies the structural impulse response function without assuming invertibility.

A number of methodological issues concerning the use of external instruments merit further research. For example, this discussion assumes homogenous treatment effects. Although this assumption seems plausible in a macroeconomic setting (there is only one 'subject', although effects may be state-dependent), more work is warranted. Also, the usual weak-instrument toolkit does not cover all the methods used here, for example, one open question is how to robustify our test of invertibility to potentially weak instruments.

Additionally, an informal argument sometimes made in favour of the local projections method is that it is robust to VAR misspecification concerning lag length, non-linearities and state dependence. In this article, we have put these arguments to one side by assuming a linear, constant-coefficient structural moving average representation. To us, the robustness of LP-IV to non-linearities is not obvious, particularly when the instrument depends in part on lagged shocks: if so, the control variables would need to span the space of those shocks, and it seems that there would be a non-linear counterpart to our no free lunch theorem (Theorem 1). In any event, it would be of interest to see these arguments made precise.

In our view, the most exciting work to be done in this area is empirical. We look forward to the development of new external instruments that provide plausibly exogenous variation to provide more credible identification of dynamic causal effects.

#### Appendix A. Asymptotics and Bootstrap Implementation

#### A.1. Asymptotic Distribution of the Hausman Test Statistic for Invertibility

This Appendix derives the asymptotic distribution (29) under the null of invertibility and under a sequence of local alternatives. For simplicity, we consider the case that the test is based on all impulse responses for a single horizon h and that the instrument is a scalar; extensions to multiple horizons and a vector of instruments is straightforward. Accordingly, we show that  $T^{1/2}(\hat{\Theta}_{h,1}^{SVAR-IV} - \hat{\Theta}_{h,1}^{LP-IV}) \stackrel{d}{\longrightarrow} N(d_h, V_h)$ . This result implies that the test statistic  $\xi$  given in (30) has an asymptotic chi-squared distribution with n degrees of freedom under the null, and a noncentral chi-squared distribution with non-centrality parameter  $\mu^2 = d_h' V_h^{-1} d_h$  under the local alternative.

We begin with the analysis under the null of invertibility. The SVAR is

$$A(L)Y_t = \Theta(L)\varepsilon_t, \tag{A.1}$$

where A(L) is a polynomial of order p. The Wold moving average polynomial is C(L) =  $A(L)^{-1} = I + C_1L + \cdots$ . Under the null hypothesis of invertibility (17), with the maintained hypothesis that  $Y_t$  has the linear structural MA representation (5), the structural IRF satisfies  $H_0$  in (27), that is,  $\Theta_{h,1} = C_h\Theta_{0,1}$  for all h.

For future reference, we note that the SVAR can be written in state-space form as

$$Y_t = SX_t,$$

$$X_t = AX_{t-1} + G\varepsilon_t,$$
(A.2)

where  $X_t = (Y_t' Y_{t1}' \dots Y_{tp+1}')'$ , A is the VAR companion matrix, the upper block of G is  $\Theta_0$  and all other elements of G are zero and  $S = (I_n \ 0 \ \cdots \ 0)$  is a selection matrix.

The local projection equation, written for the vector Y, is

$$Y_{t+h} = \Theta_{h,1} Y_{1,t} + \Gamma_h W_t + u_{t+h}^{h\perp}, \tag{A.3}$$

where the control variables are  $W_t = X_{t-1}$  and, from (A.2),  $\Gamma_h = SA^{h+1}$ . Consistent with Assumption LP-IV<sup> $\perp$ </sup>, we represent  $Z_t$  as

$$Z_t = \beta \varepsilon_{1,t} + B'W_t + e_t, \tag{A.4}$$

where  $e_t$  is uncorrelated with  $\varepsilon_s$  for all t and s. All variables are assumed to be second-order stationary with sample moments that satisfy

$$T^{-1/2} \sum \operatorname{vec}(a_t b_t' - \operatorname{E}(a_t b_t')) \xrightarrow{d} N(0, \Sigma_{ab}), \tag{A.5}$$

for any variables  $(a_t, b_t)$ .

The LP-IV estimator is

$$\hat{\Theta}_{b,1}^{LP-IV} = (Z'M_W Y_{1,0})^{-1} (Y_b'M_W Z), \tag{A.6}$$

where Z denotes the  $T \times 1$  vector of instruments,  $Y_{1,0}$  denotes the  $T \times 1$  vector  $(Y_{1,1} \dots Y_{1,T})'$ ,  $Y_h$  denotes the  $T \times n$  matrix with t'th row  $Y_{t+h}$ ' and  $M_W = I - W(W'W)^{-1}W$ , where W is a  $T \times (np)$  matrix with tth row  $W_t$ '. The SVAR-IV estimator is as follows:

$$\hat{\Theta}_{h,1}^{\text{SVAR-IV}} = \hat{C}_h \hat{\Theta}_{0,1}^{\text{LP-IV}}, \tag{A.7}$$

where  $\hat{C}(L) = \hat{A}(L)^{-1}$  where  $\hat{A}(L)$  is the OLS estimator of A(L).

Under  $H_0$  in (27) and the assumption that  $Z_t$  is a strong instrument, a straightforward calculation then yields

$$T^{1/2} \left( \hat{\Theta}_{h,1}^{\text{SVAR-IV}} - \hat{\Theta}_{h,1}^{\text{LP-IV}} \right) = T^{1/2} \left( \hat{C}_h - C_h \right) \Theta_{0,1}^{\text{LP-IV}}$$

$$+ \alpha^{-1} \left( C_h T^{-1/2} \sum_{t} Z_t^{\perp} u_t^{0\perp} - T^{-1/2} \sum_{t} Z_t^{\perp} u_{t+h}^{h\perp} \right) + o_p(1)$$

$$\xrightarrow{d} N(0, V_h),$$
(A.8)

where the result uses  $Z'\mathbf{M}_WY_{1,0}=Z^{\perp\prime}\mathbf{M}_WY_{1,0}^{\perp}=Z^{\perp\prime}Y_{1,0}^{\perp}+O_p(1)$  and similarly for  $Y_h'\mathbf{M}_WZ$ ,  $T^{-1}Z^{\perp\prime}Y_{1,0}^{\perp}\xrightarrow{p}\alpha=E(Z_t^{\perp}\varepsilon_{1,t})$ , and the delta-method.

We now consider a sequence of stochastic processes that are local to the invertible model and the resulting estimators. Specifically, maintain the definitions of all of the variables and parameters given above (so that  $Y_t$  is generated by the invertible model, etc.), but now consider the sequence of stochastic processes  $Y_{t,T}$ :

$$Y_{t,T} = SX_t + T^{-1/4}\eta_t, (A.9)$$

where  $\eta_t$  is white noise and uncorrelated with  $\varepsilon_{\tau}$  for all t and  $\tau$ . Notice that  $Y_{t,T} = Y_t + T^{-1/4}\eta_b$  so that  $\text{var}(Y_{t,T}) = \text{var}(Y_t) + T^{-1/2}\text{var}(\eta_t)$ , and the autocovariances of  $Y_{t,T}$  and  $Y_t$  coincide for all nonzero lags. The measurement error  $T^{-1/4}\eta_t$  in (A.9) means that  $X_t$  cannot be perfectly recovered from current and lagged values of  $Y_{t,T}$  and  $\varepsilon_t \neq \text{Proj}(\varepsilon_t | Y_{t,T}, Y_{t+1,T}, \ldots)$ , so the model is not invertible.

The implied p-th order VAR for  $Y_{t,T}$  is local to the VAR for  $Y_t$ ; that is

$$A_T(L) = A(L) + T^{-1/2}a(L) + o(T^{-1/2}),$$
 (A.10)

where  $A_T(L)$  denotes the projection of  $Y_{t,T}$  onto  $(Y_{t-1,T},\ldots,Y_{t-p,T})$ . Similarly, the implied moving coefficients,  $A_T(L)^{-1} = I + C_{1,T}L + \ldots$  satisfy  $C_{h,T} = C_h + T^{-1/2}c_h + o(T^{-1/2})$ . Because  $C_h\Theta_0 = \Theta_h$  (the invertible null), we have that  $C_{h,T}\Theta_0 = C_h\Theta_0 + T^{-1/2}c_h\Theta_0 + o(T^{-1/2}) = \Theta_h + O(T^{-1/2})$ 

 $T^{-1/2}d_h + o(T^{-1/2})$ , where  $d_h = c_h\Theta_0$ . Thus, the local contamination in (A.9) implies the nearly invertible moving average sequence (28).

Let  $\hat{A}_T(L)$  denote the OLS estimator of  $A_T(L)$  using  $Y_{t,T}$ . A calculation shows that  $T^{1/2}(\hat{A}_T(L) - \hat{A}(L)) = a(L) + o_p(1)$  and:

$$T^{1/2}(\hat{\mathbf{C}}_{h,T} - \hat{\mathbf{C}}_h) = c_h + o_p(1). \tag{A.11}$$

Although the VAR and MA models for  $Y_t$  and  $Y_{t,T}$  differ by a  $T^{-1/2}$  component, the LP-IV estimators using  $Y_{t,T}$  and  $Y_t$  are equivalent to order  $T^{-1/2}$ . To see this, write the LP equation as:

$$Y_{t+h,T} = \Theta_{h,1} Y_{1,t,T} + \Gamma_{h,T} W_{t,T} + u_{t+h,T}^{h\perp}, \tag{A.12}$$

where  $W_{t,T} = (Y_{t-1,T} \dots Y_{t-p,T})$ . From (A.2) and (A.12),  $\Gamma_{h,T} W_{t,T} = \mathrm{SA}^{h+1} \times \mathrm{Proj}(X_{t-1}|W_{t,T})$  and  $u_{t+h,T}^{h\perp} = u_{t+h}^{h\perp} + T^{-1/4} \eta_{t+h} + g_{t+h}^h$ , where  $g_{t+h}^h = \mathrm{SA}^{h+1} \times [X_{t-1} - \mathrm{Proj}(X_{t-1}|W_{t,T})] = O_p(T^{-1/4})$ . Similarly, let the instruments satisfy:

$$Z_{t,T} = \beta \varepsilon_{1,t} + B' W_{t,T} + e_t, \tag{A.13}$$

where now  $e_t$  is assumed to be uncorrelated with  $\varepsilon_{\tau}$  and  $\eta_{\tau}$  for all t and  $\tau$ . Using instruments that satisfy (A.13) ensures that Condition LP-IV<sup> $\perp$ </sup> holds under both the null and local alternative. Let  $\hat{\Theta}_{h,1}^{LP-IV}(\{Y_{t,T}, Z_{t,T}\})$  denote the LP-IV estimators using  $\{Y_{t,T}, Z_{t,T}\}$ . Using (A.12) and (A.13), it follows that:

$$T^{1/2} \left[ \hat{\Theta}_{h,1}^{\text{LP-IV}} \left( \left\{ Y_{t,T}, Z_{t,T} \right\} \right) - \hat{\Theta}_{h,1}^{\text{LP-IV}} \left( \left\{ Y_{t}, Z_{t} \right\} \right) \right] = o_{p}(1). \tag{A.14}$$

Finally, the SVAR estimator constructed from  $\{Y_{t,T}, Z_{t,T}\}$  is

$$\hat{\Theta}_{h}^{\text{SVAR-IV}}(\{Y_{t,T}, Z_{t,T}\}) = \hat{C}_{h,T}\hat{\Theta}_{0}^{LP-IV}(\{Y_{t,T}, Z_{t,T}\}). \tag{A.15}$$

Equations (A.8), (A.11), (A.14) and (A.15) imply:

$$T^{1/2} \left[ \hat{\Theta}_{h,1}^{\text{SVAR-IV}} \left( \left\{ Y_{t,T}, Z_{t,T} \right\} \right) - \hat{\Theta}_{h,1}^{\text{LP-IV}} \left( \left\{ Y_{t,T}, Z_{t,T} \right\} \right) \right]$$

$$= T^{1/2} \left[ \hat{\Theta}_{h,1}^{\text{SVAR-IV}} \left( \left\{ Y_{t}, Z_{t} \right\} \right) - \hat{\Theta}_{h,1}^{\text{LP-IV}} \left( \left\{ Y_{t}, Z_{t} \right\} \right) \right] + c_{h} \Theta_{0,1} + o_{p}(1)$$

$$\xrightarrow{d} N(d_{h}, V_{h}), \tag{A.16}$$

where  $d_h = c_h \Theta_{0,1}$ .

#### A.2. Parametric Bootstrap Estimation of $V_h$

The standard errors of the estimators in Tables 1 and 2 were computed using the sample variances computed from 1,000 draws from a parametric bootstrap. For each draw, we generated samples of size T for  $(\hat{Y}_t, \hat{Z}_t)$  from the stationary VAR:

$$\begin{bmatrix} \hat{\mathbf{A}}(\mathbf{L}) & 0 \\ 0 & \hat{\rho}(\mathbf{L}) \end{bmatrix} \begin{bmatrix} \tilde{Y}_t \\ \tilde{Z}_t \end{bmatrix} = \begin{bmatrix} \tilde{v}_t \\ \tilde{e}_t \end{bmatrix}, \text{ where } \begin{bmatrix} \tilde{v}_t \\ \tilde{e}_t \end{bmatrix} \sim i.i.d. \ N \begin{pmatrix} \begin{bmatrix} 0 \\ 0 \end{bmatrix}, \begin{bmatrix} \mathbf{S}_{\hat{v}\hat{v}} & \mathbf{S}_{\hat{v}\hat{e}} \\ \mathbf{S}_{\hat{e}\hat{v}} & \mathbf{S}_{\hat{e}\hat{e}} \end{bmatrix} \end{pmatrix}, \tag{A.17}$$

where  $\hat{A}(L)$  is estimated from a VAR(12),  $\hat{\rho}(L)$  is estimated from an AR(4) and  $S_{\hat{v}\hat{v}}$ ,  $S_{\hat{v}\hat{v}}$  and  $S_{\hat{e}\hat{e}}$  are sample covariances for the VAR/AR residuals. These samples are used to compute the SVAR-IV and LP-IV estimates of  $\Theta_{h,1}$ .

Harvard University and the National Bureau of Economic Research Woodrow Wilson School, Princeton University and the National Bureau of Economic Research © 2018 Royal Economic Society.

Additional Supporting Information may be found in the online version of this article:

# Data S1.

# References

Aikman, D., Bush, O. and Taylor, A.M. (2016), 'Monetary versus macroprudential policies: causal impacts of interest rates and credit controls in the era of the UK Radcliffe report', NBER Working Paper No. 22380.

Andrews, I. (2018), 'Valid two-step identification-robust confidence sets for GMM', Review of Economics and Statistics. [https://doi.org/10.1162/REST\\_a\\_00682](https://doi.org/10.1162/REST_a_00682)

Angrist, J.D., Jorda, O. and Kuersteiner, G.M. (2018). 'Semiparametric estimates of monetary policy effects: string theory revisited', Journal of Business and Economic Statistics. [https://doi.org/10.1080/07350015.](https://doi.org/10.1080/07350015.2016.1204919) [2016.1204919](https://doi.org/10.1080/07350015.2016.1204919)

Barnichon, R. and Brownlees, C. (2016). 'Impulse response estimation by smooth local projections', CEPR Discussion Paper No. DP11726.

Beaudry, P., Feve, P., Guay, A. and Portier, F. (2015). 'When is non-fundamentalness in VARs a real problem? An application to news shocks', manuscript, University of British Columbia.

Beaudry, P. and Saito, M. (1998). 'Estimating the effects of monetary policy shocks: an evaluation of different approaches', Journal of Monetary Economics, vol. 42(2), pp. 241–60.

Bernanke, B.S. and Kuttner, K.N. (2005). 'What explains the stock market's reaction to federal reserve policy?', Journal of Finance, vol. 60(3), pp. 1221–57.

Bojinov, I. and Shephard, N. (2017). 'Time series experiments, causal estimands, exact p-values, and trading', manuscript, Harvard University.

Caldara, D. and Kamps, C. (2017). 'The analytics of SVARs: a unified framework to measure fiscal multipliers', Review of Economic Studies, vol. 73 (1), pp. 195–218.

Chahrour, R. and Jurado, K. (2017). 'Recoverability', manuscript, Duke University.

Cochrane, J.H. and Piazzesi, M. (2002). 'The fed and interest rates: a high-frequency identification', American Economic Review, vol. 92(May), pp. 90–5.

Faust, J., Rogers, J.H., Swanson, E. and Wright, J.H. (2003). 'Identifying the effects of monetary policy shocks on exchange rates using high frequency data', Journal of the European Economic Association, vol. 1(5), pp. 1031–57.

Fernandez-Villaverde, J., Rubio-Ramırez, J.F., Sargent, T.J. and Watson, M.W. (2007). 'The ABCs (and Ds) of understanding VARs', American Economic Review, vol. 97(3), pp. 1021–6.

Fieldhouse, A., Mertens, K. and Ravn, M.O. (2017). 'The macroeconomic effects of government asset purchases: evidence from postwar U.S. housing credit policy', NBER Working Paper No. 23154.

Forni, M. and Gambetti, L. (2014). 'Sufficient information in structural VARs', Journal of Monetary Economics, vol. 66(C), pp. 124–36.

Forni, M., Giannone, D., Lippi, M. and Reichlin, L. (2009). 'Opening the black box: structural factor models with large cross sections', Econometric Theory, vol. 25(5), pp. 1319–47.

Frisch, R. (1933). 'Propagation problems and impulse problems in dynamic economics', in (R. Krammer, ed.), Economic Essays in Honor of Gustav Cassel, pp. 171–205, London: Allen & Unwin.

Gertler, M. and Karadi, P. (2015). 'Monetary policy surprises, credit costs, and economic activity', American Economic Journal: Macroeconomics, vol. 7(1), pp. 44–76.

Gilchrist, S. and Zakrajsek, E. (2012). 'Credit spreads and business cycle fluctuations', American Economic Review, vol. 102(4), pp. 1692–720.

Gospodinov, N. and Ng, S. (2015). 'Minimum distance estimation of possibly noninvertible moving average models', Journal of Business & Economic Statistics, vol. 33(3), pp. 403–17.

Gourieroux, C., Monfort, A. and Renne, J.-P. (2017). 'Statistical inference for independent component analysis: application to structural VAR models', Journal of Econometrics, vol. 196(1), pp. 111–26.

Gurkaynak, R.S., Sack, B. and Swanson, E. (2005). 'The sensitivity of long-term interest rates to economic news: € evidence and implications for macroeconomic models', American Economic Review, vol. 95(1), pp. 425–36.

Hamilton, J.D. (2003). 'What is an oil shock?', Journal of Econometrics, vol. 113(2), pp. 363–98.

Hausman, J.A. (1978). 'Specification tests in econometrics', Econometrica, vol. 46(6), pp. 1251–71.

Hayashi, F. (2000). Econometrics, Princeton, NJ: Princeton University Press.

Imbens, G. (2014). 'Instrumental variables: an econometrician's perspective', Statistical Science, vol. 29(3), pp. 323–58.

Jorda, O. (2005). 'Estimation and inference of impulse responses by local projections', American Economic Review, vol. 95(1), pp. 161–82.

Jorda, O., Schularick, M. and Taylor, A.M. (2015). 'Betting the house', Journal of International Economics, vol. 96(Supplement 1), pp. S2–18.

Jorda, O., Schularick, M. and Taylor, A.M. (2017). 'Large and state-dependent effects of quasi-random monetary experiments', NBER Working Paper No. 23074.

- Kilian, L. (2008). 'Exogenous oil supply shocks: how big are they and how much do they matter for the U.S. economy?', Review of Economics and Statistics, vol. 90(2), pp. 216–40.
- Kim, Y.J. and Kilian, L. (2011). 'How reliable are local projection estimators of impulse responses?', Review of Economics and Statistics, vol. 93(4), pp. 1460–6.
- Kleibergen, F. (2005). 'Testing parameters in GMM without assuming they are identified', Econometrica, vol. 73(4), pp. 1103–23.
- Kuttner, K.N. (2001). 'Monetary policy surprises and interest rates: evidence from the Fed funds futures market', Journal of Monetary Economics, vol. 47(3), pp. 523–44.
- Lanne, M. and Saikkonen, P. (2013). 'Noncausal vector autoregression', Econometric Theory, vol. 29(3), pp. 447–81. Lechner, M. (2009). 'Sequential causal models for the evaluation of labor market programs', Journal of the American Statistical Association, vol. 27(1), pp. 71–83.
- McCracken, M. and Ng, S. (2016). 'FRED-MD: a monthly database for macroeconomic research', Journal of Business and Economic Statistics, vol. 34(4), pp. 574–89.
- Mertens, K. (2015). 'Bonn summer school: advances in empirical macroeconomics, lecture 2' (slide deck). <https://karelmertenscom.files.wordpress.com/2017/09/lecture2.pdf> (last accessed 22 March 2018)
- Mertens, K. and Ravn, M.O. (2013). 'The dynamic effects of personal and corporate income tax changes in the United States', American Economic Review, vol. 103(4), pp. 1212–47.
- Miranda-Agrippino, S. and Ricco, G. (2017). 'The transmission of monetary policy shocks', manuscript, Department of Economics, University of Warwick.
- Montiel Olea, J.L. and Pflueger, C. (2013). 'A robust test for weak instruments', Journal of Business and Economic Statistics, vol. 31(3), pp. 358–69.
- Montiel Olea, J., Stock, J.H. and Watson, M.W. (2017). 'Inference in structural VARs with external instruments', manuscript.
- Moreira, M. (2003). 'A conditional likelihood ratio test for structuralmodels', Econometrica, vol. 71(4), pp. 1027–48. Plagborg-Møller,M. (2016a), 'Estimation of smooth impulse response functions',manuscript,Harvard University.
- Plagborg-Møller, M. (2016b), 'Bayesian Inference on Structural Impulse Response Functions', manuscript, Harvard University.
- Plagborg-Møller, M. and Wolf, C. (2017), 'On Structural Inference with External Instruments', manuscript, Princeton University.
- Ramey, V. (2011). 'Identifying government spending shocks: it's all in the timing', Quarterly Journal of Economics, vol. 126(1), pp. 1–50.
- Ramey, V. (2016). 'Macroeconomic shocks and their propagation', in (J. B. Taylor and H. Uhlig, eds.), Handbook of Macroeconomics, vol. 2A, pp. 71–162, Amsterdam: Elsevier.
- Ramey, V. and Zubairy, S. (2017). 'Government spending multipliers in good times and in bad: evidence from U.S. historical data', Journal of Political Economy, vol. 119(1), pp. 78–121.
- Romer, C.D. and Romer, D.H. (1989). '"Does monetary policy matter? A new test in the spirit of Friedman and Schwartz" (with discussion)', in (O.J. Blanchard and S. Fischer, eds.), NBER Macroeconomics Annual 1989, pp. 121–70, Cambridge, MA: MIT Press.
- Romer, C.D. and Romer, D.H. (2010). 'The macroeconomic effects of tax changes: estimates based on a new measure of fiscal shocks', American Economic Review, vol. 100(3), pp. 763–801.
- Rothenberg, T.J. and Leenders, C.T. (1964). 'Efficient estimation of simultaneous equation systems', Econometrica, vol. 32(4), pp. 57–76.
- Rudebusch, G.D. (1998). 'Do measures of monetary policy in a VAR make sense?', International Economic Review, vol. 39(4), pp. 907–48.
- Sargan, D. (1964). 'Three-stage least-squares and full information maximum likelihoood estimates', Econometrica, vol. 32(1/2), pp. 77–81.
- Sims, C.A. (1980). 'Macroeconomics and reality', Econometrica, vol. 48(1), pp. 1–48.
- Slutsky, E. (1937). 'The summation of random causes as the source of cyclic processes', Econometrica, vol. 5(2), pp. 105–46.
- Stock, J.H. (2008). 'What's new in econometrics: time series', lecture 7. Short course lectures, NBER Summer Institute. [http://www.nber.org/minicourse\\_2008.html](http://www.nber.org/minicourse_2008.html) (last accessed 22 March 2018).
- Stock, J.H. and Watson, M.W. (2012). 'Disentangling the channels of the 2007–2009 recession', Brookings Papers on Economic Activity, vol. 1(1), pp. 81–135.
- Stock, J.H. and Watson, M.W. (2016). 'Dynamic factor models, factor-augmented vector autoregressions, and structural vector autoregressions in macroeconomics', in (J.B. Taylor and H. Uhlig, eds.), Handbook of Macroeconomics, vol. 2A, pp. 415–525, Amsterdam: Elsevier.
- Theil, H. and Boot, J.C.G. (1962). 'Revue de l'Institut International de Statistique', Review of the International Statistical Institute, vol. 30(2), pp. 136–52.
- Wright, P.G. (1928). The Tariff on Animal and Vegetable Oils, New York: McMillan.
- Zellner, A. (1962). 'An efficient method of estimating seemingly unrleated regressions and tests for aggregation bias', Journal of the American Statistical Association, vol. 57(298), pp. 348–68.
- Zellner, A. and Theil, H. (1962). 'Three-stage least squares: simultaneous estimation of simultaneous equations', Econometrica, vol. 30(1), pp. 54–78.