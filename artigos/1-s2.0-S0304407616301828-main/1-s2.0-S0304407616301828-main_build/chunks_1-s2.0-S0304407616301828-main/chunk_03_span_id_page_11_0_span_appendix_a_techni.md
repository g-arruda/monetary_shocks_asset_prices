## <span id="page-11-0"></span>Appendix A. Technical details for Section 3

Assumption 1 in Section 3 requires the error process  $\varepsilon_t = (\varepsilon_{1,t}, \dots, \varepsilon_{n,t})$  to be temporally independent. The following alternative, weaker assumption allows for (some degree of) temporal dependence by requiring only temporal uncorrelatedness. All the results in Section 3 (but not those in Section 4) hold also under the weaker Assumption 1\*.

- <span id="page-11-1"></span>**Assumption** 1\*. (i) The error process  $\varepsilon_t = (\varepsilon_{1,t}, \dots, \varepsilon_{n,t})$  is a sequence of (strictly) stationary random vectors with each component  $\varepsilon_{i,t}$ ,  $i=1,\dots,n$ , having zero mean and finite positive variance.
- (ii) The component processes  $\varepsilon_{i,t}$ ,  $i=1,\ldots,n$ , are mutually independent and at most one of them has a Gaussian marginal distribution.
- (iii) For all  $i=1,\ldots,n$ , the components  $\varepsilon_{i,t}$  are uncorrelated in time, that is,  $Cov\left[\varepsilon_{i,t},\varepsilon_{i,t+k}\right]=0$  for all  $k\neq 0$ .

Assumption 1\*(ii) is identical to Assumption 1(ii); note that complete statistical independence of the n component processes  $\{\varepsilon_{i,t}, t \in \mathbb{Z}\}$ ,  $i = 1, \ldots, n$ , is assumed. Assuming only uncorrelatedness (and thus not necessarily independence) in Assumption 1\*(iii) has the convenience that conditionally heteroskedastic errors are also covered (for instance, the component error processes can follow conventional GARCH processes which, with appropriate parameter restrictions, are stationary with finite second moments and necessarily non-Gaussian, so that Assumptions 1\*(i) and (ii) apply).

The following proofs of Propositions 1 and 2 rely on Assumption 1\* (which, in turn, is implied by Assumption 1). The proof of Proposition 1 makes use of a well-known result referred to as the Skitovich–Darmois theorem (see, e.g., Theorem 3.1.1 in Kagan et al. (1973)). A variant of this theorem has also been used by Comon (1994) to obtain identifiability in the context of an independent component model. For ease of reference, we first provide this result as the following lemma.

<span id="page-11-3"></span>**Lemma A.1** (Kagan et al. (1973), Theorem 3.1.1). Let  $X_1, \ldots, X_n$  be independent (not necessarily identically distributed) random variables, and define  $Y_1 = \sum_{i=1}^n a_i X_i$  and  $Y_2 = \sum_{i=1}^n b_i X_i$  where  $a_i$  and  $b_i$  are constants. If  $Y_1$  and  $Y_2$  are independent, then the random variables  $X_j$  for which  $a_j b_j \neq 0$  are all normally distributed.

Now we can prove Proposition 1. The proof is straightforward with the most essential part being based on arguments already used by Comon (1994).

**Proof of Proposition 1.** First note that (5) can be expressed as  $y_t = \mu + A(L)^{-1}B\varepsilon_t = \mu^* + A^*(L)^{-1}B^*\varepsilon_t^*$ , where L denotes the lag operator (e.g.,  $Ly_t = y_{t-1}$ ). Taking expectations this implies that  $E[y_t] = \mu = \mu^*$ . Without loss of generality we can continue by assuming that  $\mu = \mu^* = 0$  (alternatively, we can replace  $y_t$  below by  $y_t - \mu$ ). From the preceding equation we then obtain  $y_t - A_1y_{t-1} - \cdots - A_py_{t-p} = B\varepsilon_t$  and  $y_t - A_1^*y_{t-1} - \cdots - A_p^*y_{t-p} = B^*\varepsilon_t^*$ . Denoting  $y_{t-1} = (y_{t-1}, \dots, y_{t-p})$  ( $np \times 1$ ),  $y_t = [A_1 : \dots : A_p]$  ( $n \times np$ ), and  $y_t = [A_1^* : \dots : A_p^*]$  ( $n \times np$ ), this implies that

$$B\varepsilon_{t} - B^{*}\varepsilon_{t}^{*} = (A_{1}^{*} - A_{1})y_{t-1} + \dots + (A_{p}^{*} - A_{p})y_{t-p}$$
$$= (\mathbf{A}^{*} - \mathbf{A})\mathbf{y}_{t-1}. \tag{10}$$

Multiplying this equation from the right by  $\mathbf{y}'_{t-1}$  and taking expectations yields

$$E[(B\varepsilon_t - B^*\varepsilon_t^*)\boldsymbol{y}_{t-1}'] = (\mathbf{A}^* - \mathbf{A})E[\boldsymbol{y}_{t-1}\boldsymbol{y}_{t-1}'],$$

and, as both  $\varepsilon_t$  and  $\varepsilon_t^*$  are uncorrelated with  $\mathbf{y}_{t-1}$  (due to (5) and Assumptions 1\*(ii) and (iii)), we get  $(\mathbf{A}^* - \mathbf{A})E[\mathbf{y}_{t-1}\mathbf{y}_{t-1}'] = 0$ .

Due to the stationarity condition (2) and Assumption 1\*(i), there can be no exact linear dependences between the components of the vector  $\mathbf{y}_{t-1}$  (this follows from the fact that the spectral density matrix of  $y_t$  is everywhere positive definite). Therefore the covariance matrix  $E[\mathbf{y}_{t-1}\mathbf{y}_{t-1}']$  is positive definite and  $\mathbf{A}^* - \mathbf{A} = 0$  must hold. From the definitions of  $\Psi_j$  and  $\Psi_j^*$  and Eq. (10) it therefore follows that  $\Psi_j^* = \Psi_j$ ,  $j = 0, 1, \ldots$ , and  $B\varepsilon_t = B^*\varepsilon_t^*$ . Using the nonsingularity of B we can solve  $\varepsilon_t$  from this equation and obtain

<span id="page-11-4"></span>
$$\varepsilon_t = M \varepsilon_t^*, \quad \text{where } M = B^{-1} B^*.$$
 (11)

By condition (iii) in the Proposition and Assumption 1\*(ii), the random variables  $\varepsilon_{1,t}^*, \dots, \varepsilon_{n,t}^*$  are mutually independent and at most one of them has a Gaussian marginal distribution. Also the random variables  $\varepsilon_{1,t},\ldots,\varepsilon_{n,t}$  are mutually independent. Therefore by Lemma A.1, at most one column of M may contain more than one nonzero element. Suppose, say, the kth column of M has at least two nonzero elements,  $m_{ik}$  and  $m_{jk}$   $(\underline{i \neq j})$ . Then  $\varepsilon_{i,t} =$  $m_{ik}\varepsilon_{k,t}^* + \sum_{l=1,\dots,n;l\neq k} m_{il}\varepsilon_{l,t}^*$  and  $\varepsilon_{j,t} = m_{jk}\varepsilon_{k,t}^* + \sum_{l=1,\dots,n;l\neq k} m_{jl}\varepsilon_{l,t}^*$  with the random variable  $\varepsilon_{k,t}^*$  being Gaussian (due to Lemma A.1) with positive variance (due to Assumption 1\*(i) for the process  $\varepsilon_t^*$ ). Moreover, for all  $l=1,\ldots,n,\ l\neq k$ , it must hold that  $m_{il}m_{jl} = 0$  because only the kth column of M could have more than one nonzero element. This, however, implies (because the random variables  $\varepsilon_{1,t}^*, \dots, \varepsilon_{n,t}^*$  are independent) that  $E[\varepsilon_{i,t}\varepsilon_{j,t}] =$  $m_{ik}m_{jk}E[\varepsilon_{k,t}^{*2}] \neq 0$  so that the random variables  $\varepsilon_{i,t}$  and  $\varepsilon_{j,t}$  are not independent, a contradiction. Therefore each column of M has at most one nonzero element. Now, by the invertibility of M, it follows that each column of M has exactly one nonzero element, and for the same reason, also that each row of M has exactly one nonzero element. Therefore there exist a permutation matrix P and a diagonal matrix  $D = diag(d_1, \ldots, d_n)$  with nonzero diagonal elements such that M = DP. This together with (11) implies that  $\varepsilon_t^* = P'D^{-1}\varepsilon_t$  and  $B^* = BDP$ , thus completing the proof.

Parts (a) and (b) of Proposition 2 are rather straightforward to prove based on the Identification Scheme.

**Proof of Proposition 2, parts (a) and (b).** We begin with part (b). To show that  $\mathcal{B}$  contains representatives from each  $\sim$ -equivalence class of  $\mathcal{I}$ , choose any  $B \in \mathcal{I}$ . Then by the definition of  $\mathcal{B}$ , the matrix  $\Pi(B) = BD_1PD_2$  belongs to  $\mathcal{B}$ . Moreover,  $B \sim \Pi(B) = BD_1PD_2$  (because necessarily  $D_1PD_2 = D_3P$  for some diagonal  $D_3$  with nonzero diagonal elements). To show that such a representative must be unique, suppose  $\tilde{B}_1$ ,  $\tilde{B}_2 \in \mathcal{B}$  and  $\tilde{B}_1 \sim \tilde{B}_2$ . Then for some  $B_1 \sim B_2$  in  $\mathcal{I}$ ,  $\tilde{B}_1 = \Pi(B_1)$  and  $\tilde{B}_2 = \Pi(B_2)$ , so that

$$B_2 = B_1 DP$$
,  $\tilde{B}_1 = B_1 D_1(B_1) P(B_1) D_2(B_1)$ , and  $\tilde{B}_2 = B_2 D_1(B_2) P(B_2) D_2(B_2)$ 

(where we have made the dependence on  $B_1$  and  $B_2$  explicit). Thus  $\tilde{B}_2 = B_1 DPD_1(B_2)P(B_2)D_2(B_2)$ . In the expressions

$$\tilde{B}_1 = B_1 D_1(B_1) P(B_1) D_2(B_1)$$
 and  $\tilde{B}_2 = B_1 DPD_1(B_2) P(B_2) D_2(B_2)$ 

<span id="page-11-2"></span>the matrices  $B_1D_1(B_1)$  and  $B_1DPD_1(B_2)$  are matrices with the same columns but potentially in different order (this follows from the identity  $B_2 = B_1DP$  and the definitions of  $D_1(B_1)$  and  $D_1(B_2)$ ). Therefore, by the definitions of the matrices  $P(B_1)$  and  $P(B_2)$ , it necessarily holds that  $B_1D_1(B_1)P(B_1) = B_1DPD_1(B_2)P(B_2)$ . Thus, due to the definitions of  $D_2(B_1)$  and  $D_2(B_2)$ , the result  $\tilde{B}_1 = \tilde{B}_2$  also follows, implying the desired uniqueness. Finally, to show that the representatives of different equivalence classes are distinct, suppose (on the contrary) that  $\Pi(B_1) = \Pi(B_2)$  but  $B_1 \approx B_2$ . Then  $B_1D_1(B_1)P(B_1)D_2(B_1) = B_2D_1(B_2)P(B_2)D_2(B_2)$ , and solving this equation for  $B_2$  implies the existence of a permutation matrix P and a diagonal matrix D such that  $B_2 = B_1DP$ , a contradiction

with  $B_1 \sim B_2$ . Thus, the representatives must be distinct, and the proof of part (b) is complete.

Having established part (b), to prove (a), it now suffices to note that if  $B, B^* \in \mathcal{B}$  are as in Proposition 1, then  $B^* = BDP$  so that  $B^* \sim B$ . Then, by the uniqueness proved in part (b), necessarily  $B^* = B$ .

The proof of Proposition 2(c) is somewhat more intricate and we resort to using results based on basic algebraic geometry. In what follows, we first define a few concepts from algebraic geometry we need, then present three auxiliary results, and finally prove Proposition 2(c) as a (rather straightforward) consequence of these auxiliary results. A comprehensive reference for the employed concepts is, e.g., Bochnak et al. (1998).

Consider the m-dimensional Euclidean space  $\mathbb{R}^m$ . A subset  $A \subseteq \mathbb{R}^m$  is called a *semi-algebraic set* (cf. Bochnak et al. (1998, Definition 2.1.4)) if it is of the form

$$A = \bigcup_{i=1}^{s} \bigcap_{i=1}^{r_i} \{ x \in \mathbb{R}^m : f_{i,j}(x) *_{i,j} 0 \}, \tag{12}$$

where, for each  $i=1,\ldots,s$  and  $j=1,\ldots,r_i,f_{i,j}(\cdot)$  is a polynomial function (of finite order) in m variables and  $*_{i,j}$  is either =, <, >, or  $\neq$ . A semi-algebraic set is called an *algebraic set* if in (12) the  $*_{i,j}$  is always = (Bochnak et al. (1998, Definition 2.1.1)). Lacking a better term, we will call a semi-algebraic set a *semi-algebraic set* with equality constraints if in (12) for each  $i=1,\ldots,s$  at least one of the  $*_{i,j}$  is = with the corresponding  $f_{i,j}$  not being identically equal to zero. Finally, the quantifier 'proper' is used in connection with these terms (e.g., proper algebraic set) if  $A \neq \mathbb{R}^m$ .

As (proper) algebraic sets are built from zeros of polynomial functions, intuition tells that in some sense they must be 'small' in  $\mathbb{R}^m$  (in  $\mathbb{R}$  they are finite, in  $\mathbb{R}^2$  finite intersections/unions of plane curves, etc.). This is indeed the case, as the following well-known result shows (as we were unable to find a convenient reference, we include a proof in the Supplementary Appendix for completeness).

**Lemma A.2.** A proper algebraic set A of  $\mathbb{R}^m$  has Lebesgue measure zero in  $\mathbb{R}^m$ . Its complement  $\mathbb{R}^m \setminus A$  in  $\mathbb{R}^m$  is an open and dense subset of  $\mathbb{R}^m$ .

Semi-algebraic sets are not necessarily 'small', but as the following result shows, semi-algebraic sets with equality constraints are (proof in the Supplementary Appendix).

<span id="page-12-2"></span>**Lemma A.3.** A proper semi-algebraic set with equality constraints A of  $\mathbb{R}^m$  has Lebesgue measure zero in  $\mathbb{R}^m$ . Its complement  $\mathbb{R}^m \setminus A$  in  $\mathbb{R}^m$  contains an open and dense subset of  $\mathbb{R}^m$ .

Now, consider the set of all (real)  $n \times n$  matrices, which we denote with  $\mathcal{M}_n^A$ . As matrices belonging to  $\mathcal{M}_n^A$  can be identified with vectors of  $\mathbb{R}^{n^2}$  the preceding results can be applied to algebraic sets of  $\mathcal{M}_n^A$  and any statement on algebraic sets of  $\mathcal{M}_n^A$  can be formulated in terms of corresponding algebraic sets of  $\mathbb{R}^{n^2}$  and vice versa. Recall that the set of all invertible  $n \times n$  matrices is denoted with  $\mathcal{M}_n$ . In Proposition 2 we end up excluding the set  $\mathcal{E} \stackrel{def}{=} \mathcal{M}_n \setminus \mathcal{I}$ . This set is a proper semi-algebraic set with equality constraints as the next result shows (proof in the Supplementary Appendix).

<span id="page-12-3"></span>**Lemma A.4.** The set  $\mathcal{E} = \mathcal{M}_n \setminus \mathcal{I}$  is a proper semi-algebraic set with equality constraints of  $\mathcal{M}_n^A$ .

Part (c) of Proposition 2 now follows from the preceding lemmas in a straightforward fashion.

**Proof of Proposition 2, part (c).** The fact that  $\mathscr E$  has Lebesgue measure zero in  $\mathbb R^{n\times n}$  follows directly from Lemmas A.3 and A.4. From these Lemmas it also follows that the set  $\mathcal M_n^A\setminus \mathscr E$  contains an

open and dense subset of  $\mathcal{M}_n^A$ , say O. Note also that the set  $\mathcal{M}_n^A \setminus \mathcal{M}_n$  is a proper algebraic subset of  $\mathcal{M}_n^A$ , and therefore  $\mathcal{M}_n$  is an open and dense subset of  $\mathcal{M}_n^A$  (this holds because the determinant of a matrix is a polynomial function, and a matrix is noninvertible if the determinant equals zero). Elementary calculations can now be used to show that  $O \cap \mathcal{M}_n \subseteq \mathcal{I} = \mathcal{M}_n \cap (\mathcal{M}_n^A \setminus \mathcal{E})$  is an open and dense subset of  $\mathcal{M}_n$ .

## <span id="page-12-0"></span>Appendix B. Technical details for Section 4.2

**Expression of the score.** We denote  $x_{t-1} = (1, y_{t-1}, \dots, y_{t-p})$  and  $\pi = vec\left(\left[v: A_1: \dots: A_p\right]\right)$ , and express  $u_t\left(\pi\right) = y_t - v - A_1y_{t-1} - \dots - A_py_{t-p}$  briefly as  $u_t\left(\pi\right) = y_t - (x'_{t-1} \otimes I_n)\pi$ . Regarding the matrix  $B(\beta)$ , for brevity we do not make its dependence on  $\beta$  explicit and denote  $B = B(\beta)$ . When  $B(\beta)$  is evaluated at  $\beta = \beta_0$ , we denote  $B_0 = B(\beta_0)$ . We also define  $\varepsilon_{i,t}\left(\theta\right) = \iota_i'B^{-1}u_t\left(\pi\right)$  (in the notation we ignore the fact that  $\varepsilon_{i,t}\left(\theta\right)$  does not depend on the parameter vector  $\lambda$ ) and  $\varepsilon_t\left(\theta\right) = \left(\varepsilon_{1,t}\left(\theta\right), \dots, \varepsilon_{n,t}\left(\theta\right)\right)$ . Note that when evaluated at the true parameter values we have  $u_t\left(\pi_0\right) = B_0\varepsilon_t$  and  $\varepsilon_{i,t}\left(\theta_0\right) = \varepsilon_{i,t}$ . Furthermore, define

<span id="page-12-1"></span>
$$e_{i,x,t}(\theta) = \frac{f_{i,x}(\sigma_i^{-1}\iota_i'B^{-1}u_t(\pi);\lambda_i)}{f_i(\sigma_i^{-1}\iota_i'B^{-1}u_t(\pi);\lambda_i)} \text{ and}$$

$$e_{i,\lambda_{i},t}\left(\theta\right) = \frac{f_{i,\lambda_{i}}\left(\sigma_{i}^{-1}\iota_{i}^{\prime}B^{-1}u_{t}\left(\pi\right);\lambda_{i}\right)}{f_{i}\left(\sigma_{i}^{-1}\iota_{i}^{\prime}B^{-1}u_{t}\left(\pi\right);\lambda_{i}\right)}$$

and use them to form the  $n \times 1$  and  $d \times 1$  vectors

$$e_{x,t}(\theta) = (e_{1,x,t}(\theta), \dots, e_{n,x,t}(\theta))$$
 and  $e_{\lambda,t}(\theta) = (e_{1,\lambda_1,t}(\theta), \dots, e_{n,\lambda_n,t}(\theta)).$ 

Finally, denote  $\Sigma = diag(\sigma_1, \ldots, \sigma_n)$ .

Let  $l_{\theta,t}(\theta) = (l_{\pi,t}(\theta), l_{\beta,t}(\theta), l_{\sigma,t}(\theta), l_{\lambda,t}(\theta))$  with  $l_{\sigma,t}(\theta) = (l_{\sigma_1,t}(\theta), \dots, l_{\sigma_n,t}(\theta))$  and  $l_{\lambda,t}(\theta) = (l_{\lambda_1,t}(\theta), \dots, l_{\lambda_n,t}(\theta))$  be the score vector of  $\theta$  based on a single observation. With straightforward differentiation (details omitted but available in the Supplementary Appendix) one obtains (the matrix H is defined in footnote 8)

$$l_{\pi,t}(\theta) = -(x_{t-1} \otimes B^{-1'} \Sigma^{-1}) e_{x,t}(\theta),$$
 (13a)

<span id="page-12-4"></span>
$$l_{\beta,t}(\theta) = -H'[(B^{-1}u_t(\pi) \otimes B^{-1'}\Sigma^{-1})e_{x,t}(\theta) + vec(B^{-1'})], (13b)$$

$$l_{\sigma,t}(\theta) = -\Sigma^{-2} \left[ \varepsilon_t(\theta) \odot e_{x,t}(\theta) + \sigma \right], \tag{13c}$$

$$l_{\lambda,t}(\theta) = e_{\lambda,t}(\theta), \tag{13d}$$

which form  $L_{\theta,T}\left(\theta\right) = T^{-1}\sum_{t=1}^{T}l_{\theta,t}\left(\theta\right)$ , the score vector of  $\theta$ . When evaluated at the true parameter value, the components of  $l_{\theta,t}\left(\theta_{0}\right) = \left(l_{\pi,t}\left(\theta_{0}\right),l_{\beta,t}\left(\theta_{0}\right),l_{\sigma,t}\left(\theta_{0}\right),l_{\lambda,t}\left(\theta_{0}\right)\right)$  are

<span id="page-12-6"></span><span id="page-12-5"></span>
$$l_{\pi,t}(\theta_0) = -(x_{t-1} \otimes B_0^{-1'} \Sigma_0^{-1}) e_{x,t}$$
(14a)

<span id="page-12-8"></span>
$$l_{\beta,t}(\theta_0) = -H'[(\varepsilon_t \otimes B_0^{-1} \Sigma_0^{-1} e_{x,t}) + vec(B_0^{-1})]$$
 (14b)

<span id="page-12-7"></span>
$$l_{\sigma,t}(\theta_0) = -\Sigma_0^{-2} (\varepsilon_t \odot e_{x,t} + \sigma_0)$$
(14c)

$$l_{\lambda t}(\theta_0) = e_{\lambda t}, \tag{14d}$$

where  $\Sigma_0 = diag(\sigma_{1,0}, \ldots, \sigma_{n,0}), e_{x,t} = (e_{1,x,t}, \ldots, e_{n,x,t}),$  and  $e_{\lambda,t} = (e_{1,\lambda_1,t}, \ldots, e_{n,\lambda_n,t})$  with

$$e_{i,x,t} = e_{i,x,t} (\theta_0) = \frac{f_{i,x}(\sigma_{i,0}^{-1} \varepsilon_{i,t}; \lambda_{i,0})}{f_i(\sigma_{i,0}^{-1} \varepsilon_{i,t}; \lambda_{i,0})}$$
 and

$$e_{i,\lambda_i,t} = e_{i,\lambda_i,t} \left(\theta_0\right) = \frac{f_{i,\lambda_i}(\sigma_{i,0}^{-1}\varepsilon_{i,t};\lambda_{i,0})}{f_i(\sigma_{i,0}^{-1}\varepsilon_{i,t};\lambda_{i,0})}.$$

**An auxiliary lemma.** The following lemma contains results needed in subsequent derivations. Its proof is straightforward and is given in the Supplementary Appendix.

<span id="page-13-1"></span>**Lemma B.1.** Under Assumptions 2–4, the following hold for  $i = 1, \ldots, n$ : (i)  $E\left[e_{i,x,t}\right] = 0$ , (ii)  $E\left[e_{i,x,t}^2\right] < \infty$ , (iii)  $E\left[e_{i,\lambda_i,t}\right] = 0$ , (iv)  $E\left[e_{i,\lambda_i,t}^2\right] = -\sigma_{i,0}$ , (vi)  $E\left[\varepsilon_{i,t}^2 e_{i,x,t}^2\right] < \infty$ .

**Martingale property of the score**. Consider  $L_{\theta,T}(\theta_0) = T^{-1} \sum_{t=1}^{T} l_{\theta,t}(\theta_0)$ , the score vector of  $\theta$  evaluated at the true parameter value. Let  $E_t[\cdot]$  signify the conditional expectation given the sigma-algebra  $\mathcal{F}_t = \sigma\left(\varepsilon_{t-j}, j \geq 0\right)$  or, equivalently, the sigma-algebra  $\sigma\left(y_{t-j}, j \geq 0\right)$  (see (4)). We need to demonstrate that  $\{l_{\theta,t}(\theta_0), \mathcal{F}_t\}$  is a martingale difference sequence.

First note that  $l_{\pi,t}$  ( $\theta_0$ ) =  $-(x_{t-1} \otimes B_0^{-1'} \Sigma_0^{-1}) e_{x,t}$  so that for this component of  $l_{\theta,t}$  ( $\theta_0$ ) the desired result follows from  $E_{t-1}[(x_{t-1} \otimes B_0^{-1'} \Sigma_0^{-1}) e_{x,t}] = 0$  which holds in view of Lemma B.1(i) and the independence of  $x_{t-1}$  and  $\varepsilon_t$ . Next consider  $l_{\lambda,t}$  ( $\theta_0$ ) =  $e_{\lambda,t}$  where  $e_{\lambda,t}$  is an IID sequence so that it suffices to show that  $E\left[e_{\lambda,t}\right] = 0$  which holds by Lemma B.1(iii). As seen from (13c),  $l_{\sigma,t}$  ( $\theta_0$ ) is an IID sequence and  $E_{t-1}[l_{\sigma,t}$  ( $\theta_0$ )] = 0 follows from the identity  $E\left[\varepsilon_{i,t}e_{i,x,t}\right] = -\sigma_{i,0}$  obtained from Lemma B.1(v). Finally, consider  $l_{\beta,t}$  ( $\theta_0$ ). As  $B_0^{-1}u_t$  ( $\pi_0$ ) =  $\varepsilon_t$  and  $e_{x,t}$  ( $\theta_0$ ) =  $e_{x,t}$  are IID sequences, we only need to show that  $E[\varepsilon_t \otimes B_0^{-1'} \Sigma_0^{-1} e_{x,t}] = -vec(B_0^{-1'})$  (see (14b)). To this end, note that  $\varepsilon_{i,t}$  and  $e_{j,x,t}$  are independent when  $i \neq j$ , so that from Lemma B.1(i) and (v) it follows that  $E[\varepsilon_{i,t}e_{j,x,t}] = -\sigma_{i,0}$  when i = j and zero otherwise. Thus, as  $\varepsilon_t \otimes B_0^{-1'} \Sigma_0^{-1} e_{x,t} = vec\left(B_0^{-1'} \Sigma_0^{-1} e_{x,t} \varepsilon_t'\right)$  and  $E\left[e_{x,t}\varepsilon_t'\right] = -\Sigma_0$  we find that

$$E[\varepsilon_t \otimes B_0^{-1'} \Sigma_0^{-1} e_{x,t}] = vec\left(E\left[B_0^{-1'} \Sigma_0^{-1} e_{x,t} \varepsilon_t'\right]\right) = -vec(B_0^{-1'}),$$

which shows the desired result.

**Covariance matrix of the score** — **expression.** We derive the components of  $Cov\left[l_{\theta,t}\left(\theta_{0}\right)\right]$  which equal the components of  $Cov\left[L_{\theta,T}\left(\theta_{0}\right)\right]$  (see (14a)–(14d)). To this end, denote  $V_{e_{x}}=Cov\left[e_{x,t}\right]$   $(n\times n)$ ,  $V_{e_{\lambda}}=Cov\left[e_{\lambda,t}\right]$   $(d\times d)$ , and  $V_{e_{x}e_{\lambda}}=Cov\left[e_{x,t},e_{\lambda,t}\right]$   $(n\times d)$ , and note that by Assumption 2(i) and Lemma B.1(i)–(iv),  $V_{e_{x}}$  is a diagonal matrix with finite diagonal elements,  $V_{e_{\lambda}}$  is a block-diagonal matrix with finite diagonal blocks, and  $Cov\left[e_{i,x,t},e_{j,\lambda,t}\right]=0$  for  $i\neq j$ . To derive the expression of  $Cov\left[l_{\theta,t}\left(\theta_{0}\right)\right]$ , first consider its diagonal blocks (the finiteness of the blocks of  $Cov\left[l_{\theta,t}\left(\theta_{0}\right)\right]$  is here assumed and justified below). Straightforward computation leads to the expressions

$$\begin{split} & Cov\left[l_{\pi,t}\left(\theta_{0}\right)\right] = E\left[x_{t-1}x_{t-1}'\right] \otimes B_{0}^{-1'} \varSigma_{0}^{-1} V_{e_{x}} \varSigma_{0}^{-1} B_{0}^{-1}, \\ & Cov\left[l_{\beta,t}\left(\theta_{0}\right)\right] = H'(I_{n} \otimes B_{0}^{-1'} \varSigma_{0}^{-1}) E\left[\varepsilon_{t}\varepsilon_{t}' \otimes e_{x,t}e_{x,t}'\right] \\ & \times \left(I_{n} \otimes \varSigma_{0}^{-1} B_{0}^{-1}\right) H - H'vec(B_{0}^{-1'})vec(B_{0}^{-1'})'H, \\ & Cov\left[l_{\lambda,t}\left(\theta_{0}\right)\right] = V_{e_{1}}, \end{split}$$

where in deriving the second result we have used the result  $E[\varepsilon_t \otimes B_0^{-1'} \Sigma_0^{-1} e_{x,t}] = -vec(B_0^{-1'})$  obtained above. The covariance matrix of  $l_{\sigma,t}(\theta_0)$  is

$$\operatorname{Cov}\left[l_{\sigma,t}\left(\theta_{0}\right)\right]=\boldsymbol{\varSigma}_{0}^{-2}\operatorname{E}\left[\left(\boldsymbol{\varepsilon}_{t}\odot\boldsymbol{e}_{\mathbf{x},t}+\boldsymbol{\sigma}_{0}\right)\left(\boldsymbol{\varepsilon}_{t}\odot\boldsymbol{e}_{\mathbf{x},t}+\boldsymbol{\sigma}_{0}\right)'\right]\boldsymbol{\varSigma}_{0}^{-2},$$

a diagonal matrix with diagonal elements

$$\begin{split} E[(\sigma_{i,0}^{-2}\varepsilon_{i,t}e_{i,x,t} + \sigma_{i,0}^{-1})^2] &= \sigma_{i,0}^{-2}E[(\sigma_{i,0}^{-1}\varepsilon_{i,t}e_{i,x,t} + 1)^2] \\ &= \sigma_{i,0}^{-4}(E[\varepsilon_{i,t}^2e_{i,x,t}^2] - \sigma_{i,0}^2), \quad i = 1, \dots, n. \end{split}$$

The off-diagonal blocks of  $Cov\left[l_{\theta,t}\left(\theta_{0}\right)\right]$  can be derived by straightforward computation by using the expressions in (14),

Lemma B.1, the martingale difference property of  $l_{\theta,t}$  ( $\theta_0$ ), the result  $E[\varepsilon_t \otimes B_0^{-1'} \Sigma_0^{-1} e_{x,t}] = -vec(B_0^{-1'})$  derived above, and the independence of  $x_{t-1}$  and  $(\varepsilon_t, e_{x,t}, e_{\lambda,t})$ . The resulting expressions are

$$\begin{split} &Cov\left[l_{\pi,t}\left(\theta_{0}\right),l_{\beta,t}\left(\theta_{0}\right)\right]\\ &=\left(E\left[x_{t-1}\right]\otimes B_{0}^{-1'}\varSigma_{0}^{-1}\right)E\left[\varepsilon_{t}'\otimes e_{x,t}e_{x,t}'\right]\left(l_{n}\otimes \varSigma_{0}^{-1}B_{0}^{-1}\right)H,\\ &Cov\left[l_{\pi,t}\left(\theta_{0}\right),l_{\sigma,t}\left(\theta_{0}\right)\right]\\ &=\left(E\left[x_{t-1}\right]\otimes B_{0}^{-1'}\varSigma_{0}^{-1}\right)E\left[e_{x,t}\left(\varepsilon_{t}\odot e_{x,t}\right)'\right]\varSigma_{0}^{-2},\\ &Cov\left[l_{\pi,t}\left(\theta_{0}\right),l_{\lambda,t}\left(\theta_{0}\right)\right]=-E\left[x_{t-1}\right]\otimes B_{0}^{-1'}\varSigma_{0}^{-1}E\left[e_{x,t}e_{\lambda,t}'\right],\\ &Cov\left[l_{\beta,t}\left(\theta_{0}\right),l_{\sigma,t}\left(\theta_{0}\right)\right]=H'\left(l_{n}\otimes B_{0}^{-1'}\varSigma_{0}^{-1}\right)\\ &\times E\left[\left(\varepsilon_{t}\otimes e_{x,t}\right)\left(\varepsilon_{t}\odot e_{x,t}\right)'\right]\varSigma_{0}^{-2}-H'vec(B_{0}^{-1'})\sigma_{0}'\varSigma_{0}^{-2},\\ &Cov\left[l_{\beta,t}\left(\theta_{0}\right),l_{\lambda,t}\left(\theta_{0}\right)\right]=-H'\left(l_{n}\otimes B_{0}^{-1'}\varSigma_{0}^{-1}\right)E\left[\varepsilon_{t}\otimes e_{x,t}e_{\lambda,t}'\right],\\ &Cov\left[l_{\sigma,t}\left(\theta_{0}\right),l_{\lambda,t}\left(\theta_{0}\right)\right]=-\Sigma_{0}^{-2}E\left[\left(\varepsilon_{t}\odot e_{x,t}\right)e_{\lambda,t}'\right]. \end{split}$$

**Covariance matrix of the score** — **finiteness.** By the Cauchy–Schwarz inequality, it suffices to show that the diagonal blocks of  $Cov\left[l_{\theta,t}\left(\theta_{0}\right)\right]$  are finite. This, in turn, is the case if the following expectations are finite:

(i) 
$$E[x_{t-1}x'_{t-1}]$$
, (ii)  $V_{e_x}$ , (iii)  $E[\varepsilon_t\varepsilon'_t\otimes e_{x,t}e'_{x,t}]$ , (iv)  $V_{e_\lambda}$ , and (v)  $E[\varepsilon^2_{i,t}e^2_{i,x,t}]$ .

The elements of  $E[x_{t-1}x'_{t-1}]$  in (i) can be expressed in terms of the expectation of  $y_t$  and the covariance matrices  $Cov\left[y_t,y_{t+k}\right]$ ,  $k=0,\ldots,p$ , and are thus finite. Finiteness of the moments in (ii) and (iv) was already noted above. A typical element of  $E[\varepsilon_t\varepsilon'_t\otimes e_{x,t}e'_{x,t}]$  in (iii) is  $E\left[\varepsilon_{i,t}\varepsilon_{j,t}e_{k,x,t}e_{l,x,t}\right]$  which by Assumption 1(i) and Lemma B.1(i,ii,vi) is finite and zero if one of the indexes i,j,k, and l is different from all others. When i=k and  $j=l\neq k$  we have  $E\left[\varepsilon_{i,t}e_{i,x,t}\varepsilon_{j,t}e_{j,x,t}\right]=E\left[\varepsilon_{i,t}e_{i,x,t}\right]E\left[\varepsilon_{j,t}e_{j,x,t}\right]=\sigma_{i,0}^2$  because both of the last expectations are equal to  $-\sigma_{i,0}$ , as noted above, and similarly when i=l and  $j=k\neq l$ . Finally, when  $i=j\neq k=l$  we have  $E\left[\varepsilon_{i,t}^2,e_{k,x,t}^2\right]=E\left[\varepsilon_{i,t}^2\right]E\left[e_{k,x,t}^2\right]=\sigma_{i,0}^2E\left[e_{k,x,t}^2\right]$ , so that altogether we have

$$E\left[\varepsilon_{i,t}\varepsilon_{j,t}e_{k,x,t}e_{l,x,t}\right] = \begin{cases} \sigma_{i,0}^2, i = k, j = l \neq k & \text{or} \quad i = l, j = k \neq l, \\ E\left[\varepsilon_{i,t}^2e_{i,x,t}^2\right], i = j = k = l, \\ \sigma_{i,0}^2E\left[\varepsilon_{k,x,t}^2\right], i = j \neq k = l, \\ 0, \text{ otherwise.} \end{cases}$$

Finiteness of the moments appearing in this expression, as well as that in (v), is ensured by Assumption 1(i) and Lemma B.1(ii,vi).

**Proof of Lemma 1.** We have demonstrated above that  $\{l_{\theta,t}(\theta_0), \mathcal{F}_t\}$  is a martingale difference sequence with a finite covariance matrix. By Assumption 4(v), this covariance matrix is positive definite. As a (measurable) function of the IID sequence  $\varepsilon_t$ , the process  $l_{\theta,t}(\theta_0)$  is also stationary and ergodic, and hence the central limit theorem of Billingsley (1961) (in conjunction with the Cramér–Wold device) implies the stated asymptotic normality.

# <span id="page-13-0"></span>Appendix C. Technical details for Section 4.3

**Expression for the Hessian matrix.** In accordance with the partition of  $\theta$  as  $\theta=(\pi,\beta,\sigma,\lambda)$ , we will denote the 16 blocks of the Hessian matrix with  $l_{\pi\pi,t}(\theta)=\frac{\partial^2 l_t(\theta)}{\partial \pi \partial \pi'}, l_{\pi\beta,t}(\theta)=\frac{\partial^2 l_t(\theta)}{\partial \pi \partial \beta'}$ , etc. Let us summarize what form the 16 blocks of the Hessian  $l_{\theta\theta,t}(\theta)$  take. To simplify notation define, for  $i=1,\ldots,n$ , the quantities

$$e_{i,xx,t}(\theta) = \frac{f_{i,xx}(\sigma_i^{-1}\iota_i'B^{-1}u_t(\pi);\lambda_i)}{f_i(\sigma_i^{-1}\iota_i'B^{-1}u_t(\pi);\lambda_i)}$$

$$\begin{split} &-\left(\frac{f_{i,x}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}{f_{i}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}\right)^{2},\\ e_{i,x\lambda_{i},t}(\theta) &= \frac{f_{i,x\lambda_{i}}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}{f_{i}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}\\ &-\frac{f_{i,x}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}{f_{i}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}\frac{f_{i,\lambda_{i}}'(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}{f_{i}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})},\\ e_{i,\lambda_{i}\lambda_{i},t}(\theta) &= \frac{f_{i,\lambda_{i}\lambda_{i}}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}{f_{i}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}\\ &-\frac{f_{i,\lambda_{i}}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}{f_{i}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}\frac{f_{i,\lambda_{i}}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}{f_{i}(\sigma_{i}^{-1}\iota_{i}'B^{-1}u_{t}(\pi);\lambda_{i})}, \end{split}$$

and use these to form the diagonal / block diagonal matrices

$$e_{xx,t}(\theta) = diag\left(e_{1,xx,t}(\theta), \dots, e_{n,xx,t}(\theta)\right)(n \times n),$$

$$e_{\lambda\lambda,t}(\theta) = diag\left(e_{1,\lambda_1\lambda_1,t}(\theta), \dots, e_{n,\lambda_n\lambda_n,t}(\theta)\right)(d \times d),$$

$$e_{x\lambda,t}(\theta) = diag(e_{1,x\lambda_1,t}(\theta), \dots, e_{n,x\lambda_n,t}(\theta))(n \times d).$$

Also define the diagonal matrices

$$E_{x,t}(\theta) = diag\left(e_{1,x,t}(\theta), \dots, e_{n,x,t}(\theta)\right) (n \times n),$$
  

$$\mathcal{E}_t(\theta) = diag\left(\varepsilon_{1,t}(\theta), \dots, \varepsilon_{n,t}(\theta)\right) (n \times n),$$

and let  $K_{nn}$  ( $n^2 \times n^2$ ) denote the commutation matrix (satisfying  $K_{nn}vec(A) = vec(A')$  for any  $n \times n$  matrix A). Now, straightforward but tedious differentiation (details available in the Supplementary Appendix) yields the different blocks of  $l_{\theta\theta,t}(\theta)$  as

$$\begin{split} l_{\pi\pi,t} \left(\theta\right) &= (l_n \otimes B^{-1'} \Sigma^{-1}) (x_{t-1} x'_{t-1} \otimes e_{xx,t} \left(\theta\right)) (l_n \otimes \Sigma^{-1} B^{-1}), \\ l_{\pi\beta,t} \left(\theta\right) &= x_{t-1} \otimes \left[ (l_n \otimes e'_{x,t} \left(\theta\right)) (B^{-1'} \otimes \Sigma^{-1} B^{-1}) H \right] \\ &+ x_{t-1} \otimes \left[ B^{-1'} \Sigma^{-1} (u'_t \left(\pi\right) \otimes e_{xx,t} \left(\theta\right)) (B^{-1'} \otimes \Sigma^{-1} B^{-1}) H \right], \\ l_{\beta\beta,t} \left(\theta\right) &= H' (B^{-1} \otimes B^{-1'} \Sigma^{-1}) (u_t \left(\pi\right) u'_t \left(\pi\right) \otimes e_{xx,t} \left(\theta\right)) \\ &\times (B^{-1'} \otimes \Sigma^{-1} B^{-1}) H + H' (B^{-1} \otimes l_n) \left( u_t \left(\pi\right) e'_{x,t} \left(\theta\right) \otimes l_n \right) \\ &\times (\Sigma^{-1} B^{-1} \otimes B^{-1'}) K_{nn} H \\ &+ H' K_{nn} (B^{-1'} \Sigma^{-1} \otimes B^{-1}) \left( e_{x,t} \left(\theta\right) u'_t \left(\pi\right) \otimes l_n \right) (B^{-1'} \otimes l_n) H \\ &+ H' (B^{-1} \otimes B^{-1'}) K_{nn} H, \\ l_{\pi\sigma,t} \left(\theta\right) &= x_{t-1} \otimes B^{-1'} \left[ \Sigma^{-2} E_{x,t} \left(\theta\right) + \Sigma^{-3} e_{xx,t} \left(\theta\right) \mathcal{E}_t \left(\theta\right) \right], \\ l_{\beta\sigma,t} \left(\theta\right) &= H' (B^{-1} \otimes B^{-1'}) \left( u_t \left(\pi\right) \otimes \left[ \Sigma^{-2} E_{x,t} \left(\theta\right) + \Sigma^{-3} e_{xx,t} \left(\theta\right) \mathcal{E}_t \left(\theta\right) \right], \\ l_{\sigma\sigma,t} \left(\theta\right) &= \Sigma^{-2} + 2 \Sigma^{-3} \mathcal{E}_t \left(\theta\right) E_{x,t} \left(\theta\right) + \Sigma^{-4} \mathcal{E}_t^2 \left(\theta\right) e_{xx,t} \left(\theta\right), \\ l_{\pi\lambda,t} \left(\theta\right) &= -H' (B^{-1} \otimes B^{-1'} \Sigma^{-1}) \left( u_t \left(\pi\right) \otimes e_{x\lambda,t} \left(\theta\right) \right), \\ l_{\beta\lambda,t} \left(\theta\right) &= -H' (B^{-1} \otimes B^{-1'} \Sigma^{-1}) \left( u_t \left(\pi\right) \otimes e_{x\lambda,t} \left(\theta\right) \right), \\ l_{\partial\lambda,t} \left(\theta\right) &= -\Sigma^{-2} \mathcal{E}_t \left(\theta\right) e_{x\lambda,t} \left(\theta\right), \\ l_{\lambda\lambda,t} \left(\theta\right) &= e_{\lambda\lambda,t} \left(\theta\right). \end{split}$$

**Proof of Lemma 2.** Regarding the uniform convergence of the Hessian, from the stationarity and ergodicity of  $y_t$  and the expressions of the components of  $l_{\theta\theta,t}(\theta)$  at the beginning of this Appendix it follows that  $l_{\theta\theta,t}(\theta)$  forms a stationary ergodic sequence of random variables that are continuous in  $\theta$  over  $\Theta_0$ . The desired result thus follows (see, e.g., Ranga Rao (1962)) if we establish that  $E\left[\sup_{\theta\in\Theta_0}\left\|l_{\theta\theta,t}(\theta)\right\|\right]$  is finite or that the corresponding result holds for the (matrix) components of  $l_{\theta\theta,t}(\theta)$ . In light of the expression of  $l_{\theta\theta,t}(\theta)$  and the definition of  $\Theta$  in Assumption 3, it suffices to show that the following condition holds:

 $E[\sup_{\theta \in \Theta_0} ||*||]$  is finite whenever \*

is replaced by any of the following expressions:

Is replaced by any of the following expressions: 
$$x_{t-1}x'_{t-1}\otimes e_{xx,t}(\theta), \quad x_{t-1}\otimes I_n\otimes e'_{x,t}(\theta),$$
 
$$x_{t-1}\otimes u'_t(\pi)\otimes e_{xx,t}(\theta), \quad u_t(\pi)u'_t(\pi)\otimes e_{xx,t}(\theta),$$
 
$$u_t(\pi)e'_{x,t}(\theta)\otimes I_n, \quad x_{t-1}\otimes E_{x,t}(\theta), \quad x_{t-1}\otimes e_{xx,t}(\theta)\&_t(\theta),$$
 
$$u_t(\pi)\otimes E_{x,t}(\theta),$$
 
$$u_t(\pi)\otimes e_{xx,t}(\theta)\&_t(\theta), \quad \&_t(\theta)E_{x,t}(\theta), \quad \&_t^2(\theta)e_{xx,t}(\theta),$$
 
$$x_{t-1}\otimes e_{x\lambda,t}(\theta),$$
 
$$u_t(\pi)\otimes e_{x\lambda,t}(\theta), \quad \&_t(\theta)e_{x\lambda,t}(\theta), \quad e_{\lambda\lambda,t}(\theta).$$

By submultiplicativity and the property  $||U \otimes V|| = ||U|| ||V||$  of the Euclidean matrix norm (for any matrices U and V), it suffices to show that the following condition holds:

 $E[\sup_{\theta \in \Theta_0} *]$  is finite whenever \*

<span id="page-14-0"></span>is replaced by any of the following expressions: (15) 
$$\|x_{t-1}\|^2 \|e_{xx,t}(\theta)\|, \quad \|x_{t-1}\| \|e_{x,t}(\theta)\|, \\ \|x_{t-1}\| \|u_t(\pi)\| \|e_{xx,t}(\theta)\|, \quad \|u_t(\pi)\|^2 \|e_{xx,t}(\theta)\|, \\ \|u_t(\pi)\| \|e_{x,t}(\theta)\|, \quad \|x_{t-1}\| \|E_{x,t}(\theta)\|, \\ \|x_{t-1}\| \|e_{xx,t}(\theta)\| \|\mathcal{E}_{t}(\theta)\|, \quad \|u_t(\pi)\| \|E_{x,t}(\theta)\|, \\ \|u_t(\pi)\| \|e_{xx,t}(\theta)\| \|\mathcal{E}_{t}(\theta)\|, \quad \|u_t(\pi)\| \|e_{xx,t}(\theta)\|, \\ \|\mathcal{E}_{t}(\theta)\| \|E_{x,t}(\theta)\|, \quad \|\mathcal{E}_{t}(\theta)\|^2 \|e_{xx,t}(\theta)\|, \\ \|x_{t-1}\| \|e_{x\lambda,t}(\theta)\|, \quad \|\mathcal{E}_{t}(\theta)\| \|e_{x\lambda,t}(\theta)\|, \\ \|u_t(\pi)\| \|e_{x\lambda,t}(\theta)\|, \quad \|\mathcal{E}_{t}(\theta)\| \|e_{x\lambda,t}(\theta)\|, \quad \|e_{\lambda\lambda,t}(\theta)\|.$$

By the definitions of  $e_{i,xx,t}(\theta)$ ,  $e_{i,x,t}(\theta)$ ,  $e_{i,x\lambda_i,t}(\theta)$ , and  $e_{i,\lambda_i\lambda_i,t}(\theta)$  and Assumption 5(iii), for some  $C < \infty$  and for all  $i = 1, \ldots, n$  and all  $\theta \in \Theta_0$ ,

$$\begin{aligned} \left| e_{i,x,t} \left( \theta \right) \right|, e_{i,x,t}^{2} \left( \theta \right), \left| e_{i,xx,t} \left( \theta \right) \right| &\leq C \left( 1 + \left\| u_{t} \left( \pi \right) \right\|^{a_{1}} \right), \\ \left\| e_{i,x\lambda_{i},t} \left( \theta \right) \right\| &\leq C \left( 1 + \left\| u_{t} \left( \pi \right) \right\|^{a_{2}} \right), \\ \left\| e_{i,\lambda_{i}\lambda_{i},t} \left( \theta \right) \right\| &\leq C \left( 1 + \left\| u_{t} \left( \pi \right) \right\|^{a_{3}} \right). \end{aligned}$$

On the other hand, by the definitions of  $u_t(\pi)$ ,  $\varepsilon_{i,t}(\theta)$  ( $i=1,\ldots,n$ ), and  $x_{t-1}=\left(1,y_{t-1},\ldots,y_{t-p}\right)$ , for some  $C<\infty$  and for all  $\theta\in\Theta_0$ ,

$$\begin{aligned} \|u_{t}\left(\pi\right)\| &\leq C\left(1 + \sum_{j=0}^{p} \|y_{t-j}\|\right), \\ \left|\varepsilon_{i,t}\left(\theta\right)\right| &\leq \|\iota_{i}'B\left(\beta\right)^{-1}\| \|u_{t}\left(\pi\right)\| &\leq C\left(1 + \sum_{j=0}^{p} \|y_{t-j}\|\right), \\ \|x_{t-1}\| &\leq 1 + \sum_{j=1}^{p} \|y_{t-j}\|, \quad \text{and} \quad \|x_{t-1}\|^{2} &= 1 + \sum_{j=1}^{p} \|y_{t-j}\|^{2}. \end{aligned}$$

Consequently by Loève's  $c_r$ -inequality, for any fixed r>0 and some  $C<\infty$ .

$$\|u_t(\pi)\|^r \le C\left(1 + \sum_{i=0}^p \|y_{t-i}\|^r\right).$$

Combining the results above, it can be shown that condition (15) holds as long as  $E[\|y_t\|^{2+a_1} + \|y_t\|^{1+a_2} + \|y_t\|^{a_3}] < \infty$ . This, in turn, holds if  $E[|\varepsilon_{i,t}|^r] < \infty$  for  $r = 2 + a_1$ ,  $1 + a_2$ ,  $a_3$  and all  $i = 1, \ldots, n$ , which is ensured by Assumption 5(iii).

Finally, using Assumptions 5(i) and (ii) (and the earlier assumptions) the identity  $E\left[l_{\theta\theta,t}\left(\theta_{0}\right)\right]=-E\left[l_{\theta,t}\left(\theta_{0}\right)l_{\theta,t}'\left(\theta_{0}\right)\right]$  can be established with straightforward but quite tedious and uninteresting matrix algebra. For brevity, we omit the details, which are available in the Supplementary Appendix.

## Appendix D. Technical details for Section 4.4

**Proof of Theorem 1. Existence of a consistent root.** We first show that there exists a sequence of solutions  $\hat{\theta}_T$  to the likelihood equations  $L_{\theta,T}(\theta)=0$  that are strongly consistent for  $\theta_0$ . To this end, choose a small fixed  $\epsilon>0$  such that the sphere  $\Theta_\epsilon=\{\theta:\|\theta-\theta_0\|=\epsilon\}$  is contained in  $\Theta_0$ . We will compare the values attained by  $L_T(\theta)$  on this sphere with  $L_T(\theta_0)$ . For an arbitrary point  $\theta\in\Theta_\epsilon$ , using a second-order Taylor expansion around  $\theta_0$  and adding and subtracting terms yields

$$\begin{split} L_{T}\left(\theta\right) - L_{T}\left(\theta_{0}\right) &= \left(\theta - \theta_{0}\right)' L_{\theta,T}\left(\theta_{0}\right) \\ &+ \frac{1}{2} \left(\theta - \theta_{0}\right)' \left[L_{\theta\theta,T}\left(\theta_{\bullet}\right) - E[l_{\theta\theta,t}\left(\theta_{\bullet}\right)]\right] \left(\theta - \theta_{0}\right) \\ &+ \frac{1}{2} \left(\theta - \theta_{0}\right)' \left[E[l_{\theta\theta,t}\left(\theta_{\bullet}\right)] - E[l_{\theta\theta,t}\left(\theta_{0}\right)]\right] \left(\theta - \theta_{0}\right) \\ &+ \frac{1}{2} \left(\theta - \theta_{0}\right)' E[l_{\theta\theta,t}\left(\theta_{0}\right)] \left(\theta - \theta_{0}\right) \\ &= S_{1} + S_{2} + S_{3} + S_{4}, \end{split}$$

where  $\theta_{\bullet}$  lies on the line segment between  $\theta$  and  $\theta_0$ , and the latter equality defines the terms  $S_i$ ,  $i=1,\ldots,4$ . It can be shown that, for any sufficiently small fixed  $\epsilon$ ,  $\sup_{\theta\in\Theta_{\epsilon}}(S_1+S_2)\to 0$  a.s. as  $T\to\infty$  (for  $S_1$  this follows from the fact that  $L_{\theta,T}(\theta_0)\to 0$  a.s. as  $T\to\infty$ ; for  $S_2$  the result is obtained making use of Lemma 2). The terms  $S_3$  and  $S_4$  do not depend on T, and it can be shown that there exists a positive  $\delta$  such that for each sufficiently small  $\epsilon$ ,  $\sup_{\theta\in\Theta_{\epsilon}}(S_3+S_4)<-\delta\epsilon^2$  (for  $S_3$  the needed arguments are obtained from Lemma 2 and the continuity of  $E[l_{\theta\theta,t}(\theta)]$  mentioned therein; for  $S_4$  one can invoke the fact that  $E[l_{\theta\theta,t}(\theta)]$  is negative definite due to Lemmas 1 and 2). Therefore, for each sufficiently small  $\epsilon$ ,

$$\sup_{\theta \in \Omega} L_T(\theta) < L_T(\theta_0) \text{ a.s. as } T \to \infty.$$
 (16)

As a consequence, for each fixed sufficiently small  $\epsilon$ , and for all T sufficiently large,  $L_T(\theta)$  must have a local maximum, and hence a root of the likelihood equation  $L_{\theta,T}(\theta)=0$ , in the interior of  $\Theta_\epsilon$  with probability one. Having established this, the existence of a sequence  $\hat{\theta}_T$ , independent of  $\epsilon$ , such that the  $\hat{\theta}_T$  are solutions of the likelihood equations  $L_{\theta,T}(\theta)=0$  for all sufficiently large T and that  $\hat{\theta}_T\to\theta_0$  a.s. as  $T\to\infty$  can be shown as in Serfling (1980, pp. 147–148).

**Asymptotic Normality**. By a standard mean value expansion of the score vector  $L_{\theta,T}(\theta)$ ,

$$T^{1/2}L_{\theta,T}(\hat{\theta}_T) = T^{1/2}L_{\theta,T}(\theta_0) + \dot{L}_{\theta\theta,T}T^{1/2}(\hat{\theta}_T - \theta_0) \text{ a.s.,}$$
 (17)

where  $\dot{L}_{\theta\theta,T}$  signifies the matrix  $L_{\theta\theta,T}$  ( $\theta$ ) with each row evaluated at an intermediate point  $\dot{\theta}_{i,T}$  ( $i=1,\ldots,\dim\theta$ ) lying between  $\hat{\theta}_T$  and  $\theta_0$ . As shown above,  $\hat{\theta}_T \to \theta_0$  a.s., so that  $\dot{\theta}_{i,T} \to \theta_0$  a.s. as  $T \to \infty$  ( $i=1,\ldots,\dim\theta$ ) which, together with the uniform convergence result for  $L_{\theta\theta,T}$  ( $\theta$ ) in Lemma 2, yields  $\dot{L}_{\theta\theta,T} \to E[l_{\theta\theta,t}$  ( $\theta_0$ )] a.s. as  $T \to \infty$ . This and the invertibility of  $E[l_{\theta\theta,t}$  ( $\theta_0$ )] obtained from Assumption 4(v) and the result  $E[l_{\theta\theta,t}$  ( $\theta_0$ )] =  $-\mathcal{L}(\theta_0)$  established in Lemma 2 imply that, for all T sufficiently large,  $\dot{L}_{\theta\theta,T}$  is also invertible (a.s.) and  $\dot{L}_{\theta,T}^{-1} \to E[l_{\theta\theta,t}$  ( $\theta_0$ )] $^{-1}$  a.s. as  $T \to \infty$ . Multiplying the mean value expansion (17) with the Moore–Penrose inverse  $\dot{L}_{\theta\theta,T}^+$  of  $\dot{L}_{\theta\theta,T}$  (this inverse exists for all T) and rearranging we obtain

$$T^{1/2}(\hat{\theta}_T - \theta_0) = (I_{\dim \theta} - \dot{L}_{\theta\theta, T}^+ \dot{L}_{\theta\theta, T}) T^{1/2}(\hat{\theta}_T - \theta_0) + \dot{L}_{\theta\theta, T}^+ T^{1/2} L_{\theta, T}(\hat{\theta}_T) - \dot{L}_{\theta\theta, T}^+ T^{1/2} L_{\theta, T}(\theta_0).$$
(18)

The first two terms on the right hand side of (18) converge to zero a.s. (for the first term, this follows from the fact that for

all T sufficiently large  $\dot{L}_{\theta\theta,T}$  is invertible; for the second one, this holds because  $\hat{\theta}_T$  being a maximizer of  $L_T(\theta)$  and  $\theta_0$  being an interior point of  $\Theta_0$  yield  $L_{\theta,T}(\hat{\theta}_T)=0$  for all T sufficiently large). Furthermore, the eventual a.s. invertibility of  $\dot{L}_{\theta\theta,T}$  also means that  $\dot{L}_{\theta\theta,T}^+ - E[l_{\theta\theta,t}(\theta_0)]^{-1} \to 0$  a.s. Hence, (18) becomes

$$T^{1/2}(\hat{\theta}_T - \theta_0) = o_1(1) - (E[l_{\theta\theta,t}(\theta_0)]^{-1} + o_2(1))T^{1/2}L_{\theta,T}(\theta_0),$$

where  $o_1(1)$  and  $o_2(1)$  (a vector- and a matrix-valued process, respectively) converge to zero a.s. Combining this with the result of Lemma 1 and the property  $E[l_{\theta\theta,t}(\theta_0)] = -\mathfrak{1}(\theta_0)$  (see Lemma 2) completes the proof.

**Proof of Theorem 2.** We begin with the block-diagonality of  $\mathfrak{L}(\theta_0)$ . Due to the expressions of the off-diagonal blocks of  $\mathfrak{L}(\theta_0) = Cov[l_{\theta,t}(\theta_0)]$  in Appendix B, it suffices to show that the moments  $E[\varepsilon_t' \otimes e_{x,t}e_{x,t}']$ ,  $E[e_{x,t}(\varepsilon_t \odot e_{x,t})']$ , and  $E[e_{x,t}e_{\lambda,t}']$  all equal zero. To this end, note that the elements of the matrices  $E[\varepsilon_t' \otimes e_{x,t}e_{x,t}']$  and  $E[e_{x,t}(\varepsilon_t \odot e_{x,t})']$  are obtained from

$$E\left[\varepsilon_{i,t}e_{j,x,t}e_{k,x,t}\right] = \begin{cases} E\left[\varepsilon_{i,t}e_{i,x,t}^{2}\right], & i = j = k\\ 0, & \text{otherwise} \end{cases}$$
 and 
$$E\left[e_{i,x,t}\varepsilon_{j,t}e_{j,x,t}\right] = \begin{cases} E\left[\varepsilon_{i,t}e_{i,x,t}^{2}\right], & i = j\\ 0, & \text{otherwise} \end{cases}$$

respectively. The assumed symmetry and Lemma A.3 of Meitz and Saikkonen (2013) ensure that  $E[\varepsilon_{i,t}e_{i,x,t}^2] = 0$ ,  $i = 1, \ldots, n$ . Regarding the moment  $E[e_{x,t}e_{\lambda,t}']$ , it suffices to show that  $E[e_{i,x,t}e_{i,\lambda_i,t}] = 0$  for  $i = 1, \ldots, n$ . As

$$E\left[e_{i,x,t}e_{i,\lambda_{i},t}\right] = E\left[\frac{f_{i,x}(\sigma_{i,0}^{-1}\varepsilon_{i,t};\lambda_{i,0})}{f_{i}(\sigma_{i,0}^{-1}\varepsilon_{i,t};\lambda_{i,0})}\frac{f_{i,\lambda_{i}}(\sigma_{i,0}^{-1}\varepsilon_{i,t};\lambda_{i,0})}{f_{i}(\sigma_{i,0}^{-1}\varepsilon_{i,t};\lambda_{i,0})}\right],$$

the desired result again follows from Lemma A.3 of Meitz and Saikkonen (2013) because if the distribution of  $\varepsilon_{i,t}$  is symmetric in the sense that  $f_i(x; \lambda_i) = f_i(-x; \lambda_i)$  for all  $\lambda_i \in \Theta_{0,\lambda_i}$ , the functions  $f_i(\sigma_{i,0}^{-1}\cdot; \lambda_{i,0})$  and  $f_{i,\lambda_i}(\sigma_{i,0}^{-1}\cdot; \lambda_{i,0})$  are symmetric functions (for the latter, this follows from  $f_{i,\lambda_i}(\sigma_{i,0}^{-1}\cdot; \lambda_{i,0}) = \frac{\partial}{\partial \lambda_i} f_i(\sigma_{i,0}^{-1}\cdot; \lambda_{i,0})$  and the symmetry of  $f_i(\sigma_{i,0}^{-1}\cdot; \lambda_i)$  for  $\lambda_i \in \Theta_{0,\lambda_i}$ ) and the function  $f_{i,x}(\sigma_{i,0}^{-1}\cdot; \lambda_{i,0})$  is an odd function.

<span id="page-15-0"></span>Now consider the three-step estimator. As for the properties of the LS estimator  $\tilde{\pi}_{LS,T}$ , standard arguments can be used to show that under Assumptions 2–5,  $\tilde{\pi}_{LS,T}$  is strongly consistent and satisfies  $T^{1/2}(\tilde{\pi}_{LS,T}-\pi_0)=O_p(1)$  (we omit the details for brevity). Concerning  $\tilde{\gamma}_T$  and  $\tilde{\pi}_T$ , arguments similar to those in the proof of Theorem 1 can be used to show that there exists a sequence of solutions  $\tilde{\gamma}_T$  (resp.  $\tilde{\pi}_T$ ) to the (likelihood-like) equations  $\tilde{L}_{\gamma,T}(\gamma)=0$  (resp.  $\tilde{L}_{\pi,T}(\pi)=0$ ) that are strongly consistent for  $\gamma_0$  (resp.  $\pi_0$ ); details are available in the Supplementary Appendix.

For the asymptotic distribution of  $(\tilde{\pi}_T, \tilde{\gamma}_T)$ , mean value expansions of the functions  $L_{\pi,T}(\cdot, \tilde{\gamma}_T)$ ,  $L_{\pi,T}(\pi_0, \cdot)$ ,  $L_{\gamma,T}(\tilde{\pi}_{LS,T}, \cdot)$ , and  $L_{\gamma,T}(\cdot, \gamma_0)$  yield

$$\begin{split} T^{1/2}L_{\pi,T}(\tilde{\pi}_{T},\tilde{\gamma}_{T}) &= T^{1/2}L_{\pi,T}(\pi_{0},\tilde{\gamma}_{T}) + \dot{L}_{\pi\pi,T}T^{1/2}(\tilde{\pi}_{T} - \pi_{0}) \quad \text{a.s.,} \\ T^{1/2}L_{\pi,T}(\pi_{0},\tilde{\gamma}_{T}) &= T^{1/2}L_{\pi,T}(\pi_{0},\gamma_{0}) + \dot{L}_{\pi\gamma,T}T^{1/2}(\tilde{\gamma}_{T} - \gamma_{0}) \quad \text{a.s.,} \\ T^{1/2}L_{\gamma,T}(\tilde{\pi}_{LS,T},\tilde{\gamma}_{T}) &= T^{1/2}L_{\gamma,T}(\tilde{\pi}_{LS,T},\gamma_{0}) + \dot{L}_{\gamma\gamma,T}T^{1/2}(\tilde{\gamma}_{T} - \gamma_{0}) \quad \text{a.s.,} \\ T^{1/2}L_{\gamma,T}(\tilde{\pi}_{LS,T},\gamma_{0}) &= T^{1/2}L_{\gamma,T}(\pi_{0},\gamma_{0}) + \dot{L}_{\gamma\pi,T}T^{1/2}(\tilde{\pi}_{LS,T} - \pi_{0}) \quad \text{a.s.,} \\ \end{split}$$

<span id="page-15-1"></span>where  $\dot{L}_{\pi\pi,T}$  signifies the matrix  $L_{\pi\pi,T}$   $(\cdot,\tilde{\gamma}_T)$  with each row evaluated at an intermediate point  $\dot{\pi}_{i,T}$ ,  $i=1,\ldots,\dim\pi$ , lying between  $\tilde{\pi}_T$  and  $\pi_0$ , and  $\dot{L}_{\pi\gamma,T}$ ,  $\dot{L}_{\gamma\gamma,T}$ , and  $\dot{L}_{\gamma\pi,T}$  are defined in an analogous manner. Arguments similar to those used in the proof of Theorem 1 now yield

$$T^{1/2} \begin{bmatrix} \tilde{\pi}_{T} - \pi_{0} \\ \tilde{\gamma}_{T} - \gamma_{0} \end{bmatrix} = - \begin{bmatrix} \dot{L}_{\pi\pi,T}^{+} & 0 \\ 0 & \dot{L}_{\gamma\gamma,T}^{+} \end{bmatrix} \begin{bmatrix} T^{1/2} L_{\pi,T}(\pi_{0}, \gamma_{0}) \\ T^{1/2} L_{\gamma,T}(\pi_{0}, \gamma_{0}) \end{bmatrix}$$
$$- \begin{bmatrix} \dot{L}_{\pi\pi,T}^{+} \dot{L}_{\pi\gamma,T} T^{1/2}(\tilde{\gamma}_{T} - \gamma_{0}) \\ \dot{L}_{\gamma\gamma,T}^{+} \dot{L}_{\gamma\pi,T} T^{1/2}(\tilde{\pi}_{LS,T} - \pi_{0}) \end{bmatrix} + o(1), \quad (19)$$

where  $\dot{L}_{\pi\pi,T}^+$  and  $\dot{L}_{\gamma\gamma,T}^+$  denote the Moore–Penrose inverses of  $\dot{L}_{\pi\pi,T}$  and  $\dot{L}_{\gamma\gamma,T}$  and o(1) (dim  $\theta \times 1$ ) converges to zero a.s. By the strong consistency of  $\tilde{\pi}_{LS,T}$ ,  $\tilde{\gamma}_T$ , and  $\tilde{\pi}_T$ , Lemmas 1 and 2, and the block diagonality of  $L(\theta_0)$ , the first term on the right hand side of (19) converges in distribution to  $N(0, diag(L_{\pi\pi}(\theta_0)^{-1}, L_{\gamma\gamma}(\theta_0)^{-1}))$  (where  $diag(\cdot, \cdot)$  denotes a block diagonal matrix with the arguments indicating the diagonal blocks). By the strong consistency of  $\tilde{\pi}_{LS,T}$  and  $\tilde{\gamma}_T$ , Lemma 2, finiteness and invertibility of  $E[l_{\theta\theta,t}(\theta_0)]$ , the block diagonality of  $L(\theta_0)$ , and the fact  $L^{1/2}(\tilde{\chi}_{LS,T} - \pi_0) = O_p(1)$  noted earlier, the bottom component of the second term on the right hand side of (19) is  $o_p(1)$ . Consequently,  $L^{1/2}(\tilde{\gamma}_T - L_{\eta}) = O_p(1)$ , and similar arguments show that also the top component of the second term on the right hand side of (19) is  $o_p(1)$ . This completes the proof.

# Appendix E. Supplementary data

Supplementary material related to this article can be found online at http://dx.doi.org/10.1016/j.jeconom.2016.06.002.

## References

- <span id="page-16-23"></span>Anderson, B.D.O, Deistler, M., Felsenstein, E., Funovits, B., Koelbl, L., Zamani, M., 2016. Multivariate AR systems and mixed frequency data: g-identifiability and estimation. Econometric Theory 32, 793–826.
- <span id="page-16-27"></span>Andrews, B., Davis, R. A., Breidt, F. J., 2006. Maximum likelihood estimation for all-pass time series models. J. Multivariate Anal. 97, 1638–1659.
- <span id="page-16-47"></span>Billingsley, P., 1961. The Lindeberg-Levy theorem for martingales. Proc. Amer. Math. Soc. 12, 788–792.
- <span id="page-16-35"></span>Bjørnland, H. C., Leitemo, K., 2009. Identifying the interdependence between US monetary policy and the stock market. J. Monet. Econ. 56, 275–282.
- <span id="page-16-30"></span>Blanchard, O. J., Quah, D., 1989. The dynamic effects of aggregate demand and supply disturbances. Amer. Econ. Rev. 79, 655–673.
- <span id="page-16-46"></span><span id="page-16-26"></span>Bochnak, J., Coste, M., Roy, M.-F., 1998. Real Algebraic Geometry. Springer, Berlin. Breidt, F. J., Davis, R. A., Lii, K.-S., Rosenblatt, M., 1991. Maximum likelihood estimation for noncausal autoregressive processes. J. Multivariate Anal. 36, 175–198.
- <span id="page-16-43"></span>Brock, W. A., Dechert, W. D., Scheinkman, J. A., LeBaron, B., 1996. A test for independence based on the correlation dimension. Econometric Rev. 15, 197–235.
- <span id="page-16-8"></span>Castelnuovo, E., 2013. Monetary policy shocks and financial conditions: A Monte Carlo experiment. J. Int. Money Financ. 32, 282–303.
- <span id="page-16-31"></span>Castelnuovo, E., Nisticò, S., 2010. Stock market conditions and monetary policy in a DSGE model for the U.S. J. Econom. Dynam. Control 34, 1700–1731.
- <span id="page-16-15"></span>Chan, K.-S., Ho, L. H., 2004. On the unique representation of non-Gaussian multivariate linear processes, Technical Report #341. University of Iowa, http://www.stat.uiowa.edu/files/stat/techrep/tr341.pdf.
- <span id="page-16-16"></span>Chan, K.-S., Ho, L. H., Tong, H., 2006. A note on time-reversibility of multivariate linear processes. Biometrika 93, 221–227.
- <span id="page-16-22"></span>Chen, A., Bickel, P., 2005. Consistent independent component analysis and prewhitening. IEEE Trans. Signal Process. 53, 3625–3632.
- <span id="page-16-39"></span>Cheng, L., Jin, Y., 2013. Asset prices, monetary policy, and aggregate fluctuations: An empirical investigation. Econom. Lett. 119, 24–27.
- <span id="page-16-40"></span>Chib, S., Ramamurthy, S., 2014. DSGE models with Student-t errors. Econometric Rev. 33, 152–177.
- <span id="page-16-44"></span>Christiano, L. J., Eichenbaum, M., Evans, C. L., 1999. Monetary policy shocks: What have we learned and to what end? In: Taylor, J. B., M., Woodford (Eds.), Handbook of Macroeconomics, vol. 1A. Elsevier, New York, pp. 65–148.
- <span id="page-16-14"></span>Comon, P., 1994. Independent component analysis, A new concept? Signal Process. 36, 287–314.

- <span id="page-16-41"></span>Cúrdia, V., Del Negro, M., Greenwald, D. L., 2014. Rare shocks, great recessions. J. Appl. Econometrics 29, 1031–1052.
- <span id="page-16-0"></span>Fry, R., Pagan, A., 2011. Sign restrictions in structural vector autoregressions: A critical review. J. Econ. Literat. 49, 938–960.
- <span id="page-16-50"></span><span id="page-16-13"></span>Gouriéroux, C., Monfort, A., 2014, Revisiting identification and estimation in structural VARMA models, CREST Discussion Paper 2014-30.
- <span id="page-16-17"></span>Gouriéroux, C., Zakoïan, J.-M., 2015. On uniqueness of moving average representations of heavy-tailed stationary processes. J. Time Series Anal. 36, 876–887.
- <span id="page-16-42"></span>Hakkio, C. S., Keeton, W. R., 2009. Financial stress: What it is, how can it be measured, and why does it matter? Federal Reserve Bank of Kansas City Economic Review, Second Quarter, 5–50.
- <span id="page-16-20"></span>Hallin, M., Mehta, C., 2015. R-estimation for asymmetric independent component analysis. J. Amer. Statist. Assoc. 110, 218–232.
- <span id="page-16-12"></span>Hannan, E. J., Deistler, M., 1988. The Statistical Theory of Linear Systems. Wiley, New York
- <span id="page-16-1"></span>New York. Hyvärinen, A., Zhang, K., Shimizu, S., Hoyer, P. O., 2010. Estimation of a structural vector autoregression model using non-Gaussianity. J. Mach. Learn. Res. 11, 1709–1731
- <span id="page-16-19"></span>Ilmonen, P., Paindaveine, D., 2011. Semiparametrically efficient inference based on signed ranks in symmetric independent component models. Ann. Statist. 39, 2448–2476
- <span id="page-16-24"></span>Johansen, S., 1995. Identifying restrictions of linear equations with applications to simultaneous equations and cointegration. J. Econometrics 69, 111–132.
- <span id="page-16-45"></span>Kagan, A. M., Linnik, Y. V., Rao, C. R., 1973. Characterization Problems in Mathematical Statistics. Wiley, New York.
- <span id="page-16-9"></span>Kilian, L., 2013. : Structural vector autoregressions. In: Hashimzade, N., Thornton, M. A. (Eds.), Handbook of Research Methods and Applications in Empirical Macroeconomics. Edward Elgar, Cheltenham, U.K., pp. 515–554.
- <span id="page-16-11"></span>Kohn, R., 1979. Identification results for ARMAX structures. Econometrica 47, 1295–1304.
- <span id="page-16-25"></span>Lanne, M., Lütkepohl, H., 2008. Identifying monetary policy shocks via changes in volatility. J. Money, Credit, Bank. 40, 1131–1149.
- <span id="page-16-3"></span>Lanne, M., Lütkepohl, H., 2010. Structural vector autoregressions with nonnormal residuals. J. Bus. Econom. Statist. 28, 159–168.
- <span id="page-16-5"></span>Lanne, M., Lütkepohl, H., Maciejowska, K., 2010. Structural vector autoregressions with Markov switching. J. Econom. Dynam. Control 34, 121–131.
- <span id="page-16-28"></span>Lanne, M., Saikkonen, P., 2011. Noncausal autoregressions for economic time series. J. Time Ser. Econom. 3 (3). Article 2.
- <span id="page-16-32"></span>Lastrapes, W. D., 1998. International evidence on equity prices, interest rates and money. J. Int. Money Financ. 17, 377–406.
- <span id="page-16-34"></span>Li, Y. D., Iscan, T. B., Xu, K., 2010. The impact of monetary shocks on stock prices: Evidence from Canada and the United States. J. Int. Money Financ. 29, 876–896.
- <span id="page-16-18"></span>Lütkepohl, H., Netšunajev, A., 2014a. Disentangling demand and supply shocks in the crude oil market: How to check sign restrictions in structural VARs. J. Appl. Econometrics 29, 479–496.
- <span id="page-16-6"></span>Lütkepohl, H., Netšunajev, A., 2014b, Structural vector autoregressions with smooth transition in variances: The interaction between U.S. monetary policy and the stock market, DIW Discussion Paper 1388.
- <span id="page-16-29"></span>Meitz, M., Saikkonen, P., 2013. Maximum likelihood estimation of a noninvertible ARMA model with autoregressive conditional heteroskedasticity. J. Multivariate Anal. 114, 227–255.
- <span id="page-16-2"></span>Moneta, A., Entner, D., Hoyer, P. O., Coad, A., 2013. Causal inference by independent component analysis: theory and applications. Oxf. Bull. Econ. Stat. 75, 705–730.
- <span id="page-16-4"></span>Normandin, M., Phaneuf, L., 2004. Monetary policy shocks: Testing identification conditions under time-varying conditional volatility. J. Monet. Econ. 51, 1217–1243.
- <span id="page-16-37"></span>Patelis, A. D., 1997. Stock return predictability and the role of monetary policy. J. Financ. 52, 1951–1972.
- <span id="page-16-21"></span>Pham, D. T., Garat, P., 1997. Blind separation of mixture of independent sources through a quasi-maximum likelihood approach. IEEE Trans. Signal Process. 45, 1712–1725
- <span id="page-16-48"></span>Ranga Rao, R., 1962. Relations between weak and uniform convergence of measures with applications. Ann. Math. Stat. 33, 659–680.
- <span id="page-16-33"></span>Rapach, D. E., 2001. Macro shocks and real stock prices. J. Econ. Bus. 53, 5–26.
- <span id="page-16-7"></span>Rigobon, R., 2003. Identification through heteroskedasticity. Rev. Econ. Stat. 85, 777–792.
- <span id="page-16-36"></span>Rigobon, R., Sack, B., 2004. The impact of monetary policy on asset prices. J. Monet. Econ. 51, 1553–1575.
- <span id="page-16-49"></span>Serfling, R. J., 1980. Approximation Theorems of Mathematical Statistics. Wiley, New York.
- <span id="page-16-10"></span>Sims, C. A., 1980. Macroeconomics and reality. Econometrica 48, 1–48.
- <span id="page-16-38"></span>Thorbecke, W., 1997. On stock market returns and monetary policy. J. Financ. 52, 635–654