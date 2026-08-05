# **Dominant Currency Pricing and Currency Risk Premia**

Prepared by Husnu C. Dalgic and Galip Kemal Ozhan

**WP/26/158**

*IMF Working Papers* **describe research in progress by the author(s) and are published to elicit comments and to encourage debate.** The views expressed in IMF Working Papers are those of the author(s) and do not necessarily represent the views of the IMF, its Executive Board, or IMF management.

2026 JUL

![](_page_0_Picture_7.jpeg)

#### **IMF Working Paper** Research Department

#### **Dominant Currency Pricing and Currency Risk Premia Prepared by Husnu C. Dalgic and Galip Kemal Ozhan[\\*](#page-1-0)**

Authorized for distribution by Deniz Igan July 2026

*IMF Working Papers* **describe research in progress by the author(s) and are published to elicit comments and to encourage debate.** The views expressed in IMF Working Papers are those of the author(s) and do not necessarily represent the views of the IMF, its Executive Board, or IMF management.

**ABSTRACT:** This paper studies how dominant-currency pricing affects currency risk premia. Empirically, we extract common risk factors from excess currency returns using principal components and relate countries' factor exposures to observable macroeconomic characteristics, with export dollar invoicing emerging as a predictor of carry trade exposure. A small open-economy model with dominant-currency pricing and dollar-denominated liabilities explains why. Dollar export invoicing weakens the exchange rate's stabilizing effect on external demand, while dollar debt makes depreciation costly for leveraged intermediaries. When the two frictions interact, depreciations occur in bad states, local-currency assets become risky, the currency premium rises, and the risk-adjusted neutral rate increases. Under a standard Taylor rule, this mechanism generates persistently higher inflation.

| JEL Classification Numbers: | E44, E32, F41, G15, G21                                                                           |
|-----------------------------|---------------------------------------------------------------------------------------------------|
| Keywords:                   | Currency returns; dominant currency pricing; uncovered interest parity;<br>inflation; dollar debt |
| Authors' email addresses:   | gozhan@IMF.org<br>dalgic@uni-mannheim.de                                                          |

<span id="page-1-0"></span><sup>\*</sup> We thank Philippe Bacchetta, Gianluca Benigno, Kenza Benhima, Emine Boz, Lawrence Christiano, Ippei Fujiwara, Pierre-Olivier Gourinchas, Max Gödl, Ralph Luetticke, Rui Mano, Dmitry Mukhin (discussant), Hélène Rey, and Dimitri Vayanos for helpful comments. We are also grateful to audiences at the CEPR International Macro and Finance Annual Meeting at the University of Lausanne, CEPR-RISE Workshop at Waseda University, 25th Central Bank Macroeconomic Modeling Workshop, International Macroeconomics and Finance Conference at Peking University, Berlin Schumpeter Lecture in 2025.

## **WORKING PAPERS**

# **Dominant Currency Pricing and Currency Risk Premia**

Prepared by Husnu C. Dalgic and Galip Kemal Ozhan\*

## Dominant Currency Pricing and Currency Risk Premia\*

Husnu C. Dalgic† University of Mannheim

Galip Kemal Ozhan‡ International Monetary Fund and NBER

July 23, 2026

#### **Abstract**

This paper studies how dominant-currency pricing affects currency risk premia. Empirically, we extract common risk factors from excess currency returns using principal components and relate countries' factor exposures to observable macroeconomic characteristics, with export dollar invoicing emerging as a predictor of carrytrade exposure. A small open-economy model with dominant-currency pricing and dollar-denominated liabilities explains why. Dollar export invoicing weakens the exchange rate's stabilizing effect on external demand, while dollar debt makes depreciation costly for leveraged intermediaries. When the two frictions interact, depreciations occur in bad states, local-currency assets become risky, the currency premium rises, and the risk-adjusted neutral rate increases. Under a standard Taylor rule, this mechanism generates persistently higher inflation.

**JEL Classification:** E44, F32, F41, G15, G21. **Keywords:** Currency returns; dominant currency pricing; uncovered interest parity; inflation; dollar debt.

International Monetary Fund, 700 19th St NW 20431 Washington, D.C. U.S.A.

Email: [gozhan@gmail.com](mailto:gozhan@gmail.com) URL: <http://galipkemalozhan.com>.

<sup>\*</sup>Previously circulated under the title, "Global Shocks and Local Response: Currency Risk and Monetary Policy." We thank Philippe Bacchetta, Gianluca Benigno, Kenza Benhima, Emine Boz, Lawrence Christiano, Ippei Fujiwara, Pierre-Olivier Gourinchas, Max Gödl, Tarek Hassan, Ralph Luetticke, Rui Mano, Dmitry Mukhin (discussant), Hélène Rey, and Dimitri Vayanos for helpful comments. We are also grateful to audiences at the CEPR International Macro and Finance Annual Meeting at the University of Lausanne, CEPR-RISE Workshop at Waseda University, 25th Central Bank Macroeconomic Modeling Workshop, International Macroeconomics and Finance Conference at Peking University, Berlin Schumpeter Lecture in 2025. The views expressed herein are those of the authors and should not be attributed to the IMF, its Executive Board, or its management.

<sup>†</sup>University of Mannheim, Department of Economics, L 7, 3–5 – Room 422 (4th floor) 68161 Mannheim. Email: [dalgic@uni-mannheim.de](mailto:dalgic@uni-mannheim.de) URL: <https://sites.google.com/view/husnucdalgic/>.

## **1 Introduction**

One of the salient features of the international monetary system is the asymmetric use of currencies in global trade and finance (see, for example, [Gopinath and Stein](#page-53-0) [\(2021\)](#page-53-0)). The U.S. dollar is the dominant vehicle currency in international trade, as documented by [Goldberg and Tille](#page-53-1) [\(2008\)](#page-53-1) and [Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-](#page-53-2)[Møller](#page-53-2) [\(2020\)](#page-53-2). The dollar is also central to global financial intermediation and to the denomination of cross-border liabilities. These two forms of dollar dominance are typically studied separately. Trade invoicing affects pass-through and expenditure switching, while liability dollarization affects balance sheets and financial fragility. This paper's hypothesis is that their interaction is central to the risk properties of exchange rates.

The cross section of currency returns provides a natural testing ground for this hypothesis. If the international price system and global balance sheets are disproportionately dollar denominated, then exchange rates need not be merely relative prices; but they also affect the state-contingent payoff of nominal assets, the tightness of financial constraints, and the severity of downturns. We therefore ask whether dominant-currency pricing and liability dollarization shape currencies' exposure to global risk, the cross section of currency risk premia, and the transmission of monetary policy in small open economies.

In particular, the paper asks three questions. First, do dollar export invoicing and dollardenominated liabilities help explain why some currencies are more exposed to global currency risk than others? Second, through what mechanism do these structural features make local-currency assets pay off poorly in bad states and thereby raise currency risk premia? Third, what are the implications for inflation and monetary policy in small open economies?

We begin empirically. We construct monthly excess currency returns for 25 countries from 2003:02 to 2018:11 using FX4Casts and IMF IFS data, together with the invoicing measures in [Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-Møller](#page-53-2) [\(2020\)](#page-53-2). Following [Lustig, Roussanov and Verdelhan](#page-54-0) [\(2011\)](#page-54-0), we extract common factors from currency excess returns. The first factor is a broad dollar factor that comoves with global equity returns, while the second is a carry-trade factor associated with global risk aversion. We then relate each currency's exposure to these factors to country characteristics, focusing on export dollar invoicing, foreign-currency liabilities in the banking system, and net foreign asset positions.

The main empirical result is that countries' exposure to currency risk is systematically shaped by their trade and financial structures. Greater dollar invoicing of exports is strongly associated with higher exposure to the carry-trade risk factor, and this relationship remains robust after controlling for additional country characteristics, including country size, reserves, trade-network centrality, and NFA-to-GFP. Banking-sector foreign liability exposure and net debtor positions also help explain cross-country differences in factor loadings. These exposures are priced in currency markets: currencies with higher loadings on global risk factors earn higher average excess returns, and the same exposures are associated with higher average inflation. Taken together, the evidence points to a macro-financial risk channel. In economies with dollarized trade and balance sheets, local-currency assets tend to lose value in adverse global states, leading investors to demand compensation for holding them.

Figure [1](#page-6-0) summarizes this empirical pattern. Panel (a) shows that export dollar invoicing is a strong predictor of carry-trade exposure. Panel (b) shows that currencies with greater carry-trade exposure earn higher average excess returns. Panel (c) shows that these exposures are also associated with higher average inflation. Together, the panels motivate the paper's central mechanism by showing that the same structural features that make a currency risky for investors also shape monetary transmission.

To interpret the empirical evidence, we develop a small open-economy model with dominant-currency pricing, dollar-denominated bank liabilities, and segmented international asset markets. The model builds on the literature on open-economy financial intermediation with foreign-currency liabilities, including [Aoki, Benigno and Kiyotaki](#page-51-0) [\(2020\)](#page-51-0), [Ozhan](#page-54-1) [\(2020\)](#page-54-1), and [Benhima, Blengini and Merrouche](#page-52-0) [\(2025\)](#page-52-0). In the model, exporters set prices in dollars, imported goods are priced in dollars, domestic intermediaries borrow partly in dollars, and foreign investors require compensation for holding local-currency assets when exchange-rate risk rises.

The analytical results show that the premium on local-currency assets rises through a covariance channel created by the interaction of dollar liabilities and sticky dollar export prices. Dollar liabilities determine the direct balance-sheet exposure to depreciation. When the domestic currency depreciates, the local-currency value of banks' dollar debt rises, bank net worth falls, and the marginal value of bank capital increases. Sticky dollar export prices determine how much stabilization the exchange rate provides on the real side of the economy. When export prices are slow to adjust in dollars, a depreciation

<span id="page-6-0"></span>![](_page_6_Figure_0.jpeg)

(a) Carry-trade exposure and dollar invoicing (b) Carry-trade exposure and excess returns

![](_page_6_Figure_3.jpeg)

(c) Carry-trade exposure and inflation

Figure 1: Carry-trade risk, currency returns, and inflation

*Notes:* Carry-trade exposure is the loading on the second principal component of currency excess returns, following [Lustig, Roussanov and Verdelhan](#page-54-0) [\(2011\)](#page-54-0). Currency returns cover 25 countries from 2003:02 to 2018:11. Data sources are FX4Casts, IMF IFS, and [Gopinath, Boz, Casas, Díez, Gourinchas](#page-53-2) [and Plagborg-Møller](#page-53-2) [\(2020\)](#page-53-2).

does not quickly lower the price faced by foreign buyers, so export demand responds only gradually. The exchange rate therefore has weaker shock-absorbing properties. Instead of rapidly supporting external demand, the depreciation immediately raises import prices and dollar-debt burdens while the export response is delayed. This timing makes depreciation coincide with lower consumption, weaker investment, lower bank net worth, and a higher continuation value of intermediary wealth. Local-currency assets are risky in this environment because their payoff is low when the pricing kernel is high. Investors therefore require a higher expected return to hold them. The premium is largest when both frictions are present because each friction strengthens a different part of the same pricing mechanism. Dollar liabilities make a depreciation reduce bank net worth directly by increasing the local-currency value of banks' dollar debt. Sticky dollar export prices make the depreciation less useful for stabilizing the real economy because foreign buyers do not quickly see lower dollar prices, so exports do not immediately offset the rise in import costs and the fall in domestic spending. The depreciation therefore comes with weaker consumption, lower investment, tighter credit, and a higher value of bank capital. Since local-currency assets lose value in exactly these states, investors require a higher expected return to hold them.

We then quantify the mechanism. We calibrate the model to a small open emergingmarket economy and study a foreign interest-rate shock across economies that differ in two dimensions: the degree of dollar export invoicing and the share of dollar liabilities. The largest UIP deviation arises when both frictions are present. High dollar debt without high dollar invoicing generates a sizable premium, but a smaller one, because the exchange rate can still work more effectively through export prices. High invoicing without high dollar debt generates only a modest premium, because depreciation does not impose large valuation losses on intermediary balance sheets. The interaction is therefore the central quantitative force because dollar liabilities make depreciation financially costly, while sticky dollar export prices prevent depreciation from delivering sufficient real stabilization.

The impulse responses also clarify the role of the exchange rate. In economies with limited dollar invoicing of exports and low financial-sector dollar debt, depreciation acts more like a shock absorber. It improves external competitiveness without generating large balance-sheet losses. In vulnerable economies, where a large share of exports is invoiced in dollars and the financial sector carries substantial dollar debt, depreciation instead becomes a macro-financial state variable. It raises the domestic price of imports, increases the local-currency burden of dollar liabilities, tightens financial constraints, and raises the premium investors require to hold local-currency assets. Although exports may rise after the shock, this expansion does not reflect the frictionless expenditure-switching mechanism of the textbook model. It is achieved through a larger depreciation, a higher UIP premium, and a sharper compression of domestic absorption.

The stochastic steady-state results show that this mechanism also has long-run implications for inflation and monetary policy. Following [Benigno, Benigno and Nisticò](#page-52-1) [\(2012\)](#page-52-1) and [Ghironi and Ozhan](#page-53-3) [\(2025\)](#page-53-3), we solve the model using a higher-order approximation and find that greater export-price stickiness raises exchange-rate volatility in the stochastic steady state. As a result, local-currency assets become riskier, and the UIP premium remains elevated even in the long run. This premium acts like an increase in the risk-adjusted neutral interest rate. Under a conventional Taylor rule with a fixed intercept, the policy rate is too low relative to the return required by investors, causing average inflation to rise above target. A rule that responds more robustly to movements in the neutral rate, in the spirit of [Orphanides and Williams](#page-54-2) [\(2006\)](#page-54-2), can stabilize inflation, but only by sustaining higher interest-rate spreads.

The paper contributes to three related literatures. First, it contributes to the literature on trade invoicing, which studies how vehicle-currency use and nominal rigidities shape exchange-rate pass-through and monetary transmission [\(Obstfeld and Ro](#page-54-3)[goff,](#page-54-3) [1995;](#page-54-3) [Betts and Devereux,](#page-52-2) [2000;](#page-52-2) [Devereux and Engel,](#page-53-4) [2003;](#page-53-4) [Goldberg and Tille,](#page-53-1) [2008;](#page-53-1) [Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-Møller,](#page-53-2) [2020;](#page-53-2) [Mukhin,](#page-54-4) [2022;](#page-54-4) [Amiti, Itskhoki and Konings,](#page-51-1) [2022;](#page-51-1) [Egorov and Mukhin,](#page-53-5) [2023\)](#page-53-5). The paper connects this literature to currency asset pricing by showing that the currency in which exports are priced affects the payoff of local-currency assets in global bad states. Second, it contributes to the literature on the determinants of currency risk premia and the UIP puzzle, which links currency excess returns to global risk factors, country characteristics, trade networks, financial intermediation, external positions, and limits to international risk sharing [\(Hassan,](#page-53-6) [2013;](#page-53-6) [Della Corte, Riddiough and Sarno,](#page-52-3) [2016;](#page-52-3) [Ready, Roussanov and](#page-54-5) [Ward,](#page-54-5) [2017a](#page-54-5)[,b;](#page-54-6) [Richmond,](#page-54-7) [2019;](#page-54-7) [Wiriadinata,](#page-55-0) [2021;](#page-55-0) [Jiang,](#page-53-7) [2021,](#page-53-7) [2022;](#page-53-8) [Hassan and Zhang,](#page-53-9) [2021;](#page-53-9) [Kalemli-Özcan and Varela,](#page-54-8) [2021;](#page-54-8) [Goldberg and Krogstrup,](#page-53-10) [2023;](#page-53-10) [Liao and Zhang,](#page-54-9) [2025;](#page-54-9) [Bocola and Lorenzoni,](#page-52-4) [2020;](#page-52-4) [Dao, Gourinchas and Itskhoki,](#page-52-5) [2025\)](#page-52-5). Relative to this work, the paper identifies dollar export invoicing and foreign-currency liabilities as observable structural sources of exposure to global currency risk. Third, it contributes to work on exchange rate volatility and monetary policy by showing how dollar liabilities and dollar export invoicing jointly determine inflation dynamics [\(Benigno, Benigno and](#page-52-1) [Nisticò,](#page-52-1) [2012;](#page-52-1) [Kalemli-Özcan,](#page-54-10) [2019;](#page-54-10) [Aoki, Benigno and Kiyotaki,](#page-51-0) [2020;](#page-51-0) [Auclert, Rogn](#page-51-2)[lie, Souchier and Straub,](#page-51-2) [2021;](#page-51-2) [Bacchetta, Benhima and Berthold,](#page-52-6) [2023a;](#page-52-6) [Bacchetta, Cor](#page-52-7)[donier and Merrouche,](#page-52-7) [2023b;](#page-52-7) [Kalemli-Özcan and Unsal,](#page-54-11) [2023\)](#page-54-11). The central contribution is to connect these literatures through a single macro-financial mechanism in which the currency risk premium is determined by the interaction between the currency denomination of liabilities and the currency denomination of export prices.

The rest of the paper is organized as follows. Section 2 describes the data and presents the empirical analysis. Section 3 presents the small open-economy model. Section 4 analytically derives the expressions for the model's key mechanism. Section 5 takes the analytical mechanism to the quantitative model and studies the transmission of foreign monetary shocks. Section 6 concludes.

## **2 Empirical Analysis**

We identify two principal sources of currency market risk—the Dollar Risk Factor, tied to global asset prices, and the Carry Trade Risk Factor, linked to global risk aversion (Section [2.1\)](#page-10-0). Both represent priced risks that command higher average excess returns (Table [1\)](#page-11-0). The underlying macroeconomic channel for this risk is the co-movement between GDP and the exchange rate (Section [2.4\)](#page-13-0); currencies that depreciate during recessions are inherently riskier to hold.

Crucially, we link these cyclical co-movements and risk exposures directly to observable structural frictions (Sections [2.3](#page-12-0) and [2.5\)](#page-16-0). High dollar invoicing, significant bankingsector foreign liabilities (FL/FA), and a net debtor position (low NFA/GDP) jointly exacerbate this risky GDP-ER correlation and determine a country's exposure to both global factors. Furthermore, professional forecast data confirms that investors ex-ante price the higher returns associated with these structural vulnerabilities (Section [2.6\)](#page-17-0). Ultimately, the empirical finding that dollar debt and trade invoicing jointly shape a currency's risk profile directly motivates our theoretical framework.

#### <span id="page-10-0"></span>2.1 Currency Returns

Our primary dataset consists of monthly data for 25 countries from 02/2003 to 11/2018, sourced from FX4casts.<sup>1</sup> We define the realized excess currency return ( $RX_{t+1}$ ) for a USD based investor as:

<span id="page-10-3"></span>
$$RX_{t+1} \equiv R_t^L \frac{S_t}{S_{t+1}} - R_t^{US} \tag{1}$$

where  $S_t$  is the spot exchange rate (LCU per USD), and  $R_t^L$  and  $R_t^{US}$  are the respective local and US gross short-term interest rates from t to t+1. This formula represents the ex-post profit from borrowing in USD, investing in the local currency, and converting the proceeds back to USD one period later.

From a macroeconomic perspective, our primary object of interest is the unconditional average of these returns, which forms the currency risk premium:

$$\mathbb{E}[RX_{t+1}] \equiv \mathbb{E}\left[R_t^L \frac{S_t}{S_{t+1}} - R_t^{US}\right]$$

We aim to understand the cross-sectional determinants of this premium. To expand our sample for the cross-sectional analysis, we augment this dataset with data for an additional 7 countries using forward returns.<sup>2</sup> The derivation of currency returns using forward contracts is detailed in Appendix Section C.

#### 2.2 Global Risk Factors

Following Lustig, Roussanov and Verdelhan (2011), we use principal component analysis to extract the common factors from our panel of currency returns. We identify two key components, which we label the "Dollar Risk Factor" (Component 1) and the "Carry Trade Risk Factor" (Component 2), in line with the literature.

Table 1 presents the cross-sectional results, testing whether these risk exposures are priced. The results confirm they are. In the full specification (Column 3), both the Dollar Risk Exposure  $(0.136^{**})$  and the Carry Trade Risk Exposure  $(0.076^{***})$  show a positive

<span id="page-10-1"></span><sup>&</sup>lt;sup>1</sup>Australia, Canada, Switzerland, Czech Rep., Denmark, Euro Area, United Kingdom, Hungary, Indonesia, India, Japan, Korea, Mexico, Norway, New Zealand, Poland, Sweden, Thailand, Turkey, South Africa, Russia, Brazil, Colombia, Chile.

<span id="page-10-2"></span><sup>&</sup>lt;sup>2</sup>Romania, Iceland, Kenya, Israel, Tunisia, Morocco, and Pakistan.

<span id="page-11-0"></span>and statistically significant relationship with average excess returns. This confirms that both factors represent priced risks in the currency market.

|                 | Dependent variable:                                  |                                                         |
|-----------------|------------------------------------------------------|---------------------------------------------------------|
|                 | Excess Returns                                       |                                                         |
| (1)             | (2)                                                  | (3)                                                     |
|                 |                                                      | 0.136∗∗∗                                                |
|                 |                                                      | (0.037)                                                 |
|                 |                                                      | 0.076∗∗∗                                                |
|                 |                                                      | (0.021)                                                 |
|                 |                                                      | 0.003                                                   |
| (0.008)         | (0.003)                                              | (0.006)                                                 |
|                 |                                                      | 32                                                      |
|                 |                                                      | 0.585                                                   |
|                 |                                                      | 0.556                                                   |
| 0.021 (df = 30) | 0.018 (df = 30)                                      | 0.015 (df = 29)                                         |
|                 | 0.133∗∗∗<br>(0.051)<br>0.003<br>32<br>0.176<br>0.149 | 0.075∗∗∗<br>(0.023)<br>0.027∗∗∗<br>32<br>0.400<br>0.380 |

Table 1: Average excess returns vs component loadings

Data source: FX4Casts, Datastream. Left hand variable is the average monthly currency returns of 32 countries between 02/2003 - 11/2018. Right hand variables are the coefficients of each country for the two principal component of currency returns. Both components are scaled such that a positive coefficient means positive covariance with the returns.

Table [2](#page-12-1) demonstrates the time-series explanatory power of these factors for a selection of five countries. The high R<sup>2</sup> values for Turkey (0.599), Chile (0.460), Mexico (0.553), and the Euro Area (0.876) indicate that these two common factors drive a significant portion of currency return variation. The notable exception is Japan (R<sup>2</sup> = 0.097), whose currency is well-known to follow distinct safe-haven dynamics.

Finally, Table [3](#page-13-1) provides a clear economic interpretation for these abstract factors. We regress the Dollar Risk Factor (Component 1) and the Carry Trade Risk Factor (Component 2) on standard macro-financial variables. The results show that the Dollar Risk Factor (Col 1) is strongly and positively correlated with S&P 500 returns (1.533∗∗∗) and is not significantly related to changes in the VIX. his identifies it as a global equity factor. The Carry Trade Risk Factor (Col 2), in contrast, is not correlated with the S&P 500 but is significantly and negatively correlated with changes in the VIX (−0.085∗∗). This identifies the second factor as global risk aversion.

<span id="page-12-1"></span>

|                                | Dependent variable:                    |          |          |           |          |
|--------------------------------|----------------------------------------|----------|----------|-----------|----------|
|                                | Chile<br>Mexico<br>Euro Area<br>Turkey |          | Japan    |           |          |
|                                | (1)                                    | (2)      | (3)      | (4)       | (5)      |
| Dollar Risk Exposure           | 0.258∗∗∗                               | 0.167∗∗∗ | 0.167∗∗∗ | 0.191∗∗∗  | 0.035    |
|                                | (0.025)                                | (0.016)  | (0.014)  | (0.005)   | (0.028)  |
| Carry trade Risk Exposure      | 0.406∗∗∗                               | 0.118∗∗∗ | 0.156∗∗∗ | −0.219∗∗∗ | −0.130∗∗ |
|                                | (0.093)                                | (0.028)  | (0.041)  | (0.029)   | (0.051)  |
| Constant                       | 0.005∗∗                                | 0.003∗∗∗ | 0.001    | 0.0005    | −0.001   |
|                                | (0.002)                                | (0.001)  | (0.001)  | (0.001)   | (0.002)  |
| Observations                   | 190                                    | 190      | 190      | 190       | 190      |
| 2<br>R                         | 0.599                                  | 0.460    | 0.553    | 0.876     | 0.097    |
| Adjusted R2                    | 0.595                                  | 0.454    | 0.548    | 0.874     | 0.087    |
| Residual Std. Error (df = 187) | 0.033                                  | 0.024    | 0.021    | 0.010     | 0.027    |

Table 2: Excess returns vs Risk Factors

Data source: FX4Casts. Left hand variable is the returns of selected currencies between 02/2003 - 11/2018. Right hand variables are the two principal component of currency returns. Both components are scaled such that a positive coefficient means positive covariance with the returns.

## <span id="page-12-0"></span>**2.3 Determinants of Component Exposures**

In this Section, we aim to understand what determines a currency's exposure to these global risk factors. We consider several variables established in the literature as key determinants of excess currency returns and regress our estimated risk exposures on them (Table [4\)](#page-14-0).[3](#page-12-2)

The regression results presented in Table [4](#page-14-0) demonstrate that both risk factors are jointly determined by the economy's underlying financial and trade frictions.

Examining the Dollar Risk Factor (Columns 1 and 2), exposure is driven by a combination of financial leverage and trade invoicing practices. The ratio of foreign liabilities to foreign assets (FL/FA) in the banking system serves as a positive and significant predictor (0.043∗∗ in the full specification). This indicates that economies relying more heavily on foreign-currency funding exhibit greater vulnerability to the global financial cycle. Conversely, when controlling for these financial vulnerabilities, a higher share of dollar invoicing correlates with lower exposure to this specific risk factor, as evidenced by the

<span id="page-12-2"></span><sup>3</sup>External balance [\(Della Corte, Riddiough and Sarno](#page-52-3) [\(2016\)](#page-52-3)), foreign assets in the banking system [\(Yey](#page-55-1)[ati](#page-55-1) [\(2006\)](#page-55-1); [Christiano, Dalgic and Nurbekyan](#page-52-8) [\(2021\)](#page-52-8)), Dollar invoicing , country size [\(Hassan](#page-53-6) [\(2013\)](#page-53-6)) and trade network centrality [\(Richmond](#page-54-7) [\(2019\)](#page-54-7)). In Appendix Section [A,](#page-56-0) we verify that these determinants also explain average currency returns directly.

<span id="page-13-1"></span>

|                                | Dependent variable:        |           |  |
|--------------------------------|----------------------------|-----------|--|
|                                | Component 1<br>Component 2 |           |  |
|                                | (1)                        | (2)       |  |
| S&P 500 Returns                | 1.533∗∗∗                   | −0.080    |  |
|                                | (0.341)                    | (0.110)   |  |
| ∆log(VIX)                      | −0.070                     | −0.085∗∗∗ |  |
|                                | (0.053)                    | (0.032)   |  |
| ∆GFC                           | −0.013                     | 0.001     |  |
|                                | (0.009)                    | (0.004)   |  |
| Observations                   | 190                        | 190       |  |
| 2<br>R                         | 0.306                      | 0.045     |  |
| Adjusted R2                    | 0.299                      | 0.035     |  |
| Residual Std. Error (df = 187) | 0.105                      | 0.058     |  |

Table 3: Risk Factors

Data source: FX4Casts, Ken French dataset, CBOE. Right hand variables are the two principal components of currency returns of 25 countries between 02/2003 - 11/2018. Left hand variables are the returns of S&P500 and log change in VIX index.

significant negative coefficient (−0.095∗∗).

The dynamics differ when evaluating the Carry Trade Risk Factor (Columns 3 and 4), though exposure remains anchored by both trade and financial variables. In this case, the dollar invoicing share emerges as the strongest predictor, yielding a positive and highly significant coefficient (0.457∗∗∗). This implies that the currencies of high-invoicing countries are notably more exposed to global risk-off shocks, a pattern consistent with carry trade dynamics. Furthermore, financial structure continues to play a role: net debtor countries, indicated by a lower Net Foreign Assets to GDP ratio, show significantly higher exposure to the Carry Trade factor in the baseline specification (−0.190∗∗∗).

Ultimately, these estimates confirm that observable frictions—specifically dollar-denominated debt and dollar invoicing—jointly shape an economy's vulnerability to global shocks. This observation directly motivates the frictions we integrate into our theoretical model.

## <span id="page-13-0"></span>**2.4 Comovement between GDP and Exchange Rate**

We measure the cyclical co-movement between the economy and the exchange rate by calculating, for each country, the correlation between log real GDP growth and log real exchange rate changes. The real exchange rate (RER) is defined as the nominal dollar

<span id="page-14-0"></span>

|                        | Dependent variable:  |                |                     |                |
|------------------------|----------------------|----------------|---------------------|----------------|
|                        | Dollar Risk Exposure |                | Carry Risk Exposure |                |
|                        | (1)                  | (2)            | (3)                 | (4)            |
| FL/FA                  | 0.035∗               | 0.043∗∗        | 0.016               | 0.037          |
|                        | (0.018)              | (0.019)        | (0.030)             | (0.059)        |
| Net Foreign Assets/GDP | −0.029               | −0.049         | −0.190∗∗∗           | −0.090         |
|                        | (0.029)              | (0.032)        | (0.071)             | (0.060)        |
| Reserves/GDP           | −0.079               | −0.161         | −0.157              | −0.384         |
|                        | (0.219)              | (0.138)        | (0.330)             | (0.360)        |
| Dollar Invoicing       | −0.098∗∗             | −0.095∗∗       | 0.490∗∗∗            | 0.457∗∗∗       |
|                        | (0.043)              | (0.040)        | (0.086)             | (0.075)        |
| GDP(Nominal USD)       | 0.006                |                | 0.018               |                |
|                        | (0.018)              |                | (0.026)             |                |
| Average Centrality     |                      | −6.345         |                     | −7.729         |
|                        |                      | (10.384)       |                     | (14.102)       |
| Constant               | 0.213∗∗∗             | 0.228∗∗∗       | −0.285∗∗∗           | −0.280∗∗       |
|                        | (0.053)              | (0.076)        | (0.088)             | (0.119)        |
| Observations           | 20                   | 14             | 20                  | 14             |
| 2<br>R                 | 0.496                | 0.743          | 0.615               | 0.533          |
| Adjusted R2            | 0.316                | 0.582          | 0.477               | 0.242          |
| Residual Std. Error    | 0.063 (df = 14)      | 0.047 (df = 8) | 0.154 (df = 14)     | 0.167 (df = 8) |

Table 4: Determinants of Exposures

Data source: IFS, Datastream, FX4Casts, [Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-Møller](#page-53-2) [\(2020\)](#page-53-2), [Richmond](#page-54-7) [\(2019\)](#page-54-7), Ken French dataset. Risk factors are the two principal components of currency returns of 25 countries between 02/2003 - 11/2018. FL/FA denotes the ratio of foreign liabilities to foreign assets in the banking system.

exchange rate divided by CPI (St/Pt). This correlation, ρ, is estimated via the following regression of standardized variables:

$$\frac{\Delta \log(GDP_t)}{\sigma_{\Delta \log(GDP)}} = \alpha + \rho \frac{\Delta \log(S_t/P_t)}{\sigma_{\Delta \log(S/P)}} + \epsilon_t$$

The estimate ρˆcorresponds to the correlation coefficient. This approach is well-suited for our dataset, as countries have widely different volatilities in GDP growth and exchange rates, and the correlation coefficient suitably scales the variables by their respective standard deviations. Another benefit is that the correlation is direction-invariant, meaning which variable is used as the left-hand-side variable does not change the estimate. We do not claim any causality here; the correlation coefficient is simply our appropriate measure for co-movement.

A negative correlation (ρ < 0) is the core of our risk mechanism. It indicates that the currency depreciates (loses value) precisely when the economy is in recession (when income is low). This makes the local currency a poor hedge and thus "risky" from the perspective of local residents. In these economies, dollar assets provide better insurance against business cycle fluctuations, lowering the relative demand for local currency assets. Consequently, local residents demand a risk premium—in the form of higher expected returns—to hold local currency assets [\(Christiano, Dalgic and Nurbekyan](#page-52-8) [\(2021\)](#page-52-8); [Dalgic](#page-52-9) [\(2024\)](#page-52-9)).

Figure [2](#page-15-0) tests this hypothesis directly. The plot of average excess returns against the GDP-ER correlation reveals a strong, negative relationship (R² = 0.172). This visually confirms our mechanism: countries with a more negative correlation (e.g., Brazil, Turkey, Chile, Peru) are precisely those with riskier currencies, and investors are, on average, compensated with significantly higher excess returns. Conversely, countries with a positive correlation (e.g., Japan, Switzerland, Denmark), where the currency acts as a hedge, have near-zero or negative excess returns.

<span id="page-15-0"></span>![](_page_15_Figure_2.jpeg)

Figure 2: GDP-ER Comovement and excess returns

Data source: FX4Casts, IMF IFS. Y-axis variable is the average currency return of 25 countries between 02/2003 - 11/2018. X-axis variable is comovement between GDP and Exchange Rate

## <span id="page-16-0"></span>**2.5 Macroeconomic Transmission Channel**

This section explores the mechanism through which dollar frictions shape a country's risk profile. A key determinant of currency risk is the cyclical co-movement between GDP and the exchange rate [\(Dalgic](#page-52-9) [\(2024\)](#page-52-9)). When this co-movement is negative—meaning the currency depreciates during domestic recessions—the currency loses value when income is lowest, making it a poor hedge and "risky" for an investor.

We test the drivers of this co-movement in Table [5.](#page-16-1) The regression results show that our proposed dollar frictions are significant determinants of this relationship. Dollar Invoicing has a negative and highly significant coefficient (−0.396∗∗∗), confirming that a higher share of dollar invoicing is strongly associated with a more countercyclical exchange rate (a more negative correlation). Similarly, net foreign assets/GDP has a significant positive coefficient (0.203∗∗). This indicates that being a net debtor (having a low or negative NFA/GDP) is associated with a significantly more negative GDP-ER correlation.

<span id="page-16-1"></span>

|                        | Dependent variable:         |
|------------------------|-----------------------------|
|                        | GDP-ER Correlation          |
| Dollar Invoicing       | −0.396∗∗∗                   |
|                        | (0.138)                     |
| FL/FA                  | −0.033                      |
|                        | (0.030)                     |
| Net Foreign Assets/GDP | 0.203∗∗                     |
|                        | (0.093)                     |
| Constant               | −0.023                      |
|                        | (0.149)                     |
| Observations           | 19                          |
| 2<br>R                 | 0.430                       |
| Adjusted R2            | 0.316                       |
| Residual Std. Error    | 0.194 (df = 15)             |
| Note:                  | ∗p<0.1; ∗∗p<0.05; ∗∗∗p<0.01 |

Table 5: The Role of Dollar Frictions in GDP-Exchange Rate Co-movement Data source: IFS, Datastream, FX4Casts, [Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-Møller](#page-53-2) [\(2020\)](#page-53-2)

Thus, the evidence shows that both high dollar invoicing and a net debtor position make the exchange rate fundamentally riskier.

## <span id="page-17-0"></span>**2.6 Currency Return Expectations**

In this section, we construct a measure of expected returns using quarterly exchange rate expectations from FX4Casts. Our sample spans the period 2003Q1-2018Q4. This dataset has been used by [Ince and Molodtsova](#page-53-11) [\(2017\)](#page-53-11) to evaluate forecast accuracy and by [Kalemli-Özcan and Varela](#page-54-8) [\(2021\)](#page-54-8) to construct UIP premium series.

We define the expected excess currency return (EtUIPt) as:

$$\mathbb{E}_t UIP_t = R_t^L \frac{S_t}{\mathbb{E}_t \left( S_{t+1} \right)} - R_t^{US} \tag{2}$$

where EtSt+1 is the one-quarter-ahead professional forecast for the spot rate.

Similar to our analysis of realized returns, we apply principal component analysis (PCA) to the panel of expected currency returns to extract common factors. We then test if these factors price the cross-section of expected returns.

Table [6](#page-18-0) presents the results from regressing average expected excess returns on the loadings for the first two factors. Column (3) shows that while the "Dollar Risk Factor" loading is not statistically significant, the "Carry Trade Risk Factor" loading is. The coefficient is positive and highly significant (+0.031∗∗∗). This finding indicates that, according to these professional forecasts, currencies with a higher exposure to the carry trade risk factor are associated with higher average expected returns, consistent with investors demanding a premium for bearing this risk.

## **3 Model**

The empirical evidence points to a joint role for trade invoicing and balance-sheet structure in shaping currency risk. Countries with high dollar invoicing tend to have currencies that are more exposed to global risk factors and more countercyclical with respect to output. These same economies also tend to display persistently higher inflation. To rationalize these patterns, we use a small open-economy New Keynesian model with dominant-currency pricing in trade, foreign-currency borrowing by financial intermediaries, and segmented international asset markets.

Two mechanisms are central. First, export prices are set in dollars. The parameter θ<sup>x</sup> denotes the Calvo probability that an export-price setter cannot adjust its dollar price

<span id="page-18-0"></span>Table 6: Average forecasted excess returns vs component loadings

|                         | Dependent variable:                                   |          |          |  |
|-------------------------|-------------------------------------------------------|----------|----------|--|
|                         | Forecasted Excess Returns                             |          |          |  |
|                         | (1)                                                   | (2)      | (3)      |  |
| Dollar Risk Factor      | 0.008                                                 |          | −0.007   |  |
|                         | (0.011)                                               |          | (0.008)  |  |
| Carry Trade Risk Factor |                                                       | 0.028∗∗∗ | 0.031∗∗∗ |  |
|                         |                                                       | (0.005)  | (0.005)  |  |
| Constant                | 0.009∗∗∗                                              | 0.005∗∗∗ | 0.004∗∗  |  |
|                         | (0.002)                                               | (0.001)  | (0.002)  |  |
| Observations            | 26                                                    | 26       | 26       |  |
| 2<br>R                  | 0.028                                                 | 0.467    | 0.484    |  |
| Adjusted R2             | −0.012                                                | 0.445    | 0.439    |  |
| Residual Std. Error     | 0.007 (df = 24)<br>0.006 (df = 24)<br>0.006 (df = 23) |          |          |  |

Data source: FX4Casts, Ken French dataset, CBOE. Left hand variables are the two principal components of currency returns of 26 countries between 02/2003 - 11/2018. Right hand variable is the average forecasted excess returns.

in a given period. When θ<sup>x</sup> is high, export dollar prices are sticky, so a depreciation does not quickly lower the dollar price paid by foreign buyers. The usual expenditureswitching channel is therefore weak.[4](#page-18-1) Second, the domestic banking system borrows in both local currency and dollars. The variable ϕ<sup>t</sup> denotes the share of bank liabilities denominated in dollars, and ϕ¯ is the target dollar-liability share. When ϕ<sup>t</sup> is high, a depreciation raises the local-currency value of dollar liabilities, reduces intermediary net worth, and tightens credit.

The interaction of these two frictions determines whether a depreciation is stabilizing or contractionary. With flexible export prices and little dollar debt, a depreciation can support exports and absorb foreign shocks. With sticky dollar export prices and high dollar debt, the depreciation fails to generate a quick export response while simultaneously weakening bank balance sheets. In that case, local-currency assets pay off badly in bad states, and investors require an endogenous risk premium to hold them. We now turn to the model that formalizes this mechanism.

<span id="page-18-1"></span><sup>4</sup>[McLeay and Tenreyro](#page-54-12) [\(2025\)](#page-54-12) show that dominant-currency pricing need not dampen the expenditureswitching channel when export prices are flexible. Since our analysis focuses on manufactured tradable goods rather than commodities, the assumption of sticky prices is more applicable in our setting.

#### 3.1 Households

A representative household consumes  $C_t$ , supplies labor  $l_t$ , and saves in one-period local-currency and dollar deposits. The nominal exchange rate is  $S_t$ , measured as local currency per dollar, so an increase in  $S_t$  is a depreciation. The gross local-currency interest rate is  $R_t$ , and the gross dollar interest rate is  $R_t^*$ . Household preferences are

$$\mathbb{E}_0 \sum_{t=0}^{\infty} \beta^t \left[ u(C_t) - \xi \frac{l_t^{1+\varphi_l}}{1+\varphi_l} - \frac{\gamma_{\Theta}}{2} (\Theta_t - \Upsilon_t)^2 \right]. \tag{3}$$

The parameter  $\beta$  is the discount factor,  $\varphi_l$  is the inverse Frisch elasticity, and  $\xi$  governs the disutility of labor. As it will be clearer, the utility from consumption is in CRRA form with relative risk aversion,  $\sigma$ . The variable  $\Theta_t$  is the household dollar-asset share, while  $\Upsilon_t$  is its preferred or target dollar-asset share. The last term captures a preferred-habitat motive: households can change their currency exposure, but it is costly to move far away from the target.

The household budget constraint is

$$D_t + S_t D_t^* + P_t^c C_t = R_{t-1} D_{t-1} + S_t R_{t-1}^* D_{t-1}^* + W_t l_t + T_t.$$

$$\tag{4}$$

Here  $D_t$  is local-currency deposits,  $D_t^*$  is dollar deposits,  $P_t^c$  is the consumer price index,  $W_t$  is the nominal wage, and  $T_t$  denotes transfers and profits rebated to the household.

Let CPI inflation be  $\Pi_{t+1}^c \equiv P_{t+1}^c/P_t^c$ . The real stochastic discount factor is

$$m_{t+1} \equiv \beta \frac{u_C(C_{t+1})}{u_C(C_t)} \frac{1}{\prod_{t+1}^c}.$$
 (5)

Household optimality implies the pure local-currency and pure dollar Euler equations

$$1 = R_t \mathbb{E}_t[m_{t+1}],\tag{6}$$

$$1 = R_t^* \mathbb{E}_t \left[ m_{t+1} \frac{S_{t+1}}{S_t} \right]. \tag{7}$$

The first equation prices a one-period local-currency payoff. The second prices a one-period dollar payoff after converting next period's dollar repayment back into local currency. Because  $S_{t+1}/S_t$  is high when the domestic currency depreciates, dollar assets are valuable insurance when depreciations occur in bad states.

The intratemporal labor condition is

$$\frac{W_t}{P_t^c} = \frac{\xi l_t^{\varphi_l}}{u_C(C_t)}.$$
(8)

The real wage equals the marginal rate of substitution between labor and consumption. Higher marginal utility of consumption raises the value of income and therefore raises desired labor supply for a given real wage.

If total real household savings are denoted by  $A_t$ , and  $s_{t+1} \equiv S_{t+1}/S_t$  is the gross depreciation rate, the household portfolio-share condition can be written as

$$\gamma_{\Theta}(\Theta_t - \Upsilon_t) = \beta A_t \mathbb{E}_t \left[ \frac{u_C(C_{t+1})}{\Pi_{t+1}^c} \left( R_t - s_{t+1} R_t^* \right) \right]. \tag{9}$$

The left-hand side is the marginal cost of moving the portfolio away from the target dollar share. The right-hand side is the expected marginal value of changing the currency composition of savings. When dollar assets hedge bad states, the term involving  $s_{t+1}R_t^*$  becomes attractive and households tilt toward dollar assets.

## 3.2 Domestic Production and Price Setting

The domestic homogeneous good  $Y_t$  is produced by a competitive aggregator using differentiated intermediate varieties  $Y_{i,t}$ :

$$Y_t = \left[ \int_0^1 Y_{i,t}^{\frac{\varepsilon - 1}{\varepsilon}} i \right]^{\frac{\varepsilon}{\varepsilon - 1}}, \qquad \varepsilon > 1.$$
 (10)

The elasticity of substitution across varieties is  $\varepsilon$ . Cost minimization gives

$$Y_{i,t} = Y_t \left(\frac{P_{i,t}}{P_t}\right)^{-\varepsilon},\tag{11}$$

$$P_t = \left[ \int_0^1 P_{i,t}^{1-\varepsilon} i \right]^{\frac{1}{1-\varepsilon}},\tag{12}$$

where  $P_t$  is the domestic-good price index. A firm that charges a higher relative price sells less, and the elasticity  $\varepsilon$  determines how sensitive demand is to relative prices.

The domestic homogeneous good is used as an input in final consumption, investment,

and export production. Its market-clearing condition is

$$Y_t = C_t^d + I_t^d + X_t^d, (13)$$

where C d t , I d t , and X<sup>d</sup> <sup>t</sup> are the domestic inputs used in consumption, investment, and exports.

Intermediate firms produce with capital and labor according to

$$Y_{i,t} = K_{i,t-1}^{\alpha} (A_t l_{i,t})^{1-\alpha}, \tag{14}$$

where Ki,t−<sup>1</sup> is predetermined capital, A<sup>t</sup> is technology, and α is capital's share. Let mc<sup>t</sup> denote real marginal cost in units of the domestic good. Domestic intermediate firms face Calvo price stickiness: with probability 1 − θ<sup>p</sup> a firm can reset its price, and with probability θ<sup>p</sup> it keeps its previous price.

The optimal reset price is summarized by

<span id="page-21-1"></span><span id="page-21-0"></span>
$$\widetilde{p}_t \equiv \frac{\widetilde{P}_t}{P_t} = \frac{\mathcal{K}_t^p}{\mathcal{F}_t^p},\tag{15}$$

where <sup>P</sup>e<sup>t</sup> is the newly chosen nominal price, and the two pricing sums satisfy

$$\mathcal{K}_{t}^{p} = \frac{u_{C}(C_{t})}{P_{t}^{c}} Y_{t} \frac{\varepsilon}{\varepsilon - 1} m c_{t} + \beta \theta_{p} \mathbb{E}_{t} \left[ (\Pi_{t+1})^{\varepsilon} \mathcal{K}_{t+1}^{p} \right], \tag{16}$$

$$\mathcal{F}_t^p = \frac{u_C(C_t)}{P_t^c} Y_t + \beta \theta_p \mathbb{E}_t \left[ (\Pi_{t+1})^{\varepsilon - 1} \mathcal{F}_{t+1}^p \right], \tag{17}$$

with Πt+1 ≡ Pt+1/P<sup>t</sup> . The numerator K p t is the discounted value of expected marginal costs, adjusted for the desired markup ε/(ε − 1). The denominator F p t is the discounted value of expected demand. A firm chooses a price that balances today's markup against the possibility that the same price remains in place in future periods.

## **3.3 Final Consumption and Investment Goods**

Final consumption combines domestic goods and imported goods:

$$C_t = \left[ (1 - \omega_c)^{1/\eta_c} (C_t^d)^{\frac{\eta_c - 1}{\eta_c}} + \omega_c^{1/\eta_c} (C_t^m)^{\frac{\eta_c - 1}{\eta_c}} \right]^{\frac{\eta_c}{\eta_c - 1}}.$$
 (18)

The parameter ω<sup>c</sup> is the import share in consumption, while η<sup>c</sup> is the elasticity of substitution between domestic and imported consumption goods. The associated CPI is

$$P_t^c = \left[ (1 - \omega_c) P_t^{1 - \eta_c} + \omega_c (P_t^m)^{1 - \eta_c} \right]^{\frac{1}{1 - \eta_c}}, \qquad P_t^m = S_t P_t^f. \tag{19}$$

Imported goods are priced in dollars at P f t , so their local-currency price is P m <sup>t</sup> = StP f t . Thus, a depreciation directly raises the local-currency price of imports. When η<sup>c</sup> is low, households cannot easily substitute away from imported goods, so the depreciation sharply raises the CPI and reduces real purchasing power.

The implied input demands are

$$C_t^d = (1 - \omega_c) \left(\frac{P_t}{P_t^c}\right)^{-\eta_c} C_t, \tag{20}$$

$$C_t^m = \omega_c \left(\frac{P_t^m}{P_t^c}\right)^{-\eta_c} C_t. \tag{21}$$

These equations show that expenditure shifts toward the input whose relative price falls, with the strength of substitution governed by ηc.

Final investment is produced analogously from domestic and imported investment inputs:

$$I_t = \left[ \gamma_I^{1/\nu_I} (I_t^d)^{\frac{\nu_I - 1}{\nu_I}} + (1 - \gamma_I)^{1/\nu_I} (I_t^m)^{\frac{\nu_I - 1}{\nu_I}} \right]^{\frac{\nu_I}{\nu_I - 1}}.$$
 (22)

Here γ<sup>I</sup> is the domestic share in investment and ν<sup>I</sup> is the substitution elasticity between domestic and imported investment inputs. Capital evolves according to

$$K_t = (1 - \delta)K_{t-1} + \left[1 - \mathcal{S}\left(\frac{I_t}{I_{t-1}}\right)\right]I_t,\tag{23}$$

where δ is depreciation and S(·) is an investment adjustment-cost function. Because investment uses imported inputs, exchange-rate movements affect the cost of building capital. Adjustment costs then make the investment response gradual rather than instantaneous.

#### 3.4 Exports and Dominant-Currency Pricing

Final exports combine a domestic export input  $X_t^d$  and an imported input  $X_t^m$ :

$$X_{t} = \left[ \gamma_{x}^{1/\eta_{x}} (X_{t}^{d})^{\frac{\eta_{x}-1}{\eta_{x}}} + (1 - \gamma_{x})^{1/\eta_{x}} (X_{t}^{m})^{\frac{\eta_{x}-1}{\eta_{x}}} \right]^{\frac{\eta_{x}}{\eta_{x}-1}}.$$
 (24)

The parameter  $\gamma_x$  is the domestic-input share in exports, and  $\eta_x$  is the substitution elasticity between domestic and imported export inputs. Foreign demand for the final export good is

$$X_t = \left(\frac{P_t^x}{P_t^f}\right)^{-\eta_f} Y_t^*,\tag{25}$$

where  $P_t^x$  is the dollar price of the final export good,  $P_t^f$  is the dollar price of foreign goods,  $Y_t^*$  is foreign demand, and  $\eta_f$  is the foreign demand elasticity.

The domestic export input is assembled from differentiated export varieties:

$$X_t^d = \left[ \int_0^1 X_{i,t}^{\frac{\varepsilon_x - 1}{\varepsilon_x}} i \right]^{\frac{\varepsilon_x}{\varepsilon_x - 1}}, \tag{26}$$

$$X_{i,t} = X_t^d \left(\frac{P_{i,t}^{d,x}}{P_t^{d,x}}\right)^{-\varepsilon_x},\tag{27}$$

$$P_t^{d,x} = \left[ \int_0^1 (P_{i,t}^{d,x})^{1-\varepsilon_x} i \right]^{\frac{1}{1-\varepsilon_x}}.$$
 (28)

The key feature is that  $P_{i,t}^{d,x}$  is set in dollars. Export-input producers face Calvo stickiness in dollar prices: with probability  $1-\theta_x$  a firm resets its dollar price, and with probability  $\theta_x$  it keeps the previous dollar price.

A resetting exporter chooses the relative dollar price

$$\widetilde{p}_t^{d,x} \equiv \frac{\widetilde{P}_t^{d,x}}{P_t^{d,x}} = \frac{\mathcal{K}_t^x}{\mathcal{F}_t^x},\tag{29}$$

where  $\mathcal{K}_t^x$  and  $\mathcal{F}_t^x$  are the export-sector analogues of the domestic Calvo pricing sums. The export price index evolves as

$$(P_t^{d,x})^{1-\varepsilon_x} = (1-\theta_x)(\widetilde{P}_t^{d,x})^{1-\varepsilon_x} + \theta_x(P_{t-1}^{d,x})^{1-\varepsilon_x}.$$
(30)

This block is where dominant-currency pricing enters the model. If  $\theta_x=0$ , firms reset

their dollar prices every period. A depreciation then lowers the dollar price implied by domestic costs and supports export demand. If  $\theta_x$  is high, export dollar prices barely move on impact. The depreciation improves competitiveness only slowly, so the trade balance cannot adjust through a rapid expansion of exports.

#### 3.5 Bankers and Financial Intermediation

Banks intermediate between savers and firms. They borrow from households and foreign financiers in local currency and dollars, purchase claims on capital, and earn the gross return  $R_{t+1}^k$ . Let  $N_{j,t}$  be bank j's net worth,  $Q_t$  the price of capital, and  $A_{j,t}$  the quantity of capital claims held by the bank. End-of-period net worth is

$$N_{j,t+1} = R_{t+1}^k Q_t \mathcal{A}_{j,t} - R_t B_{j,t}^{LC} - R_t^* \frac{S_{t+1}}{S_t} B_{j,t}^{FC}.$$
(31)

The term  $B_{j,t}^{LC}$  is local-currency borrowing and  $B_{j,t}^{FC}$  is dollar borrowing, measured in local-currency units at time t. A depreciation raises  $S_{t+1}/S_t$ , increasing the local-currency burden of dollar debt and reducing bank net worth.

The bank's dollar-liability share is  $\phi_{j,t}$ . Leverage is allowed to differ by funding currency:

$$B_{j,t}^{FC} = (L_{j,t}^{FC} - 1)\phi_{j,t}N_{j,t},$$
(32)

$$B_{i,t}^{LC} = (L_{i,t}^{LC} - 1)(1 - \phi_{i,t})N_{i,t}.$$
(33)

Using these definitions, the growth rate of bank net worth can be written as

$$\frac{N_{j,t+1}}{N_{j,t}} = L_{j,t}^{LC} (1 - \phi_{j,t}) (R_{t+1}^k - R_t) + L_{j,t}^{FC} \phi_{j,t} \left( R_{t+1}^k - R_t^* \frac{S_{t+1}}{S_t} \right) + (1 - \phi_{j,t}) R_t + \phi_{j,t} R_t^* \frac{S_{t+1}}{S_t}.$$
(34)

This expression isolates the balance-sheet channel. Local-currency borrowing exposes the bank to the spread between the capital return and the local funding rate. Dollar borrowing adds exchange-rate risk because the funding cost is multiplied by  $S_{t+1}/S_t$ .

Bankers survive with probability θb. Their value is

$$V_{j,t} = \mathbb{E}_t \sum_{i=0}^{\infty} (1 - \theta_b) \theta_b^i \beta^{i+1} \Lambda_{t,t+i+1} N_{j,t+i+1},$$
(35)

where Λt,t+i+1 is the household discount factor between dates t and t+i+1. Recursively,

$$V_{j,t} = \mathbb{E}_t \left[ \beta (1 - \theta_b) N_{j,t+1} + \beta \theta_b \Lambda_{t,t+1} V_{j,t+1} \right]. \tag{36}$$

Banks are subject to an incentive constraint. If a banker can divert a fraction λ<sup>b</sup> of assets, lenders provide funds only if the continuation value of banking is large enough. For funding currency k ∈ {LC, F C}, define the value per unit of allocated net worth as ψ k <sup>t</sup> ≡ V k t /N<sup>k</sup> t . When the incentive constraint binds,

$$\psi_t^k = \lambda_b L_t^k. (37)$$

Solving the banker problem gives leverage as

$$L_t^{FC} = \frac{\nu_t^{FC}}{\lambda_b - \eta_t^{FC}},\tag{38}$$

$$L_t^{LC} = \frac{\nu_t^{LC}}{\lambda_b - \eta_t^{LC}}. (39)$$

The objects η k <sup>t</sup> and ν k <sup>t</sup> are discounted continuation-value terms. The first captures the value of levered excess returns, while the second captures the value of the unlevered funding return. A higher continuation value relaxes the effective leverage constraint, whereas greater exchange-rate risk in dollar funding makes foreign-currency leverage more fragile.

The bank also chooses the currency composition of liabilities. Its dollar share solves

$$\max_{\phi_t} (1 - \phi_t) \psi_t^{LC} + \phi_t \psi_t^{FC} - \frac{\chi_\phi}{2} (\phi_t - \bar{\phi})^2, \tag{40}$$

where χ<sup>ϕ</sup> is the cost of deviating from the target dollar-liability share ϕ¯. The first-order condition is

$$\psi_t^{FC} - \psi_t^{LC} = \chi_\phi(\phi_t - \bar{\phi}). \tag{41}$$

Using  $\psi_t^k = \lambda_b L_t^k$ , this becomes

$$\phi_t - \bar{\phi} = \frac{\lambda_b}{\chi_\phi} (L_t^{FC} - L_t^{LC}). \tag{42}$$

Thus banks shift toward dollar liabilities when the value of foreign-currency funding rises relative to local-currency funding. The quadratic term prevents the currency composition from jumping costlessly to a corner.

In many small open economies, banks are not allowed by regulation to hold currency mismatch on their balance sheets Christiano, Dalgic and Nurbekyan (2021). In the model, we are following Gertler and Karadi (2011) to assume banks are residual claimants to firms so  $\phi$  should be interpreted as combine financial & non-financial currency mismatch.

## 3.6 Foreign Financiers and Financial Market Clearing

Foreign financiers borrow in dollars and lend to the domestic economy in local currency. Let  $B_t^*$  be the dollar amount they invest in local-currency assets, and let  $B_t^F \equiv S_t B_t^*$  denote its local-currency value. Following the segmented-market logic, their supply of local-currency lending is upward sloping in expected excess returns and downward sloping in exchange-rate risk:

<span id="page-26-0"></span>
$$B_t^* - \bar{B}^* = \frac{\mathbb{E}_t^j \left( R_t \frac{S_t}{S_{t+1}} \right) - R_t^*}{\lambda_f \left( \text{Var}_t(s_{t+1}) \right)}. \tag{43}$$

Here  $\lambda_f(\operatorname{Var}_t(s_{t+1}))$  is increasing in exchange-rate risk. Foreigners require a larger expected return to hold more local-currency assets, especially when the exchange rate is volatile.

Local-currency and dollar financial markets clear according to

$$B_t^F + D_t = B_t^{LC}, (44)$$

$$B_t^{F,*} + D_t^* = B_t^{FC}. (45)$$

The first condition says that bank local-currency borrowing is funded by household local-currency deposits and foreign local-currency lending. The second says that bank dollar borrowing is funded by domestic and foreign dollar positions.

## **3.7 Balance of Payments**

The home economy's net foreign asset position is

$$NFA_t = -\left(B_t^F + B_t^{F,*}\right). (46)$$

Net exports must equal the change in this position after interest payments:

$$X_{t} - M_{t} = -\left(B_{t}^{F,*} - R_{t-1}^{*} \frac{S_{t}}{S_{t-1}} B_{t-1}^{F,*}\right) - \left(B_{t}^{F} - R_{t-1} B_{t-1}^{F}\right). \tag{47}$$

This identity is central to the model. If the economy loses external financing or must repay more because dollar liabilities become expensive, the external adjustment must occur through higher exports, lower imports, a larger depreciation, or some combination of all three. Dominant-currency pricing makes the export margin slow, so adjustment is pushed toward import compression and a sharper depreciation.

## **3.8 Monetary Policy and Shocks**

The central bank follows an inertial Taylor rule:

<span id="page-27-0"></span>
$$\log\left(\frac{R_t}{\bar{R}}\right) = \rho_R \log\left(\frac{R_{t-1}}{\bar{R}}\right) + r_\pi \log\left(\frac{\pi_t}{\bar{\pi}}\right) + r_y \log\left(\frac{y_t}{\bar{y}}\right) + \varepsilon_{R,t}.$$
 (48)

The coefficients r<sup>π</sup> and r<sup>y</sup> govern the response to inflation and output, and ρ<sup>R</sup> captures interest-rate smoothing. The target is domestic-good inflation rather than CPI inflation. Holding this rule fixed across calibrations isolates how changes in invoicing and balance-sheet structure alter equilibrium inflation and spreads.

The foreign interest rate follows

$$R_t^* = (1 - \rho_{R^*})\bar{R}^* + \rho_{R^*}R_{t-1}^* + \sigma_{R^*}\varepsilon_{R^*,t}.$$
(49)

Foreign monetary conditions also affect export demand:

$$Y_t^* = (1 - \rho_{Y^*})\bar{Y}^* + \rho_{Y^*}Y_{t-1}^* + \gamma_R(R_t^* - \bar{R}^*) + \sigma_{Y^*}\varepsilon_{Y^*,t}.$$
(50)

Thus a foreign tightening works through both financial and trade channels: it raises dollar funding costs and can reduce external demand.

## <span id="page-28-0"></span>**4 Dollar Liabilities, Export-Price Stickiness, and Deviations from UIP**

This section derives the model's core pricing mechanism. The object of interest is the unconditional premium required to hold local-currency assets. This premium is distinct from the conditional funding wedge that enters the bank's currency-choice problem. The conditional wedge measures the relative value of local- and foreign-currency funding to intermediaries. The unconditional premium instead depends on the covariance between depreciation and the pricing kernel relevant for valuing currency payoffs.

The mechanism has two components. Dollar liabilities determine how strongly bank net worth falls when the domestic currency depreciates. Sticky dollar export prices determine how much stabilization the exchange rate provides on the real side of the economy. When export prices adjust slowly in dollars, a depreciation does not quickly lower the price faced by foreign buyers, so the export response is delayed. The exchange rate must then move more, and domestic absorption must adjust more, to satisfy external balance. In the presence of dollar liabilities, this larger depreciation also raises the local-currency value of bank debt, reduces net worth, and raises the continuation value of intermediary wealth. The unconditional premium rises because local-currency assets pay poorly relative to dollar assets in precisely the states in which the banker-weighted stochastic discount factor is high.

Let

$$s_{t+1} \equiv \frac{S_{t+1}}{S_t} \tag{51}$$

denote gross depreciation of the domestic currency. A higher value of st+1 corresponds to a weaker domestic currency. The simple local-currency premium, in domestic-return units, is

$$p_t^{LC} \equiv R_t - R_t^* \mathbb{E}_t s_{t+1}. \tag{52}$$

This is the expected excess return on a local-currency payoff relative to a dollar payoff, abstracting from the stochastic discounting of payoffs across states.

Banks value payoffs using a banker-weighted stochastic discount factor. For funding currency k ∈ {LC, F C}, define

$$\mathcal{M}_{t+1}^k \equiv \beta \Lambda_{t,t+1} \Omega_{t+1}^k, \tag{53}$$

where βΛt,t+1 is the household stochastic discount factor and Ω k <sup>t</sup>+1 is the continuationvalue component of bank net worth under funding currency k. The continuation value is high when intermediary net worth is scarce and the incentive constraint is tight. Hence M<sup>k</sup> <sup>t</sup>+1 gives high weight to states in which households value resources highly and banks are financially constrained.

The bank-valued funding wedge is

<span id="page-29-3"></span>
$$\mathcal{U}_t^B \equiv \nu_t^{LC} - \nu_t^{FC} = \mathbb{E}_t \left[ \mathcal{M}_{t+1}^{LC} R_t \right] - \mathbb{E}_t \left[ \mathcal{M}_{t+1}^{FC} R_t^* s_{t+1} \right]. \tag{54}$$

This object is the stochastic-discount-factor-weighted value of local-currency funding relative to dollar funding. It is the wedge that enters the bank's currency-composition decision.

Banks choose the dollar share of liabilities, ϕ<sup>t</sup> , subject to a quadratic cost of deviating from a reference dollar-liability share ϕ¯. The currency-choice condition is

<span id="page-29-0"></span>
$$\psi_t^{FC} - \psi_t^{LC} = \chi_\phi(\phi_t - \bar{\phi}),\tag{55}$$

where ψ k t is the value of funding in currency k, and χ<sup>ϕ</sup> > 0 governs the cost of changing the currency composition of liabilities. When the incentive constraint binds,

<span id="page-29-1"></span>
$$\psi_t^k = \lambda_b L_t^k, \qquad k \in \{LC, FC\}. \tag{56}$$

Combining [\(55\)](#page-29-0) and [\(56\)](#page-29-1) gives

<span id="page-29-2"></span>
$$L_t^{FC} - L_t^{LC} = \frac{\chi_\phi}{\lambda_b} (\phi_t - \bar{\phi}). \tag{57}$$

Thus, deviations of ϕ<sup>t</sup> from ϕ¯ summarize the bank's revealed leverage advantage from dollar funding.

The leverage associated with funding currency k is

$$L_t^k = \frac{\nu_t^k}{\lambda_b - \eta_t^k}, \qquad k \in \{LC, FC\},$$
(58)

where ν k t is the value of the unlevered funding return and η k t is the continuation-value component associated with levered excess returns. Around a symmetric reference point with common leverage L, return component ν, and continuation component η, the leverage spread satisfies

<span id="page-30-0"></span>
$$L_t^{FC} - L_t^{LC} \approx \frac{L - 1}{\lambda_b - \eta} \mathcal{U}_t^B. \tag{59}$$

The intuition is that a bank-weighted currency-return wedge changes the relative value of borrowing in the two currencies. Because banks are leveraged, this difference is amplified into a larger difference in balance-sheet capacity. The amplification is stronger when leverage is high and the intermediary constraint is close to binding.

Combining [\(57\)](#page-29-2) and [\(59\)](#page-30-0) yields the conditional bank-side wedge

<span id="page-30-1"></span>
$$\mathcal{U}_t^B = \frac{\chi_\phi(\lambda_b - \eta)}{\lambda_b(L - 1)} (\phi_t - \bar{\phi}). \tag{60}$$

This expression describes the conditional bank funding margin. Holding the stochastic environment fixed, deviations of the endogenous dollar-liability share from its reference level move the bank-weighted funding wedge.

Export-price stickiness does not enter the bank's currency-choice condition directly. Instead, it changes the general-equilibrium environment in which dollar balance-sheet exposure is priced. A higher θ<sup>x</sup> means that export prices set in dollars adjust less frequently. A depreciation then lowers the price faced by foreign buyers only gradually, so the exchange rate provides less immediate support to external demand. This weakens the shock-absorbing role of the exchange rate. When banks also carry dollar liabilities, the larger and more persistent depreciation raises the local-currency value of those liabilities, lowers bank net worth, reduces capital returns, and increases the continuation value of bank capital.

For this reason, the steady-state objects in [\(60\)](#page-30-1) should be understood as functions of both export-price stickiness and the reference dollar-liability share:

$$\eta = \eta(\theta_x, \bar{\phi}), \qquad \nu = \nu(\theta_x, \bar{\phi}), \qquad L(\theta_x, \bar{\phi}) = \frac{\nu(\theta_x, \bar{\phi})}{\lambda_b - \eta(\theta_x, \bar{\phi})}.$$
(61)

Substituting these objects into [\(60\)](#page-30-1) gives

<span id="page-30-2"></span>
$$\mathcal{U}_t^B = \Gamma(\theta_x, \bar{\phi})(\phi_t - \bar{\phi}), \tag{62}$$

where

$$\Gamma(\theta_x, \bar{\phi}) \equiv \frac{\chi_{\phi}[\lambda_b - \eta(\theta_x, \bar{\phi})]}{\lambda_b[L(\theta_x, \bar{\phi}) - 1]} = \frac{\chi_{\phi}[\lambda_b - \eta(\theta_x, \bar{\phi})]^2}{\lambda_b[\nu(\theta_x, \bar{\phi}) - \lambda_b + \eta(\theta_x, \bar{\phi})]}.$$
(63)

Equation [\(62\)](#page-30-2) separates the conditional mechanisms. Dollar liabilities move the bankweighted funding wedge through the currency-choice margin. Export-price stickiness changes the slope of this relationship by changing the macro-financial consequences of depreciation.

The unconditional premium contains an additional asset-pricing term. Starting from [\(54\)](#page-29-3), add and subtract R<sup>∗</sup> tEt [MF C <sup>t</sup>+1]E<sup>t</sup> [st+1]. This gives

$$\mathcal{U}_{t}^{B} = \mathbb{E}_{t}[\mathcal{M}_{t+1}^{LC}] \left( R_{t} - R_{t}^{*} \mathbb{E}_{t} s_{t+1} \right) 
+ R_{t}^{*} \mathbb{E}_{t} s_{t+1} \left( \mathbb{E}_{t}[\mathcal{M}_{t+1}^{LC}] - \mathbb{E}_{t}[\mathcal{M}_{t+1}^{FC}] \right) 
- R_{t}^{*} \operatorname{Cov}_{t} \left( \mathcal{M}_{t+1}^{FC}, s_{t+1} \right).$$
(64)

Solving for p LC <sup>t</sup> yields

<span id="page-31-0"></span>
$$p_t^{LC} = \frac{\mathcal{U}_t^B}{\mathbb{E}_t[\mathcal{M}_{t+1}^{LC}]} + R_t^* \mathbb{E}_t s_{t+1} \frac{\mathbb{E}_t[\mathcal{M}_{t+1}^{FC}] - \mathbb{E}_t[\mathcal{M}_{t+1}^{LC}]}{\mathbb{E}_t[\mathcal{M}_{t+1}^{LC}]} + \frac{R_t^*}{\mathbb{E}_t[\mathcal{M}_{t+1}^{LC}]} \operatorname{Cov}_t \left(\mathcal{M}_{t+1}^{FC}, s_{t+1}\right).$$

$$(65)$$

The first term is the conditional bank funding wedge. The second term captures differences in the average valuation of local- and foreign-currency funding positions. The third term is the risk-premium component. Local-currency assets require a premium when the domestic currency depreciates in states in which the banker-weighted stochastic discount factor is high.

The covariance term is the key mechanism. Since

$$\mathcal{M}_{t+1}^{FC} = \beta \Lambda_{t,t+1} \Omega_{t+1}^{FC},$$

the premium is high when depreciation is associated with high household marginal utility, high continuation value of bank net worth, or both. Using log deviations around the stochastic steady state, the covariance can be approximated by

$$\frac{\operatorname{Cov}_{t}\left(\mathcal{M}_{t+1}^{FC}, s_{t+1}\right)}{\mathbb{E}_{t}[\mathcal{M}_{t+1}^{FC}]\mathbb{E}_{t}[s_{t+1}]} \approx \operatorname{Cov}_{t}\left(\widehat{\Lambda}_{t,t+1}, \widehat{s}_{t+1}\right) + \operatorname{Cov}_{t}\left(\widehat{\Omega}_{t+1}^{FC}, \widehat{s}_{t+1}\right) + \mathcal{T}_{t}(\theta_{x}, \bar{\phi}), \tag{66}$$

where hats denote log deviations and  $\mathcal{T}_t(\theta_x, \bar{\phi})$  collects higher-order interaction terms between household marginal utility, bank continuation values, and depreciation. These interaction terms are retained in the third-order quantitative solution.

The role of dollar liabilities is easiest to see from bank net worth. Aggregate bank net worth evolves according to

$$N_{t+1} = R_{t+1}^k Q_t \mathcal{A}_t - R_t B_t^{LC} - R_t^* s_{t+1} B_t^{FC}, \tag{67}$$

with

$$B_t^{FC} = (L_t^{FC} - 1)\phi_t N_t. {(68)}$$

Holding predetermined balance-sheet positions fixed, the direct effect of depreciation on net-worth growth is

$$\left. \frac{\partial}{\partial s_{t+1}} \left( \frac{N_{t+1}}{N_t} \right) \right|_{\text{direct}} = -R_t^* (L_t^{FC} - 1) \phi_t. \tag{69}$$

Thus, a depreciation lowers bank net worth whenever banks have foreign-currency liabilities and  $L_t^{FC}>1$ . Evaluated at the stochastic steady state, where  $\phi_t=\bar{\phi}$ , the direct log-linear loading of net worth on depreciation is

<span id="page-32-0"></span>
$$\frac{\partial \widehat{N}_{t+1}}{\partial \widehat{s}_{t+1}} \bigg|_{ss, \text{direct}} = -\zeta_N(\theta_x, \bar{\phi}), \qquad \zeta_N(\theta_x, \bar{\phi}) \equiv \frac{\bar{R}^* \bar{s}[\bar{L}^{FC}(\theta_x, \bar{\phi}) - 1]\bar{\phi}}{\bar{g}_N(\theta_x, \bar{\phi})}. \tag{70}$$

Here  $\bar{g}_N$  is steady-state net-worth growth. Equation (70) is the direct balance-sheet scaling result. The exposure of bank net worth to depreciation is locally proportional to the level of dollar liabilities,  $\bar{\phi}$ , and is amplified by leverage. Indirect effects through  $\bar{L}^{FC}$  and  $\bar{g}_N$  are part of the full general-equilibrium scaling.

This direct exposure implies

<span id="page-33-0"></span>
$$-\operatorname{Cov}_{t}\left(\widehat{N}_{t+1}, \widehat{s}_{t+1}\right) = \zeta_{N}(\theta_{x}, \bar{\phi}) \mathcal{V}_{s,t}(\theta_{x}, \bar{\phi}) + \mathcal{B}_{N,t}(\theta_{x}, \bar{\phi}), \tag{71}$$

where

$$\mathcal{V}_{s,t}(\theta_x, \bar{\phi}) \equiv \operatorname{Var}_t(\widehat{s}_{t+1})$$

and  $\mathcal{B}_{N,t}(\theta_x,\bar{\phi})$  collects the general-equilibrium component of net-worth losses through output, investment, capital returns, and domestic absorption. The first term in (71) is the mechanical revaluation effect of dollar liabilities. The second term is the endogenous macro-financial feedback.

The continuation value of bank wealth transforms this net-worth covariance into a pricing covariance. When bank net worth is scarce, the marginal value of an additional unit of bank wealth is high. Locally,

<span id="page-33-1"></span>
$$\widehat{\Omega}_{t+1}^{FC} \approx -\kappa_N \widehat{N}_{t+1} + \widehat{\mathcal{R}}_{t+1}^{FC}, \qquad \kappa_N > 0,$$
(72)

where  $\widehat{\mathcal{R}}_{t+1}^{FC}$  collects expected-return components of the continuation value. Combining (71) and (72) gives

$$\operatorname{Cov}_{t}\left(\widehat{\Omega}_{t+1}^{FC}, \widehat{s}_{t+1}\right) \approx \kappa_{N}\left[\zeta_{N}(\theta_{x}, \bar{\phi}) \mathcal{V}_{s,t}(\theta_{x}, \bar{\phi}) + \mathcal{B}_{N,t}(\theta_{x}, \bar{\phi})\right] + \mathcal{R}_{\Omega,t}(\theta_{x}, \bar{\phi}), \tag{73}$$

where

$$\mathcal{R}_{\Omega,t}(\theta_x, \bar{\phi}) \equiv \operatorname{Cov}_t\left(\widehat{\mathcal{R}}_{t+1}^{FC}, \widehat{s}_{t+1}\right).$$

A depreciation is therefore priced not only because it lowers bank net worth, but because it lowers net worth in states in which the continuation value of intermediary wealth is high.

Export-price stickiness affects the household-SDF component and the general-equilibrium bank component. With standard preferences,

$$\widehat{\Lambda}_{t,t+1} \approx -\sigma \left(\widehat{C}_{t+1} - \widehat{C}_{t}\right) - \widehat{\Pi}_{t+1}^{c}.$$
(74)

Define

$$\chi_C(\theta_x, \bar{\phi}) \equiv -\frac{\operatorname{Cov}\left(\widehat{C}_{t+1} - \widehat{C}_t, \widehat{s}_{t+1}\right)}{\operatorname{Var}(\widehat{s}_{t+1})}, \qquad \chi_{\pi}(\theta_x, \bar{\phi}) \equiv \frac{\operatorname{Cov}\left(\widehat{\Pi}_{t+1}^c, \widehat{s}_{t+1}\right)}{\operatorname{Var}(\widehat{s}_{t+1})}. \tag{75}$$

Then

$$\operatorname{Cov}\left(\widehat{\Lambda}_{t,t+1}, \widehat{s}_{t+1}\right) = \left[\sigma \chi_C(\theta_x, \bar{\phi}) - \chi_{\pi}(\theta_x, \bar{\phi})\right] \mathcal{V}_s(\theta_x, \bar{\phi}). \tag{76}$$

When the real-income and output effects of depreciation dominate the inflation denominator in the real stochastic discount factor, depreciation raises the household component of the pricing kernel. A higher θ<sup>x</sup> strengthens this channel in the calibrated economy because sticky dollar export prices weaken the shock-absorbing role of the exchange rate. Depreciation provides less immediate support to export demand, while import prices and the local-currency value of dollar liabilities adjust immediately.

Taking unconditional means in [\(65\)](#page-31-0), and using the covariance approximations above, gives the model's local representation of the unconditional currency premium. The second term in [\(65\)](#page-31-0), which captures average LC–FC valuation differences, is denoted by

$$\bar{\mathcal{A}}_M(\theta_x, \bar{\phi}) \equiv \mathbb{E}\left[R_t^* \mathbb{E}_t s_{t+1} \frac{\mathbb{E}_t[\mathcal{M}_{t+1}^{FC}] - \mathbb{E}_t[\mathcal{M}_{t+1}^{LC}]}{\mathbb{E}_t[\mathcal{M}_{t+1}^{LC}]}\right]. \tag{77}$$

Around the symmetric reference point this term is small; more generally, it is grouped with the valuation terms that do not operate through the direct net-worth covariance. The unconditional premium can be written as

<span id="page-34-0"></span>
$$\bar{p}^{LC} \equiv \mathbb{E}\left[p_t^{LC}\right]$$

$$\approx \underbrace{\frac{\mathbb{E}\left[\Gamma(\theta_x,\bar{\phi})(\phi_t - \bar{\phi})\right]}{\bar{\mathcal{M}}^{LC}}}_{\text{conditional bank funding margin}}$$

$$+ \underbrace{\bar{R}^*\bar{s}\left[\sigma\chi_C(\theta_x,\bar{\phi}) - \chi_\pi(\theta_x,\bar{\phi})\right]\mathcal{V}_s(\theta_x,\bar{\phi})}_{\text{household-SDF channel}}$$

$$+ \underbrace{\bar{R}^*\bar{s}\kappa_N\left[\zeta_N(\theta_x,\bar{\phi})\mathcal{V}_s(\theta_x,\bar{\phi}) + \mathcal{B}_N(\theta_x,\bar{\phi})\right]}_{\text{bank-net-worth and continuation-value channel}}$$

$$+ \underbrace{\bar{\mathcal{A}}_M(\theta_x,\bar{\phi}) + \bar{R}^*\bar{s}\left[\mathcal{R}_{\Omega}(\theta_x,\bar{\phi}) + \mathcal{T}(\theta_x,\bar{\phi})\right]}_{\text{average-kernel and higher-order valuation terms}}$$

$$(78)$$

Equation [\(78\)](#page-34-0) links the analytical block to the quantitative results. The level of dollar lia-

bilities,  $\bar{\phi}$ , scales the direct covariance between depreciation and bank net worth through  $\zeta_N(\theta_x,\bar{\phi})$ . Export-price stickiness,  $\theta_x$ , affects the premium by changing how much stabilization the exchange rate provides after a depreciation. When dollar export prices adjust slowly, depreciation produces less immediate support for export demand. The economy therefore relies more on exchange-rate movements, import compression, and lower domestic absorption to restore external balance. In the presence of dollar liabilities, this same depreciation also reduces bank net worth and raises the continuation value of intermediary wealth. The premium rises because depreciation is associated with a high banker-weighted stochastic discount factor.

The direct comparative statics are transparent. Ignoring the indirect steady-state effects of  $\bar{\phi}$  on leverage and net-worth growth, the balance-sheet loading satisfies

$$\frac{\partial \zeta_N(\theta_x, \bar{\phi})}{\partial \bar{\phi}} \approx \frac{\bar{R}^* \bar{s} [\bar{L}^{FC}(\theta_x, \bar{\phi}) - 1]}{\bar{g}_N(\theta_x, \bar{\phi})} > 0.$$
 (79)

Hence the direct effect of dollar liabilities on the unconditional premium is

$$\frac{\partial \bar{p}^{LC}}{\partial \bar{\phi}} \bigg|_{\text{direct.}} \approx \bar{R}^* \bar{s} \kappa_N \frac{\partial \zeta_N(\theta_x, \bar{\phi})}{\partial \bar{\phi}} \mathcal{V}_s(\theta_x, \bar{\phi}) > 0. \tag{80}$$

The interaction with export-price stickiness is

$$\frac{\partial^2 \bar{p}^{LC}}{\partial \bar{\phi} \, \partial \theta_x} \approx \bar{R}^* \bar{s} \kappa_N \left[ \frac{\partial \zeta_N(\theta_x, \bar{\phi})}{\partial \bar{\phi}} \frac{\partial \mathcal{V}_s(\theta_x, \bar{\phi})}{\partial \theta_x} + \frac{\partial^2 \mathcal{B}_N(\theta_x, \bar{\phi})}{\partial \bar{\phi} \, \partial \theta_x} \right]$$
(81)

+ household-SDF, average-kernel, and higher-order interaction terms.

In the calibrated region of the model, this derivative is positive. The first term says that dollar debt is more costly when export-price stickiness raises exchange-rate volatility. The second term says that the same dollar-debt exposure produces a larger decline in output, investment, capital returns, and bank net worth when sticky dollar export prices weaken the shock-absorbing role of the exchange rate.

Equations (62) and (78) describe complementary margins. The conditional bank wedge depends on deviations of the endogenous dollar share from its target. The unconditional premium depends on the level of dollar liabilities because  $\bar{\phi}$  determines the direct revaluation loss when the currency depreciates. Export-price stickiness affects the premium by weakening the shock-absorbing role of the exchange rate. It raises exchange rate volatility and makes depreciation more closely associated with weak output, lower

investment, and scarce bank net worth.

The expression also clarifies why dominant-currency pricing alone is not sufficient to generate a large premium. Export-price stickiness can make depreciation less stabilizing, but the direct bank-net-worth exposure to depreciation is proportional to the steady-state dollar-liability share. When that share is low, the revaluation of bank liabilities is small, the covariance between depreciation and bank net worth is weak, and the continuation- value component of the pricing kernel moves little. Dominantcurrency pricing therefore amplifies the premium mainly by increasing the price of a dollar balance-sheet exposure that is already present.

This is the mechanism quantified in the next section. In the impulse responses, the largest UIP spread appears when high dollar liabilities are combined with high dollar export invoicing. In the stochastic steady state, raising θ<sup>x</sup> increases exchange-rate volatility, makes depreciation more countercyclical, and raises the unconditional UIP premium. Appendix simulations that vary ϕ¯ show the same mechanism from the balancesheet side. A higher steady-state dollar-liability share raises exchange-rate volatility, the UIP premium, and average inflation. These quantitative patterns reflect a single covariance channel. When the currency depreciates, dollar liabilities reduce bank net worth and make bank capital more valuable. The banker-weighted stochastic discount factor rises in the same states in which local-currency assets pay off poorly relative to dollar assets, so investors require a higher premium to hold them.

## **5 Model Calibration and Simulations**

This section takes the analytical mechanism to the quantitative model. The exercise is not intended as a full structural estimation. Instead, the calibration disciplines the main trade, financial, and policy margins of a small open emerging-market economy and then asks how the economy behaves when dollar pricing and dollar liabilities interact. We proceed in three steps. First, we describe the baseline calibration. Second, we compare impulse responses to a foreign monetary tightening in a vulnerable economy and in a benchmark economy without the key frictions. Third, we vary export-price stickiness and study how the stochastic steady state changes with currency risk.

## **5.1 Calibration**

The baseline calibration represents a small open economy exposed to foreign monetary conditions, imported inputs, and balance-sheet dollarization. Parameters governing preferences, production, and capital accumulation, including β, α, and δ, are assigned conventional business-cycle values. Parameters governing international transmission trade elasticities, nominal rigidities, and financial frictions—are chosen to generate plausible emerging-market responses to foreign monetary tightening. The structural estimates in [Camara, Christiano and Dalgic](#page-52-10) [\(2024\)](#page-52-10) provide a benchmark for the response of an average emerging-market economy to U.S. monetary policy shocks.

Three aspects of the calibration are central for the quantitative mechanism. First, the economy is highly exposed to foreign prices and foreign demand. The investment homebias parameter is set to a low value, γ<sup>I</sup> = 0.290, and the domestic-input share in exports is set to γ<sup>x</sup> = 0.500. The elasticity of substitution between domestic and imported consumption goods is η<sup>c</sup> = 0.410. Since η<sup>c</sup> < 1, domestic and imported goods are complements rather than close substitutes. A depreciation therefore raises the cost of imported consumption goods and inputs without generating a large substitution response. This real-income channel amplifies the contractionary effect of depreciations, as in [Auclert,](#page-51-2) [Rognlie, Souchier and Straub](#page-51-2) [\(2021\)](#page-51-2).

Second, foreign monetary tightening affects the home economy through both financial conditions and export demand. The export-demand shifter is set to γ<sup>R</sup> = −20, so an increase in the foreign interest rate is associated with weaker external demand for home exports. This parameterization captures the idea that U.S. monetary tightening is not only a funding shock for emerging markets, but also a global-demand shock. Exportprice stickiness is set to θ<sup>x</sup> = 0.800 in the baseline, implying that dollar export prices adjust slowly after the exchange rate moves.

Third, the calibration builds in the balance-sheet exposure that is central to the model. The banker incentive parameter is set to λ<sup>b</sup> = 0.300, implying steady-state leverage of approximately eight. The steady-state foreign-currency liability share is ϕ¯ = 0.250. This corresponds to a moderate but quantitatively meaningful degree of liability dollarization. Taken together, the trade and financial blocks make the exchange rate a doubleedged adjustment margin: depreciation helps only slowly through exports, while immediately raising import costs and the local-currency value of dollar liabilities. Table [7](#page-38-0) summarizes the full baseline calibration.

<span id="page-38-0"></span>

| Variable        | Description                                    | Value   |
|-----------------|------------------------------------------------|---------|
| β               | Discount Factor                                | 0.995   |
| $\alpha$        | Capital Share                                  | 0.340   |
| $\delta$        | Depreciation                                   | 0.020   |
| $\varphi$       | Inverse Frisch                                 | 1.000   |
| $\sigma$        | Relatiuve risk aversion                        | 2.000   |
| $r_{\pi}$       | <b>Taylor Inflation Coefficient</b>            | 1.500   |
| $r_y$           | Taylor Output Coefficient                      | 0.100   |
| $r_S$           | Taylor Exchange Rate Coefficient               | 0.020   |
| $\epsilon$      | Elasticity of Substitution, intermediate goods | 6.000   |
| $\theta$        | Calvo Parameter, intermediate goods            | 0.750   |
| $\epsilon^x$    | Elasticity of Substitution, export goods       | 6.000   |
| $\gamma$        | Target Portfolio Cost (UIP Friction)           | 2.560   |
| $\theta^x$      | Export Calvo Stickiness                        | 0.800   |
| $\kappa$        | Investment Adjustment Cost                     | 5.850   |
| $\eta_c$        | C, Elasticity of Substitution                  | 0.410   |
| $1-\omega_c$    | Home Bias, C                                   | 0.830   |
| $\omega_i$      | Home Bias, I                                   | 0.290   |
| $\gamma_x$      | Home Bias, X                                   | 0.500   |
| $\eta^f$        | Elasticity of Demand, Exports                  | 1.530   |
| $\eta_i$        | I, Elasticity of Substitution                  | 0.910   |
| $\eta_x$        | X, Elasticity of Substitution                  | 0.700   |
| $\rho_R$        | MP Persistence                                 | 0.900   |
| $\phi$          | Target Credit Dollarization                    | 0.250   |
| Υ               | Target Deposit Dollarization                   | 0.200   |
| $\frac{d^*}{Y}$ | Dollar Deposit/GDP                             | 0.500   |
| $\gamma_R$      | Export Demand Shifter                          | -20.000 |
| $\theta_b$      | Banker survival                                | 0.972   |
| $W_b$           | Banker startup                                 | 0.030   |
| $\lambda$       | Banker constraint                              | 0.300   |
| $\lambda^f$     | Financier Constraint                           | 1.000   |
|                 |                                                |         |

Table 7: Parameter Values

## **5.2 Response to a Foreign Interest Rate Shock**

Figure [3](#page-41-0) compares the response to a foreign monetary tightening across four economies obtained by varying two structural features: the degree of dollar export invoicing and the share of bank liabilities denominated in dollars. The monetary policy rule and the foreign interest rate shock are held fixed across all economies. Differences in domestic interest rates, exchange rates, output, and UIP spreads are therefore equilibrium outcomes, not the result of changing the policy rule.

The figure provides the quantitative counterpart to the analytical result derived above. The largest UIP deviation arises when the economy combines high dollar export invoicing with high dollar liabilities. Dollar liabilities are the direct source of balancesheet exposure: a depreciation raises the local-currency value of intermediaries' dollar debt and lowers bank net worth. Dollar export invoicing changes the real payoff to that balance-sheet exposure. When export prices are sticky in dollars, the depreciation does not translate quickly into lower dollar prices for foreign buyers. The exchange rate therefore becomes less effective at stabilizing external demand precisely when it is most damaging for domestic balance sheets.

This interaction is visible in the UIP-spread panel. The economy with both high dollar invoicing and high dollar debt displays the largest currency-risk premium. The economy with high dollar debt but low dollar invoicing also generates a sizable spread, but the spread is smaller. By contrast, the two low-debt economies generate only small UIP deviations. The result is consistent with the analytical decomposition: dollar debt moves the UIP wedge directly, while dollar export invoicing raises the marginal riskiness of a given dollar-liability position by weakening expenditure switching.

The real effects mirror this pricing result. In the high-invoicing, high-debt economy, the foreign tightening produces the largest depreciation, the sharpest decline in consumption, and the most severe initial contraction in investment and output. The depreciation raises the domestic price of imported consumption goods and imported investment inputs, reducing real purchasing power and the effective return to capital accumulation. At the same time, it revalues dollar liabilities, weakens intermediary net worth, and tightens credit. Local-currency assets therefore pay off poorly in states in which domestic absorption and intermediary balance sheets are already under pressure. Investors require a larger premium to hold those assets, and the UIP spread rises.

The export response should be interpreted carefully. Exports rise on impact in the

high-debt economies, including the high-invoicing case. But this is not the benign expenditure-switching mechanism of the textbook small open economy. It is a costly external adjustment generated by a much larger depreciation and a sharp movement in the external accounts. The right panel of Figure [5](#page-44-0) shows that low-invoicing economies obtain a larger immediate decline in dollar export prices. High-invoicing economies adjust dollar export prices more sluggishly. Thus, for a given exchange-rate movement, dollar invoicing weakens the improvement in export competitiveness. The observed export expansion in the vulnerable economy occurs only because the exchange rate and the risk premium move much more.

The benchmark low-debt economies behave differently. When dollar liabilities are limited, depreciation does not impose large valuation losses on intermediary balance sheets. When export invoicing is low, the exchange rate also works more effectively through relative prices. The exchange rate is then closer to a shock absorber: it supports external adjustment without simultaneously generating a large deterioration in domestic financial conditions. Output and investment fall less, and the UIP wedge remains small.

The same interaction creates a monetary-policy trade-off. CPI inflation rises because depreciation passes through into import prices, while output and investment contract because of balance-sheet losses and the costly external adjustment. Under the common Taylor rule, the central bank cannot remove the structural source of the UIP premium. A stronger anti-inflation response would tighten domestic financial conditions further, while a more accommodative response would validate part of the depreciation. The policy problem is therefore endogenous to the economy's trade and financial structure: the exchange rate no longer simply absorbs the foreign shock, but prices the risk created by the joint presence of dollar liabilities and sticky dollar export prices.

<span id="page-41-0"></span>![](_page_41_Figure_0.jpeg)

Figure 3: Impulse responses to a foreign interest-rate shock

*Notes:* High invoicing denotes a higher degree of dollar export invoicing, whereas low invoicing denotes producer-currency pricing. High USD debt denotes a higher share of bank liabilities denominated in dollars, whereas low USD debt denotes a lower dollar-liability share.

## **5.3 Mechanism**

The impulse responses isolate why the interaction between dollar liabilities and dollar export invoicing is a key determinant of the UIP deviation. A foreign interest rate shock raises dollar funding costs and puts downward pressure on the domestic currency. When intermediaries have dollar liabilities, the depreciation immediately increases the local-currency value of their debt. This valuation loss reduces bank net worth, raises leverage, and tightens credit. Dollar debt therefore makes the exchange rate financially fragile.

Dollar export invoicing determines whether the economy can absorb this financial loss through the trade account. Under producer-currency pricing or flexible dollar export prices, depreciation lowers the foreign-currency price of exports and stimulates foreign demand. The trade account can then help offset the balance-sheet loss. Under sticky dollar export pricing, this relative-price channel is weaker. Dollar export prices adjust only gradually, so the same depreciation produces less immediate improvement in export competitiveness. External adjustment must then occur through a more costly combination of larger depreciation, import compression, and lower domestic absorption.

Figure 4 shows this adjustment in the external accounts. In the high-invoicing (*i.e.*, significant amount of exports are invoiced in USD), high USD debt economy, the current account deteriorates sharply on impact and then reverses into surplus. The initial deterioration reflects the financial pressure created by the depreciation and the higher burden of dollar liabilities. The subsequent surplus reflects the economy's forced external adjustment. The trade balance improves strongly at first, but this improvement is not a sign of a frictionless expenditure-switching channel. It is achieved in an economy experiencing a large depreciation, a high UIP premium, and a sharp contraction in domestic demand.

<span id="page-42-0"></span>![](_page_42_Figure_2.jpeg)

Figure 4: Current Account Dynamics following a foreign interest rate shock

Figure 5 presents the same mechanism from the perspective of currency returns. The left panel shows that the UIP spread is largest when high dollar debt is combined with high dollar export invoicing. High dollar debt alone generates a substantial spread, but the spread is amplified when exports are also invoiced in dollars. High invoicing

without high dollar debt generates only a small UIP deviation. This pattern is exactly the interaction emphasized by the analytical section: the dollar-liability share is the direct balance-sheet exposure, while export-price stickiness changes the riskiness of that exposure.

The right panel explains why. Low-invoicing economies experience a larger initial decline in dollar export prices, so the depreciation works more directly through export competitiveness. High-invoicing economies exhibit a more muted and delayed dollarprice adjustment. The exchange rate therefore has to do more work to restore external balance. In the high-debt economy, this larger exchange-rate movement simultaneously worsens intermediary balance sheets. The financial channel and the trade-pricing channel reinforce each other: dollar liabilities make depreciation costly, and sticky dollar export prices make depreciation less effective as a stabilizer.

The central implication is that the exchange rate changes role. In the low-debt or lowinvoicing economies, it remains closer to a relative price that reallocates demand and absorbs foreign shocks. In the high-invoicing, high-debt economy, it becomes a macrofinancial state variable. It raises import costs, revalues dollar liabilities, tightens intermediary balance sheets, and increases the compensation investors require for holding local-currency assets. This is why the joint presence of dollar liabilities and dollar export invoicing generates the largest UIP deviation and why these two margins are central to the economy's shock-absorption capacity.

<span id="page-44-0"></span>![](_page_44_Figure_0.jpeg)

Figure 5: UIP Spread and Export Prices

## **UIP Premium**

In Section 4 we show that UIP spread in the model is related to the co-movement between marginal utility and the exchange rate. Figure 6 shows the dynamic pattern of the covariance term. It rises following foreign interest rate shocks in economies with high financial dollarization.

<span id="page-45-0"></span>![](_page_45_Figure_0.jpeg)

Figure 6: Marginal Utility Exchange Rate comovement

When balance sheets are damaged, further shocks have more destabilizing effects so that aggregate volatility goes up. Against which, agents would like to hold dollar assets and banks (which use the same SDF as households) would like to borrow in local currency (avoid dollar borrowing). Equilibrium is reached at higher local interest rates.

## **Financial Flows**

Figure [7](#page-46-0) shows financial flows following foreign interest rate shocks in four economies. In the presence of dollar debt, balance sheets are damaged so that bank leverage goes up to repair them. Dollar invoicing heavily amplifies the increase in leverage, which is responsible for rising macro volatility and co-movement between marginal utility and the exchange rate.

Households decrease both local deposits and foreign assets. They use foreign assets as a buffer against the shock but they mostly liquidate their local currency deposits because they do not want to hold local assets. Rising UIP premium disincentivezs banks to borrow in local currency and they end up borrowing in dollars. Rising dollar debt in the presence of declining dollar assets means that the economy accumulates higher dollar debt.

<span id="page-46-0"></span>![](_page_46_Figure_0.jpeg)

Figure 7: Financial Flows

#### <span id="page-46-1"></span>5.4 Stochastic Steady-State Results

The impulse responses describe the transmission of a single shock. We now ask how the economy's stochastic steady state changes as export-price stickiness,  $\theta_x$ , increases. The model is solved using a third-order approximation around the non-stochastic steady state, which allows risk to affect simulation averages.

The main result is that greater export-price stickiness makes the currency both more volatile and more countercyclical. When dollar export prices adjust slowly, external shocks require larger exchange-rate movements to satisfy the balance-of-payments constraint. Those depreciations occur precisely when output is weak, because dollar liabilities reduce intermediary net worth and import prices compress domestic absorption. As a result, the exchange rate is structurally a poor hedge for domestic activity.

#### Volatility, Cyclicality, and the UIP Premium

Figure 8 shows that increasing  $\theta_x$  raises exchange-rate volatility and strengthens the negative comovement between output and the exchange rate. The economic logic fol-

lows directly from the mechanism above. Stickier dollar export prices make expenditure switching weaker. The exchange rate must therefore move more to induce the same external adjustment. With dollarized balance sheets, these larger depreciations worsen financial conditions and make output fall at the same time that the currency depreciates.

<span id="page-47-0"></span>![](_page_47_Figure_1.jpeg)

Figure 8: Stochastic Steady-State Volatility and Export-Price Stickiness

This change in cyclicality has an asset-pricing implication. Dollar assets appreciate in domestic downturns and therefore provide insurance to domestic agents, as emphasized by [Christiano, Dalgic and Nurbekyan](#page-52-8) [\(2021\)](#page-52-8). Local-currency assets do the opposite: they lose value in states in which domestic income is already low. Households therefore demand compensation to hold local-currency exposure. Foreign financiers also require a larger expected excess return when exchange-rate volatility rises, as in Equation [43.](#page-26-0) Figure [9](#page-48-0) shows that the stochastic steady-state UIP premium rises with export-price stickiness. Dollar debt creates the direct exposure, while dominant-currency pricing raises the price of that exposure by making the exchange rate less stabilizing.

<span id="page-48-0"></span>![](_page_48_Figure_0.jpeg)

Figure 9: UIP Premium and Export Dollar Price Stickiness (θx)

#### **Inflation and Policy Trade-offs**

The rise in the UIP premium also has a monetary implication. In an open economy with segmented international asset markets, the domestic nominal interest rate must compensate investors for currency risk. When the premium rises, the risk-adjusted neutral interest rate rises with it. A conventional Taylor rule with a fixed intercept, such as Equation [48,](#page-27-0) does not automatically internalize this shift. At the inflation target, the policy rate is then too low relative to the return required to clear currency markets. In equilibrium, inflation rises above target so that the Taylor rule generates a higher nominal and real interest rate. Figure [10](#page-49-0) shows that steady-state inflation therefore increases with export-price stickiness.

<span id="page-49-0"></span>![](_page_49_Figure_0.jpeg)

Figure 10: Steady State Inflation and Export Price Stickiness

To illustrate the policy trade-off, we also consider a rule that responds to inflation in interest-rate changes rather than in levels, following the logic of policy rules that are robust to changes in the neutral rate in [Orphanides and Williams](#page-54-2) [\(2006\)](#page-54-2):

$$R_t - R_{t-1} = r^{\pi} \log \left( \frac{\pi_t}{\overline{\pi}} \right). \tag{82}$$

This rule allows the long-run level of the nominal interest rate to adjust to the risk premium while still anchoring inflation around its target.

<span id="page-49-1"></span>![](_page_49_Figure_5.jpeg)

<span id="page-49-2"></span>Figure 11: Inflation and Risk Premium under Different Monetary Policy Rules

Figure [11a](#page-49-1) shows that the robust rule stabilizes inflation across values of θx. Figure [11b](#page-49-2) shows the cost of doing so: the domestic economy must sustain a higher interest-rate spread when the currency risk premium is high. The policy conclusion is therefore not that a different rule eliminates the underlying friction. Rather, the rule changes the form in which the friction appears. Under the standard rule, the premium shows up partly as higher average inflation. Under the robust rule, inflation is anchored, but the economy absorbs the premium through higher real rates and tighter financial conditions. The trade-off is structural: as long as dollar pricing and dollar liabilities make the exchange rate risky, monetary policy must either accommodate part of the premium or impose the real-rate adjustment required to offset it.

## **6 Conclusion**

This paper develops a mechanism through which trade invoicing and financial structure jointly determine currency risk. The core argument is that dominant-currency pricing and foreign-currency liabilities are mutually reinforcing frictions. Dollar export pricing weakens the expenditure-switching benefit of depreciation. Dollar liabilities make depreciation costly for financial intermediaries. When the two frictions operate together, the exchange rate no longer behaves as a stabilizing relative price. Depreciations occur in bad states, tighten balance sheets, compress domestic absorption, and make localcurrency assets risky.

The model formalizes this mechanism in a small open economy with sticky dollar export prices, dollar borrowing by intermediaries, and segmented international asset markets. The analytical results show that the UIP wedge is directly linked to the dollar-borrowing share of intermediaries, while export-price stickiness changes the equilibrium price of that exposure. The quantitative results show the same mechanism at work. Following a foreign monetary tightening, the vulnerable economy experiences a larger depreciation, a sharper decline in consumption and investment, and a higher UIP spread than a benchmark economy without dominant-currency pricing and dollar debt. The reason is not any single friction in isolation, but their interaction: the depreciation fails to stimulate exports quickly while immediately worsening balance sheets.

The stochastic steady-state results extend this logic from impulse responses to risk premia and inflation. As export-price stickiness rises, exchange-rate volatility increases and depreciations become more strongly associated with downturns. Dollar assets become better insurance, local-currency assets become riskier, and the UIP premium rises. Because this premium raises the risk-adjusted neutral interest rate, a conventional Taylor rule with a fixed intercept generates higher average inflation. A rule that accommodates movements in the neutral rate can stabilize inflation, but only by sustaining higher real rates and interest-rate spreads.

The policy implication is that monetary policy alone cannot undo the structural source of currency risk. Central banks in economies with dollar pricing and dollar liabilities face a genuine trade-off between inflation stabilization and financial tightening. Macroprudential policies that limit unhedged foreign-currency borrowing can reduce the balance-sheet amplification of depreciations. Policies that encourage more flexible or local-currency export pricing can restore part of the expenditure-switching role of the exchange rate. More generally, the framework suggests that the riskiness of a currency is not an exogenous country characteristic. It is an equilibrium outcome shaped by how goods are priced, how liabilities are denominated, and how international investors absorb currency exposure.

Future work could investigate whether exchange-rate risk also depends on the domestic allocation of credit, beyond the foreign-currency denomination of liabilities and the currency invoicing of trade. In economies where nontradable sectors are especially dependent on bank credit, depreciation-induced balance-sheet stress may tighten credit supply, compress domestic demand, and amplify exchange-rate volatility through an additional feedback mechanism.

## **References**

<span id="page-51-1"></span>**Amiti, Mary, Oleg Itskhoki, and Jozef Konings**, "Dominant currencies: How firms choose currency invoicing and why it matters," *The Quarterly Journal of Economics*, 2022, *137* (3), 1435–1493.

<span id="page-51-0"></span>**Aoki, Kosuke, Gianluca Benigno, and Nobuhiro Kiyotaki**, "Monetary and Financial Policies in Emerging Markets," 2020.

<span id="page-51-2"></span>**Auclert, Adrien, Matthew Rognlie, Martin Souchier, and Ludwig Straub**, "Exchange Rates and Monetary Policy with Heterogeneous Agents: Sizing up the Real Income Channel," *NBER Working Papers*, May 2021, (28872).

- <span id="page-52-6"></span>**Bacchetta, Philippe, Kenza Benhima, and Brendan Berthold**, "Foreign exchange intervention with UIP and CIP deviations: The case of small safe haven economies," *Swiss Finance Institute Research Paper*, 2023, (23-71).
- <span id="page-52-7"></span>**, Rachel Cordonier, and Ouarda Merrouche**, "The rise in foreign currency bonds: The role of US monetary policy and capital controls," *Journal of International Economics*, 2023, *140*, 103709.
- <span id="page-52-0"></span>**Benhima, Kenza, Isabella Blengini, and Ouarda Merrouche**, "Foreign Currency Debt and Disagreement," *The Economic Journal*, August 2025, p. ueaf076.
- <span id="page-52-1"></span>**Benigno, Gianluca, Pierpaolo Benigno, and Salvatore Nisticò**, "Risk, Monetary Policy, and the Exchange Rate," *NBER Macroeconomics Annual*, January 2012, *26* (1), 247–309.
- <span id="page-52-2"></span>**Betts, Caroline and Michael B. Devereux**, "Exchange Rate Dynamics in a Model of Pricing-to-Market," *Journal of International Economics*, 2000, *50* (1), 215–244.
- <span id="page-52-4"></span>**Bocola, Luigi and Guido Lorenzoni**, "Financial Crises, Dollarization, and Lending of Last Resort in Open Economies," *American Economic Review*, August 2020, *110* (8), 2524–57.
- <span id="page-52-10"></span>**Camara, Santiago, Lawrence Christiano, and Hüsnü Dalgic**, "The International Monetary Transmission Mechanism," in "NBER Macroeconomics Annual 2024, Volume 39," University of Chicago Press, July 2024.
- <span id="page-52-8"></span>**Christiano, Lawrence, Husnu Dalgic, and Armen Nurbekyan**, "Financial Dollarization in Emerging Markets: Efficient Risk Sharing or Prescription for Disaster?," *CRC TR 224 Discussion Paper Series*, August 2021, (crctr224\_2021\_306).
- <span id="page-52-3"></span>**Corte, Pasquale Della, Steven J. Riddiough, and Lucio Sarno**, "Currency Premia and Global Imbalances," *Review of Financial Studies*, 2016, *29* (8), 2161–2193.
- <span id="page-52-9"></span>**Dalgic, Husnu C.**, "Financial Dollarization in Emerging Markets: An Insurance Arrangement," *International Economic Review*, 2024, *65* (3), 1189–1219.
- <span id="page-52-5"></span>**Dao, Mai C., Pierre-Olivier Gourinchas, and Oleg Itskhoki**, "Breaking Parity: Equilibrium Exchange Rates and Currency Premia," NBER Working Paper 34443, National Bureau of Economic Research 2025.

- <span id="page-53-4"></span>**Devereux, Michael B. and Charles Engel**, "Monetary Policy in the Open Economy Revisited: Price Setting and Exchange-Rate Flexibility," *The Review of Economic Studies*, 2003, *70* (4), 765–783.
- <span id="page-53-5"></span>**Egorov, Konstantin and Dmitry Mukhin**, "Optimal Policy under Dollar Pricing," *American Economic Review*, 2023, *113* (7), 1783–1824.
- <span id="page-53-12"></span>**Gertler, Mark and Peter Karadi**, "A Model of Unconventional Monetary Policy," *Journal of Monetary Economics*, 2011, *58* (1), 17–34.
- <span id="page-53-3"></span>**Ghironi, Fabio and Galip Kemal Ozhan**, "Interest Rate Uncertainty as a Policy Tool?," *Journal of International Economics*, December 2025, *158*, 104180.
- <span id="page-53-1"></span>**Goldberg, Linda S. and Cédric Tille**, "Vehicle Currency Use in International Trade," *Journal of International Economics*, December 2008, *76* (2), 177–192.
- <span id="page-53-10"></span>**and Signe Krogstrup**, "International Capital Flow Pressures and Global Factors," *Journal of International Economics*, 2023, *146*, 103749.
- <span id="page-53-0"></span>**Gopinath, Gita and Jeremy C. Stein**, "Banking, Trade, and the Making of a Dominant Currency," *The Quarterly Journal of Economics*, 2021, *136* (2), 783–830.
- <span id="page-53-2"></span>**, Emine Boz, Camila Casas, Federico J. Díez, Pierre-Olivier Gourinchas, and Mikkel Plagborg-Møller**, "Dominant Currency Paradigm," *American Economic Review*, March 2020, *110* (3), 677–719.
- <span id="page-53-6"></span>**Hassan, Tarek A.**, "Country Size, Currency Unions, and International Asset Returns," *The Journal of Finance*, 2013, *68* (6), 2269–2308.
- <span id="page-53-9"></span>**and Tony Zhang**, "The Economics of Currency Risk," *Annual Review of Economics*, August 2021, *13* (1), 281–307.
- <span id="page-53-11"></span>**Ince, Onur and Tanya Molodtsova**, "Rationality and Forecasting Accuracy of Exchange Rate Expectations: Evidence from Survey-Based Forecasts," *Journal of International Financial Markets, Institutions and Money*, March 2017, *47*, 131–151.
- <span id="page-53-7"></span>**Jiang, Zhengyang**, "US Fiscal Cycle and the Dollar," *Journal of Monetary Economics*, 2021, *124*, 91–106.
- <span id="page-53-8"></span>, "Fiscal Cyclicality and Currency Risk Premia," *The Review of Financial Studies*, 2022, *35* (3), 1527–1552. Published online May 2021.

- <span id="page-54-10"></span>**Kalemli-Özcan, ¸Sebnem**, "US monetary policy and international risk spillovers," Technical Report, National Bureau of Economic Research 2019.
- <span id="page-54-11"></span>**and Filiz Unsal**, "Global transmission of FED Hikes: The role of policy credibility and balance sheets," *Brookings Papers on Economic Activity*, 2023, *2023* (2), 169–225.
- <span id="page-54-8"></span>**and Liliana Varela**, "Five facts about the uip premium," Technical Report, National Bureau of Economic Research 2021.
- <span id="page-54-9"></span>**Liao, Gordon Y. and Tony Zhang**, "The Hedging Channel of Exchange Rate Determination," *The Review of Financial Studies*, 2025, *38* (1), 1–38.
- <span id="page-54-0"></span>**Lustig, Hanno, Nikolai Roussanov, and Adrien Verdelhan**, "Common Risk Factors in Currency Markets," *Review of Financial Studies*, 2011, *24* (11), 3731–3777.
- <span id="page-54-13"></span>**Maggiori, Matteo**, "Financial Intermediation, International Risk Sharing, and Reserve Currencies," *American Economic Review*, October 2017, *107* (10), 3038–3071.
- <span id="page-54-12"></span>**McLeay, Michael and Silvana Tenreyro**, "Dollar Dominance and the Transmission of Monetary Policy," *The Quarterly Journal of Economics*, September 2025, p. qjaf043.
- <span id="page-54-4"></span>**Mukhin, Dmitry**, "An Equilibrium Model of the International Price System," *American Economic Review*, 2022, *112* (2), 650–688.
- <span id="page-54-3"></span>**Obstfeld, Maurice and Kenneth Rogoff**, "Exchange Rate Dynamics Redux," *Journal of Political Economy*, 1995, *103* (3), 624–660.
- <span id="page-54-2"></span>**Orphanides, Athanasios and John C. Williams**, "Monetary Policy with Imperfect Knowledge," *Journal of the European Economic Association*, May 2006, *4* (2-3), 366–375.
- <span id="page-54-1"></span>**Ozhan, Galip Kemal**, "Financial Intermediation, Resource Allocation, and Macroeconomic Interdependence," *Journal of Monetary Economics*, November 2020, *115*, 265–278.
- <span id="page-54-5"></span>**Ready, Robert, Nikolai Roussanov, and Colin Ward**, "After the Tide: Commodity Currencies and Global Trade," *Journal of Monetary Economics*, 2017, *85*, 69–86.
- <span id="page-54-6"></span>**, , and** , "Commodity Trade and the Carry Trade: A Tale of Two Countries," *The Journal of Finance*, 2017, *72* (6), 2629–2684.
- <span id="page-54-7"></span>**Richmond, Robert J.**, "Trade Network Centrality and Currency Risk Premia," *Journal of Finance*, 2019, *74* (3), 1315–1361.

- <span id="page-55-2"></span>**Verdelhan, Adrien**, "The Share of Systematic Variation in Bilateral Exchange Rates," *Journal of Finance*, 2018, *73* (1), 375–418.
- <span id="page-55-0"></span>**Wiriadinata, Ursula**, "External Debt, Currency Risk, and International Monetary Policy Transmission," 2021. Working paper.
- <span id="page-55-1"></span>**Yeyati, Eduardo Levy**, "Financial Dollarization: Evaluating the Consequences," *Economic Policy*, 2006, *21* (45), 61–118.

## <span id="page-56-0"></span>**A Determinants of Currency Returns**

In this section, we look at determinants of excess currency returns discussed in the literature. We consider external balance [\(Della Corte, Riddiough and Sarno](#page-52-3) [\(2016\)](#page-52-3)), foreign assets in the banking system [\(Yeyati](#page-55-1) [\(2006\)](#page-55-1); [Christiano, Dalgic and Nurbekyan](#page-52-8) [\(2021\)](#page-52-8)), Dollar invoicing [\(Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-Møller](#page-53-2) [\(2020\)](#page-53-2)), country size [\(Hassan](#page-53-6) [\(2013\)](#page-53-6)) and trade network centrality [\(Richmond](#page-54-7) [\(2019\)](#page-54-7)). Across currencies, foreign liabilities (external debt, NFA) and export dollar invoicing emerge as the robustly significant determinants of currency returns. Below, we look at each of these variables in isolation. Table [8](#page-57-0) runs a regression of average returns on the variables discussed. Similar to [Hassan and Zhang](#page-53-9) [\(2021\)](#page-53-9), including GDP to the regression makes trade centrality insignificant, this is in line with [Richmond](#page-54-7) [\(2019\)](#page-54-7) which argues that either size or connectedness makes an economy central to international trade. Data on dollar invoicing, especially for EMEs, do not exist for many countries so in order to increase the number of countries, we added seven more countries using Forward returns.

<span id="page-57-0"></span>

|                        | Dependent variable: |                 |                |                |
|------------------------|---------------------|-----------------|----------------|----------------|
|                        | Average Return      |                 |                |                |
|                        | (1)                 | (2)             | (3)            | (4)            |
| FL/FA                  | 0.010∗∗∗            |                 | 0.009∗∗        | 0.008∗∗        |
|                        | (0.004)             |                 | (0.004)        | (0.004)        |
| Net Foreign Assets/GDP | −0.031∗∗∗           |                 | −0.027∗∗∗      | −0.028∗∗∗      |
|                        | (0.009)             |                 | (0.003)        | (0.005)        |
| GDP(Share of US)       | 0.006               |                 |                | 0.003          |
|                        | (0.005)             |                 |                | (0.007)        |
| Reserves/GDP           | 0.060               | 0.003           | 0.015          | 0.033          |
|                        | (0.048)             | (0.026)         | (0.025)        | (0.042)        |
| Export USD Invoicing   | 0.036∗              | 0.018∗∗         | 0.017∗∗∗       | 0.019∗∗        |
|                        | (0.019)             | (0.008)         | (0.006)        | (0.009)        |
| Trade Centrality       |                     | −4.304∗∗        | −0.983         | −2.774         |
|                        |                     | (2.011)         | (1.088)        | (4.387)        |
| Constant               | −0.004              | 0.029∗          | −0.003         | 0.013          |
|                        | (0.011)             | (0.016)         | (0.011)        | (0.035)        |
| Observations           | 20                  | 17              | 14             | 14             |
| 2<br>R                 | 0.560               | 0.335           | 0.805          | 0.810          |
| Adjusted R2            | 0.402               | 0.182           | 0.683          | 0.648          |
| Residual Std. Error    | 0.020 (df = 14)     | 0.016 (df = 13) | 0.010 (df = 8) | 0.011 (df = 7) |

Table 8: Determinants of Returns

Data source: IFS, Datastream, FX4Casts, [Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-Møller](#page-53-2) [\(2020\)](#page-53-2), [Richmond](#page-54-7) [\(2019\)](#page-54-7)

## **A.1 Foreign Assets and Liabilities of the Banking System**

First variable we consider is the ratio of foreign liabilities over foreign assets in the banking system (FL/FA). FL/FA is found to be a good predictor of banking crises [\(Yeyati](#page-55-1) [\(2006\)](#page-55-1); [Christiano, Dalgic and Nurbekyan](#page-52-8) [\(2021\)](#page-52-8)). High foreign liabilities can make the banking system susceptible to panics and roll-over problems, which will be accompanied by currency depreciation and low returns for investors ; against which the investors will ask for higher returns[\(Bocola and Lorenzoni](#page-52-4) [\(2020\)](#page-52-4)). In Figure [12,](#page-58-0) we plot average excess returns against average FL/FA. In economies where the banking system carries high foreign debt, we see higher expected currency returns.

<span id="page-58-0"></span>![](_page_58_Figure_2.jpeg)

Figure 12: FL/FA and excess returns

Data source: FX4Casts, IMF IFS. Y-axis variable is the average currency return of 25 countries between 02/2003 - 11/2018. X-axis variable is the ratio of foreign liabilities to foreign assets in the banking system

## **A.2 Reserves**

Against foreign borrowing, central banks can hold reserves, which should reduce the risk of rollover crises. However, we do not see a significant relationship between reserves and average excess returns. In figure [13,](#page-59-0) we plot average excess returns against reserves as a share of GDP.

<span id="page-59-0"></span>![](_page_59_Figure_0.jpeg)

Figure 13: Reserves and excess returns

Data source: FX4Casts, IMF IFS. Y-axis variable is the average currency return of 25 countries between 02/2003 - 11/2018. X-axis variable is the reserves as a share of GDP

## **A.3 External Balance**

The third variable we consider is external balance as a share of GDP, which is a proxy for net investment position of a country which is found to be an important determinant of currency returns [\(Della Corte, Riddiough and Sarno](#page-52-3) [\(2016\)](#page-52-3)). The clear negative relationship can be seen in the figure below.

![](_page_60_Figure_0.jpeg)

Figure 14: NFA and excess returns

Data source: FX4Casts, IMF IFS. Y-axis variable is the average currency return of 25 countries between 02/2003 - 11/2018. X-axis variable is the average net external balance as a share of GDP,

## **A.4 Size and Trade Centrality**

Country size [\(Hassan](#page-53-6) [\(2013\)](#page-53-6)) and trade network centrality [\(Richmond](#page-54-7) [\(2019\)](#page-54-7)) is found to be significant determinants of excess currency returns. Shocks to larger and/or to more central economies affect smaller economies but shocks to smaller economies do not spill over to larger economies. Then, assets of larger or more central economies provide insurance not only against country specific shocks, but also against global shocks. Thus, local currency assets of larger and/or more central economies should provide lower returns since there is high demand for them (see Figure [15\)](#page-61-0).

<span id="page-61-0"></span>![](_page_61_Figure_0.jpeg)

Figure 15: Size, centrality and excess returns

Data source: FX4Casts, IMF IFS, [Richmond](#page-54-7) [\(2019\)](#page-54-7). Y-axis variable is the average currency return of 25 countries between 02/2003 - 11/2018. X-axis variables is the average log nominal GDP and average trade network centrality

## **A.5 Financial Depth and Currency Returns**

<span id="page-61-1"></span>Figure [16](#page-61-1) plots total foreign assets and liabilities as a share of GDP, a proxy for financial depth, against excess returns. [Maggiori](#page-54-13) [\(2017\)](#page-54-13) argues that countries whose financial system is deep can intermediate large amounts of flows and carry a safety premium. Net external balance and financial depth highly correlate.

![](_page_61_Figure_5.jpeg)

Figure 16: Excess returns vs Financial Depth

Data source: FX4Casts. Y-axis variable is the average currency return of 25 countries between 02/2003 - 11/2018. X-axis variables is the sum of foreign assets and liabilities of the banking system as a share of GDP, proxy for financial depth.

## **A.6 Dollar Invoicing and Currency Returns**

Figure [17a](#page-62-0) provides a clear visual illustration of this two-part mechanism. Panel (a) plots the strong, negative relationship between Dollar Invoicing and the GDP-ER correlation (R² = 0.198). This visually confirms our first finding: as invoicing increases, the exchange rate becomes more countercyclical.Panel (b) completes the story by showing that this risk is priced. It plots average Excess Returns against Export Invoicing, revealing a positive relationship (R² = 0.143).

<span id="page-62-0"></span>![](_page_62_Figure_2.jpeg)

Figure 17: Currency Cyclicality and Returns, and Dollar Invoicing

Data source: IMF, FX4Casts, [Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-Møller](#page-53-2) [\(2020\)](#page-53-2). Y-axis variables the comovement between GDP-ER and the average currency return of 25 countries between 02/2003 - 11/2018. X-axis variable is the average dollar invoicing share of exports.

## **B Inflation and GDP-ER Co-movement**

In countries where the exports are mostly invoiced in USD, expenditure switching channel is muted. In these economies, the monetary policy faces a dilemma following external shocks. Economies with flexible export prices can respond to external shocks that cause exchange rate depreciations (capital flight, foreign interest rate shock etc.) by increasing exports which stimulates the economy. On the other hand, in countries with sticky export prices, external shocks are more contractionary because of weak response of exports.

Figure [18](#page-63-0) plots average inflation against GDP-ER correlation. In countries with high inflation we tend to see countercyclical exchange rate

Figure [19](#page-63-1) plots average inflation against average excess returns. In countries with high average inflation, demand for local currency assets is low, which drives up local currency interest rates.

<span id="page-63-0"></span>Figure [20](#page-64-0) plots export dollar invoicing against average inflation. In line with our theory, in countries with high dollar invoicing, monetary policy cannot react sharply against external shocks because exchange rate shocks are recessionary. In these economies, we see high average inflation.

![](_page_63_Figure_2.jpeg)

Figure 18: Average Inflation vs GDP-ER Correlation

<span id="page-63-1"></span>Data source: FX4Casts, IMF IFS. S is the Dollar exchange rate and P is the CPI.

![](_page_63_Figure_5.jpeg)

Figure 19: Average Inflation vs Average Excess Returns

Data source: FX4Casts, IMF IFS. Y-axis variable is the average currency return of 25 countries between 02/2003 - 11/2018. X-axis variables are ∆ logGDP and ∆ log <sup>S</sup> P . S is the Dollar exchange rate and P is the CPI.

<span id="page-64-0"></span>![](_page_64_Figure_0.jpeg)

Figure 20: Average Inflation vs Dollar invoicing in exports

Data source: IMF, IFS, [Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-Møller](#page-53-2) [\(2020\)](#page-53-2). Y-axis variables are ∆ logGDP and ∆ log <sup>S</sup> P . S is the Dollar exchange rate and P is the CPI. X-axis variable is the average dollar invoicing share of imports.

In addition to average inflation, we also look at price level volatility[5](#page-64-1) . The results are virtually the same.

![](_page_64_Figure_4.jpeg)

Figure 21: Price Level Volatility vs GDP-ER Correlation

Data source: FX4Casts, IMF IFS. S is the Dollar exchange rate and P is the CPI.

<span id="page-64-1"></span><sup>5</sup>We estimate price level volatility as the standard deviation of log(Pt), where P<sup>t</sup> is the CPI index.

![](_page_65_Figure_0.jpeg)

Figure 22: Price Level Volatility vs Average Excess Returns

Data source: FX4Casts, IMF IFS. Y-axis variable is the average currency return of 26 countries between 02/2003 - 11/2018. S is the Dollar exchange rate and P is the CPI.

![](_page_65_Figure_3.jpeg)

Figure 23: Price Level Volatility vs Dollar invoicing in exports

Data source: IMF, IFS, [Gopinath, Boz, Casas, Díez, Gourinchas and Plagborg-Møller](#page-53-2) [\(2020\)](#page-53-2). Y-axis variables are ∆ logGDP and ∆ log <sup>S</sup> P . S is the Dollar exchange rate and P is the CPI. X-axis variable is the average dollar invoicing share of imports.

## <span id="page-65-0"></span>**C Forward Returns**

Covered interest rate parity gives us an alternative measure for currency returns. Denote F<sup>t</sup> as the price of a forward contract. No arbitrage condition requires that the return to a hedged currency position financed by USD should be equal to the return to USD returns.

<span id="page-66-0"></span>
$$\frac{S_t}{F_t} R_t^L = R_t^{US} \tag{83}$$

We can replace R<sup>L</sup> t inside the equation [1](#page-10-3) using the equation [83,](#page-66-0)

<span id="page-66-1"></span>
$$R_t^{US} \left( \frac{F_t}{S_{t+1}} - 1 \right) \tag{84}$$

Equation [84](#page-66-1) allows us to overcome the problem of finding compatible interest rates across countries as well as accounting for trading costs using different ask/bid prices. One big potential issue with the forward returns is there are documented large CIP deviations. [Verdelhan](#page-55-2) [\(2018\)](#page-55-2) notes that in CIP holds most of the time in the monthly data. Still, buying forward contracts is the most straightforward strategy to invest in other currencies. Forward returns are by themselves valid returns, irrespective of whether they are a good proxy for actually borrowing in USD and investing in local currency interest rates.

## **D Details of the Model**

## **D.1 Household First-Order Conditions**

Work with the real budget constraint

<span id="page-66-2"></span>
$$d_t + d_t^* + p_t^c C_t = R_{t-1} d_{t-1} + s_t R_{t-1}^* d_{t-1}^* + w_t l_t + T_t, \qquad s_t \equiv \frac{S_t}{S_{t-1}}.$$
 (85)

Let µ<sup>t</sup> be the multiplier on [\(85\)](#page-66-2). The FOC for consumption is

<span id="page-66-3"></span>
$$u_C(C_t) - \mu_t p_t^c = 0, \qquad \mu_t = \frac{u_C(C_t)}{p_t^c}.$$
 (86)

The FOC for labor is

<span id="page-66-4"></span>
$$-\xi l_t^{\varphi_l} + \mu_t w_t = 0. (87)$$

Substituting [\(86\)](#page-66-3) into [\(87\)](#page-66-4) gives

$$\frac{w_t}{p_t^c} = \frac{\xi l_t^{\varphi_l}}{u_C(C_t)}. (88)$$

Define total real savings A<sup>t</sup> = d<sup>t</sup> + d ∗ <sup>t</sup> and dollar share Θ<sup>t</sup> = d ∗ t /A<sup>t</sup> . The portfolio return chosen at time t is

$$(1 - \Theta_t)R_t + \Theta_t s_{t+1} R_t^*. \tag{89}$$

The FOC for total savings is

$$u_C(C_t) = \beta_t \left[ \frac{u_C(C_{t+1})}{\prod_{t=1}^c} \left( (1 - \Theta_t) R_t + \Theta_t s_{t+1} R_t^* \right) \right].$$
 (90)

For a pure local-currency asset this reduces to

$$1 = R_{tt}[m_{t+1}], (91)$$

and for a pure dollar asset it reduces to

$$1 = R_{tt}^* \left[ m_{t+1} \frac{S_{t+1}}{S_t} \right]. {(92)}$$

The FOC for the dollar share is

$$-\gamma_{\Theta}(\Theta_{t} - \Upsilon_{t}) + \beta A_{tt} \left[ \frac{u_{C}(C_{t+1})}{\Pi_{t+1}^{c}} \left( s_{t+1} R_{t}^{*} - R_{t} \right) \right] = 0.$$
 (93)

Rearranging gives

$$\gamma_{\Theta}(\Theta_t - \Upsilon_t) = \beta A_{tt} \left[ \frac{u_C(C_{t+1})}{\Pi_{t+1}^c} \left( R_t - s_{t+1} R_t^* \right) \right]. \tag{94}$$

## **D.2 CES Demand Systems**

For a generic two-input CES aggregator

<span id="page-67-0"></span>
$$Q = \left[ a^{1/\eta} q_1^{\frac{\eta - 1}{\eta}} + (1 - a)^{1/\eta} q_2^{\frac{\eta - 1}{\eta}} \right]^{\frac{\eta}{\eta - 1}}, \tag{95}$$

a competitive producer solves

$$\min_{q_1, q_2} P_1 q_1 + P_2 q_2 \tag{96}$$

subject to (95). The FOCs imply

$$\frac{P_1}{P_2} = \left(\frac{a}{1-a}\right)^{1/\eta} \left(\frac{q_2}{q_1}\right)^{1/\eta}.$$
 (97)

Raising both sides to the power  $\eta$  and rearranging gives

$$\frac{q_1}{q_2} = \frac{a}{1-a} \left(\frac{P_1}{P_2}\right)^{-\eta}.\tag{98}$$

The demand functions and price index are therefore

$$q_1 = a \left(\frac{P_1}{P_Q}\right)^{-\eta} Q,\tag{99}$$

$$q_2 = (1-a)\left(\frac{P_2}{P_Q}\right)^{-\eta}Q,$$
 (100)

$$P_Q = \left[ a P_1^{1-\eta} + (1-a) P_2^{1-\eta} \right]^{\frac{1}{1-\eta}}.$$
 (101)

The consumption, investment, and export demand systems in the main text follow by assigning Q to  $C_t$ ,  $I_t$ , or  $X_t$  and choosing the appropriate share parameter and elasticity.

For the continuum CES aggregator

$$Y_t = \left[ \int_0^1 Y_{i,t}^{\frac{\varepsilon - 1}{\varepsilon}} i \right]^{\frac{\varepsilon}{\varepsilon - 1}}, \tag{102}$$

cost minimization gives

$$Y_{i,t} = Y_t \left(\frac{P_{i,t}}{P_t}\right)^{-\varepsilon}, \qquad P_t = \left[\int_0^1 P_{i,t}^{1-\varepsilon} i\right]^{\frac{1}{1-\varepsilon}}.$$
 (103)

## D.3 Domestic Calvo Pricing

A domestic intermediate firm that can reset its price at time t chooses  $\widetilde{P}_t$  to maximize

$${}_{t}\sum_{j=0}^{\infty}(\beta\theta_{p})^{j}\frac{u_{C}(C_{t+j})}{P_{t+j}^{c}}\left(\widetilde{P}_{t}-P_{t+j}mc_{t+j}\right)Y_{t+j}\left(\frac{\widetilde{P}_{t}}{P_{t+j}}\right)^{-\varepsilon}.$$
(104)

Differentiating with respect to  $\widetilde{P}_t$  gives

$$\sum_{t=0}^{\infty} (\beta \theta_p)^j \frac{u_C(C_{t+j})}{P_{t+j}^c} P_{t+j}^{\varepsilon} Y_{t+j} \left[ \frac{\widetilde{P}_t}{P_{t+j}} - \frac{\varepsilon}{\varepsilon - 1} m c_{t+j} \right] = 0.$$
 (105)

Collecting the terms that multiply the reset price and the terms involving marginal cost yields

$$\widetilde{p}_t = \frac{\mathcal{K}_t^p}{\mathcal{F}_t^p},\tag{106}$$

with the recursive sums reported in (16) and (17). The aggregate price index satisfies

$$P_t^{1-\varepsilon} = (1-\theta_p)\widetilde{P}_t^{1-\varepsilon} + \theta_p P_{t-1}^{1-\varepsilon}.$$
 (107)

#### D.4 Export Pricing in Dollars

The export-input aggregator implies the demand curve

$$X_{i,t} = X_t^d \left(\frac{P_{i,t}^{d,x}}{P_t^{d,x}}\right)^{-\varepsilon_x}.$$
 (108)

A resetting export producer chooses a dollar price  $\widetilde{P}_t^{d,x}$  to maximize the discounted value of local-currency profits:

$${}_{t}\sum_{j=0}^{\infty}(\beta\theta_{x})^{j}\frac{u_{C}(C_{t+j})}{P_{t+j}^{c}}\left[S_{t+j}\widetilde{P}_{t}^{d,x}-P_{t+j}\right]X_{t+j}^{d}\left(\frac{\widetilde{P}_{t}^{d,x}}{P_{t+j}^{d,x}}\right)^{-\varepsilon_{x}}.$$

$$(109)$$

The term  $S_{t+j}\widetilde{P}_t^{d,x}$  is local-currency revenue from a dollar price, while  $P_{t+j}$  is the local-currency marginal cost of the domestic input. Differentiating gives the export-sector reset-price condition

$$\widetilde{p}_t^{d,x} = \frac{\mathcal{K}_t^x}{\mathcal{F}_t^x},\tag{110}$$

where the numerator contains discounted marginal costs and the denominator contains discounted demand. The export dollar-price index evolves according to

$$(P_t^{d,x})^{1-\varepsilon_x} = (1-\theta_x)(\widetilde{P}_t^{d,x})^{1-\varepsilon_x} + \theta_x(P_{t-1}^{d,x})^{1-\varepsilon_x}.$$
 (111)

Dividing by  $(P_t^{d,x})^{1-\varepsilon_x}$  gives

$$1 = (1 - \theta_x)(\widetilde{p}_t^{d,x})^{1 - \varepsilon_x} + \theta_x(\Pi_t^{d,x})^{\varepsilon_x - 1}, \tag{112}$$

where  $\Pi_t^{d,x} \equiv P_t^{d,x}/P_{t-1}^{d,x}$ . This equation links reset prices to export dollar-price inflation and makes clear that  $\theta_x$  governs the degree of dominant-currency pricing.

## D.5 Banker Leverage and Currency Choice

The banker value function is

$$V_{j,t} = E_t \left[ \beta (1 - \theta_b) N_{j,t+1} + \beta \theta_b \Lambda_{t,t+1} V_{j,t+1} \right]. \tag{113}$$

Using the scaled net-worth law, the value per unit of net worth for foreign-currency borrowing can be written as

$$\psi_t^{FC} = \max_{L_t^{FC}} {}_t \left[ \beta \Lambda_{t,t+1} \Omega_{t+1}^{FC} \left( L_t^{FC} \left( R_{t+1}^k - R_t^* \frac{S_{t+1}}{S_t} \right) + R_t^* \frac{S_{t+1}}{S_t} \right) \right], \tag{114}$$

where

$$\Omega_{t+1}^{FC} = (1 - \theta_b) + \theta_b \psi_{t+1}^{FC}. \tag{115}$$

Define

$$\eta_t^{FC} \equiv E_t \left[ \beta \Lambda_{t,t+1} \Omega_{t+1}^{FC} \left( R_{t+1}^k - R_t^* \frac{S_{t+1}}{S_t} \right) \right], \tag{116}$$

$$\nu_t^{FC} \equiv E_t \left[ \beta \Lambda_{t,t+1} \Omega_{t+1}^{FC} R_t^* \frac{S_{t+1}}{S_t} \right]. \tag{117}$$

Then

$$\psi_t^{FC} = \eta_t^{FC} L_t^{FC} + \nu_t^{FC}. \tag{118}$$

Under the binding incentive constraint  $\psi_t^{FC} = \lambda_b L_t^{FC}$ ,

$$\lambda_b L_t^{FC} = \eta_t^{FC} L_t^{FC} + \nu_t^{FC}, \qquad L_t^{FC} = \frac{\nu_t^{FC}}{\lambda_b - \eta_t^{FC}}.$$
 (119)

The local-currency formulas are analogous:

$$L_t^{LC} = \frac{\nu_t^{LC}}{\lambda_b - \eta_t^{LC}},\tag{120}$$

$$\eta_t^{LC} = E_t \left[ \beta \Lambda_{t,t+1} \Omega_{t+1}^{LC} (R_{t+1}^k - R_t) \right], \tag{121}$$

$$\nu_t^{LC} = E_t \left[ \beta \Lambda_{t,t+1} \Omega_{t+1}^{LC} R_t \right]. \tag{122}$$

The bank chooses its dollar-liability share by solving

$$\max_{\phi_t} (1 - \phi_t) \psi_t^{LC} + \phi_t \psi_t^{FC} - \frac{\chi_\phi}{2} (\phi_t - \bar{\phi})^2.$$
 (123)

The FOC is

$$-\psi_t^{LC} + \psi_t^{FC} - \chi_\phi(\phi_t - \bar{\phi}) = 0, \tag{124}$$

or

$$\psi_t^{FC} - \psi_t^{LC} = \chi_\phi(\phi_t - \bar{\phi}). \tag{125}$$

Using ψ k <sup>t</sup> = λbL k <sup>t</sup> gives

$$\phi_t - \bar{\phi} = \frac{\lambda_b}{\chi_\phi} (L_t^{FC} - L_t^{LC}). \tag{126}$$

## **E From Dollar Liabilities and Export Pricing to the Unconditional UIP Premium**

This appendix provides the derivation behind Section [4.](#page-28-0) The goal is to connect the bank's conditional funding wedge to the unconditional currency risk premium that appears in the quantitative exercises. The derivation proceeds in five steps. First, we derive the conditional bank-weighted UIP wedge from the bank's currency-choice problem. Second, we map that conditional wedge into the simple local-currency premium using a covariance decomposition. Third, we show how the level of dollar liabilities, ϕ¯, scales the covariance between depreciation and bank net worth. Fourth, we map bank net worth into the continuation-value component of the banker stochastic discount factor. Fifth, we combine these objects into a local expression for the unconditional premium.

## **E.1 The bank-weighted funding wedge**

Let

$$s_{t+1} \equiv \frac{S_{t+1}}{S_t}$$

denote gross depreciation. The bank valuation kernel for funding currency k ∈ {LC, F C} is

$$\mathcal{M}_{t+1}^k = \beta \Lambda_{t,t+1} \Omega_{t+1}^k, \tag{127}$$

where Λt,t+1 is the household stochastic discount factor and Ω k <sup>t</sup>+1 is the continuationvalue component of bank net worth.

The local-currency and foreign-currency funding terms are

$$\nu_t^{LC} = \mathbb{E}_t \left[ \mathcal{M}_{t+1}^{LC} R_t \right], \tag{128}$$

and

$$\nu_t^{FC} = \mathbb{E}_t \left[ \mathcal{M}_{t+1}^{FC} R_t^* s_{t+1} \right]. \tag{129}$$

Define the bank-weighted funding wedge as

<span id="page-72-3"></span>
$$\mathcal{U}_t^B \equiv \nu_t^{LC} - \nu_t^{FC}.\tag{130}$$

This is the bank-valued excess return on local-currency funding relative to dollar funding.

The bank's value per unit of net worth in funding currency k can be written as

<span id="page-72-0"></span>
$$\psi_t^k = \eta_t^k L_t^k + \nu_t^k, \qquad k \in \{LC, FC\}.$$
 (131)

Under the binding incentive constraint,

<span id="page-72-1"></span>
$$\psi_t^k = \lambda_b L_t^k. \tag{132}$$

Combining [\(131\)](#page-72-0) and [\(132\)](#page-72-1) gives

<span id="page-72-2"></span>
$$L_t^k = \frac{\nu_t^k}{\lambda_b - \eta_t^k}. (133)$$

Linearize (133) around a symmetric reference point with

$$L_t^{LC} \simeq L_t^{FC} \simeq L, \qquad \eta_t^{LC} \simeq \eta_t^{FC} \simeq \eta, \qquad \nu_t^{LC} \simeq \nu_t^{FC} \simeq \nu.$$

A first-order expansion gives

<span id="page-73-1"></span>
$$L_t^{FC} - L_t^{LC} \approx \frac{1}{\lambda_b - \eta} \left[ \left( \nu_t^{FC} - \nu_t^{LC} \right) + L \left( \eta_t^{FC} - \eta_t^{LC} \right) \right]. \tag{134}$$

The funding wedge raises the value of levered foreign-currency excess returns and lowers the value of the unlevered foreign-currency funding return relative to local currency. Locally,

<span id="page-73-0"></span>
$$\nu_t^{LC} - \nu_t^{FC} \approx \mathcal{U}_t^B, \qquad \eta_t^{LC} - \eta_t^{FC} \approx -\mathcal{U}_t^B.$$
 (135)

Substituting (135) into (134) yields

<span id="page-73-2"></span>
$$L_t^{FC} - L_t^{LC} \approx \frac{L - 1}{\lambda_b - \eta} \mathcal{U}_t^B. \tag{136}$$

The bank chooses its dollar-liability share by solving

$$\max_{\phi_t} (1 - \phi_t) \psi_t^{LC} + \phi_t \psi_t^{FC} - \frac{\chi_\phi}{2} (\phi_t - \bar{\phi})^2.$$
 (137)

The first-order condition is

$$\psi_t^{FC} - \psi_t^{LC} = \chi_\phi(\phi_t - \bar{\phi}). \tag{138}$$

Using  $\psi_t^k = \lambda_b L_t^k$ , this becomes

<span id="page-73-3"></span>
$$L_t^{FC} - L_t^{LC} = \frac{\chi_\phi}{\lambda_b} (\phi_t - \bar{\phi}). \tag{139}$$

Combining (136) and (139) gives

$$\mathcal{U}_t^B = \frac{\chi_\phi(\lambda_b - \eta)}{\lambda_b(L - 1)} (\phi_t - \bar{\phi}). \tag{140}$$

The terms L,  $\eta$ , and  $\nu$  are equilibrium objects. Since export-price stickiness changes

output, capital returns, exchange-rate volatility, and bank net worth, we write

$$\eta = \eta(\theta_x, \bar{\phi}), \qquad \nu = \nu(\theta_x, \bar{\phi}), \qquad L(\theta_x, \bar{\phi}) = \frac{\nu(\theta_x, \phi)}{\lambda_b - \eta(\theta_x, \bar{\phi})}.$$
(141)

Thus

<span id="page-74-3"></span>
$$\mathcal{U}_t^B = \Gamma(\theta_x, \bar{\phi})(\phi_t - \bar{\phi}),\tag{142}$$

where

$$\Gamma(\theta_x, \bar{\phi}) = \frac{\chi_{\phi}[\lambda_b - \eta(\theta_x, \bar{\phi})]}{\lambda_b[L(\theta_x, \bar{\phi}) - 1]} = \frac{\chi_{\phi}[\lambda_b - \eta(\theta_x, \bar{\phi})]^2}{\lambda_b[\nu(\theta_x, \bar{\phi}) - \lambda_b + \eta(\theta_x, \bar{\phi})]}.$$
(143)

This is the conditional bank-side mapping. It should not be confused with the unconditional currency risk premium. The latter depends on the covariance between depreciation and the pricing kernel.

#### E.2 From the bank-weighted wedge to the simple currency premium

The simple local-currency premium is

$$p_t^{LC} \equiv R_t - R_t^* \mathbb{E}_t s_{t+1}. \tag{144}$$

Using (130),

<span id="page-74-1"></span>
$$\mathcal{U}_{t}^{B} = \mathbb{E}_{t}[\mathcal{M}_{t+1}^{LC}]R_{t} - R_{t}^{*}\mathbb{E}_{t}[\mathcal{M}_{t+1}^{FC}s_{t+1}]. \tag{145}$$

Now use

<span id="page-74-0"></span>
$$\mathbb{E}_{t}[\mathcal{M}_{t+1}^{FC}s_{t+1}] = \mathbb{E}_{t}[\mathcal{M}_{t+1}^{FC}]\mathbb{E}_{t}[s_{t+1}] + \operatorname{Cov}_{t}(\mathcal{M}_{t+1}^{FC}, s_{t+1}). \tag{146}$$

Substituting (146) into (145) and solving for  $p_t^{LC}$  gives the exact decomposition

<span id="page-74-2"></span>
$$p_{t}^{LC} = \frac{\mathcal{U}_{t}^{B}}{\mathbb{E}_{t}[\mathcal{M}_{t+1}^{LC}]} + R_{t}^{*}\mathbb{E}_{t}s_{t+1} \frac{\mathbb{E}_{t}[\mathcal{M}_{t+1}^{FC}] - \mathbb{E}_{t}[\mathcal{M}_{t+1}^{LC}]}{\mathbb{E}_{t}[\mathcal{M}_{t+1}^{LC}]} + \frac{R_{t}^{*}}{\mathbb{E}_{t}[\mathcal{M}_{t+1}^{LC}]} \operatorname{Cov}_{t}\left(\mathcal{M}_{t+1}^{FC}, s_{t+1}\right).$$
(147)

The first term is the conditional bank wedge. The second term captures differences between average LC and FC valuation kernels. The third term is the covariance-based risk premium. Around a symmetric reference point with  $\mathcal{M}_{t+1}^{LC} \simeq \mathcal{M}_{t+1}^{FC} \equiv \mathcal{M}_{t+1}^{B}$ , (147)

reduces to

<span id="page-75-0"></span>
$$p_t^{LC} \approx \frac{\mathcal{U}_t^B}{\mathbb{E}_t[\mathcal{M}_{t+1}^B]} + \frac{R_t^*}{\mathbb{E}_t[\mathcal{M}_{t+1}^B]} \operatorname{Cov}_t\left(\mathcal{M}_{t+1}^B, s_{t+1}\right). \tag{148}$$

# E.3 Dollar liabilities and the covariance of bank net worth with depreciation

The bank net-worth law of motion can be written as

$$N_{t+1} = R_{t+1}^k Q_t \mathcal{A}_t - R_t B_t^{LC} - R_t^* s_{t+1} B_t^{FC}.$$
(149)

The foreign-currency liability position is

$$B_t^{FC} = (L_t^{FC} - 1)\phi_t N_t. {150}$$

Therefore

$$\frac{N_{t+1}}{N_t} = \frac{R_{t+1}^k Q_t \mathcal{A}_t - R_t B_t^{LC}}{N_t} - R_t^* s_{t+1} (L_t^{FC} - 1) \phi_t.$$
 (151)

Holding predetermined positions fixed, the direct derivative of net-worth growth with respect to depreciation is

$$\left. \frac{\partial}{\partial s_{t+1}} \left( \frac{N_{t+1}}{N_t} \right) \right|_{\text{direct}} = -R_t^* (L_t^{FC} - 1) \phi_t. \tag{152}$$

At the stochastic steady state,  $\phi_t = \bar{\phi}$ . Let

$$\bar{g}_N(\theta_x, \bar{\phi}) \equiv \overline{N_{t+1}/N_t}.$$

The direct log-linear loading of net worth on depreciation is

$$\left. \frac{\partial \widehat{N}_{t+1}}{\partial \widehat{s}_{t+1}} \right|_{\text{ss.direct.}} = -\zeta_N(\theta_x, \bar{\phi}), \tag{153}$$

where

$$\zeta_N(\theta_x, \bar{\phi}) \equiv \frac{\bar{R}^* \bar{s} [\bar{L}^{FC}(\theta_x, \bar{\phi}) - 1] \bar{\phi}}{\bar{g}_N(\theta_x, \bar{\phi})}.$$
 (154)

This is the main scaling result for the level of dollar liabilities. Conditional on leverage and steady-state net-worth growth, the direct exposure of bank net worth to deprecia-

tion is linear in  $\bar{\phi}$ . In the full model,  $\bar{L}^{FC}$  and  $\bar{g}_N$  may also move with  $\theta_x$  and  $\bar{\phi}$ ; those effects are part of the general-equilibrium component below.

Let  $\widehat{N}_{t+1}^{GE}$  denote the part of bank net worth driven by capital returns, output, investment, and other equilibrium objects, after removing the direct foreign-currency liability revaluation term. Then the log-linear representation is

$$\widehat{N}_{t+1} = \widehat{N}_{t+1}^{GE} - \zeta_N(\theta_x, \bar{\phi})\widehat{s}_{t+1}.$$
(155)

Taking the covariance with  $\hat{s}_{t+1}$  gives

<span id="page-76-1"></span>
$$-\operatorname{Cov}_{t}\left(\widehat{N}_{t+1}, \widehat{s}_{t+1}\right) = \zeta_{N}(\theta_{x}, \bar{\phi}) \operatorname{Var}_{t}(\widehat{s}_{t+1}) - \operatorname{Cov}_{t}\left(\widehat{N}_{t+1}^{GE}, \widehat{s}_{t+1}\right)$$

$$\equiv \zeta_{N}(\theta_{x}, \bar{\phi}) \mathcal{V}_{s,t}(\theta_{x}, \bar{\phi}) + \mathcal{B}_{N,t}(\theta_{x}, \bar{\phi}).$$
(156)

The first term is the direct balance-sheet effect. The second term is the general- equilibrium amplification through output, investment, capital returns, and domestic absorption. In the quantitative model,  $\mathcal{B}_{N,t}$  becomes larger when  $\theta_x$  is high because sticky dollar export prices weaken the stabilizing effect of depreciation on external demand.

#### E.4 Continuation value and the banker stochastic discount factor

The continuation-value component of the banker SDF is high when net worth is scarce. Locally, write

<span id="page-76-0"></span>
$$\widehat{\Omega}_{t+1}^{FC} = -\kappa_N \widehat{N}_{t+1} + \widehat{\mathcal{R}}_{t+1}^{FC}, \qquad \kappa_N > 0,$$
(157)

where  $\widehat{\mathcal{R}}_{t+1}^{FC}$  collects the continuation-value effects of expected returns and leverage that are not summarized by contemporaneous net worth. Combining (157) with (156) yields

<span id="page-76-2"></span>
$$\operatorname{Cov}_{t}\left(\widehat{\Omega}_{t+1}^{FC}, \widehat{s}_{t+1}\right) = \kappa_{N}\left[\zeta_{N}(\theta_{x}, \bar{\phi})\mathcal{V}_{s,t}(\theta_{x}, \bar{\phi}) + \mathcal{B}_{N,t}(\theta_{x}, \bar{\phi})\right] + \mathcal{R}_{\Omega,t}(\theta_{x}, \bar{\phi}),$$

$$(158)$$

where

$$\mathcal{R}_{\Omega,t}(\theta_x, \bar{\phi}) \equiv \operatorname{Cov}_t\left(\widehat{\mathcal{R}}_{t+1}^{FC}, \widehat{s}_{t+1}\right). \tag{159}$$

Thus, depreciation is priced because it lowers bank net worth in precisely the states in which the marginal continuation value of intermediary wealth is high.

## **E.5 The household SDF component**

The household stochastic discount factor satisfies, up to constants,

$$\widehat{\Lambda}_{t,t+1} \approx -\sigma \left( \widehat{C}_{t+1} - \widehat{C}_t \right) - \widehat{\Pi}_{t+1}^c. \tag{160}$$

Therefore

$$\operatorname{Cov}_{t}\left(\widehat{\Lambda}_{t,t+1}, \widehat{s}_{t+1}\right) = -\sigma \operatorname{Cov}_{t}\left(\widehat{C}_{t+1} - \widehat{C}_{t}, \widehat{s}_{t+1}\right) - \operatorname{Cov}_{t}\left(\widehat{\Pi}_{t+1}^{c}, \widehat{s}_{t+1}\right).$$

$$(161)$$

Define

$$\chi_C(\theta_x, \bar{\phi}) \equiv -\frac{\operatorname{Cov}\left(\widehat{C}_{t+1} - \widehat{C}_t, \widehat{s}_{t+1}\right)}{\operatorname{Var}(\widehat{s}_{t+1})},\tag{162}$$

and

$$\chi_{\pi}(\theta_x, \bar{\phi}) \equiv \frac{\operatorname{Cov}\left(\widehat{\Pi}_{t+1}^c, \widehat{s}_{t+1}\right)}{\operatorname{Var}(\widehat{s}_{t+1})}.$$
(163)

Then

<span id="page-77-0"></span>
$$\operatorname{Cov}\left(\widehat{\Lambda}_{t,t+1}, \widehat{s}_{t+1}\right) = \left[\sigma \chi_C(\theta_x, \bar{\phi}) - \chi_{\pi}(\theta_x, \bar{\phi})\right] \mathcal{V}_s(\theta_x, \bar{\phi}). \tag{164}$$

A higher θ<sup>x</sup> raises this covariance when sticky dollar export prices make depreciation more contractionary for consumption and output. In that case, depreciation occurs in states of high household marginal utility.

## **E.6 Putting the covariance terms together**

Using

$$\mathcal{M}_{t+1}^{FC} = \beta \Lambda_{t,t+1} \Omega_{t+1}^{FC},$$

a local product expansion gives

<span id="page-77-1"></span>
$$\frac{\operatorname{Cov}_{t}\left(\mathcal{M}_{t+1}^{FC}, s_{t+1}\right)}{\mathbb{E}_{t}\left[\mathcal{M}_{t+1}^{FC}\right]\mathbb{E}_{t}\left[s_{t+1}\right]} \approx \operatorname{Cov}_{t}\left(\widehat{\Lambda}_{t,t+1}, \widehat{s}_{t+1}\right) + \operatorname{Cov}_{t}\left(\widehat{\Omega}_{t+1}^{FC}, \widehat{s}_{t+1}\right) + \mathcal{T}_{t}(\theta_{x}, \bar{\phi}), \tag{165}$$

where  $\mathcal{T}_t(\theta_x, \bar{\phi})$  collects higher-order interaction terms, including the covariance between depreciation and the product of the household-SDF and continuation-value components. These terms are relevant in the third-order solution used for the stochastic steady state.

Substituting (158) and (164) into (165) gives

<span id="page-78-0"></span>
$$\frac{\operatorname{Cov}_{t}\left(\mathcal{M}_{t+1}^{FC}, s_{t+1}\right)}{\mathbb{E}_{t}[\mathcal{M}_{t+1}^{FC}]\mathbb{E}_{t}[s_{t+1}]} \approx \left[\sigma\chi_{C}(\theta_{x}, \bar{\phi}) - \chi_{\pi}(\theta_{x}, \bar{\phi})\right] \mathcal{V}_{s,t}(\theta_{x}, \bar{\phi}) 
+ \kappa_{N}\left[\zeta_{N}(\theta_{x}, \bar{\phi})\mathcal{V}_{s,t}(\theta_{x}, \bar{\phi}) + \mathcal{B}_{N,t}(\theta_{x}, \bar{\phi})\right] 
+ \mathcal{R}_{\Omega,t}(\theta_{x}, \bar{\phi}) + \mathcal{T}_{t}(\theta_{x}, \bar{\phi}).$$
(166)

Combining (142), (148), and (166), and taking unconditional means, gives

<span id="page-78-1"></span>
$$\bar{p}^{LC} \equiv \mathbb{E}[p_t^{LC}] 
\approx \frac{\mathbb{E}\left[\Gamma(\theta_x, \bar{\phi})(\phi_t - \bar{\phi})\right]}{\bar{\mathcal{M}}^{LC}} 
+ \bar{R}^* \bar{s} \left[\sigma \chi_C(\theta_x, \bar{\phi}) - \chi_\pi(\theta_x, \bar{\phi})\right] \mathcal{V}_s(\theta_x, \bar{\phi}) 
+ \bar{R}^* \bar{s} \kappa_N \left[\zeta_N(\theta_x, \bar{\phi}) \mathcal{V}_s(\theta_x, \bar{\phi}) + \mathcal{B}_N(\theta_x, \bar{\phi})\right] 
+ \bar{R}^* \bar{s} \left[\mathcal{R}_{\Omega}(\theta_x, \bar{\phi}) + \mathcal{T}(\theta_x, \bar{\phi})\right].$$
(167)

Equation (167) is the analytical counterpart of the quantitative results. The first line is the conditional bank funding margin. The remaining lines are the unconditional risk-premium components. The level of dollar liabilities enters through

$$\zeta_N(\theta_x, \bar{\phi}) = \frac{\bar{R}^* \bar{s} [\bar{L}^{FC}(\theta_x, \bar{\phi}) - 1] \bar{\phi}}{\bar{g}_N(\theta_x, \bar{\phi})}.$$

This term is the direct exposure of bank net worth to depreciation. Export-price stickiness enters through  $V_s$ ,  $\chi_C$ ,  $\mathcal{B}_N$ , and the higher- order terms. When  $\theta_x$  rises, depreciation becomes less stabilizing, exchange- rate volatility rises, and depreciation states become states with lower consumption, lower output, lower investment, and scarcer bank net worth.

The direct comparative statics are

$$\frac{\partial \bar{p}^{LC}}{\partial \bar{\phi}} \bigg|_{\text{direct}} \approx \bar{R}^* \bar{s} \kappa_N \frac{\partial \zeta_N(\theta_x, \bar{\phi})}{\partial \bar{\phi}} \mathcal{V}_s(\theta_x, \bar{\phi}) > 0, \tag{168}$$

with

$$\frac{\partial \zeta_N(\theta_x, \bar{\phi})}{\partial \bar{\phi}} \approx \frac{\bar{R}^* \bar{s} [\bar{L}^{FC}(\theta_x, \bar{\phi}) - 1]}{\bar{g}_N(\theta_x, \bar{\phi})} > 0$$
 (169)

when indirect steady-state effects on leverage and net-worth growth are held fixed. The interaction between dollar liabilities and export-price stickiness is

$$\frac{\partial^{2} \bar{p}^{LC}}{\partial \bar{\phi} \, \partial \theta_{x}} \approx \bar{R}^{*} \bar{s} \kappa_{N} \left[ \frac{\partial \zeta_{N}(\theta_{x}, \bar{\phi})}{\partial \bar{\phi}} \frac{\partial \mathcal{V}_{s}(\theta_{x}, \bar{\phi})}{\partial \theta_{x}} + \frac{\partial^{2} \mathcal{B}_{N}(\theta_{x}, \bar{\phi})}{\partial \bar{\phi} \, \partial \theta_{x}} \right] + \text{terms from } \chi_{C}, \ \chi_{\pi}, \ \mathcal{R}_{\Omega}, \ \mathcal{T}. \tag{170}$$

This derivative is positive in the calibrated economy. A higher ϕ¯ increases the quantity of dollar balance-sheet exposure. A higher θ<sup>x</sup> raises the price of that exposure by increasing exchange-rate volatility and by making depreciation more contractionary. Therefore, the unconditional UIP premium is largest when the economy has both high dollar liabilities and sticky dollar export prices.

This derivation explains the quantitative exercises. The impulse responses show that the largest UIP spread occurs when high dollar liabilities are combined with high dollar export invoicing. The stochastic steady-state exercises that vary θ<sup>x</sup> show that exportprice stickiness raises exchange-rate volatility, makes depreciation more countercyclical, and increases the unconditional UIP premium. The appendix exercises that vary ϕ¯ show that the level of dollar liabilities raises the same premium by strengthening the negative covariance between depreciation and bank net worth. All three results are the same mechanism viewed from different margins of [\(167\)](#page-78-1).

## **F Additional Quantitative Results**

## **F.1 Response to Foreign Interest Rate Shocks**

Figure [24](#page-80-0) decomposes the transmission mechanism by simulating the foreign interest rate shock across four distinct economy profiles, varying both the level of dollardenominated debt and the degree of dollar invoicing.

The key observation: the amplification effect of trade frictions is highly contingent on the presence of financial frictions. When foreign currency debt is low, the choice of invoicing currency has a negligible impact on real macroeconomic outcomes; the output and investment trajectories remain largely insulated regardless of the invoicing regime.

Conversely, when the economy has high foreign currency debt, dollar invoicing severely amplifies the shock. In this highly dollarized economy, high dollar invoicing drastically exacerbates the downturn, roughly doubling the peak declines in both investment and GDP compared to an identical low dollar debt economy with low dollar invoicing.

<span id="page-80-0"></span>![](_page_80_Figure_2.jpeg)

Figure 24: Response to Foreign Interest Rate Shock

Figure [25](#page-81-0) shows how financial system moves following foreign interest rate shock. Under high dollar debt, leverage goes up to rebuild balance sheets that have been deteriorated. Local residents decrease savings because they want to smooth consumption so the economy needs to attract foreign capital both in local currency (panel 1,1) and foreign currency (panel 2,1)

<span id="page-81-0"></span>![](_page_81_Figure_0.jpeg)

Figure 25: Financial Flows

## F.2 Varying Dollar Debt in the Steady State

In this Section, we replicate results in Section 5.4 by varying dollar debt in the steady state by changing target portfolio of bankers  $\bar{\phi}$ . Figure 26 plots the increase in ER volatility, and rising UIP premium and inflation following increasing target dollar ratio.

<span id="page-82-0"></span>![](_page_82_Figure_0.jpeg)

Figure 26: Steady State with respect to Dollar Debt (ϕ)

## **F.3 Inflation and GDP-ER Co-movement**

In this section, we use above simulations to generate the relationship between GDP-ER comovement and inflation. Figure [27](#page-83-0) is able to capture the negative relationship between average inflation and the comovement between output and the exchange rate along both dollar debt and dollar invoicing. In countries with negative comovement between GDP and ER, exchange rate is not able to insulate the economy against external shocks; which makes inflation and output more volatile. As a response, both local and foreign investors demand risk premium and if the central bank does not address this premium, inflation increases.

<span id="page-83-0"></span>![](_page_83_Figure_0.jpeg)

Figure 27: Inflation and GDP-ER Co-movement

#### **F.3.1 Equity Premium**

In this section, we look at what happens to equity premium as the macro risk increases with higher dollar invoicing. Equity premium,

$$\mathbb{E}_t(R_{t+1}^k) - R_t$$

where return to capital is defined as marginal product of capital (r k t ) and undepreciated capital priced at current price of capital ((1 − δ)P k t ) divided by price of capital previous period (P k t−1 )

$$R^{k} = \frac{r_{t}^{k} + (1 - \delta)P_{t}^{k}}{P_{t-1}^{k}}$$

We define equity premium as the difference between return to capital and local interest rates. This is slightly misleading because actual cost of capital is defined as the weighted average of funding sources, which also include dollar financing.

Figure [28a](#page-84-0) plots what happens to equity premium as dollar invoicing and dollar debt increase. Equity premium falls. This is because both R<sup>k</sup> <sup>t</sup> and R<sup>t</sup> increase but R<sup>t</sup> increases more. Capital gains part of return to capital provides cushion against global shocks because, as real assets, their value increases with pass through inflation generated by exchange rate depreciations. On the other hand, local interest rates become unattractive investment because they lose value following adverse global shocks, which makes investors require premium to invest.

<span id="page-84-0"></span>![](_page_84_Figure_0.jpeg)

(a) Equity Premium and export dollar price stickiness (θ x )

Figure 28: Steady State Equity Premium

![](_page_85_Picture_0.jpeg)

**Dominant Currency Pricing and Currency Risk Premia**  Working Paper No. WP/2026/158