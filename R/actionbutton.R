#' Action button
#' 
#' Creates an action button whose value is initially zero, and increments by one
#' each time it is pressed.
#' 
#' @param inputId Specifies the input slot that will be used to access the 
#'   value.
#' @param label The contents of the button--usually a text label, but you could
#'   also use any other HTML, like an image.
#'   
#' @export
actionButton <- function(inputId, label) {
  addResourcePath(
    prefix='actionbutton', 
    directoryPath=system.file('actionbutton', 
                              package='shinyIncubator'))
  tagList(
    singleton(tags$head(tags$script(src = 'actionbutton/actionbutton.js'))),
    tags$button(id=inputId, type="button", class="btn action-button", label)
  )
}