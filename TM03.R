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
# setp 1. 데이터를 로딩한다
txt <- readLines("jeju.txt")
head(txt)

# step 3. 명사만 추출
nouns <-
  sapply(
    txt,
    extractNoun,
    USE.NAMES = F
  )
class(nouns)
head(nouns, 10)
cdata <- unlist(nouns) # 각 단어를 낱개로 분리
cdata <- stringr::str_replace_all(cdata,"[^[:alpha:]]"," ") 
cdata <- gsub(" ","",cdata)

gsubTxt <- readLines("제주도여행코스gsub(1).txt")
cnt <- length(gsubTxt)
for (i in 1:cnt) {
  cdata <- gsub(gsubTxt[i],"", cdata)
}
cdata
cdata <- Filter(function(x){nchar(x) >= 2}, cdata)
write(unlist(cdata), "jeju_2.txt")
nouns <- read.table("jeju_2.txt")
nrow(nouns)
wordcloud <- table(nouns)
head(sort(wordcount, decreasing = T),30)
top10 <- head(sort(wordcount, decreasing = T),10)
pie(top10, 
    col = rainbow(10),
    radius = 1,
    main="제주도 추천 여행코스 TOP 10")

# step 2. 특수문자를 제거
# txt <- stringr::str_replace_all(txt, "\\W", " ") # 특수문자 제거, 한글만 남기는건 대문자 W
# txt <- stringr::str_replace_all(txt,"[^[:alpha:]]"," ") 

# step 3-1. 특정단어 삭제하기
gsubTxt <- readLines("제주도여행코스gsub(1).txt")
gsubTxt
cnt <- length(gsubTxt)
print(paste("삭제하려는 단어의 수:", cnt))
for (i in 1:cnt) {
  nouns <- gsub(gsubTxt[i],"", nouns)
}
nouns

# step 4. 단어별로 빈도표 작성
wordcount <- table(unlist(nouns))
df_word <- as.data.frame(wordcount, stringsAsFactors = F)

# step 5. 변수명 수정
names(df_word)
df_word <- dplyr::rename(
  df_word,
  word = Var1,
  freq = Freq
)
df_word

# step 6. 2글자 이상만 추출
df_word <- dplyr::filter(df_word, nchar(word)>=2)
df_word

# step 7. 빈도순 정렬 후 상위 20단어만 추출
top_20 <- df_word %>% 
  dplyr::arrange(desc(freq)) %>% 
  head(20)
top_20

# step 8. Word cloud 만들기
wordcloud::wordcloud(
  words = df_word$word,
  freq = df_word$freq,
  min.freq = 2,
  max.words = 200,
  random.order = F,
  rot.per = .1,
  scale = c(4, 0.3),
  colors = brewer.pal(8, "Dark2")
)
