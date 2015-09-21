#EMBRAPA.R
cerrado.evi <- read.csv(file = "/home/scidb/temporal-patterns/cerrado.evi.csv", header = FALSE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
cotton.evi <- read.csv(file = "/home/scidb/temporal-patterns/cotton.evi.csv", header = FALSE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
forest.1.evi <- read.csv(file = "/home/scidb/temporal-patterns/forest.1.evi.csv", header = FALSE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
pasture.1.evi <- read.csv(file = "/home/scidb/temporal-patterns/pasture.1.evi.csv", header = FALSE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
soybean_cotton.evi <- read.csv(file = "/home/scidb/temporal-patterns/soybean_cotton.evi.csv", header = FALSE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
soybean.evi <- read.csv(file = "/home/scidb/temporal-patterns/soybean.evi.csv", header = FALSE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
soybean_maize.evi <- read.csv(file = "/home/scidb/temporal-patterns/soybean_maize.evi.csv", header = FALSE, sep = ",", quote = "\"", dec = ".", fill = TRUE, comment.char = "")
save(
  file = "/home/scidb/EMBRAPA++.evi.RData",
  list = c(
    "cerrado.evi",
    "cotton.evi",
    "forest.1.evi",
    "pasture.1.evi",
    "soybean_cotton.evi",
    "soybean.evi",
    "soybean_maize.evi"
  )
)
