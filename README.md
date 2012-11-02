downloader
==========

This package provides a wrapper for the download.file function, making it possible to download files over https on Windows, Mac OS X, and other Unix-like platforms.
The RCurl package provides this functionality (and much more) but can be difficult to install because it must be compiled with external dependencies.
This package has no external dependencies, so it is much easier to install.

Example usage
=============

This will download the source code for the downloader package:

```R
# First install downloader from CRAN
install.packages("downloader")

library(downloader)
download("https://github.com/wch/downloader/zipball/master",
         "downloader.zip", mode = "wb")
```
