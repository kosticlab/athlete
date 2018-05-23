library(ade4)
all <- read.csv("/Users/jacobluber/Desktop/athlete_metadata/veill/v_genomics.csv", header = TRUE, sep=",")
#all <- all[, which(as.numeric(colSums(all != 0)) > 10)] 
#all <- all[which(as.numeric(rowSums(all != 0)) > 10), ] 

all <- filter(filter(all,complete.cases(Exercise_state)), Exercise_state != "Middle")
all$SampleID <- NULL
all$ExtractionWell <- NULL
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
lasso <- train(x=tt,y=all$Exercise_state.After, method = "glmnet", trControl = fitControl, metric = "F", family = "binomial")
glmnet.features <- predict.glmnet(lasso$finalModel, type='nonzero', s=lasso$bestTune$lambda)
glmnet.features.1 <- predict.glmnet(lasso$finalModel, type='nonzero', s=0.01)
before <- filter(all,Exercise_state.Before==1)
after <- filter(all,Exercise_state.Before==0)
results <- NULL
important_cols <- colnames(all)[glmnet.features$X1]
for (i in 1:length(important_cols)){
  results[i] <- wilcox.test(x=after[[important_cols[i]]],y=before[[important_cols[i]]])$p.value
}
joined_stats_tests <- data_frame(important_cols,results)
important_results <- filter(joined_stats_tests,results < 0.05)

#PBAAKNOD_01129
before_non <- filter(before,Athlete_gradient.Everyday==1)
before_ath <- filter(before,Athlete_gradient.Elite==1)
after_non <- filter(after,Athlete_gradient.Everyday==1)
after_ath <- filter(after,Athlete_gradient.Elite==1)

wilcox.test(x=before_non$PBAAKNOD_01129,y=after_non$PBAAKNOD_01129)
wilcox.test(x=before_ath$PBAAKNOD_01129,y=after_ath$PBAAKNOD_01129)
wilcox.test(x=before_non$PBAAKNOD_01129,y=before_ath$PBAAKNOD_01129)
wilcox.test(x=after_non$PBAAKNOD_01129,y=after_ath$PBAAKNOD_01129)


results <- NULL
important_cols <- colnames(all)[5:505]
for (i in 1:length(important_cols)){
  results[i] <- wilcox.test(x=after[[important_cols[i]]],y=before[[important_cols[i]]])$p.value
}
res1 <- data.frame(important_cols,results)
res2 <- filter(res1,results < 0.05)
write.csv(res2,file = "vgenomics.csv")

