#' Drop columns that are no longer required
#'
#' @import stringr
#' @import data.table
#'
#' @param dt.input data.frame
#'
#' @return data.frame
#' @export
drop.useless.columns <- function(dt.input){

  dt.input$four_digit_year <- NULL
  dt.input$four_digit_year_count <- NULL
  dt.input$two_digit_year <- NULL
  dt.input$two_digit_year_count <- NULL
  dt.input$two_to_four_digit_year <- NULL
  dt.input$four_digit_product_section_year <- NULL
  dt.input$four_digit_product_section_year_count <- NULL
  dt.input$two_digit_product_section_year <- NULL
  dt.input$two_digit_product_section_year_count <- NULL
  dt.input$two_to_four_digit_product_section_year <- NULL

  # Also drop the V columns that are empty
  for(i in 4:11){
    col.player.name <- paste0("V", i)
    if(sum(is.na(dt.input[, get(col.player.name)])) == nrow(dt.input)){
      dt.input[, (col.player.name) := NULL]
    }
    rm(col.player.name)
  }
  return(dt.input)
}

#' Add additional player information
#'
#' @import stringr
#' @import data.table
#'
#' @param dt.input data.frame
#'
#' @return data.frame
#' @export
add.player.info <- function(dt.input){

  baseball.players$player <- baseball.players$original_player
  baseball.players$original_player <- NULL
  baseball.players <- baseball.players[!duplicated(baseball.players), ]
  basketball.players$player <- basketball.players$original_player
  basketball.players$original_player <- NULL
  basketball.players <- basketball.players[!duplicated(basketball.players), ]
  dt.baseball.players <- as.data.table(baseball.players)
  dt.basketball.players <- as.data.table(basketball.players)
  dt.basketball.players[, player := tolower(player)]
  dt.baseball.players[, player := tolower(player)]

  # # Find how many times each name appears
  dt.basketball.players[, n := .N, by = player]
  dt.baseball.players[, n := .N, by = player]

  # # Create an index for the names
  dt.basketball.players[, index := 1:.N, by = player]
  dt.baseball.players[, index := 1:.N, by = player]
  # dt.baseball.players[n == 5, ]

  # # For those names that appear more than once change name to name-index
  dt.basketball.players[, player_name := player]
  dt.baseball.players[, player_name := player]
  dt.basketball.players$A <- 1
  dt.basketball.players$A <- NULL
  dt.baseball.players$A <- 1
  dt.baseball.players$A <- NULL

  dt.basketball.players[n != 1, player_name := paste0(player_name, "-", index)]
  dt.baseball.players[n != 1, player_name := paste0(player_name, "-", index)]

  dt.basketball.players$sports <- "basketball"
  dt.baseball.players$sports <- "baseball"

  dt.players <- rbind(dt.basketball.players[, list(sports, player_name, from, to, active, hall_of_famer)],
                      dt.baseball.players[, list(sports, player_name, from, to, active, hall_of_famer)])

  col.names <- colnames(dt.input)
  col.names <- c(col.names, colnames(dt.players))
  col.names <- unique(col.names)
  col.names <- col.names[col.names != "player_name"]

  # Use this new name to add HoF to dt.cards
  dt.input <- merge(dt.input, dt.players,
                    by.x = c("sports", "V4"),
                    by.y = c("sports", "player_name"),
                    all.x = TRUE)
  setcolorder(dt.input, col.names)

  return(dt.input)
}
