# How Fast Does Normal Happen?

Stress testing the Central Limit Theorem with Monte Carlo simulation in R

An R and Quarto project for Math 167R (CLT Project 1). For eight populations and processes I simulated
10,000 sample means for many sample sizes n, decided when the sampling distribution of the mean is "approximately
normal" under one fixed standard, and compared the results with theory.

Short answer: no, n = 30 is not a universal rule. Under my standard the answer ranged from n = 1 (normal
population) to n = 364 (dependent machine failures), and for the Cauchy distribution no n works at all. What decides
the answer is the skewness of the population, the gaps of a discrete population, and whether the CLT assumptions hold,
not a single number.

## Files

| File | Population or experiment | CLT assumption tested |
|:--|:--|:--|
| `functions.R` | Settings (seed, number of repetitions, cutoffs), diagnostics, search, plots, populations | |
| `01normal.qmd` | Standard normal (control) | none broken |
| `02die.qmd` | Six sided die | none broken (discrete) |
| `03exponential.qmd` | Exponential(1) | none broken (skewed) |
| `04binomial.qmd` | Binomial(5, 0.1) | none broken (skewed and discrete) |
| `05cauchy.qmd` | Cauchy(0, 1) | finite variance |
| `06dependent.qmd` | Dependent machine failures (extra credit) | independence |
| `07basketball.qmd` | Basketball shots with fatigue (extra credit) | identical distribution |
| `08lifedeath.qmd` | Age at death mixture (extra credit) | none broken (two peaks) |
| `09reproducibility.qmd` | Rerun of four analyses with other seeds | |
| `experimentLog.md` | Every setting I changed, what I saw, and what I decided | |
| `aiLog.md` | My AI prompts, follow ups, and how I checked the results | |

To reproduce: open the folder in RStudio and render each `.qmd` file (Render button, or `quarto render` in the
Terminal). Only base R and knitr are used. The seed is the last four digits of my student ID (1159), set in
`functions.R` and reset before every experiment.

## Method

* For a population and a sample size n, I drew n values, took their mean, and repeated this 10,000 times. n is the
  size of one sample; 10,000 is the number of repetitions.
* My standard for "normal enough" (all three must hold): |skewness| ≤ 0.2, |excess kurtosis| ≤ 0.3, and QQ correlation
  ≥ 0.998 (the correlation between the sorted sample means and the normal quantiles, a one number summary of how
  straight the QQ plot is). I chose and tested these cutoffs in 01normal.qmd and 03exponential.qmd.
* The chosen n is the smallest tested n such that it and every larger tested n pass, so a single lucky row cannot
  decide the answer.
* I searched a coarse grid first, then added values between the last failing and the first passing n.
* Separately, I checked whether the simulated SD of the means is within 5 percent of the theoretical SE sigma / sqrt(n),
  and I reported Shapiro Wilk p values without using them to decide.
* For each population I wrote a prediction from formulas and compared it with the result. For 06 to 09 I wrote
  the prediction after I had seen the results of a first version (see aiLog.md).

## Final table

|Population              |Smallest n judged normal |Decided by             |Skewness at n |Excess kurtosis at n | QQ correlation at n|Normal enough at n = 30 |Key observation                                                                                        |
|:-----------------------|:------------------------|:----------------------|:-------------|:--------------------|-------------------:|:-----------------------|:------------------------------------------------------------------------------------------------------|
|Standard normal         |1                        |passes at every n      |0.007         |-0.035               |              0.9999|yes                     |Normal at every n: the control for the noise level of my checks                                        |
|Six sided die           |8                        |QQ (gaps)              |-0.022        |-0.112               |              0.9981|yes                     |Symmetric, so the skewness is 0; the gaps of 1 / n between possible means decide                       |
|Exponential(1)          |100                      |skewness               |0.191         |-0.044               |              0.9988|no                      |Skewness 2 / sqrt(n) predicted the answer; n = 30 still clearly right skewed                           |
|Binomial(5, 0.1)        |70                       |QQ (gaps and skewness) |0.119         |-0.027               |              0.9982|no                      |Skewed and discrete; the gaps push the answer from 36 (skewness) to 70                                 |
|Cauchy(0, 1)            |none                     |never passes           |undefined     |undefined            |              0.1070|no                      |The mean of n Cauchy values is Cauchy again; the IQR stays 2 at every n. The median works from n = 50  |
|Dependent failures      |364                      |skewness               |0.189         |0.028                |              0.9989|no                      |Shape becomes normal, but centered near 1.68 instead of 1 with an SE 2.2 times the naive one           |
|Basketball with fatigue |118                      |QQ (gaps)              |-0.058        |0.003                |              0.9981|no                      |Not identically distributed, but behaves like constant p = 0.7; exact SE 3 percent below the naive SE  |
|Age at death            |45                       |skewness               |-0.174        |0.062                |              0.9991|no                      |Two peaks, but mild skewness; the answer is very sensitive to the seed (15 to 45 in 09reproducibility) |

For the Cauchy, the skewness and kurtosis are undefined and the QQ correlation shown is the one at the largest tested
n (3,000). For the dependent process, "normal" refers to the shape only; the naive mean and SE are wrong at every n.
For the basketball model n is the number of shots in a game.

## Is the number 30?

No. Under my standard n = 30 was enough for 2 of the 8 populations: Standard normal and Six sided die. For the
exponential, the binomial, the dependent process and the basketball model it was clearly not enough, for the age at
death mixture it failed by less than the noise with my seed (and passed with all four other seeds in
09reproducibility.qmd), and for the Cauchy no n is enough. The rule of thumb is too generous for skewed or discrete
populations and more than needed for symmetric ones like the die.

The reproducibility experiment also showed that the exact chosen n is uncertain: with five seeds the exponential
ranged from 73 to 132 and the binomial from 68 to 77. The main conclusions held for every seed.

## Which populations converged fastest and slowest, and why?

Fastest: the normal (n = 1, nothing to fix), the die (small gaps, no skewness) and the age at death mixture (two peaks,
but mild skewness). Slowest among the five required populations, leaving out the Cauchy: the exponential (skewness 2)
and the binomial (skewness 1.19 plus large gaps). Among the extra credit models the basketball model (118, because of
its gaps) was slower than both, and the dependent process (364) was the slowest of all.

Two rules explained almost every answer:

1. Skewness. For independent draws the skewness of the mean is gamma1 / sqrt(n), so my cutoff of 0.2 needs about
   (gamma1 / 0.2)² draws. This predicted the exponential (100 predicted, 100 found) and gave the right order of
   magnitude elsewhere.
2. Gaps. For a discrete population the mean moves in steps of 1 / n, which is 1 / (sigma × sqrt(n)) standard errors.
   The QQ check passed when this step fell to about 0.2 SE. This rule predicted the basketball model (119 predicted,
   118 found) and Binomial(5, 0.5) in a side experiment (19 predicted, 19 found). When a population is both skewed and
   discrete (Binomial(5, 0.1)), the two effects add up and the answer is larger than either rule alone.

The number of peaks did not matter: the two peaked age at death distribution was one of the fastest.

## What happened when the assumptions failed?

Dependent observations (06). The shape still became normal (at n = 364), but the center settled near 1.68 instead
of the naive 1, and the SD of the means was about 2.2 times the naive SE. A naive 95 percent interval would contain the
long run mean only about 63 percent of the time, at every n. The shape checks alone would never have shown this.

Not identically distributed observations (07). Almost nothing changed. The shooting percentage with fatigue became
normal at nearly the same n as with a constant p = 0.7, and the exact mean and SE formulas for independent but
non identical shots worked at every n.

Extremely heavy tails (05). The CLT failed completely. The mean of n Cauchy values has the same distribution as one
value, so the spread never shrank, even at n = 3,000. The sample median, which ignores the tails, became normal at
n = 50.

So the assumption that mattered most for the shape was the finite variance, and the one that mattered most for the
formulas was independence.

## Limitations

* Every answer depends on my cutoffs; for example, a QQ cutoff of 0.995 instead of 0.998 changes the die from 8 to 5
  and the binomial from 70 to 35.
* The chosen n is uncertain by several n (by tens of n for the exponential), as 09reproducibility.qmd shows.
* My QQ check counts the gaps of discrete populations. With a continuity correction, the normal approximation for the
  die and the binomial is good at smaller n than my answers.
* Within one seed all rows reuse one random stream, so they are not independent checks.

## Use of AI

I used Claude throughout the project. `aiLog.md` records my prompts, what I checked, and what I corrected, and
`experimentLog.md` records every setting I changed myself and what I decided.
