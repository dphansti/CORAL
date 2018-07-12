
# Define a function that writes the group names
build.group.labels <- function(l,font,groupcolor)
{
 
 # change color
 colortag = paste(" fill=\"",groupcolor,"\" font-family",sep="")
 l = gsub(pattern = "font-family",colortag,l)
 
 # use correct font
 grouplabel = gsub(pattern = "'Roboto-Bold'",font,l)
 

 # make bold
 grouplabel = gsub(pattern = "letter-spacing","font-weight=\"700\" letter-spacing",grouplabel)
 
 
 
 
 return(grouplabel)
}

# Define a function that make a branch
build.branch <- function(l)
{
  branch = paste("<path id=\"b_x5F_",l["id.coral"],
                 "\" fill=\"",l["branch.col"],
                 "\" d=\"",l["branch.coords"],"\"/>",sep = "")
  return(branch)
}

# Define a function that make a label
build.text <- function(l,labelselect)
{
 
 # choose label type
 label = ""
 if (labelselect == "Default"){label = l["text.label"]}
 if (labelselect == "coralID"){label = l["id.coral"]}
 if (labelselect == "uniprot"){label = l["id.uniprot"]}
 if (labelselect == "ensembl"){label = l["id.ensembl"]}
 if (labelselect == "entrez"){label = l["id.entrez"]}
 if (labelselect == "HGNC"){label = l["id.HGNC"]}
 
 label = paste("<a xlink:href=\"http://www.uniprot.org/uniprot/",l["id.uniprot"],"\" target=\"_blank\">",
                "<text id=\"t_x5F_",l["id.coral"],"\" ",
                "x=\"",  l["text.x"],"\" ",
                "y=\"", trimws(l["text.y"]),"\" ",
                "font-weight=\"700\" ",
                " font-size=\"",l["text.size"],"px\" ",
                "fill=\"",l["text.col"],"\" ",
                "font-family=\"", l["text.font"], "\" ",
                "letter-spacing=","\".035\"",
                
                # # mouse over effects
                # " \nonmouseover=\"evt.target.setAttribute('font-size', '10');\"",
                # " \nonmouseout=\"evt.target.setAttribute('font-size','",origfontsize,"');\"",
                
                ">",label,"</text>","</a>",sep = "")
  return(label)
}


# Define a function that makes a node
build.node <- function(l)
{
  if (l["node.col"] == "none")
  {
    return()
  }
  
  circle = paste("<circle id=\"n_x5F_",l["id.coral"],"\" ",
                 "cx=\"",l["node.x"],
                 "\" cy=\"",gsub(" ","",l["node.y"]),
                 "\" r=\"",l["node.radius"],
                 "\" opacity=\"",l["node.opacity"],
                 "\" stroke=\"",l["node.strokecol"],
                 "\" stroke-width=\"",l["node.strokewidth"],
                 "\" fill=\"",l["node.col"],"\"/>",sep="")
  return(circle)
}

# Define a function that writes an kinase tree svg file
writekinasetree <- function(svginfo,destination,font,labelselect,groupcolor)
{
  outputlines = c()
  
  # add header
  outputlines = c(outputlines,svginfo$header)
  
  # add title
  outputlines = c(outputlines,"<g id=\"TITLE\">")
  outputlines = c(outputlines,paste("<text x=\"425\" y=\"10\" text-anchor=\"middle\" font-weight=\"700\" font-family=\"",font,"\"  font-size=\"15px\">",svginfo$title,"</text>",sep=""))
  outputlines = c(outputlines,"</g>")
  
  # add legend
  outputlines = c(outputlines,"<g id=\"LEGEND\">")
  outputlines = c(outputlines,svginfo$legend)
  outputlines = c(outputlines,"</g>")
    
  # reorder branches by branch order
  branchorderesDF = svginfo$dataframe[svginfo$dataframe$branchorder,]
  
  # add branches
  outputlines = c(outputlines,"<g id=\"BRANCHES\">")
  outputlines = c(outputlines,unlist(     apply(branchorderesDF,1, build.branch)       ))
  outputlines = c(outputlines,"</g>")
  
  # add circles
  outputlines = c(outputlines,"<g id=\"CIRCLES\">")
  
  # reorder by node order
  nodeorderesDF = svginfo$dataframe[svginfo$dataframe$nodeorder,]
  
  # reorder circles by size
  nodeorderesDF = nodeorderesDF[order(nodeorderesDF$node.radius,decreasing = TRUE),]
  nodeorderesDF = nodeorderesDF[order(nodeorderesDF$node.selected,decreasing = FALSE),]
  
  outputlines = c(outputlines,unlist(apply(nodeorderesDF,1, build.node )))
  outputlines = c(outputlines,"</g>")
  
  # add labels
  outputlines = c(outputlines,"<g id=\"LABELS\">")
  outputlines = c(outputlines,unlist(apply(svginfo$dataframe,1, build.text,labelselect=labelselect)))
  outputlines = c(outputlines,"</g>")
  
  # add tail
  outputlines = c(outputlines,"<g id=\"GROUPS\">")
  outputlines = c(outputlines,unlist(lapply(svginfo$groups, build.group.labels, font=font,groupcolor=groupcolor)))
  outputlines = c(outputlines,"</g>")
  outputlines = c(outputlines,"</svg>")
  
  writeLines(outputlines,destination)
}





