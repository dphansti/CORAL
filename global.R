# load basic libraries
require(shiny)
require(shinydashboard)
require(shinyBS)
require(readr)
require(rsvg)

# load Manning-related libraries
require(svgPanZoom)

# load ui-related libraries
require(rhandsontable)
require(colourpicker)
require(DT)

# load other network libraries
require(dplyr)
require(data.tree)
require(radialNetworkR)
require(networkD3)
require(igraph)
require(jsonlite)
require(rjson)
require(httr)
require(stringr)

# Point to R functions
source("R/colorby.R")
source("R/readinput.R")
source("R/writekinasetree.R")
source("R/legendfunctions.R")

source("R/map2color.R")
source("R/convertID.R")

source("R/makejson.R")
source("R/radialNetwork_KinomeTree.R")
source("R/forceNetwork_KinomeTree.R")

# read RDS
orig_svginfo = readRDS("Data/kintree.RDS")
orig_svginfo$legend = c()

# make svginfo (leaving the original intact)
svginfo = orig_svginfo

# Used for Default values
CDKs = grep(pattern = "CDK",svginfo$dataframe$id.kinrich)
CaMs = grep(pattern = "CaM",svginfo$dataframe$id.kinrich)

defaultpalette = colorRampPalette( c("forestgreen","violet","dodgerblue2","deepskyblue2","lightgrey","gold","orange","firebrick2"))(12)


# To upload
# library(rsconnect)
# rsconnect::deployApp("~/Dropbox/Work/Projects/Ongoing/Kinrich/CURRENT/Project/Kinrich/")
# rsconnect::deployApp()
# rsconnect::deployApp("~/Dropbox/Work/Projects/Ongoing/CORAL/Rpackage/CORAL/")
# rsconnect::setAccountInfo(name='dphansti', token='97CD97745674D398F80301CA4EF52342', secret='08F7iBW64Du4zadfda6qIzrHDAseBmUMtHNSi2u/')


# To access
# https://dphansti.shinyapps.io/coral/

