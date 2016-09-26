library(plyr)
library(reshape2)
split.by <- c("miasto")
summarized.grants <- ddply(grants,
                           split.by,
                           function(df) {
                              c(sr.wsp.sukcesu = mean(df$procent.sukcesu), 
                                sr.kwota.na.prac = mean(df$kwota.na.pracownika,na.rm=T))
                          })

summary.pivot <- dcast (summarized.grants, dziedzina ~ kategoria, value.var = "sr.kwota.na.prac")
rownames(summary.pivot) <- summary.pivot$dziedzina
summary.pivot$dziedzina<-NULL
summary.matrix <- data.matrix(summary.pivot,rownames.force = T)
summary.matrix [is.nan(summary.matrix)|is.na(summary.matrix)] <- 0
