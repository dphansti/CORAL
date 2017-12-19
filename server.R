
# server business
server <- function(input, output) {
  
  newdf <- reactive({ 
    
    # get current values
    tempdf = svginfo$dataframe
    
    # collect group cols
    allgroupcols = c(input$groupcol1,input$groupcol2,input$groupcol3,input$groupcol4,input$groupcol5,input$groupcol6,
                     input$groupcol7,input$groupcol8,input$groupcol9,input$groupcol10,input$groupcol11,input$groupcol12)
    
    
    # Single branch color
    if (input$branchcolortype == "As one color")
    {
      tempdf$col_line = input$col_branch_single
    }
    
    # Manually select branches to color
    if (input$branchcolortype == "Manually")
    {
      tempdf$col_line = input$col_select_bg
      
      # extract user info
      selectedkinases = input$KinasesManual
      
      if (length(selectedkinases) > 0)
      {
        # make a data frame of all kinases and values
        recolordf = data.frame(ids = selectedkinases,values=rep(1,length(selectedkinases)),stringsAsFactors = F)
        recolordf$values = as.numeric(recolordf$values)
        
        # establish palette
        pal = colorRampPalette(c(input$col_select_bg, input$col_select))(100)
        
        # recolor/order tree
        tempdf = recolortreebynumber(tempdf, recolordf,pal)
      }
    }
    
    # color branches by group
    if (input$branchcolortype == "by group")
    {

    }
    
    # color branches by value
    if (input$branchcolortype == "by value")
    {
      # split into data frame of kinase and value
      data = unlist(strsplit(input$branchValueBox,"\n"))
      
      if  (length(data) > 0){
        
        # extract user info
        recolordf = data.frame(matrix(unlist(strsplit(x=data,split="\\s+")),ncol=2,byrow = T),stringsAsFactors = F)
        colnames(recolordf) = c("ids","values")
        recolordf$values = as.numeric(recolordf$values)
        
        # convert names
        if (input$branchValueIDtype != "KinrichID")
        {
          recolordf = convertID(df=tempdf,recolordf=recolordf,inputtype = input$branchValueIDtype)
        }
        
        if  (nrow(recolordf) > 0)
        {
          # establish palette
          pal = colorRampPalette(c(input$col_heat_low, input$col_heat_med, input$col_heat_hi))(100)
          
          # recolor/order tree
          tempdf = recolortreebynumber(tempdf, recolordf,pal,heatrange = c(input$minheat,input$maxheat),objecttorecolor="branch")
        }
      }
    }
    
    # ------------------ NODE COLOR ------------------ #
    
    # color nodes by single color
    if (input$nodecolortype == "As one color")
    {
      tempdf$nodecol = input$col_node_single
    }
    
    # color branches by value
    if (input$nodecolortype == "by value")
    {
      # split into data frame of kinase and value
      data = unlist(strsplit(input$nodeValueBox,"\n"))
      
      if  (length(data) > 0){
        # extract user info
        recolordf = data.frame(matrix(unlist(strsplit(x=data,split="\\s+")),ncol=2,byrow = T),stringsAsFactors = F)
        colnames(recolordf) = c("ids","values")
        recolordf$values = as.numeric(recolordf$values)
        
        # convert names
        if (input$nodeValueIDtype != "KinrichID")
        {
          recolordf = convertID(df=tempdf,recolordf=recolordf,inputtype = input$nodeValueIDtype)
        }
        
        if  (nrow(recolordf) > 0)
        {
          # establish palette
          pal = colorRampPalette(c(input$col_node_low, input$col_node_med, input$col_node_hi))(100)
          
          # recolor/order tree
          tempdf = recolortreebynumber(tempdf, recolordf,pal,heatrange = c(input$minheat,input$maxheat),objecttorecolor="node")
        }
      }
    }
    
    # ------------------ NODE SIZE ------------------ #
    
    # color nodes by single color
    if (input$nodesizetype == "One Size")
    {
      tempdf$noderad = input$size_node_single
    }
  
    return(tempdf)
    }) # end reactive
  
  
  
  
  output$plot1  <- renderSvgPanZoom ({
      # recolor the official matrix
      svginfo$dataframe = newdf()
    
      # font size
      svginfo$dataframe$fontsize_text = paste(input$fontsize,"px",sep="")
      
      # should the text be colored
      svginfo$colortext = input$colortextcheckbox

      showcircles = TRUE
      if (input$nodecolortype == 'None')
      {
        showcircles = FALSE
      }
      
      # Write SVG file
      outfile <- "Output/kintreeout.svg"
      writekinasetree(svginfo,destination=outfile,showcircles)
      svgPanZoom(outfile,viewBox = F,controlIconsEnabled=F)
    })


  # output$plot2  <- renderForceNetwork ({
    # code to make force
    # recolor the official matrix
    # svginfo$dataframe = v$newdf
    # 
    # # font size
    # svginfo$dataframe$fontsize_text = paste(input$fontsize,"px",sep="")
    # 
    # force_kinome_tree(svginfo$dataframe)
  # })
  

  
  # output$plot3   <- renderRadialNetwork ({
  #   # code to make radial
  # 
  #   # recolor the official matrix
  #   svginfo$dataframe = v$newdf
  # 
  #   # font size
  #   svginfo$dataframe$fontsize_text = paste(input$fontsize,"px",sep="")
  # 
  #   #using adaptation of networkD3's radialNetwork (more interactivity but limited parameters):
  #   #library(radialNetworkR)
  #   
  #   withProgress(list_kinome_tree(svginfo$dataframe),message = "Loading RadialNetwork layout...",style = "old",value = 0.5)
  #   
  #   #Another example with untested parameters:
  #   #radialNetwork(ToListExplicit(Data_tree(), unname = TRUE ), linkColour = "#ccc",nodeColour = "#fff",nodeStroke = "orange",textColour = "#cccccc")
  # })
  
  output$KinaseTable <- DT::renderDataTable({
    
    simpldf = newdf()[,c("ids","family","group","values","col_line")] 
    
    # revers the data frame so that colored kinases appear first
    simpldf<-simpldf[dim(simpldf)[1]:1,]
    
    # add a column of squares
    simpldf$thecolor = 	"&#9608;"	
   
    # convert colors to rgb
    mycolors <- simpldf$col_line
    rgbcolors <- apply(grDevices::col2rgb(mycolors), 2, 
                       function(rgb) sprintf("rgb(%s)", paste(rgb, collapse=",")))
    
    
    tgt <- sprintf('<span style="color:%s">&#9608;</span>', rgbcolors)
    
    newdf = data.frame(kinase=simpldf$ids,
                       family=simpldf$family,
                       group =simpldf$group,
                       values=simpldf$values,
                       color=tgt)

    datatable(newdf, escape=FALSE)

  })
  
  
  output$branchbygroups <- renderUI({
    thesegroups <- table(output$tableinput$select$c[2])
    checkboxGroupInput("branchbygroupsgroups", "Choose Groups", thesegroups)
  })
  
  
  output$tableinput <- renderRHandsontable({
    rhandsontable(DF,stretchH = "all")
  })
  
}
