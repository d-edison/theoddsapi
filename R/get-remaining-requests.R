
#' Get the Number of Remaining Requests
#'
#' This function returns how many requests you have made for the month, and how
#' many are remaining. The tiers for how many requests are allotted can be found
#' at [the Odds API website](https://the-odds-api.com/)
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
#' \dontrun{get_remaining_requests()}
get_remaining_requests <- function(api_key = Sys.getenv("THEODDS_API_KEY")) {

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
    out <- httr::headers(res)

    tibble::tibble(
        requests_remaining = out$`x-requests-remaining`,
        requests_used = out$`x-requests-used`
    )

}
