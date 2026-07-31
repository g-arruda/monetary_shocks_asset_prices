# BIASES OF ESTIMATORS IN MULTIVARIATE NON-GAUSSIAN AUTOREGRESSIONS

### By Alun Lloyd Pope

University of Newcastle, Australia First version received January 1989

Abstract. Expressions for the bias of the least-squares and modified Yule-Walker estimators in a correctly specified multivariate autoregression of arbitrary order are obtained without assuming that the innovations are Gaussian. Instead, the innovations are assumed to form a martingale difference sequence which is stationary up to sixth order and which has finite sixth moments. The errors in the expressions are shown to be  $O(n^{-3/2})$ , as the sample size  $n \to \infty$ , under some moment conditions. The expressions obtained are the same in the Gaussian and non-Gaussian cases.

Keywords. Autoregressive models; bias; least-squares estimation; modified Yule-Walker estimation.

## 1. INTRODUCTION

Consider the problem of fitting an autoregressive model to a small number of observations from a time series when the distributional form of the innovations is unknown. Under these circumstances the maximum likelihood estimator is unavailable and we might well proceed with either the least-squares or the Yule-Walker estimator. It is well known that both these estimators have a bias which can be appreciable in small samples. Thus it is desirable to have estimates of the biases of these estimators available when the distribution of the observations is not Gaussian (even unknown) and the sample size is not large. For a correctly specified m-dimensional autoregression of any order, it is shown below that under quite mild conditions these biases are  $O(n^{-1})$  as the sample size  $n \to \infty$ . Approximations to the biases are given with an error which is  $O(n^{-3/2})$ .

Tjøstheim and Paulsen (1983) obtained an expression for the bias of the least-squares estimator under the assumption that the innovations were independent and identically distributed Gaussian variates. The order of the error was not estimated. Independently, the present author (Pope, 1987; Nicholls and Pope, 1988) obtained an equivalent expression under the same assumptions and also estimated the asymptotic order of the error. In addition, Tjøstheim and Paulsen (1983) obtained an expression for the bias of what they call the modified Yule–Walker estimator, also under Gaussian assumptions.

In this paper these results are extended by relaxing considerably the restriction to Gaussian innovations. For both estimators the expression

0143-9782/90/03 249-10 \$02.50/0 JOURNAL OF TIME SERIES ANALYSIS Vol. 11, No. 3 © 1990 A. L. Pope

obtained for the bias is the same for non-Gaussian innovations as for Gaussian innovations.

This paper is structured as follows. Section 2 is devoted to a Taylor series expansion under general conditions. In Section 3 the expansion is employed to derive an expression for the bias of the least-squares estimator in a general autoregression. In the remaining section, the bias of the least-squares estimator is compared with those of the modified Yule-Walker estimator and the Box-Jenkins version of the least-squares estimator.

The author is grateful to a referee for helpful comments regarding Theorem 1.

#### 2. A TAYLOR SERIES EXPANSION

The Taylor series expansion described in this section forms the basis for the calculation that follows. It will be applied in the first place to the case of the least-squares estimator, and will be used in Section 4 to estimate the bias of the Yule-Walker estimator. We are interested in the bias of an estimator of the form  $PQ^{-1}$ , where P and Q are random matrices, and, as is well known, it is possible to obtain estimates of such quantities by Taylor series expansions. However, no example of such a Taylor expansion giving precise error bounds under circumstances relevant to this problem seems to be available in the literature, and so we give the theorem here. The motivation for the hypotheses used can be seen by comparing them with (13) and Lemma 1.

By the norm ||M|| of the real square matrix M, we mean the operator norm (equal to the square root of the largest eigenvalue of  $M^{T}M$ ).

THEOREM 1. Let  $\hat{\Delta}_n$ ,  $\delta_n$  and  $\rho_n$  be random  $m \times m$  matrices such that

$$\hat{\Delta}_n = (\Delta_n + \delta_n)(I - \rho_n)^{-1}$$

where  $\Delta_n$  is a deterministic sequence of  $m \times m$  matrices, bounded in norm, and I is the  $m \times m$  identity. Let the sequence  $\sigma_n$  of  $m \times m$  matrices be such that, as  $n \to \infty$ ,

- (i)  $E\delta_n = -\sigma_n + O(n^{-2}),$
- (ii)  $E\rho_n = \sigma_n + O(n^{-2}),$
- (iii)  $E[|\delta_n^3|]$  and  $E[|\rho_n^3|]$  are both  $O(n^{-3/2})$  and
- (iv) for some  $\varepsilon > 0$ ,  $E[|\hat{\Delta}_n \Delta_n||^{1+\varepsilon} = O(1)$ .

Then, as  $n \to \infty$ ,

$$E\hat{\Delta}_n = \Delta_n - (I - \Delta_n)\sigma_n + E\delta_n\rho_n + \Delta_nE\rho_n^2 + O(n^{-3/2}). \tag{1}$$

PROOF. Fix c (0 < c < 1) and let S(n) denote the event  $\{||\rho_n|| < c\}$  and  $\widetilde{S(n)}$  its complement. Define

$$R_n = \begin{cases} \delta_n \rho_n^2 + (\Delta_n + \delta_n) \sum_{k=3}^{\infty} \rho_n^k & \text{if } S(n) \\ \hat{\Delta}_n - \Delta_n & \text{otherwise} \end{cases}$$

$$P_n = \delta_n + \Delta_n \rho_n + \delta_n \rho_n + \Delta_n \rho_n^2$$

$$\hat{\Delta}_n = \Delta_n + \mathcal{J}_{S(n)} P_n + R.$$

$$E\hat{\Delta}_n = \Delta_n + E(\mathcal{J}_{S(n)}P_n) + ER_n, \tag{2}$$

$$E(\mathcal{I}_{S(n)}P_n) = EP_n - E(\mathcal{I}_{\widetilde{S(n)}}P_n),$$

$$ER_n = E(R_n \mathcal{J}_{S(n)}) + E(R_n \mathcal{J}_{\widetilde{S(n)}}). \tag{3}$$

$$\leq E||\delta_{n}\rho_{n}^{2}|| + E\left\{||(\Delta_{n} + \delta_{n})\rho_{n}^{3} \sum_{k=0}^{\infty} \rho_{n}^{k}||\mathcal{I}_{S(n)}\right\}$$

$$\leq E||\delta_{n}\rho_{n}^{2}|| + (||\Delta_{n}||E||\rho_{n}^{3}|| + E||\delta_{n}\rho_{n}^{3}||) \frac{1}{1 - c}.$$
(4)

The right-hand side of **(4)** is inequality. by assumption (iii) and Holder's

inequality, For the other part of (3) we have, by assumption (iv) and Holder's

$$||E(R_n\mathcal{I}_{\widehat{S(n)}})|| \leq (E||\Delta_n - \widehat{\Delta}_n||^{1+\varepsilon})^{1/(1+\varepsilon)}(E|\mathcal{I}_{\widehat{S(n)}}|^{(1+\varepsilon)/\varepsilon})^{\varepsilon/(1+\varepsilon)}.$$

By the Chebyshev-Markov inequality, it follows from assumption (iii) that *E12s&* is *O(n-3/2).* Hence, *El* I *R,I* I = *O(n-3/2).* A similar argument using the Chebyshev-Markov and Holder inequalities shows that I I *E(?smP,)I* I is also *O(r~-~p),* and the theorem now follows. **m** 

# **3. THE BIAS OF THE LEAST-SQUARES ESTIMATOR IN AUTOREGRESSIONS**

In this section the multivariate autoregressive (AR) model and the leastsquares estimator are described, and an expression for the bias of the estimator is obtained. The multivariate **ARb)** offers no greater generality

than the multivariate AR(1), since an AR(p) of dimension d can be reformulated as an AR(1) of dimension dp. Thus we consider only the m-dimensional AR(1):

$$X_t = AX_{t-1} + Z_t \tag{5}$$

where  $X_t$  and  $Z_t$  are  $m \times 1$  and A is  $m \times m$ . We make the further generalization that the innovations  $Z_t$  constitute a martingale difference sequence (Hall and Heyde, 1980, p.182) with constant variance matrix G. In order to guarantee that (5) has a stationary representation of the form

$$X_t = \sum_{k=0}^{\infty} A^k Z_{t-k},$$

||A|| < 1 is assumed.

We always consider what is often called the mean-corrected version of the least-squares estimator. Thus there is no loss of generality in considering only models which have mean zero, because the estimators described below are invariant under translation of the sample by a constant. The discussion in the rest of the section also applies after obvious changes to the rather unrealistic case in which the mean is known a priori.

Let  $\bar{X}_n$  denote the sample mean and set  $U_t = X_t - \bar{X}_n$ . The least-squares estimator of A in (5) is

$$\hat{A}_n = C_n(-1)C_n(0)^{-1} \tag{6}$$

where, for s = 0 or s = -1,

$$C_n(s) = \frac{1}{n-1} \sum_{i=1}^{n-1} U_{i-s} U_i^{\mathrm{T}}.$$
 (7)

The estimator referred to by Tjøstheim and Paulsen (1983) as the least-squares estimator has a different mean correction. It is easily verified that in expectation this makes a difference which is only  $O(n^{-2})$  under the hypotheses of Theorem 2. The estimator given the same name by Box and Jenkins (1976, p.277) is different again: the range of the summation in the  $C_n(0)$  term in the estimator is from 2 to n-1. The bias of this estimator is discussed briefly in Section 4.

The covariance matrix at lag j is defined for any integer j by

$$\Gamma(j) = EX_t X_{t+j}^{\mathrm{T}}.$$
 (8)

THEOREM 2. Let  $\hat{A}_n$  be the least-squares estimator (6) of A in the m-dimensional AR(1) of (5), based on a sample of size n. Suppose that, for some  $\varepsilon > 0$ ,  $E||C_n(0)^{-1}||^{1+\varepsilon}$  is bounded as  $n \to \infty$  and that the innovations  $Z_t$  in (5) are a martingale difference sequence such that all moments of  $Z_t$ , up to and including the sixth, conditional on the past are finite and have values independent of t. Let G denote the conditional variance of  $Z_t$ , and suppose that ||A|| < 1. Then, as  $n \to \infty$ , the bias  $B_n = E\hat{A}_n - A$  is of the form

$$B_n = -\frac{b}{n} + \mathcal{O}(n^{-3/2})$$

where b is given by

$$b = G[(I - A^{\mathsf{T}})^{-1} + A^{\mathsf{T}}\{I - (A^{\mathsf{T}})^2\}^{-1} + \sum \lambda (I - \lambda A^{\mathsf{T}})^{-1}]\Gamma(0)^{-1}.$$
 (9)

The sum is over the eigenvalues  $\lambda$  of A, weighted by their multiplicities.

The condition that  $E[|C_n(0)^{-1}|]^{1+\varepsilon}$  be bounded as  $n \to \infty$  seems to be the weakest of its type that will work here. It is related (see Lemma 1) to the integrability of the least-squares estimator. For the case of Gaussian innovations, Fuller and Hasza (1981) have established that the estimator is integrable for sufficiently large n. However, other integrability results do not appear to be available at the moment, and indeed it is difficult to see what would constitute natural alternative conditions which could be put on the distribution of the innovations to guarantee integrability and the stronger property of boundedness of the sequence of integrals,  $E||C_n(0)^{-1}||^{1+\varepsilon}$ . The rest of this section is a proof of Theorem 2. We note that if we set  $A(k) = A^k$  if  $k \ge 0$  and zero otherwise, then

$$\Gamma(j) = \sum_{k=-\infty}^{\infty} A(k)GA(k+j)^{\mathrm{T}}.$$
 (10)

Since  $C_n(-1)$  and  $C_n(0)$  are natural estimators of  $\Gamma(-1)$  and  $\Gamma(0)$ , we introduce

$$p_n = \{C_n(-1) - \Gamma(-1)\}\Gamma(0)^{-1}$$
(11)

and

$$q_n = -\{C_n(0) - \Gamma(0)\}\Gamma(0)^{-1}. \tag{12}$$

It is easily checked that

$$\hat{A}_n = (A + p_n)(I - q_n)^{-1}. \tag{13}$$

Let  $V_n = \operatorname{cov} \bar{X}_n$  and  $v_n = V_n \Gamma(0)^{-1}$ . This notation is connected in the following lemma.

LEMMA 1. Let  $w_n$  denote  $p_n$  or  $-q_n$ . Then, as  $n \to \infty$ ,

- (i)  $v_n = n^{-1}G(I A^T)^{-1}\Gamma(0)^{-1} + O(n^{-2}),$
- (ii)  $Ew_n = -v_n + O(n^{-2}),$ (iii)  $E||w_n||^3 = O(n^{-3/2})$  and
- (iv) if  $E||C_n(0)^{-1}||^{1+\varepsilon} = O(1)$ , then  $E||\hat{A}_n A||^{1+\varepsilon} = O(1)$ .

PROOF. The proofs of the first two parts are given by Nicholls and Pope (1988). For the third we use Lemma 3.2 of Bhansali (1981) to observe that the third-order cumulants of  $C_n(-1)$  and  $C_n(0)$  are  $O(n^{-2})$  as  $n \to \infty$ . (This

relies on the fact that the sixth moments of the  $Z_t$  are finite.) Then, using the first two parts of the present lemma, we see that these third-order cumulants are just the third-order cumulants of  $p_n\Gamma(0)$  and  $q_n\Gamma(0)$  respectively to  $O(n^{-3})$ . On writing these cumulants as sums of moments, part (iii) follows, after noting that  $E||w_n||^2 = O(n^{-1})$  by Lemma 3.3 of Bhansali (1981) and using the first two parts again. The last part follows from  $\hat{A}_n - A = A\{(I - q_n)^{-1} - I\} + p_n(I - q_n)^{-1}$ , and  $(I - q_n)^{-1} = \Gamma(0)C_n(0)^{-1}$ .

Thus, we have established all the hypotheses of Theorem 1 with A,  $p_n$ ,  $q_n$  and  $v_n$  in place of  $\Delta_n$ ,  $\delta_n$ ,  $\rho_n$  and  $\sigma_n$  respectively. Applying this theorem to obtain  $E\hat{A}_n$  and hence to calculate the bias  $B_n = E\hat{A}_n - A$ , we obtain

$$B_n = -(I - A)v_n + E\{(p_n + Aq_n)q_n\} + O(n^{-3/2}).$$
 (14)

In the rest of this section, we calculate  $T = E\{(p_n + Aq_n)q_n\}\Gamma(0)$ , which is enough to determine  $B_n$  since we already have  $v_n$  from Lemma 1. This is done by an application of results of Hosoya and Taniguchi (1982). Of course we can ignore terms which are  $O(n^{-3/2})$  in this calculation.

Let  $L_{\gamma\delta}$  be the  $\gamma\delta$  component of  $\Gamma(0)^{-1}$ . Then  $T_{\mu\lambda}$  is given by

$$E\left\{\sum_{\alpha,\beta,\gamma=1}^{m} A_{\mu\alpha} h_{\alpha\beta}(0) L_{\beta\gamma} h_{\gamma\lambda}(0) - \sum_{\beta,\gamma=1}^{m} h_{\mu\beta}(-1) L_{\beta\gamma} h_{\gamma\lambda}(0)\right\}$$

$$= \sum_{\alpha,\beta,\gamma=1}^{m} A_{\mu\alpha} L_{\beta\gamma} \operatorname{cov} \left\{h_{\alpha\beta}(0), h_{\gamma\lambda}(0)\right\}$$

$$- \sum_{\beta,\gamma=1}^{m} L_{\beta\gamma} \operatorname{cov} \left\{h_{\mu\beta}(-1), h_{\gamma\lambda}(0)\right\}$$
(15)

where  $h_{\alpha\beta}(j) = \{C_n(j)\}_{\alpha\beta}$ . Neglecting terms which are  $O(n^{-2})$ , we have, by Theorem 2.2 of Hosoya and Taniguchi (1982),

$$cov \{h_{\alpha\beta}(j), h_{\gamma\lambda}(0)\} = \frac{2\pi}{n} \int_{-\pi}^{\pi} \{\overline{f_{\alpha\gamma}(\omega)}f_{\beta\lambda}(\omega) + \overline{f_{\alpha\lambda}(\omega)}f_{\beta\gamma}(\omega)\} \exp(-ij\omega) d\omega 
+ \frac{2\pi}{n} \int_{-\pi}^{\pi} \int_{-\pi}^{\pi} \sum_{\beta_1\beta_2\beta_3\beta_4}^{m} \exp(-ij\omega_1) 
\times k_{\beta\beta_1}(\omega_1)k_{\alpha\beta_2}(-\omega_1)k_{\lambda\beta_3}(\omega_2)k_{\gamma\beta_4}(-\omega_2) 
\times \left(\frac{1}{2\pi}\right)^3 K(\beta_1, \beta_2, \beta_3, \beta_4) d\omega_1 d\omega_2$$
(16)

where

$$k(\omega) = \{I - A \exp(i\omega)\}^{-1}; \tag{17}$$

f is the spectral density matrix of the process, given by

$$f(\omega) = \frac{1}{2\pi} k(\omega) Gk(\omega)^*; \tag{18}$$

14679892, 1990, 3, Downloaded from https://onlinelibrary.wiley.com/doi/10.1111/j.14679892.1990.tb00056x by Capes, Wiley Online Library on [1803/2026]. See the Terms and Conditions (https://onlinelibrary.wiley.com/ems-and-conditions) on Wiley Online Library frortales of use; OA articles are governed by the applicable Centerive Commons. Licensensense and Conditions (https://onlinelibrary.wiley.com/ems-and-conditions) on Wiley Online Library frortales of use; OA articles are governed by the applicable Centerive Commons. Licensensensensensensensensensensensensense

the asterisk denotes conjugation followed by transposition, and  $K(\beta_1, \beta_2, \beta_3, \beta_4)$  is the fourth cumulant of the joint distribution of  $Z_{\beta_1}(t), \ldots, Z_{\beta_4}(t)$ .

The neglected terms in (16) arise from the mean correction, which is not employed by Hosoya and Taniguchi (1982). We have also used the fact that their (3.2) can be applied here as on p.152 of their paper.

If M is an  $m \times m$  matrix, write tr M for the trace of M and put

$$\langle \langle M \rangle \rangle = M + (\operatorname{tr} M)I. \tag{19}$$

Replacing some summations by matrix multiplications and still neglecting terms which are  $O(n^{-2})$ , we find

$$T_{\mu\lambda} = \frac{2\pi}{n} \int_{-\pi}^{\pi} \left[ \left\{ A - \exp\left(i\omega\right) I \right\} f(\omega)^{\mathsf{T}} \left\langle \left\langle \Gamma(0)^{-1} f(\omega) \right\rangle \right\rangle \right]_{\mu\lambda} d\omega$$

$$+ \frac{2\pi}{n} \int_{-\pi}^{\pi} d\omega_{1} \int_{-\pi}^{\pi} d\omega_{2} \sum_{\beta_{1}\beta_{2}\beta_{3}\beta_{4}}^{m} \sum_{\alpha,\beta,\gamma=1}^{m} \left( \frac{1}{2\pi} \right)^{3} K(\beta_{1}, \beta_{2}, \beta_{3}, \beta_{4})$$

$$\times \left\{ A_{\mu\alpha} L_{\beta\gamma} k_{\beta\beta_{1}}(\omega_{1}) k_{\alpha\beta_{2}}(-\omega_{1}) k_{\lambda\beta_{3}}(\omega_{2}) k_{\gamma\beta_{4}}(-\omega_{2}) \right\}$$

$$- \exp\left(i\omega_{1}\right) L_{\beta\gamma} k_{\beta\beta_{1}}(\omega_{1}) k_{\mu\beta_{2}}(-\omega_{1}) k_{\lambda\beta_{3}}(\omega_{2}) k_{\gamma\beta_{4}}(-\omega_{2}) \right\}. \tag{20}$$

Let  $B = A^{T}$  and  $\delta(x) = 1$  if x = 0 and zero otherwise. The first integration in (20) is then the  $\mu\lambda$  component of

$$\frac{1}{2n\pi} \int_{-\pi}^{\pi} \{A - \exp(i\omega)I\} \{I - A \exp(-i\omega)\}^{-1}G\{I - B \exp(i\omega)\}^{-1} \\
\times \langle \langle \Gamma(0)^{-1} \{I - A \exp(i\omega)\}^{-1}G\{I - B \exp(-i\omega)\}^{-1} \rangle \rangle d\omega \\
= \frac{-G}{2n\pi} \sum_{\alpha,\beta,\gamma\geq 0} \int_{-\pi}^{\pi} \exp(i\omega)B^{\alpha} \exp(i\alpha\omega) \\
\times \langle \langle \Gamma(0)^{-1}A^{\beta} \exp(i\beta\omega)GB^{\gamma} \exp(-i\gamma\omega) \rangle \rangle d\omega \\
= \frac{-G}{n} \sum_{\alpha,\beta,\gamma\geq 0} B^{\alpha} \langle \langle \Gamma(0)^{-1}A^{\beta}GB^{\gamma} \rangle \rangle \frac{1}{2\pi} \int_{-\pi}^{\pi} \\
\times \exp(i\omega + i\alpha\omega + i\beta\omega - i\gamma\omega) d\omega \\
= \frac{-G}{n} \sum_{\alpha,\beta,\gamma\geq 0} B^{\alpha} \langle \langle \Gamma(0)^{-1}A^{\beta}GB^{\gamma} \rangle \rangle \delta(1 + \alpha + \beta - \gamma) \\
= \frac{-G}{n} \sum_{\alpha\geq 0} B^{\alpha} \langle \langle \Gamma(0)^{-1}\sum_{\beta\geq \alpha} A^{\beta}GB^{\beta+\alpha+1} \rangle \rangle \\
= \frac{-G}{n} B^{-1} \sum_{\alpha\geq 0} B^{\alpha} \langle \langle \Gamma(0)^{-1}\Gamma(\alpha) \rangle \rangle \\
= \frac{-G}{n} B^{-1} \sum_{\alpha\geq 0} B^{\alpha} \langle \langle B^{\alpha} \rangle \rangle. \tag{21}$$

Now, for any matrix *M* with I I *MI* I < **1,** 

$$\sum_{\alpha\geq 0} M^{\alpha} \langle \langle M^{\alpha} \rangle \rangle = M^{2} (I - M^{2})^{-1} + \sum_{\alpha} \lambda M (I - \lambda M)^{-1}$$

where the sum is over the eigenvalues A. of *M,* weighted by their multiplicities. Thus the proof will be complete when it is shown that the double integral in *(20)* reduces to zero. This double integral is

$$\frac{2\pi}{n} \left(\frac{1}{2\pi}\right)^{3} \int_{-\pi}^{\pi} d\omega_{1} \int_{-\pi}^{\pi} d\omega_{2} \sum_{\beta_{1}\beta_{2}\beta_{3}\beta_{4}}^{m} \sum_{\beta_{1}\gamma=1}^{m} \left[\left\{A - I \exp\left(i\omega_{1}\right)\right\} k(-\omega_{1})\right]_{\mu\beta_{2}} I \\
\times k_{\beta\beta_{1}}(\omega_{1}) k_{\lambda\beta_{3}}(\omega_{2}) k_{\gamma\beta_{4}}(-\omega_{2}) \\
= \frac{1}{4n\pi^{2}} \int_{-\pi}^{\pi} d\omega_{1} \int_{-\pi}^{\pi} d\omega_{2} \sum_{\beta_{1}\beta_{2}\beta_{3}\beta_{4}}^{m} \sum_{\beta_{1}\gamma=1}^{m} \exp\left(i\omega_{1}\right) \delta(\mu - \beta_{2}) L_{\beta\gamma} \\
\times k_{\beta\beta_{1}}(\omega_{1}) k_{\lambda\beta_{3}}(\omega_{2}) k_{\gamma\beta_{4}}(-\omega_{2}) \\
= \frac{1}{4n\pi^{2}} \int_{-\pi}^{\pi} d\omega_{1} \int_{-\pi}^{\pi} d\omega_{2} \sum_{\beta_{1}\beta_{2}\beta_{3}\beta_{4}}^{m} \sum_{\beta_{1}\gamma=1}^{m} \exp\left(i\omega_{1}\right) \delta(\mu - \beta_{2}) L_{\beta\gamma} \\
\times \left\{\sum_{\alpha\geq0} A^{\alpha} \exp\left(i\alpha\omega_{1}\right)\right\}_{\beta\beta_{1}} k_{\lambda\beta_{3}}(\omega_{2}) k_{\gamma\beta_{4}}(-\omega_{2}) \\
= \frac{1}{4n\pi^{2}} \int_{-\pi}^{\pi} \sum_{\beta_{1}\beta_{2}\beta_{3}\beta_{4}}^{m} \sum_{\beta_{1}\gamma=1}^{m} \sum_{\alpha\geq0} \delta(\mu - \beta_{2}) \\
\times L_{\beta\gamma}(A^{\alpha})_{\beta\beta_{1}} k_{\lambda\beta_{3}}(\omega_{2}) k_{\gamma\beta_{4}}(-\omega_{2}) d\omega_{2} \\
\times \int_{-\pi}^{\pi} \exp\left\{i(\alpha + 1)\omega_{1}\right\} d\omega_{1}$$

# **4. APPLICATION TO SIMILAR ESTIMATORS**

In this section the biases of two similar estimators are obtained under the same conditions as assumed in the preceding section. The modified Yule-Walker estimator of Tjastheim and Paulsen (1983) is defined by replacing a d-dimensional **AR(p)** by a dp-dimensional **AR(1)** as we indicated above, at (5), and then applying the usual Yule-Walker estimation procedure. This, as Tj0stheim and Paulsen observe, leads to a different estimator from that obtained by proceeding directly with solution of the Yule-Walker equations.

In the same notation as in the previous section, the modified Yule-Walker estimator based on *n* observations is

$$A_n^{Y} = (A + p_n)(I - q_n')^{-1}$$
 (22)

where

$$q'_n = q_n - \frac{1}{n-1} U_n U_n^{\mathrm{T}} \Gamma(0)^{-1}.$$

We find that the hypotheses of Theorem 1 are satisfied with  $A_n^Y$  in place of  $\hat{\Delta}_n$ ,  $A - (n-1)^{-1}I$  in place of  $\Delta_n$ ,  $q_n'$  in place of  $\rho_n$ ,  $v_n - (n-1)^{-1}I$  in place of  $\sigma_n$  and  $p_n + (n-1)^{-1}I$  in place of  $\delta_n$ . Thus, to  $O(n^{-3/2})$ , we can determine the difference  $E(\hat{A}_n - A_n^Y)$  from an application of that theorem. Some cancelling occurs and we can avoid the repetition of calculations like those of the last section, finding readily that

$$E(\hat{A}_n - A_n^{\rm Y}) = \frac{1}{n-1} A + O(n^{-3/2}).$$

Thus we obtain the following theorem.

THEOREM 3. Let  $A_n^Y$  be the modified Yule-Walker estimator (22) of A in the m-dimensional AR(1) of (5) based on a sample of size n. Suppose that the other conditions of Theorem 2 are satisfied. Then, as  $n \to \infty$ , the bias  $B_n^Y = EA_n^Y - A$  is of the form

$$B_n^{\rm Y} = -\frac{b^{\rm Y}}{n} + {\rm O}(n^{-3/2})$$

where  $b^{Y}$  depends on the parameters A and G but is independent of n and is given by

$$b^{Y} = A + G[(I - A^{T})^{-1} + A^{T}\{I - (A^{T})^{2}\}^{-1} + \sum \lambda (I - \lambda A^{T})^{-1}]\Gamma(0)^{-1}.$$

The sum is over the eigenvalues  $\lambda$  of A, weighted by their multiplicities.

This agrees with the expression obtained by Tjøstheim and Paulsen (1983, Equation (4.4)). Their derivation, however, applies only to the case of Gaussian innovations, while the result above holds more generally, and in addition the error has been shown to be  $O(n^{-3/2})$ .

As another application of Theorem 1, we consider the estimator referred to as the least-squares estimator by Box and Jenkins (1976, p.277), which differs from what has been called the least-squares estimator here. Their estimator can be written

$$A_n^{BJ} = (A + p_n)(I - q_n^{BJ})^{-1}$$

where

$$q_n^{\mathrm{BJ}} = q_n + \frac{1}{n-1} U_1 U_1^{\mathrm{T}} \Gamma(0)^{-1}.$$

By the same method as above, the difference in expectation can be seen to be

$$E(\hat{A}_n - A_n^{BJ}) = \frac{1}{n-1} (-A) + O(n^{-3/2}).$$

#### REFERENCES

- BHANSALI, R. J. (1981) Effects of not knowing the order of an autoregressive process on the mean squared error of prediction—I. J. Am. Statist. Assoc. 76, 588-97.
- Box, G. E. P. and Jenkins, G. M. (1976) Time Series Analysis Forecasting and Control. Oakland, CA: Holden-Day.
- Fuller, W. A. and Hasza, D. P. (1981) Properties of predictors for autoregressive time series. J. Am. Statist. Assoc. 76, 155-61.
- HALL, P. and HEYDE, C. C. (1980) Martingale Limit Theory and Its Application. New York: Academic Press.
- HOSOYA, Y. and TANIGUCHI, M. (1982) A central limit theorem for stationary linear processes and the parameter estimation of linear processes. *Ann. Statist.* 10, 132–53.
- Nicholls, D. F. and Pope, A. L. (1988) Bias in the estimation of multi-variate autoregressions. Aust. J. Statist. 30A, 296-309.
- POPE, A. L. (1987) Small sample bias problems in time series. Master's Thesis, Australian National University.
- Speed, T. P. (1983) Cumulants and partition lattices. Aust. J. Statist. 25, 378-88.
- TJØSTHEIM, D. and PAULSEN, J. (1983) Bias of some commonly-used time series estimates. Biometrika 70, 389-99; Correction, Biometrika 71, 656 (1984).