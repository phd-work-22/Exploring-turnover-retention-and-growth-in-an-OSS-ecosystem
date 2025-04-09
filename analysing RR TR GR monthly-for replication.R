library(tidyr)
library(ggplot2)
library(stringr)
library(dplyr)
library(scales)
library(tseries)
library(lubridate)

list_of_categories <- c(
  'dev-python', 'dev-libs', 'media-libs',
  'dev-util', 'net-misc',
  'sys-apps', 'media-gfx',
  'media-sound', 'app-admin', 'app-text',
  'games-kids', 'app-xemacs', 'gnustep-base',
  'gnustep-libs', 'sec-policy', 'games-roguelike',
  'gnustep-apps', 'www-misc', 'sci-calculators', 'games-mud')

setwd("/your_filepath")
commits <- read.csv("list_developers_commits_completeDate_2000_2023.csv",FALSE,';')
colnames(commits) <- c('path','year', 'month', 'day', 'name', 'email')

commits$date <- 
  as.Date(with(commits, paste(year, month, day, sep = "-")), "%Y-%m-%d")

filtered_df_commits <- commits %>% filter(year >= 2001) 

df_commits <- subset(filtered_df_commits, 
                     select = c('path', 'name', 'date', 'month'))

df_commits <- df_commits %>% mutate(year = year(date))

activeDevs <- read.csv("activeGentooDevelopers.csv",TRUE,';')
df_activeDevs <- subset(activeDevs, select = c('name'))
retiredDevs <- read.csv("retiredGentooDevelopers.csv",TRUE,';')
df_retiredDevs <- subset(retiredDevs, select = c('name'))

#merging all Gento developers: retired and active developers
allGentoDevs <- full_join(df_activeDevs, df_retiredDevs)

# Initialize an empty data frame for results
# df_analysed_devs <- data.frame(
#   year = integer(),
#   month = integer(),
#   path = character(),
#   tot_devs = integer(),
#   dev_left = integer(),
#   new_devs = integer(),
#   dev_act = integer(),
#   stringsAsFactors = FALSE
# )
df_analysed_devs <- data.frame()  # Initialize an empty data frame for results

for (year in 2001:2023) {
  for (month in 1:12) {
    
    # Determine the current and subsequent month/year
    current_month <- month
    current_year <- year
    next_month <- ifelse(month == 12, 1, month + 1)
    next_year <- ifelse(month == 12, year + 1, year)
    
    # Break if we've reached beyond the end of data
    if (next_year > 2023 || (next_year == 2023 && next_month > 3)) break
    
    print(paste("Processing Year:", current_year, "Month:", current_month))
    print(paste("Comparing to Year:", next_year, "Month:", next_month))
    
    # Data for current month
    l_df1 <- unique(subset(
      df_commits, 
      select = c('path', 'name'),
      year == current_year & month == current_month
    ))
    l2_df1 <- inner_join(l_df1, allGentoDevs, by = 'name')
    #print(paste("Current Month Developers:", nrow(l2_df1)))
    
    # Data for subsequent month
    l_df2 <- unique(subset(
      df_commits, 
      select = c('path', 'name'),
      year == next_year & month == next_month
    ))
    l2_df2 <- inner_join(l_df2, allGentoDevs, by = 'name')
    #print(paste("Subsequent Month Developers:", nrow(l2_df2)))
    
    # Get all unique paths from both months
    all_paths <- unique(c(l_df1$path, l_df2$path))
    
    # Iterate over each path to analyze developer activity
    for (path in all_paths) {
      # Filter by path for each month's data
      path_df1 <- filter(l2_df1, path == !!path)
      path_df2 <- filter(l2_df2, path == !!path)
      
      # Identify new developers in the subsequent month
      only_in_df2 <- setdiff(path_df2$name, path_df1$name)
      
      # Identify developers who left after the current month
      only_in_df1 <- setdiff(path_df1$name, path_df2$name)
      
      # Append results to the analysis data frame
      df_analysed_devs <- rbind(
        df_analysed_devs,
        data.frame(
          year = next_year,
          month = next_month,
          path = path,
          tot_devs = nrow(path_df2),
          dev_left = length(only_in_df1),
          new_devs = length(only_in_df2),
          dev_act = nrow(path_df2) - length(only_in_df2)  # Active developers
        )
      )
    }
  }
}


# Values to filter
filter_values <- c(
  'dev-python', 'dev-libs', 'media-libs',
  'dev-util', 'net-misc',
  'sys-apps', 'media-gfx',
  'media-sound', 'app-admin', 'app-text',
  'games-kids', 'app-xemacs', 'gnustep-base',
  'gnustep-libs', 'sec-policy',
  'gnustep-apps', 'www-misc', 'sci-calculators', 'games-mud', 'games-roguelike')

# Filter rows where 'metric' is in the specified list
df_analysed_devs <- df_analysed_devs %>% filter(path %in% filter_values)

df_analysed_devs$diff <- df_analysed_devs$new_devs - df_analysed_devs$dev_left

df_analysed_devs <- df_analysed_devs %>% group_by(year, month) %>%
  mutate(tot_devs_all=sum(tot_devs))

df_analysed_devs$turn_over_rate <- 
  df_analysed_devs$dev_left/df_analysed_devs$tot_devs_all*100

df_analysed_devs$growth_rate <- 
  df_analysed_devs$new_devs/df_analysed_devs$tot_devs_all*100

df_analysed_devs$retention_rate <-
  df_analysed_devs$dev_act/df_analysed_devs$tot_devs_all*100

df_melted <- df_analysed_devs %>%
  pivot_longer(
    cols = c(turn_over_rate, growth_rate, retention_rate),
    names_to = "metric",
    values_to = "value"
  )

#write.csv(df_analysed_devs, "turnover growth and retention rates- monthly.csv", row.names=TRUE)
## Analysing the two groups in terms of turn over rate, the growth rate, 
## and the retention rate

filter_df_neg_paths <- c( 'dev-python', 'dev-libs', 'media-libs',
                          'dev-util', 'net-misc',
                          'sys-apps', 'media-gfx',
                          'media-sound', 'app-admin', 'app-text')

filter_df_pos_paths <- c( 'games-kids', 'app-xemacs', 'gnustep-base',
                          'gnustep-libs', 'sec-policy',
                          'gnustep-apps', 'www-misc', 'sci-calculators', 'games-mud', 
                          'games-roguelike')


df_neg_paths <- df_melted %>% filter(path %in% filter_df_neg_paths)
df_pos_paths <- df_melted %>% filter(path %in% filter_df_pos_paths)

df_neg_paths_to <- subset(df_neg_paths, metric %in% c("turn_over_rate"))
df_pos_paths_to <- subset(df_pos_paths, metric %in% c("turn_over_rate"))
df_neg_paths_rt <- subset(df_neg_paths, metric %in% c("retention_rate"))
df_pos_paths_rt <- subset(df_pos_paths, metric %in% c("retention_rate"))
df_neg_paths_gt <- subset(df_neg_paths, metric %in% c("growth_rate"))
df_pos_paths_gt <- subset(df_pos_paths, metric %in% c("growth_rate"))

# Perform Mann-Whitney U Test
result <- wilcox.test(df_neg_paths_rt$value, df_pos_paths_to$value, 
                      alternative = "two.sided", # Can be "two.sided", "less", or "greater"
                      paired = FALSE)           # Set to FALSE for independent samples

# Print results
print(result)

result_rt <- wilcox.test(df_neg_paths_rt$value, df_pos_paths_rt$value, 
                         alternative = "two.sided", # Can be "two.sided", "less", or "greater"
                         paired = FALSE)           # Set to FALSE for independent samples

# Print results
print(result_rt)


result_gt <- wilcox.test(df_neg_paths_gt$value, df_pos_paths_gt$value, 
                         alternative = "two.sided", # Can be "two.sided", "less", or "greater"
                         paired = FALSE)           # Set to FALSE for independent samples

# Print results
print(result_gt)


lineg <-  ggplot(subset(df_melted, metric %in% c("turn_over_rate", "retention_rate")), 
                 aes(x = year, y = value, color = metric)) +
  geom_line(size = 1) +
  geom_point() +
  labs(title = "Yearly Retention and Turnover rate in 10 Negative and Positive Paths",
       x = "year",
       y = "Proportion (%)",
       color = "Metric") +
  facet_wrap(~ path, scales = "free_x") +   # Separate lines for each year if data spans multiple years
  theme_minimal()
print(lineg)


