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
