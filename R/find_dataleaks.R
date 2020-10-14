#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param lstx list of time series
#' @param h length of forecast horizon
#' @param cutoff benchmark value for corr, default 1
#' @importFrom  utils tail
#' @importFrom plyr ldply
#' @importFrom purrr map
#' @return list of matching quantities
#' @export
find_dataleaks <- function(lstx, h, cutoff=1){
  n <- length(lstx)
  result <- list()

  for (i in 1:n){

    y = utils::tail(lstx[[i]], h)
    result[[i]] <- purrr::map(lstx, ts.match, y=y)

  }


  result.list <- purrr::map(result, plyr::ldply, data.frame)
  n.result.list <- length(result.list)
  resul.list.clean <- list()
  for(i in 1:n){

    resul.list.clean[[i]] <- result.list[[i]][-i, ]
  }
  resul.list.clean
}
#' @examples
#' a = rnorm(15)
#'lst <- list(
#'  a = a,
#'  b = c(rnorm(10), a[1:5]),
#'  c = rnorm(10)
#')
#'find_dataleaks(lst, h=5)
#'#' a = rnorm(15)
#'lst <- list(
#'  a,
#'  c(rnorm(10), a[1:5]),
#'  rnorm(10)
#')
#'find_dataleaks(lst, h=5)


