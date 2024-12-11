library(tidyverse)
library(car)
library(visreg)
library(effects)
library(ggeffects)
library(interactions)
library(rsm)
library(moderndive)

# Tulips: Example from McElreath (2020)
# t <- read_csv("data/tulips.csv")
t <- read_delim("https://raw.githubusercontent.com/rmcelreath/rethinking/master/data/tulips.csv",
                delim = ";")

# center predictors
t$water.c <- t$water - mean(t$water)
t$shade.c <- t$shade - mean(t$shade)

# Model without interaction
m00 <- lm(blooms ~ water.c + shade.c, data = t)

# model with interaction
m01 <- lm(blooms ~ water.c + shade.c + water.c : shade.c, 
          data = t) # equivalent zu m03 <- lm(blooms ~ water.c * shade.c, data = t)
m01b <- lm(blooms ~ water.c + shade.c + water.c:shade.c, 
           data = t)
m02 <- lm(blooms ~ water.c*shade.c, data = t)

# compare models
summary(m00)
summary(m01)
summary(m02)

# visualize interactions
visreg(m01, "shade.c", by = "water.c")

# for comparison:
visreg(m00, "shade.c", by = "water.c") # same slope for all!

# multicollinearity?
car::vif(m00)
car::vif(m01, type = "predictor")




# linguistic example: iconicity -------------------------------------------

# In an experiment, participants were asked to 
# rate the iconicity of given words on a scale from 
# -5 to +5 (‘How much does this word sound like what it 
# means?’). 

# Response variable: Iconicity rating

# Predictors: (i) whether the word in question is 
# a noun or a verb, (ii) the sensory experience 
# rating (SER) for each word.

# d <- read_csv("data/perry_winter_2017_iconicity.csv")
d <- read_csv("https://osf.io/download/43btm/")

# only use nouns and verbs
d <- filter(d, POS %in% c("Verb", "Noun"))

# explorative visualization
ggplot(d, aes(x = SER, y = Iconicity, col = POS, pch = POS)) +
  geom_point() +
  scale_color_viridis_d(begin = .1, end = .9) + # cosmetics
  theme_bw() +                                  # cosmetics
  guides(col = guide_legend(reverse = T),       # cosmetics
         pch = guide_legend(reverse = T))       # cosmetics

# centering predictors
d$SER_c <- d$SER - mean(d$SER, na.rm = T)

# plot again with centered predictor:
(p <- ggplot(d, aes(x = SER_c, y = Iconicity, col = POS, pch = POS)) +
  geom_point(alpha=.3) +
  scale_color_viridis_d(begin = .1, end = .9) + # cosmetics
  theme_bw() +                                  # cosmetics
  guides(col = guide_legend(reverse = T),       # cosmetics
         pch = guide_legend(reverse = T)))      # cosmetics



p + geom_smooth()

# first, model without interaction:
nv_m1 <- lm(Iconicity ~ SER_c + POS, data = d)
summary(nv_m1)


# We can see that higher values of SER lead to higher 
# ratings of iconicity. On average, verbs are rated 
# .6 points more iconic than nouns.

# Since the slope of SER is the same for both nouns 
# and verbs, a model like this is also called a parallel 
# slopes model.

# visualize parallel slopes using the moderndive package:
p + geom_parallel_slopes()


# model with interaction:
# When using geom_smooth() and a colour aesthetic 
# for different groups, separate models for all groups 
# are automatically fit. 
# If their slopes vary drastically, that’s a good 
# indicator for an interaction:

p + geom_smooth(method = "lm", se = FALSE)



# model with interaction --------------------------------------------------

# the following two commands are equivalent:
nv_m2 <- lm(Iconicity ~ SER_c * POS, data = d)
nv_m2 <- lm(Iconicity ~ SER_c + POS + SER_c:POS, data = d) # same thing

summary(nv_m2)

plot(allEffects(nv_m1)) # same slope for both
plot(allEffects(nv_m2)) # different slopes for nouns and verbs

# Interpreting interactions
coef(nv_m2)

# Important: the SER slope is now the slope of sensory
# experience ratings ONLY FOR THE NOUNS.
# Compare what happens when we fit a model
# only with the nouns
lm(Iconicity ~ SER_c, data = filter(d, POS == "Noun")) %>% coef

# Likewise, the POSVerb effect is the noun-verb
# difference only for words with a sensory experience
# rating of 0:
coef(nv_m2)
p + geom_smooth(method = "lm") +
  geom_point(aes(x = 0, y = coef(nv_m2)[1]), size = 6,
             shape = 22, fill = "white", show.legend = F)
  
