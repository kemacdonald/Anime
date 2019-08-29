source("libraries_v_3.2.R")

iChart <- readiChart()

# define onset and reject prescreen
iChart <- defineOnset(iChart[iChart$Prescreen.Notes == "",], critonset=0, includeAways=FALSE)

# compute RT and gaps
iChart <- computeStatistics(iChart, startWindow=0, endWindow=2200)

# reject trials with extreme RT and gaps
iChart <- filteriChart(iChart, minRT=300, maxRT=1800, maxfirstgap=15, maxlonggap=15)

# get mean RT
RT <- poolData(iChart, RejectFirstGap=TRUE, RejectLongestGap=TRUE, RejectRT=TRUE, color=TRUE, dependent="RT", group="", facet="", dodge="Response", xlab="", ylab="mean RT (ms)", paired=TRUE, miny = 400, maxy=1300, size=13, legend.direction = "horizontal", legend.position="bottom", breaks=c(400, 800, 1200))

#stats
t.tests(RT)
correlations(RT)

# create OC plot T
createPlots(iChart, startWindow=0, endWindow=1800, RejectLongestGap=TRUE, RejectFirstGap=FALSE, RejectRT=FALSE, color=TRUE, smooth=200, targetEnd=800, carrier="Where's the", targets=c("b a l l", "d o f a"), group="",  plotStats="OC_T", miny = 0, maxy=0.85, size=15, legend.direction = "horizontal", legend.position=c(0.7, 0.95), breaks=c(0.25, 0.50, 0.75), x.target=0.33)

# create OC plot D
createPlots(iChart, startWindow=0, endWindow=1800, RejectLongestGap=TRUE, RejectFirstGap=FALSE, RejectRT=FALSE, color=TRUE, smooth=200, targetEnd=800, carrier="Where's the", targets=c("b a l l", "d o f a"), group="",  plotStats="OC_D", miny = 0, maxy=0.85, size=15, legend.direction = "horizontal", legend.position=c(0.7, 0.95), breaks=c(0.25, 0.50, 0.75), x.target=0.33)