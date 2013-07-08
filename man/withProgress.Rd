\name{withProgress}
\alias{setProgress}
\alias{withProgress}
\title{Reporting progress (functional API)}
\usage{
  withProgress(session, expr, min = 0, max = 1,
    env = parent.frame(), quoted = FALSE)

  setProgress(message = NULL, detail = NULL, value = NULL)
}
\arguments{
  \item{session}{The Shiny session object, as provided by
  \code{shinyServer} to the server function.}

  \item{expr}{The work to be done. This expression should
  contain calls to \code{setProgress}.}

  \item{min}{The value that represents the starting point
  of the progress bar. Must be less tham \code{max}.}

  \item{max}{The value that represents the end of the
  progress bar.  Must be greater than \code{min}.}

  \item{env}{The environment in which \code{expr} should be
  evaluated.}

  \item{quoted}{Whether \code{expr} is a quoted expression
  (this is not common).}

  \item{message}{A single-element character vector; the
  message to be displayed to the user, or \code{NULL} to
  hide the current message (if any).}

  \item{detail}{A single-element character vector; the
  detail message to be displayed to the user, or
  \code{NULL} to hide the current detail message (if any).
  The detail message will be shown with a de-emphasized
  appearance relative to \code{message}.}

  \item{value}{Single-element numeric vector; the value at
  which to set the progress bar, relative to \code{min} and
  \code{max}.  \code{NULL} hides the progress bar, if it is
  currently visible.}
}
\description{
  Reports progress to the user during long-running
  operations.
}
\details{
  This package exposes two distinct programming APIs for
  working with progress. \code{withProgress} and
  \code{setProgress} together provide a simple
  function-based interface, while the
  \code{\link{Progress}} reference class provides an
  object-oriented API.

  Use \code{withProgress} to wrap the scope of your work;
  doing so will cause a new progress panel to be created,
  and it will be displayed the first time
  \code{setProgress} is called. When \code{withProgress}
  exits, the corresponding progress panel will be removed.

  Generally, \code{withProgress}/\code{setProgress} should
  be sufficient; the exception is if the work to be done is
  asynchronous (this is not common) or otherwise cannot be
  encapsulated by a single scope. In that case, you can use
  the \code{Progress} reference class.
}
\examples{
\dontrun{
# server.R
shinyServer(function(input, output, session) {
  output$plot <- renderPlot({
    withProgress(session, min=1, max=15, {
      setProgress(message = 'Calculation in progress',
                  detail = 'This may take a while...')
      for (i in 1:15) {
        setProgress(value = i)
        Sys.sleep(0.5)
      }
    })
    plot(cars)
  })
})
}
}
\seealso{
  \code{\link{progressInit}}, \code{\link{Progress}}
}

