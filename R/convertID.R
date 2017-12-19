

# Define a function the converts input identifiers to kinrich IDs
convertID <- function(df,recolordf,inputtype)
{
  if (length(which(recolordf$ids %in% df[,inputtype])) == 0)
  {
    print ("no matches found")
    return(data.frame())
  }
  
  print (paste(length(which(recolordf$ids %in% df[,inputtype])),"matches found"))
  
  # filter input df for those found in table
  recolordf = recolordf[which(recolordf$ids %in% df[,inputtype]),]
  
  # make lookup
  values  = df$ids
  names(values) = df[,inputtype]
  
  # convert 
  recolordfconverted = data.frame(ids = values[as.character(recolordf$ids)], values =recolordf[,2], stringsAsFactors = F)

  return(recolordfconverted)
}
