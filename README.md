
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
## basic example code
```

The package offers three datasets. The first is a dataset with
information about all the player who have played in the MLB:

``` r
head(baseball.players)
#>          player   sports from   to active hall_of_famer original_player
#> 1 david aardsma baseball 2004 2015      0             0   david aardsma
#> 2   henry aaron baseball 1954 1976      0             1     henry aaron
#> 3  tommie aaron baseball 1962 1971      0             0    tommie aaron
#> 4      don aase baseball 1977 1990      0             0        don aase
#> 5     andy abad baseball 2001 2006      0             0       andy abad
#> 6 fernando abad baseball 2010 2019      1             0   fernando abad
```

The second is a dataset with information about all the player who have
played in the NBA:

``` r
head(basketball.players)
#>               player     sports from   to active hall_of_famer
#> 1     alaa abdelnaby basketball 1991 1995      0             0
#> 2     zaid abdulaziz basketball 1969 1978      0             0
#> 3 kareem abduljabbar basketball 1970 1989      0             1
#> 4  mahmoud abdulrauf basketball 1991 2001      0             0
#> 5   tariq abdulwahad basketball 1998 2003      0             0
#> 6 shareef abdurrahim basketball 1997 2008      0             0
#>       original_player
#> 1      alaa abdelnaby
#> 2     zaid abdul-aziz
#> 3 kareem abdul-jabbar
#> 4  mahmoud abdul-rauf
#> 5   tariq abdul-wahad
#> 6 shareef abdur-rahim
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

### Card Title Pre-Processing

``` r
dt.example.basketball.titles$card_title <- data.preprocess(dt.example.basketball.titles$card_title)
dt.example.baseball.titles$card_title <- data.preprocess(dt.example.baseball.titles$card_title)
dt.example.years$card_title_2 <- data.preprocess(dt.example.years$card_title)
```

In that case, don’t forget to commit and push the resulting figure
files, so they display on GitHub and CRAN.
