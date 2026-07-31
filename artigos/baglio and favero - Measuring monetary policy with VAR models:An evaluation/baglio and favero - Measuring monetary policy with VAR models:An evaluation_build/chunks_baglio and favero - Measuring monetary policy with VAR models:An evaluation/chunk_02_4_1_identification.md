# *4.1. Identification*

The benchmark shocks are derived by applying a standard identification scheme on the VAR model. Monetary policy shocks are identified from the VAR by assuming that policy variables react contemporaneously to the nonpolicy

![](_page_16_Figure_2.jpeg)

Fig. 4. Recursive stability tests on the benchmark VAR (1988:11-1996:3; initialization: 60 observations).

variables, while the converse does not hold, and by considering an operating procedure in which the Fed fully offsets shocks to total and borrowed reserves demand, which corresponds to the parametric assumption  $\phi^D = 1$ ,  $\phi^B = -1$ . This scheme imposes one over-identifying restriction on the system, which has now the following structural form:

$$\begin{vmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ d_{21} & 1 & 0 & 0 & 0 & 0 \\ d_{31} & d_{32} & 1 & 0 & 0 & 0 \\ d_{41} & d_{42} & d_{43} & 1 & 0 & 0 \\ d_{51} & d_{52} & d_{53} & \alpha & 1 & 0 \\ d_{61} & d_{62} & d_{63} & \beta & -1 & 1 \end{vmatrix} \begin{vmatrix} GDP_t \\ P_t \\ PCm_t \\ FF_t \\ TR_t \\ NBR_t \end{vmatrix} = C^*(L) \begin{vmatrix} GDP_{t-1} \\ P_{t-1} \\ PCm_{t-1} \\ FF_{t-1} \\ TR_{t-1} \\ NBR_{t-1} \end{vmatrix} + \begin{vmatrix} v_{1t}^{NP} \\ v_{2t}^{NP} \\ v_{3t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_$$

Estimation of Eq. (4.1) is implemented, instead of imposing the restriction  $d_{65}=-1$ , by means of a Choleski factorization of the VAR residuals with the

![](_page_17_Figure_2.jpeg)

Fig. 5. Recursive stability tests on the benchmark VAR model as a system (1988:11–1996:3; initialization: 60 observations).

ordering shown above. The validity of the overidentifying restriction is then checked by looking at the estimated  $d_{65}$  coefficient and its standard error.

The results are reported in Table 4. We note that the simultaneous reaction of the federal funds rate to the macroeconomic policy variables (captured by  $d_{41}$ ,  $d_{42}$  and  $d_{43}$ ) is not strongly significant. Such evidence is confirmed by Fig. 6, showing a negligible difference between VAR innovations in the federal funds rate and the structural monetary policy shocks  $v^{\rm S}$ , that we label BENCH.<sup>3</sup> The structural parameters describing the market for reserves are broadly in line with the predictions of the model:  $\alpha$  and  $\beta$  are not significant, though correctly signed. Finally, the overidentifying restriction  $d_{65}=-1$  cannot be rejected, supporting the validity of the identification scheme used.

<sup>&</sup>lt;sup>3</sup> Similar results are reported by Rudebusch (1996), who estimates a slightly different specification on the same sample and contrasts the results with those derived by Leeper et al. (1996) from a similar VAR but over a much longer sample period.

![](_page_18_Figure_2.jpeg)

Fig. 6. Benchmark VAR innovations (FF) and structural residuals (BENCH).

We now consider several alternative measures of monetary policy shocks derived independently from the estimation of the VAR model.

The first to be considered is the one originally proposed by Rudebusch (1996) and further analysed by Brunner (1996). Monetary policy shocks are derived from the 30-day Fed funds future contracts, which have been quoted on the Chicago Board of Trade since October 1988, and are bets on the average overnight fed funds rate for the delivery month, corresponding to the variable included in the benchmark VAR. Fig. 7 reports the federal funds rate implicit in the future contract along with the Fed's federal fund rate target. Shocks are constructed as the difference between the federal funds rate at month *t* and the 30-day federal funds future at month *t*!1. Such choice is based on the evidence, that the regression of the federal funds rate at *t* on the 30-day federal funds future at *t*!1 produces an intercept not significantly different from zero, a slope coefficient not significantly different from one, and serially

Table 4
The benchmark structural VAR model

The relation between reduced-form and structural disturbances is Eq. (2.7) in the text:

$$\begin{vmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ a_{21} & 1 & 0 & 0 & 0 & 0 \\ a_{31} & a_{32} & 1 & 0 & 0 & 0 \\ a_{41} & a_{42} & a_{43} & 1 & -\frac{1}{\beta} & \frac{1}{\beta} \\ a_{51} & a_{52} & a_{53} & \alpha & 1 & 0 \\ a_{61} & a_{62} & a_{63} & 0 & 0 & 1 \end{vmatrix} \begin{vmatrix} u_t^{GDP} \\ u_t^P \\ u_t^{Pem} \\ u_t^{FF} \\ u_t^{RR} \\ u_t^{NBR} \end{vmatrix} = \begin{vmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \\ 0 & 0 & 0 & -\frac{1}{\beta} & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & \phi^D & \phi^B & 1 \end{vmatrix} \begin{vmatrix} v_{1t}^{NP} \\ v_{2t}^{NP} \\ v_{1t}^{NP} \\ v_{2t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \end{vmatrix}$$

Estimation is performed (with  $\phi^D = 1$  and  $\phi^B = -1$  imposed) after rewriting the above expression as  $Du_t = v_t$ :

$$\begin{vmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ d_{21} & 1 & 0 & 0 & 0 & 0 \\ d_{31} & d_{32} & 1 & 0 & 0 & 0 \\ d_{41} & d_{42} & d_{43} & 1 & 0 & 0 \\ d_{51} & d_{52} & d_{53} & d_{54} & 1 & 0 \\ d_{61} & d_{62} & d_{63} & d_{64} & d_{65} & 1 \end{vmatrix} \begin{vmatrix} u_t^{GDP} \\ u_t^P \\ u_t^{FCm} \\ u_t^{FF} \\ u_t^{TR} \\ u_t^{NBR} \end{vmatrix} = \begin{vmatrix} v_{11}^{NP} \\ v_{21}^{NP} \\ v_{21}^{NP} \\ v_{31}^{NP} \\ v_t^{NP} \\ v_t^{NP} \end{vmatrix}$$

with  $d_{54} = \alpha$ ,  $d_{64} = \beta$   $d_{65} = -1$  (this restriction is not imposed in estimation). The sample period is: 1988(11)–1996(3).

|                  | Estimated ec   | Estimated ecoefficients of matrix D | natrix <b>D</b>                                           |                 |                |                 |                |                |
|------------------|----------------|-------------------------------------|-----------------------------------------------------------|-----------------|----------------|-----------------|----------------|----------------|
|                  | $d_{21}$       | $d_{31}$                            | $d_{32}$                                                  | d <sub>41</sub> | $d_{42}$       | d <sub>43</sub> | $d_{51}$       | $d_{52}$       |
| Coeff.<br>(S.E.) | -0.002 (0.050) | -1.108 (0.473)                      | -0.233 (1.044)                                            | 11.54 (5.562)   | -15.87 (11.89) | -0.540 (1.250)  | 0.056          | -0.596 (0.631) |
|                  | $d_{53}$       | $d_{54}(\alpha)$                    | $d_{61}$                                                  | $d_{62}$        | $d_{63}$       | $d_{64}(\beta)$ | $d_{65}$       |                |
| Coeff.<br>(S.E.) | 0.068          | 0.010                               | 0.042 (0.140)                                             | -0.464 (0.296)  | -0.033 (0.031) | 0.003           | -1.028 (0.051) |                |
|                  | Estimated sta  | ındard deviati                      | Estimated standard deviations of structural disturbances: | al disturbanc   | es:            |                 |                |                |
|                  | $v_1^{NP}$     | $v_2^{NP}$                          | $v_3^{NP}$                                                | N.S             | $\nu^{\rm D}$  | $v^{\rm B}$     |                |                |
| Estimate (S.E.)  | 0.002 (0.0002) | 0.001 (0.0001)                      | 0.009 (0.0007)                                            | 0.100 (0.008)   | 0.005 (0.0004) | 0.002 (0.0002)  |                |                |

![](_page_21_Figure_2.jpeg)

Fig. 7. The Fed funds target (TARGET) and the 30-day fed funds future (FFF30D).

uncorrelated residuals:

$$FF_{t} = -0.037 + 0.999 FFF_{t-1} + \hat{u}_{t},$$

$$(0.0436) \quad (0.007)$$

$$R^{2} = 0.99, \quad \sigma = 0.145, \quad DW = 1.86.$$

This procedure produces shocks, labelled FFF, which are comparable to the reduced form innovations from the VAR and not to the structural monetary policy shocks, because surprises relative to the information available at the end of month t-1 may reflect endogenous policy responses to news about the economy that become available in the course of month t. For this reason we map the FFF innovations into an equivalent of structural monetary policy shocks by regressing them on the VAR innovations of the nonpolicy variables:

$$\hat{u}_t = -0.92 u_t^{GDP} + 27.78 u_t^P - 2.04 u_t^{Pcm} + FFFS_t,$$

$$R^2 = 0.05, \quad \sigma = 0.145, \quad DW = 1.76.$$

As in the case for the benchmark VAR model, the above regression does not show any strong effect of current macroeconomic variables on the federal funds rate. This kind of evidence is in line with the results in Rudebusch (1996) and could justify the identification scheme adopted by some authors (e.g. Gordon and Leeper, 1994), who assume that within the month the Fed reacts to current money and financial market variables, but not to current innovations in the goods market variables, which are observed with a one-month lag. On the other hand, this empirical evidence does not support the view of endogeneity of money on the sample considered. We label this measure of monetary policy shocks as *FFFS*.

A second non-VAR measure of policy shocks is based on the work of Skinner and Zettelmeyer (1996). They derive a measure of unanticipated monetary policy shocks by following a two-step methodology: first, using information from central bank reports and newspapers, a list of days on which monetary policy announcements occurred is constructed; second, monetary policy shocks are identified with the changes in the three-month interest rate on the days of policy announcements. The validity of such procedure requires that (i) short rates (e.g the overnight rate) are affected by policy; (ii) arbitrage is effective between the overnight and the three-month interest rate; (iii) the impact of other news affecting the three-month rate on the day of the policy decision is negligible; (iv) policy actions are not endogenous responses to information that becomes available on the day when the decision is taken. To ensure that conditions (iii) and (iv) are applicable, Skinner and Zettelmeyer go through reports of the policy actions and exclude from their sample those which do no conform to requirements (iii) and (iv). The main problem with the index so obtained is that it can only pin down shocks associated to monetary policy decisions reflected in some action on controlled variables, whereas shocks associated with *no* action (while some action was expected by the markets) are neglected. In the latest part of our sample, when monetary policy decisions are taken on the occasion of the *FOMC* meetings, we can overcome this problem by extending the index to consider as shocks the change of the three month-rate on occasion of the *FOMC* meetings. By doing so we derive shocks that we label *ESZ*. For reference, we note that the shocks associated to no action are never larger than 5 basis point in absolute value in our sample. Therefore, most of the volatility of this series is generated at the dates where some action was taken and the sample selection problem introduced by the original methodology of Skinner and Zettelmeyer does not seem to be severe. *ESZ* are by their nature structural shocks, directly comparable with the identified monetary policy shocks of the benchmark VAR model.

The third alternative measure of shocks is based on the estimation of the term structure of spot rates and of instantaneous forward rates as proposed by Svensson (1994) and applied in Favero et al. (1996). The methodology is based on the use of instantaneous forward rates as monetary policy indicators. Forward rates are interest rates on investments made at a future date, the settlement date, and expiring at a date further into the future, the maturity date. Instantaneous forward interest rates are the limit as the maturity date and the settlement date approach one another.

To illustrate our derivation of spot rate, let us start by the consideration of a zero-coupon bond issued at time t with a face value of 1, maturity of m years and price  $P_{mt}^{\rm ZC}$ . The simple yield  $Y_{mt}$  is related to the price as follows:

$$P_{mt}^{ZC} = \frac{1}{(1 + Y_{mt})m}. (4.2)$$

Defining the spot rate  $r_{mt}$  as  $\log(1 + Y_{mt})$ , which is the continuously compounded yield, and the discount function  $D_{mt}$  as the price at time t of a zero coupon that pays one unit at time t + m, we then have

$$P_{mt}^{ZC} = \exp(-mr_{mt}) = D_{mt}. (4.3)$$

Consider now a *coupon* bond that pays a coupon rate of *c* per cent annually and pays a face value of 1 at maturity. The price of the bond at trade date is given by the following formula:

$$P_{mt} = \sum_{k=1}^{m} cD_{kt} + D_{mt}. (4.4)$$

Given the observation of prices of coupon bonds, spot rates on zero coupon equivalent can be derived by fitting a discount function based on the following specification for the spot rates:

$$r_{kt} = \beta_0 + \beta_1 \frac{1 - \exp(-k/\tau_1)}{k/\tau_1} + \beta_2 \left( \frac{1 - \exp(-k/\tau_1)}{k/\tau_1} - \exp\left(-\frac{k}{\tau_1}\right) \right) + \beta_3 \left( \frac{1 - \exp(-k/\tau_2)}{k/\tau_2} - \exp\left(-\frac{k}{\tau_2}\right) \right).$$
(4.5)

Such specification has been originally introduced by Svensson (1994) and it is an extension of the parametrization proposed by Nelson and Siegel (1987). Implied forward rates can be calculated from spot rates. A forward rate at time t with trade date t+t' and settlement date t+T can be calculated as the return on an investment strategy based on buying zero-coupon bonds at time t maturing at time t+T and selling at time t zero-coupon bonds maturing at time t+t'. The forward rate is related to the spot rate by the following formula:

$$f_{t+T,t+t',t} = \frac{Tr_{T,t} - t'r_{t',t}}{T - t'}$$
(4.6)

so the forward rate for a one-year investment with settlement in two years and maturity in three years is equal to three times the three-year spot rate minus twice the two-year spot rate. The instantaneous forward rate is the rate on a forward contract with an infinitesimal investment after the settlement date:

$$f_{mt} = \lim_{T \to m} f_{t+T,t+m,t}. \tag{4.7}$$

In practice, we identify the instantaneous forward rate with an overnight forward rate, a forward rate with maturity one day after the settlement. The relation between instantaneous forward rate and spot rate is then

$$r_{mt} = \frac{\int_{\tau=t}^{t+m} f_{\tau t} \, \mathrm{d}\tau}{m}$$

or, equivalently,

$$f_{mt} = r_{mt} + m \frac{\partial r_{m,t}}{\partial m}. {4.8}$$

Given specification Eq. (4.5) for the spot rate, the resulting forward function is as follows:

$$f_{kt} = \beta_0 + \beta_1 \exp\left(-\frac{k}{\tau_1}\right) + \beta_2 \frac{k}{\tau_1} \exp\left(-\frac{k}{\tau_1}\right) + \beta_3 \frac{k}{\tau_2} \exp\left(-\frac{k}{\tau_2}\right). \tag{4.9}$$

Therefore, as k goes to zero the spot and the forward rate coincide at  $\beta_0 + \beta_1$ and as k goes to infinity the spot and the forward rate coincide at  $\beta_0$ . The forward rate function features a constant, an exponential term decreasing when  $\beta_1$  is positive, and two 'hump-shape' terms. The relation between the spot rate and the instantaneous forward rate at the same maturity is analogous to the relation between a marginal and an average quantity. So the curve of instantaneous forward rate lies above the curve of spot rates, when this is positively sloped, and below the curve of spot rates, when this is negatively sloped. If the pure expectational model is valid and there is no term premium, then instantaneous forward rates at future dates can be interpreted as the expected spot interest rates for those future rates. The observable equivalent of the instantaneous forward rate is the overnight rate. So the curve of instantaneous forward rates at future dates can be interpreted as indicating the expected overnight rates for those future dates. If the overnight rate is thought of as a rate controlled by monetary authorities, then the curve of instantaneous forward rates can be thought of as an indicator of expected monetary policy, based on the pure expectational model. Monetary policy 'surprises' can be generated 'ex-post' by computing the distance between observed overnight rates and expected overnight rates.

Exploiting the fact that intervention on policy rates takes place on occasion of regular meetings of the Federal Open Market Committee, we estimate the term structure of spot rates and of instantaneous forward rates the day before regular meetings, obtaining a measure of expectations for Federal Reserve interventions and an associated measure of monetary policy shocks. Our estimated curves are fitted to the following rates: the federal fund target, 1m euro, 3m euro, 6m euro, 12m euro, 3, 5, 7, and 10-year fixed interest rate swap.4 The measure of the expected overnight rate for the day after the meetings is then subtracted to the observed target rate on that day to obtain a neasure of the unexpected part of Fed interventions. The *FOMC* meets eight times a year; therefore we construct a monthly measure of shocks which features four zeros each year. Since the practice of deciding on interventions at given and known dates is only recent (from 1994 onwards), in order to conduct our exercise on a meaningful sample we supplement the result on the *FOMC* meetings from 1994 onwards with the results of the application of the proposed procedure to the dates indicated by the analysis of Skinner and Zettelmeyer for the period 1988:11*—*1993:12. We label this measure of monetary policy shock as *IFS* (instantaneous forward shocks).

Table 5 and Fig. 8 provide a first assessment of the alternative measures of monetary policy shocks described above. We note that the correlations between shocks range from 0.3 to 0.6. Regression analysis shows a maximum *R*2 of 0.2 for the regression of *BENCH* on *FFFS*, while the *R*2 of the regression of *BENCH* on *ESZ* is 0.1. The lowest *R*2 of 0.09 is obtained from the regression of *BENCH* on *IFS*. The coefficients of all regressions are clearly, but not spectacularly, significant.

On the basis of similar evidence, Rudebusch (1996) concluded that shocks derived from VAR do not make sense as measures of monetary policy shocks. We conclude that they are not strongly correlated with alternative measurements of the same quantity and investigate further the issue by analysing how sensitive the description of the monetary transmission mechanism is to alternative specifications of policy shocks. We do so by including the above measures of monetary policy shocks in the benchmark VAR as exogenous variables and by deriving the associated impulse response functions.

<sup>4</sup> In a previous version of this paper we used the overnight federal funds rate instead of the federal fund target. The original estimation produced different, and less interesting, results. Frederick Mishkin pointed out that the overnight federal fund rate might display noisy behaviour in response to liquidity shocks totally unrelated to monetary policy and suggested us to substitute it with the federal funds target.

Table 5 Comparing alternative measures of monetary policy shocks. Sample period: 1988:11–1996:3

|                    |             | BENCH | FFFS          | ESZ     | IFS     |
|--------------------|-------------|-------|---------------|---------|---------|
| Mean               |             | 0     | 0             | - 0.005 | - 0.009 |
| Standard deviation |             | 0.104 | 0.141         | 0.056   | 0.176   |
| Correlation matrix | BENCH       | 1     |               |         |         |
|                    | FFFS        | 0.475 | 1             |         |         |
|                    | ESS         | 0.327 | 0.363         | 1       |         |
|                    | IFS         | 0.294 | 0.364         | 0.581   | 1       |
|                    |             |       | f BENCH onto: |         |         |
|                    |             | FFFS  | ESZ           | IFS     |         |
|                    |             |       | LSZ           | 11 5    |         |
|                    | Coefficient | 0.326 | 0.602         | 0.174   |         |
|                    | S.E.        | 0.068 | 0.186         | 0.06    |         |
|                    | $R^2$       | 0.21  | 0.11          | 0.09    |         |
|                    | $\sigma$    | 0.093 | 0.099         | 0.100   |         |
|                    | DW          | 1.85  | 2.00          | 2.04    |         |

#### 4.2. Estimation and impulse response functions

We estimate four structural models, augmenting the benchmark specification in Eq. (4.1) with the inclusion of each of the alternative measures of policy shocks discussed above as contemporaneous exogenous variables in the VAR:

$$\begin{vmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ d_{21} & 1 & 0 & 0 & 0 & 0 \\ d_{31} & d_{32} & 1 & 0 & 0 & 0 \\ d_{41} & d_{42} & d_{43} & 1 & 0 & 0 \\ d_{51} & d_{52} & d_{53} & d_{54} & 1 & 0 \\ d_{61} & d_{62} & d_{63} & d_{64} & d_{65} & 1 \end{vmatrix} \begin{vmatrix} GDP_t \\ P_t \\ Pcm_t \\ FF_t \\ TR_t \\ NBR_t \end{vmatrix}$$

$$= C^*(L) \begin{pmatrix} GDP_{t-1} \\ P_{t-1} \\ PCm_{t-1} \\ FF_{t-1} \\ TR_{t-1} \\ NBR_{t-1} \end{pmatrix} + \begin{pmatrix} g_{GNP} \\ g_P \\ g_{Pcm} \\ g_{FF} \\ g_{TR} \\ g_{NRR} \end{pmatrix} x_t + \begin{pmatrix} v_{1r}^{NP} \\ v_{2t}^{NP} \\ v_{3t}^{NP} \\ v_t^{NP} \\ v_t^{D} \\ v_t^{S} \end{pmatrix}$$
(4.10)

![](_page_27_Figure_3.jpeg)

![](_page_27_Figure_5.jpeg)

![](_page_27_Figure_7.jpeg)

Fig. 8. Alternative measures of monetary policy shocks.

where  $x_t$  is set in turn equal to  $FFFS_t$ ,  $ESZ_t$  and  $IFS_t$ . No lags of  $x_t$  are introduced because this variable is meant to be a direct measure of monetary policy shocks. All models are estimated over the sample 1988(11)–1996(3).

Results are reported in Table 6. It can be immediately noted that all alternative estimates of the  $g_{GDP}$ ,  $g_P$ , and  $g_{Pcm}$  parameters show that the contemporaneous effect of the monetary policy shocks on the macroeconomic variables is never significant. Therefore, one of the crucial identifying assumptions in the benchmark VAR model is validated by the estimation based on alternative measures of policy shocks. The estimates of  $g_{FF}$  show a quantitatively and statistically significant positive impact for FFFS, ESZ, and IFS on the federal funds rate. This evidence weakens the conclusion by Rudebusch (1996) that VAR-based monetary policy shocks do not make sense. The estimates of  $g_{TR}$  and  $g_{NBR}$  are not significant when FFFS and ESZ are used but become significant, and correctly signed, in the model with the IFS shock. We note that the parameters  $\alpha$  and  $\beta$  are not significant also in the benchmark model, where they constitute the only channel through which monetary policy affects contemporaneously the market for reserves. It seems that the inclusion of the IFS shocks in the VAR allows a better determination of the parameters determining demand and supply behaviour in th market for reserves. All other estimated structural parameters do not show a significant difference between the benchmark model and the model based on FFFS, ESZ, and IFS shocks.

On the basis of this evidence, we proceed further by comparing the impulse responses of the benchmark VAR model with those derived by considering FFFS, ESZ and IFS as monetary policy shocks. The impulse response functions for the four models along with 95% confidence intervals computed for the benchmark VAR are reported in Fig. 9. The plots clearly show that the alternative measures of policy shocks yield descriptions of the monetary transmission mechanism which are not significantly different (in a statistical sense) from each other.

#### 4.3. Discussion

Our results deserve discussion on, at least, three issues: interpretation of the impulse responses, measurement of the policy shocks, robustness. Next, we will reconsider the relevance of Rudebusch's critique in the light of our results.

On the interpretation of the impulse responses, it could be argued that the low correlation between our alternative measures of policy shocks implies that at least some of them must contain a substantial amount of variability that it is not due to unexpected monetary actions. As a consequence, impulse response estimates could be affected by errors-in-variables bias or, in the worst case, the additional variability might reflect endogenous factors. While the errors-in-variables bias is not easily dismissed, some arguments can be made to rule out the worst-case scenario. The impulse responses from the benchmark VAR model

Table 6
The VAR with exogenous measures of monetary policy shocks

The estimated VAR models are of the following form:

$$D \begin{pmatrix} GDP_{t} \\ P_{t} \\ Pcm_{t} \\ FF_{t} \\ TR_{t} \\ NBR_{t} \end{pmatrix} = C^{*}(L) \begin{pmatrix} GDP_{t-1} \\ P_{t-1} \\ Pcm_{t-1} \\ FF_{t-1} \\ TR_{t-1} \\ NBR_{t-1} \end{pmatrix} + \begin{pmatrix} g_{GDP} \\ g_{P} \\ g_{Pcm} \\ g_{FF} \\ g_{TR} \\ g_{NBR} \end{pmatrix} x_{t} + \begin{pmatrix} v_{1P}^{NP} \\ v_{2t}^{NP} \\ v_{3t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{NP}$$

where D is a lower-triangular matrix of coefficients, x is in turn equal to FFFS, ESZ and IFS (the exogenous measures of monetary policy shocks discussed in the text) and the  $g_i$ 's denote the coefficients on the policy shocks included in the VAR as contemporaneous exogenous variables. For completeness, also the results from estimation of the benchmark (BENCH) specification are reported in the first line of the table (in this case  $x \equiv 0$ ). The sample period is 1988(11)–1996(3).

|               |                | mated coe<br>Esti   | fficients of matrix | D:                  |                |                     |                     |                     |                 |
|---------------|----------------|---------------------|---------------------|---------------------|----------------|---------------------|---------------------|---------------------|-----------------|
|               |                | d21                 | d31                 | d32                 | d41            | d42                 | d43                 | d51                 |                 |
| H<br>NC<br>BE | Coeff.<br>S.E. | 0.002<br>0.050<br>! | !1.108<br>0.473     | 1.044<br>0.233<br>! | 5.562<br>11.54 | !15.87<br>11.89     | 0.540<br>1.250<br>! | 0.056<br>0.300      |                 |
| FFFS          | Coeff.<br>S.E. | 0.004<br>0.049      | !1.134<br>0.473     | 1.044<br>0.233<br>! | 3.935<br>15.12 | 4.473<br>8.462<br>! | !1.125<br>0.882     | 0.016<br>0.318<br>! |                 |
| ESZ           | Coeff.<br>S.E. | 0.050<br>0.013      | 0.479<br>!1.191     | 0.398<br>1.053<br>! | 5.166<br>16.01 | !7.980<br>10.97     | !1.026<br>1.142     | 0.087<br>0.315      |                 |
| IFS           | Coeff.<br>S.E. | 0.002<br>0.050<br>! | !1.108<br>0.473     | 0.356<br>1.043<br>! | 5.097<br>12.13 | !10.85<br>10.96     | !1.073<br>1.153     | 0.286<br>0.068<br>! |                 |
|               |                | d52                 | d53                 | d54                 | d61            | d62                 | d63                 | d64                 | d65             |
| H<br>NC<br>BE | Coeff.<br>S.E. | 0.596<br>0.631<br>! | 0.066<br>0.068      | 0.010<br>0.006      | 0.042<br>0.140 | 0.464<br>0.296<br>! | 0.033<br>0.031<br>! | 0.003<br>0.003      | !1.028<br>0.051 |
| FFFS          | Coeff.<br>S.E. | 0.622<br>0.631<br>! | 0.074<br>0.066      | 0.006<br>0.008      | 0.033<br>0.149 | 0.467<br>0.297<br>! | 0.032<br>0.031<br>! | 0.002<br>0.004      | !1.027<br>0.051 |
| ESZ           | Coeff.<br>S.E. | 0.572<br>0.636<br>! | 0.065<br>0.066      | 0.006<br>0.011      | 0.153<br>0.142 | 0.379<br>0.288<br>! | 0.042<br>0.030<br>! | 0.006<br>0.003      | !1.024<br>0.049 |
| IFS           | Coeff.<br>S.E. | 0.711<br>0.598<br>! | 0.097<br>0.063      | 0.006<br>0.003      | 0.080<br>0.137 | 0.400<br>0.289<br>! | 0.045<br>0.031<br>! | 0.005<br>0.003      | !1.065<br>0.053 |

| Continuea |                |               |                                                          |                |                |                  |                  |  |
|-----------|----------------|---------------|----------------------------------------------------------|----------------|----------------|------------------|------------------|--|
|           |                | Estimated coe | Estimated coefficients on the exogenous policy shocks:   | ne exogenous   | policy shocks  | 12               |                  |  |
|           |                | $g_{GDP}$     | $g_P$                                                    | $g_{Pcm}$      | $g_{FF}$       | $g_{TR}$         | $g_{NBR}$        |  |
| BENCH     | Coeff.<br>S.E. | I             |                                                          | 1              | I              | I                | ı                |  |
| FFFS      | Coeff.         | 0.0002        | 0.0012                                                   | -0.0038        | 0.654          | -0.0008          | -0.010           |  |
|           | S.E.           | 0.0002        | 0.0000                                                   | 0.0095         | 0.079          | 9000'0           | 900.0            |  |
| ESZ       | Coeff.         | 0.0008        | 0.0033                                                   | -0.0089        | 0.829          | -0.0003          | -0.0008          |  |
|           | S.E.           | 0.0005        | 0.0022                                                   | 0.0217         | 0.230          | 0.0013           | 0.0014           |  |
| IFS       | Coeff.         | 0.00001       | 0.0007                                                   | -0.0074        | 0.305          | -0.0137          | -0.0110          |  |
|           | S.E.           | 0.002         | 0.0007                                                   | 0.0075         | 0.078          | 0.0042           | 0.0048           |  |
|           |                |               |                                                          |                |                |                  |                  |  |
|           |                | Estimated s   | stimated standard deviations of structural disturbances: | tions of struc | tural disturba | inces:           |                  |  |
|           |                | $\nu_1^{NP} $ | $v_2^{NP}$                                               | $v_3^{NP}$     | $v_{\rm S}$    | $V^{\mathbf{D}}$ | $v^{\mathbf{B}}$ |  |
| BENCH     | Coeff.         | 0.002         | 0.001                                                    | 0.009          | 0.100          | 0.005            | 0.002            |  |
|           | S.E.           | 0.0002        | 0.0001                                                   | 0.0007         | 0.008          | 0.0004           | 0.0002           |  |
| FFFS      | Coeff.         | 0.002         | 0.001                                                    | 0.009          | 0.070          | 0.005            | 0.002            |  |
|           | S.E.           | 0.0002        | 0.0001                                                   | 0.0007         | 9000           | 0.0004           | 0.0002           |  |
| ESZ       | Coeff.         | 0.002         | 0.001                                                    | 0.009          | 0.091          | 0.005            | 0.002            |  |
|           | S.E.           | 0.0002        | 0.0001                                                   | 0.0007         | 0.007          | 0.0004           | 0.0002           |  |
| IFS       | Coeff.         | 0.002         | 0.001                                                    | 0.009          | 0.092          | 0.005            | 0.002            |  |
|           | S.E.           | 0.0002        | 0.0001                                                   | 0.0007         | 0.007          | 0.0004           | 0.0002           |  |
|           |                |               |                                                          |                |                |                  |                  |  |

![](_page_32_Figure_2.jpeg)

Fig. 9. Impulse responses to alternative monetary policy shocks (dashed lines: 95% confidence interval bands for the benchmark VAR)

are by now rather widely accepted as a description of the monetary transmission mechanism on the ground that it is very hard to think of any other shock other than monetary capable of generating the observed responses both in the variables describing the market for reserves and in the macroeconomic variables. To support the endogeneity argument one should then be able to identify the endogenous factors that allow to estimate responses of the six variables analysed that are observationally equivalent to the response we have observed to our different measures of monetary policy shocks. The fact that we cannot find any cannot be conclusive but it is consistent with our comments on the empirical results.

On the measurement of monetary policy shocks, it could be argued that the similar pattern of the impulse responses is hard to reconcile with the low correlation between the identified shocks. In other words, some justification on how models can disagree on policy shocks and agree on their effect is called for. Sims (1996) has already provided some answers to this question. His argument is based on the observation, fully consistent with our views in Section 2.1, that VAR models are best understood in a simultaneous equation framework. Consider a simple supply and demand simultaneous equation model: identification of the structural parameters in the demand equation requires some variables which shift the supply curve while not affecting demand. There might well exist more than one such 'supply shifter', and, despite their being all valid instruments to identify demand, they might be very little correlated. In the extreme case of orthogonal instruments, the alternative use of one of the instruments will lead to the same estimates of the demand parameters independently from the omission of the other instrument and from the lack of correlation between them. We cannot argue that this is what is happening in our model; however, note that the estimate of the impulse response functions depend uniquely on the estimates of the A, B and C matrices in Eq. (2.1), and they are not significantly different from each other when alternative measurement of the monetary impulses are used. Note also that both the magnitude and the significance of the estimates of the contemporaneous relation between the VAR federal funds innovation and the alternative measurements of monetary policy improves when the estimation is conducted in a multivariate framework rather than using a static regression analysis. This is easily checked by comparing the static regression coefficients and t-ratios reported in Table 5, with the VARbased estimates of coefficients  $q_{FF}$  and the associated t-values reported in Table 6.

If the exogenous variables included in the estimated system (FFFS, ESZ and IFS) are good measures of monetary policy shocks, they capture the variability of the Fed funds rate innovations due to unexpected policy actions. The remaining variability is left in the residual of the FF equation ( $v^{\rm S}$ ). The estimated standard deviation of  $v^{\rm S}$  (reported in the last panel of Table 6) decreases from 0.10 in the benchmark model (with no exogenous measure of policy) to, foe example, 0.07 and 0.09 when FFFS and IFS are added, implying that the bulk of the FF innovation variability is not related to monetary policy shocks. What distinguishes the monetary policy shock from the remaning FF shock ( $v^{\rm S}$ ) is the impact effect on the reserves market. When policy shocks are measured by

FFFS and IFS there is a relatively strong 'liquidity effect' on the reserves market, measured by the estimated coefficients  $g_{TR}$  and  $g_{NBR}$  (-0.014 and -0.011, respectively, in the IFS case) reported in Table 6, and the  $v^{\rm S}$  disturbances have weaker impacts on TR and NBR. These effects are measured by  $-d_{54}$  and  $d_{54}d_{64}-d_{65}$  (corresponding to  $\alpha+\beta$ ) for total and nonborrowed reserves, respectively: e.g. in the IFS case they are -0.003 and -0.008. Though the relatively high standard errors do not allow these differences in the estimated coefficients to be statistically significant, the point estimates may support the view that the exogenous variables adequately capture monetary policy shocks.

Lastly, we briefly address the robustness issue. Although we have documented our choice of the sample size by the need of having a statistical model with stable parameters, it could be observed that seven and a half year of monthly data could not be a sample long enough to analyse the monetary transmission mechanism and that the evidence of instability in 1988 provided in Section 3 is not overwhelming. The analysis could then be extended to a sample beginning in 1983, to check for robustness. Unfortunately, it is difficult to extend our comparison of alternative measures prior to 1988, since the federal funds future is available only from the end of 1988 onwards and our methodology of deriving estimates of shocks from shifts in instantaneous forward rates is not applicable when the dates of monetary policy action are not taken at given and known dates. However, from the one- and two-month rate on eurodollar deposits, available since 1983, a one-month forward rate can be derived and then subtracted from the observed one-month rate, to yield a non-VAR-based measure of monetary policy shocks, labelled EUR\$.

We have implemented our check for robustness by comparing EUR\$ with federal funds future-based shocks, and then by using EUR\$ as as alternative measure of policy shocks over the sample 1983–1996. A regression of the one-month eurodollar shocks on the federal funds future shock over the period 1988–1997 delivers a point estimate of 0.86 with a t-ratio of about 10, the correlation between the two shocks being 0.54. When our VAR analysis is extended to the sample 1983–1996, we find evidence in favour of robustness of all our previous results. The static regression of the VAR-based (BENCH) shocks onto EUR\$ delivers a coefficient of 0.24 with a t-ratio of about five and this coefficient raises to 0.50 with a t-ratio of about seven when estimated within a multivariate framework. The impulse responses generated by the policy shock identified in the benchmark VAR and by EUR\$ (when included in the VAR as a contemporaneous exogenous variable) are not different from each other in a statitistical sense, with a pattern of point estimates very similar to the one

<sup>&</sup>lt;sup>5</sup> This idea was suggested to us by Stefan Gerlach. The data source is DATASTREAM.

previously found over the shorter sample. Interestingly, we now find that innovations in the macroeconomic variables are statistically significant in explaining innovations in the federal funds rate both in the benchmark VAR and when the *E*º*R*\$ is included in estimation. In particular, innovations in output and prices are significant with point estimates suggesting a higher weight on inflation in the monetary authorities' reaction function.

We are now in the position to assess our results in the light of the criticism to monetary VAR by Rudebusch (1996), who criticized standard monetary VAR models under four respects: (i) the assumption of a time-invariant, linear structure, (ii) the use of a limited information set in the policy reaction function, (iii) the use of final revised data, and (iv) the presence of long distributed lags in the policy reaction function. The alternative measures of monetary policy shocks used in the above analysis are not affected by any of Rudebusch's criticisms: no time-invariant, linear structure is required by any of our method of deriving monetary policy shocks from financial markets, the information set available coincides with the one used by financial markets, there is no problem of data revisions in financial data, and no specification of a lag structure is assumed in their derivation.

However, when we analyse the impulse response functions we use our measures of monetary policy in a VAR and at least some of the original criticism could still be valid. We believe that the discussion of stability in Section 3 has dealt with the time-invariance issue. A linear structure is imposed on the system, and therefore we cannot allow for asymmetric effects of restrictive and expansionary monetary policy. This is beyond the scope of this paper, but it is an interesting area on our agenda for future research. Revised data are used, and the effect of revisions could be important. However, Bernanke and Mihov (1996) and Sims (1996) pointed out that if policy authorities make efficient used of flawed but immediately observable measures of final data, and if the resultant measurement errors do not affect the behaviour of other variables in the economy, then no bias is introduced by assuming that monetary authorities react to final revised data. Measurement errors simply help the identification of monetary policy by adding a source of exogenous variation.6 Lastly, concerning the point that long lags in the VAR specification of the policy reaction function imply that the Fed reacts systematically to old information, Sims, 1996 again has forcefully argued that even variables that display no inertia (and this is not even necessary in the case of interest rates used as policy instruments) do not necessarily show absence of long lags in regressions on other variables.7

<sup>6</sup> A referee noted that this point is valid only when the measurement error is correlated with preliminary, but not with final, data. When the converse is true, the VAR parameters are still inconsistently estimated.

<sup>7</sup> An example is provided by consumption under the theory of pure life-cycle-rational expectations. It behaves as a random walk: only innovations in any other macro-variables should affect

On the basis of the previous discussion we believe that the evidence supports the results reported in Brunner (1996) and casts serious doubts on the statement that VAR-based monetary policy shocks do not make sense.
