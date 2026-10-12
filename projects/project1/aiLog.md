# AI Interaction Log

Tool: Claude, used in one long conversation from 2026-10-09 to 2026-10-12. I wrote my prompts in Korean; below
they are translated and shortened. Settings changes I tested myself are in experimentLog.md; this file records how I
worked with the AI, what I checked, and what had to be corrected.

## Who did what

* The AI wrote functions.R, the R code in every file, and most of the English text.
* I ran every file in RStudio, compared the numbers with the AI's claims, ran my own Console experiments, made the
  decisions recorded in experimentLog.md, and wrote the predictions (section 2) for 04 to 09 myself, in Korean.
  The AI translated them into English and corrected factual errors in them.
* I asked the AI to explain every section until I could explain it myself, because of the rule "if you cannot
  explain a line, don't submit it."

## 1. Understanding the assignment (2026-10-09)

* Prompt: I uploaded the project instructions and asked what I need to do for Project 1.
* Response: the required populations (normal, die, exponential, Binomial(5, 0.1), Cauchy), the extra credit list,
  the deliverables, and the formula skewness of the mean = gamma1 / sqrt(n).
* How I checked it: compared the list with the instructions.

## 2. First version of the code, then rebuilding it step by step (2026-10-09)

* Prompt: "Give me the code; I will run it in RStudio."
* Response: a complete first version of all files at once.
* What I changed: I decided not to submit that version as it was. I rebuilt the project one population at a time
  (01, 03, 02, 04, 05, then 06 to 09), rendered each file, read each section with the AI's explanation, and
  committed each file separately.

## 3. The normality standard (01normal, 03exponential)

* The AI proposed the cutoffs |skewness| ≤ 0.2, |excess kurtosis| ≤ 0.3 and QQ correlation ≥ 0.998.
* I tested them myself: num = 1,000 instead of 10,000, and qqCor = 0.999 in 01normal and in 03exponential
  (experimentLog.md). In 01 the change did nothing; in 03 it moved the answer from 100 to 132 and made several of my
  sentences false. I went back to 0.998 both times.
* I told the AI that I check everything myself: I want to run the experiments and see the results, not only read them.

## 4. The die (02die)

* Prompt: how the 100,000 roll graph was made, and how to show that the formulas ignore the discreteness.
* Follow up: I asked to add a comparison of the die population across several seeds. Then I asked again, because the
  instructions say to use my student ID as the seed and not to change it because of results. I removed the
  comparison and kept seed 1159 only.
* I wanted to mention that real dice rolled by people are not exactly 1/6. The AI suggested Weldon's dice. I asked
  whether I need a source; I added Labby (2009) and checked the 33.77 percent myself from the WeldonDice data in the
  R package vcd (0.3377).
* I asked what the Interview Test is and why the chosen n is not a fixed number.

## 5. Binomial(5, 0.1) (04binomial)

* I asked what each section does and what I should rerun, then ran experiments myself: qqCor = 0.995 (n = 35, not
  the 40 shown in the table, because of the grid), Binomial(5, 0.5) (n = 19, exactly the gap prediction), and checks
  by hand (dbinom values, moments, the n = 30 probability). All in experimentLog.md.
* Section 2: I first asked the AI to just write it for me. When I asked whether that would be acceptable for the
  assignment, the answer was that the predictions should be mine. So I wrote a Korean draft (center and spread, the
  n for each check, my prediction for n = 30, the tails at n = 1, why I might be wrong), and the AI translated it.
* Problems: after I replaced section 2, rendering failed with "object 'exactTable' not found", because a code chunk
  had been deleted with the old text. The AI gave the full file again. The symbols ± and × inside R strings rendered
  as <U+00B1>; they were replaced with "+/-" and "times".

## 6. Cauchy (05cauchy)

* Prompt: what I need to add to functions.R for 05. The AI added the meansFun argument so that the same search can
  be run on the sample median.
* Section 2: my Korean draft, including my own guess that the median would become normal at about n = 30 to 40. The
  result was n = 50, and section 7 reports this as "Different".
* I asked what else I could test, and ran four Console experiments: a lighthouse model, max|X| / n, a t distribution
  with 3 df, and a 25 percent trimmed mean (experimentLog.md).
* Corrections: the AI first reported the t distribution as normal from n = 682. When I asked for a full review,
  it reran larger n and found that n = 1,500 to 5,000 failed again, so 682 was only where my grid stopped. For the
  trimmed mean, the numbers showed a larger SD than the median (0.2385 against 0.2273 at n = 50), which the theory
  also predicts for the Cauchy. A Python string escape had broken the LaTeX of the SE(median) formula; it was rewritten.
* I reviewed my predictions for these experiments with the AI. It removed "proving" and "eternally" as overstated,
  and corrected my claim that trimming gives the distribution a finite variance (only the trimmed mean has one).

## 7. Extra credit (06 to 08) and reproducibility (09)

* The AI wrote the first versions of these files, including section 2, and I saw their results (364, 118, 45)
  before writing my own predictions. Afterwards I answered guided questions in Korean (what a naive analysis
  predicts, which check decides, whether n = 30 is enough, and so on) and my answers replaced section 2. So these
  predictions were written after I had seen the results of the first version.
* Before writing, I ran the key numbers myself in the Console: E(X_2) = 1.5537 by simulation against 1.551 from the
  formula, the basketball SE ratio 0.967 and step 0.506 SE, and the age at death skewness −0.862 (n = 19).
* Factual errors in my answers that the AI corrected:
  * 06: I said a larger variance makes n = 30 not enough. Skewness, kurtosis and QQ correlation do not change when
    all values are multiplied by a constant, so the correct reason is the skewness (0.53 at n = 30).
  * 06: I said the heavier tail would push the answer above 209, but 209 already uses the long run skewness, which
    includes that tail.
  * 07: the Lindeberg condition also needs that no single shot dominates; the exact SE is 3.3 percent smaller than
    the naive SE (the naive SE is 3.4 percent larger).
  * 08: the middle bump at n = 2 is near age 35 (the average of the infant part, 4.5, and the adult part, 65), not
    near the overall mean of 50.
  * 09: my example 119 was the basketball answer, not one of the four populations in 09, and "mathematically
    impossible" was too strong; the exponential at n = 30 is about 7 noise units above the cutoff.
* My prediction in 09 that the exponential would move only from 100 to about 95 to 108 was wrong (73 to 132). I kept
  my prediction and added the explanation to section 6.

## 8. Errors in the AI's own text that were found and fixed

* 07: "the naive SE passes from n = 5" was wrong; it is now computed in the file (n = 10).
* 08: a claim about 03 being "harmless" was wrong and was removed.
* 05: a sentence in section 7 said I expected the mean to improve slowly, which contradicted my section 2.
* 06: the description of the sampling plot did not match the plot.
* 09: a sentence on the order of the binomial and the exponential across seeds was wrong (the binomial was larger
  for 2 of 5 seeds).
* README: "4 of 5 other seeds" was corrected to "all four other seeds", and "the exponential and the binomial were
  the slowest where the CLT holds" was wrong, because the basketball model (118) was slower than the exponential (100).

## 9. Final check before submission

* Prompt: check everything against the requirements and tell me if I need to do anything else.
* The AI compared my GitHub repository with the final files and rendered the full submission. It found that the
  functions.R on GitHub was an older version, so 05cauchy.qmd could not be rendered from the repository. The final
  functions.R is committed together with 06 to 09.
* I chose not to change 03exponential.qmd, which reports n = 150 for qqCor = 0.999 on the coarse grid; the full
  search gave 132 (experimentLog.md).

## What I learned about using AI here

The AI was fast at writing code and text, but several of its statements were wrong in ways that only showed up when
I rendered the files and compared the sentences with the numbers, or when it reran a check at larger n. Asking it to
review the whole project again found errors that a first answer did not. My own Console experiments were the part
that taught me the most, especially the cases where my prediction was wrong.
