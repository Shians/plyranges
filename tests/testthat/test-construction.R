# test-construction.R
context("Ranges construction")

test_that("invalid data.frame call throws an error", {
  expect_error(as_iranges(data.frame()))
  expect_error(as_iranges(data.frame(start = 1)))
})

test_that("valid data.frame returns expected class", {
  df <- data.frame(start = 1:3, width = 2:4)
  expect_s4_class(as_iranges(df), "IRanges")
  df2 <-df
  df2$strand <- "*"
  expect_s4_class(as_iranges(df2), "IRanges")

  # but there's not enough info for GRanges
  expect_error(as_granges(df2))

  df3 <- df2
  df3$seqnames <- "chr1"
  expect_s4_class(as_granges(df3), "GRanges")

  df4 <- df
  df4$seqnames <- "chr1"
  expect_s4_class(as_granges(df4), "GRanges")

})

test_that("non-standard evaluation works as expected", {
  df <- data.frame(st= 1:3, width = 2:4)
  expect_s4_class(as_iranges(df, start = st), "IRanges")
  # adding new column throws an error
  expect_error(as_iranges(df, start = st, gc = 1))
  expect_s4_class(as_granges(df, start = st, seqnames = "chr1"), "GRanges")
})

test_that("out of bounds Ranges throws error", {
  df <- data.frame(start = 1:3, width = 2:4)
  expect_error(as_iranges(df, end = 4))
  df2 <- df
  df2$seqnames <- "1"
  df2$strand <- "negative"
  expect_error(as_granges(df2))
})
