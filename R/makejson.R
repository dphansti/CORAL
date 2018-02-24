makejson <- function(df,tmp="www/subdf.txt",output="www/kinome_tree.json")
{
  # reorder so so that groups, families, and subfamilies are properly colored
  df<- df[seq(dim(df)[1],1),]
  
  # filter df
  df = df[,c("id.kinrich","kinase.group","kinase.family","kinase.subfamily","branch.col","node.col","node.radius","text.size")]
  
  # write df to file
  write_tsv(df,tmp,col_names = T)

  # read json file
  data<-read.delim(tmp, stringsAsFactors=F)
  root<-list("name"=list("    "), "nodecol"=list("#D3D3De"),"noderadius"=list(6) ,"children"=list())
  i = 1
  
  for(i in 1:nrow(data)) {
    
    # grab current row
    row<-data[i, ]
    
    # add white spaces
    group<-row$kinase.group
    family<-paste0(" ", row$kinase.family)
    family<-row$kinase.family
    subfamily<-paste0("  ", row$kinase.subfamily)
    kinase<-paste0("   ", row$id.kinrich)
    branchcol<-row$branch.col 
    nodecol<-row$node.col 
    noderadius<-row$node.radius 
    textsize<-row$text.size

    # Add Group if not already there
    g<-match(group, unlist(unlist(root$children, F)[names(unlist(root$children, F))=="name"]))
    if(is.na(g)) {
      root$children[[length(root$children)+1]]<-list("name"=list(group),"branchcol"=list(branchcol) ,"nodecol"=list(nodecol),"noderadius"=list(noderadius) ,"textsize"=list(textsize),"children"=list())
      g<-length(root$children)
    }
    
    # Add Group
    f<-match(family, unlist(unlist(root$children[[g]]$children, F)[names(unlist(root$children[[g]]$children, F))=="name"]))
    if(is.na(f)) {
      root$children[[g]]$children[[length(root$children[[g]]$children)+1]]<-list("name"=list(family),"branchcol"=list(branchcol) ,"nodecol"=list(nodecol),"noderadius"=list(noderadius)  , "textsize"=list(textsize),"children"=list())
      f<-length(root$children[[g]]$children)
    }
    
    # Determine whether to skip subfamily or not and add kinase
    if(subfamily == "  ") {
      root$children[[g]]$children[[f]]$children[[length(root$children[[g]]$children[[f]]$children)+1]]<-list("name"=list(kinase),"branchcol"=list(branchcol) ,"nodecol"=list(nodecol),"noderadius"=list(noderadius),"textsize"=list(textsize) )
    } else {
      sf<-match(subfamily, unlist(unlist(root$children[[g]]$children[[f]]$children, F)[names(unlist(root$children[[g]]$children[[f]]$children, F))=="name"]))
      if(is.na(sf)) {
        root$children[[g]]$children[[f]]$children[[length(root$children[[g]]$children[[f]]$children)+1]]<-list("name"=list(subfamily),"branchcol"=list(branchcol) ,"nodecol"=list(nodecol),"noderadius"=list(noderadius) ,"textsize"=list(textsize) , "children"=list())
        sf<-length(root$children[[g]]$children[[f]]$children)
      }
      root$children[[g]]$children[[f]]$children[[sf]]$children[[length(root$children[[g]]$children[[f]]$children[[sf]]$children)+1]]<-list("name"=list(kinase),"branchcol"=list(branchcol) ,"nodecol"=list(nodecol),"noderadius"=list(noderadius),"textsize"=list(textsize)  )
    }
  }
  
  # write out json file
  write(jsonlite::toJSON(root, pretty = TRUE), file=output)
}