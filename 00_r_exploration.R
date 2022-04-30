if(Sys.getenv("USERNAME") == "Filser" ) .libPaths("D:/R-library4")  # set library
library(tidyverse)
baua <- haven::read_dta("D:/Datenspeicher/BIBB_BAuA/BIBBBAuA_2018_suf1.0.dta")
baua2 <- readstata13::read.dta13("D:/Datenspeicher/BIBB_BAuA/BIBBBAuA_2018_suf1.0.dta",convert.factors = F)

baua %>% select(where(function(x) sum(is.na(x)) / length(x) < 0.5))


baua2 %>% select(where(function(x) sum(as.numeric(x) == 9999) > 0 ))

xt <- baua2 %>% summarise(across(everything(), ~sum(as.numeric(.x) %in% c(9999,-4:-1)) > 0 ))  %>% 
  t(.) %>% data.frame(.) %>% rownames_to_column(.,var = "var") %>% janitor::clean_names() %>% tibble() %>% filter(x)


labs <- baua %>% map(.,~attributes(.x)$label) %>% bind_rows(.) %>% 
  t(.) %>% data.frame() %>% rownames_to_column(.,var = "var") %>% janitor::clean_names() %>% tibble() 
ndis <- 
  baua2 %>% summarise(across(everything(), ~length(unique(.x)  )) )  %>% 
  t(.) %>% data.frame(ndis = .) %>% rownames_to_column(.,var = "var") %>% janitor::clean_names() %>% tibble() 


ndis %>% left_join(labs, by ="var") %>% 
  arrange(ndis) %>% filter(ndis %in% 3:5) %>% print(.,n=Inf)




xt <- baua2 %>% summarise(across(everything(), ~sum(as.numeric(.x) %in% c(9999)) > 0 ))  %>% 
  t(.) %>% data.frame(.) %>% rownames_to_column(.,var = "var") %>% janitor::clean_names() %>% tibble() %>% filter(x)


reg <- readstata13::read.dta13("./docs/regex1.dta",convert.factors = F)
reg$rnd <- runif(8,0,1)
reg$address <- ifelse(reg$rnd<.5, tolower(reg$address), reg$address)
haven::write_dta(data = data.frame(address= reg[,1]),path = "./docs/regex1.dta")


baua <- haven::read_dta("D:/Datenspeicher/BIBB_BAuA/BIBBBAuA_2018_suf1.0.dta")
baua$random1 <- runif(nrow(baua),0,1)

library(tidyverse)


dfx <- 
    data.frame(x1 = sample(1:100,2000,T),
               x2 = sample(LETTERS,size = 2000,replace = T),
               xyz = paste0(sample(LETTERS,2000,T),sample(LETTERS,2000,T),sample(LETTERS,2000,T),sample(LETTERS,2000,T)),
               age = sample(18:81,2000,T))  
dfx$random1 <- runif(nrow(dfx),0,1)


walk( seq(0,1,.2), function(x) {
    # baua %>% filter(between(random1,x-.1,x)) %>%   select(-random1) %>% 
    dfx %>% filter(between(random1,x-.1,x)) %>%  select(-random1) %>%  
    readr::write_delim(.,file = paste0("./projekt/data",x*20,".csv"),delim = ";")
    #haven::write_dta(.,path = paste0("./projekt/data",x*10,".dta"))
})
             
  
  



  ?walk

unique(baua$zpalter) %>% length(.)



#run render in background -------------------
 bookdown::preview_chapter("00_build.R")

rm(baua)
chap <- "09_mreg.Rmd"
chp1 <- c('index.Rmd','01-IntroI.Rmd','02-Datensaetze.Rmd','03_Deskription.Rmd','04_if_label.Rmd','05_gen.Rmd','06_egen.Rmd','07_gewichtung.Rmd',
          '08_zshg.Rmd', '09_mreg.Rmd',
          '21_bgregression.Rmd',
          '22_anova.Rmd',
          '30_literatur.Rmd',
          '31_appendix.Rmd')


map(1:length(chp1), function(x){
  chap <- chp1[x]
  rstudioapi::jobRunScript(path = "00_build.R",importEnv = T) 
  Sys.sleep(60*3)
})


# befehle ----
knitr::purl(input = "04_labels_variab.Rmd",output = "./stata_prog/04_Befehle.do")


pagedown::chrome_print(rmarkdown::render('../pdf/StataBIBB1.Rmd'))