## app.R ##

ui <- dashboardPage(
  dashboardHeader(title = "Kinrich"),
  dashboardSidebar
  (
    sidebarMenu(
      menuItem("Kinase Input", tabName = "KinaseInput", icon = icon("dashboard")),
      menuItem("PhosSite Input", tabName = "PhosSiteInput", icon = icon("th"))
    )
  ),
  dashboardBody(
    
    # Fix a bug in the texboxInput funciton that doesn't respect width= "100%"
    tags$style(HTML(".shiny-input-container:not(.shiny-input-container-inline) {width: 100%;}")),
    
    tabItems(
      # First tab content
      tabItem(tabName = "KinaseInput",
              
          fluidRow(width=12,
              column(width=3,
                   fluidRow( width=12,
                             
                       box(width=12,title = "Branch Color",status = "primary", solidHeader = TRUE,
                           collapsible = TRUE,collapsed = FALSE,
                           
                           selectInput(inputId = "branchcolortype",label = "Color Branch",
                                       choices = c("As one color","Manually","by group","by value"),
                                       multiple = FALSE,selected = "As one color",width = "100%"),
                           
                           # if single color
                           conditionalPanel(
                             condition = "input.branchcolortype == 'As one color'",
                             colourInput("col_branch_single", "Branch Color","#D3D3D3")
                           ),
                           
                           # if manual selection
                           conditionalPanel(
                             condition = "input.branchcolortype == 'Manually'",
                             selectInput(inputId = "KinasesManual",label = "Kinases",choices = svginfo$dataframe$id.kinrich,multiple = TRUE,width = "100%"),
                             fluidRow( width=12,
                                       column(6,colourInput("col_select_bg", "BG Color", "#D3D3D3")),
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
                                           value =  paste(paste(apply(data.frame(svginfo$dataframe$ids[CDKs],rep(5,length(CDKs))),1,paste,collapse="\t"),collapse="\n"),
                                                      paste(apply(data.frame(svginfo$dataframe$ids[CaMs],rep(-5,length(CaMs))),1,paste,collapse="\t"),collapse="\n"),sep="\n")
                             ),
                             selectInput(inputId = "branchValueIDtype",label = "Identifier Type",
                                         choices = c("KinrichID","uniprot","ensembl","entrez"),
                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                             fluidRow( width=12,
                                       column(4,  colourInput("col_heat_low", "Low", "deepskyblue2",showColour = "background")),
                                       column(4,                  colourInput("col_heat_med", "Med", "#D3D3D3",showColour = "background")),
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
                             colourInput("col_node_single", "Node Color","#D3D3D3")
                           ),
                           
                           # if manual selection
                           conditionalPanel(
                             condition = "input.nodecolortype == 'Manually'",
                             selectInput(inputId = "NodeManual",label = "Kinases",choices = svginfo$dataframe$id.kinrich,multiple = TRUE,width = "100%"),
                             fluidRow( width=12,
                                       column(6,colourInput("col_node_bg", "BG Color", "#D3D3D3")),
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
                                           value =  paste(paste(apply(data.frame(svginfo$dataframe$ids[CDKs],rep(5,length(CDKs))),1,paste,collapse="\t"),collapse="\n"),
                                                          paste(apply(data.frame(svginfo$dataframe$ids[CaMs],rep(-5,length(CaMs))),1,paste,collapse="\t"),collapse="\n"),sep="\n")
                             ),
                             selectInput(inputId = "nodeValueIDtype",label = "Identifier Type",
                                         choices = c("KinrichID","uniprot","ensembl","entrez"),
                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                             fluidRow( width=12,
                                       column(4,  colourInput("col_node_low", "Low", "deepskyblue2",showColour = "background")),
                                       column(4,                  colourInput("col_node_med", "Med", "#D3D3D3",showColour = "background")),
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
                             sliderInput("size_node_single", "Node Size",value=5,min = 0,max=20)
                           ),
                           
                           # if by value
                           conditionalPanel(
                             condition = "input.nodesizetype == 'by value'",
                             textAreaInput("nodesizeValueBox", "Kinases & Value", height = "100px",width = "100%",
                                           value =  paste(paste(apply(data.frame(svginfo$dataframe$ids[CDKs],rep(5,length(CDKs))),1,paste,collapse="\t"),collapse="\n"),
                                                          paste(apply(data.frame(svginfo$dataframe$ids[CaMs],rep(-5,length(CaMs))),1,paste,collapse="\t"),collapse="\n"),sep="\n")
                             ),
                             selectInput(inputId = "nodesizeValueIDtype",label = "Identifier Type",
                                         choices = c("KinrichID","uniprot","ensembl","entrez"),
                                         multiple = FALSE,selected = "KinrichID",width = "100%"),
                             sliderInput("nodesizeValueslider",label = "Size Range",value=c(0,5),min = 0, max = 20)
                           )
                       ) # end box    
                   ), # end row   
              
              #end row
              fluidRow(width=12,
                       box(width=12,
                           title = tagList(shiny::icon("gear"), "advanced settings"), status = "primary", solidHeader = TRUE,
                           collapsible = TRUE,collapsed = TRUE,
                           # Slider for font size 
                           sliderInput("fontsize", "Fontsize",min = 0, max = 8,value = 3.25,step = 0.05,ticks=F),
                           
                           # Color the text?
                           checkboxInput(inputId="colortextcheckbox",value = TRUE,label = "Color Text"),
                           
                           #colpalette
                           # Group Colors
                           fluidRow( width=12,
                                     column(2,  colourInput("groupcol1", "1", colpalette[1],showColour = "background")),
                                     column(2,  colourInput("groupcol2", "2", colpalette[2],showColour = "background")),
                                     column(2,  colourInput("groupcol3", "3", colpalette[3],showColour = "background")),
                                     column(2,  colourInput("groupcol4", "4", colpalette[4],showColour = "background")),
                                     column(2,  colourInput("groupcol5", "5", colpalette[5],showColour = "background")),
                                     column(2,  colourInput("groupcol6", "6", colpalette[6],showColour = "background"))
                           ),
                           
                           fluidRow( width=12,
                                     column(2,  colourInput("groupcol7", "7", colpalette[7],showColour = "background")),
                                     column(2,  colourInput("groupcol8", "8", colpalette[8],showColour = "background")),
                                     column(2,  colourInput("groupcol9", "9", colpalette[9],showColour = "background")),
                                     column(2,  colourInput("groupcol10", "10", colpalette[10],showColour = "background")),
                                     column(2,  colourInput("groupcol11", "11", colpalette[11],showColour = "background")),
                                     column(2,  colourInput("groupcol12", "12", colpalette[12],showColour = "background"))
                           ) 

                       ) #end box
                  ) # end row
              ) # end column
                       ,
                       
                       tabBox
                       ( width=9,height="600px",
                         tabPanel
                         ("Manning",
                           width=12,
                           svgPanZoomOutput('plot1',height="550px")
                         ),
                         tabPanel
                         ("Force",
                           width=12
                           # forceNetworkOutput('plot2',height = "450px")
                         ),
                         tabPanel
                         ("Circle",
                           width=12
                           # radialNetworkOutput('plot3',height = "450px")
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


