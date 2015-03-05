# written by http://hannes.muehleisen.org/

# from http://stackoverflow.com/questions/16474696/read-system-tmp-dir-in-r
gettmpdir <- 
	function() {
		tm <- Sys.getenv(c('TMPDIR', 'TMP', 'TEMP'))
		d <- which(file.info(tm)$isdir & file.access(tm, 2) == 0)
		if (length(d) > 0)
		  tm[[d[1]]]
		else if (.Platform$OS.type == 'windows')
		  Sys.getenv('R_USER')
		else '/tmp'
	}



download_cached <- 
  function (
	url ,
	
	destfile ,
	
	# pass in any other arguments needed for the FUN
	... ,

	# specify which download function to use.
	# `download.file` and `downloader::download` should both work.
	FUN = download.file ,

	# if usedest is TRUE, then 
	# the program checks whether the destination file is present and contains at least one byte
	# and if so, doesn't do anything.
    usedest = getOption( "download_cached.usedest" ) , 
	
    # if usecache is TRUE, then
	# it checks the temporary directory for a file that has already been downloaded,
	# and if so, copies the cached file to the destination file *instead* of downloading.
	usecache = getOption( "download_cached.usecache" ) ,
	
	# how many attempts should be made with FUN?
	attempts = 3 ,
	# just in case of a server timeout or smthn equally annoying
	
	# how long should download_cached wait between attempts?
	sleepsec = 60
  ) {
  
		# users can set the option to override usedest and usecache globally.
		# however, if they're not set, they will default to FALSE and TRUE, respectively
		if( is.null( usedest ) ) usedest <- FALSE
		if( is.null( usecache ) ) usecache <- TRUE
		# you could set these *outside* of this function
		# with lines like
		# options( "download_cached.usedest" = FALSE )
		# options( "download_cached.usecache" = TRUE )
    		
			
		cat(
			paste0(
				"Downloading from URL '" ,
				url , 
				"' to file '" , 
				destfile , 
				"'... "
			)
		)
		
		if ( usedest && file.exists( destfile ) && file.info( destfile )$size > 0 ) {
		
			cat("Destination already exists, doing nothing (override with usedest=FALSE parameter)\n")
			
			return( invisible( 0 ) )
			
		}
		
		cachefile <- 
			paste0(
				gsub( "\\" , "/" , gettmpdir() , fixed = TRUE ) , 
				"/" ,
				digest( url ) , 
				".Rdownloadercache"
			)
		
		if (usecache) {
		
			if (file.exists(cachefile) && file.info(cachefile)$size > 0) {
				
				cat(
				  paste0(
					"Destination cached in '" , 
					cachefile , 
					"', copying locally (override with usecache=FALSE parameter)\n"
				  )
				)
				
				return( invisible( ifelse( file.copy( cachefile , destfile , overwrite = TRUE ) , 0 , 1 ) ) )
				
		  }
		  
		}
		
		# start out with a failed attempt, so the while loop below commences
		failed.attempt <- try( stop() , silent = TRUE )
		
		# keep trying the download until you run out of attempts
		# and all previous attempts have failed
		
		initial.attempts <- attempts
		
		while( attempts > 0 & class( failed.attempt ) == 'try-error' ){
		
			# only run this loop a few times..
			attempts <- attempts - 1
			
			failed.attempt <-
				try( {
					
					# did the download work?
					success <- 
						do.call( 
							FUN , 
							list( url , destfile , ... ) 
						) == 0
						
					} , 
					silent = TRUE 
				)
			
			# if the download did not work, wait `sleepsec` seconds and try again.
			if( class( failed.attempt ) == 'try-error' ){
				cat( paste( "download issue with" , url , "\r\n" ) )
				Sys.sleep( sleepsec )
			}
			
		}
		
		# double-check that the `success` object exists.. it might not if `attempts` was set to zero.
		if ( exists( 'success' ) ){
			if (success && usecache) file.copy( destfile , cachefile , overwrite = TRUE )
		
			return( invisible( success ) )
		
		# otherwise break.
		} else stop( paste( "download failed after" , initial.attempts , "attempts" ) )

	}
