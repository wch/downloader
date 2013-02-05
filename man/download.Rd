\name{download}
\alias{download}
\title{Download a file, using http, https, or ftp}
\usage{
  download(url, ...)
}
\arguments{
  \item{url}{The URL to download.}

  \item{...}{Other arguments that are passed to
  \code{\link{download.file}}.}
}
\description{
  This is a wrapper for \code{\link{download.file}} and
  takes all the same arguments. The only difference is
  that, if the protocol is https, it changes some settings
  to make it work. How exactly the settings are changed
  differs among platforms.
}
\details{
  This function also should follow http redirects on all
  platforms, which is something that does not happen by
  default when \code{curl} is used, as on Mac OS X.

  With Windows, it calls \code{setInternet2}, which tells R
  to use the \code{internet2.dll}. Then it downloads the
  file by calling \code{\link{download.file}} using the
  \code{"internal"} method.

  On other platforms, it will try to use \code{wget}, then
  \code{curl}, and then \code{lynx} to download the file.
  Typically, Linux platforms will have \code{wget}
  installed, and Mac OS X will have \code{curl}.

  Note that for many (perhaps most) types of files, you
  will want to use \code{mode="wb"} so that the file is
  downloaded in binary mode.
}
\examples{
\dontrun{
# Download the downloader source, in binary mode
download("https://github.com/wch/downloader/zipball/master",
         "downloader.zip", mode = "wb")
}
}
\seealso{
  \code{\link{download.file}} for more information on the
  arguments that can be used with this function.
}

