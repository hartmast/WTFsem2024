# Prüfungsergebnisse:
a_bestanden <- 25
b_bestanden <- 17
a_durchgefallen <- 5
b_durchgefallen <- 13

# Matrix:
pruefung_df <- c(a_bestanden, b_bestanden, 
  a_durchgefallen, b_durchgefallen)

pruefung_matrix <- matrix(pruefung_df, nrow = 2)

# Chi-Quadrat-Test:
chisq.test(pruefung_matrix, correct = T)
