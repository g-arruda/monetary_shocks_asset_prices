# 5. The role of long-term interest rates

There is a well-established practice of excluding a long-term interest rate from VAR systems estimated to investigate the monetary transmission mechanism. Such choice is common to models using alternative empirical counterparts for monetary policy shocks; in fact, long-term interest rates are not included in systems specified to capture federal funds targeting (Bernanke and Blinder, 1992; Bernanke and Mihov, 1995), as well as in models featuring nonborrowed reserves targeting (Christiano et al., 1996a,b), and borrowed reserves targeting (Strongin, 1995). It is also common to studies applied to different countries and using different sample sizes (Sims, 1992; Leeper et al., 1996).

There is one obvious reason for excluding long-term interest rates from VAR models designed to investigate the monetary transmission mechanism: identification. In fact, it is very difficult to rule out simultaneous feedbacks between long-term and short-term interest rates; hence it is hard to find a suitable set of restrictions to distinguish structural shocks to long-term rates from structural shocks to short-term rates, determined on the reserves market. This identification problem becomes evident in one of the very few studies in which long-term and short-term interest rates are both included in the estimated VAR, Gordon and Leeper (1994). In that paper supply and demand shocks in the market for reserves are identified from a VAR including total reserves, the federal funds rate, the price level, output, unemployment, commodity prices and the 10-year bond yield. Identification is achieved by supplementing the usual assumption that goods market do not respond to current money market disturbances with the assumption that financial market as well do not respond to such disturbances. Ruling out the simultaneous reaction of the long-term rate to current monetary policy shocks seems a questionable identifying restriction, especially if the data are observed at a monthly frequency.

In the previous section we have introduced and discussed measures of monetary policy shocks which are derived independently from the specification of the VAR, and exploited this feature to assess the robustness of the estimated

consumption in a regression including lagged consumption. However, if other macro variables show inertia, a regression of consumption on lagged consumption and current and lagged values of other macroeconomic variables might show significant coefficients on lags of the other macro variables. The fact that consumption follows a random walk is not incompatible with the significance of, for instance, current and lagged income in a regression of consumption on lagged consumption and those two income variables.

monetary transmission mechanism to alternative specifications of monetary policy shocks. It seems natural to extend our framework to the inclusion of long-term interest rates in the VAR.

We consider the *IFS* measure of policy shocks and estimate the following structural model:

$$\begin{array}{c|c} GDP_t \\ P_t \\ Pcm_t \\ T10_t \\ FF_t \\ TR_t \\ NBR_t \end{array} = C^*(L) \begin{array}{c|c} GDP_{t-1} \\ P_{t-1} \\ Pcm_{t-1} \\ T10_{t-1} \\ FF_{t-1} \\ TR_{t-1} \\ NBR_{t-1} \end{array} + \begin{array}{c|c} g_{GNP} \\ g_P \\ g_{Pcm} \\ g_{T10} \\ g_{FF} \\ g_{TR} \\ g_{NBR} \end{array} IFS_t + \begin{array}{c|c} v_{1t}^{NP} \\ v_{2t}^{NP} \\ v_{3t}^{NP} \\ v_{3t}^{T10} \\ v_{t}^{T} \\ v_{t}^{D} \\ v_{t}^{D} \end{array} ,$$

where D is now a seven-dimensional lower-triangular matrix and all variables have already been defined with the exception of T10 – the yield on 10-year Treasury bonds –, and  $v^{T10}$  – the associated structural disturbance. Ordering T10 after the block of non-policy variables allows a contemporaneous reaction of the long rate to the macroeconomy. Moreover, the inclusion of the exogenous shocks allows to identify a simultaneous feedback between the federal funds rate and the long-term interest rate. The estimated elements of matrix D and of vector Q are reported in Table 7.

The estimated structural parameters support the significance of the policy shocks in the equation for the federal funds rate ( $g_{FF}=0.26$ ), whereas the long rate does not react contemporaneously to policy shocks ( $g_{T10}=0.005$ ). The previous evidence of a non-significant contemporaneous reaction of the goods market to monetary policy shocks is also confirmed. The inclusion of the long-term interest rate in the VAR has a remarkable impact on the precision of the estimates of the simultaneous response of total and nonborrowed reserves to the monetary policy shock, captured by  $g_{TR}$  and  $g_{NBR}$ , respectively. Moreover, there is a clearly significant contemporaneous reaction of the federal fund rate to the long-term interest rate (measured by  $|d_{54}|=0.28$ ), witnessing the relevance of contemporaneous long-term interest rates in the policy maker's reaction function.

Having identified the structural model, we now turn to the analysis of the monetary transmission mechanism, described by the impulse response functions following a (one-standard-deviation) shock to our monetary policy variable. In Fig. 10 the responses obtained in the VAR models specified with and without the long-term interest rates are plotted (the 95% confidence intervals are referred to the latter specification of the VAR). When the long-term rate is included, the reduction in output following a monetary restriction is smaller in magnitude and dies out more quickly than in the previous estimates, and also

Table 7
The VAR with a long-term interest rate

The estimated VAR model is:

$$\begin{array}{c|c} GDP_t \\ P_t \\ Pcm_t \\ T10_t \\ FF_t \\ TR_t \\ NBR_t \end{array} = \boldsymbol{C^*(L)} \begin{pmatrix} GDP_{t-1} \\ P_{t-1} \\ Pcm_{t-1} \\ TT0_{t-1} \\ TR_{t-1} \\ NBR_{t-1} \end{pmatrix} + \begin{pmatrix} g_{GDP} \\ g_P \\ g_{Pcm} \\ g_{T10} \\ g_{FF} \\ g_{TR} \\ g_{NBR} \end{pmatrix} IFS_t + \begin{pmatrix} cv_{1P}^{NP} \\ v_{2t}^{NP} \\ v_{3t}^{NP} \\ v_{t}^{NP} \\ v_{t}^{T10} \\ v_{t}^{S} \\ v_{t}^{D} \\ v_{t}^{P} \end{pmatrix} ,$$

where D is a (seven-dimensional) lower-triangular matrix of coefficients. The sample period is 1988(11)-1996(3).

|                  | Estimated e                        | elements of 1      | matrix <b>D</b> :  |                    |                    |                     |                    |  |  |
|------------------|------------------------------------|--------------------|--------------------|--------------------|--------------------|---------------------|--------------------|--|--|
|                  | d <sub>21</sub>                    | d <sub>31</sub>    | d <sub>32</sub>    | d <sub>41</sub>    | d <sub>42</sub>    | d <sub>43</sub>     | d <sub>51</sub>    |  |  |
| Coeff.<br>(S.E.) | - 0.042<br>(0.052)                 | - 1.865<br>(0.454) | 0.635<br>(0.942)   | - 23.34<br>(6.39)  | - 23.96<br>(12.12) | - 5.972<br>(1.402)  | 11.74<br>(5.75)    |  |  |
|                  | d <sub>52</sub>                    | d <sub>53</sub>    | d <sub>54</sub>    | d <sub>61</sub>    | d <sub>62</sub>    | d <sub>63</sub>     | d <sub>64</sub>    |  |  |
| Coeff.<br>(S.E.) | - 2.132<br>(10.36)                 | 1.490<br>(1.29)    | - 0.281<br>(0.090) | - 0.076<br>(0.291) | - 0.479<br>(0.520) | 0.055<br>(0.066)    | 0.002<br>(0.006)   |  |  |
|                  | d <sub>65</sub>                    | $d_{71}$           | d <sub>72</sub>    | $d_{73}$           | $d_{74}$           | $d_{75}$            | $d_{76}$           |  |  |
| Coeff.<br>(S.E.) | 0.002<br>(0.005)                   | 0.069<br>(0.145)   | - 0.049<br>(0.260) | - 0.007<br>(0.033) | 0.009<br>(0.003)   | - 0.003<br>(0.0024) | - 1.065<br>(0.055) |  |  |
|                  | Estimated elements of vector $g$ : |                    |                    |                    |                    |                     |                    |  |  |
|                  | $g_{GDP}$                          | $g_{\mathrm{P}}$   | $g_{Pcm}$          | $g_{T10}$          | $g_{FF}$           | $g_{TR}$            | $g_{NBR}$          |  |  |
| Coeff.<br>(S.E.) | 0.0002<br>(0.002)                  | 0.0006<br>(0.001)  | - 0.140<br>(0.160) | 0.005<br>(0.120)   | 0.260<br>(0.080)   | - 0.013<br>(0.003)  | - 0.012<br>(0.005) |  |  |
|                  | Estimated s                        | standard dev       | viations of st     | ructural distu     | ırbances:          |                     |                    |  |  |
|                  | $v_1^{NP}$                         | $v_2^{NP}$         | $v_3^{NP}$         | $v_T^{10}$         | v <sup>s</sup>     | $v^{\mathrm{D}}$    | $v^{\mathrm{B}}$   |  |  |
| Coeff.<br>(S.E.) | 0.002<br>(0.0001)                  | 0.001<br>(0.0001)  | 0.008<br>(0.001)   | 0.086<br>(0.010)   | 0.092<br>(0.010)   | 0.004<br>(0.001)    | 0.002<br>(0.0002)  |  |  |

![](_page_39_Figure_2.jpeg)

Fig. 10. Impulse responses to the monetary policy shock in the benchmark VAR and to the IFS shock in the VAR with long-term interest rate (dashed lines: 95% confidence interval bands for the benchmark VAR).

consumer prices respond less to monetary policy shocks. The response of total and nonborrowed reserves are perfectly in line with the previous results.

Lastly, in Fig. 11, we compare the dynamic response of all variables in the extended VAR to a (restrictive) monetary policy disturbance (in the left-hand

![](_page_40_Figure_2.jpeg)

Fig. 11. Impulse responses to monetary policy shocks (IFS) and to shocks to the long-term interest rate (dashed lines: 95% confidence interval bands).

column) and to a shock to the long-term interest rate (in the right-hand column). Given the assumed identifying hypothesis, the latter disturbance is not related to monetary policy, and may reflect unexpected increases in default risk affecting long rates. Looking at the effect of a monetary contraction, we note that the long-term interest rate does not increase; in fact, ¹10 shows a decrease over the first six months after the policy shock, before starting to rise back towards its initial level. Therefore, the contractionary monetary impulse does not seem to be transmitted to the real economy through increases in long-term interest rates (Campbell (1995) provides an account of the long rate movements following the 1994 monetary policy restriction that is broadly consistent with the above evidence.) Output declines also following a (structural) shock to the long-rate itself (perhaps due to changed default-risk perceptions), determining a response in the same direction of the federal funds rate. In reaction to both kinds of disturbances the price level does not appear to decline significantly and the dynamic behaviour of the reserve aggregates is consistent with the movement in the federal funds rate.

# 6. Conclusions

This paper studies a benchmark six-variable VAR model for the U.S., including the gross domestic product, a consumer price index, a commodity price index, the federal funds rate, total reserves and nonborrowed reserves, commonly estimated to derive a measure of monetary policy shocks. Our evaluation is conducted by addressing three issues: specification, identification, and the effect of the omission of long-term interest rates.

The issue of the econometric specification of the VAR is addressed by running a battery of diagnostic tests on the reduced form residuals and by testing for parameter stability. On the whole sample period (1965*—*1996) we find strong evidence of mis-specification and parameters' instability for all estimated equations. In principle, these findings can be explained for the equations for policy variables (the federal funds rate, total and nonborrowed reserves) with changes in the Federal Reserve operating procedures (Bernanke and Mihov, 1995) but, given the common procedure followed to identify monetary policy shocks, these changes in policy regime cannot explain the instability in the equation for the non-policy variables. However, when we concentrate on the most recent period (1988*—*1996), coinciding with a single monetary policy regime, we do not find evidence either of parameters' instability or mis-specification. We then focus on this sample period for further evaluation of the approach.

Over the shorter sample we address the issue of *identification* by comparing the monetary policy shocks derived from the VAR with three alternative measures obtained from direct observation of financial market behaviour. These measures have been proposed by Rudebusch (1996) Skinner and Zettelmeyer (1996) and Favero et al. (1996). Our empirical analysis shows that, despite of the not very high correlation between the benchmark VAR and the alternative measures of monetary policy shocks, the descriptions of the monetary trasmission mechanism obtained by impulse response functions estimated are not substantially different from each other.

Finally, we use our direct measurement of the monetary policy shock as an opportunity to include a *long*-*term rate* in our benchmark VAR, distinguishing monetary policy shocks from independent disturbances to long-term rates (an identification problem that has often determined the exclusion of long-term rates from estimated VAR models). The inclusion of the 10-year bond yield allows us to show that there is a significant reaction of policy rates to contemporaneous fluctuations of long-term rates and that the effect on output of a restrictive monetary policy seems not to be due to an increase in long-term interest rates.

# Acknowledgements

We thank our discussants, Jim Stock and Stefan Gerlach, other ISOM participants and two referees for many valuable suggestions. Graham Elliott, Frederick Mishkin, Alessandro Missale, Andrew Scott, Guido Tabellini and seminar participants at the London Business School, Queen Mary and Westfield College, the University of Rome 'Tor Vergata' and the University of California at San Diego provided helpful comments on earlier drafts of the paper. We also thank Eric Leeper for kindly providing the data used in Leeper, Sims and Zha (1996). Financial support from *Consiglio Nazionale delle Ricerche* is gratefully acknowledged. C. Favero worked on the final version of this paper while visiting the Department of Economics of the University of California at San Diego.

# References

- Andrews, D.W., 1993. Tests for parameter instability and structural change with unknown change point. Econometrica 61, 821*—*853.
- Bernanke, B.S., Blinder, A., 1992. The Federal Funds Rate and the channels of monetary transmission. American Economic Review 82, 901*—*921.
- Bernanke, B.S., Mihov, I., 1995. Measuring monetary policy. Working paper no. 5145. NBER, Cambridge, MA.
- Bernanke, B.S., Mihov I., 1996. What does the Bundesbank target? Working paper no. 5764. NBER, Cambridge, MA.
- Brunner, A., 1996. Using measures of expectations to identify the effects of a monetary policy shock. International Finance Discussion Paper no. 537. Board of Governors of the Federal Reserve System, Washington, DC.
- Campbell, J., 1995. Some lessons from the yield curve. Journal of Economic Perspectives 9, 129*—*152.

- Christiano, L.J., Eichenbaum, M., 1992. Liquidity effects and the monetary transmission mechanism. American Economic Review 82, 346*—*353.
- Christiano, L.J., Eichenbaum, M., Evans, C.L., 1996a. The effects of monetary policy shocks: Evidence from the flow of funds. Review of Economics and Statistics 78, 16*—*34.
- Christiano, L.J., Eichenbaum, M., Evans, C.L., 1996b. Monetary policy shocks and their consequences: Theory and evidence. Paper presented at ISOM, 1996.
- Doornik, J., Hendry, D.F., 1996. PcFIML: Interactive econometric modelling of dynamic system. International Thompson Publishing, London.
- Farmer, R.E.A. 1997. Money in a real business cycle model. Mimeo, Dept. of Economics, UCLA. Favero, C.A., Pifferi, M., Iacone, F., 1996. Monetary policy, forward rates and long rates: Does Germany Differ from the United States? Discussion paper no. 1456. CEPR, London.
- Goodfriend, M., King, R., 1997. The newclassical synthesis and the role of monetary policy. Paper Presented at the 12th NBER Annual Macroeconomic Conference.
- Gordon, D., Leeper, E.M., 1994. The dynamic impacts of monetary policy: An exercise in tentative identification. Journal of Political Economy 102, 1228*—*1247.
- Hendry, D.F., 1996. Dynamic Econometrics. Oxford University Press, Oxford.
- Leeper, E.M., 1997. Narrative and VAR approaches to monetary policy: Common identification problems. Journal of Monetary Economics, forthcoming.
- Leeper, E.M., Sims, C.A., Zha, T., 1996. What does monetary policy do?. Available at ftp://ftp.econ.yale.edu/pub/sims/mpolicy.
- Lucas, R.E. Jr., 1972. Expectations and the neutrality of money. Journal of Economic Theory 4, 103*—*124.
- Lucas, R.E. Jr., 1976. Econometric policy evaluation: a critique. In: Brunner, K., Meltzer, A. (Eds.), The Phillips Curve and Labor Markets. North-Holland, Amsterdam.
- Nelson, C.R., Siegel, A.F., 1987. Parsimonious modelling of yield curves. Journal of Business 60, 473*—*489.
- Romer, C.D., Romer, D.H., 1989. Does monetary policy matter? A new test in the spirit of Friedman and Schwartz. In: Blanchard, O.J., Fischer, S. (Eds.), NBER Macroeconomics Annual 1989. MIT Press, Cambridge, MA, pp. 121*—*170.
- Romer, C.D., Romer, D.H., 1994. Monetary policy matters. Journal of Monetary Economics 34, 75*—*88. Rudebusch, G.D., 1996. Do measures of monetary policy in a VAR make sense? Temi di Discussione n. 269. Bank of Italy, Rome.
- Sims, C.A., 1980. Macroeconomics and reality. Econometrica 48, 1*—*48.
- Sims, C.A., 1992. Interpreting the macroeconomic time-series facts: The effects of monetary policy. European Economic Review 36, 975*—*1011.
- Sims, C.A., 1996. Comment on Glenn Rudebusch's Do measures of monetary policy in a VAR make sense? Mimeo. Available at ftp://ftp.econ.yale.edu/pub/sims/mpolicy.
- Sims, C.A., Stock, J.H., Watson, M., 1990. Inference in linear time-series models with some unit roots. Econometrica 58, 113*—*144.
- Sims, C.A., Zha, T., 1996. Does monetary policy generate recessions? Mimeo. Available at ftp://ftp.econ.yale.edu/pub/sims/mpolicy.
- Skinner, T., Zettelmeyer, J., 1996. Identification and effects of monetary policy shocks: An alternative approach. Mimeo. MIT Cambridge, MA, Sept.
- Spanos, A., 1990. The simultaneous-equations model revisited. Statistical adequacy and identification. Journal of Econometrics 44, 87*—*105.
- Stock, J., 1994. Unit roots, structural breaks and trends. In: Engle, R.F., McFadden, D.L. (Eds.), Handbook of Applied Econometrics, vol. IV, Chapter 46. North-Holland, Amsterdam, pp. 2740*—*2841.
- Strongin, S., 1995. The identification of monetary policy disturbances. Explaining the liquidity puzzle. Journal of Monetary Economics 35, 463*—*497.
- Svensson, L.E., 1994. Estimating and interpreting forward interest rates: Sweden 1992*—*1994. Discussion paper no. 1051. CEPR, London.