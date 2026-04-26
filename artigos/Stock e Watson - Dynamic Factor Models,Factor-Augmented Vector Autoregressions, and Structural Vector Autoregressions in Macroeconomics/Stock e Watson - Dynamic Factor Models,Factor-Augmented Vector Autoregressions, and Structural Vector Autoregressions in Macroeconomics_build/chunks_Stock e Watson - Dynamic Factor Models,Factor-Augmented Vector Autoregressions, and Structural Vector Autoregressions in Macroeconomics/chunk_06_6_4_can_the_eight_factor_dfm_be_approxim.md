# 6.4 Can the Eight-Factor DFM Be Approximated by a Low-Dimensional VAR?

A key motivation for DFMs is that using many variables improves the ability of the model to span the space of the structural shocks. But is it possible to approximate the DFM by a small VARii? If so, those few variables could take the place of the factors for forecasting, and SVAR methods could be used directly to identify structural shocks without needing the SDFM apparatus: in effect, the unobserved factors could be replaced by observed factors in the form of this small number of variables. An approximation to the factors by observable variables could take two forms. The strong version would be for a small number of variables to span the space of the factors. A weaker version would be for a small number of variables to have VAR innovations that span the space of the factor innovations.jj [Bai and Ng \(2006b\)](#page-103-0) develop tests for whether observable variables span the space of the unobserved factors and apply those tests to the Fama-French facots in portfolio analysis. Following [Bai and Ng \(2006b\),](#page-103-0) we use canonical correlations to examine this possibility in our macro data application.

[Table 5](#page-79-0) examines the ability of four different VARs to approximate the DFM with eight static factors. The first two VARs are representative of small VARs used in empirical work: a four-variable system (VAR-A)with GDP,total employment, personal consumption expenditure (PCE) inflation, and the Fed funds rate, and an eight-variable system (VAR-B) that

ii We thank Chris Sims for raising this question.

jj If the observable variables are an invertible contemporaneous linear combination of the factors then the VAR and the factors will have the same innovations, but having the same innovations do not imply that the observable variables are linear combinations of contemporaneous values of the factors.

<span id="page-79-0"></span>

| Table 5 | Approximating the eight-factor DFM by a eight-variable VAR |
|---------|------------------------------------------------------------|
|         | Canonical correlation                                      |

|                                  | 1                            | 2                            | 3                            | 4                            | 5                    | 6                    | 7                    | 8                    |
|----------------------------------|------------------------------|------------------------------|------------------------------|------------------------------|----------------------|----------------------|----------------------|----------------------|
| (A) Innovations                  |                              |                              |                              |                              |                      |                      |                      |                      |
| VAR-A<br>VAR-B<br>VAR-C<br>VAR-O | 0.76<br>0.83<br>0.86<br>0.83 | 0.64<br>0.67<br>0.81<br>0.80 | 0.6<br>0.59<br>0.78<br>0.69  | 0.49<br>0.56<br>0.76<br>0.56 | 0.37<br>0.73<br>0.50 | 0.33<br>0.58<br>0.26 | 0.18<br>0.43<br>0.16 | 0.01<br>0.35<br>0.02 |
| (B) Variables and factors        |                              |                              |                              |                              |                      |                      |                      |                      |
| VAR-A<br>VAR-B<br>VAR-C<br>VAR-O | 0.97<br>0.97<br>0.98<br>0.98 | 0.85<br>0.95<br>0.93<br>0.96 | 0.79<br>0.89<br>0.90<br>0.88 | 0.57<br>0.83<br>0.87<br>0.84 | 0.61<br>0.79<br>0.72 | 0.43<br>0.78<br>0.39 | 0.26<br>0.57<br>0.18 | 0.10<br>0.41<br>0.02 |

Notes: All VARs contain four lags of all variables. The canonical correlations in panel A are between the VAR residuals and the residuals of a VAR estimated for the eight static factors.

VAR-A was chosen to be typical of four-variable VARs seen in empirical applications. Variables: GDP, total employment, PCE inflation, and Fed funds rate.

VAR-B was chosen to be typical of eight-variable VARs seen in empirical applications. Variables: GDP, total employment, PCE inflation, Fed funds, ISM manufacturing index, real oil prices (PPI-oil), corporate paper-90-day treasury spread, and 10 year–3 month treasury spread.

VAR-C variables were chosen by stepwise maximization of the canonical correlations between the VAR innovations and the static factor innovations. Variables: industrial commodities PPI, stock returns (SP500), unit labor cost (NFB), exchange rates, industrial production, Fed funds, labor compensation per hour (business), and total employment (private).

VAR-O variables: real oil prices (PPI-oil), global oil production, global commodity shipment index, GDP, total employment (private), PCE inflation, Fed funds rate, and trade-weighted US exchange rate index.

Entries are canonical correlations between (A) factor innovations and VAR residuals and (B) factors and observable variables.

additionally has the ISM manufacturing index, the oil price PPI, the corporate paper-90-day treasury spread, and the 3 month–10 year treasury term spread. The eight variables in the thirdVAR (VAR-C)were selected using a stepwise procedureto produce a highfit between VAR residuals andtheinnovationsinthe eight staticfactors (ie,the residualsintheVAR with the eight staticfactors).This procedure ledtotheVAR-C variables beingtheindex of IP, real personal consumption expenditures, government spending, the PPI for industrial commodities, unit labor costs for business, the S&P500, the 6 month–3 month term spread, and a trade-weighted index of exchange rates.kk The final VAR, VAR-O, is used for the SVAR analysis of the effect of oil shocks in [Section 7](#page-81-0) and is discussed there.

kk The variables in VAR-C were chosen from the 207 variables so that the ith variable maximizes the ith canonical correlation between the residuals from the i-variable VAR and the residuals from the eightfactor VAR. In the first step, the variable yielding the highest canonical correlation between its autoregressive residual and the factor VAR residuals was chosen. In the second step, the variable that maximized the second canonical correlation among all 206 two-variable VAR residuals (given the first VAR variable) and the factor VAR residuals was chosen. These steps continued until eight variables were chosen.

[Table 5](#page-79-0) (panel A) examines whether the VAR innovations are linear combinations of the eight innovations in the static factors by reporting the canonical correlations between the two sets of residuals. For the four-variable VAR, the first canonical correlation is large, as are the first several canonical correlations in the eight-variable VARs, indicating that some linear combinations of the DFM innovations can be constructed from linear combinations of the VAR innovations. But the canonical correlations drop off substantially. For the eight-variable VAR-B, the final four canonical correlations are less than 0.40, indicating that the innovation space of this typical VAR differs substantially from the innovation space of the factors. Even for VAR-C, for which the variables were chosen to maximize the stepwise canonical correlations of the innovations, the final three canonical correlations are less than 0.60, indicating that there is substantial variation in the factor innovations that is not captured by the VAR innovations.

[Table 5](#page-79-0) (panel B) examine whether the observable variables span the space of the factors, without leads and lags, by reporting the canonical correlations between the observable variables and the factors for the three VARs. For the four-variable VAR, the canonical correlations measure the extent to which the observable variables are linear combinations of the factors; for the eight-variable VARs, the canonical correlations measure whether the spaces spanned by the observable variables and the factors are the same, so that the eight latent factors estimated from the full dataset could be replaced by the eight observable variables. The canonical correlations in panel B indicate that the observable variables are not good approximations to the factors. In VAR-B, three of the canonical correlations are less than 0.50, and even in VAR-C two of the canonical correlations are less than 0.6.

These results have several caveats. Because the factors are estimated, the sample canonical correlations will be less than one even if in population they equal one, and no measure of sampling variability is provided. Also, VAR-C was chosen by a stepwise procedure, and presumably a better approximation would obtain were it possible to choose the approximating VAR out of all possible eight-variable VARs.ll

Still, these results suggest that while typical VARs capture important aspects of the variation in the factors, they fail to span the space of the factors and their innovations fail to span the space of the factor innovations. Overall, these results suggest that the DFM, by summarizing information from a large number of series and reducing the effect of measurement error and idiosyncratic variation, produces factor innovations that contain information not contained in small VARs.

ll Other methods for selecting variables, for example stepwise maximization of the ith canonical correlation between the variable and the factor (instead of between the VAR innovations and the factor innovations) yielded similar results to those for VAR-C in [Table 5](#page-79-0).

# <span id="page-81-0"></span>7. MACROECONOMIC EFFECTS OF OIL SUPPLY SHOCKS

This section works through an empirical example that extends SVAR identification schemes to SDFMs. The application is to estimating the macroeconomic effects of oil market shocks, using identification schemes taken from the literature on oil and the macroeconomy. For comparison purposes, results are provided using a 207-variable SDFM with eight factors, a 207-variable FAVAR in which one or more of factors are treated as observed, and an eight-variable SVAR.

# 7.1 Oil Prices and the Macroeconomy: Old Questions, New Answers

Oil plays a central role in developed economies, and for much of the past half century the price of oil has been highly volatile. The oil price increases of the 1970s were closely linked to events such as the 1973–74 OPEC oil embargo and wars in the Middle East, as well as to developments in international oil markets ([Hamilton, 2013;](#page-106-0) [Baumeister and](#page-103-0) [Kilian, 2016](#page-103-0)). The late 1980s through early 2000s were a period of relative quiescence, interrupted mainly by the spike in oil prices during the Iraqi invasion of Kuwait. Since the early 2000s oil prices have again been volatile. The nominal price of Brent oil, an international benchmark, rose from under \$30/barrel in 2002 to a peak of approximately \$140/barrel in June 2008. Oil prices collapsed during the financial crisis and ensuing recession, but by the spring of 2011 recovered to just over \$100/barrel. Then, beginning the summer of 2014, oil prices fell sharply and Brent went below \$30 in early 2016, a decline that was widely seen as stemming in part from the sharp increase in unconventional oil production (hydraulic fracturing). The real oil price over the last three decades is plotted in [Fig. 7A](#page-82-0).

[Fig. 7](#page-82-0)B shows four measures ofthe quarterly percentage change in oil prices, along with its common component estimated using the eight factors from the 207-variable DFM of [Section 6.](#page-63-0) [Fig. 7](#page-82-0)B reminds us that there is no single price of oil, rather oil is a heterogeneous commodity differentiated by grade and extraction location. The four measures of real oil prices (Brent, WTI, US refiners' acquisition cost of imported oil and the PPI for oil, all deflated by the core PCE price index) move closely together but are not identical. As discussed later, in this sectionthese series are restrictedto havethe same common component, which (as can be seen in [Fig. 7B](#page-82-0)) captures the common movements in these four price indices.

Economists have attempted to quantify the effect of oil supply shocks on the US economy ever since the oil supply disruptions of the 1970s. In seminal work, [Hamilton \(1983\)](#page-106-0) found that oil price jumps presaged US recessions; see [Hamilton \(2003, 2009\)](#page-106-0) for updated extensive discussions. Given the historical context of the 1970s, the first wave of analysis of the effect of oil supply shocks on the economy generally treated unexpected changes in oil prices as exogenous and as equivalent to oil supply shocks. In the context of SVAR analysis,

<span id="page-82-0"></span>![](_page_82_Figure_2.jpeg)

Quarterly percent change in real oil price: four oil price series and the common component Fig. 7 Real oil price (2009 dollars) and its quarterly percent change.

this equivalent allows treating the innovation in the oil price equation as an exogenous shock, which in turn corresponds to ordering oil first in a Cholesky decomposition.mm

Recent research, however, has apended this early view that unexpected oil price movements are solely the result of exogenous oil supply shocks and has argued instead that much or most movements in oil prices are in fact due to shocks to global demand or perhaps to demand shocks that are specific to oil (inventory demand). For example, this view accords with the broad perception that the long climb of oil prices in the mid-2000s was associated with increasing global demand, including demand from China, in the face of conventional supply that was growing slowly or even declining before the boom in unconventional oil production began in the late 2000s and early 2010s.

The potential importance of aggregate demand shocks for determining oil prices was proposed in the academic literature by [Barsky and Kilian \(2002\)](#page-103-0)and has been influentially promoted by Kilian [\(2008a,b,](#page-107-0) 2009). Econometric attempts to distinguish oil supply shocks from demand shocks generally do so using SVARs, broadly relying on three identification schemes. The first relies on timing restrictions to impose zeros in the H matrix of Eq. [\(20\).](#page-31-0) The logic here, due to [Kilian \(2009\),](#page-107-0) starts by noting that it is difficult to adjust oil production quickly in response to price changes, so that innovations in the quantity of oil produced are unresponsive to demand shocks during a sufficiently short period of time. As is discussed later in more detail, this timing restriction can be used to identify oil supply shocks.

The second identification scheme uses inequality restrictions: standard supply and demand reasoning suggest that a positive shock to the supply of oil will push down oil prices and increase oil consumption, whereas a positive shock to aggregate demand would push up both oil prices and consumption. This sign restriction approach has been applied by [Peersman and Van Robays \(2009\),](#page-108-0) [Lippi and Nobili \(2012\)](#page-107-0), [Kilian and](#page-107-0) [Murphy](#page-107-0) (2012, 2014), Baumeister [and Peersman \(2013\),](#page-103-0) [Lutkepohl and Nets](#page-107-0) € ˇunajev [\(2014\),](#page-107-0) and Baumeister [and Hamilton \(2015b\)](#page-103-0) among others.

The third identification approach identifies the response to supply shocks using instrumental variables. [Hamilton \(2003\)](#page-106-0) used a list of exogenous oil supply disruptions, such as the Iraqi invasion of Kuwait, as an instrument in a single-equation estimation of the effect of oil supply shocks on GDP which [Kilian \(2008b\)](#page-107-0) extended, also in a singleequation context. Stock and [Watson \(2012a\)](#page-109-0) used the method of external instruments in a SDFM to estimate the impulse responses to oil supply shocks using various instruments, including (like [Hamilton, 2003](#page-106-0)) a list of oil supply disruptions.

Broadly speaking, a common finding from this second wave of research is that oil supply shocks account for a small amount of the variation both in oil prices and in aggregate economic activity, at least since the 1970s. Moreover, this research finds that much or most of

mm Papers adopting this approach include [Shapiro and Watson \(1988\)](#page-109-0) and [Blanchard and Galı´](#page-104-0) (2010).

<span id="page-84-0"></span>the variation in oil prices (at least through 2014) arises from shifts in demand, mainly aggregate demand or demand more specifically for oil.

This section shows how this recent research on oil supply shocks can be extended from SVARs to FAVARs and SDFMs. For simplicity, this illustration is restricted to two contemporaneous identification schemes. The papers closest to the treatment in this section are [Aastveit \(2014\)](#page-102-0), who uses a FAVAR with timing restrictions similar to the ones used here, Charnavoki [and Dolado \(2014\)](#page-104-0) and [Juvenal and Petrella \(2015\)](#page-107-0), who use sign restrictions in a SDFM, and [Aastveit et al. \(2015\)](#page-102-0), who use a combination of sign and timing restrictions in a FAVAR. The results of this section are confirmatory of these papers and more generally of the modern literature that stresses the importance of demand shocks for determining oil prices, and the small role that oil supply shocks have played in determining oil production since the early 1980s. Although the purpose of this section is to illustrate these methods, the work here does contain some novel features and new results.

# 7.2 Identification Schemes

We consider two identification schemes based on the contemporaneous zero restrictions in the H matrix, that is, schemes of the form discussed in [Section 4.2.](#page-39-0) The first identification scheme, which was used in the early oil shocks literature, treats oil prices as exogenous with oil price innovations assumed to be oil price supply shocks. The second identification scheme follows [Kilian \(2009\)](#page-107-0) and distinguishes oil supply shocks from demand shocks by assuming that oil production responds to demand shocks only with a lag.nn The literature continues to evolve, for example [Kilian and Murphy \(2014\)](#page-107-0) include inventory data and use sign restrictions to help to identify oil-specific demand shocks. The treatment in this section does not aim to push the frontier on this empirical issue, but rather to illustrate SDFM, FAVAR, and SVAR methods in a simple setting that is still sufficiently rich to highlight methods and modeling choices.

nn [Kilian's \(2009\)](#page-107-0) treatment used monthly data, whereas here we use quarterly data. The timing restrictions, for example the sluggish response of production to demand, are more appropriate at the monthly than at the quarterly level. [Gu](#page-106-0)ntner € [\(2014\)](#page-106-0) used sign restrictions in an oil-macro SVAR to identify demand shocks and find that oil producers respond negligibly to demand shocks within the month, and that most producers respond negligibly within a quarter, although Saudi Arabia is estimated to respond after a delay of 2 months. The recent development of fracking and horizontal drilling technology also could undercut the validity of the timing restriction, especially at the quarterly level, because new wells are drilled and fracked relatively quickly (in some cases in a matter of weeks). In addition, because well productivity declines much more rapidly than for conventional wells, nonconventional production can respond more quickly to price than can most conventional production. If the restrictions are valid at the monthly frequency but not quarterly, our estimated supply shocks would potentially include demand shocks, biasing our SIRFs. Despite these caveats, however, the results here are similar to those in [Kilian's \(2009\)](#page-107-0) and [Aastveit's \(2014\)](#page-102-0) monthly treatments with the same exclusion restrictions.

<span id="page-85-0"></span>The "oil exogenous" identification scheme is implemented in three related models: a 207-variable SDFM with eight unobserved factors, a 207-variable FAVAR (that is, a SDFM in which some of the eight factors are treated as observed), and an eight-variable SVAR. The [Kilian \(2009\)](#page-107-0) identification scheme is examined in a eight-variable VAR, in a 207-variable FAVAR with three observed and five unobserved factors, and a 207 variable FAVAR with one observed and seven unobserved factors. As is discussed later, this final FAVAR is used instead of a SDFM with all factors unobserved because the oil production innovation plays such a small macroeconomic role that it appears not to be spanned (or is weakly spanned) by the space of innovations to the macro factors.

For the SVAR, identification requires sufficient restrictions on H to identify the column of H associated with the oil supply shock and, for the second assumption, the columns associated with the aggregate demand and oil-specific demand shocks.

For the FAVARs in which the relevant factors (oil prices in the "oil price exogenous" case, and oil production, aggregate demand, and oil prices in the [Kilian \(2009\)](#page-107-0) case) are all modeled as observed, no additional identifying restrictions are needed beyond the SVAR identifying restrictions.

For the SDFM and for the FAVAR with only one of the three factors observed, identification also entails normalizations on the factor loadings Λ and on the matrix G relating the dynamic factor innovations to the static factor innovations.

The SDFM and FAVAR models require determining the number of dynamic factors. Although [Table 2](#page-70-0) (panel C) can be interpreted as suggesting fewer dynamic than static factors, we err on the side of over-specifying the space of innovations so that they span the space of the reduced number of shocks of interest, and therefore set the number of dynamic factors equal to the number of static factors, so in turn the dimension of η<sup>t</sup> (the factor innovations) is eight. Thus we adopt the normalization that G is the identity matrix.

## 7.2.1 Identification by Treating Oil Prices Innovations as Exogenous

The historical starting point of the oil shock literature holds that any unexpected change in oil prices is exogenous to developments in the US economy. One motivation for this assumption is that if unexpected changes in oil prices arise from unexpected developments in supply—either supply disruptions from geopolitical developments or unexpected upticks in production—then those changes are specific to oil supply, and thus can be thought of as oil supply shocks. A weaker interpretation is that oil prices are determined in the world market for oil so that unexpected changes in oil prices reflect international developments in the oil market, and thus are exogenous shocks (although they could be either oil supply or demand shocks). In either case, an unexpected increase in the real price of oil is interpreted as an exogenous oil price shock. Because the oil price shock is identified as the innovation in the (log) price of oil, it is possible to estimate structural impulse responses with respect to this shock.

#### 7.2.1.1 SVAR and FAVAR

Without loss of generality, order the oil price first in the list of variables. The assumption that the oil price shock  $\varepsilon_t^{oil}$  is exogenous, combined with the unit effect normalization, implies that  $\eta_{1t} = \varepsilon_t^{oil}$ . Thus the relation between  $\eta_t$  and  $\varepsilon_t$  in (28) can be written,

$$\eta_t = \begin{pmatrix} 1 & 0 \\ H_{\bullet 1} & H_{\bullet \bullet} \end{pmatrix} \begin{pmatrix} \varepsilon_t^{oil} \\ \widetilde{\eta}_{\bullet t} \end{pmatrix}, \tag{71}$$

where  $\widetilde{\eta}_{\bullet t}$  spans the space of  $\eta_t$  orthogonal to  $\eta_{1t}$ . The vector  $H_{\bullet 1}$  is identified as the coefficient in the (population) regression of  $\eta_{\bullet t}$  on  $\eta_{1t}$ .

In practice, this identification scheme is conveniently implemented by ordering oil first in a Cholesky decomposition; the ordering of the remaining variables does not matter for the purpose of identifying and estimating the SIRFs with respect to the oil shock.

#### 7.2.1.2 SDFM

In addition to the identification of H in (71), identification in the SDFM requires normalization restrictions on the factor loadings  $\Lambda$  and on G. Because the number of static and dynamic factors is the same, we follow Section 5.1.2 and set G to the identity matrix.

If the dataset had a single oil price, then the named factor normalization would equate the innovation in the first factor with the innovations in the common component of oil. Accordingly, with a single oil price measure ordered first among the DFM variables, the first row of  $\Lambda$  would be  $\Lambda_1 = (1\ 0\ ...\ 0)$ . The normalization of the next seven rows (there are eight static factors) is arbitrary, although some care must be taken so that the innovations of the common components of those seven variables, plus oil prices, spans the space of the eight factor innovations.

The 207-variable dataset, however, contains not one but four different measures of oil prices: Brent, WTI, refiners' acquisition cost, and the producer price of oil. All four series, specified as percentage changes in price, are used as indicators that measure the percentage change in the common (unobserved) price of oil, which is identified as the first factor by applying the named factor normalization to all four series. This approach entails using the specification of  $\Lambda$  in (60).

Because *G* is set to the identity matrix, the innovation to the oil price factor is the oil price innovation.

Figure 7 suggests that real oil prices are I(1), and we use oil price growth rates in the empirical analysis, ignoring cointegration restrictions. This is the second approach to handling cointegration discussed in Section 2.1.4. In a fully parametric DFM (Section 2.3.2), imposing cointegration improves efficiency of the estimates, but the constraint may lead to less efficient estimates in nonparametric (principal components) models. This treatment also allows all four oil prices to be used to estimate the loading on the first factor and therefore to name (identify) the oil price factor.

#### <span id="page-87-0"></span>7.2.2 Kilian (2009) Identification

Following Kilian (2009), this scheme separately identifies an oil supply shock, an aggregate world commodity demand shock, and an oil-specific demand shock. This is accomplished by augmenting the system with a measure of oil production (barrels pumped during the quarter) and a measure of global real economic activity. The measure of global economic activity we use here is Kilian's (2009) global index of bulk dry goods shipments.

#### 7.2.2.1 SVAR and FAVAR

The justification for the exclusion restrictions in the H matrix is as follows. (i) Because of technological delays in the ability to adjust production at existing wells, to shut down wells, and to bring new wells on line, crude oil production responds with a delay to demand shocks or to any other macro or global shocks. Thus, within a period, an unexpected change in oil production is exogenous and is therefore an exogenous supply shocks ( $\varepsilon_t^{OS}$ ). Thus the innovation to oil production equals the oil supply shock. (ii) Global economic activity can respond immediately to oil supply shocks and responds to global aggregate demand shocks ( $\varepsilon_t^{GD}$ ), but otherwise is sluggish and responds to no other shocks within the period. (iii) Real oil prices respond to oil supply shocks and aggregate demand shocks within the period, and to other oil price-specific shocks as well, but to no other macro or global shocks. Kilian interprets the other oil price-specific shocks ( $\varepsilon_t^{OD}$ ) as shocks to oil demand that are distinct from aggregate demand shocks; examples are oil inventory demand shocks, perhaps driven by anticipated oil supply shocks, or speculative demand shocks.

The foregoing logic imparts an upper triangular structure to H and a Cholesky ordering to the shocks:

$$\begin{pmatrix}
\eta_t^{oilproduction} \\
\eta_t^{globalactivity} \\
\eta_t^{oilprice} \\
\eta_{\bullet t}
\end{pmatrix} = \begin{pmatrix}
1 & 0 & 0 & 0 \\
H_{12} & 1 & 0 & 0 \\
H_{13} & H_{23} & 1 & 0 \\
H_{1\bullet} & H_{2\bullet} & H_{3\bullet} & H_{\bullet\bullet}
\end{pmatrix} \begin{pmatrix}
\varepsilon_t^{OS} \\
\varepsilon_t^{GD} \\
\varepsilon_t^{OD} \\
\widetilde{\eta}_{\bullet t}
\end{pmatrix}, (72)$$

where the unit coefficients on the diagonal impose the unit effect normalization and the variables are ordered such that the innovations are to global oil production, global aggregate demand, the price of oil, and the remaining series. The first three rows of H identify the three shocks of interest, and the remaining elements of the first, second, and third rows of H are identified as the population regression coefficients of the innovations on the shocks.

For convenience, the identification scheme (72) can be implemented by ordering the first three variables in the order of (72) and adopting a lower triangular ordering (Cholesky factorization) for the remaining variables, renormalized so that the diagonal elements of H equal 1. Only the first three shocks are identified, and the SIRFs with respect to those shocks do not depend on the ordering of the remaining variables.

#### <span id="page-88-0"></span>7.2.2.2 SDFM

The SDFM is identified by the restrictions on H in (72), the named factor normalization for  $\Lambda$ , and setting G to be the identity matrix.

As mentioned earlier, the SDFM implementation treats the oil production factor as observed and the remaining seven factors as unobserved. Of these seven unobserved factors, we are interested in two linear combinations of the factor innovations that correspond to the global activity innovation and the oil price innovation. The combination of one observed factor, two identified unobserved factors, and five unidentified unobserved factors gives a hybrid FAVAR-SDFM. In this hybrid, the named factor normalization is,

$$\begin{bmatrix}
Oil \ production_{t} \\
Global \ activity_{t} \\
p_{t}^{PPI-Oil} \\
p_{t}^{Brent} \\
p_{t}^{WTI} \\
p_{t}^{RAC} \\
X_{7:n,t}
\end{bmatrix} = \begin{bmatrix}
1 & 0 & 0 & 0 & \cdots & 0 \\
0 & 1 & 0 & 0 & \cdots & 0 \\
0 & 0 & 1 & 0 & \cdots & 0 \\
0 & 0 & 1 & 0 & \cdots & 0 \\
0 & 0 & 1 & 0 & \cdots & 0 \\
0 & 0 & 1 & 0 & \cdots & 0 \\
0 & 0 & 1 & 0 & \cdots & 0 \\
0 & 0 & 1 & 0 & \cdots & 0
\end{bmatrix} \begin{bmatrix}
F_{t}^{Oil \ production} \\
F_{t}^{Global \ activity} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ price} \\
F_{t}^{oil \ pric$$

where the first variable is  $OilProduction_t$ , which is treated as an observed factor, the second variable is the global activity (commodity shipment) index, and the next four variables are the four oil price measures. The first factor is the observed oil production factor. The next two factors, which are unobserved, are the global activity factor and the oil price factor. The identity matrix normalization of G associates the innovations with these factors, so that those innovations align with the first three innovations in (72).

# 7.3 Comparison SVAR and Estimation Details

## 7.3.1 Comparison SVAR

Because the SDFM is specified with eight static and dynamic factors, the comparison SVAR was chosen to have eight variables. Of the eight variables in the SVAR, three are those in Kilian's (2009) three-variable SVAR: the real oil price (PPI-oil), global oil production, and Kilian's (2009) global activity index (bulk dry shipping activity). The remaining five variables were chosen to represent different aspects of US aggregate activity, inflation, and financial markets: GDP, total employment, PCE inflation, the Federal funds rate, and a trade-weighted index of exchange rates.

Canonical correlations between the factor innovations and the VAR innovations are summarized in the "VAR-O" row of Table 5 (panel A). While the first few canonical correlations are large, the final four are 0.50 or less. Evidently, the VAR and factor innovations span substantially different spaces.

#### <span id="page-89-0"></span>7.3.2 Summary of SDFM Estimation Steps

#### 7.3.2.1 Summary of Steps

We now summarize the steps entailed in estimating the SIRF for the SDFM of Section 7.2.2 with one observed factor and three identified shocks. From (58), the SIRF with respect to the *i*th shock is,

$$SIRF_i = \Lambda \Phi(L)^{-1} GH_i, \tag{74}$$

where  $H_i$  is the *i*th column of H and i = 1, 2, 3. This SIRF is estimated in the following steps.

- 1. Order the variables as in (73) and, using the restricted  $\Lambda$  in (73), estimate the seven unobserved static factors by restricted least-squares minimization of (13) as discussed in Section 2.3.1. PP Augment these seven factors with OilProduction<sub>t</sub> so that the vector of eight factors has one observed factor (ordered first) and the seven estimated factors. The next five variables in the named factor normalization can be chosen arbitrarily so long as they are not linearly dependent. This step yields the normalized factors  $\hat{F}_t$  and factor loadings  $\hat{\Lambda}$ .
- 2. Use  $\hat{F}_t$  to estimate the VAR,  $\hat{F}_t = \Phi(L)\hat{F}_{t-1} + \eta_t$ , where the normalization G = I is used and the number of innovations equals the number of factors.
- 3. Use the VAR residuals  $\hat{\eta}_t$  to estimate H using the identifying restrictions in (72). Because of the lower triangular structure of H, this can be done using the Cholesky factorization of the covariance matrix of  $\hat{\eta}_t$ , renormalized so that the diagonal elements of H equal one.

#### 7.3.2.2 Additional Estimation Details

Because of the evidence discussed in Section 6 that there is a break in the DFM parameters, possibly associated with the Great moderation break data of 1984, all models were estimated over 1985q1–2014q4.

Standard errors are computed by parametric bootstrap as discussed in Section 5.1.3.

# 7.4 Results: "Oil Price Exogenous" Identification

The focus of this and the next section is on understanding the differences and similarities among the SDFM, FAVAR, and SVAR results. We begin in this section with the results for the "oil price exogenous" identification scheme of Section 7.2.1.

Fig. 8 presents SIRFs for selected variables with respect to the oil price shock computed using the SDFM, the FAVAR in which oil is treated as an observed factor, and the

<sup>&</sup>lt;sup>PP</sup> If there were only one oil price series then  $\Lambda$  and the factors could be estimated as the renormalized principal components estimates in (59).

<sup>&</sup>lt;sup>qq</sup> If the number of innovations were less than the number of factors, the named factor normalization of G would be the upper diagonal normalization in (61) and the reduced number of innovations could be estimated as discussed following (61).

<span id="page-90-0"></span>![](_page_90_Figure_2.jpeg)

Fig. 8 Structural IRFs from the SDFM (blue (dark gray in the print version) solid with 1 standard error bands), FAVAR (red (gray in the print version) dashed), and SVAR (black dots) for selected variables with respect to an oil price shock: "oil prices exogenous" identification. Units: standard deviations for Global Commodity Demand and percentage points for all other variables.

SVAR. The SVAR SIRFs are available only for the eight variables in the SVAR. The figure shows SIRFs in the log levels of the indicated variables. For example, according to the SDFM SIRFs in the upper left panel of Fig. 8, a unit oil price shock increases the level of oil prices by 1% on impact (this is the unit effect normalization), by additional 0.3% after one quarter, then the price of oil reverts partially and after four quarters is approximately 0.8% above its level before the shock. Equivalently, these SIRFs are cumulative SIRFs in the first differences of the variables.

The most striking feature of [Fig. 8](#page-90-0) is that all three sets of SIRFs are quite close, especially at horizons less than eight quarters. There are two main reasons for this. First, as can be seen in [Fig. 7](#page-82-0)B (and in [Table 3](#page-75-0)), a large fraction of the variance of the change in oil prices is explained by its common component, so the innovation in the common component in the unobserved factor DFM is similar to the innovation in the observed factor FAVAR. Second, the forecast errors for one quarter ahead changes in oil prices are similar whether they are generated using the factors or the eight-variable VAR (changes in oil prices are difficult to predict). Putting these two facts together, the innovations in oil prices (or the oil price factor) are quite similar in all three models and, under the oil price exogenous identification scheme, so are the shocks. Indeed, as shown in [Table 8](#page-97-0), the oil price shocks in the three models are similar (the smallest correlation is 0.72). In brief, the innovations in oil prices are spanned by the space of the factor price innovations.

This said, to the extent that the SDFM, FAVAR, and SVAR SIRFs differ, the FAVAR and SVAR SIRFs tend to be attenuated relative to the SDFM, that is, the effect of the oil shock in the SDFM is typically larger. This is consistent with the single observed factor in the FAVAR being measured with error in the FAVAR and SVAR models, which use a single oil price, however this effect is minor.

Concerning substantive interpretation, for the SDFM, FAVAR, and SVAR, two of the SIRFs are puzzling: the oil shock that increases oil prices is estimated to have a small effect on oil production that is statistically insignificant (negative on impact, slightly positive after one and two quarters), and a statistically significant positive immediate impact on global shipping activity. These two puzzling SIRFs raise the question of whether the oil price shock identified in the oil price exogenous scheme is in fact an oil supply shock, which (one would think) should be associated with a decline in oil production and either a neutral or negative impact effect on global shipping activity. These puzzling SIRFs suggest that it is important to distinguish oil price increases that arise from demand from those that stem from a shock to oil supply.

[Table 7](#page-96-0) presents six quarters ahead FEVDs for the identified shock; the results for the "oil price exogenous" identification are given in columns A for the FAVAR and SDFM. For most series, the FAVAR and SDFM decompositions are very similar, consistent with the similarity of the FAVAR and SDFM SIRFs in [Fig. 8](#page-90-0) over six quarters. The results indicate that, over the six-quarter horizon, the identified oil shocks explain no more than 10% of the variation in US GDP, fixed investment, employment, the unemployment rate, and core inflation. Curiously, the oil price shock explains a negligible fraction of the forecast errors in oil production. The series for which the FAVAR and SDFM FEVDs differ the most is the real oil price: not surprisingly, treating the oil price as the observed factor, so the innovation to the oil price is the oil shock, explains much more of the oil price forecast error than does treating the oil price factor as latent.

# <span id="page-92-0"></span>7.5 Results: [Kilian \(2009\)](#page-107-0) Identification

As discussed in [Section 7.2](#page-84-0), the [Kilian \(2009\)](#page-107-0) identification scheme identifies an oil supply shock, a global aggregate demand shock, and an oil-specific demand shock. Because there are eight innovations total in all the models examined here, this leaves five unidentified shocks (or, more precisely, a five-dimensional subspace of the innovations on which no identifying restrictions are imposed).

## 7.5.1 Hybrid FAVAR-SDFM

As indicated in Table 6, the innovations in the first eight principal components explain a very small fraction of the one step ahead forecast error of oil production, that is, the innovation in oil production is nearly not spanned by the space of factor innovations. Under the [Kilian \(2009\)](#page-107-0) identification scheme, the innovation in oil production is the oil supply shock; but this oil supply shock is effectively not in the space of the eight shocks that explain the variation in the macro variables. This raises a practical problem for the SDFM because the identification scheme is asking it to identify a shock from the macro factor innovations, which is arguably not in the space of those innovations, or nearly is not in that space. In the extreme case that the common component of oil production is zero, the estimated innovation to that common component will simply be noise.

For this reason, we modify the SDFM to have a single observed factor, which is the oil production factor. The global demand shock and the oil-specific demand shock are, however, identified from the factor innovations. Thus this hybrid FAVAR–SDFM has one identified observed factor, two identified unobserved factors, and five unidentified unobserved factors.

As discussed in [Section 7.2](#page-84-0), the FAVAR treats the oil price (PPI-oil), global oil production, and the global activity index as observed factors, with five latent factors.

Table 6 Fraction of the variance explained by the eight factors at horizons h¼1 and h¼6 for selected variables: 1985:Q1–2014:Q4

| Variable                                 | h51  | h56  |
|------------------------------------------|------|------|
| GDP                                      | 0.60 | 0.80 |
| Consumption                              | 0.37 | 0.76 |
| Fixed<br>investment                      | 0.38 | 0.76 |
| Employment<br>(non-ag)                   | 0.56 | 0.94 |
| Unemployment<br>rate                     | 0.44 | 0.90 |
| PCE<br>inflation                         | 0.70 | 0.63 |
| PCE<br>inflation—core                    | 0.10 | 0.34 |
| Fed<br>funds<br>rate                     | 0.48 | 0.71 |
| Real<br>oil<br>price                     | 0.74 | 0.78 |
| Oil<br>production                        | 0.06 | 0.27 |
| Global<br>commodity<br>shipment<br>index | 0.39 | 0.51 |
| Real<br>gasoline<br>price                | 0.72 | 0.80 |
