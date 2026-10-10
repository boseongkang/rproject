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
