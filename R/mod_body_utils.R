choices <- purrr::map(rlang::fn_fmls(RmData::daily_update)[c("steps", "funs")], eval)

futile.logger::flog.appender(futile.logger::appender.console())

to_console <- function(x, mc = match.call(), id = "console", session) {
  .mc <- paste0(rlang::expr_deparse(mc), collapse = " ")
  x <- rlang::enquo(x)
  debugonce(cli::cli_alert_success)
  tryCatchLog::tryCatchLog(rlang::eval_tidy(x),
                           write.error.dump.file = FALSE,,
                           silent.warnings = FALSE,
                           silent.messages = FALSE,
                           include.compact.call.stack = TRUE,,
                           logged.conditions = NA,
                      warning = function (w) {
                        .call <- paste0(rlang::expr_deparse(w$call), collapse = " ")
                        .m <- paste0(w$message, collapse = "\n")

                        shinyjs::html(id = id, html = as.character(tags$code(class = 'text-warning', "Warning in ", .call,":", tags$strong(.m), tags$br())), add = TRUE)
                      },
                      error = function (e) {
                        .m <- paste0(e$message, collapse = "\n")
                        shinyjs::html(id = id, html = as.character(tags$code(class = 'text-danger',"Error in ", .mc,":", tags$strong(.m), tags$br())), add = TRUE)
                        shiny::showNotification("Reloading app. You can resume where from where the error occured.", type = "error")
                        session$reload()
                      },
                      message = function (m) function(m) {
                        browser()
                        .m <- paste0(m$message, collapse = "\n")
                        shinyjs::html(id = id, html = as.character(tags$p(class = 'text-info', .m, tags$br())), add = TRUE)
                      },
           finally = {

           }
  )
}
