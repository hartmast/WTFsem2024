# Bitte ergänzen Sie den folgenden Code so, 
# dass “<50” in der Konsole erscheint, wenn 
# i kleiner als 50 ist, und “>=50”, 
# wenn die Zahl größer als 50 ist.

# Übung 1

for(i in 1:100) {

  if(i < 50) {
    print("< 50")
  } else {
    print(">= 50")
  }

  # # generate output
  # print("<=100")

}



# Übung 2

zahlen <- c(2,3,4)
saetze <- c("Die Anzahl meiner Cousinen beträgt ",
            "Die Zahl meiner Tanten ist ",
            "Die Anzahl der Himmelsrichtungen beträgt ")

for(i in 1:length(zahlen)) {
  
 print(paste0(saetze[i], zahlen[i])) 
  
}

paste0(saetze, zahlen)
paste0("Das ist", " ", "ein Beispiel")

# Übung 3
d <- read.csv("https://raw.githubusercontent.com/hartmast/WTFsem2024/refs/heads/main/data/dwds_export_2024-10-16_09_26_38.csv")
d_computer_links <- d[grep(pattern = "Computer", 
                           x = d$ContextBefore),]
d_computer_rechts <- d[grep(pattern = "Computer", 
                           x = d$ContextAfter),]


# Übung 4

# entweder:
d_vorprogrammiert1 <- d[d$Hit=="vorprogrammiert",]

# oder:
d_vorprogrammiert2 <- subset(d, Hit == "vorprogrammiert")

# überprüfen, ob die Ergebnisse gleich sind:
all(d_vorprogrammiert1 == d_vorprogrammiert2)

# Übung 5

beispiel <- "Gestern war Voldemort bei D6 zu Besuch."

gsub(pattern =  "Voldemort", 
     replacement = "der, dessen Name nicht genannt werden darf,", 
     x = beispiel)


# Übung 6
chains <- read.delim("data/all_chains.csv", sep = "\t",
                     quote="")
factor(chains$condition)
unique(chains$condition)


# Übung 7
chains_control <- subset(chains, condition == "control")
chains_distractor <- subset(chains, condition == "distractor")
