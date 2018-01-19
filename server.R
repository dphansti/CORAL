
# server business
server <- function(input, output) {
  
  newdf <- reactive({ 
    
    # get current values
    tempdf = svginfo$dataframe
    
    legend = c()
    
    # default palette for group colors
    colpalette = c( input$groupcol1,input$groupcol2,input$groupcol3,input$groupcol4,input$groupcol5,input$groupcol6,
                    input$groupcol7,input$groupcol8,input$groupcol9,input$groupcol10,input$groupcol11,input$groupcol12)
    
    
    # get current values
    tempdf$text.size = input$fontsize
    
    # Single branch color
    if (input$branchcolortype == "As one color")
    {
      tempdf$branch.col = input$col_branch_single
    }
    
    # Manually select branches to color
    if (input$branchcolortype == "Manually")
    {
      # set colors based on selected ids 
      tempdf$branch.col =  color.by.selected(df = tempdf, sel = input$KinasesManual, bg.col  = input$col_select_bg,  sel.col = input$col_select)
      
      # reorder based on selected ids
      tempdf = tempdf[order(tempdf$id.kinrich %in% input$KinasesManual, decreasing = FALSE),]
    
      # yoffset = 79.125
      # 
      # legend = c(legend,
      #                   "<g>",
      #                   "<text x=\"98.8075\" y=\"87.9701\" font-family=\"'AvenirNext-Bold'\" font-size=\"9px\">Branch Color</text>",
      #                    "</g>"
      # )
      # 
      # 
      # ytop - 89.807
      # legend = c(legend,
      #            
      #            
      #            
      #            
      #            # solid bar on left
      #            "<rect x=\"89.807\" y=\"79.125\" fill=\"#D3D3D3\" width=\"2.333\" height=\"113.451\"/>",
      #            
      #             paste("<rect x=\"99.208\" y=\"105.635\" fill=\"",input$col_select_bg,"\" width=\"6.584\" height=\"6.584\"/>",sep=""),
      #             "<text x=\"110.8889\" y=\"102.2501\" font-family=\"'AvenirNext-Bold'\" font-size=\"5px\">All</text>"
      #            
      #            
      #   # 
      #   # <rect x="99.208" y="226.848" fill="#2A97D3" width="6.584" height="6.584"/>
      #   # <text transform="matrix(1 0 0 1 110.8889 218.2256)" font-family="'AvenirNext-Bold'" font-size="5px">TK</text>
      #   # <text transform="matrix(1 0 0 1 110.8889 231.8603)" font-family="'AvenirNext-Bold'" font-size="5px">TKL</text>
      # )
      
    }
    
    # color branches by group
    if (input$branchcolortype == "by group")
    {
      # read in text area input
      recolordf = read.text.input(input$branchGroupBox)
      
      # convert to coral id
      recolordf = convertID (tempdf,recolordf,inputtype=input$branchGroupIDtype)
      
      if (nrow(recolordf)>0)
      {
        # set colors based on group
        newcolors_and_colormapping = color.by.group(df = tempdf, recolordf = recolordf, colors  = colpalette)
        tempdf$branch.col = newcolors_and_colormapping[[1]]
        tempdf$branch.group = newcolors_and_colormapping[[2]]
        branch.group.colormapping = newcolors_and_colormapping[[3]]
        
        # reorder based on branch color 
        tempdf = tempdf[order(tempdf$branch.group),]
      }
    }
    
    # color branches by value
    if (input$branchcolortype == "by value")
    {
      # read in text area input
      recolordf = read.text.input(input$branchValueBox)

      # convert to coral id
      recolordf = convertID (tempdf,recolordf,inputtype=input$branchValueIDtype)

      if (nrow(recolordf)>0)
      {
        # establish palette
        branchcolpalette = colorRampPalette(c(input$col_heat_low, input$col_heat_med, input$col_heat_hi))(100)

        # set colors based on group
        newcolors_and_colormapping = color.by.value(df = tempdf, recolordf = recolordf, colors  = branchcolpalette, heatrange = c(input$minheat,input$maxheat))
        tempdf$branch.col = newcolors_and_colormapping[[1]]
        tempdf$branch.val = newcolors_and_colormapping[[2]]

        # reorder based on branch color
        tempdf = tempdf[order(abs(tempdf$branch.val), decreasing = FALSE,na.last = FALSE),]
      }
    }
    
    # ------------------ NODE COLOR ------------------ #
    
    # color nodes by single color
    if (input$nodecolortype == "None")
    {
      tempdf$node.col = "none"
    }
    
    # color nodes by single color
    if (input$nodecolortype == "As one color")
    {
      tempdf$node.col = input$col_node_single
    }
    
    if (input$nodecolortype == "Same as branches")
    {
      tempdf$node.col = tempdf$branch.col
    }
    
    # Manually select nodes to color
    if (input$nodecolortype == "Manually")
    {
      # set colors based on selected ids (!!!! write function !!!!)
      tempdf$node.col =  color.by.selected(df = tempdf, sel = input$NodeManual, bg.col  = input$col_node_bg,  sel.col = input$col_sel_node)
    }
    
    # color branches by group
    if (input$nodecolortype == "by group")
    {
      # read in text area input
      recolordf = read.text.input(input$nodeGroupBox)
      
      # convert to coral id
      recolordf = convertID (tempdf,recolordf,inputtype=input$nodeGroupIDtype)
      
      if (nrow(recolordf)>0)
      {
        # set colors based on group
        newcolors_and_colormapping = color.by.group(df = tempdf, recolordf = recolordf, colors  = colpalette)
        tempdf$node.col = newcolors_and_colormapping[[1]]
        tempdf$node.group = newcolors_and_colormapping[[2]]
        node.group.colormapping = newcolors_and_colormapping[[3]]
      }
    }
    
    # color nodes by value
    if (input$nodecolortype == "by value")
    {
      # read in text area input
      recolordf = read.text.input(input$branchValueBox)
      
      # convert to coral id
      recolordf = convertID (tempdf,recolordf,inputtype=input$branchValueIDtype)
      
      if (nrow(recolordf)>0)
      {
        # establish palette
        nodecolpalette = colorRampPalette(c(input$col_node_low, input$col_node_med, input$col_node_hi))(100)
        
        # establish palette
        colpalette = colorRampPalette(c(input$col_node_low, input$col_node_med, input$col_node_hi))(100)
        
        # set colors based on group
        newcolors_and_colormapping = color.by.value(df = tempdf, recolordf = recolordf, colors  = colpalette, heatrange = c(input$nodeminheat,input$nodemaxheat))
        tempdf$node.col = newcolors_and_colormapping[[1]]
        tempdf$node.val = newcolors_and_colormapping[[2]]
        
        # reorder based on branch color
        tempdf = tempdf[order(abs(tempdf$node.val), decreasing = FALSE,na.last = FALSE),]
      }
    }
    
    # ------------------ NODE SIZE ------------------ #
    
    # color nodes by single color
    if (input$nodesizetype == "One Size")
    {
      tempdf$node.radius = input$size_node_single
    }
    
    # color nodes by single color
    if (input$nodesizetype == "by value")
    {
      # read in text area input
      resizedf = read.text.input(input$nodesizeValueBox)
      
      # convert to coral id
      resizedf = convertID (tempdf,resizedf,inputtype=input$nodesizeValueIDtype)

      if (nrow(resizedf)>0)
      {
        radii_and_mapping = resizes.by.value(df = tempdf, resizedf = resizedf, sizerange = input$nodesizeValueslider)
        
        tempdf$node.radius     = radii_and_mapping[[1]]
        tempdf$node.val.radius = radii_and_mapping[[2]]
      }
    }
    
    # ------------------ ADVANCED OPTIONS ------------------ #
  
    # text color
    if (input$fontcolorselect == "Same as Branch")
    {
      tempdf$text.col = tempdf$branch.col
    }
    if (input$fontcolorselect == "Single Color")
    {
      tempdf$text.col = input$fontcolorchoose
    }
    
    
    return(list(tempdf,legend))
    }) # end reactive
  
  
  # build the manning tree
  output$plot1  <- renderSvgPanZoom ({
      
      # recolor the official matrix
      dfandlegend = newdf()
      svginfo$dataframe = dfandlegend[[1]]
      svginfo$legend = dfandlegend[[2]]

      # Write SVG file
      outfile <- "Output/kintreeout.svg"
      writekinasetree(svginfo,destination=outfile)
      svgPanZoom(outfile,viewBox = F,controlIconsEnabled=F)
    })


  # build the table
  output$KinaseTable <- DT::renderDataTable({
    
    simpldf = newdf()[,c("id.kinrich","kinase.family","kinase.group","branch.val","branch.col")] 
    
    # reverse the data frame so that colored kinases appear first
    simpldf<-simpldf[dim(simpldf)[1]:1,]
    
    # add a column of squares
    simpldf$thecolor = 	"&#9608;"	
   
    # convert colors to rgb
    mycolors <- simpldf$branch.col
    rgbcolors <- apply(grDevices::col2rgb(mycolors), 2, 
                       function(rgb) sprintf("rgb(%s)", paste(rgb, collapse=",")))
    
    
    tgt <- sprintf('<span style="color:%s">&#9608;</span>', rgbcolors)
    
    newdf = data.frame(kinase=simpldf$id.kinrich,
                       family=simpldf$kinase.family,
                       group =simpldf$kinase.group,
                       values=simpldf$branch.val,
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

