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
wildSubsetA1 <- c(wildSubset)
  # APPROACH 2: Subset using logical condition 
wildComplete <- colSums(wildSamples, na.rm = TRUE)/(nrow(wildSamples)*2) 
wildSubsetA2 <- wildComplete[wildComplete > 0]
# QUESTION 10: How many alleles are there which have frequencies greater than 10% in the wild?
  # 42 alleles have frequencies greater than 10%
length(which(wildSubsetA2>0.1))

## EX SITU REPRESENTATION ##

# All alleles
# QUESTION 11: Which alleles have frequencies greater than 0% in the wild?
which(wildSubsetA1 > 0)

# QUESTION 12: Which alleles have frequencies greater than 0% in the garden?
gardenComplete <- (colSums(gardenSamples, na.rm = TRUE)/(nrow(gardenSamples)*2))
gardenComplete[wildComplete==0] <- NA
gardenSubset <- na.omit(gardenComplete)
gardenSubset <- c(gardenSubset)
which(gardenSubset > 0)

# length(which(colSums(wildSamples, na.rm = TRUE) > 0))
# length(which((colSums(wildSamples, na.rm = TRUE)/(nrow(wildSamples)*2)) > 0.1)) 


# QUESTION 13: Which alleles with wild frequencies greater than 0% are also found in the garden?
  # 0 alleles with wild frequencies greater than 0% are also found in the garden
which(wildSubsetA1 %in% gardenSubset)

# Question 14: How many alleles with wild frequencies greater than 0% are also found in the garden?
  # 
