#' body UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @include mod_body_utils.R
#' @importFrom shiny NS tagList

mod_body_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyjs::useShinyjs(),
    fluidRow(bs4Dash::bs4Card(
      title = "Controls",
      id = "controls",
      fluidRow(
        shinyWidgets::prettyCheckboxGroup(ns("steps"),
                                          "Choose the steps to run:",
                                          choices = choices$steps, width = "50%"),
        shinyWidgets::materialSwitch(ns("run_all"),
                                   label = "Run All",
                                   value = TRUE,
                                   status = "success",
                                   width = "20%",
                                   inline = TRUE)
      ),
      fluidRow(
        shiny::tags$p("Inputs with ", shiny::tags$span(style='color:red', "*"), " are required.", style = "display:inline-block;")),
      shiny::uiOutput(ns("step_options"), width = "100%"),
      fluidRow(
        bs4Dash::appButton(inputId = ns("run"), label = "Run", width = "100%", color = "primary")
      ),
      width = 12
    )),
    fluidRow(tags$h5(class = "text-center", "Console"), tags$hr()),
    fluidRow(
      column(width = 12, style = "overflow: auto; height:600px", class = "border border-info rounded", id = ns("console"))
    )
  )
}


#' body Server Functions
#'
#' @noRd
mod_body_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$export_zip, {
      if (file.exists(input$export_zip$datapath))
        out <- clarity.looker::hud_export_extract(input$export_zip$datapath, dirs$export)
    })




    step_opts <- eventReactive(input$steps, {
      req(input$steps)
      opt_row <- list()
      if ("update" %in% input$steps)
        opt_row$update <- shiny::fileInput(ns("export_zip"), "Zip with Export CSVs", width = "100%", accept = c(".zip", ".7z"))

      if ("funs" %in% input$steps)
        opt_row$funs <- shinyWidgets::pickerInput(
          ns("functions"),
          label = shiny::tags$p("Functions to run", shiny::tags$span(style = "color:red;", "*")),
          choices = choices$funs,
          multiple = TRUE,
          options = shinyWidgets::pickerOptions(
            actionsBox = TRUE,
            liveSearch = TRUE),
          width = "100%",
          inline = TRUE,
          selected = purrr::when(input$run_all, . ~ choices$funs, ~ NULL)
        )

      rlang::exec(shiny::fluidRow, !!!unname(do.call(tagList, purrr::map(opt_row, bs4Dash::column, width = 4))))

    })

    output$step_options <- renderUI(step_opts())
    observe({
      req(input$run_all)
      shinyWidgets::updatePrettyCheckboxGroup(session, inputId = "steps", selected = purrr::when(input$run_all, . ~ choices$steps, ~ NULL))
      shinyWidgets::updatePickerInput(session, inputId = "functions", selected = purrr::when(input$run_all, . ~ choices$funs, ~ NULL), options = shinyWidgets::pickerOptions(showTicks = TRUE))

    }, priority = -1)

    observeEvent(input$run, {
      req(input$run, input$steps, input$functions)
      to_console(RmData::daily_update(session = session, steps = input$steps, funs = input$functions, app_env = Rm_env, clarity_api = cl_api, remote = TRUE), session = session)
    })

  })
}

## To be copied in the UI
# mod_body_ui("body_1")

## To be copied in the server
# mod_body_server("body_1")
