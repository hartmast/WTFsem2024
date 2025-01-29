library(tidyverse)
library(lme4)
library(effects)
library(MuMIn)
library(beeswarm)

# Daten
d <- read_csv("data/maedchen.csv")

# NAs ausschließen
d <- d[!is.na(d$dist),]

# Visualisierung
beeswarm(d$dist ~ d$anaph)
boxplot(d$dist ~ d$anaph, add = T, col = rgb(0, .4, .8, alpha = .3))

# anaphorische Referenz als Faktor
d$anaph <- factor(d$anaph)

# Distanz zentrieren
d$dist_c <- (d$dist) - mean(d$dist)

# Modell
m <- glm(anaph ~ dist_c , data = d, family = "binomial")
summary(m)

m0 <- glm(anaph ~ 1 , data = d, family = "binomial")
anova(m, m0, test = "Chisq")

# Koeffizienten
coef(m)

# Für jedes zusätzliche Wort zwischen "Mädchen" und dem
# Pronomen erhöhen sich die Log Odds, dass "sie" statt "es"
# auftritt, um 0,08.

# um von Log odds zu Odds zu kommen, können wir
# die logistische Funktion benutzen

# Objekte mit Intercept und Slope:
intercept <- coef(m)[1]
slope     <- coef(m)[2]

# Log odds für dist = 0 (d.h. wenn der Distanzwert den
# Mittelwert aller Distanzwerte beträgt)
intercept + slope*0

# vorhergesagte Warscheinlichkeit, dass "sie" statt "es" auftritt,
# wenn der Distanzwert auf dem Mittelwert liegt:
plogis(intercept + slope * 0)

# vorhergesagte Warscheinlichkeit, dass "sie" statt "es" auftritt,
# wenn der Distanzwert mean(dist) + 1 ist
plogis(intercept + slope * 1)

# vorhergesagte Warscheinlichkeit, dass "sie" statt "es" auftritt,
# wenn der Distanzwert mean(dist) + 2 ist
plogis(intercept + slope * 2)

# etc.


### Vorhersagen

# Werte, für die wir Prädiktionen erhalten wollen

vs <- seq(min(d$dist_c), max(d$dist_c), 1)

# DF für Vorhersagen:
preds <- tibble(dist_c = vs)

# Predictions:
preds$preds <- predict(m, preds)

# logistisch transformieren:
preds$preds2 <- plogis(preds$preds)

# Konfidenzintervalle können aus dem Standardfehler
# ableiten:
# CI = fit + / - 1.96*SE

fit <- predict(m, preds, se.fit = T)$fit
se  <- predict(m, preds, se.fit = T)$se.fit
ci_upper <- fit + 1.96 * se
ci_lower <- fit - 1.96 * se

# logistisch transformieren:
fit <- plogis(fit)
ci_upper <- plogis(ci_upper)
ci_lower <- plogis(ci_lower)

# Plot:
plot(vs, fit, type="l", ylim = c(0,1),
     lwd = 2, col = "blue", 
     ylab = "Wahrscheinlichkeit \'sie\'", xlab = "Distanz") 
lines(vs, ci_upper, lty = 3)
lines(vs, ci_lower, lty = 3)
polygon(x = c(vs, rev(vs)),
        y = c(ci_upper, rev(ci_lower)),
        col = rgb(0,.4,.6, alpha = .2), border = F)

# wir können auch die nicht-zentrierte Version
# noch hinzufügen:

axis(3, at = seq(-5, 20, length.out = 6),
     labels = round(seq(0,  20+mean(d$dist), length.out = 6)))
