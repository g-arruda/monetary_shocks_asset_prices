## Accepted Manuscript

Statistical inference for independent component analysis: Application to structural VAR models

Christian Gourieroux, Alain Monfort, Jean-Paul Renne ´

PII: S0304-4076(16)30174-9

DOI: <http://dx.doi.org/10.1016/j.jeconom.2016.09.007>

Reference: ECONOM 4303

To appear in: *Journal of Econometrics*

Received date: 28 June 2015

Revised date: 14 September 2016 Accepted date: 15 September 2016

![](_page_0_Picture_9.jpeg)

Please cite this article as: Gourieroux, C., Monfort, A., Renne, J.-P., Statistical inference for ´ independent component analysis: Application to structural VAR models. *Journal of Econometrics* (2016), http://dx.doi.org/10.1016/j.jeconom.2016.09.007

This is a PDF file of an unedited manuscript that has been accepted for publication. As a service to our customers we are providing this early version of the manuscript. The manuscript will undergo copyediting, typesetting, and review of the resulting proof before it is published in its final form. Please note that during the production process errors may be discovered which could affect the content, and all legal disclaimers that apply to the journal pertain.

# Statistical Inference for Independent Component Analysis: Application to Structural VAR Models

Christian GOURIÉROUX∗ , Alain MONFORT† , Jean-Paul RENNE‡

(September 2016, revised version)

#### Abstract

The well-known problem of non-identifiability of structural VAR models disappears if the structural shocks are independent and if at most one of them is Gaussian. In that case, the relevant estimation technique is the Independent Component Analysis (ICA). Since the introduction of ICA by Comon (1994), various semi-parametric estimation methods have been proposed for "orthogonalizing" the error terms. These methods include pseudo maximum likelihood (PML) approaches and recursive PML. The aim of our paper is to derive the asymptotic properties of the PML approaches, in particular to study their consistency. We conduct Monte Carlo studies exploring the relative performances of these methods. Finally, an application based on real data shows that structural VAR models can be estimated without additional identification restrictions in the non-Gaussian case and that the usual restrictions can be tested.

JEL Codes: C14, C32.

Key-words: Independent Component Analysis, Pseudo Maximum Likelihood, Identification, Cayley Transform, Structural Shocks, Structural VAR , Impulse Response Functions.

The first two authors gratefully acknowledge support of the chair LCL: "New Challenges for New Data", of the LABEX: Finance et Croissance Durable, and of the chair ACPR on "Regulation and Systemic Risk". We are grateful to participants to the 2016 European Meeting of the Econometric Society.

<sup>∗</sup>CREST and University of Toronto, christian.gourieroux@ensae

<sup>†</sup>Corresponding author. CREST, alain.monfort@ensae.fr

<sup>‡</sup>University of Lausanne, jeanpaul.renne@unil.ch

## 1 Introduction

Let us consider *n* observed variables *Y* = (*y*1,..., *yn*) 0 , which are linear combinations of *n* independent unobserved sources ε = (ε1,..., ε*n*) 0 :

$$Y = C\varepsilon, \tag{1.1}$$

where the components ε*<sup>i</sup>* are zero-mean and the matrix *C* is invertible.

*C* is called the "mixing matrix" and *C* −1 the "demixing matrix". The problem of independent component analysis<sup>1</sup> (ICA) is to identify *C* and ε from the knowledge of *Y*, or, in other words, to consistently estimate *C* and the distribution of ε, from a large number of observations *Y*1,...,*Y<sup>T</sup>* of vector *Y*.

If ε is Gaussian, the distribution of *Y* is also Gaussian, with zero-mean and a variance-covariance matrix*CC*0 . From the knowledge of the distribution of *Y*, we identify the matrix*CC*0 , but not matrix *C* itself. For instance, if *C* ∗ = *CQ*, where *Q* is an orthogonal matrix, we have *C* ∗*C* ∗ 0 = *CC*0 . Thus there is a problem of both local and global identification, since *C* is identified up to an orthogonal matrix.

This identification problem is prevalent in the literature that exploits vector autoregressive (VAR) models to derive the dynamic responses of macro-finance variables to so-called structural shocks. Indeed, these structural shocks are usually assumed – more or less explicitly – to be Gaussian. In this context, the independent shocks ε are not identified and identifying restrictions are required, such as restrictions on the short run impact of the shocks [see e.g. Bernanke (1986), Sims (1986), Rubio-Ramirez, Waggoner, Zha (2010)], on the long run impacts [see e.g. Blanchard, Quah (1989), Faust, Leeper (1997), Erceg, Guerrieri, Gust (2005), Christiano, Eichenbaum, Vigfusson (2006)], or on the sign of some impulse response functions [see e.g. Uhlig (2005), Chari, Kehoe, McGrattan (2008), Mountford, Uhlig (2009)]. However the lack of identification almost disappears if we assume that the components of ε are independent and not Gaussian. This results from the following theorem, derived in Eriksson, Koivunen (2004) Th. 3 [see also Comon (1994), Th. 11]:

Theorem. *Consider the model: Y* = *C*ε*. Under the following conditions:*

- i) *C is invertible,*
- ii) *The components* ε1,..., ε*<sup>n</sup> are independent, with at most one Gaussian distribution,*

<sup>1</sup> In signal processing, the components of ε are called "sources", the components of *Y* are called "sensors" and the ICA problem "blind separation of sources". Other terminologies are "sources/mixtures", "signal/mixtures", or "multiple input/multiple output" (MIMO).

then matrix C is identifiable up to the post multiplication by DP, where P is a permutation matrix and D a diagonal matrix with non-zero diagonal elements.

In other words C is identifiable up to a permutation of indexes and to signed scaling,  $\varepsilon_{i,t} \to \pm \sigma_i \varepsilon_{i,t}$ ,  $\sigma_i > 0, i = 1, ..., n$ , say. Thus, for independent non-Gaussian sources, the only cause of local lack of identification is through the positive scaling. The permutation and change in signs of columns of C create a global lack of identification, but not a local one.

The local identification problem, i.e. the possibility of replacing C by CD, where D is a diagonal matrix with strictly positive diagonal elements, can be avoided by introducing identification restrictions. Several sets of identification restrictions (SIR) have been considered in the literature. They are:

**SIR1**:  $c_{i,i} = 1$ , i = 1, ..., n where  $c_{i,i}$  is the  $i^{th}$  diagonal term of matrix C [see e.g. Jutten, Herault (1991), Comon, Jutten, Herault (1991), Eq. (3), Pham, Garat (1997), p. 1714, Ilmonen, Paindaveine (2015)].

**SIR2**:  $c_i'c_i = 1$ , i = 1, ..., n, where  $c_i$  denotes the  $i^{th}$  column of matrix C [see e.g. Comon (1994), Section 5.1, Pham, Garat (1997), p. 1714],

or similar sets of identification restrictions written on the diagonal elements  $c^{i,i}$ , or on the rows  $c^i, i = 1, ..., n$ , of the demixing matrix  $C^{-1}$ :

**SIR1\*** : 
$$c^{i,i} = 1$$
,  $i = 1, ..., n$ ,

**SIR2\*** : 
$$c^i c^{i'} = 1$$
,  $i = 1, ..., n$ .

Stronger conditions, such as the following, can be introduced:

**SIR3**: *C is an orthogonal matrix:* C'C = Id [see e.g. Hyvarinen (1997), Eq. 13, Vlassis (2001), Eq. 23, Hastie, Tibshirani (2002), Eq. 6].

If the error  $\varepsilon$  is standardized, i.e. if  $V(\varepsilon) = Id$ , these restrictions may imply constraints on the distribution of vector Y, such as V(Y) = Id for SIR3. This restriction can be asymptotically satisfied if the data are jointly prewhitened.

Restrictions SIR1 and SIR1\* have a major drawback: they implicitly assume that all diagonal elements are different from zero. Thus they exclude a priori some noncausal features between the variables, which can bias the impulse response analysis in a dynamic model with independent shocks.

Whenever the independent component model is locally identified, one can expect the existence of consistent semi-parametric estimation methods based on an i.i.d. sample  $Y_1, \ldots, Y_T$ . Two types

of approaches have been proposed in the literature, that are pseudo maximum likelihood (PML) approaches and moment methods. They differ by the form of the objective function, but also by the set of identification restrictions (SIR1-SIR3) that is used. These estimation methods have been introduced mainly in the literature on signal processing and data analysis with a focus on the numerical convergence and computational complexity of the algorithm used to get the estimate [see e.g. Amari, Cardoso (1997), Cardoso (1999), Cardoso, Laheld (1996), Cardoso, Souloumiac (1993), Comon (1994), Sections 4.2, 4.3., Hyvarinen (1997), Section 6, Hyvarinen (1999), Hyvarinen, Oja (1997, 2000), Section 6.1, Vlassis, Motomura (2001)]. As noted in Ilmonen et al. (2012), *"In the computer science communities ICA procedures are usually seen as algorithms rather than estimates with their statistical properties."* The statistical properties of these estimators, such as their consistency or asymptotic normality, are rarely considered [see Bonhomme, Robin (2009) for an exception in the context of moment methods]. This explains why several standard methods for ICA proposed in the literature or in softwares are not statistically consistent. Specifically, it can be shown that the one-unit algorithm using the identification restrictions SIR2 or SIR2\* provides estimators that are not statistically consistent.<sup>2</sup>

In this paper, we focus on the estimation of independent component models based on PML approaches and under SIR3. We carefully examine associated identification issues and we derive the asymptotic statistical behavior of the PML estimators. The PML approaches requires the specification of pseudo probability density functions (p.d.f.) for the different sources ε*i*,*<sup>t</sup>* , *i* = 1,...,*n*. We show that, whereas the potential misspecification of the pseudo p.d.f.'s influences the asymptotic accuracy of the PML estimators, it has no effect on the consistency of these estimators. This is important since, in many practical situations, we cannot assume that the true distributions belong to given parametric families. In this respect, our study extends that of Lanne, Meitz, Saikkonen (2015), who focus on the case where the parametric functional forms of the true p.d.f.'s are known. We also stress the usefulness of these methods for the identification of structural shocks and the estimation of impulse response functions in non-Gaussian vector autoregressive (VAR) models. Moreover, we show how the knowledge of the asymptotic distribution of the mixing matrix makes it possible to test the restrictions that are usually imposed in the structural vector autoregressive (SVAR) literature, these restrictions being over-identifying in the non-Gaussian context.

The remaining of this paper is organized as follows. Section 2 presents the pseudo maximum likelihood (PML) approaches for estimating matrix *C* under SIR3. This section shows that although these methods amount to maximizing a misspecified log-likelihood function, they provide consistent estimators. Then we derive the asymptotic distribution of these PML estimators. Since for large dimension *n* the optimization of the pseudo likelihood can be numerically cumbersome, we also analyse the recursive PML approaches under SIR3. These latter approaches compute the

<sup>2</sup>This is proven in Section A of the online appendix.

#### Pseudo Maximum Likelihood Approach (under SIR3)

estimators of the columns of *C* in a recursive way. Section 2 ends with the presentation of Monte-Carlo experiments aimed at comparing the finite-sample behavior of the different estimators and at evaluating their asymptotic properties. Section 3 illustrates the usefulness of ICA in the SVAR context; we employ ICA to identify structural shocks and derive impulse response functions in a small-scale VAR model estimated on U.S. macroeconomic data. In the context of this estimated VAR model, we test standard over-identification schemes based on short-run restrictions. Section 4 concludes. Technical results are gathered in appendices. Additional proofs and discussions are provided in an online appendix.

## 2 Pseudo Maximum Likelihood Approach (under SIR3)

In this section, we consider observations  $Y_t$  that are such that:

$$Y_t = C_0 \varepsilon_t, \tag{2.1}$$

where  $E_0(Y_t) = 0$  and  $V_0(Y_t) = Id$ . The true probability density functions (p.d.f.) of the latent components  $\varepsilon_{1,t}, \dots, \varepsilon_{n,t}$ , which we denote by  $f_{i,0}(\varepsilon_i)$   $(i = 1, \dots, n)$ , are unknown. These latent components satisfy the following assumption:

#### **Assumption A.1**

- i) The shocks  $\varepsilon_t$  are i.i.d. with  $E_0(\varepsilon_t) = 0$  and  $V_0(\varepsilon_t) = Id$ .
- ii) The components  $\varepsilon_{1,t}, \dots, \varepsilon_{n,t}$  are mutually independent.

In this framework,  $C_0$  is an orthogonal matrix ( $C_0C'_0 = Id$ ). Hence, this framework corresponds to the set of identification restrictions SIR3. By virtue of the theorem given above, if at most one of the true p.d.f. is Gaussian, then  $C_0$  is identifiable up to a permutation of index i and changes of sign of its columns.<sup>3</sup>

In the rest of this section, we discuss the consistency and the asymptotic properties of pseudo maximum likelihood estimators of the mixing matrix  $C_0$ .

<sup>&</sup>lt;sup>3</sup>When the sources are cross-sectionally independent, but serially correlated with distinct spectra, they can be identified by second-order methods, that is, from the knowledge of autocovariances only. This possibility to identify by means of the dynamics of the sources is not considered here. It is the basis of second-order estimation methods as AMUSE [Tong et al. (1990)], or SOBI [Belouchrani et al. (1997)], Gaussian PML written in frequency domain [Pham, Garat (1997), Section 3], or based on canonical correlations [Degerine, Malki (2000)].

#### 2.1 Pseudo Maximum Likelihood (PML) estimator

Let us introduce a set of p.d.f.  $g_i(\varepsilon_i)$ , i = 1, ..., n, and consider the pseudo log-likelihood function:

$$\log l_T(C) = \sum_{t=1}^{T} \sum_{i=1}^{n} \log g_i(c_i' Y_t), \tag{2.2}$$

where  $c_i$  is the  $i^{th}$  column of matrix C (or  $c_i'$  is the  $i^{th}$  row of  $C^{-1}$ ). The log-likelihood function (2.2) is computed as if the errors  $\varepsilon_{i,t}$  had the p.d.f.  $g_i(\varepsilon_i)$ , and using the fact that  $|\det C| = 1$ , since C is orthogonal. Then a pseudo maximum likelihood (PML) estimator of matrix C maximizes the pseudo log-likelihood function taking into account the condition that C is orthogonal. This optimization problem can be written as:

$$\hat{C}_T = \arg\max_{C} \sum_{t=1}^{T} \sum_{i=1}^{n} \log g_i(c_i' Y_t),$$
(2.3)

$$s.t. C'C = Id.$$

The optimization problem can also be considered after the elimination of the identification restrictions, that is, after parametrizing the orthogonal matrix C. It is known that any orthogonal matrix with no eigenvalue equal to -1 can be written as:

$$C(A) = (Id + A)(Id - A)^{-1},$$
 (2.4)

where A is a skew symmetric (or antisymmetric) matrix, such that A' = -A. This is the Cayley's representation of an orthogonal matrix. Moreover, this orthogonal matrix is in a one-to-one relationship with A since we have:

$$A = (C(A) + Id)^{-1}(C(A) - Id).$$
(2.5)

Thus, the PML estimator of matrix C can be alternatively derived as  $\hat{C}_T = C(\hat{A}_T)$ , where:

$$\hat{A}_T = \arg\max_{A} \sum_{t=1}^{T} \sum_{i=1}^{n} \log g_i [c_i(A)' Y_t], \tag{2.6}$$

and the optimization is with respect to the parameters characterizing A, that are the subdiagonal elements of A:  $a_{i,j}$ , i > j.

#### 2.2 The finite-sample first-order conditions (FOC)

The FOC can be written either on Problem (2.3), which is a constrained optimization, or on its parameterized version (2.6).<sup>4</sup> We focus below on the FOC for Problem (2.3).

Let us distinguish the different restrictions on matrix C:

$$c'_i c_j = 0$$
,  $i < j$ , and  $c'_i c_i = 1$ ,  $i = 1, ..., n$ ,

and let us introduce the associated Lagrange multipliers denoted  $\lambda_{i,j} = \lambda_{j,i}$ , if  $i \neq j$ , and  $\lambda_{i,i}/2$ , when both indices are equal. Then the FOC are:

$$\begin{cases}
\sum_{t=1}^{T} Y_{t} \frac{d \log g_{i}}{d\varepsilon} (\hat{c}'_{i} Y_{t}) - \sum_{j=1}^{n} \hat{\lambda}_{i,j} \hat{c}_{j} = 0, & i = 1, ..., n, \\
\hat{c}'_{i} \hat{c}_{j} = 0, & i < j, \hat{c}'_{i} \hat{c}_{i} = 1, & i = 1, ..., n.
\end{cases}$$
(2.7)

We get  $n^2 + n(n-1)/2 + n$  conditions for the  $n^2 + n(n-1)/2 + n$  unknowns, that are the  $\hat{c}_{i,j}$ ,  $\hat{\lambda}_{i,j}$ , i < j, and  $\hat{\lambda}_{i,i}$ , i, j = 1, ..., n. Premultiplying the first subsystem of (2.7) by  $\hat{C}_T'$  and taking into account the constraints on the orthogonal matrix  $\hat{C}$ , the finite-sample FOC are equivalent to:

$$\begin{cases} \sum_{t=1}^{T} \hat{c}'_{j} Y_{t} \frac{d \log g_{i}}{d \varepsilon} (\hat{c}'_{i} Y_{t}) - \hat{\lambda}_{i,j} = 0, & i, j = 1, \dots, n, \\ \hat{c}'_{i} \hat{c}_{j} = 0, i < j, \hat{c}'_{i} \hat{c}_{i} = 1, & i = 1, \dots, n. \end{cases}$$

Since  $\hat{\lambda}_{i,j} = \hat{\lambda}_{j,i}$ , it is possible to derive from this system the equations giving  $\hat{C}_T$ . They are:

$$\begin{cases}
\sum_{t=1}^{T} \hat{c}'_{j} Y_{t} \frac{d \log g_{i}}{d \varepsilon} (\hat{c}'_{i} Y_{t}) - \sum_{t=1}^{T} \hat{c}'_{i} Y_{t} \frac{d \log g_{j}}{d \varepsilon} (\hat{c}'_{j} Y_{t}) = 0, \quad i < j, \\
\hat{c}'_{i} \hat{c}_{j} = 0, i < j, \hat{c}'_{i} \hat{c}_{i} = 1, \quad i = 1, \dots, n.
\end{cases}$$
(2.8)

Thus the FOC of the constrained optimization problem (2.3) lead to a subsystem leading to the estimate of C.

Let us denote by  $\mathscr{P}(M)$  the set of matrices obtained by permuting and changing the signs of the columns of M. It is worth noting that, if the function  $g_i$  are different and not even, the value of the objective function  $\sum_{t=1}^{T} \sum_{i=1}^{n} \log g_i(c_i'Y_t)$  obtained by taking C equal to an element of  $\mathscr{P}(\hat{C}_T)$ , different from  $\hat{C}_T$ , will be different and therefore smaller than the one obtained with  $\hat{C}_T$ . On the other hand, in the extreme case where all the  $g_i$ 's are equal and even, all the elements of  $\mathscr{P}(\hat{C}_T)$ 

<sup>&</sup>lt;sup>4</sup>Section B of the online appendix provides closed-form expressions of the derivatives of C(A) with respect to A, which can be used to derive the FOC for the model written under the parametric form.

will provide a maximum.

#### 2.3 Consistency

To derive conditions for the consistency of the PML estimators when T goes to infinity (and n is fixed), we have to consider the associated asymptotic optimization problem and the asymptotic FOC.

In addition to Assumption A.1, we make the following assumption on the p.d.f.  $g_i$ :

#### **Assumption A.2**

i) The functions  $\log g_i$ , i = 1, ..., n, are twice continuously differentiable.

ii) 
$$\sup_{C:C'C=Id} \left| \sum_{i=1}^n \log g_i(c_i'y) \right| \le h(y)$$
, where  $E_0[h(Y)] < \infty$ .

From Assumption A.1 and A.2 ii), we know that the finite-sample objective function:  $Q_T(C) = \frac{1}{T} \sum_{t=1}^{T} \sum_{i=1}^{n} \log g_i(c_i'Y_t)$  tends almost surely uniformly to the asymptotic one:

$$Q_{\infty}(C) = E_0 \left[ \sum_{i=1}^n \log g_i(c_i'Y_t) \right].$$

Moreover, the parameter set, that is, the set of orthogonal matrices, is compact. Then the uniform integrability in Assumption A.2 ii) implies the uniform convergence of  $Q_T$  towards  $Q_{\infty}$ , and the convergence of the optimizers of  $Q_T$  to the set of optimisers of  $Q_{\infty}$  [Jennrich (1969), Gourieroux, Monfort (1995), vol 2, chapter 24]. Finally the latter optimizers can be analyzed by means of the asymptotic FOC. This approach is followed below.

The asymptotic optimization problem is:

$$\max_{C} L_{\infty}(C) = \max_{C} \operatorname{plim}_{T \to \infty} \frac{1}{T} \log l_{T}(C) \equiv \max_{C} \sum_{i=1}^{n} E_{0}[\log g_{i}(c_{i}'Y_{t})], \tag{2.9}$$

s.t.  $c_i'c_j = 0$ , i < j,  $c_i'c_i = 1$ , i, j = 1, ..., n, with Lagrange multipliers  $\lambda_{i,j,0}, \lambda_{i,i,0}/2$ . The asymptotic FOC are:

$$\begin{cases} E_0 \left[ Y_t \frac{d \log g_i}{d\varepsilon} (c_i' Y_t) \right] - \sum_{j=1}^n \lambda_{i,j} c_j = 0, \quad i = 1, \dots, n, \\ c_i' c_j = 0, i < j, c_i' c_i = 1, \quad i, j = 1, \dots, n. \end{cases}$$

#### Pseudo Maximum Likelihood Approach (under SIR3)

By premultiplying the set of equations by  $c'_k$ , by using the conditions of orthogonal matrix and the equality  $\lambda_{i,j} = \lambda_{j,i}$ , the asymptotic FOC imply:

$$\begin{cases}
\lambda_{i,j} = E_0 \left[ c'_j Y_t \frac{d \log g_i}{d\varepsilon} (c'_i Y_t) \right] = E_0 \left[ c'_i Y_t \frac{d \log g_j}{d\varepsilon} (c'_j Y_t) \right] = \lambda_{j,i}, & i \neq j, \\
\lambda_{i,i} = E_0 \left[ c'_i Y_t \frac{d \log g_i}{d\varepsilon} (c'_i Y_t) \right], & i = 1, \dots, n.
\end{cases}$$
(2.10)

We deduce the following property:

**Proposition 1** For any element C of  $\mathcal{P}(C_0)$ , and the associated  $\varepsilon_{i,t}$ 's, the values C,  $\lambda_{i,j,0} = 0$ , i < j,  $\lambda_{i,i,0} = E_0\left[\varepsilon_{i,t} \frac{d \log g_i(\varepsilon_{i,t})}{d\varepsilon}\right]$ , i = 1, ..., n are solutions of the asymptotic FOC.

**Proof** Replacing the  $c_i$ 's by their true values, we get:

$$\lambda_{i,j,0} = E_0 \left[ \varepsilon_{j,t} \frac{d \log g_i(\varepsilon_{i,t})}{d\varepsilon} \right] = E_0 \left[ \varepsilon_{i,t} \frac{d \log g_j(\varepsilon_{j,t})}{d\varepsilon} \right] = \lambda_{j,i,0}.$$

Then, by the independence of  $\varepsilon_{i,t}, \varepsilon_{j,t}$  for  $i \neq j$ , we get:

$$E_0\left[\varepsilon_{j,t}\frac{d\log g_i(\varepsilon_{i,t})}{d\varepsilon}\right] = E_0(\varepsilon_{j,t})E_0\left[\frac{d\log g_i(\varepsilon_{i,t})}{d\varepsilon}\right] = 0,$$

since  $\varepsilon_{j,t}$  is zero-mean. The conclusion follows.

We deduce a necessary identification assumption.

#### Assumption A.3 Identification from the asymptotic FOC.

The only solutions of the system of equations:

$$\begin{cases} E_0 \left[ c'_j Y_t \frac{d \log g_i}{d\varepsilon} (c'_i Y_t) \right] = 0, \ i \neq j, \\ C'C = Id, \end{cases}$$

are the elements of  $\mathcal{P}(C_0)$ , which is the set of matrices obtained by permutation and sign change of the columns of  $C_0$ .

#### Pseudo Maximum Likelihood Approach (under SIR3)

As seen in the next proposition, Assumption A.3 implies restrictions on the true distribution of  $Y_t$  as well as on the choice of the pseudo p.d.f..

#### **Proposition 2**

- a) If at least two components of  $Y_t$  have the Gaussian distribution N(0,1), are independent from each other and independent from the other components, then Assumption A.3 cannot be satisfied.
- b) If at least two pseudo p.d.f.  $g_i$  and  $g_j$  are Gaussian N(0,1), then Assumption A.3 cannot be satisfied.

#### **Proof**

a) Let us assume, without loss of generality, that  $Y_{1,t}$  and  $Y_{2,t}$  are independent and N(0,1). Let C be an orthogonal matrix satisfying A.3 and  $C^*$  the orthogonal matrix obtained from C by permuting its first two rows. It is easily seen that  $C^*$  also satisfies A.3. Indeed, for any column  $c_i$  of C and the corresponding column  $c_i^*$  of C we have

$$c_i'Y_t = c_{i,1}Y_{1,t} + c_{i,2}Y_{2,t} + \sum_{k \ge 2} c_{i,k}Y_{k,t},$$
  
$$c_i^{*'}Y_t = c_{i,2}Y_{1t} + c_{i,1}Y_{2,t} + \sum_{k \ge 2} c_{i,k}Y_{k,t},$$

and, since  $c_{i,1}Y_{1,t} + c_{i,2}Y_{2,t}$  and  $c_{i,2}Y_{1,t} + c_{i,1}Y_{2,t}$  have the same distribution  $N(0, c_{i,1}^2 + c_{i,2}^2)$ , the result follows.

b) When  $g_i$  is N(0,1), we have  $\frac{\partial \log g_i}{d\varepsilon}(c_i'Y_t) = -c_i'Y_t$ . Therefore, the (i,j) condition of Assumption A.3 is:  $E_0(c_j'Y_tc_i'Y_t) = 0$ , which is true for any orthogonal matrix C and any true distribution of  $Y_t$  since  $E_0(c_j'Y_tc_i'Y_t) = E_0(c_j'Y_tY_t'c_i) = c_j'c_i$ .

Even if Assumption A.3 is satisfied, we are not sure that a matrix C of  $\mathcal{P}(C_0)$  corresponds to a maximum of the asymptotic optimization problem. To check this property, we can consider a second-order expansion of  $L_{\infty}(C)$  in a neighbourhood of the true value. It is shown in Appendix 1 that the asymptotic objective function is locally concave in a neighbourhood of a matrix C of  $\mathcal{P}(C_0)$  if and only if the following assumption is satisfied:

#### Assumption A.4 Local concavity in a neighbourhood of a matrix C of $\mathcal{P}(C_0)$ .

We have:

$$E_0 \left[ \frac{d^2 \log g_i(\varepsilon_{i,t})}{d\varepsilon^2} + \frac{d^2 \log g_j(\varepsilon_{j,t})}{d\varepsilon^2} - \varepsilon_{j,t} \frac{d \log g_j(\varepsilon_{j,t})}{d\varepsilon} - \varepsilon_{i,t} \frac{d \log g_i(\varepsilon_{i,t})}{d\varepsilon} \right] < 0, \forall i < j,$$

#### Pseudo Maximum Likelihood Approach (under SIR3)

where  $\mathcal{E}_{i,t}$  is the  $i^{th}$  component of the  $\mathcal{E}_t$  associated with a particular element C of  $\mathscr{P}(C_0)$ .

This condition is in particular satisfied under the following set of conditions derived in Hyvarinen (1997), Th. 1 [see also Hyvarinen, Karhunen, Oja (2001), Th. 8.1]:<sup>5</sup>

$$E_0 \left[ \frac{d^2 \log g_i(\varepsilon_{i,t})}{d\varepsilon^2} - \varepsilon_{i,t} \frac{d \log g_i(\varepsilon_{i,t})}{d\varepsilon} \right] < 0, i = 1, \dots, n.$$
 (2.11)

This set of conditions is sufficient, but not necessary. Hyvarinen, Karhunen, Oja (2001) have exhibited a couple of distributions that is such that either one, or the other satisfy the inequality (2.11) as long as  $E_0(\varepsilon_{i,t}) = 0$ , and  $E_0(\varepsilon_{i,t}^2) = 1$ . These distributions are the Hyperbolic secant and the subgaussian distributions reported in Table 1.6

For a given set of pseudo density functions in a given order  $g_1, \ldots, g_n$ , the value of the asymptotic criterion  $\sum_{i=1}^n E_0[\log g_i(c_i'Y_t)]$  for a given element C of  $\mathscr{P}(C_0)$  is:

$$\sum_{i=1}^n E_0[\log g_i(\boldsymbol{\varepsilon}_{i,t})],$$

where  $\varepsilon_{i,t}$  is the  $i^{th}$  component of the  $\varepsilon_t$  associated with this particular element C of  $\mathcal{P}(C_0)$ . If Assumption A.4 is satisfied for matrix C, this matrix will provide a local maximum of the asymptotic criterion. Furthermore, if the following assumption is also satisfied, then the values of the asymptotic criterion at these local maxima will be in general different and the global maximum will be reached by a unique element of  $\mathcal{P}(C_0)$ :

### Assumption A.5 Distinct distributions.

The pseudo distributions  $g_i$ , as well as the true distributions of the  $\varepsilon_{i,t}$ , are different and asymmetric.

For the sake of notational simplicity, let us denote by  $C_0$  the value of C giving this global maximum. We have the following consistency result:

<sup>&</sup>lt;sup>5</sup>Note that, if the pseudo distribution  $g_i$  is N(0,1) or even  $N(m_i, \sigma_i^2)$ , the left hand side of the inequality is equal to zero, for any true distribution of  $\varepsilon_{i,t}$  satisfying  $E_0(\varepsilon_{i,t}) = 0$  and  $E_0(\varepsilon_{i,t}^2) = 1$ .

<sup>&</sup>lt;sup>6</sup>This statement is easily checked by using the third and fourth columns of this table to compute the expectation appearing on the left-hand side of Inequality (2.11) (and using  $E_0(\varepsilon_{i,t}^2) = 1$ ).

<sup>&</sup>lt;sup>7</sup>If the global maximum of the asymptotic criterion is reached on a subset  $E_0$  of  $\mathscr{P}(C_0)$ , the PML estimator will converge to  $E_0$ , that is  $\hat{C}_T - C_{0,T}$  will converge to zero, where  $C_{0,T} = \underset{C \in E_0}{\operatorname{Argmin}} d(\hat{C}_T, C)$ , d being any distance.

#### Pseudo Maximum Likelihood Approach (under SIR3)

**Proposition 3** Under Assumptions A.1-A.5, the PML estimator of C exists asymptotically and is a consistent estimator of  $C_0$ .

Thus the misspecification of pseudo distributions  $g_i$  has no effect on the consistency of these specific PML estimators. This is easily understood when we consider the asymptotic FOC in A.3. They simply correspond to zero moment conditions written on:

$$c'_{j}Y_{t}\frac{d\log g_{i}}{d\varepsilon}(c'_{i}Y_{t}), \quad i \neq j.$$

The consistency result is still valid if  $g_i$  is not a p.d.f., but the interpretation as misspecified ML is more appealing.

### 2.4 Asymptotic distribution of the PML estimator

The asymptotic accuracy of the PML estimator depends on the choice of the pseudo p.d.f.. Its asymptotic distribution is derived in Appendix 2. Again, let us denote by  $C_0$  the unique value of C giving the global maximum of the asymptotic criterion under the conditions given above.

**Proposition 4** Under Assumptions A.1-A.5, the PML estimator  $\hat{C}_T$  of  $C_0$  is asymptotically normal, with speed of convergence  $1/\sqrt{T}$ . The asymptotic variance-covariance matrix of  $vec\sqrt{T}(\hat{C}_T - C_0)$  is  $A^{-1}\begin{bmatrix} \Omega & 0 \\ 0 & 0 \end{bmatrix}(A')^{-1}$ , where A and  $\Omega$ , given in Appendix 2, are square matrices of respective sizes  $n^2$  and  $\frac{n(n-1)}{2}$ .

The previous result implies that the asymptotic Gaussian distribution has a support of dimension  $\frac{n(n-1)}{2}$ , as expected since an orthogonal matrix must satisfy  $\frac{n(n+1)}{2}$  constraints.

For illustration, let us consider the bivariate case n = 2. The asymptotic expansion of the FOC shows that:

$$\sqrt{T}\left(\begin{array}{cc} \hat{c}_1-c_{1,0} \ \hat{c}_2-c_{2,0} \end{array}\right) = \left[\begin{array}{ccc} \gamma_{1,2}c'_{2,0} & \gamma_{2,1}c'_{1,0} \ c'_{10} & c'_{20} \ c'_{10} & 0 \ 0 & c'_{20} \end{array}\right]^{-1} \left[\begin{array}{ccc} Z \ 0 \ 0 \ 0 \end{array}\right],$$

where

$$Z \sim N(0, \omega^{2}),$$

$$\gamma_{i,j} = E_{0} \left[ \frac{d^{2} \log g_{i}(\varepsilon_{i,t})}{d\varepsilon^{2}} \right] - E_{0} \left[ \varepsilon_{j,t} \frac{d \log g_{j}(\varepsilon_{j,t})}{d\varepsilon} \right],$$

$$\omega^{2} = E_{0} \left\{ \left[ \frac{d \log g_{1}(\varepsilon_{1,t})}{d\varepsilon} \right]^{2} \right\} + E_{0} \left\{ \left[ \frac{d \log g_{2}(\varepsilon_{2,t})}{d\varepsilon} \right]^{2} \right\}$$

$$-2E_{0} \left[ \varepsilon_{1,t} \frac{d \log g_{1}(\varepsilon_{1,t})}{d\varepsilon} \right] E_{0} \left[ \varepsilon_{2,t} \frac{d \log g_{2}(\varepsilon_{2,t})}{d\varepsilon} \right].$$

The expression of the asymptotic variance can be simplified in the bivariate case. We get:<sup>8</sup>

$$V_{as}\left[\sqrt{T}(vec\hat{C}_T - vecC_0)\right] = \frac{\omega^2}{(\gamma_{1,2} + \gamma_{2,1})^2} \begin{pmatrix} c_{2,0}c'_{2,0} & -c_{2,0}c'_{1,0} \\ -c_{1,0}c'_{2,0} & c_{1,0}c'_{1,0} \end{pmatrix}. \tag{2.12}$$

This closed-form expression facilitates the consistent estimation of the asymptotic variance of  $\hat{C}_T$ . Indeed, from the PML estimates  $\hat{C}_T$  we deduce the approximated errors  $\hat{\varepsilon}_t = \hat{C}_T' Y_t$ . Therefore  $\gamma_{i,j}$  and  $\omega^2$  are consistently estimated by replacing their theoretical expectations by their sample counterparts and the errors  $\varepsilon$  by their approximations  $\hat{\varepsilon}$ . For instance, we can take:

$$\hat{\gamma}_{i,j} = \frac{1}{T} \sum_{t=1}^{T} \frac{d^2 \log g_i(\hat{\epsilon}_{i,t})}{d\epsilon^2} - \frac{1}{T} \sum_{t=1}^{T} \left[ \hat{\epsilon}_{j,t} \frac{d \log g_i(\hat{\epsilon}_{j,t})}{d\epsilon} \right].$$

For n = 2, the elements of C generate a manifold of dimension 1. Thus the asymptotic variance-covariance matrix is of rank 1. It has been suggested in Pham, Garat (1997), Section 2.B, to also consider the asymptotic distribution of transformations of  $\hat{C}_T$  such as:

$$\hat{\Delta}_T = Id - C^{-1}\hat{C}_T = Id - C'\hat{C}_T. \tag{2.13}$$

It can be shown that: 10

$$V_{as}[\sqrt{T}vec\hat{\Delta}_{T}] = \frac{\omega^{2}}{(\gamma_{1,2} + \gamma_{2,1})^{2}} \begin{bmatrix} 0 & 0 & 0 & 0\\ 0 & 1 & 1 & 0\\ 0 & 1 & 1 & 0\\ 0 & 0 & 0 & 0 \end{bmatrix}.$$
 (2.14)

<sup>&</sup>lt;sup>8</sup>This is done in Section C of the online appendix.

<sup>&</sup>lt;sup>9</sup>For expository purpose we have changed the definition of the so-called contamination coefficients initially defined as  $\hat{\Delta}_T = Id - \hat{C}_T^{-1}C$ .

<sup>&</sup>lt;sup>10</sup>See Section C of the online appendix.

#### Pseudo Maximum Likelihood Approach (under SIR3)

Thus, after this transformation, the asymptotic accuracy of ∆ˆ *<sup>T</sup>* no longer depends on matrix *C*, but only on the distributional properties of the sources and of the pseudo p.d.f..

Finally, the multiplicative factor function ω <sup>2</sup>/(γ1,<sup>2</sup> +γ2,1) <sup>2</sup> differs from the multiplicative factors derived in Hyvarinen (1997), Eq. 15, or in Pham, Garat (1997), where the restrictions on *C* required for identification do not seem to have been fully taken into account in their derivations.

Going back to the general case, we see that the asymptotic accuracy of the PML estimator depends on the choice of the pseudo p.d.f.. Since the ML estimator is asymptotically efficient, we immediately deduce the following corollary [see also Pham, Garat (1997)]:

Corollary 1 *The asymptotic accuracy of the PML estimator is maximal if g<sup>i</sup> , the pseudo p.d.f. of* ε*i*,*t* , *is equal to its true p.d.f..*

The corollary above raises the following two comments:

- i) The practice of selecting a pseudo p.d.f. as different as possible from a Gaussian distribution –for instance by maximizing a distance to Gaussianity such as the negentropy, or an approximation of the negentropy, by third and fourth-order cumulants– is suboptimal,<sup>11</sup> especially when the true distribution is close to Gaussian.
- ii) The asymptotic efficiency for the estimation of parameter *C* could be improved through the implementation of a two-step adaptive estimation approach. In a first step *C* is estimated by a non efficient PML approach. The corresponding estimate is used to compute the residuals as: εˆ*<sup>t</sup>* = *C*ˆ<sup>0</sup> *TYt* , *t* = 1,...,*T*. Next the approximated sources εˆ*i*,*<sup>t</sup>* , *t* = 1,...,*T* are used to estimate nonparametrically the densities *fi*,0, *i* = 1,...,*n*. In a second step the PML approach is reapplied with *g<sup>i</sup>* = ˆ*f<sup>i</sup>* , *i* = 1,...,*n*, where ˆ*f<sup>i</sup>* is a consistent functional estimator of *fi*,0.

### 2.5 Testing procedures

Let us now consider the problem of testing that the true value of *C* belongs to P0, where P<sup>0</sup> is the set of orthogonal matrices obtained by permuting and changing the signs of the columns of a given orthogonal matrix *C*<sup>0</sup> (i.e. P<sup>0</sup> = P(*C*0)). We denote by *Cj*,0, *j* ∈ *J*, the elements of P0.

The null hypothesis *H*<sup>0</sup> stating that the true value of *C* belongs to P<sup>0</sup> is not standard since it is a finite union of simple hypotheses *H*0, *<sup>j</sup>* = (*C* = *Cj*,0).

<sup>11</sup>See Kaiser (1958) for an early version of such an idea, or the choice *gi*(*y*) = *sech*<sup>2</sup> (*y*)/2, whose associated score function is 2*tanh*(*y*) introduced in the informax algorithm [Bell, Sejnowski (1995) or Hyvarinen, Karhunen, Oja (2001), p. 111, 222-223].

#### Pseudo Maximum Likelihood Approach (under SIR3)

A first testing procedure consists in defining the Wald statistics  $\hat{\xi}_{j,T}$ ,  $j \in J$ :

$$\hat{\xi}_{j,T} = T[vec\hat{C}_T - vecC_{j,0}]'\hat{A}_T' \begin{bmatrix} \hat{\Omega}_T^{-1} & 0\\ 0 & 0 \end{bmatrix} \hat{A}_T[vec\hat{C}_T - vecC_{j,0}], \tag{2.15}$$

 $\hat{A}_T$  and  $\hat{\Omega}_T$  being consistent estimators of the matrices A and  $\Omega$  defined in Proposition 4 and Appendix 2. Since the dimension of the asymptotic distribution of  $\sqrt{T}[vec\hat{C}_T - vecC_{j,0}]$  is  $\frac{1}{2}n(n-1)$ , the asymptotic distribution of  $\hat{\xi}_{j,T}$  under  $H_{0,j}$  is  $\chi^2\left(\frac{1}{2}n(n-1)\right)$ .

Then we define:

$$\hat{\xi}_T = \min_{j \in J} \hat{\xi}_{j,T},\tag{2.16}$$

as the test statistic for the null hypothesis of interest  $H_0$ . Under the null hypothesis,  $\hat{C}_T$  converges to  $C_{j_0,0}$ , say. By the asymptotic properties of the Wald statistics for simple hypotheses, we have that:

$$\hat{\xi}_{j_0,T} \xrightarrow{D} \chi^2 \left( \frac{n(n-1)}{2} \right) \tag{2.17}$$

and  $\hat{\xi}_{j,T} \to \infty$ , if  $j \neq j_0$ .

Under the null hypothesis,  $\hat{\xi}_T = \min_j \hat{\xi}_{j,T}$  is asymptotically equal to  $\hat{\xi}_{j_0,T}$  (since, for  $j \neq j_0$ ,  $\hat{\xi}_{j_0,T}$  goes to  $+\infty$ ) and its asymptotic distribution,  $\chi^2\left(\frac{1}{2}n(n-1)\right)$ , does not depend on  $j_0$ . Therefore  $\hat{\xi}_T$  is asymptotically a pivotal statistic for the null hypothesis  $H_0$  and the test of critical region  $\hat{\xi}_T \geq \chi^2_{1-\alpha}\left(\frac{1}{2}n(n-1)\right)$  is of asymptotic level  $\alpha$  and is consistent.

The second testing method is the following. Let us first define  $C_{0,T} = \underset{C \in \mathscr{P}_0}{\operatorname{Argmin}} d(\hat{C}_T, C)$  where d is any distance, for instance the Euclidean one.

Under the null hypothesis  $H_0$ :  $(C \in \mathscr{P}_0)$ ,  $\hat{C}_T$  converges almost surely to an element of  $\mathscr{P}_0$  denoted by  $C_{j_0,0}$  and it is also the case for  $C_{0,T}$  since, asymptotically, we have  $C_{0,T} = C_{j_0,0}$ . Moreover,  $\sqrt{T}(\hat{C}_T - C_{0,T}) = \sqrt{T}(\hat{C}_T - C_{j_0,0}) + \sqrt{T}(C_{j_0,0} - C_{0,T})$  and, since  $C_{0,T}$  is almost surely asymptotically equal to  $C_{j_0,0}$ , the asymptotic distribution of  $\sqrt{T}(\hat{C}_T - C_{j_0,0})$  under  $H_0$  is the same as that of  $\sqrt{T}(\hat{C}_T - C_{j_0,0})$ . This implies that

$$\tilde{\xi}_T = T[vec\hat{C}_T - vecC_{0,T}]'\hat{A}_T' \left[ \begin{array}{cc} \hat{\Omega}_T^{-1} & 0 \ 0 & 0 \end{array} \right] \hat{A}_T[vec\hat{C}_T - vecC_{0,T}]$$

is asymptotically distributed as  $\chi^2(\frac{1}{2}n(n-1))$  under  $H_0$ .

An advantage of this second method is that it necessitates the computation of only one Wald test statistic.

<sup>&</sup>lt;sup>12</sup>See Andrews (1987).

### 2.6 Recursive PML approach (under SIR3)

For a large dimension n, the optimization of the pseudo likelihood (Problem 2.3) can be numerically cumbersome. In the present subsection, we present a recursive PML approach. This approach is based on a succession of simplified optimization problems. The recursive PML approach has been called deflation-based Fast ICA in the literature [see e.g. Ollila (2010), Reyhani et al. (2012), Ilmonen et al. (2012), Miettinen et al. (2014)].

#### 2.6.1 The recursive scheme

In the recursive PML approach and under SIR3, the identification constraints (orthogonality of C) are introduced in a recursive optimization scheme.

Let us consider step i of the recursive PML approach. At this stage, the recursive PML estimators  $\hat{c}_1, \dots, \hat{c}_{i-1}$  have already been derived. The recursive PML estimator  $\hat{c}_i$  of  $c_i$  is defined as the solution of:

$$\hat{c}_i = \arg\max_{c_i} \sum_{t=1}^{T} \log g_i(c_i'Y_t), \quad s.t.: \quad c_i'c_i = 1, \quad c_i'\hat{c}_j = 0, \quad j = 1, \dots, i-1,$$
(2.18)

for i = 2, ..., n. For i = 1, the only constraint is  $c'_1 c_i = 1$ .

#### 2.6.2 The Gaussian case

This recursive PML approach has been initially proposed by analogy with principal component analysis (PCA) [see e.g. Lawley, Maxwell (1971), Anderson (1984) for PCA]. PCA is based on a PML approach with Gaussian pseudo distributions. Taking the standard Gaussian densities for all the densities  $g_i$  in Equation (2.2), the optimization Problem (2.3) becomes:

$$\max_{C} -\sum_{t=1}^{T} \sum_{i=1}^{n} (c'_{i}Y_{t})^{2}$$
  
s.t.  $C'C = Id$ .

The objective function can also be written as:

$$-\sum_{t=1}^{T}\sum_{i=1}^{n}c_{i}'Y_{t}Y_{t}'c_{i} = -\sum_{i=1}^{n}\left[c_{i}'\sum_{t=1}^{T}Y_{t}Y_{t}'c_{i}\right] = -Tr\left[C'\sum_{t=1}^{T}Y_{t}Y_{t}'C\right]$$

$$= -Tr\left[\sum_{t=1}^{T}Y_{t}Y_{t}'CC'\right] \text{ (by commuting within the Trace operator)}$$

$$= -Tr\left(\sum_{t=1}^{T}Y_{t}Y_{t}'\right) \text{ (since } CC' = Id\text{)}.$$

#### Pseudo Maximum Likelihood Approach (under SIR3)

Thus the objective function takes the same value for all orthogonal matrices C. This is the well-known identification problem of matrix C in the Gaussian framework (see the introduction and Proposition 2.a). The recursive Gaussian PML is used in PCA to find an easily interpretable matrix C. Indeed the solution of the recursive PML approach is the sequence of unit norm eigenvectors of  $\sum_{t=1}^{T} Y_t Y_t'$  associated with the eigenvalues ranked in decreasing order (assuming that there is no multiple eigenvalue).

#### 2.6.3 Recursive vs global optimization PML estimators

When the pseudo p.d.f.'s are not Gaussian, the PML estimator of Section 2 and the recursive PML estimator are not necessarily equal in finite sample. For instance let us consider n = 2 and parametrize matrix C as:<sup>13</sup>

$$C = \left(\begin{array}{cc} \cos \theta & -\sin \theta \\ \sin \theta & \cos \theta \end{array}\right).$$

The PML estimator of  $\theta$  is the solution of

$$\max_{\theta} \sum_{t=1}^{T} \{ \log g_1(y_{1,t} \cos \theta + y_{2,t} \sin \theta) + \log g_2(-y_{1,t} \sin \theta + y_{2,t} \cos \theta) \},$$

whereas the recursive PML estimator of  $\theta$  is the solution of

$$\max_{\theta} \sum_{t=1}^{T} [\log g_1(y_{1,t} \cos \theta + y_{2,t} \sin \theta)].$$

It is easily seen that the solutions of these optimization problems differ in finite sample (even up to a permutation of the columns and to a change of sign of the columns of C). They also have different asymptotic properties. Indeed the conditions of local concavity differ (see Assumption  $\tilde{A}$ .4 below). They are, respectively:

$$E_0\left[\frac{d^2\log g_1(\varepsilon_1)}{d\varepsilon^2} + \frac{d^2\log g_2(\varepsilon_2)}{d\varepsilon^2} - \varepsilon_1 \frac{d\log g_1(\varepsilon_1)}{d\varepsilon} - \varepsilon_2 \frac{d\log g_2(\varepsilon_2)}{d\varepsilon}\right] < 0,$$
 and 
$$E_0\left[\frac{d^2\log g_1(\varepsilon_1)}{d\varepsilon^2} - \varepsilon_1 \frac{d\log g_1(\varepsilon_1)}{d\varepsilon}\right] < 0.$$

Going back to the general case, the previous identification Assumptions A.3-A.4 are replaced by:<sup>14</sup>

<sup>&</sup>lt;sup>13</sup>This parametrization is valid for an orthogonal matrix C such that  $\det C = 1$ .

<sup>&</sup>lt;sup>14</sup>See Section D of the online appendix for justifications.

**Assumption**  $\tilde{A}$ .**3** *For any* i = 1, ..., n-1, *the system:* 

$$E_0\left\{\frac{d\log g_i}{d\varepsilon}(c_i'Y_t)\left[\sum_{j=i}^n c_{j,0}\varepsilon_{j,t}-c_i'Y_tc_i-\Sigma_{j< i}\varepsilon_{j,t}c_{j,0}\right]\right\}=0,$$

$$c_i'c_i=1, c_i'c_{j,0}=0, j< i, i, j=1,\ldots,n,$$

has the (essentially)<sup>15</sup> unique solution  $c_{i,0}$ .

#### Assumption $\tilde{A}$ .4 Local concavity.

The asymptotic objective function is locally concave in a neighbourhood of  $C_0$  if and only if

$$E_0\left[\frac{d^2\log g_i(\varepsilon_{i,t})}{d\varepsilon^2} - \varepsilon_{i,t}\frac{d\log g_i(\varepsilon_{i,t})}{d\varepsilon}\right] < 0, i = 1, \dots, n-1.$$

#### 2.6.4 Behaviour of the recursive PML estimator

It can be shown that the asymptotic FOC are satisfied by the true values. Moreover, if the true distributions of the  $\varepsilon_{i,t}$  are different and asymmetric and if the pseudo distributions  $g_i$  are asymmetric, the optimal values of the asymptotic criterion at step i – i.e.  $E_0(\log g_i(\varepsilon_{i,t}))$  where  $\varepsilon_{i,t}$  is associated with a particular choice of C in  $\mathcal{P}(C_0)$  – will change if this choice changes and, therefore, the global maximum of this asymptotic criterion will be reached by a unique element denoted by  $C_0$  for the sake of simplicity. Under the previous assumption we get the following result:

**Proposition 5** Let us assume that the true matrix  $C_0$  is orthogonal.

- i) Even for the same set of pseudo distributions, the PML and recursive PML estimators of  $C_0$  under SIR3 generally differ in finite sample.
- ii) Under Assumptions A.3-A.4 the PML and recursive PML estimators of  $C_0$  are consistent.
- iii) Even for the same set of pseudo distributions, the asymptotic distributions of the PML and recursive PML estimators generally differ.

<sup>&</sup>lt;sup>15</sup>That is  $c_{i,0}$  is one of the remaining columns (or its opposite) of a matrix of  $\mathscr{P}(C_0)$  containing the columns  $c_{j,0}$ , j < i, (or their opposite), once these columns have been eliminated.

<sup>&</sup>lt;sup>16</sup>See Section D of the online appendix.

## Pseudo Maximum Likelihood Approach (under SIR3)

The FOC of Problem (2.18) are:

$$\begin{cases} \sum_{t=1}^{T} Y_t \frac{d \log g_i}{d\varepsilon} (\hat{c}_i' Y_t) - \sum_{j=1}^{i} \hat{\lambda}_{i,j} \hat{c}_j = 0, & i = 1, \dots, n, \\ \hat{c}_i' \hat{c}_j = 0, & j < i, & \hat{c}_i' \hat{c}_i = 1, & i = 1, \dots, n, \end{cases}$$

where  $\hat{\lambda}_{i,j}$ , j < i (resp.  $\hat{\lambda}_{i,i}/2$ ) is the estimated Lagrange multiplier associated with the restriction  $c'_i\hat{c}_j = 0$ , j < i (resp.  $c'_ic_i = 1$ ). Note that at the  $n^{th}$  iteration  $\hat{c}_n$  is (essentially) characterized by the orthogonality restrictions and  $g_n$  has no impact on the asymptotic distribution of the recursive PML estimator while it has an impact on the asymptotic distribution of the PML estimator.

As for deriving System (2.8) of FOC for the PML estimator, we can premultiply the first subsystem by  $\hat{C}'_T$ . We get:

$$\sum_{t=1}^{T} \hat{c}'_{j} Y_{t} \frac{d \log g_{i}}{d \varepsilon} (\hat{c}'_{i} Y_{t}) - \hat{\lambda}_{i,j} = 0, j \le i.$$

Then we can substitute this expression of the Lagrange multiplier in the system to get:

$$\sum_{t=1}^{T} \left[ Y_t \frac{d \log g_i}{d\varepsilon} (\hat{c}_i' Y_t) - \sum_{j=1}^{i} \left( \hat{c}_j' Y_t \frac{d \log g_i}{d\varepsilon} (\hat{c}_i' Y_t) \hat{c}_j \right) \right] = 0, i = 1, \dots, n,$$

$$\iff \sum_{t=1}^{T} \left\{ \frac{d \log g_i}{d\varepsilon} (\hat{c}_i Y_t) \left[ Y_t - \sum_{j=1}^{i} \hat{c}_j' Y_t \hat{c}_j \right] \right\} = 0, i = 1, \dots, n.$$

This system is easily solved recursively.

Additional asymptotic distributional properties of recursive PML estimators have been derived in Ilmonen et al. (2012), Theorem 2.2. and Miettinen et al (2014). In particular it has been realized that Assumption  $\tilde{A}$ .3 is often not satisfied when the same functions  $\frac{d \log g_i}{d\varepsilon}$ , independent of i, are introduced in the different steps [see Miettinen et al. (2014), p. 2].

#### 2.7 Monte Carlo exercises

This subsection presents the results of a Monte-Carlo exercise where we use the PML approaches presented above (under SIR3). After having specified a 2-dimensional orthogonal mixing matrix  $C_0$ , we simulate samples of i.i.d. zero-mean and unit-variance shocks  $\varepsilon_{1,t}$  and  $\varepsilon_{2,t}$  and we premultiply  $\varepsilon_t = [\varepsilon_{1,t}, \varepsilon_{2,t}]'$  by  $C_0$  to get  $Y_t$  vectors. We denote by  $\mathcal{D}_j$  the distribution used to draw  $\varepsilon_{j,t}$ . For each pair of generating distributions  $(\mathcal{D}_1, \mathcal{D}_2)$ , N = 5000 samples are generated, each one being of length T. We consider different sample sizes T = 200, 500 and 5000. The  $i^{th}$  simulated sample is denoted by  $\{Y_t^{(i)}\}_{t \in [1,T]}$ ,  $i = 1, \ldots, 5000$ . In our simulations, we use different distributions

#### Pseudo Maximum Likelihood Approach (under SIR3)

 $\mathcal{D}_j$ . More precisely, we use Student distributions with different degrees of freedom as well as a hyperbolic secant distribution [see Baten (1934)]. The logarithms of the associated p.d.f. as well as the analytical expressions of their first two derivatives are reported in Table 1.

For each simulated sample, we apply different PLM approaches to estimate matrix  $C_0$ : the PML approach of Section 2 (with different sets of pseudo distributions  $(g_1, g_2)$ ) as well as the recursive PML approach of Subsection 2.6 (with different pseudo distributions  $g_1$ ).<sup>17</sup>

Because  $C_0$  is a 2-dimensional orthogonal matrix, it depends on a single parameter. Hence, in our exercise, we focus on the estimation of  $c_{1,1}$ , where this parameter is set at  $\cos(-\pi/5) = 0.809$ . Table 2 presents summary statistics associated with the distributions of the estimators  $\widehat{c}_{1,1}$  of  $c_{1,1}$ , for the different generating distributions  $(\mathcal{D}_1, \mathcal{D}_2)$ , estimation techniques and sample sizes T. The computation of these statistics is based on the set of obtained estimators  $\{\widehat{c}_{1,1}^{(i)}\}_{i \in [1,5000]}$ . Figures 1 displays the kernel-based distributions of  $\widehat{c}_{1,1}$  for T = 500.

The results suggest that the PML estimates of  $c_{1,1}$  tend to be negatively biased (Panel (a) in Table 2). As expected, the bias is smaller for larger samples. For all sample sizes, non-recursive PML estimates are more accurate than recursive ones: for instance, for 500-period (respectively 5000-period) samples, root-mean-squared errors (RMSEs) are twice (respectively 3 times) lower for non-recursive PML estimates than for recursive ones. This can also be seen on Figure 1 by comparing the upper and lower panels. Noteworthy is the fact that, for non-recursive PMLs, the choice of the pseudo distributions has a mild impact on the estimators accuracy. In particular, when the pseudo distributions  $(g_1, g_2)$  do not coincide with  $(\mathcal{D}_1, \mathcal{D}_2)$ , the data-generating ones, we do not observe a significant increase in the RMSEs of  $c_{1,1}$  estimates.

Based on the same simulations and estimations, we conduct another exercise to assess the small-sample validity of the asymptotic distributions of C's estimators. For each simulated sample  $i \in [1,5000]$ , we compute the asymptotic covariance matrix as detailed in Appendix 2. Then we use the asymptotic standard deviation estimate of  $c_{1,1}$ , denoted by  $\widehat{\sigma_{1,1}}^{(i)}$ , to derive a confidence interval of level  $\alpha$  for  $c_{1,1}$ ; this interval is  $[\widehat{c_{1,1}}^{(i)} - \phi_{\alpha/2}\widehat{\sigma_{1,1}}^{(i)}, \widehat{c_{1,1}}^{(i)} + \phi_{\alpha/2}\widehat{\sigma_{1,1}}^{(i)}]$ , where  $\phi_{\alpha/2}$  is such that  $P(X \in [-\phi_{\alpha/2}, \phi_{\alpha/2}]) = \alpha$ , if  $X \sim N(0,1)$ . Eventually, we compute the fraction of estimations for which  $c_{1,1}$  lies in the interval. Let us denote this fraction by  $f_{\alpha}$ . If the distribution of the finite-sample estimates of  $c_{1,1}$  were equal to the asymptotic one, we would have  $\alpha \equiv f_{\alpha}$ .

Table 3 shows the results of this exercise. Even for relatively short sample size (T = 200), the asymptotic distributions of the estimators are good approximations of their small-sample distribu-

 $<sup>^{17}</sup>$ For the recursive approach a single pseudo distribution is needed since in the bivariate case  $C_0$  depends on a single parameter and is therefore identified at the end of the first step.

<sup>&</sup>lt;sup>18</sup>The mixing matrix  $C_0$  is such that  $Vec(C_0) = [0.809, -0.588, 0.588, 0.809]'$ . Recall that C is identified up to sign and permutation of its columns. Therefore, the estimator  $\widehat{c_{1,1}}$  is an estimate of either  $c_{1,1}$ ,  $-c_{1,1}$ ,  $c_{1,2}$  or  $-c_{1,2}$ . In order to deal with this, after each estimation, we look for the transformation of  $\widehat{C}_T$  (out of 4) that is the closest to C (in the sense that the sum of the squared deviations between the elements of C and those of the transformed matrix  $\widehat{C}_T$  is the lowest), see discussion in Section 2.5.

tions. Indeed, in most cases, the fractions  $f_{\alpha}$  are close to the confidence levels  $\alpha$ . In particular, the asymptotic approximations do not appear to be worse in cases where the pseudo distributions do not coincide with the true generating ones.
