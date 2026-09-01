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
