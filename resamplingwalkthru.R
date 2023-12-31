#########################################
# GDS 2023/10/16 Resampling Walkthrough #
#########################################

library(adegenet)

## READING IN THE GENIND FILE ## 
# Change the filepath below to the filepath for your particular system
QUAC.MSAT.filepath <- "C:/Users/gsalas/Documents/resampling_CIs/Code/Datasets/QUAC_woK_allpop_clean.gen"

# QUESTION 1: What does the ncode argument signify? How can you find out?
  # Number of characters used to code an allele. Information on ncode can be found on the help tab by typing ?read.genepop
QUAC.MSAT.genind <- read.genepop(QUAC.MSAT.filepath, ncode = 3)

# "G" means garden, and the "W" means wild
QUAC.MSAT.genind@pop
# rename the populations to be "garden" or "wild" based on the G or W in the current string
# Correct garden popNames
levels(QUAC.MSAT.genind@pop)[grep(pattern = "QAc-G-", levels(QUAC.MSAT.genind@pop))] <-
  rep("garden", length(grep(pattern = "QAc-G-", levels(QUAC.MSAT.genind@pop))))
# Correct wild popNames
levels(QUAC.MSAT.genind@pop)[grep(pattern = "QAc-W-", levels(QUAC.MSAT.genind@pop))] <-
  rep("wild", length(grep(pattern = "QAc-W-", levels(QUAC.MSAT.genind@pop))))
# Recall the populations, to make sure they look better
QUAC.MSAT.genind@pop

## BUILDING THE ALLELE FREQUENCY VECTOR ##
# familiarize yourself with the parts of a genind object by looking at the printed output:
QUAC.MSAT.genind

# QUESTION 2: What are the rows of the genind@tab object? What are the columns?
  # the rows of the genind@tab object are individuals and the columns are alleles. 
  # this is shown by the printed output of the genind object.
  # the basic content of the printed output shows that the @tab consists
  # of a matrix (441 x 180) which corresponds with the same numbers above the basic
  # content section which explicitly states 441 individuals and 180 alleles. 
QUAC.MSAT.genind@tab

# All individuals
# QUESTION 3: How many copies of the allele PIE125.154 are found in this set of Q. acerifolia individuals?
  # 76 copies of the allele are found throughout this population.
  # Sum of the copies of the alleles can be found by using the sum() function 
  # for the required set of QUAC individuals and by also ensuring that all NA values are removed 
  # setting the na.rm logical statement to TRUE. 
sum(QUAC.MSAT.genind@tab[,"PIE125.154"], na.rm = TRUE)

# QUESTION 4: What's the frequency of PIE125.154 (A1Frequency=A1Copies/(N∗2))
  # the frequency of PIE125.154 is 0.0861678 represented as a proportion.
  # this is calculated by the quotient of the sum of all the allele copies for PIE125.154
  # over the total individuals in the population (# note: nrow and nIND print the same output):
sum(QUAC.MSAT.genind@tab[,"PIE125.154"], na.rm = TRUE)/(nInd(QUAC.MSAT.genind)*2)
                                                         
# QUESTION 5: What would you use to obtain all of the allele frequencies?
  # To obtain the frequencies for each allele, it is necessary to calculate the sum of the 
  # copies across all individuals (using colSums() within QUAC.MSAT.genind@tab 
  # and ensuring NA values are removed by setting the na.rm logical statement to TRUE)
  # over the total individuals in the population.
(colSums(QUAC.MSAT.genind@tab, na.rm = TRUE))/(nInd(QUAC.MSAT.genind)*2)

# QUESTION 6: How many alleles have frequencies which are greater than 10%
  # 41 alleles have frequencies greater than 10%.
length(which(((colSums(QUAC.MSAT.genind@tab, na.rm = TRUE))/(nInd(QUAC.MSAT.genind)*2))>0.1))

# Wild Individuals
# Build a matrix of garden samples by finding the rows for "which" the pop value equals "garden
gardenRows <- which(QUAC.MSAT.genind@pop == "garden")
gardenSamples <- QUAC.MSAT.genind@tab[gardenRows,]
# Complete the lines below to build a matrix of wild samlpes
wildRows <- which(QUAC.MSAT.genind@pop == "wild")
wildSamples <- QUAC.MSAT.genind@tab[wildRows,]

# QUESTION 7: How many copies of allele PIE125.154 are found in the wild QUAC population?
  # 22 copies of the allele are found throughout the wild individuals
  # Sum of the copies of the allele are found by using the sum() function
  # for the set of wild QUAC individuals and by also ensuring that all NA values
  # are removed by setting the na.rm logical statement to TRUE.
sum(wildSamples[,"PIE125.154"], na.rm = TRUE)

# QUESTION 8: What's the wild allele frequency of PIE125.154
  # 0.06707317
(sum(wildSamples[,"PIE125.154"], na.rm = TRUE))/(nrow(wildSamples)*2)

# QUESTION 9: What would you use to obtain the allele frequencies for all alleles found in the wild?
  # To obtain the frequencies for each allele, it is necessary to calculate the quotient of 
  # the sum of the copies of all wild individuals over the total number of wild individuals.
  # There were two approaches to remove zero values, 
  # APPROACH 1: Frequency values equal to zero are replaced with NA which allows
  # them to be omitted using na.omit(). This is stored in the R environment for later calculations
wildComplete <- (colSums(wildSamples, na.rm = TRUE)/(nrow(wildSamples)*2))
wildComplete[wildComplete == 0] <- NA
wildSubset  <- na.omit(wildComplete)
wildSubsetA1 <- wildSubset
  # APPROACH 2: Subset using logical condition 
wildComplete <- colSums(wildSamples, na.rm = TRUE)/(nrow(wildSamples)*2) 
wildSubsetA2 <- wildComplete[wildComplete > 0]
# QUESTION 10: How many alleles are there which have frequencies greater than 10% in the wild?
  # 42 alleles have frequencies greater than 10%
length(which(wildSubsetA1>0.1))

## EX SITU REPRESENTATION ##

# All alleles
# QUESTION 11: Which alleles have frequencies greater than 0% in the wild?
  # 133
names(which(wildSubsetA1 > 0))

# QUESTION 12: Which alleles have frequencies greater than 0% in the garden?
  # names of alleles with frequencies greater than 0% are found using the following code:
  # code can then be 
gardenComplete <- colSums(gardenSamples, na.rm = TRUE)/(nrow(gardenSamples)*2) 
gardenSubset <- gardenComplete[gardenComplete > 0]
names(which(gardenSubset > 0))

# length(which(colSums(wildSamples, na.rm = TRUE) > 0))
# length(which((colSums(wildSamples, na.rm = TRUE)/(nrow(wildSamples)*2)) > 0.1)) 


# QUESTION 13: Which alleles with wild frequencies greater than 0% are also found in the garden?
  # 
names(wildSubsetA1[which(names(wildSubsetA1 > 0) %in% names(gardenSubset > 0))])

# QUESTION 14: How many alleles with wild frequencies greater than 0% are also found in the garden?
  # which() function will output the position number in the vector for alleles in the wild > 0% when specified using a logical condition. 
  # names() function will extract the wild allele names associated with the vector position 
  # %in% identifies rare alleles in the wild that are also found in the garden. in order to do that,
  # names() also has to be applied to gardenSubset. if we were to call 
  # names(which(wildSubsetA1 > 0%)) %in% names(gardenSubset) the output is logical statements (TRUE or FALSE)
  # the which() function from earlier that identified rare alleles at vector position in the wild population 
  # can be subset to only extract named numerics where the conditional statement is TRUE
which(wildSubsetA1 > 0)[names(which(wildSubsetA1 > 0)) %in% names(gardenSubset)]
  # names() function can be used again to extract the allele names.
names(which(wildSubsetA1 > 0)[names(which(wildSubsetA1 > 0)) %in% names(gardenSubset)])
  # if we want to check whether the alleles from the wild also identified in the 
  # garden extracted are indeed greater than 0%, we can subset wildSubsetA1
length(wildSubsetA1[which(wildSubsetA1 > 0)[names(which(wildSubsetA1 > 0)) %in% names(gardenSubset)]])
  # this approach is NOT correct
length(which(names(wildSubsetA1 > 0) %in% names(gardenSubset > 0)))


# QUESTION 15: What proportion of alleles with frequencies in the wild greater than 0% are found in gardens?
  # The proportion of alleles with frequencies in the wild greater than 0% found in gardens is 0.962406

length(wildSubsetA1[which(wildSubsetA1 > 0)[names(which(wildSubsetA1 > 0)) %in% names(gardenSubset)]])/length(which(wildSubsetA1 > 0))

##  ALLELES OF DIFFERENT CATEGORIES ##
# QUESTION 16: Which alleles have frequencies less than 1% in the wild?
  #
names(which(wildSubsetA1 < 0.01))

# QUESTION 17: Which alleles with wild frequencies less than 1% are also found in the garden?
  # this approach is layered and slightly more complex. 
  # which() function will output the position number in the vector for alleles in the wild < 1% when specified using a logical condition. 
  # names() function will extract the wild allele names associated with the vector position 
  # %in% identifies rare alleles in the wild that are also found in the garden. in order to do that,
  # names() also has to be applied to gardenSubset. if we were to call 
  # names(which(wildSubsetA1 < 0.01)) %in% names(gardenSubset) the output is logical statements (TRUE or FALSE)
  # the which() function from earlier that identified rare alleles at vector position in the wild population 
  # can be subset to only extract named numerics where the conditional statement is TRUE
which(wildSubsetA1 < 0.01)[names(which(wildSubsetA1 < 0.01)) %in% names(gardenSubset)]
  # names() function can be used again to extract the allele names.
names(which(wildSubsetA1 < 0.01)[names(which(wildSubsetA1 < 0.01)) %in% names(gardenSubset)])
  # if we want to check whether the alleles from the wild also identified in the 
  # garden extracted are indeed less than 1%, we can subset wildSubsetA1
wildSubsetA1[which(wildSubsetA1 < 0.01)[names(which(wildSubsetA1 < 0.01)) %in% names(gardenSubset)]]

# QUESTION 18: How many alleles with wild frequencies less than 1% are also found in the garden?
  # 19 
length(which(wildSubsetA1 < 0.01)[names(which(wildSubsetA1 < 0.01)) %in% names(gardenSubset)])

# QUESTION 19: What proportion of alleles with frequencies of less than 1% in the wild are found in gardens?
  # 0.826087
length(wildSubsetA1[which(wildSubsetA1 < 0.01)[names(which(wildSubsetA1 < 0.01)) %in% names(gardenSubset)]])/length(which(wildSubsetA1 < 0.01))

## RESAMPLING ##

# All alleles, 2 specific samples
# instead of asking you to look at all garden samples, you need to provide answers to the same questions for the 2 wild samples listed below
sampleTest_2 <- QUAC.MSAT.genind@tab[c("QAc-W-0011", "QAc-W-0091"),]
# QUESTION 20: How many alleles in the wild are also found in Samples 11 and 91?
  # 37 alleles in the wild are also found in Samples 11 and 91
  # colSums is a function that calculates the sum of the values in each column. in our case, we are calculating
  # the sum of copies (value) at every allele (column) for our two individuals.
colSums(sampleTest_2, na.rm = TRUE) 
  # filtering only for values greater than zero will output a logical T/F statement at every index in the matrix
colSums(sampleTest_2, na.rm = TRUE) > 0  
  # calling the which function tells us at which index position in the matrix we will find it
which(colSums(sampleTest_2, na.rm = TRUE) > 0)
names(which(colSums(sampleTest_2, na.rm = TRUE) > 0))
  # counting the names will help find the 
length(names(which(colSums(sampleTest_2, na.rm = TRUE) > 0)))

names(wildSubsetA1) %in% names(which(colSums(sampleTest_2, na.rm=TRUE) > 0))

length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(colSums(sampleTest_2, na.rm=TRUE) > 0)))])

# QUESTION 21: What proportion of alleles in the wild are found in Samples 11 and 91?
  # the proportion of alleles in the wild found in samples 11 and 91 is 0.2781955
length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(colSums(sampleTest_2, na.rm=TRUE) > 0)))])/length(names(wildSubsetA1))

# All alleles, 3 specific samples
QUAC.MSAT.genind@tab[c("QAc-W-0011",  "QAc-W-0051", "QAc-W-0091"),]
sampleTest_3 <- QUAC.MSAT.genind@tab[c("QAc-W-0011",  "QAc-W-0051", "QAc-W-0091"),]

# QUESTION 22: How many alleles in the wild are also found in Samples 11, 51 and 91?
  # 47 alleles in the wild are also found in Samples 11, 51, and 91
length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(colSums(sampleTest_3, na.rm=TRUE) > 0)))])

# QUESTION 23: What proportion of alleles found in the wild are found in Samples 11, 51 and 91?
  # the proportion of alleles in the wild found in sample 11, 51, and 91 is 0.3533835
length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(colSums(sampleTest_3, na.rm=TRUE) > 0)))])/length(names(wildSubsetA1))

# All alleles, 3 random samples
# SAMPLE DEMO
# Declare a vector of numbers (1--164)
numbers <- 1:164
# `sample` randomly selects items from that vector. The number of items selected is "size"; "replace" specifies whether or not you can select the same item more than once. 

# You can test it out by running the line below multiple times.
sample(numbers, size=4, replace=FALSE)

# QUESTION 24: Using sample, how can you randomly select 3 individuals (rows) from a matrix of wild individuals?
  # the samples are "QAc-W-0113", "QAc-W-0089", "QAc-W-0059"
randomSample_3 <- wildSamples[sample(nrow(wildSamples), size = 3, replace = TRUE),]
Q24_samps <- wildSamples[c("QAc-W-0113", "QAc-W-0089", "QAc-W-0059"),]

# QUESTION 25: How many alleles in the wild are also found in the 3 random samples from above?
  # 45 alleles in the wild are also found in the 3 random samples from above  
length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(colSums(Q24_samps, na.rm=TRUE) > 0)))])

# QUESTION 26: What proportion of alleles found in the wild are found in the 3 random samples from above
  # the proportion is 0.3684211
length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(colSums(Q24_samps, na.rm=TRUE) > 0)))])/length(names(wildSubsetA1))


# All alleles, all sample sizes
# QUESTION 27: Fill out the sections of the loop below, which calculates ex situ representation values for samples of multiple sizes.
# Start by declaring a vector to capture values
# resampValues <- vector(length = FILL_IN_BLANK)
# 
# # Fill in the blanks of the loop below
# for(i in 1:FILL_IN_BLANK){
#   # Use sample to randomly subsample the matrix of wild individuals
#   samp <- FILL_IN_BLANK
#   # Now, measure the proportion of allelic representation in that sample
#   resampValues[i] <- FILL_IN_BLANK # <-- Answer to Question 26
# }
# print(resampValues)

# Start by declaring a vector to capture values
resampValues <- vector(length = nrow(wildSamples))

wildSamples <- wildSamples[,which(colSums(wildSamples, na.rm = TRUE)!= 0)]

for(i in 1:nrow(wildSamples)){
  # browser()
  # Use sample to randomly subsample the matrix of wild individuals
  samp <- sample(nrow(wildSamples), size = i, replace = FALSE)
  # samp <- sample(wildSamples[!is.na(wildSamples)], size = i, replace = FALSE)
  # Now, measure the proportion of allelic representation in that sample
 if (i==1) resampValues[i] <- length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which((wildSamples[samp,]) > 0)))])/length(names(wildSubsetA1))
  if (i>1) resampValues[i] <- length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(colSums(wildSamples[samp,], na.rm=TRUE) > 0)))])/length(names(wildSubsetA1))

  }
print(resampValues)


# resampValues <- vector(length = nrow(wildSamples))
# 
# wildSamples <- wildSamples[,which(colSums(wildSamples, na.rm = TRUE)!= 0)]
# for(i in 1:nrow(wildSamples)){
#   # browser()
#   # Use sample to randomly subsample the matrix of wild individuals
#   samp <- sample(nrow(wildSamples), size = i, replace = FALSE)
#   # samp <- sample(wildSamples[!is.na(wildSamples)], size = i, replace = FALSE)
#   # Now, measure the proportion of allelic representation in that sample
#   if (i==1) resampValues[i] <- length(which(wildSamples[samp,]>0))/length(names(wildSubsetA1))
#   if (i>1) resampValues[i] <- length(which(colSums(wildSamples[samp,],na.rm=T)>0))/length(names(wildSubsetA1))
#   
# }
# print(resampValues)


# Rare alleles, 3 random samples
# QUESTION 28: Again using sample, randomly select 3 individuals (rows) from a matrix of wild individuals.
sample(nrow(wildSamples), size = 3, replace = FALSE)

# QUESTION 29: How many Rare alleles in the wild are also found in the 3 random samples from above?
  # 1
randomSample_3 <- wildSamples[sample(nrow(wildSamples), size =3, replace = FALSE),]

length(which(names(which(wildSubsetA1 < 0.01)) %in% names(which(colSums(randomSample_3, na.rm=TRUE) > 0))))

# QUESTION 30: What proportion of Rare alleles found in the wild are found in the 3 random samples from above?
  # the proportion of rare alleles found in the wild also found in sample the 3 random samples is 0.04347826
length(which(names(which(wildSubsetA1 < 0.01)) %in% names(which(colSums(randomSample_3, na.rm=TRUE) > 0))))/length(which(wildSubsetA1<0.01))

# ALL ALLELE CATEGORIES, ALL SAMPLE SIZES #
# QUESTION 31:
  # 
total <- vector(length = nrow(wildSamples))
common <- vector(length = nrow(wildSamples))
lowfreq <- vector(length = nrow(wildSamples))
rare <- vector(length = nrow(wildSamples))
wildSamples <- wildSamples[,which(colSums(wildSamples, na.rm = TRUE)!= 0)]

for(i in 1:nrow(wildSamples)){
  # browser()
  # Use sample to randomly subsample the matrix of wild individuals
  samp <- sample(nrow(wildSamples), size = i, replace = FALSE)
  samp <- wildSamples[samp,]
  # samp <- sample(wildSamples[!is.na(wildSamples)], size = i, replace = FALSE)
  # Now, measure the proportion of allelic representation in that sample
  if (i==1) {
    total[i] <- length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(samp > 0)))])/length(names(wildSubsetA1))
    common[i] <- length(which(names(which(wildSubsetA1 > 0.1)) %in% names(which(samp > 0))))/length(which(wildSubsetA1 > 0.1))
    lowfreq[i] <- length(which(names(which(wildSubsetA1 > 0.01 & wildSubsetA1 < 0.1)) %in% names(which(samp > 0))))/length(which(wildSubsetA1 > 0.01 & wildSubsetA1 < 0.1))
    rare[i] <- length(which(names(which(wildSubsetA1 < 0.01)) %in% names(which(samp > 0))))/length(which(wildSubsetA1 < 0.01))
  } else{
    total[i] <- length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(colSums(samp, na.rm=TRUE) > 0)))])/length(names(wildSubsetA1))
    common[i] <- length(which(names(which(wildSubsetA1 > 0.1)) %in% names(which(colSums(samp, na.rm=TRUE) > 0))))/length(which(wildSubsetA1 > 0.1))
    lowfreq[i] <- length(which(names(which(wildSubsetA1 > 0.01 & wildSubsetA1 < 0.1)) %in% names(which(colSums(samp, na.rm=TRUE) > 0))))/length(which(wildSubsetA1 > 0.01 & wildSubsetA1 < 0.1))
    rare[i] <- length(which(names(which(wildSubsetA1 < 0.01)) %in% names(which(colSums(samp, na.rm=TRUE) > 0))))/length(which(wildSubsetA1 < 0.01))
    
  }
  categorymat <- cbind(total,common,lowfreq,rare)
}
print(categorymat)

# Resampling in replicate: all allele categories, all sample sizes #
# QUESTION 32: Repeat Question 31, but store the values across 5 resampling replicates
resamp_category <- array(dim = c(164,4,5))
category <- colnames(categorymat)
dimnames(resamp_category) <- list(paste0("sample ", 1:nrow(categorymat)), category, paste0("replicate ",1:5))
j <- length((dimnames(resamp_category)[[3]]))
for (q in 1:j){
  for(i in 1:nrow(wildSamples)){
    # browser()
    samp <- sample(nrow(wildSamples), size = i, replace = FALSE)
    samp <- wildSamples[samp,]
    # Use sample to randomly subsample the matrix of wild individuals
    # Now, measure the proportion of allelic representation in that sample
    if (i==1) {
      total[i] <- length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(samp > 0)))])/length(names(wildSubsetA1))
      common[i] <- length(which(names(which(wildSubsetA1 > 0.1)) %in% names(which(samp > 0))))/length(which(wildSubsetA1 > 0.1))
      lowfreq[i] <- length(which(names(which(wildSubsetA1 > 0.01 & wildSubsetA1 < 0.1)) %in% names(which(samp > 0))))/length(which(wildSubsetA1 > 0.01 & wildSubsetA1 < 0.1))
      rare[i] <- length(which(names(which(wildSubsetA1 < 0.01)) %in% names(which(samp > 0))))/length(which(wildSubsetA1 < 0.01))
    } else{
      total[i] <- length(names(wildSubsetA1)[which(names(wildSubsetA1) %in% names(which(colSums(samp, na.rm=TRUE) > 0)))])/length(names(wildSubsetA1))
      common[i] <- length(which(names(which(wildSubsetA1 > 0.1)) %in% names(which(colSums(samp, na.rm=TRUE) > 0))))/length(which(wildSubsetA1 > 0.1))
      lowfreq[i] <- length(which(names(which(wildSubsetA1 > 0.01 & wildSubsetA1 < 0.1)) %in% names(which(colSums(samp, na.rm=TRUE) > 0))))/length(which(wildSubsetA1 > 0.01 & wildSubsetA1 < 0.1))
      rare[i] <- length(which(names(which(wildSubsetA1 < 0.01)) %in% names(which(colSums(samp, na.rm=TRUE) > 0))))/length(which(wildSubsetA1 < 0.01))
    }
  }
  categorymat <- cbind(total,common,lowfreq,rare)
  resamp_category[,,q] <- categorymat
}
resamp_category

setwd("C:/Users/gsalas/Documents/resampling_CIs/Code/Datasets")
saveRDS(resamp_category, file = "resamp_category.RDS")