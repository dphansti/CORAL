

# Define a function the converts input identifiers to coral IDs
convertID <- function(df,recolordf,inputtype)
{
  if (inputtype == "coralID")
  {
    inputtype = "id.coral"
  }
  if (inputtype != "id.coral")
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

  # Make a new recolordf accounting for the fact that one other ID could correspond
  # to multilpe coral IDs
  newids = c()
  newvalues = c()
  for (i in 1:nrow(recolordf))
  {
   otherid  = recolordf[i,1]
   quantval = recolordf[i,2]
   coralids = as.character(df[which(as.character(df[,inputtype]) == otherid),1])
   for (coralid in coralids)
   {
    newids = c(newids,coralid)
    newvalues = c(newvalues,quantval)
   }
  }
  recolordfconverted = data.frame(ids=newids,values=newvalues,stringsAsFactors = F)
  
  return(recolordfconverted)
}
