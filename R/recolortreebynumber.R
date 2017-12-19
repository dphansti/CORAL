
# Define a function that recolors the tree
recolortreebynumber <- function(treedf, recolordf,pal,heatrange = NULL,objecttorecolor="branch")
{
  
  # reassing to new variable for absolutely no reason
  newtreedf = treedf
  
  # make sure colors are  not factors
  newtreedf$col_line = as.character(newtreedf$col_line)
  
  # remove missing values
  recolordf = recolordf[which(recolordf$ids %in% newtreedf$ids),]
  
  if (nrow(recolordf) == 0)
  {
    return (newtreedf)
  }
  
  # update values in tree
  newtreedf[match(recolordf$ids, newtreedf$ids),]$values <- recolordf$values
  
  # sort based on absolute values
  newtreedf = newtreedf[order(abs(newtreedf$values),decreasing = FALSE),]
  
  # recolor based on values
  if (objecttorecolor == "branch")
  {
    newtreedf$col_line = map2color(newtreedf$values,pal = pal, limits = heatrange)
  }
  # recolor based on values
  if (objecttorecolor == "node")
  {
    newtreedf$nodecol = map2color(newtreedf$values,pal = pal, limits = heatrange)
  }
  
  # return recolored tree
  return (newtreedf)
}