\name{source_url}
\alias{source_url}
\title{Download an R file from a URL and source it}
\usage{
  source_url(url, ...)
}
\arguments{
  \item{url}{The URL to download.}

  \item{...}{Other arguments that are passed to
  \code{\link{source}()}.}
}
\description{
  This will download a file and source it. Because it uses
  the \code{\link{download}} function, it can handle https
  URLs.
}
\examples{
\dontrun{
# Source the download.r file from the downloader package
source_url("https://raw.github.com/wch/downloader/master/R/download.r")
}
}
\seealso{
  \code{\link{source}()} for more information on the
  arguments that can be used with this function.
}

