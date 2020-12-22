
library(mockery)

test_that("fails if bad API key set", {

    expect_error(get_sports("fake_key"))

})

test_that("fails if API key not configured", {

    stub(get_sports, "Sys.getenv", "")

    expect_error(get_sports())

})

test_that("returns tibble with correct columns", {

    skip_on_cran()

    sports <- get_sports()

    expect_s3_class(sports, "tbl_df")
    expect_equal(
        colnames(sports),
        c("key", "active", "group", "details", "title", "has_outrights")
    )

})
