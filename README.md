# Geocode Template


## Purpose

This is just a quick minimal R-based template for geocoding with the
`tidygeocoder` package and the `census api`.

This honestly better as a small package - or better yet - functions
inside of the internal `helpers` package. Alas, time is short.

## Usage

Until this is tidied up and formalized a little bit more, users can expect
to do the following:



1. Place their input datasets into `inputs/` 
  - There is no need to hardcode any file paths.  The `read` function
  will read all the files into memory- literally an R `list` called
  `memory`.  Currently the following file types are read:
    - .csv
    - .tsv
    - .xlsx and .xls
    - .parquet
    - and if none of the above it's going to take it's best
    guess and scan for a delimeter
    
    
2. Users will then head to `R/read-geo.R` and run the section 1 to have
all files read into memory.

3. Users can then go into section 2 and wrangle their code - see the commented
out code for an example.

4. Users can place outputs in `outputs/` 