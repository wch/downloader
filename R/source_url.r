#' Download an R file from a URL and source it
#'
#' This will download a file and source it. Because it uses the
#' \code{\link{download}} function, it can handle https URLs.
#'
#'
#' @param url The URL to download.
#' @param ... Other arguments that are passed to \code{\link{source}()}.
#'
#' @seealso \code{\link{source}()} for more information on the arguments
#'   that can be used with this function.
#'
#' @export
#' @examples
#' \dontrun{
#' # Source the download.r file from the downloader package
#' source_url("https://raw.github.com/wch/downloader/master/R/download.r")
#' }
#'
source_url <- function(url, ...) {
   temp_file <- tempfile()

   download(url, temp_file)
   on.exit(rm(temp_file))

   source(temp_file, ...)
}
