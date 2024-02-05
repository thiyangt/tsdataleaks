#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param finddataleaksout list, the output generated from find_dataleaks function
#' @importFrom  tibble rownames_to_column
#' @importFrom ggplot2 ggplot
#' @importFrom dplyr select
#' @importFrom dplyr summarise
#' @importFrom dplyr full_join
#' @importFrom viridis scale_fill_viridis
#' @return  matrix visualizing the output
#' @export
viz_dataleaks <- function(finddataleaksout){

  if(length(finddataleaksout)==0){x <- readline("Empty list!\n(press enter to continue)")
   return(finddataleaksout)}

  leaksdf <- do.call(rbind.data.frame, finddataleaksout)
  df <- tibble::rownames_to_column(leaksdf, "rname")
  df2 <- df |> tidyr::separate(rname, c("series1", "N"))
  df2 <- df2 |> dplyr::select(c("series1", ".id"))
  # Count the combinations considerting the columns series1 and .id
  names(df2) <- make.names(names(df2))



  df2 <- df2 |>
    group_by_at(names(df2)) |>
    dplyr::summarise(count= n())

  alllevels <- levels(as.factor(c(df2$series1, df2$.id)))
  df3 <- data.frame(series1=alllevels, .id=alllevels)

  df3 <- df3 |> tidyr::expand(series1, .id)
  df2 <- dplyr::full_join(df2, df3)

  list(
  ggplot2::ggplot(df2, aes(y=series1, x=.id, fill= count)) +
    geom_tile(colour = "black", linewidth=0.25) +
    scale_fill_viridis(option="viridis", na.value = "white") +
    labs(x = "Matching series", y ="Series to forecast") +
    theme(aspect.ratio = 1),
  finddataleaksout)
}
#'@examples
#' a = rnorm(15)
#'lst <- list(
#'  a = a,
#'  b = c(a[10:15]+rep(8,6), rnorm(10), a[1:5], a[1:5]),
#'  c = c(rnorm(10), a[1:5]),
#'  d = rnorm(10)
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

