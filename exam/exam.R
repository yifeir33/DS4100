IBD <- read.csv("IBData.csv")
# 
ibd.glm <- glm(formula = seen ~ W+C+CW,data=IBD, family = binomial)
predict(ibd.glm, )

web <- read.csv("webData.csv")

sales <- read.csv("SalesGrowth.csv")


cars

a <- lm(Web.Hits ~ Quarter, data =web)
mean(residuals.lm(a)^2)
