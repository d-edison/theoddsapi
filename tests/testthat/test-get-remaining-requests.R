# Error check already done in test code for get-sports-list,
# just need to verify that this returns correct tibble

test_that("returns tibble with correct columns", {

    skip_on_cran()

    remaining_requests <- get_remaining_requests()

    expect_s3_class(remaining_requests, "tbl_df")

    expect_equal(
        colnames(remaining_requests),
        c("requests_remaining", "requests_used")
    )

})
