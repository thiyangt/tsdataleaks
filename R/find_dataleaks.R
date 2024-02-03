#' Correlation calculation based on rolling window with overlapping observations.
#'
#' @param lstx list of time series
#' @param h length of forecast horizon
#' @param cutoff benchmark value for corr, default 1
#' @importFrom  utils tail
#' @importFrom plyr ldply
#' @importFrom purrr map
#' @importFrom  stats na.omit
#' @return list of matching quantities
#' @export
find_dataleaks <- function(lstx, h, cutoff=1){
  n <- length(lstx)
  if (is.null(names(lstx)) == TRUE){names(lstx) <- 1:n} # This is important when displying the final results
  result <- list()

  for (i in 1:n){

    y = utils::tail(lstx[[i]], h)
    result[[i]] <- purrr::map(lstx, ts.match, y=y)

  }


  result.list <- purrr::map(result, plyr::ldply, data.frame)
  n.result.list <- length(result.list)
  resul.list.clean <- list()
  for(i in 1:n){

    resul.list.clean[[i]] <- result.list[[i]]
  }

  names(resul.list.clean) <- names(lstx)
  nonmissinglist <- purrr::map(resul.list.clean, stats::na.omit)
  #nonmissinglist


  namesx <- names(nonmissinglist)


  a <- list(length(nonmissinglist))
  for (i in 1: length(nonmissinglist)){
    a[[i]] <- which(nonmissinglist[[i]]$.id == namesx[i])
  }


  selfcalculationindex <- purrr::map(a, function(temp){temp[length(temp)]})


  for (i in 1: length(nonmissinglist)){
    nonmissinglist[[i]] <- nonmissinglist[[i]][-selfcalculationindex[[i]], ]
  }


  # Remove empty entries
  isEmpty <- function(y){nrow(y)==0}

  nonempty.list <-  purrr::map(nonmissinglist, isEmpty)
  nonmissinglist[unlist(nonempty.list)==FALSE]


}
#' @examples
#' a = rnorm(15)
#'lst <- list(
#'  a = a,
#'  b = c(a[10:15], rnorm(10), a[1:5], a[1:5]),
#'  c = c(rnorm(10), a[1:5])
#')
#'find_dataleaks(lst, h=5)
#'#' a = rnorm(15)
#'lst <- list(
#'  x= a,
#'  y= c(rnorm(10), a[1:5])
#')
#'
#'find_dataleaks(lst, h=5)
#'
#'# List without naming elements
#' lst <- list(
#'  a,
#'  c(rnorm(10), a[1:5], a[1:5]),
#'  rnorm(10)
#')
#'find_dataleaks(lst, h=5)

