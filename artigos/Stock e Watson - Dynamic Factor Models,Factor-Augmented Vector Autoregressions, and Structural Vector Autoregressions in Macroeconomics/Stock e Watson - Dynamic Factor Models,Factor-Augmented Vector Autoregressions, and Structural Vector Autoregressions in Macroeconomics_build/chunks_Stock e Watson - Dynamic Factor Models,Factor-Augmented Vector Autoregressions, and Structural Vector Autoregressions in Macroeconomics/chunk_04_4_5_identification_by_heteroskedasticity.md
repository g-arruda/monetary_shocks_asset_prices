## 4.5 Identification by Heteroskedasticity

Identification can also be achieved by assuming that the H matrix remains fixed but the structural shocks are heteroskedastic. This heteroskedasticity can take the form of different heteroskedasticity regimes, or conditional heteroskedasticity.

#### 4.5.1 Identification by Heteroskedasticity: Regimes

Rigobon (2003) and Rigobon and Sack (2003, 2004) showed that *H* can be identified by assuming it is constant across regimes in which the variance of the structural shocks change.

Suppose that H is constant over the full sample, but there are two variance regimes, one in which the structural shocks have diagonal variance matrix  $\Sigma_{\varepsilon}^1$  and a second with diagonal variance matrix  $\Sigma_{\varepsilon}^2$ . Because  $\eta_t = H\varepsilon_t$  in both regimes, the variance matrices of  $\eta_t$  in the two regimes,  $\Sigma_n^1$  and  $\Sigma_n^2$  satisfy,

$$\Sigma_{\eta}^{1} = H \Sigma_{\varepsilon}^{1} H'$$

$$\Sigma_{\eta}^{2} = H \Sigma_{\varepsilon}^{2} H'$$
(42)

The first matrix equation in (42) (the first regime) delivers n(n+1)/2 distinct equations, as does the second, for a total of  $n^2 + n$  equations. Under the unit effect normalization that the diagonal elements of H are 1, H has  $n^2 - n$  unknown elements, and there are an additional 2n unknown diagonal elements of  $\Sigma_{\varepsilon}^1$  and  $\Sigma_{\varepsilon}^2$ , for a total of  $n^2 + n$  unknowns. Thus the number of equations equals the number of unknowns.

For these equations to solve uniquely for the unknown parameters, they must provide independent information (satisfy a "rank" condition). For example, proportional

heteroskedasticity  $\Sigma_{\varepsilon}^2 = a\Sigma_{\varepsilon}^1$  provides no additional information because then  $\Sigma_{\eta}^2 = a\Sigma_{\eta}^1$  and the equations from the second regime are the same as those from the first regime. In practice, it is difficult to check the "rank" condition because  $\Sigma_{\eta}^1$  and  $\Sigma_{\eta}^2$  must be estimated. For example, in the previous example  $\Sigma_{\eta}^2 = a\Sigma_{\eta}^1$  in population, but the sample estimates of  $\Sigma_{\eta}^1$  and  $\Sigma_{\eta}^2$  would not be proportional because of sampling variability.

Economic reasoning or case-specific knowledge is used in identification by heteroskedasticity in one and, in some applications, two places. The first is to make the case that H does not vary across heteroskedasticity regimes, that is, that H is time-invariant even though the variances of the structural shocks are time varying. The second arises when some of the shocks are not naturally associated with a specific observable variable. For example, Rigobon (2003) works through a bivariate example of supply and demand in which the variance of the supply disturbance is posited to increase, relative to the variance of the demand disturbance, and he shows that this increase identifies the slope of the demand curve, however this identification requires a priori knowledge about the nature of the change in the relative shock variances. Similarly, Rigobon and Sack (2004) and Wright (2012) exploit the institutional fact that monetary policy shocks arguably have a much larger variance at announcement dates than otherwise, while plausibly their effect  $(H_1)$  is the same on announcement dates and otherwise. This heteroskedasticity around announcement dates provides a variant of the approach discussed in Section 4.3 in which the shock itself is measured as changes in some market rate around the announcement.

For additional references and discussion of regime-shift heteroskedasticity, see Lütkepohl and Netšunajev (2015) and Kilian (2015).

## 4.5.2 Identification by Heteroskedasticity: Conditional Heteroskedasticity

The idea of identification by conditional heteroskedasticity is similar to that of identification by regime-shift heteroskedasticity. Suppose that the structural shocks are conditionally heteroskedastic but H is constant. Then  $\eta_t = H\varepsilon_t$  implies the conditional moment matching equations,

$$E(\eta_t \eta_t' | Y_{t-1}, Y_{t-2}, \dots) = HE(\varepsilon_t \varepsilon_t' | Y_{t-1}, Y_{t-2}, \dots) H'. \tag{43}$$

The conditional covariance matrix of  $\varepsilon_t$  is diagonal. If those variances evolve according to a GARCH process, then they imply a conditionally heteroskedastic process for  $\eta_t$ . Sentana and Fiorentini (2001) and Normandin and Phaneuf (2004) show that a GARCH process for  $\varepsilon_t$  combined with (43) can identify H. Lanne et al. (2010) extend this reasoning from GARCH models to Markov switching models. These are similar to the regime-shift model in Section 4.5.1, however the regime-shift indicator is latent; see Hamilton (2016). For further discussion, see Lütkepohl and Netšunajev (2015).

#### <span id="page-48-0"></span>4.5.3 Instrumental Variables Interpretation and Potential Weak Identification

As pointed out by Rigobon (2003) and Rigobon and Sack (2003), identification by heteroskedasticity regimes has an instrumental variables interpretation, and this interpretation illustrates the potential inference challenges when the change in the variance provides only limited identification power either because the change is small, or because there are few observations in one of the regimes.

To illustrate the instrumental variables interpretation of identification by heteroske-dasticity, let n=2 and suppose that the variance of the first shock varies between the two regimes while the variance of the other shock does not. This is the assumption used by Rigobon and Sack (2004) and Wright (2012) with high-frequency data, in which the variance of the monetary policy shock ( $\varepsilon_{1t}$ ) is elevated around FOMC announcement dates while the variance of the other shocks does not change around announcement dates. Then under the unit effect normalization, (42) becomes,

$$\begin{pmatrix} \Sigma_{\eta_1\eta_1}^j & \Sigma_{\eta_1\eta_2}^j \\ \Sigma_{\eta_2\eta_1}^j & \Sigma_{\eta_2\eta_2}^j \end{pmatrix} = \begin{pmatrix} 1 & H_{12} \\ H_{21} & 1 \end{pmatrix} \begin{pmatrix} \sigma_{\varepsilon_1,j}^2 & 0 \\ 0 & \sigma_{\varepsilon_2}^2 \end{pmatrix} \begin{pmatrix} 1 & H_{21} \\ H_{12} & 1 \end{pmatrix}, \quad j = 1, 2, \tag{44}$$

where  $\sigma_{\varepsilon_1}^2$  varies across regimes (announcement dates, or not) while  $\sigma_{\varepsilon_2}^2$  does not.

Writing out the equations in (44) and solving shows that  $H_{21}$  is identified as the change in the covariance between  $\eta_{1t}$  and  $\eta_{2t}$ , relative to the change in the variance of  $\eta_{1t}$ :

$$H_{21} = \frac{\sum_{\eta_1 \eta_2}^2 - \sum_{\eta_1 \eta_2}^1}{\sum_{\eta_1 \eta_1}^2 - \sum_{\eta_1 \eta_1}^1}.$$
 (45)

This suggests the estimator,

$$\hat{H}_{21} = \frac{\sum_{t=1}^{T} \hat{\eta}_{2t} Z_t}{\sum_{t=1}^{T} \hat{\eta}_{1t} Z_t},\tag{46}$$

where  $Z_t = D_t \hat{\eta}_{1t}$ , where  $D_t = -1/T_1$  in the first regime and  $D_t = 1/T_2$  in the second regime, where  $T_1$  and  $T_2$  are the number of observation in each regime, and where  $\hat{\eta}_t$  are the innovations estimated by full-sample OLS or weighted least squares.

The estimator in (46) is the instrumental variables estimator in the regression of  $\hat{\eta}_{2t}$  on  $\hat{\eta}_{1t}$ , using  $Z_t$  as an instrument. Note the similarity of this IV interpretation to the IV interpretation in (39) arising from the very different identifying assumption that the cumulative IRF is lower triangular, so that  $H_{21}$  is estimated by the instrumental variables estimator using  $Y_{2t-1}$  as an instrument for  $\Delta Y_{2t}$ .

The IV expression (46) connects inference in the SVAR identification by heteroskedasticity to inference in instrumental variables regression, and in particular to inference when instruments might be weak. In (46), a weak instrument corresponds to the case that

 $Z_t$  is weakly correlated with  $\hat{\eta}_{1t}$ , that is, when the population change in the variance of  $\eta_{1t}$ , which appears in the denominator of (45), is small. Using the weak-instrument asymptotic nesting of Staiger and Stock (1997), one can show that, under standard moment conditions,  $\hat{H}_{21} \xrightarrow{d} z_2/z_1$ , where  $z_1$  and  $z_2$  are jointly normally distributed variables and where the mean of  $z_1$  is  $T^{1/2}\left(\Sigma_{\eta_1\eta_1}^2 - \Sigma_{\eta_1\eta_1}^1\right)$ . If the variability in  $z_1$  is sizeable compared with this mean, then the estimator will in general have a nonnormal and potentially bimodal distribution with heavy tails, and inference based on conventional bootstrap confidence intervals will be misleading.

These weak-instrument problems can arise if the regimes each have many observations, but the difference between the regime variances is small, or if the differences between the variances is large across regimes but one of the regimes has only a small number of observations. In either case, what matters for the distribution of  $\hat{H}_{21}$  is the precision of the estimate of the change in the variance of  $\eta_{10}$ , relative to the true change.

Work on weak-identification robust inference in SVARs identified by heteroskedasticity is in its early stages. Magnusson and Mavroeidis (2014) lay out a general approach to construction of weak-identification robust confidence sets, and Nakamura and Steinsson (2015) implement weak-identification robust inference in their application to differential monetary policy shock heteroskedasticity around FOMC announcement dates.

## 4.6 Inequality (Sign) Restrictions

The identification schemes discussed so far use a priori information to identify the parameters of H, or the parameters of the first column of H in the case of single shock identification. The sense in which these parameters are identified is the conventional one: different values of the parameter induce different distributions of the data, so that the parameters of H (or  $H_1$ ) are identified up to a single point. But achieving point identification can entail strong and, in many cases, controversial assumptions. As a result, in two seminal papers, Faust (1998) and Uhlig (2005) argued that instead identification could be achieved more convincingly by imposing restrictions on the signs of the impulse responses. They argued that such an approach connects directly with broad economic theories, for example a broad range of monetary theories suggest that monetary stimulus will have a nonnegative effect on economic activity over a horizon of, say, 1 year. This alternative approach to identification, in which the restriction takes the form of inequality restrictions on the IRF, does not produce point identification, however it does limit the possible values of H (or  $H_1$ ) to a set. That is, under inequality restrictions, H (or  $H_1$ ) is set identified.

Set identification introduces new econometric issues for both computation and inference. The standard approach to set identification in SVARs is to use Bayesian methods, which are numerically convenient. This section therefore begins by reviewing the mechanics of Bayesian inequality restriction methods, then turns to inferential issues arising from

<span id="page-50-0"></span>set identification with a focus on Bayesian sign-identified SVARs. The section concludes with some new research suggesting alternative ways to address these inferential issues.

#### 4.6.1 Inequality Restrictions and Computing an Estimate of the Identified Set

In some applications, economic theory or institutional circumstances might provide a strong argument about the sign of the effect of a given shock on some variable. For example, in a supply and demand example with price and quantity as data, economic theory strongly suggests that the supply elasticity is positive, the demand elasticity is negative, so a positive supply shock increases quantity and decreases price while a positive demand shock increases both quantity and price. More generally, theory might suggest the sign of the effect of a given positive shock on one or more of the variables in the VAR over a certain number of horizons, that is, theory might suggest sign restrictions on elements of the SIRF.

As shown by Faust (1998) and Uhlig (2005) and surveyed by Fry and Pagan (2011), sign restrictions, or more generally inequality restrictions on the SIRF, can be used to help identify the shocks. In general, inequality restrictions provide set, but not point, identification of H, that is, they serve to identify a set of H matrices which contains the unique true H. The econometric problem, then, is how to estimate H and how to perform inference about H given that it is set identified.

The dominant approach in the literature is Bayesian, following Uhlig (2005). The Bayesian inference problem is to compute the posterior distribution of the SIRFs D(L) given the data and a prior. With abuse of notation, we denote this posterior by f(D|Y).

Computing f(D|Y) requires a prior distribution for D(L). Because  $D(L) = A(L)^{-1}H$ , developing a prior for D(L) in turn entails developing a prior for A(L) and H. Uhlig's (2005) algorithm adopts the unit standard deviation normalization (31), so that  $\Sigma_{\eta} = HH'$ . Thus any H can be written as  $\Sigma_{\eta}^{1/2}Q$ , where  $\Sigma_{\eta}^{1/2}$  is the Cholesky decomposition of  $\Sigma_{\eta}$  and Q is an orthonormal matrix. Thus, under the unit standard deviation normalization,  $D(L) = A(L)^{-1}\Sigma_{\eta}^{1/2}Q$ . This expression has substantial computational advantages: A(L) and  $\Sigma_{\eta}$  are reduced-form parameters which have conjugate priors under the standard assumption of normally distributed errors, and the only nonstandard part of the prior is Q. Moreover, the dimension for the prior over Q is substantially reduced because  $QQ' = I_n$ . Let  $\mathfrak{D}$  denote the set of IRFs satisfying the sign restriction, so the prior imposing the sign restrictions is proportional to  $\mathbf{1}[D(L) \in \mathfrak{D}]$ .

Continuing to abuse notation, and adopting the convention that the priors over A(L),  $\Sigma_{\eta}$ , and Q are independent conditional on  $D(L) \in \mathfrak{D}$ , we can therefore write the posterior f(D|Y) as

$$f(D|Y) \propto f(Y|A(L), \Sigma_{\eta}, Q)\pi(A)\pi(\Sigma_{\eta})\pi(Q)\mathbf{1}[D(L) \in \mathfrak{D}]$$

$$\propto f(A(L), \Sigma_{\eta}|Y)\pi(Q)\mathbf{1}[D(L) \in \mathfrak{D}]$$
(47)

where  $f(Y|A(L), \Sigma_{\eta}, Q)$  is the Gaussian likelihood for the SVAR  $A(L)Y_t = \Sigma_{\eta}^{1/2}Q\varepsilon_t$ , with  $\Sigma_{\varepsilon} = I_n$ , and  $f(A(L), \Sigma_n|Y)$  is the posterior of the reduced-form VAR, where the second

<span id="page-51-0"></span>line in (47) follows because the likelihood does not depend on Q. Uhlig's (2005) algorithm uses conjugate Normal–Wishart priors for A(L) and  $\Sigma_{\eta}^{-1}$ , so computation of (or drawing from)  $f(A(L), \Sigma_{\eta}|Y)$  is straightforward.

The sign restrictions are imposed using the following algorithm.

- (1) Draw a candidate  $\widetilde{Q}$  from  $\pi(Q)$ , and  $(\widetilde{A}(L), \widetilde{\Sigma}_{\eta})$  from the posterior  $f(A(L), \Sigma_{\eta}|Y)$ .
- (2) Compute the implied SIRF,  $\widetilde{D}(L) = \widetilde{A}(L)^{-1} \widetilde{\Sigma}_{\eta}^{1/2} \widetilde{Q}$ .
- (3) Retain D(L) if it satisfies the inequality restrictions.
- (4) Repeat Steps (1)–(3) many times to obtain draws from f(D|Y).

This algorithm uses a prior distribution  $\pi(Q)$  over the space of orthonormal matrices. In the two-dimensional case all orthonormal matrices can be written as,

$$\widetilde{Q} = \begin{pmatrix} \cos\theta & -\sin\theta \\ \sin\theta & \cos\theta \end{pmatrix}. \tag{48}$$

Thus drawing from  $\pi(Q)$  reduces to drawing from a prior over  $\theta$ ,  $0 \le \theta \le 2\pi$ . Following Uhlig (2005), it is conventional to use (48) with  $\theta \sim U[0,2\pi]$ .

For n > 2, the restrictions are more complicated. For reasons of computational speed, Rubio-Ramírez et al. (2010) recommend using the QR or householder transformation method for drawing  $\widetilde{Q}$ , also see Arias et al. (2014). The QR method for constructing a draw of  $\widetilde{Q}$  in step (1) proceeds by first drawing a  $n \times n$  matrix  $\widetilde{W}$ , with elements that are independent standard normals, then using the QR decomposition to write  $\widetilde{W} = \widetilde{Q}\widetilde{R}$ , where  $\widetilde{Q}$  is orthonormal and  $\widetilde{R}$  is upper triangular.

The choice of prior  $\pi(Q)$ —in the n=2 case, the prior distribution for  $\theta$  in (48)—is consequential and ends up being informative for the posterior, and we return to this issue in the next section.

#### 4.6.1.1 Single Shock Identification

The discussion here has focused on system identification, however it can also be implemented for identification of a single shock. Specifically, if the inequality restrictions only involve one shock  $\varepsilon_1$ , then those restrictions only involve the first column of  $\widetilde{Q}$ ,  $\widetilde{Q}_1$ , and the resulting draw of  $H_1$  is  $\Sigma_n^{1/2}\widetilde{Q}_1$ .

#### 4.6.2 Inference When H Is Set Identified

The statistical problem is to provide a meaningful characterization of what the data tell us about the true value of H (and thus the true SIRFs) when H is only set identified. As pointed out by Fry and Pagan (2011), Moon and Schorfheide (2012), Moon et al. (2013), and Baumeister and Hamilton (2015a), the standard treatment of uncertainty using the posterior computed according to the algorithm in the preceding subsection raises a number of conceptual and technical problems. Central to these problems is that, because the SIRF is a nonlinear transformation of the parameter over which the prior is placed—in the n=2 case, over  $\theta$  in (48)—a seemingly flat prior over Q ends up being

highly informative for inference. Thus inference about the SIRFs is driven by assumptions unrelated to the economic issues at hand (priors over the space of orthonormal matrices) and which have opaque but impactful implications.

We focus on two inferential problems. To illustrate the issues, we consider a stripped-down two-variable SVAR. The researcher is interested in constructing SIRFs and makes the sign restriction that the effect of shock 1 on both variables 1 and 2 is nonnegative on impact and for the first four periods; that is,  $D_{h,11} \ge 0$  and  $D_{h,21} \ge 0$ , h = 0, ..., 4, where  $D(L) = A(L)^{-1}H$  is the SIRF.

To keep the example as simple as possible, suppose that the reduced-form VAR is first order, that A(L) is diagonal, and that the innovations have identity innovation variance. That is,

$$A(L) = \begin{pmatrix} 1 - \alpha_1 L & 0 \\ 0 & 1 - \alpha_2 L \end{pmatrix} \text{ where } \alpha_1, \alpha_2 > 0 \text{ and } \Sigma_{\eta} = I$$
 (49)

so  $Chol(\Sigma_{\eta}) = I$ . Further suppose that the sample size is sufficiently large that these reduced-form parameters can be treated as known; thus the only SVAR uncertainty arises from Q or, because n = 2, from  $\theta$  in (48). The researcher draws candidate orthonormal matrices  $\widetilde{Q}$  using (48), where  $\theta \sim U[0,2\pi]$ . What is the resulting inference on the SIRF D(L)?

Under these assumptions, both the identified set for the SIRF for the first shock and the posterior distribution can be computed analytically. In large samples, for a particular draw  $\widetilde{Q}$ , the candidate IRF is,

$$\widetilde{D}(L) = \widetilde{A}(L)^{-1} \Sigma_{\eta}^{1/2} \widetilde{Q} = \begin{pmatrix} (1 - \alpha_1 L)^{-1} \cos \theta & -(1 - \alpha_1 L)^{-1} \sin \theta \\ (1 - \alpha_2 L)^{-1} \sin \theta & (1 - \alpha_2 L)^{-1} \cos \theta \end{pmatrix}, \tag{50}$$

where the equality uses the large-sample assumption that there is no sampling variability associated with estimation of A(L) or  $\Sigma_{\eta}$ , so that the posterior draws  $\left(\widetilde{A}(L),\widetilde{\Sigma}_{\eta}\right) = \left(A(L),\Sigma_{\eta}\right)$ . Applying the sign restrictions to the first column of (50) implies that  $\widetilde{D}(L)$  satisfies the sign restrictions if  $\cos\theta \geq 0$  and  $\sin\theta \geq 0$ , that is, if  $0 \leq \theta \leq \pi/2$ . Thus the identified set for  $D_{21}(L)$  is  $0 \leq D_{21}(L) \leq (1-\alpha_2 L)^{-1}$ , so the identified set for the hth lag of the IRF is  $[0,\alpha_2^h]$ .

Because  $D_{21}(L) = (1 - \alpha_2 L)^{-1} \sin \theta$ , the posterior distribution of the *h*-period SIRF of shock 2 on variable 1,  $D_{h,21}$ , is the posterior distribution of  $\alpha_2^h \sin \theta$ , where  $\theta \sim U[0,\pi/2]$ . The mean of this posterior is  $E[D_{h,21}] = E(\alpha_2^h \sin \theta) = 2\alpha_2^h/\pi \approx 0.637\alpha_2^h$  and the posterior median is  $0.707\alpha_2^h$ . By a change of variables, the posterior density of  $D_{h,21}$  is  $p_{\hat{D}_{21,i}|Y}(x) \propto 2\alpha_2^h/\pi\sqrt{1-x^2}$ , and the equal-tailed 68% posterior coverage region is  $[0.259\alpha_2^h, 0.966\alpha_2^h]$ .

<sup>&</sup>lt;sup>v</sup> This example is similar to the n=2 example in Baumeister and Hamilton (2015a), but further simplified.

<sup>&</sup>lt;sup>w</sup> In the case n=2, this is equivalent to drawing  $\widetilde{Q}$  using the QR algorithm discussed in Section 4.6.1.

This example illustrates two issues with sign-identified Bayesian inference. First, the posterior coverage interval concentrates strictly within the identified set. As pointed out by [Moon and Schorfheide \(2012\)](#page-108-0), this result is generic to set-identified Bayesian econometrics in large samples. From a frequentist perspective, this is troubling. In standard parametric settings, in large samples Bayesian 95% posterior intervals coincide with frequentist 95% confidence intervals so, from a frequentist perspective, Bayes confidence sets contain the true parameter value in 95% of all realizations of the sample for all values of the true parameter. This is not the case in this sign-identified setting, however: over repeated samples, the Bayesian interval contains the true parameter value all of the time for some values of the parameter, and none of the time for others.<sup>x</sup>

Second, although the sign restrictions provide no a priori knowledge over the identified region, the "flat" prior on θ induces an informative posterior over the identified set, and in this example places most of the mass on large values of Dh,21. Although this effect is transparent in this simple example, [Baumeister and Hamilton \(2015a\)](#page-103-0) show that the implied posteriors over the identified set can have highly informative and unintuitive shapes in more complicated models and in higher dimensions. The presence of sampling uncertainty in A(L) and Ση, which this example assumes away, further complicates the problem of knowing how inference is affected by the prior distribution.

In practice there is additional sampling variability in the reduced-form parameters A(L) and Ση. In the Bayesian context, this variability is handled by additionally integrating over the priors for those parameters, and with sampling variability the [Moon](#page-108-0) [and Schorfheide \(2012\)](#page-108-0) result that the posterior coverage set is strictly contained in the identified set need not hold. The lesson of the example, however, is that Bayesian posterior inference depends on the arbitrary prior over the space of orthonormal matrices. In short, conventional Bayesian methods can be justified from a subjectivist Bayes perspective, but doing so results in inferences that a frequentist would find unacceptable.<sup>y</sup>

<sup>x</sup> The asymptotic coincidence of Bayesian and frequentist confidence sets in standard parametric models, and of the posterior mean and the maximum likelihood estimator, is generally known as the Bernstein–von Mises theorem. [Freedman \(1999\)](#page-106-0) provides an introduction to the theorem and examples of the breakdown

of the theorem other than set-identified inference here. Also see [Moon and Schorfheide \(2012\)](#page-108-0). <sup>y</sup> A technical issue with Bayesian sign-identified SVARs is that it is conventional to examine impulse responses pointwise, as we did in the example by examining the posterior for Dh,21 for a given h rather than as a function of h. Thus the values of the VAR parameters corresponding to the posterior mode at one horizon will in general differ from the value at another horizon. See [Sims and Zha \(1999\)](#page-109-0) for a discussion. [Inoue and Kilian \(2013\)](#page-106-0) suggest a way to handle this problem and compute most likely IRFs pathways not pointwise.

### 4.6.2.1 Implications of the Unit Standard Deviation Normalization

The use of the unit standard deviation normalization in conventional Bayesian algorithms means that the SIRFs are all in standard deviation units. For questions posed in native units (what is the effect of a +25 basis point monetary policy shock to the Federal Funds rate?), it is necessary to rescale by the standard deviation of the shock. As [Fry and Pagan](#page-106-0) [\(2011\)](#page-106-0) point out, in the set-identified context, this rescaling raises additional inferential problems beyond those in the point-identified setting. Specifically, the conversion to the unit effect normalization must be done for each draw, not at a final step, because there is no consistent estimator for H under this method.

#### 4.6.2.2 New Approaches to Inference in Set-Identified SVARs

These inferential problems are difficult and research is ongoing. Here, we briefly describe five new approaches.

The first two approaches are frequentist. A great deal of econometric research over the past decade has tackled frequentist approaches to set-identified inference in general. Inference when the parameter is identified by moment inequalities is nonstandard and—as in the SVAR application—can have the additional problem that the number of moment inequalities can be large but that only one or a few inequalities might be binding for a given value of the parameters. Including many non-binding inequalities for inference typically widens confidence intervals. The two approaches proposed to date for frequentist inference in set-identified SVARs differ in how to handle the problem of many inequalities. [Moon et al. \(2013\)](#page-108-0) start with all the inequalities, then use a modification of Andrews and [Soares's \(2010\)](#page-103-0) moment selection procedure to tighten the confidence intervals. Alternatively, Gafarov [and Montiel Olea \(2015\)](#page-106-0) use only inequality constraints on H (ie, impact effects), which yield substantial computational simplifications. Their results suggest that, despite using fewer restrictions, confidence intervals can be tighter in some applications than if all the inequalities are used.

The remaining approaches are Bayesian. [Baumeister and Hamilton \(2015a\)](#page-103-0) suggest replacing the prior on Q (on θ in the two-dimensional case) with a prior directly on the impact multiplier, that is, on H21. That prior could be flat, truncated (for sign restrictions) or otherwise informative. This approach addresses the problem in the example earlier that the "flat" prior π(Q) on the space of orthonormal matrices induces an informative posterior for the IRF even in large samples. However, this approach remains subject to the [Moon and Schorfheide \(2012\)](#page-108-0) critique that the Bayesian posterior set asymptotically falls strictly within the identified set.

[Giacomini and Kitagawa \(2014\)](#page-106-0) propose instead to use robust Bayes inference. This entails sweeping through the set of possible priors over Q, computing posterior regions for each, and reporting the posterior region that is the union of the prior-specific regions, and range of posterior means which is the range of the prior-specific posterior means. <span id="page-55-0"></span>They provide conditions under which the robust credible set converges to the identified set if the sample is large (thereby avoiding the Moon and Schorfheide (2012) critique).

Plagborg-Møller (2015) takes a very different approach and treats the SIRF as the primitive over which the prior is placed; in contrast to Baumeister and Hamilton (2015a,b) who place priors on the impact effect (*H*), Plagborg-Møller (2015) places a joint prior over the entire IRF. By directly parameterizing the structural MA representation he also handles the problem of noninvertible representations, where the prior serves to distinguish observationally equivalent SVARs.

#### 4.7 Method of External Instruments

Instrumental variables estimation uses some quantifiable exogenous variation in an endogenous variable to estimate the causal effect of the endogenous variable. If a variable measuring such exogenous variation is available for a given shock, but that variable is not included in the VAR, it can be used to estimate the SIRF using a vector extension of instrumental variable regression. This method, which is due to Stock (2008), has been used in a small but increasing number of recent papers including Stock and Watson (2012a), Mertens and Ravn (2013), and Gertler and Karadi (2015). This method is also called the "proxy VAR" method, but we find the "method of external instruments" more descriptive.

Consider identification of the single shock  $\varepsilon_{1t}$ . Suppose that there is a vector of variables  $Z_t$  that satisfies:

(i) 
$$E(\varepsilon_{1t}Z'_t) = \alpha' \neq 0$$
 (51)

(ii) 
$$E(\varepsilon_{it}Z'_t) = 0, \quad j = 2, ..., n.$$
 (52)

The variable  $Z_t$  is called an *external instrument*: external because it is not an element of  $Y_t$  in the VAR, and an instrument because it can be used to estimate  $H_1$  by instrumental variables.

Condition (i) corresponds to the usual relevance condition in instrumental variables regression and requires that the instrument be correlated with the endogenous variable of interest,  $\varepsilon_{1t}$ . Condition (ii) corresponds to the usual condition for instrument exogeneity and requires that the instrument be uncorrelated with the other structural shocks.

Conditions (i) and (ii), combined with the assumption (21) that the shocks are uncorrelated and the unit effect normalization (32), serve to identify  $H_1$  and thus the structural shock. To see this, use  $\eta_t = H\varepsilon_t$  along with (i) and (ii) and the partitioning notation (28) to write,

$$\begin{pmatrix}
E(\eta_{1t}Z_t') \\
E(\eta_{\bullet t}Z_t')
\end{pmatrix} = E(\eta_t Z_t') = E(H\varepsilon_t Z_t') = [H_1 \ H_{\bullet}] \begin{pmatrix}
E(\varepsilon_{1t}Z_t') \\
E(\varepsilon_{\bullet t}Z_t')
\end{pmatrix} = H_1 \alpha' = \begin{pmatrix}
\alpha' \\
H_{1\bullet}\alpha'
\end{pmatrix},$$
(53)

<span id="page-56-0"></span>where  $\eta_{\bullet t}$  denotes the final n-1 rows of  $\eta_t$ , the second equality uses  $\eta_t = H\varepsilon_t$ , the third equality uses the partitioning notation (28), the fourth equality uses (i) and (ii), and the final equality uses the unit effect normalization  $H_{11} = 1$  in (33).

Equating the first and the final expressions in (53) show that  $H_{1\bullet}$ , and thus  $H_{1}$  and  $\varepsilon_{1t}$ , are identified. In the case of a single instrument, one obtains the expression,

$$H_{1\bullet} = \frac{E\eta_{\bullet t} Z_t}{E\eta_{1t} Z_t}.$$
 (54)

This expression has a natural instrumental variables interpretation: the effect of  $\varepsilon_{1t}$  on  $\eta_{jt}$ , that is, the *j*th element of *H*, is identified as the coefficient in the population IV regression of  $\eta_{jt}$  onto  $\eta_{1t}$  using the instrument  $Z_t$ .

As with standard instrumental variables regression, the success of the method of external instruments depends on having at least one instrument that is strong and credibly exogenous. Although the literature on SVAR estimation using external instruments is young, at least in some circumstances such instruments are plausibly available. For example, the Cochrane and Piazzesi (2002) measure of the monetary shock discussed in Section 4.2 is not in fact the monetary shock: as they note, even if it successfully captures that part of the shock that was learned as an immediate result of FOMC meetings, it is possible that speeches of FOMC members and other Fed actions could provide signals of rate movements before the actual FOMC meeting. Thus, the Cochrane and Piazzesi (2002) measure is better thought of as an instrumental variable for the shock, not the shock itself; that is, it is plausibly correlated with the monetary policy shock and, because it is measured in a window around the FOMC meeting, it is plausibly exogenous. Viewed in this light, many of the series constructed as measures of shocks discussed in Section 4.4 are not in fact the actual shock series but rather are instruments for the shock series. Accordingly, SVARs that include these measures of shocks as a variable are not actually measuring the SIRF with respect to those shocks, but rather are measuring a reducedform IRF with respect to this instrument for the shocks. In contrast, the method of external instruments identifies the IRF with respect to the structural shock.

As with IV regression more generally, if the instrument is weak then conventional asymptotic inference is unreliable. The details of external instruments in SVARs are sufficiently different from IV regression that the methods for inference under weak identification do not apply directly in the SVAR application. Work on inference with potentially weak external instruments in SVARs is currently under way (Montiel Olea et al., 2016).

#### 5. STRUCTURAL DFMs AND FAVARS

Structural DFMs hold the possibility of solving three recognized shortcomings of SVARs. First, including many variables increases the ability of the innovations to span the space of structural shocks, thereby addressing the omitted variables problem discussed

in Section 4.1.2. Second, because the shocks are shocks to the common factors, DFMs provide a natural framework for allowing for measurement error or idiosyncratic variation in individual series, thereby addressing the errors-in-variables problem in Section 4.1.2. Third, high-dimensional structural DFMs make it possible to estimate SIRFs, historical decompositions, and FEVDs that are consistent across arbitrarily many observed variables. Although these goals can be achieved using high-dimensional VARs, because the number of VAR parameters increases with  $n^2$ , those large-n VARs require adopting informative priors which typically are statistical in nature. In contrast, because in DFMs the number of parameters increases proportionately to n, DFMs do not require strong restrictions, beyond the testable restrictions of the factor structure, to estimate the parameters.

This section describes how SVAR methods extend directly to DFMs, resulting in a SDFM. In a SDFM, all the factors are unobserved. With a minor modification, one or more of the factors can be treated as observed, in which case the SDFM becomes a FAVAR. The key to meshing SVAR identification straight forwardly with DFMs is two normalizations: the "named factor" normalization in Section 2.1.3 for DFMs and the unit effect normalization described in Section 4.1.3 for SVARs. The named factor normalization ascribes the name of, say, the first variable, to the first factor, so that the innovation in the first factor equals the innovation in the common component of the first variable. The unit effect normalization says that the structural shock of interest, say the first shock, has a unit effect on the innovation to the first factor.

Taken together, these normalizations link an innovation in a factor to the innovation in a common component in a variable (naming) and set the scale of the structural shock (unit effect). For example, a one percentage point positive monetary supply shock increases the innovation in the Fed funds factor by one percentage point, which increases the innovation to the common component of the Federal funds rate by one percentage point, which increases the Federal funds rate by one percentage point. These normalizations do not identify the monetary policy shock, but any scheme that would identify the monetary policy shock in a SVAR can now be used to identify the monetary policy shock from the factor innovations.

This section works through the details of the previous paragraph. The section first considers SDFMs in the case of no additional restrictions on the factor loading matrix  $\Lambda$ , next turns to SDFMs in which  $\Lambda$  has additional restrictions and concludes with the extension of SVAR identification methods to FAVARs. This section provides a unified treatment that clarifies the link between SVARs, SDFMs, and FAVARs, including extensions to overidentified cases.

The literature has taken a number of approaches to extending SVARs to structural DFMs, and this section unifies and extends those approaches. The original FAVAR structure is due to Bernanke et al. (2005). Stock and Watson (2005) propose an approach with different normalizations and the treatment here streamlines theirs. The treatment of

<span id="page-58-0"></span>exactly identified SDFMs here is the same as in Stock and Watson (2012a). The other closest treatments in the literature are Forni and Gambetti (2010), Bai and Ng (2013), Bai and Wang (2014), and Bjørnland and Thorsrud (forthcoming).

#### 5.1 Structural Shocks in DFMs and the Unit Effect Normalization

The structural DFM posits that the innovations in the factors are linear combinations of underlying structural shocks  $\varepsilon_t$ .

#### 5.1.1 The SDFM

The SDFM augments the static DFM (6) and (7) with the assumption (20) that the factor innovations  $\eta_t$  are linear combinations of the structural shocks  $\varepsilon_t$ :

$$X_t = \Lambda^{n \times r} F_t + P_t^{n \times 1}$$

$$(55)$$

$$\overset{r \times r}{\boldsymbol{\Phi}}(\mathbf{L}) \overset{r \times 1}{F_t} = \overset{r \times q}{G} \overset{q \times 1}{\boldsymbol{\eta}_t} \quad \text{where } \boldsymbol{\Phi}(\mathbf{L}) = I - \boldsymbol{\Phi}_1 \mathbf{L} - \dots - \boldsymbol{\Phi}_p \mathbf{L}^p, \tag{56}$$

$$\eta_t = H \varepsilon_t$$
(57)

where following (7), there are r static factors and q dynamic factors, with  $r \ge q$ . In this system, the q structural shocks  $\varepsilon_t$  impact the common factors but not the idiosyncratic terms. Additionally, we assume that (SVAR-1)—(SVAR-3) in Section 4.1.4 hold, that the  $q \times q$  matrix H is invertible (so the structural shocks can be recovered from the factor innovations), and that the shocks are mutually uncorrelated, that is,  $\Sigma_{\varepsilon}$  is diagonal as in (21).

The SIRF is obtained by substituting (57) into (56) and the result into (55) to obtain,

$$X_t = \Lambda \Phi(L)^{-1} GH \varepsilon_t + e_t.$$
 (58)

The dynamic causal effect on all n variables of a unit increase in  $\varepsilon_t$  is the SIRF, which is  $\Lambda \Phi(L)^{-1}GH$ . Equivalently, the first term on the right-hand side of (58) is the moving average representation of the common component of  $X_t$  in terms of the structural shocks.

If interest is only in one shock, say the first shock, then the SIRF for that shock is  $\Lambda \Phi(L)^{-1}GH_1$ .

The SDFM generalizes the SVAR by allowing for more variables than structural shocks, and by allowing each variable to have idiosyncratic dynamics and/or measurement error. In the special case that there is no idiosyncratic error term (so  $e_t = 0$ ), r = q = n,  $\Lambda = I$ , and G = I, the SDFM (58) is simply the structural MA representation (23), where  $\Phi(L) = A(L)$ .

## 5.1.2 Combining the Unit Effect and Named Factor Normalizations

The SDFM (55)–(57) requires three normalizations:  $\Lambda$ , G, and H. We first consider the case r = q, so that the static factors have a full-rank covariance matrix, then turn to the case of  $r \ge q$ .

#### <span id="page-59-0"></span>5.1.2.1 Normalization with r=q

In this case, set G = I, so that  $\eta_t$  are the innovations to the factors. We use the named factor normalization (12) for  $\Lambda$  and the unit effect normalization (32) for H. Using these two normalizations provides SIRFs in the native units of the variables and ensure that inference about SIRFs will not err by neglecting the data-dependent rescaling needed to convert from standard deviation units (if the unit standard deviation normalization is used) to native units.

As discussed in Section 2.1.3, the named factor normalization associates a factor innovation (and thus a factor) with the innovation to the common component of the naming variable. Without loss of generality, place the naming variables first, so that the first factor adopts the name of the first variable and so forth up to all r factors. Then  $\Lambda_{1:r} = I_r$  where, as in (12),  $\Lambda_{1:r}$  denotes rows 1 through r of  $\Lambda$ . If there are no overidentifying restrictions on  $\Lambda$ ,  $\Lambda$  and  $F_t$  can first be estimated by principal components, then transformed as discussed following (12). That is, letting PC denote the principal components estimators,

$$\hat{\Lambda} = \begin{bmatrix} I_r \\ \hat{\Lambda}_{r+1:n}^{PC} (\hat{\Lambda}_{1:r}^{PC})^{-1} \end{bmatrix} \text{ and } \hat{F}_t = \hat{\Lambda}_{1:r}^{PC} \hat{F}_t^{PC}.$$
 (59)

Together, the named factor normalization and the unit effect normalization set the scale of the structural shocks. For example, if the oil price and oil price supply shock are ordered first, a unit oil price supply shock induces a unit innovation in the first factor, which is the innovation in the common component of the oil price, which increases the oil price by one native unit (for example, by one percentage point if the oil price is in percent). Restated in terms of the notation in (58) and (59), the impact effect of  $\varepsilon_{1t}$  on  $X_{1t}$  is  $\Lambda_1 H_1$ , where  $\Lambda_1$  is the first row of  $\Lambda$ . Because  $\Lambda_1 = (1 \ 0 \ ... \ 0)$  and the unit effect normalization sets  $H_{11} = 1$ ,  $\Lambda'_1 H_1 = 1$ . Thus a unit increase in  $\varepsilon_{1t}$  increases  $X_{1t}$  by one (native) unit.

This approach extends to overidentifying restrictions on  $\Lambda$  using the methods of Section 2.3.1. To be concrete, in Section 7 we consider an empirical application to identifying an oil supply shock. Our dataset has four different oil prices (the US producer price index for crude petroleum, Brent, West Texas Intermediate (WTI), and the US refiners' acquisition cost of imported oil estimated by the US Energy Information Administration, all in logs). These series, which are available over different time spans, generally move together but their spreads vary because of local conditions and differences in crude oil grades. All four variables are measures of oil prices that have been, used in the oil-macro literature. We therefore model the real oil price factor innovation as impinging on all four real prices with a unit coefficient. The named factor normalization thus is,

$$\begin{bmatrix} p_t^{PPI-Oil} \\ p_t^{Brent} \\ p_t^{WTI} \\ p_t^{RAC} \\ X_{5:n \ t} \end{bmatrix} = \begin{bmatrix} 1 & 0 & \cdots & 0 \\ 1 & 0 & \cdots & 0 \\ 1 & 0 & \cdots & 0 \\ 1 & 0 & \cdots & 0 \\ \Lambda_{5:n} \end{bmatrix} \begin{bmatrix} F_t^{oil} \\ F_{2:r, t} \end{bmatrix} + e_t, \tag{60}$$

<span id="page-60-0"></span>where  $p_t^{PPI-Oil}$  is the logarithm of the real price of crude oil from the producer price index, etc. Strictly speaking, any one of the first four rows of (60) is a naming normalization; the remaining rows are additional restrictions that treat the other three oil prices as additional indicators of the single oil price shock. At this point the number of static factors r is left unspecified; in the empirical application of Section 7, we use r=8.

Given the restricted  $\Lambda$  in (60), the static factors can be estimated by restricted principal components as described in Section 2.3.1 (by numerical minimization of the least-squares objective function (14) subject to the restrictions on  $\Lambda$  shown in (60)). The first factor computed from this minimization problem is the oil factor.

#### 5.1.2.2 Normalization with r > q

If the empirical analysis of the DFM discussed in Section 2.4.2 indicates that the number of dynamic factors q is less than the number of static factors r, then an additional step is needed to estimate G. This step also needs to be consistent with the unit effect normalization. Accordingly, we normalize G so that

$$G = \begin{bmatrix} I_q \\ G_{q+1:r} \end{bmatrix}, \tag{61}$$

where  $G_{q+1:r}$  is an unrestricted  $(q-r) \times q$  matrix.

In population, G satisfying (61) can be constructed by first obtaining the innovations  $a_t$  to the factors, so that  $\Phi(L)F_t = a_t$ . Because r > q,  $\Sigma_a = Ea_t a_t'$  has rank q. Partition  $a_t = \left(a_{1t}' a_{2t}'\right)'$ , where  $a_{1t}$  is  $q \times 1$  and  $a_{2t}$  is  $(r-q) \times 1$ , and similarly partition  $\Sigma_a$ . Assuming that the upper  $q \times q$  block of  $\Sigma_a$  is full rank, we can set  $\eta_t = a_{1t}$  and  $G_{q+1:r} = \Sigma_{a,21} \Sigma_{a,11}^{-1}$ . This construction results in the normalization (61).

In sample, these population objects can be replaced by sample objects. That is, let  $\hat{a}_t$  be the residuals from a regression of  $\hat{F}_t$  onto p lags of  $\hat{F}_t$ , let  $\hat{\eta}_t = \hat{a}_{1t}$  and let  $\hat{\Sigma}_a$  denote the sample covariance matrix of  $\hat{a}_t$ . Then  $\hat{G}_{q+1:r} = \hat{\Sigma}_{a,21} \hat{\Sigma}_{a,11}^{-1}$  is the matrix of coefficients in the regression of  $\hat{a}_{2t}$  onto  $\hat{\eta}_t$ .

 $<sup>^</sup>z$  This algorithm assumes that the sample inverse  $\hat{\Sigma}_{a,11}^{-1}$  is well behaved.

#### <span id="page-61-0"></span>5.1.2.3 Estimation Given an Identification Scheme

With the normalization set, the identification schemes discussed in Section 4 carry over directly. The innovation  $\eta_t$  in Section 4 is now the innovation to the factors, however, the factors (or the subset that are needed) have now been named, and the scale has been set on the structural shocks, so all that remains is to implement the identification scheme. The formulas in Section 4 carry over with the notational modification of setting A(L) in Section 4 to  $\Phi(L)$ . Section 6 illustrates two contemporaneous restriction identification schemes for oil prices.

#### 5.1.3 Standard Errors for SIRFs

There are various ways to compute standard errors for the SIRFs and for other statistics of interest such as FEVDs. The method used in this chapter is the parametric bootstrap, which (like other standard bootstrap methods) applies only when there is strong identification.

The parametric bootstrap used here proceeds as follows.

- **1.** Estimate  $\Lambda$ ,  $F_t$ ,  $\Phi$ (L), G, and  $\Sigma_{\eta}$ , and compute the idiosyncratic residual  $\hat{e}_t = X_t \hat{\Lambda}\hat{F}_t$ .
- **2.** Estimate univariate autoregressive processes for  $\hat{e}_t$ ,  $\hat{e}_{it} = d_i(L)\hat{e}_{it-1} + \zeta_{it}$  (this chapter uses an AR(4)).
- 3. Generate a bootstrap draw of the data by (a) independently drawing  $\widetilde{\eta}_t \sim N(0, \widehat{\Sigma}_{\eta})$  and  $\zeta_{it} \sim N(0, \widehat{\sigma}_{\zeta_i}^2)$ ; (b) using the draws of  $\zeta_{it}$  and the autoregression coefficients  $\widehat{d}_i(L)$  to generate idiosyncratic errors  $\widetilde{e}_t$ ; (c) using  $\widehat{\Phi}(L)$ ,  $\widehat{G}$ , and  $\widetilde{\eta}_t$  to generate factors  $\widetilde{F}_t$ ; and (d) generating bootstrap data as  $\widetilde{X}_t = \widehat{\Lambda} \widetilde{F}_t + \widetilde{e}_t$ .
- **4.** Using the bootstrap data, estimate  $\Lambda$ ,  $F_t$ ,  $\Phi(L)$ , G, and H to obtain a bootstrap estimate of the SIRF  $\Lambda\Phi(L)GH$ . For identification of a subset of shocks, replace H with the columns of H corresponding to the identified shock(s).
- **5.** Repeat Steps 3 and 4 for the desired number of bootstrap draws, then construct bootstrap standard errors, confidence intervals, and/or tests.

Variations on this approach are possible, for example the normal errors drawn in Step 3 could be replaced by block bootstrap resampling of the residuals from the factor VAR and the idiosyncratic autoregression.

There is ongoing work on improving inference in DFMs, SDFMs, and FAVARs using the bootstrap. For example, Yamamoto (2012) develops a bootstrap procedure for FAVARs under the unit standard deviation normalization. Corradi and Swanson (2014) consider the bootstrap for tests of the stability of the factor loadings and factor-augmented regression coefficients. Gonçalves and Perron (2015) establish the asymptotic validity of the bootstrap for the parameters in factor-augmented regressions. Gonçalves et al. (forthcoming) develop bootstrap prediction intervals for DFMs for h-period ahead forecasts. Going into detail on these developments is beyond the scope of this paper.
