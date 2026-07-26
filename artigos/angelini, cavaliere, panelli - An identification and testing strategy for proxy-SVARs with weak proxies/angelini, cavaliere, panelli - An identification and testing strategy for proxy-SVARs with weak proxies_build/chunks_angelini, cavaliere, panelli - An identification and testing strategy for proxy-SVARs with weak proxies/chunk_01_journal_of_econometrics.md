Contents lists available at [ScienceDirect](https://www.elsevier.com/locate/jeconom)

# Journal of Econometrics

journal homepage: [www.elsevier.com/locate/jeconom](http://www.elsevier.com/locate/jeconom)

![](_page_0_Picture_5.jpeg)

![](_page_0_Picture_6.jpeg)

# An identification and testing strategy for proxy-SVARs with weak proxies

Giovanni Angelini [a](#page-0-0) , Giuseppe Cavaliere [a](#page-0-0),[b](#page-0-1),[∗](#page-0-2) , Luca Fanelli [a](#page-0-0)

- <span id="page-0-0"></span><sup>a</sup> *Department of Economics, University of Bologna, Italy*
- <span id="page-0-1"></span><sup>b</sup> *Department of Economics, University of Exeter Business School, UK*

# A R T I C L E I N F O

### *JEL classification:*

C32

C51

C52

E44

*Keywords:* Proxy-SVAR Bootstrap inference External instruments Identification Oil supply shock

# A B S T R A C T

When proxies (external instruments) used to identify target structural shocks are weak, inference in proxy-SVARs (SVAR-IVs) is nonstandard and the construction of asymptotically valid confidence sets for the impulse responses of interest requires weak-instrument robust methods. In the presence of multiple target shocks, test inversion techniques require extra restrictions on the proxy-SVAR parameters other than those implied by the proxies that may be difficult to interpret and test. We show that frequentist asymptotic inference in these situations can be conducted through Minimum Distance estimation and standard asymptotic methods if the proxy-SVAR can be identified by using 'strong' instruments for the *non-target shocks*; i.e., the shocks which are not of primary interest in the analysis. The suggested identification strategy hinges on a novel pretest for the null of instrument relevance, based on bootstrap resampling, which is not subject to pre-testing issues. Specifically, the validity of post-test asymptotic inferences remains unaffected by the test outcomes due to an asymptotic independence result between the bootstrap and nonbootstrap statistics. The test is robust to conditionally heteroskedastic and/or zero-censored proxies, is computationally straightforward and applicable regardless of the number of shocks being instrumented. Some illustrative examples show the empirical usefulness of the suggested identification and testing strategy.

## **1. Introduction**

Proxy-SVARs, or SVAR-IVs, popularized by [Stock](#page-17-0) [\(2008](#page-17-0)), [Stock and Watson](#page-17-1) [\(2012](#page-17-1), [2018\)](#page-17-2) and [Mertens and Ravn](#page-17-3) [\(2013](#page-17-3)), have become standard tools to track the dynamic causal effects produced by macroeconomic shocks on variables of interest. In proxy-SVARs, the model is complemented with 'external' variables – which we call 'proxies', 'instruments' or 'external variables' interchangeably; such variables carry information on the structural shocks of interest, the *target shocks*, and allow to disregard the structural shocks not of primary interest in the analysis, the *non-target shocks*. Recent contributions on frequentist inference in proxy-SVARs include [Montiel Olea et al.](#page-17-4) ([2021\)](#page-17-4) and [Jentsch and Lunsford](#page-17-5) ([2022\)](#page-17-5); in the Bayesian framework, [Arias et al.](#page-17-6) [\(2021](#page-17-6)) and [Giacomini et al.](#page-17-7) [\(2022](#page-17-7)) discuss inference in the case of set-identification.

Inference in proxy-SVARs depends on whether the proxies are strongly or weakly correlated with the target shocks. If the connection between the proxies and the target shocks is 'local-to-zero', as in [Staiger and Stock](#page-17-8) ([1997\)](#page-17-8) and [Stock and Yogo](#page-17-9) [\(2005](#page-17-9)), asymptotic inference is non-standard. In such case, weak-proxy robust methods can be obtained by extending the logic of Anderson– Rubin tests [\(Anderson and Rubin](#page-17-10), [1949\)](#page-17-10), see [Montiel Olea et al.](#page-17-4) ([2021\)](#page-17-4). Grid Moving Block Bootstrap Anderson–Rubin confidence

<span id="page-0-2"></span><sup>∗</sup> Correspondence to: Department of Economics, University of Bologna, Piazza Scaravilli 2, 40126 Bologna, Italy. *E-mail address:* [giuseppe.cavaliere@unibo.it](mailto:giuseppe.cavaliere@unibo.it) (G. Cavaliere).

sets ('grid MBB AR') for normalized impulse response functions [IRFs] ([Brüggemann et al.,](#page-17-11) [2016;](#page-17-11) [Jentsch and Lunsford](#page-17-12), [2019\)](#page-17-12) can also be applied in the special case where one proxy identifies one structural shock; see [Jentsch and Lunsford](#page-17-5) ([2022\)](#page-17-5).

When proxy-SVARs feature multiple target shocks, further inferential difficulties arise. First, (point-)identification requires additional restrictions, other than those provided by the instruments; see [Mertens and Ravn](#page-17-3) ([2013\)](#page-17-3), [Angelini and Fanelli](#page-17-13) ([2019\)](#page-17-13), [Arias et al.](#page-17-6) ([2021\)](#page-17-6), [Montiel Olea et al.](#page-17-4) ([2021\)](#page-17-4) and [Giacomini et al.](#page-17-7) [\(2022](#page-17-7)). Second, in the frequentist setup the implementation of weak-instrument robust inference as in [Montiel Olea et al.](#page-17-4) ([2021\)](#page-17-4) may imply a large number of additional restrictions on the parameters of the proxy-SVAR relative to those needed under strong proxies. These extra restrictions are not always credible, and may be difficult to test; see [Montiel Olea et al.](#page-17-4) [\(2021](#page-17-4), Section A.7) and Section S.9 of our supplement.[1](#page-1-0) Fourth, the theory for the grid bootstrap Anderson–Rubin confidence sets does not extend to cases where multiple instruments identify multiple target shocks.

<span id="page-1-0"></span>This paper is motivated by these inferential difficulties. In particular, we design an identification and (frequentist) estimation strategy intended to circumvent, when possible, the use of weak-instrument robust methods. The idea we pursue is to identify the proxy-SVAR through an 'indirect' approach, where a vector of proxies (say, ), correlated with (all or some of) the non-target shocks of the system and uncorrelated with the target shocks (say, ), is used to infer the IRFs of interest indirectly. We call this strategy 'indirect identification strategy' or 'indirect-MD' approach, as opposed to the conventional 'direct' approach based on instrumenting the target shock(s) directly with the (potentially weak) proxies . As highlighted by our empirical illustrations, the indirect approach can prove more useful to a practitioner than one might think.

The proxies contribute to defining a set of moment conditions upon which we develop a novel Minimum Distance [MD] estimation approach [\(Newey and McFadden](#page-17-14), [1994](#page-17-14)). We derive novel necessary order conditions and necessary and sufficient rank conditions for the (local) identifiability of the proxy-SVAR. If the proxies are strong for the non-target shocks and the model is identified, asymptotically valid confidence intervals for the IRFs of interest obtain in the usual way; i.e., either by the delta-method or by bootstrap methods. Interestingly, the idea of using instruments for the non-target shocks to identify and infer the effects of structural shocks of interest was initially pursued via Bayesian methods in [Caldara and Kamps](#page-17-15) ([2017\)](#page-17-15), where two fiscal (target) shocks are recovered by instrumenting the non-fiscal (non-target) shocks of the system. We defer to Section [5](#page-4-0) a detailed comparison of our method with [Caldara and Kamps](#page-17-15) ([2017\)](#page-17-15).

Key to the indirect identification strategy is the availability of strong proxies for the non-target shocks. In particular, it is essential that the investigator can screen 'strong' from 'weak' instruments, and that such screening does not affect post-test inference. To do so, we further contribute by designing a novel pre-test for strong against weak proxies based on bootstrap resampling.

Inspired by the idea originally developed in [Angelini et al.](#page-17-16) ([2022\)](#page-17-16) for state-space models, we show that the bootstrap can be used to infer the strength of instruments, other than building valid confidence intervals for IRFs. In particular, we exploit the fact that under mild requirements, the MBB estimator of the proxy-SVAR parameters is asymptotically Gaussian when the instruments are strong while, under weak proxies à la [Staiger and Stock](#page-17-8) [\(1997](#page-17-8)), the distribution of MBB estimator is random in the limit (in the sense of [Cavaliere and Georgiev,](#page-17-17) [2020\)](#page-17-17) and, in particular, is non-Gaussian. This allows to show that a test for the null of strong proxies can be designed as a normality test based on an appropriate number of bootstrap repetitions; such test is consistent against proxies which are weak as in [Staiger and Stock](#page-17-8) [\(1997](#page-17-8)). An idea that echoes this approach in the Bayesian setting can be found in [Giacomini](#page-17-7) [et al.](#page-17-7) ([2022\)](#page-17-7), who suggest using non-normality of the posterior distribution of a suitable function of proxy-SVAR parameters to diagnose the presence of weak proxies. This idea is not pursued further in their paper.

<span id="page-1-1"></span>Our suggested test has several important features. First, it controls size under general conditions on VAR disturbances and proxies, including the case of conditional heteroskedasticity and/or zero-censored proxies. Second, with respect to extant tests such as [Montiel Olea and Pflueger'](#page-17-18)s [\(2013](#page-17-18)) effective first-stage F-test for IV models with conditional heteroskedasticity,[2](#page-1-1) our test can be applied in the presence of multiple structural shocks; as far as we are aware, no test of strength for proxy-SVARs with multiple target shocks has been formalized in the literature. Third, it is computationally straightforward, as it boils down to running multivariate/univariate normality tests on the MBB replications of bootstrap estimators of the proxy-SVAR parameters. Fourth, it can be computed in the same way regardless of the number of shocks being instrumented. Fifth, and most importantly, the test does not affect second-stage inference, meaning that regardless of the outcome of the test, post-test inferences are not affected. This property marks an important difference relative to the literature on weak instrument asymptotics, where the negative consequences of pretesting the strength of proxies are well known and documented (see, *inter alia*, [Zivot et al.,](#page-17-19) [1998](#page-17-19); [Hausman et al.](#page-17-20), [2005;](#page-17-20) [Andrews et al.](#page-17-21), [2019](#page-17-21); [Montiel Olea et al.,](#page-17-4) [2021\)](#page-17-4).

The paper is organized as follows. In Section [2](#page-2-0) we motivate our approach with a simple illustrative example. In Section [3](#page-2-1) we introduce the proxy-SVAR and rationalize the suggested identification strategy. The assumptions are summarized in Section [4,](#page-3-0) while we present our indirect-MD approach in Section [5](#page-4-0). Section [6](#page-6-0) deals with the novel approach to testing for strong proxies. To illustrate the practical implementation and relevance of our approach, we present in Section [7](#page-12-0) two illustrative examples that reconsider models already estimated in the literature. Section [8](#page-16-0) concludes. An accompanying supplement complements the paper along several dimensions, including auxiliary lemmas and their proofs, the proofs of the propositions in the paper and an additional empirical illustration based on a fiscal proxy-SVAR.

<sup>1</sup> From the perspective of Bayesian inference, one can in principle make the usual argument that weak identification issues do not matter. For instance, [Caldara and Herbst](#page-17-22) ([2019\)](#page-17-22) discuss how it is still possible to obtain numerical approximations of the exact finite-sample posterior distributions of the parameters of proxy-SVARs when instruments are weak. [Giacomini et al.](#page-17-7) [\(2022\)](#page-17-7) show that for set-identified proxy-SVARs with weak instruments, the Bernstein–von Mises property fails for the estimation of the upper and lower bonds of the identified set.

<sup>2</sup> See [Montiel Olea et al.](#page-17-4) [\(2021](#page-17-4)) for an overview on first-stage regressions in proxy-SVARs or, alternatively, [Lunsford](#page-17-23) ([2016\)](#page-17-23) for tests based on regressing the proxy on the reduced-form residuals.

#### 2. Motivating example: A market (demand/supply) model

<span id="page-2-0"></span>In this section we outline the main ideas in the paper by considering a 'toy' proxy-SVAR, where we omit the dynamics without loss of generality. We consider a model that comprises a demand and supply function for a good with associated structural shocks, given by the equations

<span id="page-2-2"></span>
$$\underbrace{\begin{pmatrix} q_t \\ p_t \end{pmatrix}}_{Y} = \underbrace{\begin{pmatrix} \beta_{1,1} & \beta_{1,2} \\ \beta_{2,1} & \beta_{2,2} \end{pmatrix}}_{R} \underbrace{\begin{pmatrix} \varepsilon_{d,t} \\ \varepsilon_{s,t} \end{pmatrix}}_{\varepsilon} \equiv \begin{pmatrix} \beta_{1,1}\varepsilon_{d,t} + \beta_{1,2}\varepsilon_{s,t} \\ \beta_{2,1}\varepsilon_{d,t} + \beta_{2,2}\varepsilon_{s,t} \end{pmatrix} \tag{1}$$

where  $q_t$  and  $p_t$  are quantity and price at time t, respectively. The nonsingular matrix B captures the instantaneous impact on  $Y_t := (q_t, p_t)'$  of the structural shocks  $\varepsilon_{d,t}, \varepsilon_{s,t}$ , which are assumed to have unit variance and to be uncorrelated. We temporary (and conventionally) label  $\varepsilon_{d,t}$  as the 'demand shock' and  $\varepsilon_{s,t}$  as the 'supply shock', and assume that the objective of the analysis is the identification and estimation of the instantaneous impact of the *demand shock* on  $Y_t$  through the 'external variables' approach. Hence,  $\varepsilon_{d,t}$  is the *target* shock,  $\varepsilon_{s,t}$  is the *non-target* shock, and the parameters of interest are the on-impact responses  $\frac{\partial Y_t}{\partial \varepsilon_{d,t}} = B_{\bullet 1} := (\beta_{1,1}, \beta_{2,1})'$ ; here  $B_{\bullet 1}$  denotes the first column of B.

Since the two equations in (1) are essentially identical for arbitrary parameter values, nothing distinguishes a demand shock from a supply shock in the absence of further information/restrictions. The typical 'direct approach' to this partial identification problem is to consider an instrument  $z_t$  correlated with the demand shock,  $E(z_t \varepsilon_{d,t}) = \phi \neq 0$  (relevance condition), and uncorrelated with the supply shock,  $E(z_t \varepsilon_{s,t}) = 0$  (exogeneity condition). Now, consider the case where the investigator strongly suspects that  $z_t$  is a weak proxy (meaning that  $\phi$  can be 'small'), but they also know that there exists an external variable  $w_t$ , correlated with the non-target supply shock and uncorrelated with the demand shock; formally,  $E(w_t \varepsilon_{s,t}) = \lambda \neq 0$  and  $E(w_t \varepsilon_{d,t}) = 0$ . Then, the proxy  $w_t$  can be used to recover the parameters of interest in  $B_{*1}$  'indirectly'; i.e., by instrumenting the non-target supply shock  $\varepsilon_{s,t}$ , rather than the target demand shock  $\varepsilon_{d,t}$ . To show how, let  $A := B^{-1}$  and consider the alternative representation of (1):

$$\underbrace{\begin{pmatrix} \alpha_{1,1} & \alpha_{1,2} \\ \alpha_{2,1} & \alpha_{2,2} \end{pmatrix}}_{A} \underbrace{\begin{pmatrix} q_t \\ p_t \end{pmatrix}}_{Y} = \begin{pmatrix} A_1 \cdot Y_t \\ A_2 \cdot Y_t \end{pmatrix} = \underbrace{\begin{pmatrix} \varepsilon_{d,t} \\ \varepsilon_{s,t} \end{pmatrix}}_{\varepsilon_{s,t}},$$

where  $A_{1\bullet} := (\alpha_{1,1}, \alpha_{1,2})$  and  $A_{2\bullet}$  denote the first row and the second row of A, respectively. Since  $w_t$  is correlated with  $p_t$  but uncorrelated with  $\epsilon_{d,t}$ , it is seen that for  $\alpha_{11} \neq 0$ ,  $w_t$  can be used in the equation:

$$q_t = -\frac{\alpha_{1,2}}{\alpha_{1,1}} p_t + \frac{1}{\alpha_{1,1}} \varepsilon_{d,t}$$

as an instrument for  $p_t$  in order to estimate the parameters in  $A_{1.}$ , that is,  $\alpha_{1,1}$  and  $\alpha_{1,2}$ . This delivers an 'estimate' of the demand shock,  $\hat{\epsilon}_{d,t} = \hat{A}_{1.}Y_t = \hat{\alpha}_{1.1}q_t + \hat{\alpha}_{1.2}p_t$  (t = 1, ..., T). Finally, since (1) and  $A = B^{-1}$  jointly imply  $B = \Sigma_u A'$ , it holds that

<span id="page-2-4"></span>
$$B_{s1} = \Sigma_{s} A_{s}^{\prime} \tag{2}$$

where  $\Sigma_u := E(Y_t Y_t')$  can be estimated (e.g., by its sample analog,  $\hat{\Sigma}_u := T^{-1} \sum_{t=1}^T Y_t Y_t'$ ) under mild requirements. Hence, an indirect plug-in estimator of the parameters of interest  $B_{\bullet 1}$  is given by  $\hat{B}_{\bullet 1} := \hat{\Sigma}_u \hat{A}_{1\bullet}'$ . If the instrument  $w_t$  is a 'strong' proxy for the supply shock, in the sense formally defined in Section 4, standard asymptotic inference on  $B_{\bullet 1}$  can then be performed using  $\hat{B}_{\bullet 1}$ .

This toy example shows that strong proxies for the non-target shocks, provided they exist, can be used to infer the causal effects of the target shocks indirectly, in a partial identification logic. Importantly, the investigator can strategically exploit the fact that if the proxies  $z_t$  available for the target shock are 'weak', the use of weak-instrument robust methods for the parameters of interest ( $B_{*1}$  in this example) can be circumvented if they can alternatively rely on strong proxies  $w_t$  for the non-target shocks.

In the following, we assume that there exist proxies  $w_t$  for the non-target shocks that might be alternatively used instead of the (potentially weak) proxies  $z_t$  available for the target structural shocks. The strength of  $w_t$  is a key ingredient of this strategy; hence, in Section 6 we present our novel pre-test of relevance, which consistently detects proxies which are weak in the sense of Staiger and Stock (1997). Since, as we show, the test does not affect post-test inferences, if the null of relevance is not rejected, inference based on  $w_t$  can be conducted by standard methods with no need for Bonferroni-type adjustments. In contrast, should the null of relevance be rejected, the investigator can rely on weak-instrument robust methods based either on the proxies  $z_t$ , if the target shocks are instrumented, or on the proxies  $w_t$  if the non-target shocks are instrumented.

# 3. Model and identification strategies

<span id="page-2-1"></span>Consider the SVAR model:

<span id="page-2-3"></span>
$$Y_t = \Pi X_t + u_t, \quad u_t = B\varepsilon, \quad (t = 1, \dots, T) \tag{3}$$

where  $Y_t$  is the  $n \times 1$  vector of endogenous variables,  $X_t := (Y'_{t-1}, \dots, Y'_{t-l})'$  collects l lags of the variables,  $\Pi := (\Pi_1, \dots, \Pi_l)$  is the  $n \times nl$  matrix containing the autoregressive (slope) parameters, and  $u_t$  is the  $n \times 1$  vector of reduced form disturbances with covariance matrix  $\Sigma_u := E(u_t u'_t)$ . Deterministic terms have been excluded without loss of generality, and the initial values  $Y_0, \dots, Y_{1-l}$  are fixed in the statistical analysis. The system of equations  $u_t = B\varepsilon_t$  in (3) defines the reduced form disturbances  $u_t$  in terms of the  $n \times 1$  vector

of structural shocks,  $\epsilon_l$ , through the nonsingular  $n \times n$  matrix B of on-impact coefficients. The structural shocks are normalized such that  $\Sigma_{\epsilon} := E(\epsilon_l \epsilon_l') = I_n$ .

We partition the structural shocks as  $\varepsilon_t := (\varepsilon'_{1,t}, \varepsilon'_{2,t})'$ , where  $\varepsilon_{1,t}$  collects the  $1 \le k < n$  target structural shocks, and  $\varepsilon_{2,t}$  collects the remaining n - k structural shocks of the system. We have

<span id="page-3-4"></span>
$$u_{t} = \begin{pmatrix} u_{1,t} \\ u_{2,t} \end{pmatrix} = \begin{pmatrix} B_{1,1} & B_{1,2} \\ B_{2,1} & B_{2,2} \end{pmatrix} \begin{pmatrix} \varepsilon_{1,t} \\ \varepsilon_{2,t} \end{pmatrix} \equiv B_{\bullet 1} \varepsilon_{1,t} + B_{\bullet 2} \varepsilon_{2,t}$$

$$\tag{4}$$

where  $u_{1,t}$  and  $u_{2,t}$  have the same dimensions as  $\varepsilon_{1,t}$  and  $\varepsilon_{2,t}$ , respectively, and  $B_{\bullet 1} := (B'_{1,1}, B'_{2,1})'$  is the  $n \times k$  matrix collecting the on-impact coefficients associated with the target structural shocks ( $B_{1,1}$  and  $B_{2,1}$  are  $k \times k$  and  $(n-k) \times k$  blocks, respectively). Finally, the  $n \times (n-k)$  matrix  $B_{\bullet 2}$  collects the instantaneous impact of the non-target shocks on the variables. We are interested in the k period ahead responses of the kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in kth variable in k

<span id="page-3-2"></span><span id="page-3-1"></span>
$$\gamma_{\bullet j}(h) := (S_n' C_v^h S_n) B_{\bullet 1} e_{k,j}, \tag{5}$$

where  $C_y$  is the VAR companion matrix,  $S_n := (I_n, 0_{n \times n(l-1)})$  is a selection matrix and  $e_{k,j}$  is the  $k \times 1$  vector containing '1' in the jth position and zero elsewhere.

The common, 'direct' approach to infer the parameters of interest in  $B_{*1}$  and hence solve the partial identification problem arising from the estimation of the IRFs in (5) is to find  $r \ge k$  observable proxies, collected in the vector  $z_t$ , correlated with the target shocks  $\varepsilon_1$ , and uncorrelated with  $\varepsilon_2$ ,. Thus,  $z_t$  is related to  $\varepsilon_1$ , by the linear measurement system

<span id="page-3-3"></span>
$$z_t = \Phi \epsilon_{1,t} + \omega_{z,t} \tag{6}$$

where the matrix  $\Phi := E(z_t \varepsilon_{1,t}')$  captures the link between the proxies  $z_t$  and the target shocks  $\varepsilon_{1,t}$ ;  $\omega_{z,t}$  is a measurement error, assumed to be uncorrelated with the structural shocks  $\varepsilon_t$ . By combining (6) with (4) and taking expectations, one obtains the moment conditions

<span id="page-3-5"></span>
$$\Sigma_{\mu,\tau} = B_{s,1} \Phi' \tag{7}$$

where  $\Sigma_{u,z} := E(u_t z_t')$  is the  $n \times r$  covariance matrix between  $u_t$  and  $z_t$ . Stock (2008), Stock and Watson (2012, 2018) and Mertens and Ravn (2013) exploit the moment conditions in (7) as starting point for the identification of the IRFs in (5).

Alternatively, as shown in the example in Section 2, the IRFs in (5) can be identified by and 'indirect approach', where a vector of proxies  $w_t$  are used to instrument the non-target shocks. Specifically, for  $A = B^{-1}$ , model (3) can be expressed in the form:

$$AY_t = YX_t + \varepsilon_t, \quad Au_t = \varepsilon_t \quad (t = 1, \dots, T)$$
(8)

where  $Y := A\Pi$  and A summarizes the simultaneous relationships that characterize the observed variables. The system of equations  $Au_t = \varepsilon_t$  can then be partitioned as

<span id="page-3-6"></span>
$$Au_t \equiv \begin{pmatrix} A_{1,u}u_t \\ A_{2,u}u_t \end{pmatrix} \equiv \begin{pmatrix} A_{1,1}u_{1,t} + A_{1,2}u_{2,t} \\ A_{2,1}u_{1,t} + A_{2,2}u_{2,t} \end{pmatrix} = \begin{pmatrix} \varepsilon_{1,t} \\ \varepsilon_{2,t} \end{pmatrix}$$

$$\tag{9}$$

where the  $k \times n$  matrix  $A_{1.} := (A_{1,1}, A_{1,2})$  collects the first k rows of A, and  $A_{2.}$  the remaining n - k rows. The VAR disturbances  $u_{1,t}$  and  $u_{2,t}$  have the same dimension as  $\varepsilon_{1,t}$  and  $\varepsilon_{2,t}$ , respectively. Under identifying restrictions on  $A_{1.}$ , the term  $\varepsilon_{1,t}$  in Eq. (9) can be interpreted as the structural shocks of a simultaneous system of equations à la Leeper et al. (1996).

Using the SVAR representation (9), we can infer the parameters in  $A_1$ , by exploiting the vector of external proxy variables  $w_t$ , correlated with (all or some of) the non-target shocks  $\varepsilon_{2,t}$  and uncorrelated with the target shocks  $\varepsilon_{1,t}$ . In Section 5 we discuss in detail how the parameters in  $A_1$ , can be identified by using  $w_t$  through a MD approach; the estimation of  $B_{\bullet 1}$  and the IRFs (5) follow indirectly, as in (2), from the relation  $B_{\bullet 1} = \Sigma_u A_1'$ .

The next section states the assumptions behind our estimation approach and qualifies the concepts of strong/weak proxies we refer to throughout the paper.

#### 4. Assumptions and asymptotics

<span id="page-3-0"></span>Our first two main assumptions pertain to the reduced form VAR.

<span id="page-3-7"></span>**Assumption 1** (*Reduced Form, Stationarity*). The data generating process (DGP) for  $Y_t$  satisfies (3) with a stable companion matrix  $C_v$ ; i.e., all eigenvalues of  $C_v$  lie inside the unit disk.

<span id="page-3-8"></span>Assumption 2 (Reduced Form, VAR Innovations). The VAR disturbances satisfy the following conditions:

- (i)  $\{u_t\}$  is a strictly stationary weak white noise;
- (ii)  $E(u_t u_t') = \Sigma_u < \infty$  is positive definite;
- (iii)  $\{u_t\}$  satisfies the  $\alpha$ -mixing conditions in Assumption 2.1 of Brüggemann et al. (2016);
- (iv)  $\{u_t\}$  has absolutely summable cumulants up to order eight.

<sup>&</sup>lt;sup>3</sup> Notice that we focus on absolute IRFs – the quantities  $\gamma_{i,j}(h)$ ,  $\gamma_{i,j}(h)$  being the *i*th element of  $\gamma_{*,j}(h)$  in (5) – rather than on relative IRFs,  $\gamma_{i,j}(h)/\gamma_{1,j}(0)$ , which measure the response of  $Y_{i,t}$  to the *j*-th shock in  $\varepsilon_{1,t}$  that increases  $Y_{1,t}$  by one unit on-impact.

Assumption 1 features a typical maintained hypothesis of correct specification and incorporates a stability condition which rules out the presence of unit roots. Assumption 2 is as in Francq and Raïssi (2006) and Boubacar Mainnasara and Francq (2011). Assumption 2(ii) is a standard unconditional homoskedasticity condition on VAR disturbances and proxies. The  $\alpha$ -mixing conditions in Assumption 2(iii) cover a large class of uncorrelated, but possibly dependent, variables, including the case of conditionally heteroskedastic disturbances. Assumption 2(iv) is a technical condition necessary to prove the consistency of the MBB in this setting, see Brüggemann et al. (2016); see also Assumption 2.4 in Jentsch and Lunsford (2022).

<span id="page-4-1"></span>The next assumption refers to the structural form.

<span id="page-4-2"></span>**Assumption 3** (Structural Form). Given the SVAR in (3), the matrix B is nonsingular and its inverse is denoted by  $A = B^{-1}$ .

Assumption 3 establishes the nonsingularity of the matrix B, which implies the conditions  $rank[B_{\bullet 1}] = k$  in (4) and  $rank[A_{1\bullet}] = k$  in (9).

The next assumption is crucial to our approach. Henceforth, with  $\tilde{\epsilon}_{2,t}$  we denote a subset of the vector of non-target shocks  $\epsilon_{2,t}$  containing  $s \le n-k$  elements. We assume, without loss of generality, that  $\tilde{\epsilon}_{2,t}$  corresponds to the first s elements of  $\epsilon_{2,t}$ , and it is intended that  $\epsilon_{2,t} \equiv \tilde{\epsilon}_{2,t}$  when s = n-k.

<span id="page-4-3"></span>**Assumption 4** (*Proxies for the Non-Target Shocks*). There exist  $s \le n - k$  proxy variables, collected in the vector  $w_t$ , such that the following linear measurement system holds:

<span id="page-4-5"></span><span id="page-4-4"></span>
$$w_t = A\tilde{\epsilon}_{2,t} + \omega_{w,t},\tag{10}$$

where  $\Lambda := E(w_t \tilde{\epsilon}'_{2,t})$  is an  $s \times s$  matrix of relevance parameters and  $\omega_{w,t}$  is a measurement error term, uncorrelated with  $\epsilon_t$ .

Assumption 4 establishes the existence of s external variables which are correlated with s non-target shocks with covariance matrix  $\Lambda := E(w_t \varepsilon_{2,t}')$ , and are uncorrelated with the target structural shocks,  $E(w_t \varepsilon_{1,t}') = 0.5$  Assumption 4 implies that  $\Sigma_{u,w} := E(u_t w_t') = \tilde{B}_{\bullet 2} \Lambda'$ , where  $\tilde{B}_{\bullet 2} := \frac{\partial Y_t}{\partial \tilde{\varepsilon}_{2,t}'}$  collects the s columns of  $\tilde{B}_{\bullet 2}$  associated with the instantaneous effects of the shocks  $\tilde{\varepsilon}_{2,t}$ ; obviously,  $\tilde{B}_{\bullet 2} \equiv B_{\bullet 2}$  when s = n - k ( $\tilde{\varepsilon}_{2,t} \equiv \varepsilon_{2,t}$ ). The illustrations we present in Section 7 and in the Supplement show that Assumption 4 holds in many problems of interest.

Assumption 4 postulates the existence of proxies for the non-target shocks but does not allow for models where the correlation between the proxies  $w_t$  and the instrumented shocks  $\tilde{\varepsilon}_{2,t}$  is weak, i.e. arbitrarily close to zero. Weak correlation between  $w_t$  and  $\tilde{\varepsilon}_{2,t}$  can be allowed as in Montiel Olea et al. (2021, Section 3.2) by considering sequences of models such that  $E(w_t\tilde{\varepsilon}_{2,t}') = \Lambda_T$ , where  $\Lambda$  can be of reduced rank. To illustrate, set s=1, so that  $w_t$ ,  $\tilde{\varepsilon}_{2,t}$  and  $E(w_t\tilde{\varepsilon}_{2,t})$  in (10) are all scalars. Then, we can consider a sequence of models with  $E(w_t\tilde{\varepsilon}_{2,t}) = \lambda_T \to \lambda \in \mathbb{R}$ . In Montiel Olea et al. (2021), a 'strong instrument' corresponds to  $\lambda \neq 0$ ; see also Assumption 2.3 in Jentsch and Lunsford (2022). A 'weak instrument' in the sense of Staiger and Stock (1997) corresponds to  $\lambda_T = cT^{-1/2}$ , where  $|c| < \infty$  is a scalar location parameter; under this embedding,  $\lambda_T \to 0$ , with the case of an 'irrelevant' proxy corresponding to c=0. If the proxy is strong ( $\lambda \neq 0$ ), the asymptotic distribution of the estimator of the parameters ( $\tilde{B}_{2,t}$ ,  $\lambda_T'$ )' (or of the impulse responses to the shock  $\tilde{\varepsilon}_{2,t}$ ) is Gaussian (see Supplement, Section S.3). On the contrary, this is not guaranteed when  $\lambda = 0$ . For instance, if  $\lambda_T = cT^{-1/2}$ , the asymptotic distribution of the estimator of ( $\tilde{B}_{2,t}'$ ,  $\lambda_T'$ )' is non-Gaussian and the parameter c governs the extent of the departure from the Gaussian distribution (see Supplement, Section Section S.3).

To deal with the case of multiple shocks (s > 1), the embedding above can be extended by considering a sequence of models with  $E(w_1\tilde{\epsilon}_2',) = A_T$ , T = 1, 2, ..., with the case of strong proxies corresponding to

<span id="page-4-7"></span>
$$\Lambda_T \to \Lambda$$
,  $rank[\Lambda] = s$ . (11)

Weak instruments as in Staiger and Stock (1997) correspond to the case where  $\Lambda_T$  can be approximated by

<span id="page-4-6"></span>
$$\Lambda_T = CT^{-1/2}, ||C|| < \infty$$
 (12)

C being an  $s \times s$  matrix with finite norm.
