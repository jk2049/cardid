#' This function pre-processes the card title column
#'
#' @import stringr
#' @import data.table
#'
#' @param v.player.names character
#'
#' @return data.frame
#' @export
data.preprocess <- function(v.player.names){

  # Convert all character to lower case
  v.player.names <- tolower(v.player.names)
  # Remove "’"
  v.player.names <- gsub("’", "'", v.player.names)
  # Replace multiple space with one space
  v.player.names <- gsub("\\s+", " ", v.player.names)
  # Remove dots
  v.player.names <- gsub("\\.", "", v.player.names)
  # Remove "' " and " '"
  v.player.names <- gsub("\\' ", "", v.player.names)
  v.player.names <- gsub(" \\'", "", v.player.names)
  # Remove "'"
  v.player.names <- gsub("\\'", "", v.player.names)
  # Remove "–"
  v.player.names <- gsub("–", "", v.player.names)
  # Remove emojis
  v.player.names <- gsub("[^\x01-\x7F]", "", v.player.names)
  # Remove parentheses
  v.player.names <- gsub("\\(", "", v.player.names)
  v.player.names <- gsub("\\)", "", v.player.names)
  # Remove "-"
  v.player.names <- gsub("-", " ", v.player.names)
  # Replace " - " with "-"
  v.player.names <- gsub(" - ", "-", v.player.names)
  # Remove multiple spaces
  v.player.names <- gsub("\\s+", " ", v.player.names)

  return(v.player.names)
}
