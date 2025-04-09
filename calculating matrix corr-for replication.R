library(tidyr)
library(ggplot2)
library(reshape2)
library(corrplot)
library(dplyr)
library(scales)

setwd("/your_filepath")
df_rates3 <- read.csv("all_results_of_workforce_dynamics_2025.csv",TRUE,',')

df_rates3 <- df_rates3 %>%
  mutate(
    log_values_c_retained = ifelse(is.na(c_retained) | c_retained <= 0, 0, log(c_retained))
    # Replace NA or non-positive values with 0
  )

df_rates3 <- df_rates3 %>%
  mutate(
    log_values_c_new = ifelse(is.na(c_new) | c_new <= 0, 0, log(c_new))
    # Replace NA or non-positive values with 0
  )


df_rates3 <- df_rates3 %>%
  mutate(
    log_values_new_devs = ifelse(is.na(new_devs) | new_devs <= 0, 0, log(new_devs))
    # Replace NA or non-positive values with 0
  )


df_rates3 <- df_rates3 %>%
  mutate(
    log_values_dev_act = ifelse(is.na(dev_act) | dev_act <= 0, 0, log(dev_act))
    # Replace NA or non-positive values with 0
  )


# calculating the values of modifications after applying the log-transformation
# This aims to seek out the correlation between variables
df_rates3$M2 <- (df_rates3$log_values_dev_act * df_rates3$Retention * df_rates3$log_values_c_retained) +
  (df_rates3$log_values_new_devs * df_rates3$log_values_c_new)


s_df_rates3 <- unique(subset(df_rates3,
                             select=c('Turnover', 'Growth', 'Retention', 'M2', 'year', 'month',
                                      'path','devs_begin_month')))


filter_df_neg_paths <- c( 'dev-python', 'dev-libs', 'media-libs',
                          'dev-util', 'net-misc',
                          'sys-apps', 'media-gfx',
                          'media-sound', 'app-admin', 'app-text')

filter_df_pos_paths <- c( 'games-kids', 'app-xemacs', 'gnustep-base',
                          'gnustep-libs', 'sec-policy',
                          'gnustep-apps', 'www-misc', 'sci-calculators', 'games-mud', 
                          'games-roguelike')

# Calculate the correlation matrix
df_neg_paths_2 <- s_df_rates3  %>% filter(path %in% filter_df_neg_paths)

data_negs <- subset(df_neg_paths_2, select = 
                      c('Turnover', 'Growth', 'Retention', 'M2'))
colnames(data_negs) <- c('TR', 'GR', 'RR', 'M')


df_pos_paths_2 <- s_df_rates3  %>% filter(path %in% filter_df_pos_paths)

data_pos <- subset(df_pos_paths_2, select = 
                      c('Turnover', 'Growth', 'Retention', 'M2'))
colnames(data_pos) <- c('TR', 'GR', 'RR', 'M')

cor_matrix <- cor(data_negs)
# Display the correlation matrix
print("Correlation Matrix Negative categories:")
print(cor_matrix)

corrplot(cor_matrix, method = "color", type = "lower", 
         tl.col = "black", tl.srt = 45, addCoef.col = "black",
         number.cex = 1.5,       # Increase the size of correlation values
         cl.cex = 1.5,
         tl.cex = 1.5)


cor_matrix_pos <- cor(data_pos)
# Display the correlation matrix
print("Correlation Matrix Postive:")
print(cor_matrix_pos)

corrplot(cor_matrix_pos, method = "color", type = "lower", 
         tl.col = "black", tl.srt = 45, addCoef.col = "black",
         number.cex = 1.5,       # Increase the size of correlation values
         cl.cex = 1.5,
         tl.cex = 1.5)
