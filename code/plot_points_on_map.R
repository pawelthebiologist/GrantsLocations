
library(rworldmap)
grants <- read.csv ("../results/2013_parsed_with_geolocation.csv")

grants.polska <- grants[grep("Poland",grants$adres),]

grants.subset.for.graphing <- grants.polska[grants.polska$kategoria=="A"&grants.polska$dziedzina=="NZ",]

newmap <- getMap(resolution = "low")
library (grDevices)
palette.degrees <- 10

#color brewer palette - c("#e9a3c9","#f7f7f7", "#a1d76a")
# isoluminant colors from here http://stackoverflow.com/questions/7251872/is-there-a-better-color-scale-than-the-rainbow-colormap

isolum.red <- "#D80E0E"
isolum.magenta <- "#B700B7"
isolum.blue <- "#5050FD"
isolum.cyan <- "#009696"

color.palette <- colorRampPalette(c(isolum.red, isolum.magenta, isolum.blue,isolum.cyan))(palette.degrees)

plot(newmap, xlim = c(min(grants.subset.for.graphing$dl.geog,na.rm=T),
                      max(grants.subset.for.graphing$dl.geog, na.rm=T)), 
     ylim = c(min(grants.subset.for.graphing$szer.geog, na.rm=T),
              max(grants.subset.for.graphing$szer.geog, na.rm=T)), asp = 1.4)

transparency <- "30"

grants.colors <- sub(paste("NA",transparency,sep=""),
                     "#FFFFFF00",
                     paste(color.palette[
                       ceiling(grants.subset.for.graphing$procent.sukcesu/max(grants.subset.for.graphing$procent.sukcesu,na.rm=T)*palette.degrees)
                     ],
                     transparency,
                     sep=""))

blob.multiplier <- 10
blob.size <- grants.subset.for.graphing$kwota.calk/max(grants.subset.for.graphing$kwota.calk,na.rm=T)*blob.multiplier
dl.geog.mieszana <- grants.subset.for.graphing$dl.geog + runif(nrow(grants.subset.for.graphing),0,0.2)
szer.geog.mieszana <- grants.subset.for.graphing$szer.geog + runif(nrow(grants.subset.for.graphing),0,0.2)

points(dl.geog.mieszana, 
       szer.geog.mieszana, 
       pch=16, 
       col = grants.colors, 
       cex = blob.size)

legend ("topleft", 
        legend=c("wysoki","średni","niski"),
        fill=c(color.palette[10],color.palette[5],color.palette[1]),
        title="wspolczynnik sukcesu")

