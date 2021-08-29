# 9.2  YouTube 댓글 수집하기
# 9.2.1  OAuth 권한 연동하기
install.packages("tuber")
library(tuber)

app_id = "ID 입력"
app_secret = "Secret 입력"

yt_oauth(app_id = app_id,
         app_secret = app_secret,
         token = "")

# 9.2.2  YouTube 채널 및 영상 통계 정보 수집ㆍ분석하기
youtuber = data.frame(channel = c("부동산 읽어주는 남자",
                                  "신사임당",
                                  "슈카월드"),
                      channel_id = c("UC2QeHNJFfuQWB4cy3M-745g",
                                     "UCaJdckl6MBdDPDf75Ec_bJA",
                                     "UCsJ6RuBiTVWRX156FVbeaGg"))

# 세 차례 get_channel_stats() 함수를 이용해서 데이터 수집
youtuber_1 = get_channel_stats(channel_id = "UC2QeHNJFfuQWB4cy3M-745g")
yt1_stats = data.frame(channel = "부동산 읽어주는 남자", youtuber_1$statistics)

youtuber_2 = get_channel_stats(channel_id = "UCaJdckl6MBdDPDf75Ec_bJA")
yt2_stats = data.frame(channel = "신사임당", youtuber_2$statistics)

youtuber_3 = get_channel_stats(channel_id = "UCsJ6RuBiTVWRX156FVbeaGg")
yt3_stats = data.frame(channel = "슈카월드", youtuber_3$statistics)

yt_stats = rbind(yt1_stats, yt2_stats, yt3_stats)
yt_stats

yt_stats = data.frame()
for(i in 1:nrow(youtuber)){
  yt_stat = data.frame(channel = youtuber$channel[i],
                       get_channel_stats(youtuber$channel_id[i])$statistics),
  yt_stats = rbind(yt_stats, yt_stat)
}

yt_stats

# 채널별 전체 시청 수 시각화
ggplot(yt_stats, aes(x = channel, fill = channel)) +
   geom_bar(aes(y = viewCount), stat = "identity") +
   geom_text(aes(label = paste0(format(viewCount, big.mark = ","), " View"),
                 y = viewCount), stat = "identity", vjust = -0.5) +
   labs(title = "채널별 전체 시청 수") +
   xlab("") +
   ylab("") +
   theme(text = element_text(size = 15),
         panel.background = element_blank(),
         legend.position = "none",
         axis.ticks = element_blank(),
         axis.text.y = element_blank())

# 채널별 구독자 수 시각화
 ggplot(yt_stats, aes(x = channel, fill = channel)) +
    geom_bar(aes(y = subscriberCount), stat = "identity") +
    geom_text(aes(label = paste0(format(subscriberCount,
                                        big.mark = ","), " View"),
                  y = subscriberCount), stat = "identity", vjust = -0.5) +
   labs(title = "채널별 구독자 수") +
   xlab("") +
   ylab("") +
   theme(text = element_text(size = 15),
         panel.background = element_blank(),
         legend.position = "none",
         axis.ticks = element_blank(),
         axis.text.y = element_blank())

# 채널별 콘텐츠 수 시각화
ggplot(yt_stats, aes(x = channel, fill = channel)) +
   geom_bar(aes(y = videoCount), stat = "identity") +
   geom_text(aes(label = paste0(format(videoCount,
                                       big.mark = ","), " View"),
                 y = videoCount), stat = "identity", vjust = -0.5) +
   labs(title = "채널별 콘텐츠 수") +
   xlab("") +
   ylab("") +
   theme(text = element_text(size = 15),
         panel.background = element_blank(),
         legend.position = "none",
         axis.ticks = element_blank(),
         axis.text.y = element_blank())

mstVideo1 = get_stats(video_id = "aeOMKD9t9H0")
mstVideo1

mstVideo2 = get_stats(video_id = "x9mGWCcCJAE")
mstVideo2

mstVideo3 = get_stats(video_id = "e6Qa05lBdEI")
mstVideo3

mstv1df = data.frame(title = "쿠팡 1조원 적자에도 멈출 수 없는 이유",
                     mstVideo1)
mstv2df = data.frame(title = "절대로 전세 살지 마라 1부ㅣ부동산읽어주는남자",
                     mstVideo2)
mstV3df = data.frame(title = "부자는 알지만 가난한 사람은 모르는 것 (존리)",
                     mstVideo3)

mstvdf = rbind(mstv1df, mstv2df, mstV3df)
mstvdf[-1]

mstvdf$viewCount = as.integer(mstvdf$viewCount)
mstvdf$likeCount = as.integer(mstvdf$likeCount)
mstvdf$dislikeCount = as.integer(mstvdf$dislikeCount) > mstvdf$commentCount = as.integer(mstvdf$commentCount)

str(mstvdf)

# 콘텐츠별 시청 수 시각화
ggplot(mstvdf, aes(x = title, fill = title)) +
   geom_bar(aes(y = viewCount), stat = "identity") +
   geom_text(aes(label = format(viewCount, big.mark = ","),
                 y = viewCount), stat = "identity", vjust = -0.5) +
   labs(title = "콘텐츠별 시청 수") +
   xlab("") +
   ylab("") +
   theme(text = element_text(size = 15),
         panel.background = element_blank(),
         legend.position = "none",
         axis.ticks = element_blank(),
         axis.text.y = element_blank())

# 콘텐츠별 좋아요 수 시각화
ggplot(mstvdf, aes(x = title, fill = title)) +
   geom_bar(aes(y = likeCount), stat = "identity") +
   geom_text(aes(label = format(likeCount, big.mark = ","),
                 y = likeCount), stat = "identity", vjust = -0.5) +
   labs(title = "콘텐츠별 좋아요 수") +
        xlab("") +
        ylab("") +
   theme(text = element_text(size = 15),
         panel.background = element_blank(),
         legend.position = "none",
         axis.ticks = element_blank(),
         axis.text.y = element_blank())

# 콘텐츠별 싫어요 수 시각화
ggplot(mstvdf, aes(x = title, fill = title)) +
   geom_bar(aes(y = dislikeCount), stat = "identity") +
   geom_text(aes(label = format(dislikeCount, big.mark = ","),
                 y = dislikeCount), stat = "identity", vjust = -0.5) +
   labs(title = "콘텐츠별 싫어요 수") +
        xlab("") +
        ylab("") +
   theme(text = element_text(size = 15),
         panel.background = element_blank(),
         legend.position = "none",
         axis.ticks = element_blank(),
         axis.text.y = element_blank())

# 콘텐츠별 댓글 수 시각화
ggplot(mstvdf, aes(x = title, fill = title)) +
   geom_bar(aes(y = commentCount), stat = "identity") +
   geom_text(aes(label = format(commentCount, big.mark = ","),
                 y = commentCount), stat = "identity", vjust = -0.5) +
   labs(title = "콘텐츠별 댓글 수") +
        xlab("") +
        ylab("") +
   theme(text = element_text(size = 15),
         panel.background = element_blank(),
         legend.position = "none",
         axis.ticks = element_blank(),
         axis.text.y = element_blank())

# 9.2.3  YouTube 채널 및 영상 댓글 수집하기
# 슈카월드 - 쿠팡 1조원 적자에도 멈출 수 없는 이유
cmt_1 = get_all_comments(video_id = "aeOMKD9t9H0")

# 부동산 읽어주는 남자 - 절대로 전세 살지 마라 1부 | 부동산읽어주는남자
cmt_2 = get_all_comments(video_id = "x9mGWCcCJAE")

# 신사임당 - 부자는 알지만 가난한 사람은 모르는 것 (존리)
cmt_3 = get_all_comments(video_id = "e6Qa05lBdEI")

nrow(cmt_1)

nrow(cmt_2)

nrow(cmt_3)

# 9.3  RcppMeCab 패키지를 이용하여 한글 자연어 처리하기
# 9.3.1  RcppMeCab 패키지 설치하기
library(remotes)
install_github("junhewk/RcppMeCab")
library(RcppMeCab)

# 9.3.2  RcppMeCab 패키지를 이용하여 형태소 분석하기
sentence = "안녕하세요"
pos(sentence = sentence)

sentence = enc2utf8("안녕하세요")
pos(sentence = sentence)

# 슈카월드 인기 콘텐츠 댓글
cmt_pos_1 = posParallel(sentence = cmt_1$textOriginal,
                        format = "data.frame")

head(cmt_pos_1)

# 부동산 읽어주는 남자 인기 콘텐츠 댓글
cmt_pos_2 = posParallel(sentence = cmt_2$textOriginal,
                        format = "data.frame")

head(cmt_pos_2)

# 신사임당 인기 콘텐츠 댓글
cmt_pos_3 = posParallel(sentence = cmt_3$textOriginal,
                        format = "data.frame")

head(cmt_pos_3)

cmt_pos_1_cnt = data.frame(table(cmt_pos_1$doc_id))
head(cmt_pos_1_cnt)
summary(cmt_pos_1_cnt$Freq)

cmt_pos_2_cnt = data.frame(table(cmt_pos_2$doc_id))
head(cmt_pos_2_cnt)
summary(cmt_pos_2_cnt$Freq)

cmt_pos_3_cnt = data.frame(table(cmt_pos_3$doc_id))
head(cmt_pos_3_cnt)
summary(cmt_pos_3_cnt$Freq)

# 쿠팡 1조원 적자에도 멈출 수 없는 이유(히스토그램) > ggplot(cmt_pos_1_cnt) +
   geom_histogram(aes(Freq), bins = 100, fill = "#e56598", color = "white") +
   scale_x_continuous(limits = c(0, 200)) +
   scale_y_continuous(limits = c(0, 150)) +
   labs(title = "쿠팡 1조원 적자에도 멈출 수 없는 이유") +
   theme(legend.position = "none",
         axis.ticks = element_blank(),
         axis.title = element_blank(),
         panel.background = element_blank())

# 쿠팡 1조원 적자에도 멈출 수 없는 이유(상자 그림) > ggplot(cmt_pos_1_cnt) +
   geom_boxplot(aes(y = Freq)) +
   scale_y_continuous(limits = c(0, 650)) + +   labs(title = NULL) +
   theme(axis.ticks = element_blank(),
         axis.text.x.bottom = element_blank(), +         axis.title = element_blank(),
         panel.background = element_blank())

# 절대로 전세 살지 마라 1부 | 부동산읽어주는남자(히스토그램) > ggplot(cmt_pos_2_cnt) +
   geom_histogram(aes(Freq), bins = 100, fill = "#161240", color = "white") + +   scale_x_continuous(limits = c(0, 200)) +
   scale_y_continuous(limits = c(0, 150)) +
   labs(title = "절대로 전세 살지 마라 1부 | 부동산읽어주는남자") + +   theme(axis.ticks = element_blank(),
         axis.title = element_blank(),
         panel.background = element_blank())

# 절대로 전세 살지 마라 1부 | 부동산읽어주는남자(상자 그림)
ggplot(cmt_pos_2_cnt) +
   geom_boxplot(aes(y = Freq)) +
   scale_y_continuous(limits = c(0, 650)) + +   labs(title = NULL) +
   theme(axis.ticks = element_blank(),
         axis.text.x.bottom = element_blank(), +         axis.title = element_blank(),
         panel.background = element_blank())

# 부자는 알지만 가난한 사람은 모르는 것 (존리)(히스토그램) > ggplot(cmt_pos_3_cnt) +
   geom_histogram(aes(Freq), bins = 100, fill = "#7da1d4", color = "white") + +   scale_x_continuous(limits = c(0, 200)) +
   scale_y_continuous(limits = c(0, 150)) +
   labs(title = "부자는 알지만 가난한 사람은 모르는 것 (존리)") + +   theme(axis.ticks = element_blank(),
         axis.title = element_blank(),
         panel.background = element_blank()) # 부자는 알지만 가난한 사람은 모르는 것 (존리)(상자 그림)
ggplot(cmt_pos_3_cnt) +
   geom_boxplot(aes(y = Freq)) +
   scale_y_continuous(limits = c(0, 650)) + +   labs(title = NULL) +
   theme(axis.ticks = element_blank(),
         axis.text.x.bottom = element_blank(), +         axis.title = element_blank(),
         panel.background = element_blank())

# 9.5 긍·부정 사전을 이용하여 감성 분석하기
nego = readLines("nego_word.txt",
                 encoding = "UTF-8")

posi = readLines("posi_word.txt",
                 encoding = "UTF-8")

negoWord = data.frame(keyword = nego,
                      value = -1)

posiWord = data.frame(keyword = posi,
                      value = 1)

# 슈카월드 "쿠팡 1조원 적자에도 멈출 수 없는 이유" # 댓글 감성 분석
neg_1 = merge.data.frame(x = cmt_pos_1,
                         y = negoWord,
                         by.x = "token",
                         by.y = "keyword")

pos_1 = merge.data.frame(x = cmt_pos_1,
                         y = posiWord,
                         by.x = "token",
                         by.y = "keyword")

sentiment_1 = rbind(neg_1, pos_1)

# 부동산 읽어주는 남자 "절대로 전세 살지 마라 1부 | 부동산읽어주는남자" # 댓글 감성 분석
neg_2 = merge.data.frame(x = cmt_pos_2,
                         y = negoWord,
                         by.x = "token",
                         by.y = "keyword")

pos_2 = merge.data.frame(x = cmt_pos_2,
                         y = posiWord,
                         by.x = "token",
                         by.y = "keyword")

sentiment_2 = rbind(neg_2, pos_2)

# 신사임당 "부자는 알지만 가난한 사람은 모르는 것 (존리)" # 댓글 감성 분석
neg_3 = merge.data.frame(x = cmt_pos_3,
                         y = negoWord,
                         by.x = "token",
                         by.y = "keyword")

pos_3 = merge.data.frame(x = cmt_pos_3,
                         y = posiWord,
                         by.x = "token",
                         by.y = "keyword")

sentiment_3 = rbind(neg_3, pos_3)

score = function(sent){
  sent_sum = aggregate(value ~ doc_id, sent, sum)
  
  for(i in 1:nrow(sent_sum)){
    if(sent_sum$value[i]>0){
      sent_sum$senti[i] = "긍정"
    }else if(sent_sum$value[i]<0){
      sent_sum$senti[i] = "부정"
    }else sent_sum$senti[i] = "중립"
  }
  return(sent_sum)
}

# 슈카월드 "쿠팡 1조원 적자에도 멈출 수 없는 이유"
sent_1 = score(sentiment_1)
table(sent_1$senti)

# 부동산 읽어주는 남자 "절대로 전세 살지 마라 1부 | 부동산읽어주는남자"
sent_2 = score(sentiment_2)
table(sent_2$senti)

# 신사임당 "부자는 알지만 가난한 사람은 모르는 것 (존리)"
sent_3 = score(sentiment_3)
table(sent_3$senti)
