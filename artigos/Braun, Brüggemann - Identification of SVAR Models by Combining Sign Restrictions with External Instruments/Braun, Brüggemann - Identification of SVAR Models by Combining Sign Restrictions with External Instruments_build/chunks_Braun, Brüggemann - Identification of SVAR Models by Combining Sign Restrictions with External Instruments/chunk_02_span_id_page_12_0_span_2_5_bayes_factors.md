## <span id="page-12-0"></span>2.5 Bayes factors

When combining sign- and IV restrictions, it can be useful to have a statistical tool to check overidentifying restrictions against the data. Therefore, we discuss using Bayes factors as a means to quantify the statistical support of a given overidentifying restriction.<sup>8</sup>

Consider the availability of two models  $M_1$  and  $M_0$ , where  $M_0$  is the more restrictive model subject to overidentifying constraints. Then, we define the Bayes factor as  $\mathrm{BF}_{10} = p(\tilde{Y}|M_1)/p(\tilde{Y}|M_0)$ , where  $p(\tilde{Y}|M_1)$  and  $p(\tilde{Y}|M_0)$  are the probabilities that the data  $\tilde{Y}$  has been generated according to models  $M_1$  and  $M_0$ , respectively. Under equal prior probability of  $M_1$  and  $M_0$ , the Bayes factor has the natural interpretation of posterior odds of  $M_1$  over  $M_0$ .

When conducting tests of overidentifying restrictions based on a combination of signand IV restrictions, the first step is to define which restrictions are assumed to be more credible to begin with.<sup>9</sup> This yields two possible scenarios. In the first, a researcher is convinced of the validity of his external instrument  $(M_1)$  and would like to test additional sign restrictions as overidentifying  $(M_0)$ . For example, in Section 3.1, we identify an oil

<span id="page-12-1"></span><sup>&</sup>lt;sup>7</sup>For an application with such an identification strategy, see Appendix F which revisits our first empirical analysis using the oil market model of Baumeister & Hamilton (2019).

<span id="page-12-3"></span><span id="page-12-2"></span><sup>&</sup>lt;sup>8</sup>As a tool to test identifying restrictions, Bayes factors have been used increasingly in SVARs, see e.g. Woźniak & Droumaguet (2015), Lütkepohl & Woźniak (2020), Lanne & Luoto (2020) and Nguyen (2019).

<sup>9</sup>We thank an anonymous referee for pointing out this important distinction.

market model via a combination of impact sign restrictions and IV constraints  $(M_1)$ . In a second step, we test different types of elasticity restrictions as overidentifying  $(M_0)$ .

In the second scenario, a researcher starts the analysis with a set of sign restrictions  $(M_1)$  and would like to test if certain additional IV restrictions are supported by the data  $(M_0)$ . Here, one may consider both the exogeneity and relevance conditions. In our empirical application of Section 3.2, we demonstrate this case in testing the exogeneity of a narrative monetary policy measure  $(M_0)$  within a sign-restricted SVAR  $(M_1)$ .

#### Testing sign restrictions

We start by testing sign restrictions as overidentifying. In the following, we show how the Bayes factors can be computed in a straightforward way from prior and posterior draws of the less restrictive model. We assume that the prior of the overidentified model  $M_0$  can be factored as:

<span id="page-13-0"></span>
$$p(\theta|M_0) = \frac{p_0(\theta)p(\theta|M_1)}{\int p_0(\theta)p(\theta|M_1)d\theta} = \frac{p_0(\theta)p(\theta|M_1)}{c_\theta}.$$
 (2.10)

Therefore,  $p_0(\theta)$  represents any additional identifying information imposed on the top of those assumed by the less restrictive model  $M_1$ . For the overidentifying sign restrictions that we aim to test,  $p_0(\theta)$  simply takes the form of a uniform distribution over the restricted parameters space  $S \in \Theta$ , that is  $p_0(\theta) \propto \mathbf{1}(\theta \in S)$ . But we note that more generally,  $p_0(\theta)$  can also be a probability density function designed to provide additional identifying information via a priori weighting of structural parameters (Baumeister & Hamilton 2015).

For a prior of the form (2.10), the posterior can be factored in an equivalent way:

$$p(\theta|M_0, \tilde{Y}) \propto p_0(\theta)p(\theta|M_1)p(\tilde{Y}|\theta)$$
$$\propto p_0(\theta)p(\theta|M_1, \tilde{Y}),$$

such that

<span id="page-13-1"></span>
$$p(\theta|M_0, \tilde{Y}) = \frac{p_0(\theta)p(\theta|M_1, \tilde{Y})}{\int p_0(\theta)p(\theta|M_1, \tilde{Y})d\theta} = \frac{p_0(\theta)p(\theta|M_1, \tilde{Y})}{c_{\theta|\tilde{Y}}}$$
(2.11)

Under prior (2.10), the Bayes factor can be simplified considerably. First, note that using Bayes theorem and the fact that the models have the same parameters  $\theta$ , we find:

$$\frac{p(\tilde{Y}|M_1)}{p(\tilde{Y}|M_0)} = \frac{p(\tilde{Y}|\theta)p(\theta|M_1)/p(\theta|M_1,\tilde{Y})}{p(\tilde{Y}|\theta)p(\theta|M_0)/p(\theta|M_0,\tilde{Y})} = \frac{p(\theta|M_1)p(\theta|M_0,\tilde{Y})}{p(\theta|M_0)p(\theta|M_1,\tilde{Y})}.$$

Using expressions of equation (2.10) and (2.11) for prior and posterior of  $M_0$  respectively, the Bayes factor simplifies to:

$$BF_{10} = \frac{p(\theta|M_1)p(\theta|\tilde{Y}, M_0)}{p(\theta|M_0)p(\theta|\tilde{Y}, M_1)} = \frac{p(\theta|M_1)\left(p(\theta|M_1, \tilde{Y})p_2(\theta)c_{\theta|\tilde{Y}}^{-1}\right)}{\left(p(\theta|M_1)p_2(\theta)c_{\theta}^{-1}\right)p(\theta|\tilde{Y}, M_1)} = \frac{c_{\theta}}{c_{\theta|\tilde{Y}}}.$$

Furthermore,  $c_{\theta|\tilde{Y}}$  and  $c_{\theta}$  can be expressed as expectations of  $p_0(\theta)$  over prior and posterior

distribution of the less restricted model respectively:

<span id="page-14-1"></span>
$$BF_{10} = \frac{c_{\theta}}{c_{\theta|\tilde{Y}}} = \frac{\int p_0(\theta)p(\theta|M_1)d\theta}{\int p_0(\theta)p(\theta|M_1,\tilde{Y})d\theta} = \frac{E_{\theta}[p_0(\theta)]}{E_{\theta|\tilde{Y}}[p_0(\theta)]}.$$
 (2.12)

This representation makes it straightforward to estimate BF<sub>10</sub> using draws from the prior and posterior of the less restrictive model  $M_1$ . In particular, one may use the simulation consistent averages  $\widehat{\mathbb{E}}_{\theta|\tilde{Y}}[p_0(\theta)] = 1/J_1 \sum_{j=1}^{J_1} p_0(\theta^{(j)})$  for  $\theta^{(j)} \sim p(\theta|M_1,\tilde{Y})$  and  $\widehat{\mathbb{E}}_{\theta}[p_0(\theta)] = 1/J_2 \sum_{i=1}^{J_2} p_0(\theta^i)$  for  $\theta^{(i)} \sim p(\theta|M_1)$ . Standard errors of the Bayes factor estimate (or the log of it if preferred) can be easily obtained via the Batch Means method. This involves using  $J_b$  subsamples of the Monte Carlo output and defining  $\widehat{\mathrm{BF}}_{10} = J_b^{-1} \sum_{j=1}^{J_b} \mathrm{BF}_{10}^{(j)}$  for  $j = 1, \ldots, J_b$ . Then, a standard limit theorem implies that  $\sqrt{J_b}(\widehat{\mathrm{BF}}_{10} - \mathrm{BF}_{10}) \to \mathcal{N}(0, \mathrm{Var}(\widehat{\mathrm{BF}}_{10}))$ .

#### Testing instrumental variables restrictions

In the second case, the researcher departs from a set of sign restrictions and would like to test additional instrumental variable restrictions. Here, the less restrictive model is the sign-identified SVAR  $(M_1)$ , and the more restrictive model relies on sign restrictions plus the additional IV restrictions  $(M_0)$ . This approach is also considered in Nguyen (2019), however, based on a different modeling framework. More broadly, the idea of testing instrument validity has been explored by relying on heteroskedasticity instead of sign restrictions, and using frequentist rather than Bayesian inference (Bertsche & Braun 2020, Podstawski et al. 2018).

In the following, we show how Bayes factors can be used to assess instrument validity in our framework. As in Section 2.2, let  $\varepsilon_{2t}$  be the shocks to be identified by an IV approach and devide  $\Phi = [\phi_1 : \phi_2] = [E(m_t \varepsilon'_{1t}) : E(m_t \varepsilon'_{2t})]$ . Then, instrument irrelevance can be tested quantifying statistical evidence against  $\phi_2 = 0$ . Furthermore, if instrument exogeneity is of interest, the corresponding restriction to test are  $\phi_1 = 0$ . As we will demonstrate, Bayes factors for both instrument relevance and exogeneity can be computed in a straightforward way using Savage Dickey Density ratios (SDDR). Again, this only requires generating draws from the prior and posterior of the less restrictive model.

To fix notation define  $S_r$  as the  $n_r \times nk$  selection matrix of zeros and ones such that  $\phi_r = S_r \text{vec}(\Phi)$  are the restricted elements in  $M_0$ . Analogously, let  $S_f$  be the corresponding  $(nk-n_r)\times nk$  selection matrix for the unrestricted elements of  $\Phi$ , denoted as  $\phi_f = S_f \text{vec}(\Phi)$ . Split the parameter vector into  $\theta = \{\theta_{-\phi_r}, \phi_r\}$ , where  $\theta_{-\phi_r} = \{\alpha, B, \Sigma_{\eta}, \phi_f\}$  gathers all the unrestricted parameters. We assume that the prior of the less restrictive model,  $p_1(\theta_{-\phi_r}, \phi_r)$  is given as outlined in Section 2.4. For the restricted model  $M_0$ , it holds that  $\phi_r = \phi_{r,0}$ , and we assume the following prior distribution  $p_0(\theta_{-\phi_r})$ :

<span id="page-14-0"></span>
$$p_0(\theta_{-\phi_r}) = p_1(\theta_{-\phi_r}|\phi_r = \phi_{r,0}). \tag{2.13}$$

In words, the prior density of the restricted model is given by the prior of the unrestricted model conditional on the exclusion restrictions. As pointed out in Jarociński & Maćkowiak

(2017), this is a very natural approach to construct a prior for the restricted model. Specifically, any researcher that starts from a model with prior  $p_1(\theta_{-\phi_r}, \phi_r)$  and learns about the restriction  $\phi_r = \phi_{r,0}$ , ends up with equation (2.13) after applying Bayes theorem. Furthermore, the choice of prior  $p_0(\theta_{-\phi_r})$  facilitates computation of Bayes factors using the SDDR. As shown in Verdinelli & Wasserman (1995), for all priors that satisfies (2.13), the Bayes factor reduces to

<span id="page-15-0"></span>
$$BF_{10} = \frac{p(\phi_r = \phi_{r,0})}{p(\phi_r = \phi_{r,0}|\tilde{Y})},$$
(2.14)

where  $p(\phi_r = \phi_{r,0}|\tilde{Y})$  and  $p(\phi_r = \phi_{r,0})$  are the marginal posterior and prior densities for  $\phi_r$  in the unrestricted model, evaluated at  $\phi_{r,0}$ . While neither of the two densities are available in closed form, we can make use of the analytical results derived in Section 2.4 and compute them using simulation output of the unrestricted model. Specifically, a simulation consistent estimator is given by:

$$\widehat{BF}_{10} = \frac{J_1^{-1} \sum_{i=1}^{J_1} p(\phi_r = \phi_{r,0} | \theta_{-\phi_r}^{(i)})}{J_2^{-1} \sum_{j=1}^{J_2} p(\phi_r = \phi_{r,0} | \tilde{Y}, \theta_{-\phi_r}^{(j)})},$$

where  $\theta_{-\phi_r}^{(i)}$  and  $\theta_{-\phi_r}^{(j)}$  are prior and posterior draws of the unrestricted model respectively. Obtaining  $p(\phi_r = \phi_{r,0}|\theta_{-\phi_r})$  is straightforward given conditional normality of  $\Phi$ , that is  $p(\Phi|\theta_{-\Phi}) \sim \mathcal{M}\mathcal{N}(S_{21}S_{11}^{-1}B, \Sigma_{\eta}, B'S_{11}^{-1}B)$ . The only missing ingredient is to further include  $\phi_f$  into the conditioning set. Let  $\phi = \text{vec}(\Phi)$  as well as  $\mu_{\phi} = \text{vec}(S_{21}S_{11}^{-1}B)$  and  $V_{\phi} = (B'S_{11}^{-1}B \otimes \Sigma_{\eta})$  the moments of  $p(\phi|\theta_{-\phi}) \sim \mathcal{N}(\mu_{\phi}, V_{\phi})$ . Exploiting standard results on joint normality between  $\phi_f$  and  $\phi_r$  we obtain  $p(\phi_r = \phi_{r,0}|\theta_{-\phi_r}) \sim \mathcal{N}(\mu_{\phi_r}, V_{\phi_r})$  where

$$\mu_{\phi_r} = S_r \mu_{\phi} + \left( S_r V_{\phi} S_f' \right) \left( S_f V_{\phi} S_f' \right)^{-1} \left( \phi_f - S_f \mu_{\phi} \right),$$

$$V_{\phi_r} = S_r V_{\phi} S_r' - \left( S_r V_{\phi} S_f' \right) \left( S_f V_{\phi} S_f' \right)^{-1} \left( S_f V_{\phi} S_r' \right).$$

The posterior ordinate  $p(\phi_r = \phi_{r,0}|\theta_{-\phi_r}, \tilde{Y})$  can be obtained following similar steps but departing from the conditional posterior of  $\Phi$ :  $p(\Phi|\theta_{-\Phi}, \tilde{Y}) \sim \mathcal{MN}(\bar{S}_{21}\bar{S}_{11}^{-1}B, \Sigma_{\eta}, B'\bar{S}_{11}^{-1}B)$ . Note that in this case  $\bar{S} = S_0 + (\tilde{Y} - X\tilde{A})(\tilde{Y} - X\tilde{A})'$ , which follows from the conjugacy of the prior. Alternatively, and maybe more intuitively, one can write the posterior as the result of a standard regression formulation. Specifically, define  $M = [m_1 : \ldots : m_T], E = [\varepsilon_1 : \ldots : \varepsilon_T], H = [\eta_1 : \ldots : \eta_T], \mu_{\Phi} = S_{21}S_{11}^{-1}B$  and  $V_{\Phi} = B'S_{11}^{-1}B$ . Then, our framework implies the regression model  $M = \Phi E + \Sigma_{\eta}^{1/2}H$ . One can show that the posterior moments of  $p(\Phi|\theta_{-\Phi}, \tilde{Y})$  can be expressed as  $\bar{S}_{21}\bar{S}_{11}^{-1}B = (ME' + \mu_{\Phi}V_{\Phi}^{-1})(EE' + V_{\Phi}^{-1})^{-1}$  and  $B'\bar{S}_{11}^{-1}B = (EE' + V_{\Phi}^{-1})^{-1}$ , which are standard posteriors for multivariate regression under a conjugate prior. This representation helps to understand the mechanics of the Bayes factors when testing IV restrictions. Assume the posterior of the sign-identified model implies structural shocks for which not only the shock(s) of interest  $\varepsilon_{2t}$  are able to predict  $m_t$ . Then, the posterior ordinate will get smaller and ultimately, the Bayes factor larger pointing towards evidence against instrument exogeneity. A similar line of argument also holds for testing instrument relevance.

When testing exogeneity restrictions using the methodology described in this section, an important question is if the result depends on identifying restrictions imposed on the n−k shocks that are unrelated to the instrument under the null hypothesis. In other words, would the density change if we further rotate the columns in B˜ with an orthogonal matrix which leaves ϕ<sup>f</sup> unaffected but rotates ϕr? It turns out that for the special case that we are interested in testing, that is ϕr,<sup>0</sup> = 0, the density is unaffected by such rotations which is comforting news for models that are only partially identified. The intuition behind this result is that zero restrictions assessed under the null hypothesis (ϕr,<sup>0</sup> = 0) remain unchanged, if postmultiplied by a rotation matrix. For a formal derivation of this result, see Appendix [C.](#page-36-0)

#### The role of the prior

From equations [\(2.12\)](#page-14-1) and [\(2.14\)](#page-15-0), it becomes clear that Bayes factors depend strongly on the prior distribution. Moreover, in set-identified models, also the posterior remains influenced by the prior, even in large samples. The reason is that the data is not informative about some quantities of the parameter space [\(Poirier 1998\)](#page-30-9). Therefore, the choice of prior needs to be explicitly defended.

One way to go about this has been proposed in [Baumeister & Hamilton \(2015\)](#page-26-4), who suggest to acknowledge this shortcoming and argue for spelling out informative prior distributions for sign and magnitude of underlying structural parameters of A = B<sup>−</sup><sup>1</sup> . We think that such an approach is useful, in case such prior information is available. However, for larger or partially identified models, it can get very difficult to formulate such prior beliefs.

In contrast, the prior considered in this paper requires just minimal inputs from the researcher and therefore is particularly easy to choose. First, it requires setting two hyperparameters v<sup>0</sup> and S<sup>0</sup> which carry the same interpretation as prior degrees of freedom and scale matrix of an inverse Wishart prior. The second ingredient are the sign and exclusion constraints considered in Sections [2.2](#page-6-3) and [2.3.](#page-7-1) In the spirit of [Arias et al. \(2018\)](#page-26-0), our prior then assumes that for a given correlation structure (summarized in v<sup>0</sup> and S0), all B-models (or A-models if preferred) satisfying the identifying restrictions are equally likely a priori. In our view, this is a sensible prior to work with when no further information is available to discriminate among SVAR models that satisfy the restrictions. However, note that being uniform on the set of B- or A-models does not necessarily mean that the prior is uninformative about other structural parameters [\(Baumeister & Hamilton 2015,](#page-26-4) [Inoue](#page-28-6) [& Kilian 2020\)](#page-28-6).

In Appendix [D,](#page-38-0) we conduct two small scale simulation exercises to illustrate that Bayes factors based on the conjugate prior are well suited for providing a statistical signal if signand IV restrictions are at odds with each other. Furthermore, our simulations suggest that fairly automatic specification for the prior parameters v<sup>0</sup> and S<sup>0</sup> based on training samples works well. Finally, making reference to [Kass & Raftery \(1995\)](#page-28-7), we give a short guide on how applied researchers typically interpret the magnitudes of Bayes factors in Appendix [E.](#page-41-1)

## <span id="page-17-0"></span>3 Empirical applications

We demonstrate the usefulness of our methodology in two empirical applications. In Section [3.1,](#page-17-1) we use a combination of sign- and IV restrictions to disentangle supply from demand shocks as drivers of oil prices. In Section [3.2,](#page-21-0) we analyze the effects of monetary policy shocks on economic and financial variables by making use of identifying information from a 'plausibly exogenous' instrument in combination with conventional sign restrictions.

## <span id="page-17-1"></span>3.1 The importance of oil supply shocks for driving oil prices

Since [Kilian \(2009\)](#page-28-8) there has been increasing interest in disentangling oil price movements into supply and demand components (see e.g. [Kilian & Murphy \(2012,](#page-28-9) [2014\)](#page-28-10), [Baumeister &](#page-26-8) [Hamilton \(2019\)](#page-26-8), [Caldara et al. \(2019\)](#page-27-11), [Zhou \(2020\)](#page-30-10), [K¨anzig \(2021\)](#page-28-1), [Cross et al. \(2020\)](#page-27-12)). Despite the large set of papers, estimates of the relative importance of oil supply and demand shocks as drivers of oil prices still vary widely.

A large share of the disagreement across the literature can be attributed to differences in identification. Models identified with a tight upper bound on the elasticity of supply find supply shocks to be unimportant drivers of oil prices. On the other hand, if a less restrictive formulation is used that incorporates uncertainty about the identifying assumptions themselves, supply shocks turn out to be considerably more important.

We use the methods developed in this paper to revisit the evidence and contribute to the debate by introducing additional identifying information into the workhorse oil market model. Specifically, on the top of sign restrictions, we exploit the OPEC production shortfall series of [Kilian \(2008\)](#page-28-11) (K08 henceforth) as an external instrument for the SVAR supply shock. Since we do not use the IV as single identification device for the supply shock, we can be less concerned about potential weak identification that arises from using the K08 shock as instrument (see e.g. [Montiel Olea et al. \(2021\)](#page-29-1)). Our findings suggest that once we incorporate the additional IV restrictions, the exact prior formulation for the elasticity of supply becomes less important for estimates of the importance of oil supply as driver of oil prices. Point estimates of forecast error variance contributions settle around 10%.

We identify the shocks of interest within a standard four equation VAR(13) following recent specifications for the global oil market. We use y<sup>t</sup> = (prod<sup>t</sup> ,rea<sup>t</sup> ,rpo<sup>t</sup> , it) ′ , where prod<sup>t</sup> is the log of world oil production and rea<sup>t</sup> is a measure for world economic activity, where we choose the industrial production index of [Baumeister & Hamilton \(2019\)](#page-26-8) (BH19 henceforth). Furthermore, rpo<sup>t</sup> is the real price of oil and i<sup>t</sup> are the seasonally adjusted log of OECD crude oil inventories. For our analysis, we have recomputed Kilian's monthly oil supply shock series from oil production data and extended it to match our estimation sample.[10](#page-17-2) Our sample includes monthly data from 1978M08 to 2018M11, given that pre-1978 the K08 shock displays very little variation. We use the first five years of the data to train a hands-off prior distribution setting v<sup>0</sup> and S<sup>0</sup> as to match, for each variable in the

<span id="page-17-2"></span><sup>10</sup>The extended series includes shocks related to the Libyan civil war and militia attacks during 2011 and 2013. We give a detailed description on how we have constructed the time series and a plot in Appendix [F.](#page-41-0)

VAR, the empirical covariance between AR(2) forecast errors and the K08 shock over the training sample (1978M10 to 1983M09). With respect to the autoregressive coefficients we use the independent Minnesota prior centered around univariate random walks as in Koop et al. (2010).

We follow Kilian & Murphy (2014), KM14, in identifying three out of the four shocks in the model. This includes an oil supply shock denoted as  $\varepsilon_t^s$ , a flow demand shock  $\varepsilon_t^{fd}$  and an inventory (speculative) demand shock  $\varepsilon_t^{id}$ . The fourth shock,  $\varepsilon_t^{od}$ , is not identified and meant to capture all other demand channels. Identification is achieved by (a combination of) the following restrictions and prior distributions.

1. R1: impact sign restrictions on B as in KM14:

$$\begin{pmatrix} u_t^{\Delta \text{prod}} \\ u_t^{\text{rea}} \\ u_t^{\text{po}} \\ u_t^{\Delta \text{i}} \end{pmatrix} = \begin{pmatrix} - & + & + & * \\ - & + & - & * \\ + & + & + & * \\ * & * & + & * \end{pmatrix} \begin{pmatrix} \varepsilon_t^s \\ \varepsilon_t^{fd} \\ \varepsilon_t^{id} \\ \varepsilon_t^{od} \end{pmatrix}.$$

- 2. R2: IV constraints relating the K08 series to the supply shocks:  $\mathrm{E}[\varepsilon_t^s m_t] \neq 0$ , while  $\mathrm{E}[\varepsilon_t^{fd} m_t] = \mathrm{E}[\varepsilon_t^{id} m_t] = \mathrm{E}[\varepsilon_t^{od} m_t] = 0$ .
- <span id="page-18-0"></span>3. R3: Let  $\eta_1 = B_{12}/B_{32}$  and  $\eta_2 = B_{13}/B_{33}$  be the supply elasticities as defined in KM14.
  - (a) R3-HR20:  $\eta_{1/2} \leq 0.04$ . Motivated by surveying microeconometric estimates, this restriction was suggested in Herrera & Rangaraju (2020) and allows for slightly larger values than the upper bound originally envisaged by KM14.
  - (b) R3-BH19:  $\eta_{1/2} \sim t_{0,\infty}(0.1, 0.2, 3)$ , a truncated t-density with mode at 0.1, scale parameter equal to 0.2 and 3 degrees of freedom. Note that BH19 suggest this prior for a (single parameter) supply elasticity in their A-model. For comparability with restriction 3a, we instead use it on  $\eta_{1/2}$ . Reflecting a substantial degree of uncertainty, this formulation is less restrictive than R3-HR20 and allows the possibility for larger values a priori.

The restrictions in R2 reflect the relevance and exogeneity restrictions of the instrumental variable approach. The two most prominent prior distributions used for the SVAR implied supply elasticity are summarized in R3. Here,  $B_{12}/B_{32}$  and  $B_{13}/B_{33}$  are thought as of oil supply elasticities, measuring the percentage increase of production in response to a one percentage increase in the real oil price, triggered by either of the two identified demand shocks.

We first study if the additional IV constraints are informative about either of the two supply elasticity prior distributions (R3). For this purpose, we identify the VAR using only the impact sign restrictions and IV constraints (R1+R2). In Panel A of Table 1, we display quantiles of the posterior distribution of the short-run supply elasticities obtained under such an identification strategy. 68% posterior credibility sets suggest that  $\eta_2$  is estimated fairly precisely with posterior median just near the upper bound suggested in HR20, and 84% quantiles just below 0.1. However, this is not the case for the elasticity of supply

<span id="page-19-0"></span>Table 1: Posterior distribution of supply elasticities and Bayes factors for overidentifying restrictions

| Panel A: Posterior under R1 and R2 |       |       |       |
|------------------------------------|-------|-------|-------|
| Parameter                          | 16%   | 50%   | 84%   |
| η1                                 | 0.031 | 0.115 | 0.370 |
| η2                                 | 0.008 | 0.032 | 0.096 |

Panel B: Bayes factors testing restrictions on η1/<sup>2</sup>

| Restrictions | Eθ Y˜<br>[p2(θ)] | Eθ[p2(θ)] | 2 lnBFc10 | s.e. |
|--------------|------------------|-----------|-----------|------|
| BH19         | 9.095            | 0.971     | −4.48     | 0.03 |
| HR20         | 0.109            | 0.002     | −8.21     | 0.40 |

Note: Bayes factors computed as described in Section [2.5.](#page-12-0) Here, the less restrictive model is identified using R1 and R2, while the more restrictive model additionally employs R3-HR20 or R3-BH19. In Panel B, we have for BH19, p2(θ) : η1/<sup>2</sup> ∼ t(0.1, 0.2, 3) while for HR20 p2(θ) : p(η1/<sup>2</sup> ≤ 0.04) = 1 and 0 else.

measured in response to a flow demand shock (η1). Here, the 68% posterior set includes values considered unreasonably large by parts of the literature. Hence, one might still have the desire to use additional identifying information for the supply elasticities, directly excluding larger values a priori (R3-HR20) or making those values less likely through a probability density function (R3-BH19). We use the Bayes factor proposed in Section [2.5](#page-12-0) to formally quantify the support of each approach within the model identified by R1+R2. The log-Bayes factors in Panel B of Table [1](#page-19-0) suggest that there is no evidence against using either prior as additional piece of identifying information (R3-H20 and R3-BH19).[11](#page-19-1) In fact, quite the opposite is observed. Since the likelihood of the restrictions is larger under the posterior than under the prior, we obtain negative values suggesting evidence in favor of using such information. In principle, we can also use these results to see which approach obtains a stronger support by the data. Redefining the Bayes factor as support of HR20 over BH19, we obtain 2 ln BF ≈ (−8.21)−(−4.48) = −3.73, suggesting some but not strong evidence in favor of HR20, according to the reference guidelines of [Kass & Raftery \(1995\)](#page-28-7). We conclude that Bayes factors suggest evidence for using additional prior information on elasticities, although the evidence is less strong about which of two is more suitable in practice.

Given that both elasticity priors are supported by Bayes factors, one might argue that we are back to the very same problem faced by the literature: depending on our choice of R3, we end up with different results. However, as we document, the trade-off becomes much less pronounced in a model where the IV conditions provide additional information for the elasticity of supply. In Table [2,](#page-20-0) we compare the implications of using either prior HR20 or BH19 in a model identified by only sign restrictions (Panel A) and again in a model identified by combining the sign restrictions with IV constraints (Panel B) by computing the contribution of identified structural shocks to the (forecast error) variance of the real

<span id="page-19-1"></span><sup>11</sup>See Appendix [E](#page-41-1) for interpretation of Bayes factor magnitudes.

<span id="page-20-0"></span>Table 2: Posterior quantiles of the Forecast Error Variance Decomposition of the Real Price of Oil

| Panel A: R1 + R3 |  |  |  |
|------------------|--|--|--|
|------------------|--|--|--|

|         | ε           | s<br>t      | ε           | ad<br>t     | ε           | sd<br>t     |
|---------|-------------|-------------|-------------|-------------|-------------|-------------|
|         | h<br>= 0    | h<br>= 24   | h<br>= 0    | h<br>= 24   | h<br>= 0    | h<br>= 24   |
| R3-HR20 | 0.06        | 0.12        | 0.44        | 0.45        | 0.31        | 0.17        |
|         | (0.01,0.19) | (0.04,0.27) | (0.18,0.72) | (0.23,0.65) | (0.10,0.62) | (0.05,0.38) |
| R3-BH19 | 0.18        | 0.18        | 0.31        | 0.28        | 0.21        | 0.09        |
|         | (0.03,0.42) | (0.05,0.42) | (0.12,0.58) | (0.12,0.51) | (0.06,0.45) | (0.03,0.24) |

Panel B: R1+R2+R3

|         | ε           | s<br>t      | ε           | ad<br>t     | ε           | sd<br>t     |
|---------|-------------|-------------|-------------|-------------|-------------|-------------|
|         | h<br>= 0    | h<br>= 24   | h<br>= 0    | h<br>= 24   | h<br>= 0    | h<br>= 24   |
| R3-HR20 | 0.06        | 0.11        | 0.50        | 0.51        | 0.37        | 0.14        |
|         | (0.02,0.13) | (0.04,0.22) | (0.20,0.78) | (0.30,0.70) | (0.11,0.69) | (0.04,0.38) |
| R3-BH19 | 0.08        | 0.12        | 0.34        | 0.26        | 0.32        | 0.11        |
|         | (0.03,0.17) | (0.05,0.25) | (0.13,0.64) | (0.10,0.54) | (0.07,0.66) | (0.04,0.35) |

Note: The forecast error variance decomposition of the real oil price is computed at horizons h = 0 and h = 24 months. Values in brackets indicate the 16% and 84% pointwise posterior credibility set. Both HR20 and BH19 are used as information for η1/2.

price of oil. We are particularly interested in the effect of the oil supply shock (ε s t ), where the estimates have diverged somewhat and are subject to debate.

In line with the literature, combining sign restrictions with a tight upper bound on the supply elasticities (R1+R3-HR20) renders supply shocks to be fairly unimportant as drivers of oil prices. Point estimates suggest contributions of between 6% and 12% depending on the forecast horizon. Instead, using a less restrictive formulation that allows for uncertainty in the elasticity of supply (R1+R3-BH19) yields fairly imprecise estimates. 68% posterior credibility sets reflect substantially higher uncertainty, including values up to 42%. This also effects median estimates rendering supply shocks to be 2-3 times more important.

In contrast, when additionally exploiting the information from the instrument (Panel B), estimates largely coincide no matter if we use a tight upper bound or a less restrictive prior distribution for the supply elasticities. Point estimates for the contribution of oil supply shocks settle at 6-8% on impact, and 11-12% at the two year horizon. The reason is that the information in the instrument points toward a minor role of supply. By incorporating hard identifying information, we allow the uninformative prior of BH19 to be updated to a larger extent by the data. While the resulting identification scheme is less restrictive than imposing an upper bound directly, it happens to point towards the same results. Note, however, that the choice of prior still matters for the contribution of other shocks. This makes perfect sense given that the IV restriction R2 is primarily designed to be informative about the supply shock.

Throughout this section, we followed [Kilian & Murphy \(2014\)](#page-28-10) in defining η1/<sup>2</sup> as the short-run elasticities of oil supply. However, as highlighted in [Baumeister & Hamilton](#page-26-10) [\(2021\)](#page-26-10), an alternative definition of the supply elasticity is given by a single parameter within the A-model, which corresponds to the systematic reaction of oil producers to increases in the oil price. In Appendix [G,](#page-43-0) we show that our empirical findings are very similar when the IV information is introduced into a model identified by a combination of exclusion restrictions and prior densities for B<sup>−</sup><sup>1</sup> , which is the original identification strategy envisaged by BH19.

## <span id="page-21-0"></span>3.2 The effects of monetary policy

The effects of monetary policy shocks have been extensively studied using SVAR models (see [Ramey \(2016\)](#page-30-2) for a recent review of the literature). To avoid overly restrictive exclusion restrictions, two very popular identification schemes have emerged in recent years. One strand of the literature uses sign restrictions, possibly combined with zero restrictions to identify the monetary policy shock. These restrictions are derived from economic theory, such that a monetary policy tightening should be associated with an increase in the interest rates but not in consumer prices [\(Uhlig 2005,](#page-30-0) [Faust 1998\)](#page-27-0) or that the Fed tightens monetary policy stance in reaction to surprising increases in output and inflation [\(Arias](#page-26-11) [et al. 2019\)](#page-26-11). Unfortunately, using set identification often leads to wide confidence intervals around impulse responses such that results are typically uninformative with respect to financial variables.

An alternative branch of the literature uses narrative or high frequency measures of monetary policy shocks for identification. Among the most prominent measures are shock series based on readings of Federal Open Market Committee (FOMC) minutes, cleaned by Greenbook forecasts for output and inflation [\(Romer & Romer 2004,](#page-30-11) [Coibion 2012\)](#page-27-13) and factors based on changes in high frequency future prices around FOMC meetings [\(Faust](#page-27-14) [et al. 2004,](#page-27-14) [Gertler & Karadi 2015,](#page-27-3) [Nakamura & Steinsson 2018\)](#page-29-14). However, it is a very difficult task to construct convincing exogenous instruments for monetary policy. With respect to the Romer & Romer shock (henceforth R&R), the authors themselves state that their series is only 'relatively free of endogenous and anticipatory movement' [\(Romer](#page-30-11) [& Romer 2004\)](#page-30-11). To ensure against remaining endogeneity they exclude the possibility of a contemporaneous response of the macroeconomic variables to the narrative series. Furthermore, as demonstrated in [Caldara & Herbst \(2019\)](#page-27-6), the FOMC responds not only to forecasts of output and inflation, but also responds to the information in credit spreads. This finding directly invalidates the use of the R&R residual as an external instrument to study the effects of monetary policy on financial markets.

As laid out in Section [2.3,](#page-7-1) our methodology provides a simple framework to exploit identifying information in proxy variables that are just 'plausibly exogenous', which we will combine with conventional sign restrictions. We show that in the sign-restricted model of [Arias et al. \(2019\)](#page-26-11) (ACR henceforth), the Bayes factor yields formal evidence against using the R&R shock as an IV. However, we still exploit its information to narrow down the set of admissible models using the type of restrictions discussed in Section [2.3.](#page-7-1) In particular, we impose the additional restriction that the monetary policy shock explains more variance of the narrative series than all other driving forces of the economy. This sharpens identification of the set-identified model and leads to more informative results, while also avoiding the potentially wrong assumption of exogeneity.

For our empirical study, we follow ACR and specify a monthly SVAR(12) model with  $y_t = (\mathrm{gdp}_t, \mathrm{def}_t, \mathrm{cp}_t, \mathrm{tr}_t, \mathrm{nbr}_t, \mathrm{ffr}_t)'$ , where  $\mathrm{gdp}_t$  is the real gross domestic product,  $\mathrm{def}_t$  is the GDP deflator,  $\mathrm{cp}_t$  is a commodity price index,  $\mathrm{tr}_t$  are total reserves,  $\mathrm{nbr}_t$  are non-borrowed reserves, and  $\mathrm{ffr}_t$  is the federal funds rate. All variables are transformed to log times 100, except for  $\mathrm{ffr}_t$  which is included in annualized percentages. With respect to the narrative series, we use  $m_t = \mathrm{rr}_t$ , the R&R narrative shock series updated by Wieland & Yang (2016). Our sample starts in 1969M1 and ends in 2007M12 and we assume that  $\Gamma_{1i} = \Gamma_{2i} = 0$ , excluding predictability of R&R by lagged values of  $\tilde{y}_t$ . The first three years are used to train an informative prior distribution, i.e. we set  $v_0 = 36$  and  $S_0 = \mathrm{diag}(S_{11}, S_{22})$  where  $S_{22} = \sum_{t=1}^{36} m_t^2$  and  $S_{11} = \sum_{t=1}^{36} \hat{u}_t \hat{u}_t'$  with  $\hat{u}_t$  being simple AR(2) forecast errors of the training sample. Assuming prior independence between the instrument and forecast errors is useful for our Bayes factor analysis as it ensures that the prior is centered around the null hypothesis of instrument exogeneity ( $\Phi_{r,0} = 0$ ). For the regression coefficients, we use the same Minnesota prior considered in the first application.

To demonstrate the merits of our approach, we will compare the following identification schemes: a pure IV approach which assumes that the R&R shock is a valid instrument for monetary policy (R1), a combination of zero and sign restriction as considered in ACR (R2), and a combined identification scheme that relaxes the exogeneity assumption (R3).

In the first identification scheme (R1), we treat the R&R residuals as an exogenous instrument for the monetary policy shock ( $\varepsilon_t^{mp} = \varepsilon_{1t}$ ). Therefore the identifying restrictions for R1 are given by  $\mathrm{E}[\varepsilon_t^{mp} m_t] \neq 0$  and  $\mathrm{E}[\varepsilon_{it} m_t] = 0, i \neq 1$ , yielding the zero restrictions on  $\Phi$  discussed in Section 2.2.

In R2, we follow ACR and restrict coefficients of the monetary policy rule implicit in the SVAR model. Rewriting the model as a simultaneous equation system, the systematic component of monetary policy is given by:

<span id="page-22-1"></span>
$$r_{t} = \xi_{y} u_{t}^{gdp} + \xi_{\pi} u_{t}^{def} + \xi_{cp} u_{t}^{cp} + \xi_{tr} u_{t}^{tr} + \xi_{nbr} u_{t}^{nbr} + \sigma_{\xi} \varepsilon_{t}^{mp}. \tag{3.1}$$

The coefficients can be backed out by  $\xi_y = -\mathsf{a}_{n1}^{-1}\mathsf{a}_{11}$ ,  $\xi_\pi = -\mathsf{a}_{n1}^{-1}\mathsf{a}_{12}$ ,  $\xi_{cp} = -\mathsf{a}_{n1}^{-1}\mathsf{a}_{13}$ ,  $\xi_{tr} = -\mathsf{a}_{n1}^{-1}\mathsf{a}_{14}$ ,  $\xi_{nbr} = -\mathsf{a}_{n1}^{-1}\mathsf{a}_{15}$ , and  $\sigma_\xi = \mathsf{a}_{n1}^{-1}$  where  $\mathsf{a}_{ij}$  are the elements of  $\mathsf{A} = B^{-1}$ . We follow ACR and impose the following combination of restrictions on equation (3.1): R2:  $\{0 < \xi_y < 4, 0 < \xi_\pi < 4, \xi_{tr} = 0, \xi_{nbr} = 0\}$ , implying that the central bank systematically increases its policy rate in response to positive surprises of output or prices, while it does not show systematic reactions towards surprises in monetary aggregates. An upper bound of 4 rules out implausibly large values. <sup>13</sup>

Finally, the combined identification scheme (R3) is based on R2 plus the additional constraint that the monetary policy shock  $\varepsilon_t^{mp}$  must explain more variation of  $m_t$  than all

<span id="page-22-0"></span> $<sup>^{12}</sup>$ All time series were obtained from the replication files of Arias et al. (2019). Note that  $gdp_t$  and  $def_t$  were interpolated based on US industrial production and CPI prices, respectively.

<span id="page-22-2"></span><sup>&</sup>lt;sup>13</sup>Strictly speaking, these restrictions imply a set identified model based on a combination of zero and sign restrictions. Within our framework, this requires adjusting the proposal distribution of Appendix A to account for the additional zero restrictions, see Arias et al. (2018) for details.

<span id="page-23-0"></span>Table 3: Posterior distribution for parameters of the policy rule

|          |         | R1          |            |           | R2          |                  |           | R3          |            |
|----------|---------|-------------|------------|-----------|-------------|------------------|-----------|-------------|------------|
| quantile | $\xi_y$ | $\xi_{\pi}$ | $\xi_{cp}$ | $ \xi_y $ | $\xi_{\pi}$ | $\xi_{cp}$       | $  \xi_y$ | $\xi_{\pi}$ | $\xi_{cp}$ |
| 5%       | -0.29   | -1.30       | -0.03      | 0.06      | 0.34        | $-0.24 \\ -0.01$ | 0.03      | 0.09        | -0.10      |
| 50%      | -0.09   | -0.74       | 0.00       | 0.63      | 2.26        | -0.01            | 0.26      | 0.84        | -0.00      |
| 95%      | 0.10    | -0.19       | 0.03       | 2.27      | 3.81        | 0.22             | 0.65      | 1.85        | 0.08       |

Posterior quantiles of the parameters governing the monetary policy rule

other structural shocks. Using notation of Section 2.3, this means we use  $\omega_1 > \sum_{j=2}^n \omega_j$ , where  $\omega_j$  is the contribution of the jth structural shock to variation of  $m_t$ . The additional restriction makes sure that only those models are retained where the monetary policy shocks is clearly related to the R&R narrative shock. At the same time, up to half of the variation in  $m_t$  explained by  $\varepsilon_t$  can reflect endogenous reactions of the R&R series to other shocks.

We start our analysis by reporting posterior quantiles for the parameters governing the monetary policy rule (Table 3). Estimates based on R1 suggest that  $m_t$  is highly informative about the monetary policy rule. However, using it as an instrument yields economically implausible parameters. For instance, the 90% posterior confidence sets of  $\xi_{\pi}$  suggests that the Fed systematically cuts the policy rate in response to higher inflation, contradicting standard macroeconomic thinking. As for the second identification strategy (R2), posterior probability intervals suggest that the data is not overly informative at all. For example, the 95% quantile of  $\xi_{\pi}$  implies that in reaction to a 1% increase in prices, the central bank systematic reaction is to increase the federal funds rate by almost 4 percentage points within the same month, which is very near to the upper bound of ACR. Adding the additional restriction on the relation between the policy shock and the R&R residual (R3) substantially narrows down these credibility sets. Values between 0.03 and 0.65 for  $\xi_y$  and between 0.09 and 1.85 for  $\xi_{\pi}$  seem reasonable and are more in line with conventional estimates of a Taylor Rule (Hamilton et al. 2011).

In Figure 1, we provide impulse response functions to the identified monetary policy shock obtained under restrictions R1, R2 and R3. First, consider the top row which shows results from the model identified by using the R&R series as an external instrument (R1). A short-term increase in output together with a sharp and significant positive response in aggregate prices (price puzzle) seems puzzling and casts additional doubt on the credibility of the identification strategy. Indeed, formal analysis via our Bayes factor points towards a rejection of instrument exogeneity under the sign-identification scheme. Defining  $M_1$  as model R2 and  $M_0$  as model R2 plus the IV exclusion restriction ( $\Phi_{r,0} = 0$ ), we find  $2 \ln \hat{B}_{10} = 14.49$  (0.64). These results confirm findings in Nguyen (2019) who incorporates the R&R shock into a quarterly model identified via sign restrictions and prior distributions on structural parameters. Interestingly, he also rejects instrument exogeneity of the R&R narrative shock despite different data, frequency and identification strategy. In contrast, when using a combination of sign- and zero restrictions (R2, second row of Figure 1), the puzzling results disappear. However, the identification seems rather weak in that it yields very wide error bounds which often include the zero line. The model does, however,

![](_page_24_Figure_0.jpeg)

<span id="page-24-0"></span>Figure 1: Impulse responses in the monetary policy SVAR obtained by using different identifying restrictions. Posterior median (solid line), 68% and 90% posterior credibility sets (dotted lines). Sample period: 1965M01-2007M12.

indicate a short-term drop in output. Finally, the bottom row of Figure [1](#page-24-0) shows the results from using R3 which imposes the additional ranking constraint on the variance contributions underlying m<sup>t</sup> . We see that such a combined identification approach leads to tighter credibility sets and therefore gives more informative results than using sign restrictions only.

In a last exercise, we demonstrate that a sharper identification is particularly useful if we are further interested in estimating the effects of monetary policy on financial variables. To this end, we add one financial variable at a time to the baseline specification and recompute IRFs to a monetary policy shock. We consider real stock prices, measured as the log of consumer price deflated S&P500 index, the mortgage spread, defined as difference between 30-year fixed rate mortgage average and the 10-year treasury yield, the commercial paper spread, defined as 3-month AA financial commercial paper rate minus the 3-months Tbill rate, and the 'excess bond premium' measure of credit market tightness developed by [Gilchrist & Zakrajˇsek \(2012\)](#page-28-14).

Similar to the baseline model without financial variables, we document that posterior credibility sets are much tighter if we exploit information from the R&R series in addition to the sign restrictions. For instance, in a model identified by R2 not much can be said on the response of stock prices and the excess bond premium since credibility sets are wide and include zero. In contrast, the picture is clearer when using R3. Here, real stock prices tend to fall and the excess bond premium responds positively. Furthermore, impulse responses are significantly different from zero, at least if judged by the 68% posterior credibility sets. A similar pattern arises for the responses of mortgage and commercial paper spreads.

![](_page_25_Figure_0.jpeg)

Figure 2: Impulse responses in the monetary policy SVAR augmented by one financial variable at a time. Posterior median (solid line), 68% and 90% posterior credibility sets (dotted lines). Sample periods: 1965M01-2007M12 (real stock prices, commercial paper spread), 1971M04-2007M12 (mortgage spreads), 1973M01-2007M12 (excess bond premium).

## <span id="page-25-0"></span>4 Conclusion

In this paper, we discuss ways of combining sign restrictions with information in proxy variables for the identification of SVAR models. When the external variables are credibly exogenous instruments, sign restrictions may be useful to identify other shocks in the system, or to disentangle multiple shocks to be identified by IV. We also suggest to use them as an overidentifying device to obtain a more informative picture in finite samples. When the external variables are just 'plausibly exogenous', we suggest to replace the exogeneity restrictions with bounds on correlations and variance contributions. Combined with conventional sign restrictions, the resulting identification strategy can be quite powerful. We introduce the restrictions in an augmented SVAR model and conduct posterior inference via MCMC methods. We rely on a conjugate prior for a B-model type SVAR, which allows to compute Bayes factors in a straightforward way.

Finally, we illustrate the usefulness of our method in two empirical applications. In the first, we study the importance of supply shocks as drivers of oil prices. Our findings suggest that once we use Kilian's OPEC shortfall series as an IV to identify supply shocks, two prominent identification strategies used in literature yield similar conclusions. In the second application, we estimate the effects of US monetary policy combining sign restrictions and information in the [Romer & Romer \(2004\)](#page-30-11) narrative shock. Formal Bayes factor analysis suggests that the narrative shock is unlikely to be exogenous. We show how the information in the proxy can still be useful to narrow down the set of admissible models and to obtain a more informative picture, particularly for financial variables.
