#' @importFrom rlang %|%
#' @export
rlang::`%|%`
#' @importFrom rlang %||%
#' @export
rlang::`%||%`

#' @importFrom clarity.looker dirs
#' @export
clarity.looker::dirs

if (interactive() && clarity.looker::is_dev())
  devtools::load_all("../RmData")
if (!RmData::is_app_env(RmData::get_app_env(ifnotfound = cli::cli_inform("app_env not found, instantiating"), e = .GlobalEnv)))
  .GlobalEnv$Rm_env <- RmData::app_env$new()
if (!RmData::is_clarity_api(RmData::get_clarity_api(ifnotfound = cli::cli_inform("clarity_api not found, instantiating"), e = .GlobalEnv)))
  .GlobalEnv$cl_api <- clarity.looker::clarity_api$new(file.path("inst","auth","Looker.ini"), dirs = clarity.looker::dirs)
