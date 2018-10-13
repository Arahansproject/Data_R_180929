print(paste("올해는",2016,"년 입니다"))
print(paste("올해는",2017,"년 입니다"))
print(paste("올해는",2018,"년 입니다"))
print(paste("올해는",2019,"년 입니다"))

for(year in c(2016:2019)){
  print(paste("올해는",year,"년 입니다"))
}

## 1 ~ 10 까지
## print("숫자 1 는 정수 입니다")

for(num in c(1:10)){
  print(paste("숫자",num,"는 정수 입니다"))
}


# 1 ~ 10 까지
# print("숫자 1 는 홀수 입니다")
# print("숫자 2 는 짝수 입니다")

for (x in 1:10) {
  if(x %% 2 == 1){
    print(paste("숫자", x,"는 홀수 입니다"))
  }else{
    print(paste("숫자", x,"는 짝수 입니다"))
  }
}

# 1부터 10까지를 출력하시오?
for (x in 1:10) {
  print(paste(x,"+"))
}

# 1부터 10까지를 합을 구하시오?
s <- 0
for (x in 1:10) {
  s <- s+x
  print(s)
}
print(s)

# 문제 1 부터 100까지의 짝수의 합과 홀수의 합을 출력하시오?
a <- 0 # 홀수의 합
b <- 0 # 짝수의 합
for (x in 1:100) {
  if(x %% 2 == 1){
    a <- a+x
  }else{
    b <- b+x
  }
}
print(paste("홀수의 합:",a))
print(paste("짝수의 합:",b))

