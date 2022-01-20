choices <- purrr::map(rlang::fn_fmls(RmData::daily_update)[c("steps", "funs")], eval)
info_to_shiny_console <- function ()
{
  function(line) {
    .class <- switch(stringr::str_extract(line, "^\\w+"),
                     TRACE = ,
                     DEBUG = 'text-primary',
                     INFO = 'text-info',
                     WARN = 'text-warning',
                     FATAL = ,
                     ERROR = 'text-danger')
    if (stringr::str_detect(stringr::str_remove(line, "[^A-Za-z]+"), "[A-Za-z]+"))
      shinyjs::html(id = "console", html = as.character(tags$code(class = .class, tags$strong(line), tags$br())), add = TRUE)
    cat(line, sep = "")
  }
}

futile.logger::flog.appender(info_to_shiny_console())
futile.logger::flog.threshold(futile.logger::INFO)
to_console <- function(x, mc = match.call(), id = "console", session) {
  x <- rlang::enquo(x)

  tryCatchLog::tryCatchLog(rlang::eval_tidy(x),
                           write.error.dump.file = FALSE,
                           silent.warnings = FALSE,
                           silent.messages = TRUE,
                           include.compact.call.stack = FALSE,
                           include.full.call.stack = FALSE,
                           logged.conditions = NA,
                      error = function (e) {
                        .m <- paste0(e$message, collapse = "\n")
                        .fn <- glue::glue("ERROR_{Sys.time()}.feather")
                        UU::object_write(tryCatchLog::last.tryCatchLog.result(), .fn)
                        shiny::showNotification(paste0("Error: ", .m, " logged to ", .fn))
                        shiny::showNotification("Reloading app. You can resume where from where the error occured.", type = "error")
                        session$reload()
                      },
                      finally = {
                        #reserved
                      }
  )
}
