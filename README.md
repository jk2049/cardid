
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cardid

<!-- badges: start -->

<!-- badges: end -->

The goal of cardid is to allow you to use the information of basketball
and baseball sports trading cards in order to find the (1) player and
(2) year that each card refers to. In addition, it allows the creation
of a card identifier.

## Installation

You can install the released version of cardid from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("cardid")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("jk2049/cardid")
```

## Example

Below you can find an example of the functionalities offered. Please
keep in mind that this is an early version. As a result, the results of
this code have only been tested when running the functions in the same
order as in the below example:

``` r
library(cardid)
library(dplyr)
#> Warning: package 'dplyr' was built under R version 4.0.5
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(stringr)
#> Warning: package 'stringr' was built under R version 4.0.3
library(data.table)
#> Warning: package 'data.table' was built under R version 4.0.5
#> 
#> Attaching package: 'data.table'
#> The following objects are masked from 'package:dplyr':
#> 
#>     between, first, last
library(plyr)
#> Warning: package 'plyr' was built under R version 4.0.4
#> ------------------------------------------------------------------------------
#> You have loaded plyr after dplyr - this is likely to cause problems.
#> If you need functions from both plyr and dplyr, please load plyr first, then dplyr:
#> library(plyr); library(dplyr)
#> ------------------------------------------------------------------------------
#> 
#> Attaching package: 'plyr'
#> The following objects are masked from 'package:dplyr':
#> 
#>     arrange, count, desc, failwith, id, mutate, rename, summarise,
#>     summarize
```

The package offers three datasets. The first is a dataset with
information about all the player who have played in the MLB:

``` r
head(dt.baseball.players)
#>           player from   to active hall_of_famer   sports
#> 1: david aardsma 2004 2015      0             0 baseball
#> 2:   henry aaron 1954 1976      0             1 baseball
#> 3:  tommie aaron 1962 1971      0             0 baseball
#> 4:      don aase 1977 1990      0             0 baseball
#> 5:     andy abad 2001 2006      0             0 baseball
#> 6: fernando abad 2010 2019      1             0 baseball
```

The second is a dataset with information about all the player who have
played in the NBA:

``` r
head(dt.basketball.players)
#>                 player from   to pos   ht  wt        birth_date
#> 1:      alaa abdelnaby 1991 1995 F-C 6-10 240     June 24, 1968
#> 2:     zaid abdul-aziz 1969 1978 C-F  6-9 235     April 7, 1946
#> 3: kareem abdul-jabbar 1970 1989   C  7-2 225    April 16, 1947
#> 4:  mahmoud abdul-rauf 1991 2001   G  6-1 162     March 9, 1969
#> 5:   tariq abdul-wahad 1998 2003   F  6-6 223  November 3, 1974
#> 6: shareef abdur-rahim 1997 2008   F  6-9 225 December 11, 1976
#>                    colleges active hall_of_famer     sports
#> 1:                     Duke      0             0 basketball
#> 2:               Iowa State      0             0 basketball
#> 3:                     UCLA      0             1 basketball
#> 4:                      LSU      0             0 basketball
#> 5: Michigan, San Jose State      0             0 basketball
#> 6:               California      0             0 basketball
```

The third is a subset of a dataset that contains information about
sports trading cards that were listed on eBay:

``` r
head(dt.example)
#>        sports
#> 1: Basketball
#> 2: Basketball
#> 3: Basketball
#> 4: Basketball
#> 5: Basketball
#> 6: Basketball
#>                                                                        card_title
#> 1:             00/01 Fleer Authority#129 Stephen Jackson RC 1/1250 BGS-9 MINT  NM
#> 2:                  00/01 Fleer Authority #136 Darius Miles RC 1/1250 BGS 9 MINT 
#> 3:          00/01 Fleer Authority Grant Hill With Authority 1/299 BGS-8 NM-MT  NM
#> 4:  00-01 Fleer Autographics Dirk Nowitzki ON CARD NBA AUTO 2000 2001 BGS 7.5 NM+
#> 5:                        00-01 SP Game Floor Kobe/Shaq Dual Floor Graded BGS 9.5
#> 6: 00-01 Topps Gold Label Finals Worn Jersey Refractive Shaq O’Neal #TT1H BGS 9.5
#>    product_section_year
#> 1:                00/01
#> 2:                00/01
#> 3:                00/01
#> 4:              2000-01
#> 5:                   NA
#> 6:                 2000

dt.example.titles <- dt.example[, list(sports, card_title)]
dt.example.basketball.titles <- dt.example.titles[sports == "Basketball", ]
dt.example.baseball.titles <- dt.example.titles[sports == "Baseball", ]
dt.example.years <- dt.example[, list(sports, card_title, product_section_year)]
```

### Player Name Pre-Processing

First, we use the functions ‘’baseball.preprocess’’ and
‘’baseball.preprocess’’ in order to manipulate the player names of
the MLB and the NBA players respectively. Standard NLP actions are taken
(i.e., remove stopwords etc.) that allow us to build a dictionary of
player names. This is important as the same player names (e.g.,
shaquille o’neal) can be written in different ways in the card titles
(e.g., shaquille o’neal, shaquille o neal, shaquille oneal etc.).

``` r
baseball.players <- baseball.preprocess(dt.baseball.players)
basketball.players <- basketball.preprocess(dt.basketball.players)
```

### Card Title Pre-Processing

Second, we use the function ‘’data.preprocess’’ on the card title
columns in order to manipulate the card titles (i.e., remove stopwords
etc.)

``` r
dt.example.basketball.titles$card_title <- data.preprocess(dt.example.basketball.titles$card_title)
dt.example.baseball.titles$card_title <- data.preprocess(dt.example.baseball.titles$card_title)
dt.example.years$card_title_2 <- data.preprocess(dt.example.years$card_title)
```
