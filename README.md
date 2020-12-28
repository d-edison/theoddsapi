
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

Once you have your key it is **highly recommended** to configure the R
environment variable `THEODDS_API_KEY`. To do this, call either
`Sys.setenv(THEODDS_API_KEY = "<your_key>")` or edit your `.Renviron`
file.

## Usage

``` r
library(theoddsapi)

# get all of the sports available
get_sports()
#> # A tibble: 32 x 6
#>    key            active group       details          title        has_outrights
#>    <chr>          <chr>  <chr>       <chr>            <chr>        <chr>        
#>  1 americanfootb~ TRUE   American F~ US College Foot~ NCAAF        FALSE        
#>  2 americanfootb~ TRUE   American F~ US Football      NFL          FALSE        
#>  3 aussierules_a~ TRUE   Aussie Rul~ Aussie Football  AFL          FALSE        
#>  4 basketball_eu~ TRUE   Basketball  Basketball Euro~ Basketball ~ FALSE        
#>  5 basketball_nba TRUE   Basketball  US Basketball    NBA          FALSE        
#>  6 basketball_nc~ TRUE   Basketball  US College Bask~ NCAAB        FALSE        
#>  7 cricket_big_b~ TRUE   Cricket     Big Bash League  Big Bash     FALSE        
#>  8 cricket_test_~ TRUE   Cricket     International T~ Test Matches FALSE        
#>  9 icehockey_nhl  TRUE   Ice Hockey  US Ice Hockey    NHL          FALSE        
#> 10 mma_mixed_mar~ TRUE   Mixed Mart~ Mixed Martial A~ MMA          FALSE        
#> # ... with 22 more rows

# find out how many requests are remaining
get_remaining_requests()
#> # A tibble: 1 x 2
#>   requests_remaining requests_used
#>   <chr>              <chr>        
#> 1 406                94

# make a request to get odds
get_odds("basketball_nba", mkt = "spreads")
#> # A tibble: 138 x 5
#>    sport commence_time       team            book         spreads
#>    <chr> <dttm>              <chr>           <chr>          <dbl>
#>  1 NBA   2020-12-28 16:40:00 Atlanta Hawks   Caesars        -10  
#>  2 NBA   2020-12-28 16:40:00 Detroit Pistons Caesars         10  
#>  3 NBA   2020-12-28 16:40:00 Atlanta Hawks   BetMGM         -10.5
#>  4 NBA   2020-12-28 16:40:00 Detroit Pistons BetMGM          10.5
#>  5 NBA   2020-12-28 16:40:00 Atlanta Hawks   BetOnline.ag   -10  
#>  6 NBA   2020-12-28 16:40:00 Detroit Pistons BetOnline.ag    10  
#>  7 NBA   2020-12-28 16:40:00 Atlanta Hawks   LowVig.ag      -10  
#>  8 NBA   2020-12-28 16:40:00 Detroit Pistons LowVig.ag       10  
#>  9 NBA   2020-12-28 16:40:00 Atlanta Hawks   GTbets         -10  
#> 10 NBA   2020-12-28 16:40:00 Detroit Pistons GTbets          10  
#> # ... with 128 more rows
```
