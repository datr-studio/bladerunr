blade_runr <- function(grid) {

  # Prepare output directory if user requested one
  if (!is.null(getOption("bladerunr_output_dir"))) {
    prepare_dir(getOption("bladerunr_output_dir"))
  }

  mtcars
}

prepare_dir <- function(output_dir) {
  run_name <- getOption("bladerunr_run_name")
  if (!dir.exists(file.path(output_dir, run_name))) {
    dir.create(file.path(output_dir, run_name))
  } else {
    msg <- crayon::magenta(glue::glue("\n>>> Are you sure you want to overwrite files in \"{run_name}\"? Y/n "))
    confirm <- tolower(input(msg))
    if (confirm == "y" || confirm == "") {
      walk(list.files(file.path(output_dir, run_name), full.names = T), unlink)
    } else {
      stop("Overwrite is necessary to continue. Please save the files or use a different run name.", call. = FALSE)
    }
  }
}