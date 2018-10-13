install.packages("foreign")
library(foreign)
if("dplyr" %in% installed.packages("dplyr") == FALSE)install.packages("dplyr")
library(dplyr)
if("ggplot2" %in% installed.packages("ggplot2") == FALSE)install.packages("ggplot2")
library(ggplot2)
library(readxl)

raw_welfare <- read.spss(file="https://www.dropbox.com/s/1kipxmhaoo0e5yj/Koweps_hpc10_2015_beta1.sav?dl=1", to.data.frame = T)
getwd()
setwd("C:\\Users\\Administrator\\rlang_weekend2\\Data_R_180929")
raw_welfare <- read.spss(file="Koweps_hpc10_2015_beta1.sav", 
                         to.data.frame=T)
View(head(raw_welfare))

# 복사본 만들기
welfare <- raw_welfare
names(welfare)
welfare <- dplyr::rename(welfare,
                  sex = h10_g3, # 성별
                  birth = h10_g4, # 태어난 연도
                  marriage = h10_g10, # 혼인 상태
                  religion = h10_g11, # 종교
                  income = p1002_8aq1, # 월급
                  code_job = h10_eco9, # 직업 코드
                  code_region = h10_reg7 # 지역 코드
                  )
# 데이터의 일부 컬럼만 발췌하는 것 (부분집합 subset)
welfare <- subset(welfare, 
                  select = c(sex, birth, marriage, religion, income, code_job, code_region))
View(head(welfare))

# 성별에 따른 월급차이 - 성별에 따라 월급이 다를까?
# 변수 검토하기
class(welfare$sex)
table(welfare$sex)
# 이상치(Outlier) 결측 (NA)
welfare$sex <- ifelse(welfare$sex == 9, NA, welfare$sex)  # ifelse(조건, 조건 참일 경우 값, 거짓일 경우 값)
table(is.na(welfare$sex))
# 성별 항목 이름 부여
welfare$sex <-  ifelse(welfare$sex == 1, "남성", "여성")
table(welfare$sex)
qplot(welfare$sex)

### 월급 변수 검토 및 전처리
class(welfare$income)
summary(welfare$income)
qplot(welfare$income)+ # + 기호는 동일 줄에 위치해야함 다음음 줄로 내릴수 없음
  xlim(0,1000)
welfare$income <-  ifelse(
  welfare$income %in% c(0, 9999),
  NA,
  welfare$income
)
table(is.na(welfare$income))

sex_income <- welfare %>% 
  dplyr::filter(!is.na(income)) %>% 
  dplyr::group_by(sex) %>%
  dplyr::summarise(mean_income = mean(income))

sex_income
ggplot(
  data = sex_income,
  aes(x = sex, y = mean_income)
)+geom_col()

### 나이와 월급의 관계
welfare$birth <- ifelse(welfare$birth == 9999, NA, welfare$birth)
table(is.na(welfare$birth))

welfare$age <-  2015 - welfare$birth + 1
qplot(welfare$age)
age_income <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income))
age_income
ggplot(
  data = age_income,
  aes(
    x = age, 
    y = mean_income
  )
)+geom_line()

# 파생변수 만들기 : mutate()
welfare <- welfare %>% 
    dplyr::mutate(
    ageg = ifelse(age < 30, "초년", 
                ifelse(age < 40, "중년", "노년"))
    )

welfare
tabel(welfare$ageg)
qplot(welfare$ageg)
sex_income <- welfare %>% 
  dplyr::filter(!is.na(income)) %>% 
  group_by(ageg, sex) %>% 
  summarise(mean_income = mean(income))

# 성별 혼합 막대그래프
ggplot(
  data = sex_income,
  aes(
    x = ageg,
    y = mean_income,
    fill = sex
  )
)+geom_col()+
  scale_x_discrete(limits = c("초년", "중년", "노년")
  )

# 성별 분리 막대그래프
ggplot(
  data = sex_income,
  aes(
    x = ageg,
    y = mean_income,
    fill = sex
  )
)+geom_col(position = "dodge")+
  scale_x_discrete(limits = c("초년", "중년", "노년")
  )

### 나이 및 성별 월급 평균표
sex_age <- welfare %>% 
  filter(!is.na(income)) %>% 
  group_by(age, sex) %>% 
  summarise(mean_income = mean(income))

ggplot(
  data = sex_age,
  aes(
    x = age, 
    y = mean_income,
    col = sex
  )
)+geom_line()



