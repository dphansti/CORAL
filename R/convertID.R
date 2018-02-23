

# Define a function the converts input identifiers to kinrich IDs
convertID <- function(df,recolordf,inputtype)
{
  if (inputtype == "KinrichID")
  {
    inputtype = "id.kinrich"
  }
  if (inputtype != "id.kinrich")
  {
    inputtype = paste("id.",inputtype,sep="")
  }
  
  if (length(which(recolordf[,1] %in% df[,inputtype])) == 0)
  {
    print ("no matches found")
    return(data.frame())
  }
  
  print (paste(length(which(recolordf[,1] %in% df[,inputtype])),"matches found"))
  
  # filter input df for those found in table
  recolordf = recolordf[which(recolordf[,1] %in% df[,inputtype]),]

  # make lookup
  values  = df[,1]
  names(values) = df[,inputtype]
  
  # convert 
  recolordfconverted = data.frame(ids = values[as.character(recolordf[,1])], values =recolordf[,2], stringsAsFactors = F)

  return(recolordfconverted)
}
