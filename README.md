# Geocode Template

## Purpose

This is just a quick minimal R-based template for geocoding with the
`tidygeocoder` package and the `census api`.

## Usage

Until this is tidied up and formalized a little bit more, users can expect
to do the following:

1. Place their input datasets into `data/`
  - if using a codespace - right-click inside of `data/` in the file explorer and select `upload` from the popup.
  - There is no need to hardcode any file paths.  
  The `read` function will read all the files into memory - literally an R `list` called
  `memory`.  Currently the following file types are read:
    - .csv
    - .tsv
    - .xlsx and .xls
    - .parquet
    - and if none of the above it's going to take it's best
    guess and scan for a delimeter
    
2. Users will then source `R/main.R`.

3. Geocoded results will appear in `output/`.
