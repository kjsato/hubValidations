#' Check hub correctly configured
#'
#' Checks that `admin` and `tasks` configuration files in directory `hub-config`
#' are valid.
#' @inherit check_valid_round_id return params
#'
#' @export
check_config_hub_valid <- function(hub_path, branch, schema_repo) {
  valid_config <- hubAdmin::validate_hub_config(hub_path, branch = branch, schema_repo = schema_repo) %>%
    suppressMessages() %>%
    suppressWarnings()

  check <- all(unlist(valid_config))

  if (check) {
    details <- NULL
  } else {
    details <- cli::format_inline(
      "Config file{?s} {.val {names(valid_config)[!unlist(valid_config)]}} invalid."
    )
  }

  capture_check_cnd(
    check = check,
    file_path = basename(fs::path_abs(hub_path)),
    msg_subject = "All hub config files",
    msg_attribute = "valid.",
    msg_verbs = c("are", "must be"),
    error = TRUE,
    details = details
  )
}
