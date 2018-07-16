## app.R ##

ui <- dashboardPage(title="CORAL",
 dashboardHeader(title = tags$a(span(img(src="logos/coral-logo-white2.png",height=60,align="left")),href="http://phanstiel-lab.med.unc.edu/CORAL/"),titleWidth = 600,

 tags$li(class = "dropdown",
         tags$style(".main-header {max-height: 60px}"),
         tags$style(".main-header .logo {height: 60px;}"),
         tags$style(".sidebar-toggle {height: 60px; padding-top: 10px !important;}"),
         tags$style(".navbar {min-height:0px !important}")
 ) ),
 
 
 dashboardSidebar
 (
  sidebarMenu(id="sidebartabs",
              menuItem("Info", tabName = "Info", icon = icon("info")),
              menuItem("Visualize", tabName = "Visualize", icon = icon("eye")),
              tags$style(".left-side, .main-sidebar {padding-top: 60px}")
  ),
  collapsed = TRUE,
  disable = TRUE
 ),
 dashboardBody(
  tags$head(
   
   tags$head(tags$link(rel="shortcut icon", href="http://phanstiel-lab.med.unc.edu/CORAL/favicon.ico")),
   
   #adds the d3 library needed to draw the plot
   tags$script(src="javascript/d3.v3.min.js"),
   
   #the js script holding the code to make the custom output
   tags$script(src="javascript/circleNetwork.js"),
   tags$script(src="javascript/collapsableForceNetwork.js"),
   
   #the stylesheet, paste all that was between the <style> tags from your example in the graph_style.css file
   tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css")
   
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
                                         
                                         selectInput(inputId = "branchcolortype",label = "Color Scheme", 
                                                     choices = c("Uniform","Manual","Categorical","Quantitative"),
                                                     multiple = FALSE,selected = "Uniform",width = "100%"),
                                         
                                         # if single color
                                         conditionalPanel(
                                          condition = "input.branchcolortype == 'Uniform'",
                                          colourInput("col_branch_single", "Color",BG_col1,showColour = "both")
                                         ),
                                         
                                         # if manual selection
                                         conditionalPanel(
                                          condition = "input.branchcolortype == 'Manual'",
                                          
                                          # choose between selecting and pasting in
                                          radioButtons(inputId="branchmanuallyinputmethod",label = "Input Method",
                                                       choices = c("browse","paste"),inline = TRUE),
                                          
                                          # if select
                                          conditionalPanel(
                                           condition = "input.branchmanuallyinputmethod == 'browse'",
                                           selectInput(inputId = "KinasesManual",label = "Kinases",choices = svginfo$dataframe$id.coral,multiple = TRUE,width = "100%")
                                          ),
                                          # if paste
                                          conditionalPanel(
                                           condition = "input.branchmanuallyinputmethod == 'paste'",
                                           textAreaInput("KinasesManualBranchText", "Kinases", height = "100px",width = "100%",
                                                         value = ""
                                           )
                                          ),
                                          
                                          selectInput(inputId = "branchManualIDtype",label = "Identifier",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),

                                          fluidRow( width=12,
                                                    column(6,colourInput("col_select_bg", "Default Color", BG_col1,showColour = "both")),
                                                    column(6,colourInput("col_select", "Selection Color", Cor_col,showColour = "both"))
                                          ),
                                          fluidRow( width=12,
                                                    column(6,textInput(inputId="branch_nonselect_label",label="Default Label",value = "not selected")),
                                                    column(6,textInput(inputId="branch_select_label",label="Selection Label",value = "selected"))
                                          ),
                                          
                                          # add ability to reverse palette
                                          actionButton(inputId = "KinasesManualBranchRevPalette","Reverse Palette",width = "100%")
                                         ),
                                         
                                         # if Categorical
                                         conditionalPanel(
                                          condition = "input.branchcolortype == 'Categorical'",
                                          prettyCheckbox(inputId="loadexamplebranchgroup",label="load default kinase groups",value = FALSE,shape="round",status="primary"),
                                          
                                          textAreaInput("branchGroupBox", "Kinases & Category", height = "100px",width = "100%",
                                                        value = ""
                                          ),
                                          selectInput(inputId = "branchGroupIDtype",label = "Identifier",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          
                                          
                                          # add option to manually pick groups
                                          prettyCheckbox(inputId="manualgroupcols_branch","manual category entry",
                                                         value = FALSE,shape="round",status="primary"),
                                          conditionalPanel(
                                           condition = "input.manualgroupcols_branch == true",
                                           textAreaInput("ManualBranchCategories", "Categories", height = "100px",width = "100%",value =  "")
                                          ),
                                          
                                          fluidRow(width=12,
                                                   column(6,
                                                          radioButtons(inputId="branchgroupcolorpalettetype",label = "Palette Type",
                                                                       choices = c("prebuilt","manual"),inline = FALSE)
                                                   ),
                                                   
                                                   column(6,
                                                          conditionalPanel(
                                                           condition = "input.branchgroupcolorpalettetype == 'prebuilt'",
                                                           radioButtons_withHTML('branchgroupcolorpalette_qaul', 'Palette',choices = qualitative_palette_choices, inline = FALSE)
                                                          ),
                                                          
                                                          conditionalPanel(
                                                           condition = "input.branchgroupcolorpalettetype == 'manual'",
                                                           h6("Select Colors"),
                                                           fluidRow(style = "margin-top: 20px",
                                                            column(width = 1,  colourInput("branchgroupcol1", "", defaultpalette[1],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("branchgroupcol2", "", defaultpalette[2],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("branchgroupcol3", "", defaultpalette[3],showColour = "both"), style = "margin-top:-29px")
                                                           ), 
                                                           fluidRow( 
                                                            column(width = 1,  colourInput("branchgroupcol4", "", defaultpalette[4],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("branchgroupcol5", "", defaultpalette[5],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("branchgroupcol6", "", defaultpalette[6],showColour = "both"), style = "margin-top:-29px")
                                                           ), 
                                                           fluidRow(
                                                            column(width = 1,  colourInput("branchgroupcol7", "", defaultpalette[7],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("branchgroupcol8", "", defaultpalette[8],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("branchgroupcol9", "", defaultpalette[9],showColour = "both"), style = "margin-top:-29px")
                                                           ),
                                                           fluidRow(
                                                            column(width = 1,  colourInput("branchgroupcol10", "", defaultpalette[10],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("branchgroupcol11", "", defaultpalette[11],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("branchgroupcol12", "", defaultpalette[12],showColour = "both"), style = "margin-top:-29px")
                                                           )
                                                          ) # end conditional
                                                   ) # end col
                                          ), # end row
                                          
                                          colourInput("defaultbranchcolor_categorical", "Default Color",BG_col1,showColour = "both")
                                         ),
                                         
                                         
                                         # if Quantitative
                                         conditionalPanel(
                                          condition = "input.branchcolortype == 'Quantitative'",
                                          prettyCheckbox(inputId="loadexamplebranchvalue",label="load example data",value = FALSE,shape="round",status="primary"),
                                          
                                          textAreaInput("branchValueBox", "Kinases & Value", height = "100px",width = "100%",
                                                        value =  ""
                                          ),
                                          
                                          selectInput(inputId = "branchValueIDtype",label = "Identifier",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          
                                          textInput(inputId = "quantvaluenamebranchcolor", label = "Legend Subtitle"),
                                          
                                          fluidRow( width=12,
                                                    column(6,                numericInput(inputId = "minheat",label = "Min Value",value = -3 )),
                                                    column(6,                  numericInput(inputId = "maxheat",label = "Max Value",value =  3 ))
                                          ),
                                          
                                          fluidRow( width=12,
                                          column(6,
                                                 radioButtons(inputId="branchcolorpalettetype",label = "Palette Type",
                                                              choices = c("sequential","divergent","manual 2-color","manual 3-color"),inline = FALSE)
                                          ),
                                          
                                          column(6,
                                                 conditionalPanel(
                                                  condition = "input.branchcolorpalettetype == 'sequential'",
                                                  radioButtons_withHTML('branchcolorpalette_seq', 'Palette',choices = sequential_palette_choices, inline = FALSE),
                                                  prettyCheckbox("reversebranchpalettesequential",label = "Reverse Palette",shape = "round")
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.branchcolorpalettetype == 'divergent'",
                                                  radioButtons_withHTML('branchcolorpalette_div', 'Palette',choices = divergent_palette_choices, inline = FALSE),
                                                  prettyCheckbox("reversebranchpalettedivergent",label = "Reverse Palette",shape = "round")
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.branchcolorpalettetype == 'manual 2-color'",
                                                  
                                                  colourInput("branch2col_low", "Low", HM2_low,showColour = "both"),
                                                  colourInput("branch2col_hi", "High", HM2_hi,showColour = "both")
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.branchcolorpalettetype == 'manual 3-color'",
                                                  
                                                  colourInput("branch3col_low", "Low", HM_low,showColour = "both"),
                                                  colourInput("branch3col_med", "Med", HM_med,showColour = "both"),
                                                  colourInput("branch3col_hi", "High", HM_hi,showColour = "both")
                                                 )
                                          ) # end column
                                          ), # end row
                                          
                                          conditionalPanel(
                                           condition = "input.branchcolorpalettetype == 'manual 2-color'",
                                           # add ability to reverse palette
                                           actionButton(inputId = "KinasesBranchValue2RevPalette","Reverse Palette",width = "100%")
                                          ),
                                          conditionalPanel(
                                           condition = "input.branchcolorpalettetype == 'manual 3-color'",
                                           # add ability to reverse palette
                                           actionButton(inputId = "KinasesBranchValue3RevPalette","Reverse Palette",width = "100%")
                                          ),
                                          
                                          tags$br(),
                                          prettyRadioButtons(inputId = "BranchValueMissingKinase",label = "Color Missing Kinases",choices = c("automatically","manually"),
                                                             selected = "automatically",inline=TRUE),
                                          
                                          conditionalPanel(
                                           condition = "input.BranchValueMissingKinase == 'manually'",
                                           colourInput(inputId = "BranchValueMissingKinaseColor", "Missing Kinase Color",value = BG_col1,showColour = "both")
                                          )
                                          
                                         ) # end conditional panel
                                     ), # end box
                                     
                                     # ---- NODE COLOR ---- #
                                     
                                     box(width=12,title = "Node Color",status = "success", solidHeader = TRUE,
                                         collapsible = TRUE,collapsed = TRUE,
                                         
                                         selectInput(inputId = "nodecolortype",label = "Color Scheme",
                                                     #  choices = c("None","Same as branches","Uniform","Manual","Categorical","Quantitative"),
                                                     choices = c("None","Uniform","Manual","Categorical","Quantitative"),
                                                     multiple = FALSE,selected = "None",width = "100%"),
                                         
                                         # if single color
                                         conditionalPanel(
                                          condition = "input.nodecolortype == 'Uniform'",
                                          colourInput("col_node_single", "Color",BG_col1)
                                         ),
                                         
                                         # if manual selection
                                         conditionalPanel(
                                          condition = "input.nodecolortype == 'Manual'",
                                           
                                           # choose between selecting and pasting in
                                           radioButtons(inputId="nodemanuallyinputmethod",label = "Input Method",
                                                        choices = c("browse","paste"),inline = TRUE),
                                           
                                           # if select
                                           conditionalPanel(
                                            condition = "input.nodemanuallyinputmethod == 'browse'",
                                            selectInput(inputId = "KinasesManualNode",label = "Kinases",choices = svginfo$dataframe$id.coral,multiple = TRUE,width = "100%")
                                           ),
                                           # if paste
                                           conditionalPanel(
                                            condition = "input.nodemanuallyinputmethod == 'paste'",
                                            textAreaInput("KinasesManualNodeText", "Kinases", height = "100px",width = "100%",
                                                          value = ""
                                            )
                                           ),
                                           
                                           selectInput(inputId = "NodeManualIDtype",label = "Identifier",
                                                       choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                       multiple = FALSE,selected = "coralID",width = "100%"),
                                           
                                           fluidRow( width=12,
                                                     column(6,colourInput("col_node_bg", "Default Color", BG_col1,showColour = "both")),
                                                     column(6,colourInput("col_sel_node", "Selection Color", Cor_col,showColour = "both"))
                                           ),
                                           fluidRow( width=12,
                                                     column(6,textInput(inputId="node_nonselect_label",label="Default Label",value = "not selected")),
                                                     column(6,textInput(inputId="node_select_label",label="Selection Label",value = "selected"))
                                           ),
                                           
                                           # add ability to reverse palette
                                           actionButton(inputId = "KinasesManualNodeRevPalette","Reverse Palette",width = "100%")
                                          ),
                                          
                                         # if Categorical
                                         conditionalPanel(
                                          condition = "input.nodecolortype == 'Categorical'",
                                          prettyCheckbox(inputId="loadexamplennodegroup",label="load default kinase groups",value = FALSE,shape="round",status="primary"),
                                          textAreaInput("nodeGroupBox", "Kinases & Category", height = "100px",width = "100%",
                                                        value =  ""
                                          ),
                                          selectInput(inputId = "nodeGroupIDtype",label = "Identifier",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          
                                          # add option to manually pick groups
                                          prettyCheckbox(inputId="manualgroupcols_node","manual category entry",
                                                         value = FALSE,shape="round",status="primary"),
                                          conditionalPanel(
                                           condition = "input.manualgroupcols_node == true",
                                           textAreaInput("ManualNodeCategories", "Categories", height = "100px",width = "100%",value =  "")
                                          ),
                                          
                                          fluidRow(width=12,
                                                   column(6,
                                                          radioButtons(inputId="nodegroupcolorpalettetype",label = "Palette Type",
                                                                       choices = c("prebuilt","manual"),inline = FALSE)
                                                   ),
                                                   
                                                   column(6,
                                                          conditionalPanel(
                                                           condition = "input.nodegroupcolorpalettetype == 'prebuilt'",
                                                           radioButtons_withHTML('nodegroupcolorpalette_qaul', 'Palette',choices = qualitative_palette_choices, inline = FALSE)
                                                          ),
                                                          
                                                          conditionalPanel(
                                                           condition = "input.nodegroupcolorpalettetype == 'manual'",
                                                           
                                                           h6("Select Colors"),
                                                           fluidRow(style = "margin-top: 20px",
                                                                    column(width = 1,  colourInput("nodegroupcol1", "", defaultpalette[1],showColour = "both"), style = "margin-top:-29px"),
                                                                    column(width = 1,  colourInput("nodegroupcol2", "", defaultpalette[2],showColour = "both"), style = "margin-top:-29px"),
                                                                    column(width = 1,  colourInput("nodegroupcol3", "", defaultpalette[3],showColour = "both"), style = "margin-top:-29px")
                                                           ), 
                                                           fluidRow( 
                                                            column(width = 1,  colourInput("nodegroupcol4", "", defaultpalette[4],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("nodegroupcol5", "", defaultpalette[5],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("nodegroupcol6", "", defaultpalette[6],showColour = "both"), style = "margin-top:-29px")
                                                           ), 
                                                           fluidRow(
                                                            column(width = 1,  colourInput("nodegroupcol7", "", defaultpalette[7],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("nodegroupcol8", "", defaultpalette[8],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("nodegroupcol9", "", defaultpalette[9],showColour = "both"), style = "margin-top:-29px")
                                                           ),
                                                           fluidRow(
                                                            column(width = 1,  colourInput("nodegroupcol10", "", defaultpalette[10],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("nodegroupcol11", "", defaultpalette[11],showColour = "both"), style = "margin-top:-29px"),
                                                            column(width = 1,  colourInput("nodegroupcol12", "", defaultpalette[12],showColour = "both"), style = "margin-top:-29px")
                                                           )
                                                          ) # end conditional
                                                   ) # end col
                                          ), # end row
                                          
                                          colourInput("defaultnodecolor_categorical", "Default Color",BG_col1,showColour = "both")
                                         ),
                                         
                                         # if Quantitative
                                         conditionalPanel(
                                          condition = "input.nodecolortype == 'Quantitative'",
                                          prettyCheckbox(inputId="loadexamplennodevalue",label="load example data",value = FALSE,shape="round",status="primary"),
                                          textAreaInput("nodeValueBox", "Kinases & Value", height = "100px",width = "100%",
                                                        value =  ""
                                          ),
                                          selectInput(inputId = "nodeValueIDtype",label = "Identifier",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          
                                          textInput(inputId = "quantvaluenamenodecolor", label = "Legend Subtitle"),
                                          
                                          fluidRow( width=12,
                                                    column(6,                numericInput(inputId = "nodeminheat",label = "Min Value",value = -3 )),
                                                    column(6,                  numericInput(inputId = "nodemaxheat",label = "Max Value",value =  3 ))
                                          ),
                                          
                                          fluidRow( width=12,
                                          column(6,
                                                 radioButtons(inputId="nodecolorpalettetype",label = "Palette Type",
                                                              choices = c("sequential","divergent","manual 2-color","manual 3-color"),inline = FALSE)
                                          ),
                                          
                                          column(6,
                                                 conditionalPanel(
                                                  condition = "input.nodecolorpalettetype == 'sequential'",
                                                  radioButtons_withHTML('nodecolorpalette_seq', 'Palette',choices = sequential_palette_choices, inline = FALSE),
                                                  prettyCheckbox("reversenodepalettesequential",label = "Reverse Palette",shape = "round")
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.nodecolorpalettetype == 'divergent'",
                                                  radioButtons_withHTML('nodecolorpalette_div', 'Palette',choices = divergent_palette_choices, inline = FALSE),
                                                  prettyCheckbox("reversenodepalettedivergent",label = "Reverse Palette",shape = "round")
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.nodecolorpalettetype == 'manual 2-color'",
                                                  
                                                  colourInput("node2col_low", "Low", HM2_low,showColour = "both"),
                                                  colourInput("node2col_hi", "High", HM2_hi,showColour = "both")
                                                 ),
                                                 
                                                 conditionalPanel(
                                                  condition = "input.nodecolorpalettetype == 'manual 3-color'",
                                                  
                                                  colourInput("node3col_low", "Low", HM_low,showColour = "both"),
                                                  colourInput("node3col_med", "Med", HM_med,showColour = "both"),
                                                  colourInput("node3col_hi", "High", HM_hi,showColour = "both")
                                                 )
                                          )
                                          ),
                                           conditionalPanel(
                                            condition = "input.nodecolorpalettetype == 'manual 2-color'",
                                            # add ability to reverse palette
                                            actionButton(inputId = "KinasesNodeValue2RevPalette","Reverse Palette",width = "100%")
                                           ),
                                           conditionalPanel(
                                            condition = "input.nodecolorpalettetype == 'manual 3-color'",
                                            # add ability to reverse palette
                                            actionButton(inputId = "KinasesNodeValue3RevPalette","Reverse Palette",width = "100%")
                                           ),
                                          
                                          tags$br(),
                                          div(
                                          prettyRadioButtons(inputId = "NodeValueMissingKinase",label = "Color Missing Kinases",choices = c("automatically","manually"),
                                                             selected = "automatically",inline=TRUE),
                                          
                                          conditionalPanel(
                                           condition = "input.NodeValueMissingKinase == 'manually'",
                                           colourInput("NodeValueMissingKinaseColor", "Missing Kinase Color",value = BG_col1,showColour = "both")
                                          )
                                          )
                                          
                                         ), # end conditional 

                                         tags$br(),
                                         div(prettyCheckbox(inputId="colorsubnodes",label="color intermediate nodes",value = TRUE,shape="round",status="primary"))
                                     ), # end box   
                                     
                                     # ---- NODE SIZE ---- #
                                     
                                     box(width=12,title = "Node Size",status = "info", solidHeader = TRUE,
                                         collapsible = TRUE,collapsed = TRUE, 
                                         
                                         # only allow node size modification if nodes are colored
                                         
                                         conditionalPanel(
                                          condition = "input.nodecolortype == 'None'",
                                          tags$b("Node Size disabled when Node Color Set to 'None'."),
                                          tags$br(),
                                          "In order to set node size please adust node color options in the box above."
                                         ),
                                         conditionalPanel(
                                          condition = "input.nodecolortype != 'None'",
                                          
                                         selectInput(inputId = "nodesizetype",label = "Scaling Scheme",
                                                     choices = c("One Size","Quantitative"),
                                                     multiple = FALSE,selected = "One Size",width = "100%"),
                                         
                                         # if single color
                                         conditionalPanel(
                                          condition = "input.nodesizetype == 'One Size'",
                                          sliderInput("size_node_single", "Size",value=5,min = 0,max=20,step = 0.25)
                                         ),
                                         
                                         # if Quantitative
                                         conditionalPanel(
                                          condition = "input.nodesizetype == 'Quantitative'",
                                          prettyCheckbox(inputId="loadexamplennodesizevalue",label="load example data",value = FALSE,shape="round",status="primary"),
                                          textAreaInput("nodesizeValueBox", "Kinases & Value", height = "100px",width = "100%",
                                                        value = ""
                                          ),
                                          selectInput(inputId = "nodesizeValueIDtype",label = "Identifier",
                                                      choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "coralID",width = "100%"),
                                          
                                          textInput(inputId = "quantvaluenamenodesize", label = "Legend Subtitle"),
                                          
                                          sliderInput("nodesizeValueslider",label = "Size Range",value=c(3,9),min = 0, max = 20,step = 0.25),
                                          
                                          # how to handle for values not provides
                                          prettyRadioButtons(inputId = "nodesizefornotprovidedquantitative", label = "Missing Kinases",
                                                             choices = c("show","hide")),
                                          
                                          prettyCheckbox("Manuallysetdatarange","manually set data range",value = FALSE,shape="round",status="primary"),
                                          
                                          conditionalPanel(
                                           condition = "input.Manuallysetdatarange == true",
                                           fluidRow( width=12,
                                                     column(6,                numericInput(inputId = "nodesizevaluemin",label = "Min Value",value = 0 )),
                                                     column(6,                  numericInput(inputId = "nodesizevaluemax",label = "Max Value",value =  1 ))
                                           )
                                          )
                                         ) # end box  
                                      ) # end conditional
                                     ),
                                     
                                     # ---- ADVANCED SETTINGS ---- #
                                     
                                     # fluidRow(width=12,
                                     box(width=12,
                                         title = "Advanced Settings", status = "warning", solidHeader = TRUE,
                                         collapsible = TRUE,collapsed = TRUE,
                                         
                                         prettyRadioButtons("AdvancedSections",label = "",
                                                            choices = c("Title","Labels","Node"),
                                                            selected = "Title",inline = TRUE),
                                         
                                         conditionalPanel(
                                          condition = "input.AdvancedSections == 'Title'",
                                          # text box for title
                                          textInput(inputId="titleinput",label ="Title",value="" )
                                         ),
                                         
                                         conditionalPanel(
                                          condition = "input.AdvancedSections == 'Labels'",
                                          
                                          # Choose Label
                                          selectInput(inputId = "kinaselabelselect",label = "Label Identifier",
                                                      choices = c("Default","coralID","uniprot","ensembl","entrez","HGNC"),
                                                      multiple = FALSE,selected = "Helvetica",width = "100%"),
                                      
                                          # Choose Font
                                          selectInput(inputId = "fontfamilyselect",label = "Font",
                                                      choices = c("Helvetica","Arial","Verdana","Trebuchet MS","Times New Roman","Garamond"),
                                                      multiple = FALSE,selected = "Helvetica",width = "100%"),
                                          
                                          selectInput(inputId = "fontcolorselect",label = "Label Color Scheme",
                                                      choices = c("Same as Branch","Single Color","Manual"),
                                                      multiple = FALSE,selected = "Single Color",width = "100%"),
                                          
                                          
                                          conditionalPanel(condition = "input.fontcolorselect == 'Single Color'|| input.fontcolorselect == 'Same as Branch'",
                                            # Slider for font size 
                                            sliderInput("fontsize", "Label Font Size",min = 0, max = 8,value = 4,step = 0.05,ticks=F)),
                                          
                                          
                                          
                                          conditionalPanel(condition = "input.fontcolorselect == 'Single Color'",
                                                           colourInput("fontcolorchoose", "Label Color","#000000")),
                                          
                                          colourInput("groupcolorchoose", "Group Color","#000000")
                                         ),
                                         
                                         conditionalPanel(
                                          condition = "input.AdvancedSections == 'Node'",
                                          
                                          
                                          sliderInput("Node_Opacity", "Opacity",value=1,min = 0,max=1,step = 0.01),
                                          
                                          # How to color stroke of node
                                          selectInput(inputId = "nodestrokecolselect",label = "Node Stroke Color Scheme",
                                                      choices = c("Same as Node","Single Color","Selected"),
                                                      multiple = FALSE,selected = "Same as Node",width = "100%"),
                                          
                                          # Node stroke as single color
                                          conditionalPanel(condition = "input.nodestrokecolselect == 'Single Color'",
                                                           colourInput("nodestrokecol", "Node Stroke Color","#ffffff")
                                          ),
                                          # Node stroke by selected
                                          conditionalPanel(condition = "input.nodestrokecolselect == 'Selected'",
                                                           textAreaInput("NodeStrokeSelect", "Selected Kinases", height = "100px",width = "100%",
                                                                         value = ""
                                                           ),
                                                           selectInput(inputId = "NodeStrokeSelectIDtype",label = "Identifier",
                                                                       choices = c("coralID","uniprot","ensembl","entrez","HGNC"),
                                                                       multiple = FALSE,selected = "coralID",width = "100%"),
                                                           
                                                           colourInput("NodeStrokeSelect_BG", "Not Selected Color","#ffffff"),
                                                           colourInput("NodeStrokeSelect_FG", "Selected Color",Cor_col)
                                          ) # end condition
                                          
                                          
                                         )
                                     ) #end box
                           ), #end row
                           
                           # ---- DOWNLOAD ---- #
                           
                           conditionalPanel(
                            condition = "input.tabboxselected == 'Tree'",
                            tipify(downloadButton(outputId = "downloadtree",label= "Download"),
                                                  title = "Plots download in SVG vector format, which can be opened in web browsers and graphics software. To easily convert to PDF, we recommend opening the SVG in Safari and selecting File > Export to PDF. To convert using another browser, choose the Save as PDF option in the Print menu.",
                                   placement = "bottom",trigger = "hover")
                            ),
                           conditionalPanel(
                            condition = "input.tabboxselected == 'Circle'",
                            tipify(tags$a(id="downloadcircle", class="btn btn-default", "Download"),
                                   title = "Plots download in SVG vector format, which can be opened in web browsers and graphics software. To easily convert to PDF, we recommend opening the SVG in Safari and selecting File > Export to PDF. To convert using another browser, choose the Save as PDF option in the Print menu.",
                                   placement = "bottom",trigger = "hover")
                            ),
                           conditionalPanel(
                            condition = "input.tabboxselected == 'Force'",
                            tipify(tags$a(id="downloadforce", class="btn btn-default", "Download"),
                                   title = "Plots download in SVG vector format, which can be opened in web browsers and graphics software. To easily convert to PDF, we recommend opening the SVG in Safari and selecting File > Export to PDF. To convert using another browser, choose the Save as PDF option in the Print menu.",
                                   placement = "bottom",trigger = "hover")
                            )
                    ), # end column
                    
                    column(width=9,
                    tabBox
                    (id = "tabboxselected",width=12,height=1000,
                     tabPanel
                     ("Tree",
                      width=12,
                      div(id="treediv")
                     ),
                     tabPanel
                     ("Circle",
                      width=12,
                      shinyjs::useShinyjs(),
                      div(id="circlediv")
                     ),
                     
                     tabPanel
                     ("Force",
                      width=12,
                      shinyjs::useShinyjs(),
                      div(id="forcediv")
                     )
                    ),
                    
                    conditionalPanel(
                     condition = "input.tabboxselected == 'Tree'",
                     div(id="treedisclaimer",width=12)),
                    
                    conditionalPanel(
                     condition = "input.tabboxselected == 'Circle'",
                     div(id="circledisclaimer",width=12)),
                    
                    conditionalPanel(
                     condition = "input.tabboxselected == 'Force'",
                     div(id="forcedisclaimer",width=12))
                    
                    )
                    
           ),
           
           fluidRow(width=12,
                    box(width=12, style = "margin-bottom: 45px",
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
                            actionButton("InfoAdvancedSettingsButton",label="Advanced Settings")
                           ),
                           
                           tags$br(),
                           
                           div(
                            actionButton("InfoAboutButton",label="About")
                           )
                           
                    ), # end column
                    
                    column
                    (width=9, style="margin-bottom: 40px",
                     
                     div(id= "InfoBox")
                    )
           ) # end row
   )
  ), # /tabItems
  tags$footer(tags$a(span(img(src="logos/PhanstielLab.png",height=16,align="left", style="")), href="http://phanstiel-lab.med.unc.edu/"), align = "left", style = "
              position: absolute;
              bottom:0;
              width:101%;
              height:40px;
              color: #eceff3;
              padding: 12px 25px 0px 20px;
              margin-left: -20px;
              background-color: #b8c2cc;
              z-index: 1000;",
              tags$ul("© 2018 Phanstiel Lab", align="right", style="font-weight:300") # c4c8cc
  )
 )
)

