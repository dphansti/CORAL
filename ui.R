## app.R ##

ui <- dashboardPage(
  dashboardHeader(title = "CORAL"),
  dashboardSidebar
  (
    sidebarMenu(
      menuItem("Kinase Input", tabName = "KinaseInput", icon = icon("dashboard")),
      menuItem("PhosSite Input", tabName = "PhosSiteInput", icon = icon("th"))
    )
  ),
  dashboardBody(
    
    tags$head(
      #adds the d3 library needed to draw the plot
      tags$script(src="d3.v3.min.js"),
      
      #the js script holding the code to make the custom output
      tags$script(src="circleNetwork.js"),
      tags$script(src="collapsableDiagonalNetwork.js"),
      tags$script(src="collapsableForceNetwork.js"),
      
      #the stylesheet, paste all that was between the <style> tags from your example in the graph_style.css file
      tags$link(rel = "stylesheet", type = "text/css", href = "styling_layouts.css")
    ),
    
    # Fix a bug in the texboxInput funciton that doesn't respect width= "100%"
    tags$style(HTML(".shiny-input-container:not(.shiny-input-container-inline) {width: 100%;}")),
    
    tabItems(
      # First tab content
      tabItem(tabName = "KinaseInput",
              
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
                             colourInput("col_branch_single", "Branch Color","#A3A3A3")
                           ),
                           
                           # if manual selection
                           conditionalPanel(
                             condition = "input.branchcolortype == 'Manually'",
                             selectInput(inputId = "KinasesManual",label = "Kinases",choices = svginfo$dataframe$id.kinrich,multiple = TRUE,width = "100%"),
                             fluidRow( width=12,
                                       column(6,colourInput("col_select_bg", "BG Color", "#A3A3A3")),
                                       column(6,colourInput("col_select", "Color", "#2C54F5"))
                             )
                           ),
                           
                           # if by group
                           conditionalPanel(
                             condition = "input.branchcolortype == 'by group'",
                             textAreaInput("branchGroupBox", "Kinases & Group", height = "100px",width = "100%",
                             value =  paste(apply(data.frame(svginfo$dataframe$id.kinrich,svginfo$dataframe$kinase.group),1,paste,collapse="\t"),collapse="\n")
                             ),
                             selectInput(inputId = "branchGroupIDtype",label = "Identifier Type",
                                         choices = c("KinrichID","uniprot","ensembl","entrez"),
                                         multiple = FALSE,selected = "KinrichID",width = "100%")
                           ),
                           
                           # if by value
                           conditionalPanel(
                             condition = "input.branchcolortype == 'by value'",
                             textAreaInput("branchValueBox", "Kinases & Value", height = "100px",width = "100%",
                                           value =  paste(paste(apply(data.frame(svginfo$dataframe$id.kinrich[CDKs],rep(5,length(CDKs))),1,paste,collapse="\t"),collapse="\n"),
                                                      paste(apply(data.frame(svginfo$dataframe$id.kinrich[CaMs],rep(-5,length(CaMs))),1,paste,collapse="\t"),collapse="\n"),sep="\n")
                             ),
                             selectInput(inputId = "branchValueIDtype",label = "Identifier Type",
                                         choices = c("KinrichID","uniprot","ensembl","entrez"),
                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                             fluidRow( width=12,
                                       column(4,  colourInput("col_heat_low", "Low", "deepskyblue2",showColour = "background")),
                                       column(4,                  colourInput("col_heat_med", "Med", "#A3A3A3",showColour = "background")),
                                       column(4,                  colourInput("col_heat_hi", "High", "gold",showColour = "background"))
                             ) ,
                             fluidRow( width=12,
                                       column(6,                numericInput(inputId = "minheat",label = "min",value = -5 )),
                                       column(6,                  numericInput(inputId = "maxheat",label = "max",value =  5 ))
                             )
                           )
                       ), # end box
                       
                       # ---- NODE COLOR ---- #
                       
                       box(width=12,title = "Node Color",status = "primary", solidHeader = TRUE,
                           collapsible = TRUE,collapsed = TRUE,
                           
                           selectInput(inputId = "nodecolortype",label = "Color Node",
                                       choices = c("None","Same as branches","As one color","Manually","by group","by value"),
                                       multiple = FALSE,selected = "None",width = "100%"),
                           
                           # if single color
                           conditionalPanel(
                             condition = "input.nodecolortype == 'As one color'",
                             colourInput("col_node_single", "Node Color","#A3A3A3")
                           ),
                           
                           # if manual selection
                           conditionalPanel(
                             condition = "input.nodecolortype == 'Manually'",
                             selectInput(inputId = "NodeManual",label = "Kinases",choices = svginfo$dataframe$id.kinrich,multiple = TRUE,width = "100%"),
                             fluidRow( width=12,
                                       column(6,colourInput("col_node_bg", "BG Color", "#A3A3A3")),
                                       column(6,colourInput("col_sel_node", "Color", "#2C54F5"))
                             )
                           ),
                           
                           # if by group
                           conditionalPanel(
                             condition = "input.nodecolortype == 'by group'",
                             textAreaInput("nodeGroupBox", "Kinases & Group", height = "100px",width = "100%",
                                           value =  paste(apply(data.frame(svginfo$dataframe$id.kinrich,svginfo$dataframe$kinase.group),1,paste,collapse="\t"),collapse="\n")
                             ),
                             selectInput(inputId = "nodeGroupIDtype",label = "Identifier Type",
                                         choices = c("KinrichID","uniprot","ensembl","entrez"),
                                         multiple = FALSE,selected = "KinrichID",width = "100%")
                           ),
                           
                           # if by value
                           conditionalPanel(
                             condition = "input.nodecolortype == 'by value'",
                             textAreaInput("nodeValueBox", "Kinases & Value", height = "100px",width = "100%",
                                           value =  paste(paste(apply(data.frame(svginfo$dataframe$id.kinrich[CDKs],rep(5,length(CDKs))),1,paste,collapse="\t"),collapse="\n"),
                                                          paste(apply(data.frame(svginfo$dataframe$id.kinrich[CaMs],rep(-5,length(CaMs))),1,paste,collapse="\t"),collapse="\n"),sep="\n")
                             ),
                             selectInput(inputId = "nodeValueIDtype",label = "Identifier Type",
                                         choices = c("KinrichID","uniprot","ensembl","entrez"),
                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                             fluidRow( width=12,
                                       column(4,  colourInput("col_node_low", "Low", "deepskyblue2",showColour = "background")),
                                       column(4,                  colourInput("col_node_med", "Med", "#A3A3A3",showColour = "background")),
                                       column(4,                  colourInput("col_node_hi", "High", "gold",showColour = "background"))
                             ) ,
                             fluidRow( width=12,
                                       column(6,                numericInput(inputId = "nodeminheat",label = "min",value = -5 )),
                                       column(6,                  numericInput(inputId = "nodemaxheat",label = "max",value =  5 ))
                             )
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
                             sliderInput("size_node_single", "Node Size",value=4,min = 0,max=10)
                           ),
                           
                           # if by value
                           conditionalPanel(
                             condition = "input.nodesizetype == 'by value'",
                             textAreaInput("nodesizeValueBox", "Kinases & Value", height = "100px",width = "100%",
                                           value =  paste(paste(apply(data.frame(svginfo$dataframe$id.kinrich[CDKs],rep(5,length(CDKs))),1,paste,collapse="\t"),collapse="\n"),
                                                          paste(apply(data.frame(svginfo$dataframe$id.kinrich[CaMs],rep(-5,length(CaMs))),1,paste,collapse="\t"),collapse="\n"),sep="\n")
                             ),
                             selectInput(inputId = "nodesizeValueIDtype",label = "Identifier Type",
                                         choices = c("KinrichID","uniprot","ensembl","entrez"),
                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                             sliderInput("nodesizeValueslider",label = "Size Range",value=c(2,5),min = 0, max = 10)
                           )
                       ) # end box    
                   ), # end row   
              
              #end row
              fluidRow(width=12,
                       box(width=12,
                           title = tagList(shiny::icon("gear"), "advanced settings"), status = "primary", solidHeader = TRUE,
                           collapsible = TRUE,collapsed = TRUE,
                           # Slider for font size 
                           sliderInput("fontsize", "Label Font Size",min = 0, max = 8,value = 3.25,step = 0.05,ticks=F),
                           
                           selectInput(inputId = "fontcolorselect",label = "Label Color",
                                       choices = c("Same as Branch","Single Color"),
                                       multiple = FALSE,selected = "Same as Branch",width = "100%"),
                           
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

                       ) #end box
                  ) # end row
              ) # end column
                       ,
                       
                       tabBox
                       ( width=9,height="1200px",
                         tabPanel
                         ("Manning",
                           width=12,
                           svgPanZoomOutput('plot1',height="1060px")
                         ),
                         tabPanel
                         ("Radial Cluster Dendrogram",
                           width=12,
                           shinyjs::useShinyjs(),
                           shinyjs::hidden(
                             selectInput("data_files", "JSON files:" ,  as.matrix(list.files(path="www",pattern="json")))),
                           #this div will hold the final graph
                           div(id="circlelayout", class="circleNetwork")
                           # actionButton(inputId = "button", label = "show / hide")
                         ),
                         
                         tabPanel
                         ("Collapsable Force Network",
                           width=12,
                           shinyjs::useShinyjs(),
                           shinyjs::hidden(
                             selectInput("data_files", "JSON files:" ,  as.matrix(list.files(path="www",pattern="json")))),
                           #this div will hold the final graph
                           div(id="forcelayout", class="collapsableForceNetwork")
                           
                         ),
                         
                         tabPanel
                         ("Collapsable Diagonal Network",
                           width=12,
                           shinyjs::useShinyjs(),
                           shinyjs::hidden(
                             selectInput("data_files", "JSON files:" ,  as.matrix(list.files(path="www",pattern="json")))),
                           #this div will hold the final graph
                           div(id="diaglayout", class="collapsableDiagonalNetwork")
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
      tabItem(tabName = "PhosSiteInput",
              h2("PhosSite Input")
      )
    )
    
    ) # /tabItems
    )


