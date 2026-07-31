## B. Measurement Problems and Reliability

Narrative measures of monetary or fiscal policy changes are best viewed as imperfectly correlated with (linear combinations of) the latent structural policy shocks. These measures are constructed from historical sources and summarize information about the size, timing, and motivation of policy interventions. But measurement errors are likely since historical records sometimes contradict each other and calls of judgment are in practice impossible to avoid. Narrative shock series also typically neglect more minor policy interventions and have many observations that are censored to zero. Moreover, in our application to taxes, it is often difficult to measure exactly the full implications of new tax legislation on effective tax rates.

These measurement problems invalidate the use of the narratives as direct observations of structural shocks and can bias estimates in regressions that rely on a one-to-one mapping between the narrative accounts and the true structural shocks. The methodology we propose above is instead robust to many types of measurement problems. As long as conditions (4)–(5) hold, the precise nature of the measurement

<span id="page-5-0"></span> $<sup>^2</sup>$  After submitting this paper, we became aware of Stock and Watson (2008) who suggest the equivalent implementation of the identification strategy through IV regressions for the case where k=1. More recently, Stock and Watson (2012) apply the same approach in a dynamic factor model to disentangle the causes of the 2007–2009 recession. Our methodology is also related to Nevo and Rosen (2012) who use weaker covariance restrictions to achieve partial identification, and Evans and Marshall (2009) who identify shocks in VARs with the aid of auxiliary shock measures derived from economic models.

<span id="page-5-1"></span><sup>&</sup>lt;sup>3</sup> Prominent examples include Romer and Romer (1989, 2010), Ramey and Shapiro (1998), Burnside, Eichenbaum, and Fisher (2004), Cloyne (2013), and Ramey (2011a).

error does not affect the identification of the impulse responses. In order to make the potential bias from ignoring measurement problems explicit, we proceed by making some specific assumptions about the mapping between the proxies derived from narrative measures and the latent shocks. The additional structure also leads to formal measures of the statistical reliability of the proxies as measurements of the latent shocks, which permits one to assess their relevance. Low values of these reliability statistics indicate that the proxies may not contain much information useful for identification.

Consider an augmented system consisting of the SVAR in (2) and the following system of measurement equations:

(8) 
$$\mathbf{m}_t = \mathbf{D}_t (\Gamma \mathbf{\varepsilon}_{1t} + \mathbf{v}_t),$$

where  $\Gamma$  is a  $k \times k$  nonsingular matrix,  $\upsilon_t$  is a  $k \times 1$  vector of measurement errors with  $E[\upsilon_t] = 0$ ,  $E[\upsilon_t \varepsilon_{1t}'] = 0$ ,  $E[\upsilon_t \upsilon_t'] = \Sigma_{\upsilon\upsilon'}$  and  $E[\upsilon_t \upsilon_s'] = 0$  for  $s \neq t$ .  $\mathbf{D}_t$  is a  $k \times k$  diagonal matrix containing random (0,1)-indicators tracking zero observations. We assume that the diagonal elements of  $\mathbf{D}_t$  are perfectly correlated, i.e., when k > 1 the proxy variables are identically censored. We also assume that  $E[\mathbf{D}_t \upsilon_t \varepsilon_{1t}'] = 0$ , but we do not require that the censoring process  $\mathbf{D}_t$  is independent of  $\varepsilon_{1t}$ . The stochastic process for the proxies in equation (8) allows for (i) censoring, including the possibility that larger realizations (in absolute value) of  $\varepsilon_{1t}$  are more likely to be measured; (ii) additive correlated measurement errors  $\upsilon_t$ ; and (iii) an arbitrary scale. Scaling problems are particularly relevant for tax narratives since available estimates of changes in tax liabilities typically assume that the tax base remains invariant after legislative changes to the tax code.

Combining (8) with the SVAR in (2) results in a system of structural equations with latent variables, as discussed in Bollen (1989). Rewrite the model as

$$\mathbf{Y}_{t} = \mathbf{\theta}' \mathbf{X}_{t}^{*} + \mathbf{w}_{t},$$

where  $\mathbf{X}_{t}^{*} = [\mathbf{Y}_{t-1}^{\prime}, ..., \mathbf{Y}_{t-p}^{\prime}, \boldsymbol{\varepsilon}_{1t}^{\prime}]^{\prime}$ ,  $\boldsymbol{\theta} = [\boldsymbol{\delta}^{\prime}, \boldsymbol{\beta}_{1}]^{\prime}$ ,  $\boldsymbol{\delta} = [\boldsymbol{\delta}_{1}, ..., \boldsymbol{\delta}_{p}]^{\prime}$  and  $\mathbf{w}_{t} = \boldsymbol{\beta}_{2} \boldsymbol{\varepsilon}_{2t}$ .  $\mathbf{X}_{t}^{*}$  is not fully observable because it contains  $\boldsymbol{\varepsilon}_{1t}$ . The enlarged system is a measurement error model of the form

$$\mathbf{Y}_{t} = \boldsymbol{\gamma}' \, \overline{\mathbf{X}}_{t} + \mathbf{z}_{t}$$

$$\overline{\mathbf{X}}_{t} = \mathbf{\Omega} \mathbf{X}_{t}^{*} + \mathbf{\Upsilon}_{t},$$

where  $\overline{\mathbf{X}}_t = [\mathbf{Y}'_{t-1}, ..., \mathbf{Y}'_{t-p}, \mathbf{m}'_t]'$  and

$$\boldsymbol{\theta} = \boldsymbol{\Omega}'\boldsymbol{\gamma}\,, \quad \boldsymbol{w}_t = \boldsymbol{z}_t + \boldsymbol{\gamma}'\boldsymbol{\Upsilon}_t\,, \quad \boldsymbol{\Omega} = \begin{bmatrix} \boldsymbol{I} & \boldsymbol{0} \\ \boldsymbol{0} & \boldsymbol{\Gamma} \end{bmatrix}, \quad \boldsymbol{\Upsilon}_t = \begin{bmatrix} \boldsymbol{0} \\ \boldsymbol{D}_t\boldsymbol{v}_t + (\boldsymbol{D}_t - \boldsymbol{I}_k)\boldsymbol{\Gamma}\boldsymbol{\varepsilon}_{1t} \end{bmatrix}.$$

Note that because of censoring,  $E[\mathbf{X}_t^* \Upsilon_t'] \neq \mathbf{0}$  and  $\Upsilon_t$  is therefore not classical measurement error. From  $\Sigma_{\overline{\mathbf{X}}\mathbf{w}'} = \mathbf{0}$ , we obtain

(12) 
$$\theta = \Omega' \Lambda_{\overline{X}}^{-1} \Sigma_{\overline{X}X'}^{-1} \Sigma_{\overline{X}Y},$$

where  $\Lambda_{\overline{X}}$  is the reliability matrix of (the uncensored realizations) of  $\overline{X}_t$ , given by

(13) 
$$\Lambda_{\overline{X}} = \begin{bmatrix} I & \mathbf{0} \\ \mathbf{0} & \Sigma_{\mathbf{mm}'}^{-1} \Phi \Gamma' \end{bmatrix}.$$

Most existing narrative studies estimate a version of (10) (often also including lags of  $\mathbf{m}_{t}$ ) but unless there is no measurement error, the resulting naïve estimator  $\Sigma_{\overline{X}\overline{X}'}^{-1}\Sigma_{\overline{X}Y}$  is generally biased because of scaling  $(\Omega'\neq I)$ , and measurement error  $(\Lambda_{\overline{X}}^{-1}\neq I)$ . The elements of  $\theta$  reduce to

$$\delta = \Sigma_{\mathbf{X}\mathbf{X}'}^{-1}\Sigma_{\mathbf{X}\mathbf{Y}'} \;, \quad \beta_1' = \Phi^{-1}\Sigma_{\mathbf{m}\mathbf{Y}'}.$$

Note that, since  $\Sigma_{\mathbf{m}\mathbf{Y}'} = \Sigma_{\mathbf{m}\mathbf{u}'}$ , the three-stage procedure described in the previous section is equivalent to estimating a measurement error model in which  $\mathbf{Y}_t$  has perfect reliability and  $\mathbf{m}_t$  is measured with error.

Under the additional assumption of independent random censoring, it is possible to identify the statistical reliability matrix (13), see the Appendix for details. In that case, the  $k \times k$  reliability matrix of  $\mathbf{m}_t$  is given by

(14) 
$$\Lambda = \Sigma_{\mathbf{mm}'}^{-1} E[\mathbf{D}_t] \Gamma \Gamma'.$$

When k=1,  $\Lambda$  is the fraction of the variance in the uncensored measurements that is explained by the variance of the latent variable or equivalently the squared correlation between the narrative measure and the true structural shock of interest. Since  $0 \le \Lambda \le 1$ , measurement error bias manifests itself in this case as shrinkage toward zero. When k>1, the bias can go in either direction. The eigenvalues of  $\Lambda$  can be interpreted as the scalar reliabilities of the principal components of the uncensored observations in  $\mathbf{m}_t$ .  $\Lambda$  provides a metric for evaluating how closely the proxy variables are related to the true shocks, and is suggestive for the quality of identification. SVAR shocks are sometimes criticized for being at odds with historical events or descriptive records, see for instance Rudebusch (1998). The reliability of proxies constructed from the historical record of policy changes quantifies the extent to which this criticism applies.

#### II. Do Tax Cuts Stimulate Economic Activity?

In this section we apply our methodology to the estimation of the impact of exogenous tax shocks on economic activity in the United States over the postwar period. Here we concentrate mainly on the effects on output. The subsequent section provides evidence for a broader set of macroeconomic aggregates.

The empirical analysis in this paper differs from existing estimates of the effects of unexpected changes in tax policy in three ways. First, we apply the SVAR estimator presented above using legislated federal tax changes as proxies. Second, we take several steps to ensure that our estimates are not affected by the fact that many tax changes are anticipated. Third, while much of the macro literature has estimated

<span id="page-7-0"></span><sup>&</sup>lt;sup>4</sup> If k > 1, the proxy variables are not identically censored and if the off-diagonal elements of  $\Gamma$  are nonzero, (13) needs to be further decomposed into a reliability matrix and yet another bias term that is due to censoring.

the impact of changes in the average "total tax rate" (or in total tax revenues), we look at more disaggregated average tax rates. Ideally, one would like to examine the effects of changes in very narrowly defined tax instruments but there are practical limits to the level of disaggregation determined by data availability. We concentrate on changes in two tax categories, personal income and corporate income taxes. In our sample, personal income tax revenues (we include contributions to social insurance in our definition of personal income taxes) have accounted for on average 74.2 percent of total federal tax revenues while corporate income taxes have accounted for 16.4 percent. Thus, the two components comprise the bulk of total federal tax revenues.

#### A. A Tax Narrative for Personal and Corporate Income Taxes

We produce a narrative account of legislated federal personal and corporate income tax liability changes in the United States for a quarterly sample covering 1950:I–2006:IV. The narrative extends Romer and Romer's (2009a) analysis by decomposing the total tax liabilities changes recorded by Romer and Romer (2009a) into the following subcomponents: corporate income tax liabilities (CI), individual income tax liabilities (II), employment taxes (EM) and a residual category with other revenue changing tax measures (OT). We discard the latter group because it is very heterogeneous. The decomposition is based on the same sources as Romer and Romer (2009a) supplemented with additional information from sources such as congressional records, the Economic Report of the President, CBO reports, etc. whenever required. The online data Appendix describes the construction of the data and the historical sources in detail.

To comply with condition (5), which requires that the proxies are orthogonal to all nontax structural shocks, we retain only those changes in tax liabilities that were unrelated to the current state of the economy. To this end, we adopt Romer and Romer's (2009a) selection of exogenous changes in tax liabilities, which is based on a classification of the motivation for the legislative action either as ideological or as arising from inherited deficit concerns. Many of those changes in the tax code were legislated well in advance of their scheduled implementation. In Mertens and Ravn (2012a) we distinguish between unanticipated and anticipated tax changes on the basis of the implementation lag, the difference between the dates at which the tax change becomes law and when it is implemented. About half of the exogenous changes in tax liabilities were legislated at least 90 days before their implementation and Mertens and Ravn (2012a) show that there is evidence for aggregate effects of legislated tax changes prior to implementation. This means that shocks signaling tax

<span id="page-8-0"></span><sup>&</sup>lt;sup>5</sup> The macroeconomic literature instead often distinguishes between labor and capital income taxes, see e.g., Mendoza, Razin, and Tesar (1994), Jones (2002), or Burnside, Eichenbaum, and Fisher (2004), which is appealing in terms of economic modeling. However, the division into personal and corporate income taxes corresponds more closely to the actual policy instruments and observed changes in federal tax liabilities can be much more easily assigned to one of these tax categories.

<span id="page-8-1"></span><sup>&</sup>lt;sup>6</sup> II and EM tax changes include adjustments to marginal rates and various deductions and tax credits. CI tax changes include a few adjustments to marginal rates and otherwise mainly changes in depreciation allowances and investment tax credits. The other tax changes mostly include excise taxes, often targeted to specific industries (transportation) or goods (gasoline, automobiles, sport and leisure goods,...), and gift and estate taxes. See the online Appendix for details.

changes in future periods have macroeconomic effects that are distinct from those of shocks that change taxes contemporaneously. We focus on unanticipated changes in taxes and therefore we retain only those tax changes for which the implementation lag is less than one quarter.

Romer and Romer (2009a) describe almost 50 legislative changes in the tax code over the sample period, many containing multiple changes in tax liabilities implemented at different points in time. Our narrative measures are a much smaller subset because we eliminate all endogenous and/or preannounced tax changes. Our dataset contains 13 observations of individual income tax liability changes, two observations for employment tax liability changes, and 16 observations for corporate income tax liability changes deriving from 21 separate legislative changes to the federal tax code. The vast majority of these changes were legislated as permanent changes to the tax code. Because there are too few observations for a separate employment tax category, we merge the EM and II taxes into a personal income (PI) tax category. All our results are very similar if we omit the employment taxes.

We convert the tax liability changes into the corresponding average tax rate changes as follows:

```
\Delta \mathbf{T}_{t}^{PI,narr} = (\text{II tax liability change}_{t} + \text{EM tax liability change}_{t})
/\text{Personal Taxable Income}_{t-1}
\Delta \mathbf{T}_{t}^{CI,narr} = \text{CI tax liability change}_{t}/\text{Corporate Profits}_{t-1},
```

where personal taxable income is defined as personal income less government transfers plus contributions for government social insurance. We scale the tax liability changes by previous quarter taxable incomes, but our results are nearly identical if we instead scale by the contemporaneous or previous year taxable income. The resulting narrative measures are depicted in Figure 1 together with NIPA-based measures of the average personal income tax rate (APITR) and average corporate income tax rate (ACITR), constructed as

```
\mathbf{APITR}_t = (\text{Personal Current Taxes}_t + \text{Contributions for Govt. Social Insurance}_t) \\ / \text{Personal Taxable Income}_t
```

 $\mathbf{ACITR}_t = \text{Taxes on Corporate Profits}_t/\text{Corporate Profits}_t$ 

where all taxes are at the federal level. The Appendix gives the precise data sources. The (demeaned) narrative measures  $\Delta \mathbf{T}_t^{PI,narr}$  and  $\Delta \mathbf{T}_t^{CI,narr}$ , shown in Figure 1, will be used as proxies for structural innovations to the two average tax rates. Both of these average tax rates display considerable variation over time, reflecting unanticipated legislative changes to the tax code but also endogenous movements in taxes, some resulting from explicit legislative actions and others not. There are many different sources of endogeneity in the average tax rates ranging from policy responses to macroeconomic shocks to cyclical fluctuations in the administrative definition of taxable income versus NIPA income, tax progressivity and changes

<span id="page-10-0"></span>![](_page_10_Figure_3.jpeg)

FIGURE 1. AVERAGE TAX RATES AND NARRATIVE SHOCK MEASURES, US 1950:I-2006:IV

in the distribution of income, cyclical variations in tax compliance and evasion, etc. The narrative measures  $\Delta \mathbf{T}_t^{PI,narr}$  and  $\Delta \mathbf{T}_t^{CI,narr}$  contain only legislative actions undertaken for reasons unrelated to the current state of the economy and can therefore be used to identify the truly exogenous innovations to the APITR and ACITR series.

We note that, even though total federal tax revenues as a share of GDP have remained fairly stable around 18 percent, the APITR and ACITR series both display trends over the sample. Figure 1 shows that the APITR has slowly risen from around 10 percent at the beginning of the sample to approximately 18 percent at the end of 2006. The two most significant exogenous changes in personal income taxes relate to the Revenue Act of 1964, which reduced marginal tax rates on individual income, and to the Jobs and Growth Tax Relief Reconciliation Act of 2003, which reduced marginal tax rates on individual income, capital gains and dividends, and increased some tax expenditures. Each of these two pieces of legislation cut average personal income tax rates by more than 1 percentage point according to the narrative measure. The ACITR instead has fallen significantly over time from over 50 percent in the early 1950s to just above 20 percent at the end of the sample period. The narrative measure indicates several sizable changes in corporate income taxes. The largest change in CI tax liabilities is associated with the repeal of the investment tax credit included in the Tax Reform Act of 1986.

We checked whether lagged macro variables Granger cause the narrative shocks but we found no such evidence. We also tested for predictive power in regressions of the uncensored observations of the measured tax shocks and lagged values of key variables but did not detect any statistical significance. As a result, the proxy measures for the tax shocks  $\mathbf{m}_t$  are the narrative shock series  $\Delta \mathbf{T}_t^{PI,narr}$  and  $\Delta \mathbf{T}_t^{PI,narr}$  shown in Figure 1 after subtracting the mean of the nonzero observations. In the robustness section, we discuss the results for some alternative choices for the proxies.

#### B. *Identifying Tax Shocks*

To obtain valid covariance restrictions from the proxy variables  $m_t$ , it is essential that the measured tax changes are uncorrelated with nontax structural shocks. It is however also important to consider whether measured changes in personal income taxes are uncorrelated with structural shocks to corporate taxes, and vice versa. If so, then each of the two proxy variables can be used in isolation to derive n-1 restrictions, or 2(n-1) in total. In combination with the residual covariance restrictions, each set of n-1 restrictions suffices to identify the impulse response to the respective tax shock, see the Appendix. If we cannot impose zero cross-correlations between the measured tax changes and structural tax shocks, the identifying assumptions on the combined proxy series yield only 2(n-2) restrictions, which is insufficient to disentangle the causal effects of shocks to both types of taxes.

Conditional on a tax change taking place, the correlation between the PI and CI narrative tax changes in our sample is 0.42. Insofar that this positive correlation is not just due to chance or correlated measurement error, it appears inappropriate to treat the narrative PI (CI) tax changes as uncorrelated with exogenous shocks to the corporate (personal) tax rate. The positive correlation between the measured changes in personal and corporate taxes is natural for a number of reasons. The tax narratives record changes in tax liabilities for which the historical documents

<span id="page-11-0"></span> $<sup>^7</sup>$  Tests of the null hypothesis that the average tax rate, GDP, government spending, and the tax base do not Granger cause the narrative shock measure have p-values of 0.70 for the PI tax shock measure and 0.76 for the CI tax shock measure. For the variables of our benchmark system below, the p-values are 0.87 and 0.57. For these tests we used first differences for the variables as the test is problematic when the data is nonstationary. We also performed tests for a range of other variables such as municipal bonds spreads and government debt. The smallest p-value (0.23) we found was for the hypothesis that the government debt to GDP ratio does not Granger cause the CI narrative measure.

indicate that they were not explicitly motivated by countercyclical considerations. Yet they of course still occurred with certain objectives in mind, typically related to longer run goals for economic growth or debt reduction. When both personal and corporate income taxes are adjusted simultaneously, it is therefore not surprising that they are often adjusted in the same direction. Also, given that the tax narratives are based on actual legislative actions, the fixed costs of passing legislation naturally imply a temporal correlation of the changes in different types of taxes.

For isolating the causal effects of a change in only one of the tax rates, it is thus important to control for changes in the other tax rate, which requires imposing more restrictions. Consider the following parametrization of the relationship between the VAR residuals  $u_t$  and structural shocks  $\varepsilon_t$ :

$$\mathbf{u}_{1t} = \mathbf{\eta} \, \mathbf{u}_{2t} + \mathbf{S}_1 \, \mathbf{\varepsilon}_{1t}$$

(16) 
$$\mathbf{u}_{2t} = \zeta \mathbf{u}_{1t} + \mathbf{S}_2 \varepsilon_{2t},$$

where  $\mathbf{u}_{1t}$  and  $\boldsymbol{\varepsilon}_{1t}$  are the  $2 \times 1$  vectors of reduced form and structural tax rate innovations, whereas the  $(n-2) \times 1$  vectors  $\mathbf{u}_{2t}$  and  $\boldsymbol{\varepsilon}_{2t}$  contain the reduced form residuals and other structural shocks associated with an arbitrary number of additional variables. The matrices  $\boldsymbol{\eta}$ ,  $\boldsymbol{\zeta}$ ,  $\mathbf{S}_1$  and  $\mathbf{S}_2$  contain the structural coefficients that underlie  $\mathbf{B}$ . In particular, the  $2 \times 2$  nonsingular matrix  $\mathbf{S}_1$  is not necessarily diagonal, capturing the potential contemporaneous interdependence of the tax instruments.

Obtaining the responses to  $\varepsilon_{1t}$  requires identification of  $\beta_1$ , containing the first two columns of **B**, which is given by

(17) 
$$\beta_1 = \begin{bmatrix} \mathbf{I} + \boldsymbol{\eta} (\mathbf{I} - \boldsymbol{\zeta} \boldsymbol{\eta})^{-1} \boldsymbol{\zeta} \\ (\mathbf{I} - \boldsymbol{\zeta} \boldsymbol{\eta})^{-1} \boldsymbol{\zeta} \end{bmatrix} \mathbf{S}_1.$$

In the Appendix, we show that the linear restrictions in (7) allow for the identification of the first term in square brackets,  $\beta_1 \mathbf{S}_1^{-1}$ , as well as  $\mathbf{S}_1 \mathbf{S}_1'$ , the covariance of  $S_1 \varepsilon_{1t}$ . The covariance restrictions are, however, not sufficient to obtain the structural decomposition of this covariance and obtain  $S_1$ . To see this intuitively, note that  $\zeta$  can be estimated by 2SLS using  $\mathbf{m}_t$  as instruments. Given an estimate of  $\zeta$ , it is possible to use  $\mathbf{u}_{2t} - \zeta \mathbf{u}_{1t}$  as instruments to estimate  $\eta$ . Finally, the covariance of  $\mathbf{u}_{1t} - \eta \mathbf{u}_{2t}$ provides an estimate of  $S_1 S_1'$ . Ideally one would like to identify  $S_1$  but this requires arbitrary assumptions on how personal income taxes respond contemporaneously to unanticipated changes in corporate taxes (beyond the indirect contemporaneous endogenous effects through  $\mathbf{u}_{2t}$ ), and vice versa. Fortunately, knowledge of  $\beta_1 \mathbf{S}_1^{-1}$ still permits economically meaningful structural responses to any linear combination of tax shocks. We report responses that result from a Choleski decomposition of  $S_1S_1'$ , imposing that  $S_1$  is lower triangular. Suppose for instance that the APITR is ordered before the ACITR. Then the response to a negative 1 percentage point ACITR shock is the response to an exogenous tax change that lowers the ACITR by 1 percentage point but leaves the APITR unchanged in "cyclically adjusted" terms, i.e., after allowing for contemporaneous feedback from  $\mathbf{u}_{2t}$ . A shock to the APITR on the other hand induces a change in the ACITR through feedback from  $\mathbf{u}_{2t}$  as well as a direct response to the APITR shock that is determined by the identified correlation between both tax rates.

If  $S_1S_1'$  is diagonal, the latter correlation is zero and the responses are identical for different orderings of the tax rates.

#### C. Benchmark Specification and Results

Our benchmark estimates for the dynamic output effects of tax changes are based on a VAR with seven variables:  $\mathbf{Y}_t = [APITR_t, ACITR_t, \ln(B_t^{PI}), \ln(B_t^{CI}), \ln(G_t), \ln(GDP_t), \ln(DEBT_t)]$ .  $APITR_t$  and  $ACITR_t$  are the average tax rates discussed above;  $B_t^{PI}$  and  $B_t^{CI}$  are the personal and corporate income tax bases in real per capita terms.  $G_t$  is government purchases of final goods,  $GDP_t$  is gross domestic product,  $DEBT_t$  is federal government debt, all in real per capita terms. All fiscal variables are for the federal level. Precise data definitions are provided in the Appendix. The sample consists of quarterly observations for the period 1950:I–2006:IV. Based on the Akaike information criterion, the lag length in the VAR is set to four.

All impulse responses are for a 1 percentage point decrease in either of the two tax rates and we show results for a forecast horizon of 20 quarters. We report 95 percent confidence intervals computed using a recursive wild bootstrap using 10,000 replications, see Gonçalves and Kilian (2004). We generate bootstrap draws  $\mathbf{Y}_{t}^{b}$  recursively using  $\hat{\delta}_i$ , j = 1,...,p and  $\hat{\mathbf{u}}_t \mathbf{e}_t^b$ , where the  $\hat{\delta}_i$ s and  $\hat{\mathbf{u}}_t$  denote the estimates for the VAR in (2) and  $\mathbf{e}_t^b$  is the realization of a random variable taking on values of -1 or 1 with probability 0.5. We also generate a draw for the proxy variables  $\mathbf{m}_{t}^{b} = \mathbf{m}_{t} \mathbf{e}_{t}^{b}$ , reestimate the VAR for  $\mathbf{Y}_{t}^{b}$  and apply the covariance restrictions implied by  $\mathbf{m}_{t}^{b}$ . The percentile intervals are for the resulting distribution of impulse response coefficients. This procedure requires symmetric distributions for  $\mathbf{u}_t$  and  $\mathbf{m}_t$  but is robust to conditional heteroscedasticity. It also takes into account uncertainty about identification and measurement. This contrasts with the typical application of coefficient restrictions in SVARs as well as narrative specifications, which often treat  $\mathbf{m}_t$  as deterministic. The standard residual bootstrap is problematic given that  $\mathbf{m}_{t}$  contains many zero observations, which means that drawing with replacement from  $\mathbf{m}_t$  yields zero vectors with positive probability.

Figures 2 and 3 show the effects of cuts in average personal and corporate income tax rates for each ordering of the tax rates. The correlation between the cyclically adjusted tax rate innovations  $S_1 \varepsilon_{1t}$  is small and estimated at -0.07 with a 95 percent confidence interval [-0.41,0.50]. As a result, the responses are very similar for the different tax rate orderings. This turns out to be a robust finding in sufficiently large VAR systems, in particular when they include government debt. When discussing a shock to a tax rate, for brevity we therefore only discuss the point estimates resulting from ordering that tax rate last, leaving the other tax rate unchanged in cyclically adjusted terms.

Figure 2 shows that after the initial 1 percentage point cut in personal income taxes, the APITR remains significantly below the level expected prior to the shock during the first year. Thereafter, the APITR gradually converges to pre-shock expected levels in the longer run. The cut in the APITR sets off a significant increase in the personal income tax base which initially rises approximately 0.6 percent and peaks

<span id="page-13-0"></span><sup>&</sup>lt;sup>8</sup> Government debt is a potentially important variable since any change in taxes eventually must lead to adjustments in the fiscal instruments. Especially if the reaction to debt is strong and relatively fast, it might be inappropriate not to explicitly allow for feedback from debt to taxes and spending.

<span id="page-14-0"></span>![](_page_14_Figure_3.jpeg)

FIGURE 2. BENCHMARK SPECIFICATION: AN APITR CUT

*Notes:* Figure shows the responses to a 1 percentage point cut in the APITR. Full lines are point estimates; broken lines indicate 95 percent confidence intervals.

at 1.3 percent one year after the tax cut. Combining the responses of the tax base and the personal income tax rate, the decrease in the APITR implies a drop in personal income tax revenues of 5.4 percent upon impact. Tax revenues remain relatively low until several years after the shock, but recover substantially from the initial drop

<span id="page-14-1"></span><sup>&</sup>lt;sup>9</sup> The response of tax revenues are computed as  $\widehat{tr}_t = \widehat{T}_t^i / \overline{T}^i + \widehat{b}_t^i$  where  $\overline{T}^i$  is the mean average tax rate of type i = PI, CI in the sample,  $\widehat{x}_t$  denotes the impulse response of  $x_t$  and lower case letters denote logged variables.

<span id="page-15-0"></span>![](_page_15_Figure_3.jpeg)

Figure 3. Benchmark Specification: An ACITR Cut

*Notes:* Figure shows the responses to a 1 percentage point cut in the ACITR. Full lines are point estimates; broken lines indicate 95 percent confidence intervals.

during the first year. Despite the increase in the tax base we find that cuts in personal income taxes unambiguously lower personal tax revenues. Most importantly, cuts in average personal income taxes provide a substantial short run output stimulus. A 1 percentage point decrease in the APITR leads to an increase in output of 1.4 percent in the first quarter and a peak increase of 1.8 percent which occurs three quarters after the tax cut. The confidence intervals indicate a significant increase (at the 95 percent level) in economic activity within a two year window after the tax cut.

Figure 3 shows the effect of a 1 percentage point decrease in the average corporate income tax rate. The cut in the ACITR leads to a prolonged period of lower average corporate income tax rates. The cut in the ACITR induces a large and significant increase in the corporate income tax base which rises by up to 3.8 percent in the first six months. The increase in the tax base is sufficiently large such that there is only a very small decline in corporate income tax revenues in the first quarter and a surplus thereafter. The response of corporate tax revenues is however insignificant at every horizon. Hence, cuts in corporate income taxes appear to be approximately self-financing which is suggestive of particularly strong behavioral responses to changes in effective corporate tax rates. The output effects of ACITR cuts are again significant and substantial. A 1 percentage point decrease leads to a rise in real GDP of around 0.4 percent rising up to 0.6 percent about one year after the cut.

In accordance with Romer and Romer (2009b), we find little impact of either tax shocks on government spending. Figure 2 shows that the response of government spending to an APITR tax cut is insignificantly different from zero at the 95 percent level at all forecast horizons. Similarly, there is little evidence that changes in the ACITR impact systematically on government spending. This is reassuring since it refutes the possibility that the responses to tax shocks are confounded with changes in government spending. We also find that cuts in one average tax rate lead to increases in the other average tax rate, although neither of these increases is significant. The mutual tax rate responses indicate that our orthogonalization scheme successfully disentangles the effects of different tax instruments. Government debt (not shown) increases significantly at the 95 percent level in the short run after an APITR cut, but does not change significantly after an ACITR cut. The debt response is more precisely estimated in specifications that include interest rates, which are discussed below.

Under the additional measurement error assumptions of Section IB, our procedure also allows for the identification of the reliabilities of the proxy variables, which are reported in Table 1. The estimated reliability matrix of  $\mathbf{m}_t$  has eigenvalues of 0.30 and 0.69 with 95 percent confidence intervals [0.16,0.48] and [0.47,0.97]. This implies that the correlations between the principal components of the narrative tax changes and the true tax shocks are 0.55 and 0.83. The former number is also the smallest correlation of any linear combination of the proxy variables. These statistics indicate that the proxies contain valuable information for the identification of the structural tax shocks and that there is a reasonably strong connection between the SVAR shocks and historically documented legislative changes to the tax code. At the same time, the fact that the reliability matrix has eigenvalues substantially below unity indicates that measurement error is a serious concern in practice. Table 1 also reports  $R^2$  statistics for regressions of the reduced form residuals of the average tax rates  $\mathbf{u}_{1t}$  on nonzero observations of the proxies. The values of 0.22 and 0.38 indicate that the narrative shocks explain a sizable fraction the prediction error variance of the average tax rates.

Perhaps the most important result in this paper is that the estimated short run output effects of changes in average tax rates are large. Another common metric for these effects is the tax multiplier, defined as the dollar change in GDP per effective dollar

<span id="page-16-0"></span><sup>&</sup>lt;sup>10</sup> We regressed each of the elements of  $\mathbf{u}_{1t}$  on both proxies  $\mathbf{m}_{t}$  in the subsample of observations for which at least one of the two proxies takes on a nonzero value.

| TARIF | I—DIAGNOSTIC | STATISTICS |
|-------|--------------|------------|
|       |              |            |

<span id="page-17-0"></span>

|                                          |                             |                      | $R^2$ ( $\mathbf{u}_{1t}$ on $\mathbf{m}_t$ ) |       |
|------------------------------------------|-----------------------------|----------------------|-----------------------------------------------|-------|
| Specification                            | Reliabilities (eigenvalues) |                      | APITR                                         | ACITR |
| Benchmark (Figures 2 and 3)              | 0.30<br>[0.16, 0.48]        | 0.69<br>[0.47, 0.97] | 0.22                                          | 0.38  |
| With monetary variables (Figure 4)       | 0.54<br>[0.30, 0.69]        | 0.66<br>[0.52, 1.00] | 0.23                                          | 0.39  |
| Using single tax proxy (Figure 5)        | 0.38<br>[0.21, 0.56]        | 0.64<br>[0.55, 0.69] | 0.24                                          | 0.16  |
| Annual with average tax rate (Figure 8)  | 0.54<br>[0.25, 0.70]        |                      | 0.37                                          | _     |
| Annual with marginal tax rate (Figure 8) | 0.60<br>[0.40, 0.70]        |                      | 0.34                                          | _     |
| With labor market variables (Figure 9)   | 0.46<br>[0.25, 0.57]        | 0.51<br>[0.42, 0.81] | 0.21                                          | 0.17  |
| With consumption variables (Figure 10)   | 0.27<br>[0.13, 0.44]        | 0.50<br>[0.33, 0.77] | 0.17                                          | 0.29  |
| With investment variables (Figure 10)    | 0.30<br>[0.15, 0.49]        | 0.69<br>[0.46, 0.95] | 0.17                                          | 0.32  |

Note: Values in brackets are 95 percent confidence bands computed using 10,000 bootstrap replications.

loss in revenues. Multipliers can be obtained in our SVAR by rescaling the output response such that the implied drop in tax revenues is normalized to 1 percent of GDP. For the personal income tax we find a multiplier of 2.0 on impact rising to a maximum of 2.5 in the third quarter. The same calculation for the corporate income tax instead makes little sense given that the estimated impact on revenues is approximately zero.

The results just discussed derive from a VAR which includes other fiscal variables such as government spending and debt. Controlling for monetary variables may be equally relevant, as monetary policy adjustments are typically very important for determining the ultimate effects of fiscal shocks in theoretical models. Moreover, changes in taxes may impact costs of production and, to the extent that cost changes are passed into prices, affect inflation. The sign of the inflation response is indicative of whether the expansionary effects of tax cuts are primarily derived from increased demand or supply for final goods. For these reasons we estimate an expanded benchmark model that also includes monetary policy instruments and inflation in the vector observables. We add the following series: the effective federal funds rate, the (log) level of nonborrowed reserves and the (log) level of the price index for personal consumption expenditures. In order to economize on the number of coefficients, we omit the two tax bases from the vector of observables. <sup>11</sup> The inclusion of the monetary variables yields reliabilities and  $R^2$  statistics similar to the benchmark specification (see Table 1), with the lowest eigenvalue of the reliability matrix now notably higher.

The first row of Figure 4 shows that the output stimuli provided by both types of tax cuts are similar in size and timing to the benchmark specification. Thus, the output responses to the tax policy shocks appear robust to controlling for monetary

<span id="page-17-1"></span><sup>&</sup>lt;sup>11</sup> The online Appendix reports results from a specification that simply adds the three additional monetary variables to the original seven observables (including the tax bases). This produces very similar point estimates but with somewhat larger confidence bands.

<span id="page-18-0"></span>![](_page_18_Figure_3.jpeg)

Figure 4. Responses with Monetary Policy and Inflation Controls

*Notes:* Panel A (panel B) shows the responses to a 1 percentage point cut in the APITR (ACITR). Full lines are point estimates; broken lines indicate 95 percent confidence intervals.

policy instruments. The second row reports the response of real federal government debt per capita, which turns out to be more precisely estimated with the inclusion of the monetary variables.[12](#page-19-0) Government debt increases persistently after an APITR cut although the effect is only statistically significant at the 95 percent level in the first two quarters. Consistent with the absence of any sizable impact on revenues, there is no significant effect on debt from a cut in the corporate tax.

A cut in the APITR is mildly disinflationary on impact and briefly inflationary in the third quarter, but none of these effects are significant at 95 percent levels. We find a stronger negative impact of a cut in the ACITR on the inflation rate in the short run and, in contrast to the results for the APITR, the decline in inflation is persistent and statistically significant at the 95 percent level in the first two quarters. The short run disinflationary effects of corporate tax cuts are robust to using alternative measures of the nominal price level, such as the GDP deflator or the BLS consumer price index. The drop in inflation after a corporate tax cut is consistent with a fall in marginal costs and dominating supply side effects. The evidence for changes in personal income taxes is inconclusive.

There is no strong evidence that changes in either of the two tax rates impact significantly on the short term nominal interest rate, as measured by the funds rate, and we found the same when using the three-month T-Bill rate[.13](#page-19-1) This supports the interpretation of the impulse responses as the impact of changes in taxes. For the APITR this result is not too surprising given there is no clear impact on the inflation rate. For the ACITR instead, the short run decline in the inflation rate following a tax cut might instead have been expected to trigger a stronger monetary policy accommodation. There are various possible explanations including that the drop in inflation is accompanied by an increase in aggregate activity and that the impact on inflation is transitory.
