# section 1 ---------------------------------------------------------------

# generic read em all
inputs <- fs::dir_ls(
  fs::path_wd("inputs")
)

read <- function(path, ext) {
  if (ext %in% c("xlsx", "xls")) {
    readxl::read_excel(path)
  } else if (ext == "csv") {
    readr::read_csv(path)
  } else if (ext == "tsv") {
    readr::read_tsv(path)
  } else if (ext == "parquet") {
    nanoparquet::read_parquet(path)
  } else {
    readr::read_delim(path)
  }
}

memory <-
  purrr::map2(
    .x = inputs,
    .y = fs::path_ext(inputs),
    \(x, y) read(x, y)
  )


# section 2 ---------------------------------------------------------------

# task specific
target <- purrr::pluck(memory, 1)

output <-
  target |>
  dplyr::rename_with(
    .cols = dplyr::everything(),
    .fn = \(x) {
      x |>
        stringr::str_squish() |>
        stringr::str_to_lower() |>
        stringr::str_replace_all("\\s|/", "_") |>
        stringr::str_remove_all("\\d")
    }
  ) |>
  dplyr::mutate(
    full_address = glue::glue("{address}, {city}, CT {zip}"),
    id = dplyr::row_number()
  )

geos <-
  tidygeocoder::geo(address = output$full_address, method = "census") |>
  dplyr::select(-address) |>
  dplyr::mutate(id = dplyr::row_number()) |>
  dplyr::rename(
    census_lat = lat,
    census_long = long
  )

output <-
  output |>
  dplyr::inner_join(geos, by = c("id")) |>
  dplyr::select(-id)

readr::write_csv(
  output,
  fs::path_wd("outputs", "geocoded", ext = "csv"),
  na = ""
)
