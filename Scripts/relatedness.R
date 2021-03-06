################################################### Script for Relatedness  #######################################################

#Created for transcriptome project
#Generates relatedness estimates w/relatedness r package (calls coancestry fortran program)

#################################################################################################################################################
######## Set-up ########

#set working directory
setwd("C:/Users/Rene/Dropbox/Pinsky_Lab/Transcriptome_Proj/R_scripts/A_clarkii_transcriptomics/")
getwd()

remove(list = ls())

#load libraries
library(tidyverse)
library(related)
library(boot)

#read in data
#relatedness.txt file created by making genepop file with PGDSpider, pulling only genotype information, pasting all columns together, then separating by # characters (3) in excel
rel_info <- readgenotypedata("Data/relatedness_input_mac2.txt") #read in data formatted for relatedness r package

#################################################################################################################################################

######## Calculate point estimates of relatedness w/95% CIs ########

rel_output <- coancestry("Data/relatedness_input_mac2.txt", lynchli = 2, lynchrd = 2, quellergt = 2, ritland = 2, wang = 2, 
                         ci95.num.bootstrap = 1000) #calculates point estimate & 95% CI for each pairwise relatedness

#pull data
relatedness <- rel_output$relatedness
inbreeding <- rel_output$inbreeding
ci95 <- rel_output$relatedness.ci95

#subset w/in pops
rel_J <- subset(relatedness, grepl("^JJ_", ind1.id) & grepl("^JJ_", ind2.id))
rel_P <- subset(relatedness, grepl("^PP_", ind1.id) & grepl("^PP_", ind2.id))
rel_I <- subset(relatedness, grepl("^NN_", ind1.id) & grepl("^NN_", ind2.id))

rel_inpop_df <- rbind(rel_J, rel_P, rel_I)

#################################################################################################################################################

######## Create null distributions of pairwise relatedness ########

#use wang estimator bc those seem to be least biased w/small sample sizes (Wang 2017) --> although if unmodified, may slightly underestimate relatedness
grouprel(genotypes = rel_info$gdata, estimatorname = "wang", usedgroups = "all", iterations = 100) #calculate null distribution of pariwise relatedness w/in pops

######## Calculate mean pairwise relatedness w/in pop ########

#calculate mean pairwise relatedness w/in pops
J_rel_means <- colMeans(rel_J[, 6:10])
P_rel_means <- colMeans(rel_P[, 6:10])
I_rel_means <- colMeans(rel_I[, 6:10])

rel_mean_df <- data.frame(J_rel_means, P_rel_means, I_rel_means)

######## Bootstrap for 95% CIs ########

#mean function for bootstrapping
samp_mean <- function(x, i) {
  mean(x[i])
} #bc if use mean() in boot() throws trim error

#bootstrap for wang estimator
#J pop
boot_J_wang <- boot(data = rel_J$wang, statistic = samp_mean, R = 1000) #1000 permutations of wang mean pairwise relatedness
plot(boot_J_wang) #plot histogram sample distribution
J_95ci_wang <- boot.ci(boot_J_wang, conf = 0.95, type = "all") #get 95% CI for wang pairwise relatedness

#P pop
boot_P_wang <- boot(data = rel_P$wang, statistic = samp_mean, R = 1000)
plot(boot_P_wang)
P_95ci_wang <- boot.ci(boot_P_wang, conf = 0.95, type = "all")

#I pop
boot_I_wang <- boot(data = rel_I$wang, statistic = samp_mean, R = 1000)
plot(boot_I_wang)
I_95ci_wang <- boot.ci(boot_I_wang, conf = 0.95, type = "all")

######## Create summary tables ########

#dataframe for wang estimator w/sample mean, and 95% CI
t_rel_mean_df <- data.frame(t(rel_mean_df)) #transpose mean df
wang_mean_rel <- t_rel_mean_df[, 1] #pull out wang mean relatedness
estimator_vector <- c("wang", "wang", "wang") #create column with estimator name
wang_mean_rel <- data.frame(wang_mean_rel, estimator_vector) #combine means & estimator vector
  colnames(wang_mean_rel) <- c("mean", "estimator")
  rownames(wang_mean_rel) <- c("Japan", "Philippines", "Indonesia")

I_95ci_wang_normal <- I_95ci_wang$normal #pull out normal distribution  2.5 & 97.5 percentiles for wang ci
J_95ci_wang_normal <- J_95ci_wang$normal
P_95ci_wang_normal <- P_95ci_wang$normal

wang_norm_ci <- rbind(J_95ci_wang_normal, P_95ci_wang_normal, I_95ci_wang_normal) #combine df w/ci info for each pop into one dataframe
  colnames(wang_norm_ci) <- c("ci", "2.5_per", "97.5_per")
  rownames(wang_norm_ci) <- c("Japan", "Philippines", "Indonesia")

#merge dataframes
mean_rel <- cbind(wang_mean_rel, wang_norm_ci) #combine wang ci info and sample mean info into one dataframe
pop_vector <- c("Japan", "Philippines", "Indonesia")
mean_rel <- cbind(mean_rel, pop_vector)
  colnames(mean_rel) <- c("mean", "estimator", "CI", "2.5_per", "97.5_per", "Pop")
mean_rel$diff_lower <- mean_rel$mean - mean_rel$`2.5_per` #calculate diff btwn sample mean and 2.5 percentile for CI visualization
mean_rel$diff_upper <- mean_rel$`97.5_per` - mean_rel$mean # calculate diff btwn sample mean and 97.5 percentile for CI visualization

#write out
write.csv(mean_rel, "Data/wang_relatedness_cis.csv")
write.csv(rel_inpop_df, "Data/all_relatedness_raw_mac2.csv")

#################################################################################################################################################

######## Visualize data ########
#designed to be run separately from earlier sections

remove(list = ls())

#read in data
rel_inpop_df <- read.csv("Data/all_relatedness_raw_mac2.csv", header = TRUE, row.names = 1)
mean_rel <- read.csv("Data/wang_relatedness_cis.csv", header = TRUE, row.names = 1)

######## Scatterplots ########

#ordering x-axis
rel_inpop_df$Pop <- c(rep("Japan", times = 28), rep("Philippines", times = 45), rep("Indonesia", times = 21)) #add row to make factor
  rel_inpop_df$Pop <- factor(rel_inpop_df$Pop, levels = c("Japan", "Philippines", "Indonesia"))
mean_rel$Pop <- factor(mean_rel$Pop, levels = c("Japan", "Philippines", "Indonesia"))

#annotated scatter plot of data
wang_rel_plot <- ggplot(data = rel_inpop_df, aes(x = Pop, y = wang)) + geom_point() + 
  annotate("text", x = 2, y = 0.52, label = "J mean r = 0.2222") + 
  annotate("text", x = 2, y = 0.48, label = "P mean r = -0.0108") + 
  annotate("text", x = 2, y = 0.44, label = "N mean r = 0.0181")
wang_rel_plot

#plot of mean w/in pop pairwise relatedness w/95% CI error bars
mean_rel_plot_wang <- ggplot(data = mean_rel[which(mean_rel$estimator == "wang"), ], aes(x = Pop, y = mean)) + 
  geom_point(aes(size = 1), show.legend = FALSE) + 
  geom_errorbar(aes(ymin = mean - diff_lower, ymax = mean + diff_upper, width = 0.5, size = 0.5), show.legend = FALSE) + 
  ggtitle("Mean pairwise relatedness (Wang) w/95% CI") + theme_bw() + 
  theme(panel.border = element_rect(size = 1), axis.title = element_text(size = 14, face = "bold"), 
           axis.ticks = element_line(color = "black", size = 1), axis.text = element_text(size = 12, color = "black"))
mean_rel_plot_wang
