# install.packages("tidyverse")
library(tidyverse)



# Das ist ein Kommentar

# Datentypen
typeof(2.5)
typeof(as.integer(2))

# Beispiele
a <- 2 + 2
b <- 4
c <- "4"
typeof(c)

# Beispiel für Addition
a + b

# Beispiel für character strings
horst <- "Hallo Welt"

# Vektoren und Listen
mein_erster_vektor <- c(1,2,3,4,5)
mein_zweiter_vektor <- c("Das", "ist", "ein", "Beispiel")

all(c(1:5) == mein_erster_vektor)


meine_erste_liste <- list(1, "a", 2, 3, "b", "c", c(1,2,3,4))
meine_erste_liste

mein_erster_vektor[3]
mein_zweiter_vektor[4]

meine_erste_liste[[7]][3]


# zwei Vektoren
namen <- c("Peter", "Petra", "Maria", "Marta")
groesse <- c(1.71, 1.70, 1.60, 1.65)

my_df <-  data.frame(Name = namen,
           Groesse = groesse)

# zuerst die Zeile, dann die Spalte:
my_df[3,2]


# Plot:
ggplot(my_df, aes(x = Name, y = Groesse)) +
  geom_point()
