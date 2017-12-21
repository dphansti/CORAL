# load basic libraries
require(shiny)
require(shinydashboard)

# load Manning-related libraries
require(svgPanZoom)

# load ui-related libraries
require(rhandsontable)
require(colourpicker)
require(DT)
# require(shinyIncubator)

# load other network libraries


# Point to R functions
source("R/colorby.R")
source("R/readinput.R")
source("R/writekinasetree.R")

source("R/recolortreebynumber.R")
source("R/map2color.R")
source("R/convertID.R")

# read RDS
orig_svginfo = readRDS("Data/kintree.RDS")

# make svginfo (leaving the original intact)
svginfo = orig_svginfo

# Used for Default values
CDKs = grep(pattern = "CDK",svginfo$dataframe$id.kinrich)
CaMs = grep(pattern = "CaM",svginfo$dataframe$id.kinrich)

# To upload
# library(rsconnect)
# rsconnect::deployApp("~/Dropbox/Work/Projects/Ongoing/Kinrich/CURRENT/Project/Kinrich/")

# To access
# https://dphansti.shinyapps.io/kinrich/

