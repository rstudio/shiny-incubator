#' Duration Input
#'
#' Creates a set of linked numeric inputs that represent hour, minute and seconds
#' Returns duration in seconds.
#'
#' @param inputId Input variable to assign the control's value to.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param value Initial value as number of seconds or a list of values for hour, minute, second
#' @param width CSS width property
#'
#' @export
durationInput <- function(inputId, label, value = list(hour = 0, minute = 0, second = 0), step = NULL, width="50px") {
  if(!is.list(value)) {
    value = list(
      hour = floor(value / 3600),
      minute = floor((value %% 3600) / 60),
      second = (value %% 60) %% 60
    )
  }
  style = ifelse(!is.null(width), paste0("width: ", shiny::validateCssUnit(width), ";"), '')
  
  input = shiny::tags$div(
    id = inputId, 
    class = "shiny-input-duration form-group shiny-input-container",
    shiny::tags$label(label, `for` = inputId),
    shiny::tags$br(),
    shiny::tags$input(class = "hour", type = "number", value = value$hour, style = style),
    shiny::tags$input(class = "minute", type = "number", value = value$minute, style = style),
    shiny::tags$input(class = "second", type = "number", value = value$second, style = style, 
      step = if(!is.null(step)) step)
  )

  depend = htmltools::htmlDependency("shinyincubator_durationinput",
    packageVersion("shinyIncubator"),
    system.file("durationinput", package="shinyIncubator"), 
    script="duration-input-bindings.js"
  )

  shiny::tagList(
    htmltools::attachDependencies(input, depend)
  )
}