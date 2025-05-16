# section 1 ---------------------------------------------------------------

# this whole thing is a little brittle - but its mostly for quick results
# TODO: make this a bit safer
# TODO: add file extension detection back

memory <-
  succor::read_all_ext(
    path = fs::path_wd("data"),
    ext = "csv" # pick your file type
  )

# section 2 ---------------------------------------------------------------

# task specific
target <- purrr::pluck(memory, 1)

output <-
  target |>
  succor::rename_with_stringr() |>
  dplyr::rename_with(
    .cols = dplyr::everything(),
    .fn = \(x) {
      x |>
        stringr::str_replace_all("\\s|/", "_") |>
        stringr::str_remove_all("\\d")
    }
  ) |>
  dplyr::mutate(
    full_address = glue::glue("{address}, {city}, CT {zip}"),
    id = dplyr::row_number()
  )

geos <-
  tidygeocoder::geo(
    address = output$full_address,
    method = "census"
  ) |>
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
  fs::path_wd("output", "geocoded", ext = "csv"),
  na = ""
)
