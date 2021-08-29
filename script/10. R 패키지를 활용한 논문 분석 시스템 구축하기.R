# 10.3 공공 데이터 API를 이용하여 학위 논문 수집하기
# 10.3.2 오픈 API 호출하기

# httr 패키지 설치 및 실행하기
install.packages("httr")
library(httr)

# rvest 패키지 설치 및 실행하기
install.packages("rvest")
library(rvest)

# 발급받은 인증키를 "인증키 입력하기"에 넣어줍니다.
keyValue = "인증키 입력하기"

# 오픈 API URL 정보
URL = "http://openapi.ndsl.kr/itemsearch.do" # 검색 키워드
search1 = "LCD"
search2 = "CRT"
search3 = "PDP"
search4 = "OLED"

paper = GET(URL,
            query = list(keyValue = keyValue,
                         version = 2.0,
                         target = "ARTI",
                         query = search,
                         searchField = "TI",
                         displayCount = 10,
                         startPosition = 1,
                         sortby = "title",
                         responseGroup = "simple",
                         returnType = "xml"))

paper

# 10.3.2 오픈 API 호출 결과 파싱하기
content(paper)

content(paper) %>% html_structure()

result = content(paper) %>%
  html_nodes("outputData") %>%
  html_children()

result

result[1] %>%
  html_children()

result[1] %>%
  html_children() %>%
  html_children()

resultText = result[1] %>%
  html_children() %>%
  html_children() %>%
  html_text()

resultTextMat = matrix(resultText, nrow = 1)
resultTextdf = data.frame(resultTextMat)

# 10.4 논문 정형 데이터 분석하기
# 10.4.1 자료 구분별 논문 데이터 분석하기
library(readxl)
paper = read_xlsx("paper.xlsx")

nrow(paper)
table(paper$dbCode)

df_dbCode = data.frame(table(paper$dbCode))
df_dbCode

ggplot(df_dbCode,
       aes(x = reorder(Var1, -Freq), y = Freq, fill = Var1)) +
  geom_bar(stat = "identity") +
  labs(title = "자료 구분별 논문 건수") +
  scale_fill_manual(values = c("#FFDFBA", "#BAFFC9", "#BAE1FF", 
                               "#FFB3BA", "#FFFFBA")) +
  theme(title = element_text(size = 14, face = "bold"),
        legend.position = "none",
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        panel.background = element_blank())

# 10.4.2  학술 출판사에 따라 논문 데이터 분석하기
library(readxl)
paper = read_xlsx("paper.xlsx")

uniPub = unique(paper$publisher)
length(uniPub)

head(uniPub, n = 10)

tbPub = data.frame(table(paper$publisher))
tbPub = tbPub[order(tbPub$Freq, decreasing = TRUE),]

head(tbPub, 10)

tbPub = tbPub[-1,]
head(tbPub, 10)

# 10.4.3  정규 표현식을 이용한 정형 데이터 분석
