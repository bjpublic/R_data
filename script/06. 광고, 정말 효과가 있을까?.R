# 6.1  엑셀 데이터 불러오기
# readxl 패키지 로드
library(readxl)

# 엑셀 데이터 불러오기
adver = read_xlsx("abtest.xlsx", sheet = 1)

# 데이터 앞부분 탐색
head(adver)

# 데이터 뒷부분 탐색
tail(adver)

table(is.na(adver$city1))

table(is.na(adver$city2))

table(is.na(adver$age))

table(is.na(adver$sex))

table(is.na(adver$type))

table(is.na(adver$open))

table(is.na(adver$click))

table(is.na(adver$conversion))

table(is.na(adver$sales))

adver = adver[adver$sales != "NA",]

adver

str(adver$sales)

adver$sales = as.numeric(adver$sales)

str(adver$sales)

unique(adver$city1)

unique(adver$city2)

unique(adver$age)

unique(adver$sex)

unique(adver$type)

summary(adver$open)

summary(adver$click)

summary(adver$conversion)

summary(adver$sales)

# 6.3  raster 패키지를 이용하여 대한민국 지도 그리기
install.packages("raster")
library(raster)

# 국가
korea = getData(name = "GADM",
                country = "kor",
                level = 0)

# 시도
korea_sido = getData(name = "GADM",
                     country = "kor",
                     level = 1)

# 시군구
korea_sigungu = getData(name = "GADM",
                        country = "kor",
                        level = 2)

korea$GID_0

korea$NAME_0

korea_sido$GID_1

korea_sido$NAME_1

korea_sido$VARNAME_1

korea_sido$NL_NAME_1

korea_sido$TYPE_1

korea_sido$ENGTYPE_1

korea_sido$HASC_1


seoul = korea_sigungu[korea_sigungu$NAME_1=="Seoul",]

seoul$GID_2

seoul$NAME_2

seoul$NL_NAME_2

seoul$TYPE_2

seoul$ENGTYPE_2

# 국가
p1 = ggplot(korea) +
      geom_polygon(aes(x = long, y = lat, group = group),
                   fill = "white", color = "black") +
      labs(title = "Korea") +
      theme(axis.ticks = element_blank(),
            axis.title = element_blank(),
            axis.text = element_blank())

# 시도
p2 = ggplot(korea_sido) +
      labs(title = "Sido") +
      geom_polygon(aes(x = long, y = lat, group = group),
                   fill = "white", color = "black") +
      theme(axis.ticks = element_blank(),
            axis.title = element_blank(),
            axis.text = element_blank())

# 시군구
p3 = ggplot(korea_sigungu) +
      geom_polygon(aes(x = long, y = lat, group = group),
                   fill = "white", color = "black") +
      labs(title = "Sigungu") +
      theme(axis.ticks = element_blank(),
            axis.title = element_blank(),
            axis.text = element_blank())

# 6.4  stats 패키지 기반 통계적 검정하기
# A_GROUP과 B_GROUP별 광고 이메일을 열어본 횟수
ggplot(adver, aes(x = type, y = open)) +
  geom_boxplot() +
  labs(title = "이메일 연 수") +
  theme(title = element_text(size = 15, face = "bold"),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text.y = element_blank())

# A_GROUP과 B_GROUP별 광고를 클릭해본 횟수
ggplot(adver, aes(x = type, y = click)) +
  geom_boxplot() +
  labs(title = "광고 클릭 수") +
  theme(title = element_text(size = 15, face = "bold"),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text.y = element_blank())

# A_GROUP과 B_GROUP별 구매 전환 횟수
ggplot(adver, aes(x = type, y = conversion)) +
  geom_boxplot() +
  labs(title = "구매 전환 수") +
  theme(title = element_text(size = 15, face = "bold"),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        axis.text.y = element_blank())

# A_GROUP 추출하기
A_GROUP = subset.data.frame(x = adver,
                            subset = c(type == "A_GROUP"))

# B_GROUP 추출하기
B_GROUP = subset.data.frame(x = adver,
                            subset = c(type == "B_GROUP"))

install.packages("nortest")
library(nortest)

ad.test(A_GROUP$open)
ad.test(B_GROUP$open)

ad.test(A_GROUP$click)
ad.test(B_GROUP$click)

ad.test(A_GROUP$conversion)
ad.test(B_GROUP$conversion)

library(car)
leveneTest(y = adver$open, group = factor(adver$type))

leveneTest(y = adver$click, group = factor(adver$type))

leveneTest(y = adver$conversion, group = factor(adver$type))

t.test(A_GROUP$open, B_GROUP$open)

t.test(A_GROUP$click, B_GROUP$click)

t.test(A_GROUP$conversion, B_GROUP$conversion)

# 6.5  ggplot2 패키지를 이용하여 광고 효과 없는 지역 표현하기
library(readxl)
adver = read_xlsx("abtest.xlsx", sheet = 1)

# 경기도 추출하기
kyungki = subset.data.frame(x = adver, subset = c(city1 == "경기도"))

# 경기도의 A_GROUP 추출하기
kyungki_A = subset.data.frame(x = kyungki,
                              subset = c(type == "A_GROUP"))

# 경기도의 B_GROUP 추출하기
kyungki_B = subset.data.frame(x = adver,
                              subset = c(type == "B_GROUP"))

shapiro.test(kyungki_A$open)

shapiro.test(kyungki_B$open)

library(car)
leveneTest(y = kyungki$open, group = factor(kyungki$type))

wilcox.test(open ~ type, kyungki)

library(raster)
library(ggplot2)

korea_sido = getData(name = "GADM",
                     country = "kor",
                     level = 1)

sido_key = data.frame(NAME_1 = korea_sido$NAME_1,
                      KOR = c("부산광역시", "충청북도", "충청남도", "대구광역시",
                              "대전광역시", "강원도", "광주광역시", "경기도",
                              "경상북도", "경상남도", "인천광역시",
                              "제주특별자치도", "전라북도", "전라남도",
                              "세종특별자치시", "서울특별시", "울산광역시"),
                      RESULT = 1)

korea_sido@data$id = rownames(korea_sido@data)
korea_sido@data = merge(korea_sido@data, sido_key, by = "NAME_1")
koreaDf = fortify(korea_sido)
koreaDf = merge(koreaDf, korea_sido@data, by = "id")

ggplot() +
   geom_polygon(data = koreaDf, aes(x = long, y = lat,
                                    group = group,
                                    fill = RESULT),
                color = "black") +
 labs(title = "지역별 두 그룹에 대한 성과 차이") +
   theme(legend.position = "none",
         axis.ticks = element_blank(),
         axis.title = element_blank(),
         axis.text = element_blank())
