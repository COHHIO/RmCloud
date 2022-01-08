choices <- purrr::map(rlang::fn_fmls(RmData::daily_update)[c("steps", "funs")], eval)



to_console <- function(x, mc = match.call(), id = "console") {
  .mc <- paste0(rlang::expr_deparse(mc), collapse = " ")
  x <- rlang::enquo(x)
  debugonce(cli::cli_alert_success)
  withCallingHandlers(rlang::eval_tidy(x),
                      warning = function (w) {
                        .call <- paste0(rlang::expr_deparse(w$call), collapse = " ")
                        .m <- paste0(w$message, collapse = "\n")

                        shinyjs::html(id = id, html = as.character(tags$code(class = 'text-warning', "Warning in ", .call,":", tags$strong(.m), tags$br())), add = TRUE)
                      },
                      error = function (e) {
                        .m <- paste0(e$message, collapse = "\n")
                        shinyjs::html(id = id, html = as.character(tags$code(class = 'text-danger',"Error in ", .mc,":", tags$strong(.m), tags$br())), add = TRUE)
                      },
                      message = function (m) function(m) {
                        .m <- paste0(m$message, collapse = "\n")
                        shinyjs::html(id = id, html = as.character(tags$p(class = 'text-info', .m, tags$br())), add = TRUE)
                      }
  )
}
