# load packages
library(tidyverse)
library(scatterplot3d)
library(effects)
library(car)


#####################
# multicollinearity #
#####################

# example from McElreath (2015)

set.seed(1990)
d <- tibble(height = rnorm(100,10,2)) # simulate height
leg_prop <- runif(100,0.4,0.5) # leg as prop. of height
d$leg_left <- leg_prop*d$height+rnorm(100,0,0.02) # left leg
d$leg_right <- leg_prop*d$height+rnorm(100,0,0.02) # right leg



# look at the data:
plot(d$leg_left, d$leg_right)
plot(d$height, d$leg_left)
plot(d$height, d$leg_right)

# length of a leg as predictor for height
m_leg1 <- lm(height ~ leg_left, data = d)
summary(m_leg1)

# Remember the interpretation of the slope:
# When the length of the left leg increases by
# one unit, height increases by 1.93


# Lengths of both legs as predictors
m_leg2 <- lm(height ~ leg_left + leg_right, data = d)
summary(m_leg2)

# This model now says that when we increase the length
# of the left leg, height increases by 1.38 - much less
# than before!

# This is because leg1 and leg2 baiscally contribute the
# same information. Note the coefficient for the right leg:
coef(m_leg2)

# The coefficients for leg_left and leg_right summed up
# are the coefficient of the one leg included in m_leg1.
coef(m_leg2)[2]+coef(m_leg2)[3]
coef(m_leg1)[2]

# note the variance inflation factors:
car::vif(m_leg2)



# Also note that the model still makes quite good predictions.

# height of someone whose left leg has 60.1 cm
# and whose right leg has 60.2 cm:
# Remember, the basic formula for a model without
# interaction is y = b0+b1x1+b2x2 ... etc.

# intercept and slopes for model without interaction:
b0_01 <- coef(m_leg1)[1]
b1_01<- coef(m_leg1)[2]

# and now the prediction:
b0_01 + b1_01 * 60.1  # 133.76 cm

# for m_leg2:
b0_02 <- coef(m_leg2)[1]
b1_02<- coef(m_leg2)[2]
b2_02<- coef(m_leg2)[3]

b0_02 + b1_02 * 60.1 + b2_02 * 60.2  # 133.83


