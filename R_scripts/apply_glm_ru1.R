abundances <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/working/ru1_genes.csv", header = TRUE, sep=",")
metadata <- read.table("/Users/jacobluber/Desktop/athlete_metadata/working/ru1_metadata.txt", header = TRUE, sep='\t')
metadata <- metadata[, sapply(metadata, nlevels) > 1]
options(na.action='na.pass')
join_loc <- metadata$Filename
metadata <- as.data.frame(model.matrix(~ . + 0,data=metadata[,3:ncol(metadata)], contrasts.arg = lapply(metadata,contrasts, contrasts=FALSE)))
metadata$Filename=join_loc
all <- merge(abundances,metadata,by.x="GENE",by.y="Filename",all=FALSE)
col_idx <- grep("Athlete_gradientElite", names(all))
all <- all[, c(col_idx, (1:ncol(all))[-col_idx])]
col_idx <- grep("Athlete_gradientEveryDay", names(all))
all <- all[, c(col_idx, (1:ncol(all))[-col_idx])]
all <- all[ , apply(all, 2, function(x) !any(is.na(x)))]
col_idx <- grep("Athlete_gradient", names(all))
all <- all[, c(col_idx, (1:ncol(all))[-col_idx])]
all <- all[ , apply(all, 2, function(x) !any(is.na(x)))]
levels(all$Athlete_gradientElite) <- make.names(levels(factor(all$Athlete_gradientElite)))
all$Athlete_gradientElite <- as.factor(all$Athlete_gradientElite)
all$Athlete_gradientElite <- ifelse(all$Athlete_gradientElite==0,"X0","X1")

library(caret)
fitControl <- trainControl(summaryFunction=twoClassSummary,method= "repeatedcv",repeats=10, number = 10, classProbs=T)
tuneGrid = expand.grid(.alpha=1,.lambda=seq(0,100,by=0.1))
lasso <- train(x=all[,4:ncol(all)],y=all$Athlete_gradientElite, method = "glmnet", trControl = fitControl, metric = "F", family = "binomial")
glmnet.features <- predict.glmnet(lasso$finalModel, type='nonzero', s=lasso$bestTune$lambda)
glmnet.features.1 <- predict.glmnet(lasso$finalModel, type='nonzero', s=0.01)
colnames(all)[glmnet.features.1$X1]
library(ROCR)
pred <- prediction(glmnet.features,all$Athlete_gradientElite)
