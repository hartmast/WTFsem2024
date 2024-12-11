library(tidyverse)
library(effects)
library(skimr)
library(patchwork)

# read data
d <- read_csv("data/baayen_2008_rts.csv")

# data structure
skim(d)

# plot
plot(d$WrittenFrequency, d$RTlexdec, pch = 16, cex = .8)
lines(lowess(with(d, RTlexdec~WrittenFrequency)), 
      col = "red", lwd = 2)
plot(d$LengthInLetters, d$RTlexdec, pch = 16, cex = .8)
with(d, RTlexdec ~ LengthInLetters) %>% lowess %>% 
  lines (col="red", lwd = 2)

# center and scale variables
# NB: The variables are already logarithmized
d$wf_centered <- scale(d$WrittenFrequency, center = TRUE, 
                       scale = TRUE) %>% as.numeric
d$length_centered <- scale(d$LengthInLetters, center = TRUE, 
                           scale = TRUE) %>% as.numeric
d$lexdec_centered <- scale(d$RTlexdec, center = TRUE,
                           scale = TRUE)


# fit model
m <- lm(lexdec_centered ~ wf_centered + length_centered + AgeSubject, 
        data = d)

# inspect model
summary(m)
coef(m)

# inspect model plots
plot(allEffects(m))


# test model assumptions --------------------------------------------------

# normality:

# histogram
hist(resid(m))


# (multi)collinearity: VIFs
car::vif(m)

# homoskedasticity:
# QQ plot
qqnorm(residuals(m)); qqline(residuals(m))

# fitted X residuals
plot(fitted(m), residuals(m)) # looks ok-ish but slightly
                              # heteroskedastic



# categorical predictors --------------------------------------------------

# "Age" is operationalized as a categorical
# predictor in our data: old vs. young
d$AgeSubject <- factor(d$AgeSubject, 
                       levels = c("young", "old"))
(p0 <- ggplot(d, aes(x = AgeSubject, y = RTlexdec)) +
  geom_point() + xlab("Age") + ggtitle("Age ~ RT") +
   theme(plot.title = element_text(face = "bold", hjust = 0.5)))

# treatment coding: 
d$AgeSubjectTreatmentCoding <- as.numeric(d$AgeSubject)-1

(p1 <- ggplot(d, aes(x = factor(AgeSubjectTreatmentCoding), y = RTlexdec)) +
  geom_point() + xlab("Age") + ggtitle("Treatment coding") +
    theme(plot.title = element_text(face = "bold", hjust = 0.5)))

# sum coding:
d$AgeSubjectSumCoding <- ifelse(d$AgeSubject=="young", -1, 1)

(p2 <- ggplot(d, aes(x = factor(AgeSubjectSumCoding), y = RTlexdec)) +
    geom_point() + xlab("Age") + ggtitle("Sum coding") +
    theme(plot.title = element_text(face = "bold", hjust = 0.5)))


# all graphs next to each other
p0 | p1 | p2



# also see:
contr.treatment(2)
contr.sum(2)

# age as the only predictor in our model
# (to get an idea of how categorical predictors work):

# treatment coding is the default in R, see:
options()$contrasts

# treatment coding (the default):
m01a <- lm(lexdec_centered ~ AgeSubject, data = d)
m01b <- lm(lexdec_centered ~ AgeSubjectTreatmentCoding, data = d)
summary(m01a)
summary(m01b)

# sum coding:
# create a copy of the column with sum coding
d$AgeSubject02 <- d$AgeSubject
contrasts(d$AgeSubject02) <- -contr.sum(2) # we negativize
                                      # the contrasts to make
                                      # sure that "young" is -1,
                                      # for comparability
m01c <- lm(lexdec_centered ~ AgeSubject02, 
           data = d)  # using "1" after predictor name is a 
                      # convention for sum-coded predictors
m01d <- lm(lexdec_centered ~ AgeSubjectSumCoding, data = d)


# take a look at the different slopes:
plot(seq(0, 1, length.out = 10), 
     seq(-0.6, 0.6, length.out = 10), type = "n")
abline(coef(m01a)[1],
       coef(m01a)[2])

plot(seq(-1, 1, length.out = 10), 
     seq(-0.6, 0.6, length.out = 10), type = "n")
abline(coef(m01d)[1],
       coef(m01d)[2])

# plot with effects package:
plot(allEffects(m01a))
plot(allEffects(m01b))
plot(allEffects(m01c))
plot(allEffects(m01d))

# which values do the treatment-coded and
# sum-coded models predict for young and old
# individuals, respectively?

coef(m01c)[1]+coef(m01c)[2]*(-1) # young
coef(m01c)[1]+coef(m01c)[2]*(+1) # old

# compare model with treatment contrasts:
coef(m01a)[1] # base level: young
coef(m01a)[1] + coef(m01a)[2] # old



# more than two levels?
contr.treatment(3)
contr.sum(3)


