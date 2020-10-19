#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param finddataleaksout list, the output generated from find_dataleaks function
#' @param reasondataleaksout dataframe, output generated from reason_dataleaks function
#' @importFrom  tibble rownames_to_column
#' @importFrom magrittr %>%
#' @importFrom ggplot2 ggplot
#' @importFrom dplyr left_join
#' @importFrom stats filter
#' @importFrom cowplot plot_grid
#' @importFrom dplyr select
#' @importFrom tidyr separate
#' @importFrom tidyr expand
#' @importFrom viridis scale_fill_viridis_d
#' @return  matrix visualizing the output
#' @export
viz_details <- function(finddataleaksout, reasondataleaksout){

  if(length(finddataleaksout)==0){x <- readline("Empty list!\n(press enter to continue)")
   return(finddataleaksout)}

  leaksdf <- do.call(rbind.data.frame, finddataleaksout)
  df <- tibble::rownames_to_column(leaksdf, "rname")
  df2 <- df %>% tidyr::separate(rname, c("series1", "N"))
  df2 <- df2 %>% dplyr::select(c("series1", ".id"))
  # Count the combinations considerting the columns series1 and .id
  names(df2) <- make.names(names(df2))



  df2 <- df2 %>%
    group_by(.dots=names(df2)) %>%
    summarise(count= n())

  alllevels <- levels(as.factor(c(df2$series1, df2$.id)))
  df3 <- data.frame(series1=alllevels, .id=alllevels)

  df3 <- df3 %>% tidyr::expand(series1, .id)
  df2 <- complete(df2, df3)

  reasondataleaksout2 <- reasondataleaksout %>% stats::filter(is.useful.leak=="useful")

  t <- dplyr::left_join(df2, reasondataleaksout2)

  #useful <- reasondataleaksout %>% filter(is.useful.leak=="useful")
 # notuseful <- reasondataleaksout %>% filter(is.useful.leak=="not useful")
  #t2 <- t[rowSums(is.na(t)) > 0,]


  g1 <- ggplot2::ggplot(t, aes(y=series1, x=.id, fill= is.useful.leak)) +
    geom_tile(colour = "black", size=0.25) +
   scale_fill_manual(values = c("#d95f02", "#1b9e77", "seagreen3")) +
     labs(x = "Matching series", y ="Series to forecast")
   g2 <- ggplot2::ggplot(t, aes(y=series1, x=.id, fill= reason)) +
     geom_tile(colour = "black", size=0.25) +  scale_fill_viridis_d(option = "plasma") +
     labs(x = "Matching series", y ="Series to forecast")
   g3 <- cowplot::plot_grid(g1, g2, labels = c("Usefulness", "Reason"))
   return(g3)
}
#' @examples
#' a = rnorm(15)
#'lst <- list(
#'  a = a,
#'  b = c(a[10:15]+rep(8,6), rnorm(10), a[1:5], a[1:5]),
#'  c = c(rnorm(10), a[1:5]),
#'  d = rnorm(10)
#')
#'f1 <- find_dataleaks(lst, h=5)
#'r1 <- reason_dataleaks(lst, f1, h=5)
#'viz_details(f1, r1)
#'
#'
#'# List without naming elements
#' lst <- list(
#'  a,
#'  c(rnorm(10), a[1:5], a[1:5]),
#'  rnorm(10)
#')
#'f2 <- find_dataleaks(lst, h=5)
#'r2 <- reason_dataleaks(lst, f2, h=5)
#'viz_details(f2, r2)

