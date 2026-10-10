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

## Template

## DATE: what I changed (which file)

* Changed:
* Observed:
* Decision:
