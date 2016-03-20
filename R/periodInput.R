#' Period Input
#'
#' Creates a set of linked numeric inputs that represent hour, minute and seconds.
#' Returns a list of hour, minute, and seconds
#'
#' @param inputId Input variable to assign the control's value to.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param value list of initial values.
#' @param width CSS width property
#'
#' @export
periodInput <- function(inputId, label, value = list(hour = 0, minute = 0, second = 0), step = NULL, width="50px") {
  style = ifelse(!is.null(width), paste0("width: ", shiny::validateCssUnit(width), ";"), '')
  
  input = shiny::tags$div(
    id = inputId, 
    class = "shiny-input-period form-group shiny-input-container",
    shiny::tags$label(label, `for` = inputId),
    shiny::tags$br(),
    shiny::tags$input(class = "hour", type = "number", value = value$hour, style = style),
    shiny::tags$input(class = "minute", type = "number", value = value$minute, style = style),
    shiny::tags$input(class = "second", type = "number", value = value$second, style = style, 
      step = if(!is.null(step)) step)
  )

  depend = htmltools::htmlDependency("shinyincubator_durationinput",
    packageVersion("shinyIncubator"),
    system.file("periodinput", package="shinyIncubator"), 
    script="period-input-bindings.js"
  )

  shiny::tagList(
    htmltools::attachDependencies(input, depend)
  )
}