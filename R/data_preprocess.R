#' This function pre-processes the names of the baseball players
#'
#' @import stringr
#' @import data.table
#'
#' @param dt.input data.frame
#'
#' @return data.frame
#' @export
baseball.preprocess <- function(dt.input){

  all.players <- dt.input[, list(player, sports, from, to, active, hall_of_famer)]
  all.players <- as.data.frame(cbind(all.players, "original_player" = all.players$player))
  ## Replace weird o, c, n, etc.
  all.players.1 <- all.players
  # Chinese characters appear
  all.players.1$player[grepl("[\\p{Han}]", all.players.1$player, perl = T)]
  # Manually find correct names and replace them
  all.players.1$player[grepl("[\\p{Han}]", all.players.1[, "player"], perl = T)] <-
    c("danys báez", "aledmys díaz", "yoan lópez", "vladimir núñez",
      "héctor olivera", "cionel perez", "josé santiago", "yasmany tomás",
      "raúl valdés", "adrián zabala")
  # Replace weird characters
  all.players.2 <- all.players.1
  all.players.2[, 1] <- iconv(all.players.1[, 1], from = 'UTF-8', to = 'ASCII//TRANSLIT')
  # Strings added manually (above) lead to issues in iconv so fix below
  # a <- which(is.na(all.players.2))
  all.players.2$player[which(is.na(all.players.2$player))] <- iconv(all.players.1$player[which(is.na(all.players.2$player))], to = 'ASCII//TRANSLIT')
  all.players <- as.data.frame(rbind(all.players.1, all.players.2))
  # Remove duplicates
  all.players <- all.players[!duplicated(all.players), ]
  # Some baseball players have the same names (for example Bob Smith - 5 players)
  rm(all.players.1, all.players.2)
  # Remove characters
  all.players.1 <- all.players
  all.players.1$player <- gsub("\\.", "", all.players.1$player)
  all.players.1$player <- gsub("\\'", "", all.players.1$player)
  all.players.1$player <- gsub("\\‘", "", all.players.1$player)
  all.players.1$player <- gsub("\"", "", all.players.1$player)
  # Add the above with space instead of ""
  all.players.2 <- all.players
  all.players.2$player <- gsub("\\.", " ", all.players.2$player)
  all.players.2$player <- gsub("\\'", " ", all.players.2$player)
  all.players.2$player <- gsub("\\‘", " ", all.players.2$player)
  all.players.2$player <- gsub("\"", " ", all.players.2$player)
  # Add the two
  all.players <- rbind(all.players.1, all.players.2)
  # Remove duplicates
  all.players <- all.players[!duplicated(all.players), ]
  rm(all.players.1, all.players.2)

  baseball.players <- all.players
  rm(all.players)

  baseball.players$flag <- 0
  baseball.players$flag[grepl("[\\p{Han}]", baseball.players$original_player, perl = T)] <- 1
  baseball.players$original_player[baseball.players$flag == 1 & grepl("danys", baseball.players$original_player)] <- "danys báez"
  baseball.players$original_player[baseball.players$flag == 1 & grepl("aledmys", baseball.players$original_player)] <- "aledmys díaz"
  baseball.players$original_player[baseball.players$flag == 1 & grepl("yoan", baseball.players$original_player)] <- "yoan lópez"
  baseball.players$original_player[baseball.players$flag == 1 & grepl("vladimir", baseball.players$original_player)] <- "vladimir núñez"
  baseball.players$original_player[baseball.players$flag == 1 & grepl("olivera", baseball.players$original_player)] <- "héctor olivera"
  baseball.players$original_player[baseball.players$flag == 1 & grepl("cionel", baseball.players$original_player)] <- "cionel perez"
  baseball.players$original_player[baseball.players$flag == 1 & grepl("santiago", baseball.players$original_player)] <- "josé santiago"
  baseball.players$original_player[baseball.players$flag == 1 & grepl("yasmany", baseball.players$original_player)] <- "yasmany tomás"
  baseball.players$original_player[baseball.players$flag == 1 & grepl("vald", baseball.players$original_player)] <- "raúl valdés"
  baseball.players$original_player[baseball.players$flag == 1 & grepl("zabala", baseball.players$original_player)] <- "adrián zabala"
  baseball.players$flag <- NULL

  player.names.split <- strsplit(baseball.players$original_player, " ")
  player.names.number.of.words <- unlist(lapply(player.names.split, length))
  player.names.one.word <- unlist(player.names.split[player.names.number.of.words == 1])
  baseball.players <- baseball.players[!baseball.players$original_player %in% player.names.one.word, ]
  rm(player.names.split, player.names.number.of.words, player.names.one.word)

  return(baseball.players)
}

#' This function pre-processes the names of the basketball players
#'
#' @import stringr
#' @import data.table
#'
#' @param dt.input data.frame
#'
#' @return data.frame
#' @export
basketball.preprocess <- function(dt.input){

  all.players <- dt.input[, list(player, sports, from, to, active, hall_of_famer)]
  all.players <- as.data.frame(cbind(all.players, "original_player" = all.players$player))
  ## Replace weird o, c, n, etc.
  all.players.1 <- all.players
  # Replace weird characters
  all.players.2 <- all.players.1
  all.players.2[, 1] <- iconv(all.players.2[, 1], from = 'UTF-8', to = 'ASCII//TRANSLIT')
  all.players <- as.data.frame(rbind(all.players.1, all.players.2))
  # Remove duplicates
  all.players <- all.players[!duplicated(all.players), ]
  rm(all.players.1, all.players.2)
  # Remove characters
  all.players.1 <- all.players
  all.players.1$player <- gsub("\\.", "", all.players.1$player)
  all.players.1$player <- gsub("\\'", "", all.players.1$player)
  all.players.1$player <- gsub("\\‘", "", all.players.1$player)
  all.players.1$player <- gsub("\"", "", all.players.1$player)
  all.players.1$player <- gsub("-", "", all.players.1$player)
  # Add the above with space instead of ""
  all.players.2 <- all.players
  all.players.2$player <- gsub("\\.", " ", all.players.2$player)
  all.players.2$player <- gsub("\\'", " ", all.players.2$player)
  all.players.2$player <- gsub("\\‘", " ", all.players.2$player)
  all.players.2$player <- gsub("\"", " ", all.players.2$player)
  all.players.2$player <- gsub("-", " ", all.players.2$player)
  # Add the two
  all.players <- rbind(all.players.1, all.players.2)
  # Remove duplicates
  all.players <- all.players[!duplicated(all.players), ]
  rm(all.players.1, all.players.2)

  basketball.players <- all.players
  rm(all.players)

  player.names.split <- strsplit(basketball.players$original_player, " ")
  player.names.number.of.words <- unlist(lapply(player.names.split, length))
  player.names.one.word <- unlist(player.names.split[player.names.number.of.words == 1])
  basketball.players <- basketball.players[!basketball.players$original_player %in% player.names.one.word, ]
  rm(player.names.split, player.names.number.of.words, player.names.one.word)

  return(basketball.players)
}

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
