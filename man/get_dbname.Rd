% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{get_dbname}
\alias{get_dbname}
\title{Get the \code{dbname} from a connection call}
\usage{
get_dbname(dots, drv = NULL)
}
\arguments{
\item{dots}{from the argument being passed to the connection}

\item{drv}{from the argument being passed to the connection}
}
\value{
the name, sanitized if needed
}
\description{
Get the \code{dbname} from a connection call
}
\keyword{internal}
