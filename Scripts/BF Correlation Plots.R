############################################# Script for creating Bayes Factors Correlation Plots #################################################

#includes BFs v. BFs plots for different environmental variables
#includes BFs v. XtX plots for different environmental variables

#################################################################################################################################################

######## Set-up ########

#set working directory
setwd("C:/Users/rclar/Dropbox/Pinsky_Lab/Transcriptome_Proj/R_scripts/A_clarkii_transcriptomics/")
getwd()

remove(list = ls())

#load libraries
library(readr)
library(tidyverse)
library(gridExtra)

#read in data
BFs <- read_csv("Data/BF_total_mac2.csv", col_names = TRUE)

################################################################################################################################################

######## BFs scatter plots ########

#correlation statistics
SSSMean_SSTMean_r <- cor(BFs$SSS_Mean, BFs$SST_Mean) #mac2 = 0.457, mac1 = 0.413
SSSMean_SSTMin_r <- cor(BFs$SSS_Mean, BFs$SST_Min) #mac2 = 0.509, mac1 = 0.459
SSSMean_SSTMax_r <- cor(BFs$SSS_Mean, BFs$SST_Max) #mac2 = 0.179, mac1 = 0.123
SSSMean_Lat_r <- cor(BFs$SSS_Mean, BFs$Lat) #mac2 = 0.794, mac1 = 0.753
SSTMean_SSTMin_r <- cor(BFs$SST_Mean, BFs$SST_Min) #mac2 = 0.880, mac1 = 0.756
SSTMean_SSTMax_r <- cor(BFs$SST_Mean, BFs$SST_Max) #mac2 = 0.317, mac1 = 0.208
SSTMean_Lat_r <- cor(BFs$SST_Mean, BFs$Lat) #mac2 = 0.839, mac1 = 0.798
SSTMin_SSTMax_r <- cor(BFs$SST_Min, BFs$SST_Max) #mac2 = 0.085, mac1 = -0.015
SSTMin_Lat_r <- cor(BFs$SST_Min, BFs$Lat) #mac2 = 0.822, mac1 = 0.716
SSTMax_Lat_r <- cor(BFs$SST_Max, BFs$Lat) #mac2 = 0.281, mac1 = 0.200

#SSSmean v. SSTmean plot
SSSmean_SSTmean_plot <- ggplot(data = BFs, aes(x = SSS_Mean, y = SST_Mean)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.457", size = 8) + 
  annotate("text", x = 3, y = 50, label = "A", size = 15)
SSSmean_SSTmean_annotated_plot <- SSSmean_SSTmean_plot + labs(x = "SSS Mean BF", y = "SST Mean BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSSmean_SSTmean_annotated_plot

#SSSmean v. SSTmin plot
SSSmean_SSTmin_plot <- ggplot(data = BFs, aes(x = SSS_Mean, y = SST_Min)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.509", size = 8) + 
  annotate("text", x = 3, y = 50, label = "B", size = 15)
SSSmean_SSTmin_annotated_plot <- SSSmean_SSTmin_plot + labs(x = "SSS Mean BF", y = "SST Minimum BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSSmean_SSTmin_annotated_plot

#SSSmean v. SSTmax plot
SSSmean_SSTmax_plot <- ggplot(data = BFs, aes(x = SSS_Mean, y = SST_Max)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.179", size = 8) + 
  annotate("text", x = 3, y = 50, label = "C", size = 15)
SSSmean_SSTmax_annotated_plot <- SSSmean_SSTmax_plot + labs(x = "SSS Mean BF", y = "SST Maximum BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSSmean_SSTmax_annotated_plot

#SSSmean v. Lat plot
SSSmean_Lat_plot <- ggplot(data = BFs, aes(x = SSS_Mean, y = Lat)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.794", size = 8) + 
  annotate("text", x = 3, y = 50, label = "D", size = 15)
SSSmean_Lat_annotated_plot <- SSSmean_Lat_plot + labs(x = "SSS Mean BF", y = "Latitude BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSSmean_Lat_annotated_plot

#SSTmean v. SSTmin plot
SSTmean_SSTmin_plot <- ggplot(data = BFs, aes(x = SST_Mean, y = SST_Min)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.880", size = 8) + 
  annotate("text", x = 3, y = 50, label = "E", size = 15)
SSTmean_SSTmin_annotated_plot <- SSTmean_SSTmin_plot + labs(x = "SST Mean BF", y = "SST Minimum BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSTmean_SSTmin_annotated_plot

#SSTmean v. SSTmax plot
SSTmean_SSTmax_plot <- ggplot(data = BFs, aes(x = SST_Mean, y = SST_Max)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.317", size = 8) + 
  annotate("text", x = 3, y = 50, label = "F", size = 15)
SSTmean_SSTmax_annotated_plot <- SSTmean_SSTmax_plot + labs(x = "SST Mean BF", y = "SST Maximum BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSTmean_SSTmax_annotated_plot

#SSTmean v. Lat plot
SSTmean_Lat_plot <- ggplot(data = BFs, aes(x = SST_Mean, y = Lat)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.839", size = 8) + 
  annotate("text", x = 3, y = 50, label = "G", size = 15)
SSTmean_Lat_annotated_plot <- SSTmean_Lat_plot + labs(x = "SST Mean BF", y = "Latitude BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSTmean_Lat_annotated_plot

#SSTmin v. SSTmax plot
SSTmin_SSTmax_plot <- ggplot(data = BFs, aes(x = SST_Min, y = SST_Max)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.085", size = 8) + 
  annotate("text", x = 3, y = 50, label = "H", size = 15)
SSTmin_SSTmax_annotated_plot <- SSTmin_SSTmax_plot + labs(x = "SST Minimum BF", y = "SST Maximum BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSTmin_SSTmax_annotated_plot

#SSTmin v. Lat plot
SSTmin_Lat_plot <- ggplot(data = BFs, aes(x = SST_Min, y = Lat)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.822", size = 8) + 
  annotate("text", x = 3, y = 50, label = "I", size = 15)
SSTmin_Lat_annotated_plot <- SSTmin_Lat_plot + labs(x = "SST Minimum BF", y = "Latitude BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSTmin_Lat_annotated_plot

#SSTmax v. Lat plot
SSTmax_Lat_plot <- ggplot(data = BFs, aes(x = SST_Max, y = Lat)) + geom_point(aes(size = 0.5, alpha = 0.1)) + 
  geom_hline(yintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_vline(xintercept = 20, size = 2, linetype = "dashed", color = "#666666") + 
  geom_abline(intercept = 0, slope = 1, size = 2, color = "#999999") + 
  annotate("text", x = 10, y = 42, label = "r = 0.281", size = 8) + 
  annotate("text", x = 3, y = 50, label = "J", size = 15)
SSTmax_Lat_annotated_plot <- SSTmax_Lat_plot + labs(x = "SST Maximum BF", y = "Latitude BF") + 
  theme_bw() + scale_y_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  scale_x_continuous(limits = c(0, 55), breaks = c(10, 20, 30, 40)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 22, color = "black"), axis.title = element_text(size = 25), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.5,.5), "cm"))
SSTmax_Lat_annotated_plot

BF_correlation_all_plot <- grid.arrange(SSSmean_SSTmean_annotated_plot, SSSmean_SSTmin_annotated_plot, 
                                       SSSmean_SSTmax_annotated_plot, SSSmean_Lat_annotated_plot, 
                                       SSTmean_SSTmin_annotated_plot, SSTmean_SSTmax_annotated_plot, 
                                       SSTmean_Lat_annotated_plot, SSTmin_SSTmax_annotated_plot, 
                                       SSTmin_Lat_annotated_plot, SSTmax_Lat_annotated_plot, ncol = 3)
BF_correlation_all_plot

###############################################################################################################################################

######## BF v. XtX scatter plots ########

#SSSmean v. XtX plot
SSSmean_XtX_plot <- ggplot(data = BFs, aes(x = SSS_Mean, y = M_XtX, color = Outlier_Status, shape = Outlier_Status)) + 
  annotate("rect", xmin = 20, xmax = Inf, ymin = 6.03, ymax = Inf, fill = "darkolivegreen", alpha = 0.4) + 
  geom_hline(yintercept = 6.03, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_vline(xintercept = 20, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_point(size = 8, alpha = 0.65) + 
  annotate("text", x = 3, y = 24, label = "A", size = 15) + 
  scale_color_manual(values = c("#999999", "#000000"), labels = c("Non-Outlier", "Outlier")) + 
  scale_shape_manual(values = c(19, 17), labels = c("Non-Outlier", "Outlier")) + 
  guides(alpha = FALSE, size = FALSE, color = guide_legend(override.aes = list(size = 8)))
SSSmean_XtX_annotated_plot <- SSSmean_XtX_plot + labs(x = "SSS Mean BF (dB)", y = "XtX") + 
  theme_bw() + scale_y_continuous(limits = c(0, 25)) + scale_x_continuous(limits = c(0, 55)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 28, color = "black"), axis.title = element_text(size = 30), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.75,.5), "cm"), legend.text = element_text(size = 26), 
        legend.title = element_blank())
SSSmean_XtX_annotated_plot

#SSTmean v. XtX plot
SSTmean_XtX_plot <- ggplot(data = BFs, aes(x = SST_Mean, y = M_XtX, color = Outlier_Status, shape = Outlier_Status)) + 
  annotate("rect", xmin = 20, xmax = Inf, ymin = 6.03, ymax = Inf, fill = "darkolivegreen", alpha = 0.4) + 
  geom_hline(yintercept = 6.03, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_vline(xintercept = 20, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_point(size = 8, alpha = 0.65) + 
  annotate("text", x = 3, y = 24, label = "B", size = 15) + 
  scale_color_manual(values = c("#999999", "#000000"), labels = c("Non-Outlier", "Outlier")) + 
  scale_shape_manual(values = c(19, 17), labels = c("Non-Outlier", "Outlier")) + 
  guides(alpha = FALSE, size = FALSE, color = guide_legend(override.aes = list(size = 8)))
SSTmean_XtX_annotated_plot <- SSTmean_XtX_plot + labs(x = "SST Mean BF (dB)", y = "XtX") + 
  theme_bw() + scale_y_continuous(limits = c(0, 25)) + scale_x_continuous(limits = c(0, 55)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 28, color = "black"), axis.title = element_text(size = 30), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.75,.5), "cm"), legend.text = element_text(size = 26), 
        legend.title = element_blank())
SSTmean_XtX_annotated_plot

#SSTmin v. XtX plot
SSTmin_XtX_plot <- ggplot(data = BFs, aes(x = SST_Min, y = M_XtX, color = Outlier_Status, shape = Outlier_Status)) + 
  annotate("rect", xmin = 20, xmax = Inf, ymin = 6.03, ymax = Inf, fill = "darkolivegreen", alpha = 0.4) + 
  geom_hline(yintercept = 6.03, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_vline(xintercept = 20, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_point(size = 8, alpha = 0.65) + 
  annotate("text", x = 3, y = 24, label = "C", size = 15) + 
  scale_color_manual(values = c("#999999", "#000000"), labels = c("Non-Outlier", "Outlier")) + 
  scale_shape_manual(values = c(19, 17), labels = c("Non-Outlier", "Outlier")) + 
  guides(alpha = FALSE, size = FALSE, color = guide_legend(override.aes = list(size = 8)))
SSTmin_XtX_annotated_plot <- SSTmin_XtX_plot + labs(x = "SST Min BF (dB)", y = "XtX") + 
  theme_bw() + scale_y_continuous(limits = c(0, 25)) + scale_x_continuous(limits = c(0, 55)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 28, color = "black"), axis.title = element_text(size = 30), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.75,.5), "cm"), legend.text = element_text(size = 26), 
        legend.title = element_blank())
SSTmin_XtX_annotated_plot

#SSTmax v. XtX plot
SSTmax_XtX_plot <- ggplot(data = BFs, aes(x = SST_Max, y = M_XtX, color = Outlier_Status, shape = Outlier_Status)) + 
  annotate("rect", xmin = 20, xmax = Inf, ymin = 6.03, ymax = Inf, fill = "darkolivegreen", alpha = 0.4) + 
  geom_hline(yintercept = 6.03, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_vline(xintercept = 20, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_point(size = 8, alpha = 0.65) + 
  annotate("text", x = 3, y = 24, label = "D", size = 15) + 
  scale_color_manual(values = c("#999999", "#000000"), labels = c("Non-Outlier", "Outlier")) + 
  scale_shape_manual(values = c(19, 17), labels = c("Non-Outlier", "Outlier")) + 
  guides(alpha = FALSE, size = FALSE, color = guide_legend(override.aes = list(size = 8)))
SSTmax_XtX_annotated_plot <- SSTmax_XtX_plot + labs(x = "SST Max BF (dB)", y = "XtX") + 
  theme_bw() + scale_y_continuous(limits = c(0, 25)) + scale_x_continuous(limits = c(0, 55)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 28, color = "black"), axis.title = element_text(size = 30), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.75,.5), "cm"), legend.text = element_text(size = 26), 
        legend.title = element_blank())
SSTmax_XtX_annotated_plot

#Lat v. XtX plot
Lat_XtX_plot <- ggplot(data = BFs, aes(x = Lat, y = M_XtX, color = Outlier_Status, shape = Outlier_Status)) + 
  annotate("rect", xmin = 20, xmax = Inf, ymin = 6.03, ymax = Inf, fill = "darkolivegreen", alpha = 0.4) + 
  geom_hline(yintercept = 6.03, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_vline(xintercept = 20, size = 1.5, color = "#000000", linetype = "dashed") + 
  geom_point(size = 8, alpha = 0.65) + 
  annotate("text", x = 3, y = 24, label = "E", size = 15) + 
  scale_color_manual(values = c("#999999", "#000000"), labels = c("Non-Outlier", "Outlier")) + 
  scale_shape_manual(values = c(19, 17), labels = c("Non-Outlier", "Outlier")) + 
  guides(alpha = FALSE, size = FALSE, color = guide_legend(override.aes = list(size = 8)))
Lat_XtX_annotated_plot <- Lat_XtX_plot + labs(x = "Latitude BF (dB)", y = "XtX") + 
  theme_bw() + scale_y_continuous(limits = c(0, 25)) + scale_x_continuous(limits = c(0, 55)) + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        axis.line = element_line(size = 1), axis.ticks = element_line(color = "black", size = 1), 
        axis.text = element_text(size = 28, color = "black"), axis.title = element_text(size = 30), 
        legend.position = "none", plot.margin = unit(c(.5,.5,.75,.5), "cm"), legend.text = element_text(size = 26), 
        legend.title = element_blank())
Lat_XtX_annotated_plot


BF_XtX_all_plot <- grid.arrange(SSSmean_XtX_annotated_plot, SSTmean_XtX_annotated_plot, 
                                SSTmin_XtX_annotated_plot, SSTmax_XtX_annotated_plot, 
                                Lat_XtX_annotated_plot, ncol = 3)
BF_XtX_all_plot
