## I. The Conventional Monetary Policy Transmission Mechanism: Some Testable Implications

In this section we describe the conventional monetary transmission mechanism and propose several testable implications. We take as an example of the conventional mechanism the one present in the New-Keynesian models used widely by central banks across the globe. Within these frameworks aggregate spending depends on current and expected future short-term real interest rates. Transmission of monetary policy then works as follows: The central bank chooses the short-term nominal interest rate  $i_t$  each period, which we express in annualized terms. Due to some form of nominal price and/or wage rigidities, control over the nominal rate gives the central bank control over current and expected future real rates, at least for some horizon. It is this leverage over the time path of short term real interest rates that allows the central bank to influence aggregate spending that in turn translates into movements in output and inflation.

Given the expectations hypothesis of the term structure, a way to summarize the impact of monetary policy actions on the path of short term interest rates is to examine the response of the yield curve. A loglinear approximation of an m period zero-coupon government bond yields

(1) 
$$i_t^m = E_t \frac{1}{m} \left\{ \sum_{j=0}^{m-1} i_{t+j} \right\} + \phi_t^m,$$

where  $i_t^m$  is the annual bond yield and  $\phi_t^m$  is the annualized term premium. To a first order,  $\phi_t^m$  is a constant within a local region of the steady state. It follows that variation in long-term rates reflects variation in the path of current and expected future short rates. In this respect, the transmission of monetary policy actions to credit

<span id="page-3-0"></span><sup>&</sup>lt;sup>3</sup>Examples of the conventional New-Keynesian dynamic stochastic general equilibrium (DSGE) model include Christiano et al. (2005) and Smets and Wouters (2007). Variations that allow for financial market frictions include Bernanke et al. (1999), Gertler and Karadi (2011) and Christiano et al. (2014). Examples of models with the risk-taking channel of monetary policy are Drechsler et al. (2014) and Brunnermeier and Sannikov (2011).

costs operates via the yield curve. This link between short and long rates is present in standard New-Keynesian models and is a feature of all conventional models of monetary policy transmission. Equation (1) also makes clear how forward guidance provides the central bank with some leverage over longer maturity interest rates, to the extent it is able to effectively communicate its intentions about the path of future short rates.

Of course what matters for monetary transmission is the behavior of real interest rates. Let  $\pi_t$  be the annualized percent change in the price level between time t and t+1 and let  $\pi_t^m$  be the annualized percent change in the price level between t and t+m. Then to a first approximation the real return of the m period nominal bond, can be expressed as the following function of the expected path of short-term real rates, again with the additive term premium  $\phi_t^m$ :

(2) 
$$i_t^m - E_t \pi_t^m = E_t \frac{1}{m} \left\{ \sum_{j=0}^{m-1} (i_{t+j} - \pi_{t+j}) \right\} + \phi_t^m$$

with  $\pi_t^m = 1/m\sum_{j=0}^{m-1}\pi_{t+j}$ , and as before  $\phi_t^m$  is constant within a local region of the steady state. As we have noted, the standard theory of monetary transmission presumes that the central bank's adjustment of nominal rates leads to adjustment in real rates due to temporary nominal rigidities that inhibit offsetting movements in inflation. Of course, in the standard model the central bank's leverage over longer maturity rates depends on the degree of price stickiness.

Up to this point we have analyzed the link between monetary policy actions and government bond yields. As we noted earlier, in the standard models of the transmission mechanism financial markets are frictionless. Thus, for given maturity, the interest rate on a private security equals the corresponding government bond rate, up to a first order. The effects of monetary policy actions on the government bond yield curve translate exactly into effects on private borrowing rates. With financial market imperfections present, however, monetary transmission may involve a "credit channel" effects (e.g., Bernanke and Gertler 1995). In particular, with credit market frictions operative, the private annual borrowing rate on an m period security  $i_t^{mp}$  exceeds the rate on a similar maturity government bond, adjusting for risk. Let  $x_t^m$  denote the external finance premium, i.e., the spread between the private security and government bond rates. Then up to a first order

$$i_t^{mp} = i_t^m + x_t^m.$$

With a credit channel present, tightening of monetary policy not only raises government bond rates but also the external finance premium, which amplifies the overall effect of the policy action on private borrowing rates. The external finance premium increases because the tightening of monetary policy leads a tightening of financial constraints. Theories of the credit channel differ on the precise way central bank interest rate shifts influence credit constraints. A common prediction, however, is that the credit channel magnifies the impact of the interest rate adjustment on private borrowing rates via the impact on credit spreads.

Overall, our analysis leads to three implications of the standard theory that we can test. First, the response of the annual yield on an m period government bond to a surprise monetary policy action should equal the surprise in the average of the annualized current short rate and the expected future short rates m-1 periods into the future, with no response of the term premium. Second, the response of the yield on an m period private security should similarly equal the surprise in the expected path of the short rate over a similar horizon, though in this case with no change in either the term premium or the credit spread. Finally, a surprise monetary policy action should affect real rates as well as nominal rates across a nontrivial portion of the yield curve.

To test the first hypothesis, rearrange equation (1) to obtain the following expression for the term premium on the government bond

(4) 
$$\phi_t^m = i_t^m - E_t \frac{1}{m} \left\{ \sum_{j=0}^{m-1} i_{t+j} \right\}.$$

One can then obtain the response of the term premium to a monetary policy surprise by using the identified VAR to compute the response of the long rate  $i_t^m$  and the path of short rate  $i_t$ . Under the null of the standard theory, the response of the term premium should be zero.

To test the second hypothesis, first define the excess return on the m period bond,  $\chi_t^m$ , as the difference between the market rate  $i_t^{mp}$  and the average of current and expected annualized short rates over the life of the bond, as follows:

(5) 
$$\chi_t^m = i_t^{mp} - E_t \frac{1}{m} \left\{ \sum_{j=0}^{m-1} i_{t+j} \right\}.$$

Then combine equations (3) and (5) to obtain the following expression for  $\chi_t$ :

(6) 
$$\chi_t^m = i_t^m - E_t \frac{1}{m} \left\{ \sum_{j=0}^{m-1} i_{t+j} \right\} + x_t^m$$
$$= \phi_t^m + x_t^m.$$

Equation (6) relates the excess return on the private security to the sum of the term premium and the external finance premium. We obtain the response of  $\chi_t^m$  to a monetary policy shock by summing the impulse responses of the term premium and the external finance premium, which we measure directly using the spread between the rate on the private security and a similar maturity government bond. We measure the response of the term premium exactly as in the previous case.

Finally, we can easily compute the response of real interest rates to monetary policy shocks. We do so by first computing the impulse response of the relevant nominal interest rate and the log price level. We then make use of equation (2) to calculate the response of real interest rates. The interesting issue is how much of the response of nominal rates to monetary shocks reflects movement in real rates across different maturities.

#### II. Econometric Framework

Our econometric model is vector autoregression with a mixture of economic and financial variables. To identify monetary surprises we use external instruments. Our use of external instruments in a VAR is a variation of the methodology developed by Stock and Watson (2012) and Mertens and Ravn (2013). We describe the approach below.

Let  $\mathbf{Y}_t$  be a vector of economic and financial variables,  $\mathbf{A}$  and  $\mathbf{C}_j \ \forall \ j \geq 1$  conformable coefficient matrices, and  $\mathbf{\varepsilon}_t$  a vector of structural white noise shocks. Then the general structural form of the VAR we are considering is given by

(7) 
$$\mathbf{A}\mathbf{Y}_{t} = \sum_{j=1}^{p} \mathbf{C}_{j}\mathbf{Y}_{t-j} + \boldsymbol{\varepsilon}_{t}.$$

Multiplying each side of the equation by  $A^{-1}$  yields the reduced form representation

(8) 
$$\mathbf{Y}_{t} = \sum_{j=1}^{p} \mathbf{B}_{j} \mathbf{Y}_{t-j} + \mathbf{u}_{t},$$

where  $\mathbf{u}_t$  is the reduced form shock, given by the following function of the structural shocks:

$$\mathbf{u}_{t} = \mathbf{S} \mathbf{\varepsilon}_{t}$$

with  $\mathbf{B}_j = \mathbf{A}^{-1}\mathbf{C}_j$ ;  $\mathbf{S} = \mathbf{A}^{-1}$ . The variance-covariance matrix of the reduced form model equals  $\Sigma$ .

(10) 
$$E[\mathbf{u}_t \mathbf{u}_t'] = E[\mathbf{SS}'] = \Sigma.$$

Let  $Y_t^p \in \mathbf{Y}_t$  be the policy indicator, specifically the variable in the structural representation (7) with exogenous variation due to the associated primitive policy shock  $\varepsilon_t^p$ . We distinguish between the policy indicator and the policy instrument. The latter is the current period short term interest rate (specifically the federal funds rate). In the standard money shock VAR the policy indicator and policy instrument are one in the same, since the structural policy shock corresponds to an exogenous innovation in the current short rate. However, because we wish to include shocks to forward guidance in the measure of the policy innovation, we instead take as the policy indicator a government bond rate with a maturity somewhat longer than the current period funds rate. The advantage of the government bond rate is that its innovations incorporate not only the effects of surprises in the current funds rate but also shifts in expectations about the future path of the funds rate, i.e., shocks to forward guidance. Later in this section we describe formally our distinction between the policy indicator and the policy instrument.

Next, let **s** denote the column in matrix **S** corresponding to impact on each element of the vector of reduced form residuals  $\mathbf{u}_t$  of the structural policy shock  $\varepsilon_t^p$ .

Accordingly, to compute the impulse responses to a monetary shock, we need to estimate

(11) 
$$\mathbf{Y}_{t} = \sum_{j=1}^{p} \mathbf{B}_{j} \mathbf{Y}_{t-j} + \mathbf{s} \varepsilon_{t}^{p}.$$

Because we are not interested in computing a variance decomposition or the impulse responses to other shocks, we do not have to identify all the coefficients of S, but rather only the elements of the column s.

One can simply use least squares estimation of the reduced form VAR to obtain estimates of the coefficients in each matrix  $\mathbf{B}_j$ . Some restrictions are necessary, however, to identify the coefficients in  $\mathbf{s}$ . The standard timing restriction we described earlier amounts to assuming that all the elements of  $\mathbf{s}$  are zero except the one that corresponds to the policy indicator. This generates extra restrictions, that are sufficient to identify  $\mathbf{s}$ .

As we noted earlier, however, this kind of timing restriction is problematic when financial variables appear in the VAR along with the policy indicator. A restriction that an innovation in the policy indicator has no contemporaneous impact on other financial variables is generally implausible. In addition, it is difficult to argue that current policy does not respond to the news contained in financial variables. Accordingly, because we are interested in examining the joint response of economic and financial variables, a different approach to identifying monetary policy surprises is needed. It is for this reason that we instead make use of external instruments as an identification strategy.

We begin with a general explanation of the external instruments methodology, before turning to the precise approach we take. Following Stock and Watson (2012) and Mertens and Ravn (2013), let  $\mathbf{Z}_t$  be a vector of instrumental variables and let  $\varepsilon_t^q$  be a vector structural shock other than the policy shock. To be a valid set instruments for the policy shock,  $\mathbf{Z}_t$  must be correlated with  $\varepsilon_t^p$  but orthogonal to  $\varepsilon_t^q$ , as follows:

(12) 
$$E\left[\mathbf{Z}_{t}\varepsilon_{t}^{p'}\right] = \mathbf{\Phi}$$

$$E\left[\mathbf{Z}_{t}\varepsilon_{t}^{q'}\right] = \mathbf{0}.$$

To obtain estimates of the elements in the vector  $\mathbf{s}$  in equation (11), proceed as follows: First, obtain estimates of the vector of reduced form residuals  $\mathbf{u}_t$  from the ordinary least squares regression of the reduced form VAR. Then let  $u_t^p$  be the reduced form residual from the equation for the policy indicator and let  $\mathbf{u}_t^q$  be the reduced form residual from the equation for variables  $q \neq p$ . Also, let  $s^q \in \mathbf{s}$  be the response of  $u_t^q$  to a unit increase in the policy shock  $\varepsilon_t^p$ . Then we can obtain an estimate of the ratio  $\mathbf{s}^q/s^p$  from the two stage least squares regression of  $\mathbf{u}_t^q$  on  $u_t^p$ , using the instrument set  $\mathbf{Z}_t$ .

Intuitively, the first stage isolates the variation in the reduced form residual for the policy indicator that is due to the structural policy shock. It does so by regressing  $u_i^p$ 

on  $\mathbf{Z}_t$  to form the fitted value  $\widehat{u_t^p}$ . Given that the variation in  $\widehat{u_t^p}$  is due only to  $\varepsilon_t^p$  the second stage regression of  $\mathbf{u}_t^q$  on  $\widehat{u_t^p}$  then yields a consistent estimate of  $\mathbf{s}^q/s^p$ 

(13) 
$$\mathbf{u}_t^q = \frac{\mathbf{s}^q}{\mathbf{s}^p} \widehat{u_t^p} + \boldsymbol{\xi}_t,$$

where  $\widehat{u_t^p}$  is orthogonal to the error term  $\xi_t$ , given the assumption of equation (12) that  $\mathbf{Z}_t$  is orthogonal to all the structural shocks other than the shock to the policy indicator  $\varepsilon_t^p$ . An estimate for  $s^p$  is then derived from the estimated reduced form variance-covariance matrix using equations (10) and (13). We are then able to identify  $\mathbf{s}^q$ . Given estimates of  $s^p$ ,  $\mathbf{s}^q$  and  $\mathbf{B}_j$ , we can use equation (11) to compute responses to monetary policy surprises.

As we discussed, following the HFI literature, the set of potential external instruments we use to identify monetary policy shocks consists of surprises in fed funds and Eurodollar futures on FOMC dates. In particular, let  $f_{t+j}$  be the settlement price on the FOMC day in month t for interest rate futures (either fed funds or Eurodollars) expiring in t+j; and let  $f_{t+j,-1}$  be the corresponding settlement price for the day prior to FOMC meeting. In addition, let  $(E_t i_{t+j})^u$  be the unexpected movement in the target funds rate anticipated for month t+j, with  $(E_t i_t)^u = i_t^u$  the surprise in the current short rate. Accordingly, we can express  $(E_t i_{t+j})^u$  as the surprise in the futures rate, as follows.<sup>5</sup>

<span id="page-8-0"></span><sup>4</sup>Consider partitioning the vector of reduced form residuals as  $\mathbf{u}_t = \left[u_t^p \ \mathbf{u}_t^{q'}\right]' = \left[u_{1t} \ \mathbf{u}_{2t}'\right]'$ , and the corresponding matrix of structural coefficients as

(14) 
$$\mathbf{S} = \begin{bmatrix} \mathbf{s} & \mathbf{S}_q \end{bmatrix} = \begin{bmatrix} \mathbf{S}_1 & \mathbf{S}_{12} \\ \mathbf{S}_{21} & \mathbf{S}_{22} \end{bmatrix},$$

and the reduced form variance-covariance matrix as

(15) 
$$\Sigma = \begin{bmatrix} \Sigma_{11} & \Sigma_{12} \\ \Sigma_{21} & \Sigma_{22} \end{bmatrix}.$$

s<sup>p</sup> is identified up to a sign convention and can be obtained by the following closed form solution

$$(s^p)^2 = s_{11}^2 = \Sigma_{11} - \mathbf{s}_{12} \mathbf{s}'_{12},$$

where

(17) 
$$\mathbf{s}_{12}\mathbf{s}_{12}' = \left(\Sigma_{21} - \frac{\mathbf{s}_{21}}{s_{11}}\Sigma_{11}\right)'\mathbf{Q}^{-1}\left(\Sigma_{21} - \frac{\mathbf{s}_{21}}{s_{11}}\Sigma_{11}\right),$$

with

(18) 
$$\mathbf{Q} = \frac{\mathbf{s}_{21}}{s_{11}} \sum_{11} \frac{\mathbf{s}'_{21}}{s_{11}} - \left( \sum_{21} \frac{\mathbf{s}_{21}'}{s_{11}} + \frac{\mathbf{s}_{21}}{s_{11}} \sum_{21}' \right) + \sum_{22}.$$

The derivation is the straightforward application of the restrictions in 10 noticing that  $\left(\Sigma_{21} - \frac{\mathbf{s}_{21}}{s_{11}} \Sigma_{11}\right)' \left(\Sigma_{21} - \frac{\mathbf{s}_{21}}{s_{11}} \Sigma_{11}\right) = \mathbf{s}_{12} \mathbf{Q} \mathbf{s}_{12}'$ .

<span id="page-8-1"></span><sup>5</sup>Following Kuttner (2001) and others, we measure the surprise in the target rate using the change in the futures rate as opposed to the difference between the realized target and the futures rate forecast. The reason is to cleanse risk premia in futures from the measure of the unanticipated movement in the target. Assuming that the risk premium for the futures rate does not change in the 24 hours leading up to the FOMC decision, differencing the future rates eliminates the risk premium for the measure of the unanticipated change in the target. See also Piazzesi and Swanson (2008) and Hamilton (2009).

(19) 
$$(E_t i_{t+i})^u = f_{t+i} - f_{t+i-1}$$

For j=0, the surprise in futures rates measures the shock to the current fed funds futures, which is the case studied by Kuttner (2001).<sup>6</sup> For  $j \ge 1$ , the surprise in the expected target rate may be thought of as measuring a shock to forward guidance, following Gürkaynak, Sack, and Swanson (2005). Finally, also following GSS, to ensure that the surprises in futures rates reflect only news about the FOMC decision, we measure these shocks within a 30 minute window of the announcement.

We next discuss exactly how we use interest rate futures as external instruments to identify exogenous monetary policy shocks. Within the baseline set of VARs we consider, we take the one-year government bond rate as the relevant monetary policy indicator, rather than the federal funds rate as is common in the literature. As we suggested earlier, using a safe interest rate with a longer maturity than the funds rate allows us to consider shocks to forward guidance in the overall measure of policy shocks. Under this scenario, a component of the reduced form VAR residual for the one government bond rate is a monetary policy shock that includes exogenous surprises not only in the current funds rate but also exogenous surprises in the forward guidance about the path of future rates.

Our conceptually preferred indicator is the two-year government bond rate based on arguments by Swanson and Williams (2014) and Hanson and Stein (2012) and others who argue the Federal Reserve's forward guidance strategy operates with a roughly two-year horizon. That is, the central bank's focus is on managing expectations of the path of the short rate roughly two years into the future. Bernanke, Reinhart, and Sack (2004) and GSS provide some evidence in support of this view. They find that FOMC statements interpretable as providing forward guidance have a significant impact on futures rates that are relevant to pricing the two-year government bond rate.

We find, however, that interest rate futures surprises that have significant explanatory power for movements in the two-year government bond rate on FOMC dates, are not strong instruments for monthly (reduced form) VAR innovations. By contrast, for the one-year government bond rate, it is possible to find good instruments among the set of futures rate surprises. Accordingly, we use the one-year rate as the policy indicator in our baseline analysis, but then show all our results are robust to using the two-year rate. In the next section we describe in detail the issues involved in the choice of the policy indicator as well as the instrument set.

In the mean time, we can be precise about how the innovation in the one-year government bond incorporates policy surprises that allow for shocks to forward guidance. In particular, given the monthly frequency and our earlier notation (see equation (1)) we can approximate the return on the one-year government bond rate,  $i_t^{12}$  as a function of current and expected short rates along with a term premium  $\phi_t^{12}$ , as follows

<span id="page-9-0"></span><sup>&</sup>lt;sup>6</sup>To measure the surprise in the futures rate for the current month we need to take account of the timing of when the FOMC date occurs within the month. This is because the futures rate is expressed as an average over all the days of the month. Following Kuttner (2001) we multiply the the surprise in  $f_t$  by the factor  $\frac{T}{T-t}$ , where T is the number of days in the month and t is the number of days elapsed before the FOMC meeting.

(20) 
$$i_t^{12} = E_t \frac{1}{12} \left\{ \sum_{j=0}^{11} i_{t+j} \right\} + \phi_t^{12}$$

Given equation (20), we can argue that the reduced form VAR residual in the equation for  $i_t^{12}$  is equivalent to the month ahead forecast error as follows:

(21) 
$$i_t^{12} - E_{t-1}i_t^{12} = \frac{1}{12} \sum_{i=0}^{11} \left\{ E_t i_{t+j} - E_{t-1}i_{t+j} \right\} + \phi_t^{12} - E_{t-1}\phi_t^{12}.$$

The residual for  $i_t^{12}$  thus depends on revisions in beliefs about the path of short rates as well as unexpected movements in the current short rate and the current term premium. A monetary policy shock within our framework, accordingly, is a linear combination of exogenous shocks to the current and expected future path of future rates. This contrasts with the conventional literature which considers only shocks to the current short rate. By allowing for shocks that cause revisions in beliefs about the future path of short rates we are able to capture shocks to forward guidance.

Of course, innovations in current and expected future interest rates reflect in part news about the economy that in turn induces the central bank to adjust interest rates. The challenge is to identify the component of these innovations that is due to purely exogenous policy shifts. It is for this reason that we consider a set of surprises in fed funds and Eurodollar futures on FOMC days as external instruments. Doing so allows us to isolate the portion of the innovation in the one-year government bond rate that is due entirely to the exogenous policy surprise. Note that by using surprises for futures contracts settled in subsequent months along with the surprise for the current month, we have instruments for innovations in expected future short rates as well as for the current rate.

#### III. Data, Estimation, and Results

We analyze monthly data on a variety of economic and financial variables over the period 1979:7 to 2012:6. We choose the starting point to coincide with the beginning of Paul Volcker's tenure as Federal Reserve chair. We do not use the pre-Volcker data based on evidence of differences in the monetary policy regime pre-and post-Volcker (e.g., Clarida et al. 2000). We also explore subsample robustness.<sup>7</sup>

The data of course includes the recent crisis, a period where the short-term interest rate reached the zero lower bound. However, until 2011, our baseline policy indicator, the one-year government bond rate, remained positive, indicating some degree of central bank leverage over this instrument. Swanson and Williams (2014) make the case that the zero lower bound was not a constraint on the Federal Reserve's ability to manipulate the two-year rate. This was probably less true for the one-year rate, though the data suggest flexibility at least until the past year. We address the concern over the zero lower bound by showing our results are robust to

<span id="page-10-0"></span> $<sup>^7</sup>$ In the working paper version we show that our results are robust to reasonable sample splits, including: 1983:1-2012:6, 1983:1-2008:6, 1979:7-2008:6.

- using the two-year rate as the policy indicator; and
- not including the period of the Great Recession.

It's also true that both real and financial variables exhibited greater volatility during the crisis period. We address this issue by showing in the online Appendix that our results are robust to allowing for a simple form of stochastic volatility.

Our potential instrument set consists of futures rates surprises on FOMC dates used by GSS's event study analysis, including the surprises in the current month's fed funds futures (FF1), in the three month ahead monthly fed funds futures (FF4), and in the six month, nine month and year ahead futures on three month Eurodollar deposits (ED2, ED3, ED4). The instruments are available for us from the period 1991:1 through 2012:6, which is shorter than the sample available for the other series. Accordingly, we use the full sample 1979:7 to 2012:6 to estimate the lag coefficients and obtain the reduced form residuals in equation (8). We then use the instrumental variables and reduced form residuals for the corresponding period to identify the contemporaneous impact of monetary policy surprises (i.e., the vector **s** in equation (11).

To illustrate the issues of the choices of a policy indicator and associated instruments and of how our external instruments approach works, we start with a simple VAR. This stripped-down VAR includes two economic variables, log industrial production and the log consumer price index, the one-year government bond rate (the policy indicator), and a credit spread, specifically the Gilchrist and Zakrajšek (2012) excess bond premium. We then construct a baseline VAR that includes additional indicators of credit costs. Finally, we consider additional interest rates by adding them one at a time to the baseline.

In the next subsection we present an analysis of our policy indicator and instrument choice. We then use the simple VAR to show how our external instrument identification works, as well as how it compares with a standard Cholesky identification. In the final subsections we present our baseline VAR along with variants. We proceed to use the framework to present our main analysis of the impact of monetary policy surprises on credit costs.

### A. Policy Indicator and Instrument Choice

To evaluate our choice of a policy indicator along with instruments for policy shocks, we begin with a high frequency variant of the external instruments approach that we ultimately use in the monthly VAR. In this high frequency variant, we examine the response of various market interest rates to surprises in various policy indicators, using interest rate futures surprises on FOMC dates as instruments. As in the HFI literature, the dependent variables in this exercise are surprises in daily rates. What this exercise permits is an analysis of the implications of different policy indicators and instruments for market interest rates in a setting where all the instruments have good explanatory power. This then sets the stage for an evaluation of indicator and instrument choice for the monthly VAR.

Let  $i_t^n$  be the interest rate on an n month government bond that serves as the policy indicator, let  $\Delta R_t$  be the change in an asset return on an FOMC day, and let  $(i_t^n)^u$  be

the same day unanticipated movement in  $i_t^n$ . Accordingly, the equation we consider relates  $\Delta R_t$  to  $(i_t^n)^u$  as follows:

(22) 
$$\Delta R_t = \alpha + \beta (i_t^n)^u + \varepsilon_t.$$

We estimate equation (22) using two stage least squares with various interest rate futures as instruments. Under our identifying assumptions, the instrumental variables estimation isolates variation in  $i_t^n$  due to pure monetary policy surprises that is orthogonal to the error term  $\varepsilon_t$ , which leads to consistent estimates of  $\beta$ . Note that this formulation is slightly different from the convention in the HFI literature, which regresses the change in asset returns directly on the futures rate surprises. However, as we just noted, the exercise corresponds directly to what we do in the VAR analysis. The difference is that in the latter, the dependent variables are monthly VAR residuals.

We consider three policy indicators: the federal funds rate, one-year government bond rate and the two-year government bond rate. We also consider three different instrument rate combinations:

- the surprise in the current federal funds futures rate (FF1);
- the surprise in the three month ahead futures rate (FF4); and
- the full GSS instrument set.

Our choice of FF4 is based on the strong performance of this variable as an external instrument in the VAR analysis, as we illustrate shortly. Finally, the independent variables we consider are the five, ten, and thirty year government bond rates, 8 the five-by-five forward rate, the Moody's Baa spread and the 30-year conventional mortgage spread. 9

As we noted earlier, we measure the surprises in the futures rates within a 30 minute window of the FOMC announcement. The response of the various government bond yields, as well as the changes in the monetary policy indicators are measured in a daily window. Because the markets for the Baa and mortgage securities are less liquid than for government bonds we instead measure the response of the returns on these instruments over a subsequent two week period. We estimate the regressions over the available 1991:1–2012:6 sample and we exclude the 2008:7–2009:6 crisis period with excess financial turbulence.

Table 1 presents the results. Each row represents a particular combination of a policy indicator and instrument set. The coefficient in each column represents the impact of a 100 basis point increase in a given policy indicator (due to an exogenous monetary policy shock) on a corresponding asset return. Overall, three results stand out: First, innovations in the one and two-year government bond rates induced by policy surprises have a stronger effect on longer term interest rates and credit spreads than do similarly induced innovations in the federal funds rate. A surprise 100 basis point increase in the funds rate instrumented by FF1 has a significant effect on both

<span id="page-12-0"></span><sup>&</sup>lt;sup>8</sup> We use the daily series of constant maturity government bond yields derived by Gürkaynak et al. (2007).

<span id="page-12-1"></span><sup>&</sup>lt;sup>9</sup>The spreads are calculated over the ten-year government bond rates.

<span id="page-13-0"></span>

| Indicator and | 2 year   | 5 year              | 10 year             | 30 year             | 5 × 5 forw          | Baa+               | Mortg.+            |
|---------------|----------|---------------------|---------------------|---------------------|---------------------|--------------------|--------------------|
| instruments   | (1)      | (2)                 | (3)                 | (4)                 | (5)                 | (6)                | (7)                |
| FF, FF1       | 0.367*** | 0.233**             | 0.0980              | 0.00637             | −0.0369             | 0.139              | 0.170              |
|               | (3.467)  | (2.241)             | (1.053)             | (0.103)             | (−0.388)            | (1.475)            | (1.445)            |
| 1 YR, FF1     | 0.739*** | 0.469***            | 0.197               | 0.0128              | −0.0744             | 0.280              | 0.343              |
|               | (8.493)  | (3.094)             | (1.173)             | (0.103)             | (−0.379)            | (1.544)            | (1.416)            |
| 1 YR, FF4     | 0.880*** | 0.683***            | 0.375***            | 0.145*              | 0.0668              | 0.333**            | 0.427**            |
|               | (15.81)  | (8.201)             | (4.410)             | (1.694)             | (0.614)             | (2.176)            | (2.239)            |
| 2 YR, FF4     |          | 0.778***<br>(11.80) | 0.432***<br>(5.306) | 0.169*<br>(1.839)   | 0.0848<br>(0.702)   | 0.355**<br>(1.986) | 0.483**<br>(2.141) |
| 2 YR, GSS     |          | 0.878***<br>(18.70) | 0.575***<br>(11.84) | 0.234***<br>(4.139) | 0.271***<br>(3.601) | 0.231*<br>(1.844)  | 0.350**<br>(2.049) |

Table 1—Yield Effects of Monetary Policy Shocks (*Daily,* 1991–2012)

*Note:* Robust *z*-statistics in parentheses; QE dates and crisis period are excluded, 188 observations.

the two and five-year government bond rate: The former increases roughly 37 basis points and the latter 23. Conversely, a similar increase in the one-year government bond rate also instrumented by FF1 has roughly double the effect on the two and five year rate. Simply put, the one-year rate captures more persistent changes in interest rate policy than the funds rate does. As Kuttner (2001) observes, a nontrivial portion of the variation in the funds rate reflects changes in the timing of the rate adjustment, as opposed to a persistent adjustment in the policy rate.

Second, for a given policy indicator, instruments that reflect expectations of interest rate movements further into the future induce a stronger impact of the policy indicator on market interest rates. For example, instrumenting the one-year government bond rate with FF4 instead of FF1 increases its impact on the two-year rate from 74 to 88 basis points and on the five-year rate from 47 to 68 basis points. In addition, with FF4 as the instrument, the one-year rate also has a significant positive effect on the ten-year rate, the Baa spread and the mortgage spread. (Note that the impact on the spread variables is suggestive of a credit channel effect, as discussed in Section I.) Similarly, the two-year government bond rate with the complete set of GSS instruments exerts the strongest impact on market rates. Intuitively, funds rate surprises on contracts settled further in the future capture movements in the policy indicator associated with more persistent changes in policy.

Third, the one-year and two-year policy indicators have similar quantitative effects on market interest rates, particularly if instruments are used which reflect some degree of forward guidance (i.e., FF4 or GSS). While the two year with GSS has the largest effects, the one year with FF4 has effects of similar magnitude. Interestingly, in each case the policy indicator has a significant impact on the Baa and mortgage spreads that is nearly identical in magnitude.

Of course we are ultimately interested in the impact of the policy indicator on real interest rates. Both Hanson and Stein (2012) and Nakamura and Steinsson (2013) have shown using TIPS data that virtually all the responsiveness of nominal rates to policy surprises on FOMC dates reflects variation in real rates, with a negligible

<sup>+</sup>Two-week cumulative changes

*<sup>\*\*\*</sup>*Significant at the 1 percent level.

*<sup>\*\*</sup>*Significant at the 5 percent level.

 *<sup>\*</sup>*Significant at the 10 percent level.

|                           |                       | , ,                   | *                      |                         |                         |                          |
|---------------------------|-----------------------|-----------------------|------------------------|-------------------------|-------------------------|--------------------------|
| Indicator and instruments | TIPS<br>2 year<br>(1) | TIPS<br>5 year<br>(2) | TIPS<br>10 year<br>(3) | Bkeven<br>2 year<br>(4) | Bkeven<br>5 year<br>(5) | Bkeven<br>10 year<br>(6) |
| FF, FF1                   | 0.245<br>(1.348)      | 0.263**<br>(2.217)    | 0.149**<br>(2.287)     | 0.0427<br>(0.596)       | -0.116<br>(-1.553)      | -0.109**<br>(-2.081)     |
| 1 YR, FF1                 | 0.800***<br>(4.141)   | 0.639***<br>(7.606)   | 0.384***<br>(6.121)    | 0.282*<br>(1.913)       | -0.0932 $(-0.620)$      | -0.125 $(-1.165)$        |
| 1 YR, FF4                 | 0.804***<br>(5.171)   | 0.565***<br>(5.763)   | 0.315***<br>(4.136)    | 0.0990<br>(0.474)       | 0.00376<br>(0.0269)     | -0.0738 $(-0.815)$       |
| 2 YR, FF4                 | 0.759***<br>(5.090)   | 0.618***<br>(4.302)   | 0.344***<br>(3.592)    | 0.0935<br>(0.525)       | 0.00412<br>(0.0269)     | -0.0808 $(-0.743)$       |
| 2 YR, GSS                 | 0.754***<br>(7.749)   | 0.630***<br>(8.394)   | 0.462***<br>(9.350)    | 0.196**<br>(1.981)      | 0.189**<br>(2.165)      | 0.101*<br>(1.818)        |

Table 2—TIPS and Breakeven Inflation Effects of Monetary Policy Shocks (*Daily*, 1999–2012)

Note: Robust z-statistics in parentheses; QE dates and crisis period are excluded, 58 (2 year), 100 observations.

response of expected inflation. Table 2 reports the results from a similar exercise using our instrumental variables methodology. The dependent variables are the TIPS two-year, five-year and ten-year real rates and the corresponding breakeven inflation rates. We also consider the same mix of policy indicators and instruments from Table 1. The five- and ten-year rates are available from 1999:1, and the two-year rates from 2004:1. The results confirm that virtually all the impact of the policy surprise is on real rates, with virtually no impact on inflation. In addition, these results confirm that the main insights from Table 1 also hold in this context. The one- and two-year rates as policy indicators have a much stronger impact on market interest than does the funds rate. In addition, the one and two-year rates have a nearly identical effect on real rates and expected inflation. One small qualification is that the two-year rate with the GSS instrument set has a small but significant effect on inflation.

We now turn to the issue of policy indicator and instrument choice in the monthly VARs. While it appears possible to use the one- and two-year rates interchangeably with high frequency dependent variables, a complication emerges in the monthly VARs. In particular, the futures rate surprises on FOMC days appear to be good instruments for the monthly VAR innovation in the one-year rate, but they may be less effective as instruments for the two-year rate.

Table 3 summarizes the issues. The columns considered are the first stage regression residual of a particular policy indicator regressed on various instrument sets.<sup>11</sup>

<sup>\*\*\*</sup>Significant at the 1 percent level.

<sup>\*\*</sup>Significant at the 5 percent level.

<sup>\*</sup>Significant at the 10 percent level.

<span id="page-14-1"></span><span id="page-14-0"></span><sup>&</sup>lt;sup>10</sup>The rates are from the daily TIPS yield curve estimates of Gürkaynak, Sack, and Wright (2010).

<sup>&</sup>lt;sup>11</sup> For the monthly VAR, we need to turn the futures surprises on FOMC days into monthly average surprises. If all the FOMC meetings were on the first day of each month, our job would be easy, the surprises on those days would be our measure of monthly average surprise. But, in reality, the day of the FOMC meetings vary over the month, and we do not want to lose information by disregarding this. Furthermore, as we use monthly average rates (not end of the month rates) for our monetary policy indicators, a surprise that happens at the end of a month can be expected to have a smaller influence on the monthly average rate than a surprise coming at the beginning of the month. We can do our calculation in two steps. First, for each day of the month, we cumulate the surprises on any FOMC days during the last 31 days (e.g., on February 15, we cumulate all the FOMC day surprises since January 15), and, second, we average these monthly surprises across each day of the month. Or, equivalently, we can first create a cumulative daily surprise series by cumulating all FOMC day surprises (similarly as was done by

0.064

5.162

1 year 1 year 1 year 1 year 1 year Variables (1)(2)(3)(4)(5)0.890\*\*\* FF1 0.394 (4.044)(1.129)1.266\*\*\* 1.243\*\*\* FF4 1.151\*\*\* (4.184)(4.224)(3.608)ED2 1.440 (1.244)-4.443\*\*\* ED3 (-2.635)ED4 0.624\*\* -0.1672.674\*\* (2.039)(-0.476)(2.493)258 258 258 258 258 Observations 0.066 0.078 0.025 0.079 0.110 F-statistic 16.36 17.50 4.159 11.00 8.347 2 year 2 year 2 year 2 year 2 year Variables (6) (7) (8)(9)(10)FF1 0.533\*\* 0.174 (2.116)(0.462)FF4 0.779\*\* 1.013\*\*\* 1.379\*\*\* (2.272)(2.643)(3.361)ED2 1.134 (0.859)-4.733\*\* ED3 (-2.448)0.293 2.946\*\* ED4 -0.339(0.923)(-0.863)(2.465)Observations 258 258 258 258 258

<span id="page-15-0"></span>Table 3—Effects of High-Frequency Instruments on the First Stage Residuals of the Four Variable VAR (Monthly, 1991–2012)

*Note:* Robust *t*-statistics in parentheses.

 $R^2$ 

F-statistic

0.020

4.477

The residuals are computed from the simple VAR described earlier that includes industrial production, the consumer price index, the excess bond premium and a policy indicator. The first five columns consider the one-year rate as the policy indicator, while the last five consider the two-year rate. Both the  $R^2$  and the robust F-statistic for each regression are reported at the bottom of the corresponding column

0.029

5.160

0.005

0.851

0.033

3.760

To be confident that a weak instrument problem is not present, Stock et al. (2002) recommend a threshold value of ten for the *F*-statistic from the first-stage regression. Table 3 shows that in three of the five cases for the one-year rate, the *F*-statistic is safely above this threshold. The instrument that works best is FF4, which explains nearly 8 percent of monthly innovation in the one-year rate and has an associated

<sup>\*\*\*</sup>Significant at the 1 percent level.

<sup>\*\*</sup>Significant at the 5 percent level.

<sup>\*</sup>Significant at the 10 percent level.

Romer and Romer 2004 and Barakchian and Crowe 2013), then, second, we can take monthly averages of these series, and, third, obtain monthly average surprises as the first difference of this series.

<span id="page-15-1"></span><sup>&</sup>lt;sup>12</sup>The results are robust to using the richer VARs described in the next section.

*F-*statistic of the seventeen and a half. For the two-year rate, none of the instrument combinations meets the threshold. This is somewhat surprising, given the strong explanatory of the GSS instrument set, and ED4 in particular, for the variation in the two-year rate in the high frequency data. One possibility is that as compared to the one-year rate and FF4, there is greater high frequency variation in the two-year rate and ED4 in daily data. Conversely, movements in the one-year rate and FF4 are relatively persistent by comparison.

The evidence in Tables 1, 2, and 3 leads us to choose the one-year rate as the policy indicator and the three month ahead funds rate surprise (FF4) as the policy indicator for our baseline case. This permits us to establish a set of results for our external instrument approach in a setting where there is unlikely to be a weak instruments problem. We then show that our results are robust to variations that allow for the two-year rate as the policy indicator. We also explore variations in the instrument set that capture different degrees of forward guidance.
