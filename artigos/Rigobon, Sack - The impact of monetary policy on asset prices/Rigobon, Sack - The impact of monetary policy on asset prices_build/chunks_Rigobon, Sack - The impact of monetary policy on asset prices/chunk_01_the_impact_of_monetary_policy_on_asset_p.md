![](_page_0_Picture_0.jpeg)

![](_page_0_Picture_2.jpeg)

![](_page_0_Picture_3.jpeg)

Journal of Monetary Economics 51 (2004) 1553–1575

<www.elsevier.com/locate/econbase>

# The impact of monetary policy on asset prices\$

Roberto Rigobona,b,, Brian Sackc

a Room E52-434, Sloan School of Management, Massachusetts Institute of Technology, 50 Memorial Drive, Cambridge, MA 02142, USA b NBER, Cambridge, MA 02138, USA c Board of Governors of the Federal Reserve System, Washington, DC 20551, USA

Received 15 May 2003; received in revised form 16 January 2004; accepted 5 February 2004

#### Abstract

Estimating the response of asset prices to changes in monetary policy is complicated by the endogeneity of policy decisions and the fact that both interest rates and asset prices react to numerous other variables. This paper develops a new estimator that is based on the heteroskedasticity that exists in high-frequency data. We show that the response of asset prices to changes in monetary policy can be identified based on the increase in the variance of policy shocks that occurs on days of FOMC meetings and of the Chairman's semi-annual monetary policy testimony to Congress. The identification approach employed requires a much weaker set of assumptions than needed under the ''event-study'' approach that is typically used in this context. The results indicate that an increase in short-term interest rates results in a decline in stock prices and in an upward shift in the yield curve that becomes smaller at longer maturities. The findings also suggest that the event-study estimates contain biases that make

E-mail address: rigobon@mit.edu (R. Rigobon).

<sup>\$</sup>The authors would like to thank Ricardo Caballero (Editor) and an anonymous referee for excellent suggestions. Additionally, we would like to thank Andrew Ang, Antulio Bomfim, Darrel Cohen, William English, James Hamilton, and seminar participants at the Federal Reserve Board and the American Economic Association meetings for useful comments. Comments are welcome to bsack@frb.gov or rigobon@mit.edu. The opinions expressed are those of the authors and do not necessarily reflect the views

of the Board of Governors of the Federal Reserve System or other members of its staff. Corresponding author. Room E52-434, Sloan School of Management, MIT, 50 Memorial Drive, Cambridge, MA 02142, USA. Tel.: +1 617 258 8374; fax: +1 617 258 6855.

the estimated effects on stock prices appear too small and those on Treasury yields too large. r 2004 Elsevier B.V. All rights reserved.

JEL classification: E44; E47; E52

Keywords: Monetary policy; Stock market; Yield curve; Identification; Heteroskedasticity

# 1. Introduction

There is a considerable amount of interest in understanding the interactions between asset prices and monetary policy. In previous research ([Rigobon and Sack,](#page-22-0) [2003\)](#page-22-0), we found that short-term interest rates react significantly to movements in broad equity price indexes, likely reflecting the expected endogenous response of monetary policy to the impact of stock price movements on aggregate demand. This paper attempts to estimate the other side of the relationship: how asset prices react to changes in monetary policy.

This relationship is an important topic for several reasons. From the perspective of monetary policymakers, having reliable estimates of the reaction of asset prices to the policy instrument is a critical step in formulating effective policy decisions. Much of the transmission of monetary policy comes through the influence of short-term interest rates on other asset prices, as it is the movements in these other asset prices including longer-term interest rates and stock prices—that determine private borrowing costs and changes in wealth, which in turn influence real economic activity.

Financial market participants are likely to be equally interested in this topic. Monetary policy exerts a considerable influence on financial markets, as evidenced by the extensive attention that the Federal Reserve receives in the financial press. Thus, having accurate estimates of the responsiveness of asset prices to monetary policy is an important component of formulating effective investment and risk management decisions.

Several difficulties arise in estimating the responsiveness of asset prices to monetary policy, though. First, short-term interest rates are simultaneously influenced by movements in asset prices, resulting in a difficult endogeneity problem. Second, a number of other variables, including news about the economic outlook, likely have an impact on both short-term interest rates and asset prices. These two considerations complicate the identification of the responsiveness of asset prices under previously used methods.

To address these issues, we develop an estimator that identifies the response of asset prices based on the heteroskedasticity of monetary policy shocks. In particular, we assume that the variance of monetary policy shocks is higher on days of FOMC meetings and of the Chairman's semi-annual monetary policy testimony to Congress, when a larger portion of the news hitting markets is about monetary policy. We show that the shift in the variance of the policy shocks on those dates is sufficient to measure the responsiveness of asset prices to monetary policy.

Our approach allows us to identify the parameter of interest under a weaker set of assumptions than required under the approach that other papers have taken in this context. In particular, other papers have typically estimated ordinary-least-squares (OLS) regressions on FOMC dates, which has been called the ''event-study'' method. We show that the event-study approach is an extreme case of our heteroskedasticitybased estimator in which the shift in the variance of the policy shock is large enough to dominate all other shocks. In contrast, the heteroskedasticity-based estimator that we develop requires only an increase in the relative importance of the policy shock. Thus, our estimator can be used to test whether the stronger assumptions under the event-study approach are valid, and, correspondingly, the extent to which the eventstudy estimates are biased.

The paper proceeds as follows. Section 2 discusses the problems of simultaneous equations and omitted variables in estimating the responsiveness of asset prices, demonstrating that some bias may remain in the coefficients estimated under the event-study approach unless some strong assumptions are met. Section 3 describes our identification approach based on the heteroskedasticity of monetary policy shocks and compares the assumptions needed to those required under the eventstudy approach. It demonstrates that the identification method can be implemented as a simple instrumental variables regression or as a generalized-method-of-moments estimator. Results on the responsiveness of stock prices and longer-term interest rates to monetary policy using both the event-study and the heteroskedasticity procedures are presented in Section 4, and Section 5 concludes.
