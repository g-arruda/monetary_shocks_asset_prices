# <span id="page-34-0"></span>5.3. Sample Composition: Exchange Rate Regimes, Reclassified Countries, Capital Controls, and CIP

We close the robustness analysis by addressing four related concerns about the composition of our sample and the interpretation of interest rate differentials.

Exchange rate regimes. Our sample keeps only floating exchange rate regimes based on the coarse classification of Ilzetzki, Reinhart and Rogoff (2017), so pegs and managed pegs are excluded by construction, including those in place early in the sample. Countries therefore enter and exit the sample as their regime changes; Appendix Table B7 reports the exact in-sample periods for each currency. This addresses the concern that early-sample pegs could

Table 12. Inflation Differential

<span id="page-35-0"></span>

|                                              | Emergi      | Emerging Markets |          |  |  |
|----------------------------------------------|-------------|------------------|----------|--|--|
|                                              | (1)         | (2)              | (3)      |  |  |
|                                              | UIP Premium | IR Diff.         | ER Adj.  |  |  |
| $\overline{\text{Inflows/GDP}_{ct-1}}$       | -0.001      | -0.002*          | -0.001   |  |  |
|                                              | (0.001)     | (0.001)          | (0.001)  |  |  |
| $\log(VIX_{t-1})$                            | 0.048***    | 0.028***         | -0.020** |  |  |
|                                              | (0.008)     | (0.008)          | (0.007)  |  |  |
| Convenience Yield/Liquidity premium $_{t-1}$ | -0.126      | -0.352           | -0.226   |  |  |
| t-1                                          | (0.987)     | (1.025)          |          |  |  |
| $PRP_{ct-1}$                                 | 0.009***    | 0.005**          | -0.004   |  |  |
| - 60 1                                       | (0.003)     | (0.002)          | (0.003)  |  |  |
| Inflation Differential $_{ct-1}$             | 1.840***    | 2.517            | 0.677    |  |  |
|                                              | (0.457)     | (1.592)          | (1.215)  |  |  |
| Observations                                 | 3203        | 3203             | 3203     |  |  |
| Adjusted $R^2$                               | 0.4015      | 0.5239           | 0.2620   |  |  |
| Number of Countries                          | 20          | 20               | 20       |  |  |
| Country (currency) FE                        | Yes         | Yes              | Yes      |  |  |

**Notes:** \* p < 0.10 \*\* p < 0.05 \*\*\* p < 0.01. Currency-time two-way clustered standard errors in parentheses. Inflation differentials are the difference between CPI in the home economy and the U.S.

contaminate the estimated relationship between interest rate differentials and expected depreciation: currency-month observations under pegged or heavily managed regimes—where the exchange rate cannot covary with the interest rate by construction—never enter our regressions.

Countries reclassified from emerging to advanced. Three countries in our sample—the Czech Republic, Korea, and the Slovak Republic—were reclassified as advanced economies by the IMF during our sample period. To avoid a composition effect whereby the country groups change over time, we hold the classification fixed using the IMF-WEO 2000 income classification, so Korea remains in the emerging market group throughout. Others drop after 2009 as they become de-jure and de-facto fixed exchange rates vis-a-vis Euro.

Capital controls. Interest rate differentials could reflect not only currency risk but also actual or feared capital controls. Three features of our analysis address this. First, our news-based policy risk premium explicitly includes "capital controls" among its search terms, and our ICRG-based government policy risk measure includes contract viability/expropriation and profits repatriation risk, so the regressions in Tables 5 and 10 already condition on measured capital control risk as part of local policy risk—this is part of our interpretation, not a confound. Second, the countries and periods with the most severe controls are typically also those with pegged regimes, which are excluded from the sample. Third, the shadow price

of impediments to arbitrage, including capital controls, is the CIP deviation, to which we turn next.

*CIP deviations and the post-2008 period.* A natural question is how survey-based UIP results should be read after the 2008 breakdown of covered interest parity even among advanced economies [\(Du, Tepper and Verdelhan,](#page-42-13) [2018\)](#page-42-13). Two points are relevant. First, our UIP premium is constructed from survey expectations and deposit/money market rates, not from forward rates; it is therefore not mechanically contaminated by CIP deviations, which reflect intermediation frictions and balance sheet costs rather than currency risk. Second, Appendix [A](#page-55-0) compares UIP and CIP deviations in our sample, over time and in the cross section (Figures [A2–](#page-56-0)[A5\)](#page-57-0): for emerging markets, the UIP premium is an order of magnitude larger than the CIP deviation throughout, and for advanced economies the post-2008 CIP deviations, while nonzero and persistent, remain small relative to the emerging market UIP premium. The comparison is robust to constructing CIP with deposit or interbank rates, and our CIP measure lines up with the [Du, Pflueger and Schreger](#page-42-14) [\(2020\)](#page-42-14) cross-currency basis on the common sample (Figure [A4\)](#page-57-1). Hence the compositional asymmetry we document is not an artifact of the post-2008 dollar intermediation regime; if anything, subtracting each currency's CIP deviation from its UIP premium leaves our facts intact, as the localrisk-driven component operates through deposit and money market rates that are largely insulated from the forward market frictions behind the CIP breakdown.

### <span id="page-36-0"></span>**5.4. Forecast Errors and Predictability**

A large literature tries to understand how much of the original Fama findings can be attributed to currency risk premium. Any wedge between the interest differential and the realized exchange rate change (realized UIP premium) is either a risk premium (something investors expected to earn, an ex-ante term) or a forecast error (something they got wrong, an ex-post term). [Froot and Frankel](#page-42-4) [\(1989\)](#page-42-4) designed a test to separate the risk premium term from expectational errors.

The test is simple and straightforward: If interest rate differentials predict forecast errors, then the wedge (realized UIP deviation) is about expectational errors. If, however, the interest rate differentials do not predict forecast errors, but there is still a wedge, then the deviation must be risk premium. Thus we run:

$$\Delta s_{ct+h} - \Delta s_{ct+h}^e = \gamma (i_{ct} - i_t^{US}) + \mu_c + \varepsilon_{ct+h}, \tag{15}$$

As shown in column (1) of Table [13,](#page-37-0) this regression delivers a negative significant coefficient of -1.6 with standard error (0.55) for advanced countries, fully consistent with the prior literature. However, in column (2), for emerging market currencies, the coefficient is insignificant: -0.106 (0.144). Thus, in columns (3) and (4), we have run conditional forecast error regressions for emerging markets, that reinforces our interpretation that interest rate differentials have no other information than what is captured by the expectations to predict forecast errors. Dropping expectations and controlling realized exchange rate change leads interest rate differentials to pick up the effect of expectations.

**Table 13.** Forecast errors regressions

<span id="page-37-0"></span>

|                                | Advanced Economies |         | Emerging Markets |           |
|--------------------------------|--------------------|---------|------------------|-----------|
|                                | (1)                | (2)     | (3)              | (4)       |
| Log Interest Differential      | -1.619∗∗           | -0.106  | 0.134            | -0.459∗∗∗ |
|                                | (0.549)            | (0.144) | (0.141)          | (0.077)   |
| Expected Exchange Rate changes |                    |         | -0.500∗∗∗        |           |
|                                |                    |         | (0.155)          |           |
| Realized Exchange Rate changes |                    |         |                  | 0.943∗∗∗  |
|                                |                    |         |                  | (0.019)   |
| Observations                   | 2285               | 3577    | 3577             | 3577      |
| R2<br>Adjusted                 | 0.0873             | 0.0482  | 0.0750           | 0.8948    |
| Number of Countries            | 12                 | 22      | 22               | 22        |
| Country (currency) FE          | Yes                | Yes     | Yes              | Yes       |
| Time FE                        | No                 | No      | No               | No        |

To do [Froot and Frankel](#page-42-4) [\(1989\)](#page-42-4) exact decomposition, note that the probability limit of the coefficient *β F* in equation [\(8\)](#page-19-2) is

$$plim \,\hat{\beta}^F = \frac{cov(\Delta s_{ct+h} - \Delta \overline{s}_c, IR_{ct} - \overline{IR}_c)}{var(IR_{ct} - \overline{IR}_c)}, \tag{16}$$

where *IRct* = *ict* − *i US <sup>t</sup>* denotes the interest rate differential, and the overline denotes the average of the variable for each currency across months, which corresponds to the currency fixed effects. Forecast error comes from regression above as;

$$\eta_{ct+h}^e = \Delta s_{ct+h} - \Delta s_{ct+h}^e, \tag{17}$$

and rewrite *plim β*ˆ*<sup>F</sup>* as:

$$plim\,\hat{\beta}^F = 1 - b_{RE} - b_{RP} \tag{18}$$

<span id="page-38-0"></span>**Table 14.** Decomposition of Fama Coefficient into Risk Premium and Expectational Error Components

|                                                                                      | Advanced Economies    | Emerging Markets                      |
|--------------------------------------------------------------------------------------|-----------------------|---------------------------------------|
|                                                                                      | (1)                   | (2)                                   |
|                                                                                      | Panel A:Decomposition | n of Bias Fama Coefficient            |
| (i) $\beta_{RE}$                                                                     | 1.62                  | .106                                  |
| (ii) $\beta_{RP}$                                                                    | 2202                  | .5198                                 |
| implied $\beta^F$ from (i) and (ii)                                                  | 3998                  | .3742                                 |
|                                                                                      | Panel B: Compon       | ents of $\beta_{RE}$ and $\beta_{RP}$ |
| $cov(\eta_{ct+h}^e - \bar{\eta}_c, IR_{ct} - \bar{IR}_c)$                            | 04046                 | 03421                                 |
| $\operatorname{var}(IR_{ct} - \bar{IR}_c)$                                           | .02498                | .3228                                 |
| $\operatorname{var}(\lambda_{ct+h}^e - \bar{\lambda}_c^e)$                           | .1798                 | .2836                                 |
| $cov(\Delta s_{ct+h}^e - \Delta \bar{s}_c^e, \lambda_{ct+h}^e - \bar{\lambda}_c^e))$ | 1853                  | 1158                                  |

$$b_{RE} = -\frac{cov(\eta_{ct+h}^e - \overline{\eta}_c^e, IR_{ct} - \overline{IR}_c)}{var(IR_{ct} - \overline{IR}_c)} \quad \text{and}$$

$$b_{RP} = \frac{var(\lambda_{ct+h}^e - \overline{\lambda}_c^e) + cov(\Delta s_{ct+h}^e - \Delta \overline{s}_c^e, \lambda_{ct+h}^e - \overline{\lambda}_c^e)}{var(IR_{ct} - \overline{IR}_c)}.$$

$$(19)$$

The first term  $b_{RE}$  represents the covariance between the forecast errors and the interest rate differential. The Fama coefficient would be biased downward if higher interest rate differentials led agents to expect a larger exchange rate change than the change observed ex-post in the data—that is, whenever  $b_{RE} > 0$ . The second term  $b_{RP}$  represents a risk premium, determined by the volatility of the expected excess return and its covariance with the expected exchange rate change. The Fama coefficient would be biased downward  $(b_{RP} > 0)$  if there is a time-varying expected excess return and the volatility of the excess return is higher than the comovement between the expected excess return and the expected exchange rate change.

Table 14 shows the results. Column 1 reports results for advanced economies and column 2 for emerging markets. For advanced economies, the  $b_{RE}$  term is more than an order of magnitude larger than the  $b_{RP}$  term. For emerging markets, in contrast, the  $b_{RP}$  term is substantially larger than the  $b_{RE}$  term.

### <span id="page-39-0"></span>**6. Conclusion**

In this paper, we construct a forward-looking measure of the currency risk premium—the UIP premium—from survey-based expectations of exchange rate changes, and use it to characterize how currency risk is priced across emerging markets and advanced economies. Our organizing finding is a compositional asymmetry: the currency risk premium is primarily an *expectations* phenomenon associated with global risk in advanced economies, but an *interestrate-differential* phenomenon associated with local policy risk in emerging markets.

We document this asymmetry through five facts, which convey three main messages. First, emerging market currencies carry a substantially higher and more volatile forwardlooking risk premium than advanced economy currencies—a 3.3 percentage point difference that persists even after accounting for default risk. This persistent gap is consistent with investors pricing in expected future depreciation of emerging market currencies.

Second, this premium is associated with local rather than global risk in emerging markets, and it operates through a different component of the premium than in advanced economies. Local risk factors—particularly news-based measures of policy uncertainty—account for 26 percent of the variation in the emerging market UIP premium, while global indicators such as the VIX account for only 12 percent; the relationship is reversed in advanced economies. Moreover, in emerging markets the premium co-moves with the interest rate differential, whereas in advanced economies it co-moves with expected exchange rate changes. Our eventstudy decompositions of Argentina's pension fund nationalization (2008) and the Brexit referendum (2016) illustrate this contrast: an increase in policy uncertainty accompanies a higher premium that operates through the interest rate differential in the emerging market and through expectations in the advanced economy.

Third, local and global risk factors are associated with the dispersion in exchange rate expectations among market participants, which in turn predicts the interest rate differentials that compensate investors for currency risk. This expectations channel is economically meaningful in emerging markets—policy shocks are followed by persistent expected depreciation over a 12-month horizon—yet largely absent in advanced economies.

Read through the lens of macro-finance models with segmented asset markets, these facts describe a two-way relationship between policy risk and currency pricing. Higher interest rate differentials in emerging markets accompany local policy uncertainty, with investors expecting currency depreciation as compensation for the risk of holding these currencies; conversely, as local risk abates, interest differentials narrow and expected depreciation moderates. This endogeneity—where both higher interest rates and expected depreciation reflect policy-related risk—distinguishes emerging market currency pricing from that of advanced economies and is consistent with the persistence of carry-trade profits specifically in emerging markets, even if carry trades ultimately unwind in both sets of countries.

Our objective has been measurement and the documentation of robust regularities for UIP premia rather than the identification of a single causal channel. The value of the five facts is that they provide empirical moments that any model of currency risk premia should confront: the level and volatility gap between the two groups, the local-versus-global composition of the premium, the component—interest rate differential versus expectations through which each group's premium operates, and the expectations channel through which local risk is associated with interest rate differentials. These regularities suggest that understanding emerging market currency dynamics requires careful attention to the domestic policy environment and its effect on investor risk perceptions. Future research might examine how policy coordination shapes the risk premium, or how foreign investors' exposure to specific emerging markets transmits to capital flows through the expectations channel we document.

### <span id="page-40-0"></span>**7. Acknowledgements**

We are especially grateful to our discussants, Kenza Benhima and Menzie Chinn, and to the board of the NBER International Seminar on Macroeconomics for detailed comments that shaped this revision. We thank Pat Kehoe, Oleg Itskhoki, Dmitry Mukhin, Vania Stavrakeva, and Adrien Verdelhan for lengthy conversations and extensive comments. We thank Manuel Amador, Mark Aguiar, Pablo Becker, Javier Bianchi, Menzie Chinn, Wenxin Du, Pierre de Leo, Charles Engel, Jeffrey Frankel, Tarek Hassan, Hanno Lustig, Arvind Krishnamurthy, Ian Martin, Emi Nakamura, Jesse Schreger, Ken Rogoff, Alessandro Rebucci, Hélène Rey, Jenny Tang, and other seminar and conference participants for helpful comments.

### **References**

- <span id="page-41-10"></span>**Alvarez, Fernando, Andrew Atkeson, and Patrick J. Kehoe.** 2009. "Time-Varying Risk, Interest Rates, and Exchange Rates in General Equilibrium." *The Review of Economic Studies*, 76(3): 851–878.
- <span id="page-41-15"></span><span id="page-41-8"></span>**Ashworth, Louis.** 2022. "Quantifying Britain's moron risk premium." *Financial Times*.
- **Avdjiev, Stefan, Bryan Hardy, Şebnem Kalemli-Özcan, and Luis Servén.** 2022. "Gross Capital Flows by Banks, Corporates and Sovereigns." *Journal of the European Economic Association*, 20(5): 2098–2135.
- <span id="page-41-12"></span>**Azzimonti, Marina, and Nirvana Mitra.** 2023. "Political Constraints and Sovereign Default." *Journal of International Money and Finance*, 137: 102895.
- <span id="page-41-2"></span>**Bacchetta, Philippe, and Eric Van Wincoop.** 2006. "Can Information Heterogeneity Explain the Exchange Rate Determination Puzzle?" *American Economic Review*, 96(3): 552–576.
- <span id="page-41-0"></span>**Backus, David K, Silverio Foresi, and Chris I Telmer.** 1995. "Interpreting the forward premium anomaly." *Canadian Journal of Economics*, S108–S119.
- <span id="page-41-6"></span>**Baker, Scott R, Nicholas Bloom, and Steven J Davis.** 2016. "Measuring Economic Policy Uncertainty." *The Quarterly Journal of Economics*, 131(4): 1593–1636.
- <span id="page-41-5"></span>**Bansal, Ravi, and Magnus Dahlquist.** 2000. "The forward premium puzzle: different tales from developed and emerging economies." *Journal of International Economics*, 51(1): 115 – 144.
- <span id="page-41-7"></span>**Barrett, Philip, Maximiliano Appendino, Kate Nguyen, and Jorge de Leon Miranda.** 2022. "Measuring social unrest using media reports." *Journal of Development Economics*, 158: 102924.
- <span id="page-41-11"></span>**Bianchi, Javier, Saki Bigio, and Charles Engel.** 2021. "Scrambling for dollars: International liquidity, banks and exchange rates." National Bureau of Economic Research.
- <span id="page-41-9"></span>**Bryant, Ralph C.** 1995. *The "exchange Risk Premium," Uncovered Unterest Parity, and the Treatment of Exchange Rates in Multicountry Macroeconomic Models.* Brookings Institution.
- <span id="page-41-3"></span>**Burnside, Craig, Martin Eichenbaum, and Sergio Rebelo.** 2007. "The Returns to Currency Speculation in Emerging Markets." *American Economic Review*, 97(2): 333–338.
- <span id="page-41-13"></span>**Bussiere, Matthieu, Menzie Chinn, Laurent Ferrara, and Jonas Heipertz.** 2022. "The new Fama puzzle." *IMF Economic Review*, 70(3): 451–486.
- <span id="page-41-4"></span>**Candian, Giacomo, and Pierre De Leo.** 2023. "Imperfect Exchange Rate Expectations." *The Review of Economics and Statistics*.
- <span id="page-41-1"></span>**Chinn, Menzie, and Jeffrey Frankel.** 1994. "Patterns in Exchange Rate Forecasts for Twenty-Five Currencies." *Journal of Money, Credit and Banking*, 26(4): 759–770.
- <span id="page-41-14"></span>**Chinn, Menzie, and Jeffrey Frankel.** 2020. "A Third of a Century of Currency Expectations Data: The Carry Trade and the Risk Premium." University of Wisconsin and Harvard Kennedy School, mimeo.

- <span id="page-42-11"></span>**Cieslak, Anna, Stephen Hansen, Michael McMahon, and Song Xiao.** 2023. "Policymakers' Uncertainty." National Bureau of Economic Research.
- <span id="page-42-6"></span>**di Giovanni, Julian, Şebnem Kalemli-Özcan, Mehmet Fatih Ulu, and Yusuf Soner Baskaya.** 2022. "International Spillovers and Local Credit Cycles." *The Review of Economic Studies*, 89(2): 733–773.
- <span id="page-42-13"></span>**Du, Wenxin, Alexander Tepper, and Adrien Verdelhan.** 2018. "Deviations from Covered Interest Rate Parity." *The Journal of Finance*, 73(3): 915–957.
- <span id="page-42-14"></span>**Du, Wenxin, Carolin E. Pflueger, and Jesse Schreger.** 2020. "Sovereign Debt Portfolios, Bond Risks, and the Credibility of Monetary Policy." *The Journal of Finance*, 75(6): 3097–3138.
- <span id="page-42-10"></span>**Engel, Charles.** 2014. "Exchange Rates and Interest Parity." In *Handbook of International Economics*. Vol. 4, Chapter Chapter 8, 453–522. Elsevier.
- <span id="page-42-12"></span>**Engel, Charles, Katya Kazakova, Mengqi Wang, and Nan Xiang.** 2022. "A reconsideration of the failure of uncovered interest parity for the US dollar." *Journal of International Economics*, 136: 103602.
- <span id="page-42-1"></span>**Fama, Eugene F.** 1984. "Forward and spot exchange rates." *Journal of Monetary Economics*, 14(3): 319 – 338.
- <span id="page-42-3"></span>**Frankel, Jeffrey A., and Kenneth A. Froot.** 1987. "Using Survey Data to Test Standard Propositions Regarding Exchange Rate Expectations." *The American Economic Review*, 77(1): 133– 153.
- <span id="page-42-5"></span>**Frankel, Jeffrey, and Jumana Poonawala.** 2010. "The forward market in emerging currencies: Less biased than in major currencies." *Journal of International Money and Finance*, 29(3): 585– 598.
- <span id="page-42-9"></span>**Friedman, Benjamin M, and Kenneth N Kuttner.** 1992. "Time-varying risk perceptions and the pricing of risky assets." *Oxford Economic Papers*, 44(4): 566–598.
- <span id="page-42-4"></span>**Froot, Kenneth A., and Jeffrey Frankel.** 1989. "Forward Discount Bias: Is it an Exchange Risk Premium?" *The Quarterly Journal of Economics*, 104(1): 139–161.
- <span id="page-42-7"></span>**Giles, Chris, and George Parker.** 2022. "UK Public Finances Shift from 'Moron Premium' to 'Dullness Dividend'." *Financial Times*.
- <span id="page-42-8"></span>**Gilmore, Stephen, and Fumio Hayashi.** 2011. "Emerging Market Currency Excess Returns." *American Economic Journal: Macroeconomics*, 3(4): 85–111.
- <span id="page-42-0"></span>**Hansen, Lars Peter, and Robert J. Hodrick.** 1980. "Forward Exchange Rates as Optimal Predictors of Future Spot Rates: An Econometric Analysis." *Journal of Political Economy*, 88(5): 829–853.
- <span id="page-42-2"></span>**Hassan, Tarek, and Rui C Mano.** 2019. "Forward and Spot Exchange Rates in a Multi-currency World." *The Quarterly Journal of Economics*, 134(1): 397–450.

- <span id="page-43-13"></span>**Ilzetzki, Ethan, Carmen M. Reinhart, and Kenneth S. Rogoff.** 2017. "The Country Chronologies to Exchange Rate Arrangements into the 21st Century: Will the Anchor Currency Hold?" National Bureau of Economic Research, Inc NBER Working Papers 23135.
- <span id="page-43-11"></span>**Isard, Peter.** 1983. "An Accounting Framework and Some Issues for Modeling How Exchange Rates Respond to the News." *Exchange Rates and International Macroeconomics*, 19–66. University of Chicago Press.
- <span id="page-43-4"></span>**Ito, Takatoshi.** 1990. "Foreign Exchange Rate Expectations: Micro Survey Data." *American Economic Review*, 80(3): 434–49.
- <span id="page-43-12"></span>**Itskhoki, Oleg, and Dmitry Mukhin.** 2024. "Mussa Puzzle Redux." *Econometrica*. forthcoming.
- <span id="page-43-15"></span>**Jiang, Zhengyang, Arvind Krishnamurthy, and Hanno Lustig.** 2021. "Foreign Safe Asset Demand and the Dollar Exchange Rate." *The Journal of Finance*, 76(3): 1049–1089.
- <span id="page-43-1"></span>**Lustig, Hanno, and Adrien Verdelhan.** 2007. "The Cross Section of Foreign Currency Risk Premia and Consumption Growth Risk." *American Economic Review*, 97(1): 89–117.
- <span id="page-43-2"></span>**Lustig, Hanno, Nikolai Roussanov, and Adrien Verdelhan.** 2011. "Common Risk Factors in Currency Markets." *The Review of Financial Studies*, 24(11): 3731–3777.
- <span id="page-43-10"></span>**Miranda-Agrippino, Silvia, and Hélène Rey.** 2020. "U.S. Monetary Policy and the Global Financial Cycle." *The Review of Economic Studies*.
- <span id="page-43-17"></span>**Morelli, Juan M., Pablo Ottonello, and Diego J. Perez.** 2022. "Global Banks and Systemic Debt Crises." *Econometrica*, 90(2): 749–798.
- <span id="page-43-16"></span>**Obstfeld, Maurice, and Haonan Zhou.** 2022. "The global dollar cycle." *Brookings Papers on Economic Activity*, 2022(2): 361–447.
- <span id="page-43-9"></span>**Pflueger, Carolin, Emil Siriwardane, and Adi Sunderam.** 2020. "Financial market risk perceptions and the macroeconomy." *The Quarterly Journal of Economics*, 135(3): 1443–1491.
- <span id="page-43-14"></span>**Reinhart, Carmen, Ken Rogoff, Christoph Trebesch, and Vincent Reinhart.** 2021. "Global Crises Data by Country." *[https: // www. hbs. edu/](https://www.hbs.edu/behavioral-finance-and-financial-stability/data/Pages/global.aspx) [behavioral-finance-and-financial-stability/ data/ Pages/ global. aspx](https://www.hbs.edu/behavioral-finance-and-financial-stability/data/Pages/global.aspx)* .
- <span id="page-43-6"></span>**Salomao, Juliana, and Liliana Varela.** 2022. "Exchange Rate Exposure and Firm Dynamics." *The Review of Economic Studies*, 89(1): 481–514.
- <span id="page-43-3"></span>**Stavrakeva, Vania, and Jenny Tang.** 2024. "A Fundamental Connection: Exchange Rates and Macroeconomic Expectations." *The Review of Economics and Statistics*. forthcoming.
- <span id="page-43-8"></span>**The Economist.** 2022. "For bond investors, every country is an emerging market now." *The Economist*.
- <span id="page-43-0"></span>**Tryon, Ralph.** 1979. "Testing for rational expectations in foreign exchange markets." Board of Governors of the Federal Reserve System International Finance Discussion Papers 139.
- <span id="page-43-7"></span>**Webber, Jude.** 2008. "Argentina moves to nationalise pension funds." *Financial Times*.
- <span id="page-43-5"></span>**Zigraiova, Diana, Tomas Havranek, Zuzana Irsova, and Jiri Novak.** 2021. "How Puzzling Is the Forward Premium Puzzle? A Meta-Analysis." *European Economic Review*, 134: 103714.

### **ONLINE DATA APPENDIX**

### **Source of Data and Construction of Individual Series**

Table [1](#page-45-0) lists the variables we employ in this paper. We obtain the spot exchange rate from IMF International Financial Statistics (IFS). IFS provides both period-end and periodaverage daily exchange rates at monthly, quarterly, and yearly frequency.

We collect market interest rates (bond, treasury bill, money market, and deposit rate) from the Bloomberg terminal. We choose the interbank offered rate as the money market rate. For a given country and interest rate, there are various tickers in Bloomberg. We choose the most reliable and longest-spanning ticker after checking whether interest rates are reported as annual percentage rates with the same maturity and denominated in local currency. Interest rates are available with maturities of 1, 3, and 12 months in the dataset. As Bloomberg provides daily values for most series, we can obtain both period-end and periodaverage values at monthly, quarterly, and yearly frequency. When interest rates are missing from Bloomberg, we obtain data from IMF IFS. Although IFS usually provides interest rates with mixed maturities, some series have fixed maturity. We refer to the country notes of the IFS database to check whether the interest rate is of the same maturity, denominated in local currency, and calculated as period-end or average of daily values. If the series meets all these criteria, we add it to our database. For some interest rate series, only period-end or period-average data is available. Aggregate variables including GDP are downloaded from IMF IFS.

Exchange rate forecasts are available only at period-end. We use the Consensus forecast (mean average) at 1 month, 3 months, 12 months, and 24 months from the survey date. More precisely, the survey form, which is usually received on the Survey Date (often the second Monday of the survey month), requests forecasts at the end of the month at the 1, 3, 12, and 24 month horizons. Thus, the forecast periods may be slightly longer than these monthly horizons.

Forward rates come from Bloomberg. After downloading forward rates, we convert the data into units of local currency per U.S. dollar. Daily forward rates are available. We download monthly, quarterly, and yearly data for both period-end and average of daily values. We obtain exchange rate forecasts from Consensus Economics and convert them into local currency per U.S. dollar forecasts using the appropriate currency forecasts. We obtain the Emerging Markets Bond Index (EMBI Global) from J.P. Morgan. We employ the exchange rate regime classification of [Ilzetzki, Reinhart and Rogoff](#page-43-13) [\(2017\)](#page-43-13) to exclude countries with fixed exchange rate regimes.

We proxy global risk with the VIX, obtained from the Federal Reserve Economic Data

(FRED). We obtain detailed information about policy risk from the International Country Risk Guide (ICRG). The ICRG rating comprises 22 variables across three subcategories of risk: political, financial, and economic. We normalize these risk indices x using the following formula:  $-(x - \mu_x)/\sigma_x$ , where  $\mu_x$  is the mean and  $\sigma_x$  is the standard deviation of variable x in the full sample. We add the minus sign so that higher normalized indices indicate higher risk.

Our sample consists of 12 advanced economy currencies and 22 emerging market currencies over the period November 1996 to December 2018. Table 2 presents the sample of countries.

Table 1. List of Variables

<span id="page-45-0"></span>

| Variable                                                           | Description                                                                                                   | Frequency                                          | Source                                             |
|--------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|----------------------------------------------------|----------------------------------------------------|
| Spot exchange rate                                                 | local currency/US dollar, period end and average                                                              | month / quarter / year                             | IMF IFS                                            |
| Interest rates: Treasury bill rate  Money market rate Deposit rate | annual percentage rate, denominated in local currency, maturity: 1, 3, 12 month, period end and average       | month / quarter / yea                              | rBloomberg, IMF IFS                                |
| Capital inflows                                                    | capital inflows by sector                                                                                     | quarter / year                                     | Avdjiev, Hardy, Kalemli-Özcan and<br>Servén (2022) |
| Aggregate variables:                                               | local currency (million), real and nominal,                                                                   | quarter / year                                     |                                                    |
| Industrial production                                              | non-seasonally-adjusted and seasonally-adjusted series index $2010=100$ , non- and seasonally-adjusted series | month / quarter / year                             | IMF IFS                                            |
| Consumer price index                                               |                                                                                                               | month / quarter /<br>vear                          |                                                    |
| Producer price index                                               | 2010=100                                                                                                      | month / quarter /<br>year                          |                                                    |
| GDP deflator<br>Current account<br>Capital account                 | 2010=100, non- and seasonally-adjusted series million US dollars million US dollars                           | quarter / year<br>quarter / year<br>quarter / year |                                                    |
| Forward Rates                                                      | local currency/US dollar, maturity: 1, 3, 12                                                                  |                                                    | Bloomberg                                          |
| F. I                                                               | month, period end and average                                                                                 | year                                               | O. P.                                              |
| exchange rate fore-<br>casts                                       | local currency/US dollar, period end,<br>forecast horizon: 1, 3, 12, 24 month                                 | month / quarter /<br>year                          | Consensus Economics                                |
| VIX                                                                | Chicago Board Options Exchange volatility index                                                               | month / quarter / year                             | FRED                                               |
| EMBI                                                               | Emerging Markets Bond Index (EMBI global)                                                                     | month                                              | J.P. Morgan                                        |
| Country Risk                                                       | 22 variables in three subcategories of risk: political, financial, and economic.                              | month / year                                       | ICRG                                               |
| Exchange Rate Regime                                               | Exchange Rate Regime Coarse Classification (1–6)                                                              | month / year                                       | Ilzetzki, Reinhart and Rogoff (2017)               |

**Table 2.** List of Currencies

<span id="page-46-0"></span>

| Advanced Economies<br>(1) | Emerging Markets<br>(2) |
|---------------------------|-------------------------|
| Australia                 | Argentina               |
| Canada                    | Brazil                  |
| Denmark                   | Chile                   |
| Euro                      | China, P.R.: Mainland   |
| Germany                   | Colombia                |
| Israel                    | Czech Republic          |
| Japan                     | Hungary                 |
| New Zealand               | India                   |
| Norway                    | Indonesia               |
| Sweden                    | Republic of Korea       |
| Switzerland               | Malaysia                |
| United Kingdom            | Mexico                  |
|                           | Peru                    |
|                           | Philippines             |
|                           | Poland                  |
|                           | Romania                 |
|                           | Russian Federation      |
|                           | Slovak Republic         |
|                           | South Africa            |
|                           | Thailand                |
|                           | Turkey                  |
|                           | Ukraine                 |

### **Interest Rates for UIP Calculation**

We obtain interest rates to calculate the UIP deviations as follows. First, we replace deposit rates with money market rates of the same maturity if the data coverage for deposit rates is shorter than 5 years in a given country. If the data coverage for market rates is shorter than 5 years in a given country, we replace deposit rates with government bond rates of the same maturity. Table [3](#page-47-0) shows the country-year observations of deposit rates that are replaced with money market rates or government bond rates.

### **Interpolation of Quarterly Capital Flows**

We interpolate quarterly capital flows to obtain monthly flows using a cubic spline built into Stata. More precisely, we use the following Stata command: by id: mipolate 'var' date , gen('var'i) spline, where id is the country group, 'var' is the flows data, and date is a variable

<span id="page-47-0"></span>**Table 3.** Replaced Deposit Rates: Country-year Observations (1996-2018)

| Country          | Year                     | Country             | Year          |
|------------------|--------------------------|---------------------|---------------|
| Austria          | 2008-14                  | Ireland             | 1999-2016     |
| Canada           | 1996-2005, 2007-18 Italy |                     | 1996, 2014-16 |
| Chile            | 2001-18                  | South Korea 2004-18 |               |
| Colombia 2001-18 |                          | Netherlands         | 2001-14       |
| Finland          | 1999, 2005-14            | Portugal            | 2002-16       |
| France           | 1996, 2000-16            | Spain               | 1996-2015     |
| Germany          | 1996, 2000-14            |                     |               |

denoting months. The interpolated flows are generated with the variable name 'var'i. This Stata module can be installed using the command ssc install mipolate. Before running this command, quarterly flows are imported into the median month of each quarter. For example, first-quarter flows are imported into February, the median month of the first quarter. The command then fills the remaining empty months with cubic spline interpolation.

We plot averages of raw and interpolated data across advanced economies and emerging markets in Figure [1.](#page-48-0) We plot both raw quarterly flows (blue solid line with diamond markers) and monthly flows interpolated from raw quarterly flows (red solid line). We find that the interpolated monthly flows closely track the raw quarterly flows with small deviations (the correlation between the two series is 0.99).

### **Exchange Rate Expectations from Survey Data: Consensus Forecasts**

This section provides additional descriptive statistics about the Consensus Forecasts database. Table [4](#page-49-0) presents the average number of forecasters per year for advanced economy and emerging market currencies separately. As shown, the number of surveyed forecasters is large in both groups of economies, although smaller for emerging markets. Table [5](#page-50-0) reports the average number of forecasters for each country across time.

Table [6](#page-51-1) presents examples of the main forecasters for the Euro, Yen, UK Pound, Korean Won, Turkish Lira, and other emerging markets in September 2012. The first thing to notice is that these forecasters are also the main global investors, and the investorforecasters surveyed for emerging market currencies were also top investor-forecasters in advanced economies. We also collect individual forecasts from printed monthly reports created by Consensus Forecasts. These reports do not provide a complete list of forecasters for each currency. For this reason, the empty cells in Table [6](#page-51-1) indicate the absence of information about whether the forecaster was surveyed for that currency; they do *not* indicate that the forecaster was *not* surveyed. It may well be that the forecaster was also surveyed, but we have no record of it.

<span id="page-48-0"></span>![](_page_48_Figure_0.jpeg)

Figure 1. Average Capital Inflows: Raw vs. Interpolated Data The interpolation of capital inflows at monthly frequency for advanced economies and emerging markets.

#### Policy Risk Premium Measure

We construct the PRP measure following the methodology of Baker, Bloom and Davis (2016). In particular, we use the online platform Factiva, which reports journal articles from the main international newspapers. We employ the same search procedure as Baker, Bloom and Davis (2016). Our list of words contains 218 words and follows theirs closely. Since the Baker, Bloom and Davis (2016) list of words is conceived mostly for advanced economies, we include four additional words to better capture policy uncertainty characteristics in emerging markets (i.e., capital controls, expropriation, nationalization, and corruption). We report the full list of words below.

<span id="page-49-0"></span>**Table 4.** Number of Forecasters in Consensus Forecasts (all years)

|      | Advanced<br>Economies<br>(1) | Emerging<br>Markets<br>(2) |
|------|------------------------------|----------------------------|
| 1996 | 62                           | 26                         |
| 1997 | 63                           | 21                         |
| 1998 | 54                           | 14                         |
| 1999 | 58                           | 13                         |
| 2000 | 57                           | 15                         |
| 2001 | 53                           | 14                         |
| 2002 | 55                           | 13                         |
| 2003 | 58                           | 15                         |
| 2004 | 59                           | 16                         |
| 2005 | 62                           | 16                         |
| 2006 | 61                           | 16                         |
| 2007 | 58                           | 15                         |
| 2008 | 57                           | 16                         |
| 2009 | 50                           | 15                         |
| 2010 | 50                           | 17                         |
| 2011 | 52                           | 17                         |
| 2012 | 56                           | 17                         |
| 2013 | 54                           | 16                         |
| 2014 | 53                           | 16                         |
| 2015 | 54                           | 17                         |
| 2016 | 43                           | 19                         |
| 2017 | 43                           | 18                         |
| Mean | 55                           | 17                         |

Because we are interested in the perspective of the U.S. international investor, we focus on news reported in international newspapers (see the complete list below). Given the lower availability of international newspapers, we follow the methodology of [Barrett, Appendino,](#page-41-7) [Nguyen and de Leon Miranda](#page-41-7) [\(2022\)](#page-41-7) to construct our PRP measure. This methodology adds up the total number of articles for a country and pools all newspapers together for each country.[22](#page-49-1) More precisely, define *Xct* as the number of articles referring to policy risk episodes in country *c* at time *t*, *Yct* as the total number of articles referring to country *c* at time *t*, and *Y<sup>t</sup>* = P *<sup>c</sup> Yct* as the total number of articles written at each time *t* (the sum of articles across countries). We replicate the [Barrett, Appendino, Nguyen and de Leon Miranda](#page-41-7) [\(2022\)](#page-41-7) index as follows:

<span id="page-49-1"></span><sup>22</sup>The difference with [Baker, Bloom and Davis](#page-41-6) [\(2016\)](#page-41-6) is that their index includes a non-minor proportion of local newspapers. Higher heterogeneity across newspapers allows them to first compute the share of news for each individual newspaper within a country and then add up the total for each country. In other words, they do not pool all articles within a country together.

**Table 5.** Number of Forecasters By Currency

<span id="page-50-0"></span>

| Average Number of Forecasters |     |                       |                  |  |  |
|-------------------------------|-----|-----------------------|------------------|--|--|
| Advanced Economies            |     |                       | Emerging Markets |  |  |
| Australia                     | 37  | Argentina             | 11               |  |  |
| Canada                        | 77  | Brazil                | 13               |  |  |
| Denmark                       | 25  | Chile                 | 12               |  |  |
| Euro Area                     | 101 | China, P.R.: Mainland | 26               |  |  |
| Germany                       | 107 | Colombia              | 10               |  |  |
| Israel                        | 11  | Czech Republic        | 12               |  |  |
| Japan                         | 98  | Hungary               | 11               |  |  |
| New Zealand                   | 31  | India                 | 20               |  |  |
| Norway                        | 24  | Indonesia             | 23               |  |  |
| Sweden                        | 30  | Republic of Korea     | 23               |  |  |
| Switzerland                   | 27  | Malaysia              | 24               |  |  |
| United Kingdom                | 84  | Mexico                | 12               |  |  |
|                               |     | Peru                  | 9                |  |  |
|                               |     | Philippines           | 17               |  |  |
|                               |     | Poland                | 11               |  |  |
|                               |     | Romania               | 8                |  |  |
|                               |     | Russian Federation    | 11               |  |  |
|                               |     | Slovak Republic       | 9                |  |  |
|                               |     | South Africa          | 22               |  |  |
|                               |     | Thailand              | 24               |  |  |
|                               |     | Turkey                | 23               |  |  |
|                               |     | Ukraine               | 4                |  |  |
| Average 1996-2018             | 55  |                       | 17               |  |  |

$$PRP_{ct} = \frac{X_{ct}}{\frac{1}{12} \sum_{j=1}^{12} Y_{t-j}}$$

where *X<sup>c</sup>* = 1 *T* P *T t*=1 *Xct* and *Y* = 1 *T* P *T t*=1 *Yt* . We normalize the index to 100 by estimating

$$PRP_{ct}^{N} = \frac{PRP_{ct}}{\overline{PRP}_{c}} \times 100,$$

where *P RP<sup>c</sup>* = 1 *T* P *T t*=1 *P RPct* is the average of policy risk news for each country across time. We construct the monthly PRP for the Euro Area as follows. We use real GDP data for France, Germany, Greece, Italy, and Spain. This real GDP is expressed in local currency and reported at quarterly frequency. Prior to 2000, we transform these real GDP measures

<span id="page-51-1"></span>**Table 6.** Example: Main Forecasters in Advanced Economies and Emerging Markets, September 2012

<span id="page-51-0"></span>

| Advanced Economies   |                      |                      | Emerging Markets   |                    |                      |
|----------------------|----------------------|----------------------|--------------------|--------------------|----------------------|
| Euro                 | Yen                  | UK Pound             | Korean Won         | Turkish Lira       | Other EMs*           |
| (1)                  | (2)                  | (3)                  | (4)                | (5)                | (6)                  |
| Goldman Sachs        | Goldman Sachs        | Goldman Sachs        | Goldman Sachs      | Goldman Sachs      | Goldman Sachs        |
| HSBC                 | HSBC                 | HSBC                 | HSBC               | HSBC               | HSBC                 |
| General Motors       | General Motors       | General Motors       | General Motors     | General Motors     | General Motors       |
| ING Financial Mar-   | ING Financial Mar-   | ING Financial Mar-   | ING Financial Mar- |                    | ING Financial Mar-   |
| kets                 | kets                 | kets                 | kets               |                    | kets                 |
| BNP Paribas          | BNP Paribas          | BNP Paribas          |                    | BNP Paribas        | BNP Paribas          |
| JP Morgan            | JP Morgan            | JP Morgan            | JP Morgan          | JP Morgan          | JP Morgan            |
| Allianz              | Allianz              | Allianz              |                    |                    | Allianz              |
| Oxford Economics     | Oxford Economics     | Oxford Economics     |                    | Oxford Economics   | Oxford Economics     |
| Morgan Stanley       | Morgan Stanley       | Morgan Stanley       |                    | Morgan Stanley     | Morgan Stanley       |
| Bank of Tokio Mit-   | Bank of Tokio Mit-   | Bank of Tokio Mit-   | Bank of Tokio Mit- | Bank of Tokio Mit- | Bank of Tokio Mit-   |
| subishi              | subishi              | subishi              | subishi            | subishi            | subishi              |
| Credit Suisse        | Credit Suisse        | Credit Suisse        |                    | Credit Suisse      |                      |
| Citigroup            | Citigroup            | Citigroup            | Citigroup          | Citigroup          | Citigroup            |
| Societe Generale     | Societe Generale     | Societe Generale     |                    | Societe Generale   | Societe Generale     |
| Royal Bank of Canada | Royal Bank of Canada | Royal Bank of Canada |                    |                    | Royal Bank of Canada |
| Royal Bank of Scot-  | Royal Bank of Scot-  | Royal Bank of Scot-  |                    |                    | Royal Bank of Scot-  |
| land                 | land                 | land                 |                    |                    | land                 |
| ABN Amro             | ABN Amro             | ABN Amro             |                    |                    | ABN Amro             |
| Barclays Capital     | Barclays Capital     | Barclays Capital     |                    | Barclays Capital   | Barclays Capital     |
| Commerzbank          | Commerzbank          | Commerzbank          |                    |                    | Commerzbank          |
| UBS                  | UBS                  | UBS                  | UBS                | UBS                | UBS                  |
| IHS Global Insight   | IHS Global Insight   | IHS Global Insight   | IHS Global Insight | IHS Global Insight | IHS Global Insight   |
| Nomura Securities    | Nomura Securities    | Nomura Securities    | Nomura Economics   | Nomura Securities  | Nomura Securities    |
|                      |                      |                      | Macquarie Capital  |                    | Macquarie Capital    |
|                      |                      |                      | ANZ Bank           |                    | ANZ Bank             |

\*Other EM currencies include: Argentinean Peso, Brazilian Real, Chilean Peso, Chinese Renminbi, Colombian Peso, Czech Koruna, Hungarian Forint, Indian Rupee, Indonesian Rupiah, Malaysian Ringgit, Mexican Peso, Peruvian Sol, Polish Zloty, Romanian Leu, Russian Rouble, South African Rand, and Ukrainian Hryvnia. Note that non-filled cells indicate the absence of information about whether the forecaster was surveyed for that currency (i.e., they do *not* indicate that the forecaster was not surveyed for that currency). Source: Consensus Forecast.

to U.S. dollars using the observed average exchange rate in the quarter. From 2000 onward, we assume all countries use the euro as the relevant currency, so there is no need to convert them to a common currency. We linearly interpolate the real GDP of each country to obtain GDP at monthly frequency. We can then aggregate GDP across eurozone countries to construct a GDP measure for the entire eurozone. We construct the Euro Area PRP measure as  $PRP_t = \sum_{c=1}^{N} \omega_{ct} PRP_{ct}$ , where  $\omega_{ct} = RGDP_{ct} / \sum_{c=1}^{N} RGDP_{ct}$  is the share of eurozone GDP accounted for by country c,  $PRP_{ct}$  is the PRP measure for country c at time t, and N is the number of countries in the eurozone for which we observe both a  $PRP_{ct}$  value and GDP.

#### List of Words

Our list of words comes from Baker, Bloom and Davis (2016). In particular, we use the following words from their list: tax, taxation, taxes, policy, government spending, federal

budget, budget battle, balanced budget, defense spending, defence spending, military spending, entitlement spending, fiscal stimulus, budget deficit, federal debt, national debt, debt ceiling, fiscal footing, government deficit, fiscal policy, federal reserve, the fed, money supply, open market operations, quantitative easing, monetary policy, fed funds rate, overnight lending rate, Bernanke, Volcker, Greenspan, central bank, interest rates, fed chairman, fed chair, lender of last resort, discount window, health care, health insurance, prescription drugs, drug policy, medical insurance reform, medical liability, national security, war, military conflict, terrorism, terror, 9/11, armed forces, base closure, military procurement, military embargo, no-fly zone, military invasion, terrorist attack, banking (or bank) supervision, thrift supervision, financial reform, basel, capital requirement, bank stress test, deposit insurance, union rights, card check, collective bargaining law, minimum wage, closed shop, workers compensation, advance notice requirement, affirmative action, overtime requirements, antitrust, competition policy, merger policy, monopoly, patent, copyright, unfair business practice, cartel, competition law, price fixing, healthcare lawsuit, tort reform, tort policy, punitive damages, medical malpractice, energy policy, energy tax, carbon tax, drilling restrictions, offshore drilling, pollution controls, environmental restrictions, immigration policy, illegal immigration, sovereign debt, currency crisis, currency crises, currency crash, crisis, crises, reserves, tariff, trade, devaluation, capital controls, expropriation, nationalization, and corruption.

The list of words used in [Baker, Bloom and Davis](#page-41-6) [\(2016\)](#page-41-6) is conceived mostly for advanced economies. To better capture the policy uncertainty characteristics of emerging markets, we include four additional words: capital controls, expropriation, nationalization, and corruption.

### **List of Newspapers**

We include the following newspapers: ABC Network, Agence France Presse, BBC, The Boston Globe, CBS Network, Chicago Tribune, Financial Times, The Globe and Mail, Houston Chronicle, Los Angeles Times, NBC Network, The New York Times, The San Francisco Chronicle, The Telegraph (U.K.), The Wall Street Journal, The Times (U.K.), USA Today, The Washington Post, Reuters, The Dallas Morning News, The Miami Herald, The Guardian (U.K.), and The Economist.

### **ICRG: Composite and Political Risks**

Our measures of composite and political risk come from the International Country Risk Guide (ICRG) dataset, which provides data on countries' political, economic, and financial risks for more than 140 countries at monthly frequency. We describe below the definition of each variable used in the paper and then present the correlation of the sub-components of political risk with the UIP premium.

### **Definition of Variables**

In our analysis, we employ the composite risk variable to proxy for overall country risk (political, economic, and financial), and socioeconomic conditions to capture confidence risk. We pool investment profile and democratic accountability together to measure government policy risk (i.e., the average of both variables). Additionally, we use investment profile separately to proxy for expropriation risk and democratic accountability to capture anti-democratic risk. We describe all the variables in detail below.

*Composite risk.* A composite of political, financial, and economic risk. Political risk contributes 50% of the composite rating, while financial and economic risk ratings each contribute 25%. Political risk has 12 components, with assessments made on the basis of subjective analysis of the available information. Financial and economic risk each have five components, with assessments made solely on the basis of objective data. The components of political, economic, and financial risk are as follows:

Political risk: government stability<sup>∗</sup> , socioeconomic conditions<sup>∗</sup> , investment profile<sup>∗</sup> , internal conflict<sup>∗</sup> , external conflict<sup>∗</sup> , democratic accountability<sup>+</sup>, corruption<sup>+</sup>, military in politics<sup>+</sup>, religious tensions<sup>+</sup>, law and order<sup>+</sup>, ethnic tensions<sup>+</sup>, and bureaucracy quality. The components with ∗ are given up to 12 points and hence carry a higher weight; the components with <sup>+</sup> are given up to 6 points; and the last component (bureaucracy quality) is given only 4 points.

- Government stability: assesses both the government's ability to carry out its declared programs and its ability to stay in office. It has three subcomponents: government unity, legislative strength, and popular support.
- Socioeconomic conditions: assesses the socioeconomic pressures at work in society that could constrain government action or fuel social dissatisfaction. It has three subcomponents: unemployment, consumer confidence, and poverty.

- Investment profile: assesses factors affecting investment risk that are not covered by other political, economic, and financial risk components. It has three components: contract viability/expropriation, profits repatriation, and payment delays.
- Internal conflict: assesses political violence in the country and its actual or potential impact on governance. The subcomponents are civil war/coup threat, terrorism/political violence, and civil disorder.
- External conflict: assesses the risk to the incumbent government from foreign action, ranging from non-violent external pressure (diplomatic pressure, withholding of aid, trade restrictions, territorial disputes, sanctions, etc.) to violent external pressure (cross-border conflicts and all-out war). External conflicts can adversely affect foreign business in many ways, from restrictions on operations to trade and investment sanctions, distortions in resource allocation, and violent changes in the structure of society. The subcomponents are war, cross-border conflict, and foreign pressures.
- Democratic accountability: a measure of how responsive and accountable government is to its people. As such, it captures the degree of freedom that a government has to impose policies to its own advantage. It evaluates several types of government from more to less democratic, considering whether it is an alternating democracy, dominated democracy, de facto one-party state, de jure one-party state, or autarchy.
- Corruption: an assessment of corruption within the political system. Such corruption is a threat to foreign investment for several reasons: it distorts the economic and financial environment; it reduces the efficiency of government and business by enabling people to assume positions of power through patronage rather than ability; and it introduces an inherent instability into the political process. The measure considers financial corruption in the form of demands for special payments and bribes connected with import and export licenses, exchange controls, tax assessments, police protection, or loans. It also considers potential corruption in the form of excessive patronage, nepotism, job reservations, "favor-for-favors," secret party funding, and suspiciously close ties between politics and business.
- Military in politics: considers the involvement of the military in politics.
- Religious tensions: measures the relevance of a single religious group that seeks to replace civil law with religious law and to exclude other religions from the political and/or social process; the desire of a single religious group to dominate governance;

the suppression of religious freedom; and the desire of a religious group to express its own identity, separate from the country as a whole.

- Law and order: refers to the strength and impartiality of the legal system and popular observance of the law.
- Ethnic tensions: refers to the degree of tension within a country attributable to racial, nationality, or language divisions.
- Bureaucracy quality: measures the strength and quality of the bureaucracy. High points are given to countries where the bureaucracy has the strength and expertise to govern without drastic changes in policy or interruptions in government services.

Economic risk: includes GDP per capita, real GDP growth, inflation rate, budget balance over GDP, and current account over GDP.

Financial risk: includes foreign debt over GDP, foreign debt service over exports of goods and services, current account over exports of goods and services, net international liquidity as months of import cover, and exchange rate stability.

*Eurozone ICRG Risk Variable Construction.* We construct monthly eurozone ICRG risk indices as follows. We use real GDP data for the 19 countries that compose the eurozone. This real GDP is expressed in local currency and reported at quarterly frequency. Prior to 2000, we transform these real GDP measures to U.S. dollars using the observed average exchange rate in the quarter. From 2000 onward, we assume that all eurozone countries use the euro as the relevant currency, so there is no need to convert them to a common currency. We linearly interpolate the real GDP of each country to obtain GDP at monthly frequency. We can then aggregate GDP across eurozone countries to construct a GDP measure for the entire eurozone. We construct the Eurozone Composite Risk Index as

$$ECR_t = \sum_{c=1}^{N_t} \omega_{ct} CR_{ct},$$

<span id="page-55-0"></span>where *ωct* = *RGDPct/* P *Nt c*=1 *RGDPct* is the share of eurozone GDP accounted for by country *c*, *CRct* is the ICRG risk index for country *c* at time *t*, and *N<sup>t</sup>* is the number of countries in the eurozone for which we observe both a *CRct* value and GDP. Starting in 1999, all 19 eurozone countries have information on both their GDP and the composite risk index.

### A. UIP and CIP: Comparison in the Cross Section and Over Time

This appendix compares our survey-based UIP premium with CIP deviations. Figure A2 plots the two series over time using deposit rates; Figure A3 presents the cross-sectional comparison; Figure A4 benchmarks our CIP measure against Du, Pflueger and Schreger (2020); and Figure A5 repeats the time-series comparison using interbank rates for CIP.

<span id="page-56-0"></span>![](_page_56_Figure_2.jpeg)

Figure A2. UIP and CIP over Time (12 Months)

Note: This figure shows UIP and CIP deviations using our sample. Both series use deposit rates. UIP deviations is measured using Consensus Forecast.

<span id="page-56-1"></span>![](_page_56_Figure_5.jpeg)

Figure A3. Cross-sectional UIP and CIP (12 Months)

Note: This figure shows UIP and CIP deviations where each point represents a different date. At each date, we take the average across countries in each classification (Emerging and Advanced). Panel (a) constructs CIP using Du, Pflueger and Schreger (2020) cross-currency basis. Panel (b) constructs CIP using forward rates. Both panels compute UIP using expectations from Consensus Forecast. Both UIP and CIP deviations use 12 months deposit rates.

<span id="page-57-1"></span>![](_page_57_Figure_0.jpeg)

Figure A4. CIP Comparison: Kalemli-Ozcan and Varela (KOV) vs. Du and Schreger (DS)

Note: This figure shows CIP comparison in a sample that restrict observations to be the same at date-country pairs in DS and our data. Both series use money market interbank rates.

<span id="page-57-0"></span>![](_page_57_Figure_3.jpeg)

Figure A5. UIP and CIP over Time, Interbank Rates (12 Months)

Note: This figure shows UIP and CIP deviations using our sample. We use interbank rates to construct CIP, while we use deposit rates to construct UIP.

### <span id="page-58-0"></span>**B. Additional Tables and Figures**

**Table B7.** Countries/Currencies in sample

| Country                              | Periods                                          | Income classification |
|--------------------------------------|--------------------------------------------------|-----------------------|
| Argentina                            | 2001m12-2018m12                                  | Emerging Market       |
| Australia                            | 1996m11-2018m12                                  | Advanced Economy      |
| Brazil                               | 1996m11-2018m12                                  | Emerging Market       |
| Canada                               | 1996m11-2018m12                                  | Advanced Economy      |
| Chile                                | 1996m11-2018m12                                  | Emerging Market       |
| China, P.R.: Mainland 2005m8-2018m12 |                                                  | Emerging Market       |
| Colombia                             | 1996m11-2018m12                                  | Emerging Market       |
| Czech Republic                       | 1996m11-2009m1                                   | Emerging Market       |
| Denmark                              | 1996m11-1998m12                                  | Advanced Economy      |
| Euro Area                            | 1999m1-2018m12                                   | Advanced Economy      |
| Germany                              | 1996m11-1998m12                                  | Advanced Economy      |
| Hungary                              | 1996m11-2018m12                                  | Emerging Market       |
| India                                | 1996m11-2018m12                                  | Emerging Market       |
| Indonesia                            | 1996m11-2018m12                                  | Emerging Market       |
| Israel                               | 1996m11-2018m12                                  | Advanced Economy      |
| Japan                                | 1996m11-2018m12                                  | Advanced Economy      |
| Korea                                | 1996m11-2018m12                                  | Emerging Market       |
| Malaysia                             | 1996m11-1998m9 ; 2005m7-2018m12                  | Emerging Market       |
| Mexico                               | 1996m11-2018m12                                  | Emerging Market       |
| New Zealand                          | 1996m11-2018m12                                  | Advanced Economy      |
| Norway                               | 1996m11-2018m12                                  | Advanced Economy      |
| Peru                                 | 1996m11-2018m12                                  | Emerging Market       |
| Philippines                          | 1997m7-2018m12                                   | Emerging Market       |
| Poland                               | 1996m11-2018m12                                  | Emerging Market       |
| Romania                              | 1996m11-2012m11                                  | Emerging Market       |
| Russian Federation                   | 1996m11-2018m12                                  | Emerging Market       |
| Slovakia*                            | 1996m11-2009m1                                   | Emerging Market       |
| South Africa                         | 1996m11-2018m12                                  | Emerging Market       |
| Sweden                               | 1996m11-2018m12                                  | Advanced Economy      |
| Switzerland                          | 1996m11-2011m8 ; 2015m2-2018m12                  | Advanced Economy      |
| Thailand                             | 1997m8-2018m12                                   | Emerging Market       |
| Turkey                               | 1996m11-2018m12                                  | Emerging Market       |
| Ukraine                              | 1996m11-1999m11 ; 2014m2-2018m12 Emerging Market |                       |
| United Kingdom                       | 1996m11-2018m12                                  | Advanced Economy      |

*Note:* This table reports the countries used in our sample. We use IMF-WEO 2000 income classification and assign each country as Advanced Economy or Emerging Market. The second column reports periods in sample, which varies by country according to its exchange rate regime. In particular, we only consider floating regimes. The Czech Republic and Slovakia are in the sample until 2009m1, after which their exchange rate regimes are classified as fixed vis-à-vis the euro.

<span id="page-59-0"></span>![](_page_59_Figure_0.jpeg)

Figure B6. Economic Policy Uncertainty and Default in Emerging Markets

<span id="page-59-1"></span>Note: This figure shows the Credit Default Swaps (CDS) and Economic Policy Uncertainty (EPU) for 18 EMs over 2003m4:2018m10.

![](_page_59_Figure_3.jpeg)

**Figure B7.** UIP Premium in Advanced Economies: Excluding Funding and Investing Currencies

Note: This figure plots the UIP premium for Advanced Economies separating between All Advanced Economies in our sample and the subsample that removes both investing and funding currencies. Investing currencies: Australia and New Zealand. Funding currencies: Japan and Switzerland. Others: Canada, Denmark, Euro Area, Germany, Israel, Norway, Sweden and United Kingdom.