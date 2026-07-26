![](_page_0_Picture_1.jpeg)

Contents lists available at [ScienceDirect](http://www.elsevier.com/locate/jeconom)

# Journal of Econometrics

journal homepage: [www.elsevier.com/locate/jeconom](http://www.elsevier.com/locate/jeconom)

![](_page_0_Picture_5.jpeg)

# Identification and estimation of non-Gaussian structural vector autoregressions[✩](#page-0-0)

![](_page_0_Picture_7.jpeg)

Markku Lanne [a](#page-0-1)[,b](#page-0-2) , Mika Meitz [a](#page-0-1) , Pentti Saikkonen[c,](#page-0-3)[∗](#page-0-4)

- <span id="page-0-1"></span><sup>a</sup> *Department of Political and Economic Studies, University of Helsinki, P. O. Box 17, FI–00014 University of Helsinki, Finland*
- <span id="page-0-2"></span><sup>b</sup> *CREATES, Denmark*
- <span id="page-0-3"></span><sup>c</sup> *Department of Mathematics and Statistics, University of Helsinki, P. O. Box 68, FI–00014 University of Helsinki, Finland*

## a r t i c l e i n f o

*Article history:* Received 15 April 2015 Received in revised form 12 January 2016 Accepted 6 June 2016 Available online 14 October 2016

*JEL classification:*

C32

C51 E52

*Keywords:* Structural vector autoregressive model Identification Impulse responses Non-Gaussianity

# a b s t r a c t

Conventional structural vector autoregressive (SVAR) models with Gaussian errors are not identified, and additional identifying restrictions are needed in applied work. We show that the Gaussian case is an exception in that a SVAR model whose error vector consists of independent non-Gaussian components is, without any additional restrictions, identified and leads to essentially unique impulse responses. Building upon this result, we introduce an identification scheme under which the maximum likelihood estimator of the parameters of the non-Gaussian SVAR model is consistent and asymptotically normally distributed. As a consequence, additional economic identifying restrictions can be tested. In an empirical application, we find a negative impact of a contractionary monetary policy shock on financial markets, and clearly reject the commonly employed recursive identifying restrictions.

© 2016 The Author(s). Published by Elsevier B.V. This is an open access article under the CC BY-NC-ND license [\(http://creativecommons.org/licenses/by-nc-nd/4.0/\)](http://creativecommons.org/licenses/by-nc-nd/4.0/).

# **1. Introduction**

Vector autoregressive (VAR) models are widely employed in empirical macroeconomic research, and they have also found applications in other fields of economics and finance. While the reduced-form VAR model can be seen as a convenient description of the joint dynamics of a number of time series that also facilitates forecasting, the structural VAR (SVAR) model is more appropriate for answering economic questions of theoretical and practical interest. The main tools in analyzing the dynamics in SVAR models are the impulse response function and the forecast error variance decomposition. The former traces out the future effects of an economic shock on the variables included in the model, while the latter gives the relative importance of each shock for each variable.

*E-mail addresses:* [markku.lanne@helsinki.fi](mailto:markku.lanne@helsinki.fi) (M. Lanne), [mika.meitz@helsinki.fi](mailto:mika.meitz@helsinki.fi) (M. Meitz), [pentti.saikkonen@helsinki.fi](mailto:pentti.saikkonen@helsinki.fi) (P. Saikkonen).

In order to apply these tools, the economic shocks (or at least the interesting subset of them) must be identified. Traditionally short-run and long-run restrictions, constraining the immediate and permanent impact of certain shocks, respectively, have been entertained, while recently alternative approaches, including sign restrictions and identification based on heteroskedasticity, have been introduced.

When SVAR models are applied, the joint distribution of the error terms is almost always (either explicitly or implicitly) assumed to have a multivariate Gaussian (normal) distribution. This means that the joint distribution of the reduced-form errors is fully determined by their covariances only. A well-known consequence of this is that the structural errors cannot be identified – any orthogonal transformation of them would do equally well – without some additional information or restrictions. This raises the question of the potential benefit of SVAR models with non-Gaussian errors whose joint distribution is not determined by the (first and) second moments only and which may therefore contain more useful information for identification of the structural shocks.

In this paper, we show that the Gaussian case is an exception in that SVAR models with (suitably defined) non-Gaussian errors are identified without any additional identifying restrictions. In the non-Gaussian SVAR model we consider, identification is

<span id="page-0-0"></span><sup>✩</sup> The authors thank the Academy of Finland (grant number 268454), Finnish Cultural Foundation, and Yrjö Jahnsson Foundation for financial support. The first author also acknowledges financial support from CREATES (DNRF78) funded by the Danish National Research Foundation. Useful comments made by the Associate Editor and two anonymous referees have helped to improve the paper.

<span id="page-0-4"></span><sup>∗</sup> Corresponding author.

achieved by assuming mutual independence across the non-Gaussian error processes. The paper contains two identification results, the first of which allows the computation of (essentially) unique impulse responses. Identification is 'statistical' but not 'economic' in the sense that the resulting impulse responses and structural shocks carry no economic meaning as such; for interpretation, additional information is needed to endow the structural shocks with economic labels. Second, we obtain a complete identification result that facilitates developing an asymptotic theory of maximum likelihood (ML) estimation. A particularly useful consequence of this second result is that economic restrictions which are under-identifying or exactlyidentifying in the conventional Gaussian set-up become testable. This is in sharp contrast to traditional identification approaches based on short-run and long-run economic restrictions which require the tested restrictions to be over-identifying (and finding even convincing exactly-identifying restrictions may be difficult). Moreover, sign restrictions, popular in the current SVAR literature, cannot be tested either (see, e.g., Fry and Pagan, 2011).

Compared to the previous literature on identification in SVAR models exploiting non-Gaussianity, our approach is quite general. Similarly to us, Hyvärinen et al. (2010) and Moneta et al. (2013) also assume independence and non-Gaussianity, but, in addition, they impose a recursive structure, which in our model only obtains as a special case. Lanne and Lütkepohl (2010) assume that the error term of the SVAR model follows a mixture of two Gaussian distributions, whereas our model allows for a wide variety of (non-Gaussian) distributions. Identification by explicitly modeling conditional heteroskedasticity of the errors in various forms, considered by Normandin and Phaneuf (2004), Lanne et al. (2010), and Lütkepohl and Netšunajev (2014b), is also covered by our approach. In fact, identification by unconditional heteroskedasticity (see, e.g., Rigobon, 2003) is the only approach in the previous literature we do not cover.

We apply our SVAR model to examining the impact of monetary policy in financial markets. There is a large related literature that for the most part relies on Gaussian SVAR models identified by short-run restrictions. While empirical results vary depending on the data and identification schemes, typically a monetary policy shock is not found to account for a major part of the variation of stock returns. This is counterintuitive and goes contrary to recent theoretical results (see Castelnuovo, 2013 and the references therein). Our model, with the errors assumed to follow independent Student's *t*-distributions, is shown to fit recent U.S. data well, and we find a strong negative, yet short-lived, impact of a contractionary monetary policy shock on financial conditions, as recent macroeconomic theory predicts. Moreover, the recursive identification restrictions employed in much of the previous literature are clearly rejected.

The rest of the paper is organized as follows. In Section 2, we introduce the SVAR model. Section 3 contains the identification results. First we show how identification needed for the computation of impulse responses is achieved and then how to obtain complete identification needed in Section 4 where we develop an asymptotic estimation theory and establish the consistency and asymptotic normality of the maximum likelihood (ML) estimator of the parameters of our model. In addition, a three-step estimator is proposed that may be useful in cases where full ML estimation is cumbersome due to short time series or the high dimension of the model. As both estimators have conventional asymptotic normal distributions, standard tests (of, e.g., additional economic identifying restrictions) can be carried out in the usual manner. An empirical application to the effect of U.S. monetary policy in financial markets is presented in Section 5, and Section 6 concludes.

Finally, a few notational conventions are given. All vectors will be treated as column vectors and, for the sake of uncluttered notation, we shall write  $x = (x_1, \ldots, x_n)$  for the (column) vector x where the components  $x_i$  may be either scalars or vectors (or both). For any vector or matrix x, the Euclidean norm is denoted by ||x||. The vectorization operator vec(A) stacks the columns of matrix A on top of one another. Kronecker and Hadamard (elementwise) products of matrices are denoted by  $\otimes$  and  $\odot$ , respectively. Notation  $t_i$  is used for the ith canonical unit vector of  $\mathbb{R}^n$  (i.e., an n-vector with 1 in the ith coordinate and zeros elsewhere),  $i = 1, \ldots, n$  (the dimension n will be clear from the context). An identity matrix of order n will be denoted by  $t_n$ .

#### <span id="page-1-0"></span>2. Model

<span id="page-1-1"></span>Consider the structural VAR (SVAR) model

$$y_t = \nu + A_1 y_{t-1} + \dots + A_p y_{t-p} + B\varepsilon_t, \tag{1}$$

where  $y_t$  is the n-dimensional time series of interest,  $\nu$  ( $n \times 1$ ) is an intercept term,  $A_1, \ldots, A_p$  and B ( $n \times n$ ) are parameter matrices with B nonsingular, and  $\varepsilon_t$  ( $n \times 1$ ) is a temporally uncorrelated strictly stationary error term with zero mean and finite positive definite covariance matrix (more specific assumptions about the covariance matrix will be made later). As we only consider stationary (or stable) time series, we assume

<span id="page-1-4"></span>
$$\det A(z) \stackrel{\text{def}}{=} \det \left( I_n - A_1 z - \dots - A_p z^p \right) \neq 0,$$

$$|z| \leq 1 \ (z \in \mathbb{C}). \tag{2}$$

Left-multiplying (1) by the inverse of *B* yields an alternative formulation of the SVAR model,

$$A_0 y_t = \nu^{\bullet} + A_1^{\bullet} y_{t-1} + \dots + A_p^{\bullet} y_{t-p} + \varepsilon_t, \tag{3}$$

<span id="page-1-2"></span>where  $\varepsilon_t$  is as in (1),  $A_0 = B^{-1}$ ,  $v^{\bullet} = B^{-1}v$ , and  $A_j^{\bullet} = B^{-1}A_j$  ( $j = 1, \ldots, p$ ). Typically the diagonal elements of  $A_0$  are normalized to unity, so that the model becomes a conventional simultaneous-equations model. In this paper, we shall not consider formulation (3) in detail.

The literature on SVAR models is voluminous (for a recent survey, see Kilian (2013)). A central problem with these models is the identification of the parameter matrix B: without additional assumptions or prior knowledge, B cannot be identified because, for any nonsingular  $n \times n$  matrix C, the matrix B and the error term  $E_t$  in the product  $E_t$  can be replaced by  $E_t$  and  $E_t$  respectively, without changing the assumptions imposed above on model (1). This identification problem has serious implications on the interpretation of the model via impulse response functions that trace out the impact of economic shocks (i.e., the components of the error term  $E_t$ ) on current and future values of the variables included in the model. Impulse responses are elements of the coefficient matrices  $E_t$ 0 in the moving average representation of the model.

<span id="page-1-3"></span>
$$y_t = \mu + \sum_{i=0}^{\infty} \Psi_j B \varepsilon_{t-j}, \quad \Psi_0 = I_n, \tag{4}$$

where  $\mu = A(1)^{-1} \nu$  is the expectation of  $y_t$  and the matrices  $\Psi_j$  ( $j=0,1,\ldots$ ) are determined by the power series  $\Psi$  (z) =  $A(z)^{-1} = \sum_{j=0}^{\infty} \Psi_j z^j$ . As the preceding discussion makes clear, for a meaningful interpretation of such an analysis, an appropriate identification result is needed to make the two factors in the product  $B\varepsilon_t$ , and hence the impulse responses  $\Psi_i B$ , unique.

So far we have only made very general assumptions about the SVAR model, implying uniqueness only up to linear transformations of the form  $B \to BC$  and  $\varepsilon_t \to C^{-1}\varepsilon_t$  with C nonsingular. In SVAR models of the type (1), the covariance matrix of the error term is typically restricted to a diagonal matrix so that the transformation matrix C has to be of the form C = DO with O orthogonal

and D diagonal and nonsingular. The diagonal elements of D are either +1 or -1 if the covariance matrix of  $\varepsilon_t$  is assumed an identity matrix, while in the absence of such a normalization, the diagonal elements of D are not restricted (except to be nonzero). Thus, further assumptions are needed to achieve identifiability, and probably the most common way of achieving identifiability is to impose short-run restrictions that restrict some of the elements of B to zero. In the best known example of this approach, the matrix B is restricted to a lower triangular matrix which can be identified as a Cholesky factor of the covariance matrix of the error term  $B\varepsilon_t$ . This solves the identification problem, but it imposes a recursive structure upon the variables included in  $v_t$  that may be implausible. This example also illustrates what seems to be an inherent difficulty in using short-run restrictions: one basically tries to solve the identification problem by using only the covariance matrix of the error term. Nevertheless, following Sims's (1980) seminal paper, recursive identification dominated the early econometric SVAR literature.

The SVAR model (1) is also a special case of a simultaneous vector ARMAX model where identification results based only on knowledge of second order moments have been obtained by Kohn (1979), Hannan and Deistler (1988), and others. Similarly to these previous authors, we use the term 'class of observationally equivalent SVAR processes' to refer to SVAR processes satisfying the assumptions made of (1) with the matrix B and the error term  $\varepsilon_t$  replaced by BC and  $C^{-1}\varepsilon_t$  with C a nonsingular matrix (in the same way we shall speak of classes of observationally equivalent moving average representations). Then the identification problem boils down to finding conditions which imply that the only possible choice for the matrix C is an identity matrix and thus that the matrix B and the error term  $\varepsilon_t$  are unique.

As already indicated, successful identification results may be difficult to obtain without strengthening the assumptions so far imposed on the error term  $\varepsilon_t$ . In this paper, we consider model (1) where, similarly to Hyvärinen et al. (2010) and Moneta et al. (2013), the components of the error term are assumed contemporaneously independent.

## <span id="page-2-0"></span>3. Identification

# 3.1. Non-Gaussian errors

We assume that the error process  $\varepsilon_t = (\varepsilon_{1,t}, \dots, \varepsilon_{n,t})$  has non-Gaussian components that are independent both contemporaneously and temporally. Specifically, we make the following assumption.

- <span id="page-2-1"></span>**Assumption 1.** (i) The error process  $\varepsilon_t = (\varepsilon_{1,t}, \dots, \varepsilon_{n,t})$  is a sequence of independent and identically distributed random vectors with each component  $\varepsilon_{i,t}$ ,  $i = 1, \dots, n$ , having zero mean and finite positive variance  $\sigma_i^2$ .
- (ii) The components of  $\varepsilon_t = (\varepsilon_{1,t}, \dots, \varepsilon_{n,t})$  are (mutually) independent and at most one of them has a Gaussian marginal distribution.

Compared with assumptions made in the previous literature, Assumption 1 is similar to its counterparts in Hyvärinen et al. (2010) and Moneta et al. (2013). The conditions imposed in Assumption 1(i) are rather standard. Assumption 1(ii) restricts the interdependence of the components of the error process. The vector process  $\varepsilon_t$  is assumed non-Gaussian, but the possibility that (at most) one of its components is Gaussian is permitted. Note that in this non-Gaussian case, independence is a much stronger requirement than mere uncorrelatedness. Nevertheless, as also stressed by Gouriéroux and Monfort (2014, Sec. 3), (contemporaneous) independence is the appropriate concept of

orthogonality in SVAR analysis, and it should be required also in the non-Gaussian case. (In the conventional Gaussian set-up, Assumption 1(ii) is not imposed directly, but independence of the component processes obtains because  $\varepsilon_t$  is assumed to be independent and identically normally distributed with mean zero and a diagonal covariance matrix.)

In Appendix A we introduce an alternative, weaker Assumption 1\* that allows the error process to be temporally dependent (though temporal uncorrelatedness is still required). In particular, conditionally heteroskedastic error processes that have recently been used to achieve identifiability in SVAR models (see, e.g., Lütkepohl and Netšunajev (2014b) and the references therein) are covered. All the identification results in Section 3 hold true also under this weaker assumption. For details, see the discussion in Appendix A.

## <span id="page-2-5"></span>3.2. Identification up to permutations and scalings

In this section, we explain how non-Gaussianity aids in solving the identification problem discussed in Section 2. As impulse response analysis constitutes a major application of the SVAR model, we consider the identification of the moving average representation (4). Under Assumption 1, this representation is essentially unique in the following sense (the subsequent arguments will be formalized and proved in Proposition 1): If the process  $y_t$  can be represented by two (potentially) different moving average representations, say,

<span id="page-2-4"></span>
$$y_t = \mu + \sum_{i=0}^{\infty} \Psi_j B \varepsilon_{t-j} = \mu^* + \sum_{i=0}^{\infty} \Psi_j^* B^* \varepsilon_{t-j}^*, \tag{5}$$

then necessarily  $\mu^* = \mu$ ,  $\Psi_j^* = \Psi_j$   $(j = 0, 1, \ldots)$ , and  $B\varepsilon_t = B^*\varepsilon_t^*$  for all t, but the choice of the matrix B and the error process  $\varepsilon_t$  is not unique: As discussed in Section 2, the choice  $B^* = BC$  and  $\varepsilon_t^* = C^{-1}\varepsilon_t$  will do for any nonsingular  $n \times n$  matrix C. In the conventional Gaussian set-up, the discussion in Section 2 applies and the aforementioned (nonsingular) matrix C is of the form C = DO with O orthogonal and D diagonal, so that an identification problem remains. However, assuming non-Gaussianity and independence (in the sense of Assumption 1) we can restrict the orthogonal matrix O in the product C = DO to a permutation matrix so that only permutations and scale changes in the columns of B are allowed. This constitutes a considerable improvement and forms the first step in achieving complete identification which is the topic of the next subsection.

The preceding discussion is formalized in the following proposition, whose proof is given in Appendix  ${\bf A.}^1$ 

<span id="page-2-2"></span>**Proposition 1.** Consider the SVAR model (1) and assume that the stationarity condition (2) and Assumption 1 (or Assumption  $1^*$  in Appendix A) on the error term  $\varepsilon_t$  are satisfied. Suppose the two moving average representations in (5) hold true

- (i) for some parameters  $\mu^*$  (n  $\times$  1) and  $B^*$  (n  $\times$  n) with  $B^*$  nonsingular,
- (ii) for some coefficient matrices  $\Psi_j^*$   $(n \times n)$ ,  $j = 0, 1, \ldots$ , that are determined by the power series  $\Psi^*(z) = A^*(z)^{-1} = \sum_{j=0}^{\infty} \Psi_j^* z^j$  with  $A^*(z) = I_n A_1^* z \cdots A_p^* z^p$  satisfying condition (2) (with  $A_j$  therein replaced by  $A_j^*$ ,  $j = 1, \ldots, p$ ), and
- (iii) for some error process  $\varepsilon_t^* = (\varepsilon_{1,t}^*, \dots, \varepsilon_{n,t}^*)$  satisfying Assumption 1 or 1\* (with each ' $\varepsilon$ ' therein replaced by ' $\varepsilon$ \*').

<span id="page-2-3"></span><sup>&</sup>lt;sup>1</sup> This proposition can be specialized to formulation (3) by setting  $B = A_0^{-1}$ ,  $\nu = A_0^{-1} \nu^{\bullet}$ , and  $A_j = A_0^{-1} A_j^{\bullet}$  ( $j = 1, \ldots, p$ ) in model (1).

Then, for some diagonal matrix  $D = diag(d_1, ..., d_n)$  with nonzero diagonal elements, for some permutation matrix  $P(n \times n)$ , and for all t.

$$B^* = BDP, \quad \varepsilon_t^* = P'D^{-1}\varepsilon_t, \quad \mu^* = \mu, \quad and$$
  
 $\Psi_j^* = \Psi_j \quad (j = 0, 1, ...).$  (6)

Variants of Proposition 1 have appeared in the previous literature. For instance, in the independent component analysis literature, reference can be made to Theorem 11 and its corollaries in Comon (1994) that are very similar, although formulated for the case corresponding to a serially uncorrelated process, i.e.,  $y_t = v + B\varepsilon_t$ . A related result in the statistics literature is Theorem 4 of Chan and Ho (2004) (a discussion of this theorem can also be found in Chan et al. (2006)) and, recently, also Gouriéroux and Monfort (2014, Proposition 2) and Gouriéroux and Zakoïan (2015, Proposition 6) have presented counterparts of Proposition 1.

Proposition 1 does not provide a complete solution to the identification problem. It only shows that the moving average representation (4) and its SVAR counterpart (1) are unique apart from permutations and scalings of the columns of B and the components of  $\varepsilon_t$ ; uniqueness of the expectation  $\mu$  and the coefficients  $\Psi_j$ ,  $j=0,1,\ldots$ , or, equivalently, the intercept term  $\nu$  and the autoregressive parameters  $A_1,\ldots,A_p$  obtains, however. Using the terminology introduced in Section 2, Proposition 1 characterizes a class of observationally equivalent SVAR processes and the corresponding moving average representations: The moving average representations in (5) are observationally equivalent (and hence members of this class) if they satisfy the equations in (6). The same, of course, applies to the corresponding SVAR processes, i.e., (1) and  $y_t = \nu^* + A_1^* y_{t-1} + \cdots + A_p^* y_{t-p} + B^* \varepsilon_t^*$  (but now the last two equations in (6) are replaced by  $\nu = \nu^*$  and  $A_i = A_i^*$ ,  $i = 1, \ldots, p$ ).

From the viewpoint of computing impulse responses (and forecast error variance decompositions), identification up to permutations and scalings is sufficient. Upon such identification of the SVAR model, labeling the shocks is in any case based on outside information, such as sign restrictions, or conventional identifying short-run or long-run restrictions (see, e.g., Lütkepohl and Netšunajev (2014a)), and the sign and size of the shocks are set by the researcher. For these purposes, any permutation and scaling are equally useful. However, development of conventional statistical estimation theory, in particular, calls for a complete solution to the identification problem.

## <span id="page-3-6"></span>3.3. Complete identification

In this section, we provide formal identifying or normalizing restrictions that remove the indeterminacy due to scaling and permutation in Proposition 1. One set of such conditions, employed in the context of independent component analysis, can be found in Ilmonen and Paindaveine (2011) (see also Hallin and Mehta (2015)); for potential alternative conditions, see, e.g., Pham and Garat (1997) and Chen and Bickel (2005). In the case of Proposition 1 these conditions are specified as follows.

To express the result, let  $\mathcal{M}_n$  denote the set of nonsingular  $n \times n$  matrices. We say that two matrices  $B_1$  and  $B_2$  in  $\mathcal{M}_n$  are equivalent, expressed as  $B_1 \sim B_2$ , if and only if they are related as  $B_2 = B_1DP$  for some diagonal matrix  $D = diag(d_1, \ldots, d_n)$  with nonzero diagonal elements and some permutation matrix P. The equivalence relation  $\sim$  partitions  $\mathcal{M}_n$  into equivalence classes, and

<span id="page-3-0"></span>each of these equivalence classes defines a set of observationally equivalent SVAR processes. Using this terminology, Proposition 1 and the discussion following it state that while a specific equivalence class for *B* is identifiable, any member from this equivalence class can be used as a *B* and also used to define a member from the corresponding set of observationally equivalent SVAR processes. Our next aim is to pinpoint a particular (unique) member from the equivalence class indicated by Proposition 1. We collect the description of how this can be done in the following 'Identification Scheme' (whose content is adapted from Ilmonen and Paindaveine (2011) and Hallin and Mehta (2015)).

**Identification Scheme.** For each  $B \in \mathcal{M}_n$ , consider the sequence of transformations

$$B \rightarrow BD_1 \rightarrow BD_1P \rightarrow BD_1PD_2$$
,

where, whenever such  $n \times n$  matrices  $D_1$ , P, and  $D_2$  exist,

- (i) D<sub>1</sub> is the positive definite diagonal matrix that makes each column of BD<sub>1</sub> have Euclidean norm one,
- (ii) *P* is the permutation matrix for which the matrix  $C = (c_{ij}) = BD_1P$  satisfies  $|c_{ii}| > |c_{ij}|$  for all i < j, and
- (iii) D<sub>2</sub> is the diagonal matrix such that all diagonal elements of BD<sub>1</sub>PD<sub>2</sub> are equal to one.

Let  $\mathcal{L} \subseteq \mathcal{M}_n$  be the set consisting of those  $B \in \mathcal{M}_n$  for which the matrices  $D_1$ , P, and  $D_2$  above exist, and  $\mathcal{E} = \mathcal{M}_n \setminus \mathcal{L}$  the complement of this set in  $\mathcal{M}_n$ .  $\mathcal{L}$  Define the transformation  $\Pi(\cdot): \mathcal{L} \to \mathcal{L}$  as  $\Pi(B) = BD_1PD_2$  with  $D_1$ , P, and  $D_2$  as above,  $\mathcal{L}$  and define the set  $\mathcal{L}$  as

$$\mathcal{B} = \Pi(\mathcal{X}) = \{\tilde{B} \in \mathcal{M}_n : \tilde{B} = \Pi(B) \text{ for some } B \in \mathcal{X}\}.$$

This scheme provides a recipe for picking a particular permutation and a particular scaling to identify a unique matrix *B* from each equivalence class corresponding to observationally equivalent SVAR processes. Therefore, the scheme provides a solution to the identification problem in the sense formalized in the following proposition (which is justified in Appendix A).

<span id="page-3-5"></span>**Proposition 2.** (a) Under the assumptions of Proposition 1, the matrix B is uniquely identified in the set B defined in the Identification Scheme.<sup>5</sup>

- (b) The set B consists of unique, distinct representatives from each ~-equivalence class of 1.
- (c) The set  $\mathscr{E}$  (of matrices being excluded in the Identification Scheme) has Lebesgue measure zero in  $\mathbb{R}^{n \times n}$ , and the set  $\mathscr{L}$  (of matrices being included in the Identification Scheme) contains an open and dense subset of  $\mathscr{M}_n$ .

According to part (a) of Proposition 2, unique identification is achieved by restricting the permissible values of the matrix B to the set  $\mathcal{B} = \Pi(\mathcal{I})$  defined in the Identification Scheme, while parts (b) and (c) of the proposition explain in further detail what exactly is achieved. According to part (b), the set  $\mathcal{B}$  is suitably defined: no two observationally equivalent SVAR processes are represented in  $\mathcal{B}$ , while nearly all observationally non-equivalent SVAR processes are represented in  $\mathcal{B}$ . Part (c) explains the quantifier 'nearly all': A small number of SVAR processes, namely those corresponding

<span id="page-3-1"></span><sup>&</sup>lt;sup>2</sup> Note that  $DP = PD_1$  for some scaling matrix  $D_1$  so that the order of the permutation and scaling matrix does not matter for the defined equivalence; from this fact it can also be seen that the relation  $B_1 \sim B_2$  is transitive and, as it is clearly symmetric and reflexive, it really is an equivalence relation.

<span id="page-3-2"></span><sup>&</sup>lt;sup>3</sup> That is,  $\mathcal{E}$  is the set of those matrices  $B \in \mathcal{M}_n$  for which a tie occurs in step (ii) in the sense that for any choice of P we have  $|c_{ii}| = |c_{ij}|$  for some i < j, or for which at least one diagonal element of  $BD_1P$  equals zero so that step (iii) cannot be done.

<span id="page-3-3"></span><sup>&</sup>lt;sup>4</sup> The matrices  $D_1$ , P, and  $D_2$  depend on B, but we do not make this dependence explicit.

<span id="page-3-4"></span><sup>&</sup>lt;sup>5</sup> In the sense that if B,  $B^* \in \mathcal{B}$  are as in Proposition 1, then necessarily  $D = P = I_n$  in (6) so that  $B = B^*$ .

to the set  $\mathcal{E}$ , have to be excluded from consideration, but as these processes only comprise a set of measure zero, ignoring them is hardly relevant in practice; moreover, the set  $\mathcal{L}$  corresponding to those SVAR processes that are included in the Identification Scheme is 'large' in the sense that  $\mathcal{L}$  contains an open and dense subset of  $\mathcal{M}_n$ . Some further remarks on this result and the Identification Scheme are in order.

First, some illustrative examples of the Identification Scheme. The sequence of transformations  $B \to BD_1 \to BD_1P \to BD_1PD_2$  for a particular four-dimensional matrix B is

$$\begin{bmatrix} 2\sqrt{2}\sqrt{3}\sqrt{2} & 0 \\ 2 & 0 & 0 & \sqrt{3} \\ 2 & 1 & 0 & 0 \\ 0 & 0 & \sqrt{2} & 1 \end{bmatrix} \rightarrow \begin{bmatrix} 1/\sqrt{2}\sqrt{3}/2 & 1/\sqrt{2} & 0 \\ 1/2 & 0 & 0 & \sqrt{3}/2 \\ 1/2 & 1/2 & 0 & 0 \\ 0 & 0 & 1/\sqrt{2} & 1/2 \end{bmatrix}$$
$$\rightarrow \begin{bmatrix} \sqrt{3}/2 & 0 & 1/\sqrt{2} & 1/\sqrt{2} \\ 0 & \sqrt{3}/2 & 1/2 & 0 \\ 1/2 & 0 & 1/2 & 0 \\ 0 & 1/2 & 0 & 1/\sqrt{2} \end{bmatrix} \rightarrow \begin{bmatrix} 1 & 0 & \sqrt{2} & 1 \\ 0 & 1 & 1 & 0 \\ 1/\sqrt{3} & 0 & 1 & 0 \\ 0 & 1/\sqrt{3} & 0 & 1 \end{bmatrix},$$

where the last matrix is the unique representative of its equivalence class in  $\mathcal{B}$ . To illustrate the matrices that belong to the set  $\mathcal{E}$ , note that they can be divided into three groups: (1) a tie occurs in step (ii) of the Identification Scheme with the members of the tie being nonzero, (2) a tie occurs in step (ii) of the Identification Scheme with the members of the tie equaling zero, and (3) no ties occur in step (ii) of the Identification Scheme but the lower-right-hand-corner element of  $BD_1P$  equals zero. Simple examples of these three possibilities (in a four-variable SVAR model) are

$$B_{1} = \begin{bmatrix} 1/2 & 1/2 & 0 & 0 \\ 0 & \sqrt{3}/2 & 0 & 0 \\ \sqrt{3}/2 & 0 & 1 & 0 \\ 0 & 0 & 0 & 1 \end{bmatrix},$$

$$B_{2} = \begin{bmatrix} \sqrt{3}/2 & 0 & 1/\sqrt{2} & 1/\sqrt{2} \\ 0 & \sqrt{3}/2 & 1/\sqrt{2} & 0 \\ 1/2 & 0 & \mathbf{0} & \mathbf{0} \\ 0 & 1/2 & 0 & 1/\sqrt{2} \end{bmatrix},$$

$$B_{3} = \begin{bmatrix} 1 & 0 & 0 & 0 \\ 0 & 1 & 0 & 1/\sqrt{2} \\ 0 & 0 & \sqrt{3}/2 & 1/\sqrt{2} \\ 0 & 0 & 1/2 & \mathbf{0} \end{bmatrix},$$

where the 'critical' elements are in bold font. Note that excluding the matrices in  $\mathcal{E}$  would be problematic only if these matrices corresponded to common hypotheses of interest one would like to test in SVAR models, which does not appear to be the case.<sup>6</sup>

Second, the set  $\mathscr E$  having measure zero and  $\mathscr L$  containing an open and dense subset of  $\mathscr M_n$  indeed mean that almost all SVAR processes are being included. According to the terminology used by some authors, the matrix  $\mathscr B$  would be 'generically identified' in case it were identified in this open and dense subset  $\mathscr L$  of the parameter space of interest,  $\mathscr M_n$ ; see, e.g., Anderson et al. (2016) for the use of this terminology in the context of VAR models, or Johansen (1995) in a cointegrated VAR model. It is also worth noting that the excluded matrices in  $\mathscr E$  are in no way 'ill-behaving'; their exclusion is done for purely technical reasons to make the formulation of the Identification Scheme easy. It would be possible to devise a scheme in a way that no exclusions are needed, but such a scheme would be rather complex and its implementation

would presumably be difficult in practice. Rather than pursuing this matter we are therefore content with Proposition 2 as a 'second best' result to full identification.

Third, as the preceding discussion suggests, one can similarly obtain identifiability by using some alternative formulation of the Identification Scheme. One relevant alternative is obtained if the definitions of  $D_1$  and P in the Identification Scheme are maintained but  $D_2$  is defined as the diagonal matrix whose diagonal elements equal either 1 or -1 and which makes the diagonal elements of  $BD_1PD_2$  positive. The restrictions implied by this alternative identification scheme may be easier to take into account in estimation than those based on the original Identification Scheme. On the other hand, the original Identification Scheme is more convenient in deriving asymptotic distributions for estimators; in the alternative scheme just described, one would need to employ Lagrange multipliers as the columns of  $BD_1PD_2$  would then have Euclidean norm one.

Fourth, as already alluded to in Section 3.2, the Identification Scheme and Proposition 2 only yield statistical identification which need not have any economic interpretation. In particular, they do not offer any information about which economic shock each component of  $\varepsilon_t$  might be. The statistical identification result obtained does, however, facilitate the development of conventional estimation theory, the topic of Section 4.

## 3.4. Discussion of previous identification results

There are a number of statistical identification procedures for SVAR models introduced in the previous literature that are more or less closely related to the procedure put forth in this paper. Hyvärinen et al. (2010) and Moneta et al. (2013) consider identification in SVAR models and, similarly to us, assume that the error terms are non-Gaussian and mutually independent. Their identification condition is explicitly stated for model (3), but it, of course, applies to model (1) as well (an analog of our Proposition 2 could also be formulated for model (3)). Compared to us, an essential difference is that they assume the matrix  $A_0$  in model (3), or equivalently the matrix B in model (1), to be lower triangular (potentially after reordering the variables in  $y_t$ ). This is a rather stringent and potentially undesirable a priori assumption, as it imposes a recursive structure on the SVAR model. Hence, our result is more general, yet allowing for a recursive structure as a special case.

Lanne and Lütkepohl (2010) assume that the errors of model (1) are independent over time with a distribution that is a mixture of two Gaussian distributions with zero means and diagonal covariance matrices, one of which is an identity matrix and the other one has positive diagonal elements, which for identifiability have to be distinct. Under these conditions, identifiability is obtained apart from permutations of the columns of *B* and multiplication by minus one. If the above-mentioned positive diagonal elements are ordered in some specific way, say from largest to smallest, the indeterminacy due to permutations of the columns of *B* is removed and unique identification is achieved. Thus, their identification result differs from ours mainly in that a specific non-Gaussian error distribution is employed, and its components are contemporane-ously only uncorrelated, not independent.

Assuming some form of heteroskedasticity of the errors  $\varepsilon_t$  is one popular approach to identification. Lanne et al. (2010), and Lütkepohl and Netšunajev (2014b) assume Markov switching and a smooth transition in the covariance matrix of the error term  $\varepsilon_t$  in model (1), respectively, while Normandin and Phaneuf (2004) allow for GARCH-type heteroskedasticity in the errors. As is explained in Appendix A, our approach also covers these cases in that the identification results hold under conditional heteroskedasticity that necessarily implies non-Gaussianity of the errors. In contrast, identification by unconditional heteroskedasticity that has also been entertained in the recent SVAR literature (see, e.g., Rigobon (2003) and Lanne and Lütkepohl (2008)) is not covered.

<span id="page-4-0"></span><sup>&</sup>lt;sup>6</sup> The hypothesis implied by the matrix  $B_1$  appears to be of interest only when the shocks  $\varepsilon_{1,t}$  and  $\varepsilon_{2,t}$  are of the same size so that the rather specific additional restriction  $\sigma_1^2 = \sigma_2^2$  must also hold. As to the zero restrictions implied by the matrices  $B_2$  and  $B_3$ , they do not seem economically interesting.

#### <span id="page-5-0"></span>4. Parameter estimation
