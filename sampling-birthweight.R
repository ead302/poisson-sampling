library(data.table)
library(ggplot2)
setDTthreads(8)
options(scipen = 999)

years <- 2013:2024
chunk_size1<-50000
sum_w <-0
sum_wt<- 0
mu_w  <- 0.6
sd_w  <- 1

t0 <- system.time({
  for (yr in years) {
    message(paste("...Starting 1st pass for Year:", yr))

    # Check if running on SOL (Linux) or Local (Windows)
    if (Sys.info()["sysname"] == "Linux") {
      # Path on ASU SOL Server
      data_dir <- "/home/eagyema3/Poisson_sampling"
    } else {
    # Path on your local Windows machine
    data_dir <- "C:/Users/User/Downloads"
    }

    #file_path<- paste0("C:/Users/User/Downloads/natality", yr, "us.csv")
    file_path <- file.path(data_dir, paste0("natality", yr, "us.csv"))
    con <- file(file_path, open = "r")
    header <- readLines(con, n = 1)
    
    chunk_count <- 0
    repeat {
      
      chunk_lines <- readLines(con, n = chunk_size1)
      if (length(chunk_lines) == 0) break
      
      chunk <- fread(text = c(header,chunk_lines), 
                     header = TRUE,
                     select = c("dbwt"),
                     na.strings = c("", "NA", "NULL"))
      
      
      if (is.null(chunk) || nrow(chunk) == 0) break
      

      sum_w <- sum_w + sum(dnorm(log(chunk$dbwt/1000), mu_w, sd_w), 
                           na.rm = TRUE)
      
      chunk_count <- chunk_count + 1
      if (chunk_count %% 10 == 0) {
        message(paste("... Processed", chunk_count * chunk_size1, "rows..."))
      }
      
    }
    
    close(con)
    rm(chunk)
    message(paste(" Year", yr, "complete.\n"))
  }
  message(paste(" First pass complete.","\n"))
  
  
  #### Second pass ####
  #Expected subsample size
  ns<-10000
  chunk_size2<-15000
  subsample <- list()
  i <- 1
  
  for (yr in years) {
    message(paste("... Starting 2nd pass for Year:", yr))

    if (Sys.info()["sysname"] == "Linux") {
      # Path on ASU SOL Server
      data_dir <- "/home/eagyema3/Poisson_sampling"
    } else {
    # Path on your local Windows machine
    data_dir <- "C:/Users/User/Downloads"
    }
    
    #file_path<- paste0("C:/Users/User/Downloads/natality", yr, "us.csv")
    file_path <- file.path(data_dir, paste0("natality", yr, "us.csv"))
    con <- file(file_path, open = "r")
    
    
    #colnames_list <- names(fread(file_path, nrows = 0))
    header <- readLines(con, n = 1)
    
    #skip <- 1
    chunk_ct<-0
    rows_processed<-1
    report<-25*chunk_size2
    
    repeat {
      chunk_lines <- readLines(con, n = chunk_size2)
      if (length(chunk_lines) == 0) break
      
      # Convert to single string
      #chunk_text <- paste(chunk_lines, collapse = "\n")
      
      # Read ALL columns first (no select yet!)
      #chunk <- tryCatch(
      #  fread(file_path, skip = skip, nrows = chunk_size2, header = FALSE),
      #  error = function(e) NULL
      #)
      chunk <- tryCatch(
        fread(text = c(header,chunk_lines),
              header = TRUE),
        error = function(e) NULL
      )
      
      if (is.null(chunk) || nrow(chunk) == 0) break
      #setnames(chunk, colnames_list)
      
      nm<-names(chunk)
      if ("mar" %in% nm)   chunk$dmar <- chunk$mar  
      if ("mrace" %in% nm) chunk$mrace6 <- chunk$mrace  
      if ("precare_rec" %in% nm) chunk$precare5 <- chunk$precare_rec  
      
      
      
      #chunk<-subset(chunk,select = c(dob_yy,dbwt,mager, sex, dmar, mrace6, meduc, precare5, cig_rec))
      chunk <- chunk[, .(dob_yy, dbwt, mager, sex, dmar, mrace6, meduc, precare5, cig_rec)]
      chunk$dbwt <- log(chunk$dbwt/1000)
      
      
      chunk$w <- dnorm(chunk$dbwt, mu_w, sd_w)
      sum_wt <- sum_wt + sum(chunk$w*chunk$dbwt)
      
      prob <- pmin(1,(chunk$w / sum_w) * ns)
      keep <- runif(nrow(chunk)) <= prob
      
      
      if (any(keep)) {
        subsample[[i]] <- chunk[keep, ]
        i <- i + 1
      }
      
      rows_processed<-rows_processed+nrow(chunk)
      chunk_ct <- chunk_ct + 1
      if (rows_processed>=report) {
        message(paste("... Processed", rows_processed, "rows..."))
        report<-report+ 25*chunk_size2
      }
    }
    
    message(paste(" Year", yr, "complete.\n"))
    close(con)
    rm(chunk)
    
  }
  
})


subsample <- do.call(rbind, subsample)

# --- Save the Final Subsample ---
# Saving as .rds preserves R-specific data types (like factors) and is compressed
saveRDS(subsample, "natality_subsample_2013_2024.rds")

# Optional: Also save as a small CSV if you want to open it in Excel/Python
# fwrite(subsample, "natality_subsample_2013_2024.csv")

message("Subsample saved successfully. You can now download the .rds file to your local machine.")

print(t0["elapsed"])

#print(table(subsample$dob_yy))

print(
ggplot(subsample, aes(x = exp(dbwt))) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 25,
                 fill = "steelblue",
                 color = "white") +
  facet_wrap(~ dob_yy, ncol = 3)+
  xlim(0.5, 5) 
)




