
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

### Get Card Player

Then, we use the function ‘’get.player’’ to find the player(s) that each
card title refers to.

``` r
dt.example.basketball.titles <- rbindlist(
  apply(dt.example.basketball.titles, 1, get.player, 
        card.title.col.name = "card_title", sport = "basketball"), fill=TRUE)
dt.example.baseball.titles <- rbindlist(
  apply(dt.example.baseball.titles, 1, get.player, 
        card.title.col.name = "card_title", sport = "baseball"), fill=TRUE)
```

### Get Card Year

The next step is to identify the year that each card refers to. We can
identify the card year with at most two ways: One is by analyzing the
card title through the function ‘’get.year.from.title’‘, while the other
is to analyze the information contained in the product section field of
the listed cards through the function’‘get.year.from.product.section’’.
The product section field may or may not have been filled in by the
seller.

Once we are done, we use ‘’get.product.year’’ to construct the card year
column.

``` r
# Year from the card title
dt.example.years <- suppressWarnings(rbindlist(apply(dt.example.years, 1, get.year.from.title,
                                                     card.title.col.name = "card_title"), fill=TRUE))

# Year from the product section information
dt.example.years <- rbindlist(apply(dt.example.years, 1, get.year.from.product.section,
                                    product.section.year.col.name = "product_section_year"), fill=TRUE)

# Combine the two
dt.example.years <- get.product.year(dt.example.years)
```

### Get Product ID

Now that we have the identified player and year of every card, we can
construct the product identifier. If there is no identified player or no
identified year for a card, then that we insert a missing value (i.e.,
<NA>) in that card’s product id column.

``` r
dt.example.names <- rbind.fill(dt.example.baseball.titles, dt.example.basketball.titles)
rm(dt.example.baseball.titles, dt.example.basketball.titles)

dt.example.names <- as.data.table(dt.example.names)
dt.example.names <- dt.example.names[!duplicated(dt.example.names)]

dt.example <- merge(dt.example.years, dt.example.names,
                    by.x = c("sports", "card_title_2"),
                    by.y = c("sports", "card_title"), all.x = TRUE)

dt.example[, product_id := paste0(V4, "-", product_id_year)]
# If any component is NA then replace the ID with NA
dt.example[is.na(V4), product_id := NA]
dt.example[is.na(product_id_year), product_id := NA]
```

### Get Valid Product ID

Although we have constructed a product identifier, there are still some
pending issues that can only be discovered upon closer inspection of the
data:

<ol>

<li>

For some entries the previous functions have identified identical player
names that have been inserted in separate columns. By using
‘’remove.duplicate.players’’ we can remove the duplicates and only
keeps the unique names

</li>

<li>

There’s an issue with some names that contain “jr.”. This issue is only
present for the baseball cards. We address this issue using
‘’fix.names’’.

</li>

<li>

In some cases the identified player names can refer to players who were
active during different periods in time (e.g., Bob Smith for baseball).
We address this issue by using ‘’player.tie.break’’. This function
utilizes the identified card year and pinpoints which specific player
each card refers to.

</li>

<li>

We have constructed a product id for any cards for which we have
identified at least one player and a year. The product id however should
only be valid for those cards for which exactly one player has been
identified. The function ‘’flag.id.valid’’ flags these observations.

</li>

</ol>

``` r
dt.example.5.1.1 <- remove.duplicate.players(dt.example, "basketball")
#> [1] "Loop 1 - basketball 1 out of 22"
#> [1] "Loop 1 - basketball 2 out of 22"
#> [1] "Loop 1 - basketball 3 out of 22"
#> [1] "Loop 1 - basketball 4 out of 22"
#> [1] "Loop 1 - basketball 5 out of 22"
#> [1] "Loop 1 - basketball 6 out of 22"
#> [1] "Loop 1 - basketball 7 out of 22"
#> [1] "Loop 1 - basketball 8 out of 22"
#> [1] "Loop 1 - basketball 9 out of 22"
#> [1] "Loop 1 - basketball 10 out of 22"
#> [1] "Loop 1 - basketball 11 out of 22"
#> [1] "Loop 1 - basketball 12 out of 22"
#> [1] "Loop 1 - basketball 13 out of 22"
#> [1] "Loop 1 - basketball 14 out of 22"
#> [1] "Loop 1 - basketball 15 out of 22"
#> [1] "Loop 1 - basketball 16 out of 22"
#> [1] "Loop 1 - basketball 17 out of 22"
#> [1] "Loop 1 - basketball 18 out of 22"
#> [1] "Loop 1 - basketball 19 out of 22"
#> [1] "Loop 1 - basketball 20 out of 22"
#> [1] "Loop 1 - basketball 21 out of 22"
#> [1] "Loop 1 - basketball 22 out of 22"
dt.example.5.1.2 <- remove.duplicate.players(dt.example, "baseball")
#> [1] "Loop 1 - baseball 1 out of 68"
#> [1] "Loop 1 - baseball 2 out of 68"
#> [1] "Loop 1 - baseball 3 out of 68"
#> [1] "Loop 1 - baseball 4 out of 68"
#> [1] "Loop 1 - baseball 5 out of 68"
#> [1] "Loop 1 - baseball 6 out of 68"
#> [1] "Loop 1 - baseball 7 out of 68"
#> [1] "Loop 1 - baseball 8 out of 68"
#> [1] "Loop 1 - baseball 9 out of 68"
#> [1] "Loop 1 - baseball 10 out of 68"
#> [1] "Loop 1 - baseball 11 out of 68"
#> [1] "Loop 1 - baseball 12 out of 68"
#> [1] "Loop 1 - baseball 13 out of 68"
#> [1] "Loop 1 - baseball 14 out of 68"
#> [1] "Loop 1 - baseball 15 out of 68"
#> [1] "Loop 1 - baseball 16 out of 68"
#> [1] "Loop 1 - baseball 17 out of 68"
#> [1] "Loop 1 - baseball 18 out of 68"
#> [1] "Loop 1 - baseball 19 out of 68"
#> [1] "Loop 1 - baseball 20 out of 68"
#> [1] "Loop 1 - baseball 21 out of 68"
#> [1] "Loop 1 - baseball 22 out of 68"
#> [1] "Loop 1 - baseball 23 out of 68"
#> [1] "Loop 1 - baseball 24 out of 68"
#> [1] "Loop 1 - baseball 25 out of 68"
#> [1] "Loop 1 - baseball 26 out of 68"
#> [1] "Loop 1 - baseball 27 out of 68"
#> [1] "Loop 1 - baseball 28 out of 68"
#> [1] "Loop 1 - baseball 29 out of 68"
#> [1] "Loop 1 - baseball 30 out of 68"
#> [1] "Loop 1 - baseball 31 out of 68"
#> [1] "Loop 1 - baseball 32 out of 68"
#> [1] "Loop 1 - baseball 33 out of 68"
#> [1] "Loop 1 - baseball 34 out of 68"
#> [1] "Loop 1 - baseball 35 out of 68"
#> [1] "Loop 1 - baseball 36 out of 68"
#> [1] "Loop 1 - baseball 37 out of 68"
#> [1] "Loop 1 - baseball 38 out of 68"
#> [1] "Loop 1 - baseball 39 out of 68"
#> [1] "Loop 1 - baseball 40 out of 68"
#> [1] "Loop 1 - baseball 41 out of 68"
#> [1] "Loop 1 - baseball 42 out of 68"
#> [1] "Loop 1 - baseball 43 out of 68"
#> [1] "Loop 1 - baseball 44 out of 68"
#> [1] "Loop 1 - baseball 45 out of 68"
#> [1] "Loop 1 - baseball 46 out of 68"
#> [1] "Loop 1 - baseball 47 out of 68"
#> [1] "Loop 1 - baseball 48 out of 68"
#> [1] "Loop 1 - baseball 49 out of 68"
#> [1] "Loop 1 - baseball 50 out of 68"
#> [1] "Loop 1 - baseball 51 out of 68"
#> [1] "Loop 1 - baseball 52 out of 68"
#> [1] "Loop 1 - baseball 53 out of 68"
#> [1] "Loop 1 - baseball 54 out of 68"
#> [1] "Loop 1 - baseball 55 out of 68"
#> [1] "Loop 1 - baseball 56 out of 68"
#> [1] "Loop 1 - baseball 57 out of 68"
#> [1] "Loop 1 - baseball 58 out of 68"
#> [1] "Loop 1 - baseball 59 out of 68"
#> [1] "Loop 1 - baseball 60 out of 68"
#> [1] "Loop 1 - baseball 61 out of 68"
#> [1] "Loop 1 - baseball 62 out of 68"
#> [1] "Loop 1 - baseball 63 out of 68"
#> [1] "Loop 1 - baseball 64 out of 68"
#> [1] "Loop 1 - baseball 65 out of 68"
#> [1] "Loop 1 - baseball 66 out of 68"
#> [1] "Loop 1 - baseball 67 out of 68"
#> [1] "Loop 1 - baseball 68 out of 68"

dt.example.5.2.2 <- fix.names(dt.example.5.1.2, "baseball")
#> [1] "Loop 2 - sport baseball 1 out of 34"
#> [1] "Loop 2 - sport baseball 2 out of 34"
#> [1] "Loop 2 - sport baseball 3 out of 34"
#> [1] "Loop 2 - sport baseball 4 out of 34"
#> [1] "Loop 2 - sport baseball 5 out of 34"
#> [1] "Loop 2 - sport baseball 6 out of 34"
#> [1] "Loop 2 - sport baseball 7 out of 34"
#> [1] "Loop 2 - sport baseball 8 out of 34"
#> [1] "Loop 2 - sport baseball 9 out of 34"
#> [1] "Loop 2 - sport baseball 10 out of 34"
#> [1] "Loop 2 - sport baseball 11 out of 34"
#> [1] "Loop 2 - sport baseball 12 out of 34"
#> [1] "Loop 2 - sport baseball 13 out of 34"
#> [1] "Loop 2 - sport baseball 14 out of 34"
#> [1] "Loop 2 - sport baseball 15 out of 34"
#> [1] "Loop 2 - sport baseball 16 out of 34"
#> [1] "Loop 2 - sport baseball 17 out of 34"
#> [1] "Loop 2 - sport baseball 18 out of 34"
#> [1] "Loop 2 - sport baseball 19 out of 34"
#> [1] "Loop 2 - sport baseball 20 out of 34"
#> [1] "Loop 2 - sport baseball 21 out of 34"
#> [1] "Loop 2 - sport baseball 22 out of 34"
#> [1] "Loop 2 - sport baseball 23 out of 34"
#> [1] "Loop 2 - sport baseball 24 out of 34"
#> [1] "Loop 2 - sport baseball 25 out of 34"
#> [1] "Loop 2 - sport baseball 26 out of 34"
#> [1] "Loop 2 - sport baseball 27 out of 34"
#> [1] "Loop 2 - sport baseball 28 out of 34"
#> [1] "Loop 2 - sport baseball 29 out of 34"
#> [1] "Loop 2 - sport baseball 30 out of 34"
#> [1] "Loop 2 - sport baseball 31 out of 34"
#> [1] "Loop 2 - sport baseball 32 out of 34"
#> [1] "Loop 2 - sport baseball 33 out of 34"
#> [1] "Loop 2 - sport baseball 34 out of 34"

dt.example.5.3.1 <- player.tie.break(dt.example.5.1.1, "basketball")
#> [1] "Loop 3 - basketball player 1 out of 22"
#> [1] "Loop 3 - basketball player 2 out of 22"
#> [1] "Loop 3 - basketball player 3 out of 22"
#> [1] "Loop 3 - basketball player 4 out of 22"
#> [1] "Loop 3 - basketball player 5 out of 22"
#> [1] "Loop 3 - basketball player 6 out of 22"
#> [1] "Loop 3 - basketball player 7 out of 22"
#> [1] "Loop 3 - basketball player 8 out of 22"
#> [1] "Loop 3 - basketball player 9 out of 22"
#> [1] "Loop 3 - basketball player 10 out of 22"
#> [1] "Loop 3 - basketball player 11 out of 22"
#> [1] "Loop 3 - basketball player 12 out of 22"
#> [1] "Loop 3 - basketball player 13 out of 22"
#> [1] "Loop 3 - basketball player 14 out of 22"
#> [1] "Loop 3 - basketball player 15 out of 22"
#> [1] "Loop 3 - basketball player 16 out of 22"
#> [1] "Loop 3 - basketball player 17 out of 22"
#> [1] "Loop 3 - basketball player 18 out of 22"
#> [1] "Loop 3 - basketball player 19 out of 22"
#> [1] "Loop 3 - basketball player 20 out of 22"
#> [1] "Loop 3 - basketball player 21 out of 22"
#> [1] "Loop 3 - basketball player 22 out of 22"
dt.example.5.3.2 <- player.tie.break(dt.example.5.2.2, "baseball")
#> [1] "Loop 3 - baseball player 1 out of 32"
#> [1] "Loop 3 - baseball player 2 out of 32"
#> [1] "Loop 3 - baseball player 3 out of 32"
#> [1] "Loop 3 - baseball player 4 out of 32"
#> [1] "Loop 3 - baseball player 5 out of 32"
#> [1] "Loop 3 - baseball player 6 out of 32"
#> [1] "Loop 3 - baseball player 7 out of 32"
#> [1] "Loop 3 - baseball player 8 out of 32"
#> [1] "Loop 3 - baseball player 9 out of 32"
#> [1] "Loop 3 - baseball player 10 out of 32"
#> [1] "Loop 3 - baseball player 11 out of 32"
#> [1] "Loop 3 - baseball player 12 out of 32"
#> [1] "Loop 3 - baseball player 13 out of 32"
#> [1] "Loop 3 - baseball player 14 out of 32"
#> [1] "Loop 3 - baseball player 15 out of 32"
#> [1] "Loop 3 - baseball player 16 out of 32"
#> [1] "Loop 3 - baseball player 17 out of 32"
#> [1] "Loop 3 - baseball player 18 out of 32"
#> [1] "Loop 3 - baseball player 19 out of 32"
#> [1] "Loop 3 - baseball player 20 out of 32"
#> [1] "Loop 3 - baseball player 21 out of 32"
#> [1] "Loop 3 - baseball player 22 out of 32"
#> [1] "Loop 3 - baseball player 23 out of 32"
#> [1] "Loop 3 - baseball player 24 out of 32"
#> [1] "Loop 3 - baseball player 25 out of 32"
#> [1] "Loop 3 - baseball player 26 out of 32"
#> [1] "Loop 3 - baseball player 27 out of 32"
#> [1] "Loop 3 - baseball player 28 out of 32"
#> [1] "Loop 3 - baseball player 29 out of 32"
#> [1] "Loop 3 - baseball player 30 out of 32"
#> [1] "Loop 3 - baseball player 31 out of 32"
#> [1] "Loop 3 - baseball player 32 out of 32"

dt.example.5 <- rbind.fill(dt.example.5.3.1, dt.example.5.3.2)
dt.example.5 <- as.data.table(dt.example.5)

dt.example.valid <- flag.id.valid(dt.example.5)
```

### Drop Columns

Using the function ‘’drop.useless.columns’’ we can drop some columns
that are no longer needed.

``` r
colnames(dt.example.valid)
#>  [1] "sports"                                
#>  [2] "card_title_2"                          
#>  [3] "card_title"                            
#>  [4] "product_section_year"                  
#>  [5] "four_digit_year"                       
#>  [6] "four_digit_year_count"                 
#>  [7] "two_digit_year"                        
#>  [8] "two_digit_year_count"                  
#>  [9] "two_to_four_digit_year"                
#> [10] "four_digit_product_section_year"       
#> [11] "four_digit_product_section_year_count" 
#> [12] "two_digit_product_section_year"        
#> [13] "two_digit_product_section_year_count"  
#> [14] "two_to_four_digit_product_section_year"
#> [15] "product_id_year"                       
#> [16] "n_players"                             
#> [17] "V4"                                    
#> [18] "V5"                                    
#> [19] "V6"                                    
#> [20] "V7"                                    
#> [21] "product_id"                            
#> [22] "V8"                                    
#> [23] "V9"                                    
#> [24] "V10"                                   
#> [25] "valid"
dt.example.valid <- drop.useless.columns(dt.example.valid)
colnames(dt.example.valid)
#>  [1] "sports"               "card_title_2"         "card_title"          
#>  [4] "product_section_year" "product_id_year"      "n_players"           
#>  [7] "V4"                   "V5"                   "V6"                  
#> [10] "product_id"           "valid"
```

### Get Additional Player Information

Our initial sports player datasets contain information that we have not
included. Using the function ‘’add.player.info’’ we add this information
to our dataset.

``` r
dt.example.valid.hof <- add.player.info(dt.example.valid)
head(dt.example.valid.hof)
#>      sports
#> 1: baseball
#> 2: baseball
#> 3: baseball
#> 4: baseball
#> 5: baseball
#> 6: baseball
#>                                                                        card_title_2
#> 1:           #1 registry 1983 topps baseball complete set & #2 1981 topps registry 
#> 2:        **119 ea you pick many stars!! 1969 1970 1971 1972 topps baseball set lot
#> 3: *0243 thomas szapucki 2017 bowman chrome prospect purple refractor auto rc psa 9
#> 4:      *0621 joe rizzo 2016 bowman chrome draft autograph auto rookie rc bgs 95/10
#> 5:                  00 pacific private stock griffey artists canvas psa 10 gem mint
#> 6:                                   00 topps allegiance bgs 95 raw review gem mint
#>                                                                          card_title
#> 1:          #1 Registry 1983 Topps Baseball Complete Set  & #2 1981 Topps Registry 
#> 2:  **1.19 ea - you pick - MANY STARS!! -1969 1970 1971 1972 Topps baseball set lot
#> 3: *0243 Thomas Szapucki 2017 Bowman Chrome Prospect Purple Refractor AUTO RC PSA 9
#> 4:     *0621 Joe Rizzo 2016 Bowman Chrome Draft Autograph AUTO Rookie RC BGS 9.5/10
#> 5:                  00 Pacific Private Stock Griffey Artists Canvas PSA 10 Gem Mint
#> 6:                                 00 Topps Allegiance  BGS 9.5 Raw Review Gem Mint
#>    product_section_year product_id_year n_players   V4   V5   V6 product_id
#> 1:                 1983            1983         0 <NA> <NA> <NA>       <NA>
#> 2:                   NA            1969         0 <NA> <NA> <NA>       <NA>
#> 3:                   NA            2017         0 <NA> <NA> <NA>       <NA>
#> 4:                   NA            2016         0 <NA> <NA> <NA>       <NA>
#> 5:                   NA            2000         0 <NA> <NA> <NA>       <NA>
#> 6:                   NA            2000         0 <NA> <NA> <NA>       <NA>
#>    valid from   to active hall_of_famer
#> 1:     0 <NA> <NA>     NA            NA
#> 2:     0 <NA> <NA>     NA            NA
#> 3:     0 <NA> <NA>     NA            NA
#> 4:     0 <NA> <NA>     NA            NA
#> 5:     0 <NA> <NA>     NA            NA
#> 6:     0 <NA> <NA>     NA            NA
```

### Data Inspection

Let’s inspect the important columns of our produced dataset. The first
column (‘’card\_title’‘) shows the original card title. The second
(’‘n\_players’‘) shows the number of players that were identified
using our dictionary, while the third (’‘V4’‘) shows the first player
name that was identified by our dictionary. If there is more than one
identified player, then each following name is inserted into
columns’‘V5’‘,’‘V6’‘, etc. (these columns are not displayed here
to save space). In the fourth column (’‘product\_id\_year’‘) we can find
the identified card year, while in the fifth column (’‘product\_id’‘) we
see the product id. In the sixth column we can find whether the product
id is valid (’‘valid’’ equals 1). A product id is valid only if (1) a
year has been identified for this card and (2) exactly one player name
has been identified for this same card. In the columns that follow we
can find the year that the identified player started (‘’from’‘) and
stopped (’‘to’‘) playing in the MLB/NBA, as well as whether the
identified player is currently active in the MLB/NBA (’‘active’’ equals
1) and whether the player has been inducted to the hall of fame (‘’hall
of famer’’ equals 1).

``` r
dt.example.valid.hof <- dt.example.valid.hof[, list(card_title, n_players, V4, 
                                 product_id_year, product_id, 
                                 valid, from, to, active, hall_of_famer)]
head(dt.example.valid.hof[valid == 1, ])
#>                                                                          card_title
#> 1: #10  AARON  JUDGE  2019 PANINI CHROMICLES  titan  hyper   PSA 9  YANKEES  94/299
#> 2:     1 OF 1 2020 Panini Chroniclies Aaron Judge Contenders Optic Gold Vinyl PSA 9
#> 3:  (1)  PGA 10  GRADED  2018  AARON JUDGE  DONRUSS  STAT LINE BASEBALL CARD #d/402
#> 4:                      03 Diamond Kings HOF Heroes Reprints Hawaii Al Kaline /50  
#> 5: 01 Topps Finest Albert Pujols MLB RC ROOKIE ON CARD AUTO 2001 ST LOUIS CARDINALS
#> 6:     10-2008 Topps Moments and Milestones All Black Albert Pujols  /25 & /150 NM 
#>    n_players            V4 product_id_year         product_id valid from   to
#> 1:         1   aaron judge            2019   aaron judge-2019     1 2016 2021
#> 2:         1   aaron judge            2020   aaron judge-2020     1 2016 2021
#> 3:         1   aaron judge            2018   aaron judge-2018     1 2016 2021
#> 4:         1     al kaline            2003     al kaline-2003     1 1953 1974
#> 5:         1 albert pujols            2001 albert pujols-2001     1 2001 2021
#> 6:         1 albert pujols            2008 albert pujols-2008     1 2001 2021
#>    active hall_of_famer
#> 1:      1             0
#> 2:      1             0
#> 3:      1             0
#> 4:      0             1
#> 5:      1             0
#> 6:      1             0
head(dt.example.valid.hof[valid == 0, ])
#>                                                                          card_title
#> 1:          #1 Registry 1983 Topps Baseball Complete Set  & #2 1981 Topps Registry 
#> 2:  **1.19 ea - you pick - MANY STARS!! -1969 1970 1971 1972 Topps baseball set lot
#> 3: *0243 Thomas Szapucki 2017 Bowman Chrome Prospect Purple Refractor AUTO RC PSA 9
#> 4:     *0621 Joe Rizzo 2016 Bowman Chrome Draft Autograph AUTO Rookie RC BGS 9.5/10
#> 5:                  00 Pacific Private Stock Griffey Artists Canvas PSA 10 Gem Mint
#> 6:                                 00 Topps Allegiance  BGS 9.5 Raw Review Gem Mint
#>    n_players   V4 product_id_year product_id valid from   to active
#> 1:         0 <NA>            1983       <NA>     0 <NA> <NA>     NA
#> 2:         0 <NA>            1969       <NA>     0 <NA> <NA>     NA
#> 3:         0 <NA>            2017       <NA>     0 <NA> <NA>     NA
#> 4:         0 <NA>            2016       <NA>     0 <NA> <NA>     NA
#> 5:         0 <NA>            2000       <NA>     0 <NA> <NA>     NA
#> 6:         0 <NA>            2000       <NA>     0 <NA> <NA>     NA
#>    hall_of_famer
#> 1:            NA
#> 2:            NA
#> 3:            NA
#> 4:            NA
#> 5:            NA
#> 6:            NA
```
