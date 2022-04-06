weight <- c(61, 100,  56, 113,  99, 103,  75,  62,  ## sire 1
            75, 102,  95, 103,  98, 115,  98,  94,  ## sire 2
            58,  60,  60,  57,  57,  59,  54, 100,  ## sire 3
            57,  56,  67,  59,  58, 121, 101, 101,  ## sire 4
            59,  46, 120, 115, 115,  93, 105,  75)  ## sire 5
sire    <- factor(rep(1:5, each = 8))
animals <- data.frame(weight, sire)
str(animals)

library(lme4)
fit.animals <- lmer(weight ~ (1 | sire), data = animals)

summary(fit.animals)

fit.animals.aov <- aov(weight ~ sire, data = animals)
confint(fit.animals.aov)
