% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get-sports.R
\name{get_sports}
\alias{get_sports}
\title{Get a List of Available Sports}
\usage{
get_sports(api_key = Sys.getenv("THEODDS_API_KEY"))
}
\arguments{
\item{api_key}{The API key for The Odds API -- A key can be obtained at \href{https://the-odds-api.com/}{the Odds API's website}. By default,
\code{api_key} is set to \code{Sys.getenv("THEODDS_API_KEY")}. It is highly
recommended to configure this environment variable before using this
package, both for convenience and to avoid surfacing your key as plain text
in a script}
}
\value{
A tibble
}
\description{
This function returns a tibble of all of the sports which are available
currently to request from the API. The \code{key} column is what you pass
along to the \code{sport} argument to \code{get_odds}
}
\examples{
\dontrun{get_sports()}
}
