###########################################

# This script analyzes iChart data from the Looking-while-listening procedure
# Ricardo A. H. Bion, October, 2009
# Updated (with VM) January/February/March, 2010
# Updated (with VM) September 2010

############################################

# All comments are identified by # at the beginning of the line.
# We have provided multiple versions of various commands.  Simply remove comment indicator (#),
# highlight relevant text, and indicate "Run Line or Selection Ctl-R"

########## LOAD LIBRARIES ##########

# load libraries from the file
#source("libraries_v_3.3.R")

# or provide the path
source("~/Downloads/RScripts_v_3.3/libraries_v_3.3.R")


########## READ ICHART ##########

# Read in your iChart. Will use D/T/A information as defined in your current i-chart.
# All outputs of scripts will be stored in the same directory as the iChart.

# The following command will open a dialog box and prompt the user to select the i-chart file. 
iChart <- readiChart()

# or you can provide the path directly 
# iChart <- readiChart("c:/yourdirectory/youricharts/ichart.txt")

# use one of these functions to read an iChart previously saved with this R script
# iChart <- re.readiChart() 
# iChart <- re.readiChart("c:/yourdirectory/youricharts/ichart.txt")

######### CHECK ICHART ##########

# This function will report on the contents of a working file.  The command will report on
# the number of lines (rows) in the file, the number of D, T and A responses, the number of
# participants, and number of conditions.  The output will also list each participant and the
# number of trials per condition.  This function can be read at any time during the analysis
# process.

check(iChart)

# Additional useful commands are:

# provides the number of rows in the current iChart
nrow(iChart)

# lists the subjects in the iChart
unique(iChart$Sub.Num)

# provides the number of unique subjects in the iChart
length(unique(iChart$Sub.Num))

# lists the unique conditions in the iChart
unique(iChart$Condition) 

# provides the number of unique conditions in the iChart
length(unique(iChart$Condition))

# gives a crosstabs with the number of trials per subject.
xtabs(~Sub.Num, data=iChart)

# gives a crosstab with the number of trials per subject per condition
xtabs(~Sub.Num+Condition, data=iChart) 

# prints out the first few lines of the iChart
head(iChart)


########## SET RESPONSES ##########

# Do this step if you want the script to re-define D/T/A based on a critonset value that you have defined here.
# F0 is based on identifying information in column header in original or cleaned i-chart.
# Use order files to set F0 at critical onset (e.g., noun, adjective) and then define here critical onset
# value or offset by a fixed amount (e.g., 300)
# For example, if you used F0 to define responses for your first pass, and now you want to re-define responses at F300.  
# This command will write over response column with new D/T/A values.

# Indicate frame to define D/T in relation to critical onset (F0)

critonset <- 0
#critonset <- 300 # for defining D/T at F300

# Decide whether aways should be included in the analyses. If yes, A becomes D.
# includeAways <- TRUE
includeAways <- FALSE

iChart <- defineOnset(iChart, critonset, includeAways)


########## BACKFILL ##########

# Run this script if you want to re-define responses based on backfilling (not recommended)
# framesToBackFill <- 0 # number of frames to backfill
# iChart <- backFill(iChart, critonset, framesToBackFill)


########## USE ONLY KNOWN WORDS ##########

# Run these lines if you want to select only those words the child is reported to "know."  You can determine
# the status of known words using either "understands" or "says."  
# You will be prompted to identify the file with the known words information. 
# Make sure your file with words known follows the correct format (see example on web site).  
# For example, on a 4-point scale, any value 3 or higher is coded as "known." On a 2 point scale where
# 1 = understands and 0 is says, the minimum value is 1.

minUnderstands <- 3 # min value for the word to be considered as understood by the child.
minSays <- 3 # min value for the word to be considered as produced by the child.
 
#iChart <- useKnown(iChart, minUnderstands, minSays)


########## REJECT PRESCREEN ##########

# Removes trials from i-chart
# Selects out trials based on prescreening information
# Using standard pre-screening criteria, all trials with prescreening info in notes field should be excluded.
# Running first command will include only non-prescreened out trials.
iChart <- iChart[iChart$Prescreen.Notes == "",] # Only include trials in which prescreen notes field is blank

# OR

# Use any of the following commands to exclude trials with other prescreening info.

#iChart <- iChart[iChart$Prescreen.Notes != "Fidgeting, Fussy",]
# iChart <- iChart[iChart$Prescreen.Notes != "Not Looking Before Critical Word",]
# iChart <- iChart[iChart$Prescreen.Notes != "Child Talking",]
# iChart <- iChart[iChart$Prescreen.Notes != "Parent Interfering",]
# iChart <- iChart[iChart$Prescreen.Notes != "Eyes Not Visible",]
#iChart <- iChart[iChart$Prescreen.Notes != "Inattentive",]
# iChart <- iChart[iChart$Prescreen.Notes != "Aborted Trial",]
# iChart <- iChart[iChart$Prescreen.Notes != "Equipment Malfunction",]
# iChart <- iChart[iChart$Prescreen.Notes != "Other Interference"]

########## REJECT PARTICIPANTS ##########

# Defines which participants to exclude (if any).  You can either use numeric or string IDs.

# participants <- c(num1, num2, num3) # if participant IDs are numeric
# participants <- c("ID1", "ID2", "ID3") # if participant IDs are strings
# iChart <- removeParticipants(iChart, participants)

########## RENAME OR COLLAPSE CONDITIONS ##########

# Use these commands to collapse across conditions or rename in your order file.  For example, if your
# order file distinguishes between "NovelFamiliar1" (1st novel word) and NovelFamiliar2 (2nd novel word), you 
# will need to collapse across these conditions.   You could change the condition names in the original i-Chart as well.

# oldCondition should be a vector with the names of conditions to be renamed
oldCondition <- c("FF", "FN", "NF", "NT", "FamiliarFamiliar1", "FamiliarFamiliar2", "FamiliarNovel1", "FamiliarNovel2")

# newCondition should be a vector with the same length as oldCondition, with the new names of the conditions
newCondition <- c("Familiar vocalization", "Familiar vocalization", "Disambiguation", "Retention", "FF", "FF", "FN", "FN")

iChart <- renameCondition(iChart, oldCondition, newCondition)

########## SELECT CONDITIONS ##########

# selects only some specific condition that is inside c("cond1", "cond2", "...")
#iChart <- iChart[iChart$Condition %in% c("TestLF", "TestHF"),]

########## RENAME OR COLLAPSE ITEMS ##########

# Use this command to collapse across items in your order file.  For example, the order file distinguishes
# between "doggie1" (1st instance of doggy) and "doggie2"(2nd instance of doggy).

# oldItem should be a vector with the names of conditions to be renamed
# oldItem <- c("doggie1", "doggie2", "doggie3", "doggie4")

# newItem should be a vector with the same length as oldCondition, with the new names of the conditions
# newItem <- c("doggie", "doggie", "doggie", "doggie")

# iChart <- renameItem(iChart, oldItem, newItem)

########## SELECT ITEMS ##########

# selects only some specific condition that is inside c("item1", "item2", "...")
#iChart <- iChart[iChart$Target.Image %in% c("doggie", "baby"),]


########## DEFINE BLOCKS BASED ON TRIALS ##########

#iChart$Block[as.numeric(iChart$Tr.Num) < 11] <- "Block_1" # Block 1 consists of trial nums < 10.
#iChart$Block[as.numeric(iChart$Tr.Num >= 10) & as.numeric(iChart$Tr.Num <= 20)] <- "Block_2"  # Block 2 consists of trials 11-20.
#iChart$Block[as.numeric(iChart$Tr.Num > 20)] <- "Block_3"  # Block 3 consists of trials 21+

# condition becomes block
#iChart$Condition <- iChart$Block

# condition is combined with block
#iChart$Condition <- paste(iChart$Condition, iChart$Block, sep="_")

########## ITEM ANALYSES ##########

# condition becomes item
#iChart$Condition <- iChart$Target.Image

# condition is combined with block
#iChart$Condition <- paste(iChart$Condition, iChart$Target.Image, sep="_")

########## ORDER ANALYSES ##########

#iChart$Block[iChart$Order %in% c("FrIndy1", "FrIndy3", "FrIndy5", "FrIndy7")] <- "odd" #select the orders that are odd, and renames them
#iChart$Block[iChart$Order %in% c("FrIndy2", "FrIndy4", "FrIndy6", "FrIndy8")] <- "even" #selects the orders that are even, and renames them
#iChart$Block[iChart$Order == "OrderA"] <- "OrderA"

# condition becomes order
#iChart$Condition <- iChart$Order

# condition is combined with order
#iChart$Condition <- paste(iChart$Condition, iChart$Order, sep="_")

########## COMPUTE STATISTICS ##########

# The following computes descriptive statistics used for either # cleaning or analysis purposes.  Since all legitimate RTs are
# based on shifts that both begin and land within the cleaning
# window, we typically establish a cleaning window that is 500
# msec longer than the upper end of the RT window.  For example,
# for an RT window that includes only RTs within 300-1800 msec,
# the cleaning window is 0-2300 (1800 + 500)
# Compute descriptive statistics (RT, Accuracy, FirstGap, LongestGap, LongestGapPosition, StartofLongestLook_T, Dur of Longest fixation, LongestLookTD)

# Define cleaning window over which descriptive stats are computed and saved in i-chart based on start/end window

startWindow <- 0 # starting from F0, mark first frame of the analyses window
endWindow <- 2200 # starting from F0, mark end of the analyses window

iChart <- computeStatistics(iChart, startWindow, endWindow)


######### GET MEAN ACCURACY PER TRIAL ######

# Define accuracy window

startWindowAcc <- 300
endWindowAcc <- 1800

# calculate accuracy per trial using defined accuracy window
iChart <- meanAccuracy(iChart, startWindowAcc, endWindowAcc)



########## GET SUMMARY STATISTICS ##########

# Save summary statistics (min, 1st quartile, median, 3rd quartile, M, max, SD) based on raw iChart in text file
# You must indicate one additional quartile cut-off (e.g., 90th) here:

iChart_quartile <- 0.90

# Save summary statistics in graphic form in pdf file

getSummaryStats(iChart, iChart_quartile)


########## FILTER ICHART ##########

# The following commands identify trials as "good" depending on the cleaning criteria.

# Filter iChart - based on descriptives from computeResponses function, choose which trials meet criteria for inclusion
# Trials that meet these filtering criteria will be flagged in the filtered ichart in new columns called GoodRT, GoodFirstGap, GoodLongGap

maxRT <- 1800 # highest accepted RT (inclusive), either as raw msec value or as percentile value, e.g., .95
minRT <- 300 # lowest accepted RT (inclusive)
maxfirstgap <- 9 # max number of frames in the first shift, above which trial is rejected
maxlonggap <- 15 # max number of frames in the longest gap, above which trial is rejected (i.e., number of frames away)

iChart <- filteriChart(iChart, minRT, maxRT, maxfirstgap, maxlonggap)


########## POOL RT OVER SUBJECTS ##########

# Decide which filtering criteria you want for rejecting trials for computation of Mean RT over subjects

RejectFirstGap <- TRUE # Reject trials with first gaps that exceed maxfirstgap value (defined above)
# RejectFirstGap <- FALSE # DO NOT reject trials with first gaps that exceed maxfirstgap value (defined above)

RejectLongestGap <- TRUE # Reject trials with longest gaps that exceed maxlonggap value (defined above)
# RejectLongestGap <- FALSE # DO NOT reject trials with longest gaps that exceed maxlonggap value (defined above)

RejectRT <- TRUE	# Reject trials with min/max values outside of RT window (defined above, inclusive)
# RejectRT <- FALSE # DO NOT reject trials with min/max values outside of RT window (defined above, inclusive)

# color in plot
color <- TRUE

# define grouping variable for RT
# look at the plot online to understand what each value is doing
# if you leave them all empty, you will get your standard accuracy plot

# legend
#group <- ""
group <- ""

# separate plots
#facet <- "Condition"
facet <- ""

# same plot
#dodge <- "Vocab"
dodge <- "Response"

# define the dependent variable
dependent <- "RT"

xlab = ""
ylab = "mean RT (ms)"

# save results paired
paired = TRUE

RT <- poolData(iChart, RejectFirstGap, RejectLongestGap, RejectRT, color, dependent, group, facet, dodge, xlab, ylab)


########## POOL ACCURACY OVER SUBJECTS ##########

# Decide which filtering criteria you want for rejecting trials for computation of Mean Accuracy over subjects

RejectFirstGap <- TRUE # Reject trials with long first gaps
# RejectFirstGap <- FALSE # DO NOT reject trials with long first gaps

RejectLongestGap <- TRUE # Reject trials with long longest gaps
# RejectLongestGap <- FALSE # DO NOT reject trials with long longest gaps

# RejectRT <- TRUE	# Reject trials with min/max values outside of RT window (defined above, inclusive)
RejectRT <- FALSE # DO NOT reject trials with min/max values outside of RT window (defined above, inclusive)

# color in plot
color <- TRUE

# define grouping variable for accuracy
# look at the plot online to understand what each value is doing
# if you leave them all empty, you will get your standard accuracy plot

# legend
#group <- "Months"
group <- ""

# separate plots
#facet <- "Condition"
facet <- ""

# same plot
#dodge <- "Vocab"
dodge <- ""

# define the dependent variable
dependent <- "Accuracy"

xlab = ""
ylab = "Proportion\n  Looking\n  to target"

# save results paired
paired = TRUE

accuracy <- poolData(iChart, RejectFirstGap, RejectLongestGap, RejectRT, color, dependent, group, facet, dodge, xlab, ylab, paired)


########## READ CDI ##########

# Read in a text file with CDI information to be merged with means over subjects.
# ID must be first column; will take variable names from the header in text file (i.e., 
# will use variable names provided by CDI scoring program).  Abuts CDI information to means over subjects.
# leave it as FALSE in case you do not want to include CDI information

# CDI <- readCDI()
CDI <- FALSE

########## COMBINE RT/ACCURACY WITH CDI VARIABLES IN SINGLE OUTPUT ##########

# create a single paired table with different variables, e.g., RT, Accuracy and CDI (if available)

combinedData <- combineData(iChart, accuracy, RT, CDI)

# you can combine any two paired files or variables - unselect file1, file2, and combined files if running this function
#file1 <- file.choose()
#file2 <- file.choose()
header1 <- "Acc3001800"
header2 <- "Acc18332500"
filename <- "combinedFile.txt"


#combinedFiles <- combineFiles(file1, file2, header1, header2, save_as = paste(iChart$Directory[1], filename , sep=""))

########## PLOT ##########

# Create OC and Profile plots; Will save graph values as output file.

# RejectFirstGap <- TRUE
RejectFirstGap <- FALSE

RejectLongestGap <- TRUE # Reject trials with long longest gaps
# RejectLongestGap <- FALSE # DO NOT reject trials with long longest gaps

# RejectRT <- TRUE # Reject trials with min/max values outside of RT window (defined above, inclusive)
RejectRT <- FALSE # DO NOT reject trials with min/max values outside of RT window (defined above, inclusive)

# Define the x-axis values for plots

startWindow <- 0
endWindow <- 1800
color <- TRUE


# defines interval for plotting error bars
# higher values make the graph easier to read
# 33 plots all the values
smooth <- 200

# define carrier phrases and nouns to be plotted on the graph
carrier <- "Where's the"   # carrier phrase to appear in the PP - leave empty for no carrier
targets <- c("ball", "dofa")   # targets to be drawn in the PP - leave empty for no carrier
targetEnd <- 800   # end of the target to appear in the PP


# give a value if you want to have a grouping variable for PP
# leave it empty if you want your standard profile plot
# the grouping variable must be the name of a column on the iChart

#group <- "Months"    # group by month
group <- ""  # NO grouping

# define the kind of plot, options are PP, OC, OC_D, OC_T

# create OC plot
plotStats = "OC"

createPlots(iChart, startWindow, endWindow, RejectLongestGap, RejectFirstGap, RejectRT, color, smooth, targetEnd, carrier, targets, group,  plotStats)

# create OC plot just for D trials
plotStats = "OC_D"

createPlots(iChart, startWindow, endWindow, RejectLongestGap, RejectFirstGap, RejectRT, color, smooth, targetEnd, carrier, targets, group,  plotStats)

# create OC plot just for T trials
plotStats = "OC_T"

createPlots(iChart, startWindow, endWindow, RejectLongestGap, RejectFirstGap, RejectRT, color, smooth, targetEnd, carrier, targets, group,  plotStats)

# create Profile Plot
plotStats = "PP"

createPlots(iChart, startWindow, endWindow, RejectLongestGap, RejectFirstGap, RejectRT, color, smooth, targetEnd, carrier, targets, group,  plotStats)

########## INFERENTIAL STATISTICS ##########

# compare accuracy against chance
chance(accuracy)

# t.test of accuracy in all conditions. Change paired to FALSE if between subjects
t.tests(accuracy, paired=TRUE)

# t.test of RT in all conditions. Change paired to FALSE if between subjects
t.tests(RT, paired=TRUE)

# correlation of RT, accuracy, and (if added) CDI
correlations(combinedData)

########## DONE ##########
