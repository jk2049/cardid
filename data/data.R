#' Player information of 20,247 historical MLB players.
#'
#' A dataset containing the prices and other attributes of almost 20,000
#' historical MLB players.
#'
#' @format A data frame with 20,247 rows and 7 variables:
#' \describe{
#'   \item{player}{name of the baseball player (can have multiple formats - each
#'   in a new entry - due to non-ASCII characters)}
#'   \item{sports}{sport that this dataset refers to}
#'   \item{from}{year when the player started playing in the MLB}
#'   \item{to}{year when the player stopped playing in the MLB}
#'   \item{active}{whether the player is active in the MLB}
#'   \item{hall_of_famer}{whether the player is a hall of famer}
#'   \item{original_player}{name of the baseball player (it's the same no
#'   matter how many different "player" names are available for the same
#'   player)}
#' }
#' @source \url{https://www.baseball-reference.com/players/}
"baseball.players"
#'
#' Player information of 5,154 historical NBA players.
#'
#' A dataset containing the prices and other attributes of almost 5,000
#' historical NBA players.
#'
#' @format A data frame with 5,154 rows and 7 variables:
#' \describe{
#'   \item{player}{name of the baseball player (can have multiple formats - each
#'   in a new entry - due to non-ASCII characters)}
#'   \item{sports}{sport that this dataset refers to}
#'   \item{from}{year when the player started playing in the NBA}
#'   \item{to}{year when the player stopped playing in the NBA}
#'   \item{active}{whether the player is active in the NBA}
#'   \item{hall_of_famer}{whether the player is a hall of famer}
#'   \item{original_player}{name of the baseball player (it's the same no
#'   matter how many different "player" names are available for the same
#'   player)}
#' }
#' @source \url{https://www.basketball-reference.com/players/}
"basketball.players"
#'
#' Card information of 10,000 sports trading cards.
#'
#' A dataset containing the titles and other attributes of 10,000 sports
#' trading cards.
#'
#' @format A data frame with 5,154 rows and 7 variables:
#' \describe{
#'   \item{sports}{sport that the card refers to}
#'   \item{card_title}{the title of the card}
#'   \item{product_section_year}{information of the product section field. This
#'   information may or may not have been filled by the seller}
#' }
#' @source \url{eBay}
"dt.example"
