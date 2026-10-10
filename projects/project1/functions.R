student_id <- 1159

#num <- 100
#num <- 1000
num <- 10000
#num <- 100000

criteria <- list(
  #skew = 0.05,
  #skew = 0.1,
  skew = 0.2,
  #skew = 0.3,
  #kurt = 0.1,
  kurt = 0.3,
  #kurt = 0.5,
  #qqCor = 0.995,
  qqCor = 0.998
  #qqCor = 0.999
)

#seTol <- 0.01
#seTol <- 0.03
seTol <- 0.05

skewness <- function(x) {
  d <- x - mean(x)
  mean(d^3) / mean(d^2)^1.5
}

exKurtosis <- function(x) {
  d <- x - mean(x)
  mean(d^4) / mean(d^2)^2 - 3
}

qqCorrelation <- function(x) {
  cor(sort(x), qnorm(ppoints(length(x))))
}

tailShares <- function(x) {
  z <- (x - mean(x)) / sd(x)
  c(low = mean(z < -1.96), high = mean(z > 1.96))
}

iidPrediction <- function(gamma1, gamma2) {
  function(n) c(skew = gamma1 / sqrt(n), kurt = gamma2 / n)
}

iidSE <- function(sigma) {
  function(n) sigma / sqrt(n)
}

predictedN <- function(gamma1, cut = criteria$skew) {
  max(1, ceiling((gamma1 / cut)^2))
}

simMeans <- function(generator, n, reps = num) {
  replicate(reps, mean(generator(n)))
}

diagnose <- function(means, n, mu, theoSE, pred) {
  se <- theoSE(n)
  pr <- pred(n)
  sw <- shapiro.test(sample(means, min(5000, length(means))))
  tails <- tailShares(means)
  data.frame(
    n        = n,
    simMean  = mean(means),
    theoMean = mu,
    simSD    = sd(means),
    theoSE   = se,
    seRatio  = sd(means) / se,
    skew     = skewness(means),
    predSkew = unname(pr["skew"]),
    exKurt   = exKurtosis(means),
    predKurt = unname(pr["kurt"]),
    qqCor    = qqCorrelation(means),
    tailLow  = unname(tails["low"]),
    tailHigh = unname(tails["high"]),
    swW      = unname(sw$statistic),
    swP      = sw$p.value
  )
}

isNormalEnough <- function(tab, crit = criteria) {
  abs(tab$skew) <= crit$skew &
    abs(tab$exKurt) <= crit$kurt &
    tab$qqCor >= crit$qqCor
}

seAgrees <- function(tab, tol = seTol) {
  abs(tab$seRatio - 1) <= tol
}

runGrid <- function(generator, nValues, mu, theoSE, pred, reps = num, seed = student_id) {
  nValues <- sort(unique(nValues))
  means <- list()
  rows <- list()
  for (n in nValues) {
    set.seed(seed)
    m <- simMeans(generator, n, reps)
    key <- as.character(n)
    means[[key]] <- m
    rows[[key]] <- diagnose(m, n, mu, theoSE, pred)
  }
  tab <- do.call(rbind, rows)
  rownames(tab) <- NULL
  tab$normalEnough <- isNormalEnough(tab)
  tab$seOK <- seAgrees(tab)
  list(table = tab, means = means)
}

smallestN <- function(tab, crit = criteria) {
  tab <- tab[order(tab$n), ]
  ok <- isNormalEnough(tab, crit)
  for (i in 1:nrow(tab)) {
    if (all(ok[i:nrow(tab)])) return(tab$n[i])
  }
  NA
}

refineGrid <- function(tab, howMany = 12) {
  n0 <- smallestN(tab)
  if (is.na(n0)) return(numeric(0))
  below <- tab$n[tab$n < n0]
  if (length(below) == 0) return(numeric(0))
  candidates <- unique(round(seq(max(below), n0, length.out = howMany)))
  setdiff(candidates, tab$n)
}

combineGrids <- function(a, b) {
  tab <- rbind(a$table, b$table)
  tab <- tab[order(tab$n), ]
  rownames(tab) <- NULL
  means <- c(a$means, b$means)
  means <- means[order(as.numeric(names(means)))]
  list(table = tab, means = means)
}

searchN <- function(generator, coarse, mu, theoSE, pred, reps = num, seed = student_id) {
  first <- runGrid(generator, coarse, mu, theoSE, pred, reps, seed)
  extra <- refineGrid(first$table)
  if (length(extra) == 0) return(first)
  second <- runGrid(generator, extra, mu, theoSE, pred, reps, seed)
  combineGrids(first, second)
}


showTable <- function(tab, digits = 4) {
  cols <- c("n", "simMean", "theoMean", "simSD", "theoSE", "seRatio",
            "skew", "predSkew", "exKurt", "predKurt", "qqCor",
            "tailLow", "tailHigh", "swP", "normalEnough", "seOK")
  knitr::kable(tab[, cols], digits = digits, row.names = FALSE)
}

plotSampling <- function(res, nShow, mu, theoSE, label = "") {
  old <- par(mfrow = c(2, length(nShow)), mar = c(4, 4, 3, 1))
  on.exit(par(old))
  for (n in nShow) {
    m <- res$means[[as.character(n)]]
    hist(m, breaks = 40, probability = TRUE, col = "gray85", border = "white",
         main = paste0(label, "\nn = ", n), xlab = "Sample mean")
    curve(dnorm(x, mean = mu, sd = theoSE(n)), add = TRUE, col = "firebrick", lwd = 2)
    curve(dnorm(x, mean = mean(m), sd = sd(m)), add = TRUE, col = "steelblue", lwd = 2, lty = 2)
  }
  for (n in nShow) {
    m <- res$means[[as.character(n)]]
    qqnorm(m, main = paste("QQ plot: n =", n), pch = 16, cex = 0.3)
    qqline(m, col = "firebrick", lwd = 2)
  }
}

plotConvergence <- function(tab, label = "") {
  old <- par(mfrow = c(1, 3), mar = c(4, 4, 3, 1))
  on.exit(par(old))
  ns <- tab$n
  plot(ns, tab$skew, log = "x", pch = 16, xlab = "n (log scale)", ylab = "Skewness of means",
       main = paste(label, "skewness"),
       ylim = range(c(tab$skew, tab$predSkew, criteria$skew, -criteria$skew)))
  lines(ns, tab$predSkew, col = "firebrick", lwd = 2)
  abline(h = c(-1, 1) * criteria$skew, lty = 2, col = "gray40")
  abline(h = 0, col = "gray80")
  
  plot(ns, tab$exKurt, log = "x", pch = 16, xlab = "n (log scale)", ylab = "Excess kurtosis of means",
       main = paste(label, "kurtosis"),
       ylim = range(c(tab$exKurt, tab$predKurt, criteria$kurt, -criteria$kurt)))
  lines(ns, tab$predKurt, col = "firebrick", lwd = 2)
  abline(h = c(-1, 1) * criteria$kurt, lty = 2, col = "gray40")
  abline(h = 0, col = "gray80")
  
  plot(ns, tab$qqCor, log = "x", pch = 16, xlab = "n (log scale)", ylab = "QQ correlation",
       main = paste(label, "QQ straightness"),
       ylim = range(c(tab$qqCor, criteria$qqCor, 1)))
  abline(h = criteria$qqCor, lty = 2, col = "gray40")
}

cdfGap <- function(value, prob, mu, se, shift = 0) {
  F <- cumsum(prob)
  Fbefore <- c(0, head(F, -1))
  normalF <- pnorm(value + shift, mean = mu, sd = se)
  if (shift == 0) max(abs(F - normalF), abs(Fbefore - normalF)) else max(abs(F - normalF))
}
plotSE <- function(tab, label = "") {
  plot(tab$n, tab$simSD, log = "xy", pch = 16,
       xlab = "n (log scale)", ylab = "SD of sample means (log scale)",
       main = paste(label, ": simulated SD vs theoretical SE"),
       ylim = range(c(tab$simSD, tab$theoSE)))
  lines(tab$n, tab$theoSE, col = "firebrick", lwd = 2)
  legend("topright", c("Simulated SD of means", "Theoretical SE"),
         pch = c(16, NA), lty = c(NA, 1), col = c("black", "firebrick"), lwd = c(NA, 2), bty = "n")
}

populations <- list(
  normal = list(
    label = "Standard Normal",
    generator = function(n) rnorm(n, mean = 0, sd = 1),
    mu = 0, sigma = 1, gamma1 = 0, gamma2 = 0,
    coarse = c(1, 2, 3, 5, 10, 20, 30, 50, 100)
  ),
  die = list(
    label = "Six Sided Die",
    generator = function(n) sample(1:6, n, replace = TRUE),
    mu = 3.5, sigma = sqrt(35 / 12), gamma1 = 0, gamma2 = -222 / 175,
    coarse = c(1, 2, 3, 4, 5, 6, 8, 10, 15, 20, 30, 50, 100)
  ),
  binomial = list(
    label = "Binomial(5, 0.1)",
    generator = function(n) rbinom(n, size = 5, prob = 0.1),
    mu = 0.5, sigma = sqrt(0.45), gamma1 = 0.8 / sqrt(0.45), gamma2 = 0.46 / 0.45,
    coarse = c(1, 2, 5, 10, 20, 30, 40, 50, 75, 100, 150, 200, 300, 500)
  ),
  exponential = list(
    label = "Exponential(1)",
    generator = function(n) rexp(n, rate = 1),
    mu = 1, sigma = 1, gamma1 = 2, gamma2 = 6,
    coarse = c(1, 2, 5, 10, 20, 30, 50, 75, 100, 150, 200, 300, 500)
  )
)

analyzePopulation <- function(pop, seed = student_id, reps = num) {
  searchN(pop$generator, pop$coarse, pop$mu,
          theoSE = iidSE(pop$sigma),
          pred = iidPrediction(pop$gamma1, pop$gamma2),
          reps = reps, seed = seed)
}

plotLattice <- function(res, nShow, mu, theoSE, label = "") {
  old <- par(mfrow = c(2, length(nShow)), mar = c(4, 4, 3, 1))
  on.exit(par(old))
  for (n in nShow) {
    m <- res$means[[as.character(n)]]
    steps <- round((max(m) - min(m)) * n)
    br <- min(m) - 1 / (2 * n) + (0:(steps + 1)) / n
    h <- hist(m, breaks = br, plot = FALSE)
    curveTop <- dnorm(mu, mean = mu, sd = theoSE(n))
    hist(m, breaks = br, probability = TRUE, col = "gray75", border = if (n <= 10) "white" else NA,
         ylim = c(0, max(h$density, curveTop)),
         main = paste0(label, "\nn = ", n), xlab = "Sample mean")
    curve(dnorm(x, mean = mu, sd = theoSE(n)), add = TRUE, col = "firebrick", lwd = 2)
  }
  for (n in nShow) {
    m <- res$means[[as.character(n)]]
    qqnorm(m, main = paste("QQ plot: n =", n), pch = 16, cex = 0.3)
    qqline(m, col = "firebrick", lwd = 2)
  }
}
