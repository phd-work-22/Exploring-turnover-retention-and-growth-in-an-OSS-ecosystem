library(reshape2)
library(tidyr)
library(ggplot2)
library(stringr)
library(dplyr)
library(ggpubr)
library(scales)

setwd("/Volumes/Data/PhD/Gentoo/workdir/tables")
data <- read.csv("data-all-sentiments-commits2.csv",TRUE,';')
s_data <- 
  subset(data, select = c('path', 'year', 'n_neg_messages', 'n_pos_messages'))

data2 <- read.csv("list_messages_containing_strongPosSentences_2024-CLEANED.csv",TRUE,';')

data_all <- na.omit(s_data)
data_all$diff <- data_all$n_pos_messages - data_all$n_neg_messages
minmax<-function(x) {
  (x-mean(x))/sd(x)
}

data_all2 <- data_all %>% group_by(year) %>%
  mutate(norm = minmax(diff))

# data_all2 <- na.omit(data_all2)
# agg_diff <- data_all2 %>% group_by(path) %>%
#   summarise(sum_diff = sum(diff))

data_all2 <- na.omit(data_all2)
agg_diff <- data_all2 %>% group_by(path) %>%
  summarise(sum_norm = sum(norm))

m_data_all2 <- merge(data_all2, agg_diff, by=c('path'))

ordered_data <- m_data_all2 %>% arrange(sum_norm)

ordered_data$path <- factor(ordered_data$path, 
                            levels = unique(ordered_data$path))

my_palette <- c('#67001f','#b2182b','#d6604d',
                         '#f4a582','#fddbc7','#f7f7f7',
                         '#d1e5f0','#92c5de','#4393c3',
                         '#2166ac','#053061')
       
                  
plot_signi <- ggplot(ordered_data, aes(x=year, y=path, fill=norm), ) +
  geom_tile(color = "black") + 
  scale_fill_gradientn(colors = my_palette, limits = c(-3,4), 
                       breaks = c(-3,-2, -1, 0, 1, 2, 3, 4)) +
  scale_x_continuous(limits = c(2000.5, 2023.5), expand=c(0,0), 
                     breaks = ordered_data$year)+
  coord_fixed() +
  theme(axis.text.y = element_text(hjust = 1, vjust=0.5, size=10),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(angle=90,vjust = 0.75, hjust=1,size=7),
        legend.position = "top", legend.margin = margin(10,0,0,-10),
        legend.text = element_text(size=7), 
        legend.title = element_text(size=12, vjust=1),
        panel.background = element_rect(fill="white"),
        panel.grid.major = element_line(colour = "black", size = 0.1))+
  labs(fill="z-score of the number of differences\n between positive and negative messages")
plot_signi + coord_flip()

list_of_categories <- c(
  'dev-python', 'dev-libs', 'media-libs',
  'dev-util', 'net-misc',
  'sys-apps', 'media-gfx',
  'media-sound', 'app-admin', 'app-text',
  'games-kids', 'app-xemacs', 'gnustep-base',
  'gnustep-libs', 'sec-policy', 'games-roguelike',
  'gnustep-apps', 'www-misc', 'sci-calculators', 'games-mud')

f_ordered_data <- ordered_data %>% filter(path %in% list_of_categories)

plot_signi <- ggplot(f_ordered_data, aes(x=year, y=path, fill=norm), ) +
  geom_tile(color = "black") + 
  scale_fill_gradientn(colors = my_palette, limits = c(-3,4), 
                       breaks = c(-3,-2, -1, 0, 1, 2, 3, 4)) +
  scale_x_continuous(limits = c(2000.5, 2023.5), expand=c(0,0), 
                     breaks = f_ordered_data$year)+
  coord_fixed() +
  theme(axis.text.y = element_text(hjust = 1, vjust=0.5, size=14),
        axis.title.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(angle=90,vjust = 0.75, hjust=1,size=14),
        legend.position = "top", legend.margin = margin(10,0,0,-10),
        legend.text = element_text(size=12), 
        legend.title = element_text(size=14, vjust=1),
        panel.background = element_rect(fill="white"),
        panel.grid.major = element_line(colour = "black", size = 0.1))+
  labs(fill="z-score of the number of differences between\npositive and negative messages",
       x = "")
plot_signi

