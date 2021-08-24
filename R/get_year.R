#' Extract card year from card title
#'
#' Use a card's title to extract the year that it refers to
#' Returns a data frame consisting of the (1) input card title, (2) a set of
#' columns with identified years
#'
#' @import dplyr
#' @import stringr
#' @import data.table
#' @import plyr
#'
#' @param dt.input data.frame
#' @param card.title.col.name character
#'
#' @return data.frame
#' @export
#' @examples
#' dt.example.year <- suppressWarnings(rbindlist(apply(dt.example.year, 1, get.year.from.title,
#' card.title.col.name = "card_title"), fill=TRUE))
get.year.from.title <- function(dt.input, card.title.col.name = "card_title"){

  card.title.index <- which(names(dt.input) == card.title.col.name)

  years <- dt.input[card.title.index]

  years <- tolower(years)
  years <- gsub("’", "'", years)
  years <- gsub("\\s+", " ", str_trim(years))

  years <- gsub("–", " ", years)
  years <- gsub("[^\x01-\x7F]", " ", years)
  years <- gsub("\\s+", " ", str_trim(years))
  years <- gsub("-", " ", years)
  years <- gsub("/", " ", years)
  years <- gsub("‘", " ", years)
  years <- gsub("'", " ", years)
  years <- gsub("\\*", "", str_trim(years))
  years <- gsub("~", " ", str_trim(years))
  years <- gsub("&", " ", years)
  years <- gsub("and", " ", years)
  years <- gsub(":", " ", years)
  years <- gsub("topps", " ", years)
  years <- gsub("[ [:alpha:] ]", " ", years)
  years <- gsub("\\s+", " ", str_trim(years))
  years <- unlist(strsplit(years, " "))
  years <- as.numeric(years)
  years <- as.character(as.numeric(years))
  years <- years[nchar(years) <= 4]
  years <- gsub("\\s+", " ", str_trim(years))
  years <- unlist(str_extract_all(years, "\\d{4}"))

  years <- as.numeric(years)
  years <- years[years >= 1850 & years <= 2022]
  years <- years[!is.na(years)]

  if(is.na(years) || (length(years) == 0)){
    four_digit_year <- NA
    four_digit_year_count <- 0
  }else{
    four_digit_year <- years[1]
    four_digit_year_count <- length(years)
  }

  years <- dt.input[card.title.index]
  years <- gsub("# ", "#", years)
  years <- unlist(strsplit(years, " "))
  years <- years[!grepl("#", years)]
  years <- paste(years, collapse = " ")
  years <- gsub("\\d{4}", "", years)
  years <- gsub("\\d{3}", "", years)

  years.0 <- unlist(str_extract_all(years, "^\\d{2} \\d{2}"))
  if(length(years.0) == 1 && is.na(years.0)) years.0 <- c()
  if(length(years.0) != 0 && nchar(years.0) > 2) years.0 <- unlist(strsplit(years.0, " "))[1]
  years.0.5 <- c()
  if(!is.na(as.numeric(substr(years, 1, 2))) & substr(years, 3, 3) == " "){
    years.0.5 <- substr(years, 1, 2)
  }
  years.1 <- unlist(str_extract_all(years, "‘\\d{2}"))
  years.1 <- gsub("‘", "", years.1)
  years.1.5 <- unlist(str_extract_all(years, "\\d{2}‘"))
  years.1.5 <- gsub("‘", "", years.1.5)
  years.2 <- unlist(str_extract_all(years, "'\\d{2}"))
  years.2 <- gsub("'", "", years.2)
  years.2.5 <- unlist(str_extract_all(years, "\\d{2}'"))
  years.2.5 <- gsub("'", "", years.2.5)
  years.3 <- unlist(str_extract_all(years, "\\d{2}-\\d{2}"))
  years.3 <- strsplit(years.3, "-")
  years.3.5 <- c()
  if(length(years.3) != 0){
    for(i in 1:length(years.3)){
      years.3.5 <- c(years.3.5,
                     as.numeric(lapply(years.3, `[`, 2))[i] -
                       as.numeric(lapply(years.3, `[`, 1))[i])
    }
    if(length(which(years.3.5 == 1) == 1)){
      years.3 <- unlist(lapply(years.3, `[`, 1)[which(years.3.5 == 1)])
    }else if(length(which(years.3.5 == 1) > 1)){
      years.3 <- unlist(lapply(years.3, `[`, 1)[1])
    }else{
      years.3 <- c()
    }
  }else if(length(years.3) == 0){
    years.3 <- c()
  }
  rm(years.3.5)
  years.4 <- unlist(str_extract_all(years, "\\d{2}/\\d{2}"))
  years.4 <- strsplit(years.4, "/")
  years.4.5 <- c()
  if(length(years.4) != 0){
    for(i in 1:length(years.4)){
      years.4.5 <- c(years.4.5,
                     as.numeric(lapply(years.4, `[`, 2))[i] -
                       as.numeric(lapply(years.4, `[`, 1))[i])
    }
    if(length(which(years.4.5 == 1) == 1)){
      years.4 <- unlist(lapply(years.4, `[`, 1)[which(years.4.5 == 1)])
    }else if(length(which(years.4.5 == 1) > 1)){
      years.4 <- unlist(lapply(years.4, `[`, 1)[1])
    }else{
      years.4 <- c()
    }
  }else if(length(years.4) == 0){
    years.4 <- c()
  }
  rm(years.4.5)

  years.5 <- gsub("#\\d{0,3}", "", years)
  years.5 <- gsub("# \\d{0,3}", "", years.5)
  years.5 <- trimws(years.5)
  years.5 <- unlist(str_extract_all(years, "\\d{2} \\d{2} "))
  years.5 <- substr(years.5, 1, 2)
  years <- c(years.0, years.0.5, years.1, years.1.5, years.2, years.2.5, years.3, years.4)
  years <- years[!duplicated(years)]

  if(is.na(years) || (length(years) == 0)){
    two_digit_year <- NA
    two_digit_year_count <- 0
    two_to_four_digit_year <- NA
  }else{
    two_digit_year <- years[1]
    two_digit_year_count <- length(years)

    if(as.numeric(two_digit_year) > 21){
      two_to_four_digit_year <- paste0("19", two_digit_year)
    }else{
      two_to_four_digit_year <- paste0("20", two_digit_year)
    }
  }

  dt.output <- c(dt.input,
                 "four_digit_year" = four_digit_year,
                 "four_digit_year_count" = four_digit_year_count,
                 "two_digit_year" = two_digit_year,
                 "two_digit_year_count" = two_digit_year_count,
                 "two_to_four_digit_year" = two_to_four_digit_year)
  dt.output <- as.data.frame(t(dt.output))

  return(dt.output)
}

#' Extract card year from product section
#'
#' Use a card's product section information to extract the year that it refers to
#' Returns a data frame consisting of the (1) input card title, (2) a set of
#' columns with identified years. Product section information is commonly used
#' in marketplaces such as eBay. Sellers of items may or may not fill in this
#' information.
#'
#' @param dt.input data.frame
#' @param product.section.year.col.name character
#'
#' @return data.frame
#' @export
#' @examples
#' dt.example.year <- rbindlist(apply(dt.example.year, 1, get.year.from.product.section,
#' product.section.year.col.name = "product_section_year"), fill=TRUE)
get.year.from.product.section <- function(dt.input, product.section.year.col.name = "product_section_year"){

  prod.sect.year.index <- which(names(dt.input) == product.section.year.col.name)

  years.1.index <- grepl(".*(\\d{4}).*", dt.input[prod.sect.year.index])

  years.1 <- ifelse(years.1.index == TRUE, unlist(str_extract_all(dt.input[prod.sect.year.index], "\\d{4}")), NA)
  years.1 <- as.numeric(years.1)
  years.1 <- years.1[years.1 >= 1900 & years.1 <= 2022]

  if(is.na(years.1) || (length(years.1) == 0)){
    four_digit_product_section_year <- NA
    four_digit_product_section_year_count <- 0
  }else{
    four_digit_product_section_year <- years.1[1]
    four_digit_product_section_year_count <- length(years.1)
  }

  years.2 <- ifelse(years.1.index == FALSE, unlist(str_extract_all(dt.input[prod.sect.year.index], "\\d{2}")), NA)
  years.2 <- years.2[!duplicated(years.2)]

  if(is.na(years.2) || (length(years.2) == 0)){
    two_digit_product_section_year <- NA
    two_digit_product_section_year_count <- 0
    two_to_four_digit_product_section_year <- NA
  }else{
    two_digit_product_section_year <- years.2[1]
    two_digit_product_section_year_count <- length(years.2)

    if(as.numeric(two_digit_product_section_year) > 21){
      two_to_four_digit_product_section_year <- paste0("19", two_digit_product_section_year)
    }else{
      two_to_four_digit_product_section_year <- paste0("20", two_digit_product_section_year)
    }
  }

  dt.output <- c(dt.input,
                 "four_digit_product_section_year" = four_digit_product_section_year,
                 "four_digit_product_section_year_count" = four_digit_product_section_year_count,
                 "two_digit_product_section_year" = two_digit_product_section_year,
                 "two_digit_product_section_year_count" = two_digit_product_section_year_count,
                 "two_to_four_digit_product_section_year" = two_to_four_digit_product_section_year)
  dt.output <- as.data.frame(t(dt.output))

  return(dt.output)
}

#' Use the extracted years from get.year.from.title and
#' get.year.from.product.section to construct a card year column
#'
#' @param dt.input data.frame
#'
#' @return data.frame
#' @export
#' @examples
#' dt.example.year <- get.product.year(dt.example.year)
get.product.year <- function(dt.input){

  dt.input[, product_id_year := ifelse(!is.na(four_digit_year), four_digit_year,
                                       ifelse(!is.na(two_to_four_digit_year), two_to_four_digit_year,
                                              ifelse(!is.na(four_digit_product_section_year), four_digit_product_section_year,
                                                     ifelse(!is.na(two_to_four_digit_product_section_year), two_to_four_digit_product_section_year, NA))))]
  return(dt.input)
}
