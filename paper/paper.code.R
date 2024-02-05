library(tidyverse)

##---- Figure 1 ----
set.seed(15102020)
t <- seq(0, 10, 0.1)
y <- sin(t) + rnorm(100)
y <- y + 100
time <- 1:length(t)
col1 <- c(rep(1, 5), rep(0, 44), rep(1, 52))
traintest <- c(rep(1, 81), rep(0, 20))
h1 <- c(rep(1, 5), rep(0, 24), rep(1, 72))
h2 <- c(rep(1, 5), rep(0, 44), rep(1, 52))
df1 <- data.frame(y=y, time=time, col=col1, traintest=traintest, h=rep(1, 101),
                  h1=h1, h3=col1)
t2 <- seq(0, 10, 0.1)
y2 <- cos(t2) + rnorm(25, sd=0.05) + 100
y2 <- c(y2, y[5:50])
t3 <- 1: 101
col2 <- c(rep(1, 101), rep(0, 46))
h <- c(rep(1, 101), rep(0, 26), rep(1, 20))[46:146]
df2 <- data.frame(y=y2[46:146], time=t3, col=col2[46:146], traintest=traintest,
                  h=h, h1=h, h3=h)
dfCombined <- bind_rows(df2, df1)
dfCombined$dfindex <- c(rep("A", nrow(df1)), rep("B", nrow(df2)))
ggplot(dfCombined, aes(y=y, x=time, col=factor(col)), group=1) +
  scale_colour_manual(values = c("red", "black")) +
  geom_line() +  aes(group=NA) +
  geom_vline(xintercept=82,colour="#66a61e", lwd=1) +
  facet_wrap(vars(dfindex), ncol=1) +
  theme(legend.position = "none") +
  annotate("rect", xmin = 82, xmax = 101, ymin = 97.11, ymax = 103.38,
           alpha = 0.5, fill = c("yellow") ) +
  geom_line()
