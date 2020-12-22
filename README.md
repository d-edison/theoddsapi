
<!-- README.md is generated from README.Rmd. Please edit that file -->

# theoddsapi

<!-- badges: start -->

<!-- badges: end -->

theoddsapi package provides a convenient wrapper for [the Odds
API](https://the-odds-api.com/). The principal function `get_odds`
provides a convenient, simple interface which allows you to leverage the
API to pull odds from various different sports, books, and market types
into nice, tidy tibbles.

## Installation

You can install the theoddsapi from GitHub with:

``` r
devtools::install_github("d-edison/theoddsapi")
```

## Configuration

In order to use this R package, you must first generate an API key (A
free tier is available which grants 500 requests per month). To generate
the key, navigate to [the Odds API’s website](https://the-odds-api.com/)
and click the “Get API Key” button. From there, you simply follow the
instructions to get your key emailed to you.

Once you have your key it is **highly recommded** to configure the R
environment variable `THEODDS_API_KEY`. To do this, call either
`Sys.setenv(THEODDS_API_KEY = "<your_key>")` or edit your `.Renviron`
file.

## Usage

``` r
library(theoddsapi)

# get all of the sports available
get_sports()
#> # A tibble: 30 x 6
#>    key           active group       details            title       has_outrights
#>    <chr>         <chr>  <chr>       <chr>              <chr>       <chr>        
#>  1 americanfoot~ TRUE   American F~ "US College Footb~ NCAAF       FALSE        
#>  2 americanfoot~ TRUE   American F~ "US Football"      NFL         FALSE        
#>  3 basketball_e~ TRUE   Basketball  "Basketball Eurol~ Basketball~ FALSE        
#>  4 basketball_n~ TRUE   Basketball  "US Basketball"    NBA         FALSE        
#>  5 basketball_n~ TRUE   Basketball  "US College Baske~ NCAAB       FALSE        
#>  6 cricket_big_~ TRUE   Cricket     "Big Bash League"  Big Bash    FALSE        
#>  7 cricket_test~ TRUE   Cricket     "International Te~ Test Match~ FALSE        
#>  8 mma_mixed_ma~ TRUE   Mixed Mart~ "Mixed Martial Ar~ MMA         FALSE        
#>  9 rugbyleague_~ TRUE   Rugby Leag~ "Aussie Rugby Lea~ NRL         FALSE        
#> 10 soccer_austr~ TRUE   Soccer - O~ "Aussie Soccer \U~ A-League    FALSE        
#> # ... with 20 more rows

# find out how many requests are remaining
get_remaining_requests()
#> # A tibble: 1 x 2
#>   requests_remaining requests_used
#>   <chr>              <chr>        
#> 1 434                66

# make a request to get odds
get_odds("basketball_nba", mkt = "spreads")
#> # A tibble: 390 x 5
#>    sport commence_time       team                  book           spreads
#>    <chr> <dttm>              <chr>                 <chr>            <dbl>
#>  1 NBA   2020-12-22 16:10:00 Brooklyn Nets         PointsBet (US)    -7.5
#>  2 NBA   2020-12-22 16:10:00 Golden State Warriors PointsBet (US)     7.5
#>  3 NBA   2020-12-22 16:10:00 Brooklyn Nets         BetMGM            -7.5
#>  4 NBA   2020-12-22 16:10:00 Golden State Warriors BetMGM             7.5
#>  5 NBA   2020-12-22 16:10:00 Brooklyn Nets         SugarHouse        -7.5
#>  6 NBA   2020-12-22 16:10:00 Golden State Warriors SugarHouse         7.5
#>  7 NBA   2020-12-22 16:10:00 Brooklyn Nets         LowVig.ag         -7.5
#>  8 NBA   2020-12-22 16:10:00 Golden State Warriors LowVig.ag          7.5
#>  9 NBA   2020-12-22 16:10:00 Brooklyn Nets         Bovada            -7.5
#> 10 NBA   2020-12-22 16:10:00 Golden State Warriors Bovada             7.5
#> # ... with 380 more rows
```
