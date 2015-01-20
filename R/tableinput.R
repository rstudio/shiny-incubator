#' @import shiny
NULL

#' Matrix input
#' 
#' Creates an adjustable-length matrix input.
#' 
#' @param inputId Input variable to assign the control's value to.
#' @param label Display label for the control.
#' @param data The initial values to use for the matrix.
#' 
#' @export
matrixInput <- function(inputId, label, data) {
  addResourcePath(
    prefix='tableinput', 
    directoryPath=system.file('tableinput', 
                              package='shinyIncubator'))
  
  tagList(
    singleton(
      tags$head(
        tags$link(rel = 'stylesheet',
                  type = 'text/css',
                  href = 'tableinput/tableinput.css'),
        tags$script(src = 'tableinput/tableinput.js')
      )
    ),
    
    tags$div(
      class = 'control-group tableinput-container',
      tags$label(
        class = "control-label",
        label,
        tags$div(
          class = 'tableinput-buttons',
          tags$button(
            type = 'button', class = 'btn btn-mini tableinput-settings hide',
            tags$i(class = 'glyphicon glyphicon-cog icon-cog')
          ),
          HTML('<a href="#" class="tableinput-plusrow"><i class="glyphicon glyphicon-plus-sign icon-plus-sign"></i></a>'),
          HTML('<a href="#" class="tableinput-minusrow"><i class="glyphicon glyphicon-minus-sign icon-minus-sign"></i></a>')
        )
      ),
      tags$table(
        id = inputId,
        class = 'tableinput data table table-bordered table-condensed',
        tags$colgroup(
          lapply(names(data), function(name) {
            tags$col('data-name' = name,
                     'data-field' = name,
                     'data-type' = 'numeric')
          })
        ),
        tags$thead(
          class = 'hide',
          tags$tr(
            lapply(names(data), function(name) {
              tags$th(name)
            })
          )
        ),
        tags$tbody(
          lapply(1:nrow(data), function(i) {
            tags$tr(
              lapply(names(data), function(name) {
                tags$td(
                  div(tabindex=0, as.character(data[i,name]))
                )
              })
            )
          })
        )
      ),
      tags$div(
        class = 'tableinput-editor modal hide fade',
        tags$div(
          class = 'modal-header',
          HTML('<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>'),
          tags$h3(label)
        ),
        tags$div(
          class = 'modal-body',
          
          HTML('
<form class="form-horizontal">
  <div class="control-group">
    <label class="control-label">Rows</label>
    <div class="controls">
      <input type="number" class="tableinput-rowcount">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Columns</label>
    <div class="controls">
      <input type="number" class="tableinput-colcount">
    </div>
  </div>
</form>'
          )
        ),
        tags$div(
          class = 'modal-footer',
          tags$a(href = '#', class = 'btn btn-primary tableinput-edit', 'OK'),
          tags$a(href = '#',
                 class = 'btn',
                 'data-dismiss' = 'modal',
                 'aria-hidden' = 'true',
                 'Cancel')
        )
      )
    )
  )
}
