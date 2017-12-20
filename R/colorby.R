
# Define a function to create a vector of colors based on selected kinases
color.by.selected <- function(df,sel,bg.col,sel.col)
{
  # set background color
  color.vector = rep(bg.col,nrow(df))
  
  # recolor selected kinases
  if (length(sel) > 0)
  {
    color.vector[which(df$id.kinrich %in% sel)] = sel.col
  }
  
  # return color vector
  return (color.vector)
}


# Define a function creates color vector from group
color.by.group <- function(df,recolordf,colors,bg.col="#D3D3D3")
{
  # set background color
  color.vector = rep(bg.col,nrow(df))
  
  # kep track of group labels
  group.vector = rep("none",nrow(df))
  
  # get group names
  group.names = names(table(recolordf[,2]))
  
  # Determine the number of groups
  numgroups = length(group.names)
  
  # set palette
  if (numgroups > length(colors))
  {
    colors = colorRampPalette(colors)(numgroups)
  }
  pal = colors[1:numgroups]
  
  groupcolormapping = c()
  for (i in 1:numgroups)
  {
    # get group and color
    group.name  = group.names[i]
    group.color = pal[i]
    
    # record the group/color mapping
    groupcolormapping = c(groupcolormapping,group.color)
    names(groupcolormapping)[length(groupcolormapping)] = group.name
    
    # get kinases from this group
    kinsase.from.this.group = recolordf[which(recolordf[,2]==group.name),1]
    
    # update vector of colors
    color.vector[which(df$id.kinrich %in% kinsase.from.this.group)] = group.color
    group.vector[which(df$id.kinrich %in% kinsase.from.this.group)] = group.name
  }

  return( list(color.vector,group.vector,groupcolormapping))
}


# Define a function creates color vector from values
color.by.value <- function(df ,recolordf ,colors  ,range , bg.col="#D3D3D3")
{
  # set background color
  color.vector = rep(bg.col,nrow(df))
  
  # kep track of group labels
  value.vector = rep("0",nrow(df))
  
  ##### ENDED HERE ######
  
  
  
  
  
  
  
  
  
  
  
}
