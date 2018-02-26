
#---------------------- LOAD LIBRARIES ----------------------#

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

#---------------------- SOURCE R FILES ----------------------#

source("R/colorby.R")
source("R/readinput.R")
source("R/writekinasetree.R")
source("R/legendfunctions.R")
source("R/map2color.R")
source("R/convertID.R")
source("R/makejson.R")

#---------------------- READ IN AND ORGANIZE DATA ----------------------#

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

# set all of the temp files
outputjson = tempfile(pattern="kinome_tree",tmpdir="www",fileext = ".json")
outputjsonshort =strsplit(outputjson,split = "/")[[1]][2]
subdffile = tempfile(pattern="subdf",tmpdir="tempfiles",fileext = ".txt")
svgoutfile = tempfile(pattern="kintreeout",tmpdir="tempfiles",fileext = ".svg")

#---------------------- DEFAULT COLORS ----------------------#

# Default tree branch color
BG_col1 = "#D3D3D3"

# Default heatmap colors
HM_low = "#F66049"
HM_med = "#D3D3D3"
HM_hi = "#07C9DE"

# Default group color palette
defaultpalette = colorRampPalette( c("forestgreen","violet","dodgerblue2","deepskyblue2","lightgrey","gold","orange","firebrick2"))(12)




















