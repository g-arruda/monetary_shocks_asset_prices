# Acknowledgements

We thank Javier Hidalgo, Atsushi Inoue, Simone Manganelli, Nour Meddahi, Benoit Perron, Michael Wolf, Jonathan Wright, the associate editor and two anonymous referees for helpful comments. The views expressed in this paper do not necessarily reflect the opinion of the ECB or its staff.

#### Appendix.

Throughout this appendix, K denotes a generic constant independent of n. We use u.i. to mean uniformly integrable. Given an  $m \times n$  matrix A; let  $||A|| = \sum_{i=1}^m \sum_{j=1}^n |a_{ij}|$ ; for an  $m \times 1$  vector a, let  $|a| = \sum_{i=1}^m |a_i|$ . For any  $n \times n$  matrix A,  $diag(a_{11}, \ldots, a_{nn})$  denotes a diagonal matrix with  $a_{ii}$ ,  $i = 1, \ldots, n$  in the main diagonal. Similarly, let  $[a_{ij}]_{i,j=1,\ldots,n}$  denote a matrix A with typical element  $a_{ij}$ . For any bootstrap statistic  $T_n^*$  we write  $T_n^* \stackrel{P^*}{\to} 0$  in probability when  $\lim_{n \to \infty} P[P^*(|T_n^*| > \delta) > \delta] = 0$  for any  $\delta > 0$ , i.e.,  $P^*(|T_n^*| > \delta) = o_P(1)$ . We write  $T_n^* \Rightarrow^{d_{p^*}} D$ , in probability, for any distribution D, when weak convergence under the bootstrap probability measure occurs in a set with probability converging to one.

The following CLT will be useful in proving results for the bootstrap (cf. White, 1999, p. 133; the Lindeberg condition there has been replaced by the stronger Lyapunov condition here):

**Theorem A.1** (Martingale difference arrays CLT). Let  $\{Z_{nt}, \mathcal{F}_{nt}\}$  be a martingale difference array such that  $\sigma_{nt}^2 = \mathrm{E}(Z_{nt}^2), \ \sigma_{nt}^2 \neq 0$ , and define  $\bar{Z}_n \equiv n^{-1} \sum_{t=1}^n Z_{nt}$  and  $\bar{\sigma}_n^2 \equiv Var(\sqrt{n}\bar{Z}_n) = n^{-1} \sum_{t=1}^n \sigma_{nt}^2$ . If

1. 
$$n^{-1} \sum_{t=1}^{n} Z_{nt}^{2} / \bar{\sigma}_{n}^{2} - 1 \xrightarrow{P} 0$$
, and  
2.  $\lim_{n \to \infty} \bar{\sigma}_{n}^{-2(1+\delta)} n^{-(1+\delta)} \sum_{t=1}^{n} E|Z_{nt}|^{2(1+\delta)} = 0$  for some  $\delta > 0$ ,  
then  $\sqrt{n}\bar{Z}_{n} / \bar{\sigma}_{n} \Rightarrow N(0,1)$ .

The following lemma generalizes Kuersteiner's (2001) Lemma A.1. Kuersteiner's Assumption A.1 is stronger than our Assumption A in that it assumes that  $\{\varepsilon_t\}$  is strictly stationary and ergodic, and in that it imposes a summability condition on the fourth-order cumulants.

<span id="page-19-0"></span>**Lemma A.1.** Under Assumption A, for each  $m \in \mathbb{N}$ , m fixed, the vector

$$n^{-1/2}\sum_{t=1}^n (\varepsilon_t \varepsilon_{t-1}, \dots, \varepsilon_t \varepsilon_{t-m})' \Rightarrow \mathrm{N}(0, \Omega_m),$$

where  $\Omega_m = \sigma^4[\tau_{r,s}]_{r,s=1,\dots,m}$ .

Lemmas A.2–A.5 are used to prove the asymptotic validity of the recursive-design WB (cf. Theorem 3.2). In these lemmas,  $\hat{\varepsilon}_t^* = \hat{\varepsilon}_t \eta_t$ ,  $t = 1, \ldots, n$ , where  $\hat{\varepsilon}_t = y_t - \hat{\phi}' Y_{t-1}$ , and  $\eta_t$  is i.i.d. (0,1) such that  $E^* |\eta_t|^4 \leq \Delta < \infty$ .

**Lemma A.2.** *Under Assumption* A, *for fixed*  $j \in \mathbb{N}$ ,

- (i)  $n^{-1} \sum_{t=i+1}^{n} \hat{\varepsilon}_{t-i}^{*2} \xrightarrow{P^*} \sigma^2$ , in probability;
- (ii)  $n^{-1} \sum_{t=j+1}^{n} \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_t^* \stackrel{P^*}{\to} 0$ , in probability.

If we strengthen Assumption A by A'(vi'), then for fixed  $i, j \in \mathbb{N}$ ,

(iii)  $n^{-1} \sum_{t=\max(i,j)+1}^{n} \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_{t-i}^* \hat{\varepsilon}_{t}^{*2} \xrightarrow{P^*} \sigma^4 \tau_{i,j} 1 (i=j)$ , in probability, where 1(i=j) is 1 if i=j, and 0 otherwise.

The following lemma is the WB analogue of Lemma A.1.

**Lemma A.3.** Under Assumption A strengthened by A(vi'), for all fixed  $m \in \mathbb{N}$ ,

$$n^{-1/2} \sum_{t=m+1}^{n} (\hat{\varepsilon}_t^* \hat{\varepsilon}_{t-1}^*, \dots, \hat{\varepsilon}_t^* \hat{\varepsilon}_{t-m}^*)' \Rightarrow^{d_{P^*}} \mathrm{N}(0, \tilde{\Omega}_m),$$

in probability, where  $\tilde{\Omega}_m \equiv \sigma^4 \operatorname{diag}(\tau_{1,1}, \dots, \tau_{m,m})$  and  $\Rightarrow^{d_{P^*}}$  denotes weak convergence under the bootstrap probability measure.

**Lemma A.4.** Suppose Assumption A holds. Then  $n^{-1} \sum_{t=1}^{n} Y_{t-1}^* Y_{t-1}^{*'} \xrightarrow{P^*} A$ , in probability, where  $A \equiv \sigma^2 \sum_{j=1}^{\infty} b_j b_j'$ .

**Lemma A.5.** Suppose Assumption A strengthened by A(vi') holds. Then

$$n^{-1/2} \sum_{t=1}^{n} Y_{t-1}^* \hat{\varepsilon}_t^* \Rightarrow^{d_{P^*}} N(0, \tilde{B}),$$

in probability, where  $\tilde{B} = \sum_{j=1}^{\infty} b_j b_j' \sigma^4 \tau_{j,j}$ .

**Proof of Theorem 3.1.** We show that (i)  $A_{1n} \equiv n^{-1} \sum_{t=1}^{n} Y_{t-1} Y_{t-1}^{\prime} \stackrel{P}{\to} A$ ; and (ii)  $A_{2n} \equiv n^{-1/2} \sum_{t=1}^{n} Y_{t-1} \varepsilon_{t} \Rightarrow N(0,B)$ . First, notice that for any stationary AR(p) process we have  $y_{t} = \sum_{j=0}^{\infty} \psi_{j} \varepsilon_{t-j}$ , where  $\{\psi_{j}\}$  satisfies the recursion  $\psi_{s} - \phi_{1} \psi_{s-1} - \cdots - \phi_{p} \psi_{s-p} = 0$  with  $\psi_{0} = 1$  and  $\psi_{j} = 0$  for j < 0, implying that  $\sum_{j=0}^{\infty} j |\psi_{j}| < \infty$ . We can write  $Y_{t-1} = 0$ 

 $(\sum_{j=0}^{\infty} \psi_j \varepsilon_{t-1-j}, \dots, \sum_{j=0}^{\infty} \psi_j \varepsilon_{t-p-j})' = \sum_{j=1}^{\infty} b_j \varepsilon_{t-j}$  with  $b_j = (\psi_{j-1}, \dots, \psi_{j-p})'$ , where  $\psi_{-j} = 0$  for all j > 0. Hence, by direct evaluation,

$$A \equiv E(Y_{t-1}Y'_{t-1}) = E\left[\left(\sum_{j=1}^{\infty} \sum_{i=1}^{\infty} b_j b'_i \varepsilon_{t-j} \varepsilon_{t-i}\right)\right] = \sigma^2 \sum_{j=1}^{\infty} b_j b'_j$$
$$= \left[\sigma^2 \sum_{j=0}^{\infty} \psi_j \psi_{j+|k-l|}\right]_{k,l=1,\dots,p},$$

since  $\mathrm{E}(\varepsilon_{t-i}\varepsilon_{t-j})=0$  for  $i\neq j$  under the m.d.s. assumption, and  $\sum_{j=0}^{\infty}|\psi_j\psi_{j+|k-l|}|\leqslant\sum_{j=0}^{\infty}|\psi_j|\sum_{j=0}^{\infty}|\psi_j+|k-l|}|\leqslant\sum_{j=0}^{\infty}|\psi_j|\sum_{j=0}^{\infty}|\psi_j+|k-l|}|<\infty$  for all k,l. To show (i), for fixed  $m\in\mathbb{N}$ , define  $A_{1n}^m\equiv n^{-1}\sum_{t=1}^nY_{t-1,m}Y'_{t-1,m}$ , where  $Y_{t-1,m}=\sum_{j=1}^mb_j\varepsilon_{t-j}$ . It suffices to show: (a)  $A_{1n}^m\stackrel{P}{\to} A$  as  $m\to\infty$ , and (c)  $\lim_{m\to\infty}\lim\sup_{n\to\infty}P[\|A_{1n}-A_{1n}^m\|\geqslant\delta]=0$  for all  $\delta>0$  (cf. Proposition 6.3.9 of Brockwell and Davis (BD), 1991, p. 207). For (a), we have  $A_{1n}^m=\sum_{j=1}^m\sum_{i=1}^mb_jb'_in^{-1}$   $\sum_{t=1}^n\varepsilon_{t-j}\varepsilon_{t-i}$ . For fixed  $i\neq j$  it follows that  $n^{-1}\sum_{t=1}^n\varepsilon_{t-j}\varepsilon_{t-i}\stackrel{P}{\to} 0$  by Andrews' (1988) LLN for u.i.  $L_1$ -mixingales, since  $\{\varepsilon_{t-j}\varepsilon_{t-i}\}$  is a m.d.s. with  $\mathrm{E}|\varepsilon_{t-j}\varepsilon_{t-i}|^r\leqslant\|\varepsilon_{t-j}\|_{2r}^r\|\varepsilon_{t-i}\|_{2r}^r<A^{2r}<\infty$  by Cauchy–Schwartz and Assumption A(vi). For fixed i=j, we can write  $n^{-1}\sum_{t=1}^n\varepsilon_{t-j}^2-\sigma^2=n^{-1}\sum_{t=1}^nz_t+n^{-1}\sum_{t=1}^n\mathrm{E}(\varepsilon_{t-j}^2)=\varepsilon_{t-j-1}-\sigma^2$ , with  $z_t=\varepsilon_{t-j}^2-\mathrm{E}(\varepsilon_{t-j}^2)=\varepsilon_{t-j-1}-\sigma^2$ . Since  $z_t$  can be shown to be an u.i. m.d.s, the first term goes to zero in probability by Andrews' LLN. The second term vanishes in probability by Assumption A(iii). Thus,  $n^{-1}\sum_{t=1}^n\varepsilon_{t-j}^2-\sigma^2\stackrel{P}{\to}0$  for fixed j. It follows that  $A_{1n}^m\stackrel{P}{\to}\sigma^2\sum_{j=1}^mb_jb_j'\equiv A_1^m$ , which completes the proof of (a). Part (b) follows from the dominated convergence theorem, given that  $\|\sum_{j=1}^\infty b_jb_j'\|\leqslant\sum_{j=1}^\infty|b_j|^2<\infty$ . To prove (c), note that for any  $\delta>0$ ,

$$\begin{split} P[\|A_{1n} - A_{1n}^m\| \geqslant \delta] \leqslant \frac{1}{\delta} \, \mathrm{E} \|A_{1n} - A_{1n}^m\| \\ \leqslant \frac{2}{\delta} \left( \sum_{j>m}^{\infty} |b_j| \right) \left( \sum_{j=1}^{\infty} |b_j| \right) n^{-1} \sum_{t=1}^{n} \mathrm{E} |\varepsilon_{t-i}\varepsilon_{t-j}| \\ \leqslant \left( \sum_{j>m}^{\infty} |b_j| \right) K \to 0 \quad \text{as } m \to \infty, \end{split}$$

since  $E|\varepsilon_{t-i}\varepsilon_{t-j}| \leq \Delta$  for some  $\Delta < \infty$ , and since  $\sum_{j=1}^{\infty} |b_j| < \infty$ . Next, we prove (ii). We apply Proposition 6.3.9 of BD. Let  $Z_t = Y_{t-1}\varepsilon_t \equiv \sum_{j=1}^{\infty} b_j\varepsilon_{t-j}\varepsilon_t$ . For fixed m, define  $Z_t^m = Y_{t-1,m}\varepsilon_t = \sum_{j=1}^m b_j\varepsilon_{t-j}\varepsilon_t$ , where  $Y_{t-1,m}$  is defined as above. We first

show that  $n^{-1/2} \sum_{t=1}^n Z_t^m \Rightarrow N(0,B_m)$ , with  $B_m = \sum_{i=1}^m \sum_{j=1}^m b_j b_j' \sigma^4 \tau_{j,i}$ . We have

$$n^{-1/2} \sum_{t=1}^{n} Z_{t}^{m} = n^{-1/2} \sum_{t=1}^{n} \sum_{j=1}^{m} b_{j} \varepsilon_{t-j} \varepsilon_{t} = \sum_{i=1}^{m} b_{j} n^{-1/2} \sum_{t=1}^{n} \varepsilon_{t-j} \varepsilon_{t} \equiv \sum_{i=1}^{m} b_{j} \chi_{nj}.$$

By Lemma A.1 we have that  $(\chi_{n1}, \ldots, \chi_{nm})' \Rightarrow N(0, \Omega_m)$ . Thus,  $\sum_{j=1}^m b_j \chi_{nj} \Rightarrow N(0, B_m)$ , with  $B_m = b' \Omega_m b$ ,  $b' = (b_1, \ldots, b_m)$ . Since  $\|\sum_{j=1}^\infty \sum_{i=1}^\infty b_j b_i' \sigma^4 \tau_{j,i}\| \leqslant \sum_{j=1}^\infty \sum_{i=1}^\infty |b_j| |b_i| \sigma^4 |\tau_{j,i}| < \infty$ , it follows that  $B_m \to B \equiv \sum_{j=1}^\infty \sum_{i=1}^\infty b_j b_i' \sigma^4 \tau_{j,i}$  as  $m \to \infty$ . Finally, for any  $\lambda \in \mathbb{R}^p$  such that  $\lambda' \lambda = 1$  and for any  $\delta > 0$ , we have

$$\lim_{m \to \infty} \lim \sup_{n \to \infty} P\left[ \left| n^{-1/2} \sum_{t=1}^{n} \lambda' Z_{t} - n^{-1/2} \sum_{t=1}^{n} \lambda' Z_{t}^{m} \right| \geqslant \delta \right]$$

$$= \lim_{m \to \infty} \lim \sup_{n \to \infty} P\left[ \left| n^{-1/2} \sum_{t=1}^{n} \sum_{j > m} \lambda' b_{j} \varepsilon_{t-j} \varepsilon_{t} \right| \geqslant \delta \right]$$

$$\leq \lim_{m \to \infty} \lim \sup_{n \to \infty} \frac{1}{n\delta^{2}} \operatorname{E}\left( \left| \sum_{t=1}^{n} \sum_{j > m} \lambda' b_{j} \varepsilon_{t-j} \varepsilon_{t} \right|^{2} \right)$$

$$= \lim_{m \to \infty} \frac{1}{\delta^{2}} \left( \sum_{j > m} \sum_{i > m} \lambda' b_{j} b'_{i} \lambda \sigma^{4} \tau_{j,i} \right) = 0,$$

where the inequality holds by Chebyshev's inequality, the second-to-last equality holds by the fact that  $E(\varepsilon_{t-j}\varepsilon_t\varepsilon_{s-i}\varepsilon_s)=0$  for  $s\neq t$ , and all i,j, and the last equality holds by the summability of  $\{\psi_i\}$  and the fact that  $\tau_{i,i}$  are uniformly bounded.  $\square$ 

**Proof of Theorem 3.2.** By Lemma A.4,  $n^{-1} \sum_{t=1}^{n} Y_{t-1}^{*} Y_{t-1}^{*'} \stackrel{P^{*}}{\to} A$ , in probability, whereas Lemma A.5 implies  $n^{-1/2} \sum_{t=1}^{n} Y_{t-1}^{*} \hat{\varepsilon}_{t}^{*} \Rightarrow^{d_{P^{*}}} N(0, \tilde{B})$ , in probability. Since under Assumption A(iv'),  $B = \tilde{B}$ , the result follows by Polya's Theorem, given that the normal distribution is everywhere continuous.  $\square$ 

**Proof of Theorem 3.3.** We need to show that (a)  $n^{-1} \sum_{t=1}^{n} Y_{t-1} Y_{t-1}' \xrightarrow{P} A$ , and (b)  $n^{-1/2} \sum_{t=1}^{n} Y_{t-1} \hat{\varepsilon}_{t}^{*} \Rightarrow^{d_{P^{*}}} N(0,B)$  in probability. Part (a) was proved in Theorem 3.1. To show part (b) note that

$$n^{-1/2} \sum_{t=1}^{n} Y_{t-1} \hat{\varepsilon}_{t}^{*} = n^{-1/2} \sum_{t=1}^{n} Y_{t-1} \varepsilon_{t} \eta_{t} - n^{-1/2} \sum_{t=1}^{n} Y_{t-1} (\varepsilon_{t} - \hat{\varepsilon}_{t}) \eta_{t}$$

$$= n^{-1/2} \sum_{t=1}^{n} Y_{t-1} \varepsilon_{t} \eta_{t} - n^{-1} \sum_{t=1}^{n} Y_{t-1} Y'_{t-1} \eta_{t} \sqrt{n} (\hat{\phi} - \phi) \equiv A_{1}^{*} - A_{2}^{*}.$$

First, note that  $A_2^* \xrightarrow{P^*} 0$ , in probability, since  $\sqrt{n}(\hat{\phi} - \phi) = O_P(1)$  and  $n^{-1} \sum_{t=1}^n Y_{t-1} Y_{t-1} Y_{t-1} \eta_t \xrightarrow{P^*} 0$ , in probability. This follows from showing that  $E^*(n^{-1} \sum_{t=1}^n Y_{t-1} Y_{t-1}' \eta_t) = 0$ 

and  $Var^*(n^{-1}\sum_{t=1}^n Y_{t-1}Y'_{t-1}\eta_t) = n^{-2}\sum_{t=1}^n Y_{t-1}Y'_{t-1}Y_{t-1}Y'_{t-1} \stackrel{P}{\to} 0$ , under Assumption A. We next show  $A_1^* \Rightarrow^{d_{P^*}} N(0,B)$  in probability, where  $B = Var(n^{-1/2}\sum_{t=1}^n Y_{t-1}\varepsilon_t) = n^{-1}\sum_{t=1}^n E(Y_{t-1}Y'_{t-1}\varepsilon_t^2)$ . For any  $\lambda \in \mathbb{R}^P$ ,  $\lambda'\lambda = 1$ , let  $Z_t^* = \lambda'Y_{t-1}\varepsilon_t\eta_t$ .  $\{Z_t^*\}$  is (conditionally) independent such that  $E^*(n^{-1/2}\sum_{t=1}^n Z_t^*) = 0$  and  $Var^*(n^{-1/2}\sum_{t=1}^n Z_t^*) = \lambda'n^{-1}\sum_{t=1}^n Y_{t-1}Y'_{t-1}\varepsilon_t^2\lambda$ . We now apply Lyapunov's Theorem (e.g. Durrett, 1996, p. 121). Let  $\alpha_n^{*2} = \lambda'\sum_{t=1}^n Y_{t-1}Y'_{t-1}\varepsilon_t^2\lambda$ . By arguments similar to Theorem 3.1,  $n^{-1}\alpha_n^{*2} \stackrel{P}{\to} B$ . If for some r > 1

$$\alpha_n^{*-2r} \sum_{t=1}^n E^* |Z_t^*|^{2r} \xrightarrow{P} 0$$
 (A.1)

then  $\alpha_n^{*-1} \sum_{t=1}^n Z_t^* \Rightarrow^{d_{P^*}} N(0,1)$  in probability. By Slutsky's Theorem, it follows that  $n^{-1/2} \sum_{t=1}^n Z_t^* \Rightarrow^{d_{P^*}} N(0,\lambda'B\lambda)$ . To show (A.1), note that the LHS can be written as

$$\left(\frac{\alpha_n^{*2}}{n}\right)^{-r} n^{-r} \sum_{t=1}^n |\lambda' Y_{t-1} \varepsilon_t|^{2r} \mathbf{E}^* |\eta_t|^{2r}.$$

Thus, it suffices to show that  $E|n^{-r}\sum_{t=1}^n |\lambda' Y_{t-1}\varepsilon_t|^{2r}E^*|\eta_t|^{2r}| \to 0$ . Since  $E^*|\eta_t|^{2r} \leqslant \Delta < \infty$ , this holds provided  $E|\lambda' Y_{t-1}\varepsilon_t|^{2r} \leqslant \Delta < \infty$ , which follows under Assumption A.  $\square$ 

**Proof of Theorem 3.4.** Let  $\hat{\varepsilon}_t = y_t - \hat{\phi}' Y_{t-1}$ ,  $\hat{\varepsilon}_t^* = y_t^* - \hat{\phi}' Y_{t-1}^*$ , and  $\varepsilon_t^* = y_t^* - \phi' Y_{t-1}^*$ . We show that (i)  $n^{-1} \sum_{t=1}^n Y_{t-1}^* Y_{t-1}^{*'} \xrightarrow{P^*} A$  in probability, and (ii)  $n^{-1/2} \sum_{t=1}^n Y_{t-1}^* \hat{\varepsilon}_t^* \Rightarrow^{d_{P^*}} N(0,B)$  in probability. We can write,

$$n^{-1} \sum_{t=1}^{n} Y_{t-1}^{*} Y_{t-1}^{*'} - A = \left\{ n^{-1} \sum_{t=1}^{n} Y_{t-1}^{*} Y_{t-1}^{*'} - n^{-1} \sum_{t=1}^{n} Y_{t-1} Y_{t-1}' \right\}$$

$$+ \left\{ n^{-1} \sum_{t=1}^{n} Y_{t-1} Y_{t-1}' - A \right\} \equiv A_{1}^{*} + A_{2}.$$

Theorem 3.1 shows  $A_2 \stackrel{P}{\to} 0$ . Next we show  $A_1^* \stackrel{P^*}{\to} 0$ , in probability. Conditional on the data, by Chebyshev's inequality, it suffices that  $E^*(A_1^*A_1^{*\prime}) = o_P(1)$ . But

$$E^*(A_1^*A_1^{*\prime}) = n^{-1}E^* \left( n^{-1} \sum_{t=1}^n \sum_{s=1}^n \left( Y_{t-1}^* Y_{t-1}^{*\prime} - n^{-1} \sum_{t=1}^n Y_{t-1} Y_{t-1}^{\prime} \right) \right)$$

$$\times \left( Y_{s-1}^* Y_{s-1}^{*\prime} - n^{-1} \sum_{t=1}^n Y_{t-1} Y_{t-1}^{\prime} \right)^{\prime} \right)$$

$$= n^{-1} \left\{ n^{-1} \sum_{t=1}^n \left( Y_{t-1} Y_{t-1}^{\prime} - n^{-1} \sum_{t=1}^n Y_{t-1} Y_{t-1}^{\prime} \right) \right\}$$

$$\times \left( Y_{t-1} Y_{t-1}^{\prime} - n^{-1} \sum_{t=1}^n Y_{t-1} Y_{t-1}^{\prime} \right)^{\prime} \right\},$$

where the term in curly brackets is  $O_P(1)$  given Assumption A (in particular, given A(vi)), delivering the result. Next we show (ii). We can write

$$n^{-1/2} \sum_{t=1}^{n} Y_{t-1}^* \hat{\varepsilon}_t^* = n^{-1/2} \sum_{t=1}^{n} \left( Y_{t-1}^* \varepsilon_t^* - n^{-1} \sum_{t=1}^{n} Y_{t-1} \varepsilon_t \right)$$

$$+ \left( n^{-1} \sum_{t=1}^{n} Y_{t-1} Y_{t-1}' - n^{-1} \sum_{t=1}^{n} Y_{t-1}^* Y_{t-1}^{*\prime} \right) \sqrt{n} (\hat{\phi} - \phi) \equiv B_1^* + B_2^*.$$

Since  $B_2^* \stackrel{P^*}{\to} 0$  in probability, (ii) follows if we prove that  $B_1^* \Rightarrow^{d_{P^*}} N(0,B)$  in probability. This follows straightforwardly by an application of Lyapunov's CLT, given that  $Z_t^* \equiv Y_{t-1}^* \varepsilon_t^* - n^{-1} \sum_{t=1}^n Y_{t-1} \varepsilon_t$  is (conditionally) i.i.d. with mean zero and variance  $Var^*(Z_t^*) = n^{-1} \sum_{t=1}^n Z_t Z_t'$ , where  $Z_t \equiv Y_{t-1} \varepsilon_t - n^{-1} \sum_{t=1}^n Y_{t-1} \varepsilon_t$ , and by arguments similar to those used in the proof of Theorem 3.1,  $n^{-1} \sum_{t=1}^n Y_{t-1} Y_{t-1}' \varepsilon_t^2 \stackrel{P}{\to} B$  and  $n^{-1} \sum_{t=1}^n Y_{t-1} \varepsilon_t \stackrel{P}{\to} 0$ .  $\square$ 

**Proof of Corollary 3.1.** Given the previous results, it suffices to show that  $\hat{C}^* \stackrel{P^*}{\to} C$ , i.e., (i)  $\hat{A}^* \stackrel{P^*}{\to} A$ , and (ii)  $\hat{B}^* \stackrel{P^*}{\to} B$ , in probability, where  $B = \tilde{B}$  for the recursive-design WB. We showed (i) in Lemma A.4 for the recursive-design WB, and in Theorems 3.3 and 3.4, for the fixed-design WB and pairwise bootstrap, respectively. Next, we sketch the proof of (ii). For simplicity we take p = 1. The proof for general p is similar. For each of the three bootstrap schemes, we can write  $\tilde{\epsilon}_t^* = \hat{\epsilon}_t^* - (\hat{\phi}^* - \hat{\phi})y_{t-1}^*$ , where  $\hat{\epsilon}_t^* = \hat{\epsilon}_t \eta_t$  for the recursive-design and fixed-design WB, and  $\hat{\epsilon}_t^* = y_t^* - \hat{\phi}y_{t-1}^*$  for the pairwise bootstrap. Thus,

$$\hat{B}^* = \hat{B}_1^* + \hat{B}_2^* + \hat{B}_3^*, \quad \text{with}$$

$$\hat{B}_1^* = n^{-1} \sum_{t=1}^n y_{t-1}^{*2} \hat{\varepsilon}_t^{*2}, \quad \hat{B}_2^* = -2(\hat{\phi}^* - \hat{\phi}) n^{-1} \sum_{t=1}^n y_{t-1}^{*3} \hat{\varepsilon}_t^*, \quad \text{and}$$

$$\hat{B}_3^* = (\hat{\phi}^* - \hat{\phi})^2 n^{-1} \sum_{t=1}^n y_{t-1}^{*4}.$$

It is enough to show that with probability approaching one, (a)  $\hat{B}_1^* \stackrel{P^*}{\to} B$ , (b)  $\hat{B}_2^* \stackrel{P^*}{\to} 0$ , and (c)  $\hat{B}_3^* \stackrel{P^*}{\to} 0$ . For the fixed-design WB, starting with (a), note that  $y_{t-1}^* = y_{t-1}$ , and therefore  $\hat{B}_1^* - B = n^{-1} \sum_{t=1}^n y_{t-1}^2 \hat{\varepsilon}_t^2 (\eta_t^2 - 1) + n^{-1} \sum_{t=1}^n y_{t-1}^2 \hat{\varepsilon}_t^2 - B \equiv \chi_1 + \chi_2$ . Under our assumptions  $\chi_2 \stackrel{P}{\to} 0$ . Since  $\hat{\varepsilon}_t = \varepsilon_t - (\hat{\phi} - \phi)y_{t-1}$ , we can write  $\chi_1 = n^{-1} \sum_{t=1}^n y_{t-1}^2 \varepsilon_t^2 (\eta_t^2 - 1) - 2(\hat{\phi} - \phi)n^{-1} \sum_{t=1}^n y_{t-1}^3 \varepsilon_t (\eta_t^2 - 1) + (\hat{\phi} - \phi)^2 n^{-1} \sum_{t=1}^n y_{t-1}^4 (\eta_t^2 - 1)$ . We can show that each of these terms is  $o_{P^*}(1)$  in probability. For the first term, write  $z_t = y_{t-1}^2 \varepsilon_t^2 (\eta_t^2 - 1)$ , and note that  $z_t$  is (conditionally) a m.d.s. with respect to  $\mathscr{F}_t^* = \sigma(\eta_t, \dots, \eta_1)$ . Thus, by Andrews' (1988) LLN, it follows that  $n^{-1} \sum_{t=1}^n z_t \stackrel{P^*}{\to} 0$ , in probability, provided that  $E^*|z_t|^r = O_P(1)$ , or  $E(E^*|z_t|^r) = O(1)$ , for some r > 1, which holds under our moment conditions (in particular, the existence of 4r moments of  $\varepsilon_t$  suffices). A similar

argument applies to the last two terms of  $\chi_1$ , where we note that  $\hat{\phi} - \phi \stackrel{P}{\to} 0$ . For (b), and given  $\hat{\phi}^* - \hat{\phi} = o_{P^*}(1)$ , it suffices that  $n^{-1} \sum_{t=1}^n y_{t-1}^3 \hat{\varepsilon}_t^* = O_{P^*}(1)$ , in probability, or that  $E^*|n^{-1} \sum_{t=1}^n y_{t-1}^3 \hat{\varepsilon}_t^*| = O_P(1)$ . This condition holds under Assumption A (first apply the triangle inequality, then use the definition of  $\hat{\varepsilon}_t$ , and finally apply repeatedly the Cauchy–Schwartz inequality to the sums involving products of  $y_{t-1}$  and/or  $\varepsilon_t$ .). For (c), by a reasoning similar to (b), it suffices that  $n^{-1} \sum_{t=1}^n y_{t-1}^4 = O_P(1)$ , which holds under our moment conditions. For the pairwise bootstrap, we proceed similarly, but rely on the (conditional) independence of  $(y_t^*, y_{t-1}^*)$  to obtain the results. In particular, for (a), following Theorem 3.3 we can define  $\hat{\varepsilon}_t^* = \varepsilon_t^* - (\hat{\phi} - \phi)y_{t-1}^*$ , with  $\varepsilon_t^* = y_t^* - \phi y_{t-1}^*$ , which implies  $\hat{B}_1^* \equiv \chi_1 + \chi_2$ , say. In particular,  $\chi_1 = n^{-1} \sum_{t=1}^n z_{1t}^* + \zeta$ , where  $z_{1t}^* = y_{t-1}^* \varepsilon_{t-1}^* - n^{-1} \sum_{t=1}^n y_{t-1}^2 \varepsilon_t^2$  and  $\zeta = n^{-1} \sum_{t=1}^n y_{t-1}^2 \varepsilon_t^2$ . Under our conditions,  $\zeta \stackrel{P}{\to} B$ . Since  $z_{1t}^*$  is a uniformly square-integrable m.d.s. (conditional on the original data), Andrews' LLN implies that the first term of  $\chi_1$  is  $o_{P^*}(1)$  in probability. Similarly, we can show that  $\chi_2 = o_{P^*}(1)$  in probability. For the recursive-design WB, for part (a), note that we can write  $\hat{B}_1^* = \chi_1 + \chi_2$ , where  $\chi_1 = \sum_{j=1}^{n-1} \hat{\psi}_{j-1}^2 (n^{-1} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^{*2} \hat{\varepsilon}_t^{*2})$ , and  $\chi_2 = n^{-1} \sum_{t=1}^n \sum_{i,j=1,i\neq j}^{t-1} \hat{\psi}_{j-1} \hat{\psi}_{i-1} \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_t^{*2}$ . Now, using arguments analogous to those used in the proof of Lemmas A.4 and A.5 we can show that  $\chi_1 \stackrel{P^*}{\to} \tilde{B}$ , and  $\chi_2 \stackrel{P^*}{\to} 0$ , in probability. Similar arguments apply for (b) and (c).

**Proof of Lemma A.1.** The proof follows closely that of Lemma A.1 of Kuersteiner (2001). We reproduce his steps under our weaker Assumption A. In particular, we show that for all  $\lambda \in \mathbb{R}^m$  such that  $\lambda' \lambda = 1$  we have  $n^{-1/2} \sum_{t=1}^n \lambda' W_t \Rightarrow \mathrm{N}(0, \lambda' \Omega_m \lambda)$ , where  $W_t = (\varepsilon_t \varepsilon_{t-1}, \ldots, \varepsilon_t \varepsilon_{t-m})'$ . Noting that  $\{W_t, \mathcal{F}_t\}$  is a vector m.d.s., we check the m.d.s. CLT conditions (cf. Davidson, 1994, Theorem 24.3). Let  $Z_t = \lambda' W_t$ . We check: (i)  $n^{-1} \sum_{t=1}^n [Z_t^2 - \mathrm{E}(Z_t^2)] \xrightarrow{P} 0$ , where  $\mathrm{E}(Z_t^2) = \lambda' \mathrm{E}(W_t W_t') \lambda = \lambda' \Omega_m \lambda$ ; and (ii)  $n^{-1/2} \max_{1 \le t \le n} |Z_t| \xrightarrow{P} 0$ . To see (i), note that  $n^{-1} \sum_{t=1}^n [Z_t^2 - \mathrm{E}(Z_t^2)] = A_1 + A_2$ , with

$$A_1 = n^{-1} \sum_{t=1}^{n} \left[ Z_t^2 - \mathbb{E}(Z_t^2 | \mathscr{F}_{t-1}) \right] \quad \text{and} \quad A_2 = n^{-1} \sum_{t=1}^{n} \left[ \mathbb{E}(Z_t^2 | \mathscr{F}_{t-1}) - \mathbb{E}(Z_t^2) \right].$$

First consider  $A_1$ . Since  $\{Z_t^2 - \mathrm{E}(Z_t^2|\mathscr{F}_{t-1}), \mathscr{F}_t\}$  is a m.d.s., we have that  $Z_t^2 - \mathrm{E}(Z_t^2|\mathscr{F}_{t-1})$  is an  $L_1$ -mixingale with mixingale constants  $c_t = \mathrm{E}|Z_t^2 - \mathrm{E}(Z_t^2|\mathscr{F}_{t-1})|$ :  $\mathrm{E}|\mathrm{E}(Z_t^2 - \mathrm{E}(Z_t^2|\mathscr{F}_{t-1})|\mathscr{F}_{t-k})| \leqslant c_t \zeta_k, \ k = 0, 1, \ldots$ , with  $\zeta_k = 1$  for k = 0 and  $\zeta_k = 0$  otherwise. Thus, we apply Andrews' LLN for  $L_1$ -mixingales (Andrews, 1988) to show  $A_1 \stackrel{P}{\to} 0$ . It suffices that for some r > 1,  $\mathrm{E}|Z_t^2|^r \leqslant K < \infty$  and  $n^{-1} \sum_{t=1}^n c_t < \infty$ . Now,  $\mathrm{E}|Z_t|^{2r} = \mathrm{E}|\sum_{i=1}^m \lambda_i \varepsilon_t \varepsilon_{t-i}|^{2r} \leqslant (\sum_{i=1}^m |\lambda_i| \|\varepsilon_t \varepsilon_{t-i}\|_{2r})^{2r} < K$  by repeated application of Minkowski and Cauchy–Schwartz, given Assumption A(vi). The second condition on  $\{c_t\}$  follows similarly. Next we consider  $A_2$ . We have that

$$A_{2} = \lambda' n^{-1} \sum_{t=1}^{n} (\mathbb{E}(W_{t}W'_{t}|\mathscr{F}_{t-1}) - \mathbb{E}(W_{t}W'_{t}))\lambda$$

$$= \lambda' \left[ n^{-1} \sum_{t=1}^{n} \varepsilon_{t-i}\varepsilon_{t-j} \mathbb{E}(\varepsilon_{t}^{2}|\mathscr{F}_{t-1}) - \sigma^{4}\tau_{i,j} \right]_{i,j=1,\dots,p} \lambda \stackrel{P}{\to} 0,$$

given Assumption A(v). This proves (i). To prove (ii), note that by Markov's inequality, for any  $\delta > 0$  and for some r > 1,

$$P\left(\frac{1}{\sqrt{n}}\max_{1\leqslant t\leqslant n}|Z_t|>\delta\right)\leqslant \sum_{t=1}^n P(|Z_t|>n^{1/2}\delta)\leqslant \delta^{-2r}n^{-r}\sum_{t=1}^n \mathrm{E}|Z_t|^{2r}$$
  
$$\leqslant K\delta^{-2r}n^{1-r}\to 0.$$

**Proof of Lemma A.2.** First we consider (i) with j = 0, without loss of generality. By definition,  $\hat{e}_t^* \equiv \hat{e}_t \eta_t$ , and thus

$$n^{-1}\sum_{t=1}^{n}\hat{\varepsilon}_{t}^{*2}-\sigma^{2}=\left[n^{-1}\sum_{t=1}^{n}\hat{\varepsilon}_{t}^{2}(\eta_{t}^{2}-1)\right]+\left[n^{-1}\sum_{t=1}^{n}\hat{\varepsilon}_{t}^{2}-\sigma^{2}\right]\equiv F_{1}^{*}+F_{2},$$

with the obvious definitions. Under our assumptions  $F_2 = o_P(1)$ . So it suffices to show that  $P^*[|F_1^*| > \delta] = o_P(1)$ , for any  $\delta > 0$ , or, by Chebyshev's inequality, that  $E^*((F_1^*)^2) = o_P(1)$ . Let  $z_t^* \equiv \hat{\varepsilon}_t^2(\eta_t^2 - 1)$  and note that  $E^*(z_t^*z_s^*) = 0$  for  $t \neq s$ ,  $E^*(z_t^{*2}) = \hat{\varepsilon}_t^4 E^*(\eta_t^4 - 2\eta_t^2 + 1) = \hat{\varepsilon}_t^4(E^*(\eta_t^4) - 1)$ . Thus,

$$E^*[(F_1^*)^2] = E^* \left( n^{-2} \sum_{t=1}^n \sum_{s=1}^n z_t^* z_s^* \right) = n^{-1} \left( n^{-1} \sum_{t=1}^n \hat{\varepsilon}_t^4 (E^*(\eta_t^4) - 1) \right)$$

$$\leq n^{-1} K \left( n^{-1} \sum_{t=1}^n \hat{\varepsilon}_t^4 \right) = o_P(1),$$

where the last inequality holds by  $E^*(\eta_t^4) \leq \Delta < \infty$  and  $n^{-1} \sum_{t=1}^n \hat{\varepsilon}_t^4 = O_P(1)$ , given that  $E|\varepsilon_t|^4 < K < \infty$  and that  $\hat{\phi} \to \phi$  in probability. For (ii), by a similar reasoning, it suffices to note that

$$\mathbb{E}^* \left[ \left( n^{-1} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_t^* \right)^2 \right] = n^{-2} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^2 \hat{\varepsilon}_t^2 \mathbb{E}^* (\eta_t^2 \eta_{t-j}^2) = n^{-2} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^2 \hat{\varepsilon}_t^2 = o_P(1).$$

For (iii), note that

$$n^{-1} \sum_{t=\max(i,j)+1}^{n} \hat{\varepsilon}_{t-i}^* \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_{t}^{*2} - \sigma^4 \tau_{i,j} 1(i=j)$$

$$= n^{-1} \sum_{t=\max(i,j)+1}^{n} \hat{\varepsilon}_{t-i} \hat{\varepsilon}_{t-j} \hat{\varepsilon}_{t}^{2} (\eta_t^2 \eta_{t-i} \eta_{t-j} - 1(i=j))$$

$$+ n^{-1} \sum_{t=\max(i,j)+1}^{n} (\hat{\varepsilon}_{t-i} \hat{\varepsilon}_{t-j} \hat{\varepsilon}_{t}^{2} - \sigma^4 \tau_{ij}) 1(i=j) \equiv G_1^* + G_2.$$

Under our assumptions, for any fixed i, j,

$$n^{-1} \sum_{t=\max(i,i)+1}^{n} \hat{\varepsilon}_{t-i} \hat{\varepsilon}_{t-j} \hat{\varepsilon}_{t}^{2} = n^{-1} \sum_{t=\max(i,i)+1}^{n} \varepsilon_{t-i} \varepsilon_{t-j} \varepsilon_{t}^{2} + R_{n},$$

where the remainder  $R_n$  involves products of elements of  $\hat{\phi} - \phi$ , which are  $o_P(1)$  under our assumptions, with averages of products of elements of  $Y_{t-1-j}$  and  $\varepsilon_t$ , up to the fourth order, which are bounded in probability, given that  $E|\varepsilon_t|^4 < \Delta < \infty$ . Thus,  $R_n = o_P(1)$ , and since  $n^{-1} \sum_{t=\max(i,j)+1}^n \varepsilon_{t-i}\varepsilon_{t-j}\varepsilon_t^2 \to \sigma^4\tau_{i,j}$  (cf. proof of Lemma A.1), it follows that  $G_2 = o_P(1)$ . So, if we let  $z_t^{*(i,j)} = \hat{\varepsilon}_{t-i}\hat{\varepsilon}_{t-j}\hat{\varepsilon}_t^2(\eta_{t-i}\eta_{t-j}\eta_t^2 - 1(i=j))$ , it suffices that  $P^*(|G_1^*| > \delta) = o_P(1)$  for any  $\delta > 0$ . But

$$\begin{split} P^*(|G_1^*| > \delta) &\leqslant \frac{1}{\delta^2 n^2} \, \mathbf{E}^* \left[ \sum_{t = \max(i,j)+1}^n \sum_{s = \max(i,j)+1}^n \mathbf{E}^*(z_t^{*(i,j)} \, z_s^{*(i,j)}) \right] \\ &= \frac{1}{\delta^2 n^2} \sum_{t = \max(i,j)+1}^n \hat{\varepsilon}_{t-i}^2 \hat{\varepsilon}_{t-j}^2 \hat{\varepsilon}_t^4 \mathbf{E}^* [(\eta_{t-i} \eta_{t-j} \eta_t^2 - 1(i=j))^2] \\ &\leqslant \frac{K}{\delta^2 n} \left( n^{-1} \sum_{t = \max(i,j)+1}^n \hat{\varepsilon}_{t-i}^2 \hat{\varepsilon}_{t-j}^2 \hat{\varepsilon}_t^4 \right), \end{split}$$

where the equality holds because  $E^*(z_t^{*(i,j)}z_s^{*(i,j)})=0$  for  $s\neq t$  by the properties of  $\{\eta_t\}$ , and the second inequality uses the fact that  $E^*|\eta_t|^4<\Delta<\infty$ . Under Assumption A strengthened by A'(vi'), we can show that  $n^{-1}\sum_{t=\max(i,j)+1}^n\hat{\varepsilon}_{t-i}^2\hat{\varepsilon}_{t-j}^2\hat{\varepsilon}_t^4=O_P(1)$ , which implies that  $P^*(|G_1^*|>\delta)=o_P(1)$ . In fact, given that  $\hat{\varepsilon}_t=\varepsilon_t-(\hat{\phi}-\phi)'Y_{t-1}$ , it follows that  $n^{-1}\sum_{t=\max(i,j)+1}^n\hat{\varepsilon}_{t-i}^2\hat{\varepsilon}_{t-j}^2\hat{\varepsilon}_t^4=n^{-1}\sum_{t=\max(i,j)+1}^n\varepsilon_{t-i}^2\varepsilon_{t-j}^2\varepsilon_t^4+o_P(1)$ . In particular, the remainder contains terms involving products of elements of  $\hat{\phi}-\phi$  (which are  $o_P(1)$ ) with terms involving averages of cross products of elements of  $Y_{t-1-j}$  and  $\varepsilon_t$ , up to the eighth order, which are  $O_P(1)$ , given  $E|\varepsilon_t|^8 \leqslant \Delta < \infty$ . The latter assumption also ensures that  $n^{-1}\sum_{t=\max(i,j)+1}^n\varepsilon_{t-i}^2\varepsilon_{t-j}^2\varepsilon_t^4=O_P(1)$ , by an application of the Markov and Cauchy–Schwartz inequalities.  $\square$ 

**Proof of Lemma A.3.** Let  $\mathscr{F}_t^* = \sigma(\eta_t, \eta_{t-1}, \dots, \eta_1)$ , and define  $W_t^* = (\hat{\varepsilon}_t^* \hat{\varepsilon}_{t-1}^*, \dots, \hat{\varepsilon}_t^* \hat{\varepsilon}_{t-m}^*)'$ . Conditional on the original sample, we have  $\mathrm{E}^*(W_t^* | \mathscr{F}_{t-1}^*) = \mathrm{E}^*(\hat{\varepsilon}_t^* | \mathscr{F}_{t-1}^*)(\hat{\varepsilon}_{t-1}^*, \dots, \hat{\varepsilon}_{t-m}^*)' = 0$  since  $\mathrm{E}^*(\hat{\varepsilon}_t^* | \mathscr{F}_{t-1}^*) = \mathrm{E}^*(\hat{\varepsilon}_t \eta_t | \mathscr{F}_{t-1}^*) = \hat{\varepsilon}_t \mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = \mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = \mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = \mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = \mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = \mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = \mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*) = 0$ , where  $\mathrm{E}^*(\eta_t | \mathscr{F}_{t-1}^*$ 

$$\Omega_{n,m}^* = diag\left(n^{-1} \sum_{t=m+1}^n \hat{\varepsilon}_t^2 \hat{\varepsilon}_{t-1}^2, \dots, n^{-1} \sum_{t=m+1}^n \hat{\varepsilon}_t^2 \hat{\varepsilon}_{t-m}^2\right).$$

Under our assumptions, we can show that  $n^{-1} \sum_{t=m+1}^{n} \hat{\varepsilon}_{t}^{2} \hat{\varepsilon}_{t-i}^{2} \xrightarrow{P} \sigma^{4} \tau_{i,i}$ , i = 1, ..., m, which implies  $\Omega_{n,m}^{*} \xrightarrow{P} \tilde{\Omega}_{m} \equiv \sigma^{4} \operatorname{diag}(\tau_{1,1}, ..., \tau_{m,m})$ . Thus, to verify the first condition of

the CLT it suffices that

$$\lambda' \left[ n^{-1} \sum_{t=m+1}^{n} W_t^* W_t^{*\prime} - \tilde{\Omega}_m \right] \lambda \equiv \lambda' V_n^* \lambda \stackrel{P^*}{\to} 0$$
, in probability.

A typical element (k, l) of the middle matrix  $V_n^*$  is given by

$$(V_n^*)_{k,l} \equiv n^{-1} \sum_{t=m+1}^n \hat{\varepsilon}_{t-k}^* \hat{\varepsilon}_{t-l}^* \hat{\varepsilon}_t^{*2} - \sigma^4 \tau_{k,l} 1 \ (k=l),$$

where by Lemma A.2 (iii), under Assumption A strengthened by A'(vi'), we have that  $(V_n^*)_{k,l} \stackrel{P^*}{\to} 0$  in probability. Lastly, condition 2 holds if for some r > 1,  $n^{-r} \sum_{t=m+1}^n E^* |\lambda' W_t^*|^{2r} = o_P(1)$ . We take r = 2. By the  $c_r$ -inequality, we have

$$n^{-r} \sum_{t=m+1}^{n} E^{*} |\lambda' W_{t}^{*}|^{2r} = n^{-r} \sum_{t=m+1}^{n} E^{*} \left| \sum_{i=1}^{m} \lambda_{i} \hat{\varepsilon}_{t}^{*} \hat{\varepsilon}_{t-i}^{*} \right|^{2r}$$

$$\leq m^{2r-1} \sum_{i=1}^{m} |\lambda_{i}|^{2r} n^{-r} \sum_{t=m+1}^{n} E^{*} |\hat{\varepsilon}_{t}^{*} \hat{\varepsilon}_{t-i}^{*}|^{2r}$$

$$\leq n^{-(r-1)} m^{2r-1} \sum_{i=1}^{m} |\lambda_{i}|^{2r} n^{-1} \sum_{t=m+1}^{n} |\hat{\varepsilon}_{t} \hat{\varepsilon}_{t-i}|^{2r}$$

$$\times E^{*} |\eta_{t}|^{2r} E^{*} |\eta_{t-i}|^{2r} = o_{P}(1),$$

given in particular that  $n^{-1} \sum_{t=m+1}^{n} |\hat{\epsilon}_t \hat{\epsilon}_{t-i}|^{2r} = O_P(1)$ .  $\square$ 

**Proof of Lemma A.4.** We can write  $y_t^* = \sum_{j=0}^{t-1} \hat{\psi}_j \hat{\varepsilon}_{t-j}^*$ , t = 1, ..., n, where  $\{\hat{\psi}_j\}$  is defined by  $\hat{\psi}_j = \sum_{i=1}^{\min(j,p)} \hat{\phi}_i \hat{\psi}_{j-1}$ , with  $\hat{\psi}_0 = 1$  and  $\hat{\psi}_j = 0$  for j < 0. It follows that  $Y_{t-1}^* = \sum_{j=1}^{t-1} \hat{b}_j \hat{\varepsilon}_{t-j}^*$ , for t = 2, ..., n, where  $\hat{b}_j = (\hat{\psi}_{j-1}, ..., \hat{\psi}_{j-p})'$ . Note that for t = 1,  $Y_{t-1}^* = Y_0^* = 0$ , given the zero initial conditions. Hence,

$$n^{-1} \sum_{t=1}^{n} Y_{t-1}^{*} Y_{t-1}^{*'} = T_{1n}^{*} + T_{2n}^{*}, \quad \text{with } T_{1n}^{*} = \sum_{j=1}^{n-1} \hat{b}_{j} \hat{b}'_{j} \left( n^{-1} \sum_{t=j+1}^{n} \hat{\varepsilon}_{t-j}^{*2} \right), \quad \text{and}$$

$$T_{2n}^{*} = \sum_{k=1}^{n-2} \sum_{j=1}^{n-k-1} (\hat{b}_{j} \hat{b}'_{j+k} + \hat{b}_{j+k} \hat{b}'_{j}) \left( n^{-1} \sum_{t=1+k}^{n-j} \hat{\varepsilon}_{t-k}^{*} \hat{\varepsilon}_{t}^{*} \right).$$

Next, we show: (a)  $T_{1n}^* \xrightarrow{P^*} A \equiv \sigma^2 \sum_{j=1}^{\infty} b_j b_j'$ , and (b)  $T_{2n}^* \xrightarrow{P^*} 0$ , in probability. To prove (a), consider for fixed  $m \in \mathbb{N}$ ,

$$T_{1n}^* = T_{1n}^{*m} + R_{1n}^{*m}, \quad \text{with } T_{1n}^{*m} = \sum_{j=1}^{m-1} \hat{b}_j \hat{b}_j' \left( n^{-1} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^{*2} \right), \quad \text{and}$$

$$R_{1n}^{*m} = \sum_{j=m}^{n-1} \hat{b}_j \hat{b}_j' \left( n^{-1} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^{*2} \right).$$

By Lemma A.2(i), for each  $j=1,\ldots,m$ , m fixed,  $n^{-1}\sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^{*2} \stackrel{P^*}{\to} \sigma^2$ , in probability; also, under Assumption A,  $\hat{\psi}_j \stackrel{P}{\to} \psi_j$ , implying  $\hat{b}_j \stackrel{P}{\to} b_j$ . Thus, by Slutsky's theorem,  $T_{1n}^{*m} \stackrel{P^*}{\to} \sum_{j=1}^{m-1} b_j b_j' \sigma^2 \equiv A_m$ , in probability. Since  $\{\psi_j\}$  is absolutely summable, it follows that  $A_m \to A$  as  $m \to \infty$ . Thus,  $T_{1n}^{*m} \stackrel{P^*}{\to} A$ , in probability. Choose  $\lambda \in \mathbb{R}^p$  arbitrarily such that  $\lambda' \lambda = 1$ . By BD's Proposition 6.3.9, it now suffices to show that, for any  $\delta > 0$ ,  $\lim_{m \to \infty} \lim\sup_{n \to \infty} P^*(|\lambda' R_{1n}^{*m} \lambda| > \delta) = 0$ , in probability, or  $\lim_{m \to \infty} \limsup\sup_{n \to \infty} E^*(|\lambda' R_{1n}^{*m} \lambda|) = 0$ , in probability, by Markov's inequality. Using the triangle inequality and the properties of  $\{\eta_t\}$ , we get

$$\begin{split} \mathbf{E}^*(|\lambda' R_{1n}^{*m} \lambda|) & \leq \sum_{j=m}^{n-1} |\lambda' \hat{b}_j \hat{b}_j' \lambda| \mathbf{E}^* \left( n^{-1} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^{*2} \right) = \sum_{j=m}^{n-1} |\lambda' \hat{b}_j \hat{b}_j' \lambda| n^{-1} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^2 \\ & \leq \left( n^{-1} \sum_{t=1}^n \hat{\varepsilon}_t^2 \right) \left( \sum_{j=m}^{n-1} |\lambda' \hat{b}_j \hat{b}_j' \lambda| \right). \end{split}$$

Given that  $\hat{\varepsilon}_t = \varepsilon_t - (\hat{\phi} - \phi)' Y_{t-1}$ , and that  $\hat{\phi} - \phi \stackrel{P}{\to} 0$ , we can show  $n^{-1} \sum_{t=1}^n \hat{\varepsilon}_t^2 = O_P(1)$ . Thus,

$$E^*(|\lambda' R_{1n}^{*m} \lambda|) \leq O_P(1) \sum_{j=m}^{n-1} |\lambda' \hat{b}_j \hat{b}_j' \lambda| \leq O_P(1) \sum_{k=1}^p \sum_{l=1}^p |\lambda_k \lambda_l| \sum_{j=m}^{\infty} |\hat{\psi}_{j-k} \hat{\psi}_{j-l}|.$$

Under our assumptions,  $\sum_{j=1}^{p} |\hat{\phi}_j - \phi_j| = o_P(1)$ , so there exists  $n_1$  such that  $\sup_{n \geq n_1} \sum_{j=1}^{\infty} |\hat{\psi}_j| < \infty$  in probability (cf. Bühlmann, 1995, Lemma 2.2.). This implies  $\sup_{n \geq n_1} \sum_{j=m}^{\infty} |\hat{\psi}_{j-k}\hat{\psi}_{j-l}| = o_P(1)$  as  $m \to \infty$ , which completes the proof that  $T_{1n}^* \stackrel{P^*}{\to} A$ , in probability. Finally, to show (b), consider first for fixed  $m \in \mathbb{N}$ ,  $T_{2n}^{*m} = \sum_{k=1}^{m-2} \sum_{j=1}^{m-k-1} (\hat{b}_j \hat{b}'_{j+k} + \hat{b}_{j+k} \hat{b}'_j)(n^{-1} \sum_{t=1+k}^{n-j} \hat{\epsilon}^*_{t-k} \hat{\epsilon}^*_{t})$ . For fixed j and k, it follows by Lemma A.2(ii) that  $n^{-1} \sum_{t=1+k}^{n-j} \hat{\epsilon}^*_{t-k} \hat{\epsilon}^*_{t} \stackrel{P^*}{\to} 0$ , in probability. Since  $\hat{b}_j \hat{b}'_{j+k} + \hat{b}_{j+k} \hat{b}'_j \stackrel{P}{\to} b_j b_{j+k} + b_{j+k} b'_j$ , we have that  $T_{2n}^{*m} \stackrel{P^*}{\to} 0$ , in probability. To complete the proof of (b) we need to show

that each of the following

$$R_{2,1n}^{*m} = \sum_{k=m-1}^{n-1} \sum_{j=1}^{n-k-1} (\hat{b}_j \hat{b}'_{j+k} + \hat{b}_{j+k} \hat{b}'_j) \left( n^{-1} \sum_{t=1+k}^{n-j} \hat{\varepsilon}_{t-k}^* \hat{\varepsilon}_t^* \right), \quad \text{and}$$

$$R_{2,2n}^{*m} = \sum_{k=1}^{m-2} \sum_{j=1}^{n-k-1} (\hat{b}_j \hat{b}'_{j+k} + \hat{b}_{j+k} \hat{b}'_j) \left( n^{-1} \sum_{j=1}^{n-j} \hat{\varepsilon}_{t-k}^* \hat{\varepsilon}_t^* \right),$$

satisfies the condition  $\lim_{m\to\infty} \limsup_{n\to\infty} P^*(|\lambda' R_{2,in}^{*m} \lambda| > \delta) = 0$  in probability, for i=1,2, where  $\lambda$  and  $\delta$  are as above. This can be verified analogously.  $\square$ 

**Proof of Lemma A.5.** As in the proof of Lemma A.4, we have  $Y_{t-1}^* = \sum_{j=1}^{t-1} \hat{b}_j \hat{\varepsilon}_{t-j}^*$ , where  $\hat{b}_j = (\hat{\psi}_{j-1}, \dots, \hat{\psi}_{j-p})'$ , with  $\hat{\psi}_0 = 1$  and  $\hat{\psi}_j = 0$  for j < 0. Noting that  $Y_0^* = 1$ ,

$$n^{-1/2} \sum_{t=1}^{n} Y_{t-1}^* \hat{\varepsilon}_t^* = n^{-1/2} \sum_{t=2}^{n} \sum_{j=1}^{t-1} \hat{b}_j \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_t^* = \sum_{j=1}^{n-1} \hat{b}_j n^{-1/2} \sum_{t=j+1}^{n} \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_t^* \equiv \chi_n^*.$$

For fixed  $m \in \mathbb{N}$ , let  $\chi_{n,m}^* \equiv \sum_{j=1}^{m-1} \hat{b}_j n^{-1/2} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^* \hat{\epsilon}_t^*$ . Next we show: (a) for m fixed,  $\chi_{n,m}^* \Rightarrow^{d_{P^*}} \mathbb{N}(0,\tilde{B}_m)$ , as  $n \to \infty$ , where  $\tilde{B}_m = \sum_{j=1}^m b_j b_j' \sigma^4 \tau_{j,j}$ ; (b)  $\tilde{B}_m \to \tilde{B}$  as  $m \to \infty$ , and (c)  $\lim_{m \to \infty} \limsup_{n \to \infty} P^*(|\chi_n^* - \chi_{n,m}^*| > \delta) = 0$  for any  $\delta > 0$ . For (a), write

$$\chi_{n,m}^* = \sum_{j=1}^{m-1} b_j n^{-1/2} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_t^* + \sum_{j=1}^{m-1} (\hat{b}_j - b_j) n^{-1/2} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_t^* \equiv Q_1^* + Q_2^*.$$

By Lemma A.3, under Assumption A strengthened by A(vi'),  $Q_1^* \Rightarrow^{d_{P^*}} N(0, \tilde{B}_{m-1})$ , in probability, where  $\tilde{B}_{m-1} = \sum_{j=1}^{m-1} b_j b_j' \sigma^4 \tau_{j,j}$ . Next, note that  $Q_2^* \stackrel{P^*}{\to} 0$  in probability, since  $\hat{b}_j - b_j \stackrel{P}{\to} 0$  and  $n^{-1/2} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_t^* = O_{P^*}(1)$  for each  $j=1,\ldots,m-1$ . The asymptotic equivalence lemma now implies (a). (b) follows by dominated convergence given the summability of  $\{\psi_j\}$  and the uniform boundedness of  $\sigma^4 \tau_{j,j}$ . To prove (c), note that it suffices to show that  $\lim_{m\to\infty} \limsup_{n\to\infty} E^*(|\chi_n^* - \chi_{n,m}^*|^2) = o_P(1)$ , by Chebyshev's inequality. Equivalently, we consider for any  $\lambda \in \mathbb{R}^P$ , such that  $\lambda' \lambda = 1$ ,

$$E^*(|\lambda'(\chi_n^* - \chi_{n,m}^*)|^2) = E^* \left( \sum_{j=m}^{n-1} \sum_{i=m}^{n-1} \lambda' \hat{b}_j \hat{b}_i' \lambda Z_{nj}^* Z_{ni}^* \right),$$

where  $Z_{nj}^* \equiv n^{-1/2} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^* \hat{\varepsilon}_t^*$ . Since  $E^*(Z_{nj}^* Z_{ni}^*) = 0$  for  $i \neq j$  and  $E^*(Z_{nj}^{*2}) = n^{-1} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^2 \hat{\varepsilon}_t^2$ , it follows that

$$\begin{split} \mathbf{E}^*(|\lambda'(\chi_n^* - \chi_{n,m}^*)|^2) &= \sum_{j=m}^{n-1} \lambda' \hat{b}_j \hat{b}_j' \lambda \left( n^{-1} \sum_{t=j+1}^n \hat{\varepsilon}_{t-j}^2 \hat{\varepsilon}_t^2 \right) \\ &\leq \left( n^{-1} \sum_{t=1}^n \hat{\varepsilon}_t^4 \right) \left( \sum_{j=m}^{n-1} \lambda' \hat{b}_j \hat{b}_j' \lambda \right), \end{split}$$

<span id="page-30-0"></span>where the last inequality holds by an application of the Cauchy–Schwartz inequality. Using the definition of  $\hat{\varepsilon}_t$ , i.e.,  $\hat{\varepsilon}_t = \varepsilon_t \eta_t - (\hat{\phi} - \phi)' Y_{t-1}$ , and the fact that  $\hat{\phi} - \phi \stackrel{P}{\rightarrow} 0$ , we can show that  $n^{-1} \sum_{t=1}^n \hat{\varepsilon}_t^t = O_P(1)$ . The proof of (c) now follows exactly the argument used in Lemma A.4 when dealing with  $R_{1n}^{*m}$ .

#### <span id="page-30-1"></span>References

Andrews, D.W.K., 1988. Laws of large numbers for dependent nonidentically distributed random variables. Econometric Theory 4, 458–467.

Bekaert, G., Hodrick, R.J., 2001. Expectations hypothesis tests. Journal of Finance 56, 1357-1394.

Bekaert, G., Hodrick, R.J., Marshall, D.A., 1997. On biases in tests of the expectations hypothesis in the term structure of interest rates. Journal of Financial Economics 44, 309–348.

Berkowitz, J., Kilian, L., 2000. Recent developments in bootstrapping time series. Econometric Reviews 19, 1-48

Berkowitz, J, Birgean, I., Kilian L., 2000. On the finite-sample accuracy of nonparametric resampling algorithms for economic time series. In: Fomby, T.B., Hill, C. (Eds.), Advances in Econometrics: Applying Kernel and Nonparametric Estimation to Economic Topics, Vol. 14. JAI Press, CT, 77–107.

Bollerslev, T., 1986. Generalized autoregressive conditional heteroskedasticity. Journal of Econometrics 37, 307–327.

Bollerslev, T., 1990. Modeling the coherence on short-run nominal exchange rates: a multivariate GARCH model. Review of Economics and Statistics 72, 498–505.

Bollerslev, T., Engle, R.F., Wooldridge, J.M., 1988. A capital-asset pricing model with time-varying covariances. Journal of Political Economy 96, 116–131.

Bose, A., 1988. Edgeworth correction by bootstrap in autoregression. Annals of Statistics 16, 1709-1722.

Brockwell, P.J., Davis, R.A., 1991. Time Series: Theory and Methods, 2nd Edition. Springer, New York.

Bühlmann, P., 1995. Moving-average representation for autoregressive approximations. Stochastic Processes and Their Applications 60, 331–342.

Chesher, A., Jewitt, I., 1987. The bias of a heteroskedasticity consistent covariance matrix estimator. Econometrica 55, 1217–1222.

Davidson, J., 1994. Stochastic Limit Theory. Oxford University Press, New York.

Davidson, R., Flachaire, E., 2001. The wild bootstrap, tamed at last. Working Paper, Darp58, STICERD, London School of Economics.

Deo, S.R., 2000. Spectral tests of the martingale hypothesis under conditional heteroskedasticity. Journal of Econometrics 99, 291–315.

Durrett, R., 1996. Probability: Theory and Examples. Duxury Press, California.

Eicker, F., 1963. Asymptotic normality and consistency of the least squares estimators for families of linear regressions. Annals of Mathematical Statistics 34, 447–456.

Engle, R.F., 1982. Autoregressive conditional heteroskedasticity with estimates of the variance of United Kingdom inflation. Econometrica 50, 987–1007.

Engle, R.F., 1990. Discussion: stock market volatility and the crash of '87. Review of Financial Studies 3, 103-106.

Engle, R.F., Ng, V.K., 1993. Measuring and testing the impact of news on volatility. Journal of Finance 48, 1749–1778.

Freedman, D.A., 1981. Bootstrapping regression models. Annals of Statistics 9, 1218-1228.

Glosten, L.R., Jaganathan, R., Runkle, D.E., 1993. On the relation between the expected value and the volatility of nominal excess returns on stocks. Journal of Finance 48, 1779–1801.

Godfrey, L.G., Orme, C.D., 2001. Significance levels of heteroskedasticity-robust tests for specification and misspecification: some results on the use of the wild bootstraps. Economics Letters, forthcoming.

Goetzmann, W.N., Jorion, P., 1993. Testing the predictive power of dividend yields. Journal of Finance 48, 663–679.

Goetzmann, W.N., Jorion, P., 1995. A longer look at dividend yields. Journal of Business 68, 483-508.

- <span id="page-31-0"></span>Gon\*calves, S., Kilian, L., 2003. Asymptotic and bootstrap inference for AR(∞) processes with conditional heteroskedasticity. CIRANO Working Paper 2003-s28.
- Hansen, B.E., 1999. The grid bootstrapand the autoregressive model. Review of Economics and Statistics 81, 594–607.
- Hansen, B.E., 2000. Testing for structural change in conditional models. Journal of Econometrics 97, 93–115.
- HPardle, W., Horowitz, J., Kreiss, J.-P., 2001. Bootstrapmethods for time series. Manuscript, Institute for Statistics and Econometrics, Humboldt-UniversitPat zu Berlin.
- He, C., TerPasvirta, T., 1999. Properties of moments of a family of GARCH processes. Journal of Econometrics 92, 173–192.
- Hodrick, R.J., 1992. Dividend yields and expected stock returns: alternative procedures for inference and measurement. Review of Financial Studies 5, 357–386.
- Inoue, A., Kilian, L., 2002. Bootstrapping autoregressions with possible unit roots. Econometrica 70, 377–391.
- Kreiss, J.P., 1997. Asymptotic properties of residual bootstrap for autoregressions. Manuscript, Institute for Mathematical Stochastics, Technical University of Braunschweig, Germany.
- Kuersteiner, G.M., 2001. Optimal instrumental variables estimation for ARMA models. Journal of Econometrics 104, 359–405.
- Ledoit, O., Santa-Clara, P., Wolf, M., 2001. Multivariate GARCH modeling with an application to international stock markets. Working Paper No. 578, Department of Economics, Universitat Pompeu Fabra.
- Liu, R.Y., 1988. Bootstrapprocedure under some non-i.i.d. models. Annals of Statistics 16, 1696–1708.
- Lutkepohl, H., 1990. Asymptotic distributions of impulse response functions and forecast error variance P decompositions of vector autoregressive models. Review of Economics and Statistics 72, 116–125.
- MacKinnon, J.G., White, H., 1985. Some heteroskedasticity consistent covariance matrix estimators with improved 1nite-sample properties. Journal of Econometrics 29, 305–325.
- Mammen, E., 1993. Bootstrapand wild bootstrapfor high dimensional linear models. Annals of Statistics 21, 255–285.
- MilhHj, A., 1985. The moment structure of ARCH processes. Scandinavian Journal of Statistics 12, 281–292.
- Nicholls, D.F., Pagan, A.R., 1983. Heteroskedasticity in models with lagged dependent variables. Econometrica 51, 1233–1242.
- Shephard, N., 1996. Statistical aspects of ARCH and stochastic volatility. In: Cox, D.R., et al. (Ed.), Time Series Models in Econometrics, Finance and Other Fields. Chapman & Hall, London.
- Weiss, A.A., 1988. ARMA models with ARCH errors. Journal of Time Series Analysis 5, 129–143.
- White, H., 1980. A heteroskedasticity-consistent covariance matrix estimator and a direct test for heteroskedasticity. Econometrica 48, 817–838.
- White, H., 1999. Asymptotic Theory for Econometricians, 2nd Edition. Academic Press, London.
- Wu, C.F.J., 1986. Jackknife, bootstrapand other resampling methods in regression analysis. Annals of Statistics 14, 1261–1295.
- Wolf, M., 2000. Stock returns and dividend yields revisited: a new way to look at an old problem. Journal of Business and Economic Statistics 18, 18–30.