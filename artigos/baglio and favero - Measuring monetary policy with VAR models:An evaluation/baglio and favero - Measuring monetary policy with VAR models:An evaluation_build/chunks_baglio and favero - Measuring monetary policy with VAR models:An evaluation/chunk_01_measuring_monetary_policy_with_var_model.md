![](_page_0_Picture_0.jpeg)

European Economic Review 42 (1998) 1069*—*1112

![](_page_0_Picture_2.jpeg)

# Measuring monetary policy with VAR models: An evaluation

Fabio C. Bagliano!,*\**, Carlo A. Favero",#

! *Dipartimento di Scienze Economiche e Finanziarie* \*\**G. Prato*++*, Universita*% *di Torino, Corso Unione Sovietica 218bis, 10134, Torino, Italy* " *Universita*% \*\**L. Bocconi*++*, Via Sarfatti 25, 20136, Milano, Italy* # *CEPR, London, UK*

#### Abstract

This paper evaluates VAR models designed to analyse the monetary policy transmission mechanism in the United States by considering three issues: specification, identification, and the effect of the omission of the long-term interest rate. Specification analysis suggests that only VAR models estimated on a single monetary regime feature parameters stability and do not show signs of mis-specification. The identification analysis shows that VAR-based monetary policy shocks and policy disturbances identified from alternative sources are not highly correlated but yield similar descriptions of the monetary transmission mechanism. Lastly, the inclusion of the long-term interest rate in a benchmark VAR delivers a more precise estimation of the structural parameters capturing behaviour in the market for reserves and shows that contemporaneous fluctuations in long-term interest rates are an important determinant of the monetary authority's reaction function. ( 1998 Elsevier Science B.V. All rights reserved.

*JEL classification:* E44; E52

*Keywords:* Monetary transmission; VAR models

*<sup>\*</sup>* Corresponding author. Tel.: 39-11-670 6084; fax: 39-11-670 6062; e-mail: bagliano@econ.unito.it.

# 1. Introduction

Vector autoregressive (VAR) models are widely used in the empirical analysis of monetary policy issues. This methodology has undoubtedly the merit of avoiding the need for a complete specification of a structural model of the economy; however, when the effects of monetary policy actions are to be evaluated, a fundamental identification problem must be solved. Policy actions which are an endogenous response to current developments in the economy must be separated from exogenous policy actions. Only when the latter are identified the dynamic analysis of the VAR system may yield reliable information on the monetary transmission mechanism.

Increasing attention to monetary shocks identification issues has been devoted in the recent VAR literature, with a special focus on the functioning of the bank reserves market, which is directly affected by monetary policy actions (Gordon and Leeper, 1994; Strongin, 1995; Bernanke and Mihov, 1995; Christiano et al., 1996a; Leeper et al., 1996). Following a different, though related, line of research, other authors have constructed measures of monetary policy shocks using direct financial market information, not derived from a VAR system (Rudebusch, 1996; Skinner and Zettelmeyer, 1996; Favero et al., 1996).

The main purpose of this paper is to assess the properties of these different measures for the United States, evaluating the implied dynamic responses of the economy to monetary policy shocks using a common benchmark VAR model.

Section 2 introduces the VAR-based analysis of the monetary transmission mechanism and describes a six-variable VAR (based on the work by Strongin, 1995 and Bernanke and Mihov, 1995) which will be used as a benchmark in the following discussion. The chosen general formulation nests alternative assumptions on the specific targets and operating procedures adopted by the Federal Reserve in conducting monetary policy.

Section 3 analyses the issue of the econometric specification of the benchmark VAR, focusing on parameter stability and on residual properties over various sample periods. On the basis of the specification results, Section 4 focuses on the most recent part of the sample, starting in 1988, and compares the measure of monetary policy shocks derived from the benchmark VAR with alternative measures constructed using financial market information. Such measures are then included in the VAR as additional exogenous variables and the responses of the economy to these shocks are contrasted with those obtained from the benchmark VAR.

Finally, Section 5 further extends the estimated system by including a longterm interest rate as an additional endogenous variable, so that the response of the interest rate term structure to monetary policy shocks can be evaluated. Section 6 ends the paper with a summary of the main conclusions.

#### 2. VAR models and the analysis of the monetary transmission mechanism

#### 2.1. On the interpretation of VAR analysis

VAR analyses of the monetary transmission mechanism started developing when the failure of traditional Cowles Commission models was rationalized by two demolishing theoretical critiques due to Lucas (1976) and Sims (1980). The Lucas critique applies to structural models when the coefficient describing the impact of monetary policy on the macroeconomic variables of interest depend on the monetary policy regimes; in this case no model estimated under a specific regime can be used to simulate the effects of a different monetary policy regime. The Sims critique attacks identification from a different perspective, pointing out that the restrictions needed to support exogeneity in structural Cowles Commision-type models are 'incredible' in an environment where agents optimise intertemporally. VAR models and structural Cowles Commission models of the monetary transmission mechanism specify the same statitistical model (i.e. reduced form) of the data generating process, and therefore, in general, also the VAR approach is subject to the Lucas and Sims critique. In fact, the criticism that structural equation restrictions are incredible could just be refereed to the contemporaneous correlation matrix restrictions generally used in the VAR literature; similarly the Lucas critique also applies to this type of models, given their backward-looking autoregressive structure.

However, VAR models differ from structural Cowles Commission models as to the purpose of their specification and estimation. This difference allows to implement VAR analysis by identifying models imposing more 'credible' restrictions and by using them in some specific contexts where the Lucas critique should not apply.

The common structure shared by Cowles Commission and VAR models specified to analyse the impact of monetary policy can be represented as follows:

$$A\begin{pmatrix} Y_t \\ M_t \end{pmatrix} = C(L)\begin{pmatrix} Y_{t-1} \\ M_{t-1} \end{pmatrix} + B\begin{pmatrix} v_t^Y \\ v_t^M \end{pmatrix}$$
(2.1)

where Y and M are vectors of macroeconomic (non-policy) variables (e.g. output and prices) and variables controlled by the monetary policymaker (e.g. interest rates and monetary aggregates containing information on monetary policy actions) respectively. Matrix A describes the contemporaneous relations among the variables and C(L) is a matrix finite-order lag polynomial.

$$v \equiv \binom{v^Y}{v^M}$$

is a vector of structural disturbances to the non-policy and policy variables; non-zero off-diagonal elements of B allow some shocks to affect directly more

than one endogenous variable in the system. The main difference between the two approaches lies in the aim for which models are estimated.

On the one hand, traditional structural models are designed to identify the impact of policy variables on macroeconomic quantities in order to determine the value to be assigned to the monetary instruments (*M* ) to achieve a given target for the macroeconomic variables (*Y* ), assuming exogeneity of the policy variables in *M* on the ground that these are the instruments controlled by the policy maker. Identification in traditional structural models is obtained without assuming the orthogonality of structural disturbances. As a consequence, impulse response analysis cannot be implemented within this framework, dynamic multipliers being computed instead. Dynamic multipliers describe the impact of monetary policy variables on macroeconomic quantities without separating changes in the monetary variable into the expected and unexpected components.

The assumed exogeneity of the monetary variables makes the model invalid for policy analysis if monetary policy reacts endogenously to the macroeconomic variables. To our reading, this is the kind of restriction labelled as 'incredible' by Sims. Outside the tradition of structural modelling, a similar framework has been used to assess the impact on macroeconomic variables of qualitative indicators of monetary policy derived adopting the 'narrative approach' of Romer and Romer (1989, 1994). In a recent paper, Leeper (1997) shows that even the dummy variable generated by the 'narrative approach' (identifying episodes of deliberate monetary contractions) is predictable from past macroeconomic variables, thus reflecting the endogenous response of policy to the economy, and the estimated coefficients cannot provide an unbiased estimate of the response of the macroeconomic variables to a monetary impulse. Furthermore, the lack of *super*exogeneity of the monetary variable would make the inference invalid if the coefficients in Eq. (2.1) are functions of the distribution of the monetary variable (the Lucas critique).

On the other hand, VAR models of the transmission mechanism are not estimated to yield advice on the best monetary policy; they are rather estimated to provide empirical evidence on the response of macroeconomic variables to monetary policy impulses in order to discriminate between alternative theoretical models of the economy. Monetary policy actions should be identified using theory-free restrictions, taking into account the potential endogeneity of policy instruments. Viewed in this perspective, VAR models can be identified and used in full awareness of the two critiques mentioned above. As an example, in a series of recent papers by Christiano et al. (1996a,b), apply the VAR approach to derive 'stylized facts' on the effect of a contractionary policy shock, and conclude that plausible models of the monetary transmission mechanism should be consistent at least with the following evidence on price, output and interest rates: (i) the aggregate price level initially responds very little; (ii) interest rates initially rise, and (iii) aggregate output initially falls, with a *j*-shaped response, with a zero long-run effect of the monetary impulse. Such evidence leads to the dismissal of traditional real business cycle model, which are not compatible with the liquidity effect of monetary policy on interest rates, and of the Lucas (1972) model of money, in which the effect of monetary policy on output depends on price misperceptions. The evidence seems to be more in line with alternative interpretations of the monetary transmission mechanism based on sticky prices models (Goodfriend and King, 1997), limited participation models (Christiano and Eichenbaum, 1992) or models with indeterminacy-sunspot equilibria (Farmer, 1997).

At the empirical level, the starting point of VAR analysis is the estimation of the reduced form of the underlying structural model Eq. (2.1):

$$\begin{pmatrix} Y_t \\ M_t \end{pmatrix} = A^{-1}C(L) \begin{pmatrix} Y_{t-1} \\ M_{t-1} \end{pmatrix} + \begin{pmatrix} u_t^Y \\ u_t^M \end{pmatrix}, \tag{2.2}$$

where u denotes the VAR residual vector. The relation between the VAR residuals in u and the structural disturbances in v is therefore

$$A \begin{pmatrix} \mathbf{u}_t^Y \\ \mathbf{u}_t^M \end{pmatrix} = B \begin{pmatrix} \mathbf{v}_t^Y \\ \mathbf{v}_t^M \end{pmatrix}. \tag{2.3}$$

The identification of the relevant structural parameters, given the estimation of the reduced form, is the most traditional problem in econometrics and requires the imposition of some restrictions on the elements of  $\boldsymbol{A}$  and  $\boldsymbol{B}$ . A structural model is then identified by (i) assuming orthogonality of the structural disturbances; (ii) imposing that macroeconomic variables do not simultaneously react to monetary variables, while the simultaneous feedback in the other direction is allowed, and (iii) imposing restrictions on the monetary block of the model reflecting the operational procedures implemented by the monetary policy maker. In models estimated on monthly data, restrictions (ii) are consistent with a wide spectrum of alternative theoretical structures and imply a minimal assumption on the lag of the impact of monetary policy on macroeconomic variables, whereas restrictions (iii) are based on institutional analysis.

Having identified the 'monetary rule' by proposing an explicit solution to the problem of the endogeneity of money, the VAR approach concentrates on *deviations* from the rule. In fact, such deviations provide researchers with the best opportunity to detect the response of macroeconomic variables to monetary impulses that are not expected by the market. The first chain of most models of the monetary transmission mechanism links the policy rates to the term structure of the interest rates and the most popular model of the term structure, the expectational model, predicts that the term structure does not generally react to expected monetary impulses. The monetary impulses relevant to the transmission analysis are therefore structural shocks in Eq. (2.1). The VAR approach to the monetary transmission mechanism has been criticized on the

basis that it views Central Banks as 'random number generators'. This does not seem to be correct: in fact, monetary policy rules are explicitly estimated in structural VAR models. However, the focus is not on rules but on deviations from rules, since only when central banks deviate from their rules it becomes possible to collect interesting information on the response of macroeconomic variables to monetary policy impulses, to be compared with the predictions of the alternative theoretical models.

A final word on the Lucas critique. In order to limit the practical importance of the critique, models should be estimated on a single monetary regime, since regime shifts require different parameterizations. The objective of the specification of VAR models for the analysis of the monetary transmission mechanism is perfectly achieved by estimating models on a single policy regime. In fact, the within-sample estimation results are not to be used for any out-of-sample simulation.

To summarize, if VAR models are estimated to provide stylized facts on the responses of macroeconomic variables to monetary impulses (to be compared with the predictions of alternative theoretical models), then they can be specified and used taking full account of both the Lucas and the Sims critiques. The latter is accounted for by identifying shocks using restrictions related to the institutional context and assumptions on the lag of the responses of macro variables to monetary impulses which are compatible with a wide spectrum of alternative theoretical model. The Lucas critique could be made irrelevant by estimating such models on a single policy regime. Admittedly, this view restricts the spectrum of structural applications of VAR models and implicitly criticizes a good number of VAR-based applications available in the literature, but it clarifies the framework in which we would like to put our contribution.

# *2.2. The benchmark VAR model*

The baseline specification of our empirical work is a VAR system which has by now become the standard reference model in the analysis of the monetary transmission mechanism in the U.S. (Strongin, 1995; Bernanke and Mihov, 1995; Christiano et al., 1996a; Leeper et al., 1996; Bernanke and Mihov, 1995). Our 'benchmark' specification of the general structural model in Eq. (2.1), with the associated reduced-form VAR in Eq. (2.2), contains six variables, with the vector of macroeconomic non-policy variables including gross domestic product (*GDP*), the consumer price index (*P*) and the commodity price level (*Pcm*). A first set of identifying assumptions imposed throughout our empirical analysis (using data at a monthly frequency) is that the policy variables have no contemporaneous effect on macroeconomic quantities: the corresponding elements of matrix *A* in Eq. (2.1) are set to zero accordingly. The vector of policy variables includes the federal funds rate (*FF*), the quantity of total bank reserves (¹*R*) and the amount of nonborrowed reserves (*NBR*). All policy variables are allowed to be affected by current developments in the macroeconomy, so that the coefficients on the Y elements in the equations for FF, TR and NBR are left completely unrestricted.

The contemporaneous relations among the Fed funds rate and the reserve aggregates are derived, as in Bernanke and Mihov (1995), from a specific model of the reserve market:

$$u^{TR} = -\alpha u^{FF} + v^{D}, \tag{2.4}$$

$$u^{BR} = u^{FF} + v^{B}, (2.5)$$

$$u^{NBR} = \phi^{D} v^{D} + \phi^{B} v^{B} + v^{S}. \tag{2.6}$$

Eqs. (2.4) and (2.5) describe banks' demand equations (expressed in innovation, i.e. VAR residual form) for total and borrowed reserves BR (time subscripts are omitted): the federal funds rate affects negatively the demand for total reserves Eq. (2.4) and positively the demand for borrowed reserves.<sup>1</sup>  $v^D$  and  $v^B$  are disturbances to total and borrowed reserves respectively. The supply of nonborrowed reserves in Eq. (2.6) reflects the behaviour of the Federal Reserve. In particular, by means of open-market operations, the Fed can change the amount of NBR supplied to the banking system in response to (readily observed) disturbances to total and borrowed reserve demand. Moreover, variations in nonborrowed reserves may be due to monetary policy shocks unrelated to reserve demand behaviour. In Eq. (2.6) the coefficients  $\phi^D$  and  $\phi^B$  measure the reaction of the Fed to total and borrowed reserve demand movements, respectively, and  $v^S$  represents the monetary policy shock to be empirically identified.

Combining the market for reserves with the macroeconomic variables, we can explicitly rewrite Eq. (2.3) as follows:

$$\begin{vmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ a_{21} & 1 & 0 & 0 & 0 & 0 \\ a_{31} & a_{32} & 1 & 0 & 0 & 0 \\ a_{41} & a_{42} & a_{43} & 1 & -\frac{1}{\beta} & \frac{1}{\beta} \\ a_{51} & a_{52} & a_{53} & \alpha & 1 & 0 \\ a_{61} & a_{62} & a_{63} & 0 & 0 & 1 \end{vmatrix} \begin{vmatrix} u_t^{GDP} \\ u_t^P \\ u_t^{FCm} \\ u_t^{TR} \\ u_t^{TR} \\ u_t^{NBR} \end{vmatrix}$$

<sup>&</sup>lt;sup>1</sup> We assume from the start that movements in the discount rate, which would enter Eq. (2.5) with a negative sign, are completely anticipated, so that the innovation in the Fed funds-discount rate differential is entirely attributable to the former rate.

$$= \begin{pmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \\ 0 & 0 & 0 & -\frac{1}{\beta} & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & \phi^{B} & \phi^{D} & 1 \end{pmatrix} \begin{pmatrix} v_{1t}^{NP} \\ v_{2t}^{NP} \\ v_{2t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{D} \\ v_{t}^{D} \\ v_{t}^{S} \end{pmatrix}$$

$$(2.7)$$

Several features of Eq. (2.7) must be noted. First, VAR residuals from the first three equations, describing the nonpolicy part of the system, are orthogonalized simply by assuming a recursive (Choleski) structure for the corresponding block of the A matrix. This procedure yields orthogonal disturbances to which we do not attach a specific 'structural' interpretation, labelling them simply as  $v_i^{NP}$  (i = 1, 2, 3), where NP denotes a non-policy shock.

Second, as shown by Bernanke and Mihov (1995), the general formulation in Eq. (2.7) nests various assumptions on the monetary policy operating procedures that have been used in the literature to identify policy shocks. In particular, under a federal funds rate targeting policy, nonborrowed reserves are adjusted to offset shocks to total and borrowed reserves demand. Full adjustment implies  $\phi^{\rm D}=1$  and  $\phi^{\rm B}=-1$  in Eqs. (2.6) and (2.7). From the account of the Fed operating procedures in Strongin (1995) and the empirical results provided by Bernanke and Mihov (1995) these assumptions seem to well characterize Fed's behaviour from the mid-60s to 1979 and again from 1988 onwards. Alternatively, under a nonborrowed reserve target as in the 1979–1982 period, NBR do not respond to reserve demand shocks, implying  $\phi^D = \phi^B = 0$ . Finally, a borrowed reserve target, that Strongin (1995) attributes to the Federal Reserve after 1982, implies that nonborrowed reserves fully accommodate total reserve demand shocks ( $\phi^{D} = 1$ ) and partially react to disturbances in the borrowing function  $(\phi^{\rm B} = \alpha/\beta)$  so as to maintain the chosen target. Given each of the above assumptions on the prevailing monetary policy regime, the structural innovation capturing policy shocks v<sup>S</sup> may be identified as the orthogonalized residual of the FF equation (under federal funds rate targeting) or of the NBR equation (under a nonborrowed reserve targeting) or, under a borrowed reserve targeting, as a linear combination of the VAR residuals from the TR and NBR equations  $(u^{TR}-u^{NBR}).$ 

As pointed out by Rudebusch (1996), the validity of the VAR analysis of the monetary transmission mechanism depends on two (closely related) crucial questions: (i) 'Does a VAR funds rate equation correctly model reactive Fed policy?', and (ii) 'Do its residuals plausibly represent monetary policy shocks?'. Rudebusch's answer to both questions is simply no. In the following sections we will use the general VAR Eqs. (2.2) and (2.7) as a benchmark in order to provide

answers to the above two questions. We try to do so by addressing the following issues:

- f *specification*, with particular attention to parameter stability and residual properties;
- f *identification*, augmenting the VAR above with exogenous variables constructed as alternative measures of monetary policy using non-VAR information (Rudebusch, 1996; Skinner and Zettelmeyer, 1996; Favero et al., 1996) to compare the dynamic response of the system with that derived by appropriate structuralization of VAR residuals;
- f *inclusion of the long*-*term interest rate*, extending the VAR above to evaluate the response of the term structure to monetary policy shocks.

# 3. Specification

We employ monthly U.S. data from 1966(1) to 1996(3). Only from the mid-60s the federal funds rate begins to be a significant tool for monetary policy (the level of the federal funds rate starts to be constantly above the discount rate) and this justifies the choice of the starting date of the sample. The variables used in the benchmark VAR are defined as follows:

*GDP*: real gross domestic product, monthly seasonally adjusted series interpolated from national income and product accounts quarterly series using the Chow*—*Lin procedure as described in Leeper et al. (1996)

*P*: consumer price index for urban consumers, total, seasonally adjusted;

*Pcm*: IMF index of world commodity price;

*FF*: federal funds rate, effective rate, per cent per annum;

¹*R*: total bank reserves, adjusted for reserve requirements changes, seasonally adjusted;

*NBR*: nonborrowed bank reserves, adjusted for reserve requirements changes, seasonally adjusted.

Given the linear identification structure adopted for the reserve and federal funds rate shocks, ¹*R* and *NBR* cannot be transformed in logarithms. To smooth the series, the levels of total and nonborrowed reserves are normalized by a 36-month moving average of ¹*R*, as in Bernanke and Mihov (1995) (see also Strongin, 1995 for a similar procedure). *GDP*, *P* and *Pcm* are in logarithms. The series are plotted in Fig. 1. Some of the variables display a possibly nonstationary behaviour. Nevertheless, we estimate the system with six lags and all variables in levels, with no imposition of cointegrating relations. In doing so we avoid a long-run identification problem, which may be in principle difficult to solve, with no loss of information on the long-run properties of the system (for a discussion of this issue see Sims et al. (1990), Hendry (1996) incurring some

![](_page_9_Figure_2.jpeg)

Fig. 1. Variables used in the benchmark VAR model.

loss due to the reduced efficiency of estimation but at no cost in terms of consistency of estimators.

Prior to analysing monetary policy identification issues, we perform several specification tests on the benchmark VAR.2 This is a preliminary but important step in the empirical analysis, since the reduced form of the system must be well specified (i.e. its residuals must be homoscedastic innovations and it must have constant parameters) to be validly used as a statistical framework for the formulation and testing of alternative structural hypotheses (Spanos (1990) and Hendry (1996) emphasize this point).

We first look at the residuals from estimation of the six-variable system over the whole sample (1966*—*1996), plotted in Fig. 2 in standardized form. Residuals from all equations repeatedly exceed the \$2 standard error bands, showing serious departures from normality and homoscedasticity. The visual impression of mis-specification is confirmed by the diagnostic tests reported in Table 1. As

<sup>2</sup>The econometric analysis is performed using *PcFIM*¸ by Doornik and Hendry (1996) and the RATS procedure MALCOLM written by R. Mosconi.

![](_page_10_Figure_2.jpeg)

Fig. 2. Residuals from the benchmark VAR model (1966:1*—*1996:3).

far as the equations for the policy variables are concerned, (some of ) the well documented changes in monetary policy operating procedures mentioned in the preceding section are a potential explanation. For example, the federal funds rate residuals display a huge increase in variability over the 1979*—*1982 period, when a nonborrowed reserve target was in operation. Other large residuals may be due to exceptional events, as the sudden increase in borrowings by Continental Illinois in 1984, determining a large (but readily reversed) drop in the ratio of nonborrowed to total reserves. Overall, the diagnostic tests yield overwhelming evidence of mis-specification, likely attributable to parameter instability.

Since it has often been noticed that VAR systems estimated over a relatively long sample display parameter instability in at least some equations (see Rudebusch, 1996; Bernanke and Mihov, 1995), we formally analyse the stability issue, starting from the results of recursive one-step Chow stability tests on each VAR equation. Large structural breaks are detected for all variables at several dates in the sample. Moreover, recursive *N*-step system Chow tests reject stability for most of the possible sample splits date from the beginning of the sample, after initialization.

Table 1 The specification of the benchmark VAR model

(A) *Correlations of* »*AR residuals* (Correlations for the whole sample (1966*—*1996) *below* the diagonal; correlations for the 1988*—*1996 sample *above* the diagonal)

|     | GDP   | P     | Pcm   | FF    | ¹R    | NBR   |
|-----|-------|-------|-------|-------|-------|-------|
| GDP | 1     | 0.04  | 0.26  | !0.18 | !0.02 | !0.04 |
| P   | !0.09 | 1     | !0.06 | 0.13  | 0.13  | 0.14  |
| Pcm | 0.06  | 0.10  | 1     | 0.05  | !0.18 | !0.12 |
| FF  | 0.10  | 0.04  | !0.08 | 1     | !0.22 | !0.20 |
| ¹R  | 0.02  | 0.02  | !0.01 | 0.16  | 1     | 0.85  |
| NBR | 0.01  | !0.07 | 0.07  | !0.28 | 0.47  | 1     |

(B) *Diagnostic tests* (*\** and *\*\** indicate statistical significance at the 5% and 1% level, respectively)

| Sample    | GDP                                    | P                           | Pcm     | FF       | ¹R      | NBR      |  |  |  |
|-----------|----------------------------------------|-----------------------------|---------|----------|---------|----------|--|--|--|
|           |                                        | Residual standard deviation |         |          |         |          |  |  |  |
| 1966—1996 | 0.0046                                 | 0.0020                      | 0.0208  | 0.569    | 0.0097  | 0.0171   |  |  |  |
| 1988—1996 | 0.0029                                 | 0.0013                      | 0.0121  | 0.139    | 0.0071  | 0.0090   |  |  |  |
|           | Normality test                         | s2(2)                       |         |          |         |          |  |  |  |
| 1966—1996 | 8.73*                                  | 71.42**                     | 58.87** | 846.64** | 33.30** | 152.97** |  |  |  |
| 1988—1996 | 0.37                                   | 1.77                        | 1.06    | 2.55     | 3.49    | 0.56     |  |  |  |
|           | Residual autocorrelation test F(7,356) |                             |         |          |         |          |  |  |  |
| 1966—1996 | 0.30                                   | 2.54*                       | 0.68    | 3.90**   | 2.82**  | 0.58     |  |  |  |
| 1988—1996 | 0.66                                   | 0.87                        | 1.46    | 0.89     | 1.29    | 1.14     |  |  |  |
|           |                                        | ARCH test F(7,349)          |         |          |         |          |  |  |  |
| 1966—1996 | 3.72**                                 | 15.10**                     | 3.61**  | 12.03**  | 1.71    | 7.30**   |  |  |  |
| 1988—1996 | 0.42                                   | 0.22                        | 0.34    | 0.78     | 0.77    | 1.20     |  |  |  |

However, it is widely recognized that the information provided by Chow tests could be misleading when the breaks are not one-off and when they occur at unknown dates (Andrews, 1993; Stock, 1994). In recent work, Sims (1996) and Sims et al. (1990) have also remarked that deciding whether there is time variation in parameters by conducting Chow tests with a standard significance level is an inconsistent decision procedure, since when there is in fact no time variation, the procedure does not lead to the correct decision with arbitrarily high probability in large samples. Therefore, he advocated the use of information criteria, such as the Schwarz criterion, to evaluate the difference between a model fit to the full sample and a model allowing parameter change over a chosen subsample. To take account of these criticisms to the recursive-Chow test procedure, we took a list of likely break points related to changes in monetary policy operational procedures and evaluated stability by estimating the model on a sample containing a single known break point. Based on the account of the prevailing operating procedure offered by Bernanke and Mihov (1995) and Strongin (1995), the following possible subsamples are considered:

- f 1966:1*—*1972:12 (free reserves targeting);
- f 1973:1*—*1979:10 (federal funds rate targeting);
- f 1979:11*—*1982:10 (nonborrowed reserves targeting);
- f 1982:11*—*1988:10 (federal funds rate-borrowed reserves targeting, pre-Greenspan period);
- f 1988:11*—*1996:3 (federal funds rate*—*borrowed reserves targeting, Greenspan period).

Table 2 displays the estimated VAR residuals correlation matrix over the three sample periods characterized by a single operating procedure and spanning more than six years (1966*—*1972, 1973*—*1979 and 1988*—*1996). Remarkable changes in the pattern of correlations can be noticed, both within the block of monetary variables and between the monetary and the nonpolicy variables.

Given the above list of changes in operating procedures and the need of having a sufficient number of observations on either side of the potential break, we concentrate on three possible break dates: 1973:1, 1979:11 and 1988:11. We investigate the role of these potential breaks by estimating the VAR on the samples 1966:1*—*1979:10, 1973:1*—*1982:10, and 1982:11*—*1996:3, respectively, so that for each estimates there is only one potential (known) break date.

To test for stability we employed both the parameter constancy forecast tests based on the full variance matrix of all forecast errors available in *PcFIM*¸ (Doornik and Hendry, 1996), and information criteria (Schwarz and Hannan-Quinn). Results are reported in Table 3, panel A. The parameter constancy test confirms the evidence of instability for the first two break points (1973 and 1979) but not for the third (1988), whereas the information criteria weaken the evidence for the first and third breaks but not for the second.

However, this evidence could still be considered as not conclusive. In particular, it could be argued that the break dates have been chosen after the data have been informally examined and their status of 'known' is questionable. To allow for this possibility we introduced an uncertainty of one year around the point estimate of the break dates, and computed the Chow test (in s2 form) for structural stability for every breakpoint. The largest statistic so obtained provides a stability test ('maximum Chow' test) for an unknown break point (Andrews (1993) provides the underlying distributional theory and critical values). We apply the maximum Chow test only to the three equations describing the market for reserves, which, given our structural identification assumptions (absence of contemporaneous effect of the monetary on the nonpolicy variables), should be the only equations affected by changes in the monetary

Table 2 Correlations of benchmark VAR residuals over different sub-samples

(A) Sample: 1966:1*—*1972:12

|     | GDP   | P     | Pcm   | FF    | ¹R   | NBR |
|-----|-------|-------|-------|-------|------|-----|
| GDP | 1     |       |       |       |      |     |
| P   | !0.19 | 1     |       |       |      |     |
| Pcm | 0.18  | !0.28 | 1     |       |      |     |
| FF  | !0.11 | 0.07  | !0.05 | 1     |      |     |
| ¹R  | 0.08  | !0.15 | 0.15  | !0.03 | 1    |     |
| NBR | 0.08  | !0.06 | 0.01  | !0.35 | 0.65 | 1   |
|     |       |       |       |       |      |     |

(B) Sample: 1973:1*—*1979:10

|     | GDP   | P     | Pcm   | FF    | ¹R   | NBR |
|-----|-------|-------|-------|-------|------|-----|
| GDP | 1     |       |       |       |      |     |
| P   | !0.24 | 1     |       |       |      |     |
| Pcm | !0.02 | 0.14  | 1     |       |      |     |
| FF  | !0.06 | !0.26 | !0.12 | 1     |      |     |
| ¹R  | !0.03 | !0.05 | !0.08 | 0.36  | 1    |     |
| NBR | !0.14 | !0.32 | 0.06  | !0.05 | 0.48 | 1   |

(C) Sample: 1988:11*—*1996:3

|     | GDP   | P     | Pcm   | FF    | ¹R   | NBR |  |
|-----|-------|-------|-------|-------|------|-----|--|
| GDP | 1     |       |       |       |      |     |  |
| P   | 0.04  | 1     |       |       |      |     |  |
| Pcm | 0.26  | !0.06 | 1     |       |      |     |  |
| FF  | !0.18 | 0.13  | 0.05  | 1     |      |     |  |
| ¹R  | !0.02 | 0.13  | !0.18 | !0.22 | 1    |     |  |
| NBR | !0.04 | 0.14  | !0.12 | !0.20 | 0.85 | 1   |  |

policy regime. With 37 regressors in each equation, if the change point is known the Chow statistic has critical values of around 52 and 59 at the 5% and 1% significance level, respectively. In the case of unknown break points, the maximum Chow statistic has nonstandard distribution with higher critical values, tabulated by Andrews (1993) for estimated equations with up to 20 regressors. In the case of our trimming points (defining the portion of the sample in which the break is contained), when uncertainty is allowed for, the correct critical values are about 1.12 times the standard critical value of the s2 distribution (42.97 against 37.57 for 20 regressors and trimming points 0.45*—*0.55). Applying these criteria (Table 3, panel B) we find strong evidence of instability in 1979, where

Table 3 Testing stability of the benchmark VAR model

#### (A) Testing stability at known break dates

| Full sample<br>(break date) | Schwarz criterion<br>Hannan-Quinn crit.<br>(unr./restr. model) | F-test for constant.<br>parameters restr.<br>(p-value) | Parameter constancy<br>forecast test<br>(p-value) |
|-----------------------------|----------------------------------------------------------------|--------------------------------------------------------|---------------------------------------------------|
| 1966:1—1979:10              | !41.61/!46.27                                                  | F(216, 530)"0.98                                       | F(492, 47)"2.03                                   |
| (1973:1)                    | !46.49/!48.75                                                  | (0.56)                                                 | (0.002)                                           |
| 1973:1—1982:10              | !39.96/!42.05                                                  | F(216, 316)"2.57                                       | F(210, 58)"3.96                                   |
| (1979:11)                   | !45.69/!44.95                                                  | (0.00)                                                 | (0.00)                                            |
| 1982:11—1996:3              | !43.38/!47.68                                                  | F(216, 500)"1.23                                       | F(528, 34)"0.79                                   |
| (1988:11)                   | !48.36/!50.20                                                  | (0.035)                                                | (0.85)                                            |

#### (B) Testing stability with unknown break dates

| Full sample    | Interval for the break<br>(sample truncation |       | Maximum Chow test (s2 | form) for equation for |  |
|----------------|----------------------------------------------|-------|-----------------------|------------------------|--|
|                | fractions)                                   | FF    | ¹R                    | NBR                    |  |
| 1966:1—1979:10 | 1972:7—1973:7<br>(0.48—0.55)                 | 79.5  | 51.8                  | 72.3                   |  |
| 1973:1—1982:10 | 1979:1—1979:12<br>(0.78—0.84)                | 296.3 | 93.3                  | 146.7                  |  |
| 1982:11—1996:3 | 1988:5—1989:5<br>(0.42—0.48)                 | 78.8  | 92.7                  | 93.9                   |  |

the observed statistics range from a minimum of 93 for the total reserves equation, to a maximum of 296 for the Fed funds rate equation, and some evidence of instability in 1988*—*1989, where the statistics range from a minimum of 78 (Fed funds rate equation) to a maximum of 94 (non borrowed reserves equation).

Overall, the results from the above stability analysis over the whole sample cast serious doubts on the adequacy of our benchmark VAR as a statistical model from which reliable measures of monetary policy innovations could be derived.

When estimation is performed over the most recent period, starting in November 1988, no signs of mis-specification are detected by the diagnostic tests reported in Table 1. All standardized residuals displayed in Fig. 3 are within the \$2p bands (with the only exception of one observation for the total reserves equation). Although recursive stability tests on each equation show some relatively minor episodes of instability (Fig. 4), at the whole system level the hypothesis of structural stability cannot be rejected (Fig. 5). Therefore, we feel justified in concentrating on this shorter sample period to evaluate different methods for identifying monetary policy shocks.

![](_page_15_Figure_2.jpeg)

Fig. 3. Residuals from the benchmark VAR model (1988:11*—*1996:3).

# 4. Identifying shocks: an evaluation of alternative strategies

In this section we concentrate on the sample 1988(11)*—*1996(3) to compare different procedures to identify monetary policy shocks. As shown in the previous section, the benchmark VAR model does not display any parameter instability over this sample period, and the analysis of the Fed's operating procedures suggests a single policy regime, to be associated with a precise identifying scheme. We consider three alternative specifications for monetary policy shocks, which are not derived by applying different structuralization to the same reduced form VAR, but instead are obtained independently from the estimation of the VAR model.
