#' Filter loci or specimens in a genlight \{adegenet\} object based on call rate
#'
#' SNP datasets generated by DArT have missing values primarily arising from failure to call a SNP because of a mutation
#' at one or both of the the restriction enzyme recognition sites. This script filters out loci (or specimens) for which the call rate is
#' lower than a specified value. The script will also filter out loci (or specimens) in SilicoDArT (presence/absence) datasets where the call rate
#' is lower than the specified value. In this case, the data are missing owing to low coverage.
#'
#' @param  x name of the genlight object containing the SNP data, or the genind object containing the SilocoDArT data [required]
#' @param method -- "loc" to specify that loci are to be filtered, "ind" to specify that specimens are to be filtered [default "loc"]
#' @param threshold -- threshold value below which loci will be removed [default 0.95]
#' @param recalc -- Recalculate the locus metadata statistics if any individuals are deleted in the filtering [default TRUE]
#' @param v -- verbosity: 0, silent or fatal errors; 1, begin and end; 2, progress log ; 3, progress and results summary; 5, full report [default 2]
#' @return The reduced genlight or genind object, plus a summary
#' @export
#' @author Arthur Georges (glbugs@aerg.canberra.edu.au)
#' @examples
#' result <- gl.filter.callrate(testset.gl, method="ind", t=0.8)

# Last edit:25-Apr-18

 gl.filter.callrate <- function(x, method="loc", threshold=0.95, recalc=TRUE, v=2) {
   
  if(class(x) == "genlight") {
    if (v > 2) {cat("Reporting for a genlight object\n")}
   } else if (class(x) == "genind") {
     if (v > 2) {cat("Reporting for a genind object\n")}
   } else {
     cat("Fatal Error: Specify either a genlight or a genind object\n")
     stop()
   }
   
   if ( v > 0) {cat("Starting gl.filter.callrate: Filtering on Call Rate\n")}
   if (v > 2) {cat("Note: Missing values most commonly arise from restriction site mutation\n")}

  if (method != "ind" & method != "loc") {
    method <- "loc"
    if (v > 2) {cat("Method set to loc\n")}
  }
   
  if( method == "loc" ) {
    # Determine starting number of loci and individuals
    if (v > 1) {cat("  Removing loci based on Call Rate, threshold =",threshold,"\n")}
    n0 <- nLoc(x)
    if (v > 2) {cat("Initial no. of loci =", n0, "\n")}

    if(class(x)=="genlight") {
    # Remove loci with NA count <= 1-t
      x2 <- x[ ,glNA(x,alleleAsUnit=FALSE)<=((1-threshold)*nInd(x))]
      x2@other$loc.metrics <- x@other$loc.metrics[glNA(x,alleleAsUnit=FALSE)<=((1-threshold)*nInd(x)),]
      if (v > 2) {cat ("  No. of loci deleted =", (n0-nLoc(x2)),"\n")}

    } else if (class(x)=="genind") {
      x2 <- x[,(colSums(is.na(tab((x))))/nInd(x))<=(1-threshold)]
      idx <- which((colSums(is.na(tab((x))))/nInd(x))<=(1-threshold))
      x2@other$loc.metrics <- x@other$loc.metrics[c(idx),]
      if (v > 2) {cat ("  No. of loci deleted =", (n0-nLoc(x2)),"\n")}
    } else {
      cat("Fatal Error: genlight or genind objects required for call rate filtering!\n"); stop()
    }

  } else if ( method == "ind" ) {
    # Determine starting number of loci and individuals
    if (v > 1) {cat("  Removing individuals based on Call Rate, threshold t =",threshold,"\n")}
      n0 <- nInd(x)
      if (v > 2) {cat("Initial no. of individuals =", n0, "\n")}
    # Calculate the individual call rate
      ind.call.rate <- 1 - rowSums(is.na(as.matrix(x)))/nLoc(x)
    # Check that there are some individuals left
      if (sum(ind.call.rate >= threshold) == 0) stop(paste("Maximum individual call rate =",max(ind.call.rate),". Nominated threshold of",t,"too stringent.\n No individuals remain.\n"))
    # Extract those individuals with a call rate greater or equal to the threshold
      x2 <- x[ind.call.rate >= threshold,]
    # for some reason that eludes me, this also (appropriately) filters the latlons and the covariates, but see above for locus filtering
      if( class(x) == "genlight") {
        if (v > 2) {cat ("Filtering a genlight object\n  no. of individuals deleted =", (n0-nInd(x2)), "\nIndividuals retained =", nInd(x2),"\n")}
      }
      if( class(x) == "genind") {
        if (v > 2) {cat ("Filtering a genind object\n  No. of individuals deleted =", (n0-nInd(x2)), "\n  Individuals retained =", nInd(x2),"\n")}
      }
    # Report individuals that are excluded on call rate
      if (any(ind.call.rate <= threshold)) {
        x3 <- x[ind.call.rate <= threshold,]
        if (length(x3) > 0) {
          if (v > 1) {
            cat("  List of individuals deleted because of low call rate:",indNames(x3))
            cat(" from populations:",as.character(pop(x3)),"\n")
          }  
            # Remove monomorphic loci
              x2 <- gl.filter.monomorphs(x2,v=v)
              if (recalc) { x2 <- gl.recalc.metrics(x2, v=v)}
        }
      }  
   }
   # REPORT A SUMMARY
   if (v > 2) {
     cat("Summary of filtered dataset\n")
     cat(paste("  Call Rate >",threshold,"\n"))
     cat(paste("  No. of loci:",nLoc(x2),"\n"))
     cat(paste("  No. of individuals:", nInd(x2),"\n"))
     cat(paste("  No. of populations: ", length(levels(factor(pop(x2)))),"\n"))
   }
   
   if ( v > 0) {cat("gl.filter.callrate completed\n")}

    return(x2)
}