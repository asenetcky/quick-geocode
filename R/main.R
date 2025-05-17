# geocode the files in `data/`

## attempt to read files
memory <- succor::read_folder(path = fs::path_wd("data"))

# task specific - but lets say for every tibble do...
output <-
  memory |>
  purrr::map(
    \(x) {
      x |>
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
          # right here will need the most TLC depending on data
          full_address = glue::glue("{address}, {city}, {state} {zip}"),
          id = dplyr::row_number()
        )
    }
  )

## geocode with census api
geocoded_output <-
  output |>
  purrr::map(
    \(x) {
      geo <-
        tidygeocoder::geo(
          address = x$full_address,
          method = "census"
        ) |>
        dplyr::select(-address) |> #address var is returned by api
        dplyr::mutate(id = dplyr::row_number()) |>
        dplyr::rename(
          census_lat = lat,
          census_long = long
        )
      x |>
        dplyr::inner_join(geo, by = "id") |>
        dplyr::select(-id)
    }
  )

# write results to `data/`
geocoded_output |>
  purrr::imap(
    \(x, idx) {
      # don't clobber original file
      name <-
        glue::glue("{fs::path_ext_remove(idx)}-geocoded.csv") |>
        stringr::str_replace("data/", "output/")
      readr::write_csv(x, name, na = "")
    }
  )
