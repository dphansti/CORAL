#!/usr/bin/env Rscript

# to find all the library commands run:
#  grep -Rh library * | sort | uniq
# 
# then reformat the library calls to use p_load as below, plus dealing with the github only packages

if("pacman" %in% rownames(installed.packages()) == FALSE) {
 install.packages("pacman")
}

library(pacman)

p_load(colourpicker)
p_load(data.tree)
p_load(DT)
p_load(jsonlite)
p_load(RColorBrewer)
p_load(readr)
p_load(rsvg)
p_load(shiny)
p_load(shinyBS)
p_load(shinydashboard)
p_load(shinyWidgets)
p_load(svgPanZoom)