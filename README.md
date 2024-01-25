
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="hex/hexsticker.png" align="right" height="200"/>

# tsdataleaks

R Package for detecting data leakages in time series forecasting
competitions.

## Installation

<!--You can install the released version of tsdataleaks from -->
<!-- [CRAN](https://CRAN.R-project.org) with: -->
<!--
&#10;``` r
install.packages("tsdataleaks")
```
&#10;-->

The development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("thiyangt/tsdataleaks")
library(tsdataleaks)
```

## Example

This is a basic example which shows you how to solve a common problem:

To demonstrate the package functions, I created a small data set with 4
time series.

``` r
set.seed(2020)
a <- rnorm(15)
d <- rnorm(10)
lst <- list(
  a = a,
  b = c(a[10:15]+rep(8,6), rnorm(10), a[1:5], a[1:5]),
  c = c(rnorm(10), a[1:5]),
  d = d,
  e = d)
```

## `find_dataleaks`: Exploit data leaks

``` r
library(tsdataleaks)
library(magrittr)
library(tidyverse)
library(viridis)
# h - I assume test period length is 5 and took that as wind size, h.
f1 <- find_dataleaks(lstx = lst, h=5, cutoff=1) 
f1
$a
  .id start end
2   b     2   6

$b
  .id start end
1   a     1   5
2   b    17  21
4   c    11  15

$c
  .id start end
1   a     1   5
2   b    17  21
3   b    22  26

$d
  .id start end
5   e     6  10

$e
  .id start end
4   d     6  10
```

Interpretation: The first element in the list means the last 5
observations of the time series `a` correlates with time series `b`
observarion from 2 to 6.

## `viz_dataleaks`: Visualise the data leaks

``` r
viz_dataleaks(f1)
[[1]]
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />


    [[2]]
    [[2]]$a
      .id start end
    2   b     2   6

    [[2]]$b
      .id start end
    1   a     1   5
    2   b    17  21
    4   c    11  15

    [[2]]$c
      .id start end
    1   a     1   5
    2   b    17  21
    3   b    22  26

    [[2]]$d
      .id start end
    5   e     6  10

    [[2]]$e
      .id start end
    4   d     6  10

## `reason_dataleaks`

Display the reasons for data leaks and evaluate usefulness of data leaks
towards the winning of the competition

``` r
r1 <- reason_dataleaks(lstx = lst, finddataleaksout = f1, h=5)
r1
[[1]]
  series1 .id start end dist_mean dist_sd is.useful.leak       reason
1       a   b     2   6        -8       0         useful add constant
2       b   a     1   5         0       0         useful  exact match
3       b   b    17  21         0       0         useful  exact match
4       b   c    11  15         0       0     not useful  exact match
5       c   a     1   5         0       0         useful  exact match
6       c   b    17  21         0       0         useful  exact match
7       c   b    22  26         0       0     not useful  exact match
8       d   e     6  10         0       0     not useful  exact match
9       e   d     6  10         0       0     not useful  exact match

[[2]]
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />
