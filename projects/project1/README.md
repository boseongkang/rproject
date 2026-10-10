# How Fast Does Normal Happen? Stress Testing the Central Limit Theorem

Monte Carlo study in R of how quickly the sampling distribution of the mean becomes
approximately normal, and what happens when CLT assumptions fail.

## Status

| File | Contents | Status |
|:--|:--|:--|
| functions.R | Shared settings and helpers | grows as each population is added |
| 01normal.qmd | Standard normal (control) | done |
| 03exponential.qmd | Exponential(1) | next |
| 02die.qmd, 04binomial.qmd, 05cauchy.qmd | Remaining required populations | not started |
| experimentLog.md | Settings I changed, what I observed, and what I decided | updated as I go |

Reproduce: open this folder in RStudio and render each .qmd file.
