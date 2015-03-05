\name{download_cached}
\alias{download_cached}
\title{Download a file from the internet, but check your hard drive for a saved copy first}
\usage{
  download_cached(	url , destfile , ... , FUN = download.file , usedest = getOption( "download_cached.usedest" ) , usecache = getOption( "download_cached.usecache" ) , attempts = 3 , sleepsec = 60 )
}
\arguments{
  \item{url}{The URL to download.}

  \item{destfile}{A SHA-1 hash of the file at the URL.}
	
  \item{...}{Other arguments that are passed to FUN}

  \item{FUN}{either \code{download.file} or \code{download}}

  \item{usedest}{the program checks whether the destination file is present and contains at least one byte and if so, doesn't do anything}

  \item{usecache}{check the temporary directory for a file that has already been downloaded and copy the cached file to the destination file instead of downloading it}

  \item{attempts}{how many attempts should be made with FUN?}

  \item{sleepsec}{how long should download.cache wait between attempts?}
  
}
\description{
  This will check the local disk for a cached copy of a file before downloading it from the internet. Use \code{FUN=\link{download}()} function, to handle https URLs.
}
\details{
  By default, \code{download_cached()} checks the R temporary 
  directories for an already-downloaded version of the file.
  If the file exists on the local disk, it will
  copy the cached file to the \code{destfile} location.

  To force the re-downloading of all files from the internet,
  set \code{ options( "download_cached.usecache" = TRUE ) }.
}
\examples{
\dontrun{
# initiate a temporary file on the local disk
tf <- tempfile()

# download a sample file or web page
downloader::download_cached( "http://www.cwi.nl" , tf )

# nuke the temporary file
file.remove( tf )

# download it again, but since it's already been stored on the local disk, no download required!
downloader::download_cached( "http://www.cwi.nl" , tf )

}
}
\seealso{
  \code{\link{download.file}()} and \code{\link{downloader::download}()}
  for more information on the arguments that can be used with this function.
}

