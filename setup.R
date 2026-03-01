library(data.table)
library(ggplot2)
setDTthreads(percent=80)
options(scipen = 999)

# ==========================================
# VALIDATION CHECK
# ==========================================

# If the expected folders exist. If not, the user is in the wrong place.
if (!dir.exists("toy_data") && !dir.exists("data")) {
  stop("\n[!] ERROR: Working Directory Incorrect.
       R is looking in: ", getwd(), "
       But it cannot find 'toy_data' or 'data' folders.
       
       FIX: Use setwd() to point to your project folder.")
}

# ==========================================
# PATH CHECK
# ==========================================
# Check for project-specific folders first 
if (dir.exists("data") && length(list.files("data", pattern = "natality")) > 0) {
    data_dir <- "data"
    message("Using FULL dataset from local /data folder...")
    
} else if (dir.exists("toy_data")) {
    data_dir <- "toy_data"
    message("Using TOY dataset from /toy_data folder...")

} else {
    current_os <- Sys.info()["sysname"]
    
    if (current_os == "Linux") {
        # ASU SOL Cluster
        data_dir <- "/home/eagyema3/Poisson_sampling"
        message("Running on SOL Cluster path...")
        
    } else if (current_os == "Darwin") {
        data_dir <- file.path(Sys.getenv("HOME"), "Downloads")
        message("Running on Mac: Using Downloads folder...")
        
    } else if (current_os == "Windows") {
        data_dir <- file.path(Sys.getenv("USERPROFILE"), "Downloads")
        message("Running on Windows: Using Downloads folder...")
        
    } else {
        # Last resort fallback
        data_dir <- "." 
        message("OS not recognized. Using current working directory...")
    }
}
