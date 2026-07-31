# 2.1. SVAR-IV

A vector autoregression expresses Yt as its projection on its past values, plus an innovation m<sup>t</sup> that is linearly unpredictable from its past:

$$A(L) Y_t = v_t, (16)$$

where A(L) <sup>=</sup> <sup>I</sup> A1L – A2L<sup>2</sup> ... . We assume that the VAR innovations have a nonsingular covariance matrix (otherwise a linear combination of Y could be perfectly predicted). Because the construction of <sup>m</sup><sup>t</sup> <sup>=</sup> Yt Proj(Yt|Yt1, Yt2, ...) is the first step in the proof of the Wold decomposition, the innovations are also called the Wold errors.

In a structural VAR, the innovations are assumed to be linear combinations of the shocks and, moreover, the spaces spanned by the innovations and the structural shocks are assumed to coincide:

$$v_t = \Theta_0 \varepsilon_t$$
 where  $\Theta_0$  is non-singular. (17)

A necessary condition for (17) to hold is that the number of variables in the VAR equal the number of shocks (n = m).

Because Yt is second-order stationary, A(L) is invertible. Thus, (16) and (17) yield a moving average representation in terms of the structural shocks:

© 2018 Royal Economic Society.

$$Y_t = C(L)\Theta_0\varepsilon_t,\tag{18}$$

where  $C(L) = A(L)^{-1}$  is square summable.

If (17) holds, then the SVAR impulse response function reveals the population dynamic causal effects; that is,  $C(L)\Theta_0 = \Theta(L)$ . Condition (17) is an implication of the assumption that the structural moving average is invertible. This 'invertibility' assumption, which underpins SVAR analysis, is non-trivial and we discuss it in more detail in the next subsection.

Under the assumption of invertibility, the SVAR identification problem is to identify  $\Theta_0$ . Here, we summarise SVAR identification using external instruments.

Suppose there is an instrument  $Z_t$  that satisfies the first two conditions of Condition LP-IV, which we relabel as Condition SVAR-IV:

#### CONDITION SVAR-IV

- (i)  $E\varepsilon_{1t}Z_t' = \alpha' \neq 0$  (relevance); and
- (ii)  $E\varepsilon_{2:n,t}Z_t' = 0$  (exogeneity w.r.t. other current shocks).

Condition SVAR-IV and (17) imply that

$$E\nu_t Z_t = E(\Theta_0 \varepsilon_t Z_t) = \Theta_0 E \begin{pmatrix} \varepsilon_{1t} Z_t' \\ \varepsilon_{2:n,t} Z_t' \end{pmatrix} = \Theta_0 \begin{pmatrix} \alpha' \\ 0 \end{pmatrix} = \begin{pmatrix} \Theta_{0,11} \alpha' \\ \Theta_{0,2:n,1} \alpha' \end{pmatrix}. \tag{19}$$

With the help of the unit effect normalisation (6), it follows from (19) that, in the case of scalar  $Z_i$ :

$$\frac{E(v_{i,t}Z_t)}{E(v_{1,t}Z_t)} = \Theta_{0,i1},\tag{20}$$

with the extension to multiple instruments as follows (8). Thus,  $\Theta_{0,i1}$  is the population estimand of the IV regression:

$$v_{i,t} = \Theta_{0,i1} v_{1,t} + \{ \varepsilon_{2:n,t} \}$$
 (21)

using the instrument  $Z_t$ .

Because the innovations  $v_t$  are not observed, the IV regression (21) is not feasible. One possibility is replacing the population innovations in (21) with their sample counterparts  $\hat{v}_t$ , which are the VAR residuals. However, while doing so would provide a consistent estimator with strong instruments, the resulting standard errors would need to be adjusted because of potential correlation between  $Z_t$  and lagged values of  $Y_t$  since  $\hat{v}_{1,t}$  is a generated regressor.

Instead,  $\Theta_{0,i1}$  can be estimated by an approach that directly yields the correct large-sample, strong-instrument standard errors. Because  $v_{i,t} = Y_{i,t} - \text{Proj}(Y_{i,t}|Y_{t-1}, Y_{t-2}, \ldots)$ , (21) can be rewritten as

$$Y_{i,t} = \Theta_{0,i1} Y_{1,t} + \gamma_i(L) Y_{t-1} + \{ \varepsilon_{2:n,t} \}, \tag{22}$$

<sup>&</sup>lt;sup>5</sup> Note that from (5) and (16),  $v_t = A(L)\Theta(L)\varepsilon_t$ . With the addition of condition (17), we have  $\Theta_0\varepsilon_t = A(L)\Theta(L)\varepsilon_t$ , so that  $\Theta_0 = A(L)\Theta(L)$  and  $\Theta(L) = A(L)^{-1}\Theta_0 = C(L)\Theta_0$ .

<sup>© 2018</sup> Royal Economic Society.

where  $\gamma_i(L)$  are the coefficients of  $\operatorname{Proj}(Y_{i,t} - \Theta_{0,i1} Y_{1,t} | Y_{t-1}, Y_{t-2}, \ldots)$ . The coefficients  $\Theta_{0,i1}$  and  $\gamma_i(L)$  can be estimated by two-stage least squares equation-by-equation using the instrument  $Z_t$ . By classic results of Zellner and Theil (1962) and Zellner (1962), this equation-by-equation estimation by two-stage least squares entails no efficiency loss – is in fact equivalent to – system estimation by three stage least squares.

To summarise, SVAR-IV proceeds in three steps:

- (*i*) Estimate (22) using instruments  $Z_t$  for the variables in  $Y_t$ , using p lagged values of  $Y_t$  as controls. This, along with the unit effect normalisation  $\Theta_{0,11} = 1$ , yields the IV estimator of the first column of  $\Theta_0$ ,  $\hat{\Theta}_{0,1}^{\text{SVAR-IV}}$ .
- (ii) Estimate a VAR(p) and invert the VAR to obtain  $\hat{C}(L) = \hat{A}(L)^{-1}$ .
- (iii) Estimate the dynamic causal effects of shock 1 on the vector of variables as

$$\hat{\Theta}_{h,1}^{\text{SVAR-IV}} = \hat{C}_h \hat{\Theta}_{0,1}^{\text{SVAR-IV}}.$$
(23)

It is useful to compare the SVAR-IV and LP-IV estimators. For h=0, the SVAR-IV and LP-IV estimators of  $\Theta_{0,i1}$  are the same when the control variables  $W_t$  are  $Y_{t-1}$ ,  $Y_{t-2},\ldots,Y_{t-p}$ . For h>0, however, the SVAR-IV and LP-IV estimators differ. In the SVAR-IV estimator, the impulse response functions are generated from the VAR dynamics. In contrast, the LP-IV estimator does not use the VAR parametric restriction: the dynamic causal effect is estimated by h distinct IV regressions, with no parametric restrictions tying together the estimates across horizons.

#### 2.1.1. Inference

Let  $\Gamma$  denote the unknown parameters in A(L) and  $\Theta_{0,1}$  (the first column of  $\Theta_0$ ). Under standard regression and strong instrument assumptions (e.g. Hayashi, 2000),  $\sqrt{T}(\hat{\Gamma} - \Gamma) \stackrel{p}{\longrightarrow} N(0, \Sigma_{\Gamma})$ . And, because estimator  $\hat{\Theta}_{h,1}^{SVAR-IV}$  from Step (iii) is a smooth function of  $\hat{\Gamma}$ ,  $\sqrt{T}(\hat{\Theta}_{h,1}^{SVAR-IV} - \Theta_{h,1}) \stackrel{d}{\longrightarrow} N(0, \Sigma_{\Theta})$  where  $\Sigma_{\Theta}$  can be calculated using the  $\delta$ -method. Alternatively, and often more conveniently, confidence intervals can be computed using a parametric bootstrap. Doing so requires specifying an auxiliary process for  $Z_t$ . We provide some details in Appendix A in the context of our empirical illustration.

When instruments are weak, the asymptotic distribution of  $\hat{\Theta}_{h,1}^{\text{SVAR-IV}}$  is not normal; Montiel Olea *et al.* (2017) discuss weak-instrument robust inference for SVARs identified by external instruments.

We stress that the normalisation of ultimate interest – typically the unit effect normalisation – needs to be incorporated into the computation of standard errors. In general, it is incorrect to use a different normalisation (such as the unit standard deviation normalisation), compute confidence bands, then rescale the bands and point estimates to obtain the unit effect normalisation. In practice, this means the unit effect normalisation must be 'inside' the bootstrap, not 'outside'.

#### 2.1.2. Different data spans for Z and Y ('unbalanced panels')

The SVAR-IV estimator of the impulse response function in (23) has two parts,  $\hat{C}_h$  and  $\hat{\Theta}_{0,1}^{SVAR-IV}$ . In general these can be estimated over different sample periods. For example, in Gertler and Karadi (2015), the data on the macro variables  $Y_t$  are available

for a longer period than are data on the instruments, and they estimate the VAR coefficients A(L) over the longer sample and  $\hat{\Theta}_{0,1}^{SVAR-IV}$  over the shorter sample when  $Z_t$  is available. Using the longer sample for the VAR improves efficiency at all horizons.

In contrast, there is less opportunity to improve efficiency by using the longer sample for Y using LP-IV. If Z satisfies Condition LP-IV, then the estimation must all be done on the shorter sample because the moments in (8) are only available over the period of overlap of the Y and Z samples. If control variables are included, the longer sample can be used to estimate  $Y_t^{\perp}$  and  $Y_{t+h}^{\perp}$ , but the moments in (11) must still be estimated over the period of overlap of the Y and Z samples.

A related limitation of LP-IV is that the number of observations available for estimation decreases with the horizon h. This is true regardless of whether the data samples for Z and Y are the same, but becomes more of an issue (compared to SVAR-IV) if the sample for Z is already short.

#### 2.1.3. News shocks and the unit-effect normalisation

A structural moving average may be invertible even when it includes news shocks as long as  $Y_t$  contains forward-looking variables. But, as discussed in the previous Section, news variables require a change in the unit-effect normalisation from contemporaneous  $\Theta_{0,11}=1$  to k periods ahead  $\Theta_{k,11}=1$ . To implement this normalisation in the SVAR, note that the effect of  $\varepsilon_t$  on  $Y_{t+k}$  is given by  $\eta_t=\Theta_k\varepsilon_t=C_k\Theta_0\varepsilon_t=C_kv_t$ . The k-period ahead unit-effect normalisation is  $\Theta_{k,11}=1$ , so  $\eta_{1,t}=\varepsilon_{1,t}+\{\varepsilon_{2:n,t}\}$ . Thus, letting  $X_t=\hat{C}_kY_t$  the normalisation is implemented by replacing  $Y_{1,t}$  with  $X_{1,t}$  in (22) and carrying out the three steps given above. Because  $X_{1,t}$  is a generated regressor, standard errors differ from the model using  $Y_{1,t}$  and are most easily calculated using simulation (parametric bootstrap) methods like those outlined in Appendix A.

#### 2.1.4. Historical and forecast error variance decompositions

As discussed in subsection 1.4, if the shock is identified, then the historical decomposition can be computed using (14). The forecast error variance decomposition, given in (15), further requires identification of  $\sigma_{\epsilon_1}^2$  and the object in the denominator of that expression. The IRFs ( $\Theta$ 's) appearing in (14) and (15) can be estimated using either LP-IV or SVAR-IV. By using the same estimator for the IRFs and the historical decompositions, the set of results will be internally consistent.

The shock  $\varepsilon_{1,t}$ ,  $\sigma_{\varepsilon_1}^2$  and the denominator of (15) are all identified from  $\Theta_{0,1}$  if the VAR is invertible. Specifically, if (17) holds, then  $\varepsilon_{1,t} = \lambda' v_b$  where  $\lambda = \Theta_{0,1}' \Sigma_{\nu\nu}^{-1} / (\Theta_{0,1}' \Sigma_{\nu\nu}^{-1} \Theta_{0,1})^{.6}$  It follows from this expression that  $\sigma_{\varepsilon_1}^2 = \lambda' \Sigma_{\nu\nu} \lambda = (\Theta_{0,1}' \Sigma_{\nu\nu}^{-1} \Theta_{0,1})^{-1}$ . Also, under invertibility the denominator of (15) is  $\text{var}(Y_{i,t+h}|\varepsilon_t,\varepsilon_{t-1},\ldots) = \text{var}(Y_{i,t+h}|\nu_t,\nu_{t-1},\ldots) = \text{var}(Y_{i,t+h}|Y_t,Y_{t-1},\ldots)$ , so the denominator is also identified. Thus, if  $\Theta_{0,1}$  is identified and if the VAR is invertible, the historical decomposition and FEVD are also identified.

<sup>&</sup>lt;sup>6</sup> To show this result, first write  $\Theta_{0,1}'\Sigma_{vv}^{-1}\nu_t = \Theta_{0,1}'(\Theta_0\Sigma_{\varepsilon\varepsilon}\Theta_0')^{-1}\nu_t = \Theta_{0,1}'(\Theta_0')^{-1}\Sigma_{\varepsilon\varepsilon}^{-1}\Theta_0^{-1}\nu_t = e_1'\Sigma_{\varepsilon\varepsilon}^{-1}\varepsilon_t = \sigma_{\varepsilon_t}^2$ , where the first line uses (17) to write  $\Sigma_{vv} = \Theta_0\Sigma_{\varepsilon\varepsilon}\Theta_0'$ ; the second line uses invertibility of Θ<sub>0</sub>; the third line uses the fact that  $B^{-1}B_1 = e_1$  (the first unit vector) where  $B_1$  is the first column of the invertible matrix B and uses (17) plus invertibility to write  $\varepsilon_t = \Theta_0^{-1}\nu_t$  and the final line uses the assumption that  $\varepsilon_{1,t}$  is uncorrelated with  $\varepsilon_{2:n,t}$ . Similar algebra shows that  $\Theta_{0,1}'\Sigma_{vv}^{-1}\Theta_{0,1} = 1/\sigma_{\varepsilon_1}^2$ , and the result follows.

Recall that if LP-IV is implemented using the control variables  $W_t = Y_{t-1}, Y_{t-2}, \ldots$ , then  $\hat{\Theta}_{0,1}^{\text{LP-IV}} = \hat{\Theta}_{0,1}^{\text{SVAR-IV}}$ . If so, the values of  $\lambda$  and  $\sigma_{\varepsilon_1}^2$  computed using LP-IV and SVAR-IV are the same, as is the expression in the denominator of (15). Even if LP-IV is implemented using a reduced set of controls or, if Condition LP-IV holds, no controls, the full VAR must be used to obtain the innovations needed to compute  $\lambda$  and  $\sigma_{\varepsilon_1}^2$ .

# 2.2. Invertibility, Omitted Variable Bias and the Relation between Assumptions SVAR-IV and LP-IV

The structural moving average  $\Theta(L)$  in (5) is said to be invertible if  $\varepsilon_t$  can be linearly determined from current and lagged values of  $Y_t$ :

$$\varepsilon_t = \text{Proj}(\varepsilon_t | Y_t, Y_{t-1}, \ldots)$$
 (invertibility). (24)

In the linear models of this article, condition (24) is equivalent to saying that  $\Theta(L)^{-1}$  exists.<sup>7</sup> The reason we state the invertibility condition as (24) is that it is closer to the standard definition,  $\varepsilon_t = E(\varepsilon_t | Y_b, Y_{t-1}, \ldots)$ , which applies to non-linear models as well.

In this subsection, we make four points. First, we show that (24), plus the assumption that the innovation covariance matrix is non-singular, implies (17). Second, we reframe (24) to show how very strong this condition is: under invertibility, a forecaster using a VAR who magically stumbled upon the history of true shocks would have no interest in adding those shocks to her forecasting equations. Third, this reframing provides a natural reinterpretation of invertibility as a problem of omitted variables; thus, LP-IV can be seen as a solution to omitted variables bias, akin to a standard motivation for IV regression in microeconometrics. Fourth, we show that there is, at a formal level, a close connection between the choice of control variables in LP-IV and invertibility. Specifically, we show that, for a generic instrument  $Z_t$ , using lagged  $Y_t$  as control variables to ensure that Condition LP-IV $^{\perp}$  holds is equivalent to assuming that Condition SVAR-IV and invertibility (24) both hold.

#### 2.2.1. Demonstration that invertibility (24) implies (17)

This result is well known but we show it here for completeness. Recall that by definition,  $v_t = Y_t - \operatorname{Proj}(Y_t | Y_{t-1}, Y_{t-2}, \dots) = \Theta(L)\varepsilon_t - \operatorname{Proj}(\Theta(L)\varepsilon_t | Y_{t-1}, Y_{t-2}, \dots) = \Theta_0\varepsilon_t + \sum_{i=1}^{\infty} \Theta_i[\varepsilon_{t-i} - \operatorname{Proj}(\varepsilon_{t-i} | Y_{t-1}, Y_{t-2}, \dots)],$  where the second equality uses (5), and the third equality uses the fact that  $\operatorname{Proj}(\varepsilon_t | Y_{t-1}, Y_{t-2}, \dots) = 0$  and collects terms. Equation (24) implies that  $\operatorname{Proj}(\varepsilon_{t-i} | Y_{t-1}, Y_{t-2}, \dots) = \varepsilon_{t-i}$ , so the term in brackets in the final summation is zero for all i; thus we have that  $v_t = \Theta_0\varepsilon_t$  as in (17).

To see why (24) implies that  $\Theta_0$  is invertible, note that  $\varepsilon_t = \operatorname{Proj}(\varepsilon_t|Y_t, Y_{t-1}, \ldots) = \operatorname{Proj}(\varepsilon_t|v_t, v_{t-1}, \ldots) = \operatorname{Proj}(\varepsilon_t|\Theta_0\varepsilon_t, \Theta_0\varepsilon_{t-1}, \ldots) = \operatorname{Proj}(\varepsilon_t|\Theta_0\varepsilon_t) = \operatorname{Proj}(\varepsilon_t|v_t)$ , where the first equality is (24), the second follows because current and past innovations span the space of current and past Ys, the third and fifth follow from  $v_t = \Theta_0\varepsilon_t$ , and the fourth follows from the serial independence of  $\varepsilon_t$ . Because  $\varepsilon_t = \operatorname{Proj}(\varepsilon_t|v_t)$ , the

 $<sup>^7</sup>$  By  $\Theta(L)^{-1}$  existing we mean that it is a square-summable limit of a sequence of matrix polynomials in positive powers of L.

<sup>© 2018</sup> Royal Economic Society.

equation  $v_t = \Theta_0 \varepsilon_t$  must yield a unique solution for  $\varepsilon_t$ , so that  $\Theta_0$  has rank m. Moreover, because  $\text{var}(v_t)$  is assumed to have full rank,  $n \leq m$ . Taken together these imply that n = m and  $\Theta_0$  has rank n. Therefore, if (24) holds, then (17) holds.

#### 2.2.2. Invertibility as omitted variables

One interpretation provided in the literature on invertibility is that invertibility implies that there are no omitted variables in the VAR (e.g. Fernández-Villaverde *et al.*, 2007): because invertibility implies that the spans of  $\varepsilon_t$  and  $v_t$  are the same, there is no forecasting gain from adding past shocks to the VAR. That is, the invertibility condition (24) implies that<sup>8</sup>

$$Proj(Y_t|Y_{t-1}, Y_{t-2}, ..., \varepsilon_{t-1}, \varepsilon_{t-2}, ...) = Proj(Y_t|Y_{t-1}, Y_{t-2}, ...).$$
(25)

Condition (25) both shows how strong the assumption of invertibility is, and provides an interpretation of invertibility as a problem of omitted variables. If invertibility holds, then knowledge of the past true shocks would not improve the VAR forecast. If instead those forecasts were improved by adding the shocks to the regression – infeasible, of course, but a thought experiment – then the VAR has omitted some variables, and that omission is an indication of the failure of the invertibility assumption.<sup>9</sup>

In general, one solution to omitted variable problems is to include the omitted variables in the regression. In the case at hand, that is challenging, because the omitted variables are the unobserved structural shocks. Pursuing this line of reasoning suggests using a large number of variables in the VAR, a high-dimensional dynamic factor model or a factor-augmented vector autoregression (FAVAR). This is a potentially useful avenue to dealing with the invertibility problem; see, for example, Forni *et al.* (2009) and the survey in Stock and Watson (2016).<sup>10</sup>

It is important to note that expanding the number of variables will not necessarily result in (24) being satisfied, so that moving to large systems does not assure invertibility.

# 2.2.3. Relation between assumptions SVAR-IV, LP-IV and invertibility

A major appeal of LP-IV is that the direct regression approach does not explicitly assume invertibility. If, however, the instrument depends on lagged shocks and lagged Ys are used as control variables, then in general the instrument is valid with these controls (i.e. Condition LP-IV<sup>\(\perp}\) holds) if and only if Condition SVAR-IV holds and that the SVAR is invertible. Intuitively, if the instrument depends on lagged shocks, the</sup>

<sup>&</sup>lt;sup>8</sup> Equation (25) follows from (17) by writing,  $\operatorname{Proj}(Y_t|Y_{t-1},Y_{t-2},\ldots,\varepsilon_{t-1},\varepsilon_{t-2},\ldots) = \operatorname{Proj}(Y_t|v_{t-1},v_{t-2},\ldots,\varepsilon_{t-1},\varepsilon_{t-2},\ldots) = \operatorname{Proj}(Y_t|v_{t-1},v_{t-2},\ldots) = \operatorname{Proj}(Y_t|Y_{t-1},Y_{t-2},\ldots)$ , where the first and third equalities uses the fact that the innovations are the Wold errors, and the second equality uses the implication of (17) that span  $(\varepsilon_t) = \operatorname{span}(v_t)$ .

<sup>&</sup>lt;sup>9</sup> Condition (25) is closely related to Proposition 3 in Forni and Gambetti (2014), which states (with some refinements) that the structural moving average is invertible if no added state variable in a VAR have predictive content for *Y<sub>t</sub>*. That observation leads to their test for invertibility, which involves estimating factors using a dynamic factor model and including them in the VAR.

<sup>&</sup>lt;sup>10</sup> Aikman *et al.* (2016) use lagged macro factors as controls in local projection OLS regression, which they call factor-augmented local projections. This method is the local projection counterpart of FAVARs.

control variables must span the space of those shocks but the requirement that the *Y*s span the space of the shocks is simply the invertibility condition. This result is stated in the following theorem.

THEOREM 1. Let  $\mathbb{Z}$  denote the set of scalar stochastic processes (instruments) such that for all  $Z \in \mathbb{Z}$ , Z satisfies LP-IV Conditions (i), (ii) and (iii for j > 0), but not (iii for j < 0). Let  $W_t = \{Y_{t-1}, Y_{t-2}, \ldots\}$ . Then LP-IV is satisfied for all  $Z \in \mathbb{Z}$  if and only if (a) Z satisfies Condition SVAR-IV and (b) the invertibility condition (24) holds.

*Proof.* We first show that condition SVAR-IV plus invertibility (24) implies Condition LP-IV $^{\perp}$ . First note that for  $j \geq 0$ ,  $\operatorname{Proj}(\varepsilon_{t+j}|Y_{t-1},Y_{t-2},\ldots)=0$  so  $\varepsilon_{t+j}^{\perp}=\varepsilon_{t+j}-\operatorname{Proj}(\varepsilon_{t+j}|Y_{t-1},Y_{t-2},\ldots)=\varepsilon_{t+j}$ . Thus, for  $j \geq 0$ ,  $E(\varepsilon_{t+j}^{\perp}Z_t^{\perp})=E\{\varepsilon_{t+j}[Z_t-\operatorname{Proj}(Z_t|Y_{t-1},Y_{t-2},\ldots)]\}=E(\varepsilon_{t+j}Z_t)$ . Setting j=0, it follows that SVAR-IV (i) and (i) are equivalent to LP-IV $^{\perp}$  (i) and (i). In addition, Condition LP-IV (i) for j>0) (which holds by definition of  $\mathbf{Z}$ ) is equivalent to Condition LP-IV $^{\perp}$  (i) for j>0). For j<0, (24) directly implies that  $\varepsilon_{t+j}=\operatorname{Proj}(\varepsilon_{t+j}|Y_{t-1},Y_{t-2},\ldots)$ , so  $\varepsilon_{t+j}^{\perp}=0$  and thus  $E(\varepsilon_{t+j}^{\perp}Z_t^{\perp})=0$  trivially; thus (24) implies LP-IV $^{\perp}$  (i) for j<0). Thus condition SVAR-IV plus (24) implies Condition LP-IV $^{\perp}$  for all  $Z\in\mathbf{Z}$ .

We now show that, if Condition LP-IV<sup> $\perp$ </sup> holds for all  $Z \in \mathbb{Z}$ , then Conditions SVAR-IV and (24) hold. First, as noted above, LP-IV<sup> $\perp$ </sup> (*i*) and (*ii*) are equivalent to SVAR-IV (*i*) and (*ii*). It remains to show that, if LP-IV<sup> $\perp$ </sup> (*iii*) holds for all  $\mathbb{Z} \in \mathbb{Z}$ , then (24) holds. Consider  $\tilde{Z} \in \mathbb{Z}$ , and let  $\tilde{Z}_t = \tilde{Z}_t + \varepsilon_{t-1}$ ; by construction,  $\tilde{Z} \in \mathbb{Z}$ . Because LP-IV<sup> $\perp$ </sup> holds by assumption for all  $Z \in \mathbb{Z}$ , it holds in particular for  $\tilde{Z}$  and  $\tilde{Z}$ , so LP-IV<sup> $\perp$ </sup> (*iii*, j < 0) implies that  $E(\varepsilon_{t-1}^{\perp}\tilde{Z}_t^{\perp}) = E(\varepsilon_{t-1}^{\perp}\tilde{Z}_t^{\perp}) = E(\varepsilon_{t-1}^{\perp}\tilde{Z}_t^{\perp}) + E(\varepsilon_{t-1}^{\perp})^2$ , so it must be that  $E(\varepsilon_{t-1}^{\perp})^2 = 0$ ; but  $E(\varepsilon_{t-1}^{\perp})^2 = 0$  implies that (24) holds.

We interpret this theorem as a 'no free lunch' result. Although LP-IV can estimate the impulse response function without assuming invertibility, to do so requires an instrument that either satisfies LP-IV (iii) or that can be made to do so by adding control variables that are specific to the application. Simply including past Y's out of concern that  $Z_t$  is correlated with past shocks is in general valid if and only if the VAR with those past Y's is invertible but if so, it is more efficient to use SVAR-IV. <sup>11</sup>

#### 2.3. Observable Shocks, VAR Misspecification and Partial Invertibility

The external instrument approach to impulse response estimation treats shock measures, such as the Romer and Romer (1989) narrative shocks or a monetary announcement surprise as in Kuttner (2001), as instrumental variables. Originally, however, that literature treated those measures as the shocks directly. Given our focus on invertibility, we therefore briefly digress to consider issues of VAR specification

<sup>&</sup>lt;sup>11</sup> It is well known that in VARs, distributions of estimators of impulse response functions are generally not well approximated by their asymptotic distributions in sample sizes typically found in practice. A more relevant comparison would be of the efficiency of the estimators in a simulation calibrated to empirical data. Kim and Kilian (2011) did such an exercise comparing LP and SVAR estimators, with identification by a Cholesky decomposition (what we would call 'internal' instruments). Their results are consistent with improvements in efficiency, and tighter confidence intervals, for SVARs than LP.

when the shock of interest is observed. We will refer to the situation in which  $\varepsilon_{1,t}$  is observed, or at least is recoverable from the VAR innovations  $v_b$  as partial invertibility: we will say that the VAR is partially invertible if there is some  $\lambda$  such that  $\varepsilon_{1,t} = \lambda' v_b$ . The leading case is the observed shock case in which  $\lambda = (1 \ 0 \ \dots \ 0)'$ , with the observed shock ordered first in the VAR. Here, we first consider partial identification in the case that  $\lambda$  is identified without assuming full invertibility (the 'observed shock' case), so that the shock can be used directly as a regressor. We then contrast this with the case of identification by external instruments.

First, consider the case that  $\varepsilon_{1,t}$  is observed, and let  $Y_{1,t} = \varepsilon_{1,b}$  and as usual let  $Y_{2:n,t}$  denote the remaining Ys. Write the structural moving average representation for  $Y_{2:n,t}$  as  $Y_{2:n,t} = \Theta_1(\mathbf{L})\varepsilon_{1,t} + \omega_b$  where  $\omega_t$  is the distributed lag all the shocks other than  $\varepsilon_{1,t}$ . Because  $\omega_t$  is stationary, it has a population VAR representation,  $\omega_t = A_{22}(\mathbf{L})\omega_{t-1} + \zeta_t$ . Premultiplying  $Y_{2:n,t} = \Theta_1(\mathbf{L})\varepsilon_{1,t} + \omega_t$  by  $I - \mathbf{L}A_{22}(\mathbf{L})$  and rearranging yields,  $Y_{2:n,t} = [I - \mathbf{L}A_{22}(\mathbf{L})]\Theta_1(\mathbf{L})\varepsilon_{1,t} + A_{22}(\mathbf{L})Y_{2:n,t-1} + \zeta_t = A_{21}(\mathbf{L})\varepsilon_{1,t-1} + A_{22}(\mathbf{L})Y_{2:n,t-1} + \Theta_{0,1}\varepsilon_{1,t} + \zeta_t$  where  $A_{21}(\mathbf{L}) = \mathbf{L}^{-1}\left\{[I - \mathbf{L}A_{22}(\mathbf{L})]\Theta_1(\mathbf{L}) - \Theta_{0,1}\right\}$  (note that the leading term of  $[I - \mathbf{L}A_{22}(\mathbf{L})]\Theta_1(\mathbf{L})$  is  $\Theta_{0,1}$ ). The expressions for  $Y_{1,t}$  and  $Y_{2:n,t}$  combine to yield the VAR:

$$Y_{t} = \begin{pmatrix} Y_{1,t} \\ Y_{2:n,t} \end{pmatrix} = \begin{pmatrix} 0 & 0 \\ A_{21}(L) & A_{22}(L) \end{pmatrix} \begin{pmatrix} Y_{1,t-1} \\ Y_{2:n,t-1} \end{pmatrix} + \begin{pmatrix} v_{1,t} \\ v_{2:n,t} \end{pmatrix},$$

$$\text{where } \begin{pmatrix} v_{1,t} \\ v_{2:n,t} \end{pmatrix} = \begin{pmatrix} 1 & 0 \\ \Theta_{0,1} & I \end{pmatrix} \begin{pmatrix} \varepsilon_{1,t} \\ \zeta_{t} \end{pmatrix}.$$

$$(26)$$

Assuming correct lag specification, the VAR coefficient estimator is consistent for the population lag matrix in (26). The lack of feedback in the population VAR coefficient matrix to the first variable, combined with the lower triangular error structure in (26), imply that the IRFs produced by a Cholesky factorisation of the VAR innovations, with the observed shock ordered first, produce an IRF that simply iterates on the second block of equations. That is, the IRF is computed from the difference equation  $Y_{2:n,t} = [I - LA_{22}(L)]\Theta_1(L)\varepsilon_{1,t} + A_{22}(L)Y_{2,t-1}$ , which yields the IRF  $\Theta_1(L)$ .

The conclusion that the VAR ' $\varepsilon_{1,t}$  first' IRF is consistent for  $\Theta_1(L)$  was reached without ever assuming that  $\zeta_t$  spans the space of the remaining shocks: the VAR can have omitted variables in the sense that the shocks are not fully observable. The reason for this result is that  $\varepsilon_{1,t}$  is strictly exogenous. Because of this strict exogeneity,  $\Theta_1(L)$  can be consistently estimated by a distributed lag regression of  $Y_{2:n,t}$  on  $\varepsilon_{1,b}$  an autoregressive distributed lag regression, by GLS, or using a VAR with arbitrary choice of VAR variables, including a choice of VAR variables that differs from one variable of interest to the next.

These observations all extend to the case of partial invertibility, in which there is an identified  $\lambda$  such that  $\varepsilon_{1,t} = \lambda' v_t$ . Let  $\tilde{\lambda}$  be a  $n \times (n-1)$  matrix such that  $\tilde{\lambda}' \lambda = 0$  and  $\tilde{\lambda}' \tilde{\lambda} = I$ . Then the algebra of the preceding paragraph goes through using the transformed variables  $\tilde{Y}_t = (\tilde{Y}_{1,t}, \tilde{Y}_{2:n,t}) = (\lambda' Y_t, \tilde{\lambda}' Y_t)$ .

Returning to IV methods, an implication of these observations is that if the IV methods identify  $\lambda$  such that  $\varepsilon_{1,t} = \lambda' v_t$ , then the additional assumption of invertibility of the SVAR can be dispensed with for the validity of SVAR-IV. This said, as discussed in

subsection 2.2, identification of  $\Theta_{0,1}$  is insufficient to identify  $\lambda$ , and the expression for  $\lambda$  given there (that  $\lambda = \Theta_{0,1}'\Sigma_{vv}^{-1}/(\Theta_{0,1}'\Sigma_{vv}^{-1}\Theta_{0,1}))$  was derived under the invertibility assumption (17). While the partial invertibility assumption that  $\varepsilon_{1,t} = \lambda' v_t$  is weaker than invertibility assumption (17), it remains to be seen whether there are empirical applications in which this weaker condition would hold but invertibility does not.<sup>12</sup>

#### 3. A Test of Invertibility

Suppose one has an instrument that satisfies Condition LP-IV. Under invertibility, SVAR-IV and LP-IV are both consistent, but SVAR-IV is more efficient, at least under homoscedasticity. If, however, invertibility fails, LP-IV is consistent but SVAR-IV is not. This observation suggests that comparing the SVAR-IV and LP-IV estimators provides a Hausman (1978)-type test of the null hypothesis of invertibility. Throughout, we maintain the assumption that  $Y_t$  has the linear structural moving average (5). We additionally assume the VAR lag length p is finite and known.

Before introducing the test, we make precise the null and alternative hypothesis. We also provide a nesting of local departures from the null, which we refer to as local non-invertibility.

#### 3.1. Null and Local Alternative

Under invertibility (24), the structural moving average can be written  $Y_t = C(L)\Theta_0\varepsilon_t$  as in (18), where  $C(L) = A(L)^{-1}$ ; that is, that  $\Theta(L) = C(L)\Theta_0$ . The null and alternative hypotheses thus are

$$H_0: C_h\Theta_{0,1} = \Theta_{h,1}, \text{ all } h \text{ v. } H_1: C_h\Theta_{0,1} \neq \Theta_{h,1}, \text{ some } h.$$
 (27)

In addition to establishing the null distribution of the test, we wish to examine its distribution under an alternative to check that the test has power against non-invertibility. Beaudry *et al.* (2015) and Plagborg-Møller (2016*b*) provide numerical evidence that in many cases the non-invertible (non-fundamental) representation of a time series may be very close to its invertible representation. With this motivation, we focus on non-invertible IRFs that represent small departures from an invertible null.

Specifically, we consider the drifting sequence of alternatives:

$$C_{h,T}\Theta_{0,1} = \Theta_{h,1} + T^{-1/2}d_h + o(T^{-1/2}),$$
 (28)

where under the null  $d_h = 0$ , while under the alternative  $d_h$  is a non-zero  $n \times 1$  vector for at least some h > 0. In Appendix A.1, we construct a sequence of models that are non-invertible because of a small amount (specifically,  $O_p(T^{-1/4})$ ) of measurement

<sup>&</sup>lt;sup>12</sup> Evidently, without partial invertibility or recoverability, the historical and forecast error variance decompositions in (14) and (15) are not point-identified. Plagborg-Møller and Wolf (2017) derive set identification results for these decompositions using external instruments in the absence of invertibility or recoverability.

<sup>© 2018</sup> Royal Economic Society.

error contamination, and show that this sequence of models induces local non-invertibility of the form (28).

#### 3.2. Test of Invertibility

We now turn to the test statistic. Let  $\hat{\theta}^{\text{SVAR-IV}}$  denote an  $m \times 1$  vector of SVAR-IV estimators (23), computed using a VAR(p), for different variables and/or horizons and let  $\hat{\theta}^{\text{LP-IV}}$  denote the corresponding LP-IV estimators. Compute the LP-IV estimator using as control variables the p lags of Y that appear in the VAR; because  $Z_t$  satisfies Condition LP-IV, including these lags as controls is not necessary for consistency but makes the two statistics comparable for use in the same test statistic.

It is shown in Appendix A that, with strong instruments and under standard moment/memory assumptions, under the null and local alternative:

$$\sqrt{T}(\hat{\theta}^{\text{LP-IV}} - \hat{\theta}^{\text{SVAR-IV}}) \xrightarrow{d} N(d, V),$$
 (29)

where d consists of the elements of  $\{d_h\}$  corresponding to the variable-horizon combinations that comprise  $\hat{\theta}^{\text{LP-IV}}$  and  $\hat{\theta}^{\text{SVAR-IV}}$ .

The Hausman-type test statistic is

$$\xi = T(\hat{\theta}^{LP-IV} - \hat{\theta}^{SVAR-IV})'\hat{V}^{-1}(\hat{\theta}^{LP-IV} - \hat{\theta}^{SVAR-IV}), \tag{30}$$

where  $\hat{V}$  is a consistent estimator of V. Under the null of invertibility,  $\xi \xrightarrow{d} \chi_m^2$ . We make four remarks about this test:

- (i) We suggest computation of the variance matrix  $\hat{V}$  using the parametric bootstrap, and we discuss some specifics in Appendix A.2.
- (ii) The LP-IV and SVAR-IV estimators for the impact effect (h = 0) are identical when lagged Ys are used as controls. Thus, this test compares the LP-IV and SVAR-IV estimates of the impulse responses for  $h \ge 1$ . This test therefore assesses the validity of the parametric restrictions imposed by inverting the SVAR, compared to direct estimation of the impulse response function by LP-IV. Here, we have maintained the assumption that the structural moving average is linear and the VAR lag length is finite and known. Under these maintained assumptions, any divergence between the SVAR impulse responses and the direct estimates, in population, is attributable to non-invertibility.
- (iii) Under the local alternative (28), the test statistic has a non-central chi-squared distribution with m degrees of freedom and non-centrality parameter  $\mu^2 = d'V^{-1}d$ . The expressions in Appendix A show that, for a given local alternative d, the non-centrality parameter converges to zero as  $\alpha \to 0$ , and increases to a finite limit as  $|\alpha|$  increases. Thus, the power of the test is increasing as the strength of the instrument increases, according to this local strong-instrument approximation.
- (iv) Existing tests for invertibility (Forni and Gambetti, 2014) test the implication of invertibility that  $Z_t$  does not Granger-cause  $Y_t$ . The test here differs because it focuses not on forecasting contribution, but on the object of interest in the

analysis, the impulse response function. In both approaches – directly testing Granger non-causality and the Hausman-type test approach here, the testable implications all stem from moments involving Z: second moments of Y alone cannot distinguish invertible from non-invertible processes.

# 4. Illustration: Gertler and Karadi (2015) Identification of the Dynamic Causal Effect of Monetary Policy

Gertler and Karadi (2015) use the SVAR-IV method to estimate the effect of a monetary policy shock on real output, prices and various credit variables, and Ramey (2016) applies LP-IV to their data to illustrate the differences between the two methods. Here, we extend Ramey's comparison and formally test invertibility. We use this application to discuss several implementation details.

Gertler and Karadi's (2015) benchmark analysis uses US monthly data to estimate the effect of Federal Reserve policy shocks on four variables: the index of industrial production and the consumer price index (both in logarithms, denoted here as IP and P), the interest rate on one-year US Treasury bonds (Rt) and a financial stress indicator, the Gilchrist and Zakrajsek (2012) excess bond premium (EBP). We firstdifference IP and P, so the vector of variables is Yt = (Rt, 100DIP, 100DP, EBP), where R and EBP are measured in percentage points at the annual rate and DIP and DP are multiplied by 100 so these variables are measured in percentage point growth rates.

Gertler and Karadi (GK) identify the monetary policy shock using changes in Federal Funds futures rates (FFF) around FOMC announcement dates. In doing so, they draw on insights from Kuttner (2001) and others who argued that this measure is plausibly uncorrelated with other shocks because they are changes across a short announcement window. However, the original literature treated such a measure as the shock and GK use it as an instrument, that is, Zt = FFFt.

Column (1) of Table 1 shows results for the LP-IV regression (7), the equation without controls, using the GK data that span 1990m1–2012m6. Standard errors in Table 1 for LP-IV impulse responses are Newey–West with h + 1 lags. We highlight three results. First, the table shows that the estimated contemporaneous (h = 0) effect of monetary policy shocks on interest rates (R) is Θ0,11 = 1.0; this is the unit-effect normalisation. Second, the first-stage F-statistic – that is the (standard) F-statistic from the regression of Rt onto FFFt – is small, only 1.7, raising weak instrument concerns. Third, the estimated standard errors for the estimated causal effects are large, particularly for large values of h.

These final two results are related. To see why, rewrite (5) to highlight the various components of Yi,t+h:

$$Y_{i,t+h} = \Theta_{h,i1}\varepsilon_{1+h} + \{\varepsilon_{t+h}, \dots, \varepsilon_{t+1}\} + \{\varepsilon_{2:n,t}\} + \{\varepsilon_{t-1}, \dots\},$$
(31)

where, again, the notation {} denotes a linear function of the variables included in the braces. The first-stage F-statistic is from the regression of Y1,<sup>t</sup> (= Rt) onto Zt (= FFFt). From (31), the error term in the first-stage regression is comprised of {ɛ2:n,t} and

Table 1
Estimated Causal Effect of Monetary Policy Shocks on Selected Economic Variables: Gertler and Karadi (2015) Variables, Instrument and Sample Period

|                              |         | LP-IV        |                   |                     | SVAR                        | SVAR – LP            |
|------------------------------|---------|--------------|-------------------|---------------------|-----------------------------|----------------------|
|                              | lag (h) | (1)          | (2)               | (3)                 | (4)                         | $(5) \\ ((4) - (2))$ |
| R                            | 0       | 1.00 (0.00)  | 1.00 (0.00)       | 1.00 (0.00)         | 1.00 (0.00)                 | 0.00 (0.00)          |
|                              | 6       | -0.07(1.34)  | 1.12 (0.52)       | 0.67(0.57)          | 0.89 (0.31)                 | -0.23(1.19)          |
|                              | 12      | -1.05(2.51)  | 0.78 (1.02)       | -0.12(1.07)         | 0.78 (0.46)                 | 0.00 (1.79)          |
|                              | 24      | -2.09(5.66)  | -0.80(1.53)       | -1.57(1.48)         | $0.40\ (0.49)$              | 1.19 (2.57)          |
| IP                           | 0       | -0.59(0.71)  | 0.21(0.40)        | 0.03(0.55)          | $0.16\ (0.59)$              | -0.06(0.35)          |
|                              | 6       | -2.15(3.42)  | -3.80(3.14)       | -4.05(3.65)         | $-0.81\ (1.19)$             | 3.00 (2.32)          |
|                              | 12      | -3.60(6.23)  | -6.70(4.70)       | -6.86(5.49)         | -1.87(1.54)                 | 4.83 (4.00)          |
|                              | 24      | -2.99(10.21) | -9.51(7.70)       | -8.13(7.62)         | -2.16(1.65)                 | 7.35 (6.40)          |
| P                            | 0       | 0.02(0.07)   | -0.08(0.25)       | -0.04(0.25)         | 0.02(0.23)                  | 0.10 (0.13)          |
|                              | 6       | 0.16 (0.42)  | -0.39(0.52)       | -0.79(0.83)         | 0.31 (0.41)                 | 0.71 (0.98)          |
|                              | 12      | -0.26(0.88)  | -1.35(1.03)       | -1.37(1.23)         | 0.45(0.54)                  | 1.80 (1.53)          |
|                              | 24      | -0.88(3.08)  | -2.26(1.31)       | -2.58(1.69)         | 0.50(0.65)                  | 2.76 (2.60)          |
| EBP                          | 0       | 0.51(0.61)   | 0.67(0.40)        | 0.82 (0.49)         | 0.77 (0.29)                 | 0.09 (0.24)          |
|                              | 6       | 0.22(0.30)   | 1.33 (0.81)       | 1.66 (1.04)         | 0.48 (0.20)                 | -0.85(0.51)          |
|                              | 12      | 0.56 (0.91)  | 0.84(0.65)        | 0.91 (0.80)         | 0.18 (0.13)                 | -0.66(0.55)          |
|                              | 24      | -0.44(1.29)  | 0.94 (0.66)       | 0.85(0.76)          | 0.06(0.07)                  | -0.88(0.62)          |
| Controls                     |         | None         | 4 lags of $(z,y)$ | 4 lags of $(z,y,f)$ | 12 lags of y<br>4 lags of z | na                   |
| First-stage F <sup>Hom</sup> |         | 1.7          | 23.7              | 18.6                | 20.5                        | na                   |
| First-stage $F^{HAC}$        |         | 1.1          | 15.5              | 12.7                | 19.2                        | na                   |

Notes. The instrument,  $Z_b$  is available from 1990m1 to 2012m6; the other variables are available from 1979m1 to 2012m6. The LP-IV estimates in (1)–(3) use data from 1990m1 to 2012m6. The VAR for (4) is computed over 1980m7–2012m6 and the IV-regression computed over 1990m5–2012m6. The numbers in parentheses are standard errors computed by Newey–West HAC with h+1 lags for the local projections, and using a parametric Gaussian bootstrap for the SVAR and the SVAR – LP differences shown in (5). In the final two rows,  $F^{Hom}$  is the standard (conditional homoscedasticity, no serial correlation) first-stage F-statistic, while  $F^{HAC}$  is the Newey–West version using 12 lags in (1) and heteroscedasticity-robust (no lags) in (2), (3) and (4).

 $\{\varepsilon_{t-1}, \ldots\}$ . Because interest rates are very persistent, only a small fraction of the variance is attributable to contemporaneous shocks,  $\varepsilon_b$  a fraction of this contemporaneous effect is associated with the monetary policy shock  $\varepsilon_{1,b}$  and only a fraction of  $\varepsilon_{1,t}$  can be explained by the instrument  $Z_t$ . Taken together, these effects yield a first-stage regression with  $R^2 = 0.006$  and a correspondingly small F-statistic. Similar logic explains the large standard errors for the estimated causal effects because these are associated with IV regressions with error terms comprised of  $\{\varepsilon_{t+h}, \ldots, \varepsilon_{t+1}\} + \{\varepsilon_{2:n,t}\} + \{\varepsilon_{t+1}, \ldots\}$ .

Column (2) of Table 1 repeats the estimation, but now using four lags of  $Y_t$  and  $Z_t$  as controls. The controls serve two purposes. First, because these controls are correlated with lagged values of  $\varepsilon$ , they reduce the variance of the regression error term and, for example, the first-stage (partial)  $R^2$  in (2) increases to  $R^2 = 0.09$  with a first-stage F-statistic increasing to F = 23.7. Second, the controls adjust for a data processing issue that makes the FFF variable an invalid instrument in the LP-IV regression without controls. Specifically, as pointed out by Ramey (2016), Gertler and Karadi (2015) form their FFF instrument as a moving average of returns from month t and month t = 1.

Thus,  $FFF_t$  will be correlated with both  $\varepsilon_{1,t}$  and  $\varepsilon_{1,t-1}$ , violating Assumption LP-IV (iii). Because  $Z_t$  has a MA(1) structure, using lags of  $Z_t$  as controls eliminates the correlation with  $\varepsilon_{1,t-1}$ , so that Condition LP-IV $^{\perp}$  (iii) is satisfied. Despite the MA(1) structure, it is plausible that this instrument is uncorrelated with other shocks. Thus, to satisfy Condition LP-IV $^{\perp}$  (iii), it would suffice to include lags of Zs as a controls; including lagged Ys and additional lags of Z serves to improve precision (increase the first-stage F). <sup>13</sup>

If there are more than four shocks that affect  $Y_t$  or if some elements of  $Y_t$  are measured with error (as IP and P surely are), then the innovations to the four variables making up  $Y_t$  will not span the space of the shocks. This is not a problem for the validity of LP-IV with lagged  $Z_t$ ; however, it does suggest that including additional variables that are correlated with the shocks could further reduce the regression standard error, and thus result in smaller standard errors. One plausible set of such variables are principal components (factors) computed from a large set of macro variables. With this motivation, column (3) adds lags of four factors computed from the FRED-MD data set (McCracken and Ng, 2016). In this illustration, these additional controls yield results that are largely consistent with the results using lags of Z and Y.

Both specification (2) and (3) in Table 1 improve on the model without controls, (1), by eliminating some of the variability associated with lagged  $\varepsilon$  and in particular by making Z satisfy LP-IV $^{\perp}$  (iii), whereas (1) does not satisfy LP-IV (iii). However, neither eliminates the variability associated with *future*  $\varepsilon$ 's, the { $\varepsilon_{t+h}$ , ...,  $\varepsilon_{t+1}$ } component of the error term shown in (31). The variability of this component increases with the horizon h, and this is evident in the large standard errors in estimates associated with long-horizons. When the structural moving average model is invertible, it is in effect possible to control for both lagged and future values of  $\varepsilon$  in the IV regression using VAR methods.

Column (4) of Table 1 shows results from a SVAR with 12 lags, with monetary policy identified by the FFF instrument. Because the data on the Ys are available for a longer span than the data on the instrument, we follow Gertler and Karadi (2015) and estimate the VAR over the sample 1980m7–2012m6, while  $\Theta_{0,1}$  is estimated over the sample 1990m1–2012m6 (see the discussion of data spans towards the end of subsection 2.1). Standard errors for the SVAR-IV estimate are computed by the parametric bootstrap described in Appendix A. Because the VAR uses 12 lags of Y instead of the four lags used as controls in the local projections, the first stage F statistics differ slightly in columns (2) and (4). As expected, the standard errors for the estimated dynamic causal effects are smaller for the SVAR than for the local projections, particularly for large values of h, for two reasons. First, the local projections are estimated using regressions with error terms that include leads and lags of  $\varepsilon$  (see (31)), and these terms are absent from the IV regression used in the SVAR, because

 $<sup>^{13}</sup>$  The construction of  $Z_t$  is described in footnote 6 in GK. The MA(1) structure invalidates the LP-IV regression reported in column (1), but it does not affect its validity in the SVAR-IV regression used by GK. An additional issue is that the weights used in GK's construction of  $Z_t$  are time varying because of floating FOMC meeting dates. In principle, this could yield a time-varying MA(1) structure but we approximate the MA coefficients as constant.

| Table 2 |                                        |  |  |  |  |  |  |  |
|---------|----------------------------------------|--|--|--|--|--|--|--|
|         | Tests for VAR Invertibility (p-values) |  |  |  |  |  |  |  |

|                                       | 1 year rate | ln(IP) | ln(CPI) | GZ EBP |
|---------------------------------------|-------------|--------|---------|--------|
| VAR-LP difference (lags 0, 6, 12, 24) | 0.95        | 0.55   | 0.75    | 0.26   |
| VAR Z-GC test                         | 0.16        | 0.09   | 0.38    | 0.97   |

Notes. The first row is the bootstrap p-value for the test ξ in (30) of the null hypothesis that IV-LP and IV-SVAR causal effects are same for h = 0, 6, 12 and 24. The second row shows p-values for the F-statistic testing the null hypothesis that the coefficients on four lags of Z are jointly equal to zero in each of the VAR equations.

only the impact effect, Θ0, is estimated by IV. Second, the VAR parameterisation imposes smoothness and damping on the moving average coefficients in Ch, which further reduces the standard errors. Still, in this empirical application, the standard errors in the SVAR remain large.

The final column of Table 1 shows the difference in estimates of dynamic causal effects from the LP-IV estimator in column (2) and the SVAR-IV estimator in column (4). These differences form the basis for the invertibility test developed in the last Section, and the standard errors shown in final column are computed from the parametric bootstrap, which imposes invertibility. Some of the differences between the SVAR and LP estimates are large, but so are their estimated errors, and none of the differences are statistically significant. Relative to the sampling uncertainty, the differences in the LP and SVAR estimates shown in Table 1 are not large enough to conclude that the SVAR suffers from misspecification associated with a lack of invertibility.

Table 2 shows results for two additional tests for invertibility. The first row shows results for the test ξ in (30) for the differences of the LP-IV and SVAR-IV estimates jointly across the lags shown in Table 1. The second row shows results from Grangercausality tests that include four lags of Z in each of the VAR equation. Despite the large differences, in economic terms, between the two estimates of the impulse responses, the table indicates that there is no statistically significant evidence against the null of hypothesis of invertibility.
