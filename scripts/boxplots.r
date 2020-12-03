# Make the dataframe with the results and the make boxplots

# data 
data <- data.frame("Total" = c(79,79,97), "EU" = c(38,38,48), "Asia" = c(2,2,4), "NCA" = c(12,12,11), "Oceania" = c(4,4,4), 
                   "SA" = c(14,14,18), "Africa"=c(2,2,5), "ME"=c(7,7,7))
boxplot(data$Total, main="Average Introductions From NYC Globally", ylab="Number of Introductions", xlab="Average Introductions", col="green", horizontal = TRUE)

par(mfrow=c(3,3))
boxplot(data$EU, main="Introductions From NYC to Europe", ylab="Number of Introductions", xlab="Europe", col="light blue", horizontal = TRUE)
boxplot(data$Asia, main="Introductions From NYC to Asia", xlab="Asia", col="purple", horizontal = TRUE)
boxplot(data$NCA, main="Introductions From NYC to North and Central America", xlab="North and Central America", col="red", horizontal = TRUE)
boxplot(data$SA, main="Introductions From NYC to South America", ylab="Number of Introductions", xlab="South America", col="yellow", horizontal = TRUE)
boxplot(data$Africa, main="Introductions From NYC to Africa", xlab="Africa", col="light green", horizontal = TRUE)
boxplot(data$Oceania, main="Introductions From NYC to Oceania", xlab="Ocenia", col="pink", horizontal = TRUE)
boxplot(data$ME, main="Introductions From NYC to Middle East", ylab="Number of Introductions", xlab="Middle East", col="white", horizontal = TRUE)

par(mfrow=c(1,1))
