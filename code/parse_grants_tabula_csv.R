grants <- read.csv ("../raw_data/tabula-Zestawienie_wnioskodawcow_2013.csv")
names(grants) <- c("GWO","kategoria","wydzial","jednostka.gl","zlozone","pozyskane","procent.sukcesu","kwota.calk","liczba.pracownikow","kwota.na.pracownika")
grants$kategoria <- factor(grants$kategoria, levels = c("A+","A","B","C"))
grants$procent.sukcesu <- grants$pozyskane/grants$zlozone
grants$kwota.calk <- as.numeric(gsub("[^0-9]","", grants$kwota.calk), ordered = T)
grants$liczba.pracownikow <- gsub(",",".", grants$liczba.pracownikow)
grants$liczba.pracownikow <- as.numeric(gsub("[^0-9.]","", grants$liczba.pracownikow))
grants$kwota.na.pracownika <- grants$kwota.calk/grants$liczba.pracownikow
grants$dziedzina <- factor(substring (sub("BRAK DANYCH","--",grants$GWO),1,2))
write.csv (grants,"../results/2013_parsed.csv", row.names=F)
