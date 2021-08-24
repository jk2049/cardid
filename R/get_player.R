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
