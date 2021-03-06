% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gl.make.recode.pop.r
\name{gl.make.recode.pop}
\alias{gl.make.recode.pop}
\title{Create a proforma recode_pop_table file for reassigning population names}
\usage{
gl.make.recode.pop(x, outfile = "recode_pop_table.csv", outpath = tempdir())
}
\arguments{
\item{x}{-- name of the genlight object containing the SNP data [required]}

\item{outfile}{-- name of the new proforma file [default recode_pop_table.csv]}

\item{outpath}{-- path where to save the output file (set to tempdir by default)}
}
\value{
A vector containing the new population names
}
\description{
Renaming populations may be required when there have been errors in assignment arising
in the process from sample to DArT files or when one wishes to amalgamate populations, or delete populations.
Recoding populations can also be done with a recode table (csv).
}
\details{
This script facilitates 
the construction of a recode table by producing a proforma file with
current population names in two identical columns. Edit the second
column to reassign populations. Use keyword Delete to delete a population.

Apply the recoding using gl.recode.pop().
}
\examples{
\donttest{
result <- gl.make.recode.pop(testset.gl, outfile="Emmac_recode_pop.csv")
}
}
\author{
Arthur Georges (glbugs@aerg.canberra.edu.au)
}
