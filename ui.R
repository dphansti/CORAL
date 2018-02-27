## app.R ##
ui <- dashboardPage(skin="black",
                    dashboardHeader(title = "CORAL"),
                    
                    dashboardSidebar
                    (
                     sidebarMenu(
                      menuItem("Visualize", tabName = "Visualize", icon = icon("eye")),
                      menuItem("Info", tabName = "Info", icon = icon("info"))
                     ),
                     collapsed = TRUE
                    ),
                    dashboardBody(
                     
                     tags$head(
                      
                      #adds the d3 library needed to draw the plot
                      tags$script(src="d3.v3.min.js"),
                      
                      #the js script holding the code to make the custom output
                      tags$script(src="circleNetwork.js"),
                      tags$script(src="collapsableForceNetwork.js"),
                      
                      #the stylesheet, paste all that was between the <style> tags from your example in the graph_style.css file
                      # tags$link(rel = "stylesheet", type = "text/css", href = "styling_layouts.css"),
                      
                      # try to resize plot according to window size
                      tags$head(tags$style("#plot1{height:100vh;}"))
                     ),
                     
                     # Fix a bug in the texboxInput funciton that doesn't respect width= "100%"
                     tags$style(HTML(".shiny-input-container:not(.shiny-input-container-inline) {width: 100%;}")),
                     
                     tabItems(
                      # First tab content
                      tabItem(tabName = "Visualize",
                              
                              fluidRow(width=12,
                                       column(width=3,
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
                                                             selectInput(inputId = "KinasesManual",label = "Kinases",choices = svginfo$dataframe$id.kinrich,multiple = TRUE,width = "100%"),
                                                             fluidRow( width=12,
                                                                       column(6,colourInput("col_select_bg", "BG Color", BG_col1,showColour = "both")),
                                                                       column(6,colourInput("col_select", "Color", HM_hi,showColour = "both"))
                                                             )
                                                            ),
                                                            
                                                            # if by group
                                                            conditionalPanel(
                                                             condition = "input.branchcolortype == 'by group'",
                                                             textAreaInput("branchGroupBox", "Kinases & Group", height = "100px",width = "100%",
                                                                           value = ""
                                                             ),
                                                             selectInput(inputId = "branchGroupIDtype",label = "Identifier Type",
                                                                         choices = c("KinrichID","uniprot","ensembl","entrez","HGNC"),
                                                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                                                            
                                                             checkboxInput(inputId="loadexamplebranchgroup",label="load kinase groups",value = FALSE)
                                                             ),
                                                            
                                                            # if by value
                                                            conditionalPanel(
                                                             condition = "input.branchcolortype == 'by value'",
                                                             textAreaInput("branchValueBox", "Kinases & Value", height = "100px",width = "100%",
                                                                           value =  ""
                                                             ),
                                                             selectInput(inputId = "branchValueIDtype",label = "Identifier Type",
                                                                         choices = c("KinrichID","uniprot","ensembl","entrez","HGNC"),
                                                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                                                             fluidRow( width=12,
                                                                       column(4,  colourInput("col_heat_low", "Low", HM_low,showColour = "both")),
                                                                       column(4,                  colourInput("col_heat_med", "Med", HM_med,showColour = "both")),
                                                                       column(4,                  colourInput("col_heat_hi", "High", HM_hi,showColour = "both"))
                                                             ) ,
                                                             fluidRow( width=12,
                                                                       column(6,                numericInput(inputId = "minheat",label = "min",value = -5 )),
                                                                       column(6,                  numericInput(inputId = "maxheat",label = "max",value =  5 ))
                                                             ),
                                                             checkboxInput(inputId="loadexamplebranchvalue",label="load example data",value = FALSE)
                                                            )
                                                        ), # end box
                                                        
                                                        # ---- NODE COLOR ---- #
                                                        
                                                        box(width=12,title = "Node Color",status = "primary", solidHeader = TRUE,
                                                            collapsible = TRUE,collapsed = TRUE,
                                                            
                                                            selectInput(inputId = "nodecolortype",label = "Color Node",
                                                                        #  choices = c("None","Same as branches","As one color","Manually","by group","by value"),
                                                                        choices = c("None","As one color","Manually","by group","by value"),
                                                                        multiple = FALSE,selected = "None",width = "100%"),
                                                            
                                                            # if single color
                                                            conditionalPanel(
                                                             condition = "input.nodecolortype == 'As one color'",
                                                             colourInput("col_node_single", "Node Color","#A3A3A3")
                                                            ),
                                                            
                                                            
                                                            conditionalPanel(
                                                             condition = "input.nodecolortype != 'As one color' & input.nodecolortype != 'None'",
                                                             checkboxInput(inputId="colorsubnodes",label="Color Intermediate Nodes?",value = TRUE)
                                                            ),
                                                            
                                                            
                                                            # if manual selection
                                                            conditionalPanel(
                                                             condition = "input.nodecolortype == 'Manually'",
                                                             selectInput(inputId = "NodeManual",label = "Kinases",choices = svginfo$dataframe$id.kinrich,multiple = TRUE,width = "100%"),
                                                             fluidRow( width=12,
                                                                       column(6,colourInput("col_node_bg", "BG Color", HM_med)),
                                                                       column(6,colourInput("col_sel_node", "Color", HM_hi))
                                                             )
                                                            ),
                                                            
                                                            # if by group
                                                            conditionalPanel(
                                                             condition = "input.nodecolortype == 'by group'",
                                                             textAreaInput("nodeGroupBox", "Kinases & Group", height = "100px",width = "100%",
                                                                           value =  ""
                                                             ),
                                                             selectInput(inputId = "nodeGroupIDtype",label = "Identifier Type",
                                                                         choices = c("KinrichID","uniprot","ensembl","entrez","HGNC"),
                                                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                                                             
                                                             checkboxInput(inputId="loadexamplennodegroup",label="load kinase groups",value = FALSE)
                                                            ),
                                                            
                                                            # if by value
                                                            conditionalPanel(
                                                             condition = "input.nodecolortype == 'by value'",
                                                             textAreaInput("nodeValueBox", "Kinases & Value", height = "100px",width = "100%",
                                                                           value =  ""
                                                             ),
                                                             selectInput(inputId = "nodeValueIDtype",label = "Identifier Type",
                                                                         choices = c("KinrichID","uniprot","ensembl","entrez","HGNC"),
                                                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                                                             fluidRow( width=12,
                                                                       column(4,  colourInput("col_node_low", "Low", HM_low,showColour = "background")),
                                                                       column(4,                  colourInput("col_node_med", "Med", HM_med,showColour = "background")),
                                                                       column(4,                  colourInput("col_node_hi", "High", HM_hi,showColour = "background"))
                                                             ) ,
                                                             fluidRow( width=12,
                                                                       column(6,                numericInput(inputId = "nodeminheat",label = "min",value = -5 )),
                                                                       column(6,                  numericInput(inputId = "nodemaxheat",label = "max",value =  5 ))
                                                             ),
                                                             checkboxInput(inputId="loadexamplennodevalue",label="load example data",value = FALSE)
                                                            )
                                                            
                                                        ), # end box   
                                                        
                                                        # ---- NODE SIZE ---- #
                                                        
                                                        box(width=12,title = "Node Size",status = "primary", solidHeader = TRUE,
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
                                                             textAreaInput("nodesizeValueBox", "Kinases & Value", height = "100px",width = "100%",
                                                                           value =  paste(paste(apply(data.frame(svginfo$dataframe$id.kinrich[CDKs],rep(5,length(CDKs))),1,paste,collapse="\t"),collapse="\n"),
                                                                                          paste(apply(data.frame(svginfo$dataframe$id.kinrich[CaMs],rep(-5,length(CaMs))),1,paste,collapse="\t"),collapse="\n"),sep="\n")
                                                             ),
                                                             selectInput(inputId = "nodesizeValueIDtype",label = "Identifier Type",
                                                                         choices = c("KinrichID","uniprot","ensembl","entrez","HGNC"),
                                                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                                                             sliderInput("nodesizeValueslider",label = "Size Range",value=c(2,5),min = 0, max = 20,step = 0.25),
                                                             
                                                             checkboxInput("Manuallysetdatarange","Manually set data range",value = FALSE),
                                                             
                                                             conditionalPanel(
                                                              condition = "input.Manuallysetdatarange == true",
                                                              
                                                              
                                                              fluidRow( width=12,
                                                                        column(6,                numericInput(inputId = "nodesizevaluemin",label = "Min Value",value = 0 )),
                                                                        column(6,                  numericInput(inputId = "nodesizevaluemax",label = "Max Value",value =  1 ))
                                                              )
                                                             ),
                                                             checkboxInput(inputId="loadexamplennodesizevalue",label="load example data",value = FALSE)
                                                            ) # end box    
                                                            ),

                                                        # fluidRow(width=12,
                                                        box(width=12,
                                                            title = tagList(shiny::icon("gear"), "advanced settings"), status = "primary", solidHeader = TRUE,
                                                            collapsible = TRUE,collapsed = TRUE,
                                                            
                                                            # text box for title
                                                            textInput(inputId="titleinput",label = 
                                                                       h4("Title",
                                                                          tags$style(type = "text/css", "#titletooltip {vertical-align: top;}"),
                                                                          bsButton("titletooltip", label = "", icon = icon("question"), style = "primary", size = "extra-small")),
                                                                      placeholder = ""),
                                                            bsTooltip(id="titletooltip",title="Provide title for top of plot (Only applies to Tree layout)",
                                                                      placement = "bottom", trigger = "hover",
                                                                      options = NULL),
                                                            
                                                            # Slider for font size 
                                                            sliderInput("fontsize", "Label Font Size",min = 0, max = 8,value = 4,step = 0.05,ticks=F),
                                                            
                                                            selectInput(inputId = "fontcolorselect",label = "Label Color",
                                                                        choices = c("Same as Branch","Single Color"),
                                                                        multiple = FALSE,selected = "Single Color",width = "100%"),
                                                            
                                                            conditionalPanel(condition = "input.fontcolorselect == 'Single Color'",
                                                                             colourInput("fontcolorchoose", "Label Color","#000000")
                                                            ),
                                                            
                                                            tags$b("Group Colors") ,
                                                            #colpalette
                                                            # Group Colors
                                                            fluidRow( width=12,
                                                                      column(width = 3,  colourInput("groupcol1", "1", defaultpalette[1],showColour = "background")),
                                                                      column(width = 3,  colourInput("groupcol2", "2", defaultpalette[2],showColour = "background")),
                                                                      column(width = 3,  colourInput("groupcol3", "3", defaultpalette[3],showColour = "background")),
                                                                      column(width = 3,  colourInput("groupcol4", "4", defaultpalette[4],showColour = "background"))
                                                            ),
                                                            
                                                            fluidRow( width=12,
                                                                      column(width = 3,  colourInput("groupcol5", "5", defaultpalette[5],showColour = "background")),
                                                                      column(width = 3,  colourInput("groupcol6", "6", defaultpalette[6],showColour = "background")),
                                                                      column(width = 3,  colourInput("groupcol7", "7", defaultpalette[7],showColour = "background")),
                                                                      column(width = 3,  colourInput("groupcol8", "8", defaultpalette[8],showColour = "background"))
                                                            ),
                                                            
                                                            fluidRow( width=12,
                                                                      column(width = 3,  colourInput("groupcol9", "9", defaultpalette[9],showColour = "background")),
                                                                      column(width = 3,  colourInput("groupcol10", "10", defaultpalette[10],showColour = "background")),
                                                                      column(width = 3,  colourInput("groupcol11", "11", defaultpalette[11],showColour = "background")),
                                                                      column(width = 3,  colourInput("groupcol12", "12", defaultpalette[12],showColour = "background"))
                                                            ) 
                                                            
                                                        ), #end box
                                                        
                                                        
                                                        # box(width=12,title = "Phosphopeptide Analysis",status = "info", solidHeader = TRUE,
                                                        #     collapsible = TRUE,collapsed = TRUE,
                                                        #     
                                                        #     fileInput(inputId="phospepcsv",
                                                        #               label = h4("Upload CSV File",
                                                        #                          tags$style(type = "text/css", "#q1 {vertical-align: top;}"),
                                                        #                          bsButton("q1", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                        #               ),
                                                        #             accept = c(
                                                        #               "text/csv",
                                                        #               "text/comma-separated-values,text/plain",
                                                        #               ".csv")
                                                        #       ),
                                                        #       checkboxInput("header", "csv file contains a header row", TRUE),
                                                        #     
                                                        #     bsTooltip(id="q1",title="Provide phosphorylation site and group info in 2 columns csv file. Column 1 should be unprot ID and site (e.g. Q01860_S236).  Column 2 should be a group classification (e.g. up, down, static, etc)",
                                                        #               placement = "bottom", trigger = "hover",
                                                        #               options = NULL),
                                                        # tags$hr(),
                                                        # 
                                                        # textAreaInput("Phospepinput", 
                                                        #               
                                                        #               label = h4("PO4 Sites & Group",
                                                        #                          tags$style(type = "text/css", "#q2 {vertical-align: top;}"),
                                                        #                          bsButton("q2", label = "", icon = icon("question"), style = "info", size = "extra-small")
                                                        #               ),
                                                        #               "PO4 Sites & Group", height = "100px",width = "100%"
                                                        # ),
                                                        # 
                                                        # bsTooltip(id="q2",title="Provide phosphorylation site and group info in 2 columns separated by a space or tab. Column 1 should be unprot ID and site (e.g. Q01860_S236).  Column 2 should be a group classification (e.g. up, down, static, etc)",
                                                        #           placement = "bottom", trigger = "hover",
                                                        #           options = NULL),
                                                        # 
                                                        # checkboxInput("load_example_po4data", "Use example data", FALSE)
                                                        #     ), # end box
                                                        
                                                        box(width=12,title = "Download",status = "warning", solidHeader = TRUE,
                                                            collapsible = TRUE,collapsed = TRUE,
                                                            
                                                            # download link for circle
                                                            conditionalPanel(
                                                             condition = "input.tabboxselected == 'Tree'",
                                                             # add select tree circle force
                                                             selectInput(inputId =  "downloadtype", label = "File Type",choices = c("pdf","svg"),selected = "pdf"),
                                                             
                                                             # download button
                                                             downloadButton("downloadData", "Download")
                                                            ),
                                                            
                                                            # download link for circle
                                                            conditionalPanel(
                                                             condition = "input.tabboxselected == 'Circle'",
                                                             
                                                             HTML("<a id=\"downloadcircle\" href=\"#\"><b>Download Circle in .svg format</b></button></a>")
                                                            ),
                                                            
                                                            # download link for force
                                                            conditionalPanel(
                                                             condition = "input.tabboxselected == 'Force'",
                                                             
                                                             HTML("<a id=\"downloadforce\" href=\"#\"><b>Download Force in .svg format</b></button></a>")
                                                            )
                                                        ) # end box
                                              ) # end row
                                              
                                       ) # end column
                                       ,
                                       
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
                      
                      # Second tab content
                      tabItem(tabName = "Info",
                              
                              source("R/info.R",local=TRUE)$value
                      )
                     )
                    ) # /tabItems
)
