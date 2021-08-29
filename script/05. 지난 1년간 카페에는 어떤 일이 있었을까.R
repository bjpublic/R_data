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

