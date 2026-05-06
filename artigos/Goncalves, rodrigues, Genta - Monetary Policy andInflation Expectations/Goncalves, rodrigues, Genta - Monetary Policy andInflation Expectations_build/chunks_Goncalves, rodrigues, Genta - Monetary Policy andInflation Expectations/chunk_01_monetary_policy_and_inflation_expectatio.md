# **Monetary Policy and Inflation Expectations**

**High Frequency Evidence from Brazil** 

Carlos Goncalves, Mauro Rodrigues and Fernando Genta

WP/**25/48**

*IMF Working Papers* **describe research in progress by the author(s) and are published to elicit comments and to encourage debate.**  The views expressed in IMF Working Papers are those of the author(s) and do not necessarily represent the views of the IMF, its Executive Board, or IMF management.

2025 FEB

![](_page_0_Picture_7.jpeg)

#### **IMF Working Paper**

Fiscal Affairs Department

#### **Monetary Policy and Inflation Expectations: High-Frequency Evidence from Brazil Prepared by Carlos Goncalves, Mauro Rodrigues and Fernando Genta**

Authorized for distribution by Davide Furceri February 2025

*IMF Working Papers* **describe research in progress by the author(s) and are published to elicit comments and to encourage debate.** The views expressed in IMF Working Papers are those of the author(s) and do not necessarily represent the views of the IMF, its Executive Board, or IMF management.

**ABSTRACT:** We investigate the impact of high frequency monetary policy shocks in Brazil using daily data and Rigobon' s identification via heteroskedasticity. We show that positive changes in interest rates cause inflation expectations to decline and the exchange rate to appreciate. To the best of our knowledge, this is the first paper to study how monetary policy affects inflation *expectations* in an emerging economy using high frequency identification techniques.

| JEL Classification Numbers: | E52, E31                                                            |
|-----------------------------|---------------------------------------------------------------------|
| Keywords:                   | Monetary policy; inflation expectations; Brazil                     |
| Author's E-Mail Address:    | cgoncalves@imf.org, mauror@usp.br,<br>fernandogentasantos@gmail.com |

## **WORKING PAPERS**

## **Monetary Policy and Inflation Expectations**

High-Frequency Evidence from Brazil

Prepared by Carlos Goncalves, Mauro Rodrigues and Fernando Genta<sup>1</sup>

<sup>1</sup> We thank Francesco Bianchi, Carlos Carvalho, Daniel Leigh, Rodrigo Valdez and participants in the IMF WHD seminar for helpful suggestions. All remaining errors are our own.

**IMF WORKING PAPERS** Title of WP

## **Glossary**

CB Central Bank

Copom Monetary Policy Committee (acronym in Portuguese)

FOMC Federal Open Markets Committee

HFI High-Frequency Identification

UIP Uncovered Interest Parity

**IMF WORKING PAPERS** Title of WP

## **Executive Summary**

The last decade witnessed a substantial increase in the number of studies using high frequency data to identify the effects of monetary policy shocks on the economy. The overall lesson is that the old SVAR literature was unable to accurately represent the impact of monetary policy shocks on the economy. But High Frequency Identification (HFI) has rarely been deployed to study monetary transmission in Emerging Economies, a gap we help bridge in this paper.

There are three distinctive features to our work. First, our main focus is on the impact of monetary policy on daily inflation *expectations*. In much of this literature, *daily* shocks are used to investigate *monthly* responses of prices and output. Here, the variables under scrutiny – inflation expectations, the exchange rate and a measure of sovereign risk premium – are themselves high frequency. Second, we use data from a high-debt emerging economy, while most of the literature focuses on the US. Third, changes in interest rates around monetary policy meetings are not automatically assumed as a measure of exogenous monetary policy shocks. In most papers that use HFI, changes in rates within a tight time window are automatically labeled as shocks. But "case study" measures of monetary surprises are not immune to the endogeneity problem. Our paper bears testament to that: here, the case study OLS regressions deliver different results from our IV estimations exploiting heteroskedasticity. The paper is also related to the "tight money paradox" literature kickstarted by Sargent and Wallace (1981) and Leeper (1991). In essence, the idea in those articles is that the behavior of fiscal policy is key to understand how changes in interest rates end up affecting inflation. If higher real interest rates trigger an increase in debt levels and no response from primary balances (passive fiscal policy in the words of Leeper), the public might expect the snowballing of debt to end in monetization. Paradoxically then, monetary policy can be counterproductive: higher interest rates would cause inflation expectations to go up. We do not find evidence of this "unpleasant arithmetic" in the case of Brazil. At least not on average or for the subperiods reported in the "Robustness" section.

## **Contents**

| 1 |         | Introduction                                                    |    |  |  |  |
|---|---------|-----------------------------------------------------------------|----|--|--|--|
| 2 |         | Data and empirical strategy                                     | 5  |  |  |  |
|   | 2.1     | Data                                                            | 5  |  |  |  |
|   | 2.2     | The identification strategy                                     | 6  |  |  |  |
|   | 2.3     | Test of the identification assumptions                          | 9  |  |  |  |
| 3 | Results |                                                                 | 10 |  |  |  |
|   | 3.1     | OLS: whole sample and "event study"                             | 10 |  |  |  |
|   | 3.2     | Effect of monetary surprises on inflation expectations using IV | 12 |  |  |  |
|   | 3.3     | Effect of monetary surprises on CDS and the exchange rate       | 13 |  |  |  |
|   | 3.4     | Robustness tests                                                | 13 |  |  |  |
| 4 |         | Final remarks                                                   | 15 |  |  |  |
|   |         | List of Figures                                                 |    |  |  |  |
|   |         |                                                                 |    |  |  |  |
|   | 1       | Gross Debt/GDP in Brazil and other Emerging Economies           | 4  |  |  |  |
|   | 2       | Full Sample                                                     | 11 |  |  |  |
|   | 3       | Only Copom meetings                                             | 11 |  |  |  |
|   |         | List of Tables                                                  |    |  |  |  |
|   | 1       | Variance tests using TNC > TC                                   | 10 |  |  |  |
|   | 2       | From naive OLS to case study coefficient                        | 11 |  |  |  |
|   | 3       | OLS estimates: full sample and case study                       | 11 |  |  |  |
|   | 4       | IV through heteroskedasticity estimates                         | 12 |  |  |  |
|   | 5       | Exchange rate and Risk: IV estimates                            | 13 |  |  |  |
|   | 6       | Using survey measure of<br>𝜋<br>𝑒                               | 14 |  |  |  |
|   | 7       | Excluding changes in inflation above P(95) and below P(05)      | 14 |  |  |  |
|   | 8       | Moving window IV regressions: 3m interest rates                 | 14 |  |  |  |
|   | 9       | Dropping FOMC dates                                             | 15 |  |  |  |

## <span id="page-6-0"></span>1 Introduction

The last decade witnessed a substantial increase in the number of studies using high-frequency data to identify the effects of monetary policy shocks on the economy. These include Agripino and Ricco (2021), Gertler and Karadi (2015), Bauer and Swanson (2022, 2023), Nakamura and Steinsson (2018), amongst others. The overall lesson is that the old SVAR literature, relying mostly on timing restrictions for identification, was unable to accurately represent the impact of monetary policy shocks on the economy.

But High Frequency Identification (HFI) has rarely been deployed to study monetary transmission in Emerging Economies<sup>1</sup>, a gap we aim to bridge here by focusing on a large developing economy, Brazil.

This paper has three new features. First, our main focus is on the impact of monetary policy on inflation *expectations*. The main variable of interest is the daily change in market-based (not survey data) inflation expectations. In much of this literature, *daily* monetary policy shocks are used to investigate *monthly* responses of prices and output. Here, the variables under scrutiny – inflation expectations, the exchange rate and a measure of sovereign risk premium (the so-called CDS) – are themselves high frequency in nature. Second, we use data from a high-debt emerging economy, while most of the literature focuses on the US<sup>2</sup>. Third, changes in interest rates around monetary policy meetings are not automatically assumed to be a measure of exogenous monetary policy shocks. In most papers using HFI, the change in rates within a tight time window is automatically labeled as a shock. But as Rigobon and Sack (2004) convincingly argue, "case study" measures of monetary surprises are not immune to the endogeneity problem. Our paper bears testament to that: here the case study OLS regressions deliver different results from our IV estimations exploiting heteroskedasticity.

Our work is also related to the "tight money paradox" literature kickstarted by Sargent and Wallace (1981), and to its multiple offsprings, such as Leeper (1991) and more recently Bianchi and Melosi (2019). In essence, the idea in those articles is that monetary policy does not take place in a vacuum, and amongst other factors, the behavior of fiscal policy is key to understanding how changes in interest rates end up affecting inflation. If higher real interest rates trigger an increase in debt levels and no response from primary balances (passive fiscal policy in the words of Leeper), the public might expect the snowballing of debt to end in monetization. Paradoxically then, monetary policy can be counterproductive: higher interest rates would cause inflation expectations to go up.<sup>3</sup>

<span id="page-6-2"></span><span id="page-6-1"></span><sup>&</sup>lt;sup>1</sup>A very recent exception is Checo et al (2024), which employs however a different empirical strategy. <sup>2</sup>Cesa-Bianchi et al (2020) applies HFI to analyze monetary policy in the UK.

<span id="page-6-3"></span><sup>&</sup>lt;sup>3</sup>Analyses of the so-called "tight money paradox" can be found in Loyo (1999), Bhattacharya and

Can traces of the tight monetary paradox be found in Brazil's post-2009 data? On average, this does not appear to be the case.

Historically, Brazil has faced very high inflation from the 1980s until the mid-1990s. In 1994, the country implemented a successful stabilization plan (the Real Plan), bringing inflation down through an exchange rate peg. Then in 1999, following a sequence of international crises (Asia, Russia), the government was forced to abandon the peg, replacing it with an inflation-targeting cum floating exchange rate regime. In terms of institutional progress, the formal independence of the central bank was granted only very recently, in 2019, although *de facto* independence was arguably achieved much earlier. Overall, our reading is that credibility building is an ongoing process and the fact that **long-term** inflation expectations as of January 2025 were still 50 bps above the target is a sign of imperfect credibility.

Moreover, government finances have been on shaky ground for many years: the country has one of the largest public debts among emerging economies, deficits are elevated, and real interest rates have been very high since the 1990s.<sup>4</sup> This is illustrated in Figure 1, which compares Brazil's debt-GDP ratio with that of a set of emerging countries during the last 15 years (which roughly coincides with our sample).<sup>5</sup>

<span id="page-7-0"></span>![](_page_7_Figure_3.jpeg)

Figure 1: Gross Debt/GDP in Brazil and other Emerging Economies

Kudoh (2003), Sims (2011), Uribe (2016), Andolfatto (2021), Werning (2021), amongst others.

<span id="page-7-2"></span><span id="page-7-1"></span><sup>&</sup>lt;sup>4</sup>See Ayres et al (2022) for a discussion on Brazil's recent monetary and fiscal history.

<sup>&</sup>lt;sup>5</sup>General government gross debt, percent of GDP. Data from the IMF's World Economic Outlook Database, October 2024.

Finally, simple estimates of the so-called Bohn rule<sup>6</sup> for the country suggest passive fiscal policy as the norm rather than the exception.

Given this background, one might conclude that inflation expectations cannot possibly be tamed by higher interest rates. However, our estimated coefficients indicate that a positive/negative interest rate surprise causes inflation expectations to decline/increase by a nontrivial amount<sup>7</sup>.

We also test whether monetary policy influences the exchange rate. It has been argued that by increasing the probability of default, a tighter monetary stance could cause the exchange rate to depreciate. Blanchard (2005) and Favero and Giavazzi (2005) make this argument explicitly for the case of Brazil circa 2002. Our analysis does not support this conjecture for the 2009:2024 years as a whole.<sup>8</sup> We also find no evidence of the mechanism suggested for the "inverted-UIP": monetary policy tightenings do not lead to higher risk premia in our sample (though, as we show later, this positive association is what a naive OLS regression yields).

To be clear, this paper estimates **average** effects and it might very well be possible that monetary policy was inefficient at specific moments in time within our sample. Formally testing this is challenging, though. Robustness tests using different sample periods corroborate our main finding: monetary policy works.

## <span id="page-8-0"></span>2 Data and empirical strategy

#### <span id="page-8-1"></span>2.1 Data

In the same vein as the Fed's FOMC, in Brazil the monetary policy committee (Copom is the acronym in Portuguese) meets at pre-scheduled dates. The committee is composed of the Central Bank's president and its board of directors, who discuss the state of the economy for two days, typically a Tuesday and a Wednesday, and then announce their decision on how much the policy rate should be adjusted after markets close on Wednesday. Our 1 day window then will be comprised of variations in closing prices from Wednesdays to Thursdays. The sample comprises all the weeks between September 2009 and December 2024.

Since there is no futures market for the prime rate, we measure the change in interest rates,  $\Delta i$ , using inter-bank deposit rate changes. For robustness, we look at different

<span id="page-8-2"></span><sup>&</sup>lt;sup>6</sup>Available upon request; see Bohn (1998).

<span id="page-8-4"></span><span id="page-8-3"></span><sup>&</sup>lt;sup>7</sup>All coefficients estimated using ID through heteroskedasticity are also highly statistically significant. <sup>8</sup>Though this result is reversed when the data sample is restricted to the 2003-2008 period, as shown

in Goncalves and Guimaraes (2011).

maturities: 30, 90, 180 and 360 days.9

Brazil features a private market for inflation-indexed financial instruments that allows us to tease out markets' inflation expectations at different horizons: 1 year ahead (our benchmark), but also 2, 3 and 5 years ahead.<sup>10</sup>

By subtracting from the expected return on nominal debt contracts the coupon of inflation-indexed instruments of same maturity, we arrive at a measure of expected inflation *plus a risk premium*. This is admittedly an imperfect measure of expected inflation, given it also incorporates an inflation risk premium<sup>11</sup>.

The alternative is to use Central Bank's weekly survey data, the so-called FOCUS database. The problem with this strategy, in addition to the well-known issues with surveys' data on expectations (see Coibion et al (2020), for example) is that participants update their forecasts in the Central Bank system mostly on Fridays. This means the window around the COPOM meeting becomes too large: an entire week, instead of one day. Nevertheless, when we employ this measure of inflation expectations, our results barely change.

The other two dependent variables under scrutiny are (i) the variation in the closing price of nominal exchange rate, and (ii) the Wednesday-to-Thursday change in CDS risk premium.

In the case of the exchange rate, we simply replace  $\Delta \pi_t^e$  by  $\frac{\Delta E_t}{E_{t-1}}$ : the percentage change in the BRL/USD exchange rate between Wednesdays and Thursdays. Defined this way, a positive (negative)  $\Delta E_t$  implies a depreciation (appreciation) of the Brazilian Real against the U.S. Dollar.<sup>12</sup>

## <span id="page-9-0"></span>2.2 The identification strategy

Our main goal is to estimate the effect of interest rates surprises ( $\Delta i$ ) on inflation expectations ( $\Delta \pi^e$ ). This is captured by the parameter  $\beta$  in equation (1) below. However, consistently estimating this effect is tricky. First, omitted variables might affect both interest rates and inflation expectations. Second, reverse causality may impart a positive bias on the OLS coefficient, as the Central Bank increases interest rates and bondholders

<span id="page-9-1"></span><sup>&</sup>lt;sup>9</sup>Data can be downloaded from the Sao Paulo Stock Exchange webpage (BM&FBOVESPA, 2009-2024a,b).

<span id="page-9-2"></span><sup>&</sup>lt;sup>10</sup>Daily data on government bond yields were downloaded from a Bloomberg terminal. See Bloomberg (2009-2024a,b,c) for non-inflation linked bond yields, and Bloomberg (2009-2024d,e,f) for inflation linked bond yields. Alternatively, the Brazilian Financial and Capital Markets Association (2009-2024a,b,c) provides free access to these series.

<span id="page-9-3"></span><sup>&</sup>lt;sup>11</sup>Though Central Bank of Brazil (2014) argues it is a reliable measure of average inflation expectations. In addition, if the risk-premium does not change much over time, its presence would not meaningfully affect our estimations, since these are based on 1-day *differences* 

<span id="page-9-4"></span><sup>&</sup>lt;sup>12</sup>Data were obtained at the Central Bank of Brazil webpage (SGS Banco Central do Brasil, 2009-2024).

demand higher nominal yields when they expect higher inflation.

$$\Delta \pi_t^e = \alpha + \beta \Delta i_t + u_t \tag{1}$$

$$\Delta i_t = \gamma + \delta \Delta \pi_t^e + v_t \tag{2}$$

Where  $u_t$  and  $v_t$  are error terms with variances  $\sigma_{ut}$  and  $\sigma_{vt}$ , respectively. If  $\delta \neq 0$ ,  $\beta$  cannot be consistently estimated via OLS.

Rearranging the equations:

$$\Delta \pi_t^e = (1 - \delta \beta)^{-1} (\alpha + \beta \gamma + (\delta u_t + v_t))$$
(3)

$$\Delta i_t = (1 - \delta \beta)^{-1} (\alpha \delta + \gamma + (u_t + \beta v_t)) \tag{4}$$

Using (3) and (4) it can be easily shown that if one naively estimates (1), the estimated parameter will differ from the true one as follows:

$$\widehat{\beta_{ols}} = \beta + \delta(1 - \delta\beta) \frac{\sigma_u}{\beta^2 \sigma_u + \sigma_v}$$

Hence, when  $\delta \neq 0$ ,  $\widehat{\beta_{ols}} \rightarrow \beta$  only as  $\sigma_v \rightarrow \infty$ 

To be clear, this is a potential problem for all empirical studies relying on variations in interest rates around a narrow window of time.

Therefore, to estimate the effect of interest rate surprises on inflation expectations, we follow Rigobon (2003)'s approach of identification through heteroskedasticity. As shown in Rigobon and Sack (2004), identification is achieved if two conditions are satisfied: (i) the variance of interest rate shocks ( $v_t$ ) is higher in the subsample of daily changes featuring Central Bank's monetary policy committee meetings and (ii) no such difference in variances is present for changes inflation expectations ( $u_t$ ).

That these are the identifying assumptions becomes clear from manipulating the variance-covariance matrices for two partitions of the sample: *C* for Copom dates and *NC* for the non-Copom dates. Define the variances of the shocks in equations (1) and (2) in these two subsamples as:

$$\sigma_{ut} = \begin{cases} \sigma_u^C & \text{, if } t \in C \\ \sigma_u^N & \text{, if } t \in N \end{cases}; \qquad \sigma_{vt} = \begin{cases} \sigma_v^C & \text{, if } t \in C \\ \sigma_v^N & \text{, if } t \in N \end{cases}$$

Calculating the difference in the variance-covariance matrices, one gets:

$$\Omega_{C} - \Omega_{NC} = \frac{1}{(1 - \beta \delta)^{2}} \begin{bmatrix} \sigma_{v}^{C} - \sigma_{v}^{NC} + \delta^{2}(\sigma_{u}^{C} - \sigma_{u}^{NC}) & \beta(\sigma_{v}^{C} - \sigma_{v}^{NC}) + \delta(\sigma_{u}^{C} - \sigma_{u}^{NC}) \\ & \cdot & \beta^{2}(\sigma_{v}^{C} - \sigma_{v}^{NC}) + \sigma_{u}^{C} - \sigma_{u}^{NC} \end{bmatrix}$$

Imposing the identifying assumptions:

$$\sigma_v^{\mathsf{C}} > \sigma_v^{\mathsf{N}} \tag{5}$$

$$\sigma_u^C = \sigma_u^N \tag{6}$$

One gets:

$$\Omega_C - \Omega_{NC} = \frac{\sigma_v^C - \sigma_v^{NC}}{(1 - \beta \delta)^2} \begin{bmatrix} 1 & \beta \\ \cdot & \beta^2 \end{bmatrix}$$

Thus allowing for two ways of identifying  $\beta$ :

$$\widehat{\Omega_C} - \widehat{\Omega_{NC}} = \begin{bmatrix} \omega_{11} & \omega_{12} \\ \cdot & \omega_{22} \end{bmatrix} \Rightarrow \widehat{\beta} = \frac{\omega_{12}}{\omega_{11}} \text{ or, alternatively } \widehat{\beta} = \frac{\omega_{22}}{\omega_{12}}$$

The same can be achieved in an instrumental variable setting. 13 Let:

$$\Delta I = \begin{cases} \Delta i_t / \sqrt{T_C} & , \text{ if } t \in C \\ \Delta i_t / \sqrt{T_N} & , \text{ if } t \in N \end{cases}$$

And,

$$z_t^i = \begin{cases} \Delta i_t / \sqrt{T_C} & , \text{ if } t \in C \\ -\Delta i_t / \sqrt{T_N} & , \text{ if } t \in N \end{cases}$$

where  $T_C$  is the size of the subsample in which Copom meetings occur, and  $T_N$  represents the number of observations in its complement. If the sizes of the subsamples are different, the explained variable also needs to be normalized as follows:

$$\Delta \widetilde{\pi}_{t}^{e} = \begin{cases} \Delta \pi_{t}^{e} / \sqrt{T_{C}} & , \text{ if } t \in C \\ \Delta \pi_{t}^{e} / \sqrt{T_{N}} & , \text{ if } t \in N \end{cases}$$

<span id="page-11-0"></span><sup>&</sup>lt;sup>13</sup>For further details, see Rigobon and Sack (2004).

Then the first stage, using the system of equations, takes the following form:

$$plim\frac{1}{T}(z'\Delta I) = \frac{1}{T_C}(\Delta i^C)'(\Delta i^C) - \frac{1}{T_{NC}}(\Delta i^{NC})'(\Delta i^{NC}) = (\frac{\delta + \beta}{1 - \delta \beta})^2 \cdot (\sigma_v^C - \sigma_v^{NC}) > 0 \quad (7)$$

Where the last equality comes from the identifying assumption discussed. Similarly:

$$plim\frac{1}{T}(z'\Delta\pi^{e}) = \frac{1}{T_{C}}(\Delta i^{C})'(u^{C}) - \frac{1}{T_{NC}}(\Delta i^{NC})'(u^{NC}) = (\frac{\beta}{1 - \delta\beta}).(\sigma_{u}^{C} - \sigma_{u}^{NC}) = 0$$
 (8)
