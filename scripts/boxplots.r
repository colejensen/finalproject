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


# make a single boxplot with all the information 
# No facet
library(ggplot2)
ggplot(data=data, aes(x='Where Introductions Occured', y='Number of Introdiuctions')) + geom_boxplot()


data <- data.frame("Total" = c(79,79,97), "EU" = c(38,38,48), "Asia" = c(2,2,4), "NCA" = c(12,12,11), "Oceania" = c(4,4,4), 
                   "SA" = c(14,14,18), "Africa"=c(2,2,5), "ME"=c(7,7,7))
test <- data.frame("Values"= c(38,38,48,2,2,4,12,12,11,4,4,4,14,14,18,2,2,5,7,7,7), "Location" = 
                     c("Europe","Europe","Europe","Asia","Asia","Asia","N.C.A.", "N.C.A.","N.C.A.",
                       "Oceania","Oceania","Oceania","S.A.","S.A.","S.A.","Africa","Africa","Africa","Middle East","Middle East","Middle East"))

boxplot(Values~Location, data=test, main="Introductions from New York", xlab="Location", ylab="Number of Introductions", col="steelblue", border="black")
boxplot(data$Total, main="Total Number of Introductions from New York", ylab="Number of Introductions", col="steelblue", border="black")
