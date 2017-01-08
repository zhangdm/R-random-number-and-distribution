# 'root' character string of directory to search
# 'file_typs' character vector of file types to search
# 'omit_blank' logical indicating of blank lines are counted
# 'recursive' logical indicating if all directories within 'root' are searched
# 'lns' logical indicating if lines are counted, use F for counting characters
# 'trace' logical for monitoring progress
file.lens <- function(root, file_typs, omit_blank = F, recursive = T, 
	lns = T, trace = T){
	
	require(reshape2)
	
	# get files by recursive search, uses 'list.files'
	if(trace) cat(paste0('Finding files in ', root, '...\n'))
	files <- list.files(
		root, 
		pattern = paste(paste0('\\.',file_typs,'$'), collapse = '|'),
		recursive = recursive,
		full.names = T,
		ignore.case = T
		)
	
	# stop if no files found
	if(length(files) == 0) return(cat('No files found\n'))
	
	# read files, get info
	out_ls <- vector('list', length(files))
	names(out_ls) <- files
	for(fl in files){
		
		if(trace) cat(fl, '\n')
		
		# read file
		tmp <- readLines(fl, warn = F)
		
		# get file information
		fl_len <- length(tmp)
		if(omit_blank) fl_len <- sum(tmp != '')
		fl_nchr <- sum(nchar(tmp))
		Date <- file.info(fl)$mtime
		
		# combine file info, append to output
		# line or character total
		if(lns)
			out <- data.frame(
				fl = basename(fl),
				Length = fl_len,
				Date = as.character(Date), 
				stringsAsFactors = F)
		else
			out <- data.frame(
				fl = basename(fl), 
				Length = fl_nchr, 
				Date = as.character(Date), 
				stringsAsFactors = F)
		
		out_ls[[fl]] <- out
		
	}
	
	# convert list to data frame
	out_df <- do.call('rbind', out_ls)
	out_df$fl_typ <- out_df$fl
	out_df <- data.frame(out_df, row.names = 1:nrow(out_df))
	out_df$fl_typ <- tolower(lapply(strsplit(out_df$fl_typ, '\\.'), 
		function(x) x[[length(x)]]))
	
	# convert file date to posix then date, order by date
	out_df$Date <- as.POSIXct(as.character(out_df$Date), 
		format = '%Y-%m-%d %H:%M:%S')
	out_df$Date <- as.Date(out_df$Date)
	out_df <- out_df[order(out_df$Date),]
	
	# get cumulative sums by file type
	out_df <- lapply(
		split(out_df, out_df$fl_typ),
		function(x){
			tmp <- x[order(x$Date),]
			tmp$cum_len <- cumsum(tmp$Length)
			tmp[,!names(tmp) %in% 'fl_typ']
		})
	
	# add column of file type using melt
	# reassign column name
	out_df <- melt(out_df, id.var = c('fl', 'Length', 'Date', 'cum_len'))
	names(out_df)[names(out_df) %in% 'L1'] <- 'Type'
	
	return(out_df)
	
}