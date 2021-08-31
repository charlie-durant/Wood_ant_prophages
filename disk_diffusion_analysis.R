# Script to analyse disk diffusion assays

library(tidyverse)
options(pillar.sigfig = 2)

# define variables
dilution_A = c("neat", "1:2", "1:10", "water")
isolate_A = c("1","2","3","7","14","18","19","28","50","76","92","NB")
replicate_A = c("A","B","C","D")

# recycle values
num_observations <- (length(isolate_A) * length(dilution_A)) * length(replicate_A)

dilution_B = c(rep(dilution_A, each = length(isolate_A)*length(replicate_A)))

isolate_B = c(rep(isolate_A, each = length(replicate_A)*length(dilution_A)))

replicate_B = c(rep(replicate_A, each = length(isolate_A)*length(dilution_A)))

data <- tibble(isolate_B, replicate_B, dilution_B)

rows <- nrow(data)
row <- 1

# fix replicates

while (row < rows){
  
  A <- row
  B <- row + 1
  C <- row + 2
  D <- row + 3
  
  #print(A)
  #print(B)
  #print(C)
  
  data[A,2] <- "A"
  data[B,2] <- "B"
  data[C,2] <- "C"
  data[D,2] <- "D"
 
  row <- row + 4
  
  #print(row)
}

# fix dilutions

rows <- nrow(data)
row <- 1

while (row < rows){ 
  dilutions <- c("neat", "1:2", "1:10", "water")
  #print(row)
  
  x <- 1 
  while (x < length(dilutions)+1){
    print(x)
    A <- row
    B <- row + 1
    C <- row + 2
    D <- row + 3
    
    print(row)
    
    data[A,3] <- dilutions[x]
    data[B,3] <- dilutions[x]
    data[C,3] <- dilutions[x]
    data[D,3] <- dilutions[x]
    
    row <- row + 4
    x <- x + 1
    next
   
  } 
}

#  manually input values for each isolate from lab book 

isolate1 <- tibble(
  inhibition_zone = c(1.1, 1.1, 1.1, 1.0, 0.6, 0.6, 0.6, 0.5, 0.2, 0.2, 0.2, 0.2, 0, 0, 0, 0)
)

isolate2 <- tibble(
  inhibition_zone = c(1.1, 1.1, 1.4, 0.9, 0.5, 0.5, 0.6, 0.5, 0.1, 0.2, 0.2, 0.2, 0, 0, 0, 0)
)

isolate3 <- tibble(
  inhibition_zone = c(1.2, 1.1, 1.1, 1.2, 0.6, 0.6, 0.6, 0.7, 0.2, 0.2, 0.2, 0.2, 0, 0, 0, 0)
)
                    
isolate7 <- tibble(
  inhibition_zone = c(1.2, 1.1, 1.2, 1.2, 0.7, 0.7, 0.7, 0.7, 0.2, 0.1, 0.1, 0.1, 0, 0, 0, 0)
)

isolate14 <- tibble(
  inhibition_zone = c(0.5, 0.5, 0.6, 0.6, 0.3, 0.4, 0.3, 0.3, 0.1, 0.1, 0.1, 0.1, 0, 0, 0, 0)
)

isolate18 <- tibble(
  inhibition_zone = c(1.2, 1.2, 1.1, 1.1, 0.6, 0.6, 0.6, 0.5, 0.2, 0.2, 0.2, 0.2, 0, 0, 0, 0)
)

isolate19 <- tibble(
  inhibition_zone = c(0.9, 1.0, 1.0, 1.0, 0.5, 0.7, 0.5, 0.5, 0.2, 0.1, 0.2, 0.2, 0, 0, 0, 0)
)

isolate28 <- tibble(
  inhibition_zone = c(0.6, 0.6, 0.6, 0.6, 0.4, 0.4, 0.4, 0.3, 0.1, 0.1, 0.1, 0.1, 0, 0, 0, 0)
)

isolate50 <- tibble(
  inhibition_zone = c(1.1, 1.0, 1.1, 1.1, 0.7, 0.7, 0.7, 0.7, 0.2, 0.2, 0.2, 0.2, 0, 0, 0, 0)
)

isolate76 <- tibble(
  inhibition_zone = c(0.8, 0.8, 0.8, 0.8, 0.7, 0.6, 0.6, 0.6, 0.2, 0.2, 0.3, 0.2, 0, 0, 0, 0)
)

isolate96 <- tibble(
  inhibition_zone = c(1.3, 1.1, 1.0, 1.0, 0.5, 0.6, 0.6, 0.5, 0.2, 0.2, 0.2, 0.2, 0, 0, 0, 0)
)

isolateNB <- tibble(
  inhibition_zone = c(rep(0, 16))
)

data[,4] <- bind_rows(isolate1, isolate2, isolate3, isolate7, isolate14, isolate18, isolate19, isolate28, isolate50, isolate76, isolate96, isolateNB) # add values to column 4

#d# Analysis of data

# Questions:
# Is there a statistical difference between the venom treatments

# How best to present this data. Heatmap? Bar chart?

# To compare between isolates - calculate % change in zone of inhibition. Use water as a baseline. Not needed because water values are all 0. They are all directly comparable.

# Percentage change in zone of inhibition size.

# select just rows with data for water treatment
#water_rows <- filter(data, dilution_B == "water")

#mean(water_rows$inhibition_zone) # calculate mean for this group
#summary(water_rows$inhibition_zone) # summary stats

# calculate means and stdev

means <- data %>% group_by(isolate_B, dilution_B) %>% 
  summarise(mean_inhibition_zone = mean(inhibition_zone), stdev = sd(inhibition_zone)) 

means %>% select(dilution_B) %>% arrange("neat", "1:2", "1:10", "water")

means %>% arrange(desc(mean_inhibition_zone)) # arrange by descending inhibition zone to see top values

ggplot(data = means, aes(x = isolate_B, y = mean_inhibition_zone, color = dilution_B)) +
  geom_bar(stat="identity", fill = "white",  position=position_dodge()) +
  geom_errorbar(aes(ymin = mean_inhibition_zone - stdev, ymax = mean_inhibition_zone + stdev), width=.2,
                position=position_dodge(.9)) +
  theme_minimal()


# Questions

# Are there statistically significant differences between isolates? 

# Can you plot this as a heatmap with 2 axes, isolate and dilution, with colour indicating the size of inhibition zone

means %>%
  ggplot( aes(x = reorder(isolate_B, mean_inhibition_zone), y = reorder(dilution_B, mean_inhibition_zone), fill = mean_inhibition_zone)) +
  geom_tile() + 
  scale_fill_continuous(limits=c(0, 2), breaks=seq(0,2,by=1)) +
  labs( x = "Isolate", y = "Venom treatment", fill = "Inhibition zone (cm)")


