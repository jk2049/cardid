#' For some entries the previous functions have identified identical player
#' names that have been inserted in separate columns. The below function
#' removes the duplicates and only keeps the unique names
#'
#' @import stringr
#' @import data.table
#'
#' @param dt.input data.frame
#' @param card.title.col.name character
#' @param sport character
#'
#' @export
remove.duplicate.players <- function(dt.input, sport){

  # Subset data to specific sport
  dt.input$sports <- tolower(dt.input$sports)
  dt.input <- dt.input[sports == sport, ]

  if(sport == "basketball"){
    all.players <- dt.basketball.players$player
    ## Keep duplicate entries
    all.players.duplicates <- all.players[duplicated(all.players)]
  }else if(sport == "baseball"){
    all.players <- dt.baseball.players$player
    ## Keep duplicate entries
    all.players.duplicates <- all.players[duplicated(all.players)]
    all.players.duplicates <- c(all.players.duplicates,
                                all.players[grepl("jr\\.", all.players)])
  }else{
    stop(paste("Sport ", sport, " is not supported."))
  }
  rm(all.players)

  i.limit <- as.numeric(max(dt.input$n_players)) + 3

  # all.players.duplicates <- "lamelo ball"
  # table(dt.input$flag, exclude = NULL)

  dt.input$flag <- 0
  dt.input$sports <- tolower(dt.input$sports)


  for(i in 4:i.limit){
    col.player.name <- paste0("V", i)
    dt.input[get(col.player.name) %in% all.players.duplicates, flag := 1]
    rm(col.player.name)
  }
  indices <- which(dt.input$flag == 1)

  # Fix columns
  # Some V columns have the same players
  for(i in 1:length(indices)){

    # print(paste0("Loop 1 - ", sport, " ", i, " out of ", length(indices)))

    card.info <- dt.input[indices[i], ]

    # Get all the players and insert them into a vector
    players.in.title <- c()
    for(j in 4:i.limit){
      col.player.name <- paste0("V", j)
      players.in.title <- append(players.in.title, card.info[, get(col.player.name)])
      rm(col.player.name)
    }
    # Remove the NAs
    players.in.title <- players.in.title[!is.na(players.in.title)]
    # Get the number of duplicate players
    n.duplicated.player.in.title <- sum(duplicated(players.in.title))
    # Get the duplicate players
    duplicated.player.in.title <- players.in.title[duplicated(players.in.title)]

    # For every duplicate player in the vector
    j <- 1
    # Insert all the players into a new vector
    insert.players.in.title <- players.in.title
    while(j <= length(duplicated.player.in.title)){

      # Find the index of all the entries of that player
      duplicated.player.in.title.index <- which(players.in.title == duplicated.player.in.title[j])
      # Remove the first index (we want to keep the first - i.e. one - entry)
      duplicated.player.in.title.index <- duplicated.player.in.title.index[-1]
      # Replace the duplicate indices with NA
      insert.players.in.title[duplicated.player.in.title.index] <- NA

      rm(duplicated.player.in.title.index)
      j <- j + 1
    }
    # Remove the NAs
    insert.players.in.title <- insert.players.in.title[!is.na(insert.players.in.title)]

    # Change n_players
    dt.input[indices[i], n_players := as.numeric(length(insert.players.in.title))]

    # Lengthen the new vector so that it has i.limit elements (corresponding to V4-Vi.limit)
    insert.players.in.title <- c(insert.players.in.title,
                                 rep(NA, i.limit-length(insert.players.in.title)))
    # Insert the new elements into the current columns
    for(z in 1:i.limit){
      col.player.name <- paste0("V", z+3)
      dt.input[indices[i], (col.player.name) := insert.players.in.title[z]]
      rm(col.player.name)
    }

    rm(card.info, players.in.title,
       n.duplicated.player.in.title, duplicated.player.in.title,
       j, z, insert.players.in.title)
  }
  return(dt.input)
}

#' There's an issue with some names that contain "jr." for the baseball cards
#' this function addresses that issue
#'
#' @import stringr
#' @import data.table
#'
#' @param dt.input data.frame
#' @param sport character
#'
#' @export
fix.names <- function(dt.input, sport){
  if(sport == "baseball"){
    dt.input <- dt.input[sports == sport, ]

    i.limit <- as.numeric(max(dt.input$n_players)) + 3
    dt.input$flag <- 0
    for(i in 4:i.limit){
      col.player.name <- paste0("V", i)
      dt.input[grepl(" jr\\.", get(col.player.name)), flag := 1]
      rm(col.player.name)
    }
    indices <- which(dt.input$flag == 1)

    for(i in 1:length(indices)){

      # print(paste0("Loop 2 - sport ", sport, " ", i, " out of ", length(indices)))

      card.info <- dt.input[indices[i], ]

      # Get all the players and insert them into a vector
      players.in.title <- c()
      for(j in 4:i.limit){
        col.player.name <- paste0("V", j)
        players.in.title <- append(players.in.title, card.info[, get(col.player.name)])
        rm(col.player.name)
      }
      # Remove the jr. part
      players.in.title.jr.removed <- gsub(" jr\\.", "", players.in.title)
      # Remove the NAs
      players.in.title <- players.in.title[!is.na(players.in.title)]
      players.in.title.jr.removed <- players.in.title.jr.removed[!is.na(players.in.title.jr.removed)]
      # Get the number of duplicate players
      n.duplicated.player.in.title <- sum(duplicated(players.in.title.jr.removed))
      # Get the duplicate players
      duplicated.player.in.title <- players.in.title.jr.removed[duplicated(players.in.title.jr.removed)]

      # For every duplicate player in the vector
      j <- 1
      # Insert all the players into a new vector
      insert.players.in.title <- players.in.title
      while(j <= length(duplicated.player.in.title)){

        # Find the index of all the entries of that player
        duplicated.player.in.title.index <- which(grepl(duplicated.player.in.title[j], players.in.title))
        # Remove the first index (we want to keep the first - i.e. one - entry)
        duplicated.player.in.title.index <- duplicated.player.in.title.index[-2]
        # Replace the duplicate indices with NA
        insert.players.in.title[duplicated.player.in.title.index] <- NA

        rm(duplicated.player.in.title.index)
        j <- j + 1
      }
      # Remove the NAs
      insert.players.in.title <- insert.players.in.title[!is.na(insert.players.in.title)]

      # Change n_players
      dt.input[indices[i], n_players := as.numeric(length(insert.players.in.title))]

      # Lengthen the new vector so that it has 8 elements (corresponding to V4-V11)
      insert.players.in.title <- c(insert.players.in.title,
                                   rep(NA, 8-length(insert.players.in.title)))
      # Insert the new elements into the current columns
      for(z in 1:i.limit){
        col.player.name <- paste0("V", z+3)
        dt.input[indices[i], (col.player.name) := insert.players.in.title[z]]
        rm(col.player.name)
      }

      rm(card.info, players.in.title,
         n.duplicated.player.in.title, duplicated.player.in.title,
         j, insert.players.in.title, z)
    }
    dt.input[, flag := NULL]
    return(dt.input)

  }else{
    stop(paste("This function is not valid for sport ", sport, ". It's only valid for baseball."))
  }
}

#' In some cases the identified player names can refer to players who were
#' active during different periods in time (e.g., Bob Smith for baseball). This
#' function tries to address this issue by utilizing the identified card year
#' and pinpointing which specific player each card refers to.
#'
#' @import stringr
#' @import data.table
#'
#' @param dt.input data.frame
#' @param sport character
#'
#' @export
player.tie.break <- function(dt.input, sport){

  if(sport == "basketball"){
    all.players <- dt.basketball.players$player
  }else if(sport == "baseball"){
    all.players <- dt.baseball.players$player
  }else{
    stop(paste("Sport ", sport, " is not supported."))
  }
  all.players.duplicates <- all.players[duplicated(all.players)]
  if(sport == "basketball"){
    all.players <- dt.basketball.players
  }else if(sport == "baseball"){
    # Reconstruct flag
    dt.input$flag <- 0
    i.limit <- as.numeric(max(dt.input$n_players)) + 3
    for(i in 4:i.limit){
      col.player.name <- paste0("V", i)
      dt.input[get(col.player.name) %in% all.players.duplicates, flag := 1]
      rm(col.player.name)
    }
    rm(i, i.limit)

    all.players <- dt.baseball.players
  }

  indices <- which(dt.input$flag == 1)

  for(i in 1:length(indices)){

    # print(paste0("Loop 3 - ", sport, " player ", i, " out of ", length(indices)))

    card.info <- dt.input[indices[i], ]
    card.title <- card.info[, card_title_2]

    # Get all the players and insert them into a vector
    players.in.title <- c()
    col.names <- c()
    i.limit <- as.numeric(max(dt.input$n_players)) + 3
    for(j in 4:i.limit){
      col.player.name <- paste0("V", j)
      col.names <- append(col.names, col.player.name)
      players.in.title <- append(players.in.title, card.info[, get(col.player.name)])
      rm(col.player.name)
    }

    # Keep only the names that are in the names of the duplicated vector
    players.in.title <- players.in.title[players.in.title %in% all.players.duplicates]

    players.in.title.count <- 1
    while(players.in.title.count <= length(players.in.title)){
      # Get active years for every player
      player.active.year <- all.players[player == players.in.title[players.in.title.count], list(player, from, to)]
      # Compare with card title year
      player.active.year[, potential := ((as.numeric(from)-1) <= as.numeric(card.info[, product_id_year]) &
                                           as.numeric(to) >= as.numeric(card.info[, product_id_year]))]

      player.count <- sum(player.active.year$potential == TRUE)
      player.index <- which(player.active.year$potential == TRUE)
      if(!is.na(player.count) & player.count == 1){
        # One player fits
        player.name <- player.active.year[potential == TRUE, player]
        new.player.name <- paste0(player.name, "-", player.index)
      }else if(!is.na(player.count) & player.count == 0){
        # No players fit
        player.name <- player.active.year[1, player]
        new.player.name <- paste0(player.name, "-no-fit")
      }else if(!is.na(player.count) & player.count > 1){
        # All players fit
        player.name <- player.active.year[1, player]
        new.player.name <- paste0(player.name, "-all-fit")
      }else if(is.na(player.count)){
        # All players fit
        player.name <- player.active.year[1, player]
        new.player.name <- paste0(player.name, "-NA")
      }
      rm(player.active.year, player.count, player.index)

      pot.cols <- card.info[, col.names, with = FALSE]
      col.ind <- which(pot.cols == player.name)
      rm(pot.cols, player.name)

      col.player.name <- paste0("V", col.ind+3)
      dt.input[indices[i], (col.player.name) := new.player.name]
      rm(new.player.name, col.ind, col.player.name)

      players.in.title.count <- players.in.title.count + 1
    }
    rm(card.info, card.title, players.in.title, players.in.title.count)
    rm(col.names)
  }
  dt.input$flag <- NULL
  return(dt.input)
}


#' Tags which observations have a valid product id. These are the observations
#' for which exactly one player has been identified.
#'
#' @import stringr
#' @import data.table
#'
#' @param dt.input data.frame
#'
#' @export
flag.id.valid <- function(dt.input){
  dt.input[, valid := 0]
  dt.input[n_players == 1 &
             !grepl("-no-fit", V4) & !grepl("-all-fit", V4) & !grepl("-NA", V4) &
             !grepl("-no-fit", V5) & !grepl("-all-fit", V5) & !grepl("-NA", V5) &
             !grepl("-no-fit", V6) & !grepl("-all-fit", V6) & !grepl("-NA", V6) &
             !grepl("-no-fit", V7) & !grepl("-all-fit", V7) & !grepl("-NA", V7) &
             !grepl("-no-fit", V8) & !grepl("-all-fit", V8) & !grepl("-NA", V8) &
             !grepl("-no-fit", V9) & !grepl("-all-fit", V9) & !grepl("-NA", V9), valid := 1]
  dt.input[is.na(product_id_year), valid := 0]

  return(dt.input)
}
