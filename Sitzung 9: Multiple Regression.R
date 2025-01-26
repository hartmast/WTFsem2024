library(tidyverse)
library(languageR)

# Exkurs: Zipfsche Verteilung
data("alice")
table(alice) %>% as_tibble() %>% arrange(desc(n)) %>% 
  ggplot(aes(x = fct_reorder(alice, n), y = n, group = 1)) + geom_line()

# Exkurs: Logarithmische Tranformation
table(alice) %>% as_tibble() %>% arrange(desc(n)) %>%
  mutate(log_n = log(n)) %>% 
  ggplot(aes(x = fct_reorder(alice, log_n), y = log_n, group = 1)) + geom_line()


# Daten: Lexical decision
data("lexdec")

# visualisieren
plot(lexdec$RT, lexdec$Frequency)
plot(lexdec$RT, lexdec$Length)

# Modell anpassen
m <- lm(RT ~ Length * Frequency, data = lexdec)
m2 <- lm(RT ~ Length + Frequency, data = lexdec)
summary(m)

anova(m,m2)
