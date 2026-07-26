## 5. Indirect-MD estimation

<span id="page-4-0"></span>We now present our indirect-MD estimation approach based on the SVAR representation (9) and the availability of external (strong) proxies  $w_t$  for the non-target shocks. In this framework, given the estimator of the parameters in  $A_1$ , we described below, the IRFs in (5) are recovered by using (2).

<sup>&</sup>lt;sup>4</sup> The MBB is similar in spirit to a standard residual-based bootstrap where the VAR residuals are resampled with replacement. However, instead of resampling one VAR residual at a time the MBB, which is robust against forms of 'weak dependence' that may arise under α-mixing conditions, resamples blocks of the VAR residuals/proxies in order to replicate their serial dependence structure. We refer to Jentsch and Lunsford (2019, 2022) and Mertens and Ravn (2019) for a comprehensive discussion of the merits of the MBB relative to other bootstrap methods in proxy-SVARs. Section S.7 in the Supplement sketches the essential steps behind the MBB algorithm.

<sup>&</sup>lt;sup>5</sup> In principle, Assumption 4 can be generalized to allow for more proxies than instrumented non-target shocks; i.e.,  $\dim(w_t) > \dim(\tilde{\epsilon}_{2,t}) = s$ . Without loss of generality, we focus on the case where  $\Lambda$  in (10) is a square matrix.

The first k equations of system (9) read

<span id="page-5-0"></span>
$$A_{1} u_{t} \equiv A_{1,1} u_{1,t} + A_{1,2} u_{2,t} = \varepsilon_{1,t}. \tag{13}$$

Taking the variance of both sides of (13), we obtain the  $\frac{1}{2}k(k+1)$  moment conditions

<span id="page-5-1"></span>
$$A_1, \Sigma_{\mu} A_1' = I_k. \tag{14}$$

Post-multiplying (13) by  $w'_t$  and taking expectations yield the additional ks moment conditions

<span id="page-5-2"></span>
$$A_{1\bullet} \Sigma_{n,n} = 0_{k \times r}. \tag{15}$$

Taken together, (14) and (15) provide  $m := \frac{1}{2}k(k+1) + ks$  independent moment conditions that can be used to estimate the parameters in  $A_{1*}$ . The idea is simple: the moment conditions (14)–(15) define a set of 'distances' between reduced form and structural parameters, which can be minimized once  $\Sigma_u$  and  $\Sigma_{u,u}$  are replaced with their consistent estimates. When k > 1, however, the proxies alone do not suffice to point-identify the proxy-SVAR, and it is necessary to impose additional parametric restrictions; see Mertens and Ravn (2013), Angelini and Fanelli (2019), Montiel Olea et al. (2021), Arias et al. (2021) and Giacomini et al. (2022). Depending on the information/theory available, the additional restrictions can involve the parameters in  $A_{1*}$  or those in  $B_{*1}$ , and can be sign- or point-restrictions. We rule out the case of sign-restrictions and, as in Angelini and Fanelli (2019), focus on general (possibly non-homogeneous) linear constraints on  $A_{1*}$ , as given by

<span id="page-5-4"></span><span id="page-5-3"></span>
$$vec(A_1,) = S_{A_1}\alpha + s_{A_1}$$
 (16)

where  $\alpha$  is the vector of (free) structural parameters in  $A_1$ ,  $S_{A_1}$  is a full-column rank selection matrix and  $s_{A_1}$  is a known vector. Under (16), we provide below necessary and sufficient conditions for local identification of the proxy-SVAR; we refer to Bacchiocchi and Kitagawa (2022) for a thorough investigation of SVARs that attain local identification, but may fail to attain global identification.

Let  $\sigma^+ := (vech(\Sigma_u)', vec(\Sigma_{u,w})')'$  be the  $m \times 1$  vector of reduced form parameters entering the moment conditions in (14)–(15). Let  $\hat{\sigma}_T^+ := (vech(\hat{\Sigma}_u)', vec(\hat{\Sigma}_{u,w})')'$  be the estimator of  $\sigma^+$ , and  $\sigma_0^+$  the corresponding true value.  $\hat{\sigma}_T^+$  is easily obtained from  $\hat{\Sigma}_{u,w} := \frac{1}{T} \sum_{t=1}^T \hat{u}_t w_t'$  and  $\hat{\Sigma}_u := \frac{1}{T} \sum_{t=1}^T \hat{u}_t \hat{u}_t'$ ,  $\hat{u}_t$ ,  $t=1,\ldots,T$ , being the VAR residuals. By Lemma S.1 in the Supplement,  $T^{1/2}(\hat{\sigma}_T^+ - \sigma_0^+) \stackrel{d}{\to} N(0_{a\times 1}, V_{\sigma^+})$ , with  $V_{\sigma^+}$  positive definite asymptotic covariance matrix that can be estimated consistently under fairly general conditions. The moment conditions (14)–(15) and the restrictions in (16) can be summarized by the distance function

<span id="page-5-9"></span>
$$g(\sigma^+, \alpha) := \begin{pmatrix} vech(A_1, \Sigma_u A'_{1\bullet} - I_k) \\ vec(A_1, \Sigma_{u,w}) \end{pmatrix}$$

$$(17)$$

where  $A_1$ , depends on  $\alpha$  through (16). At the true parameter values,  $g(\sigma_0^+, \alpha_0) = 0_{m \times 1}$ . The MD estimator of  $\alpha$  is defined as

<span id="page-5-6"></span><span id="page-5-5"></span>
$$\hat{\alpha}_T := \arg\min_{\alpha \in \mathcal{P}_n} \hat{Q}_T(\alpha), \quad \hat{Q}_T(\alpha) := g_T(\hat{\sigma}_T^+, \alpha)' \hat{V}_{gg}(\bar{\alpha})^{-1} g_T(\hat{\sigma}_T^+, \alpha)$$

$$\tag{18}$$

where  $g_T(\cdot,\cdot)$  denotes the function  $g(\cdot,\cdot)$  once  $\sigma^+$  is replaced with  $\hat{\sigma}_T^+$ ,  $\mathcal{P}_\alpha$  is the parameter space,  $\hat{V}_{gg}(\alpha) := G_{\sigma^+}(\hat{\sigma}_T^+, \alpha)\hat{V}_{\sigma^+}G_{\sigma^+}(\hat{\sigma}_T^+, \alpha)'$ ,  $\hat{V}_{\sigma^+}$  is a consistent estimator of  $V_{\sigma^+}$ , and  $G_{\sigma^+}(\sigma^+, \alpha)$  is the  $m \times m$  Jacobian matrix  $G_{\sigma^+}(\sigma^+, \alpha) := \frac{\partial g(\sigma^+, \alpha)}{\partial \sigma^{+\prime}}$ . Finally,  $\bar{\alpha}$  (interior point of  $\mathcal{P}_\alpha$ ) is some preliminary estimate of  $\alpha$ ; for example,  $\bar{\alpha}$  might be the MD estimate of  $\alpha$  obtained in a first-step by replacing  $\hat{V}_{gg}(\bar{\alpha})$  in (18) with the identity matrix, in which case  $\hat{\alpha}_T$  from (18) corresponds to a classical two-step MD estimator (see Newey and McFadden, 1994). Note that, despite under Assumption 4 it holds  $\mathcal{E}_{u,w} := \tilde{B}_{\bullet 2} \Lambda'$  (see Section 4), in (18) the investigator needs not take a stand on the restrictions that might characterize  $\Lambda$  and  $\tilde{B}_{\bullet 2}$ .

The next proposition establishes the necessary and sufficient rank condition, as well as the necessary order condition for local identification of the proxy-SVAR identified by the proxies  $w_l$ .  $\mathcal{N}_{\alpha_0}$  denotes a neighborhood of  $\alpha_0$  in  $\mathcal{P}_{\alpha}$ , with  $\alpha_0$  true value of the structural parameters in the matrix  $A_1$ , and  $D_k^+$  the generalized Moore–Penrose inverse of the duplication matrix  $D_k$ , see Supplement, Section S.2.

<span id="page-5-7"></span>**Proposition 1** (Point-Identification). Consider the proxy-SVAR obtained by combining the SVAR (3) with the proxies  $w_t$  in (10) for the  $s \le n-k$  non-target structural shocks  $\tilde{\varepsilon}_{2,t}$ . Assume that the parameters in  $A_1$ , satisfy the  $m := \frac{1}{2}k(k+1) + ks$  independent moment conditions (14) and (15) and, for k > 1, are restricted as in (16). Under Assumptions 1–4 and sequences of models in which  $E(w_t \tilde{\varepsilon}'_{1,t}) = A_T \to A$ :

(i) a necessary and sufficient condition for identification is that

<span id="page-5-8"></span>
$$rank\left[G_{a}(\sigma^{+},\alpha)\right] = a \tag{19}$$

<sup>&</sup>lt;sup>6</sup> See Section S.5 in the Supplement for cases where additional point-restrictions are placed on the parameters in  $B_{\bullet 1}$ .

<sup>&</sup>lt;sup>7</sup> Gains in efficiency can be achieved if these matrices are subject to constraints that are explicitly imposed in the minimization problem (18) via the matrix  $\Sigma_{u,w}$ . For instance, if  $\Lambda$  is known to be diagonal (meaning that each proxy variable in  $w_t$  solely instruments one structural shock in  $\bar{\varepsilon}_{2,t}$ ), one can use a constrained estimator of the covariance matrix  $\Sigma_{u,w}$  in (18). This can be done by using  $\hat{\Sigma}_{u,w} := \hat{B}'_{*2}\hat{\Lambda}$ , where  $\hat{\Lambda}$  and  $\hat{B}_{*2}$  are obtained in a previous step through the CMD approach we discuss in Section 6.1.

holds in  $\mathcal{N}_{\alpha o}$ , where  $a = dim(\alpha)$  and

$$G_{\alpha}(\sigma^+,\alpha) := \begin{pmatrix} 2D_k^+(A_{1\bullet}\Sigma_u \otimes I_k) \\ (\Lambda \tilde{B}_{2\bullet} \otimes I_k) \end{pmatrix} S_{A_1};$$

(ii) a necessary order condition is  $a \le m$ ; when k > 1, this implies at least  $\frac{1}{2}k(k-1)$  additional restrictions on the proxy-SVAR parameters.

As it is typical for SVARs and proxy-SVARs, the identification result in Proposition 1 holds 'up to sign', meaning that the rank condition in (19) is valid regardless of the sign normalizations of the rows of the matrix  $A_1$ . The necessary order condition,  $a \le m$ , simply states that when s shocks are instrumented, the number of moment conditions used to estimate the proxy-SVAR must be larger or at least equal to the total number of unknown structural parameters. It is not strictly necessary that s = n - k, meaning that identification can be achieved also by instrumenting part of the non-target shocks, provided there are enough uncontroversial restrictions on  $A_1$ , through (16).

An important consequence of Proposition 1 is stated in the next corollary, which establishes that the necessary and sufficient rank condition for the identification of the proxy-SVAR fails when the proxies are weak in the sense of (12).

<span id="page-6-2"></span>**Corollary 1** (Identification Failure). Under the assumptions of *Proposition 1*, the necessary and sufficient rank condition for identification in (19) fails if the proxies satisfy (12).

The next proposition summarizes the asymptotic properties of the MD estimator  $\hat{a}_T$  derived from (18) under local identification.

<span id="page-6-1"></span>**Proposition 2** (Asymptotic Properties). Under the conditions of Proposition 1, let the true value  $\alpha_0$  be an interior of  $\mathcal{P}_{\alpha}$  (assumed compact). If the necessary and sufficient rank condition in (19) is satisfied, then  $\hat{\alpha}_T$  in (18) has the following properties:

(i) 
$$\hat{\alpha}_T \stackrel{P}{\rightarrow} \alpha_0$$

(i) 
$$T^{1/2}(\hat{\alpha}_T \to \alpha_0)$$
,  
(ii)  $T^{1/2}(\hat{\alpha}_T - \alpha_0) \xrightarrow{d} N(0_{a \times 1}, V_a)$ ,  $V_\alpha := \{G_\alpha(\sigma_0^+, \alpha_0)'V_{gg}(\bar{\alpha})^{-1}G_\alpha(\sigma_0^+, \alpha_0)\}^{-1}$  with  $V_{gg}(\alpha) := G_{\sigma^+}(\sigma_0^+, \alpha)V_{\sigma^+}G_{\sigma^+}(\sigma_0^+, \alpha)'$  and  $G_\alpha(\sigma^+, \alpha)$  as in Proposition 1.

Proposition 2 ensures that the MD estimator  $\hat{a}_T$  is consistent and asymptotically Gaussian if the rank condition holds. Inference on the IRFs (5) can be based on standard asymptotic methods by classical delta-method arguments. Conversely, by Corollary 1, consistency and asymptotic normality is not guaranteed to hold if the instruments satisfy the local-to-zero embedding (12). The rank of the Jacobian matrix  $G_{\alpha}(\sigma^+, \alpha)$  in Proposition 1 depends on the covariance matrix  $\Sigma_{w,u} = \Lambda \tilde{B}'_{*2}$ , which in turn reflects the strength of the proxies  $w_t$ . The pre-test of relevance discussed in Section 6 is based on an estimator of the parameters in  $\Lambda$  and  $\tilde{B}_{*2}$ .

<span id="page-6-3"></span>We end this section by noticing that our indirect-MD method presents several differences with respect to Caldara and Kamps's (2017) approach to proxy-SVARs. Caldara and Kamps (2017) interpret the structural equations of their fiscal proxy-SVAR, the analog of system (13), as fiscal reaction functions whose unsystematic components correspond to the fiscal shocks of interest. They then identify the implied fiscal multipliers by a Bayesian penalty function approach. We differ from Caldara and Kamps (2017) in the motivations behind our analysis, as well as in the frequentist nature of our approach. Caldara and Kamps's (2017) main objective is the estimation of fiscal multipliers from policy (fiscal) reaction functions using external instruments. In contrast, our primary purpose is to rationalize a strategy intended to circumvent, when possible, the use of weak-instrument robust methods. Finally, as our empirical applications in Section 7 illustrate, our approach is not confined or limited to cases where the estimated structural equations read as policy reaction functions.

#### 6. Testing instrument relevance

<span id="page-6-0"></span>In this section we present our pre-test for relevance of the proxies. Our test exploits the different asymptotic properties of a bootstrap estimator of proxy-SVAR parameters under the regularity conditions in Proposition 2 – which imply that the strong proxy condition (11) is verified – and under the weak IV sequences of Staiger and Stock (1997) in (12). The test works for general  $\alpha$ -mixing VAR disturbances and/or zero-censored proxies, and is computationally invariant to the number of shocks being instrumented. Importantly, the outcomes of the test do not affect post-test inferences because of an asymptotic independence result between bootstrap and non-bootstrap statistics that we summarize in Proposition 7 below. This implies that the asymptotic coverage of IRFs confidence intervals constructed using our indirect approach remains unaffected if the bootstrap pre-test does not reject the null hypothesis of relevance of the proxies  $w_t$ . Similarly, the asymptotic coverage is not affected even if the bootstrap pre-test does reject the relevance of  $w_t$  and weak-instrument robust methods (using either the proxies  $z_t$ , or the proxies  $w_t$ ) are employed.

We organize this section as follows. In Section 6.1 we discuss the bootstrap estimator used to capture the strength of the proxies and then derive its asymptotic distribution. In Section 6.2 we explain the mechanics of the test. In Section 6.3 we summarize its finite sample performance through simulation experiments. Finally, Section 6.4 focuses on its key properties.

<sup>&</sup>lt;sup>8</sup> See Section S.6 in the Supplement for a comparison between the suggested MD approach and the 'standard' IV approach.

#### 6.1. Bootstrap estimator and asymptotic distribution

<span id="page-7-0"></span>As noticed in Section 5, the covariance matrix  $\Sigma_{w,u}:=E(w_tu_t')=\Lambda \tilde{B}_{2}'$  is a key ingredient of the Jacobian  $G_{\alpha}(\sigma^+,\alpha)$ , which determines the asymptotic properties of the MD estimator  $\hat{\alpha}_T$ ; see Propositions 1 and 2. In this section, we analyze a bootstrap estimator of the parameters in  $\Lambda$  and  $\tilde{B}_{2}'$ ; the asymptotic distribution of this estimator will subsequently serve as a measure of the strength of the proxies  $w_t$ .

Let  $\Omega_w$  be the  $s \times s$  matrix defined by  $\Omega_w := \Sigma_{w,u} \Sigma_u^{-1} \Sigma_{u,w}$ . By combining  $\Sigma_{w,u} = \Lambda \tilde{B}'_{\bullet 2}$  with the 'standard' SVAR covariance restrictions,  $\Sigma_u = BB'$ , by simple algebra we obtain the relation  $\Omega_w = \Lambda \tilde{B}'_{\bullet 2} (BB')^{-1} \tilde{B}'_{\bullet 2} \Lambda' = \Lambda \Lambda'$ . Hence, the link between the reduced form parameters in  $\Omega_w$ ,  $\Sigma_{w,u}$  and the proxy-SVAR parameters in the  $(n+s) \times s$  matrix  $(\tilde{B}'_{\bullet 2}, \Lambda')'$  is summarized by the following set of moment conditions

<span id="page-7-1"></span>
$$\Omega_{w} = \Lambda \Lambda', \ \Sigma_{wu} = \Lambda \tilde{B}'_{2} \tag{20}$$

which capture the connection between the proxies  $w_t$  and the non-target shocks  $\tilde{\epsilon}_{2,t}$ . We denote by  $\theta := (\beta_2', \lambda')'$  the  $q_\theta \times 1$  vector containing the (free) parameters in the matrix  $(\tilde{B}_{2}', \Lambda')'$ ; here,  $\beta_2$  collects the non-zero on-impact coefficients in  $\tilde{B}_{2}$  and  $\lambda$  the non-zero elements in  $\Lambda$ . While the parameters in  $\theta$  are not economically interesting on their own, the asymptotic distribution of the estimator of  $\theta$  is informative on the strength of the proxies  $w_t$ .

The moment conditions (20) can be summarized by the distance function  $d(\mu,\theta) := \mu - f(\theta)$ , with  $\mu := (vech(\Omega_w)', vec(\Sigma_{w,\mu})')'$  and  $f(\theta) = (vech(\Lambda\Lambda')', vec(\Lambda \bar{B}'_{12})')'$ . At the true parameter values,  $d(\mu_0,\theta_0) = 0$ . In order to estimate  $\theta$  through a MD approach, one needs an estimator of the reduced form parameters  $\mu$ . This is given by  $\hat{\mu}_T := (vech(\hat{\Omega}_w)', vec(\hat{\Sigma}_{w,\mu})')'$ , where  $\hat{\Omega}_w := \hat{\Sigma}_{u,w} \hat{\Sigma}_{u}^{-1} \hat{\Sigma}_{u,w}$ ,  $\hat{\Sigma}_{u,w} := T^{-1} \sum_{l=1}^T \hat{u}_l w_l'$  and  $\hat{\Sigma}_u := T^{-1} \sum_{l=1}^T \hat{u}_l \hat{u}_l'$ . When the proxy-SVAR is identified as in Proposition 1,  $T^{1/2}(\hat{u}_T - \mu_0)$  is asymptotically Gaussian with positive definite asymptotic covariance matrix  $V_\mu := J_{\sigma^+} V_{\sigma^+} J_{\sigma^+}'$ ,  $J_{\sigma^+}$  being the full-row rank Jacobian matrix  $J_{\sigma^+} := \frac{\partial \mu}{\partial \sigma^{+1}}$ , see Lemma S.2 in the Supplement, and  $\hat{V}_\mu := \hat{J}_{\sigma^+} \hat{V}_{\sigma^+} \hat{J}_{\sigma^+}'$  is a consistent estimator of  $V_\mu$ . Conversely, by Lemma S.3 in the Supplement,  $T^{1/2}(\hat{\mu}_T - \mu_0)$  is not asymptotically Gaussian when the proxies  $w_l$  satisfy the local-to-zero condition (12). Then, a classical MD (CMD) estimator of  $\theta$  can defined as

<span id="page-7-7"></span><span id="page-7-3"></span><span id="page-7-2"></span>
$$\hat{\theta}_T := \arg\min_{\theta \in \mathcal{D}_a} \hat{Q}_T(\theta), \quad \hat{Q}_T(\theta) := d_T(\hat{\mu}_T, \theta)' \hat{V}_{\mu}^{-1} d_T(\hat{\mu}_T, \theta)$$
(21)

where  $d_T(\cdot,\cdot)$  denotes the function  $d(\cdot,\cdot)$  once  $\mu$  is replaced with  $\hat{\mu}_T$ , and  $\mathcal{P}_{\theta}$  is the parameter space. Lemma S.4 in the Supplement shows that under the conditions of Proposition 1,  $T^{1/2}(\hat{\theta}_T-\theta_0)\overset{d}{\to}N(0,V_{\theta})$ , where  $\theta_0:=(\beta'_{2,0},\lambda'_0)'$  is the true value of  $\theta$ ,  $J_{\theta}$  is the full-column rank Jacobian matrix  $J_{\theta}:=\frac{\partial f(\theta)}{\partial \theta'}$ , and  $V_{\theta}:=(J'_{\theta}V_{\mu}^{-1}J_{\theta})^{-1}$ . Hence,  $\Gamma_T:=T^{1/2}V_{\theta}^{-1/2}(\hat{\theta}_T-\theta_0)$  is asymptotically standard normal, and  $\hat{V}_{\theta}:=(J'_{\theta}\hat{V}_{\mu}^{-1}\hat{J}_{\theta})^{-1}$  is a consistent estimator of  $V_{\theta}$ , where  $\hat{J}_{\theta}$  is the analog of  $J_{\theta}$  with  $\theta$  replaced by  $\hat{\theta}_T$ . In contrast, Lemma S.5 shows that, asymptotically,  $\Gamma_T$  is non-Gaussian when the instruments satisfy the local-to-zero embedding in (12); its asymptotic distribution is explicitly derived in the proof of Lemma S.5.

The bootstrap counterpart of  $\hat{\theta}_T$  (henceforth, MBB-CMD), given by

<span id="page-7-8"></span><span id="page-7-5"></span>
$$\hat{\theta}_T^* := \arg\min_{\theta \in \mathcal{P}_a} \hat{Q}_T^*(\theta) , \ \hat{Q}_T^*(\theta) := d(\hat{\mu}_T^*, \theta)' \hat{V}_\mu^{-1} d(\hat{\mu}_T^*, \theta)$$
 (22)

where  $\hat{\mu}_T^* := (vech(\hat{\Omega}_w^*)', vec(\hat{\Sigma}_{w,u}^*)')'$  is the bootstrap analog of  $\hat{\mu}_T$ , is also affected by the strength of the proxies. Specifically, Proposition 3 below shows that when the proxies are strong in the sense of condition (11), the asymptotic distribution of  $\Gamma_T^* := T^{1/2}\hat{V}_{\theta}^{-1/2}(\hat{\theta}_T^* - \hat{\theta}_T)$ , conditional on the data, is asymptotically Gaussian. This result is consistent with Theorem 4.1 in Jentsch and Lunsford (2022) on MBB consistency in proxy-SVARs. In contrast, we show in Proposition 4 that under the weak proxies embedding (12), the limiting distribution of  $\Gamma_T^*$ , conditional on the data, is random and non-Gaussian (see equations (S.26) and (S.29) in the Supplement; see also Cavaliere and Georgiev (2020), for details on weak convergence in distribution).

<span id="page-7-4"></span>**Proposition 3** (Bootstrap Asymptotic Distribution, Strong Proxies). Consider the CMD estimator  $\hat{\theta}_T$  obtained from (21) and its MBB counterpart  $\hat{\theta}_T^*$  derived from (22). Under the conditions of Proposition 1, if the necessary and sufficient rank condition for identification in (19) is satisfied,  $\Gamma_T^* := T^{1/2} \hat{V}_{\theta}^{-1/2} (\hat{\theta}_T^* - \hat{\theta}_T) \xrightarrow{d^*} N(0_{q_{\theta} \times 1}, I_{q_{\theta}})$ .

<span id="page-7-9"></span><span id="page-7-6"></span>**Proposition 4** (Bootstrap Asymptotic Distribution, Weak Proxies). Consider the CMD estimator  $\hat{\theta}_T$  obtained from (21) and its MBB counterpart  $\hat{\theta}_T^*$  derived from (22). Under the conditions of Proposition 1, if the proxies  $w_t$  satisfy the local-to-zero condition (12),  $\Gamma_T^* := T^{1/2} \hat{V}_{\theta}^{-1/2} (\hat{\theta}_T^* - \hat{\theta}_T)$  converges weakly in distribution to a non-Gaussian limit.

<sup>&</sup>lt;sup>9</sup> In the 'sandwich' expression  $\hat{V}_{\mu} := \hat{J}_{\sigma^+} \hat{V}_{\sigma^+} \hat{J}'_{\sigma^+}$ ,  $\hat{V}_{\sigma^+}$  is a consistent estimator of  $V_{\sigma^+}$ , see Supplement, Section S.3, and  $\hat{J}_{\sigma^+}$  is obtained from the expression of  $J_{\sigma^+}$  in Lemma S.2 by replacing  $\Sigma_{u,u}$  and  $\Sigma_u^{-1}$  with the estimators  $\hat{\Sigma}_{u,w}$  and  $\hat{\Sigma}_u^{-1}$ , respectively.

<sup>&</sup>lt;sup>10</sup> For s > 1, the estimation problem (21) requires that at least (1/2)s(s-1) restrictions are placed on  $\tilde{B}'_{2}$  and/or on  $\Lambda$ ; see Proposition 1 in Angelini and Fanelli (2019) and the proof of Lemma S.4 in the Supplement.

<sup>&</sup>lt;sup>11</sup> As remarked in the Supplement, see Sections S.3 and S.7, the asymptotic validity of the MBB requires that  $\ell^3/T \to 0$ , where  $\ell$  is the block length parameter behind resampling, see Jentsch and Lunsford (2019, 2022). It is maintained that this condition holds in Proposition 3 as well as in all cases in which the MBB is involved. In the Monte Carlo experiments considered in Section 6.3 and in the empirical illustrations considered in Section 7 and Section S.9,  $\ell$  is chosen as in Jentsch and Lunsford (2019) and Mertens and Ravn (2019).

<sup>12</sup> As is standard, with  $X_T \stackrel{d^+}{\to}_p X$  we denote convergence of  $X_T^*$  in conditional distribution to X, in probability, as defined in the Supplement, Section S.2.

The different asymptotic behaviors of  $\Gamma_T^*$  highlighted in Propositions 3 and 4 and, in particular, the distance of the cdf of  $\Gamma_T^*$  from the Gaussian cdf, are the key ingredients of our bootstrap test of instrument relevance, 13 which we consider next.

## 6.2. Bootstrap test

<span id="page-8-0"></span>Our measure of strength is based on the cdf, conditional on the data, of the bootstrap statistic  $\hat{\Gamma}_T^* := T^{1/2} \hat{V}_{\theta}^{-1/2} (\hat{\theta}_T^* - \hat{\theta}_T)$ . For simplicity and without loss of generality, we consider one component of the vector  $\hat{\Gamma}_T^*$ , say its first element,  $\hat{\Gamma}_{1,T}^*$ ; its cdf, conditional on the data, is denoted by  $F_T^*(\cdot)$ .

By Proposition 3, if the proxies satisfy condition (11),  $\hat{\Gamma}_{1,T}^*$  converges to a standard normal random variable; hence,  $_{F_T}^*(x) - _{F_G}(x) \rightarrow_p 0$  uniformly in  $x \in \mathbb{R}$  as  $T \rightarrow \infty$ , where  $_{F_G}(\cdot)$  denotes the N(0,1) cdf. Our approach simply consists in evaluating, for large T, how 'close or distant'  $_{F_T}^*(x)$  is from  $_{F_G}(x)$ . To do so, consider a set of N i.i.d. (conditionally on the original data) bootstrap replications, say  $\hat{\Gamma}_{1,T:1}^*$ , ...,  $\hat{\Gamma}_{1,T:N}^*$ , and the corresponding estimator of  $_{F_T}^*(x)$ , given by

<span id="page-8-1"></span>
$$F_{T,N}^{*}(x) := \frac{1}{N} \sum_{b=1}^{N} \mathbb{I}(\hat{\Gamma}_{1,T:b}^{*} \le x), x \in \mathbb{R}.$$
 (23)

For any x, deviation of  $F_{T,N}^*(x)$  from the standard normal distribution can be evaluated by considering the distance  $|F_{T,N}^*(x) - F_{\mathcal{G}}(x)|$ . By standard arguments, and regardless of the strength of the proxies, as  $N \to \infty$  (keeping T fixed)

$$N^{1/2}(\rho_{T,N}^*(x) - \rho_{T}^*(x)) \xrightarrow{d^*} N(0, U_T(x))$$
(24)

where  $U_T(x) := F_T^*(x)(1 - F_T^*(x))$ . This suggests that, with  $\hat{U}_T(x)$  a consistent estimator of  $U_T(x)$ , <sup>14</sup> we may consider the normalized statistic:

<span id="page-8-7"></span><span id="page-8-2"></span>
$$\tau_{T,N}^*(x) := N^{1/2} \hat{U}_T(x)^{-1/2} (F_{T,N}^*(x) - F_G(x)). \tag{25}$$

The next two propositions establish the limit behavior of  $\tau_{T,N}^*(x)$  in the two scenarios of interest: under the conditions of Proposition 3, where the proxy-SVAR is identified and strong proxy asymptotics holds, and under the conditions of Proposition 4, where weak proxy asymptotics à la Staiger and Stock (1997) holds.
