#' Download a file, using http, https, or ftp
#'
#' This is a wrapper for \code{\link{download.file}} and takes all the same
#' arguments. The only difference is that, if the protocol is https, it changes
#' some settings to make it work. How exactly the settings are changed
#' differs among platforms.
#'
#' With Windows, it calls \code{setInternet2}, which tells R to use the
#' \code{internet2.dll}. Then it downloads the file by calling
#' \code{\link{download.file}} using the \code{"internal"} method.
#'
#' On other platforms, it will try to use \code{wget}, then \code{curl}, and
#' then \code{lynx} to download the file. Typically, Linux platforms will have
#' \code{wget} installed, and Mac OS X will have \code{curl}.
#'
#' Note that for many (perhaps most) types of files, you will want to use
#' \code{mode="wb"} so that the file is downloaded in binary mode.
#'
#' @param url The URL to download.
#' @param ... Other arguments that are passed to \code{\link{download.file}}.
#'
#' @seealso \code{\link{download.file}} for more information on the arguments
#'   that can be used with this function.
#'
#' @export
#' @examples
#' \dontrun{
#' # Download the downloader source, in binary mode
#' download("https://github.com/wch/downloader/zipball/master",
#'          "downloader.zip", mode = "wb")
#' }
#'
download <- function(url, ...) {
  # First, check protocol. If https, check platform:
  if (grepl('^https://', url)) {

    # If Windows, call setInternet2, then use download.file with defaults.
    if (.Platform$OS.type == "windows") {

      # Store initial settings, and restore on exit
      internet2_start <- setInternet2(NA)
      on.exit(setInternet2(internet2_start))

      # Needed for https
      setInternet2(TRUE)
      download.file(url, ...)

    } else {
      # If non-Windows, check for curl/wget/lynx, then call download.file with
      # appropriate method.

      if (system("wget --help", ignore.stdout=TRUE, ignore.stderr=TRUE) == 0L) {
        method <- "wget"
      } else if (system("curl --help", ignore.stdout=TRUE, ignore.stderr=TRUE) == 0L) {
        method <- "curl"

        # curl needs to add a -L option to follow redirects.
        # Save the original options and restore when we exit.
        orig_extra_options <- getOption("download.file.extra")
        on.exit(options(download.file.extra = orig_extra_options))

        options(download.file.extra = paste("-L", orig_extra_options))

      } else if (system("lynx -help", ignore.stdout=TRUE, ignore.stderr=TRUE) == 0L) {
        method <- "lynx"
      } else {
        stop("no download method found")
      }

      download.file(url, method = method, ...)
    }

  } else {
    download.file(url, ...)
  }
}
