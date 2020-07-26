#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param x time series
#' @param y subsection of the time series to map
#' @param cutoff benchmark value for corr, default 1
#' @importFrom
#' @return Pearson's correlation coefficient between \code{x} and \code{y}
#' @export
ts.match <- function(x, y, cutoff=1){
  slide.size <- length(y)
  match.index <- round(tsibble:::slide_dbl(x, function(x){stats::cor(x, y)}, .size = slide.size,
                                           .partial = TRUE), 4)
  index.cutoff.end <- which(match.index >= cutoff)
#  if(length(index.cutoff.end) == 0){
#    return(print("No data leaks"))
#  } else {
    index.cutoff.start <- index.cutoff.end - (slide.size-1)
    tibble::tibble(start = index.cutoff.start, end = index.cutoff.end)
#  }
}
#' @examples
#' x <- rnorm(15)
#' y <- x[6:10]
#' x <- c(x, y)
#' ts.match(x, y, 1)
#' z <- rnorm(5)
#' ts.match(x, z)
