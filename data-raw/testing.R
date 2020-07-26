a = rnorm(15)

lst <- list(
  a = a,
  b = c(rnorm(10), a[1:5])
)


ts.match(lst[[1]], tail(lst[[1]], 5))
ts.match(lst[[1]], tail(lst[[2]], 5))
ts.match(lst[[2]], tail(lst[[1]], 5))
ts.match(lst[[2]], tail(lst[[2]], 5))


library(purrr)

result <- list()

for (i in 1:2){

  y = tail(lst[[i]], 5)
  result[[i]] <- map(lst, ts.match, y=y)

}
