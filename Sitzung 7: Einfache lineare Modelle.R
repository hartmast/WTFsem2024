
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

