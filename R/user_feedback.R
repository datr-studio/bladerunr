announce <- function(n, n_tests, av_duration, start) {
  prog_n <- crayon::bold(str_with_places(n, n_tests)) %+% "/" %+% crayon::chr(n_tests)
  perc <- str_with_places(round(n / n_tests * 100, 1), 1) %+% "%"
  cat("\n\n")
  cat(crayon::yellow("Test Number: " %+% prog_n %+% " (" %+% perc %+% ")\n"))
  cat("Test Start Time: " %+% strftime(Sys.time(), "%H:%M:%S") %+% "\n")
  cat("Average Duration: " %+% readable_duration(av_duration) %+% "\n")
  remaining <- n_tests - n
  now <- Sys.time()
  total_elapsed <- as.numeric(now - start, units = "secs")
  est_finish <- now + (remaining * av_duration)
  est_finish_str <- ifelse(is.na(est_finish), crayon::blurred("calculating..."), strftime(est_finish, "%H:%M"))

  cat("Total Time Elapsed: " %+% readable_duration(total_elapsed) %+% "\n")
  cat("Expected Completion: " %+% est_finish_str %+% "\n")
}

alert <- function() {
  if (getOption("bladerunr_sound")) beepr::beep(sound = 5)
}

skip_msg <- function(n) {
  cat(crayon::red("Test run #" %+% as.character(n) %+% " has reached the attempt threshold and will be skipped."))
}

final_run_msg <- function(skipped_tests) {
  cat(crayon::yellow$bold("\n\nAll tests complete.\n"))
  if (skipped_tests > 0) {
    cat(crayon::blurred("Note: " %+% as.character(skipped_tests) %+% " failed and were skipped."))
  }
}

readable_duration <- function(dur) {
  if (is.na(dur) | round(dur) == 0) {
    crayon::blurred("calculating...")
  } else if (dur <= 90) {
    paste(round(dur), "seconds")
  } else if (dur < 60 * 60) {
    paste(round(dur / 60, 1), "minutes")
  } else {
    paste(round(dur / 3600, 1), "hours")
  }
}