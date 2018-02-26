

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
                "y=\"", trimws(l["text.y"]),"\" ",
                " font-size=\"",l["text.size"],"px\" ",
                "fill=\"",l["text.col"],"\" ",
                "font-family=\"", l["text.font"], "\" ",
                "letter-spacing=","\".035\"",
                
                # # mouse over effects
                # " \nonmouseover=\"evt.target.setAttribute('font-size', '10');\"",
                # " \nonmouseout=\"evt.target.setAttribute('font-size','",origfontsize,"');\"",
                
                ">",l["text.label"],"</text>","</a>",sep = "")
  return(label)
}


# Define a function that makes a node
build.node <- function(l)
{
  if (l["node.col"] == "none")
  {
    return()
  }
  
  circle = paste("<circle id=\"n_x5F_",l["id.kinrich"],"\" ",
                 "cx=\"",l["node.x"],
                 "\" cy=\"",l["node.y"],
                 "\" r=\"",l["node.radius"],
                 # "\" stroke=\"",l["node.strokecol"],
                 "\" stroke=\"","white",
                 "\" stroke-width=\"",l["node.strokewidth"],
                 "\" fill=\"",l["node.col"],"\"/>",sep="")
  return(circle)
}

# Define a function that writes an kinase tree svg file
writekinasetree <- function(svginfo,destination)
{
  outputlines = c()
  
  # add header
  outputlines = c(outputlines,svginfo$header)
  
  # add title
  outputlines = c(outputlines,"<g id=\"TITLE\">")
  outputlines = c(outputlines,paste("<text x=\"425\" y=\"10\" text-anchor=\"middle\" font-family=\"'AvenirNext-Bold'\"  font-size=\"15px\">",svginfo$title,"</text>",sep=""))
  outputlines = c(outputlines,"</g>")
  
  # add legend
  outputlines = c(outputlines,"<g id=\"LEGEND\">")
  outputlines = c(outputlines,svginfo$legend)
  outputlines = c(outputlines,"</g>")
    
  # add branches
  outputlines = c(outputlines,"<g id=\"BRANCHES\">")
  outputlines = c(outputlines,unlist(apply(svginfo$dataframe,1, build.branch)))
  outputlines = c(outputlines,"</g>")
  
  # add circles
  outputlines = c(outputlines,"<g id=\"CIRCLES\">")
  outputlines = c(outputlines,unlist(apply(svginfo$dataframe,1, build.node )))
  outputlines = c(outputlines,"</g>")
  
  # add labels
  outputlines = c(outputlines,"<g id=\"LABELS\">")
  outputlines = c(outputlines,unlist(apply(svginfo$dataframe,1, build.text)))
  outputlines = c(outputlines,"</g>")
  
  # add tail
  outputlines = c(outputlines,"<g id=\"GROUPS\">")
  outputlines = c(outputlines,svginfo$groups)
  outputlines = c(outputlines,"</g>")
  outputlines = c(outputlines,"</svg>")
  
  writeLines(outputlines,destination)
}












