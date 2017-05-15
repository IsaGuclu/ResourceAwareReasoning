options( java.parameters = "-Xmx4g" )
getwd()
setwd("/Users/isa/R/")
getwd()

# Using Ms Excel data
library(XLConnect)               # load XLConnect package 
wk = loadWorkbook("EmapGoFma.xlsx") 
myData = readWorksheet(wk, sheet="fma-el")

# and attach the data
attach(myData)

# ask for a summary of the data
summary(myData)

cor(RAM_KB, AxiomCount, method="pearson")

# make a plot of RAM_KB vs. AxiomCount with COLORS according to GROUPS.
# plot(RAM_KB, AxiomCount, col=c("orange","blue","green")[Grp], main="SNOMED CT on ELK (Poly.Reg.)")

plot(myData$RAM_KB, myData$AxiomCount, xlab="RAM (KB.)", ylab="Axiom Count", main="FMA-EL on ELK (Poly.Reg.)", pch=2, cex.main=1.5, frame.plot=FALSE , col=ifelse(myData$Grp==1, "orange", (ifelse(myData$Grp==2, "blue", "green"))))

# and, let's add a legend to clarify the lines
legend(10000, 280000, pch=c(2,2), legend = c("linear model","model2: poly(degree = 2)", "model3: poly(degree = 3)"), 
       col=c("orange", "green", "red"), lty=c(1,1,1), lwd=3, bty="0",  box.col="darkgreen", cex=0.8)

# and, let's add a legend to clarify the data points
# legend(20000, 250000, pch=c(2,2), col=c("orange", "blue", "green"), c("1st scenario", "2nd scenario", "3rd scenario"), bty="o",  box.col="darkgreen", cex=.8)


# now, let's fit a linear regression
model1 <- lm(AxiomCount ~ RAM_KB)
summary(model1)
# and add the line to the plot...make it thick and red...
abline(model1, lwd=3, col="orange")

AxiomCount_Predicted <- predict(model1, myData)
AxiomCount_Difference <- AxiomCount_Predicted - myData$AxiomCount
myRMSE <- sqrt(mean(AxiomCount_Difference^2))
myRMSE
myMAE <- mean(abs(AxiomCount_Difference))
myMAE
n = nrow(myData)
n
myMAPE <- 100/n * sum(abs(AxiomCount_Difference/myData$AxiomCount))
myMAPE


# now, the poly^2
# model2 <- lm(RAM_KB ~ AxiomCount + I(AxiomCount ^2))
model2 <- lm(AxiomCount ~ poly(RAM_KB, degree=2, raw=T))
summary(model2)
# now, let's add this model to the plot, using a thick green line
lines(smooth.spline(RAM_KB, predict(model2)), col="green", lwd=3)

AxiomCount_Predicted <- predict(model2, myData)
AxiomCount_Difference <- AxiomCount_Predicted - myData$AxiomCount
myRMSE <- sqrt(mean(AxiomCount_Difference^2))
myRMSE
myMAE <- mean(abs(AxiomCount_Difference))
myMAE

n = nrow(myData)
n
myMAPE <- 100/n * sum(abs(AxiomCount_Difference/myData$AxiomCount))
myMAPE

# test if the model including AxiomCount^2 i signif. better than one without
# using the partial F-test
anova(model1, model2)

# try fitting a model that includes AxiomCount ^3 as well
model3 <- lm(AxiomCount ~ poly(RAM_KB, degree=3, raw=T))
summary(model3)
# now, let's add this model to the plot, using a thick red line
lines(smooth.spline(RAM_KB, predict(model3)), col="red", lwd=3)

AxiomCount_Predicted <- predict(model3, myData)
AxiomCount_Difference <- AxiomCount_Predicted - myData$AxiomCount
myRMSE <- sqrt(mean(AxiomCount_Difference^2))
myRMSE
myMAE <- mean(abs(AxiomCount_Difference))
myMAE

n = nrow(myData)
n
myMAPE <- 100/n * sum(abs(AxiomCount_Difference/myData$AxiomCount))
myMAPE

# let's test if the model with AxiomCount^3 is signif better than one without
anova(model2, model3)


# try fitting a model that includes AxiomCount^4 as well
model4 <- lm(AxiomCount ~ poly(RAM_KB, degree=4, raw=T))
summary(model4)
# now, let's add this model to the plot, using a thick blue line
# lines(smooth.spline(RAM_KB, predict(model4)), col="blue", lwd=3)

AxiomCount_Predicted <- predict(model4, myData)
AxiomCount_Difference <- AxiomCount_Predicted - myData$AxiomCount
myRMSE <- sqrt(mean(AxiomCount_Difference^2))
myRMSE
myMAE <- mean(abs(AxiomCount_Difference))
myMAE

n = nrow(myData)
n
myMAPE <- 100/n * sum(abs(AxiomCount_Difference/myData$AxiomCount))
myMAPE

# let's test if the model with AxiomCount^4 is signif better than one without
anova(model3, model4)