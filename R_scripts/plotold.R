library(pheatmap)
library(RColorBrewer)
library(viridis)

quantile_breaks <- function(xs, n = 10) {
  breaks <- quantile(xs, probs = seq(0, 1, length.out = n))
  breaks[!duplicated(breaks)]
}
matdf <- read.csv(file=paste(paste("/Users/jacobluber/Desktop/athlete/",commandArgs(trailingOnly = TRUE),sep=""),"_ra.csv",sep=""),header=TRUE,row.names=1)
png(paste(paste("/Users/jacobluber/Desktop/athlete/",commandArgs(trailingOnly = TRUE),sep=""),".png",sep="")) 
matdf$S52_ru2 <- NULL
matdf$S53_ru2 <- NULL
matdf$S54_ru2 <- NULL
matdf$S55_ru2 <- NULL
matdf$S56_ru2 <- NULL
matdf$S57_ru2 <- NULL
matdf$S58_ru2 <- NULL
matdf$S59_ru2 <- NULL
matdf$S60_ru2 <- NULL
matdf$S75_ru2 <- NULL
matdf$S78_ru2 <- NULL
matdf$S7_ru2 <- NULL
mat <- as.matrix(matdf)
mat_breaks <- quantile_breaks(mat, n = 11)
exercise_state <- c("Before","After","After","After","After","Before","Before","Before","Before","Before","After","After","After","After","Before","Before","After","Before","After","After","Before","After","Before","After","After","Before","Before","Before","Before","Before","Before","After","After","After","Before","Before","Before","Before","After","After","After","After","Before","Before","After","Before","Before","Before","Before","After","After","Before","After","After","Before","Before","After","After","After","Before","Before","After","After","After","After","After","After","After","After","Before","Before","Before","After","After","Before","Before")
individual <- c("SG40","SG40","SG40","SG40","SG40","SG48","SG48","SG48","SG48","SG48","SG48","SG48","SG48","SG48","SG49","SG49","SG49","SG49","SG49","SG49","SG49","SG49","SG49","SG49","SG49","SG50","SG50","SG50","SG50","SG50","SG50","SG50","SG50","SG50","SG51","SG51","SG51","SG51","SG51","SG51","SG51","SG51","SG41","SG41","SG41","SG41","SG41","SG42","SG42","SG42","SG42","SG42","SG42","SG42","SG43","SG43","SG43","SG43","SG43","SG45","SG45","SG45","SG45","SG45","SG45","SG45","SG45","SG45","SG45","SG46","SG46","SG46","SG46","SG46","SG46","SG46")
type <- c("UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon"    ,"UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","UltraMarathon","Marathon","Marathon","Marathon","Marathon","Marathon","Marathon","Marathon","Marathon","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower","Rower")
gradient <- c("Elite","Elite","Elite","Elite","Elite","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite"    ,"Elite","Elite","Elite","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday" ,"Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Everyday","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite","Elite")
#annotation_row = data.frame( ExerciseState = exercise_state, Individual = individual, Sport = type, AthleteGradient = gradient)
exercise_state <- factor(exercise_state, levels = c("Before", "After"))
annotation_row = data.frame( ExerciseState = exercise_state, Individual = individual)
#annotation_row = data.frame( ExerciseState = exercise_state)
rownames(annotation_row) = colnames(mat)

mat_colors <- list(group = brewer.pal(9, "Set1"))
#names(mat_colors$group) <- unique(col_groups)
mat <- mat[ , order(individual,exercise_state)]

pheatmap(
  mat               = mat,
  color             = inferno(length(mat_breaks) - 1),
  breaks            = mat_breaks,
  border_color      = NA,
  show_colnames     = FALSE,
  show_rownames     = FALSE,
  annotation_col    = annotation_row,
  annotation_colors = mat_colors,
  drop_levels       = TRUE,
  fontsize          = 10,
  cluster_cols      = FALSE,
  main              = commandArgs(trailingOnly = TRUE)
)
dev.off()

#pheatmap(mtxm,annotation_col = mat_col,breaks = mat_breaks, color = inferno(length(mat_breaks)-1), annotation_colors = mat_colors, drop_levels = TRUE)
