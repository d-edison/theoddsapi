
<!-- README.md is generated from README.Rmd. Please edit that file -->

# theoddsapi

<!-- badges: start -->

<!-- badges: end -->

theoddsapi package provides a convenient wrapper for [the Odds
API](https://the-odds-api.com/). The principal function `get_odds`
provides a convenient, simple interface which allows you to leverage the
API to pull odds from various different sports, books, and market types
into tidy tibbles.

## Installation

Install the theoddsapi from GitHub with:

``` r
devtools::install_github("d-edison/theoddsapi")
```

## Configuration

In order to use this R package, you must first generate an API key (A
free tier is available which grants 500 requests per month). To generate
the key, navigate to [the Odds API’s website](https://the-odds-api.com/)
and click the “Get API Key” button. From there, you simply follow the
instructions to get your key emailed to you.

Once you have your key it is **highly recommended** to configure the R
environment variable `THEODDS_API_KEY`. To do this, call either
`Sys.setenv(THEODDS_API_KEY = "<your_key>")` or directly edit your
`.Renviron` file.

## Usage

``` r
library(theoddsapi)

# get all of the sports available
get_sports()
#> # A tibble: 39 x 6
#>    key            active group      details          title         has_outrights
#>    <chr>          <chr>  <chr>      <chr>            <chr>         <chr>        
#>  1 americanfootb~ TRUE   American ~ US College Foot~ NCAAF         FALSE        
#>  2 americanfootb~ TRUE   American ~ US Football      NFL           FALSE        
#>  3 aussierules_a~ TRUE   Aussie Ru~ Aussie Football  AFL           FALSE        
#>  4 basketball_eu~ TRUE   Basketball Basketball Euro~ Basketball E~ FALSE        
#>  5 basketball_nba TRUE   Basketball US Basketball    NBA           FALSE        
#>  6 basketball_nc~ TRUE   Basketball US College Bask~ NCAAB         FALSE        
#>  7 cricket_big_b~ TRUE   Cricket    Big Bash League  Big Bash      FALSE        
#>  8 cricket_odi    TRUE   Cricket    One Day Interna~ One Day Inte~ FALSE        
#>  9 cricket_test_~ TRUE   Cricket    International T~ Test Matches  FALSE        
#> 10 icehockey_nhl  TRUE   Ice Hockey US Ice Hockey    NHL           FALSE        
#> # ... with 29 more rows

# find out how many requests are remaining
get_remaining_requests()
#> # A tibble: 1 x 2
#>   requests_remaining requests_used
#>   <chr>              <chr>        
#> 1 450                50

# make a request to get odds
get_odds("basketball_nba", mkt = "spreads")
#> # A tibble: 122 x 5
#>    sport commence_time       team              book           spreads
#>    <chr> <dttm>              <chr>             <chr>            <dbl>
#>  1 NBA   2021-01-11 16:10:00 Charlotte Hornets Caesars           -4.5
#>  2 NBA   2021-01-11 16:10:00 New York Knicks   Caesars            4.5
#>  3 NBA   2021-01-11 16:10:00 Charlotte Hornets BetMGM            -4.5
#>  4 NBA   2021-01-11 16:10:00 New York Knicks   BetMGM             4.5
#>  5 NBA   2021-01-11 16:10:00 Charlotte Hornets Bovada            -4.5
#>  6 NBA   2021-01-11 16:10:00 New York Knicks   Bovada             4.5
#>  7 NBA   2021-01-11 16:10:00 Charlotte Hornets PointsBet (US)    -4.5
#>  8 NBA   2021-01-11 16:10:00 New York Knicks   PointsBet (US)     4.5
#>  9 NBA   2021-01-11 16:10:00 Charlotte Hornets GTbets            -4.5
#> 10 NBA   2021-01-11 16:10:00 New York Knicks   GTbets             4.5
#> # ... with 112 more rows
```
