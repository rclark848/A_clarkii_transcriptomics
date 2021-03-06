################################################### Script for Tajima D  #######################################################

#Created for transcriptome project
#Uses Tajima's D estimates from VCFtools --> only synonymous sites incorporated into calculations (ID'd from mapping to A. frenatus)
#Includes Mann-Whitney U-test & ECDF plots to compare outlier-only transcripts and total transcript distirbutions

##########################################################################################################################################

######## Set-up ########

#set working directory
setwd("C:/Users/rclar/Dropbox/Pinsky_Lab/Transcriptome_Proj/R_scripts/A_clarkii_transcriptomics/")
getwd()

remove(list = ls())

#load libraries
library(tidyverse)
library(plotrix)

#read in data
J_TD <- read.csv("Data/SYN_mac1_JTajimasD.csv", header = TRUE) #read in data from vcftools
P_TD <- read.csv("Data/SYN_mac1_PTajimasD.csv", header =TRUE)
N_TD <- read.csv("Data/SYN_mac1_NTajimasD.csv", header = TRUE)
All_TD <- read.csv("Data/SYN_mac1_AllTajimasD.csv", header = TRUE)
outlierseq <- read.csv("Data/outlier_sequences_TD_mac1_SYN.csv", header = TRUE)

#clean data
JTD_data_clean <- J_TD[which(J_TD$TajimaD!='NA'),]
PTD_data_clean <- P_TD[which(P_TD$TajimaD!='NA'),]
NTD_data_clean <- N_TD[which(N_TD$TajimaD!='NA'),]
AllTD_data_clean <- All_TD[which(All_TD$TajimaD!='NA'),] #bc some windows with no SNPs at all

#coercing Tajima D to numeric
JTD_data_clean$TajimaD <- as.numeric(JTD_data_clean$TajimaD)
PTD_data_clean$TajimaD <- as.numeric(PTD_data_clean$TajimaD)
NTD_data_clean$TajimaD <- as.numeric(NTD_data_clean$TajimaD)
AllTD_data_clean$TajimaD <- as.numeric(AllTD_data_clean$TajimaD)

#################################################################################################################################################

######## Adding monomorphic sequences back in ########

#make sure outlierseqs are correct
AllTD_data_clean$uniqseq <- paste(AllTD_data_clean$CHROM, "-", AllTD_data_clean$BIN_START) #create uniq column to compare dfs by
AllTD_data_clean$Pop <- c(rep("All", times = 498))
AllTD_data_clean$NUM <- c(1:498)
setdiff(outlierseq$CONTIG, AllTD_data_clean$uniqseq) #should = 0, as all should be present in All_TD

######## J pop calculations ########

#number of monomorphic sequences not included
nrow(AllTD_data_clean) - nrow(JTD_data_clean) #124 --> need to add this many instances of 0 into dataframe

#create uniq column to compare dfs by
JTD_data_clean$uniqseq <- paste(JTD_data_clean$CHROM, "-", JTD_data_clean$BIN_START)

#create dataframe of sequences to add back
contigs_needed_J <- as.data.frame(setdiff(AllTD_data_clean$uniqseq, JTD_data_clean$uniqseq))
  colnames(contigs_needed_J) <- c("uniqseq")

contigs_needed_J <- separate(contigs_needed_J, uniqseq, c("CHROM", "BIN_START"), sep = "-", remove = FALSE) #separate uniqseq out to original columns
contigs_needed_J$N_SNPS <- c(rep(0, times = 124)) #add N_SNPS column
contigs_needed_J$TajimaD <- c(rep("NA", times = 124)) #add TajimaD column

#create full Tajima D df
JTD_nonum <- JTD_data_clean[, 2:6]
full_JTD <- rbind(JTD_nonum, contigs_needed_J)
full_JTD <- full_JTD[order(full_JTD$uniqseq), ] #reorder by contig
  nrow(full_JTD) #check equals 498 (# total sequences)
full_JTD$Pop <- c(rep("Japan", times = 498))
full_JTD$NUM <- c(1:498)

#pull outlier seq & stats for J pop
J_outlierseq <- full_JTD[full_JTD$uniqseq %in% outlierseq$CONTIG, ]
J_outlierseq <- J_outlierseq[, 1:6]
J_outlierseq$NUM <- c(1:24) #re-numbering for plotting
  J_outlierseq$TajimaD <- as.numeric(J_outlierseq$TajimaD)

######## P pop calculations ########

#number of monomorphic sequences not included
nrow(AllTD_data_clean) - nrow(PTD_data_clean) #65 --> need to add this many instances of 0 into dataframe

#create uniq column to compare dfs by
PTD_data_clean$uniqseq <- paste(PTD_data_clean$CHROM, "-", PTD_data_clean$BIN_START)

#create dataframe of sequences to add back
contigs_needed_P <- as.data.frame(setdiff(AllTD_data_clean$uniqseq, PTD_data_clean$uniqseq))
  colnames(contigs_needed_P) <- c("uniqseq")

contigs_needed_P <- separate(contigs_needed_P, uniqseq, c("CHROM", "BIN_START"), sep = "-", remove = FALSE)
contigs_needed_P$N_SNPS <- c(rep(0, times = 65))
contigs_needed_P$TajimaD <- c(rep("NA", times = 65))

#create full Tajima D df
PTD_nonum <- PTD_data_clean[, 2:6]
full_PTD <- rbind(PTD_nonum, contigs_needed_P)
full_PTD <- full_PTD[order(full_PTD$uniqseq), ]
  nrow(full_PTD) #check equals 498 (# total sequences)
full_PTD$Pop <- c(rep("Philippines", times = 498))
full_PTD$NUM <- c(1:498)

#pull outlier seq & stats for P pop
P_outlierseq <- full_PTD[full_PTD$uniqseq %in% outlierseq$CONTIG, ]
P_outlierseq <- P_outlierseq[, 1:6]
P_outlierseq$NUM <- c(1:24)
  P_outlierseq$TajimaD <- as.numeric(P_outlierseq$TajimaD)

######## N pop calculations ########

#number of monomorphic sequences not included
nrow(AllTD_data_clean) - nrow(NTD_data_clean) #126 --> need to add this many instances of 0 into dataframe

#create uniq column to compare dfs by
NTD_data_clean$uniqseq <- paste(NTD_data_clean$CHROM, "-", NTD_data_clean$BIN_START)

#create dataframe of sequences to add back
contigs_needed_N <- as.data.frame(setdiff(AllTD_data_clean$uniqseq, NTD_data_clean$uniqseq))
  colnames(contigs_needed_N) <- c("uniqseq")

contigs_needed_N <- separate(contigs_needed_N, uniqseq, c("CHROM", "BIN_START"), sep = "-", remove = FALSE)
contigs_needed_N$N_SNPS <- c(rep(0, times = 126))
contigs_needed_N$TajimaD <- c(rep("NA", times = 126))

#create full Tajima D df
NTD_nonum <- NTD_data_clean[, 2:6]
full_NTD <- rbind(NTD_nonum, contigs_needed_N)
full_NTD <- full_NTD[order(full_NTD$uniqseq), ]
  nrow(full_NTD) #check equals 498 (# total sequences)
full_NTD$Pop <- c(rep("Indonesia", times = 498))
full_NTD$NUM <- c(1:498)

#pull outlier seq & stats for N pop
N_outlierseq <- full_NTD[full_NTD$uniqseq %in% outlierseq$CONTIG, ]
N_outlierseq <- N_outlierseq[, 1:6]
N_outlierseq$NUM <- c(1:24)
  N_outlierseq$TajimaD <- as.numeric(N_outlierseq$TajimaD)

######## Combine pop data ########

#pull outlier seq & stats for pops combined
all_outlierseq <- AllTD_data_clean[AllTD_data_clean$uniqseq %in% outlierseq$CONTIG, ]
all_outlierseq <- all_outlierseq[order(all_outlierseq$uniqseq), ] #reorder by contig
all_outlierseq <- all_outlierseq[, 2:7]
all_outlierseq$NUM <- c(1:24)
  all_outlierseq$TajimaD <- as.numeric(all_outlierseq$TajimaD)

#combine TD for all seqs
AllTD_data_clean <- AllTD_data_clean[order(AllTD_data_clean$uniqseq), ] #reorder by contig
TD_only_all <- rbind(full_JTD, full_PTD, full_NTD, AllTD_data_clean)
  lapply(TD_only_all, class) #check character class for columns
  TD_only_all$TajimaD <- as.numeric(TD_only_all$TajimaD)

#combine TD for outlier seqs only
TD_outlier_only_all <- rbind(J_outlierseq, P_outlierseq, N_outlierseq, all_outlierseq)
  lapply(TD_outlier_only_all, class) #check character class for columns

#write out
write.csv(TD_only_all, "Data/SYN_mac1_TajimasD_combined_full.csv")
write.csv(TD_outlier_only_all, "Data/SYN_mac1_TajimasD_outlier_combined_full.csv")

#################################################################################################################################################

######## Calculate means & SE by pop ########

######## J pop calculations ########

#calculate mean Tajimas D for all seq
J_mean_TD_all <- mean(JTD_data_clean$TajimaD) #-0.280
J_SE_TD_all <- std.error(JTD_data_clean$TajimaD) #0.052

#calculate mean Tajimas D for outlier seq
J_outlierseq_clean <- J_outlierseq[which(J_outlierseq$TajimaD!='NA'),]
  J_outlierseq_clean$TajimaD <- as.numeric(J_outlierseq_clean$TajimaD)
J_mean_TD_outlierseq <- mean(J_outlierseq_clean$TajimaD) #0.031
J_SE_TD_outlierseq <- std.error(J_outlierseq_clean$TajimaD) #0.255

######## P pop calculations ########

#calculate mean Tajimas D for all seq
P_mean_TD_all <- mean(PTD_data_clean$TajimaD) #-0.290
P_SE_TD_all <- std.error(PTD_data_clean$TajimaD) #0.046

#calculate mean Tajimas D for outlier seq
P_outlierseq_clean <- P_outlierseq[which(P_outlierseq$TajimaD!='NA'),]
  P_outlierseq_clean$TajimaD <- as.numeric(P_outlierseq_clean$TajimaD)
P_mean_TD_outlierseq <- mean(P_outlierseq_clean$TajimaD) #0.066
P_SE_TD_outlierseq <- std.error(P_outlierseq_clean$TajimaD) #0.244

######## N pop calculations ########

#calculate mean Tajimas D for all seq
N_mean_TD_all <- mean(NTD_data_clean$TajimaD) #-0.166
N_SE_TD_all <- std.error(NTD_data_clean$TajimaD) #0.050

#calculate mean Tajimas D for outlier seq
N_outlierseq_clean <- N_outlierseq[which(N_outlierseq$TajimaD!='NA'),]
  N_outlierseq_clean$TajimaD <- as.numeric(N_outlierseq_clean$TajimaD)
N_mean_TD_outlierseq <- mean(N_outlierseq_clean$TajimaD) #0.006
N_SE_TD_outlierseq <- std.error(N_outlierseq_clean$TajimaD) #0.244

######## All pop calculations ########

#calculate mean Tajimas D for all seq
Tot_mean_TD_all <- mean(AllTD_data_clean$TajimaD) #-0.355
Tot_SE_TD_all <- std.error(AllTD_data_clean$TajimaD) #0.041

#calculate mean Tajimas D for outlier seq
all_outlierseq_clean <- all_outlierseq[which(all_outlierseq$TajimaD!='NA'),]
  all_outlierseq_clean$TajimaD <- as.numeric(all_outlierseq_clean$TajimaD)
Tot_mean_TD_outlierseq <- mean(all_outlierseq_clean$TajimaD) #0.012
Tot_SE_TD_outlierseq <- std.error(all_outlierseq_clean$TajimaD) #0.208

#################################################################################################################################################

######## Visualize data ########
#designed to be run separately from earlier sections

remove(list = ls())

#read in data
TD_only_all <- read.csv("Data/SYN_mac1_TajimasD_combined_full.csv", header = TRUE, row.names = 1)
TD_outlier_only_all <- read.csv("Data/SYN_mac1_TajimasD_outlier_combined_full.csv", header = TRUE, row.names = 1)
outlierseq <- read.csv("Data/outlier_sequences_TD_mac1_SYN.csv", header = TRUE) #only if running separately to visualize data

#add outlier status
outliers <- TD_only_all[TD_only_all$uniqseq %in% outlierseq$CONTIG, ] #df with only outliers
nonoutliers <- TD_only_all[!(TD_only_all$uniqseq %in% outlierseq$CONTIG), ] #df with all other loci

#set seq status
outliers$Status <- c(rep("Outlier", times = 96))
nonoutliers$Status <- c(rep("Not_Outlier", times = 1896))
TD_only_all$Status <- c(rep("All", times = 1992))

#merge together
TD_only_all <- rbind(outliers, nonoutliers, TD_only_all)

######## Scatter plots ########

#all seqs by pop
all_plot <- ggplot(data = TD_only_all, aes(x = NUM, y = TajimaD, color = Pop)) + 
  geom_point() + geom_hline(yintercept = 0, color = "black", size = 1)
all_plot_annotated <- all_plot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1), 
        axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 14, color = "black"), 
        axis.title = element_text(size = 14, face = "bold"), legend.position = "top", 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12))
all_plot_annotated

#outliers only by pop
outliers_plot <- ggplot(data = TD_outlier_only_all, aes(x = NUM, y = TajimaD, color = Pop)) + 
  geom_point() + geom_hline(yintercept = 0, color = "black", size = 1)
outliers_plot_annotated <- outliers_plot + theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1), 
        axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 14, color = "black"), 
        axis.title = element_text(size = 14, face = "bold"), legend.position = "top", 
        legend.text = element_text(size = 12), legend.title = element_text(size = 12))
outliers_plot_annotated

######## Boxplots ########

#ordering x-axis
TD_only_all$Pop2 <- factor(TD_only_all$Pop, levels = c("Japan", "Philippines", "Indonesia", "All")) #ordering X-axis

#boxplot
TD_boxplot <- ggplot(data = TD_only_all, aes(x = Pop2, y = TajimaD, color = Status)) + 
  geom_boxplot(lwd = 1.5) + 
  geom_hline(yintercept = 0, size = 1, linetype = "dashed", color = "#000000")
TD_boxplot_annotated <- TD_boxplot + theme_bw() + 
  scale_color_manual(values = c("#999999", "#E69F00", "#009E73"), labels = c("All loci", "No outliers", "Outliers only")) + 
  labs(x = "Sampling Location", y = "Tajima's D") + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1), 
        axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 28, color = "black"),
        axis.title = element_text(size = 30), legend.position = "top",
        legend.text = element_text(size = 30), legend.title = element_blank())
TD_boxplot_annotated

######## Mann-Whitney U-tests & ECDF plots ########

#Japan analysis
#subset data for plot
Japan_df <- TD_only_all[which(TD_only_all$Pop == "Japan"), ]
Japan_df <- Japan_df[which(Japan_df$Status != "All"), ]

#subset data for Mann-Whitney U-test
Japan_df_outliers <- Japan_df[which(Japan_df$Status == "Outlier"), ]
Japan_df_outliers <- Japan_df_outliers[which(Japan_df_outliers$TajimaD!='NA'),]
Japan_outliers_TD <- Japan_df_outliers$TajimaD

#subset data for Mann-Whitney U-test
Japan_df_all <- Japan_df[which(Japan_df$Status == "Not_Outlier"), ]
Japan_df_all <- Japan_df_all[which(Japan_df_all$TajimaD!='NA'),]
Japan_all_TD <- Japan_df_all$TajimaD

#run Mann-Whitney U-test for Japan dataset
Japan_TD_MUtest <- wilcox.test(Japan_outliers_TD, Japan_all_TD) #W = 2987, p = 0.237

#plot distributions
Japan_ecdf_plot <- ggplot(data = Japan_df, aes(x = TajimaD, color = Status)) + stat_ecdf(geom = "step", size = 1.5) + 
  geom_hline(yintercept = 1, size = 1, linetype = "dashed", color = "#666666") + 
  geom_hline(yintercept = 0, size = 1, linetype = "dashed", color = "#666666") + 
  annotate("text", x = 1.4, y = 0.65, label = "W = 2987", size = 12) + 
  annotate("text", x = 1.4, y = 0.57, label = "p = 0.237", size = 12) + 
  annotate("text", x = -1, y = 0.9, label = "Japan", size = 18)
Japan_ecdf_plot_annotated <- Japan_ecdf_plot + theme_bw() + labs(x = "Tajima's D", y = "Proportion of loci") + 
  scale_x_continuous(limits = c(-2,2)) + scale_color_manual(values = c("#999999", "#E69F00"), labels = c("Not_Outlier", "Outlier")) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1), 
        axis.ticks = element_line(color = "black", size = 1), axis.text = element_text(size = 20, color = "black"), 
        axis.title = element_text(size = 24, face = "bold"), legend.position = "top", 
        legend.text = element_text(size = 20), legend.title = element_blank())
Japan_ecdf_plot_annotated


#Philippines analysis
#subset data for plot
Philippines_df <- TD_only_all[which(TD_only_all$Pop == "Philippines"), ]
Philippines_df <- Philippines_df[which(Philippines_df$Status != "All"), ]

#subset data for Mann-Whitney U-test
Philippines_df_outliers <- Philippines_df[which(Philippines_df$Status == "Outlier"), ]
Philippines_df_outliers <- Philippines_df_outliers[which(Philippines_df_outliers$TajimaD!='NA'),]
Philippines_outliers_TD <- Philippines_df_outliers$TajimaD

#subset data for Mann-Whitney U-test
Philippines_df_all <- Philippines_df[which(Philippines_df$Status == "Not_Outlier"), ] 
Philippines_df_all <- Philippines_df_all[which(Philippines_df_all$TajimaD!='NA'),]
Philippines_all_TD <- Philippines_df_all$TajimaD

#run Mann-Whitney U-test for Philippines dataset
Philippines_TD_MUtest <- wilcox.test(Philippines_outliers_TD, Philippines_all_TD) #W = 5211, p = 0.227

#plot distributions
Philippines_ecdf_plot <- ggplot(data = Philippines_df, aes(x = TajimaD, color = Status)) + stat_ecdf(geom = "step", size = 1.5) + 
  geom_hline(yintercept = 1, size = 1, linetype = "dashed", color = "#666666") + 
  geom_hline(yintercept = 0, size = 1, linetype = "dashed", color = "#666666") + 
  annotate("text", x = 1.4, y = 0.65, label = "W = 5211", size = 12) + 
  annotate("text", x = 1.4, y = 0.57, label = "p = 0.227", size = 12) + 
  annotate("text", x = -1, y = 0.9, label = "Philippines", size = 18)
Philippines_ecdf_plot_annotated <- Philippines_ecdf_plot + theme_bw() + labs(x = "Tajima's D", y = "Proportion of loci") + 
  scale_x_continuous(limits = c(-2,2)) + scale_color_manual(values = c("#999999", "#E69F00"), labels = c("Not_Outlier", "Outlier")) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1), 
        axis.ticks = element_line(color = "black", size = 1), axis.text = element_text(size = 20, color = "black"), 
        axis.title = element_text(size = 24, face = "bold"), legend.position = "top", 
        legend.text = element_text(size = 20), legend.title = element_blank())
Philippines_ecdf_plot_annotated

#Indonesia analysis
#subset data for plot
Indonesia_df <- TD_only_all[which(TD_only_all$Pop == "Indonesia"), ]
Indonesia_df <- Indonesia_df[which(Indonesia_df$Status != "All"), ]

#subset data for Mann-Whitney U-test
Indonesia_df_outliers <- Indonesia_df[which(Indonesia_df$Status == "Outlier"), ]
Indonesia_df_outliers <- Indonesia_df_outliers[which(Indonesia_df_outliers$TajimaD!='NA'),]
Indonesia_outliers_TD <- Indonesia_df_outliers$TajimaD

#subset data for Mann-Whitney U-test
Indonesia_df_all <- Indonesia_df[which(Indonesia_df$Status == "Not_Outlier"), ]
Indonesia_df_all <- Indonesia_df_all[which(Indonesia_df_all$TajimaD!='NA'),]
Indonesia_all_TD <- Indonesia_df_all$TajimaD

#run Mann-Whitney U-test for Indonesia dataset
Indonesia_TD_MUtest <- wilcox.test(Indonesia_outliers_TD, Indonesia_all_TD) #W = 3558, p = 0.402

#plot distributions
Indonesia_ecdf_plot <- ggplot(data = Indonesia_df, aes(x = TajimaD, color = Status)) + stat_ecdf(geom = "step", size = 1.5) + 
  geom_hline(yintercept = 1, size = 1, linetype = "dashed", color = "#666666") + 
  geom_hline(yintercept = 0, size = 1, linetype = "dashed", color = "#666666") + 
  annotate("text", x = 1.4, y = 0.65, label = "W = 3558", size = 12) + 
  annotate("text", x = 1.4, y = 0.57, label = "p = 0.402", size = 12) + 
  annotate("text", x = -1, y = 0.9, label = "Indonesia", size = 18)
Indonesia_ecdf_plot_annotated <- Indonesia_ecdf_plot + theme_bw() + labs(x = "Tajima's D", y = "Proportion of loci") + 
  scale_x_continuous(limits = c(-2,2)) + scale_color_manual(values = c("#999999", "#E69F00"), labels = c("Not_Outlier", "Outlier")) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1), 
        axis.ticks = element_line(color = "black", size = 1), axis.text = element_text(size = 20, color = "black"), 
        axis.title = element_text(size = 24, face = "bold"), legend.position = "none", 
        legend.text = element_text(size = 20), legend.title = element_blank())
Indonesia_ecdf_plot_annotated

#All analysis
#subset data for plot
All_df <- TD_only_all[which(TD_only_all$Pop == "All"), ]
All_df <- All_df[which(All_df$Status != "All"), ]

#subset data for Mann-Whitney U-test
All_df_outliers <- All_df[which(All_df$Status == "Outlier"), ]
All_df_outliers <- All_df_outliers[which(All_df_outliers$TajimaD!='NA'),]
All_outliers_TD <- All_df_outliers$TajimaD

#subset data for Mann-Whitney U-test
All_df_all <- All_df[which(All_df$Status == "Not_Outlier"), ]
All_df_all <- All_df_all[which(All_df_all$TajimaD!='NA'),]
All_all_TD <- All_df_all$TajimaD

#run Mann-Whitney U-test for All dataset
All_TD_MUtest <- wilcox.test(All_outliers_TD, All_all_TD) #W = 6936, p = 0.069

#plot distributions
All_ecdf_plot <- ggplot(data = All_df, aes(x = TajimaD, color = Status)) + stat_ecdf(geom = "step", size = 1.5) + 
  geom_hline(yintercept = 1, size = 1, linetype = "dashed", color = "#666666") + 
  geom_hline(yintercept = 0, size = 1, linetype = "dashed", color = "#666666") + 
  annotate("text", x = 1.4, y = 0.65, label = "W = 6936", size = 12) + 
  annotate("text", x = 1.4, y = 0.57, label = "p = 0.069", size = 12) + 
  annotate("text", x = -1, y = 0.9, label = "All", size = 18)
All_ecdf_plot_annotated <- All_ecdf_plot + theme_bw() + labs(x = "Tajima's D", y = "Proportion of loci") + 
  scale_x_continuous(limits = c(-2,2)) + scale_color_manual(values = c("#999999", "#E69F00"), labels = c("Not_Outlier", "Outlier")) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(size = 1), 
        axis.ticks = element_line(color = "black", size = 1), axis.text = element_text(size = 20, color = "black"), 
        axis.title = element_text(size = 24, face = "bold"), legend.position = "none", 
        legend.text = element_text(size = 20), legend.title = element_blank())
All_ecdf_plot_annotated

#arrange all plots on same page
library(ggpubr)
combined_ecdfs <- ggarrange(Japan_ecdf_plot_annotated, Philippines_ecdf_plot_annotated, 
                            Indonesia_ecdf_plot_annotated, All_ecdf_plot_annotated, ncol = 2, nrow =2)
combined_ecdfs
