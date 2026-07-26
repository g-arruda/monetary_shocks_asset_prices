![](_page_0_Picture_0.jpeg)

# Staff Working Paper No. 961 Identification of SVAR models by combining sign restrictions with external instruments

Robin Braun and Ralf Brüggemann

February 2022

Staff Working Papers describe research in progress by the author(s) and are published to elicit comments and to further debate. Any views expressed are solely those of the author(s) and so cannot be taken to represent those of the Bank of England or to state Bank of England policy. This paper should therefore not be reported as representing the views of the Bank of England or members of the Monetary Policy Committee, Financial Policy Committee or Prudential Regulation Committee.

![](_page_1_Picture_0.jpeg)

## Staff Working Paper No. 961 Identification of SVAR models by combining sign restrictions with external instruments

Robin Braun(1) and Ralf Brüggemann(2)

### Abstract

We discuss combining sign restrictions with information in external instruments (proxy variables) to identify structural vector autoregressive (SVAR) models. In one setting, we assume the availability of valid external instruments. Sign restrictions may then be used to identify further orthogonal shocks, or as an additional piece of information to pin down the shocks identified by the external instruments more precisely. In a second setting, we assume that proxy variables are only 'plausibly exogenous' and suggest various types of inequality restrictions to bound the relation between structural shocks and the external variable. This can be combined with conventional sign restrictions to further narrow down the set of admissible models. Within a proxy-augmented SVAR, we conduct Bayesian inference and discuss computation of Bayes factors. They can be useful to test either the sign or IV restrictions as overidentifying. We illustrate the usefulness of our methodology in estimating the effects of oil supply and monetary policy shocks.

Key words: Structural vector autoregressive model, sign restrictions, external instruments, proxy VAR.

JEL classification: C32, C11, E32, E52.

- (1) Bank of England. Email: robin.braun@bankofengland.co.uk
- (2) University of Konstanz. Email: ralf.brueggemann@uni-konstanz.de

The views expressed in this paper do not reflect those of the Bank of England or its committees. We thank participants of the Konstanz-Tübingen-Hohenheim Econometrics Seminar, the CFE-CMStatistics 2017, the 2017 annual meeting of the German Statistical Society as well as seminar participants at University of Melbourne, Monash University, Universidad Nacional de Córdoba (Argentina), Universität Duisburg-Essen, and FAU Universität Erlangen-Nürnberg, and the Bank of England for useful comments. We also thank Gökhan Ider for excellent research assistance. Part of this research has been conducted when the second author was visiting Monash University, Australia. Financial support of the Graduate School of Decision Sciences (GSDS) at the University of Konstanz and the German Science Foundation (grant number: BR 2941/3-1) is gratefully acknowledged.

The Bank's working paper series can be found at www.bankofengland.co.uk/working-paper/staff-working-papers

Bank of England, Threadneedle Street, London, EC2R 8AH Email enquiries@bankofengland.co.uk

## 1 Introduction

In this paper, we discuss the identification of structural vector autoregressive (SVAR) models by combining sign restrictions with information in time series that act as proxy or external instruments for the structural shocks of interest. We argue that combining both approaches can be useful in many situations in order to obtain more informative results and mitigate some drawbacks that may occur when using either sign restrictions or external instruments only. We also provide tools to formally quantify the support of overidentifying restrictions in this framework.

Sign restrictions have been introduced by [Faust \(1998\)](#page-27-0), [Canova & De Nicol´o \(2002\)](#page-27-1) and [Uhlig \(2005\)](#page-30-0) as a generalization of short- and long-run restrictions on the effect of structural shocks. In their most common form, they are imposed on contemporaneous or higher horizon structural impulse responses. More broadly, they have been exploited to bound other structural parameters, e.g. elasticities or variance decompositions. Given that sign restrictions imply set-identification, an important practical problem is that the set of admissible models is often wide, and therefore structural analysis not very informative.

Introduced by [Stock & Watson \(2012\)](#page-30-1) and [Mertens & Ravn \(2012\)](#page-29-0), the use of external instrumental variables (IV) (or proxy variables) provides another popular way to achieve identification.[1](#page-2-0) While the external IV approach is conceptually appealing, the exogeneity of instruments is questionable in many applications (see e.g. the discussion in [Ramey \(2016\)](#page-30-2) on the narrative measures of monetary policy shocks). Furthermore, even a proxy variable that is credibly exogenous may be weak, complicating reliable inference [\(Montiel Olea et al.](#page-29-1) [2021\)](#page-29-1).

In this paper, we contribute to the literature by discussing how to combine the proxy variable approach with sign restrictions. We discuss two interesting cases which differ in the underlying assumption for the external variables. In the first, we assume the availability of credibly exogenous instruments. In this case, sign restrictions can serve two purposes. On the one hand, they may be useful to identify additional shocks from the group of shocks that are orthogonal to those identified by IVs. On the other hand, sign restrictions can be used in addition to the IV conditions such that they are informative with respect to the shocks for which instruments are available. This can be useful to disentangle multiple shocks to be identified by IV, or simply to obtain a more informative picture in finite samples.

In our second setting, we assume the availability of 'plausibly exogenous' proxies. Following the terminology of [Conley et al. \(2012\)](#page-27-2), these are external variables which may be related to the structural shock of interest, but are not credibly exogenous. As in the microeconometric literature, we propose to use inequality restrictions to bound endogeneity. In our context, such bounds arise naturally as sign restrictions on the parameters that relate the structural shocks with the external variable, including restrictions on correlations and variance decompositions of the instrument. Furthermore, they can easily be combined with conventional sign restrictions on the responses of variables to achieve a reduced set of admissible models.

<span id="page-2-0"></span><sup>1</sup>Many interesting papers have successfully exploited this identification strategy, including [Gertler &](#page-27-3) [Karadi](#page-27-3) [\(2015\)](#page-27-3), [Gerko & Rey](#page-27-4) [\(2017\)](#page-27-4), [Mertens & Montiel Olea](#page-29-2) [\(2018\)](#page-29-2), [Lakdawala](#page-28-0) [\(2019\)](#page-28-0), [K¨anzig](#page-28-1) [\(2021\)](#page-28-1) and [Peersman](#page-29-3) [\(2020\)](#page-29-3).

To conduct inference, we rely on a unified econometric framework, a Bayesian SVAR model augmented by equations for the proxy variables. In our baseline setting, we formulate independent priors on the reduced form parameters and the structural impact matrix of a B-model type SVAR, i.e. we use a model where the proxy-augmented reduced form errors are a linear function of the structural shocks and a measurement error.[2](#page-3-0) We summarize the posterior distribution of the structural parameters by Markov Chain Monte Carlo (MCMC) methods. In order to sample from the conditional distribution of the structural parameters, we implement a Metropolis Hastings algorithm that makes use of the efficient importance distribution developed in [Arias et al. \(2018\)](#page-26-0). By combining the different types of restrictions discussed in this paper, the model may be overidentified. For these situations, we describe Bayes factors as a formal statistical tool to quantify the support of overidentifying restrictions.

### Related Literature

Our paper is related to an emerging literature that has discussed some form of combining sign restrictions with external instruments specifically, or non-model information more broadly. Related to our first setting are papers by [Cesa-Bianchi & Sokol \(2017\)](#page-27-5), [Jaroci´nski](#page-28-2) [& Karadi \(2020\)](#page-28-2), and [Arias et al. \(2021\)](#page-26-1) who combine instrumental variables with sign restrictions to either identify additional shocks unrelated to the instrument, or to disentangle multiple shocks to be identified by IV. Related to those papers, we highlight the benefits from imposing overidentifying sign restrictions and provide methodology on how these can be tested via Bayes factors.

Our second setting is closely related to the microeconometric literature exploiting plausibly exogenous instruments. Here, set-identified simultaneous equation models are obtained by replacing exogeneity constraints with upper bounds on the degree of endogeneity [\(Nevo](#page-29-4) [& Rosen 2012,](#page-29-4) [Conley et al. 2012\)](#page-27-2). In parallel work to ours, [Ludvigson et al. \(2020\)](#page-29-5) also translate this idea to SVAR models, introducing 'external inequality constraints'. Effectively, this entails discarding models in which the shock of interest is not or only loosely correlated with the proxy variables.[3](#page-3-1) Our paper is more general with respect to important modeling aspects. For instance, we also discuss constraints on variance contributions and, in addition to threshold constraints, introduce several ranking restrictions that do not require input by the researcher. Furthermore, we put special emphasis on restrictions that are invariant under rotation of shocks unrelated to the external variables, allowing researchers to work with partially identified models.

Methodologically, our paper relates to recent advances in Bayesian inference for SVARs identified by external instruments [\(Caldara & Herbst 2019,](#page-27-6) [Drautzburg 2020,](#page-27-7) [Arias et al.](#page-26-1) [2021,](#page-26-1) [Giacomini et al. 2021\)](#page-28-3). Our paper complements this literature by considering inference in an augmented B-model type proxy SVAR. There are several reasons why we choose this model representation. First, the B-model is very popular among researchers

<span id="page-3-0"></span><sup>2</sup>The basic structure of our proxy SVAR is of the same form as the one used in [Angelini & Fanelli](#page-26-2) [\(2019\)](#page-26-2). As explained in Section [2,](#page-4-0) this setup is labeled as a B-model SVAR in some parts of the literature (see e.g. [L¨utkepohl](#page-29-6) [\(2005,](#page-29-6) Chapter 9)).

<span id="page-3-1"></span><sup>3</sup>See also [Uhrin & Herwartz](#page-30-3) [\(2016\)](#page-30-3) for a similar idea.

working with sign restrictions (see [Bruns & Piffer \(2019\)](#page-27-8) for a survey). Economic theory is often informative about the impact impulse response functions to a certain shock which are effectively elements in the B-matrix.[4](#page-4-1) Second, specifying a proxy VAR model in form of an augmented B-model implies a very natural measurement error equation for the instruments m<sup>t</sup> given by m<sup>t</sup> = Φε<sup>t</sup> + η<sup>t</sup> , where ε<sup>t</sup> are structural shocks and η<sup>t</sup> is a measurement error. As discussed in [Mertens & Ravn \(2013\)](#page-29-7), IV restrictions correspond to simple exclusion restrictions on Φ. We show that under the conjugate prior for the B-model, both conditional prior and posterior of Φ are matrix variate normal. As we discuss in the paper, this result facilitates testing exclusion restrictions on Φ via Savage Dickey Density ratios [\(Dickey 1971\)](#page-27-9). In our framework, we make use of this result to test IV validity within a sign-identified model. Finally, in our paper we consider independent prior distributions on the reduced form autoregressive coefficients, which allows to impose a wider spectrum of prior information including asymmetric priors across equations.

Our paper is also related to [Nguyen \(2019\)](#page-29-8), who introduces identifying information from external instruments into a set-identified monetary policy model [\(Baumeister & Hamilton](#page-26-3) [2018\)](#page-26-3). In a second step, Bayes factors are used to formally assess the validity of each instrument. This approach is similar to what we suggest in our first setting, but there are important differences. First, his approach relies on including external instruments as exogenous regressors into the VAR model of [Baumeister & Hamilton \(2015\)](#page-26-4), which requires explicit formulation of prior distributions on structural parameters in B<sup>−</sup><sup>1</sup> . In situations where such prior formulations are difficult, our conjugate prior framework is easier to use. Furthermore, as we show, the Bayes factors under the conjugate prior are not sensitive to rotations of those shocks unrelated to the external variables, allowing researchers to use our method within partially identified models.

#### Structure of the paper

Section [2](#page-4-0) introduces the econometric modeling framework, discusses identifying restrictions, Bayesian inference as well as the computation of Bayes factors. Section [3](#page-17-0) illustrates the suggested methods in applications to oil market shocks and US monetary policy shocks. Section [4](#page-25-0) summarizes and concludes.

## <span id="page-4-0"></span>2 Methodology

## <span id="page-4-3"></span>2.1 Augmented SVAR model

We consider a B-model type SVAR model (see e.g. [\(L¨utkepohl 2005,](#page-29-6) Section 9.1)) given by

<span id="page-4-2"></span>
$$y_t = \nu + \sum_{i=1}^p A_i y_{t-i} + B\varepsilon_t, \quad \varepsilon_t \sim (0, I_n),$$
 (2.1)

<span id="page-4-1"></span><sup>4</sup>Mostly, those restrictions take the form of dogmatic sign or exclusion restrictions, but within our approach they could also be spelled out in forms of more general prior distributions as suggested in [Baumeister & Hamilton](#page-26-4) [\(2015\)](#page-26-4).

where  $y_t = (y_{1t}, \dots, y_{nt})'$  is a  $n \times 1$  vector of endogenous time series,  $\nu$  is a  $n \times 1$  vector of intercepts, and  $A_i, i = 1, \dots, p$  are  $n \times n$  matrices of autoregressive coefficients. The dynamics of the system is assumed to be driven by n structural shocks  $\varepsilon_t$ , where we assume that the elements of  $\varepsilon_t$  are orthogonal and are normalized to have unit variances. The  $n \times n$  matrix B is the contemporaneous impact matrix and reflects the immediate responses of the variables  $y_t$  to the structural shocks  $\varepsilon_t$ . We assume stability of the VAR, which implies that the SVAR(p) has a MA $(\infty)$  representation given by  $y_t = \mu_y + \sum_{j=0}^{\infty} \Xi_j B \varepsilon_{t-j} = \mu_y + \sum_{j=0}^{\infty} \Theta_j \varepsilon_{t-j}$ , where  $\mu_y = E(y_t)$  and the  $n \times n$  coefficient matrices  $\Theta_j = \Xi_j B$ , are the structural impulse response functions (IRFs). The reduced form MA $(\infty)$  matrices  $\Xi_j$  can be computed recursively from  $\Xi_j = \sum_{i=1}^j \Xi_{j-i} A_i$  with  $\Xi_0 = I_n$  and  $A_i = 0$  for i > p. Without additional restrictions this model is not identified. Therefore, restrictions must be imposed on the structural impact matrix B in order to pin down a meaningful structural model.

In this paper, we focus on identification by combining sign restrictions with information in external variables. Let  $m_t = (m_{1t}, \ldots, m_{kt})'$  be a  $k \times 1$  vector of external variables designed to provide identifying information about a subset of k < n structural shocks. Our econometric methods are based on augmenting the SVAR given in (2.1) by equations for  $m_t$ :

<span id="page-5-0"></span>
$$\underbrace{\begin{pmatrix} y_t \\ m_t \end{pmatrix}}_{\tilde{y}_t} = \underbrace{\begin{pmatrix} \nu \\ \nu_m \end{pmatrix}}_{\tilde{\nu}} + \sum_{i=1}^p \underbrace{\begin{pmatrix} A_i & 0_{n \times k} \\ \Gamma_{1i} & \Gamma_{2i} \end{pmatrix}}_{\tilde{A}_i} \underbrace{\begin{pmatrix} y_{t-i} \\ m_{t-i} \end{pmatrix}}_{\tilde{y}_{t-i}} + \underbrace{\begin{pmatrix} B & 0_{n \times k} \\ \Phi & \Sigma_{\eta}^{1/2} \end{pmatrix}}_{\tilde{B}} \underbrace{\begin{pmatrix} \varepsilon_t \\ \eta_t \end{pmatrix}}_{\tilde{\varepsilon}_t}, \quad \begin{pmatrix} \varepsilon_t \\ \eta_t \end{pmatrix} \sim (0, I_{n+k}).$$
(2.2)

As noted in Mertens & Ravn (2012), the additional equations have an intuitive measurement error interpretation. The k variables  $m_t$  are modeled as a linear function of lagged values of  $\tilde{y}_t$ , the structural errors  $\varepsilon_t$ , plus a zero mean measurement error  $\eta_t$ , which is assumed to be orthogonal to the structural shocks  $\varepsilon_t$ , i.e.  $\eta_t \perp \varepsilon_t$ .  $\Gamma_{1i}$ ,  $\Gamma_{2i}$  and  $\Phi$  are  $k \times n$  coefficient matrices. Corresponding  $n \times k$  blocks of zeros in the upper right parts of  $\tilde{A}_i$  and  $\tilde{B}$  ensure that  $m_t$  and the measurement error  $\eta_t$  are external to the model and have no implications for the dynamics of  $y_t$ . We also assume that  $\tilde{B}$  has full rank,  $\operatorname{rk}(\tilde{B}) = n + k$ , throughout the paper. Usually, proxy variables are designed to be unpredictable by lagged values of  $y_t$  and  $m_t$ , and do only contain contemporaneous information about  $\varepsilon_t$ . In this case, one can set  $\Gamma_{1i} = \Gamma_{2i} = 0$ , and the model shares the more natural representation introduced in Mertens & Ravn (2012). To keep notation simple, for the remainder of this section, we assume  $\Gamma_{1i} = \Gamma_{2i} = 0$  holds, implying that the model reduces to

$$y_t = \nu + \sum_{i=1}^p A_i y_{t-i} + B\varepsilon_t, \tag{2.3}$$

$$m_t = \nu_m + \Phi \varepsilon_t + \Sigma_{\eta}^{1/2} \eta_t. \tag{2.4}$$

Without any further restrictions, the augmented SVAR model is only identified up to orthogonal rotations of the form  $\bar{B} = \tilde{B}Q$ , where the rotation matrix  $Q = \text{diag}(Q_1, Q_2)$ ,  $Q_1Q_1' = I_n$  and  $Q_2Q_2' = I_k$ . Q has a block structure that reflects the fact that the

measurement error  $\eta_t$  is assumed to be orthogonal to the dynamics in  $y_t$ , implying a  $n \times k$  block of zeros in the upper right part of  $\tilde{B}$ . Through restrictions on  $\Phi$ , identifying information can be imposed to pin down values of B or equivalently, to narrow the set of rotation matrices  $Q_1$ .

At this point, we highlight recent work of Noh (2017) and Plagborg-Møller & Wolf (2021b) who discuss IV identification of IRFs, relaxing the assumption that  $\varepsilon_t$  is recoverable from lagged and contemporaneous values of  $y_t$  (invertibility). Within equation (2.2), this could be implemented by allowing for unrestricted lead-lag dynamics between instrument and endogenous variables, and computation of IRFs via a Cholesky decomposition for  $(m_t, y_t')'$  with  $m_t$  ordered first. However, without the invertibility assumption, only measurement error contaminated shocks can be identified, complicating the identification of variance decompositions even under instrument exogeneity (Plagborg-Møller & Wolf 2021a). Throughout this paper, we often rely on the ability to explicitly take out variation in the instrument that is due to measurement error. Therefore, we assume invertibility in the following.

#### <span id="page-6-3"></span>2.2 Sign and instrumental variables restrictions

We first discuss combining sign restrictions with instrumental variables (IV), assuming that  $m_t$  provides valid exogenous variation. For this purpose, partition the structural shocks  $\varepsilon_t$  and the matrix  $\Phi$  as:

<span id="page-6-0"></span>
$$\varepsilon_t = \begin{bmatrix} \varepsilon'_{1t} : \varepsilon'_{2t} \end{bmatrix}' \quad \text{and} \quad \Phi = \begin{bmatrix} \phi_1 : \phi_2 \end{bmatrix}. \tag{2.5}$$

Without loss of generality, assume that out of all n structural shocks, the researcher identifies the last k shocks  $(\varepsilon_{2t})$  using k instrumental variables  $m_t$ . In our model,  $E(m_t \varepsilon'_t) = \Phi$  and using the partitioning in (2.5), we get

$$[\mathrm{E}(m_t \varepsilon_{1t}') \, \mathrm{E}(m_t \varepsilon_{2t}')] = [\phi_1 : \phi_2].$$

The assumption that  $m_t$  are valid instruments for  $\varepsilon_{2t}$ , implies that  $m_t$  is correlated with  $\varepsilon_{2t}$  but uncorrelated with all other shocks in the system, that is  $E(m_t \varepsilon'_{1t}) = 0$ . Consequently, the IV conditions imply

<span id="page-6-1"></span>
$$\phi_1 = 0_{k \times n - k},\tag{2.6}$$

and

<span id="page-6-2"></span>
$$\phi_2 \neq 0, \quad \text{rk}(\phi_2) = k, \tag{2.7}$$

where (2.6) and (2.7) are the exogeneity and relevance conditions, respectively. If k = 1, the scalar shock of interest ( $\varepsilon_{2t}$ ) is point identified by the external instrument conditions, while for any k > 1, restrictions (2.7) and (2.6) only partition the structural shocks into shocks  $\varepsilon_{2t}$  which correlate with the instruments, and shocks  $\varepsilon_{1t}$  assumed to be orthogonal to the instruments. Therefore, when k > 1 additional restrictions are necessary to disentangle the effects of each subcomponent of  $\varepsilon_{2t}$ .

When instrument restrictions are valid, we see two potentially useful ways to introduce

sign restrictions. On the one hand, they can be used to identify additional shocks within ε1t , the shocks orthogonal to the instrument. For example, in one of our empirical applications, we use an IV to identify a supply shock while different demand shocks are identified using sign restrictions on impact IRFs. Within our unified framework, all shocks identified by either sign restrictions or IV restrictions are guaranteed to be mutually orthogonal. Alternatively, sign restrictions may be imposed on ε2<sup>t</sup> , which are the shocks identified by external instruments. This may be useful for two reasons. First, if k > 1, sign restrictions can be imposed to further disentangle each subcomponent of ε2<sup>t</sup> . [5](#page-7-0) Second, sign restrictions can act as an additional piece of information for shocks that are point-identified by IV. Such information can be particularly valuable when the external variables are only weakly informative. For example, within our oil market application (Section [3.1\)](#page-17-1), we combine classical impact sign restrictions with IV restriction to identify the supply shock. Also, [Bruns](#page-27-10) [& Piffer \(2021\)](#page-27-10) use sign restrictions on the top of IV restrictions within a non-linear VAR. Additional restrictions on ε2<sup>t</sup> are potentially overidentifying and may be checked against the data. In our framework, this can be done in form of Bayes factors which we will discuss in Section [2.5.](#page-12-0)

## <span id="page-7-1"></span>2.3 Sign restrictions and plausibly exogenous instruments

There may be situations where researchers have doubts regarding the exogeneity of their external instruments. Therefore, we discuss how proxy variables that are not exogenous may still be useful for identification. In reference to the microeconometric literature, we adopt the terminology and call these proxy variables 'plausibly exogenous' (cf. [Conley et al.](#page-27-2) [\(2012\)](#page-27-2)). Instead of instrument exogeneity, weaker inequality restrictions are suggested to bound the relation between structural shocks and proxy variables.

For ease of exposition, we discuss a situation where the goal is to identify a single shock, say ε1<sup>t</sup> or equivalently B1, the first column of the structural impact matrix. Furthermore, assume that we have a scalar proxy variable m<sup>t</sup> , which is only 'plausibly exogenous' for ε1<sup>t</sup> such that the approach in Section [2.2](#page-6-3) cannot be used in a credible way. In the following, we suggest various restrictions that bound the relation between the proxy variable m<sup>t</sup> , the structural shock of interest ε1<sup>t</sup> and all other shocks ε2<sup>t</sup> . In particular, we discuss constraints on correlations and variance contributions, and further classify these into threshold and ranking restrictions as explained below.

#### Correlation constraints

For k = 1, the measurement error equation is given by:

$$m_t = \nu_m + \phi \varepsilon_t + \sigma_\eta \eta_t, \qquad \eta_t \sim (0, 1),$$

<span id="page-7-0"></span><sup>5</sup>For example, [Piffer & Podstawski](#page-29-10) [\(2017\)](#page-29-10) use sign restrictions on ϕ<sup>2</sup> in the situation that k = 2, while [Bertsche](#page-26-5) [\(2019\)](#page-26-5) imposes restrictions on the impact matrix B<sup>2</sup> directly.

where  $\phi$  is a  $1 \times n$  vector and  $\sigma_{\eta}$  a scalar. Therefore, within the proxy-augmented SVAR, the correlation between the *i*th shock and the instrument is:

$$\rho_i := \operatorname{Corr}(m_t, \varepsilon_{it}) = \frac{\operatorname{E}(m_t \varepsilon_{it})}{\sqrt{\operatorname{Var}(m_t)}} = \frac{\phi_i}{\sqrt{\phi \phi' + \sigma_\eta^2}} \in (-1, 1).$$

A threshold restriction of the form  $\rho_1 > c_1$  can be used (see also Ludvigson et al. 2020). Effectively, this retains all models where the correlation between  $m_t$  and the structural shock of interest  $\varepsilon_{1t}$  exceeds a threshold  $c_1$ . A special case is obtained for  $c_1 = 0$ , expressing the belief that the external variable  $m_t$  is at least positively correlated with the structural shock it has been designed for. The larger  $c_1$ , the more models are ruled out from the set of admissible SVARs. The threshold value  $c_1$  needs to be set by the researcher. However, in our view, a particular choice is often difficult to justify in practice.

Instead of choosing  $c_1$ , one could employ a ranking restriction of the form  $\rho_1 > \rho_j$ ,  $j = 2, \ldots, n$ . Such a restriction ensures that the identified set only includes models where the shock of interest  $\varepsilon_{1t}$  shows a larger correlation with the proxy  $m_t$  than any other shock in the system. One drawback with this ranking restriction on the correlations is that the results may not be invariant to the identification and normalization of the shocks unrelated to the instrument  $(\varepsilon_{2t})$ . For example, in a bivariate model where  $\operatorname{Corr}(m_t, \varepsilon_{1t}) = 0.1$  and  $\operatorname{Corr}(m_t, \varepsilon_{2t}) = -0.2$  this restriction would be satisfied. However, a simple re-normalization of the sign to  $\tilde{\varepsilon}_{2t} = -\varepsilon_{2t}$  yields the opposite conclusion. This problem can be addressed by considering variance contributions instead, which we discuss in in the following.

#### Variance contribution constraints

Since the elements in  $\varepsilon_t$  are orthogonal by construction, the share of variance  $\omega_i$  in  $m_t$  explained by the *i*th structural shock is given by the squared correlation:

$$\omega_i = \frac{\phi_i^2}{\phi \phi' + \sigma_n^2} \in (0, 1),$$

and one could use a threshold constraint of form  $\omega_1 > c_2$  for some  $c_2 \in (0,1)$ . Thus, one would only retain models for which the shock of interest  $\varepsilon_{1t}$  explains at least  $c_2 \cdot 100\%$  of the variation in the instrument. However, the extent to which  $m_t$  reflects the measurement error is not known a priori, which makes it difficult to set  $c_2$  in practice.

To alleviate this problem, it might be useful to consider the statistic

$$\omega_i^* = \frac{\phi_i^2}{\phi \phi'} \in (0, 1),$$

which gives the contribution of the *i*th structural shock to  $Var(m_t - \eta_t)$ , the variance of the proxy net of measurement error. Choosing the value  $c_2^* \in (0,1)$  for the restriction  $\omega_1^* > c_2^*$  is easier as  $(1 - c_2^*)$  carries the convenient interpretation of the maximum degree of endogeneity one is willing to allow for. As  $c_2^*$  approaches unity, one increasingly excludes endogenous variation in  $m_t$  with the limiting case of  $c_2^* = 1$  effectively imposing the IV restriction.

Alternatively, one could also use the ranking constraint  $\omega_1 > \sum_{j=2}^n \omega_j$ , i.e. one would only keep models for which the identified shock of interest  $\varepsilon_{1t}$  explains more of the variation in  $m_t$  than all remaining shocks in  $\varepsilon_{2t}$  together. Note that using  $\omega_1^* > \sum_{j=2}^n \omega_j^*$  would give identical results and that this ranking restriction is a special case of the threshold constraint above with  $c_2^* = 0.5$ . Instead, one may think of imposing the ranking constraint  $\omega_1 > \omega_j$ ,  $j = 2, \ldots, n$ . Here, one keeps only models in which the identified shock of interest  $\varepsilon_{1t}$  explains more of the variation in  $m_t$  than any other shock in  $\varepsilon_{2t}$ . However, this restriction is not invariant to rotations of  $\varepsilon_{2t}$  and hence requires their explicit identification to be operational. In contrast, using  $\omega_1 > \sum_{j=2}^n \omega_j$  is invariant to such rotations. To see this, define rotated shocks  $\bar{\varepsilon}_{2t} = Q_2' \varepsilon_{2t}$  with corresponding measurement error regression coefficients  $\bar{\phi}_2 = \phi_2 Q_2$  where  $Q_2 Q_2' = I_{n-1}$ . Then, it holds that:

$$\sum_{j=2}^{n} \omega_j = \frac{\phi_2 \phi_2'}{\phi_1^2 + \phi_2 \phi_2' + \sigma_\eta^2} = \frac{\bar{\phi}_2 \bar{\phi}_2'}{\phi_1^2 + \bar{\phi}_2 \bar{\phi}_2' + \sigma_\eta^2}.$$

Note that similar manipulations can be used to show that  $\omega_1 > c_2$  and  $\omega_1^* > c_2^*$  are also invariant to the identification of  $\varepsilon_{2t}$  and hence suitable for partially identified models.

#### Practical considerations

In practice, applied researchers need to choose one particular way of exploiting information in plausibly exogenous proxy variables from the menu above. As usual in SVARs, this choice needs to be made by the researcher against the background of the particular application. For instance, in some applications, researchers may have a good understanding of reasonable values for threshold values. If no such information is available, then researchers may revert to methods that rely on a simple ranking. Furthermore, we recommend that in partially identified models, one should only consider restrictions that are invariant to the identification of  $\varepsilon_{2t}$ .

Some researchers may be reluctant to select a single threshold or ranking condition. In this case, it might be attractive to formulate a more general prior belief on the amount of endogeneity in the spirit of Baumeister & Hamilton (2015). To give an example, one can use a Beta prior on  $\omega_1^* \sim \text{Beta}(\alpha, \beta)$  and tune  $\alpha$  and  $\beta$  to the particular proxy variable. For instance, setting  $\alpha = 5$  and  $\beta = 1$  yields a density that peaks at  $\omega_1^* = 1$ , implying the modal prior belief that  $m_t$  is a valid instrument. Also, for those values, most of the prior mass would lie above 0.5, reflecting a strong belief that most of the variation in  $m_t$  (unrelated to measurement error) should be driven by the shock of interest. The algorithm developed in this paper is general enough to handle such prior distributions.

We also highlight that any of the restrictions outlined above can be adapted to a setting with multiple shocks and instruments, and can be combined with conventional sign restrictions on structural parameters of the model. As we demonstrate in our empirical applications (Section 3.2), a combination with conventional sign restrictions can be a powerful identification strategy if the latter alone are not strong enough to yield informative results.

Finally, the possibility to exploit identification of partially endogenous instruments fa-

cilitates the construction of such variables considerably. Among those, one could consider qualitative indicators for the sign of given shocks at a certain date, which are often easy to construct (see Plagborg-Møller & Wolf (2021b, Appendix B.3) and Boer & Lütkepohl (2021)). Coupled with restrictions discussed in this section, just a few non-zero elements in  $m_t$  might help to considerably narrow down the set of admissible models without the need to impose full exogeneity. Similarly, one may construct a proxy  $m_t$ , which is either 0 or the prediction error of a variable of interest. In a second step, one may then impose that the structural shock of interest is the main driver of these selected prediction errors. In fact, such an approach would be closely related to narrative sign restrictions suggested in Antolín-Díaz & Rubio-Ramírez (2018).

## <span id="page-10-1"></span>2.4 Bayesian inference

In the following, we discuss Bayesian inference for the augmented B-model type SVAR subject to the restrictions discussed previously. Let  $\tilde{A} = [\tilde{\nu}, \tilde{A}_1, \dots, \tilde{A}_p], \ \tilde{Y} = [\tilde{y}_1, \dots, \tilde{y}_T]'$  and  $X = [x_1, \dots, x_T]'$  where  $x_t = [1, \tilde{y}'_{t-1}, \dots, \tilde{y}'_{t-p}]'$ . We work with a standard Gaussian likelihood. Given known presample values  $\tilde{y}_0, \tilde{y}_{-1}, \dots, \tilde{y}_{-p+1}$ , the density is:

$$p(\tilde{Y}|\tilde{A}, \tilde{B}) = (2\pi)^{-\frac{(n+k)T}{2}} |\tilde{B}\tilde{B}'|^{-\frac{T}{2}} \exp\left(-\frac{1}{2} \text{tr}(\tilde{B}^{-1'}\tilde{B}^{-1}(\tilde{Y} - X\tilde{A})(\tilde{Y} - X\tilde{A})')\right). \tag{2.8}$$

Given that the Gaussian likelihood is fully characterized by the first two moments, it is invariant to certain orthogonal rotations of  $\tilde{B}$ . That is, if no exogeneity restrictions are imposed, the same likelihood value is obtained for any alternative model  $\tilde{B}^* = \tilde{B}Q$  with  $Q = \text{diag}(Q_1, Q_2)$  (see Section 2.1) as long as the sign- and IV restrictions remain satisfied.

Regarding the prior, we specify independent distributions for the autoregressive coefficients and the structural impact matrix. With respect to the first, denote by  $\alpha$  the vectorized non-zero elements in A. Then, we assume a Gaussian prior given by  $p(\alpha; \alpha_0, V_\alpha) \sim$  $\mathcal{N}(\alpha_0, V_\alpha)$ . While this choice allows the user to pick from a wide range of priors developed for multivariate regression analysis, normality implies conditional conjugacy and hence ensures straightforward treatment within Markov Chain Monte Carlo (MCMC) methods. As opposed to other Bayesian proxy SVARs considered in Caldara & Herbst (2019) and Arias et al. (2021), we consider an independent prior for the reduced form parameters rather than a fully conjugate prior for the structural parameters. This is motivated by the fact that in a VAR setting, informative priors are typically spelled out for the reduced form parameters. Furthermore, assuming prior independence has the benefit that it allows for a wider spectrum of priors which can be asymmetric across equations. These include the original Minnesota prior of Litterman (1986) and various popular hierarchical shrinkage priors surveyed in Koop et al. (2010). This effectively allows us to employ dogmatic exclusion restrictions imposed on A which we employ to ensure that the external variables do not influence the dynamics of the endogenous variables.

<span id="page-10-0"></span> $<sup>^6\</sup>mathrm{We}$  are grateful to an anonymous referee for pointing out this possibility.

For the structural impact matrix  $\tilde{B}$ , we consider a conjugate prior which takes the form

<span id="page-11-0"></span>
$$p(\tilde{B}; v_0, S_0) \propto |\det(\tilde{B})|^{-(v_0+n+k)} \exp\left(-\frac{1}{2} \operatorname{tr}\left(S_0\left(\tilde{B}\tilde{B}'\right)^{-1}\right)\right).$$
 (2.9)

Akin to the likelihood, the conjugate prior implies that all B-models satisfying the restrictions discussed in this paper obtain the same prior density value. This guarantees that the researcher does not impose unintentional identifying information beyond the restrictions considered in this paper. Furthermore, the prior hyperparameters are fairly easy to choose, e.g. by a training sample. Specifically,  $v_0$  and  $S_0$  can be thought of as degrees of freedom and a scale matrix from an inverse Wishart prior specified on the augmented covariance matrix  $\tilde{\Sigma} = \tilde{B}\tilde{B}'$ .

In Appendix A, we prove that the prior specified in (2.9) can be further split into densities for each of the three underlying parameter blocks of  $\tilde{B}$ , that is B,  $\Sigma_{\eta}^{1/2}$  and  $\Phi$ . Specifically, we can show that  $p(\tilde{B}; v_0, S_0) \propto p(B; v_0, S_0) p(\Sigma_{\eta}^{1/2}; v_0, S_0) p(\Phi|B, \Sigma_{\eta}^{1/2}; v_0, S_0)$ , where:  $p(B; v_0, S_0) \propto |\det(B)|^{-(v_0+n)} \exp\left(-\frac{1}{2} \operatorname{tr}\left(S_{11} \left(BB'\right)^{-1}\right)\right),$ 

$$p(B; v_0, S_0) \propto |\det(B)|^{-(v_0+n)} \exp\left(-\frac{1}{2} \operatorname{tr}\left(S_{11} (BB')^{-1}\right)\right),$$

$$p(\Sigma_{\eta}^{1/2}; v_0, S_0) \propto |\Sigma_{\eta}|^{-(v_0+k)/2} \exp\left(-\frac{1}{2} \operatorname{tr}\left(S_{22 \cdot 1} \Sigma_{\eta}^{-1}\right)\right),$$

$$p(\Phi|B, \Sigma_{\eta}^{1/2}; v_0, S_0) \sim \mathcal{MN}(S_{21} S_{11}^{-1} B, \Sigma_{\eta}, B' S_{11}^{-1} B).$$

Here,  $\Sigma_{\eta} = \Sigma_{\eta}^{1/2}(\Sigma_{\eta}^{1/2})'$ ,  $S_0 = \begin{pmatrix} S_{11} & S_{12} \\ S_{21} & S_{22} \end{pmatrix}$ ,  $S_{22\cdot 1} = S_{22} - S_{21}S_{11}^{-1}S_{12}$ , and  $X \sim \mathcal{MN}(M, U, V)$  denotes the matrix normal distribution with mean E[X] = M and variance  $Var[vec(X)] = V \otimes U$ .

There are several useful implications from this result. First, conditional normality of  $\Phi$ sets the cornerstone for simple Bayes factor computation. As we will discuss in Section 2.5, it allows the use of Savage Dickey Density Ratios to test IV exclusion restrictions. Second, the result gives insights on how the prior relates to others used in the Bayesian proxy SVAR literature. Specifically, (for p=0) using a change of variable technique with  $\tilde{A}=\tilde{B}^{-1}$  yields the Jacobian of transformation  $|\det(\tilde{A})|^{-2(n+k)}$  and the prior density of Arias et al. (2018):  $p(\tilde{\mathsf{A}}; v_0, S_0) \propto |\det(\tilde{\mathsf{A}})|^{v_0 - n - k} \exp\left(-\frac{1}{2} \operatorname{tr}\left(\tilde{\mathsf{A}}' S_0 \tilde{\mathsf{A}}\right)\right)$ . Furthermore, a prior as in Caldara & Herbst (2019) can be obtained by applying the change of variables to the upper left block  $A = B^{-1}$ , and using an independent normal prior for  $\Phi$ . However, prior dependence on B (or A), is needed if a researcher would like to ensure that the prior is not unintentionally informative about the set of admissible models. Third, the result opens the door to easily switch to a prior which is uniform for the A-model, if a researcher prefers doing so. Using a change of variable technique with  $\{B, \Phi, \Sigma_n\}$  to  $\{A = B^{-1}, \Phi, \Sigma_n\}$  yields the corresponding prior  $p(A, \Sigma_{\eta}^{1/2}, \Phi; S_0, v_0) \propto p(A; v_0, S_0) p(\Sigma_{\eta}^{1/2}; v_0, S_0) p(\Phi|A, \Sigma_{\eta}^{1/2}; v_0, S_0)$  with alternated densities given by  $p(\mathsf{A}; v_0, S_0) \propto |\det(\mathsf{A})|^{v_0 - n} \exp\left(-\frac{1}{2} \operatorname{tr}\left(\mathsf{A}' S_0 \mathsf{A}\right)\right)$  and  $p(\Phi | \mathsf{A}, \Sigma_{\eta}^{1/2}; v_0, S_0) \sim 0$  $\mathcal{MN}(S_{21}S_{11}^{-1}\mathsf{A}^{-1},\Sigma_{\eta},\mathsf{A}^{-1'}S_{11}^{-1}\mathsf{A}^{-1})$ . For the re-parameterized SVAR, the prior then resembles that of Arias et al. (2018). Note that the methodology considered in this paper, including the posterior sampler, are general enough to handle other priors. If the researcher would like to impose additional identifying information in terms of a density function that weights certain structural parameters *a priori*, the prior of equation (2.9) can be replaced or simply amended accordingly. However, we stress that one would need to defend these very carefully as they become informative about the set of otherwise observationally equivalent parameters.<sup>7</sup>

For posterior inference, Markov Chain Monte Carlo (MCMC) methods are used and we refer the reader to Appendix B for a detailed exposition. Essentially, the algorithm iteratively draws from the conditional posteriors  $p(\tilde{A}|\tilde{B},\tilde{Y})$  and  $p(\tilde{B}|\tilde{A},\tilde{Y})$ . While the conditional posterior of  $\tilde{A}$  is Gaussian and hence simple to draw from, that of  $\tilde{B}$  is unknown. Here, we rely on an Accept Reject Metropolis Hastings (AR-MH) algorithm that is based on the proposal distribution suggested in Arias et al. (2018). The proposal is able to draw from the conditional distribution of  $\tilde{B}$  up to a small approximation error arising from the change of variables applied during the algorithm. Given that the approximation error tends to have very small variance, the MH step has a very high acceptance rate. For more details regarding MCMC efficiency, we refer to Appendix B.2.

Given the proposal distribution, we note that the same constraints apply as in Arias et al. (2018). Specifically, the algorithm is unable to handle overidentifying exclusion restrictions. This can become a problem if a researcher would like to identify a single shock with multiple instruments, or if multiple instruments are assumed to be correlated with just one structural shock. In this case, depending on the identifying restrictions, one would need a different algorithm (e.g. that proposed in Caldara & Herbst (2019)). We note that for the applications considered in this paper the caveat is of no concern.
