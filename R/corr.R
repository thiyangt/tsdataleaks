#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param x time series
#' @param y subsection of the time series to map
#' @param cutoff benchmark value for corr, default 1
#' @param boost Logical value indicating whether to boost performance by using RCpp. For small datasets setting boost=TRUE would not be efficient.
#' @importFrom slider slide_dbl
#' @importFrom tibble tibble
#' @return Pearson's correlation coefficient between \code{x} and \code{y}
#' @export
ts.match <- function(x, y, cutoff=1,boost=TRUE){
  slide.size <- length(y)
  fn <- function(x){stats::cor(x, y)}
  if(boost){
    match.index <- round(corw(x,y), 4)
  }else{
    match.index <- round(slider::slide_dbl(x, fn, .before = slide.size - 1L, .complete = TRUE), 4)
  }
  index.cutoff.end <- which(match.index >= cutoff)
    index.cutoff.start <- index.cutoff.end - (slide.size-1L)

  # print(match.index)
    if(length(index.cutoff.end) == 0){
      tibble::tibble(start = NA, end = NA)
      } else {
    tibble::tibble(start = index.cutoff.start, end = index.cutoff.end)
      }
}

#' @examples
#' x <- rnorm(15)
#' y <- x[6:10]
#' x <- c(x, y)
#' ts.match(x, y, 1)
#' z <- rnorm(5)
#' ts.match(x, z)

