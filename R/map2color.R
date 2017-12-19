
# Define a function that maps numbers to colors
map2color <- function(x=NULL,pal=colorRampPalette(c("deepskyblue2","black","gold"))(100),limits=NULL)
{
  
  # set the limits to the min and max
  if(is.null(limits)) 
  {
    # get just the finite values
    finitevalues = x[which(is.finite(x)==TRUE)]
    
    # set the limits
    limits = range(x)
  }
  
  # get the new colors
  newcolors = pal[findInterval(x,seq(limits[1],limits[2],length.out=length(pal)+1), all.inside=TRUE)]
  
  # return the new colors
  return(newcolors)
}
