
# Define a function that shifts a leged in the x direction
shiftlegend <- function (legend,xshift=0,yshift=0,noderadiusexpansion)
{
 NodeSizeSection = FALSE
 
 newlegend = c()
 for (legendtext in legend)
 {
  if (grepl(">Node Size<",legendtext)==TRUE)
  {
   NodeSizeSection = TRUE
  }
  
  # split legend by space
  legendsplit = unlist(strsplit(x=legendtext,split=" "))
  
  # perform the shift
  for (i in 1:length(legendsplit))
  {
   entry = legendsplit[i]
   
   if (startsWith(entry,"x="))
   {
    origvalue = as.numeric(substr(entry,4,nchar(entry)-1))
    newvalue  = origvalue - xshift
    newentry  = paste("x=\"",newvalue,"\"",sep="")
    legendsplit[i] = newentry
   }
   if (startsWith(entry,"y="))
   {
    origvalue = as.numeric(substr(entry,4,nchar(entry)-1))
    newvalue  = origvalue - yshift
    newentry  = paste("y=\"",newvalue,"\"",sep="")
    legendsplit[i] = newentry
   }
   if (startsWith(entry,"cx="))
   {
    origvalue = as.numeric(substr(entry,5,nchar(entry)-1))
    newvalue  = origvalue - xshift
    newentry  = paste("cx=\"",newvalue,"\"",sep="")
    legendsplit[i] = newentry
   }
   if (startsWith(entry,"cy="))
   {
    origvalue = as.numeric(substr(entry,5,nchar(entry)-1))
    newvalue  = origvalue - yshift
    newentry  = paste("cy=\"",newvalue,"\"",sep="")
    legendsplit[i] = newentry
   }
   
   if (  NodeSizeSection == TRUE)
   {
    # scale the node (for force plots)
    if (startsWith(entry,"r="))
    {
     origvalue = substr(entry,4,nchar(entry)-3)
     newvalue  = as.numeric(origvalue) * noderadiusexpansion
     newentry  = paste("r=\"",newvalue,"\"/>",sep="")
     legendsplit[i] = newentry
    }
    
    # move the cirle down just a little
    if (startsWith(legendsplit[i],"cy="))
    {
     extraspace = (noderadiusexpansion-1) * 16
     origvalue = substr(legendsplit[i],5,nchar(legendsplit[i])-1)
     newvalue  = as.numeric(origvalue) + extraspace
     newentry  = paste("cy=\"",newvalue,"\"",sep="")
     legendsplit[i] = newentry
    }
    
    # increase the height of the grey bar
    if (startsWith(legendsplit[i],"height="))
    {
     extraspace = (noderadiusexpansion-1) * 16
     origvalue = substr(legendsplit[i],9,nchar(legendsplit[i])-3)
     newvalue  = as.numeric(origvalue) + extraspace
     newentry  = paste("height=\"",newvalue,"\"/>",sep="")
     legendsplit[i] = newentry
    }
    
   }

  }
  
  # recombine
  newlegendtext = paste(legendsplit,collapse=" ")
  
  newlegend = c(newlegend,newlegendtext)
 }

 # return shifted legend
 return(newlegend)
}

makejson <- function(df,tmp="www/subdf.txt",output="www/kinome_tree.json",BGcol="#D3D3D3",
                     BGstrolecol="#ffffff",colsubnodes=FALSE,legend="",
                     labelselect,defaultnoderadius,
                     xshift=85,yshift=50,noderadiusexpansion=1)
{
  
 # shift legend to the left
 legend = shiftlegend(legend,xshift=xshift,yshift=yshift,noderadiusexpansion=noderadiusexpansion)
 
 # reorder so so that groups, families, and subfamilies are properly colored
  df<- df[seq(dim(df)[1],1),]
  
  label = ""
  if (labelselect == "Default"){label = "text.label"}
  if (labelselect == "coralID"){label = "id.coral"}
  if (labelselect == "uniprot"){label = "id.uniprot"}
  if (labelselect == "ensembl"){label = "id.ensembl"}
  if (labelselect == "entrez"){label = "id.entrez"}
  if (labelselect == "HGNC"){label = "id.HGNC"}
  
  # filter df
  df = df[,c(label,"kinase.group","kinase.family","kinase.subfamily","branch.col","node.col","node.radius","text.size","node.strokecol","node.opacity")]
  
  # write df to file
  write_tsv(df,tmp,col_names = T)

  # read json file
  data<-read.delim(tmp, stringsAsFactors=F)
  root<-list("name"=list("    "), "nodecol"=list(BGcol),"noderadius"=list(defaultnoderadius), nodestrokecol= BGcol,"children"=list(),"legend"=legend)
  i = 1
  
  # print (legend)
  
  for(i in 1:nrow(data)) {
    
    # grab current row
    row<-data[i, ]
    
    # add white spaces
    group<-row$kinase.group
    family<-paste0(" ", row$kinase.family)
    family<-row$kinase.family
    subfamily<-paste0("  ", row$kinase.subfamily)
    kinase<-paste0("   ", row[label])
    branchcol<-row$branch.col 
    nodecol<-row$node.col 
    noderadius<-row$node.radius
    nodestrokecol<-row$node.strokecol
    subnodestrokecol = row$node.strokecol
    nodeopacity<-row$node.opacity
    textsize<-row$text.size
    subnodecol=nodecol
    if (colsubnodes == FALSE)
    {
     subnodecol = BGcol
     subnodestrokecol = BGstrolecol # only highlight the outer nodes
    }

    # Add Group if not already there
    g<-match(group, unlist(unlist(root$children, F)[names(unlist(root$children, F))=="name"]))
    if(is.na(g)) {
      root$children[[length(root$children)+1]]<-list("name"=list(group),"branchcol"=list(branchcol) ,"nodecol"=list(subnodecol),"noderadius"=list(defaultnoderadius),"nodestrokecol"=list(subnodestrokecol) , "nodeopacity"=list(nodeopacity) ,"textsize"=list(textsize),"children"=list())
      g<-length(root$children)
    }
    
    # Add Group
    f<-match(family, unlist(unlist(root$children[[g]]$children, F)[names(unlist(root$children[[g]]$children, F))=="name"]))
    if(is.na(f)) {
      root$children[[g]]$children[[length(root$children[[g]]$children)+1]]<-list("name"=list(family),"branchcol"=list(branchcol) ,"nodecol"=list(subnodecol),"noderadius"=list(defaultnoderadius),"nodestrokecol"=list(subnodestrokecol) , "nodeopacity"=list(nodeopacity) , "textsize"=list(textsize),"children"=list())
      f<-length(root$children[[g]]$children)
    }
    
    # Determine whether to skip subfamily or not and add kinase
    if(subfamily == "  ") {
      root$children[[g]]$children[[f]]$children[[length(root$children[[g]]$children[[f]]$children)+1]]<-list("name"=list(kinase),"branchcol"=list(branchcol) ,"nodecol"=list(nodecol),"noderadius"=list(noderadius),"nodestrokecol"=list(nodestrokecol), "nodeopacity"=list(nodeopacity),"textsize"=list(textsize) )
    } else {
      sf<-match(subfamily, unlist(unlist(root$children[[g]]$children[[f]]$children, F)[names(unlist(root$children[[g]]$children[[f]]$children, F))=="name"]))
      if(is.na(sf)) {
        root$children[[g]]$children[[f]]$children[[length(root$children[[g]]$children[[f]]$children)+1]]<-list("name"=list(subfamily),"branchcol"=list(branchcol) ,"nodecol"=list(subnodecol),"noderadius"=list(defaultnoderadius), "nodestrokecol"=list(subnodestrokecol) , "nodeopacity"=list(nodeopacity),"textsize"=list(textsize) , "children"=list())
        sf<-length(root$children[[g]]$children[[f]]$children)
      }
      root$children[[g]]$children[[f]]$children[[sf]]$children[[length(root$children[[g]]$children[[f]]$children[[sf]]$children)+1]]<-list("name"=list(kinase),"branchcol"=list(branchcol) ,"nodecol"=list(nodecol),"noderadius"=list(noderadius),"nodestrokecol"=list(nodestrokecol), "nodeopacity"=list(nodeopacity),"textsize"=list(textsize)  )
    }
  }
  
  # write out json file
  write(jsonlite::toJSON(root, pretty = TRUE), file=output)

}