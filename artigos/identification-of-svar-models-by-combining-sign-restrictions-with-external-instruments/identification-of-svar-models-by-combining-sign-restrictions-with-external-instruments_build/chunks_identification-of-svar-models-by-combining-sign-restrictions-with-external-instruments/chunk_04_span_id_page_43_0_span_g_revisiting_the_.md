# <span id="page-43-0"></span>G Revisiting the oil market model of Baumeister and Hamilton (2019)

As noted in Section 3.1, Baumeister & Hamilton (2019) (BH19) express their prior beliefs on different definitions for the oil price elasticities than used in Kilian & Murphy (2014). To assess the robustness of our empirical results to how we define elasticities, we use this part of the appendix to repeat our oil market exercise within the model of BH19. As opposed of the B type of model we considered in the main part of our paper, this involves a mixture of sign- and exclusion restrictions on  $B^{-1}$  plus formulation of prior densities for the underlying parameters. We start our analysis by broadly replicating the results of BH19 using the methodology proposed in this paper. We then proceed by documenting how the results change once we use Kilian's oil production shortfall series as an IV for the SVAR supply shock.

Following BH19, we use  $y_t = [100 \times \Delta q_t, 100 \times \Delta y_t, 100 \times \Delta p_t, \Delta i_t]'$ , where  $q_t$  is the log of global crude oil production (in million barrels per day),  $y_t$  a world industrial production index,  $p_t$  is the log of the real oil price and  $\Delta i_t$  the proxy for OECD oil inventories expressed as a fraction of previous month's global crude oil production. As in their paper, we set p = 12 lags in the VAR and use a slightly updated dataset covering 1974m2 to 2019m4. Their structural oil market model (abstracting from lags and difference notation) is given by the following simultaneous equation system:

$$Supply q_t = \alpha_{pq} p_t + \varepsilon_t^s, (G.1)$$

Economic activity 
$$y_t = \alpha_{py} p_t + \varepsilon_t^{ad},$$
 (G.2)

Consumption demand 
$$q_t - i_t^* = \beta_{py} y_t + \beta_{pq} p_t + \varepsilon_t^{cd},$$
 (G.3)

Inventory demand 
$$i_t^* = \psi_1 q_t + \psi_3 p_t + \varepsilon_t^{id},$$
 (G.4)

Measurement error 
$$i_t = \chi i_t^* + \varepsilon_t^{me}$$
. (G.5)

In this model,  $\alpha_{pq} > 0$  is the (unique) oil supply elasticity,  $\alpha_{py} < 0$  is the systematic reaction of global production to oil price changes,  $\beta_{py} > 0$  the income elasticity of oil demand,  $\beta_{pq} < 0$  the oil demand elasticity, and  $0 < \chi < 1$  carries the interpretation of a fraction of latent oil inventories  $(i_t^*)$  observed under a measurement error specification. Furthermore, the structural shocks are assumed to be mutually orthogonal with each variance  $\sigma_i^2$ ,  $i=1,\ldots,4$ . Written in terms of observable VAR forecast errors, the model is given by:

$$\underbrace{\begin{pmatrix}
1 & 0 & -\alpha_{pq} & 0 \\
0 & 1 & -\alpha_{py} & 0 \\
1 & -\beta_{py} & -\beta_{pq} & -\chi^{-1} \\
-\psi_1 & 0 & -\psi_3 & 1
\end{pmatrix}}_{\mathbf{A}} \underbrace{\begin{pmatrix}\nu_t^q \\ u_t^y \\ u_t^p \\ u_t^i \end{pmatrix}}_{u_t} = \underbrace{\begin{pmatrix}
\varepsilon_t^s \\ \varepsilon_t^{ea} \\ \varepsilon_t^{cd} - \chi^{-1} \varepsilon_t^{me} \\ \chi^{-1} \varepsilon_t^{id} + \varepsilon_t^{me} \end{pmatrix}}_{\tilde{\varepsilon}_t}.$$
(G.6)

To further orthogonalize the latter last two shocks, BH19 premultiply the system by a

matrix

<span id="page-44-0"></span>
$$\Gamma = \begin{pmatrix} 1 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 \\ 0 & 0 & 1 & 0 \\ 0 & 0 & \rho & 1 \end{pmatrix},$$

where  $\rho = \frac{\chi^{-1}\sigma_{me}^2}{\sigma_{cd}^2 + \chi^{-2}\sigma_{me}^2}$  which yields mutually orthogonal shocks  $\varepsilon_t^{cd\star}$  and  $\varepsilon_t^{id\star}$  and further transforms the last row of A. Augmented by an equation for our IV, the model is then given by:

$$\underbrace{\begin{pmatrix} 1 & 0 & -\alpha_{pq} & 0 \\ 0 & 1 & -\alpha_{py} & 0 \\ 1 & -\beta_{py} & -\beta_{pq} & -\chi^{-1} \\ \psi_1^{\star} & \psi_2^{\star} & \psi_3^{\star} & \psi_4^{\star} \end{pmatrix}}_{\mathbf{A}} \underbrace{\begin{pmatrix} u_t^q \\ u_t^y \\ u_t^p \\ u_t^i \end{pmatrix}}_{u_t} = \underbrace{\begin{pmatrix} \varepsilon_t^s \\ \varepsilon_t^{ea} \\ \varepsilon_t^{cd\star} \\ \varepsilon_t^{id\star} \end{pmatrix}}_{\varepsilon_t^{\star}}.$$
(G.7)

$$m_t = \phi_1 \varepsilon_t^s + \phi_2 \varepsilon_t^{ea} + \phi_3 \varepsilon_t^{cd\star} + \phi_4 \varepsilon_t^{id\star} + \eta_t$$
 (G.8)

Here,  $\psi_1^{\star} = \rho - \psi_1$ ,  $\psi_2^{\star} = -\rho \beta_{py}$ ,  $\psi_3^{\star} = -\rho \beta_{pq} - \psi_1$  and  $\psi_4^{\star} = -\rho \chi^{-1} + 1$ . The last equation allows us to further exploit the information of the IV if further constraints are imposed on  $\phi$ .

We compare results obtained under the following two identification schemes. In model  $R_1$  we closely follow BH19 and combine the exclusion restrictions on  $B^{-1}$  expressed in equation (G.7) with a series of prior distributions that put larger weight on a priori plausible structural parameters:

$$p_{R1}(\beta) \propto |\tilde{B}|^{-(v_0+n+k)} \exp\left(-\frac{1}{2} \operatorname{tr}\left(S_0\left(\tilde{B}\tilde{B}'\right)^{-1}\right)\right) p\left(\alpha_{pq}(\beta)\right) p\left(\alpha_{py}(\beta)\right) p\left(\beta_{py}\left(\beta\right)\right) p\left(\beta_{pq}(\beta)\right) p\left(\chi(\beta)\right).$$

For the exact density specifications of each parameter we refer to the paper of BH19. We note that in contrast to the prior considered in Section 2, it is informative about certain rotations that imply a priori reasonable structural parameters. Also, note that BH19 also specify additional priors on  $\rho$  and  $\psi_{1/2}$  and determinants of A which we do not further consider in our paper as they are not necessary to replicate the results of BH19.

We compare results from model  $R_1$  to those of a second model  $R_2$ . In  $R_2$  we relax the exclusion restrictions in the first equation and instead impose IV restrictions relating the K08 shortfall series to the SVAR supply shock. The model reads then:

$$\underbrace{\begin{pmatrix} 1 & -\alpha_{yq} & -\alpha_{pq} & -\alpha_{iq} \\ 0 & 1 & -\alpha_{py} & 0 \\ 1 & -\beta_{py} & -\beta_{pq} & -\chi^{-1} \\ \psi_1^* & \psi_2^* & \psi_3^* & \psi_4^* \end{pmatrix}}_{\mathbf{A}} \underbrace{\begin{pmatrix} u_t^q \\ u_t^y \\ u_t^p \\ u_t^i \end{pmatrix}}_{u_t} = \underbrace{\begin{pmatrix} \varepsilon_t^s \\ \varepsilon_t^{ea} \\ \varepsilon_t^{cd*} \\ \varepsilon_t^{id*} \end{pmatrix}}_{\varepsilon_t^*}. \tag{G.9}$$

As for the prior in model  $R_2$ , we use the exact same density used for  $R_1$  but disregard from

the additional term on αpq which we would like to test for.[17](#page-45-0) Hence, the prior is given by:

$$p_{R2}(\beta) \propto |\tilde{B}|^{-(v_0+n+k)} \exp\left(-\frac{1}{2} \operatorname{tr}\left(S_0\left(\tilde{B}\tilde{B}'\right)^{-1}\right)\right) p\left(\alpha_{py}(\beta)\right) p(\beta_{py}(\beta)) p\left(\beta_{pq}(\beta)\right) p\left(\chi(\beta)\right).$$

For both priors, we set S<sup>0</sup> and v<sup>0</sup> via a training sample based on the first five years.

Our empirical results are summarized in table [7.](#page-46-0) First, in Panel A we provide the posterior credibility set of the supply elasticity αqp. Model R1 is designed to replicate the results of BH19 and hence finds a very similar posterior of αqp. [18](#page-45-1) The median estimate suggests a fairly large value of about 0.13 in comparison to the upper bound of HR20. In turn, once we replace the exclusion restrictions of the supply equation with the IV constraints (R2), we end up with considerably smaller values of αqp. The posterior is remarkably narrow given that model R2 does not use explicit prior information on αqp. We proceed by testing the competing priors used in the literature (BH19 and HR20) as overidentifying. The resulting Bayes factors are given in Panel B. Similar to the analysis in the main part of this paper, the likelihood of the densities increases from prior to posterior. Hence, there is positive support in favor of using either piece of information. The differences between HR20 and BH19 are not very large, however, closely resembling our findings in the main part of the text.

Finally, we compare the variance contribution of the supply shock to oil prices for two models. In the model designed to replicate BH19 results (R1), we find that supply shocks are fairly important drivers of oil prices, with point estimates of about one third of the variance at both impact and 2 years horizon. Using model R2 plus the BH19 prior for αqp, we arrive at much smaller estimates of between 7% and 11% depending on the horizon. If we use R2 plus the HR20 restriction, similar results are obtained in terms of magnitudes, although with considerable smaller confidence sets. Overall, the findings are similar to those of Section [3.1](#page-17-1) despite relying on different identifying assumptions and definitions of the oil price elasticity.

<span id="page-45-0"></span><sup>17</sup>However, similar to the exercise conducted in the main part, we maintain the sign restriction that αpq > 0.

<span id="page-45-1"></span><sup>18</sup>The posterior distribution of the other structural parameters also match those of BH19. Those are αpy, βpy, βpq and χ.

<span id="page-46-0"></span>Table 7: Posterior distribution of supply elasticities and Bayes factors for overidentifying restrictions using the model of [Baumeister & Hamilton \(2019\)](#page-26-8).

| Panel A: Posterior of supply elasticity<br>αqp                                  |                  |           |           |      |
|---------------------------------------------------------------------------------|------------------|-----------|-----------|------|
| Model                                                                           | 16%              | 50%       | 84%       |      |
| R1                                                                              | 0.096            | 0.134     | 0.181     |      |
| R2                                                                              | 0.013            | 0.039     | 0.081     |      |
| Panel B: Bayes factors testing restrictions on<br>αqp                           |                  |           |           |      |
| Restrictions                                                                    | Eθ Y˜<br>[p2(θ)] | Eθ[p2(θ)] | 2 lnBFc10 | s.e. |
| BH19                                                                            | 3.61             | 0.98      | -2.59     | 0.04 |
| HR20                                                                            | 0.51             | 0.03      | -5.51     | 0.17 |
| s<br>Panel C: Contribution of<br>ε<br>to the FEVD of the real price of oil<br>t |                  |           |           |      |
| Model                                                                           | h<br>= 0         |           | h<br>= 24 |      |

| Model     | h<br>= 0     | h<br>= 24    |
|-----------|--------------|--------------|
| R1        | 0.33         | 0.32         |
|           | (0.23, 0.45) | (0.22, 0.44) |
| R2 + BH19 | 0.07         | 0.11         |
|           | (0.03, 0.15) | (0.06, 0.19) |
| R2 + HR20 | 0.04         | 0.07         |
|           | (0.02, 0.06) | (0.04, 0.10) |

Bayes factors computed as described in Section [2.5.](#page-12-0) Here, the less restrictive model is identified using the IV restrictions combined with prior distributions on A but not on αqp (R2), while the more restrictive model additionally imposes prior information on the supply elasticity αqp. For BH19, p2(θ) : αqp ∼ t(0.1, 0.2, 3) while for HR20 p2(θ) : p(αqp ≤ 0.04) = 1 and 0 else. The FEVD of the real oil price is computed at horizon h and values in brackets indicate pointwise 68% posterior credibility sets.