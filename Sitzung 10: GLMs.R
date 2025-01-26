library(tidyverse)
library(lme4)
library(effects)
library(languageR)



# Daten aus languageR -----------------------------------------------------

d <- dative


# Relevante Variablen:
# RealizationOfRecipient, AnimacyOfRec
plot(d$RealizationOfRecipient ~d$AnimacyOfRec)


# Modell anpassen:
m <- glm(RealizationOfRecipient ~ AnimacyOfRec,
    data = d,
    family = "binomial")

# Resultate inspizieren:
summary(m)
plot(allEffects(m))

# Resultate interpretieren:
intercept <- coef(m)[1]
slope     <- coef(m)[2]

# Wahrscheinlichkeitsvorhersagen ableiten:
plogis(intercept + slope * 0) # Wahrscheinlichkeit, einen 
                              # präp. Dativ zu beobachten, wenn
                              # Rezipient belebt ist
                              # weil animate = base level category

# Woher wissen wir, dass die Wahrscheinlichkeit für
# präp. Dativ ausgegeben wird?
levels(m$data$RealizationOfRecipient)
# Weil die andere Kategorie (NP) die base level category ist.

# Der Intercept zeigt die Wahrscheinlichkeiz für PP,
# wenn AnimacyOfRec bei seinem Base level ist, also
levels(m$data$AnimacyOfRec) # animate als base level

# die positive Slope bedeutet, das für unbelebte Entitäten
# (im Vergleich zu belebten) die Odds, einen präp. Dativ
# zu beobachten, sich erhöhen

plogis(intercept + slope * 1) # Wahrscheinlichkeit, einen präp.
                              # Dativ zu beobachten, wenn Recipient
                              # unbelebt ist

# diese Werte sehen wir auch im effects plot:
plot(allEffects(m))


