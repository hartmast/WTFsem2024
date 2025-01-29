library(tidyverse)
library(lme4)
library(effects)
library(skimr)
library(languageR)
library(broom)
library(afex)
library(MuMIn)
library(lmerTest)
library(lattice)
library(beeswarm)
library(languageR)
library(moderndive)
library(Hmisc)

##########################
## Linear mixed models ##
#########################


# understanding the concept behind varying
# intercepts and slopes:

# fake data ---------------------------------------------------------------

hulk      <-   tibble(trial = c(1:10), RTs = c(7,6,5,6,4,4,3,3,2,2))
cptmarvel <-   tibble(trial = c(1:10), RTs = c(8,5,6,7,7,7.5,8,7,8,8))
groot     <-   tibble(trial = c(1:10), RTs = c(12,11,13,14,11,9,8,8,9,8))
ironman   <-   tibble(trial = c(1:10), RTs = c(4,5,5,6,7,7,8,9,9,9))

av <- rbind(mutate(hulk, participant = "Hulk"),
            mutate(cptmarvel, participant = "Captain Marvel"),
            mutate(groot, participant = "Groot"),
            mutate(ironman, participant = "Iron Man"))

# plot
(p <- ggplot(av, aes(x = trial, y = RTs)) +
    geom_point() + facet_wrap(~ participant))

# fit a simple lm
m_av <- lm(RTs ~ trial, data = av)
summary(m_av)


p + geom_smooth(method = "lm", se = F) 
p + geom_abline(aes(intercept = coef(m_av)[1], 
                    slope = coef(m_av)[2]), 
                lty = 2, col = "blue")


# fit a model with varying intercept
m_av01 <- lmer(RTs ~ trial + (1 | participant), data = av)
summary(m_av01)

# get coefficients for individual participants:
m_av01_coef <- coef(m_av01)$participant %>% rownames_to_column() %>%
  setNames(c("participant", "intercept", "slope"))

# visualize varying intercepts:
left_join(av, m_av01_coef) %>% 
  ggplot(aes(x = trial, y = RTs)) +
  geom_point() + facet_wrap(~ participant) +
  geom_abline(aes(intercept = intercept, slope = slope),
              col = "blue", lty = 2) 

# add varying slopes:

m_av02 <- lmer(RTs ~ trial + (1 + trial | participant), data = av)

# get coefficients:
m_av02_coef <- coef(m_av02)$participant %>% rownames_to_column() %>%
  setNames(c("participant", "intercept02", "slope02"))

left_join(left_join(av, m_av01_coef), m_av02_coef) %>% 
  ggplot(aes(x = trial, y = RTs)) +
  geom_point() + facet_wrap(~ participant) +
  geom_abline(aes(intercept = intercept, slope = slope),
              col = "blue", lty = 2) + 
  geom_abline(aes(intercept = intercept02, slope = slope02),
              col = "red", lty = 3) +
  geom_abline(aes(intercept = coef(m_av)[1], 
                  slope = coef(m_av)[2]), 
              lty = 4, col = "grey")

summary(m_av02)

#############################################
## example with made-up data (Winter 2020) ##
#############################################

# set seed
set.seed (666)

# random participant IDs
ppt_ids <- gl(6, 20)

# 20 item identifiers
# gl: ‘generate levels’; it generates factors
# for a specified number of levels
it_ids <- gl(20, 1)

# repeat participant IDs 6 times:
# 6 items collected from each participant
it_ids <- rep(it_ids, 6)

# word frequency: each word should have
# its own (log) frequency value

# hence: 20 random numbers, rounded:
logfreqs <- round(rexp(20) * 5, 2)

# Repeat frequency predictor 6 times:
logfreqs <- rep(logfreqs, 6)

# Combine predictors:
xdata <- tibble( ppt = ppt_ids, item = it_ids,
                 freq = logfreqs)


# column containing the intercept: 
# 300 (reasonable value for vowel duration)
xdata$int <- 300

# Generate varying intercepts for participants:
ppt_ints <- rnorm(6, sd = 40)

# add the varying intercepts to the dataframe:
xdata$ppt_ints <- rep(ppt_ints, each = 20)

# Generate 20 varying intercepts for items:
item_ints <- rnorm(20, sd = 20)

# Repeat item intercepts for six participants
# and add them to the dataframe:
item_ints <- rep(item_ints, times = 6)
xdata$item_ints <- item_ints

# add residual variation
xdata$error <- rnorm(120, sd = 20)

# the actual frequency effect: for each
# increase in log frequency by 1, vowel
# durations are set to increased by 5ms
xdata$effect <- (-5) * xdata$freq

# add to df
xdata <- mutate(xdata,
                dur = int + ppt_ints + item_ints +
                  error + effect)
# to make the dataset look more like an actual one,
# let's get rid of the columns used to create the data
xreal <- select(xdata, -(int:effect))


# fit the model:
xmdl <- lmer(dur ~ freq + (1|ppt) + (1|item),
             data = xreal, REML = FALSE)

# model summary
summary(xmdl)
fixef(xmdl)

intercept <- fixef(xmdl)[1]
slope <- fixef(xmdl)[2]

plot(x = xreal$freq, y = xreal$dur)
abline(intercept, slope)


# extracting information out of lme4 objects
coef(xmdl)
plot(allEffects(xmdl))
fixef(xmdl)
ranef(xmdl)
allEffects(xmdl)
plot(allEffects(xmdl))
dotplot(ranef(xmdl))



#########################################
### authentic data (from Baayen 2008) ###
#########################################


# load data (from languageR)
data("lexdec")

xylowess.fnc(RT ~ Trial | Subject, data = lexdec, 
             ylabel = "log RT", xlabel = "Trial")

# remove outliers, only use correct answers
lexdec2 <- lexdec[lexdec$RT < 7, ]
lexdec3 <- lexdec2[lexdec2$Correct == "correct", ]

# center relevant data
lexdec3$Frequency.c <- scale(lexdec3$Frequency, scale = F)
lexdec3$Trial.c <- scale(lexdec3$Trial, scale = F)


# plot each participant in a single panel
xylowess.fnc(RT ~ Trial | Subject, data = lexdec3, 
             ylabel = "log RT", xlabel = "Trial")


# model: Reaction Time ~ Frequency
m0 <- lmer(RT ~ 1 + 
             (1 | Subject) + 
             (1 | Word), 
           data = lexdec3, 
           REML = F) 

m0a <- lmer(RT ~ Frequency.c + 
              (1 | Subject), 
            data = lexdec3, 
            REML = F) 

m1 <- lme4::lmer(RT ~ Frequency.c + 
                   (1 | Subject) + 
                   (1 | Word), 
                 data = lexdec3, 
                 REML = F) # REML: restricted maximum likelihood

anova(m0, m1)
anova(m0a, m1)

# REML = F is recommended for models in which one
# would like to compare fixed effects.

summary(m1)


plot(allEffects(m1))

# random intercepts for the individual words
dotplot(ranef(m1))[1]

# random intercepts for the individual participants
dotplot(ranef(m1))[2]

# residuals-fitted plot
plot(m1)

# qqplot
qqnorm(resid(m1))
qqline(resid(m1), col = "red")


r.squaredGLMM(m1)


# random slopes
data("quasif") 
# SOA = stimulus onset asynchrony: the time 
# between the presentation of a prime or distractor 
# and the presentation of the target in chronometric experiments)



# Plot
m_l <- lm(RT ~ SOA, data= quasif)
summary(m_l)

boxplot(quasif$SOA, quasif$RT)
xylowess.fnc(RT ~ SOA | Subject, data = quasif, 
             ylab = "log RT", xlabel = "SOA")


m2 <- lmer(RT ~ SOA + (1|Item) +
             (1 + SOA|Subject), data = quasif, REML = F)

summary(m2)

m2.0 <- lmer(RT ~ (1|Item) +
               (1 + SOA|Subject), data = quasif, REML = F)



# model comparison
anova(m2, m2.0)







