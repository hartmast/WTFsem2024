library(tidyverse)


# Scatterplot -------------------------------

data("cars")
plot(x = cars$speed, y = cars$dist)

plot(x = cars$speed, # x-Achse
     y = cars$dist, # y-Achse
     xlab = "Speed (mph)", # x-Achsen-Beschriftung
     ylab = "Distance (ft)", #y-Achsen-Beschriftung
     main = "Speed and Stopping Distances of Cars", # Titel
     pch = 20, # Punkttyp
     col = "#026ab3")
abline(lm(dist~speed, data = cars), # Regressionslinie
       col = "grey40", # Farbe
       lty = 2) # Linientyp


# Lineplot ----------------------------------

data("WWWusage")

plot(x = 1:100,
     y = WWWusage,
     type = "o",
     xlab="Time",
     ylab="www usage",
     ylim=c(0,250))
grid(col = "grey70")
points(x=20,y=150, col="red")
text(x=80,y=200,"Hallo Welt")
title("WWW usage")


# Barplot -------------------------------------

set.seed(1234)
spl <- LETTERS[abs(round(rnorm(200, mean = 5, sd = 2)))]

barplot(table(spl))
spl %>% table %>% sort %>% rev %>% barplot


# Boxplot -------------------------------------

# Sample data
set.seed(42)
d <- tibble(x = rnorm(100, mean = 5, sd = 1),
            y = rnorm(100, mean = 7, sd = 3))
boxplot(d)


############################
######## ggplot ############
############################



# Scatterplot -------------------------------------------------------------

( p1 <- ggplot(cars, aes(
  x = speed,
  y = dist
)) + geom_point() )


p1 + geom_smooth(method = "lm") + xlab("Speed") + ylab("Distance") +
  ggtitle("Speed and distance") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))



