
library(mockery)

test_that("fails if bad API key set", {

    expect_error(get_odds_raw(api_key = "fake_key"))

})

test_that("fails if API key not configured", {

    stub(get_odds_raw, "Sys.getenv", "")

    expect_error(get_odds_raw())

})

test_that("fails if bad sport key is provided", {

    expect_error(get_odds_raw("fake_sport_key"))

})

test_that("fails if other bad arguments are provided", {

    expect_error(get_odds_raw(region = "fake_region"))
    expect_error(get_odds_raw(mkt = "fake_market"))
    expect_error(get_odds_raw(date_format = "fake_date_format"))
    expect_error(get_odds_raw(odds_format = "fake_odds_format"))

})

# Run tests for h2h, spread, and totals
test_that("returns tibbles with correct columns, mkt = 'h2h'", {

    skip_on_cran()

    # randomly choose a sport
    sport_key <- sample(get_sports()$key, 1)
    odds_raw <- get_odds_raw(sport_key, mkt = "h2h")

    # checks on raw object returned
    expect_type(odds_raw, "list")
    expect_gt(length(odds_raw), 0)

    # rectangle
    odds <- rectangle_output(odds_raw)

    # checks on final tibble
    expect_s3_class(odds, "tbl_df")
    expect_equal(
        colnames(odds),
        c("sport", "commence_time", "team", "book", "h2h")
    )

})

test_that("returns tibbles with correct columns, mkt = 'spreads'", {

    skip_on_cran()

    odds_raw <- get_odds_raw(mkt = "spreads")

    # checks on raw object returned
    expect_type(odds_raw, "list")
    expect_gt(length(odds_raw), 0)

    # rectangle
    odds <- rectangle_output(odds_raw, mkt = "spreads")

    # checks on final tibble
    expect_s3_class(odds, "tbl_df")
    expect_equal(
        colnames(odds),
        c("sport", "commence_time", "team", "book", "spreads")
    )

})

test_that("returns tibbles with correct columns, mkt = 'totals'", {

    skip_on_cran()

    odds_raw <- get_odds_raw(mkt = "totals")

    # checks on raw object returned
    expect_type(odds_raw, "list")
    expect_gt(length(odds_raw), 0)

    # rectangle
    odds <- rectangle_output(odds_raw, mkt = "totals")

    # checks on final tibble
    expect_s3_class(odds, "tbl_df")
    expect_equal(
        colnames(odds),
        c("sport", "commence_time", "team", "book", "totals")
    )

})
