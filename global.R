# load basic libraries
require(shiny)
require(shinydashboard)

# load Manning-related libraries
require(rhandsontable)
require(svgPanZoom)

# load ui-related libraries
require(rhandsontable)
require(colourpicker)
require(DT)
# require(shinyIncubator)

# load other network libraries
#devtools::install_github("timelyportfolio/radialNetworkR")
require(dplyr)
require(tidyverse)
require(data.tree)
require(radialNetworkR)
require(networkD3)
require(igraph)


# Point to R functions
source("R/recolortreebynumber.R")
source("R/map2color.R")
source("R/writekinasetree.R")
source("R/convertID.R")
source("R/radialNetwork_KinomeTree.R")
# source("R/forceNetwork_KinomeTree.R")

# read RDS
orig_svginfo = readRDS("Data/KinaseTree_Master.RDS")
rownames(orig_svginfo$dataframe) = orig_svginfo$dataframe$ids

# add values column
orig_svginfo$dataframe$values  = 0

# color by group
length(table(orig_svginfo$dataframe$group))
colpalette = colorRampPalette( c("forestgreen","violet","dodgerblue2","deepskyblue2","lightgrey","gold","orange","firebrick2"))(12)
col_conversion = 1:11
names(col_conversion) = names(table(orig_svginfo$dataframe$group))
orig_svginfo$dataframe$col_line = colpalette[col_conversion[orig_svginfo$dataframe$group]]

# make svginfo (leaving the original intact)
svginfo = orig_svginfo

# add colummns for nodes
svginfo$dataframe$nodecol = "lightgrey"
svginfo$dataframe$noderad = 5

# fix header
svginfo$header =  "<svg xmlns=\"http://www.w3.org/2000/svg\"
xmlns:xlink=\"http://www.w3.org/1999/xlink\" >"

# Used for Default values
CDKs = grep(pattern = "CDK",svginfo$dataframe$ids)
CaMs = grep(pattern = "CaM",svginfo$dataframe$ids)




# make a well formatted svg data frame
a = orig_svginfo$dataframe

xs = c()
ys = c()
for (i in 1:nrow(a))
{
  splitline = unlist(strsplit(as.character(a[i,4]),split=" "))
  x = splitline[length(splitline)-1]
  y = gsub(pattern = ")\"",replacement = "",x = splitline[length(splitline)])
  xs = c(xs,x)
  ys = c(ys,y)
}

gooddataframe = data.frame(

  # identifiers
  id.kinrich  = a$ids,
  id.uniprot  = a$uniprot,
  id.ensembl  = a$ensembl,
  id.entrez   = a$entrez,
  id.HGNC     = a$HGNC,
  id.longname = a$name,

  # phylogeny
  kinase.group = a$group,
  kinase.family = a$family,
  kinase.subfamily = a$subfamily,

  # branch info
  branch.coords = a$d_line,
  branch.val = a$values,
  branch.group = "none",
  branch.col = a$col_line,

  # node info
  node.x = xs,
  node.y = ys,
  node.group.col = "none",
  node.val.col = 0,
  node.val.radius = 0,
  node.radius = 5,
  node.col = "#D3D3D3",
  node.strokewidth = 1,
  node.strokecol = "black",

  # text info
  text.x = xs,
  text.y = ys,
  text.col = "black",
  text.font = "\'AvenirNext-Bold\'",
  text.size = 3.25,
  text.label = a$label_text
)

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
head(gooddataframe)

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








# To upload
# library(rsconnect)
# rsconnect::deployApp("~/Dropbox/Work/Projects/Ongoing/Kinrich/CURRENT/Project/Kinrich/")

# To access
# https://dphansti.shinyapps.io/kinrich/

