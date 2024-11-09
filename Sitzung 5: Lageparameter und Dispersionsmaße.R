
library(tidyverse)

# kategoriale Variablen

# Seed setzen
set.seed(42)
sample(1:49, 6)


set.seed(666)
spl <- sample(c(LETTERS, letters), 200, replace = T)

# Tabelle erstellen
tbl <- table(spl)
tbl <- sort(tbl, decreasing = T)
tbl <- data.frame(tbl)
colnames(tbl) <- c("Buchstabe", "Frequenz")


# normalisierte Entropie

# Anzahl der Variablenausprägungen
k <- length(levels(factor(tbl$Buchstabe)))

# Proportionen der Variablenausprägungen
props <- prop.table(table(spl))

# sicherstellen, dass nur Werte > 0 im Vektor sind
# (hier kein Problem, aber prinzipiell mögliche
# Fehlerquelle)

props <- props[props > 0]

# in Hnorm-Formel einsetzen:
hnorm <- -sum(props * log2(props)) / log2(k)
hnorm

# Barplot:
barplot(sort(table(spl)))

spl %>% table %>% sort %>% barplot



# ordinale Variablen

set.seed(0611)
schulnoten <- sample(1:6, 30, replace = TRUE)
table(schulnoten) %>% median
table(schulnoten) %>% IQR
sort(schulnoten)[15]
sort(schulnoten)[16]
median(schulnoten)
mean(schulnoten)
table(schulnoten)

# Variablenausprägungen:
factor(schulnoten) # 1,2,3,4,5,6

table_sn <- table(schulnoten)
table_sn <- table_sn %>% data.frame()
table_sn$schulnoten <- factor(table_sn$schulnoten)



# neuer Seed
set.seed(100)
ord <- sample(c(1:10), 100, replace = T)

# Tabelle:
table(ord)

sort(table(ord)) %>%
  barplot()
median(ord)
boxplot(ord)


# numerische Variablen

set.seed(123)
nm <- rnorm(n = 100, mean = 10, sd = 5)

# Mittelwert:
mean(nm)

# Standardabweichung:
sqrt(sum((nm-mean(nm))^2) / (length(nm)-1))

# Standardfehler:
sd(nm) / sqrt(length(nm))

# alternativ:
sqrt(var(nm) / length(nm))

