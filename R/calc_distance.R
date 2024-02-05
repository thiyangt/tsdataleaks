#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param lstx list of time series
#' @param finddataleaksout list, the output generated from find_dataleaks function
#' @param h length of the window size
#' @importFrom  tibble rownames_to_column
#' @importFrom ggplot2 ggplot
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @return  matrix visualizing the output
#' @export
#' @examples
#' a = rnorm(15)
#' lst <- list(
#'  a = a,
#'  b = c(a[10:15], rnorm(10), a[1:5]+10, a[1:5]),
#'  c = c(rnorm(10), a[1:5])
#')
#'f1 <- find_dataleaks(lst, h=5)
#'reason_dataleaks(lst, f1, h=5)
#'
#'# List without naming elements
#' lst <- list(
#'  a,
#'  c(rnorm(10), a[1:5], a[1:5]),
#'  rnorm(10)
#')
#'f2 <- find_dataleaks(lst, h=5)
#'reason_dataleaks(lst, f2, h=5)
reason_dataleaks <- function(lstx, finddataleaksout, h){

  if(length(finddataleaksout)==0){x <- readline("Empty list!\n(press enter to continue)")
   return(finddataleaksout)}

  leaksdf <- do.call(rbind.data.frame, finddataleaksout)
  df <- tibble::rownames_to_column(leaksdf, "Series1")
  df2 <- df |> tidyr::separate(Series1, c("series1", "N"))
  df2 <- df2 |> dplyr::select(c("series1", ".id", "start", "end"))
  ndf2 <- dim(df2)[1]
  dist.mean <- numeric(ndf2)
  dist.sd <- numeric(ndf2)
  is.useful.leak <- numeric(ndf2)
  if (is.null(names(lstx)) == TRUE){
  for (i in 1:ndf2){ # not labelled list

    name1 <- as.numeric(df2$series[i])
    name2 <- as.numeric(df2$.id[i])
    s1 <- lstx[name1][[1]]
    s2 <- lstx[name2][[1]]
    s1length <- length(s1)
    s2length <- length(s2)
    is.useful.leak[i] <- ifelse(s2length == df$end[i], "not useful", "useful")
    hh <- h-1
    s1.section <- s1[(s1length-hh):s1length]
    s2.section <- s2[df2$start[i]: df2$end[i]]
    dist <- s1.section - s2.section
    dist.mean[i] <- mean(dist)
    dist.sd[i] <- sd(dist)


  }
    } else { # labelled list

    for (i in 1:ndf2){



      name1 <- df2$series[i]
      name2 <- df2$.id[i]
      s1 <- lstx[name1][[1]]
      s2 <- lstx[name2][[1]]
      s1length <- length(s1)
      s2length <- length(s2)
      is.useful.leak[i] <- ifelse(s2length == df$end[i], "not useful", "useful")
      hh <- h-1
      s1.section <- s1[(s1length-hh):s1length]
      s2.section <- s2[df2$start[i]: df2$end[i]]
      dist <- s1.section - s2.section
      dist.mean[i] <- mean(dist)
      dist.sd[i] <- sd(dist)


    }



  }

  df2$dist_mean <- dist.mean
  df2$dist_sd <- dist.sd
  df2$is.useful.leak <- is.useful.leak

  df2 <- df2 |>
    dplyr::mutate(reason = ifelse(dist_mean == 0 & dist_sd == 0 , "exact match",
                       ifelse(dist_mean != 0 & dist_sd == 0 , "add constant", "Do not know")))

  df2

}


