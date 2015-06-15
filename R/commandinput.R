#' Command input
#'
#' Creates a text box that only sends its value when the user hits Enter.
#'
#' @param inputId Input variable to assign the control's value to.
#' @param label Display label for the control, or \code{NULL} for no label.
#' @param value Initial value.
#' @param ... Additional attributes to be included on the \code{<input>} tag.
#' @param autoclear If \code{TRUE}, the contents of the text box are cleared
#'   after the value is sent.
#'
#' @export
commandInput <- function(inputId, label, value, ..., autoclear = TRUE) {
  htmltools::attachDependencies(
    div(class = "form-group shiny-input-container",
      if (!is.null(label)) tags$label(label, `for` = inputId),
      tags$input(id=inputId, type="text", class="command-text form-control",
        `data-autoclear` = autoclear, value = value,
        ...)
    ),
    htmltools::htmlDependency("shinyincubator_commandinput",
      packageVersion("shinyIncubator"),
      system.file("commandinput", package="shinyIncubator"),
      script="commandinput.js")
  )
}
