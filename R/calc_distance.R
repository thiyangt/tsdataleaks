#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param lstx list of time series
#' @param finddataleaksout list, the output generated from find_dataleaks function
#' @param h length of the window size
#' @importFrom  tibble rownames_to_column
#' @importFrom magrittr %>%
#' @importFrom ggplot2 ggplot
#' @return  matrix visualizing the output
#' @export
calc_distance <- function(lstx, finddataleaksout, h){

  if(length(finddataleaksout)==0){x <- readline("Empty list!\n(press enter to continue)")
   return(finddataleaksout)}

  leaksdf <- do.call(rbind.data.frame, finddataleaksout)
  df <- tibble::rownames_to_column(leaksdf, "Series1")
  df2 <- df %>% tidyr::separate(Series1, c("series1", "N"))
  df2 <- df2 %>% select(c("series1", ".id"))
  nleaks <- nrow(df2)
  for (i in 1:nleaks){



  }


}
#' @examples
#' a = rnorm(15)
#' lst <- list(
#'  a = a,
#'  b = c(a[10:15], rnorm(10), a[1:5], a[1:5]),
#'  c = c(rnorm(10), a[1:5])
#')
#'f1 <- find_dataleaks(lst, h=5)
#'viz_dataleaks(f1)
#'
#' a = rnorm(15)
#'lst <- list(
#'  x= a,
#'  y= c(rnorm(10), a[1:5])
#')
#'
#'f2 <- find_dataleaks(lst, h=5)
#'viz_dataleaks(f2)
#'
#'# List without naming elements
#' lst <- list(
#'  a,
#'  c(rnorm(10), a[1:5], a[1:5]),
#'  rnorm(10)
#')
#'f3 <- find_dataleaks(lst, h=5)
#'viz_dataleaks(f3)

