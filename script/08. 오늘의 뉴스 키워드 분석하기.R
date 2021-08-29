# 8.2  httr 패키지를 이용하여 뉴스 데이터 수집하기
install.packages("httr")
library(httr)

news = GET(url = "https://openapi.naver.com/v1/search/news.json?",
           add_headers("X-Naver-Client-Id" = cId,
                       "X-Naver-Client-Secret" = cSec),
           query = list(query = "코로나",
                        display = 100,
                        start = 1,
                        sort = "date"))

news

content(news)

content(news)$total

# 8.4  KoNLP 패키지를 이용하여 한글 자연어 처리하기
# 8.4.1  KoNLP 패키지 설치하기
install.packages("rJava")
library(rJava)

source("https://install-github.me/talgalili/installr")

installr::install.java()

library(rJava)

install.packages("remote")
library(remote)

remotes::install_github("haven-jeon/KoNLP",
                        upgrade = "never",
                        INSTALL_opts = c("--no-multiarch"))

library(KoNLP)

# 8.4.2  전기자동차 관련 뉴스 수집하기
library(httr)
url = "https://openapi.naver.com/v1/search/news.json?"
sample_news = GET(url = url,
                  add_headers("X-Naver-Client-Id" = cId,
                              "X-Naver-Client-Secret" = cSec),
                  query = list(query = "전기자동차",
                               display = 1,
                               start = 1,
                               sort = "date"))

content(sample_news)$total

all_news = data.frame()
all_news

URL = "https://openapi.naver.com/v1/search/news.json?"
search = "전기자동차"

for(i in 1:10){
  param = list(query = search,
               display = 100,
               start = i,
               sort = "date")
  
  news = GET(url = URL,
             add_headers("X-Naver-Client-Id" = cId,
                         "X-Naver-Client-Secret" = cSec),
             query = param)
  
  body = data.frame(t(sapply(content(news)$item, data.frame)))
  all_news = rbind(all_news, body)
  Sys.sleep(0.1)
}

# 8.4.3  뉴스 데이터 분석하기
all_news$title[1:10]

pat = "<b>|</b>|&quot;"
rep = ""

title = gsub(pattern = pat,
             replacement = rep,
             x = all_news$title)

head(title, 10)

useNIADic()

noun_list = extractNoun(title)

head(noun_list)

tb_noun = table(unlist(noun_list))

length(tb_noun)

head(tb_noun)

df_noun = data.frame(tb_noun)
top10_noun = head(df_noun, 10)

ggplot(top10_noun) +
  geom_bar(aes(x = reorder(Var1, -Freq), y = Freq), stat = "identity")

str(df_noun)

df_noun$Var1 = as.character(df_noun$Var1)
df_noun = df_noun[nchar(df_noun$Var1) > 1,]
top10_noun = head(df_noun, 10)

ggplot(top10_noun) +
  geom_bar(aes(x = reorder(Var1, -Freq), y = Freq), stat = "identity")

# 8.5  wordcloud 패키지를 이용한 워드클라우드
# 8.5.1  wordcloud 패키지를 이용한 시각화
install.packages("wordcloud")
library(wordcloud)
library(RColorBrewer)

pat = "<b>|</b>|&quot;|Q&amp;A|\\.|\\'|,|…|·|ㆍ|"|'|'"

rep = ""

title = gsub(pattern = pat,
             replacement = rep,
             x = all_news$title)

head(title, 10)

noun_list = extractNoun(title)
tb_noun = table(unlist(noun_list))
df_noun = data.frame(tb_noun)

[그림 8-15] wordcloud 기본 시각화
wordcloud(words = df_noun$Var1,
          freq = df_noun$Freq)

[그림 8-16] wordcloud 옵션 설정
wordcloud(words = df_noun$Var1,
          freq = df_noun$Freq,
          random.order = FALSE,
          min.freq = 20,
          colors = brewer.pal(8, "Dark2"))

# 8.5.2  wordcloud2 패키지를 이용한 시각화
install.packages("wordcloud2")
library(wordcloud2)

pat = "<b>|</b>|&quot;|Q&amp;A|\\.|\\'|,|…|·|ㆍ|"|'|'"

rep = ""

title = gsub(pattern = pat,
             replacement = rep,
             x = all_news$title)

head(title, 10)

noun_list = extractNoun(title)
tb_noun = table(unlist(noun_list))
df_noun = data.frame(tb_noun)

wordcloud2(data = df_noun,
           color = "random-dark",
           shape = "circle",
           fontFamily = "맑은고딕",
           fontWeight = 550,
           size = 2,
           widgetsize = c(900, 500))

# [그림 8-18] 로고 적용하기
wordcloud2(data = df_noun,
           figPath = "logo.png")

# [그림 8-19] 문자 'R' 적용하기
letterCloud(df_noun, "R", wordSize = 1)

# 8.6  오늘의 뉴스 그래프로 분석하기
URL = "https://openapi.naver.com/v1/search/news.json?"
search = "전기자동차"

all_news = data.frame()
for(i in 1:100){
   param = list(query = search,
                display = 100,
                start = i,
                sort = "sim")
   
   news = GET(url = url,
              add_headers("X-Naver-Client-Id" = cId,
                          "X-Naver-Client-Secret" = cSec),
              query = param)
   
   body = data.frame(t(sapply(content(news)$item, data.frame)))
        
   all_news = rbind(all_news, body)
   Sys.sleep(0.1)
}

format(Sys.time(), "%Y-%m-%d %a")

Sys.setlocale(category = "LC_TIME",
              locale = "C")

all_news$pubDate = as.Date(unlist(all_news$pubDate), "%a, %d %b %Y")

ggplot(all_news, aes(x = pubDate)) +
   geom_line(stat = "count", color = "#EEEEEE", size = 1.5) + 
   geom_point(stat = "count", color = "#424242", size = 2) +
   geom_text(aes(label = ..count..),
             stat = "count",
             position = position_nudge(y = 150)) +
   labs(title = "전기자동차 뉴스 트렌드") +
   xlab("날짜") +
   ylab("") +
   scale_x_date(date_labels = "%m-%d") +
   theme(text = element_text(size = 15),
         panel.background = element_blank(),
         axis.ticks = element_blank())

pat = "<b>|</b>"
rep = ""
all_news$title = gsub(pat, rep, all_news$title)

pat1 = "&quot;|Q&amp;A|<U+00A0>|\\.|\\'|,|…|·|ㆍ|"|"|!|'|'|\\(|\\)"
rep1 = " "
all_news$title = gsub(pat1, rep1, all_news$title)

top = data.frame(1:10)
for(i in 1:length(unique(all_news$pubDate))){
   sub_news = all_news[all_news$pubDate==sort(unique(all_news$pubDate))[i],] +   
   df_target = data.frame(table(unlist(strsplit(sub_news$title, " "))))
   df_target = df_target[order(df_target$Freq, decreasing = TRUE),]
   df_target$Var1 = as.character(df_target$Var1)
   df_target = df_target[nchar(df_target$Var1) > 1,]

   top10 = head(df_target, 10)

   top = cbind(top, top10)
}
