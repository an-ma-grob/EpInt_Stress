
#-----------------------------------------
### R script for Stress Paper Analysis ###
  # 26th April 2022
# run on R version 4.1.2 (2021-11-01)
#----------------------------------------

library(ez); library(ggplot2); library(nlme); library(pastecs);
library(reshape); library(WRS)
library(reshape2) library(tidyverse) library(lme4)
library(ggplot2)
library(psych)
library(Hmisc)
library(lsr)
library("readxl")
library(afex)
library("emmeans")
library(corrplot)
library("dplyr")
library(tidyr)
library(magrittr)
library(rlang)
library(chron)
library("xlsx")
library(rstatix)

setwd("W:/Allgemeine 2 Psy/Mitarbeiter/Anna-Maria/Paper/Stress_Paper/Code")
total <- read_excel("Data.xlsx")

#------------------------------
## set apatheme
#install.packages("showtext")
library(showtext)
library("curl")
font_add_google("Montserrat", "Montserrat")
showtext.auto()

apatheme=theme_bw()+
  theme(panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.border=element_blank(),
        axis.line=element_line(),
        text=element_text(family='Montserrat', size = 25),
        plot.title = element_text(hjust = 0.5),
        legend.position = c(0.9,0.9)) 
#---------------------------------------
### wide to long format: Blood Pressure

now <- total

BloodPressure_Syst <- as.data.frame(now[,c(1,2,3,4,5,6,8,11,14,17)])
BloodPressure_Diast <- as.data.frame(now[,c(1,2,3,4,5,6,9,12,15,18)])
BloodPressure_Pulse <-as.data.frame(now[,c(1,2,3,4,5,6,10,13,16,19)])


Blood_long_Syst <- melt(BloodPressure_Syst, id.vars = c("VP.x","Code","Condition.x","Stress.x","Sex.x","Age.x"
),measure = names(BloodPressure_Syst[7:10]))
names(Blood_long_Syst) <- c("VP", "Code", "Condition", "Stress", "Sex","Age","Systole","V")

Blood_long_Diast <- melt(BloodPressure_Diast, id.vars = c("VP.x","Code","Condition.x","Stress.x","Sex.x","Age.x"
),measure = names(BloodPressure_Diast[7:10]))
names(Blood_long_Diast) <- c("VP", "Code", "Condition", "Stress", "Sex","Age","Diastole","V")

Blood_long_Pulse <- melt(BloodPressure_Pulse, id.vars = c("VP.x","Code","Condition.x","Stress.x","Sex.x","Age.x"
),measure = names(BloodPressure_Pulse[7:10]))
names(Blood_long_Pulse) <- c("VP", "Code", "Condition", "Stress", "Sex","Age","Pulse","V")


# make within factor Time
for (i in 1:(dim(Blood_long_Syst)[1])) {
  l = as.character(Blood_long_Syst$Systole[i])
  if (substr(Blood_long_Syst$Systole[i],(nchar(l)-1),nchar(l)) == "T1") {
    Blood_long_Syst$Time[i] <- -5
  } else if (substr(Blood_long_Syst$Systole[i],(nchar(l)-1),nchar(l)) == "T2"){
    Blood_long_Syst$Time[i] <- 3
  } else if (substr(Blood_long_Syst$Systole[i],(nchar(l)-1),nchar(l)) == "T3"){
    Blood_long_Syst$Time[i] <- 20
  } else if (substr(Blood_long_Syst$Systole[i],(nchar(l)-1),nchar(l)) == "T4"){
    Blood_long_Syst$Time[i] <- 110}
}

for (i in 1:(dim(Blood_long_Diast)[1])) {
  l = as.character(Blood_long_Diast$Diastole[i])
  if (substr(Blood_long_Diast$Diastole[i],(nchar(l)-1),nchar(l)) == "T1") {
    Blood_long_Diast$Time[i] <- -5
  } else if (substr(Blood_long_Diast$Diastole[i],(nchar(l)-1),nchar(l)) == "T2"){
    Blood_long_Diast$Time[i] <- 3
  } else if (substr(Blood_long_Diast$Diastole[i],(nchar(l)-1),nchar(l)) == "T3"){
    Blood_long_Diast$Time[i] <- 20
  } else if (substr(Blood_long_Diast$Diastole[i],(nchar(l)-1),nchar(l)) == "T4"){
    Blood_long_Diast$Time[i] <- 110}
}

for (i in 1:(dim(Blood_long_Pulse)[1])) {
  l = as.character(Blood_long_Pulse$Pulse[i])
  if (substr(Blood_long_Pulse$Pulse[i],(nchar(l)-1),nchar(l)) == "T1") {
    Blood_long_Pulse$Time[i] <- -5
  } else if (substr(Blood_long_Pulse$Pulse[i],(nchar(l)-1),nchar(l)) == "T2"){
    Blood_long_Pulse$Time[i] <- 3
  } else if (substr(Blood_long_Pulse$Pulse[i],(nchar(l)-1),nchar(l)) == "T3"){
    Blood_long_Pulse$Time[i] <- 20
  } else if (substr(Blood_long_Pulse$Pulse[i],(nchar(l)-1),nchar(l)) == "T4"){
    Blood_long_Pulse$Time[i] <- 110}
}

#-------
## Check for Outliers
# Outliers
Blood_long_Syst[Blood_long_Syst$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  identify_outliers(V)

# Normality assumption
Blood_long_Syst[Blood_long_Syst$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  shapiro_test(V)

# Homogeneity assumption 
Blood_long_Syst[Blood_long_Syst$Condition == "Presentation",] %>%
  group_by(Time) %>%
  levene_test(V ~ Stress)

# Compute ANOVA
Syst <- aov_car(V~ Time*Stress + Error(VP/Time), 
                data = Blood_long_Syst[Blood_long_Syst$Condition == "Presentation",])
knitr::kable(nice(Syst))

t.test(Blood_long_Syst$value[Blood_long_Syst$Condition == "Presentation" & Blood_long_Syst$Stress == "Control"& Blood_long_Syst$Time == "T4"],
       Blood_long_Syst$value[Blood_long_Syst$Condition == "Presentation" & Blood_long_Syst$Stress == "Stress"& Blood_long_Syst$Time == "T4"],paired = F)


#---------------------
# Outliers
Blood_long_Diast[Blood_long_Diast$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  identify_outliers(V)

# Normality assumption
Blood_long_Diast[Blood_long_Diast$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  shapiro_test(V)

# Homogeneity assumption 
Blood_long_Diast[Blood_long_Diast$Condition == "Presentation",] %>%
  group_by(Time) %>%
  levene_test(V ~ Stress)

# Compute ANOVA
Diast<-aov_car(V~ Time*Stress + Error(VP/Time), 
               data = Blood_long_Diast[Blood_long_Syst$Condition == "Presentation",])
knitr::kable(nice(Diast))

t.test(Blood_long_Diast$value[Blood_long_Diast$Condition == "Presentation" & Blood_long_Diast$Stress == "Control"& Blood_long_Diast$Time == "T4"],
       Blood_long_Diast$value[Blood_long_Diast$Condition == "Presentation" & Blood_long_Diast$Stress == "Stress"& Blood_long_Diast$Time == "T4"],paired = F)


#--------------------
# Outliers
Blood_long_Pulse[Blood_long_Pulse$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  identify_outliers(V)

# Normality assumption
Blood_long_Pulse[Blood_long_Pulse$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  shapiro_test(V)

# Homogeneity assumption 
Blood_long_Pulse[Blood_long_Pulse$Condition == "Presentation",] %>%
  group_by(Time) %>%
  levene_test(V ~ Stress)

Pulse<-aov_car(V ~ Time*Stress + Error(VP/Time), 
               data = Blood_long_Pulse[Blood_long_Pulse$Condition == "Presentation",])
knitr::kable(nice(Pulse))

t.test(Blood_long_Pulse$value[Blood_long_Pulse$Condition == "Presentation" & Blood_long_Pulse$Stress == "Control"& Blood_long_Pulse$Time == "T4"],
       Blood_long_Pulse$value[Blood_long_Pulse$Condition == "Presentation" & Blood_long_Pulse$Stress == "Stress"& Blood_long_Pulse$Time == "T4"],paired = F)
#----------------------

# Plotten 

p <- ggplot(Blood_long_Syst[Blood_long_Syst$Condition == "Presentation",],aes(x=Time, y=V, group=Stress))+
  geom_vline(xintercept = 4,color = "azure3", size=16.3, alpha =0.2)+ 
  #annotate(geom="text", x=4, y=117, label= c("TSST/\n Control"), color="black", size = 5) +
  geom_vline(xintercept = 65,color = "azure3", size=114,alpha =0.2)+
  #annotate(geom="text", x=65, y=115.8, label= c("NIT"), color="black", size = 5) + 
  coord_cartesian( xlim= c(-20,120),ylim = c(115, 155)) + guides(color=guide_legend("Group")) +
  annotate(geom="text", x=3, y=154, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=-1.5,xend=7.5,y=153.3,yend=153.3))+
  stat_summary(fun='mean',geom='line', size = 1.5, aes(color=Stress)) + ylab('Systolic Blood Pressure (mmHg)')+
  stat_summary(fun.data = mean_se, geom = "errorbar",  width =3) + xlab('')+
  scale_colour_manual(values = c("darkslategray4", "brown3")) + apatheme 

p + scale_x_continuous(breaks = c(-5,20,110),labels = paste0(c("-5","+20", "+110"))) 


g <- ggplot(Blood_long_Diast[Blood_long_Diast$Condition == "Presentation",],aes(x=Time, y=V, group=Stress))+
  geom_vline(xintercept = 4,color = "azure3", size=16.3, alpha =0.2)+ 
  #annotate(geom="text", x=4, y=76, label= c("TSST/\n Control"), color="black", size = 5) +
  geom_vline(xintercept = 65,color = "azure3", size=114,alpha =0.2)+
  #annotate(geom="text", x=65, y=75.8, label= c("NIT"), color="black", size = 5) + 
  coord_cartesian( xlim= c(-20,120),ylim = c(75, 103)) + guides(color=guide_legend("Group")) +
  annotate(geom="text", x=3, y=102, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=-1.5,xend=7.5,y=101.3,yend=101.3))+
  stat_summary(fun='mean',geom='line', size = 1.5, aes(color=Stress)) + ylab('Diastolic Blood Pressure (mmHg)')+ 
  stat_summary(fun.data = mean_se, geom = "errorbar",  width =3) + xlab('')+
  scale_colour_manual(values = c("darkslategray4", "brown3")) + apatheme

g + scale_x_continuous(breaks = c(-5,20,110),labels = paste0(c("-5", "+20", "+110"))) 



f <- ggplot(Blood_long_Pulse[Blood_long_Pulse$Condition == "Presentation",],aes(x=Time, y=V, group=Stress)) +
  geom_vline(xintercept = 4,color = "azure3", size=16.3, alpha =0.2)+ 
  #annotate(geom="text", x=4, y=78, label= c("TSST/\n Control"), color="black", size = 5) +
  geom_vline(xintercept = 65,color = "azure3", size=114,alpha =0.2)+
  #annotate(geom="text", x=65, y=77.8, label= c("NIT"), color="black", size = 5) +
  coord_cartesian( xlim= c(-20,120),ylim = c(77, 110)) + guides(color=guide_legend("Group")) +
  annotate(geom="text", x=3, y=107, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=-1.5,xend=7.5,y=106.3,yend=106.3))+
  stat_summary(fun='mean',geom='line', size = 1.5, aes(color=Stress)) + ylab('Pulse (bpm)')+ 
  stat_summary(fun.data = mean_se, geom = "errorbar",  width =3) + xlab('Minutes relative to treatment onset')+
  scale_colour_manual(values = c("darkslategray4", "brown3")) + apatheme

f + scale_x_continuous(breaks = c(-5,20,110),labels = paste0(c("-5", "+20", "+110")))


#--------------------------------------
#--------------------------------------
### MDBF ###

MDBF_help <- total %>% dplyr::select(VP.x, Stress.x, MDBF_GS1, MDBF_WM1, MDBF_RU1,
                              MDBF_GS2, MDBF_WM2, MDBF_RU2,
                              MDBF_GS3, MDBF_WM3, MDBF_RU3) %>% rename (VP = VP.x, Stress = Stress.x)

GS_long <- MDBF_help %>% 
  gather(GS, V, MDBF_GS1, MDBF_GS2, MDBF_GS3,  factor_key=TRUE) %>% 
  dplyr::select(-c(MDBF_WM1, MDBF_RU1, MDBF_WM2, MDBF_RU2, MDBF_WM3, MDBF_RU3))


for (i in 1:(dim( GS_long)[1])) {
  l = as.character( GS_long$GS[i])
  if (substr(GS_long$GS[i],(nchar(l)-1),nchar(l)) == "S1") {
    GS_long$Time[i] <- "T1"
    GS_long$Plot[i] <- -5
  } else if (substr(GS_long$GS[i],(nchar(l)-1),nchar(l)) == "S2"){
    GS_long$Time[i] <- "T2"
    GS_long$Plot[i] <- 20
  } else if (substr(GS_long$GS[i],(nchar(l)-1),nchar(l)) == "S3"){
    GS_long$Time[i] <- "T3"
    GS_long$Plot[i] <- 110
  }
}


WM_long <- MDBF_help %>% 
  gather(WM, V, MDBF_WM1, MDBF_WM2, MDBF_WM3,  factor_key=TRUE) %>% 
  dplyr::select(-c(MDBF_GS1, MDBF_RU1, MDBF_GS2, MDBF_RU2, MDBF_GS3, MDBF_RU3))


for (i in 1:(dim( WM_long)[1])) {
  l = as.character( WM_long$WM[i])
  if (substr(WM_long$WM[i],(nchar(l)-1),nchar(l)) == "M1") {
    WM_long$Time[i] <- "T1"
    WM_long$Plot[i] <- -5
  } else if (substr(WM_long$WM[i],(nchar(l)-1),nchar(l)) == "M2"){
    WM_long$Time[i] <- "T2"
    WM_long$Plot[i] <- 20
  } else if (substr(WM_long$WM[i],(nchar(l)-1),nchar(l)) == "M3"){
    WM_long$Time[i] <- "T3"
    WM_long$Plot[i] <- 110
  }
}

RU_long <- MDBF_help %>% 
  gather(RU, V, MDBF_RU1, MDBF_RU2, MDBF_RU3,  factor_key=TRUE) %>% 
  dplyr::select(-c(MDBF_GS1, MDBF_WM1, MDBF_GS2, MDBF_WM2, MDBF_GS3, MDBF_WM3))

for (i in 1:(dim( RU_long)[1])) {
  l = as.character( RU_long$RU[i])
  if (substr(RU_long$RU[i],(nchar(l)-1),nchar(l)) == "U1") {
    RU_long$Time[i] <- "T1"
    RU_long$Plot[i] <- -5
  } else if (substr(RU_long$RU[i],(nchar(l)-1),nchar(l)) == "U2"){
    RU_long$Time[i] <- "T2"
    RU_long$Plot[i] <- 20
  } else if (substr(RU_long$RU[i],(nchar(l)-1),nchar(l)) == "U3"){
    RU_long$Time[i] <- "T3"
    RU_long$Plot[i] <- 110
  }
}


## GS 

-----------------------------------------------------------
  # Outliers
  GS_long[GS_long$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  identify_outliers(V)

# Normality assumption
GS_long[GS_long$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  shapiro_test(V)

# Homogeneity assumption 
GS_long[GS_long$Condition == "Presentation",] %>%
  group_by(Time) %>%
  levene_test(V ~ Stress)
-----------------------------------------------------------
  
  
gs<-aov_car(V~ Time*Stress + Error(VP/Time), 
              data = GS_long)
knitr::kable(nice(gs))

t.test(GS_long$value[GS_long$Condition == "Presentation" & GS_long$Stress == "Control"& GS_long$Time == "T1"],
       GS_long$value[GS_long$Condition == "Presentation" & GS_long$Stress == "Stress"& GS_long$Time == "T1"],paired = F)


## WM 

-----------------------------------------------------------
  # Outliers
  WM_long[WM_long$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  identify_outliers(V)

# Normality assumption
WM_long[WM_long$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  shapiro_test(V)

# Homogeneity assumption 
WM_long[WM_long$Condition == "Presentation",] %>%
  group_by(Time) %>%
  levene_test(V ~ Stress)
-----------------------------------------------------------
  
wm<-aov_car(V~ Time*Stress + Error(VP/Time), 
              data = WM_long)
knitr::kable(nice(wm))


t.test(WM_long$value[WM_long$Condition == "Presentation" & WM_long$Time == "T1"],
       WM_long$value[WM_long$Condition == "Presentation" & WM_long$Time == "T2"],paired = TRUE)


## RU 

-----------------------------------------------------------
  # Outliers
  RU_long[RU_long$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  identify_outliers(V)

# Normality assumption
RU_long[RU_long$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  shapiro_test(V)

# Homogeneity assumption 
RU_long[RU_long$Condition == "Presentation",] %>%
  group_by(Time) %>%
  levene_test(V ~ Stress)
-----------------------------------------------------------
  
ru<-aov_car(V~ Time*Stress + Error(VP/Time), 
              data = RU_long)
knitr::kable(nice(ru))


t.test(RU_long$value[RU_long$Condition == "Presentation" & RU_long$Stress == "Control"& RU_long$Time == "T1"],
       RU_long$value[RU_long$Condition == "Presentation" & RU_long$Stress == "Stress"& RU_long$Time == "T1"],paired = F)


-------------------------------------------------------------------------------------------
  ### Cortisol ###
my_data <- total
Cort_long <- as.data.frame(my_data[,c(1,2,3,4,5,6,48,49,50,51,52)])
Cort_long_1 <- melt(Cort_long, id.vars = c("VP.x","Code","Condition.x","Stress.x","Sex.x","Age.x"),
                    measure = names(Cort_long[7:11]))
names(Cort_long_1) <- c("VP", "Code", "Condition", "Stress", "Sex", "Age", "Time","V")

# Mixed Anova
-----------------------------------------------------------
  # Outliers
  Cort_long_1[Cort_long_1$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  identify_outliers(V)

# Normality assumption
Cort_long_1[Cort_long_1$Condition == "Presentation",] %>%
  group_by(Time, Stress) %>%
  shapiro_test(V)

# Homogeneity assumption 
Cort_long_1[Cort_long_1$Condition == "Presentation",] %>%
  group_by(Time) %>%
  levene_test(V ~ Stress)
-----------------------------------------------------------
  
cortisol<-aov_car(V~ Time*Stress + Error(VP/Time), 
                    data = Cort_long_1[Cort_long_1$Condition == "Presentation",])
knitr::kable(nice(cortisol))

t.test(Cort_long_1$value[Cort_long_1$Condition == "Presentation" & Cort_long_1$Stress == "Control"& Cort_long_1$Plot == 1],
       Cort_long_1$value[Cort_long_1$Condition == "Presentation" & Cort_long_1$Stress == "Stress"& Cort_long_1$Plot == 1],paired = F)

## Plotten 

for (i in 1:(dim(Cort_long_1)[1])) {
  l = as.character(Cort_long_1$Time[i])
  if (substr(Cort_long_1$Time[i],(nchar(l)-1),nchar(l)) == "_1") {
    Cort_long_1$Plot[i] <- -5
  } else if (substr(Cort_long_1$Time[i],(nchar(l)-1),nchar(l)) == "_2"){
    Cort_long_1$Plot[i] <- 20
  } else if (substr(Cort_long_1$Time[i],(nchar(l)-1),nchar(l)) == "_3"){
    Cort_long_1$Plot[i] <- 60
  } else if (substr(Cort_long_1$Time[i],(nchar(l)-1),nchar(l)) == "_4"){
    Cort_long_1$Plot[i] <- 80
  } else if (substr(Cort_long_1$Time[i],(nchar(l)-1),nchar(l)) == "_5"){
    Cort_long_1$Plot[i] <- 110
  }
}


p <- ggplot(Cort_long_1[Cort_long_1$Condition=="Presentation",],aes(x=Plot, y=V, group=Stress))+
  geom_vline(xintercept = 4,color = "azure3", size=16.3, alpha =0.2)+ 
  #annotate(geom="text", x=4, y=2, label= c("TSST/\n Control"), color="black", size = 5) +
  geom_vline(xintercept = 65,color = "azure3", size=114,alpha =0.2)+
  #annotate(geom="text", x=65, y=1.8, label= c("NIT"), color="black", size = 5) +
  coord_cartesian( xlim= c(-20,120),ylim = c(0, 8)) + guides(color=guide_legend("Group")) +
  annotate(geom="text", x=20, y=7.7, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=16,xend=24,y=7.5,yend=7.5)) +
  annotate(geom="text", x=60, y=5.7, label= c("* *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=56,xend=64,y=5.5,yend=5.5)) +
  annotate(geom="text", x=80, y=4.8, label= c("*"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=76,xend=84,y=4.6,yend=4.6)) +
  annotate(geom="text", x=110, y=3.7, label=  c("\u2020"), color="black", fontface = "bold", size = 6) + 
  geom_segment(aes(x=106,xend=114,y=3.5,yend=3.5))+
  stat_summary(fun='mean',geom='line', size = 1.5, aes(color=Stress)) + ylab('Salivary cortisol (nmol/l)')+
  stat_summary(fun.data = mean_se, geom = "errorbar",  width =3) + xlab('Minutes relative to treatment onset')+
  scale_colour_manual(values = c("darkslategray4", "brown3")) + apatheme 


p + scale_x_continuous(breaks = c(-5,20,60,80,110),labels = paste0(c("-5", "+20", "+60", "+80", "+110")))


#-------------------------------------------------
## No cortisol baseline differences on day 2 ##
t.test(my_data$Cort_D2[my_data$Stress.x == "Control"],
       my_data$Cort_D2[my_data$Stress.x == "Stress"],paired = F)


---------------------------------------------------------------------------------------------
  #### Integration ####

Integration <- as.data.frame(my_data[,c(1,2,3,4,5,6,39,40,41,42)])

Integration_long <- melt(Integration, id.vars = c("VP.x","Code","Condition.x","Stress.x","Sex.x","Age.x"
),measure = names(Integration[7:10]))
names(Integration_long) <- c("VP", "Code", "Condition", "Stress", "Sex","Age","Which","Integration")

for (i in 1:(dim(Integration_long)[1])) {
  l = as.character(Integration_long$Which[i])
  if (substr(Integration_long$Which[i],6,8) == "Lin") {
    Integration_long$Link[i] <- "Link"
  } else if (substr(Integration_long$Which[i],6,8) == "Non"){
    Integration_long$Link[i] <- "NonLink"
  } }


for (i in 1:(dim(Integration_long)[1])) {
  l = as.character(Integration_long$Which[i])
  if (substr(Integration_long$Which[i],(nchar(l)-2),nchar(l)) == "Pre"){
    Integration_long$Time[i] <- "Pre"
  } else if (substr(Integration_long$Which[i],(nchar(l)-2),nchar(l)) == "ost"){
    Integration_long$Time[i] <- "Post"}
}

for (i in 1:(dim(Integration_long)[1])) {
  if (Integration_long$Stress[i] == "Stress" & Integration_long$Time[i] == "Pre"){
    Integration_long$Group[i] <- "Stress Pre"
  } else if (Integration_long$Stress[i] == "Stress" & Integration_long$Time[i] == "Post"){
    Integration_long$Group[i] <- "Stress Post"
  } else if (Integration_long$Stress[i] == "Control" & Integration_long$Time[i] == "Pre"){
    Integration_long$Group[i] <- "Control Pre"
  } else if (Integration_long$Stress[i] == "Control" & Integration_long$Time[i] == "Post"){
    Integration_long$Group[i] <- "Control Post"
  }}


for (i in 1:(dim(Integration_long)[1])) {
  if (Integration_long$Link[i] == "Link" & Integration_long$Time[i] == "Pre"){
    Integration_long$Group[i] <- "Link Pre"
  } else if (Integration_long$Link[i] == "Link" & Integration_long$Time[i] == "Post"){
    Integration_long$Group[i] <- "Link Post"
  } else if (Integration_long$Link[i] == "NonLink" & Integration_long$Time[i] == "Pre"){
    Integration_long$Group[i] <- "NonLink Pre"
  } else if (Integration_long$Link[i] == "NonLink" & Integration_long$Time[i] == "Post"){
    Integration_long$Group[i] <- "NonLink Post"
  }}


Integration_long$Link=as.factor(Integration_long$Link) #define factors
Integration_long$Time=factor(Integration_long$Time,
                             levels = c("Pre", "Post", ordered = TRUE))
Integration_long$Group=factor(Integration_long$Group,
                              levels = c("Control Pre", "Control Post", "Stress Pre", "Stress Post", ordered = TRUE))

-----------------------------------------------------------
  # Outliers
  Integration_long[Integration_long$Condition == "Presentation",] %>%
  group_by(Time, Link, Stress) %>%
  identify_outliers(Integration)

# Normality assumption
Integration_long[Integration_long$Condition == "Presentation",] %>%
  group_by(Time, Link, Stress) %>%
  shapiro_test(Integration)

# Homogeneity assumption 
Integration_long[Integration_long$Condition == "Presentation",] %>%
  group_by(Time, Link) %>%
  levene_test(Integration ~ Stress)
-----------------------------------------------------------
  
  
Link<-aov_car(Integration ~ Stress*Time*Link + Error(VP/Time*Link), 
                data = Integration_long[Integration_long$Condition=="Presentation",])
knitr::kable(nice(Link))

### Linked Stress
dodge = 0.15

Integration_long <- Integration_long %>%
  mutate(x = case_when(
    Link == "Link" & Time == "Pre" ~ 1 - dodge,
    Link == "Link" & Time == "Post" ~ 1 + dodge,
    Link == "NonLink" & Time == "Pre" ~ 2 - dodge,
    Link == "NonLink" & Time == "Post" ~ 2 + dodge,
  ))

p <-ggplot(Integration_long[Integration_long$Condition=="Presentation" & Integration_long$Stress=="Stress",], aes(x = Link, y = Integration, fill = Time))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Time),pch = 19, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  geom_line(aes(x = x, group = interaction(Code, Link)), alpha = 0.2, color = "brown4") +
  scale_fill_manual("Time",values = c("Pre"="brown1", "Post" = "brown4")) +
  scale_colour_manual(values=c("brown1", "brown4")) + 
  ylab('Link rating') + xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme

p+ coord_cartesian( ylim = c(1, 4.5))+ ggtitle("Stress Group") +
  annotate(geom="text", x=1, y=4.3, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=0.9,xend=1.1,y=4.2,yend=4.2)) +
  annotate(geom="text", x=2, y=3.5, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=1.9,xend=2.1,y=3.4,yend=3.4))

### Link Control 
dodge = 0.15

Integration_long <- Integration_long %>%
  mutate(x = case_when(
    Link == "Link" & Time == "Pre" ~ 1 - dodge,
    Link == "Link" & Time == "Post" ~ 1 + dodge,
    Link == "NonLink" & Time == "Pre" ~ 2 - dodge,
    Link == "NonLink" & Time == "Post" ~ 2 + dodge,
  ))

p <-ggplot(Integration_long[Integration_long$Condition=="Presentation" & Integration_long$Stress=="Control",], aes(x = Link, y = Integration, fill = Time))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Time),pch = 19, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  geom_line(aes(x = x, group = interaction(Code, Link)), alpha = 0.2, color = "darkslategray4") +
  scale_fill_manual("Time",values = c("Pre"="darkslategray3", "Post" = "darkslategray4")) +
  scale_colour_manual(values=c("darkslategray3", "darkslategray4")) + 
  ylab('Link rating') + xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme

p+ coord_cartesian( ylim = c(1, 4.5))+ ggtitle("Control Group") +
  annotate(geom="text", x=1, y=4.3, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=0.9,xend=1.1,y=4.2,yend=4.2)) +
  annotate(geom="text", x=2, y=3.5, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=1.9,xend=2.1,y=3.4,yend=3.4))


--------------------------------------------------------------------------------------------------
  # Cued Recall #
Cued <- my_data
Cued$Group <- Cued$Stress.x

t.test(Cued$CuedRecall[my_data$Stress.x == "Control"],
       Cued$CuedRecall[my_data$Stress.x == "Stress"],paired = F)


Cued <- Cued %>%
  mutate(x = case_when(
    Stress.x == "Stress"  ~ 1.5,
    Stress.x == "Control" ~ 1 ,
  ))


p <-ggplot(Cued[Cued$Condition.x=="Presentation",], aes(x = Group, y = CuedRecall*100, fill = Group))+
  stat_summary(aes(x = x),fun='mean',geom='bar', position=position_dodge(0.9), width = 0.4, alpha = 0.6)+
  geom_point(aes(x = x, colour=Group, fill = Group),pch = 21, position = position_jitterdodge(jitter.width = 0.05, dodge.width = 0.4), alpha = 0.6)+
  scale_fill_manual("Group",values = c("Control" = "darkslategray4","Stress"="brown1")) + 
  scale_colour_manual(values=c("darkslategray4", "brown1"))+ xlab('')+
  apatheme + ylab('Memory performance (%)') + stat_summary(aes(x = x),fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.9),width =.05)+
  scale_x_continuous(expand=expansion(mult=c(0.2,1)), breaks = c(1,1.5,2,2.5), labels = c('Control','Stress','',''))

p+ coord_cartesian(ylim = c(10, 100)) + theme(legend.position = c(0.7,0.9), axis.ticks = element_blank())


# Cued recall certainty

t.test(Cued$Cued_Recall_Mean_Certainty[my_data$Stress.x == "Control"],
       Cued$Cued_Recall_Mean_Certainty[my_data$Stress.x == "Stress"],paired = F)

p <-ggplot(Cued[Cued$Condition.x=="Presentation",], aes(x = Group, y = Cued_Recall_Mean_Certainty, fill = Group))+
  stat_summary(aes(x = x),fun='mean',geom='bar', position=position_dodge(0.9), width = 0.4, alpha = 0.6)+
  geom_point(aes(x = x, colour=Group, fill = Group),pch = 21, position = position_jitterdodge(jitter.width = 0.02, dodge.width = 0.4), alpha = 0.6)+
  scale_fill_manual("Group",values = c("Control" = "darkslategray4","Stress"="brown1")) + 
  scale_colour_manual(values=c("darkslategray4", "brown1"))+ xlab('')+
  apatheme + ylab('Certainty rating') + stat_summary(aes(x = x),fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.9),width =.05)+
  scale_x_continuous(expand=expansion(mult=c(0.2,1)), breaks = c(1,1.5,2,2.5), labels = c('Control','Stress','',''))

p+ coord_cartesian(ylim = c(0.7, 4.3)) + theme(legend.position = c(0.7,0.9), axis.ticks = element_blank())+ annotate(geom="text", x=1.25, y=4, label= c("\u2020"), color="black", fontface = "bold", size = 4.5) +
  geom_segment(aes(x=1.15,xend=1.35,y=3.9,yend=3.9))


#---------------------------------------
# Association Link ratings and Cued recall 

cor.test(total[total$Stress.x=="Stress" ,]$Mean_LinkPost, 
         total[total$Stress.x=="Stress" ,]$CuedRecall)

cor.test(total[total$Stress.x=="Control" ,]$Mean_LinkPost, 
         total[total$Stress.x=="Control" ,]$CuedRecall)

--------------------------------------------------------------------------------------------------------------
  ### ARENA ###
  
ARENA_pre <- as.data.frame(my_data[,c(1,2,3,4,5,6,37,38)])

ARENA_long <- melt(ARENA_pre, id.vars = c("VP.x","Code","Condition.x","Stress.x","Sex.x","Age.x"
),measure = names(ARENA_pre[7:8]))
names(ARENA_long) <- c("VP", "Code", "Condition", "Stress", "Sex","Age","What","V")

for (i in 1:(dim(ARENA_long)[1])) {
  if (substr(ARENA_long$What[i],12,13) == "Li") {
    ARENA_long$Link[i] <- "Link"
  } else if (substr(ARENA_long$What[i],12,13) == "No"){
    ARENA_long$Link[i] <- "NonLink"
  } }


ARENA_long$Stress=as.factor(ARENA_long$Stress) #define factors
ARENA_long$Condition=as.factor(ARENA_long$Condition)

-----------------------------------------------------------
  # Outliers
  ARENA_long[ARENA_long$Condition == "Presentation",] %>%
  group_by(Link, Stress) %>%
  identify_outliers(V)

# Normality assumption
ARENA_long[ARENA_long$Condition == "Presentation",] %>%
  group_by(Link, Stress) %>%
  shapiro_test(V)

# Homogeneity assumption 
ARENA_long[ARENA_long$Condition == "Presentation",] %>%
  group_by(Link) %>%
  levene_test(V ~ Stress)
-----------------------------------------------------------
  
ar<-aov_car(V ~ Stress *  Link + Error(VP/Link), 
              data = ARENA_long[ARENA_long$Condition == "Presentation",])
knitr::kable(nice(ar))


for (i in 1:(dim(ARENA_long)[1])) {
  if (ARENA_long$Stress[i] == "Stress" & ARENA_long$Link[i] == "Link"){
    ARENA_long$Group[i] <- "Stress Link"
  } else if (ARENA_long$Stress[i] == "Stress" & ARENA_long$Link[i] == "NonLink"){
    ARENA_long$Group[i] <- "Stress NonLink"
  } else if (ARENA_long$Stress[i] == "Control" & ARENA_long$Link[i] == "Link"){
    ARENA_long$Group[i] <- "Control Link"
  } else if (ARENA_long$Stress[i] == "Control" & ARENA_long$Link[i] == "NonLink"){
    ARENA_long$Group[i] <- "Control NonLink"
  }}

ARENA_long$Group=factor(ARENA_long$Group,
                        levels = c("Control Link", "Stress Link", "Control NonLink",
                                   "Stress NonLink", ordered = TRUE))

#--------------------------------------------
dodge = 0.15

ARENA_long <- ARENA_long %>%
  mutate(x = case_when(
    Link == "Link" & Stress == "Control"  ~ 1 - dodge,
    Link == "NonLink" & Stress == "Control"  ~ 1 + dodge,
    Link == "Link" & Stress == "Stress" ~ 2 - dodge,
    Link == "NonLink" & Stress == "Stress" ~ 2 + dodge,
  ))

p <-ggplot(ARENA_long[ARENA_long$Condition=="Presentation" ,], aes(x = Link, y = V, fill = Stress))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Stress),pch = 19, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  #geom_line(aes(x = x, group = interaction(Code, Stress), color = Group), alpha = 0.2) +
  scale_fill_manual("Stress",values = c("Control"="darkslategray4", "Stress" = "brown1")) +
  scale_colour_manual("Stress", values = c("Control"="darkslategray4", "Stress" = "brown1")) + 
  #scale_colour_manual("Stress",values = c("Control"="blueviolet", "Stress"="brown4")) +
  ylab('Euclidian distance') + xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme 


p+coord_cartesian(ylim = c(.006, .11)) +
  annotate(geom="text", x=1.65, y=.10, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=1.15,xend=2.15,y=.098,yend=.098))+
  annotate(geom="text", x=1.35, y=.107, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=0.85,xend=1.85,y=.105,yend=.105))+ theme(legend.position = "none") +  scale_y_continuous(breaks=c("0" = 0, ".02" = .02, ".04" = .04, ".06" = .06, ".08" = .08, ".10" = .10)) 

-------------------------------------------------------------------------------------------------------------------
 ### Free Recall ###

Free <- as.data.frame(my_data[,c(1,2,99,4,5,6,56, 57, 58)])
Free_long <-  melt(Free, id.vars = c("VP.x","Code","Counterbalancing","Stress.x","Sex.x","Age.x", "FreeRecall_A_total.y"
                                     , "FreeRecall_B_total.y","FreeRecall_X_total.y"),measure = names(Free[,c(7,8,9)]))
names(Free_long) <- c("VP", "Code", "Condition", "Stress", "Sex","Age","FreeRecall_A_total", "FreeRecall_B_total","FreeRecall_X_total","Which","Details")

for (i in 1:(dim(Free_long)[1])) {
  l = as.character(Free_long$Which[i])
  if (Free_long$Condition[i] == "I1" | Free_long$Condition[i] == "L1"){
    if (substr(Free_long$Which[i],11,12) == "_A") {
      Free_long$Item[i] <- "A"
    } else if (substr(Free_long$Which[i],11,12) == "_B"){
      Free_long$Item[i] <- "B"
    } else if (substr(Free_long$Which[i],11,12) == "_X"){
      Free_long$Item[i] <- "X"
    }} else if (Free_long$Condition[i] == "I2" |  Free_long$Condition[i] == "L2"){
      if (substr(Free_long$Which[i],11,12) == "_A") {
        Free_long$Item[i] <- "A"
      } else if (substr(Free_long$Which[i],11,12) == "_B"){
        Free_long$Item[i] <- "X"
      } else if (substr(Free_long$Which[i],11,12) == "_X"){
        Free_long$Item[i] <- "B"
      } }}

for (i in 1:(dim(Free_long))[1]) {
  if (Free_long$Condition[i] == "L1" || Free_long$Condition[i] == "L2") {
    Free_long$Condition[i] <- "Presentation"} 
  else 
  {Free_long$Condition[i] <- "Imagination"}
}


for (i in 1:(dim(Free_long)[1])) {
  if (Free_long$Stress[i] == "Stress" & Free_long$Condition[i] == "Imagination"){
    Free_long$Group[i] <- "Stress Imagination"
  } else if (Free_long$Stress[i] == "Stress" & Free_long$Condition[i] == "Presentation"){
    Free_long$Group[i] <- "Stress Presentation"
  } else if (Free_long$Stress[i] == "Control" & Free_long$Condition[i] == "Imagination"){
    Free_long$Group[i] <- "Control Imagination"
  } else if (Free_long$Stress[i] == "Control" & Free_long$Condition[i] == "Presentation"){
    Free_long$Group[i] <- "Control Presentation"
  }}

Free_long$Item=as.factor(Free_long$Item)
Free_long$Condition = as.factor(Free_long$Condition)
Free_long$Stress=as.factor(Free_long$Stress)
Free_long$Group = as.factor(Free_long$Group)

-----------------------------------------------------------
  # Outliers
  L <-Free_long[Free_long$Condition=="Presentation",] %>%
  group_by(Item, Stress) %>%
  identify_outliers(Details)

# Normality assumption
Free_long[Free_long$Condition=="Presentation",] %>%
  group_by(Item, Stress) %>%
  shapiro_test(Details)

# Homogeneity assumption 
Free_long[Free_long$Condition=="Presentation",] %>%
  group_by(Item) %>%
  levene_test(Details ~ Stress)
-----------------------------------------------------------
  
nb<-aov_car(Details ~ Stress * Item + Error(VP/Item), 
              data = Free_long[Free_long$Condition=="Presentation",])
knitr::kable(nice(nb))


#-------------------------------------
# Association: Free Recall & Cortisol increase
total$Cort_incr <- total$Cort_2 - total$Cort_1                        #Cortisol increase
total$AB <- (total$FreeRecall_A_total.y + total$Link_Free)/2          # Mean details for linked events
total$Diff_Free <- total$AB - total$NonLink_Free                      # Difference between linked and non-linked events


cor.test(total[total$Stress.x=="Stress" ,]$Cort_incr, 
         total[total$Stress.x=="Stress" ,]$Diff_Free)

cor.test(total[total$Stress.x=="Control" ,]$Cort_incr, 
         total[total$Stress.x=="Control" ,]$Diff_Free)


# Plot
ggplot(total[total$Stress.x=="Stress" & total$Condition.x == "Presentation" ,], aes(x=Cort_incr, y=Diff_Free)) +
  geom_point(size=2, shape=19) + apatheme + xlab('Left parahippocampus \u03B2') + coord_cartesian(ylim = c(-5, 15))+
  ylab("mnemonic prioritization \n of linked events") + ggtitle("Stress group") +
  geom_smooth(method='lm',color="brown3", fill = "brown3") +  labs(
    x = "*\u0394* salivary cortisol (nmol/l)",
    #y = "mnemonic prioritization \n of linked events",
    fill = "Var1"
  ) +
  theme(axis.title.x = ggtext::element_markdown())


ggplot(total[total$Stress.x=="Control" & total$Condition.x == "Presentation" ,], aes(x=Cort_incr, y=Diff_Free)) +
  geom_point(size=2, shape=19) + apatheme + xlab('Left parahippocampus \u03B2') + coord_cartesian(ylim = c(-5, 15))+ 
  ylab("mnemonic prioritization \n of linked events") + ggtitle("Control group") +
  geom_smooth(method='lm',color="darkslategray4", fill = "darkslategray4") +  labs(
    x = "*\u0394* salivary cortisol (nmol/l)",
    #y = "*\u0394* memory performance",
    fill = "Var1"
  ) +
  theme(axis.title.x = ggtext::element_markdown())

#-----------------------------------------------------------------------------
## Figures for Univariate 

# Mismatch association
cor.test(total[total$Stress.x=="Stress" ,]$Left_Amy_LinkvsCon, 
         total[total$Stress.x=="Stress" ,]$Mean_ARENA_Link)

cor.test(total[total$Stress.x=="Control" ,]$Left_Amy_LinkvsCon, 
         total[total$Stress.x=="Control" ,]$Mean_ARENA_Link)


# Mismatch bar plots 
colnames(total) <- make.unique(names(total))
total$Group <- total$Stress.x

total <- total %>%
  mutate(x = case_when(
    Stress.x == "Stress"  ~ 1.5,
    Stress.x == "Control" ~ 1 ,
  ))


p <-ggplot(total[total$Condition.x=="Presentation",], aes(x = Group, y = Left_Amy_LinkvsCon, fill = Group))+
  stat_summary(aes(x = x),fun='mean',geom='bar', position=position_dodge(0.9), width = 0.4, alpha = 0.6)+
  geom_point(aes(x = x, colour=Group, fill = Group),pch = 21, size = 2.5, position = position_jitterdodge(jitter.width = 0.05, dodge.width = 0.4), alpha = 0.6)+
  scale_fill_manual("Group",values = c("Control" = "darkslategray4","Stress"="brown1")) + 
  scale_colour_manual(values=c("darkslategray4", "brown1"))+ xlab('')+
  apatheme + ylab('Right amygdala activity (??)') + stat_summary(aes(x = x),fun.data = mean_se, size = 1, geom = "errorbar",  position=position_dodge(0.9),width =.05)+
  scale_x_continuous(expand=expansion(mult=c(0.2,1)), breaks = c(1,1.5), labels = c('Control','Stress'))

p+ coord_cartesian(ylim = c(-115, 110)) + theme(legend.position = c(0.7,0.9), axis.ticks = element_blank()) +
  labs(
    y = "Amygdala activity (*??*)",
    fill = "Var1"
  ) +
  theme(axis.title.y = ggtext::element_markdown()) +
  annotate(geom="text", x=1.25, y=63, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=1.1, xend=1.4,y=60,yend=60))

#-------
p <-ggplot(total[total$Condition.x=="Presentation",], aes(x = Group, y = Left_HC_LinkvsCon, fill = Group))+
  stat_summary(aes(x = x),fun='mean',geom='bar', position=position_dodge(0.9), width = 0.4, alpha = 0.6)+
  geom_point(aes(x = x, colour=Group, fill = Group),pch = 21, size = 2.5, position = position_jitterdodge(jitter.width = 0.05, dodge.width = 0.4), alpha = 0.6)+
  scale_fill_manual("Group",values = c("Control" = "darkslategray4","Stress"="brown1")) + 
  scale_colour_manual(values=c("darkslategray4", "brown1"))+ xlab('')+
  apatheme + ylab('Right amygdala activity (??)') + stat_summary(aes(x = x),fun.data = mean_se, size = 1, geom = "errorbar",  position=position_dodge(0.9),width =.05)+
  scale_x_continuous(expand=expansion(mult=c(0.2,1)), breaks = c(1,1.5), labels = c('Control','Stress'))

p+ coord_cartesian(ylim = c(-115, 110)) + theme(legend.position = c(0.7,0.9), axis.ticks = element_blank()) +
  labs(
    y = "Hippocampal activity (*??*)",
    fill = "Var1"
  ) +
  theme(axis.title.y = ggtext::element_markdown()) +
  annotate(geom="text", x=1.25, y=63, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=1.1, xend=1.4,y=60,yend=60))

#----------------------------------------
## Pre to post 


# OrbFront
t.test(total[total$Condition.x=="Presentation" & total$Stress.x=="Control",]$OrbFront_preLink, 
       total[total$Condition.x=="Presentation" & total$Stress.x=="Control",]$OrbFront_postLink, paired = TRUE)

t.test(total[total$Condition.x=="Presentation" & total$Stress.x=="Stress",]$OrbFront_preLink, 
       total[total$Condition.x=="Presentation" & total$Stress.x=="Stress",]$OrbFront_postLink, paired = TRUE)


OFC <- as.data.frame(total[,c(1,2,4,5,6,100,102)])
OFC_long <- melt(OFC, id.vars = c("VP.x","Code","Stress.x","Sex.x","Age.x"
),measure = names(OFC[c(6,7)]))

# make within factor Time
for (i in 1:(dim(OFC_long)[1])) {
  if (substr(OFC_long$variable[i],10,11) == "pr") {
    OFC_long$Time[i] <- "Pre"
  } else if (substr(OFC_long$variable[i],10,11) == "po"){
    OFC_long$Time[i] <- "Post"}
}

for (i in 1:(dim(OFC_long)[1])) {
  if (substr(OFC_long$variable[i],10,11) == "pr" & OFC_long$Stress.x[i] == "Control") {
    OFC_long$Group[i] <- "Con Pre"
    OFC_long$Order[i] <- "pre"
  } else if (substr(OFC_long$variable[i],10,11) == "pr" & OFC_long$Stress.x[i] == "Stress") {
    OFC_long$Group[i] <- "Stress Pre"
    OFC_long$Order[i] <- "post"
  } else if (substr(OFC_long$variable[i],10,11) == "po" & OFC_long$Stress.x[i] == "Control") {
    OFC_long$Group[i] <- "Con Post"
    OFC_long$Order[i] <- "pre"
  } else if (substr(OFC_long$variable[i],10,11) == "po" & OFC_long$Stress.x[i] == "Stress") {
    OFC_long$Group[i] <- "Stress Post"
    OFC_long$Order[i] <- "post"
  }
}

OFC_long$Group=factor(OFC_long$Group,
                      levels = c("Con Pre", "Con Post", "Stress Pre", "Stress Post", ordered = TRUE))

dodge = 0.15

OFC_long <- OFC_long %>%
  mutate(x = case_when(
    Stress.x == "Control" & Time == "Pre" ~ 1 - dodge,
    Stress.x == "Control" & Time == "Post" ~ 1 + dodge,
    Stress.x == "Stress" & Time == "Pre" ~ 2 - dodge,
    Stress.x == "Stress" & Time == "Post" ~ 2 + dodge,
  ))

colnames(OFC_long) <- make.unique(names(OFC_long))
OFC_long <- as.data.frame(OFC_long)


p <-ggplot(OFC_long, aes(x = Stress.x, y = value, fill = Group))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6),width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Group),pch = 19, size = 2.5, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  #geom_line(aes(x = x, group = interaction(Code, Stress.x), colour = Group), alpha = 0.2) +
  scale_fill_manual("Group",values = c("Con Pre"="darkslategray3", "Con Post" = "darkslategray4", 
                                       "Stress Pre" = "brown1", "Stress Post" = "brown4")) +
  scale_colour_manual("Group",values = c("Con Pre"="darkslategray3", "Con Post" = "darkslategray4", 
                                         "Stress Pre" = "brown1", "Stress Post" = "brown4")) + 
  ylab('Orbitofrontal activity') + xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar", size = 1,  position=position_dodge(0.6),width =.1)+
  apatheme

p + coord_cartesian(ylim = c(-2, 2.4))+
  annotate(geom="text", x=2, y=2.5, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=1.85,xend=2.15,y=2.4,yend=2.4))


#---------------------
# PHC

t.test(total[total$Condition.x=="Presentation" & total$Stress.x=="Control",]$L_PHC_preLink, 
       total[total$Condition.x=="Presentation" & total$Stress.x=="Control",]$L_PHC_postLink, paired = TRUE)

t.test(total[total$Condition.x=="Presentation" & total$Stress.x=="Stress",]$L_PHC_preLink, 
       total[total$Condition.x=="Presentation" & total$Stress.x=="Stress",]$L_PHC_postLink, paired = TRUE)


PHC <- as.data.frame(total[,c(1,2,4,5,6,101,103)])
PHC_long <- melt(PHC, id.vars = c("VP.x","Code","Stress.x","Sex.x","Age.x"
),measure = names(PHC[c(6,7)]))

for (i in 1:(dim(PHC_long)[1])) {
  if (substr(PHC_long$variable[i],7,8) == "pr") {
    PHC_long$Time[i] <- "Pre"
  } else if (substr(PHC_long$variable[i],7,8) == "po"){
    PHC_long$Time[i] <- "Post"}
}


for (i in 1:(dim(PHC_long)[1])) {
  if (substr(PHC_long$variable[i],7,8) == "pr" & PHC_long$Stress.x[i] == "Control") {
    PHC_long$Group[i] <- "Con Pre"
    PHC_long$Order[i] <- "pre"
  } else if (substr(PHC_long$variable[i],7,8) == "pr" & PHC_long$Stress.x[i] == "Stress") {
    PHC_long$Group[i] <- "Stress Pre"
    PHC_long$Order[i] <- "post"
  } else if (substr(PHC_long$variable[i],7,8) == "po" & PHC_long$Stress.x[i] == "Control") {
    PHC_long$Group[i] <- "Con Post"
    PHC_long$Order[i] <- "pre"
  } else if (substr(PHC_long$variable[i],7,8) == "po" & PHC_long$Stress.x[i] == "Stress") {
    PHC_long$Group[i] <- "Stress Post"
    PHC_long$Order[i] <- "post"
  }
}

PHC_long$Group=factor(PHC_long$Group,
                      levels = c("Con Pre", "Con Post", "Stress Pre", "Stress Post", ordered = TRUE))



colnames(PHC_long) <- make.unique(names(PHC_long))
PHC_long <- as.data.frame(PHC_long)

PHC_long <- PHC_long %>%
  mutate(x = case_when(
    Stress.x == "Control" & Time == "Pre" ~ 1 - dodge,
    Stress.x == "Control" & Time == "Post" ~ 1 + dodge,
    Stress.x == "Stress" & Time == "Pre" ~ 2 - dodge,
    Stress.x == "Stress" & Time == "Post" ~ 2 + dodge,
  ))


p <-ggplot(PHC_long, aes(x = Stress.x, y = value, fill = Group))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Group),pch = 19, size = 2.5, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.6)+
  #geom_line(aes(x = x, group = interaction(Code, Stress.x), colour = Group), alpha = 0.2) +
  scale_fill_manual("Group",values = c("Con Pre"="darkslategray3", "Con Post" = "darkslategray4", 
                                       "Stress Pre" = "brown1", "Stress Post" = "brown4")) +
  scale_colour_manual("Group",values = c("Con Pre"="darkslategray3", "Con Post" = "darkslategray4", 
                                         "Stress Pre" = "brown1", "Stress Post" = "brown4")) +
  ylab('Parahippocampal activity') + xlab ('') + stat_summary(fun.data = mean_se, size = 1, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme

p + coord_cartesian(ylim = c(-2, 2.4))+
  annotate(geom="text", x=2, y=2.5, label= c("*"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=1.85,xend=2.15,y=2.3,yend=2.3))+
  annotate(geom="text", x=1, y=2.5, label= c("* * *"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=.85,xend=1.15,y=2.3,yend=2.3))





#----------------------------------------------------------------------------------
## RSA results ###

A <- as.data.frame(my_data[,c(1,2,4,67, 68, 69, 70)])

Amygdala <- melt(A, id.vars = c("Code", "VP.x","Stress.x"),measure = names(A[c(4:7)]))
names(Amygdala) <- c("Code", "VP",  "Stress", "Neural_sim","V")

for (i in 1:(dim(Amygdala)[1])) {
  l = as.character(Amygdala$Neural_sim[i])
  if (substr(Amygdala$Neural_sim[i],16,17) == "AB" | substr(Amygdala$Neural_sim[i],17,18) == "AB") {
    Amygdala$Link[i] <- "AB"
  } else if (substr(Amygdala$Neural_sim[i],16,17) == "AX" | substr(Amygdala$Neural_sim[i],17,18) == "AX") {
    Amygdala$Link[i] <- "AX"
  } 
}

for (i in 1:(dim(Amygdala)[1])) {
  l = as.character(Amygdala$Neural_sim[i])
  if (substr(Amygdala$Neural_sim[i],19,20) == "pr" ||  substr(Amygdala$Neural_sim[i],19,20) == "pr"){#| substr(Amygdala$Neural_sim[i],13,14) == "pr") {
    Amygdala$Time[i] <- "pre"
  } else {
    Amygdala$Time[i] <- "post"
  }
}

for (i in 1:(dim(Amygdala)[1])) {
  if (Amygdala$Stress[i] == "Stress" & Amygdala$Time[i] == "pre"){
    Amygdala$Group[i] <- "Stress Pre"
  } else if (Amygdala$Stress[i] == "Stress" & Amygdala$Time[i] == "post"){
    Amygdala$Group[i] <- "Stress Post"
  } else if (Amygdala$Stress[i] == "Control" & Amygdala$Time[i] == "pre"){
    Amygdala$Group[i] <- "Control Pre"
  } else if (Amygdala$Stress[i] == "Control" & Amygdala$Time[i] == "post"){
    Amygdala$Group[i] <- "Control Post"
  }}


Amygdala$Link=as.factor(Amygdala$Link) #define factors
Amygdala$Group=factor(Amygdala$Group,
                      levels = c("Control Pre", "Control Post", "Stress Pre", "Stress Post", ordered = TRUE))
Amygdala$Time=factor(Amygdala$Time,
                     levels = c("pre", "post", ordered = TRUE))


-----------------------------------------------------------
  # Outliers
  Amygdala[Amygdala$Condition=="Presentation",] %>%
  group_by(Time, Link, Stress) %>%
  identify_outliers(V)

# Normality assumption
Amygdala[Amygdala$Condition=="Presentation",] %>%
  group_by(Time, Link, Stress) %>%
  shapiro_test(V)

# Homogeneity assumption 
Amygdala[Amygdala$Condition=="Presentation",] %>%
  group_by(Time, Link) %>%
  levene_test(V ~ Stress)
-----------------------------------------------------------
Link<-aov_car(V ~ Time*Link + Error(VP/Time*Link),
                data = Amygdala[Amygdala$Stress=="Control",]) #
knitr::kable(nice(Link))

Link<-aov_car(V ~ Time*Link + Error(VP/Time*Link),
              data = Amygdala[Amygdala$Stress=="Stress",]) #
knitr::kable(nice(Link))
  
  
Link<-aov_car(V ~ Stress*Time*Link + Error(VP/Time*Link),
                data = Amygdala) #
knitr::kable(nice(Link))

## Follow up t-tests
t.test(Amygdala[which(Amygdala$Link == "AX" & Amygdala$Group == "Control Pre"),]$V,
       Amygdala[which(Amygdala$Link == "AX" & Amygdala$Group == "Control Post"),]$V, paired = T)

-----------------------------------------------------------
  ### Dissimilarity increase for Controls 
colnames(Amygdala) <- make.unique(names(Amygdala))

dodge = 0.15

Amygdala <- Amygdala %>%
  mutate(x = case_when(
    Link == "AB" & Time == "pre" ~ 1 - dodge,
    Link == "AB" & Time == "post" ~ 1 + dodge,
    Link == "AX" & Time == "pre" ~ 2 - dodge,
    Link == "AX" & Time == "post" ~ 2 + dodge,
  ))

p <-ggplot(Amygdala[Amygdala$Stress=="Control",], aes(x = Link, y = V, fill = Time))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Time),pch = 19, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  geom_line(aes(x = x, group = interaction(Code, Link)), alpha = 0.2, color = "darkslategray4") +
  scale_fill_manual("Time",values = c("pre"="darkslategray3", "post" = "darkslategray4")) +
  scale_colour_manual(values=c("darkslategray3", "darkslategray4")) + 
  xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme +labs(y=expression(paste("Neural dissimilarity (1- ",italic("r"), ")")))

p+  ggtitle("aHC: Control Group") + coord_cartesian(ylim = c(0.59, 1))+
  annotate(geom="text", x=1, y=0.95, label= c("*"), color="black", fontface = "bold", size = 6) +
  geom_segment(aes(x=0.9,xend=1.1,y=0.93,yend=0.93)) + scale_x_discrete(labels=c("AB" = "Link", "AX" = "NonLink"))+
  scale_y_continuous(breaks=c(".6" = .6, ".7" = .7, ".8" = .8, ".9" = .9, "1" = 1)) 

----------------
  # Dissimilarity Stress
  dodge = 0.15

Amygdala <- Amygdala %>%
  mutate(x = case_when(
    Link == "AB" & Time == "pre" ~ 1 - dodge,
    Link == "AB" & Time == "post" ~ 1 + dodge,
    Link == "AX" & Time == "pre" ~ 2 - dodge,
    Link == "AX" & Time == "post" ~ 2 + dodge,
  ))

p <-ggplot(Amygdala[Amygdala$Stress=="Stress",], aes(x = Link, y = V, fill = Time))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Time),pch = 19, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  geom_line(aes(x = x, group = interaction(Code, Link)), alpha = 0.2, color = "brown4") +
  scale_fill_manual("Time",values = c("pre"="brown1", "post" = "brown4")) +
  scale_colour_manual(values=c("brown1", "brown4")) + 
  xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme +labs(y=expression(paste("Neural dissimilarity (1- ",italic("r"), ")")))

p+  ggtitle("aHC: Stress Group") + coord_cartesian(ylim = c(0.59, 1)) + scale_x_discrete(labels=c("AB" = "Link", "AX" = "NonLink"))+
  scale_y_continuous(breaks=c(".6" = .6, ".7" = .7, ".8" = .8, ".9" = .9, "1" = 1)) 


#-----------------------------------------------------------------------------------------------
### Quadratic Function ###

library(lmtest)
library("reghelper")


## Linear vs Quadratic for Stress and Controls
#Control
L1 <- lm(Mean_ARENA_Link ~ RSA_RightAntHC_AB_post, data = my_data[my_data$Stress.x == "Control",])
Q1 <- lm(Mean_ARENA_Link ~ RSA_RightAntHC_AB_post + I(RSA_RightAntHC_AB_post^2), data = my_data[my_data$Stress.x == "Control",])
summary(L1)
summary(Q1)
lrtest(L1, Q1)

#Stress
L2 <- lm(Mean_ARENA_Link ~ RSA_RightAntHC_AB_post, data = my_data[my_data$Stress.x == "Stress",])
Q2 <- lm(Mean_ARENA_Link ~ RSA_RightAntHC_AB_post + I(RSA_RightAntHC_AB_post^2), data = my_data[my_data$Stress.x == "Stress",])
summary(L2)
summary(Q2)
lrtest(L2, Q2)


## Unstandardized Models

M1 <- lm(Mean_ARENA_Link ~ RSA_RightAntHC_AB_post + I(RSA_RightAntHC_AB_post^2) + Stress.x, data = my_data)
M2 <- lm(Mean_ARENA_Link ~ RSA_RightAntHC_AB_post + I(RSA_RightAntHC_AB_post^2) + Stress.x +
           RSA_RightAntHC_AB_post*Stress.x + I(RSA_RightAntHC_AB_post^2)*Stress.x, data = my_data)

summary(M1)
summary(M2)
lrtest(M1, M2)

## z-standardized beta coefficients
beta(M1, x = TRUE, y = TRUE)
beta(M2, x = TRUE, y = TRUE)

#----------------------
## Plot Functions
fit <- lm(Mean_ARENA_Link ~ RSA_RightAntHC_AB_post+I(RSA_RightAntHC_AB_post^2), 
          data = total[total$Stress.x=="Control" &total$Condition.x=="Presentation",])
prd <- data.frame(RSA_RightAntHC_AB_post = seq(from = range(total[total$Condition.x=="Presentation"&total$Stress.x=="Control",]$RSA_RightAntHC_AB_post)[1], 
                                             to = range(total[total$Condition.x=="Presentation"&total$Stress.x=="Control",]$RSA_RightAntHC_AB_post)[2], length.out = 100))

err <- predict(fit, newdata = prd, se.fit = TRUE)
prd$lci <- err$fit - 1.96 * err$se.fit
prd$fit <- err$fit
prd$uci <- err$fit + 1.96 * err$se.fit

ggplot(prd, aes(x = RSA_RightAntHC_AB_post, y = fit)) +
  #ggtitle("Quadratic relation in controls") + xlab("Neural dissimilarity") + 
  ylab("Perceived dissimilarity \n (Euclidian distance)")+
  apatheme +
  geom_line() +
  geom_smooth(aes(ymin = lci, ymax = uci), stat = "identity",color="darkslategray4", fill = "darkslategray4") +
  geom_point(data = total[total$Condition.x=="Presentation"&total$Stress.x=="Control",], 
             aes(x = RSA_RightAntHC_AB_post, y = Mean_ARENA_Link))+ coord_cartesian(ylim = c(0, .09), xlim = c(.63, .93))+
  scale_y_continuous(breaks=c("0" = 0, ".025" = .025, ".050" = .05, ".075" = .075)) +
  labs(x=expression(paste("Neural dissimilarity (1- ",italic("r"), ")")))


#--------------------------------------
fit <- lm(Mean_ARENA_Link ~ RSA_RightAntHC_AB_post+I(RSA_RightAntHC_AB_post^2), 
          data = total[total$Stress.x=="Stress" &total$Condition.x=="Presentation",])
prd <- data.frame(RSA_RightAntHC_AB_post = seq(from = range(total[total$Condition.x=="Presentation"&total$Stress.x=="Stress",]$RSA_RightAntHC_AB_post)[1], 
                                             to = range(total[total$Condition.x=="Presentation"&total$Stress.x=="Stress",]$RSA_RightAntHC_AB_post)[2], length.out = 100))

err <- predict(fit, newdata = prd, se.fit = TRUE)
prd$lci <- err$fit - 1.96 * err$se.fit
prd$fit <- err$fit
prd$uci <- err$fit + 1.96 * err$se.fit

ggplot(prd, aes(x = RSA_RightAntHC_AB_post, y = fit)) +
  #ggtitle("Quadratic relation in stress") + xlab("Neural dissimilarity") + 
  ylab("Euclidian distance")+ coord_cartesian(ylim = c(0, .09), xlim = c(.63, .93))+
  apatheme +
  geom_line() +
  geom_smooth(aes(ymin = lci, ymax = uci), stat = "identity",color="brown3", fill = "brown3") +
  geom_point(data = total[total$Condition.x=="Presentation"&total$Stress.x=="Stress",], 
             aes(x = RSA_RightAntHC_AB_post, y = Mean_ARENA_Link))+ #coord_cartesian(ylim = c(0, .09))+
  scale_y_continuous(breaks=c("0" = 0, ".025" = .025, ".050" = .05, ".075" = .075))+
  labs(x=expression(paste("Neural dissimilarity (1- ",italic("r"), ")")))

#--------------------------------------------------------------------------------------------
### RSA results posterior HC ###

A <- as.data.frame(my_data[,c(1,2,4,71, 72, 73, 74, 104,105,106,107)])

Amygdala <- melt(A, id.vars = c("Code", "VP.x","Stress.x"),measure = names(A[c(4:11)]))
names(Amygdala) <- c("Code", "VP",  "Stress", "Neural_sim","V")

for (i in 1:(dim(Amygdala)[1])) {
  l = as.character(Amygdala$Neural_sim[i])
  if (substr(Amygdala$Neural_sim[i],12,13) == "AB" | substr(Amygdala$Neural_sim[i],17,18) == "AB") {
    Amygdala$Link[i] <- "AB"
  } else if (substr(Amygdala$Neural_sim[i],12,13) == "AX" | substr(Amygdala$Neural_sim[i],17,18) == "AX") {
    Amygdala$Link[i] <- "AX"
  } 
}

for (i in 1:(dim(Amygdala)[1])) {
  l = as.character(Amygdala$Neural_sim[i])
  if (substr(Amygdala$Neural_sim[i],15,16) == "pr" ||  substr(Amygdala$Neural_sim[i],20,21) == "pr"){#| substr(Amygdala$Neural_sim[i],13,14) == "pr") {
    Amygdala$Time[i] <- "pre"
  } else {
    Amygdala$Time[i] <- "post"
  }
}

for (i in 1:(dim(Amygdala)[1])) {
  l = as.character(Amygdala$Neural_sim[i])
  if (substr(Amygdala$Neural_sim[i],1,1) == "R") {
    Amygdala$Side[i] <- "Right"
  } else {
    Amygdala$Side[i] <- "Left"
  }
}

for (i in 1:(dim(Amygdala)[1])) {
  if (Amygdala$Stress[i] == "Stress" & Amygdala$Time[i] == "pre"){
    Amygdala$Group[i] <- "Stress Pre"
  } else if (Amygdala$Stress[i] == "Stress" & Amygdala$Time[i] == "post"){
    Amygdala$Group[i] <- "Stress Post"
  } else if (Amygdala$Stress[i] == "Control" & Amygdala$Time[i] == "pre"){
    Amygdala$Group[i] <- "Control Pre"
  } else if (Amygdala$Stress[i] == "Control" & Amygdala$Time[i] == "post"){
    Amygdala$Group[i] <- "Control Post"
  }}


Amygdala$Link=as.factor(Amygdala$Link) #define factors
Amygdala$Group=factor(Amygdala$Group,
                      levels = c("Control Pre", "Control Post", "Stress Pre", "Stress Post", ordered = TRUE))
Amygdala$Time=factor(Amygdala$Time,
                     levels = c("pre", "post", ordered = TRUE))

# For Controls right posterior
Link<-aov_car(V ~ Time*Link + Error(VP/Time*Link),
              data = Amygdala[Amygdala$Stress=="Control" & Amygdala$Side == "Right",]) #
knitr::kable(nice(Link))


Link<-aov_car(V ~ Time*Link + Error(VP/Time*Link),
              data = Amygdala[Amygdala$Stress=="Control" & Amygdala$Side == "Left",]) #
knitr::kable(nice(Link))


# Plot 
dodge = 0.15

Amygdala <- Amygdala %>%
  mutate(x = case_when(
    Link == "AB" & Time == "pre" ~ 1 - dodge,
    Link == "AB" & Time == "post" ~ 1 + dodge,
    Link == "AX" & Time == "pre" ~ 2 - dodge,
    Link == "AX" & Time == "post" ~ 2 + dodge,
  ))


# Controls
p <-ggplot(Amygdala[Amygdala$Stress=="Control" & Amygdala$Side == "Right",], aes(x = Link, y = V, fill = Time))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Time),pch = 19, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  geom_line(aes(x = x, group = interaction(Code, Link)), alpha = 0.2, color = "darkslategray4") +
  scale_fill_manual("Time",values = c("pre"="darkslategray3", "post" = "darkslategray4")) +
  scale_colour_manual(values=c("darkslategray3", "darkslategray4")) + 
  xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme +labs(y=expression(paste("Neural dissimilarity (1- ",italic("r"), ")")))

p+  ggtitle("R pHC: Control Group") + coord_cartesian(ylim = c(0.59, 1))



p <-ggplot(Amygdala[Amygdala$Stress=="Control" & Amygdala$Side == "Left",], aes(x = Link, y = V, fill = Time))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Time),pch = 19, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  geom_line(aes(x = x, group = interaction(Code, Link)), alpha = 0.2, color = "darkslategray4") +
  scale_fill_manual("Time",values = c("pre"="darkslategray3", "post" = "darkslategray4")) +
  scale_colour_manual(values=c("darkslategray3", "darkslategray4")) + 
  xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme +labs(y=expression(paste("Neural dissimilarity (1- ",italic("r"), ")")))

p+  ggtitle("L pHC: Control Group") + coord_cartesian(ylim = c(0.59, 1))


#--------------
# Stress
p <-ggplot(Amygdala[Amygdala$Stress=="Stress"& Amygdala$Side == "Right",], aes(x = Link, y = V, fill = Time))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Time),pch = 19, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  geom_line(aes(x = x, group = interaction(Code, Link)), alpha = 0.2, color = "brown4") +
  scale_fill_manual("Time",values = c("pre"="brown1", "post" = "brown4")) +
  scale_colour_manual(values=c("brown1", "brown4")) + 
  xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme +labs(y=expression(paste("Neural dissimilarity (1- ",italic("r"), ")")))

p+  ggtitle("R pHC: Stress Group") + coord_cartesian(ylim = c(0.59, 1)) + scale_x_discrete(labels=c("AB" = "Link", "AX" = "NonLink"))+
  scale_y_continuous(breaks=c(".6" = .6, ".7" = .7, ".8" = .8, ".9" = .9, "1" = 1)) 


p <-ggplot(Amygdala[Amygdala$Stress=="Stress"& Amygdala$Side == "Left",], aes(x = Link, y = V, fill = Time))+
  stat_summary(stat = 'identity', fun='mean',geom='bar', position=position_dodge(0.6), size = 1.5,width = 0.6, alpha = 0.6) +
  geom_point(aes(colour=Time),pch = 19, position = position_dodge(0.6), # new version (no more jittering)
             alpha = 0.4)+
  geom_line(aes(x = x, group = interaction(Code, Link)), alpha = 0.2, color = "brown4") +
  scale_fill_manual("Time",values = c("pre"="brown1", "post" = "brown4")) +
  scale_colour_manual(values=c("brown1", "brown4")) + 
  xlab ('') + stat_summary(fun.data = mean_se, geom = "errorbar",  position=position_dodge(0.6),width =.1)+
  apatheme +labs(y=expression(paste("Neural dissimilarity (1- ",italic("r"), ")")))

p+  ggtitle("L pHC: Stress Group") + coord_cartesian(ylim = c(0.59, 1)) + scale_x_discrete(labels=c("AB" = "Link", "AX" = "NonLink"))+
  scale_y_continuous(breaks=c(".6" = .6, ".7" = .7, ".8" = .8, ".9" = .9, "1" = 1)) 


#-----------------------------------------------------------------------------------------------
### Control variables ### 

library(matrixTests)
library(dplyr)

Stress <- my_data %>% filter(Stress.x == "Stress") %>% 
           dplyr::select(STAI_TRAIT_SUM, STAI_STATE_SUM,
           PSQI_GW, TICS_SSCS, BDI_SUM, BFI_SUM_E, BFI_SUM_N,
           BFI_SUM_O, BFI_SUM_G,BFI_SUM_V)
  

Control  <- my_data %>% filter(Stress.x == "Control") %>% 
           dplyr::select(STAI_TRAIT_SUM, STAI_STATE_SUM,
                PSQI_GW, TICS_SSCS, BDI_SUM, BFI_SUM_E, BFI_SUM_N,
                BFI_SUM_O, BFI_SUM_G,BFI_SUM_V)

result <- col_t_welch(Stress, Control)

#----------------------------------------------------------------------------------------------
### Working memory pre and post stress ###

Stress <- my_data %>% filter(Stress.x == "Stress") %>% 
  dplyr::select(NbackPreAcc_3, NbackPreRT_3,
                NbackPreAcc_4, NbackPreRT_4, 
                NbackPostAcc_3, NbackPostRT_3, 
                NbackPostAcc_4,NbackPostRT_4)


Control  <- my_data %>% filter(Stress.x == "Control") %>% 
  dplyr::select(NbackPreAcc_3, NbackPreRT_3,
                NbackPreAcc_4, NbackPreRT_4, 
                NbackPostAcc_3, NbackPostRT_3, 
                NbackPostAcc_4,NbackPostRT_4)

result <- col_t_welch(Stress, Control)


