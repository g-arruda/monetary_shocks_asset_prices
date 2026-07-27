## American Economic Association

Narrative Sign Restrictions for SVARs

Author(s): Juan Antolín-Díaz and Juan F. Rubio-Ramírez

Source: The American Economic Review , OCTOBER 2018, Vol. 108, No. 10 (OCTOBER

2018), pp. 2802-2829

Published by: American Economic Association

Stable URL:<https://www.jstor.org/stable/10.2307/26528339>

# REFERENCES

Linked references are available on JSTOR for this article: [https://www.jstor.org/stable/10.2307/26528339?seq=1&cid=pdf](https://www.jstor.org/stable/10.2307/26528339?seq=1&cid=pdf-reference#references_tab_contents)[reference#references\\_tab\\_contents](https://www.jstor.org/stable/10.2307/26528339?seq=1&cid=pdf-reference#references_tab_contents) You may need to log in to JSTOR to access the linked references.

JSTOR is a not-for-profit service that helps scholars, researchers, and students discover, use, and build upon a wide range of content in a trusted digital archive. We use information technology and tools to increase productivity and facilitate new forms of scholarship. For more information about JSTOR, please contact support@jstor.org.

Your use of the JSTOR archive indicates your acceptance of the Terms & Conditions of Use, available at https://about.jstor.org/terms

![](_page_0_Picture_11.jpeg)

American Economic Association is collaborating with JSTOR to digitize, preserve and extend access to The American Economic Review

# Narrative Sign Restrictions for SVARs<sup>†</sup>

By Juan Antolín-Díaz and Juan F. Rubio-Ramírez\*

We identify structural vector autoregressions using narrative sign restrictions. Narrative sign restrictions constrain the structural shocks and/or the historical decomposition around key historical events, ensuring that they agree with the established narrative account of these episodes. Using models of the oil market and monetary policy, we show that narrative sign restrictions tend to be highly informative. Even a single narrative sign restriction may dramatically sharpen and even change the inference of SVARs originally identified via traditional sign restrictions. Our approach combines the appeal of narrative methods with the popularized usage of traditional sign restrictions. (JEL C32, E52, Q35, Q43)

Starting with Faust (1998), Canova and De Nicolo (2002), and Uhlig (2005), it has become common to identify structural vector autoregressions (SVARs) using a handful of uncontroversial sign restrictions on either the impulse response functions (IRFs) or the structural parameters themselves. Such minimalist restrictions are generally weaker than classical identification schemes and, therefore, likely to be agreed upon by a majority of researchers. Additionally, because the structural parameters are set-identified, they lead to conclusions that are robust across the set of SVARs that satisfy the sign restrictions (see Rubio-Ramírez, Waggoner, and Zha 2010 for details). But this minimalist approach is not without cost. The small number of sign restrictions will usually result in a set of structural parameters with very different implications for IRFs, elasticities, historical decompositions, or forecasting error variance decompositions. In the best case, this means that it will be difficult to arrive at meaningful economic conclusions. In the worst case, there is the risk of retaining in the admissible set structural parameters with implausible implications. The latter point was first illustrated by Kilian and Murphy (2012), who showed that, in the context of the global market for crude oil, SVARs identified only through sign restrictions on IRFs imply disputable values for the price elasticity of oil supply to demand shocks. More recently, Arias, Caldara, and Rubio-Ramírez (forthcoming) have pointed out that the identification scheme of Uhlig (2005) retains many

<sup>\*</sup>Antolín-Díaz: Research Department, Fulcrum Asset Management, Marble Arch House 66 Seymour Street, London, W1H 5BT, UK (email: juan.antolin-diaz@fulcrumasset.com); Rubio-Ramírez: Economics Department, Emory University, Rich Memorial Building, Room 306, Atlanta, GA 30322, Federal Reserve Bank of Atlanta, and BBVA Research (email: jrubior@emory.edu). This paper was accepted to the *AER* under the guidance of John Leahy, Coeditor. We are grateful to Gavyn Davies, Dan Waggonner, Lutz Kilian, Michele Lenza, Frank Schorfheide, Thomas Drechsel, and Ivan Petrella for helpful comments and suggestions.

 $<sup>^{\</sup>dagger}$ Go to https://doi.org/10.1257/aer.20161852 to visit the article page for additional materials and author disclosure statement(s).

structural parameters with improbable implications for the systematic response of monetary policy to output. The challenge is to come up with a small number of additional uncontentious sign restrictions that help shrink the set of admissible structural parameters and allow us to reach clear economic conclusions.

We propose a new class of sign restrictions based on narrative information that we call narrative sign restrictions. Narrative sign restrictions constrain the structural parameters by ensuring that around selected historical events the structural shocks and/or historical decompositions agree with the established narrative. For example, a narrative sign restriction on the structural shocks rules out structural parameters that disagree with the view that "a negative oil supply shock occurred at the outbreak of the Gulf War in August 1990," whereas a restriction on the historical decomposition would imply that "a monetary policy shock was the most important driver of the increase in the federal funds rate observed in October 1979." Narrative information in the context of the oil market was used by Kilian and Murphy (2014) to confirm the validity of their proposed identification, but, to the best of our knowledge, we are the first to formalize the idea and develop the methodology. We show that whereas sign restrictions on the IRFs and the structural parameters, which we refer to as traditional sign restrictions, truncate the support of the prior distribution of the structural parameters, narrative sign restrictions instead truncate the support of the likelihood function. Thus, the Bayesian methods in Rubio-Ramírez, Waggoner, and Zha (2010) and Arias, Rubio-Ramírez, and Waggoner (2018) need to be modified for the case of narrative sign restrictions. Narrative sign restrictions complement the traditional ones. In our empirical applications we combine both.

A long tradition, starting with Friedman and Schwartz (1963), uses historical sources to identify structural shocks. A key reference is the work of Romer and Romer (1989), who combed through the minutes of the Federal Open Market Committee (FOMC) to single out a number of events that they argued represented monetary policy shocks. A large number of subsequent papers have adopted and extended Romer and Romer's (1989) approach, documenting and collecting various historical events on monetary policy shocks (Romer and Romer 2004), oil shocks (Hamilton 1985, Kilian 2008), and fiscal shocks (Ramey 2011, Romer and Romer 2010). The objective of these papers is to construct narrative time series that are then treated as a direct measure of the structural shocks of interest. Recognizing that the narrative time series might be imperfect measures of the structural shocks, recent papers have proposed to treat the narrative time series as external instruments of the targeted structural shocks, i.e., correlated with the shock of interest, and uncorrelated with other structural shocks. This approach was first suggested in Stock and Watson (2008) and was developed independently by Stock and Watson (2012) and Mertens and Ravn (2013).<sup>1</sup>

There are important differences between our method and the existing narrative approaches. First, in practice our method only uses a small number of key historical events, and sometimes a single event, as opposed to an entire time series. Like the instrumental variables approach, this alleviates the issue of measurement error in the narrative time series, but with our method the researcher can incorporate only those

<sup>&</sup>lt;sup>1</sup> See also Montiel-Olea, Stock, and Watson (2016).

events upon which there is agreement. It also makes it straightforward to verify how a particular episode affects the results. Second, we impose the narrative information as sign restrictions. For instance, one might not be sure of exactly how much of the October 1979 Volcker reform was exogenous, but one is confident that a contractionary monetary policy shock did occur, and that it was more relevant than other shocks in explaining the unexpected movement in the federal funds rate. Therefore, our method combines the appeal of narrative approaches with the advantages of sign restrictions. Finally, our methods are Bayesian, while most of the existing narrative approaches are frequentist.

We illustrate the methodology by applying it to two well-known examples of SVARs previously identified with traditional sign restrictions for which narrative information is readily available. In particular, we revisit the model of the oil market of Kilian and Murphy (2012) and Inoue and Kilian (2013), and the model of the effects of monetary policy that has been used in Christiano, Eichenbaum, and Evans (1999), Bernanke and Mihov (1998), and Uhlig (2005). In the case of oil shocks, supply shocks are sharply identified using only traditional sign restrictions, whereas disentangling aggregate demand and oil-specific demand shocks is more difficult in a standard three-variable oil market VAR. Adding narrative sign restrictions based on a small set of historical events dramatically sharpens the identification. In fact, adding narrative information on a single event, the start of the Persian Gulf War in August 1990, is enough to obtain this result. In the case of monetary policy shocks, we show that Uhlig's (2005) results are not robust to discarding structural parameters that have implausible implications for the key historical event that occurred in October 1979, the Volcker reform. In both applications, we find that restrictions on the historical decomposition tend to be particularly effective in shrinking the identified set.

The rest of this paper is organized as follows. Section I presents the basic SVAR framework. Section II introduces narrative sign restrictions. Section III derives the posterior distribution under narrative sign restrictions and describes the algorithm to draw from it. Sections IV and V apply the methodology to the oil market and monetary policy shocks, respectively. Section VI concludes.

#### I. The Model

Consider the structural vector autoregression (SVAR) of the general form

(1) 
$$\mathbf{y}_{t}'\mathbf{A}_{0} = \sum_{\ell=1}^{p} \mathbf{y}_{t-\ell}'\mathbf{A}_{\ell} + \mathbf{c} + \mathbf{c}_{t}' \text{ for } 1 \leq t \leq T,$$

where  $\mathbf{y}_t$  is an  $n \times 1$  vector of variables,  $\mathbf{\varepsilon}_t$  is an  $n \times 1$  vector of structural shocks,  $\mathbf{A}_\ell$  is an  $n \times n$  matrix of parameters for  $0 \le \ell \le p$  with  $\mathbf{A}_0$  invertible,  $\mathbf{c}$  is a  $1 \times n$  vector of parameters, p is the lag length, and T is the sample size. The vector  $\mathbf{\varepsilon}_t$ , conditional on past information and the initial conditions  $\mathbf{y}_0, \ldots, \mathbf{y}_{1-p}$ , is Gaussian with mean zero and covariance matrix  $\mathbf{I}_n$ , the  $n \times n$  identity matrix. The model described in equation (1) can be written as

(2) 
$$\mathbf{y}_{t}'\mathbf{A}_{0} = \mathbf{x}_{t}'\mathbf{A}_{+} + \boldsymbol{\varepsilon}_{t}' \text{ for } 1 \leq t \leq T,$$

where  $\mathbf{A}'_{+} = [\mathbf{A}'_{1} \cdots \mathbf{A}'_{p}\mathbf{c}']$  and  $\mathbf{x}'_{t} = [\mathbf{y}'_{t-1}, \dots, \mathbf{y}'_{t-p}, 1]$  for  $1 \leq t \leq T$ . The dimension of  $\mathbf{A}_{+}$  is  $m \times n$  and the dimension of  $\mathbf{x}_{t}$  is  $m \times 1$ , where m = np + 1. The reduced-form representation implied by equation (2) is  $\mathbf{y}'_{t} = \mathbf{x}'_{t}\mathbf{B} + \mathbf{u}'_{t}$  for  $1 \leq t \leq T$ , where  $\mathbf{B} = \mathbf{A}_{+}\mathbf{A}_{0}^{-1}$ ,  $\mathbf{u}'_{t} = \varepsilon'_{t}\mathbf{A}_{0}^{-1}$ , and  $E[\mathbf{u}_{t}\mathbf{u}'_{t}] = \mathbf{\Sigma} = (\mathbf{A}_{0}\mathbf{A}'_{0})^{-1}$ . The matrices  $\mathbf{B}$  and  $\mathbf{\Sigma}$  are the reduced-form parameters, while  $\mathbf{A}_{0}$  and  $\mathbf{A}_{+}$  are the structural parameters. Similarly,  $\mathbf{u}'_{t}$  are the reduced-form innovations, while  $\varepsilon'_{t}$  are the structural shocks. The shocks are orthogonal and have an economic interpretation, while the innovations are, in general, correlated and do not have an interpretation. Let  $\mathbf{\Theta} = (\mathbf{A}_{0}, \mathbf{A}_{+})$  collect the value of the structural parameters.

## A. Impulse Response Functions

Recall the definition of impulse response functions (IRFs). Given a value  $\Theta$  of the structural parameters, the response of the *i*th variable to the *j*th structural shock at horizon *k* corresponds to the element in row *i* and column *j* of the matrix  $\mathbf{L}_k(\Theta)$ , where  $\mathbf{L}_k(\Theta)$  is defined recursively by

$$\mathbf{L}_0(\mathbf{\Theta}) = (\mathbf{A}_0^{-1})', \quad \mathbf{L}_k(\mathbf{\Theta}) = \sum_{\ell=1}^k (\mathbf{A}_\ell \mathbf{A}_0^{-1})' \mathbf{L}_{k-\ell}(\mathbf{\Theta}), \quad \text{for } 1 \leq k \leq p,$$

$$\mathbf{L}_k(\mathbf{\Theta}) = \sum_{\ell=1}^p (\mathbf{A}_\ell \mathbf{A}_0^{-1})' \mathbf{L}_{k-\ell}(\mathbf{\Theta}), \quad \text{for } p < k < \infty.$$

## B. Structural Shocks and Historical Decomposition

Given a value  $\Theta$  of the structural parameters and the data, the structural shocks at time t are

(3) 
$$\varepsilon'_{t}(\Theta) = \mathbf{y}'_{t}\mathbf{A}_{0} - \mathbf{x}'_{t}\mathbf{A}_{+} \text{ for } 1 \leq t \leq T.$$

The historical decomposition calculates the cumulative contribution of each shock to the observed unexpected change in the variables between two periods.<sup>2</sup> Formally, the contribution of the *j*th shock to the observed unexpected change in the *i*th variable between periods t and t + h is

$$H_{i,j,t,t+h}\bigl(\Theta,\varepsilon_t,\ldots,\varepsilon_{t+h}\bigr) \ = \ \sum_{\ell=0}^h \mathbf{e}_{i,n}' \mathbf{L}_\ell\bigl(\Theta\bigr) \, \mathbf{e}_{j,n}' \, \mathbf{e}_{t+h-\ell},$$

where  $\mathbf{e}_{j,n}$  is the jth column of  $\mathbf{I}_n$ , for  $1 \leq i, j \leq n$  and for  $h \geq 0$ .

#### II. The Identification Problem and Sign Restrictions

As is well known, the structural form in equation (1) is not identified, so restrictions must be imposed on the structural parameters to solve the identification problem. The desire to impose only minimalist identification restrictions that are agreed upon by most researchers and lead to robust conclusions motivated Faust (1998),

<sup>&</sup>lt;sup>2</sup>See Kilian and Lütkepohl (2017) for a textbook treatment.

Canova and De Nicolo (2002), and Uhlig (2005) to develop methods to identify the structural parameters by placing a handful of uncontroversial sign restrictions on the IRFs or the structural parameters themselves. In this paper we propose a new class of sign restrictions based on narrative information that we call narrative sign restrictions. Narrative sign restrictions constrain the structural parameters by ensuring that around a handful of key historical events the structural shocks and/ or historical decompositions agree with the established narrative. For instance, in the context of a model of demand and supply in the global oil market, it is well established from historical sources that an exogenous disruption to oil production occurred at the outbreak of the Gulf War in August 1990. Therefore, a researcher may want to constrain the structural parameters so that the oil supply shock for that period was negative or that it was the most important contributor (as opposed to, for instance, a negative demand shock) to the unexpected drop in oil production observed during that period. We now formally describe the functions that characterize sign restrictions on the IRFs and the structural parameters (traditional sign restrictions) and on the structural shocks and the historical decompositions (narrative sign restrictions).

#### A. Traditional Sign Restrictions

Traditional sign restrictions are well understood and their use is widespread in the literature. In particular, Rubio-Ramírez, Waggoner, and Zha (2010) and Arias, Rubio-Ramírez, and Waggoner (2018) highlight how this class of restrictions can be characterized by the function

(4) 
$$\Gamma(\Theta) = (\mathbf{e}'_{1,n}\mathbf{F}(\Theta)'\mathbf{S}'_1, \dots, \mathbf{e}'_{n,n}\mathbf{F}(\Theta)'\mathbf{S}'_n)' > \mathbf{0}.$$

Appropriate choices of  $S_j$  and  $F(\Theta)$  will lead to sign restrictions on the IRFs or the structural parameters themselves. In particular, to impose restrictions on the IRFs, one can define  $F(\Theta)$  as vertically stacking the IRFs at the different horizons over which we want to impose the restrictions and  $S_j$  as an  $s_j \times r_j$  matrix of 0s, 1s, and -1s that will select the horizons and the variables over which we want to impose the  $r_j$  sign restrictions to identify structural shock j. If instead we want to impose restrictions on the structural parameters themselves, we can then define  $F(\Theta) = \Theta$  and  $S_j$  as an  $s_j \times r_j$  matrix of 0s, 1s, and -1s that will select entries of  $\Theta$  over which we want to impose the sign restrictions.

## B. Restrictions on the Signs of the Structural Shocks

Let us now consider the first class of narrative sign restrictions. Let us assume that we want to impose the restriction that the signs of the *j*th shock at  $s_j$  episodes occurring at dates  $t_1, \ldots, t_{s_j}$  are all positive. Then, the narrative sign restrictions can be imposed as

(5) 
$$\mathbf{e}'_{i,n} \mathbf{\varepsilon}_{t_{v}}(\boldsymbol{\Theta}) > 0 \quad \text{for } 1 \leq v \leq s_{i}.$$

Assume instead that we want to impose the restriction that the signs of the jth shock at  $s_j$  episodes occurring at dates  $t_1, \ldots, t_{s_j}$  are negative. Then, the narrative sign restrictions can be imposed with a negative sign in the left-hand side of equation (5). Of course, one could restrict the shocks in a few periods to be negative and positive in a few others.

#### C. Restrictions on the Historical Decomposition

Let us now consider the second class of narrative sign restrictions. In many cases the researcher will have narrative information that indicates that a particular shock was the most important contributor to the unexpected movement of some variable during a particular period. This is information on the relative magnitude of the contribution of the jth shock to the unexpected change in the ith variable between some periods, i.e., on the historical decomposition. We propose to formalize this idea in two different ways. First, we may specify that a given shock was the *most important* (*least important*) driver of the unexpected change in a variable during some periods. By this we mean that for a particular period or periods the absolute value of its contribution to the unexpected change in a variable is larger (smaller) than the absolute value of the contribution of any other structural shock. Second, we may want to say that a given shock was the *overwhelming* (negligible) driver of the unexpected change in a given variable during the period. By this we mean that for a particular period or periods the absolute value of its contribution to the unexpected change in a variable is larger (smaller) than the sum of the absolute value of the contributions of all other structural shocks. We will label these two alternatives Type A and Type B, respectively.<sup>3</sup>

#### D. Type A Restrictions on the Historical Decomposition

To fix ideas, consider the following example: assume we have a model with three variables and we want to impose the constraint that between periods 6 and 7, the second structural shock is the most important contributor in absolute terms to the unexpected change in the third variable. This narrative restriction can be formalized by the function  $|H_{3,2,6,7}(\Theta, \varepsilon_6(\Theta), \varepsilon_7(\Theta))| - \max_{j'\neq 2} |H_{3,j',6,7}(\Theta, \varepsilon_6(\Theta), \varepsilon_7(\Theta))| > 0$ , where  $|H(\cdot)|$  is the absolute value of the matrix  $H(\cdot)$ . In other words, the contribution of the second shock to the historical decomposition is larger in absolute value than the largest contribution of any other shock.

In general, we can identify the *j*th shock by imposing  $s_j$  restrictions of this type. Thus, suppose we want to impose the restriction that the *j*th shock is the *most important* contributor to the unexpected change in the  $i_1, \ldots, i_{s_j}$ th variables from periods  $t_1, \ldots, t_{s_j}$  to  $t_1 + h_1, \ldots, t_{s_j} + h_{s_j}$ , i.e., that its cumulative contribution is larger in absolute value than the contribution of any other shock to the unexpected change

<sup>&</sup>lt;sup>3</sup> As pointed out to us by a referee, one could also impose sign restrictions on the historical decompositions themselves, rather than on their relative magnitudes. For example, Kilian and Lee (2014) note that industry sources show that the cumulative effect of speculative demand shocks between May 1979 and December 1979 on the real price of oil was positive, without this effect necessarily being the dominant effect. This type of restriction would be weaker than any of the three proposed above.

in those variables during those periods. Then, the narrative sign restrictions can be imposed as

$$(6) |H_{i_{\nu},j,t_{\nu},t_{\nu}+h_{\nu}}(\Theta,\varepsilon_{t_{\nu}}(\Theta),\ldots,\varepsilon_{t_{\nu}+h_{\nu}}(\Theta))|$$

$$- \max_{j'\neq j} |H_{i_{\nu},j',t_{\nu},t_{\nu}+h_{\nu}}(\Theta,\varepsilon_{t_{\nu}}(\Theta),\ldots,\varepsilon_{t_{\nu}+h_{\nu}}(\Theta))| > 0,$$

for  $1 \le v \le s_j$ . If instead one wishes to impose the constraint that the contribution of the shock is the *least important*, i.e., that its cumulative contribution is smaller in absolute value than the contribution of any other shock to the unexpected change in those variables during those periods, the narrative sign restrictions can be imposed as

$$(7) \qquad |H_{i_{\nu},j,t_{\nu},t_{\nu}+h_{\nu}}(\Theta,\varepsilon_{t_{\nu}}(\Theta),\ldots,\varepsilon_{t_{\nu}+h_{\nu}}(\Theta))|$$

$$-\min_{j'\neq j}|H_{i_{\nu},j',t_{\nu},t_{\nu}+h_{\nu}}(\Theta,\varepsilon_{t_{\nu}}(\Theta),\ldots,\varepsilon_{t_{\nu}+h_{\nu}}(\Theta))| < 0,$$

for  $1 \le v \le s_i$ . As above, equations (6) and (7) can be used jointly.

Type B Restrictions on the Historical Decomposition.—As before, to fix ideas, assume we have a model with three variables and we want to impose the restriction that between periods 6 and 7, the second structural shock is the overwhelming contributor in absolute terms to the unexpected change in the third variable. This narrative restriction can be formalized by the function  $|H_{3,2,6,7}(\Theta, \varepsilon_6(\Theta), \varepsilon_7(\Theta))| - \sum_{j'\neq 2} |H_{3,j',6,7}(\Theta, \varepsilon_6(\Theta), \varepsilon_7(\Theta))| > 0$ . In other words, the contribution of the second shock to the historical decomposition is larger in absolute value than the sum of the absolute contributions of all other shocks.

As before, we can identify the *j*th structural shock by imposing  $s_j$  restrictions of this type. Thus, suppose we want to impose the restriction that the *j*th shock is the *overwhelming* contributor to the unexpected change in the  $i_1, \ldots, i_{s_j}$ th variables from periods  $t_1, \ldots, t_{s_j}$  to  $t_1 + h_1, \ldots, t_{s_j} + h_{s_j}$ , i.e., that its contribution is larger in absolute value than the sum of the absolute contributions of all other shocks to the unexpected change in those variables during those periods. Then, we can define

$$(8) |H_{i_{\nu},j,t_{\nu},h_{\nu}}(\Theta,\varepsilon_{t_{\nu}}(\Theta),\ldots,\varepsilon_{t_{\nu}+h_{\nu}}(\Theta))|$$

$$-\sum_{j'\neq j}|H_{i_{\nu},j',t_{\nu},t_{\nu}+h_{\nu}}(\Theta,\varepsilon_{t_{\nu}}(\Theta),\ldots,\varepsilon_{t_{\nu}+h_{\nu}}(\Theta))| > 0,$$

for  $1 \le v \le s_j$ . If instead one wishes to impose the constraint that the contribution of the shock is *negligible*, i.e., that its contribution is smaller in absolute value than the sum of the contributions of all other shocks to the unexpected change in those variables during those periods, the narrative sign restrictions can be imposed as

$$(9) |H_{i_{\nu},j,t_{\nu}+h_{\nu}}(\Theta,\varepsilon_{t_{\nu}}(\Theta),\ldots,\varepsilon_{t_{\nu}+h_{\nu}}(\Theta))|$$
 
$$-\sum_{j'\neq j}|H_{i_{\nu},j',t_{\nu}+h_{\nu}}(\Theta,\varepsilon_{t_{\nu}}(\Theta),\ldots,\varepsilon_{t_{\nu}+h_{\nu}}(\Theta))| < 0,$$

for  $1 \le v \le s_i$ . Equations (8) and (9) can also be used jointly.

Discussion.—A natural question is to ask whether Type A or Type B restrictions on the historical decomposition are more restrictive. The answer depends on whether we are restricting the cumulative contribution of a particular shock to the unexpected change in a variable to be "larger" or "smaller." If the contribution of shock *j* is larger than the sum of all other contributions, it is always larger than any single contribution. Therefore, when contributions are defined as "larger," Type B is more restrictive than Type A. In contrast, if the contribution of shock *j* is smaller than any single contribution, it must also be smaller than the sum of the other contributions in absolute value. Consequently, when restrictions are defined as "smaller," Type B is stronger than Type A. Therefore, the use of either Type A or Type B allows the researcher to express different levels of confidence in the narrative information about a particular episode.

#### III. Bayesian Inference

In this section we show how to adapt the Bayesian methods developed in Rubio-Ramírez, Waggoner, and Zha (2010) and Arias, Rubio-Ramírez, and Waggoner (2018) to handle narrative sign restrictions. Equations (5)–(9) imply the following function to characterize narrative sign restrictions

(10) 
$$\phi(\boldsymbol{\Theta}, \boldsymbol{\varepsilon}^{\boldsymbol{v}}) > \mathbf{0},$$

where  $\varepsilon^{\nu} = (\varepsilon_{t_1}, \dots, \varepsilon_{t_{\nu}})$  are the structural shocks constrained by the narrative sign restrictions. A comparison with equation (4) makes it clear that the traditional sign restrictions depend on the structural parameters, whereas the narrative sign restrictions depend as well on the structural shocks. Moreover, equation (3) implies the following invertible function:

(11) 
$$\varepsilon_t = g_h(\mathbf{y}_t, \mathbf{x}_t, \boldsymbol{\Theta}) \quad \text{for } 1 \le t \le T,$$

with  $\mathbf{y}_t = g_h^{-1}(\mathbf{\varepsilon}_t; \mathbf{x}_t, \boldsymbol{\Theta})$  for  $1 \leq t \leq T$ . Using equations (10) and (11), we can write

(12) 
$$\tilde{\phi}(\boldsymbol{\Theta}, \mathbf{y}^{\nu}, \mathbf{x}^{\nu}) = \phi(\boldsymbol{\Theta}, g_h(\mathbf{y}_{t_1}, \mathbf{x}_{t_1}, \boldsymbol{\Theta}), \dots, g_h(\mathbf{y}_{t_r}, \mathbf{x}_{t_r}, \boldsymbol{\Theta})) > \mathbf{0},$$

where  $\mathbf{y}^{\nu} = (\mathbf{y}_{t_1}, \dots, \mathbf{y}_{t_{\nu}})$  and  $\mathbf{x}^{\nu} = (\mathbf{x}_{t_1}, \dots, \mathbf{x}_{t_{\nu}})$ . Hence, given the data, equation (10) is continuous on the structural parameters while, given the structural parameters, equation (10) is continuous on the structural shocks.

#### A. The Posterior Distribution

Following Arias, Rubio-Ramírez, and Waggoner (2018), we can consider an alternative parameterization of the structural VAR in (2), defined by  $\mathbf{B}$ ,  $\Sigma$ , and

**Q**, where  $\mathbf{Q} \in O(n)$ , the set of all orthogonal  $n \times n$  matrices, which we call the orthogonal reduced-form parameterization. To define a mapping between  $\Theta$  and  $(\mathbf{B}, \Sigma, \mathbf{Q})$ , one must first choose a decomposition of the covariance matrix  $\Sigma$ . Let  $h(\Sigma)$  be an  $n \times n$  matrix that satisfies  $h(\Sigma)'h(\Sigma) = \Sigma$ , where h is differentiable. One would normally choose  $h(\Sigma)$  to be the Cholesky decomposition. Given a decomposition h, we can define the mapping between  $\Theta$  and  $(\mathbf{B}, \Sigma, \mathbf{Q})$ ,

$$f_h(\boldsymbol{\Theta}) = (\underbrace{\mathbf{A}_{+}\mathbf{A}_{0}^{-1}}_{\mathbf{B}}, \underbrace{(\mathbf{A}_{0}\mathbf{A}_{0}')^{-1}}_{\Sigma}, \underbrace{h((\mathbf{A}_{0}\mathbf{A}_{0}')^{-1})\mathbf{A}_{0}}_{\mathbf{O}}),$$

where it is easy to see that  $h((\mathbf{A}_0\mathbf{A}_0')^{-1})\mathbf{A}_0$  is an orthogonal matrix. The function  $f_h$ is invertible, with inverse defined by

(13) 
$$f_h^{-1}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}) = (\underbrace{h(\mathbf{\Sigma})^{-1}\mathbf{Q}}_{\mathbf{A}_0}, \underbrace{\mathbf{B}h(\mathbf{\Sigma})^{-1}\mathbf{Q}}_{\mathbf{A}_{\perp}}).$$

Using equation (13), we can rewrite equation (12) as  $\Phi(\mathbf{B}, \Sigma, \mathbf{Q}, \mathbf{y}^{\nu}, \mathbf{x}^{\nu})$  $= \tilde{\phi}\left(f_h^{-1}(\mathbf{B}, \Sigma, \mathbf{Q}), \mathbf{y}^{\nu}, \mathbf{x}^{\nu}\right) > \mathbf{0}.$ Thus, the posterior of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  subject to the narrative sign restrictions is

(14) 
$$\pi(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q} | \mathbf{y}^{T}, \mathbf{\Phi}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{v}, \mathbf{x}^{v}) > \mathbf{0})$$

$$= \frac{\pi(\mathbf{y}^{T} | \mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{\Phi}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{v}, \mathbf{x}^{v}) > \mathbf{0}) \pi(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q})}{\int \pi(\mathbf{y}^{T} | \mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{\Phi}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{v}, \mathbf{x}^{v}) > \mathbf{0}) \pi(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}) d(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q})},$$

where  $\mathbf{y}^T = \{\mathbf{y}_{1-p}, \dots, \mathbf{y}_0, \dots, \mathbf{y}_T\}$  is the data,  $\pi(\mathbf{y}^T | \mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \Phi(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^v, \mathbf{x}^v) > \mathbf{0})$  is the likelihood function subject to the narrative sign restrictions and  $\pi(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q})$  is the prior.

It is useful at this point to compare the posterior distribution defined in equation (14) with the one obtained using only traditional sign restrictions. The posterior of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  subject to the traditional sign restrictions is

$$\begin{aligned} \pi \big( \mathbf{B}, \mathbf{\Sigma}, \mathbf{Q} \, | \, \mathbf{y}^T, \Gamma \big( f_h^{-1}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}) \big) &> \mathbf{0} \big) \ &= \frac{\pi \big( \mathbf{y}^T | \mathbf{B}, \mathbf{\Sigma} \big) \pi \big( \mathbf{B}, \mathbf{\Sigma}, \mathbf{Q} | \Gamma \big( f_h^{-1}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}) \big) &> \mathbf{0} \big)}{\int \pi \big( \mathbf{y}^T | \mathbf{B}, \mathbf{\Sigma} \big) \pi \big( \mathbf{B}, \mathbf{\Sigma}, \mathbf{Q} | \Gamma \big( f_h^{-1}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}) \big) &> \mathbf{0} \big) d(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}) \end{matrix}$$

where  $\pi(\mathbf{y}^T|\mathbf{B}, \Sigma)$  is the likelihood function and  $\pi(\mathbf{B}, \Sigma, \mathbf{Q}|\Gamma(f_h^{-1}(\mathbf{B}, \Sigma, \mathbf{Q})) > \mathbf{0})$ is the prior subject to the traditional sign restrictions. Since the likelihood function does not depend on Q and the traditional sign restrictions are characterized by a function that does not depend on the structural shocks, traditional sign restrictions only truncate the prior of  $(B, \Sigma, Q)$ . On the contrary, since the function characterizing the narrative sign restrictions depends on the structural shocks, narrative sign restrictions do not truncate the prior of  $(B, \Sigma, Q)$  but the likelihood function.

The truncated likelihood function in equation (14) can be written as

(15) 
$$\pi(\mathbf{y}^{T}|\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{\Phi}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{v}, \mathbf{x}^{v}) > \mathbf{0})$$

$$= \frac{\left[\mathbf{\Phi}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{v}, \mathbf{x}^{v}) > \mathbf{0}\right] \pi(\mathbf{y}^{T}|\mathbf{B}, \mathbf{\Sigma})}{\int \left[\mathbf{\Phi}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{v}, \mathbf{x}^{v}) > \mathbf{0}\right] \pi(\mathbf{y}^{T}|\mathbf{B}, \mathbf{\Sigma}) d\mathbf{y}^{T}}.$$

But note that

$$\begin{split} &\int \left[ \boldsymbol{\Phi}(\mathbf{B}, \boldsymbol{\Sigma}, \mathbf{Q}, \mathbf{y}^{\boldsymbol{v}}, \mathbf{x}^{\boldsymbol{v}}) > \mathbf{0} \right] \pi \left( \mathbf{y}^{T} | \mathbf{B}, \boldsymbol{\Sigma} \right) d\mathbf{y}^{T} \\ &= \int \left[ \boldsymbol{\Phi}(\mathbf{B}, \boldsymbol{\Sigma}, \mathbf{Q}, \mathbf{y}^{\boldsymbol{v}}, \mathbf{x}^{\boldsymbol{v}}) > \mathbf{0} \right] \left( \prod_{t=1}^{T} \pi \left( \mathbf{y}_{t} | \mathbf{x}_{t}, \mathbf{B}, \boldsymbol{\Sigma} \right) \right) d(\mathbf{y}_{1} \cdots \mathbf{y}_{T}) \\ &= \int \left[ \tilde{\boldsymbol{\Phi}}(\mathbf{B}, \boldsymbol{\Sigma}, \mathbf{Q}, \boldsymbol{\varepsilon}^{\boldsymbol{v}}) > \mathbf{0} \right] \left( \prod_{t=1}^{T} \frac{\pi \left( g_{h}^{-1} \left( \boldsymbol{\varepsilon}_{t}; \mathbf{x}_{t}, f_{h}^{-1} (\mathbf{B}, \boldsymbol{\Sigma}, \mathbf{Q}) \right) | \mathbf{x}_{t}, \mathbf{B}, \boldsymbol{\Sigma} \right)}{\upsilon_{g_{h}} \left( g_{h}^{-1} \left( \boldsymbol{\varepsilon}_{t}; \mathbf{x}_{t}, f_{h}^{-1} (\mathbf{B}, \boldsymbol{\Sigma}, \mathbf{Q}) \right) \right)} \right) d(\boldsymbol{\varepsilon}_{1} \cdots \boldsymbol{\varepsilon}_{T}), \end{split}$$

where  $\tilde{\Phi}(\mathbf{B}, \Sigma, \mathbf{Q}, \varepsilon^{\nu}) = \phi(f_h^{-1}(\mathbf{B}, \Sigma, \mathbf{Q}), \varepsilon^{\nu})$  and the term  $v_{g_h}$  is called the volume element of the function  $g_h$  evaluated at  $g_h^{-1}(\varepsilon_t; \mathbf{x}_t, f_h^{-1}(\mathbf{B}, \Sigma, \mathbf{Q}))$ . Our equation (11) implies that  $v_{g_h}(g_h^{-1}(\varepsilon_t; \mathbf{x}_t, f_h^{-1}(\mathbf{B}, \Sigma, \mathbf{Q}))) = |\Sigma|^{-1/2}$  for  $1 \leq t \leq T$ . Hence,

$$(16) \int \left[\tilde{\Phi}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \boldsymbol{\varepsilon}^{\nu}) > \mathbf{0}\right] \left( \prod_{t=1}^{T} \frac{\pi \left(g_{h}^{-1}(\boldsymbol{\varepsilon}_{t}; \mathbf{x}_{t}, f_{h}^{-1}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q})) | \mathbf{x}_{t}, \mathbf{B}, \mathbf{\Sigma}\right)}{v_{g_{h}}\left(g_{h}^{-1}(\boldsymbol{\varepsilon}_{t}; \mathbf{x}_{t}, f_{h}^{-1}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}))\right)} \right) d(\boldsymbol{\varepsilon}_{1} \cdots \boldsymbol{\varepsilon}_{T})$$

$$= \int \left[\tilde{\Phi}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \boldsymbol{\varepsilon}^{\nu}) > \mathbf{0}\right] \left(\prod_{t=1}^{T} \pi(\boldsymbol{\varepsilon}_{t})\right) d(\boldsymbol{\varepsilon}_{1} \cdots \boldsymbol{\varepsilon}_{T})$$

$$= \int \left[\tilde{\Phi}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \boldsymbol{\varepsilon}^{\nu}) > \mathbf{0}\right] \left(\prod_{s=1}^{V} \pi(\boldsymbol{\varepsilon}_{t_{s}})\right) d(\boldsymbol{\varepsilon}_{t_{1}} \cdots \boldsymbol{\varepsilon}_{t_{v}}).$$

Equation (16) allows us to write the truncated likelihood in equation (15) as

(17) 
$$\pi(\mathbf{y}^T|\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \Phi(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{\nu}, \mathbf{x}^{\nu}) > \mathbf{0}) = \frac{\left[\Phi(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{\nu}, \mathbf{x}^{\nu}) > \mathbf{0}\right] \pi(\mathbf{y}^T|\mathbf{B}, \mathbf{\Sigma})}{\omega(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q})},$$

where  $\omega(\mathbf{B}, \Sigma, \mathbf{Q}) = \int \left[\tilde{\Phi}(\mathbf{B}, \Sigma, \mathbf{Q}, \varepsilon^{\nu}) > \mathbf{0}\right] \left(\prod_{s=1}^{\nu} \pi(\varepsilon_{t_s})\right) d(\varepsilon_{t_1} \cdots \varepsilon_{t_{\nu}})$ . Equation (17) makes clear that the truncated likelihood can be written as a reweighting of the likelihood function, with weights inversely proportional to the probability of satisfying the restriction.

One would normally choose priors of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  that are uniform over O(n). When that is the case,  $\pi(\mathbf{B}, \Sigma, \mathbf{Q}) = \pi(\mathbf{B}, \Sigma)$ , and the posterior of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  subject to the narrative sign restrictions is proportional to

$$\begin{split} \pi \big( \mathbf{B}, \mathbf{\Sigma}, \mathbf{Q} \, | \, \mathbf{y}^T, \Phi \big( \mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{\scriptscriptstyle V}, \mathbf{x}^{\scriptscriptstyle V} \big) \, > \, \mathbf{0} \big) \\ \propto \, \frac{ \big[ \Phi \big( \mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{\scriptscriptstyle V}, \mathbf{x}^{\scriptscriptstyle V} \big) \, > \, \mathbf{0} \big] \pi \big( \mathbf{y}^T | \, \mathbf{B}, \mathbf{\Sigma} \big) }{\omega (\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q})} \pi \big( \mathbf{B}, \mathbf{\Sigma} \big). \end{split}$$

In other words, the posterior distribution is proportional to the reweighted likelihood times the prior. On the contrary, as mentioned above, for the case of traditional sign restrictions, it is the prior and not the likelihood that is truncated. Using similar derivations, under priors that are uniform over O(n) the posterior distribution subject to the traditional sign restrictions is  $\pi(\mathbf{B}, \Sigma, \mathbf{Q} | \mathbf{y}^T, \Gamma(f_h^{-1}(\mathbf{B}, \Sigma, \mathbf{Q})) > \mathbf{0})$   $\propto \left[\Gamma(f_h^{-1}(\mathbf{B}, \Sigma, \mathbf{Q})) > \mathbf{0}\right] \pi(\mathbf{y}^T | \mathbf{B}, \Sigma) \pi(\mathbf{B}, \Sigma)$ , in which no reweighting of the likelihood is needed. If one uses both traditional and narrative sign restrictions the posterior distribution  $\pi(\mathbf{B}, \Sigma, \mathbf{Q} | \mathbf{y}^T, \Gamma(f_h^{-1}(\mathbf{B}, \Sigma, \mathbf{Q})) > \mathbf{0}, \Phi(\mathbf{B}, \Sigma, \mathbf{Q}, \mathbf{y}^v, \mathbf{x}^v) > \mathbf{0})$  is proportional to

$$\Big[\Gamma \big(f_h^{-1} \big(\mathbf{B}, \boldsymbol{\Sigma}, \mathbf{Q}\big)\big) \ > \ \mathbf{0} \Big] \frac{ \big[\Phi \big(\mathbf{B}, \boldsymbol{\Sigma}, \mathbf{Q}, \mathbf{y}^{\boldsymbol{\nu}}, \mathbf{x}^{\boldsymbol{\nu}}\big) \ > \ \mathbf{0} \big] \pi \big(\mathbf{y}^T | \mathbf{B}, \boldsymbol{\Sigma}\big)}{\omega \big(\mathbf{B}, \boldsymbol{\Sigma}, \mathbf{Q}\big)} \pi \big(\mathbf{B}, \boldsymbol{\Sigma}\big).$$

B. The Algorithm

In practice, one would normally choose priors of  $(B, \Sigma, Q)$  that are uniform-normal-inverse-Wishart. In that choice, we are now ready to specify our algorithm to independently draw from the uniform-normal-inverse-Wishart posterior of  $(B, \Sigma, Q)$  conditional on the traditional and narrative sign restrictions.

ALGORITHM 1: This algorithm makes independent draws from the uniform-normal-inverse-Wishart posterior of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  conditional on the traditional and narrative sign restrictions.

- (i) Independently draw  $(\mathbf{B}, \Sigma)$  from the normal-inverse-Wishart posterior of the reduced-form parameters and  $\mathbf{Q}$  from the uniform distribution over O(n).
- (ii) Check whether  $\left[\Gamma\left(f_h^{-1}(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q})\right) > \mathbf{0}\right]$  and  $\left[\Phi(\mathbf{B}, \mathbf{\Sigma}, \mathbf{Q}, \mathbf{y}^{\nu}, \mathbf{x}^{\nu}) > \mathbf{0}\right]$  are satisfied.
- (iii) If not, discard the draw. Otherwise let the importance weight of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  be as follows:
  - (a) Simulate M independent draws of  $\varepsilon^{\nu}$  from the standard normal distribution.
  - (b) Approximate  $\omega(\mathbf{B}, \Sigma, \mathbf{Q})$  by the proportion of the M draws that satisfy  $\tilde{\Phi}(\mathbf{B}, \Sigma, \mathbf{Q}, \varepsilon^{\nu}) > \mathbf{0}$  and set the importance weight to  $1/\omega(\mathbf{B}, \Sigma, \mathbf{Q})$ .
- (iv) Return to Step (i) until the required number of draws has been obtained.

(v) Draw with replacement from the set of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  using the importance weights.

As explained in detail in Arias, Rubio-Ramírez, and Waggoner (2018), this choice of priors of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  is good because it is extremely easy and efficient to make independent draws from the normal-inverse-Wishart distribution and because Rubio-Ramírez, Waggoner, and Zha (2010) describe how to use the QR decomposition to independently draw the uniform distribution over O(n). Algorithm 1 makes clear that it does not suffice to simply discard the draws that violate the narrative sign restrictions. This would imply giving higher posterior probability to draws of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  that are more likely to satisfy the narrative sign restrictions. Hence, this would amount to drawing from a posterior distribution of  $(\mathbf{B}, \Sigma, \mathbf{Q})$  that it is not uniform-normal-inverse-Wishart. Instead, we need to compute the importance weights and resample the draws accordingly.<sup>4</sup> Also, for the reasons explained in Arias, Rubio-Ramírez, and Waggoner (2018), Algorithm 1 is making independent draws from the posterior normal-generalized-normal distribution of  $\Theta$ .<sup>5</sup> Further details on the computational properties are provided in online Appendix D.

#### IV. Demand and Supply Shocks in the Oil Market

In this section we use narrative information to revisit efforts by Kilian (2009b) and Kilian and Murphy (2012) to assess the relative importance of supply and demand shocks in the oil market. The case of the oil market is particularly well suited to our procedure because a vast literature has documented a number of widely accepted historical events associated with wars or civil conflicts in major oil-producing countries that led to significant physical disruptions in the oil market. We will show that, while the identification scheme proposed by Kilian and Murphy (2012), based on traditional sign restrictions, does a very good job of separating the effects of supply and demand shocks, adding narrative sign restrictions improves the ability to distinguish between aggregate demand and oil-specific demand shocks, in line with the conclusions of Kilian and Murphy (2014).
