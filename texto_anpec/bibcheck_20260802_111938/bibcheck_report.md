# bibcheck — `texto_anpec/references.bib`

Run 2026-08-02 · mode: per-citation · 46 entries · one agent per entry.

| | |
|---|---|
| Entries audited | 46 |
| Cited in `paper_anpec.tex` | 25 |
| Uncited (dead weight) | 21 |
| Clean | 6 |
| Corrected | 40 |
| Unverifiable | 0 |

No entry was unverifiable: every one of the 46 was matched to a real paper with a DOI or an authoritative landing page. **No field-mixing was found in any cited entry** — no case of one paper's title carried on another's authors or year.

## What actually matters

### 1. `alessi2016response` — every coordinate wrong, and it duplicates `alessi`

Claimed *Journal of Applied Econometrics* **31(6), 930–950, 2016**. The real article is **34(5), 661–672, 2019** (DOI 10.1002/jae.2706). JAE 31(6) runs pp. 929–1196 and contains no Alessi–Kerssenfischer paper at all; 929–960 is Bailey/Kapetanios/Pesaran on cross-sectional dependence. The 2016 came from the ECB Working Paper 1967 precursor. Two agents reached this independently. The entry is **not cited**, and `alessi` already carries the right coordinates.

**Removed from `corrected.bib`.** Had it ever been cited, the paper would have printed a citation to an article that does not exist.

### 2. `barigozzi2016non` — real category error, and a swap I did *not* make

Cited three times (`paper_anpec.tex:220, 224, 505`) for the BLL standardization. It was typed `@article` with `journal = {Finance and Economics Discussion Series}` — FEDS is the Federal Reserve Board's **working-paper series**, not a journal, so the bibliography printed a Fed working paper as a journal article with volume 2016, issue 024. Fixed to `@techreport` with institution, series number 2016-024r1 and DOI 10.17016/FEDS.2016.024r1.

The auditing agent went further and rewrote the entry to point at *Large-dimensional Dynamic Factor Models: Estimation of Impulse–Response Functions with I(1) cointegrated factors*, **JoE 221(2), 455–482, 2021**, claiming it is the same work retitled and that RePEc says so. **I checked and it does not.** The JoE article is real with exactly those coordinates, but neither the Federal Reserve's own landing page for 2016-024 nor RePEc/EconPapers annotates it as published. So the identity is unconfirmed, and I reverted the swap — `barigozzi2016non` still cites the FEDS paper, only correctly typed. The JoE article sits in `corrected.bib` as `barigozzi2021large` with that caveat attached, for you to decide.

### 3. `svensson1994estimating` — NBER printed as a journal

`@article` with `journal = {National Bureau of Economic Research}` and `number = {w4871}`. The bibliography printed *“Estimating and interpreting forward interest rates: Sweden 1992-1994. National Bureau of Economic Research.”* with no volume, no pages and no indication it is a working paper. Fixed to `@techreport` (NBER Working Paper 4871, Sept. 1994, DOI 10.3386/w4871). Also issued as IMF WP 94/114.

### 4. `bai2002determining` — exact duplicate of the cited `bai-ng`

Same title, authors, *Econometrica* 70(1), 191–221, 2002. Only `bai-ng` is cited (`paper_anpec.tex:224`). Its `publisher = {Wiley Online Library}` is a Google-Scholar artifact — a hosting platform, not a publisher. **Removed from `corrected.bib`.**

### 5. `BERNANKE19991341` — wrong Handbook volume, missing editors

Handbook of Macroeconomics vol. 1 was published in parts; the financial-accelerator chapter is in **1C** (ISBN 9780444501585), not “1”. The `@incollection` had neither `booktitle` nor `editor`, so the printed entry named no editors — added Taylor & Woodford. “Chapter 21” was embedded in the title field and has been stripped.

### 6. Smaller factual fixes in cited entries

| Key | Was | Is |
|---|---|---|
| `castelnuovo` | issue `9, SI`; author `Nistico` | issue `9`; `Nisticò` |
| `miranda` | `Rey, Helene`; `US Monetary Policy` | `Rey, Hélène`; `U.S. Monetary Policy` |
| `Cooley` | `Cooley, T and Quadrini, V` | `Cooley, Thomas F. and Quadrini, Vincenzo` |
| `STOCK2016415` | `J.H. Stock and M.W. Watson` | `Stock, James H. and Watson, Mark W.` |
| `bagliano1998` | no issue number | issue `6` |
| `sax2018seasonal` | no issue; title lowercased | issue `11`; `{X-13ARIMA-SEATS}`, `{R}` |
| `kilian1998small` | `Review of economics and statistics` | `The Review of Economics and Statistics` |
| `bernanke` | title ends in `*` (OUP footnote marker) | asterisk removed |
| `jarocinski2020` | raw UTF-8 `ń` | `Jaroci{\'n}ski` |

### 7. Cosmetic, applied across the file

DOI coverage went from **10 entries to 44** of 45. Web-of-Science export cruft dropped (`Unique-ID`, `ResearcherID-Numbers`, `ORCID-Numbers`, `EISSN`) — no `.bst` reads these. ALL-CAPS journal names from WoS restored to title case in 8 entries (`REVIEW OF ECONOMIC STUDIES`, `ECONOMIC THEORY`, `APPLIED ECONOMICS`, …). Duplicated `year` fields removed from `maddala_wu_1999`, `choi_2001`, `levin_lin_chu_2002` and duplicated `Year`/`Month` from `kilian`. Page ranges normalised to `--`. JSTOR import clutter (`urldate` with no `url`, stray `abstract`, combined `ISSN`) dropped.

One publisher anachronism: `clarida` carried `Oxford University Press`, but the *QJE* in 2000 was published by **MIT Press** — OUP took it over in 2007. JSTOR shows the current publisher, which is what got imported. (Entry is uncited.)

## Where I overrode an agent

- **`barigozzi2016non`** — reverted the swap to the JoE 2021 article, as above.
- **`rigobon2003`** — an agent recapitalised the title to *Identification **Through** Heteroskedasticity*. MIT Press blocks automated fetches so I could not confirm it, and the universally used form is lowercase `through`, which is what the entry already had. Reverted.

## Verification

`corrected.bib` was compiled against `paper_anpec.tex` in a scratch copy: **25 entries used, 0 BibTeX warnings, 0 errors, 0 undefined citations, 25 `\bibitem`s** — same count as the current file. Nothing in `texto_anpec/` was modified.

**The `.bbl` is the working file of record**, so `corrected.bbl` in this directory is the deliverable, not `corrected.bib`. Do **not** run `bibtex` on this project: it regenerates the `.bbl` from scratch and would discard any hand edits. `corrected.bib` is kept as the archival source, for whenever the `.bbl` is next rebuilt from it.

`corrected.bbl` was generated from `corrected.bib` and then compiled: 25 `\bibitem`s, matching the 25 `\cite` keys in the `.tex`, 0 undefined citations. Against the current `paper_anpec.bbl`, **17 of the 25 entries change and 8 are untouched**. The current `.bbl` is byte-identical to what BibTeX produces from `references.bib`, i.e. it carries no hand edits yet.

Three cosmetic calls are left open in `corrected.bbl`, all in cited entries:

- `STOCK2016415` keeps `Chapter 8 - ` in its title while `BERNANKE19991341` had `Chapter 21` stripped, and only the latter gained `booktitle`/`editor`. The two Handbook chapters are now formatted inconsistently.
- `castelnuovo` loses its trailing conference note (*14th International Conference on Computing in Economics and Finance, CEF 2008…*). Defensible as WoS cruft, but it is information removed from the printed entry.
- `lutz` renders as `61(Dec.)` because the `.bst` drops `month` into the empty issue slot. Deleting `month` would give a clean `61`.

## The 21 uncited entries

BibTeX only emits cited entries, so these never reach the printed bibliography. They were audited anyway (a `corrected.bib` should be a true drop-in), and all were verified real. Two were removed as duplicates; the other 19 are simply dead weight you may want to prune:

`BOIVIN2006169`, `CHATZIANTONIOU2013754`, `Thorbecke`, `UHLIG2005381`, `amengual2007consistent`, `brunnermeier2021`, `choi_2001`, `clarida`, `ehrmann`, `forni2005generalized`, `hanisch`, `kilian`, `levin_lin_chu_2002`, `li`, `maddala_wu_1999`, `meinusch`, `miranda-transmi`, `pascal`, `stock2002macroeconomic`

## Per-entry ledger

| Key | Cited | Status | Issues | Paper |
|---|---|---|---|---|
| `BOIVIN2006169` | — | corrected | 4 | Boivin and Ng (2006, Journal of Econometrics) show that adding more series to a factor model… |
| `kilian` | — | corrected | 4 | Kilian (2009, American Economic Review) develops a structural VAR to disentangle oil supply … |
| `STOCK2016415` | yes | corrected | 3 | A survey/user's-guide chapter by James H. Stock and Mark W. Watson on dynamic factor models,… |
| `alessi` | yes | corrected | 7 | This entry correctly identifies Alessi & Kerssenfischer, 'The response of asset prices to mo… |
| `villaverde` | yes | corrected | 3 | All substantive fields (authors, title, journal, volume, number, year, month, pages) correct… |
| `bernanke` | yes | corrected | 5 | Correctly identifies Bernanke, Boivin & Eliasz (2005) FAVAR paper in QJE 120(1):387-422 with… |
| `clarida` | — | corrected | 5 | Title/authors/year/journal/volume/issue/pages all correctly identify Clarida-Galí-Gertler (2… |
| `UHLIG2005381` | — | corrected | 3 | All content fields (title, author, journal, volume, issue, pages, year, ISSN) correctly iden… |
| `ehrmann` | — | corrected | 5 | Ehrmann and Fratzscher (2004, Journal of Money, Credit and Banking 36(4), pp. 719-737) show … |
| `CHATZIANTONIOU2013754` | — | corrected | 4 | All substantive fields (title, authors, year, journal, volume, pages, ISSN, abstract) match … |
| `BEKAERT2013771` | yes | corrected | 6 | Correctly identifies Bekaert, Hoerova & Lo Duca (2013), "Risk, uncertainty and monetary poli… |
| `Thorbecke` | — | corrected | 6 | Correctly cites Thorbecke (1997), 'On Stock Market Returns and Monetary Policy,' Journal of … |
| `miranda` | yes | corrected | 8 | Miranda-Agrippino and Rey (Review of Economic Studies, 2020) show that a single 'Global Fina… |
| `miranda-transmi` | — | corrected | 7 | Miranda-Agrippino and Ricco (2021, American Economic Journal: Macroeconomics 13(3):74-107) d… |
| `pascal` | — | corrected | 7 | All substantive fields (author, title, year, volume, number, pages, ISSN) correctly match Pa… |
| `castelnuovo` | yes | corrected | 11 | Correctly identifies Castelnuovo & Nisticò (2010), JEDC 34(9):1700-1731 with no field mixing… |
| `bai-ng` | yes | corrected | 6 | Bai and Ng (2002, Econometrica 70(1), pp. 191-221) develop panel information criteria to con… |
| `lutz` | yes | corrected | 7 | All substantive fields (author, title, year, volume, pages, ISSN) check out against CrossRef… |
| `meinusch` | — | corrected | 7 | Meinusch & Tillmann (2016), 'The macroeconomic impact of unconventional monetary policy shoc… |
| `li` | — | corrected | 6 | Verified: Jinfang Li, 'The asymmetric effects of investor sentiment and monetary policy on s… |
| `Cooley` | yes | corrected | 8 | Cooley & Quadrini (2006), 'Monetary policy and the financial decisions of firms', Economic T… |
| `hanisch` | — | corrected | 10 | Hanisch (2017), 'The effectiveness of conventional and unconventional monetary policy: Evide… |
| `maddala_wu_1999` | — | corrected | 5 | All content fields (title, authors, year, journal, volume, issue S1, pages) are verified cor… |
| `choi_2001` | — | corrected | 5 | Choi, In (2001), "Unit root tests for panel data", Journal of International Money and Financ… |
| `levin_lin_chu_2002` | — | corrected | 5 | Levin, Lin & Chu (2002), 'Unit root tests in panel data: asymptotic and finite-sample proper… |
| `stock2002macroeconomic` | — | corrected | 6 | All bibliographic fields (title, authors, journal, volume 20, issue 2, pages 147-162, year 2… |
| `forni2005generalized` | — | corrected | 6 | All substantive fields (title, four authors in order, journal, volume 100/issue 471/pages 83… |
| `alessi2016response` | — | **removed** | 7 | The cited paper is Alessi & Kerssenfischer, 'The response of asset prices to monetary policy… |
| `bai2002determining` | — | **removed** | 6 | Bai & Ng (2002), 'Determining the Number of Factors in Approximate Factor Models,' Econometr… |
| `barigozzi2016non` | yes | corrected | 10 | The entry cites Barigozzi, Lippi & Luciani's FEDS Working Paper 2016-024 ("Non-Stationary Dy… |
| `amengual2007consistent` | — | corrected | 3 | All bibliographic facts (title, authors, journal, volume/issue, pages, year, publisher) chec… |
| `kilian1998small` | yes | corrected | 2 | Kilian (1998), 'Small-Sample Confidence Intervals for Impulse Response Functions', The Revie… |
| `svensson1994estimating` | yes | corrected | 9 | Svensson (1994), NBER Working Paper No. 4871 (also issued as IMF Working Paper 94/114), fits… |
| `sax2018seasonal` | yes | corrected | 3 | Sax & Eddelbuettel (2018), 'Seasonal Adjustment by X-13ARIMA-SEATS in R', JSS 87(11):1-17, d… |
| `gertler2015` | yes | clean | 0 | Gertler & Karadi (2015), 'Monetary Policy Surprises, Credit Costs, and Economic Activity', A… |
| `jarocinski2020` | yes | corrected | 3 | DOI 10.1257/mac.20180090 correctly resolves to Jarociński & Karadi (2020), "Deconstructing M… |
| `bauer2023` | yes | clean | 0 | All fields (title, authors, journal, volume 113, issue 3, pages 664-700, year 2023, DOI 10.1… |
| `stockwatson2018` | yes | clean | 1 | DOI 10.1111/ecoj.12593 resolves to Stock & Watson (2018), 'Identification and Estimation of … |
| `mertensravn2013` | yes | corrected | 1 | Mertens & Ravn (2013), 'The Dynamic Effects of Personal and Corporate Income Tax Changes in … |
| `montielolea` | yes | clean | 1 | All fields (authors, title, journal, volume 225(1), pages 74-87, year 2021) match the publis… |
| `bagliano1998` | yes | corrected | 4 | Title, authors, volume, and pages 1069-1112 are all correct for this exact article, but the … |
| `goncalves2025` | yes | corrected | 3 | IMF Working Paper WP/25/48 (Feb 2025), "Monetary Policy and Inflation Expectations: High-Fre… |
| `goncalveskilian2004` | yes | clean | 3 | All substantive fields (authors incl. the accented 'Sílvia', title, journal, volume 123, iss… |
| `rigobon2003` | yes | corrected | 2 | Verified: Rigobon's single-authored 'Identification Through Heteroskedasticity', Review of E… |
| `brunnermeier2021` | — | clean | 4 | All fields (title, four authors, year, journal, volume 111, issue 6, pages 1845-1879, DOI 10… |
| `BERNANKE19991341` | yes | corrected | 7 | Bernanke, Gertler and Gilchrist (1999), Chapter 21 of the Handbook of Macroeconomics, Volume… |

Full per-entry JSON, including the canonical URL each agent anchored on, is in `reports/`.
