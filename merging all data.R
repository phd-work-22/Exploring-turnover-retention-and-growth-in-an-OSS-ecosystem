library(dplyr)
library(ggplot2)

#setwd("/Users/tientulili/Documents/My Doctorate FILES/2 PhD Objective 2/Replicate Study/threads")
#mailists <- read.csv("2022-05-1m.csv",TRUE, ",")

setwd("/Users/tientulili/Documents/gentoo_mailingLists/completed mailing lists reports/")
mailists <- read.csv("dumpFile.csv",TRUE, ",")

df <- as.data.frame(mailists)
for(year in 2001:2022) {
  for(month in 1:12) {
    for(page in 1:10) {
      if (month < 10) {
        
        filename <- paste(year,"-0",month,"-",page,"m.csv",sep='')
        
        if(!file.exists(filename))
          next
        else {
          mailists2 <- read.csv(filename,TRUE, ",")
          df1 <- as.data.frame(mailists2)
          df <- rbind(df,df1)
          print(paste(year,month,page,nrow(df1)))
        }
      }
      else {
        
        filename <- paste(year,"-",month,"-",page,"m.csv",sep='')
        
        if(!file.exists(filename))
          next
        else {
          mailists2 <- read.csv(filename,TRUE, ",")
          df1 <- as.data.frame(mailists2)
          df <- rbind(df,df1)
          print(paste(year,month,page, nrow(df1)))
        }
      }
    }
  } 
}

write.csv(df,"/Users/tientulili/Documents/gentoo_mlists_all.csv", row.names = FALSE)
df





