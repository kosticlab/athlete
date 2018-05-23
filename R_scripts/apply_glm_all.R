library(ade4)
all <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/merged_data/all.csv", header = TRUE, sep=",")
all <- filter(filter(all,complete.cases(Exercise_state)), Exercise_state != "Middle")
all$Exercise_state <- factor(all$Exercise_state)
factor_cols <- all[,sapply(all,is.factor)]
factor_cols$GENE <- NULL
sample_id = all$GENE
for (f in colnames(factor_cols)){
  all_dummy = acm.disjonctif(all[f])
  all[f] = NULL
  all = cbind(all,all_dummy)
}


col_idx <- grep("Exercise_state.Before", names(all))
all <- all[, c(col_idx, (1:ncol(all))[-col_idx])]
col_idx <- grep("Exercise_state.After", names(all))
all <- all[, c(col_idx, (1:ncol(all))[-col_idx])]
all <- all[ , apply(all, 2, function(x) !any(is.na(x)))]
levels(all$Exercise_state.After) <- make.names(levels(factor(all$Exercise_state.After)))
all$Exercise_state.After <- as.factor(all$Exercise_state.After)
all$Exercise_state.After <- ifelse(all$Exercise_state.After==0,"X0","X1")
all <- all[ , colSums(is.na(all)) == 0]




library(caret)
fitControl <- trainControl(summaryFunction=twoClassSummary,method= "repeatedcv",repeats=10, number = 10, classProbs=T)
tuneGrid = expand.grid(.alpha=1,.lambda=seq(0,100,by=0.1))
tt <- all[,5:ncol(all)]
write.csv(tt, file="test.csv")
lasso <- train(x=tt,y=all$Exercise_state.After, method = "glmnet", trControl = fitControl, metric = "F", family = "binomial")
colnamglmnet.features <- predict.glmnet(lasso$finalModel, type='nonzero', s=lasso$bestTune$lambda)
glmnet.features.1 <- predict.glmnet(lasso$finalModel, type='nonzero', s=0.01)
colnames(all)[glmnet.features$X1]
library(ROCR)
pred <- prediction(glmnet.features,all$Athlete_gradientElite)
