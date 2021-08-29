# readxl 패키지 로드
library(readxl)

# 엑셀 데이터 불러오기
sales = read_xlsx("Cafe_Sales.xlsx", sheet = 1)
