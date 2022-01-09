announce <- function(n, n_tests) {
  prog_n <- crayon::bold(str_with_places(n, n_tests)) %+% "/" %+% crayon::chr(n_tests)
  perc <- str_with_places(round(n / n_tests * 100, 1), 1) %+% "%"
  cat("\n\n")
  cat(crayon::yellow("Test Number: " %+% prog_n %+% " (" %+% perc %+% ")\n"))
  cat("Start Time: " %+% strftime(Sys.time(), "%H:%M:%S"))
}

alert <- function() {
  if (getOption("bladerunr_sound")) beepr::beep(sound = 5)
}