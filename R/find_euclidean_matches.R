#' Find shape similarity based on Euclidean distance
#'
#'
#' @param template_list list of time series templates that we want to match
#' @param lstx list of time series


find_Euclidean_shapematches <- function(template_list, lstx) {

  all_results <- data.frame()

  for(temp_name in names(template_list)) {

    template <- template_list[[temp_name]]
    m <- length(template)

    # z-normalize template
    template <- scale(template)[,1]

    for(loc in names(lstx)) {

      series <- lstx[[loc]]

      if(length(series) < m) next

      best_dist <- Inf
      best_pos <- NA

      # Sliding window
      for(i in 1:(length(series) - m + 1)) {

        window <- series[i:(i + m - 1)]

        # Skip constant windows
        if(sd(window) == 0) next

        # z-normalize
        window <- scale(window)[,1]

        # Euclidean shape distance
        d <- proxy::dist(
          x = matrix(template, nrow = 1),
          y = matrix(window, nrow = 1),
          method = "Euclidean"
        )

        if(d < best_dist) {
          best_dist <- d
          best_pos <- i
        }
      }

      all_results <- rbind(
        all_results,
        data.frame(
          template = temp_name,
          location = loc,
          distance = as.numeric(best_dist),
          position = best_pos
        )
      )
    }
  }

  # Best match per template
  best_matches <- do.call(
    rbind,
    lapply(split(all_results, all_results$template),
           function(x) x[which.min(x$distance), ])
  )

  rownames(best_matches) <- NULL

  return(list(
    all_matches = all_results,
    best_matches = best_matches
  ))
}
