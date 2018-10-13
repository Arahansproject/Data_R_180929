if("rJava" %in% installed.packages("rJava") == FALSE)install.packages("rJava")
library(rJava)
if("memoise" %in% installed.packages("memoise") == FALSE)install.packages("memoise")
library(memoise)
if("KoNLP" %in% installed.packages("KoNLP") == FALSE)install.packages("KoNLP")
library(KoNLP)
if("tm" %in% installed.packages("tm") == FALSE)install.packages("tm")
library(tm)
if("wordcloud" %in% installed.packages("wordcloud") == FALSE)install.packages("wordcloud")
library(wordcloud)
if("dplyr" %in% installed.packages("dplyr") == FALSE)install.packages("dplyr")
library(dplyr)
library(ggplot2)
if("stringr" %in% installed.packages("stringr") == FALSE)install.packages("stringr")
library(stringr)
if("RColorBrewer" %in% installed.packages("RColorBrewer") == FALSE)install.packages("RColorBrewer")
library(RColorBrewer)


KoNLP::useSejongDic()
getwd()
setwd("C:\\Users\\Administrator\\rlang_weekend2\\Data_R_180929")

# 데이터 가져오기
twitter <- read.csv ("twitter.csv",
                     header = T,
                     stringsAsFactors = F,
                     fileEncoding = "UTF-8"
                     )
# 변수명 변경
names(twitter)
twitter <- dplyr::rename(twitter,
                         no = 번호,
                         id = 계정이름, 
                         date = 작성일,
                         tw = 내용
                         )

twitter$tw <- str_replace_all(twitter$tw, "\\W", " ")
head(twitter$tw)

# 단어 빈도표 만들기
