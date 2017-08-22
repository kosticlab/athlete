abundances <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/working/ru2_genes.csv", header = TRUE, sep=",")
metadata <- read.table("/Users/jacobluber/Desktop/athlete_metadata/working/ru2_metadata.txt", header = TRUE, sep='\t')
metadata <- metadata[, sapply(metadata, nlevels) > 1]
options(na.action='na.pass')
join_loc <- metadata$SampleID
metadata <- as.data.frame(model.matrix(~ . + 0,data=metadata[,3:ncol(metadata)], contrasts.arg = lapply(metadata,contrasts, contrasts=FALSE)))
metadata$Filename=join_loc
all <- merge(abundances,metadata,by.x="GENE",by.y="Filename",all=FALSE)
col_idx <- grep("Exercise_stateBefore", names(all))
all <- all[, c(col_idx, (1:ncol(all))[-col_idx])]
col_idx <- grep("Exercise_stateAfter", names(all))
all <- all[, c(col_idx, (1:ncol(all))[-col_idx])]
all <- all[ , apply(all, 2, function(x) !any(is.na(x)))]
levels(all$Exercise_stateAfter) <- make.names(levels(factor(all$Exercise_stateAfter)))
all$Exercise_stateAfter <- as.factor(all$Exercise_stateAfter)
all$Exercise_stateAfter <- ifelse(all$Exercise_stateAfter==0,"X0","X1")

library(caret)
fitControl <- trainControl(summaryFunction=twoClassSummary,method= "repeatedcv",repeats=10, number = 10, classProbs=T)
tuneGrid = expand.grid(.alpha=1,.lambda=seq(0,100,by=0.1))
tt <- all[,4:ncol(all)]
lasso <- train(x=tt,y=all$Exercise_stateAfter, method = "glmnet", trControl = fitControl, metric = "F", family = "binomial")
glmnet.features <- predict.glmnet(lasso$finalModel, type='nonzero', s=lasso$bestTune$lambda)
glmnet.features.1 <- predict.glmnet(lasso$finalModel, type='nonzero', s=0.01)
colnames(all)[glmnet.features$X1]
library(ROCR)
pred <- prediction(glmnet.features,all$Athlete_gradientElite)
