# The Review of Economics and Statistics

Vol. LXXXV November 2003 Number 4

# IDENTIFICATION THROUGH HETEROSKEDASTICITY

Roberto Rigobon\*

Abstract—This paper develops a method for solving the identification problem that arises in simultaneous-equation models. It is based on the heteroskedasticity of the structural shocks. For simplicity, I consider heteroskedasticity that can be described as a two-regime process and show that the system is just identified. I discuss identification under general conditions, such as more than two regimes, when common unobservable shocks exist, and situations in which the nature of the heteroskedasticity is misspecified. Finally, I use this methodology to measure the contemporaneous relationship between the returns on Argentinean, Brazilian, and Mexican sovereign bonds—a case in which standard identification methodologies do not apply.

#### I. Introduction

The question of identification when the model includes endogenous variables has been studied for several decades now. The problem arises when the structural form cannot be directly estimated and the parameters must be recovered from the reduced form, which has fewer equations than unknowns. Thus, to solve for the original parameters, more information is required. The typical solution is to impose additional constraints based on economic knowledge about the particular model that is estimated. Indeed, assumptions such as exclusion, sign, long-run, and covariance restrictions have been very useful in numerous applied problems. However, they cannot always be justified.

I present an alternative method to solve the identification problem that is based on the heteroskedasticity in the data. I show that if the structural shocks have a known correlation (usually 0), the identification problem can be solved by simply appealing to the heteroskedasticity of the structural shocks. For simplicity, I begin with a case in which there are two endogenous variables and two regimes. Subsequently, I study the cases in which there are more than two regimes,

Received for publication January 11, 2001. Revision accepted for publication September 20, 2002.

\* Sloan School of Management, MIT, and NBER.

I thank Olivier Blanchard, Frank Fisher, Robert Hall, Vincent Hogan, Lutz Kilian, Vladimir Kliouev, Guido Kuersteiner, Andrew Lo, Whitney Newey, Ken Rogoff, Brian Sack, Enrique Sentana, Min Shi, Jim Stock, Tom Stoker, Mark Watson, and three anonymous referees for helpful comments and suggestions. I thank the seminar participants at the MIT Macro seminar, the MIT Finance seminar, the Harvard International seminar, the BYU seminar, the International Seminar at Rochester, the International Seminar at Michigan, and the Econometrics lunch at MIT. An earlier version of the results of the paper were also presented at the International Seminar at Princeton and at the Finance Seminar at Ohio University. Any remaining errors are mine.

<sup>1</sup> See Fisher (1976) for the most comprehensive treatment of the subject. See Haavelmo (1947) and Koopmans, Rubin, and Leipnik (1950) for the seminal contributions.

when there are multiple endogenous variables, and when common unobservable shocks are present.

I apply this method to measure the contemporaneous propagation between the returns on several Latin American sovereign bonds. This is a case where the standard identification assumptions cannot be defended, thus leaving the problem of estimation unsolved using the traditional techniques. I show that the heteroskedasticity in sovereign-bond returns makes it feasible to estimate the relevant parameters.

The typical problem of identification is depicted in the first panel of figure 1. Assume that in the standard supply and demand problem we are interested in estimating the slope of the demand curve. The realizations are the outcomes of shocks to both the supply and the demand schedule, so the OLS estimates will be biased. The instrumental variable approach solves the problem of identification by finding a variable that shifts the supply schedule without affecting the demand curve, thus measuring the slope of the demand. The heteroskedasticity of the structural shocks works in a similar fashion.

The simplest intuition can be developed by looking at a special case: Split the sample in two, and assume that in the second subsample the supply shocks are more volatile than in the first subsample, whereas the demand shocks have a constant variance across the two subsamples. This increase in the variance of the supply shocks implies that the cloud of realizations enlarges through the demand schedule, as is shown in the second panel of figure 1. The residuals are distributed over an ellipse, and the shift in the variance implies a tilting toward the demand curve. From the instrumental variables point of view, this is equivalent to having a *probabilistic* instrument; we cannot assure that the supply curve shifts (as in the standard IV approach), but in the second sample shocks to the supply are more likely to occur. Thus, the joint behavior approximates the demand schedule more closely.

In the limit as the variance of the supply shocks goes to infinity, the ellipse collapses and becomes the demand curve. In this case, the slope of the demand can be estimated by OLS. This intuition was put forward by Philip Wright (1928). This paper extends the original methodology to the case in which the shifts in the variances are finite and the form of the heteroskedasticity is unknown. In fact, if the structural shocks are not correlated, the system is identified

FIGURE 1.—IDENTIFICATION PROBLEM.

![](_page_1_Figure_3.jpeg)

just by knowing that there is a change in the relative variance of the shocks. In particular, if both variances shift by the same amount, then the two ellipses are similar, and the system is not identified. On the other hand, if the relative importance changes, then the system will be identified by the rotation of the ellipse.

The paper is organized as follows: In section II, the typical problem of identification is specified in the bivariate setting. The methodology based on heteroskedasticity is studied when the data exhibit two regimes, as well as when they exhibit more than two. A GMM interpretation of the estimation problem is developed. In section III, necessary conditions for identification are derived for multivariate processes with unobservable common shocks. In section IV, the question of consistency under misspecification of the heteroskedasticity is explored in the bivariate setup. Two cases are studied: first, when the number of regimes are correctly specified but not the timing of the regimes, or windows; and second, when the number of regimes is smaller than the actual number exhibited by the data. In section V, an application of the identification method is presented. The contemporaneous relationship across different Latin American sovereign-bond yields is estimated. Finally, in section VI, conclusions and extensions are discussed.

#### II. Identification

Consider the following standard problem of simultaneous equations:

$$p_t = \beta q_t + \epsilon_t, \tag{1}$$

$$q_t = \alpha p_t + \eta_t, \tag{2}$$

where (1) is the demand equation, (2) is the supply equation,  $p_t$  and  $q_t$  are the observed price and quantity, and  $\epsilon_t$  and  $\eta_t$  are the structural shocks. The parameters of interest are  $\alpha$ ,  $\beta$ , and the variances of the shocks:  $\sigma_{\epsilon}^2$ ,  $\sigma_{\eta}^2$ . For the moment, assume that the structural shocks are not correlated:  $\sigma_{\epsilon\eta} = 0$ . This assumption is relaxed below.

It is well known that if  $\alpha$  and  $\beta$  are different from 0, equations (1) and (2) cannot be consistently estimated without further information. Actually, one can only estimate the covariance matrix of the reduced form  $\hat{\Omega}$  given by

$$\hat{\Omega} = \frac{1}{(1-\alpha\beta)^2} \begin{bmatrix} \beta^2 \sigma_\eta^2 + \sigma_\varepsilon^2 & \beta \sigma_\eta^2 + \alpha \sigma_\varepsilon^2 \\ & & \sigma_\eta^2 + \alpha^2 \sigma_\varepsilon^2 \end{bmatrix}\!.$$

The problem of identification is that the covariance matrix provides only three moments (the variance of  $p_t$ , the variance of  $q_t$ , and the covariance between  $p_t$  and  $q_t$ ), whereas there are four unknowns:  $\alpha$ ,  $\beta$ ,  $\sigma_{\eta}^2$ ,  $\sigma_{\varepsilon}^2$ .

The literature has solved this problem by imposing additional parameter constraints: (i) Exclusion restriction: this amounts to assuming that either  $\alpha=0$  or  $\beta=0$ . (ii) Sign restrictions: constraining the sign on the slopes of the structural equations can achieve partial identification because the two inequalities imply a region of admissible parameters.<sup>2</sup> (iii) Long-run constraints: when the structural form includes lagged dependent variables, it is possible to restrict the long-run behavior of a particular shock. This

assumption is equivalent to forcing the sum of some lag coefficients to equal zero.<sup>3</sup> (iv) Finally, constraints on the variances,<sup>4</sup> for example, that  $\sigma_{\eta}^2/\sigma_{\epsilon}^2$  is equal to some constant or to infinity. The case in which the relative variances are restricted to be equal to a constant has not been frequently used in applied work, whereas the assumption that the ratio goes to zero or to infinity is used as one of the underlying assumptions of most event studies.<sup>5</sup>

These restrictions have proven to be very useful in applied work, but there are important economic problems in which none of them can be rationalized. The purpose of this section is to offer an alternative identification method that is based on heteroskedasticity.

#### A. Identification under Two Regimes

Assume there are two regimes in the variances of the structural shocks: high and low volatility. Additionally, assume that the structural parameters are stable across the regimes. Under these assumptions the two reduced-form covariance matrices have the same structure as before:

$$\hat{\Omega}_{s} \equiv \begin{bmatrix} \omega_{11,s} & \omega_{12,s} \\ \cdot & \omega_{22,s} \end{bmatrix} \\
= \frac{1}{(1 - \alpha\beta)^{2}} \begin{bmatrix} \beta^{2} \sigma_{\eta,s}^{2} + \sigma_{\epsilon,s}^{2} & \beta \sigma_{\eta,s}^{2} + \alpha \sigma_{\epsilon,s}^{2} \\ \cdot & \sigma_{\eta,s}^{2} + \alpha^{2} \sigma_{\epsilon,s}^{2} \end{bmatrix}, \qquad (3)$$

$$s \in \{1, 2\},$$

where the regime is denoted as  $s \in \{1, 2\}$ , where the variances of the structural shocks in regime s are given by  $\sigma_{\epsilon,s}$  and  $\sigma_{\eta,s}$ , and where  $\hat{\Omega}_s$  indicates the reduced-form covariance matrix in regime s. In this new system of equations there are six unknowns  $(\alpha, \beta, \sigma_{\eta,1}^2, \sigma_{\epsilon,1}^2, \sigma_{\eta,2}^2, \text{ and } \sigma_{\epsilon,2}^2)$  and two covariance matrices, which provide six equations. If the equations are independent, the problem of identification has been solved. It is essential to restate the assumptions that lead to the identification of the system: (i) the parameters are stable across the heteroskedasticity regimes, and (ii) the structural shocks are not correlated. These assumptions are implicit in much of the applied macro work and are further discussed below.

Solving for the variances in equation (3),  $\alpha$  and  $\beta$  satisfy the following nonlinear system of equations:

$$\beta = \frac{\omega_{12,s} - \alpha \omega_{11,s}}{\omega_{22,s} - \alpha \omega_{12,s}}, \qquad s \in \{1, 2\}.$$
 (4)

<sup>&</sup>lt;sup>2</sup> Even though a unique estimate cannot be obtained, at least an admissible interval is derived. See Fisher (1976).

<sup>&</sup>lt;sup>3</sup> If it is known that one shock does not have permanent effects, then, under some conditions, it is possible to obtain identification. For example, assume that nominal shocks are short-lived, whereas real shocks are permanent. Imposing this constraint, Blanchard and Quah (1989) and Shapiro and Watson (1988) were able to estimate the effects of aggregate shocks on aggregate activity and unemployment.

<sup>&</sup>lt;sup>4</sup> Rothenberg and Ruud (1990) study the case in which covariance restrictions are imposed in linear simultaneous-equation models.

<sup>&</sup>lt;sup>5</sup> This is the original intuition developed by P. Wright (1928). See Fisher (1976) for a general discussion. See Rigobon and Sack (2002) for an application and a test of the near-identification assumption in monetary policy.

After some algebra, we see that solves the quadratic equation

$$\begin{split} & \left[ \omega_{11,1} \omega_{12,2} - \omega_{12,1} \omega_{11,2} \right] \alpha^2 \\ & - \left[ \omega_{11,1} \omega_{22,2} - \omega_{22,1} \omega_{11,2} \right] \alpha \\ & + \left[ \omega_{12,1} \omega_{22,2} - \omega_{22,1} \omega_{12,2} \right] = 0. \end{split}$$
 (5)

There are two solutions to this equation. It is easy to show that if , is one solution to the system of equations, then \* 1/, \* 1/ is the other solution. Indeed, the solutions are the two possible ways in which the structural form can be written. In other words, the system is identified up to row permutations of the original model.

**Proposition 1.** Let *pt* and *qt* be described by equations (1) and (2), where the parameters ( and ) determining the law of motion are stable and where the disturbances have finite variance, are not correlated, and exhibit heteroskedasticity that can be described with two regimes. Then, if the covariance matrices satisfy

$$\det \left| \hat{\Omega}_2 - \frac{w_{11,2}}{w_{11,1}} \hat{\Omega}_1 \right| \neq 0, \tag{6}$$

the structural form is just identified: and are consistently estimated from the two estimable covariance matrices.

**Proof.** See Appendix. -Equation (6) is equivalent to

$$w_{11,1}w_{12,2} - w_{11,2}w_{12,1} \neq 0. (7)$$

Note that the conditions (6) and (7) are similar to testing the rank condition when the order condition (number of equations) has been satisfied. In terms of the standard literature on linear systems of equations, the order condition requires that the number of equations be at least as large as the number of unknowns. The rank condition requires the number of linearly independent equations to be equal to or larger than the number of unknowns. In linear systems of equations, this is verified by computing the rank of the matrix. In the case studied here, the system is nonlinear, and the rank condition takes the form of equation (6).

Equation (6) fails if the two covariance matrices are proportional; that is, the heteroskedasticity does not identify the system if the relative variances are constant across regimes. Returning to the intuition given in the introduction, imagine that the variances of both shocks double; then the shape of the ellipse in the two regimes is the same, and nothing can be learned about the original system. Technically, this is the case in which we have six equations and six unknowns, but the equations are not independent. On the other hand, when the ratio of the variances shifts, then the heteroskedasticity changes the region in which the errors are distributed, tilting the ellipse toward one of the structural equations. This rotation of the ellipse can be estimated from the reduced-form covariances, allowing us to obtain the slope of the schedules.

The simplest intuition of how identification is achieved can be developed by first analyzing the case in which the variance changes for only one shock. Assume that it is known that at some point in time there is an increase in the variance of the supply shocks. During that period, the cloud of realizations is going to widen along the demand curve as depicted in figure 1. Observing how the ellipse of the realizations has changed across the two samples allows one to determine the slope of the demand curve. In this particular case, because it has been assumed that the structural shocks have zero correlation, this is enough to estimate the slope of the supply curve, too. Moreover, this explanation has an instrumental variables interpretation. A valid instrument to estimate the demand schedule is one that moves the supply without affecting the demand. In this example, the rise in the variance of the supply shocks becomes a *probabilistic* instrument precisely because it increases the likelihood that the supply equation "moves."

Finally, when both variances shift, there is an expansion along both axes. So it is not necessary to know which shock becomes more important across the regimes. It is enough if the relative variances shift—equation (6) will be satisfied and both schedules identified.

#### *B. Related Literature*

At this point it is useful to discuss the relationship between this methodology and the literature on identification using heteroskedasticity.

As mentioned before, the use of second moments for identification was first introduced by Philip Wright (1928). He argued that an increase in the variance of the shocks in one equation reduces the bias introduced by simultaneousequation problems in the OLS estimate of the other one. Taking the limit to infinity implies that OLS would estimate the coefficients consistently. More recent research has been conducted extending the original intuition (i) to nonlinear models, (ii) to models with parametric representations of the heteroskedasticity (such as ARCH or GARCH models), and (iii) to models that are partially identified.

Klein and Vella (2000a, b) discuss the problem of identification and estimation in a binary endogenous model when exclusion restrictions (or any other parameter restrictions) are not available and the case of the triangular model, respectively. They estimate the heteroskedasticity semiparametrically and use the residual from the second equation as an additional regressor in the first equation as the instrument.6

Sentana (1992) and Sentana and Fiorentini (2001) study the problem of estimation in factor regressions when there is conditional heteroskedasticity. The simple case developed

<sup>6</sup> See also Chen and Khan (1999) for a general solution of the problem of identification in sample selection models when the data exhibit heteroskedasticity.

in this section (proposition 1) is a special case of their proposition 3. They study the conditions in which identification is achieved in a nontriangular system when the common latent factors exhibit heteroskedasticity.

There are important differences between those papers and the approach developed here. First, the procedure highlighted in this paper requires only the knowledge that a shift in the relative variances has occurred—that is, the regime shift comes from economic events, such as crises, policy shifts, or shifts in other characteristics in the data such as heteroskedasticity with region, time, or other cross-sectional characteristics. The ARCH specification uses the time series heteroskedasticity in the data as a statistical vehicle to achieve identification. Second, the procedure described in this paper allows us to test for some of the underlying assumptions, such as parameter stability; the system is overidentified when there are more than two regimes. The techniques based on conditional heteroskedasticity are unable to provide this test. Third, as is shown below, if the heteroskedasticity is misspecified in this model, the coefficients are still consistent. This is not the case when the heteroskedasticity is modeled parametrically; misspecification in those cases can bias the contemporaneous coefficients as well. Furthermore, if the data exhibit conditional heteroskedasticity, and the procedure here described is implemented, it is still the case that the coefficients will be consistent. Fourth, models that rely on conditional heteroskedasticity to achieve identification require the number of heteroskedastic shocks to be smaller than or equal to the number of endogenous variables. As is shown in section III, this is not the case in the present procedure. If there are more than two regime shifts, then there are conditions in which it is possible to have more latent factors than endogenous variables and still being able to identify the structural system.

Though the estimation procedures in all these papers are very different, they share the same intuition for solving the problem of endogenous variables: the heteroskedasticity adds equations to the system after some covariance restrictions have been imposed. It is important to mention that these procedures require that the system of equations be linear, or in other words, that the coefficients be stable to changes in the volatility. Future research should consider extending the methodology to nonlinear specifications.

Finally, in addition to the papers mentioned above, some applied papers already have used heteroskedasticity to identify a system of equations. In the context of conditional heteroskedasticity, see Caporale, Cipollini, and Demetriades (2002a), Dungey and Martin (2001), King, Sentana, and Wadhwani (1994), and Rigobon (2002). In these papers a structural conditionally heteroskedastic model is estimated from a reduced-form GARCH model. In the context of regime switches see Caporale, Cipollini, and Spagnolo (2002b) and Rigobon and Sack (2002, 2003). In the context of testing parameter stability see Rigobon (2000). He discusses partial identification of simultaneous-equation models with unobservable common shocks. He is more concerned with developing a test for

stability of parameters than with identifying the system of equations. His procedure depends on the presence of a particular form of the heteroskedasticity, where in the short run only a subset of the variances are allowed to shift. The methodology developed here does not require this assumption.

#### C. Identification under More than Two Regimes

It is easy to extend the previous results to the case where there are more than two regimes. Assume that the data exhibit multiple finite heteroskedasticity regimes indexed by  $s \in \{1, \ldots, S\}$ . For each regime, the covariance matrix is

$$\hat{\Omega}_{s} \equiv \begin{bmatrix} \omega_{11,s} & \omega_{12,s} \\ \cdot & \omega_{22,s} \end{bmatrix} \\
= \frac{1}{(1 - \alpha\beta)^{2}} \begin{bmatrix} \beta^{2} \sigma_{\eta,s}^{2} + \sigma_{\epsilon,s}^{2} & \beta \sigma_{\eta,s}^{2} + \alpha \sigma_{\epsilon,s}^{2} \\ \cdot & \sigma_{\eta,s}^{2} + \alpha^{2} \sigma_{\epsilon,s}^{2} \end{bmatrix}.$$
(8)

This is a system that has 3S equations (one covariance matrix per regime) and 2S + 2 unknowns: S times two structural variances for each regime, plus the two parameters  $\alpha$  and  $\beta$ .

The order condition will be satisfied for any *S* larger than or equal to 2. The rank condition takes the same form as equations (6) and (7) for any pair of regimes. Indeed, the system is overidentified if there are at least three regimes that satisfy the rank condition for all combinations.

Appealing to the probabilistic IV interpretation used before, each new heteroskedastic regime is a valid instrument if and only if it satisfies the rank condition with respect to all the previous regimes. In this case, each new covariance matrix adds three equations and only two unknowns. Otherwise, the new heteroskedastic regime does not increase the number of restrictions on the structural coefficients. Hence, for S larger than 2 and for all covariance matrices satisfying the rank condition, the system of equations is overidentified, and the underlying assumption—such as that  $\alpha$  and  $\beta$  are stable through time—can be tested. The estimation has a minimum-distance interpretation where each heteroskedastic regime is equivalent to one instrument.

#### III. Identification with Common Shocks

In the previous sections, the stochastic process is bivariate and there are no common shocks. In this section, these assumptions are relaxed and the necessary conditions to achieve identification are discussed.<sup>8</sup>

 $<sup>^7</sup>$  The additional equations can also be interpreted as a factor regression model, where the left-side variables of equation (8) are the estimates (or observable), the variances ( $\sigma_{\eta s}^2$  and  $\sigma_{\epsilon s}^2$ ) are the unobservable factors, and the coefficients are the weights or factor loadings. Factor analysis usually assumes that the  $\omega_{ij,s}$ 's are independent. It is unlikely, however, that that is the case in this setup. Therefore proper corrections have to be considered in the estimation procedure. In this paper, I use the GMM interpretation.

<sup>&</sup>lt;sup>8</sup> Including common shocks in the model is equivalent to relaxing the assumption on the correlation of the structural shocks.

It should be clear that if we allow for a common unobservable heteroskedastic shock in the bivariate setting, the heteroskedasticity will not be sufficient to achieve identification. Each heteroskedastic regime adds not only three equations, but also three unknowns. So it is essential to impose some constraints on the covariances to be able to use the variation in the second moments to solve the problem of identification.

Assume that there are N endogenous variables, K common unobservable shocks, and  $s \in \{1, \ldots, S\}$  possible regimes or states. Denote the structural form as follows:

$$A_{N\times N} \begin{bmatrix} x_{1,t} \\ \vdots \\ x_{N,t} \end{bmatrix} = \Gamma_{N\times K} \begin{bmatrix} z_{1,t} \\ \vdots \\ z_{K,t} \end{bmatrix} + \begin{bmatrix} \boldsymbol{\epsilon}_{1,t} \\ \vdots \\ \boldsymbol{\epsilon}_{N,t} \end{bmatrix}, \tag{9}$$

where all the shocks are assumed to have zero correlation at all leads and lags: that is,

$$E[z_{i,t}, z_{j,t}] = 0 \qquad \forall i \neq j, \quad i, j \in \{1, K\},$$

$$E[\boldsymbol{\epsilon}_{i,t}, \boldsymbol{\epsilon}_{j,t}] = 0 \qquad \forall i \neq j, \quad i, j \in \{1, N\}, \qquad (10)$$

$$E[z_{i,t}, \boldsymbol{\epsilon}_{j,t}] = 0 \qquad \forall i \neq j, \quad i \in \{1, K\}, \ j \in \{1, N\},$$

and where  $x_{n,t}$ ,  $n \in \{1, ..., N\}$ , are the N endogenous (row vector) variables;  $z_{k,t}$ ,  $k \in \{1, ..., K\}$ , are the K unobservable common shocks, assumed to have no correlation, with variance  $\sigma_{z,k,s}$  in state s; and  $\epsilon_{n,t}$  are the structural shocks, assumed not to be correlated, with variance  $\sigma_{\epsilon,n,s}$  in state s.

The matrix  $A_{N\times N}$  contains the contemporaneous parameters,

$$A_{N\times N} = \begin{bmatrix} 1 & a_{12} & \cdots & a_{1n} \\ a_{21} & 1 & \cdots & a_{2n} \\ \vdots & \vdots & \ddots & \vdots \\ a_{n1} & a_{n2} & \cdots & 1 \end{bmatrix}, \tag{11}$$

where the assumption of normalization already has been imposed (coefficients along the diagonal are equal to 1). The matrix  $\Gamma_{N\times K}$  contains the parameters from the common shocks, where normalization is also assumed; in this case, it implies a unit impact on the first equation:

$$\Gamma_{N\times K} = \begin{bmatrix} 1 & 1 & \cdots & 1 \\ \gamma_{21} & \gamma_{22} & \cdots & \gamma_{2k} \\ \vdots & \vdots & \ddots & \vdots \\ \gamma_{n1} & \gamma_{n2} & \cdots & \gamma_{nk} \end{bmatrix}.$$
 (12)

**Proposition 2.** A multivariate system of N equations, with K unobservable common shocks, described by equations (9), (10), (11), and (12), is identified if and only if, for N > 1,

(i) the number of states (S) satisfies

$$S \ge 2 \frac{(N+K)(N-1)}{N^2 - N - 2K},\tag{13}$$

(ii) there is a minimum number of endogenous variables (or maximum number of common shocks) that satisfies

$$N^2 - N - 2K > 0, (14)$$

and

(iii) the covariance matrices constitute a system of equations that is linearly independent.

## **Proof.** See Appendix. ■

Equation (14) is the *catch-up* constraint. It indicates the conditions under which one additional regime in the variance-covariance adds more equations than unknowns. In the example that motivated this section, (N = 2 and K = 1) implies that the inequality is not satisfied and no further information is obtained from the heteroskedasticity. Moreover, if the common shocks are interpreted as the sources of correlation between the structural shocks, then this constraint indicates that some of the covariances of the structural shocks must be restricted to be constant or zero. Solving for K, it is found that identification requires K < N(N-1)/2, where the right-hand side is exactly the number of all possible contemporaneous correlations among structural shocks.

There are two main implications of proposition 2: First, in the absence of common shocks only two states are required to achieve identification, independently of the number of endogenous variables, N. Second, if K > 0 and N is finite, the number of states required to achieve identification is always larger than 2.

The estimation of this model is performed by GMM where the moment conditions are

$$A\Omega_{s}A' = \Gamma\Omega_{z,s}\Gamma' + \Omega_{\epsilon,s}, \tag{15}$$

where  $\Omega_s$  is the covariance matrix that can be estimated in the data from the observed variables  $(x_t)$  in regime s, where  $\Omega_{z,s}$  is the covariance matrix of the common unobservable shocks in regime s, which, given the assumptions in equation (10), is a diagonal matrix, and where  $\Omega_{\epsilon,s}$  is the covariance matrix of the structural shocks in regime s, which given the assumptions in equation (10), is also diagonal. The parameters of interest are s and s.

# IV. Consistency under Misspecification of the Heteroskedasticity

An important question arising from the previous derivation is the issue of consistency when the heteroskedasticity is misspecified. This section shows that the estimates are consistent even though the regimes might be misspecified.

In this section two cases are evaluated: (i) when the windows of the heteroskedasticity are wrongly specified but the number of regimes is correct, and (ii) when the data have more regimes than the ones assumed in the specification.

Without loss of generality, only the bivariate case in which there are no common shocks is discussed.

The intuition about why consistency is achieved in these two cases is that the misspecified covariance matrices are linear combinations of the true underlying ones. Therefore, the misspecified system of equations is a linear transformation of the original problem. If this linear transformation does not lower the rank of the system, the same solution is obtained. It is not proven in this section, but it should be intuitively obvious, that the misspecification reduces the power of the test by eliminating the differences across regimes. For example, in the limit when the misspecification is so large that the system decreases in rank, then the estimates are inconsistent—there is a continuum of them.

#### A. Misspecification of the Regime Windows

Assume the system is described by equations (1) and (2), and that the data exhibit heteroskedasticity with only two regimes. If the windows are misspecified, the computed covariance matrices are linear combinations of the true underlying covariance matrices. Denote

$$\Omega_{r1} = \lambda_{r1}\Omega_1 + (1 - \lambda_{r1})\Omega_2,$$

$$\Omega_{r2} = (1 - \lambda_{r2})\Omega_1 + \lambda_{r2}\Omega_2,$$

where  $\Omega_1$  and  $\Omega_2$  are the true covariance matrices describing the heteroskedasticity,  $\Omega_{r1}$  and  $\Omega_{r2}$  are the estimated covariance matrices, and  $\lambda_{r1}$  and  $\lambda_{r2}$  are weights indicating how correct the windows are: when they are equal to 1, the windows coincide with the true regimes.

**Proposition 3.** Assume the original system satisfies the rank condition (6). If the misspecified heteroskedasticity also satisfies (6), then the model is identified and its estimators are consistent.

# **Proof.** See Appendix. ■

In other words, if the computed covariance matrices satisfy the rank condition, then the estimates are consistent even if the regimes have been slightly misspecified. On the other hand, if the misspecification is so large that the system fails the rank condition, then the coefficients are not identified. Hence, the estimated coefficients should be consistent for small perturbations of the regime definitions.

Remember that the equivalent rank condition is testable. Therefore, the degree of misspecification can be detected in the applications.

#### B. Underspecified Number of Regimes

Assume the system is described by equations (1) and (2), and that the data exhibit heteroskedasticity with  $S^*$  regimes, where there are no restrictions to the form of the heteroske-

dasticity. For simplicity denote the variances of the structural shocks in each regime as follows:

$$\sigma_{\eta,s}^2 = (1 + \delta_{\eta,s})\sigma_{\eta,0}^2, \sigma_{\epsilon,s}^2 = (1 + \delta_{\epsilon,s})\sigma_{\epsilon,0}^2, \qquad \forall s \neq 0,$$

where  $\sigma_{\eta,s}^2$  and  $\sigma_{\epsilon,s}^2$  represent the variances of the idiosyncratic shocks in regime s, and  $\delta_{\eta,s}$  and  $\delta_{\epsilon,s}$  are the changes of those variances relative to the variances from regime s=0.

Assume that only two regimes are used in the estimation. Without loss of generality assume that the first window corresponds to the first set of  $\hat{s} < S^*$  regimes and that the second window corresponds to the second set of  $S^* - \hat{s}$  regimes. The covariance matrices of each of the misspecified periods are given by (written in *vech* notation)

$$vech(\Omega_{r1}) = \frac{1}{(1 - \alpha\beta)^2} \times \begin{bmatrix} \beta^2 \frac{1}{\hat{s}} \sum_{s < \hat{s}} \sigma_{\eta, s}^2 + \frac{1}{\hat{s}} \sum_{s < \hat{s}} \sigma_{\epsilon, s}^2 \\ \beta \frac{1}{\hat{s}} \sum_{s < \hat{s}} \sigma_{\eta, s}^2 + \alpha \frac{1}{\hat{s}} \sum_{s < \hat{s}} \sigma_{\epsilon, s}^2 \\ \frac{1}{\hat{s}} \sum_{s < \hat{s}} \sigma_{\eta, s}^2 + \alpha^2 \frac{1}{\hat{s}} \sum_{s < \hat{s}} \sigma_{\epsilon, s}^2 \end{bmatrix}$$

for the first window, and

$$vech(\Omega_{r2}) = \frac{1}{(1 - \alpha\beta)^{2}} \times \begin{bmatrix} \beta^{2} \frac{1}{S^{*} - \hat{s}} \sum_{s > \hat{s}} \sigma_{\eta,s}^{2} + \frac{1}{S^{*} - \hat{s}} \sum_{s > \hat{s}} \sigma_{\epsilon,s}^{2} \\ \beta \frac{1}{S^{*} - \hat{s}} \sum_{s > \hat{s}} \sigma_{\eta,s}^{2} + \alpha \frac{1}{S^{*} - \hat{s}} \sum_{s > \hat{s}} \sigma_{\epsilon,s}^{2} \\ \frac{1}{S^{*} - \hat{s}} \sum_{s > \hat{s}} \sigma_{\eta,s}^{2} + \alpha^{2} \frac{1}{S^{*} - \hat{s}} \sum_{s > \hat{s}} \sigma_{\epsilon,s}^{2} \end{bmatrix}$$

for the second one. The two matrices can be rewritten as

$$\begin{split} \textit{vech}(\Omega_{\textit{rl}}) \\ &= \frac{1}{(1 - \alpha \beta)^2} \begin{bmatrix} (1 + \delta_{\eta,\textit{rl}}) \beta^2 \sigma_{\eta,0}^2 + (1 + \delta_{\eta,\textit{rl}}) \sigma_{\varepsilon,0}^2 \\ (1 + \delta_{\eta,\textit{rl}}) \beta \sigma_{\eta,0}^2 + (1 + \delta_{\eta,\textit{rl}}) \alpha \sigma_{\varepsilon,0}^2 \\ (1 + \delta_{\eta,\textit{rl}}) \sigma_{\eta,0}^2 + (1 + \delta_{\eta,\textit{rl}}) \alpha^2 \sigma_{\varepsilon,0}^2 \end{bmatrix}, \\ \textit{vech}(\Omega_{\textit{r2}}) &= \frac{1}{(1 - \alpha \beta)^2} \begin{bmatrix} (1 + \delta_{\eta,\textit{r2}}) \beta^2 \sigma_{\eta,0}^2 + (1 + \delta_{\eta,\textit{r2}}) \sigma_{\varepsilon,0}^2 \\ (1 + \delta_{\eta,\textit{r2}}) \beta \sigma_{\eta,0}^2 + (1 + \delta_{\eta,\textit{r2}}) \alpha \sigma_{\varepsilon,0}^2 \\ (1 + \delta_{\eta,\textit{r2}}) \sigma_{\eta,0}^2 + (1 + \delta_{\eta,\textit{r2}}) \alpha^2 \sigma_{\varepsilon,0}^2 \end{bmatrix}, \end{split}$$

where

$$\delta_{\eta,r1} = \frac{1}{\hat{s}} \sum_{s < \hat{s}} \delta_{\eta,s} \quad \text{and} \quad \delta_{\eta,r2} = \frac{1}{S^* - \hat{s}} \sum_{s > \hat{s}} \delta_{\eta,s}, \quad (16)$$

$$\delta_{\epsilon,r1} = \frac{1}{\hat{s}} \sum_{s < \hat{s}} \delta_{\epsilon,s} \quad \text{and} \quad \delta_{\epsilon,r2} = \frac{1}{S^* - \hat{s}} \sum_{s > \hat{s}} \delta_{\epsilon,s}. \tag{17}$$

**Proposition 4.** Assume the true heteroskedasticity is described by *S*\* regimes and that those covariance matrices satisfy the rank condition (6). Assume that only two regimes have been used in the estimation. Then, if the following conditions are satisfied, the system is identified and its estimates are consistent:

- 1. The misspecified covariance matrices have to exhibit heteroskedasticity: *<sup>r</sup>*<sup>1</sup> *r*2.
- 2. The misspecified covariance matrices satisfy the rank condition (6).
