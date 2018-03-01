
#---------------------- LOAD LIBRARIES ----------------------#

library(pacman)

# load basic libraries
p_load(shiny)
p_load(shinydashboard)
p_load(shinyBS)
p_load(readr)
p_load(rsvg)
p_load(shinyWidgets)
p_load(RColorBrewer)

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
source("R/colors.R")

#---------------------- READ IN AND ORGANIZE DATA ----------------------#

# read RDS
orig_svginfo = readRDS("Data/kintree.RDS")

# read in to get eEF2K data
# readintofixEEF2K = data.frame(read_tsv("~/Desktop/dftorecolor.tsv",col_names = TRUE))
# orig_svginfo$dataframe$node.x = as.numeric(as.character(orig_svginfo$dataframe$node.x))
# orig_svginfo$dataframe$node.y = as.numeric(as.character(orig_svginfo$dataframe$node.y))
# orig_svginfo$dataframe$text.x = as.numeric(as.character(orig_svginfo$dataframe$text.x))
# orig_svginfo$dataframe$text.y = as.numeric(trimws(as.character(orig_svginfo$dataframe$text.y)))
# orig_svginfo$dataframe = rbind(orig_svginfo$dataframe,readintofixEEF2K[which(readintofixEEF2K$id.kinrich == "eEF2K"),])

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

# get example RNA data
rna_data = paste(readLines("Data/RNAdata.txt"),collapse="\n")

# set all of the temp files
outputjson = tempfile(pattern="kinome_tree",tmpdir="www",fileext = ".json")
outputjsonshort =strsplit(outputjson,split = "/")[[1]][2]
subdffile = tempfile(pattern="subdf",tmpdir="tempfiles",fileext = ".txt")
svgoutfile = tempfile(pattern="kintreeout",tmpdir="tempfiles",fileext = ".svg")

#---------------------- DEFAULT COLORS ----------------------#



sequential_palette_choices <- c(
 '<img src="Greys.png">' = 'Greys',
 '<img src="Reds.png">' = 'Reds',
 '<img src="Oranges.png">' = 'Oranges',
 '<img src="Greens.png">' = 'Greens',
  '<img src="Blues.png">' = 'Blues',
 '<img src="Purples.png">' = 'Purples'
                                #'<img src="BuGn.png">' = 'BuGn',
                                #'<img src="BuPu.png">' = 'BuPu',
                                #'<img src="GnBu.png">' = 'GnBu',
                                #'<img src="OrRd.png">' = 'OrRd',
                                #'<img src="PuBu.png">' = 'PuBu',
                                #'<img src="PuBuGn.png">' = 'PuBuGn',
                                #'<img src="PuRd.png">' = 'PuRd',
                                #'<img src="RdPu.png">' = 'RdPu',
                                #'<img src="YlGn.png">' = 'YlGn',
                                #'<img src="YlGnBu.png">' = 'YlGnBu',
                                #'<img src="YlOrBr.png">' = 'YlOrBr',
                                #'<img src="YlOrRd.png">' = 'YlOrRd'
                                )

# divergent_palette_choices <- c('<img src="BrBG.png">' = 'BrBG',
#                                 '<img src="PiYG.png">' = 'PiYG',
#                                 '<img src="PRGn.png">' = 'PRGn',
#                                '<img src="PuOr.png">' = 'PuOr',
#                                '<img src="RdBu.png">' = 'RdBu',
#                                '<img src="RdGy.png">' = 'RdGy',
#                                '<img src="RdYlBu.png">' = 'RdYlBu',
#                                '<img src="RdYlGn.png">' = 'RdYlGn',
#                                '<img src="Spectral.png">' = 'Spectral')

qualitative_palette_choices <- c('<img src="Accent.png">' = 'Accent',
                               '<img src="Dark2.png">' = 'Dark2',
                               '<img src="Paired.png">' = 'Paired',
                               '<img src="Pastel1.png">' = 'Pastel1',
                               '<img src="Pastel2.png">' = 'Pastel2',
                               '<img src="Set1.png">' = 'Set1',
                               '<img src="Set2.png">' = 'Set2',
                               '<img src="Set3.png">' = 'Set3')



divergent_palette_choices <- c('<img src="Red_Grey_Blue.png">' = 'Red_Grey_Blue',
                               '<img src="Bro_Grey_Tur.png">' = 'Bro_Grey_Tur',
                               '<img src="Pink_Grey_Gre.png">' = 'Pink_Grey_Gre',
                               '<img src="Pur_Grey_Gre.png">' = 'Pur_Grey_Gre',
                               '<img src="Pur_Grey_Or.png">' = 'Pur_Grey_Or',
                               '<img src="Red_Grey_Gre.png">' = 'Red_Grey_Gre')

# my sequential palettes
Greys = brewer.pal(3,"Greys")
Reds = brewer.pal(3,"Reds")
Oranges = brewer.pal(3,"Oranges")
Greens = brewer.pal(3,"Greens")
Blues = brewer.pal(3,"Blues")
Purples = brewer.pal(3,"Purples")

seqpalettes = list(Greys,Reds,Oranges,Greens,Blues,Purples)
names(seqpalettes) = c("Greys","Reds","Oranges","Greens","Blues","Purples")


# brewer.pal(9,"RdBu")[2]
# my divergent palettes
Red_Grey_Blue = c("#CA0020","grey90","#0571B0")
Bro_Grey_Tur = c("#A6611A","grey90", "#018571")
Pink_Grey_Gre = c("#D01C8B","grey90", "#4DAC26")
Pur_Grey_Gre = c("#7B3294","grey90", "#008837")
Pur_Grey_Or = c("#E66101","grey90", "#5E3C99")
Red_Grey_Gre = c("#CA0020","grey90", "#404040")

divpalettes = list(Red_Grey_Blue,Bro_Grey_Tur,Pink_Grey_Gre,Pur_Grey_Gre,Pur_Grey_Or,Red_Grey_Gre)
names(divpalettes) = c("Red_Grey_Blue","Bro_Grey_Tur","Pink_Grey_Gre","Pur_Grey_Gre","Pur_Grey_Or","Red_Grey_Gre")

drawmypalettes("Red_Grey_Blue",Red_Grey_Blue,"www")
drawmypalettes("Bro_Grey_Tur",Bro_Grey_Tur,"www")
drawmypalettes("Pink_Grey_Gre",Pink_Grey_Gre,"www")
drawmypalettes("Pur_Grey_Gre",Pur_Grey_Gre,"www")
drawmypalettes("Pur_Grey_Or",Pur_Grey_Or,"www")
drawmypalettes("Red_Grey_Gre",Red_Grey_Gre,"www")





colorRampPalette(c(brewer.pal(5,"RdBu")[1],"grey90",brewer.pal(5,"RdBu")[5]))


# make images of palettes
for (palette in row.names(brewer.pal.info))
{
 drawpalettes(palette=palette,outdir="www")
}

pal_divs = row.names(brewer.pal.info[brewer.pal.info[,2]=="div",])
pal_seqs = row.names(brewer.pal.info[brewer.pal.info[,2]=="seq",])
pal_quals = row.names(brewer.pal.info[brewer.pal.info[,2]=="qual",])


# Default tree branch color
BG_col1 = "#D3D3D3"

# Default heatmap colors
HM_low = "#07C9DE"
HM_med = "#D3D3D3"
HM_hi = "#F66049"

# Default group color palette
defaultpalette = colorRampPalette( c(
 "#F05F37",
 "#16CDDE",
 "#EDC624",
 "#B348A1",
 "#7C64FF",
 "#78C99B",
 "#C2374A",
 "#B0BE33",
 "#CAE6A1",
 "#3F9FFC",
 "#F2987A",
 "#BA8DB4"
))(12)

# # Default group color palette
# defaultpalette = colorRampPalette( brewer.pal(11,"Paired"))(11)

















