

# Define a function that make a branch
build.branch <- function(l)
{
  branch = paste("<path id=\"b_x5F_",l["id.kinrich"],
                 "\" fill=\"",l["branch.col"],
                 "\" d=\"",l["branch.coords"],"\"/>",sep = "")
  return(branch)
}

# Define a function that make a label
build.text <- function(l)
{
  label = paste("<a xlink:href=\"http://www.uniprot.org/uniprot/",l["id.uniprot"],"\">",
                "<text id=\"t_x5F_",l["id.kinrich"],"\" ",
                "x=\"", l["text.x"],"\" ",
                "y=\"", l["text.y"],"\" ",
                " font-size=\"",l["text.size"],"px\" ",
                "fill=\"",l["text.col"],"\" ",
                "font-family=\"", l["text.font"], "\" ",
                
                # # mouse over effects
                # " \nonmouseover=\"evt.target.setAttribute('font-size', '10');\"",
                # " \nonmouseout=\"evt.target.setAttribute('font-size','",origfontsize,"');\"",
                
                ">",l["text.label"],"</text>","</a>",sep = "")
  return(label)
}


# Define a function that makes a node
build.node <- function(l)
{
  circle = paste("<circle id=\"n_x5F_",l["id.kinrich"],"\" ",
                 "cx=\"",l["node.x"],
                 "\" cy=\"",l["node.y"],
                 "\" r=\"",l["node.radius"],
                 "\" stroke=\"",l["node.strokecol"],
                 "\" stroke-width=\"",l["node.strokewidth"],
                 "\" fill=\"",l["node.col"],"\"/>",sep="")
  return(circle)
}

# Define a function that writes an kinase tree svg file
writekinasetree.new <- function(svginfo,destination="../Output/MultiColored.svg",showcircles=FALSE)
{
  outputlines = c()
  
  # add header
  outputlines = c(outputlines,svginfo$header)
  
  # add branches
  outputlines = c(outputlines,"<g id=\"BRANCHES\">")
  outputlines = c(outputlines,unlist(apply(gooddataframe,1, build.branch)))
  outputlines = c(outputlines,"</g>")
  
  # add circles
  outputlines = c(outputlines,"<g id=\"CIRCLES\">")
  outputlines = c(outputlines,unlist(apply(gooddataframe,1, build.node )))
  outputlines = c(outputlines,"</g>")
  
  # add labels
  outputlines = c(outputlines,"<g id=\"LABELS\">")
  outputlines = c(outputlines,unlist(apply(gooddataframe,1, build.text)))
  outputlines = c(outputlines,"</g>")
  
  # add tail
  outputlines = c(outputlines,"<g id=\"GROUPS\">")
  outputlines = c(outputlines,svginfo$groups)
  outputlines = c(outputlines,"</g>")
  outputlines = c(outputlines,"</svg>")
  
  destination = "~/Desktop/svgwithnodes.svg"
  writeLines(outputlines,destination)
}















# --------------------- BELOW CODE IS OLD AND CAN BE DELETED ONCE THE CODE ABOVE IS FUNCTIONAL --------------------- #

# Define a function that make a branch
buildbranch <- function(l)
{
  branch = paste("<path id=\"l_x5F_",l[1],"\" fill=\"",l[2],"\" d=\"",l[3],"\"/>",sep = "")
  return(branch)
}


# Define a function that make a label
buildlabel <- function(l,coltext=FALSE)
{
  if (coltext == FALSE)
  {
    textcolor = "black"
  }
  if (coltext == TRUE)
  {
    textcolor = l[2]
  }
  origfontsize = as.numeric(gsub("px","",l[6]))

  label = paste("<a xlink:href=\"http://www.uniprot.org/uniprot/",l[13],"\">","<text id=\"t_x5F_",l[1],"\" ",l[4]," ",l[5]," font-size=\"",origfontsize,"\" fill=\"",textcolor,"\"", 
                " \nonmouseover=\"evt.target.setAttribute('font-size', '10');\"",
                " \nonmouseout=\"evt.target.setAttribute('font-size','",origfontsize,"');\"",

                ">",l[7],"</text>","</a>",sep = "")
  return(label)
}



# Define a function that make a branch
buildcircle <- function(l)
{
  r = 5
  splitline = unlist(strsplit(l[4],split= " "))
  x = splitline[length(splitline)-1]
  y = gsub(pattern = ")\"",replacement = "",x = splitline[length(splitline)])
  
  circle = paste("<circle cx=\"",x,"\" cy=\"",y,"\" r=\"",l[18],"\" stroke=\"",l[18],"\" stroke-width=\"1\" fill=\"",l[17],"\"/>",sep="")
  
  return(circle)
}

# Define a function that writes an kinase tree svg file
writekinasetree <- function(svginfo,destination="../Output/MultiColored.svg",showcircles=FALSE)
{
  outputlines = c()
  
  # add header
  outputlines = c(outputlines,svginfo$header)
  
  # add branches
  outputlines = c(outputlines,"<g id=\"BRANCHES\">")
  outputlines = c(outputlines,unlist(apply(svginfo$dataframe,1, buildbranch)))
  outputlines = c(outputlines,"</g>")
  
  if (showcircles == TRUE)
  {
    # add circles
    outputlines = c(outputlines,"<g id=\"CIRCLES\">")
    outputlines = c(outputlines,unlist(apply(svginfo$dataframe,1, buildcircle )))
    outputlines = c(outputlines,"</g>")
  }
  
  # add labels
  outputlines = c(outputlines,"<g id=\"LABELS\">")
  outputlines = c(outputlines,unlist(apply(svginfo$dataframe,1, buildlabel,coltext = svginfo$colortext )))
  outputlines = c(outputlines,"</g>")
  
  # add tail
  outputlines = c(outputlines,"<g id=\"GROUPS\">")
  outputlines = c(outputlines,svginfo$groups)
  outputlines = c(outputlines,"</g>")
  outputlines = c(outputlines,"</svg>")
  
  writeLines(outputlines,destination)
}













