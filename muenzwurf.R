
set.seed(2011)
muenzwuerfe <- sample(c("Kopf", "Zahl"), 10000, replace = TRUE)
table(muenzwuerfe)

wirf_muenze <- function(n) {
  x <- sample(c("Kopf", "Zahl"), n, replace = TRUE)
  barplot(table(x), ylim = c(0, n))
}


for(i in 1:10) {
  wirf_muenze(1e6)
  Sys.sleep(1)
}
  