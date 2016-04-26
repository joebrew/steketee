library(ggplot2)
library(tidyr)
library(dplyr)
library(RColorBrewer)
library(Hmisc)
library(waffle)
survival <- function(n = 100, p = 85, prev = 50, d = 30){
  df <- data.frame(day = 1:d,
                   n = NA,
                   infected = NA)
  df$n[1] <- n
  df$infected[1] <- 0
  
  # Create a percentage infected line
  df$p_infected[2:nrow(df)] <- 
    1-((1 - ((1/3) * (prev/100)))^df$day[1:(nrow(df)-1)])
  df$p_infected[1] <- 0
  
  # Populate dataframe
  for (i in 2:nrow(df)){
    
    # Populate mosquito population
    df$n[i] <- 
      df$n[i-1] * (0.01*p)
    
  }
  # Get the number that should be infected
  df$infected <- df$n * df$p_infected
  
  # Get number of non infected
  df$non_infected <- df$n - df$infected
  
  # Calculate number of infectious bites
  df$infectious_bites <- 
    df$infected * 0.3333
  
  # Calculate number of non_infectious bites
  df$non_infectious_bites <- 
    df$non_infected * 0.3333
  
  # Return df
  return(df)
}

# Function to plot survival
visualize_survival <- function(df = survival()){
  
  # Make a long version
  long <- gather(df, key, value, n:non_infected)
  
#   # Make long title
#   long_title <- 
#     paste0(n, ' mosquitoes with a daily survival rate of ',
#            p, ' and a human parasitemia rate of ', prev)
#   
#   # Make sub-title
#   sub_title <- 
#     paste0(bites, ' infectious bites')
  
  # Define color vector
  cols <- colorRampPalette(brewer.pal(n = 9, 'Spectral'))(2)
  
  # GGPLOT
  g <- 
    ggplot() +
    geom_area(data = long %>%
                filter(key %in% c('infected', 'non_infected')) %>%
                mutate(key = capitalize(gsub('_', ' ', key))), 
              aes(x = day, 
                  y = value, 
                  fill = key), 
              position = 'stack',
              alpha = 0.5) +
    scale_fill_manual(name = 'Status',
                      values = cols) +
    xlab('Day') +
    ylab('Mosquitoes') +
    ggtitle('Mosquito population')
    #+
  # ggtitle(paste0(long_title, sub_title)) 
  print(g)
}

# Function to visualize infected bites
visualize_bites <- function(df = survival()){
  # Calculate total infectious bites
  bites <- c('Infectious bites' = round(sum(df$infectious_bites)),
             'Non infectious bites' = round(sum(df$non_infectious_bites)))
  
  # Make scaled
  if(sum(bites) > 1000){
    scaled <- TRUE
  } else{
    scaled <- FALSE
  }
  
  if(scaled){
    scaler <- (nchar(sum(bites)) - 2) * 10
    bites <- bites / scaler
  } else {
    scaler <- 1
  }
  
  # Round up
  bites <- ceiling(bites)
  
  # Subset if necessary
  bites <- bites[bites > 0]
  
  # Define color vector
  cols <- colorRampPalette(brewer.pal(n = 9, 'Spectral'))(2)
  if(length(bites) == 1){
    if(names(bites) == 'Non infectious bites'){
      cols <- cols[2]
    } else{
      cols <- cols[1]
    }
  }
  
  if(scaled){
    the_title <- paste0(scaler, ' bites/square')
  } else {
    the_title <- '1 bite/square'
  }
  # Append breakdown
  the_title <-
    paste0(the_title,
           ' -- ',
           'Infectious: ', scaler * round(as.numeric(bites[1])),
           ' / ',
           'Non-infectious: ', scaler * round(as.numeric(bites[2])))
  

  
   waffle(bites,
         title = the_title,
         colors = cols,
         rows = 10,
         size = 0.5)
}




# 100 mosquitos get 27 infectious bites

# if only 10% parasite prevalence, only 8 infectious bites


