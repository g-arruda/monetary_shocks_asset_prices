# Monetary Policy, Real Activity, and Credit Spreads: Evidence from Bayesian Proxy SVARs<sup>†</sup>

By Dario Caldara and Edward Herbst\*

In this paper, we develop a Bayesian framework to estimate a proxy structural vector autoregression to identify monetary policy shocks. We find that during the Great Moderation period, monetary policy shocks induce a persistent decline in real activity and tightening in financial conditions. Central to this result is a systematic component of monetary policy characterized by a direct and economically significant reaction to changes in corporate credit spreads. The failure to account for this endogenous reaction induces an attenuation in the response of all variables to monetary shocks, a result that also applies to the narrative identification of Romer and Romer (2004). (JEL C32, E23, E32, E44, E52, E58)

Starting with Sims (1980), a large literature has assessed the effects of monetary policy in the United States using structural vector autoregressions (SVARs). When considering the entirety of the post-World War II period, there is a large body of evidence suggesting that unexpected monetary tightenings reduce output. The strength and robustness of this finding noticeably weaken, however, when considering only data from the mid-1980s to the onset of the global financial crisis, a period of low business cycle volatility known as the Great Moderation. For instance, Boivin, Kiley, and Mishkin (2010) document that monetary policy shocks have no discernible effects on the real economy. By contrast, Gertler and Karadi (2015) find sizable adverse economic effects of monetary policy tightenings. In a critical summary of research on monetary SVARs applied to the Great Moderation period, Ramey (2016) describes mixed evidence for the importance of monetary shocks and shows that existing estimates of the economic response to monetary policy shocks lack robustness.

<span id="page-0-1"></span><sup>\*</sup>Caldara: Federal Reserve Board, 20th Street and Constitution Avenue NW, Washington, DC 20551 (email: dario.caldara@frb.gov); Herbst: Federal Reserve Board, 20th Street and Constitution Avenue NW, Washington, DC 20551 (email: edward.p.herbst@frb.gov). We thank Giovanni Favara, Domenico Giannone, Yuriy Gorodnichenko, Jim Hamilton, David Lopez-Salido, Andrea Prestipino, Juan Rubio-Ramírez, Jón Steinsson, Mark Watson, Egon Zakrajšek, Tao Zha, and seminar and conference participants at the Federal Reserve Board, the 2015 SED Annual Meetings, the EFSF workshop at the 2015 NBER Summer Institute, Cornell University, Colgate University, and Emory University. All errors and omissions are our own responsibility. The views expressed in this paper are solely the responsibility of the authors and should not be interpreted as reflecting the views of the Board of Governors of the Federal Reserve System or of anyone else associated with the Federal Reserve System.

<span id="page-0-0"></span> $<sup>^{\</sup>dagger}$ Go to https://doi.org/10.1257/mac.20170294 to visit the article page for additional materials and author disclosure statement(s) or to comment in the online discussion forum.

<span id="page-0-2"></span><sup>&</sup>lt;sup>1</sup> See Bernanke and Blinder (1992); Christiano, Eichenbaum, and Evans (1996); Leeper, Sims, and Zha (1996); Leeper and Zha (2003); Romer and Romer (2004); and, more recently, Arias, Caldara, and Rubio-Ramírez (2015).

In this paper, we show that, for the Great Moderation period, large effects of monetary policy shocks hinge on the presence of a strong systematic response of monetary policy to financial conditions. This component of the monetary policy rule, which is present in, but not the focus of, Gertler and Karadi (2015), is mostly neglected in the literature. We find that the failure to account for this endogenous reaction induces an attenuation in the response of all variables to monetary shocks. Thus, our results can reconcile the dispersion in the estimated effects of monetary policy shocks on real activity found in the literature, and explain the lack of robustness documented in Ramey (2016).

To reach this conclusion, we estimate over the 1994–2007 period a Bayesian proxy SVAR (BP-SVAR), a SVAR model that is augmented by monetary surprises computed using high-frequency financial data, to identify monetary policy shocks. In our BP-SVAR, which we specify closely following Gertler and Karadi (2015), positive monetary policy shocks induce a sustained decline in industrial production and rise in the unemployment rate, and are transmitted through tightening in financial conditions. Importantly, we document that the monetary policy rule reacts systematically to changes in corporate credit spreads; all else being equal, a 10 basis-point increase in spreads leads to a contemporaneous 10 basis-point drop in the federal funds rate, an elasticity of  $-1.^2$ 

To quantify the importance of accounting for the endogenous response of monetary policy to spreads when assessing the role of monetary shocks in economic fluctuations, we estimate two additional variants of the model: one that omits credit spreads, and one where monetary shocks are identified by imposing that the federal funds rate does not react contemporaneously to changes in credit spreads (a standard Cholesky identification). In the first variant, monetary shocks induce no change in industrial production. In the second variant, monetary policy shocks induce a decline in industrial production that is 40 percent smaller than in our preferred BP-SVAR specification. In both these alternative specifications, a monetary shock is a mix of exogenous changes in policy and the systematic response of monetary policy to changes in credit spreads. The attenuation happens because a drop in corporate spreads generates a persistent increase in real activity. This analysis explains why monetary policy shocks identified using BP-SVARs that include corporate spreads have large economic effects compared to shocks identified using conventional SVAR identification schemes.

In light of the relationship between monetary policy and corporate credit spreads uncovered by the BP-SVAR, we revisit the narrative identification proposed by Romer and Romer (2004). Under this identification, monetary policy shocks are the residual of a regression of intended changes in the federal funds rate on the Federal Reserve's Greenbook forecasts of output and inflation. The macroeconomic impact of these shocks is typically studied using reduced-form VARs, as in Romer and Romer (2004) and Coibion (2012), or by running local projections, as in Ramey (2016).

<span id="page-1-0"></span><sup>&</sup>lt;sup>2</sup> Although several recent papers have concentrated on the transmission of monetary policy through financial markets, both empirically (Gertler and Karadi 2015, Galí and Gambetti 2015) and theoretically (Bernanke, Gertler, and Gilchrist 1999; Gertler and Karadi 2011), substantially less attention has been devoted to the endogenous response of monetary policy to changes in asset prices. A notable exception is Rigobon and Sack (2003) who document a significant response of the federal funds rate to stock prices.

For the 1994–2007 sample, we show that the intended federal funds rate reacts to corporate spreads beyond its response to forecasted output and inflation, as in the monetary policy rule identified in the BP-SVAR. Moreover, in both the reduced-form VAR and local projection approaches, we find that the implications are the same as in the BP-SVAR: shocks constructed without controlling for the response of monetary policy to corporate spreads have no effects on real activity, in line with the evidence in Ramey (2016). By contrast, the shocks constructed controlling for corporate spreads have large effects on the real economy.

Our paper also provides a methodological contribution to the recent literature on proxy SVARs. The standard framework of Stock and Watson (2012) and Mertens and Ravn (2013) uses an instrumental variables approach to estimate proxy SVARs in multiple stages, while we provide an encompassing framework that jointly models the interaction between the SVAR and the proxy. In particular, we write the likelihood of a SVAR model augmented with a measurement equation that relates the proxy to the unobserved structural shock of interest and estimate the model using Bayesian techniques. Our framework has several advantages over the standard framework. First, inference is valid even if the information content of the proxy is weak. Second, as we coherently incorporate all sources of uncertainty in the estimation, the proxy becomes informative about both the reduced-form and structural parameters of the model. Third, through prior distributions, we can adjust the informativeness of the proxy for the estimation of the parameters of the SVAR model, that is, researchers that are convinced of the relevance of their proxies for the identification of the structural shock of interest can express this view via the prior distribution. This prior induces the estimation to take a lot of signal from the proxy.

To construct the proxy for monetary policy shocks, we follow the literature pioneered by Kuttner (2001), and use high-frequency data to capture the surprise component of policy actions announced in Federal Open Market Committee (FOMC) statements. The bulk of this literature, which includes Bernanke and Kuttner (2005); Gürkaynak, Sack, and Swanson (2005); Campbell et al. (2012); and Gilchrist, López-Salido, and Zakrajšek (2015), considers univariate regressions for assessing the effects on monetary policy on daily changes in asset prices. An important exception is Gertler and Karadi (2015), who like we do in this paper identify a monetary proxy SVAR that includes corporate spreads. However, the focus of the analysis in the two papers is different. While Gertler and Karadi concentrate on impulse responses to monetary policy shocks, our focus is on the centrality of the systematic response of monetary policy to corporate spreads for understanding the transmission of both monetary policy and non-policy shocks and their relative importance in explaining business cycle fluctuations. Finally, our work is also related to Faust, Swanson, and Wright (2004), who pioneered the use of high-frequency monetary surprises to identify monetary shocks in a VAR using a different estimation framework and omitting measures of financial conditions that, as we show, are crucial for characterizing the role of monetary policy for business cycle fluctuations.

The BP-SVAR and our revaluation of the narrative identification of Romer and Romer (2004) clearly point to the existence of a significant systematic response of

monetary policy to financial conditions beyond the well-understood response to real economic activity and prices. This evidence is consistent with Peek, Rosengren, and Tootell (2016), who use textual analysis to examine FOMC transcripts and find that, even after controlling for forecasts of inflation and unemployment, the word counts of terms related to financial conditions predict monetary policy decisions.

This paper is structured as follows. Section I describes the econometric framework. Section II describes the construction of the proxy and its properties. Section III shows the main empirical findings based on the BP-SVARs. Section IV shows the implications of the interaction between monetary policy and corporate spreads for the Romer and Romer (2004) identification of monetary shocks. Section V explores the robustness of our main findings to an alternative estimation methodology and model specifications. Section VI concludes.

### I. Econometric Methodology

In this section, we first describe a standard SVAR model and derive the monetary policy rule embedded in the SVAR. We then present the BP-SVAR and explain the identification of the monetary policy rule and, by implication, of the monetary policy shock. Finally, we discuss the prior distributions of the model parameters and the samplers used to draw from their posterior distributions.

Consider the following VAR, written in structural form:

(1) 
$$\mathbf{A}_0 \mathbf{y}_t = \sum_{\ell=1}^p \mathbf{A}_\ell \mathbf{y}_{t-\ell} + \mathbf{c} + \mathbf{e}_t, \text{ for } 1 \leq t \leq T,$$

where  $\mathbf{y}_t$  is an  $n \times 1$  vector of endogenous variables,  $\mathbf{e}_t$  is an  $n \times 1$  vector of structural shocks,  $\mathbf{A}_\ell$  is an  $n \times n$  matrix of structural parameters for  $0 \le \ell \le p$  with  $\mathbf{A}_0$  invertible,  $\mathbf{c}$  is an  $n \times 1$  vector of intercepts, p is the lag length, and T is the sample size. The vector  $\mathbf{e}_t$ , conditional on past information and the initial conditions  $\mathbf{y}_0, \ldots, \mathbf{y}_{1-p}$ , is Gaussian with a mean of zero and covariance matrix  $\mathbf{I}_n$  (the  $n \times n$  identity matrix). The model described in equation (1) can be written in compact form as

(2) 
$$\mathbf{A}_0 \mathbf{y}_t = \mathbf{A}_+ \mathbf{x}_t + \mathbf{e}_t, \text{ for } 1 \le t \le T,$$

where  $\mathbf{x}_t = [\mathbf{y}_{t-1}', \dots, \mathbf{y}_{t-p}', 1]'$  and  $\mathbf{A}_+ = [\mathbf{A}_1, \dots, \mathbf{A}_p, \mathbf{c}]$ . The reduced-form representation of this model is given by

(3) 
$$\mathbf{y}_t = \mathbf{\Phi} \mathbf{x}_t + \mathbf{u}_t, \quad \mathbf{u}_t \sim \mathcal{N}(0, \mathbf{\Sigma}).$$

The reduced-form parameters and the structural parameters are linked through

(4) 
$$\Sigma = (\mathbf{A}_0' \mathbf{A}_0)^{-1} \text{ and } \Phi = \mathbf{A}_0^{-1} \mathbf{A}_+.$$

### B. The Monetary Policy Equation

To study the effects of monetary policy, we need to select an element of  $e_t$  that represents the monetary policy shock  $e_{MP,t}$ . As discussed in Leeper, Sims, and Zha (1996), specifying  $e_{MP,t}$  is equivalent to specifying an equation that characterizes monetary policy behavior. In what follows, we assume, without loss of generality, that  $e_{MP,t}$  is the first shock in  $e_t$ . Consequently, the first equation of the SVAR is the monetary policy equation

(5) 
$$\mathbf{A}_{0.1}\mathbf{y}_t = \mathbf{A}_{+.1}\mathbf{x}_t + e_{MP,t}, \text{ for } 1 \le t \le T,$$

where  $A_{0,1}$  and  $A_{+,1}$  denote the first row of  $A_0$  and  $A_+$ , respectively. If we assume that the policy rate  $r_t$  is also ordered first in  $y_t$ , we can rewrite equation (5) as follows:

(6) 
$$r_t = \sum_{j=2}^n y'_{j,t} \psi_{0,j} + \sum_{\ell=1}^p y'_{t-\ell} \psi_{\ell} + \sigma_{MP} e_{MP,t}, \quad \text{for } 1 \leq t \leq T,$$

where  $\psi_{0,j} = -a_{0,1j}/a_{0,11}$ ,  $\psi_{\ell} = a_{\ell,1}/a_{0,11}$ , and  $\sigma_{MP} = 1/a_{0,11}$ , with  $a_{\ell,ij}$  denoting the ijth element of  $\mathbf{A}_{\ell}$ . The first two terms on the right-hand side of equation (6) describe the systematic component of monetary policy, characterizing how the policy rate at time t responds to contemporaneous and lagged movements in the variables included in the model.

It is clear from equations (5) and (6) that the identification of the monetary policy shock  $e_{MP,t}$  is equivalent to the identification of the systematic component of monetary policy. In turn, to characterize the systematic component we require knowledge of a subset of the structural parameters,  $(\mathbf{A}_{0,1},\mathbf{A}_{+,1})$ . As is well known, without additional restrictions, it is not possible to discriminate between the many possible combinations of structural parameters  $(\mathbf{A}_0,\mathbf{A}_+)$  that yield the same reduced-form parameters  $(\mathbf{\Phi},\mathbf{\Sigma})$ , that is, the likelihood of the SVAR model (2) is flat with respect to these combinations. The majority of the literature, beginning with Sims (1980), has used theoretical restrictions to achieve identification, that is, to inform the choice of  $(\mathbf{A}_0,\mathbf{A}_+)$ , and most debates in the SVAR literature are about the "correct" choice of restrictions for any given application. By contrast, in this paper, we follow a different strategy, which we discuss next.

#### C. The BP-SVAR

We inform the identification of  $(\mathbf{A}_{0,1}, \mathbf{A}_{+,1})$ —the structural parameters that describe the systematic component of monetary policy—by incorporating additional data in the estimation of the model. The framework is a Bayesian implementation of the proxy SVAR approach of Stock and Watson (2012) and Mertens and Ravn (2013). In particular, in our application, we achieve identification by observing a series of surprise monetary policy changes constructed using high-frequency financial data.

As discussed in Section II, this series is not a perfect measure; instead, it serves as a proxy for the unobserved monetary policy shock  $e_{MP,t}$ .

In what follows, we take the proxy,  $m_t$  and we link it to the monetary policy shock  $e_{MP,t}$  as follows:

(7) 
$$m_t = \beta e_{MP,t} + \sigma_{\nu} \nu_t$$
,  $\nu_t \sim \mathcal{N}(0,1)$  and  $\nu_t \perp e_t$ , for  $1 \leq t \leq T$ ,

where  $\nu_t$  is an iid measurement error.<sup>3</sup> The formulation in equation (7), which we extend in Section IV to incorporate multiple proxies, has two implications. The first is that the squared correlation between  $m_t$  and  $e_{MP,t}$ ,

(8) 
$$\rho \equiv \operatorname{corr}(m_t, e_{MP, t})^2 = \frac{\beta^2}{\beta^2 + \sigma_{\nu}^2},$$

measures the "relevance" of the external information for the structural shock of interest. Equation (8) makes clear that the relevance of the proxy is directly related to the signal-to-noise ratio  $\beta/\sigma$ . The larger this value, the more information the proxy brings to bear on the identification of the SVAR.<sup>4</sup> The second implication of equation (7) is that  $m_t$  is orthogonal to other structural shocks in the VAR. If we partition the vector of shocks as  $\mathbf{e}_t = [e_{MP,t}, \mathbf{e}'_{NMP,t}]'$ , this condition can be written as

$$(9) E[m_t \mathbf{e}'_{NMP,t}] = \mathbf{0}.$$

Equation (9) conveys the exogeneity of the proxy, which ensures that our proxy is only informative about the monetary policy shock. These two conditions are very similar to those required of an instrument in an instrumental variables regression. The setting, though, is different, as both the relevance and exogeneity of the proxy cannot be directly inferred by the data, but depend on the specification of the model used to generate the vector of unobserved structural shocks  $e_{MP,t}$ .

To examine in detail how the proxy interacts with the rest of the SVAR, we augment equation (2) with equation (7). Letting  $\tilde{\mathbf{y}}_t = [\mathbf{y}_t', m_t]'$  and  $\tilde{\mathbf{e}}_t = [\mathbf{e}_t', \nu_t]'$ , we can rewrite equation (2) as a system of equations for  $\tilde{\mathbf{y}}_t$ :

(10) 
$$\tilde{\mathbf{A}}_0 \tilde{\mathbf{y}}_t = \tilde{\mathbf{A}}_+ x_t + \tilde{\mathbf{e}}_t.$$

The structural matrices  $\tilde{\mathbf{A}}_0$  and  $\tilde{\mathbf{A}}_+$  are functions of the original SVAR matrices,  $(\mathbf{A}_0, \mathbf{A}_+)$ , and the parameters governing the proxy equation,  $(\beta, \sigma_{\nu})$ , with

(11) 
$$\tilde{\mathbf{A}}_{0} = \begin{bmatrix} \mathbf{A}_{0} & \mathbf{0}_{n \times 1} \\ -\frac{\beta}{\sigma_{\nu}} \mathbf{A}_{0,1} & \frac{1}{\sigma_{\nu}} \end{bmatrix}, \text{ and } \tilde{\mathbf{A}}_{+} = \begin{bmatrix} \mathbf{A}_{+} \\ -\frac{\beta}{\sigma} \mathbf{A}_{+,1} \end{bmatrix}.$$

<span id="page-5-0"></span><sup>&</sup>lt;sup>3</sup> Equation (7) can be generalized by adding lags of  $m_t$  to allow for autocorrelation in the proxy, a specification we do not explore as it is not relevant in our application.

<span id="page-5-1"></span><sup>&</sup>lt;sup>4</sup> Mertens and Ravn (2013) call  $\rho$  the reliability indicator for the proxy.

As can be seen from equation (11), the proxy SVAR is a model that links the proxy to the structural shock of interest, the monetary policy shock, through the structural coefficients  $(\mathbf{A}_{0,1}, \mathbf{A}_{+,1})$  associated with the systematic component of monetary policy. The zero restrictions in the bottom left partition of  $\tilde{\mathbf{A}}_0$  and  $\tilde{\mathbf{A}}_+$  are implied by the assumption stated in equation (7) that the measurement error  $\nu_t$  is orthogonal to all structural shocks  $e_t$ .

To understand identification, it is instructive to write the likelihood function for the model:<sup>5</sup>

(12) 
$$p(\mathbf{Y}_{1:T}, \mathbf{M}_{1:T} | \tilde{\mathbf{A}}_0, \tilde{\mathbf{A}}_+) = p(\mathbf{Y}_{1:T} | \tilde{\mathbf{A}}_0, \tilde{\mathbf{A}}_+) p(\mathbf{M}_{1:T} | \mathbf{Y}_{1:T}, \tilde{\mathbf{A}}_0, \tilde{\mathbf{A}}_+)$$
$$= p(\mathbf{Y}_{1:T} | \boldsymbol{\Phi}, \boldsymbol{\Sigma}) p(\mathbf{M}_{1:T} | \mathbf{Y}_{1:T}, \mathbf{A}_0, \mathbf{A}_+, \boldsymbol{\beta}, \boldsymbol{\sigma}_{\nu}),$$

where  $\mathbf{Y}_{1:T} = [\mathbf{y}_1, \dots, \mathbf{y}_T]'$ . The first term on the right-hand side of equation (12) is the likelihood of the VAR data  $\mathbf{Y}_{1:T}$ . This likelihood contains information only about the reduced-form parameters  $\mathbf{\Phi}$  and  $\mathbf{\Sigma}$ . The second term, which is unique to BP-SVARs, is the conditional likelihood of the proxy  $\mathbf{M}_{1:T}$  given the VAR data  $\mathbf{Y}_{1:T}$ . As we show in Appendix A, this likelihood has the following form:

(13) 
$$\mathbf{M}_{1:T}|\mathbf{Y}_{1:T},\mathbf{A}_0,\mathbf{A}_+,\beta,\sigma_{\nu} \sim \mathcal{N}(\mu_{M|Y},\mathbf{V}_{M|Y}),$$

with

$$\mu_{M|Y} = \beta \mathbf{e}_{MP, \ 1:T} \quad \text{and} \quad \mathbf{V}_{M|Y} = \sigma_{\nu}^2 \mathbf{I}_T,$$

where  $\mu_{M|Y}$  and  $\mathbf{V}_{M|Y}$  are the mean and variance, respectively, associated with the multivariate normal distribution. Equation (13) reveals that the signal-to-noise ratio  $\beta/\sigma_{\nu}$  is crucial for identifying the coefficients of the SVAR. On the one hand, when  $\beta/\sigma_{\nu}$  is large,  $m_t$  provides a lot of information about  $e_{MP,t}$ . On the other hand, when  $\beta=0$ ,  $m_t$  is simply noise and provides no information about  $e_{MP,t}$ . Finally, when  $\beta/\sigma_{\nu}$  is close to zero, we have weak identification.

We can rewrite  $\mu_{M|Y}$  in terms of the systematic component of monetary policy by substituting the definition of  $\mathbf{e}_{MP, 1:T}$  implied by equation (5):

(14) 
$$\mu_{M|Y} = \beta [\mathbf{Y}_{1:T} \mathbf{A}'_{0,1} - \mathbf{X}_{1:T} \mathbf{A}'_{+,1}].$$

<span id="page-6-1"></span><span id="page-6-0"></span><sup>&</sup>lt;sup>5</sup> In this and what follows, we suppress any dependence on the initial conditions  $Y_{1-p:0}$  for convenience.

<sup>&</sup>lt;sup>6</sup> In case of weak identification, the prior plays an important role in inference. But in our framework comparing prior to posterior distributions, a standard diagnostic to detect identification issues, is trivial. The reason is that, as already shown by equation (12), when it comes to identification, the relevant prior distributions are those implied by the model before observing  $\mathbf{M}_{1:T}$  but after observing  $\mathbf{Y}_{1:T}$ . Finally, lack of identification or weak identification, which manifests itself in flat or nearly flat likelihood profiles, could pose practical issues when sampling the posterior.

As we see from equations (13) and (14), for given  $\beta$ , and  $\sigma_{\nu}$ , the econometrician updates the beliefs about the systematic component of monetary policy described by  $(\mathbf{A}_{0,1}, \mathbf{A}_{+,1})$  by giving relatively more weight to structural parameters that result in monetary policy shocks that look like a scaled version of the proxy.

### D. Specification of the Prior and Posterior Sampler

*Prior Distributions.*—The prior for the structural parameters  $(\mathbf{A}_0, \mathbf{A}_+)$ , which we describe in Appendix A, is based on a standard Minnesota Prior. For the parameters of the measurement equation (7), we choose the prior for  $\beta$  to be normally distributed with mean  $\mu_{\beta} = 0$  and variance  $\sigma_{\beta} = 1$ . The standard deviation of the measurement error,  $\sigma_{\nu}$ , is crucial because it determines the tightness of the relationship between the proxy and the SVAR model. For this reason we consider two types of priors for  $\sigma_{\nu}$ . Our baseline prior is an inverse Gamma with degrees of freedom  $s_1$  and centering coefficient  $s_2$ . We set  $s_1 = 2$  and  $s_2 = 0.02$  so that the prior is not very informative and, combined with our prior for  $\beta$ , implies that the posterior distribution of the relevance indicator overwhelmingly reflects the likelihood. The second prior for  $\sigma_{\nu}$ , which we refer to as the *high relevance prior*, places the dogmatic view that  $\sigma_{\nu} = 0.5 \times \mathrm{std}(\mathbf{M}_{1:T})$  with probability 1; that is, only half of the variation in our proxy can be attributed to measurement error. In our applications, this high relevance prior induces a substantially tighter relationship between the proxy and  $e_{MP,t}$  than under the baseline prior for  $\sigma_{\nu}$  at the cost of overall statistical fit, as the estimation becomes less reliant on the measurement error.

Posterior Sampler.—Our prior formulation does not admit a closed-form solution, so we rely on simulation methods to sample from the posterior. We offer two related algorithms to sample the posterior distribution of the BP-SVAR: a sequential Monte Carlo (SMC) algorithm and a Markov Chain Monte Carlo (MCMC) algorithm. The SMC algorithm has the advantage of being more robust when the posterior is irregular, such as with weakly informative proxies, and under the high-relevance prior; the MCMC algorithm works well with our baseline prior on  $\sigma_{\nu}$ , and is faster and closer to existing algorithms in the literature. We discuss both algorithms in the Appendix A.

### E. Advantages over Traditional Proxy SVARs

The BP-SVAR offers four advantages over the traditional implementation. Traditional proxy SVARs are typically estimated following a three-step procedure. First, estimate the reduced-form VAR by least squares. Second, regress the reduced-form residuals on the proxy. Third, impose the restrictions derived in the second stage to identify the SVAR model. First, a BP-SVAR makes efficient use of the information contained in the proxy. The joint likelihood described in equation (12) offers a coherent modeling of all sources of uncertainty and, hence, allows the proxy to inform the estimation of both reduced-form and structural parameters. By contrast, the three-stage procedure makes only limited

use of the information contained in the proxy, for instance, the estimation of the reduced-form VAR is not informed by the proxy  $m_t$ .

Second, in a Bayesian setting, weak identification does not pose a problem per se, as long as the prior distribution is proper, inference is possible (Poirier 1998). By contrast, the frequentist approach requires an explicit theory to work with weakly informative instruments, either to derive the asymptotic distributions of the estimators (Montiel Olea, Stock, and Watson 2012) or to ensure a good coverage in bootstrap algorithms.<sup>7</sup>

Third, we can adjust the informativeness of the proxy for the estimation of the parameters of the BP-SVAR model through prior distributions. Researchers construct proxies to be relevant, to contain a lot of information about the structural shock of interest, which is consistent with a prior view of a high degree of relevance  $\rho$ .<sup>8</sup> In our application, the benefit of using the high relevance prior is that the identified systematic component of monetary policy is associated with monetary shocks that more closely resemble the proxy than under the baseline prior at the cost of overall fit. This reflects the classic trade-off in econometrics between structural inference and statistical fit discussed in, for instance, Del Negro et al. (2007).

Fourth, the Bayesian framework is well suited for the estimation of large and richly parameterized models, particularly over the relatively short samples for which many proxies are available. Hence, BP-SVARs obviate the need to estimate the VAR part of the model over a longer sample, which implicitly requires additional assumptions about parameter stability. In Section V, we take advantage of this feature to explore multiple transmission channels of monetary policy.

### **II.** A Proxy for Monetary Policy Shocks

To construct our baseline proxy for monetary policy shocks, we apply the event study methodology developed in Kuttner (2001), which uses high-frequency financial data to construct monetary policy surprises associated with FOMC announcements. This methodology uses the price of federal funds futures contracts traded at the Chicago Board of Trade to measure market expectations about the Federal Reserve's policy actions. In our analysis, we use spot month contracts based on the current month funds rate.<sup>9</sup>

Our sample begins in January 1994, the year in which the FOMC started issuing statements immediately after each meeting. Prior to 1994, the FOMC did not issue a statement and changes to the target rate had to be inferred by the size and type of open market operations. Coibion and Gorodnichenko (2012) find an increase in the ability of financial markets and professional forecasters to predict subsequent

<span id="page-8-0"></span><sup>&</sup>lt;sup>7</sup>To the best of our knowledge, bootstrap algorithms developed to construct confidence intervals in proxy SVARs only apply to strong instruments. Moreover, Jentsch and Lunsford (2016) show that the choice of bootstrap algorithms can yield very different confidence intervals for impulse responses.

<span id="page-8-1"></span><sup>&</sup>lt;sup>8</sup>This feature is one major differentiation of our analysis from other Bayesian approaches, for example, Bahaj (2014) and Drautzburg (2016).

<span id="page-8-2"></span><sup>&</sup>lt;sup>9</sup>Gertler and Karadi (2015) use the three-month ahead contracts as their sample also includes the global financial crisis and the zero lower bound period.

interest rate changes after 1994, suggesting that improved transparency could have altered the transmission of policy surprises. <sup>10</sup> The sample ends in June 2007, three months before the FOMC started to rapidly cut interest rates at the onset of the global financial crisis. This conservative cutoff ensures that we do not capture the effects of unconventional monetary policy or the presence of the zero lower bound in our estimates.

At date  $\tau$ , the spot contract for the federal funds future in the current month pays out based on the average funds rate prevailing in that month. We measure the surprise component of the change in the target federal funds rate around FOMC announcements as follows:

(15) 
$$\Delta r_{\tau} = (E_{\tau}[r] - E_{\tau-\Delta}[r]) \times SF(\tau),$$

where  $E_{\tau}[r]$  is the federal funds rate expected by markets to prevail over the remainder of the month of the FOMC meeting *after* the announcement;  $E_{\tau-\Delta}[r]$  is the federal funds rate expected to prevail over the remainder of the month of the FOMC meeting *before* the announcement; and  $SF(\tau)$  is a scaling factor that accounts for the fact that these contracts trade on the average federal funds rate over the month, but FOMC meetings take place on different days within months. The surprise changes described by equation (15) are calculated only at FOMC-meeting frequency. We construct the monthly proxy  $m_{HF,t}$  by assigning each surprise change to the month in which the corresponding FOMC meeting occurred. If there are no meetings in a month, we record the shock as zero for that month.  $^{12}$ 

In our sample, there were 108 scheduled FOMC meetings, with 4 FOMC statements released after unscheduled FOMC meetings and phone calls. We exclude these unscheduled FOMC decisions from our analysis because, as discussed for instance in van Dijk, Lumsdaine, and van der Wel (2016), markets are caught by surprise by these announcements, and hence asset prices prior to the announcements do not reflect market expectations about that particular policy action. That is, asset prices do not reflect financial market expectations about the endogenous response of the Federal Reserve to the state of the economy.

The choice of  $\Delta$ , the window around the FOMC announcement, is crucial. Kuttner (2001) uses a daily window, but subsequent studies have shown that even the use of a daily window might not be enough to purge this policy measure from expected, and hence endogenous, movements. For this reason we follow Gürkaynak, Sack, and Swanson (2005) and Gilchrist, López-Salido, and Zakrajšek (2015) and use intraday data. In particular, we set  $\Delta$  to be a 30-minute window around the release of the FOMC statement (10 minutes before and 20 minutes after).

<span id="page-9-1"></span><span id="page-9-0"></span><sup>&</sup>lt;sup>10</sup> In any event, our qualitative results are robust to the inclusion in the sample of the early 1990s.

<sup>&</sup>lt;sup>11</sup> The rate of the spot contract can potentially reflect risk premia required by investors to hold the contract. The assumption underlying the identification strategy is that, by looking at the change in the futures rates over a narrow window, we are able to purge the risk premium and isolate the surprise change in the federal funds rate.

<span id="page-9-2"></span><sup>&</sup>lt;sup>12</sup> The conversion from FOMC frequency to monthly frequency follows Romer and Romer (2004). Moreover, and also in accordance with Romer and Romer (2004) and Nakamura and Steinsson (2013), because our series incorporates only policy changes associated with scheduled FOMC meetings, there are never two shocks in the same month.

The use of a narrow window and the exclusion of policy changes associated with unscheduled FOMC meetings does not necessarily ensure that the series of monetary surprises is exogenous. For instance, if, as shown by Romer and Romer (2000), the Federal Reserve has superior information compared with the private sector about the current and future state of the economy, the high frequency monetary surprises would partly capture the endogenous actions that the Federal Reserve takes in response to this private information. Miranda-Agrippino and Ricco (2017) argue that even within a narrow window, a predictable component remains embedded in monetary surprises computed using three-month ahead federal funds futures. We examined the predictability of our surprises, which are based on current month futures contract, and we do not find evidence of economically meaningful predictability over our sample period. In any event, the purging of the surprises does not affect any of the results in paper.

Finally, equation (15) also shows why we use  $m_{HF,t}$  only as a proxy and not as a direct measure of the monetary policy shock. Expectations about future policy actions derived from financial markets may not align with the SVAR-based expectations. The former are model-free expectations of market participants formed by combining information from a variety of sources with their judgment. The latter are deviations from the systematic component of monetary policy embedded in the SVAR. Nonetheless, the measurement equation (7) does not rule out an estimated BP-SVAR with  $e_{MP,t}$  closely resembling  $m_{HF,t}$ .

### III. Monetary Policy, Real Activity, and Credit Spreads

To show how monetary policy, real activity, and credit spreads interact in BP-SVARs, in this section we present results from two models. We first estimate a four-equation BP-SVAR that consists of the federal funds rate;  $^{13}$  the log of manufacturing industrial production (IP); the unemployment rate; and a measure of prices, the log of the producer price index (PPI) for finished goods. The selection of endogenous variables is similar to Coibion (2012) and Ramey (2016).  $^{14}$  The second model is a five-equation BP-SVAR that includes the Moody's seasoned Baa corporate bond yield relative to the yield on ten-year treasury constant maturity, which we refer to as the Baa spread. We select the tightness and decay parameters that govern the distribution of the Minnesota prior, as well as the VAR lag length p, using the marginal data density of the VAR using only the standard observables,  $\mathbf{Y}_{1:T}$ .

<span id="page-10-0"></span><sup>&</sup>lt;sup>13</sup> The monthly federal funds rate is the average effective rate over the last week of the month. All VAR results are robust to using the monthly average. Local projections are more sensitive to the measure of federal funds rate, but results are qualitatively robust. End-of-the-month data would ensure that the series responds to a policy change within a month irrespective of the FOMC meeting date, but the series is highly volatile due to technical factors in the overnight market; the monthly average of the effective rate is less affected by technical factors, but responds less within a month to policy decisions taken towards the end of the month. We strike a balance between these two extremes.

<span id="page-10-1"></span><sup>&</sup>lt;sup>14</sup> Results on the interaction among monetary policy, real activity, and corporate spreads are robust to using the consumer price index (CPI) instead of PPI. We use PPI because it is more informative for identifying the systematic response of monetary policy to prices and the response of prices to monetary policy shocks. By contrast, when using CPI, the posterior distribution of these objects are more sensitive to the choice of prior distributions.

![](_page_11_Figure_3.jpeg)

FIGURE 1. IMPULSE RESPONSES TO A MONETARY POLICY SHOCK

*Notes:* The solid line depicts the median impulse response of the specified variable to a one standard deviation monetary policy shock identified in the four-equation (left column) and in the five-equation (right column) BP-SVARs. Shaded bands denote the 90 percent pointwise credible sets.

The resulting specifications, which include a constant, are estimated on data from January 1994 to June 2007 using 12 lags. 15

## A. The Effect of Monetary Policy Shocks

The left column of Figure 1 displays the impulse responses of the endogenous variables to a one standard deviation monetary shock identified using the four-equation BP-SVAR. The solid lines show the pointwise median responses, while the shaded areas represent the corresponding 90-percent pointwise credible bands. Unless otherwise noted, the estimates discussed in the text refer

<span id="page-11-0"></span><sup>&</sup>lt;sup>15</sup> We use data from January 1990 to December 1993 as a training sample for the Minnesota prior.

to posterior medians. The near-term effect of a positive monetary policy shock causes the federal funds rate to increase about 25 basis points, a number within conventional estimates. Thereafter, the federal funds rate slowly falls, returning to zero after approximately two years. There is no evidence that the shock has any effect on IP or on the unemployment rate. Similarly, prices are not affected over the first year, although there is some evidence that they fall over a longer horizon. Overall, the results from the four-equation BP-SVAR echo Ramey (2016), who finds no evidence of contractionary effects of monetary policy during the Great Moderation period.

The right column of Figure 1 displays the impulse responses to a one standard deviation monetary policy shock identified using the BP-SVAR that includes the Baa spread. The impact responses of the federal funds rate, IP, the unemployment rate, and prices, are nearly identical to those in the four-equation model. By contrast, the two models display strikingly different dynamics. The federal funds rate falls quickly after the shock and turns negative—monetary policy becomes more accommodative, relative to its initial level—after about one year. This change in monetary policy stance can be explained by inspecting the real and financial consequences of the shock. The effect of the shock on real activity is large. Two years after the shock, IP has fallen about 0.4 percent and the unemployment rate has increased 5 basis points. The decline in prices is persistent and exhibits a modest hump-shape. In addition, monetary policy causes a long-lasting tightening in financial conditions, with Baa spread jumping about five basis points on impact and remaining elevated for more than two years.

Using the VAR structure, we can decompose the forecast error of the VAR along different horizons, attributing portions of the error variance to monetary shocks. The left column of [Figure 2](#page-13-0) displays these quantities for the monetary shock identified in the four-equation model, while the right column displays these quantities for the monetary shock identified in the five-equation model. Concentrating on the horizons associated with business cycle frequencies—that is, 12 to 36 months we see that in the four equation model, the monetary policy shock explains a negligible fraction of short-run movements in IP and unemployment, in line with the conventional wisdom that monetary policy does not contribute to business cycle fluctuations. In the five equation BP-SVAR, monetary policy accounts for about 20 percent of the fluctuations in IP and in the unemployment rate and for about 25 percent of the fluctuations in corporate credit spreads. We note, though, the posterior uncertainty surrounding these estimates is large.[16](#page-12-0)

# B. *The Systematic Component of Monetary Policy*

In the previous section, we showed that corporate credit spreads are an important variable to characterize the transmission of monetary policy. In this section, we study how monetary policy responds to changes in corporate spreads by inspecting the estimated elasticities associated with the systematic component of monetary policy.

<span id="page-12-0"></span><sup>16</sup>The uncertainty bands associated with forecast error variance decompositions also do not take into account the direction of the impulse responses, which is why in our discussion we focus on the posterior median estimates.

<span id="page-13-0"></span>![](_page_13_Figure_3.jpeg)

FIGURE 2. CONTRIBUTION OF MONETARY POLICY SHOCKS TO THE FORECAST ERROR VARIANCE

*Notes:* The solid line depicts the median estimate of the portion of the forecast error variance of a specified variable attributable to a one standard deviation monetary policy shock identified in the four-equation (left column) and in the five-equation (right column) BP-SVARs. Shaded bands denote the 90 percent pointwise credible sets.

For ease of exposition, we refer to the elasticity of the federal funds rate to variable j at lag l,  $\psi_{l,j}$ , defined in equation (6), using the following subscripts: cs (Baa spread),  $\pi$  (prices),  $\Delta y$  (IP), u (unemployment rate), and r (federal funds rate). Panel A of Table 1 reports the contemporaneous elasticities of the federal funds rate to the non-policy variables included in the system. Panel B of Table 1 reports the cumulative elasticities of the federal funds rate to all variables in the system. These coefficients represent the response of the federal funds rate to a unit change in the variable in question, if all other variables remained constant. The cumulative elasticities are defined as follows:

$$\psi_{cs} = \sum_{\ell=0}^{p} \psi_{\ell,cs}, \quad \psi_{\pi} = \sum_{\ell=0}^{p} \sum_{i=0}^{\ell} \psi_{i,\pi}, \quad \psi_{\Delta ip} = \sum_{\ell=0}^{p} \sum_{i=0}^{\ell} \psi_{i,\Delta ip},$$

$$\psi_{u} = \sum_{\ell=0}^{p} \psi_{\ell,u}, \quad \text{and} \quad \psi_{r} = \sum_{\ell=1}^{p} \psi_{\ell,r},$$

TABLE 1—COEFFICIENTS IN THE MONETARY POLICY EQUATION

<span id="page-14-0"></span>

|                                       | Four-equation BP-SVAR  | Five-equation BP-SVAR     |
|---------------------------------------|------------------------|---------------------------|
| Panel A. Contemporaneous elasticities |                        |                           |
| $\psi_{0,cs}$                         |                        | -1.18 [-3.11, -0.35]      |
| $\psi_{0,\pi}$                        | 0.10<br>[-0.08, 0.33]  | 0.13 [-0.11, 0.37]        |
| $\psi_{0,\Delta_{\mathrm{y}}}$        | 0.06 [ $-0.11, 0.27$ ] | $ 0.03 \\ [-0.15, 0.25] $ |
| $\psi_{0,u}$                          | 0.22<br>[-0.64, 1.19]  | 0.23<br>[-0.67, 1.38]     |
| Panel B. Cumulative elasticities      |                        |                           |
| $\psi_{cs}$                           |                        | -0.22 [-0.35, -0.09]      |
| $\psi_\pi$                            | 0.15<br>[-0.15, 0.52]  | $ 0.13 \\ [-0.12, 0.39] $ |
| $\psi_{\Delta_y}$                     | 0.35<br>[0.06, 0.67]   | 0.06<br>[-0.14, 0.32]     |
| $\psi_u$                              | -0.01 [-0.09, 0.06]    | -0.06 [-0.16, 0.04]       |
| $\psi_r$                              | 0.97<br>[0.94, 1.01]   | 0.96<br>[0.92, 1.01]      |

*Notes:* The entries in the table denote the posterior median estimates of the contemporaneous elasticities (panel A) and the cumulative elasticities (panel B) in the monetary equation identified in the four-equation (column 1) and in the five-equation (column 2) BP-SVARs. The 90 percent credible sets from the posterior distributions are reported in brackets. See the main text for details.

where, the cumulative elasticities  $\psi_{\Delta y}$  and  $\psi_{\pi}$  describe the response of the federal funds rate to the change in output and prices, respectively. We stress that our cumulative coefficients are not directly comparable to those in Sims and Zha (2006), who compute so-called *long-run* coefficients. Their calculations involve dividing the sum of coefficients for the non-policy variables by  $1-\psi_r$ , one minus the cumulative coefficient for the policy variable. As we see next, some of our draws imply that  $\psi_r \geq 1$ , and for these draws the long-run coefficients are not well defined.

Column 1 of Table 1 tabulates the elasticities identified in the BP-SVAR that excludes the Baa spread. In accordance to conventional wisdom, the median estimates of both the contemporaneous and cumulative elasticities of the federal funds rate to monthly changes in output and prices are positive. The cumulative elasticity to unemployment is negative but economically insignificant. Overall, there is a high amount of uncertainty surrounding these estimates; with the exception of  $\psi_{\Delta ip}$ , 0 is well contained in the 90 percent credible set. The degree of policy inertia implied by this rule is high, with a posterior median estimate for  $\psi_r$  of 0.97. The estimated monetary policy rule implies that, for a non-trivial number of posterior draws,  $\psi_r \geq 1$ , and hence the rule is super-inertial.

Column 2 tabulates the elasticities identified in the BP-SVAR that includes the Baa spread. <sup>17</sup> The median estimate of the contemporaneous response to corporate spreads

<span id="page-14-1"></span><sup>&</sup>lt;sup>17</sup> Density plots of these elasticities are available in Figure 2 of the online Appendix.

is about -1, while the cumulative elasticity is -0.2. In other words, a one standard deviation surprise increase in corporate credit spreads, approximately ten basis points, all else being equal, elicits an immediate monetary policy accommodation of about ten basis points and a cumulative response of about four basis points. Moreover, the 90 percent bands for  $\psi_{0,\,cs}$  and  $\psi_{cs}$  do not contain zero, where the prior is centered, indicating that this countercyclical response of monetary policy to corporate spreads is identified by the data.

The elasticities of the federal funds rate to prices, output, and the unemployment rate evaluated at the posterior median are also consistent with countercyclical monetary policy. The median long-run coefficient on inflation is 2.51, in line with the conventional wisdom that a Taylor-type rule describes monetary policy during the Great Moderation period though, as discussed earlier, the tails of the distribution of this object are distorted by the portion of the posterior distribution where  $\psi_r \geq 1$ . When we condition on draws from the posterior that satisfy  $\psi_r < 1$ , the median long-run coefficient on inflation becomes 2.81, and the impulse responses are nearly identical to those reported in Figure 1.

Nonetheless, the considerable uncertainty about these elasticities means that in a non-trivial region of the parameter space, monetary policy does not stabilize real activity and prices, which could cast doubt about the overall reliability of our identification strategy. In Section IIID, we show that, under the high-relevance prior, the posterior probability associated with "counterfactual" elasticities vanishes, corroborating the finding that, in addition to stabilizing movements in output and prices, monetary policy also stabilizes changes in financial conditions by directly responding to changes in corporate spreads. <sup>18</sup>
