rectangle_output <- function(res, mkt = "h2h") {

    sports <- res %>%
        purrr::map("sport_nice")

    commence_times <- res %>%
        purrr::map("commence_time")

    matchups <- res %>%
        purrr::map("teams") %>%
        purrr::map(unlist)

    sites <- res %>%
        purrr::map("sites")

    books <- sites %>%
        purrr::map_depth(2, "site_nice") %>%
        purrr::map(unlist)

    odds <- switch(
        mkt,
        h2h = {
            sites %>%
                purrr::map_depth(2, "odds") %>%
                purrr::map_depth(2, "h2h") %>%
                purrr::map(unlist)
        },
        spreads = {
            sites %>%
                purrr::map_depth(2, "odds") %>%
                purrr::map_depth(3, "points") %>%
                purrr::map(unlist)
        },
        totals = {
            sites %>%
                purrr::map_depth(2, "odds") %>%
                purrr::map_depth(3, "points") %>%
                purrr::map(unlist)
        }
    )

    # Some sports have a third odd for draws / ties,
    # need to take this into account
    len_odds <- odds %>% purrr::map_dbl(length)
    len_books <- books %>% purrr::map_dbl(length)
    odds_per_book <- len_odds / len_books

    sports <- sports %>%
        purrr::map2(len_odds, rep) %>%
        unlist()

    commence_times <- commence_times %>%
        purrr::map2(len_odds, rep) %>%
        unlist() %>%
        anytime::anytime()

    matchups <- matchups %>%
        purrr::map_if(
            tidyr::replace_na(odds_per_book == 3, FALSE),
            ~ c(.x, "Draw")
        ) %>%
        purrr::map2(len_books, rep) %>%
        unlist()

    books <- books %>%
        purrr::map2(
            odds_per_book,
            ~ rep(.x, each = .y)
        ) %>%
        unlist()

    odds <- odds %>%
        unlist() %>%
        as.double()

    out <- tibble::tibble(
        sport = sports,
        commence_time = commence_times,
        team = matchups,
        book = books,
        odds = odds
    )

    colnames(out)[5] <- mkt

    out

}

get_odds_raw <- function(sport = "upcoming",
                         region = "us",
                         mkt = "h2h",
                         date_format = "unix",
                         odds_format = "decimal",
                         api_key = Sys.getenv("THEODDS_API_KEY")) {

    region <- match.arg(region, c("us", "eu", "uk", "au"))
    mkt <- match.arg(mkt, c("h2h", "spreads", "totals"))
    date_format <- match.arg(date_format, c("unix", "iso"))
    odds_format <- match.arg(odds_format, "decimal") # Currently only supports decimal odds,
                                                     # will work to add american odds in the future
    res <- httr::GET(
        "https://api.the-odds-api.com/v3/odds",
        query = list(
            api_key = api_key,
            sport = sport,
            region = region,
            mkt = mkt,
            date_format = date_format,
            odds_format = odds_format
        )
    )

    if (httr::status_code(res) == 401L) {

        error_message <- paste(
            "Request returned 401 status code,",
            "a likely reason is THEODDS_API_KEY environment",
            "variable has not been configured"
        )

        stop(error_message, call. = FALSE)

    }

    if (httr::status_code(res) == 400L) {

        error_message <- paste(
            "Request returned 400 status code,",
            "a likely reason is an invalid value for the `sport` argument.",
            "Run `get_sports()` to get a list of valid keys"
        )

        stop(error_message, call. = FALSE)

    }

    res %>%
        httr::content() %>%
        purrr::pluck("data")

}


#' Get Odds
#'
#' The principal function of the package, \code{get_odds} allows you to pull
#' odds from various different sports, books, and market types into nice, tidy
#' tibbles
#'
#' These function arguments correspond to the request query parameters, from
#' which this help page's argument descriptions were borrowed. You can see the
#' original documentation [on the Odds API's
#' website](https://the-odds-api.com/liveapi/guides/v3/#parameters-2)
#'
#' @param sport The sport key obtained from calling the \code{get_sports}
#'   function. "upcoming" is always valid (and the default), returning any live
#'   games as well as the next 8 upcoming games across all sports
#' @param region Determines which bookmakers are returned. Valid regions are
#'   "au" (Australia), "uk" (United Kingdom), "eu" (Europe) and "us" (United
#'   States). Defaults to "us"
#' @param mkt Determines which odds market is returned. Valid markets are "h2h"
#'   (head to head / moneyline), "spreads" (handicaps) and "totals" (over/under).
#'   "spreads" and "totals" odds are not always as comprehensive as "h2h", so they do
#'   not count against the usage quota on paid plans. Defaults to "h2h"
#' @param date_format  Determines the format of timestamps in the response.
#'   Valid values are "unix" and "iso" (ISO 8601). Defaults to "unix"
#' @param odds_format Determines the format of odds in the response.
#'   Valid values are "decimal" and "american". When set to
#'   "american", small discrepancies might exist for some bookmakers due to
#'   rounding errors. Currently, this package does not support "american" odds,
#'   but hopefully will in the near future
#' @param api_key The API key for The Odds API -- A key can be obtained at [the
#'   Odds API's website](https://the-odds-api.com/). By default,
#'   \code{api_key} is set to \code{Sys.getenv("THEODDS_API_KEY")}. It is highly
#'   recommended to configure this environment variable before using this
#'   package, both for convenience and to avoid surfacing your key as plain text
#'   in a script
#'
#' @return
#' A tibble
#'
#' @export
#'
#' @examples
#' \dontrun{epl_odds <- get_odds("soccer_epl")}
#' \dontrun{nfl_spreads <- get_odds("americanfootball_nfl", mkt = "spreads")}
#' \dontrun{nba_totals <- get_odds("basketball_nba", mkt = "totals")}
get_odds <- function(sport = "upcoming",
                     region = "us",
                     mkt = "h2h",
                     date_format = "unix",
                     odds_format = "decimal",
                     api_key = Sys.getenv("THEODDS_API_KEY")) {

    res <- get_odds_raw(
        sport,
        region,
        mkt,
        date_format,
        odds_format,
        api_key
    )

    tryCatch(
        rectangle_output(res, mkt = mkt),
        error = function(e) stop("Unable to transform raw output to a tibble", call. = FALSE)
    )

}
