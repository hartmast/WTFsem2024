

# Vektoren
my_vector <- c(1,2,3)
my_other_vector <- c("a", "b", "c")
my_other_character_vector <- c("Peter", "Petra", "Hensel", "Gretel")

# Data frames
my_data_frame <- data.frame(Zahlen = my_vector, 
                            Buchstaben = my_other_vector)


my_other_data_frame <- data.frame(Zahlen = c(1,3,4,5),
                                  Buchstaben = c("A", "B", "C", "D"))
str(my_other_data_frame)
colnames(my_other_data_frame) <- c("numbers", "characters")
my_other_data_frame
rownames(my_other_data_frame)

# Matrizen
matrix(c(1,2,3,4,5,6), ncol = 2)

# Listen
my_list <- list(my_data_frame, my_other_character_vector)
my_list[[1]][3,2]



## DATENTYPEN ##

# character
my_character_object <- "hi"

# numeric 
my_numeric_object <- sqrt(5)

# integer
my_integer_object <- 5
my_integer_object <- as.integer(my_integer_object)
is.integer(my_integer_object)

# logical
sqrt(25) == 5
sqrt(25) == 42

# factors
my_data_frame2 <- my_data_frame
my_data_frame2$Uni <- c("HHU", "Uni Koeln", "Uni Hogwarts")
str(my_data_frame2)
my_data_frame2$Uni <- factor(my_data_frame2$Uni, 
                             levels = c("HHU", "Uni Koeln", 
                                        "Uni Hogwarts"))
str(my_data_frame2)
my_data_frame2[2,3] <- "Uni Köln"
my_data_frame2$Uni <- as.character(my_data_frame2$Uni)
my_data_frame2[2,3] <- "Uni Köln"
my_data_frame2
levels(as.factor(my_data_frame2$Uni))

my_data_frame2$Uni <- factor(my_data_frame2$Uni)
my_data_frame2$Zahlen <- factor(my_data_frame2$Zahlen)
as.numeric(my_data_frame2$Zahlen)

my_data_frame2$Uni

which(colnames(my_data_frame2)=="Uni")
which(my_data_frame2[,3] == "Uni Köln")



# Daten einlesen ----------------------

# d <- read.csv("https://www.dwds.de/r/?format=kwic&limit=5000&p=1&view=csv&output=inline&q=%40programmiert+%7C%7C+%40vorprogrammiert&corpus=dwdsxl&date-start=1897&date-end=2024&sort=date_desc&seed=")
d <- read.csv("data/dwds_export_2024-10-16_09_26_38.csv")
str(d)
table(d$Hit)

# neue Jahresspalte:
d$Year <- gsub("-.*", "", d$Date)
table(d$Year)
prop.table(table(d$Year))

