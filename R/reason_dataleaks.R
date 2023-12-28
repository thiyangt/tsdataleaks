#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param lstx list of time series
#' @param finddataleaksout list, the output generated from find_dataleaks function
#' @param h length of the window size
#' @importFrom  tibble rownames_to_column
#' @importFrom magrittr %>%
#' @importFrom ggplot2 ggplot
#' @importFrom stats  sd
#' @importFrom dplyr select
#' @importFrom dplyr full_join
#' @return  matrix visualizing the output
#' @export
reason_dataleaks <- function(lstx, finddataleaksout, h){

  if(length(finddataleaksout)==0){x <- readline("Empty list!\n(press enter to continue)")
   return(finddataleaksout)}

  leaksdf <- do.call(rbind.data.frame, finddataleaksout)
  df <- tibble::rownames_to_column(leaksdf, "rname")
  df2 <- df %>% tidyr::separate(rname, c("series1", "N"))
  df2 <- df2 %>% dplyr::select(c("series1", ".id", "start", "end"))
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
    dist.sd[i] <- stats::sd(dist)


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
      dist.mean[i] <- round(mean(dist), 1)
      dist.sd[i] <- round(sd(dist), 1)


    }



  }

  df2$dist_mean <- dist.mean
  df2$dist_sd <- dist.sd
  df2$is.useful.leak <- is.useful.leak

  df2 <- df2 %>%
    dplyr::mutate(reason = ifelse(dist_mean == 0 & dist_sd == 0 , "exact match",
                       ifelse(dist_mean != 0 & dist_sd == 0 , "add constant", "Do not know")))

 # g1 <- ggplot2::ggplot(df2, aes(y=series1, x=.id, fill= is.useful.leak)) +
 #   geom_tile(colour = "black", size=0.25) +
 #   scale_fill_manual(values = c("#d95f02", "#1b9e77", "seagreen3")) +
 #   labs(x = "Matching series", y ="Series to forecast")
 # g2 <- ggplot2::ggplot(df2, aes(y=series1, x=.id, fill= reason)) +
 #   geom_tile(colour = "black", size=0.25) +  scale_fill_viridis_d(option = "plasma")
 # g3 <- cowplot::plot_grid(g1, g2, labels = c("Usefulness", "Reason")) +

  #df2 <- df2 %>% filter(is.useful.leak=="useful")
  #  df2

  # Visualisation of reasons

  leaksdf <- do.call(rbind.data.frame, finddataleaksout)
  df <- tibble::rownames_to_column(leaksdf, "rname")
  df3 <- df %>% tidyr::separate(rname, c("series1", "N"))
  df3 <- df3 %>% dplyr::select(c("series1", ".id"))
  # Count the combinations considerting the columns series1 and .id
  names(df3) <- make.names(names(df3))



  df3 <- df3 %>%
    group_by(.dots=names(df3)) %>%
    summarise(count= n())

  alllevels <- levels(as.factor(c(df3$series1, df3$.id)))
  df4 <- data.frame(series1=alllevels, .id=alllevels)

  df4 <- df4 %>% tidyr::expand(series1, .id)
  df3 <- dplyr::full_join(df3, df4)

  reasondataleaksout2 <- df2 %>% dplyr::filter(is.useful.leak=="useful")

  t <- dplyr::left_join(df3, reasondataleaksout2)

  #useful <- reasondataleaksout %>% filter(is.useful.leak=="useful")
  # notuseful <- reasondataleaksout %>% filter(is.useful.leak=="not useful")
  #t2 <- t[rowSums(is.na(t)) > 0,]


  g1 <- ggplot2::ggplot(t, aes(y=series1, x=.id, fill= is.useful.leak)) +
    geom_tile(colour = "black", size=0.25) +
    scale_fill_manual(values = c("#d95f02", "#1b9e77", "seagreen3"),  na.value = "white") +
    labs(x = "Matching series", y ="Series to forecast")
  g2 <- ggplot2::ggplot(t, aes(y=series1, x=.id, fill= reason)) +
    geom_tile(colour = "black", size=0.25) +  scale_fill_viridis_d(option = "plasma", na.value="white") +
    labs(x = "Matching series", y ="Series to forecast")
  g3 <- cowplot::plot_grid(g1, g2, labels = c("Usefulness", "Reason"))

    list(df2, g3)
    #return(g3)

}
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

