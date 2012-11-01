context("download")

# Download from a url, and return the contents of the file as a string
download_result <- function(url) {
  tfile <- tempfile()
  download(url, tfile, mode = "wb")

  # Read the file
  tfile_fd <- file(tfile, "r")
  dl_text <- readLines(tfile_fd, warn = FALSE)
  dl_text <- paste(dl_text, collapse = "\n")
  close(tfile_fd)
  unlink(tfile)

  dl_text
}


test_that("downloading https works properly", {
  # Download https from httpbin.org
  result <- download_result("https://httpbin.org/ip")

  # Check that it has the string "origin" in the text
  expect_true(grepl("origin", result))
})

test_that("follows redirects", {
  # Download https redirect from httpbin.org
  result <- download_result("https://httpbin.org/redirect/3")

  # Check that it has the string "origin" in the text
  expect_true(grepl("origin", result))
})
