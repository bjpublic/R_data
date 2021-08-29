# 5.1 readxl 패키지를 이용하여 엑셀 데이터 불러오기
# readxl 패키지 로드
library(readxl)

# 엑셀 데이터 불러오기
sales = read_xlsx("Cafe_Sales.xlsx", sheet = 1)

# 데이터 앞부분 탐색
head(sales)

# 데이터 뒷부분 탐색
tail(sales)

is.na(sales$order_id)
table(is.na(sales$order_id))
table(is.na(sales$order_date))
table(is.na(sales$category))
table(is.na(sales$item))
table(is.na(sales$price))

sales = na.omit(sales)
sales

head(sales, n = 12)

nrow(sales)

length(unique(sales$order_id))

sort(unique(sales$order_id))

sort(unique(sales$order_id), decreasing = TRUE)

unique(sales$order_date)

unique(sales$category)

unique(sales$item)

unique(sales$price)

# 5.2 카페에서 가장 많이 판매한 메뉴 확인하기
table(sales$item)

# 내림차순 정렬하기
sort(table(sales$item), decreasing = TRUE)

sales_tr = data.frame(table(sales$item))
head(sales_tr)

sales_item = subset.data.frame(sales,
                               select = c("item", "price"))

head(sales_item)

sales_item = unique(sales_item)
sales_item

# 잘못된 계산
sales_tr$Freq*sales_item$price

item_list = merge(sales_tr,
                  sales_item,
                  by.x = "Var1",
                  by.y = "item")

head(item_list)

item_list$amount = item_list$Freq*item_list$price

head(item_list)

sum(item_list$amount)

# 5.3 요일별로 판매한 메뉴 확인하기
sales$weekday = weekdays(sales$order_date)

head(sales)

table(sales$weekday)

date_info = data.frame(weekday = c("월요일", "화요일", "수요일", "목요일",
                                   "금요일", "토요일", "일요일"),
                       day = c("평일", "평일", "평일", "평일", "평일",
                               "주말", "주말"))

date_info

sales = merge(sales, date_info)
head(sales)

table(sales$day)

# 5.4  계절별로 판매한 메뉴 확인하기
sales$month = months(sales$order_date)

sales

for(i in 1:nrow(sales)){
  if(sales$month[i] == "1월"){
    sales$season[i] = "겨울"
  }else if(sales$month[i] == "2월"){
    sales$season[i] = "겨울"
  }else if(sales$month[i] == "3월"){
    sales$season[i] = "봄"
  }else if(sales$month[i] == "4월"){
    sales$season[i] = "봄"
  }else if(sales$month[i] == "5월"){
    sales$season[i] = "봄"
  }else if(sales$month[i] == "6월"){ 
    sales$season[i] = "여름"
  }else if(sales$month[i] == "7월"){ 
    sales$season[i] = "여름"
  }else if(sales$month[i] == "8월"){ 
    sales$season[i] = "여름"
  }else if(sales$month[i] == "9월"){ 
    sales$season[i] = "가을"
  }else if(sales$month[i] == "10월"){ 
    sales$season[i] = "가을"
  }else if(sales$month[i] == "11월"){ 
    sales$season[i] = "가을"
  }else
    sales$season[i] = "겨울"
}
    
for(i in 1:nrow(sales)){
  if(sales$month[i]=="12월"|sales$month[i]=="1월"|sales$month[i]=="2월"){
    sales$season[i] = "겨울"
  }else if(sales$month[i]=="3월"|sales$month[i]=="4월"|sales$month[i]=="5월"){
    sales$season[i] = "봄"
  }else if(sales$month[i]=="6월"|sales$month[i]=="7월"|sales$month[i]=="8월"){
    sales$season[i] = "여름"
  }else
    sales$season[i] = "가을"
}
  
sales

table(sales$season)

# 5.5  R에서 시각화하기
# 5.5.2  R 시각화 대표 패키지 ggplot2
install.packages("ggplot2")
library(ggplot2)
  
head(iris)

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width))

ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)
       +   geom_point()

ggplot(iris, aes(x = Sepal.Length,
                 y = Sepal.Width,
                 label = Species))+
       geom_point() +
       geom_text(size = 3,
                 hjust = 0,
                 nudge_x = 0.05)
       

base = ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
       geom_point()
       
x축 반전
base +scale_x_reverse()
       
# y축 반전
base +scale_y_reverse()

# x축 편집(0부터 10까지)
base + xlim(0, 10)

# y 축 편집(0부터 5까지)
base + ylim(0, 5)

# [그림 5-12] ggplot() 기본 테마 결과
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
       geom_point()

# [그림 5-13] theme_bw() 테마 적용 결과
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
       geom_point() +
       theme_bw()

# [그림 5-14] 자유 편집한 테마 적용 결과1
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
       labs(title = "Iris Scatter Plot") +
       geom_point() +
       theme()

# [그림 5-15] 자유 편집한 테마 적용 결과2
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width)) +
       labs(title = "Iris Scatter Plot") +
       geom_point() +
       theme(
         plot.title = element_text(size = rel(2)),
         axis.line.x.bottom = element_line(color = "black"),
         axis.line.y.left = element_line(color = "black")
       )

# 5.5.3  ggplot2 패키지를 이용한 시각화 예시
sample = data.frame(x = round(rnorm(3, 50, 10), 0),
                    y = round(rnorm(3, 57, 3), 0),
                    category = c("a", "b", "c"))

ggplot(sample, aes(x = x, y = y)) +
       geom_line(size = 1,
                 color = "#20639B")

ggplot(sample, aes(x = x, y = y)) +
       geom_line(size = 1,
                 color = "#20639B") +
       geom_point()

# 5.6  매출 현황 그래프로 분석하기
 5.6.1  카테고리별 판매 건수 시각화하기
# 패키지 불러오기
library(ggplot2)
library(readxl)

# 데이터 불러오기
sales = read_xlsx("Cafe_Sales.xlsx")
target = data.frame(table(sales$category))
       
       
# 시각화하기
ggplot(target, aes(x = Var1, y = Freq)) +
       geom_col() +
       geom_text(label = paste0(target$Freq, "건"), nudge_y = 1000)
       
# 5.6.2  월별 판매 건수 시각화하기
# 년 칼럼과 월 칼럼 생성
sales$date_ym = format(sales$order_date, "%Y-%m")

# 년/월별 판매 건수
target = data.frame(table(sales$date_ym))
target_12 = tail(target, 12)

ggplot(target_12, aes(x = Var1, y = Freq, group = 1))

ggplot(target_12, aes(x = Var1, y = Freq, group = 1)) +
       geom_line(size = 1,
                 color = "#000000",
                 inetype = 2)

ggplot(tail(target, 12), aes(x = Var1, y = Freq, group = 1)) +
       geom_line(size = 1,
                 color = "#000000") +
       geom_point(color = "#173F5F") +
       geom_text(aes(label = Freq), nudge_y = 100)

# 5.6.3  요일별 판매 건수 시각화하기
# 요일 추가
sales$weekday = weekdays(sales$order_date)

# 요일별 건수
target = data.frame(table(sales$weekday))
target

# 비율 계산
target$por = target$Freq/sum(target$Freq)*100

# 막대 그래프 생성
ggplot(target, aes(x ="", y = por, fill = Var1)) +
       geom_col()

# 파이 차트 옵션 설정하기
ggplot(target, aes(x ="", y = por, fill = Var1)) +
       geom_col() +
       coord_polar(theta = "y")
       
# 그래프에 레이블 추가
ggplot(target, aes(x ="", y = por, fill = Var1)) +
       geom_col() +
       coord_polar(theta = "y") +
       geom_text(aes(label = paste0(Var1, "\n", round(por, 2), "%")),
                 position = position_stack(vjust = 0.5))

ggplot(target, aes(x ="", y = por, fill = Var1)) +
       geom_col() +
       coord_polar(theta = "y") +
       geom_text(col = "white",
                 aes(label = paste0(Var1, "\n", round(por, 2), "%")),
                 position = position_stack(vjust = 0.5)) +
       scale_fill_manual(values = c("#000000", "#222222",
                                    "#444444", "#666666",
                                    "#888888", "#999999"))

ggplot(target, aes(x ="", y = por, fill = Var1)) +
       geom_col() +
       coord_polar(theta = "y") +
       geom_text(col = "white",
                 aes(label = paste0(Var1, "\n", round(por, 2), "%")),
                 position = position_stack(vjust = 0.5)) +
       scale_fill_manual(values = c("#000000", "#222222",
                                    "#444444", "#666666",
                                    "#888888", "#999999")) +
       theme(legend.position = "none",
             panel.background = element_blank(),
             axis.text = element_blank(),
             axis.title = element_blank(),
             axis.ticks = element_blank())

