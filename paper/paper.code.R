library(tidyverse)

##---- Figure 1 ----
set.seed(15102020)
t <- seq(0, 10, 0.1)
y <- sin(t) + rnorm(100)
y <- y + 100
time <- 1:length(t)
col1 <- c(rep(1, 5), rep(2, 44), rep(1, 52))
df1 <- data.frame(y=y, time=time, col=col1)
t2 <- seq(0, 10, 0.1)
y2 <- cos(t2) + rnorm(25, sd=0.05) + 100
y2 <- c(y2, y[5:50])
t3 <- 1: 101
col2 <- c(rep(1, 101), rep(2, 46))
df2 <- data.frame(y=y2[46:146], time=t3, col=col2[46:146])
dfCombined <- bind_rows(df1, df2)
dfCombined$dfindex <- c(rep("A", nrow(df1)), rep("B", nrow(df2)))
ggplot(dfCombined, aes(y=y, x=time, col=factor(col)), group=1) +
  scale_colour_manual(values = c("#1b9e77", "#d95f02")) +
  geom_line() +  aes(group=NA) +
  geom_vline(xintercept=81, colour="#7570b3") +
  facet_wrap(vars(dfindex), ncol=1) +
  theme(legend.position = "none")
