#' Duration Input
#'
#' Creates a set of linked numeric inputs that represent hour, minute and seconds
#'
#' @param inputId Input variable to assign the control's value to.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param value list of initial values.
#' @param width CSS width property
#'
#' @export
durationInput <- function(inputId, label, value = list(hour = 0, min = 0, sec = 0), step = NULL, width="50px") {
  style = ifelse(!is.null(width), paste0("width: ", shiny::validateCssUnit(width), ";"), '')

  shiny::tagList(
    shiny::singleton(
      shiny::tags$head(
        #shiny::tags$script(src = "duration-input-bindings.js")
        #shiny::tags$script(src = system.file('durationinput/duration-input-bindings.js', package='shinyIncubator'))
        shiny::tags$script(src = "")
        #htmltools::htmlDependency("shinyincubator_durationinput",
        #  packageVersion("shinyIncubator"),
        #  system.file("durationinput", package="shinyIncubator"), 
        #  script="duration-input-bindings.js")
        #)
      )
    ),

    shiny::tags$div(
      id = inputId, 
      class = "shiny-input-duration form-group shiny-input-container",
      shiny::tags$label(label, `for` = inputId),
      shiny::tags$br(),
      shiny::tags$input(class = "hour", type = "number", value = value$hour, style = style),
      shiny::tags$input(class = "minute", type = "number", value = value$min, style = style),
      shiny::tags$input(class = "second", type = "number", value = value$sec, style = style, 
        step = if(!is.null(step)) step)
    )
  )
}