library(effects)


# Daten einlesen
hw <- read.csv("data/howell.csv")

# Daten visualisieren
plot(hw$height, hw$weight)

# nur Erwachsene
hw_backup <- hw
hw <- subset(hw, age >= 18)

# Daten für Erwachsene visualisieren
plot(hw$height, hw$weight)

# einfaches Modell anpassen
m01 <- lm(height ~ weight, data = hw)

# Modell zusammenfassen
summary(m01)



# Datentransformation -----------------------------------------------------

# Zentrieren

hw$height_centered <- hw$height - mean(hw$height)
hw$weight_centered <- hw$weight - mean(hw$weight)

hist(hw$height)
hist(hw$height_centered)


plot(1:length(hw$height), sort(hw$height)) 
abline(h = mean(hw$height), col = "red", lty = 2)
plot(1:length(hw$height_centered), sort(hw$height_centered))



# Standardisieren

hw$height_standardized <- hw$height_centered / sd(hw$height_centered)
hw$weight_standardized <- hw$weight_centered / sd(hw$weight_centered)

hist(hw$height_standardized)
plot(1:length(hw$height_standardized), sort(hw$height_standardized)) 


# R-interne Funktion für z-Standardisierung
hw$height_scaled <- as.numeric(scale(hw$height))
hw$weight_scaled <- as.numeric(scale(hw$weight))

# gleiche Werte wie bei manueller Berechnung?
hist(hw$height_standardized)
hist(hw$height_scaled)
all(hw$height_standardized == hw$height_scaled)

# neues Modell mit standardisierten Werten:

m2 <- lm(height_standardized ~ weight_standardized, data =  hw)
summary(m2)

plot(allEffects(m2))


plot(hw_backup$height, hw_backup$weight)

