source("libraries_v_3.3.R")

iChart1 <- readiChart("/Users/ricardoh/Dropbox/ANIME/ANIME_A.txt")
iChart2 <- readiChart("/Users/ricardoh/Dropbox/ANIME/ANIME_B.txt")

iChart3 <- readiChart("/Users/ricardoh/Dropbox/ANIME/ANIMERetention.txt")

iChart1$Sound <- 


iChart1$Novel <- ifelse(iChart1$Condition %in% c("PNF", "NF"), "Novel", "Familiar")
iChart1 <- renameCondition(iChart1, c("vanilla", "sounds", "NF","FN","Pvanilla","Psounds","PNF","PFN"), 
          c("name","onomatopoeic word", "name NF","name FN","name","onomatopoeic word","name NF","name FN"))


iChart2 <- renameCondition(iChart2, c("FN", "NF"), 
                           c("vocalization FN", "vocalization NF"))



iChart2$Novel <- ifelse(iChart2$Condition %in% c("NF"), "Novel", "Familiar")
iChart2$Condition <- "vocalization"

merge(iChart1, iChart2, by = intersect(names(iChart1), names(iChart2)), all.x=TRUE, all.y=TRUE) -> iChart

iChart3 <- renameCondition(iChart3, c("FF","FN","NF","NT","E"), c("Familiar","Familiar","Disambiguation","Retention",NA))


# define onset and reject prescreen
iChart3 <- defineOnset(iChart3[iChart3$Prescreen.Notes == "",], critonset=0, includeAways=TRUE)

# compute RT and gaps
iChart <- computeStatistics.TEST(iChart, startWindow=0, endWindow=2200)

# reject trials with extreme RT and gaps
iChart <- filteriChart(iChart, minRT=200, maxRT=1800, maxfirstgap=15, maxlonggap=15)

# get mean RT
RT <- poolData(iChart[iChart$Response == "D" & iChart$Novel == "Familiar",], RejectFirstGap=TRUE,
               RejectLongestGap=TRUE, RejectRT=TRUE, color=TRUE, 
               dependent="RT", group="", facet="", dodge="", xlab="", 
               ylab="mean RT (ms)", paired=TRUE, miny = 400, maxy=1300, 
               size=18, legend.direction = "horizontal", 
               legend.position="bottom", breaks=c(400, 800, 1200))


[iChart$Condition %in% c("name NF", "name FN", "vocalization NF", "vocalization FN"),]

accuracy <- poolData(meanAccuracy(iChart3, 
            startWindowAcc=300, endWindowAcc=4300), RejectFirstGap=FALSE, 
            RejectLongestGap=FALSE, RejectRT=FALSE, color=TRUE, dependent="Accuracy", 
            group="", facet="", dodge="", xlab="", ylab= "Proportion\n  Looking\n  to target",
            paired=TRUE, miny = 0.2, maxy = 0.80, size=12, legend.direction = "horizontal", 
            legend.position="bottom", breaks=c(0.25, 0.50, 0.75))

#stats
t.tests(RT)
correlations(RT)

# create OC plot T
createPlots(iChart, startWindow=0, endWindow=1800, RejectLongestGap=TRUE, RejectFirstGap=FALSE, RejectRT=FALSE, color=TRUE, smooth=200, targetEnd=800, carrier="Where's the", targets=c("b a l l", "d o f a"), group="",  plotStats="OC_T", miny = 0, maxy=0.85, size=15, legend.direction = "horizontal", legend.position=c(0.7, 0.95), breaks=c(0.25, 0.50, 0.75), x.target=0.33)

# create OC plot D
createPlots(iChartTEMP[iChartTEMP$Novel == "Familiar",], startWindow=0, endWindow=1800, RejectLongestGap=TRUE, RejectFirstGap=FALSE, RejectRT=FALSE, color=TRUE, smooth=200, targetEnd=0, carrier="Which one...", targets=c(""), group="",  plotStats="OC_D", miny = 0, maxy=0.99, size=18, legend.direction = "horizontal", legend.position=c(0.7, 0.95), breaks=c(0.25, 0.50, 0.75), x.target=0.33)