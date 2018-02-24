
# server business
server <- function(input, output) {
  
  outputjson <- "www/kinome_tree.json"
  subdffile  <-  "tempfiles/subdf.txt"
  svgoutfile <- "tempfiles/kintreeout.svg"
  
  newdf <- reactive({ 
    
    # get current values
    tempdf = svginfo$dataframe
    
    # establish legend
    legend = c()
    # Set initial yoffset
    yoffset = 79.125
    
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
      
      # build legend for Branch Color (by group)
      lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=c("not selected","selected"),groupcolors=c(input$col_select_bg,input$col_select),elementtype = "Branch")
      lines = lines_and_offset[[1]]
      yoffset = lines_and_offset[[2]] + 14
      
      legend = c(legend,lines)
      
    }
    
    # color branches by group
    if (input$branchcolortype == "by group")
    {
      # read in text area input
      recolordf = read.text.input(input$branchGroupBox)
      
      # convert to coral id
      # print (paste("asdfadsfadsf = ",input$branchGroupIDtype))
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
        
        # build legend for Branch Color (by group)
        lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=names(branch.group.colormapping),groupcolors=branch.group.colormapping,elementtype = "Branch")
        lines = lines_and_offset[[1]]
        yoffset = lines_and_offset[[2]] + 14
        legend = c(legend,lines)
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
        
        # add legend info
        lines_and_offset = build.value.legend(yoffset=yoffset,minval=input$minheat,maxval=input$maxheat, palette=branchcolpalette,elementtype = "Branch")
        lines = lines_and_offset[[1]]
        yoffset = lines_and_offset[[2]] + 14
        legend = c(legend,lines)
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
      # set colors based on selected ids
      tempdf$node.col =  color.by.selected(df = tempdf, sel = input$NodeManual, bg.col  = input$col_node_bg,  sel.col = input$col_sel_node)
      
      # # build legend for Node Color (by group)
      lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=c("not selected","selected"),groupcolors=c(input$col_node_bg,input$col_sel_node),elementtype = "Node")
      lines = lines_and_offset[[1]]
      yoffset = lines_and_offset[[2]] + 14
      legend = c(legend,lines)
    }
    
    # color nodes by group
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
        
        # build legend for Branch Color (by group)
        lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=names(node.group.colormapping),groupcolors=node.group.colormapping,elementtype = "Node")
        lines = lines_and_offset[[1]]
        yoffset = lines_and_offset[[2]] + 14
        legend = c(legend,lines)
      }
    }
    
    # color nodes by value
    if (input$nodecolortype == "by value")
    {
      # read in text area input
      recolordf = read.text.input(input$nodeValueBox)
      
      # convert to coral id
      recolordf = convertID (tempdf,recolordf,inputtype=input$nodeValueIDtype)
      
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
        
        # add legend info
        lines_and_offset = build.value.legend(yoffset=yoffset,minval=input$nodeminheat,maxval=input$nodemaxheat, palette=nodecolpalette,elementtype = "Node")
        lines = lines_and_offset[[1]]
        yoffset = lines_and_offset[[2]] + 14
        legend = c(legend,lines)
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
        
        radii_and_mapping = resizes.by.value(df = tempdf, resizedf = resizedf, sizerange = input$nodesizeValueslider,
                                             controlledrange = input$Manuallysetdatarange, minvalue=input$nodesizevaluemin, maxvalue = input$nodesizevaluemax)

        tempdf$node.radius     = radii_and_mapping[[1]]
        tempdf$node.val.radius = radii_and_mapping[[2]]
        
        # add legend info
        lines_and_offset = build.nodesize.legend (yoffset=yoffset,minval=min(as.numeric(resizedf[,2])),maxval=max(as.numeric(resizedf[,2])),minsize = input$nodesizeValueslider[1] ,maxsize = input$nodesizeValueslider[2])
        lines = lines_and_offset[[1]]
        yoffset = lines_and_offset[[2]] + 14
        legend = c(legend,lines)
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
    
    # set title
    svginfo$title = input$titleinput
    
    # Write SVG file
    writekinasetree(svginfo,destination=svgoutfile)
    svgPanZoom(svgoutfile,viewBox = F,controlIconsEnabled=F)
  })
  
  
  #output to the graph div
  output$forcelayout <- reactive({
    
    # recolor the official matrix
    dfandlegend = newdf()
    svginfo$dataframe = dfandlegend[[1]]
    
    # replace none color for D3 plots
    allnodescoloreddf =  svginfo$dataframe
    allnodescoloreddf$node.col[which(allnodescoloreddf$node.col == "none")] = "#D3D3D3"
    
    # Write kinome_tree.json (based on current dataframe)
    makejson(allnodescoloreddf,tmp=subdffile,output=outputjson)
    
    # Make this reactive to any change in input paramters
    x <- reactiveValuesToList(input)
  })
  
  #output to the graph div
  output$diaglayout <- reactive({
    # recolor the official matrix
    dfandlegend = newdf()
    svginfo$dataframe = dfandlegend[[1]]
    
    # replace none color for D3 plots
    allnodescoloreddf =  svginfo$dataframe
    allnodescoloreddf$node.col[which(allnodescoloreddf$node.col == "none")] = "#D3D3D3"
    
    # Write kinome_tree.json (based on current dataframe)
    makejson(allnodescoloreddf,tmp="www/subdf.txt",output=outputjson)
    
    # Make this reactive to any change in input paramters
    x <- reactiveValuesToList(input)
  })
  
  #output to the graph div
  output$circlelayout <- reactive({
    # recolor the official matrix
    dfandlegend = newdf()
    svginfo$dataframe = dfandlegend[[1]]
    
    # replace none color for D3 plots
    allnodescoloreddf =  svginfo$dataframe
    allnodescoloreddf$node.col[which(allnodescoloreddf$node.col == "none")] = "#D3D3D3"
    
    # Write kinome_tree.json (based on current dataframe)
    makejson(allnodescoloreddf,tmp=subdffile,output=outputjson)
    
    # Make this reactive to any change in input paramters
    x <- reactiveValuesToList(input)
  })
  
  # build the table
  output$KinaseTable <- DT::renderDataTable({
    
    dfandlegend = newdf()
    simpldf = dfandlegend[[1]][,c("id.kinrich","id.longname","kinase.family","kinase.group","branch.val","branch.col","node.col","node.radius")] 
    
    # reverse the data frame so that colored kinases appear first
    simpldf<-simpldf[dim(simpldf)[1]:1,]
    
    # convert branch colors to rgb
    mycolors <- simpldf$branch.col
    rgbcolors <- apply(grDevices::col2rgb(mycolors), 2, 
                       function(rgb) sprintf("rgb(%s)", paste(rgb, collapse=",")))
    tgtbranch <- sprintf('<span style="color:%s">&#9608;</span>', rgbcolors)
    
    newdf = data.frame(kinase=simpldf$id.kinrich,
                       name=simpldf$id.longname,
                       family=simpldf$kinase.family,
                       group = simpldf$kinase.group
    )
    
    # add node info if present
    if ("none" %in% simpldf$node.col == F)
    {
      # convert node colors to rgb
      mycolors <- simpldf$node.col
      
      rgbcolors <- apply(grDevices::col2rgb(mycolors), 2, 
                         function(rgb) sprintf("rgb(%s)", paste(rgb, collapse=",")))
      tgtnode <- sprintf('<span style="color:%s">&#11044;</span>', rgbcolors)
      
      newdf$node_radius = simpldf$node.radius
      newdf$node_color = tgtnode
    }
    
    # add branch color
    newdf$branch_color=tgtbranch
    
    datatable(newdf, escape=FALSE)
  })
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    
    filename <- function(file) { paste("CORAL",".","tree",".",input$downloadtype,sep="")},
    content <- function(file) {
      if (input$downloadtype == 'pdf') {
        rsvg_pdf(svgoutfile, file)
      } else if (input$downloadtype == 'svg') {
        rsvg_svg(svgoutfile, file)
      } else {
        showNotification('Unrecognized Output Image Type')
      }
    }
  )
  
}