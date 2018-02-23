library(pacman)

# load basic libraries
p_load(shiny)
p_load(shinydashboard)
p_load(shinyBS)
p_load(readr)
p_load(rsvg)

# load Manning-related libraries
p_load(svgPanZoom)

# load ui-related libraries
p_load(colourpicker)
p_load(DT)

# load other network libraries
p_load(data.tree)
p_load(jsonlite)

# Point to R functions
source("R/colorby.R")
source("R/readinput.R")
source("R/writekinasetree.R")
source("R/legendfunctions.R")

source("R/map2color.R")
source("R/convertID.R")
source("R/makejson.R")

# read RDS
orig_svginfo = readRDS("Data/kintree.RDS")

# add correct header
orig_svginfo$header = "<svg viewBox=\"50 -10 800 640\"  preserveAspectRatio=\"xMidYMid meet\"\n
xmlns=\"http://www.w3.org/2000/svg\"\n
xmlns:xlink=\"http://www.w3.org/1999/xlink\" >\n
<defs>\n    <style type=\"text/css\">\n
@import url('https://fonts.googleapis.com/css?family=Roboto:700');\n
text {font-family: \"Roboto-Bold\";\n  }\n  </style>\n    </defs>"

# intitialize title
orig_svginfo$title = ""

# initilize legend
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

