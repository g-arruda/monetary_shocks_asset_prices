# **4.1.1 VARs, SVARs, and the Shock Identification Problem**

Let  $Y_t$  be a  $n \times 1$  vector of stationary time series, assumed for convenience to have mean zero. A pth order VAR model represents  $Y_t$  as a linear function of its first p lagged values plus a serially uncorrelated disturbance  $\eta_t$ . This disturbance  $\eta_t$ , which is referred to as the innovation in  $Y_t$ , has conditional mean zero given past Y; thus  $\eta_t$  is the population one step ahead forecast error under squared-error loss. That is, the VAR(p) model of  $Y_t$  is,

$$Y_t = A_1 Y_{t-1} + \dots + A_p Y_{t-p} + \eta_t \text{ or } A(L) Y_t = \eta_t,$$
 (18)

where  $A(L) = I - A_1L - \cdots - A_pL^p$  and L is the lag operator, and where the disturbance  $\eta_t$  is a martingale difference sequence with covariance matrix  $\Sigma_{\eta}$ , so that  $\eta_t$  is serially uncorrelated.

In practice,  $Y_t$  will generally have nonzero mean and the VAR in (18) would include an intercept. The assumption of zero mean and no intercept in the VAR is made without loss of generality to simplify notation.

The VAR (18) is called the *reduced-form VAR*. The *i*th equation in (18) is the population regression of  $Y_{it}$  onto lagged values of  $Y_t$ . Because (18) is the population regression of  $Y_t$  onto its lags, its parameters A(L) and  $\Sigma_{\eta}$  are identified.

The *innovation* in  $Y_{it}$  is the one step ahead forecast error,  $\eta_{it}$ , in the *i*th equation in (18). The *vector moving average representation* of  $Y_t$ , which in general will be infinite order, expresses  $Y_t$  in terms of current and past values of the innovations:

$$Y_t = C(L)\eta_t$$
, where  $C(L) = I + C_1L + C_2L^2 + \dots = A(L)^{-1}$ . (19)

#### <span id="page-31-0"></span>4.1.1.2 The SVAR

A structural VAR model represents  $Y_t$  not in terms of its innovations  $\eta_t$ , but rather in terms of a vector of underlying *structural shocks*  $\varepsilon_t$ , where these structural shocks represent unexpected exogenous disturbances to structural economic relationships such as production functions (productivity shocks), central bank reaction functions (monetary policy shocks), or oil supply functions (oil supply shocks). The SVAR assumes that the innovations are a linear combination of the unobserved structural shocks:

$$\eta_t = H\varepsilon_t. \tag{20}$$

The structural shocks are assumed to be uncorrelated<sup>p</sup>:

$$E\varepsilon_{t}\varepsilon_{t}' = \Sigma_{\varepsilon} = \begin{pmatrix} \sigma_{\varepsilon_{1}}^{2} & 0 \\ & \ddots & \\ 0 & & \sigma_{\varepsilon_{n}}^{2} \end{pmatrix}. \tag{21}$$

Substituting (20) into (18) and (19) delivers the structural VAR and the structural moving average representation of the observable variables in terms of the structural shocks:

$$A(L)Y_t = H\varepsilon_t \text{ or } B(L)Y_t = \varepsilon_t, \text{ where } B(L) = H^{-1}A(L) \text{ (Structural VAR)}$$
 (22)

$$Y_t = D(L)\varepsilon_t$$
, where  $D(L) = C(L)H$ , (Structural MA) (23)

where the second expression in (22) holds if  $H^{-1}$  exists.

#### 4.1.1.3 The SVAR Identification Problem

Because A(L) and  $\Sigma_{\eta}$  are identified from the projection of  $Y_t$  onto its past, the parameters of the structural VAR (22) and the structural MA (23) are identified if H and  $\Sigma_{\varepsilon}$  are identified. The problem of identifying H and  $\Sigma_{\varepsilon}$  is known as the SVAR identification problem. Strictly speaking, the concept of identification refers to nonrandom parameters or functions, but because D(L) is the projection of  $Y_t$  onto current and past shocks, the SVAR identification problem is also called the problem of identifying the structural shocks.

ORamey (2016) characterizes structural shocks as having three characteristics: (1) they are exogenous and unforecastable, (2) they are uncorrelated with other shocks, and (3) they represent either unanticipated movements in exogenous variables or news about future movements in exogenous variables.

P This assumption that  $\Sigma_{\varepsilon}$  is diagonal is a natural part of the definition of an autonomous structural shock. For example, if one was to posit that two structural shocks were correlated, presumably there would be some structural reason or linkage, but if so then one of the shocks (or both) would be responding to the other endogenously in which case it would not be an exogenous structural shock. See Ramey (2016) for a discussion of this assumption.

#### 4.1.1.4 SIRFs, Historical Decompositions, and Forecast Error Variance Decompositions

The structural MA (23) summarizes the dynamic causal effect of the shocks on current and future  $Y_t$ , and it directly delivers two key objects in SVAR analysis: the SIRF and the decomposition of  $Y_t$  into structural shocks. With the additional assumption (21) that the structural shocks are uncorrelated, the structural moving average representation also delivers the structural forecast error variance decomposition (FEVD).

The SIRF is the time path of the dynamic causal effect on variable  $Y_{it}$  of a unit increase in  $\varepsilon_{jt}$  at date 0. Let  $D_h$  denote the hth lag matrix of coefficients in D(L). Then  $D_{h,ij}$  is the causal effect on the ith variable of a unit increase in the jth shock after h periods, that is,  $D_{h,ij}$  is the effect on  $Y_{it+h}$  of a unit increase in  $\varepsilon_{jt}$ . Thus the *structural impulse response function* ( $SIRF_{ij}$ ) is the sequence of structural MA coefficients,

$$SIRF_{ij} = \{D_{h,ij}\}, h = 0, 1, ..., \text{ where } D_h = C_h H,$$
 (24)

where from (19)  $C(L) = A(L)^{-1}$ . The contemporaneous effect,  $D_0$ , is called the impact effect; note that  $D_0 = H$  because  $C_0 = I$ .

The *cumulative structural impulse response function* is the cumulative dynamic causal effect on  $Y_t$  of a unit shock at date 0. Expressed in terms of D(L), the cumulative SIRF on variable i of shock j after h periods is  $\sum_{k=0}^{h} D_{k,ij}$ .

Because  $D(L)\varepsilon_t$  is a linear function of current and lagged values of  $\varepsilon_t$ , (23) is the historical decomposition of the path of  $Y_t$  into the distinct contributions of each of the structural shocks; given D(L), this decomposition is unique.

The FEVD<sub>h,ij</sub> measures how important the jth shock is in explaining the variation in  $Y_{it}$  by computing the relative contribution of that shock to the variance of the unexpected changes in  $Y_{it}$  over h periods, that is, to the variance of its h-step ahead forecast errors. The FEVD is,

$$FEVD_{h,ij} = \frac{\sum_{k=0}^{h} D_{k,ij}^{2} \sigma_{\varepsilon_{j}}^{2}}{\operatorname{var}(Y_{it+h}|Y_{t}, Y_{t-1}, \dots)} = \frac{\sum_{k=0}^{h} D_{k,ij}^{2} \sigma_{\varepsilon_{j}}^{2}}{\sum_{i=1}^{n} \sum_{k=0}^{h} D_{k,ij}^{2} \sigma_{\varepsilon_{i}}^{2}},$$
(25)

where  $D(L) = A(L)^{-1}H$ .

#### 4.1.1.5 System Identification

System identification entails identification of the full matrix H and thus the full matrix D(L) of SIRFs. System identification makes the assumption that the space of innovations spans the space of structural shocks, so that H is invertible:

$$H^{-1}$$
 exists so that  $\varepsilon_t = H^{-1}\eta_t$ . (26)

Assumption (26) is equivalent to saying that the system SVAR representation (22) exists. Eqs. (20) and (21) imply that

$$\Sigma_n = H \Sigma_{\varepsilon} H'. \tag{27}$$

<span id="page-33-0"></span>The number of free parameters is n(n+1) ( $n^2$  in H and n in  $\Sigma_{\varepsilon}$ ). Because covariance matrices are symmetric, the number of unique equations in  $\Sigma_{\eta} = H\Sigma_{\varepsilon}H'$  is n(n+1)/2. Thus identification of H and  $\Sigma_{\varepsilon}$  requires n(n+1)/2 additional assumptions. Of these, n are obtained from normalizing the scale of the shocks, leaving n(n-1)/2 additional restrictions for identification of H.

When the shocks are i.i.d. Gaussian, the restrictions (27) are the only ones available for identification. If the shocks are not Gaussian then additional restrictions on higher moments can be available, and some research pursues the use of these restrictions. Typically these restrictions require strong additional assumptions, for example that the shocks are independently distributed (as opposed to simply uncorrelated) and in any event this approach does not enhance identification in the Gaussian case. We do not pursue further identification that exploits non-Gaussianity.

#### 4.1.1.6 Single Shock Identification

In many applications, such as the application to the effect of oil supply shocks in Section 7, interest is in the effect of just one shock. Without loss of generality, let the shock of interest be the first shock,  $\varepsilon_{1t}$ . In general, the other shocks need not be identified to identify the SIRF for the first shock, and the innovations need not span the shocks other than  $\varepsilon_{1t}$  to identify the first SIRF. To stress this point, for single shock identification we rewrite (20) as,

$$\eta_{t} = H\begin{pmatrix} \varepsilon_{1t} \\ \widetilde{\eta}_{\bullet t} \end{pmatrix} = \begin{bmatrix} H_{1} & H_{\bullet} \end{bmatrix} \begin{pmatrix} \varepsilon_{1t} \\ \widetilde{\eta}_{\bullet t} \end{pmatrix} = \begin{pmatrix} H_{11} & H_{1\bullet} \\ H_{\bullet 1} & H_{\bullet \bullet} \end{pmatrix} \begin{pmatrix} \varepsilon_{1t} \\ \widetilde{\eta}_{\bullet t} \end{pmatrix}, \tag{28}$$

where  $H_1$  is the first column of H and  $H_{\bullet}$  denotes the remaining columns and the final expression partitions these columns similarly, and where  $\tilde{\eta}_{\bullet t}$  spans the space of  $\eta_t$  orthogonal to  $\varepsilon_{1t}$ . Because these other shocks are uncorrelated with  $\varepsilon_{1t}$ ,  $\operatorname{cov}(\varepsilon_{1t}, \tilde{\eta}_{\bullet t}) = 0$ .

In single shock identification, the aim is to identify  $H_1$ . Given  $H_1$ , the structural moving average representation (23) can be written,

$$Y_t = C(L)\eta_t = C(L)H_1\varepsilon_{1t} + C(L)H_{\bullet}\widetilde{\eta}_{\bullet t}, \text{ where } cov(\varepsilon_{1t}, \widetilde{\eta}_{\bullet t}) = 0.$$
 (29)

Evidently, the SIRF for shock 1 is  $C(L)H_1$  and the historical contribution of shock 1 to  $Y_t$  is  $C(L)H_1\varepsilon_{1t}$ .

If H in (28) is invertible, then  $\varepsilon_{1t}$  can be obtained as a linear combination of  $\eta_t$ . Denote the first row of  $H^{-1}$  by  $H^1$ . It follows from the partitioned inverse formula and the assumption (21) that the shocks are mutually uncorrelated that if  $H_1$  is identified, then  $H^1$  is identified up to scale. In turn, knowing  $H^1$  up to scale allows construction of the shock  $\varepsilon_{1t}$  up to scale:

$$\varepsilon_{1t} = H^1 \eta_t \propto \left[ 1 \ \widetilde{H}^{1 \bullet} \right] \eta_t, \tag{30}$$

<span id="page-34-0"></span>where  $\widetilde{H}^{1\bullet}$  is a function of  $H_1$  and  $\Sigma_{\eta}$ . Thus identification of  $H_1$  permits the construction of  $\varepsilon_{1t}$  up to scale. An implication of (30) is that identification of  $H_1$  and identification of the shock are interchangeable.

Note that (30) obtains without the additional assumption that the innovations span all the shocks or, for that matter, that they span any shock other than  $\varepsilon_{1t}$ .

#### 4.1.2 Invertibility

The structural MA representation  $Y_t = D(L)\varepsilon_t$  represents  $Y_t$  in terms of current and past values of the structural shocks  $\varepsilon_t$ . The moving average is said to be *invertible* if  $\varepsilon_t$  can be expressed as a distributed lag of current and past values of the observed data  $Y_t$ . SVARs typically assume  $\varepsilon_t = H^{-1}\eta_t = H^{-1}A(L)Y_t$ , so an SVAR typically imposes invertibility. Yet, an economic model may give rise to a structural moving average process that is not invertible. If so the VAR innovations will not span the sapce of the structural shocks. Because identification of the shocks and identification of the SIRF are equivalent, if the true SIRF is not invertible, a SVAR constructed from the VAR innovations will not recover the true SIRF.

- Use the partitioning notation for H in the final expression in (28) and the partitioned matrix inverse formula to write,  $H^1 = \begin{bmatrix} H^{11} & -H^{11}H_{1\bullet}H_{\bullet\bullet}^{-1} \end{bmatrix} \propto \begin{bmatrix} 1 & -H_{1\bullet}H_{\bullet\bullet}^{-1} \end{bmatrix}$ , where  $H^{11}$  is the scalar,  $H^{11} = (H_{11} H_{1\bullet}H_{\bullet\bullet}^{-1}H_{\bullet1}')^{-1}$ . Because the goal is to identify  $\varepsilon_{1t}$  up to scale, the scale of  $\varepsilon_{1t}$  is arbitrary, so for convenience we adopt the normalization that  $\Sigma_{\varepsilon} = I$ ; this is the unit standard deviation normalization of Section 4.1.3 and is made without loss of generality. Then (27) implies that  $\Sigma_{\eta} = HH'$ . Adopt partitioning notation for  $\Sigma_{\eta}$  conformable with that of H in (28). Then  $\Sigma_{\eta} = HH'$  implies that  $\Sigma_{\eta,1\bullet} = H_{11}H_{\bullet1}' + H_{1\bullet}H_{\bullet\bullet}'$  and  $\Sigma_{\eta,\bullet\bullet} = H_{\bullet1}H_{\bullet1}' + H_{\bullet\bullet}H_{\bullet\bullet}'$ , which in turn implies  $H_{1\bullet}H_{\bullet\bullet}' = \Sigma_{\eta,1\bullet} H_{11}H_{\bullet1}'$  and  $H_{\bullet\bullet}H_{\bullet\bullet}' = \Sigma_{\eta,\bullet\bullet} H_{\bullet1}H_{\bullet1}'$ . Using these final two expressions and the fact that  $H_{1\bullet}H_{\bullet\bullet}' = (H_{\bullet\bullet}H_{\bullet\bullet}')^{-1} = H_{1\bullet}H_{\bullet\bullet}'$  yields  $H_{1\bullet}H_{\bullet\bullet}' = (\Sigma_{\eta,1\bullet} H_{11}H_{\bullet1}') (\Sigma_{\eta,\bullet\bullet} H_{\bullet1}H_{\bullet1}')^{-1}$ . Thus  $H^{1} \propto \begin{bmatrix} 1 & \widetilde{H}^{1\bullet} \end{bmatrix}$ , where  $\widetilde{H}^{1\bullet} = -(\Sigma_{\eta,1\bullet} H_{11}H_{\bullet1}') (\Sigma_{\eta,\bullet\bullet} H_{\bullet1}H_{\bullet1}')^{-1}$ . Because  $\Sigma_{\eta}$  is identified from the reduced form, knowledge of  $H_{1}$  and the uncorrelated shock assumption therefore determines  $H^{1}$ , and thus the shock  $\varepsilon_{1t}$ , up to scale.
- Here is a second, perhaps more intuitive, method for constructing  $\varepsilon_{1t}$  from  $\eta_t$  given  $H_1$ , the assumption (21) that the shocks are mutually uncorrelated, and the invertibility of H. Let  $H_1^{\perp}$  be any  $n \times (n-1)$  matrix with linearly independent columns that are orthogonal to  $H_1$ . Then  $H_1^{\prime} \eta_t = H_1^{\prime} H \varepsilon_t = H_1^{\prime} [H_1 \ H_0] \varepsilon_t = [0 \ H_1^{\prime} H_0] \varepsilon_t = H_1^{\prime} H_0 \varepsilon_{0t}$ . If H is invertible, then  $H_1^{\prime} H_0 \varepsilon_{0t}$  is invertible, so  $\varepsilon_{0t} = (H_1^{\prime} H_0)^{-1} H_1^{\prime} \eta_t$ . In addition,  $H_1^{\prime} \eta_t = H_1^{\prime} H \varepsilon_t = H_1^{\prime} H_1 \varepsilon_{1t} + H_1^{\prime} H_0 \varepsilon_{0t}$ . Because  $\varepsilon_{1t}$  and  $\varepsilon_{0t}$  are uncorrelated,  $H_1^{\prime} \eta_t \text{Proj}(H_1^{\prime} \eta_t | \varepsilon_{0t}) = H_1^{\prime} H_1 \varepsilon_{1t}$ , where Proj(X|Y) is the population projection of X on Y. Because  $\varepsilon_{0t} = (H_1^{\prime} H_0)^{-1} H_1^{\prime} \eta_t$ ,  $\varepsilon_{1t} = (H_1^{\prime} H_1)^{-1} [H_1^{\prime} \eta_t \text{Proj}(H_1^{\prime} \eta_t | \varepsilon_{0t})] = (H_1^{\prime} H_1)^{-1} [H_1^{\prime} \eta_t \text{Proj}(H_1^{\prime} \eta_t | \varepsilon_{0t})]$ ; this is an alternative representation of the linear combination of  $\eta_t$  given by  $H_1^{\prime} \eta_t$  in (30).
- In linear filtering theory, a time series representation is called *fundamental* if the disturbances are a function of current and past values of the observable data. Accordingly, the invertibility assumption is also referred to as the assumption that the structural shocks are fundamental.

There are at least three reasons why the structural moving average might not be invertible. One is that there are too few variables in the VAR. For example, suppose that there are four shocks of interest (monetary policy, productivity, demand, oil supply) but only three variables (interest rates, GDP, the oil price) in the VAR. It is impossible to reconstruct the four shocks from current and lagged values of the three observed time series, so the structural moving average process is not invertible. Estimates from a SVAR constructed from the VAR innovations will therefore suffer from a form of omitted variable bias.

Second, some elements of Y may be measured with error, which effectively adds more shocks (the measurement error) to the model. Again, this makes it impossible to reconstruct the structural shocks from current and lagged values of Y. This source of noninvertibility can be thought of as errors-in-variables bias.

Third, noninvertibility can arise when shocks contain news about the future. To see the mechanics of the problem, consider the first-order moving average univariate model with a single lag:  $Y_t = \varepsilon_t - d\varepsilon_{t-1}$ . Solving for  $\varepsilon_t$  as a function of current and lagged values of  $Y_t$  yields  $\varepsilon_t = \sum_{i=0}^{h-1} d^i Y_{t-i} + d^h \varepsilon_{t-h}$ . If |d| < 1, then  $d^h \approx 0$  for h large and  $E\left(\varepsilon_t - \sum_{i=0}^{h-1} d^i Y_{t-i}\right)^2 \to 0$  as  $h \to \infty$ , so that  $\varepsilon_t$  can be recovered from current and lagged values of y and the process is invertible. In contrast, when |d| > 1, the initial value of  $\varepsilon_0$  remains important, so the process is not invertible. In this case, however,  $\varepsilon_t$  can be recovered from current and future values of  $\gamma_i$ : solving the moving average process forward yields the representation,  $\varepsilon_t = -(1/d) \sum_{i=1}^h (1/d)^i Y_{t+i} + (1/d)^h \varepsilon_{t+h}$ , where  $E((1/d)^h \varepsilon_{t+h})^2 \to 0$  when |d| > 1. In economic models, noninvertibility can arise, for example, because technological innovations (shocks) may have small initial effects on productivity and much larger effects on future productivity, so a technology shock today (an invention today) is actually observed in the data as a productivity increase in the future. As a second example, if the central bank announces that it will raise interest rates next month, the monetary policy shock occurs today but is not be observed in the overnight rate until next month. Like the case of omitted variables, news shocks are an example of economic agents knowing more about shocks than the econometrician can decipher from current and past data.

Unfortunately, statistics based on the second moments of the data—which include the parameters of the SVAR—cannot determine whether the true SIRF is invertible or not: each noninvertible moving average representation has an invertible moving average representation that is observationally equivalent based on the second moments of the data. To see this, consider the univariate first-order moving average example of the previous paragraph,  $\gamma_t = \varepsilon_t - d\varepsilon_{t-1}$ . By direct calculation,  $\text{var}(\gamma_t) = (1 + d^2)\sigma_{\varepsilon}^2$ ,  $\text{cov}(\gamma_t, \gamma_{t-1}) = -d\sigma_{\varepsilon}^2$ , and  $\text{cov}(\gamma_t, \gamma_{t-1}) = 0$ , |i| > 1. It is readily verified that for any set of parameter values

<span id="page-36-0"></span> $(d, \sigma_{\varepsilon}^2)$  with |d| < 1, the alternative parameter values  $\left(\widetilde{d}, \widetilde{\sigma}_{\varepsilon}^2\right) = \left(d^{-1}, d^2\sigma_{\varepsilon}^2\right)$  produce the same autocovariances; that is,  $(d, \sigma_{\varepsilon}^2)$  and  $\left(d^{-1}, d^2\sigma_{\varepsilon}^2\right)$  are observationally equivalent values of the parameters based on the second moments of the data. If the data are Gaussian, then these two sets of parameter values are observationally equivalent based on the likelihood. Because these pairs have the same autocovariances, they produce the same reduced-form VAR, but they imply different SIRFs.

Noninvertibility is an important threat to the validity of SVAR analysis. Hansen and Sargent (1991) provide an early and important discussion, Sargent (1987) provides an illuminating example using the permanent income model of consumption, and Fernández-Villaverde et al. (2007) discuss the restrictions on linear economic models that give rise to invertibility. For more detailed discussion of the literature and references, see Forni et al. (2009), Leeper et al. (2013), Plagborg-Møller (2015), and Ramey (2016, this Handbook). As Forni et al. (2009) point out and as discussed in more detail in Section 5, SDFMs can resolve the problems of measurement error, omitted variables, and in some cases timing (news) through the use of large numbers of series.

#### 4.1.3 Unit Effect Normalization

Because the structural shocks are unobserved, their sign and scale are arbitrary and must be normalized. There are two normalizations commonly used, the unit standard deviation normalization and the unit effect normalization.

The unit standard deviation normalization makes each shock have unit variance:

$$\Sigma_{\varepsilon} = I$$
 (unit standard deviation normalization). (31)

The normalization (31) fixes the units of the shock, but not its sign. The sign must be fixed separately, for example by defining a positive monetary shock to increase the target rate on impact.

The *unit effect normalization* fixes the sign and scale of the *j*th shock so that a unit increase in  $\varepsilon_{jt}$  induces a contemporaneous unit increase in a specific observed variable, which we take to be  $Y_{jt}$ . Written in terms of the H matrix, the unit effect normalization sets

$$H_{jj} = 1$$
 (unit effect normalization). (32)

Equivalently, under the unit effect normalization a unit increase in  $\varepsilon_{jt}$  increases  $\eta_{jt}$  by one unit, which in turn increases  $Y_{jt}$  by one unit. For example, if the Federal Funds rate is measured in percentage points, then a unit monetary shock induces a one percentage point increase in the Federal Funds rate. A unit shock to productivity growth increases the growth rate of productivity by one percentage point, and so forth.

For system identification, both normalizations provide n additional restrictions on H, so that n(n-1)/2 additional restrictions are needed.

<span id="page-37-0"></span>For single shock identification, both normalizations set the scale of  $\varepsilon_{1t}$ . Under the unit standard deviation assumption,  $\sigma_{\varepsilon_1}^2 = 1$ . Under the unit effect normalization,

$$H_1 = \begin{pmatrix} 1 \\ H_{1\bullet} \end{pmatrix}. \tag{33}$$

In both cases, n-1 additional restrictions are needed to identify  $H_1$ .

In population, these two normalizations are interchangeable. Nevertheless, the unit effect normalization is preferable for three reasons.

First, the unit effect normalization is in the units needed for policy analysis or real-world interpretation. A monetary policy maker needs to know the effect of a 25 basis point increase in the policy rate; providing the answer in standard deviation units does not fulfill that need. When oil prices fall by, say, 10%, because of an oil supply shock, the question is what the effect of that fall is on the economy; again, stating the SIRFs in standard deviation units does not answer that question.

Second, although the two formulations are equivalent in population, statistical inference about the SIRFs differs under the two normalizations. In particular, it is an inferential error to compute confidence intervals for SIRFs under the unit standard deviation normalization, then renormalize those bands so that they answer the questions relevant to policymakers. The inferential error is that this renormalization entails dividing by an estimator of  $H_{11}$ , which introduces additional sampling uncertainty. If, under the unit standard deviation normalization,  $H_{11}$  is close to zero, then this sampling variability can be considerable and renormalization introduces inference problems related to weak instruments.

Third, as discussed in the next section, the unit effect normalization allows SVAR identification schemes to be extended directly to SDFMs.

For these reasons, we adopt the unit effect normalization throughout this chapter.

Finally, we note that the unit effect normalization could alternatively involve the normalization that shock j induces a unit increase in variable i. In this case, the normalization for shock j would be  $H_{ij} = 1$  instead of  $H_{ij} = 1$  as in (32). If each shock has a unit impact on a different VAR innovation, the distinction we are making here is trivial because the named shocks can always be ordered to align with the order of the variables in the VAR. For example, without loss of generality the Fed funds rate can be listed first, the monetary policy shock can be taken to be the first shock, and  $H_{11} = 1$  is the unit effect normalization.

Another way to state this problem is in the context of bootstrap draws of the IRFs. If the bootstrap uses the unit standard deviation normalization to compute confidence intervals, then multiplies the confidence intervals by a scaling coefficient which converts from standard deviation to native units, the resulting IRF confidence intervals do not incorporate the sampling uncertainty of that scaling coefficient. In contrast, if the bootstrap does that conversion for every draw, which is equivalent to using the unit effect normalization, then the IRF confidence intervals do incorporate the sampling uncertainty of the unit conversion step.

<span id="page-38-0"></span>This distinction, however, becomes nontrivial when two distinct shocks are normalized to have unit effects on the same variable. For example, suppose one was interested in investigating the separate effects of an oil supply shock ( $\varepsilon_{1t}$ , say) and an oil inventory demand shock ( $\varepsilon_{2t}$ , say), and for the purpose of the investigation it was useful to fix the scales of the two shocks so that they each produced a one percentage point increase in the price of oil. Without loss of generality, let the oil price be the first variable so  $\eta_{1t}$  is the innovation in the oil price. Then this alternative unit effect normalization would be that  $H_{11} = 1$  and  $H_{12} = 1$ . If the results will be presented using this normalization, then adopting this normalization from the outset ensures that confidence intervals will correctly incorporate the data-dependent transformations to impose this normalization.

Because the circumstance described in the previous paragraph is unusual, throughout this chapter we use the version of the unit effect normalization in (32).

#### 4.1.4 Summary of SVAR Assumptions.

We now collect the assumptions underlying SVAR analysis:

- **(SVAR-1)** The innovations in  $Y_t$ ,  $\eta_t$ , span the space of the one or more structural shocks:
  - (a) for system identification,  $\eta_t = H\varepsilon_t$  as in (20) and  $H^{-1}$  exists and
  - **(b)** for single shock identification, (28) holds and  $H^1$  exists.
- (SVAR-2) The structural shocks are uncorrelated as in (21).
- **(SVAR-3)** The scale of the shocks is normalized using either the unit standard deviation normalization (31) or the unit effect normalization (32).

With one exception, these assumptions, which were discussed earlier, are needed for all the shock identification schemes discussed in this section. The exception is single shock identification based on direct measurement of the time series of structural shocks, which, because the shock is observed, requires only assumption SVAR-2.

For this chapter, we make the further assumptions:

**(SVAR-4)** The innovations  $\eta_t$  are the one step ahead forecast errors from the VAR(p) (18) with time-invariant parameters A(L) and  $\Sigma_{\eta}$ .

**(SVAR-5)** The VAR lag polynomial A(L) is invertible.

Assumptions SVAR-4 and SVAR-5 are technical assumptions made for convenience. For example, SVAR-4 can be relaxed to allow for breaks, or time variation can be introduced into the VAR parameters using the methods of, for example, Cogley and Sargent (2005) or Sims and Zha (2006). Assumption SVAR-5 presumes that the variables have been transformed to stationarity, typically using first differences or error correction terms. Alternatively the series could be modeled in levels in which case the SIRF would have the interpretation of a cumulative SIRF. Levels specifications are used in much of the literature. These relaxations of SVAR-4 and SVAR-5 do not materially affect any of the subsequent discussion and they are made here to streamline the discussion.

## <span id="page-39-0"></span>4.2 Contemporaneous (Short-Run) Restrictions

Contemporaneous restrictions rest on timing arguments about the effect of a given shock on a given variable within the period (monthly if monthly data, etc.). Typically these are zero restrictions, indicating that shock  $\varepsilon_{jt}$  does not affect  $Y_{it}$  (equivalently, does not affect  $\eta_{it}$ ) within a period because of some sluggish or institutional feature of  $Y_{it}$ . These contemporaneous timing restrictions can identify all the shocks, or just some shocks.

## 4.2.1 System Identification

Sims's (1980) original suggestion for identifying the structural shocks was of this form, specifically he adopted an ordering for the variables in which the first innovation responds only to the first shock within a period, the second innovation responds only to the first and second shocks, etc. Under this recursive scheme, the shocks are simply linear regression residuals, where the first regression only controls for lagged observables, the second regression controls for lags and one contemporaneous variable, etc. For example, in many recursive monetary SVARs, the monetary policy shock is identified as the residual from an Taylor rule-type regression.

This recursive identification scheme is a Wold (1954) causal chain and corresponds to assuming that H is lower triangular. Because  $\Sigma_{\eta} = H\Sigma_{\varepsilon}H'$ , the lower-triangular assumption implies that  $H\Sigma_{\varepsilon}^{1/2} = Chol(\Sigma_{\eta})$ , where Chol denotes the Cholesky factorization. With the unit effect normalization, H is obtained as the renormalized Cholesky factorization, that is,  $H = Chol(\Sigma_{\eta})\Sigma_{\varepsilon}^{-1/2}$ , where  $\Sigma_{\varepsilon} = diag(\{[Chol(\Sigma_{\eta})_{jj}]^2, j=1, ..., n\})$ . This lower-triangular assumption remains a common identification assumption used in SVAR empirical applications.

Nonrecursive restrictions also can provide the n(n-1)/2 contemporaneous restrictions for system identification. For example, some of the elements of H can be specified by drawing on application-specific information. An early example of this approach is Blanchard and Watson (1986), who used information about automatic stabilizers in the budget to determine the contemporaneous fiscal response to aggregate demand shocks which, along with zero restrictions based on timing arguments, identified H.

Blanchard and Watson (1986) also show how short-run restrictions on the coefficients can be reinterpreted from an instrumental variables perspective.

## 4.2.2 Single Shock Identification

Identification of a single shock requires fewer restrictions on H; here we give three examples. The first example is to suppose that a given variable (without loss of generality,  $Y_{1t}$ ) responds within the period only to a single structural shock; if so, then  $\varepsilon_{1t} = \eta_{1t}$  and no additional assumptions are needed to identify  $\varepsilon_{1t}$ . This first example corresponds to ordering the variable first in a Cholesky factorization, and no additional assumptions are

<span id="page-40-0"></span>needed about the ordering of the remaining variables (or in fact whether the remaining shocks are identifiable).

The second example makes the opposite assumption: that a given shock affects only one variable within a period, and that variable (and innovation) potentially responds to all other shocks as well. This second example corresponds to ordering the variable last in a Cholesky factorization.

The third example is the "Slow-r-Fast" identification scheme frequently used to identify monetary policy shocks, see, for example, Christiano, Eichenbaum, and Evans, (1999) and Bernanke et al. (2005). Under this scheme, so-called slow-moving variables  $Y_t^s$  such as output and prices do not respond to monetary policy or to movements in asset prices within the period; through monetary policy, the Fed funds rate  $r_t$  responds to shocks to the slow-moving variables within a period but not to asset price developments; and fast-moving variables  $Y_t^f$ , such as asset prices and expectational variables, respond to all shocks within the period. This delivers the block recursive scheme,

$$\begin{pmatrix} \eta_t^s \\ \eta_t^r \\ \eta_t^f \end{pmatrix} = \begin{pmatrix} H_{ss} & 0 & 0 \\ H_{rs} & H_{rr} & 0 \\ H_{fs} & H_{fr} & H_{ff} \end{pmatrix} \begin{pmatrix} \varepsilon_t^s \\ \varepsilon_t^r \\ \varepsilon_t^f \end{pmatrix} \text{ where } Y_t \text{ is partitioned } \begin{pmatrix} Y_t^s \\ r_t \\ Y_t^f \end{pmatrix}, \tag{34}$$

where  $H_{ss}$  is square. Under (34),  $\eta_t^s$  spans the space of  $\varepsilon_t^s$ , so the monetary policy shock  $\varepsilon_t^r$  is the residual in the population regression of the Fed funds rate innovation  $\eta_t^r$  on  $\eta_t^s$ . Equivalently,  $\varepsilon_t^r$  is identified as the residual in the regression of the monetary instrument on current values of slow-moving variables as well as lags of all the variables.

# 4.3 Long-Run Restrictions

Identification of the shocks, or of a single shock, can also be achieved by imposing restrictions on the long-run effect of a given shock on a given variable (Shapiro and Watson, 1988; Blanchard and Quah, 1989; King, Plosser, Stock, and Watson, 1991). Because  $Y_t$  is assumed to be stationary, the cumulative long-run effect of  $\varepsilon_t$  on future values of  $Y_t$  is the sum of the structural MA coefficients D(1), where  $D(1) = C(1)H = A(1)^{-1}H$ , where C(1) and A(1) are, respectively, the sums of the reduced-form MA and VAR coefficients.

## 4.3.1 System Identification

Let  $\Omega$  denote the long-run variance matrix of  $Y_t$ , that is,  $\Omega = \text{var}(\sqrt{n}\bar{Y}) = 2\pi$  times the spectral density matrix of  $Y_t$  at frequency zero. Then

$$\Omega = A(1)^{-1} \Sigma_n A(1)^{-1'} = A(1)^{-1} H \Sigma_{\varepsilon} H' A(1)^{-1'} = D(1) \Sigma_{\varepsilon} D(1)'. \tag{35}$$

Imposing n(n-1)/2 restrictions on D(1) permits identifying D(1) and, because  $A(1)^{-1}H = D(1)$ , H is identified by H = A(1)D(1).

<span id="page-41-0"></span>A common approach is to adopt identifying assumptions that imply that D(1) is lower triangular. For example, Blanchard and Quah (1989) identify a demand shock as having no long-run effect on the level of output. Let  $Y_t = (\text{GDP growth}, \text{ unemployment rate})$  and let  $\varepsilon_{1t}$  be an aggregate supply shock and  $\varepsilon_{2t}$  be an aggregate demand shock. The assumption that  $\varepsilon_{2t}$  has no long-run effect on the *level* of output is equivalent to saying that its cumulative effect on output *growth* is zero. Thus the long-term effect of  $\varepsilon_{2t}$  (the demand shock) on  $Y_{1t}$  (output growth) is zero, that is,  $D_{12}(1) = 0$ , so D(1) is lower triangular.

In another influential paper, Gali (1999) used long-run restrictions to identify a technology shock. Specifically, Gali (1999) uses a small aggregate structural model to argue that only the technology shock has a permanent effect on the level of labor productivity. Let  $Y_t$ = (labor productivity growth, hours growth),  $\varepsilon_{1t}$  be a technology shock, and  $\varepsilon_{2t}$  be a non-technology shock. Gali's (1999) restriction that the nontechnology shock has zero long-run effect on the *level* of labor productivity implies that  $D_{12}(1) = 0$ , so that D(1) is lower triangular.

Blanchard and Quah (1989), King, Plosser, Stock, and Watson (1991), and Gali (1999) use the unit standard deviation normalization, so that  $\Sigma_{\varepsilon} = I$  and, by (35),  $\Omega = D(1)D(1)'$ . The lower triangular factorization of  $\Omega$  is uniquely the Cholesky factorization,  $D(1) = Chol(\Omega)$ . Using the first expression in (35) and H = A(1)D(1), the combination of the unit standard deviation normalization and the identifying restriction that D(1) is lower triangular provides the closed-form expression for H,

$$H = A(1) Chol \left[ A(1)^{-1} \Sigma_{\eta} A(1)^{-1} \right]. \tag{36}$$

In general, the sample estimate of H can be estimated by substituting sample counterparts for the reduced-form VAR,  $\hat{A}(1)$  and  $\hat{\Sigma}_{\hat{\eta}}$ , for the population matrices, imposing the restrictions on D(1), and solving (35). In the case that D(1) is lower triangular and the unit standard deviation assumption is used, the estimator of H has the closed-form solution which is the sample version of (36).

## 4.3.2 Single Shock Identification

Long-run restrictions can also identify a single shock. The Blanchard and Quah (1989) and Gali (1999) examples have n=2, but suppose that n>2. Then the assumption that only  $\varepsilon_{1t}$  affects  $Y_{1t}$  in the long run imposes n-1 zero restrictions on the first row of D(1), and implies that  $\varepsilon_{1t}$  is proportional to  $A(1)^1\eta_t$ , where  $A(1)^1$  is the first row of  $A(1)^{-1}$ . Thus this assumption identifies  $\varepsilon_{1t}$  up to scale, and the scale is then set using either the unit effect normalization or the unit standard deviation normalization.

#### 4.3.3 IV Interpretation of Long-Run Restrictions

Shapiro and Watson (1988) provide an instrumental variables interpretation of identification by long-run restrictions. We illustrate this interpretation for a two-variable

<span id="page-42-0"></span>VAR(1). Following (22), write the SVAR as  $B(L)Y_t = \varepsilon_t$ , where  $B(L) = H^{-1}A(L) = B_0 + B_1L$ , where the final expression assumes the VAR lag length p = 1. Add and subtract  $B_0L$  so that  $B(L)Y_t = (B_0 + B_1L)Y_t = B_0\Delta Y_t + B(1)Y_{t-1}$ , and note that  $B_0 = H^{-1}$  so that the SVAR can be written,  $H^{-1}\Delta Y_t = -B(1)Y_{t-1} + \varepsilon_t$ . Under the unit effect normalization,  $H_{11} = H_{22} = 1$  so, using the formula for the inverse of a 2 × 2 matrix, the SVAR can be written.

$$\Delta Y_{1t} = H_{12} \Delta Y_{2t} - \det(H) B(1)_{11} Y_{1t-1} - \det(H) B(1)_{12} Y_{2t-1} + \det(H) \varepsilon_{1t}$$

$$\Delta Y_{2t} = H_{21} \Delta Y_{1t} - \det(H) B(1)_{21} Y_{1t-1} - \det(H) B(1)_{22} Y_{2t-1} + \det(H) \varepsilon_{2t}.$$
(37)

The parameters  $H_{12}$  and  $H_{21}$  are unidentified without a further restriction on the simultaneous equations model (37), however, long-run restrictions on D(1) provide such a restriction. Specifically, the assumption that D(1) is lower triangular implies that  $D(1)^{-1} = B(1)$  is lower triangular, so that  $B(1)_{12} = 0$ . Thus, the assumption that D(1) is lower triangular implies that  $Y_{2t-1}$  is excluded from the first equation of (37), and thus is available as an instrument for  $\Delta Y_{2t}$  to estimate  $H_{12}$  in that equation. Because  $Y_{2t-1}$  is predetermined,  $E(\varepsilon_{1t}Y_{2t-1}) = 0$  so  $Y_{2t-1}$  satisfies the exogeneity condition for a valid instrument.

As an example, consider the special case of the VAR(1) (37) where,

$$\Delta Y_{1t} = H_{12} \Delta Y_{2t} + \det(H) \varepsilon_{1t}$$
  

$$\Delta Y_{2t} = H_{21} \Delta Y_{1t} + (\alpha - 1) Y_{2t-1} + \det(H) \varepsilon_{2t}.$$
(38)

Because  $\Delta Y_{2t}$  depends on  $\Delta Y_{1t}$ , (38) is a system of simultaneous equations and neither  $H_{12}$  nor  $H_{21}$  can be estimated consistently by OLS. However, because  $Y_{2t-1}$  does not appear in the first equation, it can be used as an instrument for  $\Delta Y_{2t}$  to estimate  $H_{12}$ . The instrumental variables estimator of  $H_{12}$  is,

$$\hat{H}_{12} = \frac{\sum_{t=2}^{T} \Delta Y_{1t} Y_{2t-1}}{\sum_{t=2}^{T} \Delta Y_{2t} Y_{2t-1}}.$$
(39)

This instrumental variables interpretation is noteworthy for two reasons. First, although standard estimation algorithms for long-run identification, such as the Cholesky factor expression (36), appear to be quite different from instrumental variables, when the system is exactly identified the two estimation approaches are equivalent. Thus, the "equation counting" identification approach to identification is the same as having a valid instrument for  $\Delta Y_{2t}$ .

Second, the IV interpretation links the inference problem under long-run restrictions to the well-studied topic of inference in IV regressions. Here, we focus on one aspect of inference in IV regression which turns out to be relevant for SVARs with long-run restrictions: inference when instruments are weak.

#### <span id="page-43-0"></span>4.3.4 Digression: Inference in IV Regression with Weak Instruments

An instrument in IV regression is said to be weak if its correlation with the included endogenous regressor is small. Although a detailed discussion of weak instruments and weak identification is beyond the scope of this chapter, it is useful to lay out the central ideas here because they also arise in other SVAR identification schemes. For this digression only, we modify notation slightly to align with the standard regression model. With this temporary notation, the IV regression model is,

$$Y_{1t} = \beta Y_{2t} + u_t Y_{2t} = \pi' Z_t + V_t$$
 (40)

where  $Y_{2t}$  is the single included endogenous variable,  $\beta$  is the coefficient of interest, and the second equation in (40) is the first-stage equation relating the included endogenous variable to the vector of k instruments,  $Z_t$ . The instruments are assumed to be exogenous in the sense that  $E(Z_tu_t) = 0$ . When there is a single instrument, the IV estimator is

$$\hat{\beta}_{IV} = \frac{\sum_{t=1}^{T} Y_{1t} Z_t}{\sum_{t=1}^{T} Y_{2t} Z_t}.$$
(41)

With multiple instruments, there are multiple estimators available, such as two-stage least squares.

The weak-instrument problem arises when the included endogenous variable  $Y_{2t}$  is weakly correlated with  $Z_t$  or, equivalently, when  $\pi$  in (40) is small. In this case, the sample covariance in the denominator of (41) can have a mean sufficiently close to zero that, in some samples, the denominator itself could be close to zero or even have a sign different from the population covariance. When the sampling distribution of the denominator includes small values, the result is bias in the IV estimator, heavy tails in its distribution, and substantial departures from normality of its associated *t*-statistic. These features are general and arise in time series, panel, and cross-sectional regression, with multiple instruments, multiple included endogenous regressors, and in GMM estimation (eg, Nelson and Startz, 1990a,b; Staiger and Stock, 1997; Stock and Wright, 2000).

In linear IV regression, the primary measure of strength of an instrument is the so-called concentration parameter, divided by the number of instruments. The concentration parameter is defined in the classical linear instrumental variables model with homoscedasticity and i.i.d. observations. The concentration parameter is  $\mu^2 = \pi' Z' Z \pi / \sigma_v^2$ , where  $\sigma_v^2$  is the variance of the first-stage error. The quantity  $\mu^2/k$  is the noncentrality parameter of the *F*-statistic testing the coefficient on the instrument in the first-stage regression. One rule

of thumb is that weak-instrument problems are an important concern when this first-stage *F*-statistic is less than 10 (Staiger and Stock, 1997).<sup>u</sup>

### 4.3.5 Inference Under Long-Run Restrictions and Weak Instruments

A number of studies have pointed out that SVAR inference based on long-run restrictions can be delicate to seemingly minor changes, such as different sample periods or different number of VAR lags. In addition, in Monte Carlo simulations, IRFs based on long-run restrictions have been found to be biased and/or have confidence intervals that do not have the desired coverage probability; see, for example, Christiano et al. (2006). One interpretation of these problems, as put forth by Faust and Leeper (1997), is that they arise because it is difficult to estimate the long-run variance  $\Omega$ , which entails estimating  $A(1)^{-1}$ . In our view, however, this interpretation, while not incorrect, is less useful than posing the problem in terms of the IV framework earlier. Viewing the problem as weak identification both explains the pathologies of the sampling distribution and points the way toward inference procedures that are robust to these problems.

We therefore focus on the IV interpretation of identification by long-run restrictions and weak-instrument issues, initially raised by Sarte (1997), Pagan and Robertson (1998), and Watson (2006). We focus on the special case (38) and the IV estimator (39), however as shown by these authors these comments apply generally to inference using long-run restrictions.

Comparison of the SVAR example (38) and (39) to the IV model and estimator (40) and (41) indicates that the instrument  $Y_{2t}$  will be weak when  $\alpha$  is sufficiently close to one. Consider the special case  $H_{21}=0$ , so that the second equation in (38) is the first stage and the first-stage coefficient is  $\alpha-1$ . A direct calculation in this case shows that the concentration parameter is  $T(\alpha-1)^2/(1-\alpha^2)$ . For T=100, the concentration parameter is 5.3 for  $\alpha=0.9$  and is 2.6 for  $\alpha=0.95$ . These are small concentration parameters, well below the rule-of-thumb cutoff of 10.

Gospodinov (2010) provides a more complete treatment of the distribution theory when the excluded variable is persistent and shows that in general standard inferences will be misleading when the instrument is weak (estimated IRFs are biased, confidence intervals do not have the advertised coverage rates).

Because the weak-instrument problems arise when roots are large, standard methods for inference in the presence of weak instruments under stationarity (eg, Stock and Wright, 2000) no longer apply directly. Chevillon et al. (2015) develop a method for constructing

<sup>&</sup>lt;sup>u</sup> There is now a very large literature on weak instruments in IV regression and weak identification in generalized method of moments estimation. Andrews and Stock (2007) survey the early econometrics literature on weak instruments. For a recent survey of weak instruments in the context of estimation of the New Keynesian Phillips curve, see Mavroeidis et al. (2014).

<span id="page-45-0"></span>confidence sets in this application that is robust to this weak-instruments problem, and they find that using weak-instruments procedures change conclusions in some classic long-run identification SVAR papers, including [Blanchard and Quah \(1989\)](#page-104-0).

# 4.4 Direct Measurement of the Shock

Measuring ε1<sup>t</sup> through direct observation solves the identification problem, and some papers undertake to do so.

One approach to direct measurement of shocks uses narrative sources to determine exogenous policy changes. This method was developed by [Romer and Romer \(1989\)](#page-108-0) for the measurement of monetary policy shocks, and the same authors have used this approach to measure tax, financial distress, and monetary policy shocks ([Romer and](#page-108-0) [Romer, 2004,](#page-108-0) 2010, 2015). For example, [Romer and Romer \(2010\)](#page-108-0) use textual data including presidential speeches and congressional reports to construct a series of exogenous tax changes. [Ramey and Shapiro \(1998\)](#page-108-0) and [Ramey \(2011\)](#page-108-0) use related methods to measure government spending shocks.

A series of papers take this approach to measuring monetary policy shocks by exploiting the expectations hypothesis of the term structure and/or high-frequency financial data. Early contributions include [Rudebusch \(1998\)](#page-109-0), [Kuttner \(2001\)](#page-107-0), [Cochrane and](#page-104-0) [Piazzesi \(2002\),](#page-104-0) Faust et [al. \(2003, 2004\),](#page-105-0) [G](#page-106-0)u[rkaynak et al. \(2005\)](#page-106-0) € , and [Bernanke and](#page-104-0) [Kuttner](#page-104-0) (2005), and recent contributions (with references) are [Campbell et al. \(2012\)](#page-104-0), [Hanson and Stein \(2015\)](#page-106-0), and [Nakamura and Steinsson \(2015\).](#page-108-0) For example, [Kuttner](#page-107-0) [\(2001\)](#page-107-0) measures the monetary policy shock as the change in the Fed Funds futures rate on the day that the Federal Open Market Committee (FOMC) announces a target rate change. Under the expectations hypothesis, any expected change in the target rate will be incorporated into the preannouncement rate, so the change in the Fed Funds futures rate on the announcement date measures its unexpected movement. [Cochrane and Piazzesi](#page-104-0) [\(2002\)](#page-104-0) take a similar approach, using changes in the Eurodollar rate around FOMC target change announcements. Upon aggregation to the monthly level, this yields a series of monetary policy shocks, which they use as a regressor to estimate SIRFs.

Another set of applications of this method is to the direct measurement of oil supply shocks. [Hamilton \(2003\)](#page-106-0) and [Kilian \(2008a\)](#page-107-0) develop an historical chronology of OPEC oil supply disruptions based on exogenous political events to construct numerical estimates of exogenous oil production shortfalls, that is, exogenous shocks to oil supply.

The approach of directly measuring shocks is ambitious and creative and often delivers new insights. This approach, however, has two challenges. The first is that there are inevitable questions about whether the constructed series measures only the exogenous shock of interest. For example, short-term interest rates can change at announcement dates because of an exogenous monetary shock resulting in a change in a target rate, or because the change in the target rate revealed inside knowledge that the Fed might have about the <span id="page-46-0"></span>economy (that is, about the values of other shocks). Additionally, if the window around the announcement is too wide, then rate changes can reflect influences other than the monetary shock (Nakamura and Steinsson, 2015).

The second challenge is that these constructed shocks rarely measure the entirety of the structural shock. For example, some of the monetary shock could be revealed in speeches by Federal Reserve officials in the weeks leading up to a FOMC meeting, so that the change in short rates before and after the FOMC meeting understates the full shock. Whether this omission leads to bias in the estimator of the effect of the monetary policy shock depends on whether the measured shock is correlated with the unmeasured shock. If the measured and unmeasured components are correlated, then this measurement error produces bias in the SIRF estimated using the constructed shock.

The first of these problems, exogeneity, is intrinsic to the research design and does not have a econometric resolution. The second of these problems, errors-in-variables bias, can be solved using econometric methods, in particular by using the measured shock series as an external instrument as discussed in Section 4.7.
