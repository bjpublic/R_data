# 7.1  KOSPI 데이터 불러오기
library(quantmod)

KOSPI = getSymbols("^KS11",
                   from = "2001-01-01",
                   to = Sys.time(),
                   auto.assign = FALSE)

head(KOSPI)

tail(KOSPI)

SEC = getSymbols("005930.KS",
                 from = "2015-01-01",
                 to = "2021-01-01",
                 auto.assign = FALSE)

# 7.2 ggplot2 패키지를 이용하여 KOSPI 지수 시각화하기
str(KOSPI)

sample = data.frame(date = time(KOSPI),
                    KOSPI,
                    growth = ifelse(Cl(KOSPI) > Op(KOSPI),
                                    "up", "down"))

colnames(KOSPI)

colnames(sample) = c("date", "Open", "High", "Low",
                     "Close", "Volume", "Adjusted", "growth")

sample

summary(sample)

ggplot(sample, aes(x = date)) +
  geom_line(aes(y = Low))

ggplot(sample[sample$date >= "2020-01-01",],
       aes(x = date)) +
  geom_line(aes(y = Low))

sample[sample$date >= "2020-04-01" & sample$date <= "2020-06-30",]

sample$Low[sample$date == "2020-05-06"] = 1925.55

ggplot(sample[sample$date >= "2020-01-01",], aes(x = date)) +
  geom_linerange(aes(ymin = Low, ymax = High))

ggplot(sample[sample$date >= "2020-01-01",], aes(x = date)) +
  geom_linerange(aes(ymin = Low, ymax = High)) +
  geom_rect(aes(xmin = date - 0.3,
                xmax = date + 0.3,
                ymin = pmin(Open, Close),
                ymax = pmax(Open, Close),
                fill = growth))

ggplot(sample[sample$date >= "2020-01-01",], aes(x = date)) +
   geom_linerange(aes(ymin = Low, ymax = High)) +
   geom_rect(aes(xmin = date - 0.3,
                 xmax = date + 0.3,
                 ymin = pmin(Open, Close),
                 ymax = pmax(Open, Close),
                 fill = growth)) +
   guides(fill = "none") +
   scale_fill_manual(values =c("down" = "blue", "up" = "red")) +
   labs(
     title = "KOSPI",
     subtitle = "2020-01-01 ~ 2021-01-25"
     ) +
   theme(plot.title = element_text(face = "bold"),
         plot.subtitle = element_text(hjust = 1),
         axis.title = element_blank(),
         axis.line.x.bottom = element_line(color = "grey"),
         axis.ticks = element_line(color = "grey"),
         axis.line.y.left = element_line(color = "grey"),
         plot.background = element_rect(fill = "white"),
         panel.background = element_rect(fill = "white")
        )

# 7.4  stats 패키지로 KOSPI 지수 분해하기
library(quantmod)

KOSPI = getSymbols("^KS11",
                   from = "2001-01-01",
                   to = Sys.time(),
                   auto.assign = FALSE)

str(KOSPI)

KOSPI_C = na.omit(KOSPI$KS11.Close)
KOSPI_C = as.numeric(KOSPI_C)
ts_KOSPI_C = ts(data = KOSPI_C, frequency = 365)

# 가법모형 시계열 분해
de_data_add = decompose(ts_data,
                        type = "additive")

# 승법 모형 시계열 분해
de_data_multi = decompose(ts_data,
                          type = "multiplicative")

str(de_data_add)

str(de_data_multi)

# 가법모형 시계열 분해 시각화
plot(de_data_add)

# 승법모형 시계열 분해 시각화
plot(de_data_multi)

# 7.5  forecast 패키지로 시계열 회귀 모형 만들기
# 7.5.3  적절한 독립 변수
KOSPI = getSymbols("^KS11",
                   from = "2020-01-01",
                   to = "2021-01-31",
                   auto.assign = FALSE)

head(KOSPI)

ggplot(KOSPI, aes(x = time(KOSPI), y = KS11.Close)) +
  geom_line()

ts_data = ts(data = as.numeric(KOSPI$KS11.Close),
             frequency = 5)

library(forecast)
fit_lm = tslm(ts_data ~ trend)
fit_lm

summary(fit_lm)

ggplot(KOSPI, aes(x = time(KOSPI), y = KS11.Close)) +
  geom_line() +
  geom_line(y = fit_lm$fitted.values, color = "grey")

pred = data.frame(forecast(fit_lm, h = 20),
                  stringsAsFactors = FALSE)

ggplot(pred, aes(x = index(pred), y = Point.Forecast)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lo.95, ymax = Hi.95), alpha = 0.25) +
  geom_ribbon(aes(ymin = Lo.80, ymax = Hi.80), alpha = 0.5)

ts_data = ts(data = as.numeric(KOSPI$KS11.Close),
             frequency = 12)

library(forecast)
fitted = tslm(ts_data ~ trend + season)

fitted

summary(fitted)

ggplot(KOSPI, aes(x = time(KOSPI), y = KS11.Close)) +
  geom_line() +
  geom_line(y = fitted$fitted.values, color = "grey")

ts_data = ts(data = as.numeric(KOSPI$KS11.Close),
             frequency = 20)

t = time(ts_data)

t.break = data.frame(t, ts_data)

t.break[t.break$t < 3.65,] = 0
t.break[t.break$t > 3.75,] = 0

tb1 = ts(t.break$t, frequency = 20)

fit.t = tslm(ts_data ~ t)
AIC(fit.t)

fit.tb = tslm(ts_data ~ t + I(t^2) + I(t^3) + I(tb1^3))
AIC(fit.tb)

ggplot(ts_data, aes(x = time(ts_data))) +
  geom_line(aes(y = ts_data)) +
  geom_line(aes(y = fit.t$fitted.values),
            color = "#7f7f7f", size = 1) +
  geom_line(aes(y = fit.tb$fitted.values),
            color = "#bcbcbc")

new = data.frame(t = t[length(t)] + seq(1, by = 0.05, length.out = 20))
forecast(fit.t, newdata = new)

# 7.6  auto.arima를 이용하여 KOSPI 지수 예측하기
# 7.6.1  정상성과 차분
library(urca)

KOSPI = getSymbols("^KS11",
                   from = "2020-01-01",
                   to = "2021-01-31",
                   auto.assign = FALSE)

ts_kospi = ts(as.numeric(KOSPI$KS11.Close), frequency = 20)

ur_test = ur.kpss(ts_kospi)

summary(ur_test)

dif_1 = diff(ts_kospi, differences = 1)
ur_test2 = ur.kpss(dif_1)
ur_test2

dif_2 = diff(ts_kospi, differences = 2)
ur_test3 = ur.kpss(dif_2)
summary(ur_test3)

log_dif_2 = diff(log(ts_kospi), differences = 2)
ur_test4 = ur.kpss(log_dif_2)
summary(ur_test4)

# 7.6.2  auto.arima 활용하기
ggplot(ts_kospi, aes(x = time(ts_kospi))) +
  geom_line(aes(y = ts_kospi))

library(forecast)
fit = auto.arima(ts_kospi)

fit

checkresiduals(fit)

fore = data.frame(forecast(fit, h = 5))
fore

ggplot(fore, aes(x = index(fore), y = Point.Forecast)) +
  geom_line() +
  geom_ribbon(aes(ymin = Lo.95, ymax = Hi.95), alpha = 0.25) +
  geom_ribbon(aes(ymin = Lo.80, ymax = Hi.80), alpha = 0.5)
