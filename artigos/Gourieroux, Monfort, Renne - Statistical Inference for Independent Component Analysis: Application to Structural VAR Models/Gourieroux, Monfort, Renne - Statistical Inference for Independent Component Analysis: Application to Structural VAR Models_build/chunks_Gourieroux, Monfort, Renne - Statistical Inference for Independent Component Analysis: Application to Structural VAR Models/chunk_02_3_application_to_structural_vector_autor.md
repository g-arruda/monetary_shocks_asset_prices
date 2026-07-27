## 3 Application to Structural Vector Autoregressive Models

In this section, we show how the PML approach presented in the previous section can be applied to identify structural shocks in vector autoregressive models.<sup>19</sup> In essence, the structural shocks that underlie this kind of modelling are expected to be independent: if this was not the case, it would mean that it is impossible to shock one component of  $\varepsilon_t$  without affecting the others.

To begin with, let us explain how the results obtained in the context of Equation (2.1) can be extended to a more general model.

#### 3.1 Extension to the dynamic case and impulse response functions

The results of the subsections above can be used to derive consistent semi-parametric estimators in models of the type:

$$Y_t = a(X_t; \theta) + SC\varepsilon_t, \tag{2.19}$$

where  $E(Y_t|X_t) = a(X_t;\theta), V(Y_t|X_t) = \Sigma$ , C is an orthogonal matrix, S is any matrix satisfying  $SS' = \Sigma$  (it can for instance be the matrix resulting from the Cholesky decomposition of  $\Sigma$  with positive diagonal entries) and  $(\varepsilon_t)$  satisfies Assumption A.1.

The parameters  $\theta, \Sigma$  can be estimated by nonlinear least squares:  $\hat{\theta}_T$  is the solution of:

$$\hat{\theta}_T = \arg\min_{\theta} \sum_{t=1}^T ||Y_t - a(X_t; \theta)||^2.$$

Then a consistent estimator of  $\Sigma$  is:

$$\hat{\Sigma}_T = \frac{1}{T} [Y_t - a(X_t; \hat{\theta}_T)] [Y_t - a(X_t; \hat{\theta}_T)]'.$$

These first-step estimators are used to compute standardized OLS residuals:

$$\hat{u}_t = \hat{S}_T^{-1}[Y_t - a(X_t; \hat{\theta}_T)],$$

<sup>&</sup>lt;sup>19</sup>Comprehensive presentations of VAR models and reviews of this literature are provided by, e.g., Canova (1994), Watson (1994), Stock and Watson (2001), or Lütkepohl (2005).

#### Application to Structural Vector Autoregressive Models

where  $\hat{S}_T$  is such that  $\hat{S}_T \hat{S}_T' = \hat{\Sigma}_T$ . The orthogonal matrix C is finally estimated by applying the PML approach on the series of residuals  $\hat{u}_t$ .

This consistent estimation approach can be applied to dynamic models. In particular it can be used to identify independent shocks in a SVAR model [see e.g. Chen, Choi, Escanciano (2012), Moneta et al. (2013), Gourieroux, Monfort (2014)]. In this case the explanatory variables  $X_t$  are larged endogenous variables and the model of interest is:

$$\Phi(L)Y_t = SC\varepsilon_t$$

with  $\Phi(L) = Id - \Phi_1 L - \dots - \Phi_p L^p$ , L being the lag operator and the roots of  $\det \Phi(L)$  being outside the unit circle. In this context, the independent components  $\varepsilon_{j,t}$  of  $\varepsilon_t$  are called "structural" shocks. Inverting  $\Phi(L)$  gives the infinite moving average representation:

$$Y_t = \sum_{k=0}^{\infty} \Theta_k SC\varepsilon_{t-k}$$
, with  $\Theta_0 = Id$ .

The impulse response function (IRF) of  $Y_{i,t}$  to a unitary shock on  $\varepsilon_{j,t}$  is the sequence:

$$IRF_{i,j}(k) = \Theta_{i,k}Sc_j$$

where  $\Theta_{i,k}$  is the  $i^{th}$  row of  $\Theta_k$ . The estimation results in the estimated IRF:

$$\widehat{IRF}_{i,j}(k) = \hat{\Theta}_{i,k} \hat{S}_T \hat{c}_j.$$

Importantly, the fact that  $\lim_{T\to\infty} \hat{C}_T$  is one or another element of  $\mathscr{P}(C_0)$  is totally harmless. Indeed the ordering of the components of  $\varepsilon_t$  is arbitrary; it is just a problem of labelling of these components. Similarly it is always possible to rename  $-\varepsilon_{j,t}$  as  $\varepsilon_{j,t}$  and to change the sign of  $c_j$  accordingly.

The economic interpretation of the structural independent shocks  $\varepsilon_{j,t}$  can be based on the shapes of the impulse response function  $\{\widehat{IRF}_{i,j}(k), k = 0, 1, 2, ..., \}$  for 1, ..., n, that are perfectly identified in our context, without any additional conditions. This is illustrated in the next subsection.

## 3.2 An application to U.S. macroeconomic data

In this subsection, we show how independent component analysis can be used to identify structural shocks and their associated impulse response functions (IRFs) in the context of vector autoregressive (VAR) models. For the sake of illustration, we consider a small-scale VAR model involving

#### Application to Structural Vector Autoregressive Models

three dependent variables stacked in vector  $Y_t$  (say), that are the inflation  $(\pi_t)$ , the economic activity  $(y_t)$  and the nominal short-term interest rate  $(r_t)$ . In this context, the structural shocks we aim at identifying are as follows: a monetary-policy shock, a demand shock and a supply shock.

The reduced-form VAR model takes the form of Equation (2.19), where  $X_t$  denotes the set of information made of the past values of  $Y_t$ , that is  $\{Y_{t-1}, Y_{t-2}, \dots\}$ , and of exogenous variables  $\{Z_t, Z_{t-1}, \dots\}$ . The mean of  $Y_t$  conditional on  $X_t$  is given by  $a(X_t; \theta) = \mu + \sum_{i=1}^p \Phi_i Y_{t-1} + \Gamma Z_t$ , and the  $u_t$ 's are serially independent, with zero mean and variance-covariance matrix  $\Sigma$  conditional on  $X_t$ .

Our dataset covers the period from 1959:IV to 2015:I at the quarterly frequency (T=224). All data are extracted from the Federal Reserve Economic Database (FRED). We consider two different measures of economic activity extensively used in the literature, that are the output gap and the unemployment gap, respectively.<sup>20</sup> Inflation is calculated as the change in the logarithm of the GDP deflator. The change in the logarithm of oil prices is added as an exogenous variable in each of the three VAR equations.<sup>21</sup> Following the Akaike criteria, we select VAR specifications with six lags.<sup>22</sup> Parameters  $\mu$ ,  $\Phi_i$ ,  $\Gamma$  and  $\Sigma$  are consistently estimated by OLS. Jarque-Bera tests support the hypothesis of non-normality for all residuals, opening the door to the ICA machinery.

We want to estimate the orthogonal matrix C such that  $u_t$  is equal to  $SC\varepsilon_t$ , where S is the lower triangular matrix resulting from the Cholesky decomposition of  $\Sigma$  with positive diagonal entries and the components of  $\varepsilon_t$  are independent, zero-mean with unit variance. Since the  $u_t$ 's are not observed, the PML approach will be applied on standardized VAR residuals, the latter being obtained by pre-multiplying the residuals  $\hat{u}_t$ , i.e.  $Y_t - a(X_t; \hat{\theta}_T)$ , by  $\hat{S}_T^{-1}$ . The pseudo density functions we use are those of three distinct and asymmetric mixtures of Gaussian distributions.<sup>23</sup>

Once C has been estimated, it remains to associate the structural shocks (monetary-policy, supply or demand) with the different components of  $\varepsilon_t$ . To that purpose, we rely on basic economic theory stating that contractionary monetary-policy shocks are expected to have a (short-term and medium-term) negative impact on real activity and on inflation. Moreover, contrary to the demand

<sup>&</sup>lt;sup>20</sup>The output gap is computed as the deviation of the natural logarithm of real GDP (mnemonic GDPC1) from a measure of the log potential GDP (mnemonic GDPPOT). The unemployment gap is computed as the difference between the observed unemployment rate (mnemonic UNRATE) and the natural rate of unemployment (mnemonic NROU).

<sup>&</sup>lt;sup>21</sup>Sims (1992), or Leeper, Sims and Zha (1996) have shown that the introduction of commodity prices in VAR models help to eliminate the positive response of prices to contractionary monetary policy shocks.

<sup>&</sup>lt;sup>22</sup>The Hannan-Quinn and Schwartz criteria point to a lower number of lags (3 and 2 respectively) whatever the chosen measure of real activity. However, portmanteau tests suggest that for such low numbers of lags, residuals are strongly auto-correlated.

<sup>&</sup>lt;sup>23</sup>Specifically, each of the  $g_i$  corresponds to the density function of a random variable  $X_i$  equal to  $\omega_i W_{i,1} + (1 - \omega_i)W_{i,2}$  where  $\omega_i$  is a Bernoulli-distributed random variable of parameter  $p_i$  and where  $W_{i,1} \sim \mathcal{N}(\mu_{i,1}, \sigma_{i,1}^2)$  and  $W_{i,2} \sim \mathcal{N}(\mu_{i,2}, \sigma_{i,2}^2)$ . Imposing that the expectation and variance of  $X_i$  are respectively equal to zero and one, these distributions depends on three parameters. We use  $p_1 = p_2 = p_3 = 0.5$ ,  $\mu_{1,1} = \mu_{2,1} = \mu_{3,1} = 0.1$ ,  $\sigma_{1,1} = 0.5$ ,  $\sigma_{2,1} = 0.7$ ,  $\sigma_{3,1} = 1.3$  (which implies  $\mu_{1,2} = \mu_{2,2} = \mu_{3,2} = -0.1$ ,  $\sigma_{1,2} = 1.32$ ,  $\sigma_{2,2} = 1.22$  and  $\sigma_{3,2} = 0.54$ ).

#### Application to Structural Vector Autoregressive Models

shock, the supply shock is expected to have (short-term and medium-term) influences of opposite signs on economic activity and on inflation. Figure 2 displays the IRFs resulting from the ICA approach (see the black solid lines). For both VAR models, associated with the two measures of economic activity, there is only one of the three shocks that is such that an increase in the short-term rate is accompanied by a decrease in both inflation and economic activity:<sup>24</sup> this shock corresponds to the third row of IRFs, and could be seen as a contractionary monetary-policy shock. Out of the two remaining shocks, one has influences of opposite signs on economic activity and on inflation (second row of IRFs). Because this shock has a positive impact on economic activity, it could be seen as an expansionary supply shock. The remaining shock could be seen as an expansionary demand shock (first row of IRFs).

Table 4 displays the results of the PML estimation of matrix C for the two VAR models. The left-hand side (respectively right-hand side) of the table corresponds to the model where economic activity is proxied by the output gap (resp. the unemployment gap). Asymptotic standard deviations are also reported. These standard deviations are based on the asymptotic distribution given in Proposition 4. It can be noted that this computation does not take the randomness of  $\hat{\theta}_T$  into account. In order to gauge the influence of this, we have resorted to a Monte-Carlo experiment where we have simulated samples by drawing structural shocks, with replacement, in the set of estimated ones. The details of this experiment are given in the online appendix (Section E). The results suggest that, in this specific finite-sample case, using the covariance matrix formulas of Proposition 4 after having applied the PML approach (i) to the true residuals (not affected by the randomness of  $\hat{\theta}_T$ ) or (ii) to the estimated ones (affected by the randomness of the covariance matrices of  $\hat{C}_T$  that are equally reliable.<sup>25</sup>

Let us come back to the IRF results. It is natural to compare these ICA-based IRFs with those stemming from the standard "recursive" identification approach based on specific short-run restrictions (SRRs). This approach, originally due to Sims (1980a,b) is based on the assumptions that (a) the covariance matrix of the structural shocks is the identity matrix, (b) the  $k^{th}$  structural shock does not contemporaneously affects the first k-1 endogenous variables and (c) the contemporaneous effect of the  $k^{th}$  structural shock on the  $k^{th}$  dependent variable is positive [see e.g. Kilian, 2013]. Under these assumptions, the structural shocks are given by  $S^{-1}u_t$ . It is easily seen that the ICA approach provides the same structural shocks as in the previous recursive approach, up to permutations and sign changes, if  $C \in \mathcal{P}(Id)$ , where  $\mathcal{P}(Id)$  is the set of matrices obtained by

<sup>&</sup>lt;sup>24</sup>We associate a decrease in economic activity with an increase in the unemployment rate.

 $<sup>^{25}</sup>$ Specifically, the results show that the probability that the true elements of the mixing matrix C lie within the level- $\alpha$  confidence intervals based on the estimate of the covariance matrix resulting from Proposition 4 is not closer to  $\alpha$  when the PML approach is carried out on the true residuals than when the PML approach is applied to estimated residuals (the former residuals are based on the true  $\theta$ , the latter are based on OLS estimates of  $\theta$  estimated on each simulated sample).

#### Application to Structural Vector Autoregressive Models

permutation and sign change of the columns of the identity matrix.<sup>26</sup> It is important to stress that, contrary to the ICA, the recursive approach assumes, potentially wrongly, that the contemporaneous impacts of some structural shocks on given variables are null and that this kind of assumption can be tested. Using the second method described in Section 2.5, we have tested two different sets of such SRRs, which correspond to two different ordering of the endogenous variables, as will be explained below. The null hypothesis of these tests is  $H_0 = (C \in \mathcal{P}(Id))$ .<sup>27</sup>

Typical SRRs state that monetary policy shocks have neither a contemporaneous effect on economic activity, nor on inflation [see e.g. Bernanke and Blinder (1989), Christiano, Eichenbaum and Evans (2005) or Boivin and Giannoni, 2009]. Additional SRRs are used to disentangle the remaining two shocks. A possibility is to impose that inflation is contemporaneously impacted by only one structural shock, while economic activity is affected by two of them. In this context, the test of the null hypothesis has to be performed with the macroeconomic variables ordered as follows:  $Y_t = [\pi_t, y_t, r_t]$  (SRR Scheme 1, say). Indeed, in this case, the impact of the third shock  $\varepsilon_{3,t}$  on  $Y_t$  is of the form  $[0,0,s_{3,3}]'$ , where we denote by  $s_{i,j}$  the element (i,j) of matrix S. Therefore, this structural shock satisfies the restrictions put on the monetary policy shock. Further, the instantaneous impacts of the first and the second components of  $\varepsilon_t$  are respectively  $[s_{1,1}, s_{2,1}, s_{3,1}]'$  and  $[0, s_{2,2}, s_{3,2}]'$ . Hence, inflation is instantaneously affected by a single shock  $(\varepsilon_{1,t})$  as requested. Alternatively, if economic activity is contemporaneously affected by a single shock, then the null hypothesis will be tested on the macrovariables with the new ordering  $Y_t = [y_t, \pi_t, r_t]'$  (SRR Scheme 2). Remark that the IRFs of the identified monetary policy shocks resulting from these two SRR schemes are identical.<sup>28</sup>

The bottom of Table 4 reports the *p*-values obtained for each scheme and each VAR model. The SRR schemes are rejected at the 5% significance level for the VAR models featuring the output gap

 $<sup>^{26}\</sup>mathcal{P}(Id)$  contains  $2^n n!$  different matrices, that is 48 matrices for n=3.

<sup>&</sup>lt;sup>27</sup>The two sets of SRRs that we consider result in two different sets of estimated structural shocks. By contrast, changing the ordering of the endogenous variables affects the ICA-based estimate of C, but not the associated structural shocks. Let us denote by  $S_i$  the Cholesky decomposition (with positive diagonal entries) of  $\Sigma_i$ , where  $\Sigma_i$  is the covariance matrix of the residuals obtained for the  $i^{th}$  ( $i \in \{1,2\}$ ) ordering of the endogenous variables (this ordering being consistent with the  $i^{th}$  set of SRRs). Let us further denote by P the permutation matrix that is such that  $u_t^{(1)} = Pu_t^{(2)}$ , where  $u_t^{(i)}$  is the vector of residuals resulting from the  $i^{th}$  ordering. Then we have  $C_1 = S_1^{-1}PS_2C_2$ , where  $C_i$  is the estimate of C associated with the  $i^{th}$  ordering of the dependent variables.

<sup>&</sup>lt;sup>28</sup>Let us denote by  $\Sigma_1$  and  $\Sigma_2$  the covariance matrices of the VAR residuals obtained under SRR Scheme 1 and SRR Scheme 2, respectively (we have  $\Sigma_2 = P\Sigma_1 P'$  where P is a permutation matrix that permutes the first two elements of a three-dimensional vector). Under SRR Scheme 1 (respectively Scheme 2), the instantaneous impact of the identified monetary policy shock on  $Y_t$  corresponds to the last column of  $S_1$  (resp.  $S_2$ ), which is the matrix resulting from the Cholesky decomposition of  $\Sigma_1$  (resp.  $\Sigma_2$ ) whose diagonal elements are positive. For SRR scheme i, this instantaneous impact is  $[0,0,s_{3,3}^{(i)}]'$ , where  $s_{3,3}^{(i)}$  is the (3,3) element of  $S_i$ . Further, we have  $s_{3,3}^{(1)} = s_{3,3}^{(2)}$ . Indeed, the  $j^{th}$  diagonal element of  $S_i$  corresponds to the standard deviation of the residuals of the regression of  $u_{j,t}$  on  $u_{1,t}, \ldots, u_{j-1,t}$  (this relates to the Gram-Schmidt orthogonalisation procedure); therefore,  $s_{n,n}^{(1)}$  does not depend on the order of the first n-1 elements of  $u_t$ . The IRFs of the monetary shocks resulting from both SRR schemes are therefore the same because the initial shocks as well as the following dynamics (captured by the VAR autoregressive matrices) are the same.

as a proxy for economic activity. The *p*-values are higher when the unemployment gap is used and, in that case, the SRR schemes cannot be rejected at the 10% significance level.

Figure 2 displays the impulse response functions resulting from the ICA approach (black solid lines) and compare them to those based on the two considered SRR Schemes (black dashed lines and grey solid lines). The responses to the monetary-policy shock and to the demand shocks are relatively close for the different methods. The difference is more marked for the supply shock, where the impact on economic activity is stronger in the ICA case. Consistently with the results of the test detailed above, there are less graphical differences between the ICA-based and the SRRbased IRFs when the unemployment gap is used to measure the economic activity.
