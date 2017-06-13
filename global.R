library(shiny)
library(readxl)
library(plotly)
library(tidyverse)
library(ggthemes)

#original data prep
dta <- read_excel("Live Automated tool 2015-17.xlsx", sheet = 10, skip = 1, n_max = 34)
dtaNames <- read_excel("Live Automated tool 2015-17.xlsx", sheet = 10, n_max = 1, col_names = FALSE)
dtaNames <- t(dtaNames) %>% as.data.frame(.)
dtaNames <- na.omit(dtaNames)
dtaNames <- separate(dtaNames, "V1", into = c("Ind", "IndName"), " -") %>% na.omit()
dta <- gather(dta, "Indicator", "Value", 3:378)
dta$Indicator <- gsub(" 20", "_20", dta$Indicator)
dta <- separate(dta, "Indicator", c("Indicator", "Year"), sep = "_")
dta$Indicator <- gsub(" -", "", dta$Indicator)
dtaNames$Ind <- toupper(dtaNames$Ind) %>% gsub(" ", "", .)
dta$Indicator <- toupper(dta$Indicator) %>% gsub(" ", "", .)
dta <- left_join(dta, dtaNames, by = c("Indicator" = "Ind")) %>% .[!is.na(.$IndName),]
dta <- unique(dta)
dta$Value <- as.numeric(dta$Value)
dtaFG <- aggregate(Value ~ grpchldrn_2012 + Indicator + Year+ IndName, dta,median)
colnames(dtaFG)[5] <- "Value"
dtaFG$`Local Authority` <- "Family Group"
dtaFG <- dtaFG[c(6,1,2,3,5,4)]
saveRDS(dta, file = "AutoToolDataset.rds")
dta <- readRDS("AutoToolDataset.rds")
