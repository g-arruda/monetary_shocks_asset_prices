![](_page_0_Picture_1.jpeg)

The Economic Journal, 128 (May), 917–948. Doi: 10.1111/ecoj.12593 © 2018 Royal Economic Society. Published by John Wiley & Sons, 9600 Garsington Road, Oxford OX4 2DQ, UK and 350 Main Street, Malden, MA 02148, USA.

# IDENTIFICATION AND ESTIMATION OF DYNAMIC CAUSAL EFFECTS IN MACROECONOMICS USING EXTERNAL INSTRUMENTS\*

James H. Stock and Mark W. Watson

External sources of as-if randomness — that is, external instruments — can be used to identify the dynamic causal effects of macroeconomic shocks. One method is a one-step instrumental variables regression (local projections – IV); a more efficient two-step method involves a vector autoregression. We show that, under a restrictive instrument validity condition, the one-step method is valid even if the vector autoregression is not invertible, so comparing the two estimates provides a test of invertibility. If, however, lagged endogenous variables are needed as control variables in the one-step method, then the conditions for validity of the two methods are the same.

The identification and estimation of dynamic causal effects is a defining challenge of macroeconometrics. In the macroeconomic tradition dating to Frisch (1933) and Slutsky (1937), dynamic causal effects are conceived as the effect, over time, of an intervention that propagates through the economy, as modelled by a system of simultaneous equations. Restrictions on that system can be used to identify its parameters.

In a classic result by the namesake of this lecture, Sargan (1964) (along with Rothenberg and Leenders, 1964) showed that full information maximum likelihood estimation, subject to identifying restrictions, is asymptotically equivalent to instrumental variables (IV) estimation by three stage least squares. The three stage least squares instruments are obtained from restrictions on the system, typically that some variables and/or their lags enter some equations but not others, and thus are 'internal' instruments – they are internal to the system. The massive modern literature since Sims (1980) on point-identified structural vector autoregressions (SVARs) descends from this tradition, and nearly all the papers in that literature can be interpreted as achieving identification through internal instruments. In these models, structural shocks are the interventions of interest, and the goal is to estimate the dynamic causal effect of these shocks on macroeconomic outcomes.

In contrast, modern microeconometric identification strategies rely heavily on 'external' sources of variation that provide quasi-experiments to identify causal effects. Such external variation might be found, for example, in institutional idiosyncrasies that introduce as-if randomness in the variable of interest (the treatment). The use of

\*Corresponding author: James H. Stock, Department of Economics, Harvard University, Cambridge MA 02138, USA. Email: james\_stock@harvard.edu.

This work was presented by Stock as the Sargan Lecture to the Royal Economic Society on 11 April 2017. We thank Paul Beaudry, Mark Gertler, Oscar Jorda, Daniel Lewis, Karel Mertens, Mikkel Plagborg-Møller, Glenn Rudebusch, Jose Luis Montiel Olea, Valerie Ramey, Morten Ravn, Giovanni Ricco, Neil Shephard, Leif Anders Thorsrud, Christian Wolf and an anonymous referee for helpful comments and/or discussions.

such external instruments in microeconometrics has proven highly productive and has yielded compelling estimates of causal effects.

The subject of this article is the use of external instruments to estimate dynamic causal effects in macroeconomics. By an external instrument, we mean a variable that is correlated with a shock of interest, but not with other shocks, so that the instrument captures some exogenous variation in the shock of interest. These instruments are typically not a macro variable of ultimate interest, and as such they are external to the system. In referring to these instruments as external, we also connect with the original term for instruments, external factors (Wright, 1928).

External instruments can be used to estimate dynamic causal effects directly without an intervening VAR step. This method uses an instrumental variables (IV) version of what is called in the forecasting literature a direct multistep forecasting regression; in the impulse response literature, this method is called a local projection. Alternatively, the instruments can be used in conjunction with a VAR to identify structural impulse response functions; this is the IV version of an iterated multistep forecast.

The use of external instruments has opened a new and rapidly growing research programme in macroeconometrics, in which credible identification is obtained using as-if random variation in the shock of interest that is distinct from – external to – the macroeconomic shocks hitting the economy. In many applications, the instrument is constructed as a partial measure of the shock of interest: the quantity of oil kept from market because of a political disruption, a change in fiscal policy not related to business cycle conditions, or the part of a monetary shock revealed during a monetary policy announcement window. Such constructed measures typically have measurement error, which in general leads to bias if the measure is treated as the true shock. However, that measurement error need not compromise the validity of the measure as an instrument. As in the microeconometric setting, finding such instruments is not easy. Still, in our view this research programme holds out the potential for more credible identification than is typically provided by SVARs identified using internal restrictions.

This article unifies and explicates a number of strands of recent work on external instruments in macroeconometrics. The idea that constructed shock series are best thought of as instruments is not new: Blanchard and Sims made this observation in the published general discussion of Romer and Romer (1989), but it seems not to have been followed up. To our knowledge, the earliest work to use constructed shocks as an instrument in a SVAR is Beaudry and Saito (1998), who use the Romer and Romer (1989) indicators to estimate impulse responses to monetary shocks. The method of external instruments for SVAR identification (SVAR-IV) was introduced by Stock (2008), and has been used by Stock and Watson (2012), Mertens and Ravn (2013), Gertler and Karadi (2015), Caldara and Kamps (2017) and a growing list of other researchers. Turning to single-equation methods, Hamilton (2003) developed a list of exogenous oil supply disruptions, which he used as an instrument for autoregressive-distributed lag estimation of the effect of oil supply shocks on GDP. The modern use of external instruments to estimate structural impulse response functions directly (that is, without estimating a VAR or iterating) dates to Jorda et al. (2015) and Ramey and Zubairy (2017), and is clearly exposited in Ramey (2016). The condition for instrument validity in the direct regression without control variables, given in Section 1 below, appears in unpublished lecture notes by Mertens (2015). Those notes and Fieldhouse et al. (2017) discuss the extension of these conditions to control variables. Jorda et al. (2015) and Ramey (2016) call these direct IV regressions 'local projections-IV' (LP-IV) in reference to Jorda's (2005) method of local projections (LP) on which it builds. We adopt this terminology while noting that these IV regressions emerge from the much older tradition of simultaneous equations estimation in macroeconomics pioneered by Sargan and his contemporaries. Although these methods increasingly are being used in applications, we are not aware of a unified presentation of the econometric theory of and connections between the SVAR-IV and LP-IV methods.

In addition to expositing the use of external instruments in macroeconomics, this article makes five contributions to this literature.

First, we provide conditions for instrument validity for LP-IV, and show that under those conditions LP-IV can estimate dynamic causal effects without assuming invertibility, that is, without assuming that the structural shocks can be recovered from current and lagged values of the observed data. Because of the dynamic nature of the macroeconometric problem, exogeneity of the instrument entails a strong 'lead– lag exogeneity' requirement that the instrument be uncorrelated with past and future shocks, at least after including control variables. This condition provides concrete guidance for the construction of instruments and choice of control variables when undertaking LP-IV.

Second, we recapitulate how IV estimation can be undertaken in a SVAR (the SVAR-IV method). This method is more efficient asymptotically than LP-IV under stronginstrument asymptotics, and it does not require lead–lag exogeneity. But to be valid, this method requires invertibility. Invertibility is a very strong, albeit commonly made, assumption: under invertibility, a forecaster using a VAR would find no value in augmenting her system with data on the true macroeconomic shocks, were they magically to become available.

Third, having a more efficient estimator of the structural impulse response function (SVAR-IV) that requires invertibility for consistency, and a less efficient estimator (LP-IV) that does not, gives rise to a Hausman (1978)-type test for whether the SVAR is invertible. We provide this test statistic, obtain its large-sample null distribution, introduce the concept of local non-invertibility and derive the local asymptotic power of the test against this alternative. The focus of this test on the impulse response function – the estimand of interest – differs from existing tests for invertibility, which examine the no-omitted-variables implication by adding variables; see, for example, Forni and Gambetti (2014).

Fourth, lest one think that LP-IV is too good to be true, we provide a 'no free lunch' result. Suppose an instrument satisfies a contemporaneous exogeneity condition, but not the no lead–lag exogeneity condition because it is correlated with past shocks. A natural approach is to include additional regressors – lagged macro variables – that control for the lagged shocks. We show, however, that the condition for these control variables to produce valid inference in LP-IV is in general equivalent to assuming invertibility of the corresponding VAR, in which case SVAR-IV provides more efficient inference.

Fifth, we discuss some econometric odds and ends, such as heteroscedasticity and autocorrelation-robust (HAR) standard errors, what to do if the external instruments are weak, estimation of cumulative dynamic effects, forecast error variance decompositions and the pros and cons of using generic controls including factors from dynamic factor models (factor-augmented LP-IV).

Following Ramey (2016), we illustrate these methods using Gertler and Karadi's (2015) application, in which they estimate the dynamic causal effect of a monetary policy shock using SVAR-IV, with an instrument that captures the news revealed in regularly scheduled monetary policy announcements by the Federal Open Market Committee.

Before proceeding, we note two substantial simplifications made throughout this article. First, we focus exclusively on linear models and identification through second moments, so that conditional expectations are typically replaced by projections. Second, we assume homogenous treatment effects so that valid instruments all have the same estimand (i.e. the local average treatment effect equals the average treatment effect). Both these simplifications are non-trivial. The assumption of non-linearity, in particular, rules out a frequent justification for using LP methods (either OLS or LP-IV), which is that LP methods can estimate non-linear effects without needing to model them as a system. That said, there is a tension between the assumption that the control variables and specification are correct in the single-equation specification, and what this must imply for the full system, and this tension is unresolved in the literature and merits further investigation. We return to this point in the conclusions.

Finally, we use two notational devices: the subscript '2:n' denotes the elements of a vector or matrix other than the first row or column, and {...} denotes a linear combination of the terms inside the braces.

# 1. Identifying Dynamic Causal Effects Using External Instruments and Local Projections

The LP-IV method emerges naturally from the modern microeconometrics use of instrumental variables. Making this connection requires some translation between two sets of jargon, however, so we start with a brief review of causal effects and instrumental variables regression in the microeconometric setting.

### 1.1. Causal Effects and Instrumental Variables Regression

Our starting point is that the expected difference in outcomes between the treatment and control groups in a randomised controlled experiment with a binary treatment is the average treatment effect.<sup>1</sup> In brief, if a binary treatment X is randomly assigned, then all other determinants of Y are independent of X, which implies that the (average) treatment effect is <sup>E</sup>(Y|<sup>X</sup> <sup>=</sup> 1) <sup>E</sup>(Y|<sup>X</sup> <sup>=</sup> 0). In the linear model Y = c + Xb + u, where b is the treatment effect, random assignment implies that

<sup>1</sup> This starting point is actually a result, or conclusion, of a vast literature on defining causal effects for statistical analysis. See Imbens (2014) for a review, including discussion of both the potential outcomes framework and graphical models.

<sup>©</sup> 2018 Royal Economic Society.

E(u|X) = 0 so that the population regression coefficient is the treatment effect. If randomisation is conditional on covariates W, then the treatment effect for an individual with covariates W = w is estimated by the outcome of a random experiment on a group of subjects with the same value of W, that is, it is E(Y|X = 1, W = w) - E(Y|X = 0, W = w). With the additional assumptions of linearity and homogeneous treatment effects, this treatment effect is estimated by ordinary least squares estimation of

$$Y = \beta X + \gamma' W + u,\tag{1}$$

where the intercept has been subsumed in  $\gamma'W$ .

In observational data, the treatment level X is often endogenous. This is generally the case when the subject has some control over receiving the treatment in an experiment. But if there is some source of variation Z that is correlated with treatment, such as random assignment to the treatment or control group, conditional on observed covariates W, then the causal effect can be estimated by instrumental variables. Let ' $^{\perp}$ ' denote the residual from the population projection onto W, for example,  $X^{\perp} = X - \text{Proj}(X|W)$ . If the instrument satisfies the conditions:

(i) 
$$E(X^{\perp}Z^{\perp}) \neq 0$$
 (relevance), (2)

(ii) 
$$E(u^{\perp}Z^{\perp}) = 0$$
 (exogeneity), (3)

and if the instruments are strong, then instrumental variables estimation of (1) consistently estimates the causal effect  $\beta$ .

#### 1.2. Dynamic Causal Effects and the Structural Moving Average Model

In macroeconomics, we can imagine a counterpart of a randomised controlled experiment. For example, in the US, the Federal Open Market Committee (FOMC) could set the Federal Funds rate according to a rule, such as the Taylor rule, perturbed by a randomly chosen amount. Although we have only one subject (the US macroeconomy), by repeating this experiment through time, the FOMC could generate data on the effect of these random interventions.

More generally, let  $\varepsilon_{1,t}$  denote the mean-zero random treatment at date t. Then the causal effect on the value of a variable  $Y_2$ , h periods hence, of a unit intervention in  $\varepsilon_1$  is

$$E_t(Y_{2,t+h}|\varepsilon_{1,t}=1) - E_t(Y_{2,t+h}|\varepsilon_{1,t}=0).$$

We now assume linearity and stationarity, assumptions we maintain henceforth. With these assumptions, the h-lag treatment effect is the population coefficient in the regression:

$$Y_{2,t+h} = \Theta_{h,21}\varepsilon_{1,t} + u_{t+h},\tag{4}$$

where throughout we omit constant terms for convenience. Because  $\varepsilon_{1,t}$  is randomly assigned,  $E(u_{t+h}|\varepsilon_{1t}) = 0$ , so  $\Theta_{h,21} = E(Y_{2,t+h}|\varepsilon_{1,t} = 1) - E(Y_{2,t+h}|\varepsilon_{1,t} = 0)$ . Thus,  $\Theta_{h,21}$  is the causal effect of treatment 1 on variable 2, h periods after the treatment. Were  $\varepsilon_{1,t}$  observed, this causal effect could be estimated by OLS estimation of (4).

The path of causal effects mapped out by Θh,21 for h = 0, 1, 2, ... is the dynamic causal effect of treatment 1 on variable 2.<sup>2</sup>

The macroeconometric jargon for this random treatment ɛ1,<sup>t</sup> is a 'structural shock': a primitive, unanticipated economic force, or driving impulse, that is unforecastable and uncorrelated with other shocks.<sup>3</sup> The macroeconomist's shock is the microeconomists' random treatment, and impulse response functions are the causal effects of those treatments on variables of interest over time, that is, dynamic causal effects.

The Slutzky–Frisch paradigm represents the path of observed macroeconomic variables as arising from current and past shocks and measurement error. If we collect all such structural shocks and measurement error together in the m 9 1 vector ɛt, the n 9 1 vector of macroeconomic variables Yt can be written in terms of current and past ɛt:

$$Y_t = \Theta(\mathbf{L})\varepsilon_t,\tag{5}$$

where L is the lag operator and Θ(L) = Θ<sup>0</sup> + Θ1L + Θ2L<sup>2</sup> + ... , where Θ<sup>h</sup> is an n 9 m matrix of coefficients. The shock variance matrix ∑ɛɛ = Eɛtɛ<sup>t</sup> <sup>0</sup> is assumed to be positive definite to rule out trivial (non-varying) shocks. We assume that the shocks are mutually uncorrelated. Throughout, we treat Yt as having been transformed so that it is second-order stationary, for example, real activity variables would appear in growth rates.

The assumption that the structural shocks are mutually uncorrelated accords both with their interpretation as randomly assigned treatments and with their being primitive economic forces; see Ramey (2016) for a discussion. We assume that any measurement error included in ɛ<sup>t</sup> is uncorrelated with the structural shocks, although measurement error could be correlated across variables. Because ɛ1,<sup>t</sup> is uncorrelated with the other shocks and with any measurement error, the causal effect can be written as <sup>E</sup>ðY2;tþhje1;<sup>t</sup> <sup>¼</sup> <sup>1</sup>;e2:n;<sup>t</sup> ;es;<sup>s</sup> 6¼ <sup>t</sup>Þ <sup>E</sup>ðY2;tþhje1;<sup>t</sup> <sup>¼</sup> <sup>0</sup>;e2:n;<sup>t</sup> ;es;<sup>s</sup> 6¼ <sup>t</sup>Þ. Although conditioning on the other shocks is redundant by randomisation, this alternative expression connects with the definition, seen in the older macro literature, of the causal effect as the partial derivative @Y2,t+h/@ɛ1,t, holding all other shocks constant.

Representation (5) is the structural moving average representation of Yt. The coefficients of Θ(L) are the structural impulse response functions, which are the dynamic causal effects of the shocks. In general, the number of shocks plus measurement errors, m, can exceed the number of observed variables, n.

The recognition that, if ɛ1,<sup>t</sup> were observed, Θh,21 could be estimated by OLS estimation of (4) – or by OLS estimation of the distributed lag regression of Yt on ɛ1,t, <sup>ɛ</sup>1,t1, <sup>ɛ</sup>1,t2, ... – underpins a productive and insightful research programme. In this programme, which dates to Romer and Romer (1989), researchers aim to measure directly a specific macroeconomic shock. Influential examples include Rudebusch

<sup>2</sup> There is a literature that defines dynamic causal effects in terms of primitives and connects those to what can be identified in an experiment with data collected over time; see Lechner (2009), Angrist et al. (2018), Jorda et al. (2017) and especially Bojinov and Shephard (2017) for discussion and references. With the additional assumptions of linearity and stationarity, Bojinov and Shephard's (2017) dynamic potential outcomes framework leads to (4). <sup>3</sup> For an extensive discussion, see Ramey (2016).

(1998), who measured monetary shocks by Fed Funds surprises controlling for employment report announcements, and Kuttner (2001), Cochrane and Piazzesi (2002), Faust *et al.* (2003), Gürkaynak *et al.* (2005) and Bernanke and Kuttner (2005), all of whom used interest rate changes around Federal Reserve announcement dates to measure monetary policy shocks.

#### 1.3. Direct Estimation of Structural IRFs Using External Instruments (LP-IV)

One difficulty with directly measured shocks is that they capture only part of the shock, or are measured with error. For example, Kuttner (2001)-type variables measure that part of a shock revealed in a monetary policy announcement but not the part revealed, for example, in speeches by FOMC members. This concern applies to other examples, including Romer and Romer's (1989) binary indicators, Romer and Romer's (2010) measure of exogenous changes in fiscal policy and Hamilton's (2003) and Kilian's (2008) lists of exogenous oil supply disruptions. In all of these cases, the constructed variable is correlated with the true (unobserved) shock and, if the author's argument for exogeneity is correct, the constructed variable is uncorrelated with other shocks. That is, the constructed variable is not the shock, but is an instrument for the shock. This instrument is not obtained from restrictions internal to a VAR (or some other dynamic simultaneous equations model); rather, it is an external instrument.

This reasoning suggests using instrumental variables methods to estimate the dynamic causal effects of the shock. To do so, however, requires resolving a difficulty not normally encountered in microeconometrics, which is that the shock/treatment  $\varepsilon_{1,t}$  is unobserved. As a result, the scale of  $\varepsilon_{1,t}$  is indeterminate, that is, (4) holds for all h if  $\varepsilon_{1,t}$  is replaced by  $\varepsilon$   $\varepsilon_{1,t}$  and  $\Theta_{h,21}$  is replaced by  $\varepsilon^{-1}\Theta_{h,21}$ . This scale ambiguity is resolved by adopting, without loss of generality, a normalisation for the scale of  $\varepsilon_{1,t}$ . Specifically, we assume that  $\varepsilon_{1,t}$  is such that a unit increase in  $\varepsilon_{1,t}$  increases  $Y_{1,t}$  by one unit:

$$\Theta_{0,11} = 1$$
 (unit effect normalisation). (6)

For example, if  $\varepsilon_{1,t}$  is the monetary policy shock and  $Y_{1,t}$  is the federal funds rate, (6) fixes the scale of  $\varepsilon_{1,t}$  so that a 1 percentage point monetary policy shock increases the federal funds rate by 1 percentage point.

The unit effect normalisation has advantages over the more common unit standard deviation normalisation, which sets  $var(\varepsilon_{1,t}) = 1$ . Most importantly, the unit effect normalisation allows for direct estimation of the dynamic causal effect in the native units relevant to policy analysis. While one can convert one normalisation to another, doing so entails rescaling by estimated values and care must be taken to conduct inference incorporating that normalisation (we elaborate on this below). As discussed in Stock and Watson (2016), the unit effect normalisation also allows for direct extension of SVAR methods to structural dynamic factor models.

The unit effect normalisation underpins the local projection approach because it allows the regression (4) to be rewritten in terms of an observable regressor,  $Y_{1,t}$ . Specifically, use the unit effect normalisation to write  $Y_{1,t} = \varepsilon_{1,t} + \{\varepsilon_{2:n,t}, \varepsilon_{t-1}, \varepsilon_{t-2}, \ldots\}$  (recall the notational devices that  $\varepsilon_{2:n,t} = (\varepsilon_{2,t}, \ldots, \varepsilon_{n,t})'$  and that  $\{\ldots\}$  denotes a linear combination of the terms in braces). Rewriting this expression in terms of  $\varepsilon_{1,t}$  and substituting it into (4) yields

$$Y_{i,t+h} = \Theta_{h,i1} Y_{1,t} + u_{i,t+h}^h, \tag{7}$$

where  $u_{i,t+h}^h = \{\varepsilon_{t+h}, \dots, \varepsilon_{t+1}, \varepsilon_{2:n,t}, \varepsilon_{t-1}, \varepsilon_{t-2}, \dots\}$ . Because  $Y_{1,t}$  is endogenous, it is correlated with  $u_{i,t+h}^h$ , so OLS estimation of (7) is not valid. But with a suitable instrument, (7) can be estimated by IV.

Let  $Z_t$  be a vector of instrumental variables. These instruments can be used to estimate the dynamic causal effect using (7) if they satisfy:

#### CONDITION LP-IV

- (i)  $E(\varepsilon_{1,t}Z_t') = \alpha' \neq 0$  (relevance);
- (ii)  $E(\varepsilon_{2:n,t}Z_t') = 0$  (contemporaneous exogeneity);
- (iii)  $E(\varepsilon_{t+j}Z_t') = 0$  for  $j \neq 0$  (lead–lag exogeneity).

Conditions LP-IV (i) and (ii) are conventional IV relevance and exogeneity conditions, and are the counterparts of the microeconometric conditions equations (2) and (3) in the absence of control variables.

Condition LP-IV (iii) arises because of the dynamics. The key idea of this condition is that  $Y_{2,t+h}$  generally depends on the entire history of the shocks, so if  $Z_t$  is to identify the effect of shock  $\varepsilon_{1,t}$  alone, it must be uncorrelated with all shocks at all leads and lags. The requirement that  $Z_t$  be uncorrelated with future  $\varepsilon$ 's is generally not restrictive: when  $Z_t$  contains only variables realised at date t or earlier, it follows from the definition of shocks as unanticipated structural disturbances. In contrast, the requirement that  $Z_t$  be uncorrelated with past  $\varepsilon$ 's is restrictive and strong.

We will refer to Condition LP-IV (*iii*) as requiring that  $Z_t$  be unpredictable given past  $\varepsilon$ 's, although strictly the requirement is that it not be linearly predictable given past  $\varepsilon$ 's. Note that  $Z_t$  could be serially correlated yet satisfy this condition. For example, suppose  $Z_t = \delta \varepsilon_{1,t} + \zeta_b$  where  $\zeta_t$  is a serially correlated error that is independent of  $\{\varepsilon_t\}$ ; then  $Z_t$  satisfies Condition LP-IV.

The IV estimator of  $\Theta_{h,i1}$  obtains by noting two implications of the assumptions. First, Condition LP-IV and (5) imply that  $E(Y_{i,t+h}Z_t') = \Theta_{h,i1}\alpha'$ . Second, Condition LP-IV, the unit effect normalisation (6) and (5) imply that  $E(Y_{1,t}Z_t') = \alpha'$ . Thus, when  $Z_t$  is a scalar:

$$\frac{E(Y_{i,t+h}Z_t)}{E(Y_{1,t}Z_t)} = \Theta_{h,i1}.$$
(8)

For a vector of instruments,  $E(Y_{i,t+h}Z_t')HE(Z_tY_{1,t})/E(Y_{1,t}Z_t')HE(Z_tY_{1,t}) = \Theta_{h,i1}$  for any positive definite matrix H. These are the moment expressions for IV estimation of (7) using the instrument  $Z_t$ .

These moment expressions provide an intuitive interpretation of LP-IV. Suppose that  $Y_{i,t}$  is GDP growth,  $Y_{1,t}$  is the federal funds rate and  $Z_t$  is a monetary policy announcement instrument, constructed so that it satisfies Condition LP-IV. Then the causal effect of a monetary policy shock on GDP growth h periods hence is estimated by regressing  $\Delta \ln \text{GDP}_{t+h}$  on FF<sub>b</sub> using the announcement surprise  $Z_t$  as an instrument. In this two-stage least squares interpretation, the unit effect normalisation is imposed automatically.

Another interpretation of the moment condition (8) relates to the distributed lag representation of  $Y_t$  in terms of  $Z_t$ :

$$Y_t = \Pi(L)Z_t + v_t. \tag{9}$$

This is Theil and Boot's (1962) final form of the dynamic model for  $(Y_b, Z_t)$ . It is also the time series counterpart to what is (somewhat confusingly) called the reduced form for non-dynamic simultaneous equations systems. In the non-dynamic setting with a single instrument, a familiar result is that the Wald IV estimator is the ratio of the reduced-form coefficients. Similarly, in the dynamic context, when  $Z_t$  is serially uncorrelated and a scalar,  $\Theta_{h,i1}$  is the ratio of the hth distributed lag coefficient in the  $Y_{i,t}$  equation,  $\Pi_{h,i}$  to the impact effect on the first variable,  $\Pi_{0,1}$ ; that is,  $\Theta_{h,i1} = \Pi_{h,i}/\Pi_{0,1}$ . In the monetary policy announcement example,  $\Pi(L)$  is the impulse response function of  $Y_t$  with respect to the announcement surprise. The older literature treated this as the causal effect of interest, but as explained in Gertler and Karadi (2015), the surprise is better thought of as an instrument for the shock. Akin to the Wald estimator in the static setting, the IV estimator of the dynamic causal effect is the impulse response function of the effect of the shock on  $\Delta \ln GDP$ , divided by the impact effect of the announcement on the Federal Funds rate.

The lag exogeneity Condition LP-IV(iii) is testable:  $Z_t$  should be unforecastable in a regression of  $Z_t$  on lags of  $Y_t$ . If the lag exogeneity condition fails, then the LP-IV methods laid out in this subsection are not valid because  $Z_t$  will be correlated with the error  $u_{t+h}$  in (4). This problem can potentially be addressed by adding control variables to the LP-IV regression.

# 1.4. Extension of LP-IV to Control Variables

There are two reasons to consider adding control variables to the IV regression (7).

First, although an instrument might not satisfy Condition LP-IV, it might do so after including suitable control variables; that is, the instruments might satisfy the exogeneity conditions only after controlling for some observable factors. As discussed in Section 4, this is the case in the Gertler and Karadi (2015) application.

Second, even if Condition LP-IV is satisfied, including control variables could reduce the sampling variance of the IV estimator by reducing the variance of the error term. The reasoning is standard: because the variance of the LP-IV estimator depends on the scale of the errors, including control variables that explain the error term can reduce the variance of the estimator. Here, the relevant variance is the long-run variance of the instrument-times-error, so the aim of including additional control variables is to reduce this long-run variance. Under Condition LP-IV,  $Y_{t-1}$ ,  $Y_{t-2}$ , ... and possibly future  $Z_{t+lv}$ , ...,  $Z_{t+1}$  are candidate control variables.

Adding control variables  $W_t$  to (7) yields

$$Y_{i,t+h} = \Theta_{h,i1} Y_{1,t} + \gamma_h' W_t + u_{i,t+h}^{h\perp}, \tag{10}$$

where  $x_t^{\perp} = x_t - \text{Proj}(x_t | W_t)$  for some variable  $x_t$  and  $u_{i,t+h}^{h\perp} = \{\varepsilon_{t+h}^{\perp}, \dots, \varepsilon_{t+1}^{\perp}, \varepsilon_{2:n,t}^{\perp}, \varepsilon_{t-1}^{\perp}, \varepsilon_{t-2}^{\perp}, \dots\}.$ 

With control variables W, the conditions for instrument validity are:

CONDITION LP-IV<sup>⊥</sup>

(i) 
$$E(\varepsilon_{1,t}^{\perp}Z_t^{\perp'}) = \alpha' \neq 0;$$

(ii) 
$$E\left(\varepsilon_{2:n,t}^{\perp}Z_{t}^{\perp\prime}\right)=0$$
; and

(iii) 
$$E(\varepsilon_{t+j}^{\perp} Z_t^{\perp'}) = 0$$
 for  $j \neq 0$ .

By projecting on  $W_b$  (10) can be written,  $Y_{i,t+h}^{\perp} = \Theta_{h,i1} Y_{i,t}^{\perp} + u_{i,t+h}^{h\perp}$ . For a scalar instrument, multiplying both sides of this expression by  $Z_t^{\perp}$  and using Condition LP-IV<sup> $\perp$ </sup> and the unit effect normalisation (6) yields

$$\frac{E(Y_{i,t+h}^{\perp}Z_t^{\perp})}{E(Y_{1,t}^{\perp}Z_t^{\perp})} = \Theta_{h,i1}. \tag{11}$$

For a vector of instruments,  $E(Y_{i,t+h}^{\perp}Z_t^{\perp'})HE(Z_t^{\perp}Y_{1,t}^{\perp})/E(Y_{1,t}^{\perp}Z_t^{\perp'})HE(Z_t^{\perp}Y_{1,t}^{\perp}) = \Theta_{h,i1}$  for any positive definite matrix H. Equation (11) is the moment condition for IV estimation of (10) using instrument  $Z_t$ .

Equation (11) holds for all h, including the impact effect h=0, with the proviso that for h=0, the effect for the first variable is normalised to  $\Theta_{0,11}=1$ . Under the unit effect normalisation, for h=0 and i=1, (10) become the identity  $Y_{1,t}=Y_{1,t}$  (or  $cY_{1,t}^{\perp}=Y_{1,t}^{\perp}$ ).

The question of what control variables to include, if any, is a critical one that depends on the application.

Even if Condition LP-IV (iii) holds, including control variables could reduce the variance of the regression error, and thus improve estimator efficiency. This suggests using control variables aimed at capturing some of the dynamics of  $Y_{1,t}$  and  $Y_{i,t}$ . Such control variables could include lagged values of  $Y_1$  and  $Y_i$ , or additionally lagged values of other macro variables. Such control variables could also include generic controls, such as lagged factors from a dynamic factor model. Whether or not lagged Y's are used as controls, under Condition LP-IV(iii), leads and lags of  $Z_t$  can be included as controls to improve efficiency.

A more difficult problem arises if Conditions LP-IV (ii) and (ii) hold, but Condition LP-IV (iii) fails because  $Z_t$  is correlated with one or more lagged shocks. Then instrument validity hinges upon including in W variables that control for those lagged shocks, so that Condition LP-IV $^{\perp}$  (iii) holds. It is useful to think of two cases.

In the first case, suppose  $Z_t$  is correlated with past values of  $\varepsilon_{1,b}$  but not with past values of other shocks. As we discuss below, this situation arises in the Gertler and Karadi (2015) application, where the construction of  $Z_t$  induces a first-order moving average structure. In this case, including lagged values of Z as controls would be appropriate. Another example is oil supply disruptions arising from political disturbances as in Hamilton (2003) and Kilian (2008), where the onset of the disruption might plausibly be unpredictable using lagged  $\varepsilon$ 's, but the disruption indicator could exhibit time series correlation because any given disruption could last more than one period. If so, it could be appropriate to include lagged values of Z as controls, or otherwise to modify the instrument so that it satisfies Condition LP-IV $^{\perp}$  (iii).

A second case arises when  $Z_t$  is correlated with past shocks including those other than  $\varepsilon_{1,t}$ . If so, instrument validity given the controls requires that the controls span the space of those shocks. If it were known which past shocks were correlated with Z, then application-specific reasoning could guide the choice of controls, akin to the first case. But without such information, the controls would need to span the space of all past shocks. This reasoning suggests using generic controls. One such set of generic controls would be a vector of macro variables, say  $Y_t$ . Another such set could be factors estimated from a dynamic factor model; using such factors would provide a factor-augmented IV estimate of the structural impulse response function. We show in subsection 2.2 that the requirement that Condition LP-IV $^{\perp}$  (iii) be satisfied by generic controls, when Condition LP-IV (iii) does not hold, is quite strong.

#### 1.5. LP-IV: Econometric Odds and Ends

#### 1.5.1. Levels, differences and cumulated impulse responses

In many applications,  $Y_{i,t}$  will be specified in first differences, but interest is in impulse responses for its levels. Impulse responses for levels are cumulated impulse responses for first differences. The cumulated impulse responses can be computed from the IV regression:

$$\sum_{k=0}^{h} Y_{i,t+k} = \Theta_{h,i1}^{cum} Y_{1,t} + \gamma_h^{cum'} W_t + u_{i,t+h}^{h,cum\perp},$$
(12)

where  $\Theta_{h,i1}^{cum} = \sum_{k=0}^{h} \Theta_{k,i1}$ . For example, if  $Y_{i,t} = \Delta \ln \text{GDP}_b$  then the left-hand side of (12) is  $\ln(\text{GDP}_{t+h}) - \ln(\text{GDP}_t)$ , that is, the log-point change in GDP from t to t+h. If  $Z_t$  satisfies  $\text{LP-IV}^{\perp}$ , it is a valid instrument for IV estimation of (12).

Another measure of a dynamic causal effect is the ratio of cumulative impulse responses. For example, a shock to government spending typically induces a flow over time of government outlays. As discussed by Ramey and Zubairy (2017, section 3.2.2), a useful measure of the effect on output of government spending is the cumulative GDP gain resulting from cumulative government spending over the same period. Fieldhouse *et al.* (2017) make a similar argument for considering ratios of cumulative multipliers in their study of the effect on residential investment of US housing agency purchases of mortgage-backed securities. As Ramey and Zubairy (2017) point out, this ratio of cumulative multipliers can be estimated in the LP-IV regression:

$$\sum_{k=0}^{h_i} Y_{i,t+k} = \rho_{i1}^{h_i,h_1} \sum_{k=0}^{h_1} Y_{1,t+k} + \gamma_{h_i,h_1}^{cum'} W_t + u_{i,t+h}^{h_i,h_1},$$
(13)

where  $\rho_{i1}^{h_i,h_1} = \sum_{k=0}^{h_i} \Theta_{k,i1} / \sum_{k=0}^{h_1} \Theta_{k,11}$  (in (13), we generalise Ramey and Zubairy, 2017 slightly to allow for different cumulative periods for  $Y_i$  and  $Y_1$ ). When the instrument  $Z_t$  satisfies Condition LP-IV $^{\perp}$ ,  $E\sum_{k=0}^{h_i} Y_{i,t+k}^{\perp} z_t^{\perp} = \sum_{k=0}^{h_i} \Theta_{k,i1} \alpha'$  and  $E\sum_{k=0}^{h_1} Y_{1,t+k}^{\perp} z_t^{\perp} = \sum_{k=0}^{h_1} \Theta_{k,11} \alpha'$ . Thus, when there is a single instrument, the IV moment condition is  $E\sum_{k=0}^{h_i} Y_{i,t+k}^{\perp} z_t^{\perp} / E\sum_{k=0}^{h_1} Y_{1,t+k}^{\perp} z_t^{\perp} = \sum_{k=0}^{h_i} \Theta_{k,i1} / \sum_{k=0}^{h_1} \Theta_{k,11} = \rho_{i1}^{h_i,h_1}$ . Thus, if  $Z_t$  satisfies LP-IV $^{\perp}$ , it is a valid instrument for IV estimation of (13).

#### 1.5.2. HAC/HAR inference and long-horizon impulse responses

When the instruments are strong, the validity of inference can be justified under standard assumptions of stationarity, weak dependence and existence of moments (Hayashi, 2000). However, the multistep nature of the direct regressions in general requires an adjustment for serial correlation of the instrument  $\times$  error process: the error terms in (7), (10) and (12) include future and lagged values of  $\varepsilon_b$  and in general terms like  $Z_{t}\varepsilon_{t+j}$  and  $Z_{t+j}\varepsilon_t$  will be correlated. Inference based on standard heteroscedasticity and autocorrelation robust (HAR) covariance matrix estimators are valid at short to medium horizons.

One special case in which HAR inference is not needed is when the Ws are lagged Ys, the VAR for Y is invertible and the Zs are serially uncorrelated conditional on the Ws. In this case,  $Z_t^{\perp} u_{t+h}^{h\perp}$  is serially uncorrelated and standard heteroscedasticity-robust standard errors can be used. If in addition the errors are homoscedastic, homoscedasticity-only standard errors can be used.

#### 1.5.3. Historical and forecast error variance decompositions

The historical decomposition decomposes the path of  $Y_t$  to the contributions of the individual shocks. The contribution of shock  $\varepsilon_{1,t}$  to  $Y_{i,t+h}$  can be read off the structural moving average representation (5):

Historical contribution of 
$$\varepsilon_{1,t}$$
 to  $Y_{i,t+h} = \Theta_{h,i1}\varepsilon_{1,t}$ . (14)

The forecast error variance decomposition (FEVD) decomposes the variance of the unforecasted change in a variable h periods hence to the variance contributions from the shocks that occurred between t and t+h. Because the shocks are uncorrelated over time and with each other, this decomposition, expressed in  $\mathbb{R}^2$  form is as follows:

$$FEVD_{h,i1} = \frac{\sum_{k=0}^{h-1} \Theta_{k,i1}^2 \sigma_{\varepsilon_1}^2}{\operatorname{var}(Y_{i,t+h} | \varepsilon_t, \varepsilon_{t-1}, \dots)}.$$
 (15)

If  $\varepsilon_{1,t}$  can be recovered, then the historical decomposition can be computed using the LP-IV estimates of  $\{\Theta_{h,j1}\}$ ,  $h=0,1,2,\ldots$  Similarly, if  $\sigma_{\varepsilon_1}^2$  and  $\text{var}(Y_{i,t+h} \mid \varepsilon_b, \varepsilon_{t-1},\ldots)$  are identified, then the forecast error variance decomposition is identified and also can be computed using the LP-IV estimates of  $\Theta_{h,j1}$ ,  $h=0,1,2,\ldots$ 

In general, even though Conditions LP-IV and LP-IV<sup> $\perp$ </sup> serve to identify the impulse response function, they do not identify either  $\varepsilon_{1,t}$  or  $\sigma_{\varepsilon_1}^2$  without additional assumptions. A sufficient condition for identifying  $\varepsilon_{1,t}$  and the FEVD is that the VAR for  $Y_t$  is invertible; a somewhat weaker condition for identifying  $\varepsilon_{1,t}$  (but not the FEVD) is that  $Y_t$  is partially invertible. Weaker yet is the 'recoverability' condition discussed in Chahrour and Jurado (2017) and Plagborg-Møller and Wolf (2017). Further discussion, including expressions for  $\varepsilon_{1,b}$   $\sigma_{\varepsilon_1}^2$ , and the FEVD, are deferred until the next Section.

<sup>&</sup>lt;sup>4</sup> This result follows by direct calculation using the invertibility results in subsection 2.2.

# 1.5.4. Smoothness restrictions

The IV estimator of (7), (10) and (12) impose no restrictions across the values of the dynamic causal effects for different horizons. In many applications, smoothness across horizons is sensible. The VAR methods discussed in the next Section impose smoothness by modelling the structural moving average (5) as the inverse of a loworder VAR; however, as is discussed in that Section those methods require the additional assumption that Θ(L) is invertible. A few recent papers develop methods for smoothing IRFs estimated by local projections using OLS. Barnichon and Brownlees (2016) and Plagborg-Møller (2016a) use smoothness priors to shrink the IRFs across horizons. Miranda-Agrippino and Ricco (2017) smooth LP IRFs by shrinking them towards SVAR IRVs. Although these papers develop these methods for OLS estimates of LP and SVARs, the extension to IV estimates seems straightforward.

# 1.5.5. Weak instruments

If the instruments are weak, then in general the distribution of the IV estimator in (7), (10) and (12) is not centred at Θh,i1, and inference based on conventional IV standard errors is unreliable. However, a suite of heteroscedasticity and autocorrelation-robust methods now exists to detect weak instruments and to conduct inference robust to weak instruments in linear IV regression. For example, see Kleibergen (2005) for a HAR version of Moreira's (2003) conditional likelihood ratio statistics, and Montiel Olea and Pflueger (2013) and Andrews (2018) for HAR alternatives to first-stage F statistics for detecting weak identification.

As previously discussed, HAR inference is not needed in the special case that the Ws are lagged Ys, the VAR for Y is invertible and the Zs are serially uncorrelated conditional on the Ws. If in addition the errors are homoscedastic, then the suite of tools for weak identification in homoscedastic cross-section data can be applied, including the usual first-stage F statistic for assessing instrument strength.

#### 1.5.6. News shocks and the unit-effect normalisation

In some applications, interest focuses on a 'news shock', which is defined to be a shock that is revealed at time t, but has a delayed effect on its natural indicator. For example, Ramey (2011) argues that many fiscal shocks are news shocks because they are revealed during the legislative process but have direct effects on government spending and/or taxes only with a lag. Despite this lag, forward looking variables, like consumption, investment, prices and interest rates may respond immediately to the shock. This differential timing changes the scale normalisation for the shock because Θ0,11 may equal zero; that is, the news shock e1,<sup>t</sup> affects its indicator Y1,<sup>t</sup> only with a lag. Thus, the contemporaneous unit-effect normalisation (Θ0,11 = 1) is inappropriate.

Instead, for a news shock, a k-period ahead unit-effect normalisation, Θk,11 = 1 for pre-specified k, should be used. For example, if government spending reacts to news about spending with a 12-month lag, then the 12-month-ahead unit-effect normalisation Θ12,11 = 1 would be appropriate: this normalises the spending shock so that a 1 pp increase in the shock at time t corresponds to a 1 pp increase in observed government spending 12 months hence. With this k-period ahead normalisation, Y1,t+<sup>k</sup> = ɛ1,<sup>t</sup> + {ɛt+k, ... , ɛt+1, ɛ2:n,t, ɛt-1, ɛt-2, ...}. Accordingly, Y1,t+<sup>k</sup> replaces Y1,<sup>t</sup> in the IV

© 2018 Royal Economic Society.

regressions (7), (10) and (12). In practice, implementing this strategy requires a choice of the news lead-time k, and this choice would be informed by applicationspecific knowledge.

# 2. Identifying Dynamic Causal Effects Using External Instruments and VARs

Since Sims (1980), the standard approach in macroeconomics to estimation of the structural moving average representation (5) has been to estimate a structural vector autoregression (SVAR), then to invert the SVAR to estimate Θ(L). This approach has several virtues. Macroeconomists are in general interested in responses to multiple shocks, and the SVAR approach provides estimates of the full system of responses. It emerges from the long tradition, dating from the Cowles Commission, of simultaneous equation modelling of time series variables. It imposes parametric restrictions on the high-dimensional moving average representation that, if correct, can improve estimation efficiency. And, importantly, it replaces the computationally difficult problem of estimating a multivariate moving average with the straightforward task of single-equation estimation by OLS.

These many advantages come with two requirements. The first is that the researcher has some scheme to identify the relation between the VAR innovations and the structural shocks, assuming that the two span the same space; this is generally known as the SVAR identification problem. The second is that, in fact, this spanning condition holds, a condition that is generally referred to as invertibility. Here, we begin by discussing how IV methods can be used to solve the thorny SVAR identification problem. We then turn to a discussion of invertibility, which we interpret as an omitted variable problem.
