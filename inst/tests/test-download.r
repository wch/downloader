context("download")

test_that("downloading https works properly", {
  # Download https from httpbin.org
  tfile <- tempfile()
  download("https://httpbin.org/ip", tfile, mode = "wb")

  # Read the file
  tfile_fd <- file(tfile, "r")
  dl_text <- readLines(tfile_fd, warn = FALSE)
  dl_text <- paste(dl_text, collapse = "")
  close(tfile_fd)
  unlink(tfile)

  # Check that it has the string "origin" in the text
  expect_true(grepl("origin", dl_text))
})

test_that("follows redirects", {
  # Download from httpbin.org
  tfile <- tempfile()
  download("https://httpbin.org/redirect/3", tfile, mode = "wb")

  # Read the file
  tfile_fd <- file(tfile, "r")
  dl_text <- readLines(tfile_fd, warn = FALSE)
  dl_text <- paste(dl_text, collapse = "")
  close(tfile_fd)
  unlink(tfile)

  # Check that it has the string "origin" in the text
  expect_true(grepl("origin", dl_text))
})
