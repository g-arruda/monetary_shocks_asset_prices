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
