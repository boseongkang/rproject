# Experiment Log

Each entry records one change I made, what I saw after rendering, and what I decided.
Seed: 1159 unless noted.

## 2026-10-09: num = 1,000 instead of 10,000 (01normal)

* Changed: functions.R, num <- 1000
* Observed:
  * Section 2 noise ratio dropped from 8 and 6 to 3 and 2.
  * Largest |skewness| was 0.176, close to my 0.2 cutoff.
  * SE check failed at n = 3 (SE ratio 0.937), 8 of 9 passed.
  * Cutoff margins became 1, 1.5 and 0.5 times the smallest passing values, so my cutoffs were no longer justified.
  * The overall mean at n = 30 was exactly the same as at n = 3 with num = 10,000 (both use the same 30,000 random numbers because I reset the seed for each n).
* Decision: went back to num = 10,000.

## 2026-10-09: qqCor = 0.999 instead of 0.998 (01normal)

* Changed: functions.R, qqCor = 0.999
* Observed:
  * Nothing in the decision changed. All 9 sample sizes still passed and the answer stayed n = 1.
  * The lowest QQ correlation was 0.9999, above both 0.998 and 0.999.
  * The QQ panel of the convergence plot zoomed in to 0.999 to 1.000 because the axis includes the cutoff line.
* Decision: went back to 0.998. A normal population cannot tell me which QQ cutoff is right, because it passes any cutoff up to 0.9995. I will test the QQ cutoff on the exponential population.

## 2026-10-10: qqCor = 0.999 instead of 0.998 (03exponential)

* Changed: functions.R, qqCor = 0.999
* Observed:
  * The answer moved from n = 100 to n = 132. The finer grid now searched 105 to 145 instead of 77 to 98.
  * The last failure was n = 127, and it failed on the QQ check only (skewness 0.181 was already below 0.2).
  * The skewness cutoff comparison changed to 400 / 150 / 150 / 150: with 0.999 the QQ check decides for every
    skewness cutoff of 0.2 or looser.
  * Several of my written sentences became false (for example "skewness was the check that decided the answer").
* Decision: went back to 0.998. With 0.999 the QQ check overrules skewness, and the answer no longer matches the
  2 / sqrt(n) prediction. In 01normal this change did nothing; here it changed the answer.

## 2026-10-10: Checking the Weldon dice numbers myself (02die)

* Changed: nothing in the project files. In the Console I installed the R package vcd and loaded its WeldonDice data.
* Observed:
  * The data has 26,306 throws, the same number as in Labby (2009).
  * The share of fives and sixes among the 12 × 26,306 dice was 0.337686, about 33.77 percent, as in the paper.
    The last category is "10 or more", which I counted as 10, so the true share can be very slightly higher.
* Decision: kept the Weldon sentence in 02die.qmd and added the source and my own check next to it.

## 2026-10-10: Comparing the die population across seeds (02die)

* Changed: I planned to check the share of each face with four other seeds besides 1159.
* Reason for dropping it: the project instructions say to use the last four digits of my student ID and not to
  change the seed because of the results. A comparison across seeds belongs in the reproducibility file.
* Decision: removed it. Instead I checked the population with seed 1159 only: the shares against 1/6 in standard
  errors, a chi square test, and how the shares approach 1/6 as the number of rolls grows (N = 10 to 100,000).

## 2026-10-10: qqCor = 0.995, full search (02die)

* Changed: in the Console, criteria$qqCor <- 0.995, then reran analyzePopulation(populations$die)
* Observed:
  * The answer was n = 5, the same as the qqCompare table in 02die.qmd.
  * The finer grid added nothing: the last failure was n = 4 and the first pass n = 5, with no whole number between
    them. My die grid already has every n from 1 to 6, so unlike 03exponential and 04binomial the table value was
    not limited by the grid.
  * n = 4 failed on kurtosis only (excess kurtosis -0.319, cutoff 0.3); its QQ correlation 0.9956 already passed
    0.995. So with 0.995 the kurtosis decides, exactly at the formula prediction of n = 5.
* Decision: kept 0.998. No change to 02die.qmd; this confirms its sentence that with 0.995 the gaps do not change
  the answer.

## 2026-10-10: qqCor = 0.995, full search (04binomial)

* Changed: in the Console, criteria$qqCor <- 0.995, then reran analyzePopulation(populations$binomial)
* Observed:
  * The answer was n = 35, not 40. The finer grid searched 31 to 39.
  * The qqCompare table in 04binomial.qmd shows 40 only because it reuses the grid I already ran, which has no n
    between 30 and 40. This is the same thing I saw in 03exponential with qqCor = 0.999 (150 on the grid, 132 after
    a full search).
  * 35 is close to the skewness prediction of 36, so with 0.995 the gaps hardly matter.
* Decision: kept 0.998. Added a note to 04binomial.qmd that the 0.995 value in qqCompare is grid limited.

## 2026-10-10: Binomial(5, 0.5) instead of Binomial(5, 0.1) (04binomial)

* Changed: in the Console, a population with prob = 0.5 (mu = 2.5, sigma = sqrt(1.25), gamma1 = 0, gamma2 = -0.4);
  functions.R and 04binomial.qmd were not changed.
* Prediction before running: no skewness, so only the gaps matter. The step is 0.894 / sqrt(n) SE; for it to reach
  the 0.207 SE where the die passed, n is about 19.
* Observed:
  * The answer was n = 19, exactly the prediction.
  * Skewness stayed near 0 at every n (largest 0.026) and kurtosis was small; the last failure (n = 18) failed
    only on the QQ check.
* Decision: no change to the population. This supports my explanation in 04binomial: without skewness, the step
  size rule predicts the answer, so the extra n for p = 0.1 (70 instead of 52) comes from the skewness.
  Added a short paragraph about this to section 7 of 04binomial.qmd.

## 2026-10-10: Checking Binomial(5, 0.1) by hand (04binomial)

* Changed: nothing in the project files; all checks in the Console.
* Observed:
  * 0.9^5 = 0.59049 and 5 × 0.1 × 0.9^4 = 0.32805 match dbinom(0:5, 5, 0.1), and the six probabilities sum to 1.
  * Mean, SD, skewness and excess kurtosis computed directly from the probability table were 0.5, 0.6708, 1.1926
    and 1.0222, the same as the formulas I use.
  * Building the draws from the definition (5 trials with runif() < 0.1, then rowSums) gave shares within about
    0.001 of dbinom for every value.
  * The share of zeros in one sequence of draws was 0.70, 0.51, 0.566, 0.5919 and 0.5929 after 10, 100, 1,000,
    10,000 and 100,000 draws. The gap did not shrink at every step (0.0014 at 10,000 but 0.0024 at 100,000), but it
    was within 2 standard errors at every N. 59,289 zeros out of 100,000 is the same count as in the chi square
    table of 04binomial.qmd, because both use seed 1159.
  * Without combining 3, 4 and 5, chisq.test gave the warning "Chi-squared approximation may be incorrect"
    (p = 0.466).
  * The sum of 30 draws matched dbinom(5:25, 150, 0.1) closely; at n = 30 the side above the mean was still
    heavier (sum 25: 0.0037 against sum 5: 0.0014).
  * A gamma distribution with shape (2 / 1.193)² had a simulated skewness of 1.1916 against the target 1.1926.
  * P(mean of 30 draws > 0.6): exact 0.1692, plain normal approximation 0.2071, with continuity correction 0.1704.
* Decision: kept the combined chi square group. Added the n = 30 probability example to section 6 of
  04binomial.qmd as a concrete case of "n = 30 is not enough".

## 2026-10-11: Lighthouse check (05cauchy)

* Changed: nothing in the project files. In the Console I generated values as tan(angle) with the angle
  uniform on (−π/2, π/2).
* Prediction: the quantiles should match qcauchy.
* Observed: the 10, 25, 50, 75 and 90 percent quantiles were −3.088, −1.002, −0.004, 0.99 and 3.027, against
  −3.078, −1, 0, 1 and 3.078 for Cauchy(0, 1).
* Decision: the Cauchy also comes from a physical setup (a light beam at a random angle). Not added to the qmd.

## 2026-10-11: Largest value divided by n (05cauchy)

* Changed: nothing in the project files. In the Console I computed max|X| / n for n = 10 to 1,000,000 for the
  Cauchy and the exponential.
* Prediction: for the exponential, the maximum grows like log(n), so max / n should go to 0 quickly. For the Cauchy,
  the maximum grows in proportion to n, so I expected max / n not to shrink but to stay around a constant with
  occasional spikes. That would mean one extreme value can move the mean by a large amount at every n.
* Observed:
  * Exponential: fell from 0.18 to 1.2e−5, close to log(n) / n (1.4e−5 at n = 1,000,000).
  * Cauchy: 0.90, 0.54, 1.23, 1.28 and 0.91, then 31 at n = 1,000,000. The typical value in theory is
    2 / (π log 2) = 0.92 at every n, and a value above 31 has a chance of about 2 percent.
* Decision: this explains section 6 of 05cauchy.qmd: one draw can move the Cauchy mean by about max / n, and that
  does not shrink as n grows. Not added to the qmd.

## 2026-10-11: t distribution with 3 df (05cauchy)

* Changed: nothing in the project files. In the Console I ran analyzePopulation on rt(n, df = 3), which has a finite
  variance (3) but an infinite fourth moment, then ran runGrid at n = 682, 1,000, 1,500, 2,000, 3,000 and 5,000.
* Prediction: the t distribution with 3 df has a finite variance, so the CLT says the sample mean must eventually
  become normal. Because of its heavy tails I expected this to need a very large n, assuming my checks would
  stabilize once they passed.
* Observed:
  * The search gave n = 682 (n = 618 failed on kurtosis, 0.424; n = 682 had 0.293).
  * At larger n it failed again: excess kurtosis 0.342, 2.024, 1.156 and 0.349 at n = 1,500, 2,000, 3,000 and
    5,000; QQ correlation 0.9964 at n = 2,000.
  * The SE ratio was between 0.983 and 1.015 at every n, so sigma / sqrt(n) was right.
* Decision: 682 was an artifact of where my grid stopped, and my assumption that the checks would stabilize was
  wrong. Because the fourth moment is infinite, the kurtosis of the means is infinite at every n and its estimate
  from 10,000 means jumps whenever one extreme mean appears. The CLT holds (finite variance), but my standard
  cannot confirm it reliably. I report "no stable n up to 5,000".

## 2026-10-11: 25 percent trimmed mean (05cauchy)

* Changed: nothing in the project files. In the Console I ran the same search as the median in 05cauchy.qmd, with
  mean(x, trim = 0.25) instead of median(x).
* Prediction: trimming 25 percent from each side removes the extreme values, so the trimmed mean should have a
  finite variance even though the Cauchy does not. Since the median is the limit of trimming 50 percent, I expected
  the trimmed mean to behave like the median and pass at an n close to the median's (50).
* Observed:
  * n = 59 (n = 55 failed on kurtosis, 0.314).
  * At n = 50 the SD was 0.2385 against 0.2273 for the median, and the excess kurtosis 0.332 against 0.154. Both use
    the same draws, because the seed is reset for each n.
  * For n = 1 and 3 nothing is trimmed (floor(0.25 n) = 0), so the trimmed mean is the plain mean there (SD 131
    and 313).
* Decision: theory agrees that the median is slightly better here: the large n variance of the 25 percent trimmed
  mean is 2.546 / n against π² / 4 / n = 2.467 / n for the median. Both pass at about n = 50 to 60 under my standard.

## 2026-10-11: Checking the numbers for my predictions (06dependent, 07basketball, 08lifedeath)

* Changed: nothing in the project files. Before writing section 2 of these files, I computed the key numbers myself
  in the Console.
* Observed:
  * 06: one million simulated X_2 values had mean 1.5537, against e^1.25 / 2.25 = 1.5513 from the formula. The
    difference is about one standard error (0.0021). (2.888 / 0.2)² = 208.5, so 209 for independent values.
  * 07: exact SE / naive SE = 0.9674 at n = 200, the die step 0.2070 SE, and the step of one 20 shot game 0.5060 SE.
  * 08: mean 49.98, SD 27.63, skewness −0.862, excess kurtosis −0.790, so n = 19 from the skewness; the step at
    n = 1 is 0.036 SE; mean ± 1.96 SD is −4.2 to 104.1.
* Decision: used these numbers as the basis of my predictions in section 2. The 06 check is also a code chunk in
  section 2 of 06dependent.qmd.
