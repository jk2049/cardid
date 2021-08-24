#' Extract player name(s)
#'
#' Use a card's title to extract the player/players name/names that it refers to
#' Returns a data frame consisting of the (1) input card title, (2) number of
#' identified players, (3) name(s) of the identified player(s) (each name in a
#' different column)
#'
#' @import stringr
#' @import data.table
#'
#' @param dt.input data.frame
#' @param card.title.col.name character
#' @param sport character
#'
#' @return data.frame
#' @export
#' @examples
#' dt.example.basketball.names <- data.table::rbindlist(
#' apply(dt.example.basketball.names, 1, get.player,
#' card.title.col.name = "card_title", sport = "basketball"), fill=TRUE)
#' dt.example.baseball.names <- data.table::rbindlist(
#' apply(dt.example.baseball.names, 1, get.player,
#' card.title.col.name = "card_title", sport = "baseball"), fill=TRUE)
get.player <- function(dt.input, card.title.col.name = "card_title", sport){

  card.title.index <- which(names(dt.input) == card.title.col.name)

  if(sport == "basketball"){
    players.in.title <- basketball.players[str_detect(dt.input[card.title.index], basketball.players$player),
                                           "original_player"]
  }else if(sport == "baseball"){
    players.in.title <- baseball.players[str_detect(dt.input[card.title.index], baseball.players$player),
                                         "original_player"]
  }else{
    stop(paste("Sport ", sport, " is not supported."))
  }
  n.players <- length(players.in.title)
  players.in.title <- paste(players.in.title, sep = ",")

  if(length(players.in.title) == 0) players.in.title <- NA

  dt.output <- c(dt.input, "n_players" = n.players,
                 players.in.title)
  dt.output <- as.data.frame(t(dt.output))

  return(dt.output)
}
