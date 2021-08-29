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
library(readxl)
paper = read_xlsx("paper.xlsx")

dfDissertation = paper[paper$dbCode == "DIKO",]
unique(dfDissertation$schoolName)

trans = function(name){
            name = gsub("大學校|大學敎", "대학교", name)
            name = gsub("大學院", "대학원", name)
            name = gsub("釜山", "부산", name)
            name = gsub("暻園", "경원", name)
            name = gsub("慶北", "경북", name)
            name = gsub("高麗", "고려", name)
            name = gsub("亞洲", "아주", name)
            name = gsub("順天鄕", "순천향", name)
            name = gsub("國民", "국민", name)
            name = gsub("漢陽", "한양", name)
            name = gsub("嶺南", "영남", name)
            name = gsub("忠南", "충남", name)
            name = gsub("忠北", "충북", name)
            name = gsub("忠州", "충주", name)
            name = gsub("慶雲", "경운", name)
            name = gsub("水原", "수원", name)
            name = gsub("世宗", "세종", name)
            name = gsub("淸州", "청주", name)
            name = gsub("濟州", "제주", name)
            name = gsub("釜慶", "부경", name)
            name = gsub("成均館", "성균관", name)
            name = gsub("中央", "중앙", name)
            name = gsub("建國", "건국", name)
            name = gsub("尙州", "상주", name)
            name = gsub("翰林", "한림", name)
            name = gsub("京畿", "경기", name)
            name = gsub("韓南", "한남", name)
            name = gsub("市立", "시립", name)
            return(name)
}

dfDissertation$schoolName = trans(dfDissertation$schoolName)

school = unique(dfDissertation$schoolName)
schoolEng = data.frame(origin = grep("[A-z]", school, value = T))

dicSchool1 = data.frame(origin = grep("대학원$", school, value = T))

dicSchool2 = data.frame(origin = grep("대학교$|기술원$", school, value = T),
                        fixed = grep("대학교$|기술원$", school, value = T))

dictSchool = rbind(schoolEng, dicSchool1, dicSchool2)
dictSchool

Dissertation = merge(x = dfDissertation,
                     y = dictSchool,
                     by.x = "schoolName",
                     by.y = "origin",
                     all.x = TRUE)

uniSchool = unique(Dissertation$fixed)
length(uniSchool)

dfSchool = data.frame(table(Dissertation$fixed))
dfSchool = dfSchool[order(dfSchool$Freq, decreasing = TRUE),]

head(dfSchool, 10)
table(Dissertation$degree)

library(readxl)
paper = read_xlsx("paper.xlsx")

year = data.frame(table(paper$year, paper$search),
                  stringAsFactor = FALSE)

year$Var1 = as.character(year$Var1)
year$Var1 = as.integer(year$Var1)
year$type = as.integer(year$Var2)

ggplot(year, aes(x = Var1, y = Freq, color = Var2)) +
            geom_line(stat = "identity",
                      linetype = year$type,
                      size = year$type/4) +
            scale_color_manual(values = c("#000000", "#333333",
                                          "#666666", "#999999")) +
            labs(title = "4가지 검색 키워드별 논문 트렌드") +
            theme(title = element_text(size = 14, face = "bold"),
                  axis.ticks = element_blank(),
                  axis.title = element_blank(),
                  panel.background = element_blank())

# 10.5 논문 비정형 데이터 분석하기
# 10.5.1  논문 제목 분석하기
library(readxl)
paper = read_excel("paper.xlsx")

# 제목에 한글이 포함된 논문 수
length(grep("[가-힣]", paper$title))

# 영문 제목의 논문 비율
(1-length(grep("[가-힣]", paper$title))/length(paper$title))*100

# 한글이 포함된 논문
korTitle = paper[grep("[가-힣]", paper$title), 15]

# 영문 논문
engTitle = paper[-grep("[가-힣]", paper$title), 15]

# 한글이 포함된 논문
library(KoNLP)

korextNoun = unlist(extractNoun(korTitle))
kenOver1 = korextNoun[nchar(korextNoun)>1]

kenDf = data.frame(table(kenOver1))
kenDf = kenDf[order(kenDf$Freq, decreasing = TRUE),]

head(kenDf, n = 10)

# 불용어 리스트
stopword = "of|for|the|on|in|and|with|by|an"

# 키워드 재구성
kenEli = gsub(pattern = stopword, "", kenOver1)
kenDf2 = data.frame(table(kenEli))
kenDf2 = kenDf2[order(kenDf2$Freq, decreasing = TRUE),]

> head(kenDf2, 10)

# 영어 논문
engextNoun = unlist(strsplit(engTitle, " "))
eenOver1 = engextNoun[nchar(engextNoun) > 1]
eenOver1 = toupper(eenOver1)

eenDf = data.frame(table(eenOver1))
eenDf = eenDf[order(eenDf$Freq, decreasing = TRUE),]

head(eenDf)

# 불용어 리스트
stopword = "of|for|the|on|in|and|with|by|to|an"

키워드 재구성
eenEli = gsub(pattern = stopword, "", eenOver1)
eenDf2 = data.frame(table(eenEli))
eenDf2 = eenDf2[order(eenDf2$Freq, decreasing = TRUE),]

head(eenDf2, 10)

# 10.5.2  논문 초록 분석하기
library(readxl)
paper = read_excel("paper.xlsx")

# 초록에 한글이 포함된 논문 수
length(grep("[가-힣]", paper$abstractInfo))

# 영문 초록의 논문 비율
(1-length(grep("[가-힣]", paper$abstractInfo))/length(paper$abstractInfo))*100

# 한글이 포함된 논문
korAbs = paper[grep("[가-힣]", paper$ abstractInfo), 4]

# 영문 논문
engAbs = paper[-grep("[가-힣]", paper$abstractInfo), 4]

# 한글이 포함된 논문
library(KoNLP)
korextNoun = unlist(extractNoun(korAbs))
kenOver1 = korextNoun[nchar(korextNoun) > 1]

kenDf = data.frame(table(kenOver1))
kenDf = kenDf[order(kenDf$Freq, decreasing = TRUE),]
head(kenDf, n = 10)

# 영어 논문
engextNoun = unlist(strsplit(engAbs, " "))
eenOver1 = engextNoun[nchar(engextNoun) > 1]
eenOver1 = toupper(eenOver1)

eenDf = data.frame(table(eenOver1))
eenDf = eenDf[order(eenDf$Freq, decreasing = TRUE),]
head(eenDf)

# 불용어 리스트
Stopword = c("of", "for", "the", "on", "in", "and",
             "with", "by", "to", "an", "is","was",
             "as", "that", "using", "which", "high",
             "can", "has", "been", "were", "are",
             "we", "be", "this", "at", "from", "it",
             "have", "or", "used")

# 불용어 변환
pattern = paste0(paste0("^", toupper(stopword), "$"),
                 collapse = "|")

# 키워드 재구성
eenEli = gsub(pattern = pattern, "", eenOver1)
eenDf2 = data.frame(table(eenEli))
eenDf2 = eenDf2[order(eenDf2$Freq, decreasing = TRUE),]

head(eenDf2, 11)

# 10.6  tm 패키지를 이용하여 Term Document Matrix 생성하기
# 10.6.1  Bag-of-words
text1 = "우리 아파트가 생기고 나서 우리 지역의 인구는 어떻게 변했을까?"
text2 = "우리 가게 근처엔 어떤 연령대 사람들이 살고 있지?"
text3 = "전체 인구는 얼마나 될까?"

install.packages("tm")
library(tm)

cvEnc1 = enc2utf8(text1)
Encoding(cvEnc1)

cvEnc2 = enc2utf8(text2)
Encoding(cvEnc2)

cvEnc3 = enc2utf8(text3)
Encoding(cvEnc3)

ctrl = list(wordLengths = c(2, Inf))

termFreq(cvEnc1,
         control = ctrl)

termFreq(cvEnc2,
         control = ctrl)

termFreq(cvEnc3,
         control = ctrl)

# 10.6.2  문서 단어 행렬(Document-Term Matrix)
text = c("올해 서울에서는 99년만에 가장 빨리 벚꽃이 피었습니다",
         "서울의 벚꽃 개화 시점은 서울기상관측소에 있는 왕벚나무를 기준",
         "서울 지역에 따라 이보다 더 빨리 벚꽃이 핀 지역도 있을 수 있습니다",
         "여의도 윤중로의 관측목은 아직 꽃망울을 터뜨리지 않았습니다")

cvEnc = enc2utf8(text)
Encoding(cvEnc)

vs = VectorSource(cvEnc)
cps = Corpus(vs)
cps

dtm = DocumentTermMatrix(cps)
inspect(dtm)

# 10.6.3  TF-IDF(Term Frequency-Inverse Document Frequency)
text = c("올해 서울에서는 99년만에 가장 빨리 벚꽃이 피었습니다",
         "서울의 벚꽃 개화 시점은 서울기상관측소에 있는 왕벚나무를 기준",
         "서울 지역에 따라 이보다 더 빨리 벚꽃이 핀 지역도 있을 수 있습니다",
         "여의도 윤중로의 관측목은 아직 꽃망울을 터뜨리지 않았습니다")

cvEnc = enc2utf8(text)
Encoding(cvEnc)

vs = VectorSource(cvEnc)
cps = Corpus(vs)
cps

ctrl = list(wordLengths = c(2, Inf),
            weighting = function(x){
                        weightTfIdf(x, normalize = TRUE)}
           )

tfidf = DocumentTermMatrix(cps,
                           control = ctrl)
tfidf

round(as.matrix(tfidf)[,1:8], 3)

# 10.7  LDA Topic modeling을 이용하여 논문 주제 도출하기
install.packages("topicmodels")
library(topicmodels)

library(readxl)
paper = read_xlsx(path = "paper.xlsx")

cvTitle = enc2utf8(paper$title)
cpsTitle = Corpus(VectorSource(unlist(cvTitle)))
cpsTitle

dtmTitle = DocumentTermMatrix(cpsTitle,
                              control = list(minWordLength = 3))
dtmTitle

ldaTitle = LDA(dtmTitle,
               k = 10,
               control = list(seed = 0214))
ldaTitle

topic = topics(ldaTitle)

head(topics(ldaTitle), 10)

Terms = terms(ldaTitle, 10)

Terms[,1:10]

# 10.8  shiny 패키지를 이용하여 논문 분석 시스템 웹 화면 구축하기
# 10.8.1  shiny란
install.packages("shiny")
library(shiny)

runExample("01_hello")

library(shiny)

# UI 영역
ui = fluidPage()

# Server 영역
server = function(input, output){ }

# App 실행
shinyApp(ui = ui, server = server)

ui = fluidPage(
            fluidRow(
                        textInput("name", "당신의 이름은 무엇인가요?"),
                        numericInput("age", "당신의 나이는 어떻게 됩니까?",
                                     value = 0, min = 0, max = 100),
                        dateInput("birth", "태어난 날은 언제인가요?"),
                        selectInput(
                                    "search", "관심 분야는?", unique(paper$search),
                                    multiple = TRUE),
                        textAreaInput("intro", "자기소개"),
                        fileInput("upload", "본인의 포트폴리오를 게시하십시오")
            ),
            fluidRow(
                        actionButton("click", "저장", class = "btn-save"),
                        actionButton("click", "취소", class = "btn-cancel")
            )
)
server = function(input, output, session) {}
shinyApp(ui, server)

library(readxl)
paper = read_xlsx(path = "paper.xlsx")
target = subset.data.frame(paper,
                           select = c("title", "year", "publisher",
                                      "search", "affiliation"))
ui = fluidPage(
            textOutput("text"),
            verbatimTextOutput("code"),
            dataTableOutput("dynamic")
)

server = function(input, output, session) {
            output$text = renderText({
                        "디스플레이 동향 분석"
            })
            output$code = renderPrint(paste0(nrow(paper), "건"))
            output$dynamic = renderDataTable(, options = list(pageLength = 5))
}

shinyApp(ui, server)

# 10.8.2  논문 분석 시스템 구축하기
library(readxl)
library(shiny)
library(KoNLP)

paper = read_xlsx(path = "paper.xlsx")

ui = fluidPage()

server = function(input, output){ }

ui = fluidPage(
            tableOutput("data")
)

server = function(input, output){
            output$data = renderTable(subset.data.frame(paper,
                                                        select = c("title",
                                                                   "search",
                                                                   "year")))
}

ui = fluidPage(selectInput("search", "주제 영역",
                           choices = unique(paper$search)),
               selectInput("year", "발행년도",
                           choices = unique(paper$year)),
               tableOutput("data"))

server = function(input, output){
            output$data = renderTable(subset.data.frame(paper,
                                                        subset = c(paper$search == input$search &
                                                                   paper$year == input$year),
                                                        select = c("title", "search", "year")))
}

shinyApp(ui, server)

ui = fluidPage(fluidRow(column(width = 3,
                               selectInput("search", "주제 영역",
                                           choices = unique(paper$search))),
                        column(width = 3,
                               selectInput("year", "발행년도",
                                           choices = sort(unique(paper$year))))),
               tableOutput("data"))

server = function(input, output){
            output$data = renderTable(subset.data.frame(paper,
                                                        subset = c(paper$search == input$search &
                                                                   paper$year == input$year),
                                                        select = c("title", "search", "year")))
}

shinyApp(ui, server)

ui = fluidPage(fluidRow(column(width = 3,
                               selectInput("search", "주제 영역",
                                           choices = c("ALL",
                                                       unique(paper$search)))),
                        column(width = 3,
                               selectInput("year", "발행년도",
                                           choices = c("ALL",
                                                       sort(unique(paper$year),
                                                            decreasing = TRUE))))),
               dataTableOutput("data"))

server = function(input, output){
            output$data = renderDataTable(
                        if(input$search == "ALL" & input$year == "ALL"){
                                    subset.data.frame(paper,
                                                      select = c("search", "title", "year",
                                                                 "author", "publisher"))
                        }else if(input$search == "ALL"){
                                    subset.data.frame(paper,
                                                      subset = c(paper$year == input$year),
                                                      select = c("search", "title", "year",
                                                                 "author", "publisher"))
                        }else if(input$year == "ALL"){
                                    subset.data.frame(paper,
                                                      subset = c(paper$search == input$search),
                                                      select = c("search", "title", "year",
                                                                 "author", "publisher"))
                        }else{
                                    subset.data.frame(paper,
                                                      subset = c(paper$search == input$search &
                                                                 paper$year == input$year), 
                                                      select = c("search", "title", "year",
                                                                 "author", "publisher"))
                        }, options = list(pageLength = 5))
}

shinyApp(ui, server)
                        
ui = fluidPage(
            navbarPage("Pa-Miner"),
            fluidRow(
                        column(width = 3,
                               selectInput("search", "주제 영역",
                                           choices = c("ALL", unique(paper$search)))),
                        column(width = 3,
                               selectInput("year", "발행년도",
                                           choices = c("ALL",
                                                       sort(unique(paper$year),
                                                            ecreasing = TRUE))))),
            fluidRow(
                        plotOutput("plot"),
                        column(width = 12,
                               dataTableOutput("table"))))

server = function(input, output){
            output$plot = renderPlot(
                        if(input$search == "ALL"){
                                    ggplot(subset.data.frame(paper,
                                                             select = c("search", "title", "year",
                                                                        "author", "publisher")), aes(x = year)) +
                                    geom_line(stat = "count", size = 2, color = "#3CAEA3") +
                                    geom_point(stat = "count", size = 2, color = "#173F5F") +
                                    labs(title = "년도별 논문 동향 분석") +
                                    theme(title = element_text(size = 15),
                                          panel.background = element_blank())
                                    
                        }else{
                                    ggplot(subset.data.frame(paper,
                                                             subset = c(paper$search == input$search),
                                                             select = c("search", "title", "year",
                                                                        "author", "publisher")), aes(x = year)) +
                                    geom_line(stat = "count", size = 2, color = "#3CAEA3") +
                                    geom_point(stat = "count", size = 2, color = "#173F5F") +
                                    labs(title = "년도별 논문 동향 분석") +
                                    theme(title = element_text(size = 15),
                                          panel.background = element_blank())
                        })
            
            output$data = renderDataTable(
                        if(input$search == "ALL" & input$year == "ALL"){
                                    data = subset.data.frame(paper,
                                                             select = c("search", "title", "year",
                                                                        "author", "publisher"))
                        }else if(input$search == "ALL"){
                                    data = subset.data.frame(paper,
                                                             subset = c(paper$year == input$year),
                                                             select = c("search", "title", "year",
                                                                        "author", "publisher"))
                        }else if(input$year == "ALL"){
                                    data = subset.data.frame(paper,
                                                             subset = c(paper$search == input$search),
                                                             select = c("search", "title", "year",
                                                                        "author", "publisher"))
                        }else{
                                    data = subset.data.frame(paper,
                                                             subset = c(paper$search == input$search &
                                                                        paper$year == input$year),
                                                             select = c("search", "title", "year",
                                                                        "author", "publisher"))
                        }, options = list(pageLength = 5))
}
                        
shinyApp(ui, server)
