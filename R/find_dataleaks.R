#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param x list of time series
#' @param h length of forecast horizon
#' @param cutoff benchmark value for corr, default 1
#' @importFrom
#' @return list of matching quantities
#' @export
find_dataleaks <- function(x, h, cutoff=1){
  n <- length(x)
  result <- list()

  for (i in 1:n){

    y = tail(lst[[i]], h)
    result[[i]] <- map(lst, ts.match, y=y)

  }

  result


}
#' @examples
#' a = rnorm(15)
#'lst <- list(
#'  a = a,
#'  b = c(rnorm(10), a[1:5]),
#'  c = rnorm(10)
#')
#'ff <- find_dataleaks(lst, h=5)
#'map(ff, reduce, bind_rows)
