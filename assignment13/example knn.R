---
  title: "kNN for Breast Cancer Screening"
output: html_notebook
---
  
  This notebook demonstrates how to use kNN to classify breast cancer biopsy tissue as either malignant or benign.

Dataset: Mangasarian, O., Street, W., Wolberg, W. (1995). Breast cancer diagnosis and prognosis via linear programming. Operations Research. (43), 570-577.

Available from: http://archive.ics.uci.edu/ml

```{r}
#install.packages("class")
install.packages("gmodels")
library(class)
library(gmodels)
```
Import the data and explore features. Always exclude ID.
```{r}
wbcd <- read.csv("c:/temp/wisc_bc_data.csv", stringsAsFactors = FALSE)
str(wbcd)
wbcd <- wbcd[-1]
```
Explore the response variable "diagnosis" coded as M or B
```{r}
table(wbcd$diagnosis)
```
Recode the diagnosis variable as a factor which if often required by many machine learning packages
```{r}
wbcd$diagnosis <- factor(wbcd$diagnosis, levels = c("B","M"), labels = c("Benign","Malignant"))
round(prop.table(table(wbcd$diagnosis)) * 100, digits = 1)
```
```{r}
summary(wbcd[c("radius_mean","area_mean","smoothness_mean")])
```
Transform data - normalize numeric data with differing scales
```{r}
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}
```
Normalize all 30 numeric variables using lapply() rather than a loop
```{r}
wbcd_n <- as.data.frame(lapply(wbcd[2:31], normalize))
summary(wbcd_n)
```
Create training vs validation data sets to avoid overfitting; the following only works because the cases in the full data set are random; if they weren't then one would need to take a random or a stratified random sample
```{r}
wbcd_train <- wbcd_n[1:469, ]
wbcd_test <- wbcd_n[470:569, ]
```
Create vector of the target/response variable -- many kNN implementation require separate response variable vectors
```{r}
wbcd_train_labels <- wbcd[1:469, 1]
wbcd_test_labels <- wbcd[470:569, 1]
```
Train the model on the data; the knn() function returns a factor vector of predicted labels for the cases in the test data set based on comparing them via Euclidean distance to the cases in the train data set
```{r}
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)
```
Evaluate the model by matching predicted values to known values
```{r}
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)
```
z-score standardization may often yield better distance results than min-max normalization
```{r}
wbcd_z <- as.data.frame(scale(wbcd[-1]))
summary(wbcd_z)
```
```{r}
wbcd_train <- wbcd_z[1:469, ]
wbcd_test <- wbcd_z[470:569, ]
wbcd_test_pred <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 21)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred, prop.chisq = FALSE)
```
Testing alternative values of k
```{r}
wbcd_test_pred_5 <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 5)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred_5, prop.chisq = FALSE)

wbcd_test_pred_11 <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 11)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred_11, prop.chisq = FALSE)

wbcd_test_pred_15 <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 15)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred_15, prop.chisq = FALSE)

wbcd_test_pred_27 <- knn(train = wbcd_train, test = wbcd_test, cl = wbcd_train_labels, k = 27)
CrossTable(x = wbcd_test_labels, y = wbcd_test_pred_27, prop.chisq = FALSE)
```
