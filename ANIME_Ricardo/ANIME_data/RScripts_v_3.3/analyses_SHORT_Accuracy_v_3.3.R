source("libraries_v_3.3.R")

iChart <- readiChart()

# define onset and reject prescreen
iChart <- defineOnset(iChart[iChart$Prescreen.Notes == "",], critonset=0, includeAways=FALSE)

# compute gaps
iChart <- computeStatistics(iChart, startWindow=0, endWindow=2200)

# reject trials with extreme RT and gaps
iChart <- filteriChart(iChart, minRT=300, maxRT=1800, maxfirstgap=15, maxlonggap=15)


# get mean accuracy
accuracy <- poolData(meanAccuracy(iChart[!(iChart$Sub.Num %in% c("6835", "6800", "6763")),], startWindowAcc=300, endWindowAcc=4300), RejectFirstGap=TRUE, RejectLongestGap=TRUE, RejectRT=FALSE, color=TRUE, dependent="Accuracy", group="", facet="", dodge="", xlab="", ylab= "Proportion\n  Looking\n  to target", paired=TRUE, miny = 0.2, maxy = 0.80, size=12, legend.direction = "horizontal", legend.position="bottom", breaks=c(0.25, 0.50, 0.75))

vocab <- read.csv("~/Documents/ANIME/AniME.newCDI.csv")
vocab <- read.csv("~/Documents/ANIME/AniMOO.CDI.new.csv")
mergedANIME <- merge(vocab, accuracy, by.x = "ParticipantId", by.y="Sub.Num")
correlations(mergedANIME[, c(1, 9, 11, 12, 13, 14, 15)])


correlations(mergedANIME[, 8:17])

# reject subjects

iChart2 <- iChart[!(iChart$Sub.Num %in% c("6835", "6800", "7040", "7077")),]

# stats
chance(accuracy)
t.tests(accuracy)
correlations(accuracy)

# create PP plots
createPlots(iChart[iChart$Condition == "name" & iChart$Novel == "Familiar",], startWindow=0, endWindow=4300, RejectLongestGap=TRUE, RejectFirstGap=FALSE, RejectRT=FALSE, color=TRUE, smooth=200, targetEnd=800, carrier="Where's the", targets=c("b a l l", "d o f a"), group="Order",  plotStats="PP", miny = 0.30, maxy=0.85, size=15, legend.direction = "horizontal", legend.position=c(0.7, 0.95), breaks=c(0.25, 0.50, 0.75), x.target=0.33)



