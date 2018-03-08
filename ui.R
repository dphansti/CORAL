## app.R ##

ui <- dashboardPage(
 dashboardHeader(title = span(img(src="images/coral-logo-white.png",height=60,align="left")),titleWidth = 600,

 tags$li(class = "dropdown",
         tags$style(".main-header {max-height: 60px}"),
         tags$style(".main-header .logo {height: 60px;}"),
         tags$style(".sidebar-toggle {height: 60px; padding-top: 10px !important;}"),
         tags$style(".navbar {min-height:60px !important}")
 ) ),
 
 dashboardSidebar
 (
  sidebarMenu(id="sidebartabs",
              menuItem("Visualize", tabName = "Visualize", icon = icon("eye")),
              menuItem("Info", tabName = "Info", icon = icon("info")),
              tags$style(".left-side, .main-sidebar {padding-top: 60px}")
  ),
  collapsed = TRUE,
  disable = TRUE
 ),
 dashboardBody(
  tags$head(
   
   #adds the d3 library needed to draw the plot
   tags$script(src="d3.v3.min.js"),
   
   #the js script holding the code to make the custom output
   tags$script(src="circleNetwork.js"),
   tags$script(src="collapsableForceNetwork.js"),
   
   #the stylesheet, paste all that was between the <style> tags from your example in the graph_style.css file
   tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
   
   # # try to resize plot according to window size
   # tags$head(tags$style("#plot1{height:100vh;}")),
   # tags$head(tags$style("#InfoAbout{text-align: left; color: #fff; background-color: #0571B0; height:43px; font-size: 120%; line-height: 140%; letter-spacing: .25px; border-radius: 0;}")),
   # tags$head(tags$style("#InfoUsage{text-align: left; color: #fff; background-color: #0571B0; height:43px; font-size: 120%; line-height: 140%; letter-spacing: .25px; border-radius: 0;}")),
   # tags$head(tags$style("#InfoOther{text-align: left; color: #fff; background-color: #0571B0; height:43px; font-size: 120%; line-height: 140%; letter-spacing: .25px; border-radius: 0;}"))
  ),
  
  # Fix a bug in the texboxInput funciton that doesn't respect width= "100%"
  tags$style(HTML(".shiny-input-container:not(.shiny-input-container-inline) {width: 100%;}")),
  
  tabItems(
   # First tab content
   tabItem(tabName = "Visualize",
           
           fluidRow(width=12,
                    column(width=3,
                           
                           # choose between tabs
                           radioGroupButtons(
                            inputId = "dashboardchooser", label = NULL, 
                            choices = c("Info", "Plot"), 
                            selected = "Plot",
                            justified = TRUE, status = "primary",
                            checkIcon = list(yes = "", no = "")
                           ),
                           
                           fluidRow( width=12,
                                     box(width=12,title = "Branch Color",status = "primary", solidHeader = TRUE,
                                         collapsible = TRUE,collapsed = TRUE,
                                         
                                         selectInput(inputId = "branchcolortype",label = "Color Branch", 
                                                     choices = c("As one color","Manually","by group","by value"),
                                                     multiple = FALSE,selected = "As one color",width = "100%"),
                                         
                                         # if single color
                                         conditionalPanel(
                                          condition = "input.branchcolortype == 'As one color'",
                                          colourInput("col_branch_single", "Branch Color",BG_col1,showColour = "both")
                                         ),
                                         
                                         # if manual selection
                                         conditionalPanel(
                                          condition = "input.branchcolortype == 'Manually'",
                                          
                                          # choose between selecting and pasting in
                                          radioButtons(inputId="branchmanuallyinputmethod",label = "Kinase Input Method",
                                                       choices = c("Select","Paste"),inline = TRUE),
                                          
                                          # if Select
                                          conditionalPanel(
                                           condition = "input.branchmanuallyinputmethod == 'Select'",
                                           selectInput(inputId = "KinasesManual",label = "Kinases",choices = svginfo$dataframe$id.coral,multiple = TRUE,width = "100%")
                                          ),
                                          # if Paste
                                          conditionalPanel(
                                           condition = "input.branchmanuallyinputmethod == 'Paste'",
                                           textAreaInput("KinasesManualBranchText", "Kinases", height = "100px",width = "100%",
                                                         value = ""
                                           )
                                          ),

                                          fluidRow( width=12,
                                                    column(6,colourInput("col_select_bg", "BG Color", BG_col1,showColour = "both")),
                                                    column(6,colourInput("col_select", "Color", HM_hi,showColour = "both"))
                                          )
                                          
                                         ),
                                         
                                         # if by group
                                         conditionalPanel(
                                          condition = "input.branchcolortype == 'by group'",
                                          prettyCheckbox(inputId="loadexamplebranchgroup",label="load default kinase groups",value = FALSE,shape="round",status="primary"),
                                          
                                          textAreaInput("branchGroupBox", "Kinases & Group", height = "100px",width = "100%",
                                                        value = ""
                                          ),
                                          selectInput(inputId = "branchGroupIDtype",label = "Identifier Type",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          
                                          fluidRow(width=12,
                                                   column(6,
                                                          radioButtons(inputId="branchgroupcolorpalettetype",label = "Color Range Type",
                                                                       choices = c("prebuilt","manual"),inline = FALSE)
                                                   ),
                                                   
                                                   column(6,
                                                          conditionalPanel(
                                                           condition = "input.branchgroupcolorpalettetype == 'prebuilt'",
                                                           radioButtons_withHTML('branchgroupcolorpalette_qaul', 'Choose Palette',choices = qualitative_palette_choices, inline = FALSE)
                                                          ),
                                                          
                                                          conditionalPanel(
                                                           condition = "input.branchgroupcolorpalettetype == 'manual'",
                                                           
                                                           "Select Colors",
                                                           
                                                           fluidRow(
                                                            column(width = 1,  colourInput("branchgroupcol1", "", defaultpalette[1],showColour = "both")),
                                                            column(width = 1,  colourInput("branchgroupcol2", "", defaultpalette[2],showColour = "both")),
                                                            column(width = 1,  colourInput("branchgroupcol3", "", defaultpalette[3],showColour = "both")),
                                                            column(width = 1,  colourInput("branchgroupcol4", "", defaultpalette[4],showColour = "both"))
                                                           ),
                                                           fluidRow( 
                                                            column(width = 1,  colourInput("branchgroupcol5", "", defaultpalette[5],showColour = "both")),
                                                            column(width = 1,  colourInput("branchgroupcol6", "", defaultpalette[6],showColour = "both")),
                                                            column(width = 1,  colourInput("branchgroupcol7", "", defaultpalette[7],showColour = "both")),
                                                            column(width = 1,  colourInput("branchgroupcol8", "", defaultpalette[8],showColour = "both"))
                                                           ),
                                                           fluidRow( 
                                                            column(width = 1,  colourInput("branchgroupcol9", "", defaultpalette[9],showColour = "both")),
                                                            column(width = 1,  colourInput("branchgroupcol10", "", defaultpalette[10],showColour = "both")),
                                                            column(width = 1,  colourInput("branchgroupcol11", "", defaultpalette[11],showColour = "both")),
                                                            column(width = 1,  colourInput("branchgroupcol12", "", defaultpalette[12],showColour = "both"))
                                                           )
                                                          ) # end conditional
                                                   ) # end col
                                          ), # end row
                                          
                                          tags$hr(),
                                          
                                          prettyCheckbox(inputId="manualgroupcols_branch","manual group entry",
                                                         value = FALSE,shape="round",status="primary")
                                         ),
                                         
                                         
                                         # if by value
                                         conditionalPanel(
                                          condition = "input.branchcolortype == 'by value'",
                                          prettyCheckbox(inputId="loadexamplebranchvalue",label="load example data",value = FALSE,shape="round",status="primary"),
                                          
                                          textAreaInput("branchValueBox", "Kinases & Value", height = "100px",width = "100%",
                                                        value =  ""
                                          ),
                                          
                                          selectInput(inputId = "branchValueIDtype",label = "Identifier Type",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          
                                          fluidRow( width=12,
                                                    column(6,                numericInput(inputId = "minheat",label = "min",value = -3 )),
                                                    column(6,                  numericInput(inputId = "maxheat",label = "max",value =  3 ))
                                          ),
                                          
                                          column(6,
                                                 radioButtons(inputId="branchcolorpalettetype",label = "Color Range Type",
                                                              choices = c("sequential","divergent","manual 2 color","manual 3 color"),inline = FALSE)
                                          ),
                                          
                                          column(6,
                                                 conditionalPanel(
                                                  condition = "input.branchcolorpalettetype == 'sequential'",
                                                  radioButtons_withHTML('branchcolorpalette_seq', 'Choose Palette',choices = sequential_palette_choices, inline = FALSE)
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.branchcolorpalettetype == 'divergent'",
                                                  radioButtons_withHTML('branchcolorpalette_div', 'Choose Palette',choices = divergent_palette_choices, inline = FALSE)
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.branchcolorpalettetype == 'manual 2 color'",
                                                  
                                                  colourInput("branch2col_low", "Low", HM_low,showColour = "both"),
                                                  colourInput("branch2col_hi", "High", HM_hi,showColour = "both")
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.branchcolorpalettetype == 'manual 3 color'",
                                                  
                                                  colourInput("branch3col_low", "Low", HM_low,showColour = "both"),
                                                  colourInput("branch3col_med", "Med", HM_med,showColour = "both"),
                                                  colourInput("branch3col_hi", "High", HM_hi,showColour = "both")
                                                 )
                                          ) # end column
                                         ) # end conditional panel
                                     ), # end box
                                     
                                     # ---- NODE COLOR ---- #
                                     
                                     box(width=12,title = "Node Color",status = "success", solidHeader = TRUE,
                                         collapsible = TRUE,collapsed = TRUE,
                                         
                                         selectInput(inputId = "nodecolortype",label = "Color Node",
                                                     #  choices = c("None","Same as branches","As one color","Manually","by group","by value"),
                                                     choices = c("None","As one color","Manually","by group","by value"),
                                                     multiple = FALSE,selected = "None",width = "100%"),
                                         
                                         # if single color
                                         conditionalPanel(
                                          condition = "input.nodecolortype == 'As one color'",
                                          colourInput("col_node_single", "Node Color",BG_col1)
                                         ),
                                         
                                         # if manual selection
                                         conditionalPanel(
                                          condition = "input.nodecolortype == 'Manually'",
                                          selectInput(inputId = "NodeManual",label = "Kinases",choices = svginfo$dataframe$id.coral,multiple = TRUE,width = "100%"),
                                          fluidRow( width=12,
                                                    column(6,colourInput("col_node_bg", "BG Color", HM_med)),
                                                    column(6,colourInput("col_sel_node", "Color", HM_hi))
                                          )
                                         ),
                                         
                                         # if by group
                                         conditionalPanel(
                                          condition = "input.nodecolortype == 'by group'",
                                          prettyCheckbox(inputId="loadexamplennodegroup",label="load default kinase groups",value = FALSE,shape="round",status="primary"),
                                          textAreaInput("nodeGroupBox", "Kinases & Group", height = "100px",width = "100%",
                                                        value =  ""
                                          ),
                                          selectInput(inputId = "nodeGroupIDtype",label = "Identifier Type",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          
                                          
                                          fluidRow(width=12,
                                                   column(6,
                                                          radioButtons(inputId="nodegroupcolorpalettetype",label = "Color Range Type",
                                                                       choices = c("prebuilt","manual"),inline = FALSE)
                                                   ),
                                                   
                                                   column(6,
                                                          conditionalPanel(
                                                           condition = "input.nodegroupcolorpalettetype == 'prebuilt'",
                                                           radioButtons_withHTML('nodegroupcolorpalette_qaul', 'Choose Palette',choices = qualitative_palette_choices, inline = FALSE)
                                                          ),
                                                          
                                                          conditionalPanel(
                                                           condition = "input.nodegroupcolorpalettetype == 'manual'",
                                                           
                                                           "Select Colors",
                                                           
                                                           fluidRow(
                                                            column(width = 1,  colourInput("nodegroupcol1", "", defaultpalette[1],showColour = "both")),
                                                            column(width = 1,  colourInput("nodegroupcol2", "", defaultpalette[2],showColour = "both")),
                                                            column(width = 1,  colourInput("nodegroupcol3", "", defaultpalette[3],showColour = "both")),
                                                            column(width = 1,  colourInput("nodegroupcol4", "", defaultpalette[4],showColour = "both"))
                                                           ),
                                                           fluidRow( 
                                                            column(width = 1,  colourInput("nodegroupcol5", "", defaultpalette[5],showColour = "both")),
                                                            column(width = 1,  colourInput("nodegroupcol6", "", defaultpalette[6],showColour = "both")),
                                                            column(width = 1,  colourInput("nodegroupcol7", "", defaultpalette[7],showColour = "both")),
                                                            column(width = 1,  colourInput("nodegroupcol8", "", defaultpalette[8],showColour = "both"))
                                                           ),
                                                           fluidRow( 
                                                            column(width = 1,  colourInput("nodegroupcol9", "", defaultpalette[9],showColour = "both")),
                                                            column(width = 1,  colourInput("nodegroupcol10", "", defaultpalette[10],showColour = "both")),
                                                            column(width = 1,  colourInput("nodegroupcol11", "", defaultpalette[11],showColour = "both")),
                                                            column(width = 1,  colourInput("nodegroupcol12", "", defaultpalette[12],showColour = "both"))
                                                           )
                                                          ) # end conditional
                                                   ) # end col
                                          ), # end row
                                          
                                          tags$hr(),
                                          
                                          prettyCheckbox(inputId="manualgroupcols_node","manual group entry",
                                                         value = FALSE,shape="round",status="primary")
                                         ),
                                         
                                         # if by value
                                         conditionalPanel(
                                          condition = "input.nodecolortype == 'by value'",
                                          prettyCheckbox(inputId="loadexamplennodevalue",label="load example data",value = FALSE,shape="round",status="primary"),
                                          textAreaInput("nodeValueBox", "Kinases & Value", height = "100px",width = "100%",
                                                        value =  ""
                                          ),
                                          selectInput(inputId = "nodeValueIDtype",label = "Identifier Type",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          fluidRow( width=12,
                                                    column(6,                numericInput(inputId = "nodeminheat",label = "min",value = -3 )),
                                                    column(6,                  numericInput(inputId = "nodemaxheat",label = "max",value =  3 ))
                                          ),
                                          column(6,
                                                 radioButtons(inputId="nodecolorpalettetype",label = "Color Range Type",
                                                              choices = c("sequential","divergent","manual 2 color","manual 3 color"),inline = FALSE)
                                          ),
                                          
                                          column(6,
                                                 conditionalPanel(
                                                  condition = "input.nodecolorpalettetype == 'sequential'",
                                                  radioButtons_withHTML('nodecolorpalette_seq', 'Choose Palette',choices = sequential_palette_choices, inline = FALSE)
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.nodecolorpalettetype == 'divergent'",
                                                  radioButtons_withHTML('nodecolorpalette_div', 'Choose Palette',choices = divergent_palette_choices, inline = FALSE)
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.nodecolorpalettetype == 'manual 2 color'",
                                                  
                                                  colourInput("node2col_low", "Low", HM_low,showColour = "both"),
                                                  colourInput("node2col_hi", "High", HM_hi,showColour = "both")
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.nodecolorpalettetype == 'manual 3 color'",
                                                  
                                                  colourInput("node3col_low", "Low", HM_low,showColour = "both"),
                                                  colourInput("node3col_med", "Med", HM_med,showColour = "both"),
                                                  colourInput("node3col_hi", "High", HM_hi,showColour = "both")
                                                 )
                                                 
                                          )
                                         ), # end conditional  
                                         prettyCheckbox(inputId="colorsubnodes",label="Color Intermediate Nodes?",value = FALSE,shape="round",status="primary")
                                     ), # end box   
                                     
                                     # ---- NODE SIZE ---- #
                                     
                                     box(width=12,title = "Node Size",status = "info", solidHeader = TRUE,
                                         collapsible = TRUE,collapsed = TRUE, 
                                         
                                         selectInput(inputId = "nodesizetype",label = "Size Node",
                                                     choices = c("One Size","by value"),
                                                     multiple = FALSE,selected = "One Size",width = "100%"),
                                         
                                         # if single color
                                         conditionalPanel(
                                          condition = "input.nodesizetype == 'One Size'",
                                          sliderInput("size_node_single", "Node Size",value=6,min = 0,max=20,step = 0.25)
                                         ),
                                         
                                         # if by value
                                         conditionalPanel(
                                          condition = "input.nodesizetype == 'by value'",
                                          prettyCheckbox(inputId="loadexamplennodesizevalue",label="load example data",value = FALSE,shape="round",status="primary"),
                                          textAreaInput("nodesizeValueBox", "Kinases & Value", height = "100px",width = "100%",
                                                        value = ""
                                          ),
                                          selectInput(inputId = "nodesizeValueIDtype",label = "Identifier Type",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          sliderInput("nodesizeValueslider",label = "Size Range",value=c(3,9),min = 0, max = 20,step = 0.25),
                                          
                                          prettyCheckbox("Manuallysetdatarange","Manually set data range",value = FALSE,shape="round",status="primary"),
                                          
                                          conditionalPanel(
                                           condition = "input.Manuallysetdatarange == true",
                                           fluidRow( width=12,
                                                     column(6,                numericInput(inputId = "nodesizevaluemin",label = "Min Value",value = 0 )),
                                                     column(6,                  numericInput(inputId = "nodesizevaluemax",label = "Max Value",value =  1 ))
                                           )
                                          )
                                         ) # end box  
                                     ),
                                     
                                     # ---- ADVANCED SETTINGS ---- #
                                     
                                     # fluidRow(width=12,
                                     box(width=12,
                                         title = "Advanced Settings", status = "warning", solidHeader = TRUE,
                                         collapsible = TRUE,collapsed = TRUE,
                                         
                                         prettyRadioButtons("AdvancedSections",label = "",
                                                            choices = c("Title","Font","Node"),
                                                            selected = "Title",inline = TRUE),
                                         
                                         conditionalPanel(
                                          condition = "input.AdvancedSections == 'Title'",
                                          # text box for title
                                          textInput(inputId="titleinput",label = 
                                                     h4("Title",
                                                        tags$style(type = "text/css", "#titletooltip {vertical-align: bottom;}"),
                                                        bsButton("titletooltip", label = "", icon = icon("question"), style = "primary", size = "extra-small")),
                                                    placeholder = ""),
                                          bsTooltip(id="titletooltip",title="Provide title for top of plot (Only applies to Tree layout)",
                                                    placement = "bottom", trigger = "hover",
                                                    options = NULL)
                                         ),
                                         
                                         conditionalPanel(
                                          condition = "input.AdvancedSections == 'Font'",
                                          
                                          # Choose Font
                                          selectInput(inputId = "fontfamilyselect",label = "Choose Font",
                                                      choices = c("Helvetica","Arial","Verdana","Trebuchet MS","Times New Roman","Garamond"),
                                                      multiple = FALSE,selected = "Helvetica",width = "100%"),
                                          
                                          # Slider for font size 
                                          sliderInput("fontsize", "Label Font Size",min = 0, max = 8,value = 4,step = 0.05,ticks=F),
                                          
                                          selectInput(inputId = "fontcolorselect",label = "Label Color",
                                                      choices = c("Same as Branch","Single Color"),
                                                      multiple = FALSE,selected = "Single Color",width = "100%"),
                                          
                                          conditionalPanel(condition = "input.fontcolorselect == 'Single Color'",
                                                           colourInput("fontcolorchoose", "Label Color","#000000"))
                                         ),
                                         
                                         conditionalPanel(
                                          condition = "input.AdvancedSections == 'Node'",
                                          
                                          # How to color stroke of node
                                          selectInput(inputId = "nodestrokecolselect",label = "Color Node Stroke By",
                                                      choices = c("Single Color","Same as Node","Selected"),
                                                      multiple = FALSE,selected = "Single Color",width = "100%"),
                                          
                                          # Node stroke as single color
                                          conditionalPanel(condition = "input.nodestrokecolselect == 'Single Color'",
                                                           colourInput("nodestrokecol", "Node Stroke Color","#ffffff")
                                          ),
                                          # Node stroke by selected
                                          conditionalPanel(condition = "input.nodestrokecolselect == 'Selected'",
                                                           textAreaInput("NodeStrokeSelect", "Selected Kinases", height = "100px",width = "100%",
                                                                         value = ""
                                                           ),
                                                           selectInput(inputId = "NodeStrokeSelectIDtype",label = "Identifier Type",
                                                                       choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                                       multiple = FALSE,selected = "coralID",width = "100%"),
                                                           
                                                           colourInput("NodeStrokeSelect_BG", "Not Selected Color","#ffffff"),
                                                           colourInput("NodeStrokeSelect_FG", "Selected Color",HM_hi)
                                          ) # end condition
                                         )
                                     ) #end box
                           ), #end row
                           
                           # ---- DOWNLOAD ---- #
                           
                           conditionalPanel(
                            condition = "input.tabboxselected == 'Tree'",
                            downloadButton(outputId = "downloadtree",label= "Download")
                           ),
                           conditionalPanel(
                            condition = "input.tabboxselected == 'Circle'",
                            tags$a(id="downloadcircle", href="#", class="btn btn-default", "Download")
                           ),
                           conditionalPanel(
                            condition = "input.tabboxselected == 'Force'",
                            tags$a(id="downloadforce", href="#", class="btn btn-default", "Download")
                           )
                    ), # end column
                    
                    tabBox
                    (id = "tabboxselected",width=9,height=1000,
                     tabPanel
                     ("Tree",
                      width=12,
                      svgPanZoomOutput('plot1',height=940), class = 'leftAlign'
                     ),
                     tabPanel
                     ("Circle",
                      width=12,
                      shinyjs::useShinyjs(),
                      
                      #this div will hold the final graph
                      div(id="circlelayout", class="circleNetwork",jsonfilename=outputjsonshort)
                     ),
                     
                     tabPanel
                     ("Force",
                      width=12,
                      shinyjs::useShinyjs(),
                      
                      #this div will hold the final graph
                      div(id="forcelayout", class="collapsableForceNetwork",jsonfilename=outputjsonshort)
                     )
                    )
           ),
           
           fluidRow(width=12,
                    box(width=12,
                        DT::dataTableOutput("KinaseTable")
                    )
           )
   ),
   
   tabItem(tabName = "Info",
           
           fluidRow(width=12,
                    column(width=3,
                           
                           # choose between tabs
                           radioGroupButtons(
                            inputId = "dashboardchooser2", label = NULL, 
                            choices = c("Info", "Plot"), 
                            selected = "Info",
                            justified = TRUE, status = "primary",
                            checkIcon = list(yes = "", no = "")
                           ),
                           
                           div(
                            actionButton("InfoBranchColorButton",label="Branch Color")
                           ),
                           
                           tags$br(),
                           
                           div(
                            actionButton("InfoNodeColorButton",label="Node Color")
                           ),
                           
                           tags$br(),
                           
                           div(
                            actionButton("InfoNodeSizeButton",label="Node Size")
                           ),
                           
                           tags$br(),
                           
                           div(
                            actionButton("InfoAdvancedOptionsButton",label="Advanced Options")
                           ),
                           
                           tags$br(),
                           
                           div(
                            actionButton("InfoAboutButton",label="About")
                           )
                           
                    ), # end column
                    
                    column
                    (  width=9,   
                     
                     div(id= "InfoBox")
                    )
           ) # end row
   )
  )
 ) # /tabItems
)
