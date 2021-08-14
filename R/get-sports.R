
#' Get a List of Available Sports
#'
#' This function returns a tibble of all of the sports which are available
#' currently to request from the API. The \code{key} column is what you pass
#' along to the \code{sport} argument to \code{get_odds}
#'
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
#' \dontrun{get_sports()}
get_sports <- function(api_key = Sys.getenv("THEODDS_API_KEY")) {

    # Make the request
    res <- httr::GET(
        "https://api.the-odds-api.com/v3/sports",
        query = list(api_key = api_key)
    )

    # Check for 401 status code and provide helpful error message
    if (httr::status_code(res) == 401L) {

        error_message <- paste(
            "Request returned 401 status code,",
            "a likely reason is THEODDS_API_KEY environment",
            "variable has not been configured"
        )

        stop(error_message, call. = FALSE)

    }

    # Rectangle the data
    res %>%
        httr::content() %>%
        purrr::pluck("data") %>%
        purrr::map(unlist) %>%
        purrr::map(tibble::enframe) %>%
        purrr::map(
            tidyr::pivot_wider,
            names_from = "name",
            values_from = "value"
        ) %>%
        dplyr::bind_rows() %>%
        dplyr::mutate(
            dplyr::across(c(active, has_outrights), as.logical)
        )

}
