#' Import DarT data into R and conver it to a genlight object
#' 
#' This function is a wrapper function that allows you to convert you dart file into a genlight object in one step. In previous versions you had to use read.dart and then dart2genlight. In case you have individual metadata for each individual/sample you can specify as before in the dart2genlight command the file that combines the data.
#'
#' @param filename path to file (csv file only currently)
#' @param ind.metafile the name of the file that has entails additional information on individuals. For the required format check
#' @param covfilename depreciated, use ind.metafile parameter 
#' @param nas a character specifying NAs (default is "-")
#' @param topskip a number specifying the number of rows to be skipped. If not provided the number of rows to be skipped are "guessed" by the number of rows with "*" at the beginning.
#' @param lastmetric specifies the last non genetic column (Default is "RepAvg"). Be sure to check if that is true, otherwise the number of individuals will not match. You can also specify the last column by a number.
#' @param probar show progress bar
#' @return a dart genlight object that contains individuals [if data were provided] and loci meta data [from a DArT report]. The dart genlight object can then be fed into a number of initial screening, export and export functions provided by the package. For some of the function it is necessary to have the metadata that was provided from DArT. Please check the vignette for more information. Additional information can also be found in the help documents for  \code{\link{read.dart}} and \code{\link{dart2genlight}}. 
#' @export
#' @examples{
#' dartfile <- system.file("extdata","testset_SNPs_2Row.csv", package="dartR")
#' covfilename <- system.file("extdata","testset_metadata.csv", package="dartR")
#' gl <- gl.read.dart(dartfile, ind.metafile = covfilename, probar=TRUE)
#' }

gl.read.dart <- function(filename, ind.metafile=NULL, covfilename=NULL, nas = "-", topskip=NULL,  lastmetric ="RepAvg", probar=TRUE)
{
  if (is.null(ind.metafile)) {
    ind.metafile <- covfilename
  }
  dout <-read.dart(filename = filename, nas=nas, topskip=topskip, lastmetric = lastmetric)
  glout <- dart2genlight(dout, ind.metafile = ind.metafile, probar = probar)
return(glout)
}
