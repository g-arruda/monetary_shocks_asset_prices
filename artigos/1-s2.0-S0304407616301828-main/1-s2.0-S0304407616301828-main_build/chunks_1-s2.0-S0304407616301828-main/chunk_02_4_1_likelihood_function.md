# 4.1. Likelihood function

We next consider maximum likelihood (ML) estimation of the parameters in the non-Gaussian SVAR model (1). To that end, we have to be more specific about the distribution of the error term.

<span id="page-5-1"></span>**Assumption 2.** For each  $i=1,\ldots,n$ , the distribution of the error term  $\varepsilon_{i,t}$  has a (Lebesgue) density  $f_{i,\sigma_i}(x;\lambda_i)=\sigma_i^{-1}f_i(\sigma_i^{-1}x;\lambda_i)$  which may also depend on a parameter vector  $\lambda_i$ .

Assumption 2 is sufficient for constructing the likelihood function of the parameters. Note that the component densities  $f_i$  ( $\cdot$ ;  $\lambda_i$ ) are supposed to depend on their own parameter vectors, but they can (though need not) belong to the same family of densities. For instance, they can be densities of (univariate) Student's t-distribution with different degrees of freedom parameters.<sup>7</sup>

Next we define the parameter space of the model. First consider the parameter matrix B which we assume to belong to the set  $\mathcal{B}$  introduced in the previous section. This restricts the diagonal elements of the matrix B to unity, and we collect its off-diagonal elements in the vector  $\beta$  ( $n(n-1) \times 1$ ) and express this as  $\beta = vecd^{\circ}(B)$  where, for any  $n \times n$  matrix C,  $vecd^{\circ}(C)$ signifies the n(n-1)-dimensional vector obtained by removing the n diagonal entries of C from its usual vectorized form vec(C). Note that  $vec(B(\beta)) = H\beta + vec(I_n)$ , where the  $n^2 \times n(n-1)$ matrix H is of full column rank and its elements consist of zeros and ones<sup>8</sup> (we use the notation  $B(\beta)$  when we wish to make the dependence of the parameter matrix B on its unknown off-diagonal elements explicit). The parameters of the model are now contained in the vector  $\theta = (\pi, \beta, \sigma, \lambda)$  where  $\pi = (\pi_1, \pi_2)$ with  $\pi_1 = \nu$  and  $\pi_2 = vec([A_1 : \cdots : A_p]), \sigma = (\sigma_1, \ldots, \sigma_n)$  and  $\lambda = (\lambda_1, \dots, \lambda_n)$ . We use  $\theta_0$  to signify the true parameter value (and similarly for its components) and introduce the following assumption.

<span id="page-5-4"></span>**Assumption 3.** The true parameter value  $\theta_0$  belongs to the permissible parameter space  $\Theta = \Theta_\pi \times \Theta_\beta \times \Theta_\sigma \times \Theta_\lambda$ , where (i)  $\Theta_\pi = \mathbb{R}^n \times \Theta_{\pi_2}$  with  $\Theta_{\pi_2} \subseteq \mathbb{R}^{n^2p}$  such that condition (2) holds for every  $\pi_2 \in \Theta_{\pi_2}$ , (ii)  $\Theta_\beta = vecd^\circ$  ( $\mathcal{B}$ ) =  $\{\beta \in \mathbb{R}^{n(n-1)} : \beta = vecd^\circ$  ( $\mathcal{B}$ ) for some  $\mathcal{B} \in \mathcal{B}\}$ , (iii)  $\Theta_\sigma = \mathbb{R}^n_+$ , and (iv)  $\Theta_\lambda = \Theta_{\lambda_1} \times \cdots \times \Theta_{\lambda_n} \subseteq \mathbb{R}^d$  with  $\Theta_{\lambda_i} \subseteq \mathbb{R}^{d_i}$  open for every  $i = 1, \ldots, n$  and  $d = d_1 + \cdots + d_n$ .

Condition (2) entails that  $\Theta_{\pi_2}$ , the parameter space of  $\pi_2$ , is open whereas  $\Theta_\beta$  is open due to the Identification Scheme and Proposition 2 (a justification is given in the Supplementary Appendix). Thus, Assumption 3 implies that the whole parameter space  $\Theta$  is open so that the true parameter value  $\theta_0$  is an interior point of the parameter space, as assumed in standard derivations of the asymptotic properties of a local ML estimator.

The (standardized) log-likelihood function of the parameter  $\theta \in \Theta$  based on model (1) and the data  $y_{-p+1}, \ldots, y_0, y_1, \ldots, y_T$  (and conditional on  $y_{-p+1}, \ldots, y_0$ ) can now be written as

$$L_{T}(\theta) = T^{-1} \sum_{t=1}^{T} l_{t}(\theta), \qquad (7)$$

where

<span id="page-5-7"></span>
$$l_{t}(\theta) = \sum_{i=1}^{n} \log f_{i} \left( \sigma_{i}^{-1} \iota_{i}' B(\beta)^{-1} u_{t}(\pi); \lambda_{i} \right)$$
$$- \log |\det (B(\beta))| - \sum_{i=1}^{n} \log \sigma_{i}$$
(8)

with  $\iota_i$  the ith unit vector and  $u_t$  ( $\pi$ ) =  $y_t - v - A_1 y_{t-1} - \cdots - A_p y_{t-p}$ . Maximizing  $L_T$  ( $\theta$ ) over the permissible parameter space  $\Theta$  yields the ML estimate of  $\theta$ .

To apply the estimator discussed above one has to choose a non-Gaussian error distribution. In economic applications departures from Gaussianity typically manifest themselves as leptokurtic behavior, and Student's *t*-distribution is presumably the non-Gaussian distribution most commonly employed in the previous empirical literature. Alternatives include the normal inverse Gaussian distribution, the generalized hyperbolic distribution, and their skewed versions.

#### <span id="page-5-9"></span>4.2. Score vector

We first derive the asymptotic distribution of the score vector (evaluated at the true parameter value  $\theta_0$ ). We use a subscript to signify a partial derivative; for instance  $l_{\theta,t}\left(\theta\right) = \partial l_t\left(\theta\right)/\partial\theta$ ,  $f_{i,x}\left(x;\lambda_i\right) = \partial f_i\left(x;\lambda_i\right)/\partial x$ , and  $f_{i,\lambda_i}\left(x;\lambda_i\right) = \partial f_i\left(x;\lambda_i\right)/\partial \lambda_i$  (an assumption which guarantees the existence of these partial derivatives will be given shortly). The score vector of a single observation,  $l_{\theta,t}\left(\theta\right)$ , is derived in Appendix B.

Some of our subsequent assumptions are required to hold in a (small) neighborhood of the true parameter value, and to this end we introduce the compact and convex set  $\Theta_0 = \Theta_{0,\pi} \times \Theta_{0,\beta} \times \Theta_{0,\sigma} \times \Theta_{0,\lambda}$  that is contained in the interior of  $\Theta$  and has  $\theta_0$  as an interior point. Now, we make the following assumption.

**Assumption 4.** The following conditions hold for i = 1, ..., n:

- <span id="page-5-6"></span>(i) For all  $x \in \mathbb{R}$  and all  $\lambda_i \in \Theta_{0,\lambda_i}$ ,  $f_i(x; \lambda_i) > 0$  and  $f_i(x; \lambda_i)$  is twice continuously differentiable with respect to  $(x; \lambda_i)$ .
- (ii) The function  $f_{i,x}(x; \lambda_{i,0})$  is integrable with respect to x, i.e.,  $\int |f_{i,x}(x; \lambda_{i,0})| dx < \infty$ .
- (iii) For all  $x \in \mathbb{R}$ ,

$$x^{2} \frac{f_{i,x}^{2}(x; \lambda_{i,0})}{f_{i}^{2}(x; \lambda_{i,0})}$$
 and  $\frac{\|f_{i,\lambda_{i}}(x; \lambda_{i,0})\|^{2}}{f_{i}^{2}(x; \lambda_{i,0})}$ 

are dominated by  $c_1(1+|x|^{c_2})$  with  $c_1,c_2\geq 0$  and  $\int |x|^{c_2}f_i\left(x;\lambda_{i,0}\right)dx<\infty$ .

(iv)  $\int \sup_{\lambda_i \in \Theta_{0,\lambda_i}} \|f_{i,\lambda_i}(x;\lambda_i)\| dx < \infty$ .

Moreover,

(v) The matrix  $E[l_{\theta,t}(\theta_0)l'_{\theta,t}(\theta_0)]$  is positive definite.

<span id="page-5-8"></span>Assumption 4(i) guarantees that the log-likelihood function satisfies conventional differentiability assumptions of ML estimation by imposing differentiability assumptions on the density functions  $f_i(x; \lambda_i)$ . Assumptions 4(ii)–(iv) require that the partial derivatives of the density functions  $f_i(x; \lambda_i)$  satisfy suitable integrability conditions that are needed to ensure that the score function (evaluated at the true parameter value) has zero mean and a finite covariance matrix. Assumption 4(v) ensures that this covariance matrix, and hence the covariance matrix of the (normal) limiting

<span id="page-5-2"></span> $<sup>^{7}</sup>$  Note, however, that the independence requirement in Assumption 1(ii) rules out common multivariate error distributions such as the multivariate Student's t-distribution.

<span id="page-5-3"></span><sup>&</sup>lt;sup>8</sup> The matrix H can be expressed as  $H = \sum_{i=1}^{n} \sum_{j=1}^{n-1} (\iota_i t_i' \otimes \iota_{j+I[j \geq i]} \overline{t}_j')$ , where  $\widetilde{\iota}_j$  denotes an (n-1)-vector with 1 in the jth coordinate and zeros elsewhere,  $j=1,\ldots,n-1$ , and  $I[j \geq i]=1$  if  $j \geq i$  and zero otherwise (cf. Ilmonen and Paindaveine (2011, p. 2452)).

<span id="page-5-5"></span> $<sup>^9</sup>$  Note that compactness and convexity may here be assumed without loss of generality; if  $\Theta_0$  were not compact/convex, we could instead consider its compact and convex subset.

distribution of the ML estimator of  $\theta$ , is positive definite. The conditions in Assumption 4 (as well as those in Assumption 5) are similar to those previously imposed on error density functions in the estimation theory of non-Gaussian ARMA models (see, e.g., Breidt et al. (1991), Andrews et al. (2006), Lanne and Saikkonen (2011), Meitz and Saikkonen (2013), and the references therein), although their formulation is somewhat different. Most common density functions satisfy these assumptions.

The limiting distribution of the score vector is given in the following lemma which is proved in Appendix B.

<span id="page-6-2"></span>**Lemma 1.** If Assumptions 2-4 hold, 
$$T^{-1/2} \sum_{t=1}^{T} l_{\theta,t} (\theta_0) \stackrel{d}{\rightarrow} N (0, \mathcal{I}(\theta_0))$$
, where  $\mathcal{I}(\theta_0) = E[l_{\theta,t} (\theta_0) l'_{\theta,t} (\theta_0)]$  is positive definite.

As shown in Appendix B,  $l_{\theta,t}(\theta_0)$  is a stationary and ergodic martingale difference sequence with covariance matrix  $\mathcal{L}(\theta_0)$  and, consequently, the limiting distribution can be obtained by applying a standard central limit theorem. An explicit expression of the covariance matrix  $\mathcal{L}(\theta_0)$  is given in Appendix B.

#### <span id="page-6-6"></span>4.3. Hessian matrix

We next consider the Hessian matrix. Expressions for the required second partial derivatives are given in Appendix C. Similarly to the first partial derivatives, we use notations such as landy to the first partial derivatives, we use includens satisfied  $l_{\theta\theta,t}(\theta) = \partial^2 l_t(\theta) / \partial\theta \partial\theta', f_{i,xx}(x,\lambda_i) = \partial^2 f_i(x;\lambda_i) / \partial x^2$ , and  $f_{i,x\lambda_i}(x;\lambda_i) = \partial^2 f_i(x;\lambda_i) / \partial x \partial \lambda_i'$ . The following assumption complements Assumption 4 by providing further regularity conditions on the partial derivatives of the density functions  $f_i(x; \lambda_i)$ .

<span id="page-6-0"></span>**Assumption 5.** The following conditions hold for i = 1, ..., n:

- (i) The functions  $f_{i,xx}(x; \lambda_{i,0})$  and  $f_{i,x\lambda_i}(x; \lambda_{i,0})$  are integrable with respect to x, i.e.,  $\int \left| f_{i,xx}\left(x;\lambda_{i,0}\right) \right| dx < \infty \text{ and } \int \left\| f_{i,x\lambda_{i}}\left(x;\lambda_{i,0}\right) \right\| dx < \infty.$ (ii)  $\int \sup_{\lambda_{i} \in \Theta_{0,\lambda_{i}}} \left\| f_{i,\lambda_{i}\lambda_{i}}\left(x;\lambda_{i}\right) \right\| dx < \infty.$ (iii) For all  $x \in \mathbb{R}$  and all  $\lambda_{i} \in \Theta_{0,\lambda_{i}}$ ,

$$\frac{f_{i,x}^{2}(x;\lambda_{i})}{f_{i}^{2}(x;\lambda_{i})} \quad \text{and} \quad \left| \frac{f_{i,xx}(x;\lambda_{i})}{f_{i}(x;\lambda_{i})} \right|$$

re dominated by  $a_0 (1 + |x|^{a_1})$ 

$$\left\| \frac{f_{i,x\lambda_{i}}\left(x;\lambda_{i}\right)}{f_{i}\left(x;\lambda_{i}\right)} \right\| \quad \text{and} \quad \left\| \frac{f_{i,x}\left(x;\lambda_{i}\right)}{f_{i}\left(x;\lambda_{i}\right)} \frac{f_{i,\lambda_{i}}\left(x;\lambda_{i}\right)}{f_{i}\left(x;\lambda_{i}\right)} \right\|$$

are dominated by  $a_0 (1 + |x|^{a_2})$ 

$$\left\| \frac{f_{i,\lambda_i}\left(x;\lambda_i\right)}{f_i\left(x;\lambda_i\right)} \right\|^2 \quad \text{and} \quad \left\| \frac{f_{i,\lambda_i\lambda_i}\left(x;\lambda_i\right)}{f_i\left(x;\lambda_i\right)} \right\|$$

are dominated by  $a_0 (1 + |x|^{a_3})$ ,

with 
$$a_0, a_1, a_2, a_3 \ge 0$$
 such that  $\int (|x|^{2+a_1} + |x|^{1+a_2} + |x|^{a_3})f_i(x; \lambda_{i,0}) dx < \infty$   $(i = 1, ..., n)$ .

These conditions are similar to those in Assumptions 4(ii)-(iv) and again impose suitable integrability conditions on partial derivatives of the density functions  $f_i(x; \lambda_i)$ . Assumptions 5(i) and (ii) are needed to ensure that, when evaluated at the true parameter value, the expectation of the Hessian matrix has the usual property  $E[l_{\theta,t}(\theta_0)] = -Cov[l_{\theta,t}(\theta_0)]$ , whereas Assumption 5(iii) guarantees that the (standardized) Hessian matrix obeys an appropriate uniform law of large numbers. These results are given in the following lemma which is proved in Appendix C.

<span id="page-6-1"></span>**Lemma 2.** If Assumptions 2–5 hold, 
$$\sup_{\theta \in \Theta_0} \|T^{-1} \sum_{t=1}^{T} l_{\theta\theta,t}(\theta) - E\left[l_{\theta\theta,t}(\theta)\right]\| \to 0$$
 a.s., where  $E[l_{\theta\theta,t}(\theta)]$  is continuous at  $\theta_0$  and  $E[l_{\theta\theta,t}(\theta_0)] = -\mathbf{1}(\theta_0)$ .

In addition to enabling us to establish the asymptotic normality of the ML estimator, Lemma 2 can also be used to obtain a consistent estimator for the covariance matrix of the limiting distribution needed to conduct statistical inference.

#### <span id="page-6-7"></span>4.4. Maximum likelihood estimator

The results of Lemmas 1 and 2 provide the basic ingredients needed to derive the consistency and asymptotic normality of a local ML estimator stated in the following theorem.

<span id="page-6-3"></span>**Theorem 1.** If Assumptions 2-5 hold, there exists a sequence of solutions  $\hat{\theta}_T$  to the likelihood equations  $L_{\theta,T}(\theta) = 0$  such that  $T^{1/2}(\hat{\theta}_T - \theta_0) \stackrel{d}{\rightarrow} N(0, I(\theta_0)^{-1}) \text{ as } T \rightarrow \infty.$ 

Theorem 1 shows that the usual result on consistency and asymptotic normality of a local maximizer of the log-likelihood function applies. The proof of Theorem 1, given in Appendix C, is based on arguments used in similar proofs in the previous litera-

A consistent estimator of the covariance matrix  $\mathcal{L}(\theta_0)^{-1}$  in Theorem 1 can be obtained by using the ML estimator  $\hat{\theta}_T$  and the Hessian matrix of the log-likelihood function. Specifically,

<span id="page-6-4"></span>
$$-L_{\theta\theta,T}^{-1}(\hat{\theta}_T) \stackrel{def}{=} -\left(T^{-1} \sum_{t=1}^{T} l_{\theta\theta,t}(\hat{\theta}_T)\right)^{-1} \to \mathcal{I}(\theta_0)^{-1} \quad (a.s.). \tag{9}$$

We omit the proof of this result, which follows from Lemma 2 and Theorem 1 with standard arguments.

### <span id="page-6-5"></span>4.5. Three-step estimation

The ML estimator  $\hat{\theta}_T$  can be computationally rather demanding when the dimension n is not small and relatively short time series are considered. In this section, we therefore consider a computationally simpler three-step estimator which turns out to be asymptotically efficient when the components of the error term  $\varepsilon_t$  are symmetric in the following sense.

**Symmetry Condition.** For each i = 1, ..., n, the distribution of  $\varepsilon_{i,t}$  is symmetric in the sense that  $f_i(x; \lambda_i) = f_i(-x; \lambda_i)$  for all  $\lambda_i \in \Theta_{0,\lambda_i}$ .

Most error distributions employed in empirical SVAR literature satisfy this condition.

To present the estimator, partition the parameter vector  $\theta$  as  $\theta = (\pi, \gamma)$ , where  $\pi$  contains the autoregressive parameters ( $\nu$ and  $A_1, \ldots, A_p$ ) and  $\gamma = (\beta, \sigma, \lambda)$  the parameters related to the error term  $B\varepsilon_t$ . In the first step, the autoregressive parameters are estimated by the least squares (LS) estimator denoted by  $\tilde{\pi}_{LS,T}$ . In the second step, the parameter  $\pi$  in the log-likelihood function  $L_{T}(\pi, \gamma)$  is replaced by the LS estimator  $\tilde{\pi}_{LS,T}$  and the resulting

$$\tilde{L}_{T}(\gamma) = L_{T}\left(\tilde{\pi}_{LS,T}, \gamma\right) = T^{-1} \sum_{t=1}^{T} l_{t}\left(\tilde{\pi}_{LS,T}, \gamma\right)$$

is maximized with respect to  $\gamma$  (here  $l_t(\tilde{\pi}_{LS,T}, \gamma)$  is defined by replacing  $u_t(\pi)$  in the expression of  $l_t(\theta) = l_t(\pi, \gamma)$  in (8) with the LS residuals  $u_t(\tilde{\pi}_{LS,T})$ ). The resulting estimator, denoted by  $\tilde{\gamma}_T$ , therefore uses the LS residuals to estimate the parameters related to the error term  $B\varepsilon_t$ . In the third step, we replace the parameter  $\gamma$  in the log-likelihood function  $L_T(\pi, \gamma)$  by the estimator  $\tilde{\gamma}_T$  and maximize the resulting function

$$\tilde{\tilde{L}}_{T}(\pi) = L_{T}(\pi, \tilde{\gamma}_{T}) = T^{-1} \sum_{t=1}^{T} l_{t}(\pi, \tilde{\gamma}_{T})$$

with respect to  $\pi$  (see (8)).

The following theorem shows that the resulting three-step estimator  $\tilde{\theta}_T = (\tilde{\pi}_T, \tilde{\gamma}_T)$  is asymptotically efficient under the Symmetry Condition.

<span id="page-7-1"></span>**Theorem 2.** Suppose Assumptions 2–5 and the Symmetry Condition hold. Then the three-step estimator  $\tilde{\theta}_T = (\tilde{\pi}_T, \tilde{\gamma}_T)$  is asymptotically efficient and the matrix  $\mathcal{L}(\theta_0)$  is block diagonal, i.e.,

$$\begin{split} T^{1/2} \left( \begin{bmatrix} \tilde{\pi}_T \\ \tilde{\gamma}_T \end{bmatrix} - \begin{bmatrix} \pi_0 \\ \gamma_0 \end{bmatrix} \right) \\ & \stackrel{d}{\to} N \left( 0, \begin{bmatrix} I_{\pi\pi} (\theta_0)^{-1} & 0 \\ 0 & I_{\gamma\gamma} (\theta_0)^{-1} \end{bmatrix} \right) \quad \text{as } T \to \infty. \end{split}$$

The result given in (9) applies with the ML estimator  $\hat{\theta}_T$  replaced by the three-step estimator  $\tilde{\theta}_T$  so that  $-L_{\pi\pi,T}^{-1}(\tilde{\theta}_T)$  and  $-L_{\gamma\gamma,T}^{-1}(\tilde{\theta}_T)$  are consistent estimators of the covariance matrices  $\pounds_{\pi\pi}(\theta_0)^{-1}$  and  $\pounds_{\gamma\gamma}(\theta_0)^{-1}$  in Theorem 2.

## <span id="page-7-4"></span>4.6. Testing hypotheses

A major advantage of the non-Gaussian SVAR model is the ability to test restrictions that are partly or exactly identifying in its Gaussian counterpart. <sup>10</sup> Such restrictions, often obtained from the previous literature, may also prove useful in interpretation. Short-run restrictions typically come in the form of zero restrictions on certain elements of the matrix B (assumed to belong to the set  $\mathcal{B}$ ); for instance, in a four-variable SVAR model, B could take one of the following forms:

$$\begin{bmatrix} 1 & 0 & 0 & 0 \\ * & 1 & 0 & 0 \\ * & * & 1 & 0 \\ * & * & * & 1 \end{bmatrix}, \quad \begin{bmatrix} 1 & * & * & 0 \\ * & 1 & * & 0 \\ * & * & 1 & 0 \\ * & * & * & 1 \end{bmatrix}, \quad \text{or} \begin{bmatrix} 1 & * & * & * \\ * & 1 & * & * \\ * & * & 1 & 0 \\ * & * & * & 1 \end{bmatrix},$$

where \* denotes an arbitrary value. The first matrix implies a recursive structure on the SVAR model. This restriction corresponds to the common use of the Cholesky factor of the covariance matrix of the error term  $B\varepsilon_t$  to identify Gaussian SVARs (and is also an a priori restriction in the identification results of Hyvärinen et al. (2010) and Moneta et al. (2013)). In our set-up, validity of this restriction can be tested. Alternative non-recursive hypotheses of interest are exemplified by the second and third matrices above: the second matrix restricts the fourth shock to have an immediate impact on the fourth variable only, and the third precludes the immediate impact of the fourth shock on the third variable. Note that, in the Gaussian SVAR model, only the first set of the restrictions illustrated above is exactly identifying, while the other two do not suffice for identification of the structural shocks (because in the two latter cases, there exist non-identity transformations C = D0, with O orthogonal and D diagonal and non-singular, that preserve these restrictions).

As the parameter vector  $\theta$  is fully identified in  $\Theta$  and the ML estimator (and in the symmetric case also the three-step estimator) has a conventional asymptotic normal distribution, hypothesis tests can be carried out in the usual manner, using standard Wald, likelihood ratio, or Lagrange multiplier tests. In the case of short-run restrictions discussed above, testing is straightforward. For instance, the likelihood ratio test statistic  $LR = -2[L_T(\hat{\theta}_T^{(R)}) - L_T(\hat{\theta}_T)]$ , where  $\hat{\theta}_T^{(R)}$  denotes the maximizer of (7) under the short-run restrictions of interest, has its usual asymptotic

 $\chi_r^2$ -distribution when the restrictions hold true (r denotes the number of restrictions imposed; for instance, r = n(n-1)/2 when recursiveness is tested). Also long-run restrictions (à la Blanchard and Quah (1989)) imposing zero restrictions on the sum of certain element(s) of the matrices  $\Psi_j B, j = 0, 1, \ldots$ , can be tested by standard tests. For instance, testing whether the nth shock has no accumulated long-run effect on the first component of  $y_t$  amounts to checking whether  $\sum_{j=0}^{\infty} \iota'_1 \Psi_j B \iota_n = \iota'_1 A(1)^{-1} B \iota_n = 0$  ( $\iota_i$  denotes the ith unit vector), and this restriction can conveniently be tested using an asymptotically  $\chi_1^2$ -distributed Wald test for a nonlinear hypothesis.

When performing and interpreting tests, one should keep in mind that the straightforward conventional tests require the parameter vector under the null hypothesis to belong to the parameter space considered. In particular, it is required that the assumed value of the matrix B under the null hypothesis belongs to the set B defined in the Identification Scheme (see Section 3.3). One implication of this is that not all restrictions can be straightforwardly tested (an example is the restriction that a diagonal element of B equals zero). Another, more subtle, implication to be kept in mind is that the particular permutation (of the columns of B and the elements of  $\varepsilon_t$ ) being considered is fixed to the one defined by step (ii) of the Identification Scheme. For instance, one might be tempted to interpret a test of the second set of restrictions above as a test of whether there exists a shock with no immediate impact on the other three variables. However, it should only be interpreted as a test of whether, with this particular ordering, the fourth structural shock has no immediate impact on the first three variables. 11 Therefore, prior to testing restrictions, we recommend labeling the shocks by inspection of impulse response functions, as illustrated in Section 5.

# <span id="page-7-0"></span>5. Empirical application

The interdependence of monetary policy and the stock market is an issue that has recently awoken a lot of interest and that has been addressed by means of SVAR analysis. Intuitively, one would expect the dynamics of monetary policy actions and the stock market to be closely linked. Movements of stock prices are driven by expectations of future returns that are connected to the business cycle and monetary policy decisions. On the other hand, because of the close interconnections between financial markets and the real economy, policymakers monitor asset prices, and presumably use them as indicators when making monetary policy decisions.

Given the plausibly close connections between financial markets and monetary policy, it is somewhat surprising that typical new-Keynesian models of the business cycle mostly ignore stock prices, as Castelnuovo and Nisticò (2010), among others, have pointed out. They put forth a dynamic stochastic general equilibrium (DSGE) model where the stock market is allowed to play an active role in the determination of the business cycle, and their empirical results with postwar U.S. data indeed lend support to reciprocal effects between financial markets and monetary policy. Specifically, they find an on-impact negative reaction in the stock-price gap following a contractionary monetary policy shock, and an interest rate increase following a positive stock market shock.

While the theoretical literature on interactions between monetary policy and the stock market is scant, empirically this issue has been addressed in a number of papers by means of SVAR

<span id="page-7-2"></span><sup>10</sup> Related tests have been discussed, for instance, in Lanne and Lütkepohl (2010) in the econometrics literature and in Ilmonen and Paindaveine (2011, Sec. 3) in the independent component analysis literature.

<span id="page-7-3"></span><sup>11</sup> Even if the second set of restrictions above does not hold, there may exist a shock with no immediate impact on the other three variables. On the other hand, if the second set of restrictions above holds with the permutation defined by step (ii) of the Identification Scheme, it may not hold with other permutations (as the locations of the zeros may change).

<span id="page-8-0"></span>![](_page_8_Figure_2.jpeg)

**Fig. 1.** The time series included in the SVAR model.

analysis using different identification schemes. Examples include [Lastrapes](#page-16-32) [\(1998\)](#page-16-32) and [Rapach](#page-16-33) [\(2001\)](#page-16-33) who rely on long-run restrictions for identification, [Li](#page-16-34) [et al.](#page-16-34) [\(2010\)](#page-16-34) who use nonrecursive short-run restrictions, [Bjørnland](#page-16-35) [and](#page-16-35) [Leitemo](#page-16-35) [\(2009\)](#page-16-35) who consider identification by a combination of short-run and long-run restrictions, and [Rigobon](#page-16-36) [and](#page-16-36) [Sack](#page-16-36) [\(2004\)](#page-16-36), who base identification on the heteroskedasticity of shocks in high-frequency data. However, short-run recursive restrictions have probably been the most commonly employed approach to identification in this literature; see, e.g., [Patelis](#page-16-37) [\(1997\)](#page-16-37), [Thorbecke](#page-16-38) [\(1997\)](#page-16-38), and [Cheng](#page-16-39) [and](#page-16-39) [Jin](#page-16-39) [\(2013\)](#page-16-39). Empirical results depend on the data and identification scheme used, but typically a monetary policy shock is found not to account for a major part of the variation of stock returns.

However, recursive identification by the Cholesky decomposition has been strongly criticized by [Bjørnland](#page-16-35) [and](#page-16-35) [Leitemo](#page-16-35) [\(2009\)](#page-16-35) on the grounds that in their U.S. data set (from 1983 to 2002), such identification yields counterintuitive impulse responses. In particular, they found a permanent positive effect on stock returns following a contractionary monetary policy shock, while on economic grounds a temporary negative response is expected. Moreover, recursive ordering, by construction, precludes the immediate impact of a monetary policy (stock market) shock on the stock price (policy rate) if the interest rate (stock return) is placed last in the ordering of the variables as is usually done. This is not theoretically well founded, and it does not conform to [Castelnuovo](#page-16-31) [and](#page-16-31) [Nisticò's](#page-16-31) [\(2010\)](#page-16-31) DSGE model. According to [Castelnuovo's](#page-16-8) [\(2013\)](#page-16-8) simulation results, the impulse response functions of a monetary policy shock of a Cholesky-identified SVAR model estimated on data generated from their DSGE model are quite different from those implied by the actual DSGE model. Specifically, the DSGE model predicts a significant negative reaction of financial conditions to a contractionary monetary policy shock, which is necessarily overlooked by the recursive SVAR model.

In this paper, we estimate a four-variable SVAR model with recent U.S. data. Identification is achieved by assuming that the components of the error term are independently *t*-distributed. Given that financial market data are involved, a distributional assumption allowing for errors with fatter tails than in the Gaussian case seems useful. Moreover, *t*-distributed shocks have also recently been implemented in DSGE models (see, e.g., [Chib](#page-16-40) [and](#page-16-40) [Ramamurthy](#page-16-40) [\(2014\)](#page-16-40), and [Cúrdia](#page-16-41) [et al.](#page-16-41) [\(2014\)](#page-16-41)). To facilitate direct interpretation of our results in terms of [Castelnuovo's](#page-16-8) [\(2013\)](#page-16-8) DSGE model, we use the same data set as he did. Moreover, as our identification scheme facilitates testing additional identification restrictions, we are able to test directly the recursive identification restrictions criticized by [Castelnuovo](#page-16-8) [\(2013\)](#page-16-8).

# *5.1. Data*

Our quarterly U.S. data set comprises the same four time series on which [Castelnuovo](#page-16-8) [\(2013\)](#page-16-8) based the estimates of the parameters of his DSGE model discussed above. The output gap is computed as the log-deviation of the real GDP from the potential output estimated by the Congressional Budget Office. Inflation is measured by the growth rate of the GDP deflator. Instead of a stock return, we include the Kansas City Financial Condition Index (KCFCI) that combines information from a variety of financial indexes (see [Hakkio](#page-16-42) [and](#page-16-42) [Keeton](#page-16-42) [\(2009\)](#page-16-42) for details, and [Castelnuovo](#page-16-8) [\(2013,](#page-16-8) Appendix 4) for further discussion). Federal funds rate (average of monthly values) is the policy interest rate in the model. The output gap (*xt*), inflation (π*t*), and federal funds rate (*Rt*) are measured as percentages. Our sample period runs from the beginning of 1990 until the second quarter of 2008. Hence, the time series consist of only 74 observations, but there are a number of reasons to prefer this relatively short sample period. First, observations of the KCFCI are not available before 1990, and, second, as [Castelnuovo](#page-16-8) [\(2013\)](#page-16-8), we also do not want to include earlier data to avoid the plausible policy break prior to the Greenspan–Bernanke regime. Moreover, the most recent data are excluded to avoid having to deal with the acceleration of the financial crisis. The KCFCI series (*st*) is downloaded from the website of the Federal Reserve Bank of Kansas City, while the rest of the data are extracted from FRED database of the Federal Reserve Bank of St. Louis. The time series are depicted in [Fig. 1.](#page-8-0)

## *5.2. Results*

We start out by selecting an adequate reduced-form VAR(*p*) model for the data vector *y<sup>t</sup>* = (*xt*, π*t*, *st*, *Rt*). The Bayesian and Akaike information criteria select models with one and two lags, respectively. However, according to the multivariate

<span id="page-9-0"></span>**Table 1** Estimation results of the SVAR(2) model.

| B | 1.000   | −0.231  | −1.362  | −0.772  |    | Equation |         |         |          |
|---|---------|---------|---------|---------|----|----------|---------|---------|----------|
|   | ·       | (0.114) | (0.595) | (0.962) |    | xt       | πt      | st      | Rt       |
|   | 0.142   | 1.000   | −0.007  | 0.011   |    |          |         |         |          |
|   | (0.310) | ·       | (0.254) | (0.271) | σi | 0.293    | 0.657   | 0.211   | 0.198    |
|   | 0.334   | −0.044  | 1.000   | −0.469  |    | (0.083)  | (0.203) | (0.051) | (0.066)  |
|   | (0.201) | (0.056) | ·       | (0.340) |    |          |         |         |          |
|   | 0.505   | −0.049  | −0.337  | 1.000   | λi | 9.920    | 3.141   | 4.073   | 15.049   |
|   | (0.361) | (0.063) | (0.293) | ·       |    | (8.318)  | (1.470) | (2.546) | (21.352) |
|   |         |         |         |         |    |          |         |         |          |

<span id="page-9-3"></span>Notes: The model is estimated by the three-step method described in Section [4.5](#page-6-5) (the figures in parentheses are standard errors).

![](_page_9_Figure_5.jpeg)

**Fig. 2.** Quantile–quantile plots of the residuals of the SVAR(2) model.

Portmanteau test (with eight lags), only the latter produces serially uncorrelated residuals. Moreover, the solution of [Castelnuovo](#page-16-31) [and](#page-16-31) [Nisticò's](#page-16-31) [\(2010\)](#page-16-31) DSGE model has a VAR(2) representation. The multivariate Jarque–Bera test soundly rejects normality at the 1% level, and all residual series seem leptokurtic. Thus, we proceed to a second-order SVAR model with errors following independent *t*-distributions.

Given the short sample period, we estimate the SVAR(2) model by the three-step procedure discussed in Section [4.5.](#page-6-5) In estimation, the identification restrictions on the matrix *B* mentioned in Section [3.3](#page-3-6) are imposed. In [Table 1,](#page-9-0) we report the estimates of *B* and the scale (σ*i*) and degree of freedom (λ*i*) parameters corresponding to the errors of each equation *i*. The fit of the SVAR(2) model to the data appears quite good. As for remaining temporal dependence, according to the Ljung–Box test with eight lags, there is no evidence of remaining autocorrelation in the residuals (the *p*-values for the four residual series are 0.07, 0.12, 0.45, and 0.48). Also, no remaining conditional heteroskedasticity is detected (the *p*-values of the McLeod-Li test with eight lags for the four residual series equal 0.12, 0.99, 0.84, and 0.97).[12](#page-9-1) The residuals and their squares are virtually uncorrelated, and do not exhibit any significant cross correlations,[13](#page-9-2) lending support to the independence assumption underlying identification. The estimates of the degree of freedom parameters suggest clear deviations from normality, which is required for identification. The fit of the error distributions is also reasonable as shown by the quantile–quantile plots in [Fig. 2.](#page-9-3)

In order to interpret the estimation result, we compute the implied impulse response functions. However, as discussed in Section [3,](#page-2-0) the identified shocks do not, as such, carry any economic interpretation despite exact identification. Therefore, along the lines of [Lütkepohl](#page-16-18) [and](#page-16-18) [Netšunajev](#page-16-18) [\(2014a\)](#page-16-18), we use sign restrictions to help in economic identification. It is especially the monetary policy shock that we are interested in, and its qualitative properties on which there is considerable agreement in the established literature, are summarized by [Christiano](#page-16-44) [et al.](#page-16-44) [\(1999\)](#page-16-44), among others. As far as the variables included in our SVAR model are concerned, these properties are as follows: after a contractionary monetary policy shock, the short-term interest rate rises, output (gap) decreases, and inflation responds very slowly. Because of the arguments presented at the beginning of this section, there should be an immediate negative effect on the financial condition index.

The impulse response functions of one standard deviation shocks up to 16 quarters ahead are depicted in [Fig. 3.](#page-10-1) Each row contains the impulse responses of all variables to one shock. Following the common practice in the literature, 68% (pointwise Hall's percentile) confidence bands are plotted to facilitate the assessment of the significance of the impulse responses. They are obtained by residual-based bootstrap (1000 replications). In bootstrapping, three-step estimates of the parameters were used as starting values.

<span id="page-9-1"></span><sup>12</sup> Even the BDS test [\(Brock](#page-16-43) [et al.,](#page-16-43) [1996\)](#page-16-43), in general, indicates temporal independence of the residual series (the *p*-values for the four residual series are, for two commonly used sets of the BDS test's tuning parameters, 0.01, 0.87, 0.51, 0.30, and 0.06, 0.69, 0.11, 0.80, respectively).

<span id="page-9-2"></span><sup>13</sup> To save space, the detailed results are not reported, but they are available upon request.

<span id="page-10-1"></span>![](_page_10_Figure_2.jpeg)

**Fig. 3.** Impulse response functions implied by the SVAR model. Each row contains the impulse responses of all variables to one shock. The dashed lines are the pointwise 68% Hall's percentile confidence bands.

Judged by the confidence bands, only the shock on the bottom row has a nonzero positive immediate impact on the interest rate, and it is thus the only candidate for a contractionary monetary policy shock (the shock on the second row has a barely significant negative impact effect on the interest rate, but because its effect on the output gap is also negative, it cannot be labeled as an expansionary monetary policy shock). The monetary policy shock has a significantly negative impact on inflation over time as well as a negative impact on output, as expected. Interestingly, it also has a significant negative immediate impact on financial conditions, and its effect remains significantly negative for approximately a year. With the exception of inflation, the magnitudes of the impact effects and the time it takes for the impulse responses to revert to zero are quite well in line with those implied by the DSGE model of [Castelnuovo](#page-16-8) [\(2013\)](#page-16-8).

Finally, we assess the validity of recursive identification (entailing zero restrictions on the six upper-triangular elements of *B*) entertained in much of the previous literature. As discussed in Section [4.6,](#page-7-4) our model facilitates testing these kinds of restrictions by conventional asymptotic tests. The *p*-values of the likelihood ratio and Wald tests equal 0.071 and 0.025, respectively, indicating rejection at least at the 10% level. Thus, there is little support for recursive identification, and the monetary policy shock (i.e., the shock ordered last) indeed seems to have an immediate impact on the financial markets, as also indicated by the impulse response analysis. This evidence against recursive identification is in line with the results of [Lütkepohl](#page-16-6) [and](#page-16-6) [Netšunajev](#page-16-6) [\(2014b\)](#page-16-6), who achieved exact identification in a similar SVAR model for U.S. data by introducing a smooth transition in the error covariance matrix.

# <span id="page-10-0"></span>**6. Conclusion**

In this paper, we have considered identification and estimation of SVAR models with non-Gaussian errors. Specifically, we considered a SVAR model where the components of the error process were assumed non-Gaussian and independent. Deviations from Gaussianity, especially error distributions with fatter tails than in the Gaussian case, are often encountered in VAR analysis, and therefore we expect the model to be useful in a large number of applications. Our first identification result showed that, together with standard VAR assumptions, the non-Gaussianity and independence assumptions are sufficient for identification up to permutation and scaling of the structural shocks, which facilitates impulse response analysis. We also presented an Identification Scheme yielding complete identification, a prerequisite for the development of conventional estimation theory.

Under mild technical conditions, we showed consistency and asymptotic normality of the (local) maximum likelihood estimator and a three-step estimator devised for computationally demanding situations. Due to complete identification and standard asymptotic estimation theory, additional economic identifying restrictions, such as commonly used short-run and long-run restrictions, can be tested, which is a particularly convenient feature of the non-Gaussian SVAR model.

We illustrated the new methods in an empirical application to the relationship between the U.S. stock market and monetary policy. In previous studies, the instantaneous impact of a monetary policy shock on the stock market has either been precluded at the outset or found relatively minor or insignificant. In contrast, we found the monetary policy shock to have a negative significant instantaneous impact on the stock market. Moreover, we were able to clearly reject the recursive identification scheme precluding an instantaneous impact of the monetary policy shock on the stock market, employed in part of the previous literature.

Several future research topics could be entertained. In this paper we have considered only stationary VAR models and an extension to a vector error correction framework would be of interest. As noted in [Appendix A,](#page-11-0) the identification results we present also hold true with conditionally heteroskedastic errors, an issue that could be explored further. Finally, as the estimation theory we develop in the paper requires one to specify a non-Gaussian error distribution, quasi-maximum likelihood or semiparametric methods might provide useful alternatives.
