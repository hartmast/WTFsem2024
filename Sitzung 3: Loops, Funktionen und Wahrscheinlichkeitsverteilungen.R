install.packages("lme4")
require(devtools)
library(tidyverse)
library(lme4)

install_github("hartmast/concordances")
install_github("skeptikantin/collostructions")
library(concordances)

concordances::last_left("Lorem ipsum dolor sit amet", n = 2)


# Loops ------------

my_vector <- c(23,24,28,30,25,60,50,23,20,24,23)

for(i in my_vector) {
  x <- i * 10
  print(x)
}


for(item in 1:length(my_vector)) {
  x <- my_vector[item] * 10
  print(x)
}


sapply(my_vector, function(i) i * 10)



# if loop -----------------------------------------------------------------

my_vector2 <- c("Petra", "Peter", "Nils", "Gabi")

for(i in my_vector2) {
  if(i != "Peter") {
    print(paste0("Hallo ", i))
  }
}

for(j in my_vector2) {
  if(j %in% c("Petra", "Nils", "Gabi")) {
    print(paste0("Hallo ", j))
  } else{
    print(paste0("F** dich ", j))
  }
}

paste0("Hallo ", my_vector2[1])






