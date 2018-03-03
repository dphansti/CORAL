
# server business
server <- function(input, output,session) {
 
 # ----------------- INFO PAGES ---------------- #
 
 observeEvent(input$InfoAbout,{
  
  # Remove existing info boxes
  removeUI(
   selector = "#InfoBoxAbout")
  removeUI(
   selector = "#InfoBoxUsage")
  removeUI(
   selector = "#InfoBoxOther")
  
  # Add appropriate info box
  insertUI(
   selector = "#InfoBox",
   where = "afterEnd",
   ui = source("R/InfoAbout.R",local=TRUE)$value
  )
 })
 
 observeEvent(input$InfoUsage,{
  
  # Remove existing info boxes
  removeUI(
   selector = "#InfoBoxAbout")
  removeUI(
   selector = "#InfoBoxUsage")
  removeUI(
   selector = "#InfoBoxOther")
  
  # Add appropriate info box
  insertUI(
   selector = "#InfoBox",
   where = "afterEnd",
   ui = source("R/InfoUsage.R",local=TRUE)$value
  )
 })
 
 observeEvent(input$InfoOther,{
  
  # Remove existing info boxes
  removeUI(
   selector = "#InfoBoxAbout")
  removeUI(
   selector = "#InfoBoxUsage")
  removeUI(
   selector = "#InfoBoxOther")
  
  # Add appropriate info box
  insertUI(
   selector = "#InfoBox",
   where = "afterEnd",
   ui = source("R/InfoOther.R",local=TRUE)$value
  )
 })
 
 # Update selected tab
 observe({
  if (input$dashboardchooser == "Info")
   {
   updateTabItems(session, inputId="sidebartabs", selected = "Info")
   updateRadioGroupButtons(session,inputId="dashboardchooser2",selected="Info")
   }
 })
 
 observe({
  if (input$dashboardchooser2 == "Plot")
  {
   updateTabItems(session, inputId="sidebartabs", selected = "Visualize")
   updateRadioGroupButtons(session,inputId="dashboardchooser",selected="Plot")
   }
 })
 
 
 # ----------------- LOAD EXAMPLE DATA ---------------- #
 
 # Load example data for branches color by group
 observe({
  if (input$loadexamplebranchgroup == FALSE)
  {
   kinasegroupinfobr = ""
  }
  if (input$loadexamplebranchgroup == TRUE)
  {
   kinasegroupinfobr = paste(apply(data.frame(svginfo$dataframe$id.kinrich,svginfo$dataframe$kinase.group),1,paste,collapse="\t"),collapse="\n")
   updateTextInput(session, "branchGroupIDtype", value = "KinrichID")
  }
  
  updateTextInput(session, "branchGroupBox", value = kinasegroupinfobr)
 })
 
 # Load example data for nodes color by group
 observe({
  if (input$loadexamplennodegroup == FALSE)
  {
   kinasegroupinfono = ""
  }
  if (input$loadexamplennodegroup == TRUE)
  {
   kinasegroupinfono = paste(apply(data.frame(svginfo$dataframe$id.kinrich,svginfo$dataframe$kinase.group),1,paste,collapse="\t"),collapse="\n")
   updateTextInput(session, "nodeGroupIDtype", value = "KinrichID")
  }
  
  updateTextInput(session, "nodeGroupBox", value = kinasegroupinfono)
 })
 
 # Load example data for branches color by value
 observe({
  if (input$loadexamplebranchvalue == FALSE)
  {
   examplebranchvaluedata = ""
  }
  if (input$loadexamplebranchvalue == TRUE)
  {
   examplebranchvaluedata = rna_data
   updateTextInput(session, "branchValueIDtype", value = "HGNC")
  }
  
  updateTextInput(session, "branchValueBox", value = examplebranchvaluedata)
 })
 
 # Load example data for nodes color by value
 observe({
  if (input$loadexamplennodevalue == FALSE)
  {
   examplenodevaluedata = ""
  }
  if (input$loadexamplennodevalue == TRUE)
  {
   examplenodevaluedata = rna_data
   updateTextInput(session, "nodeValueIDtype", value = "HGNC")
  }
  
  updateTextInput(session, "nodeValueBox", value = examplenodevaluedata)
 })
 
 # Load example data for nodes size by value
 observe({
  if (input$loadexamplennodesizevalue == FALSE)
  {
   examplenodesizevaluedata = ""
  }
  if (input$loadexamplennodesizevalue == TRUE)
  {
   examplenodesizevaluedata = rna_abs_data
   
   # set the correct ID type
   updateTextInput(session, "nodesizeValueIDtype", value = "HGNC")
   
   # update the manual inpout checkbox
   updatePrettyCheckbox(session,"Manuallysetdatarange",value=TRUE)
   
   # Set the input range
   updateNumericInput(session, "nodesizevaluein", value = 0)
   updateNumericInput(session, "nodesizevaluemax",value = 100)
   
   # Set the size range
   updateSliderInput(session,"nodesizeValueslider",value=c(4,16))
  }
  
  updateTextInput(session, "nodesizeValueBox", value = examplenodesizevaluedata)
 })
 
 # ----------------- MAIN REACTIVE FUNCTION ---------------- #
 
  newdf <- reactive({ 
   
    # get current values
    tempdf = svginfo$dataframe
    
    # establish legend
    legend = c()
    # Set initial yoffset
    yoffset = 79.125
    
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
     # define color palette
     if (input$branchgroupcolorpalettetype == "prebuilt")
     {
      branchgroupcolpalette = unlist(qualpalettes[input$branchgroupcolorpalette_qaul])
     }
     if (input$branchgroupcolorpalettetype == "manual")
     {
      branchgroupcolpalette = c(input$branchgroupcol1,input$branchgroupcol2,input$branchgroupcol3,input$branchgroupcol4,
                                input$branchgroupcol5,input$branchgroupcol6,input$branchgroupcol7,input$branchgroupcol8,
                                input$branchgroupcol9,input$branchgroupcol10,input$branchgroupcol11,input$branchgroupcol12)
     }
     
     # read in text area input
      recolordf = read.text.input(input$branchGroupBox)
      
      # convert to coral id
      recolordf = convertID (tempdf,recolordf,inputtype=input$branchGroupIDtype)
      
      if (nrow(recolordf)>0)
      {
        # set colors based on group
        newcolors_and_colormapping = color.by.group(df = tempdf, recolordf = recolordf, colors  = branchgroupcolpalette)
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
        if (input$branchcolorpalettetype == "sequential") 
        {
          branchcolpalette = colorRampPalette(unlist(seqpalettes[input$branchcolorpalette_seq]))(11)
          bg.col = unlist(seqpalettes[input$branchcolorpalette_seq])[1]
         }
        if (input$branchcolorpalettetype == "divergent") 
         {
         branchcolpalette = colorRampPalette(unlist(divpalettes[input$branchcolorpalette_div]))(11)
         bg.col = unlist(divpalettes[input$branchcolorpalette_div])[2]
         }
        if (input$branchcolorpalettetype == "manual 2 color")
         {
         branchcolpalette = colorRampPalette(c(input$branch2col_low,input$branch2col_hi))(11)
         bg.col = input$branch2col_low
         }
        if (input$branchcolorpalettetype == "manual 3 color") 
        {
         branchcolpalette = colorRampPalette(c(input$branch3col_low,input$branch3col_med,input$branch3col_hi))(11)
         bg.col = input$branch3col_med
         }
       
        # set colors based on group
        newcolors_and_colormapping = color.by.value(df = tempdf, recolordf = recolordf, colors  = branchcolpalette, heatrange = c(input$minheat,input$maxheat),bg.col = bg.col)
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
     # define color palette
     if (input$nodegroupcolorpalettetype == "prebuilt")
     {
      nodegroupcolpalette = unlist(qualpalettes[input$nodegroupcolorpalette_qaul])
     }
     if (input$nodegroupcolorpalettetype == "manual")
     {
      nodegroupcolpalette = c(input$nodegroupcol1,input$nodegroupcol2,input$nodegroupcol3,input$nodegroupcol4,
                                input$nodegroupcol5,input$nodegroupcol6,input$nodegroupcol7,input$nodegroupcol8,
                                input$nodegroupcol9,input$nodegroupcol10,input$nodegroupcol11,input$nodegroupcol12)
     }
     
     # read in text area input
      recolordf = read.text.input(input$nodeGroupBox)
      
      # convert to coral id
      recolordf = convertID (tempdf,recolordf,inputtype=input$nodeGroupIDtype)
      
      if (nrow(recolordf)>0)
      {
        # set colors based on group
        newcolors_and_colormapping = color.by.group(df = tempdf, recolordf = recolordf, colors  = nodegroupcolpalette)
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
       if (input$nodecolorpalettetype == "sequential") 
       {
        nodecolpalette = colorRampPalette(unlist(seqpalettes[input$nodecolorpalette_seq]))(11)
        bg.col = unlist(seqpalettes[input$nodecolorpalette_seq])[1]
        }
       if (input$nodecolorpalettetype == "divergent") 
       {
        nodecolpalette = colorRampPalette(unlist(divpalettes[input$nodecolorpalette_div]))(11)
        bg.col = unlist(divpalettes[input$nodecolorpalette_div])[2]
        }
       if (input$nodecolorpalettetype == "manual 2 color") 
       {
        nodecolpalette = colorRampPalette(c(input$node2col_low,input$node2col_hi))(11)
        bg.col = input$node2col_low
        }
       if (input$nodecolorpalettetype == "manual 3 color") 
        {
        nodecolpalette = colorRampPalette(c(input$node3col_low,input$node3col_med,input$node3col_hi))(11)
        bg.col = input$node3col_med
       }
       
        # set colors based on group
        newcolors_and_colormapping = color.by.value(df = tempdf, recolordf = recolordf, colors  = nodecolpalette, heatrange = c(input$nodeminheat,input$nodemaxheat),bg.col = bg.col)
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
       
        # Get correct limits for legend
        if (input$Manuallysetdatarange == FALSE)
        {
         minvalforlegend = min(as.numeric(resizedf[,2]))
         maxvalforlegend = max(as.numeric(resizedf[,2]))
        }
        if (input$Manuallysetdatarange == TRUE)
        {
         minvalforlegend = input$nodesizevaluemin
         maxvalforlegend = input$nodesizevaluemax
        }
        
        tempdf$node.radius     = radii_and_mapping[[1]]
        tempdf$node.val.radius = radii_and_mapping[[2]]
        
        # add legend info
        lines_and_offset = build.nodesize.legend (yoffset=yoffset,minval=minvalforlegend,maxval=maxvalforlegend,minsize = input$nodesizeValueslider[1] ,maxsize = input$nodesizeValueslider[2])
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
    if (input$nodestrokecolselect == "Single Color")
    {
       tempdf$node.strokecol = input$nodestrokecol
    }
    if (input$nodestrokecolselect == "Same as Node")
    {
     tempdf$node.strokecol = tempdf$node.col
    }
    if (input$nodestrokecolselect == "Selected")
    {
     
     tempdf$node.strokecol =  input$NodeStrokeSelect_BG
     
     # read in text area input
     kinases = unlist(strsplit(x=input$NodeStrokeSelect,split="\\n"))
     
     if (length(kinases) > 0)
     {
      df = data.frame(kinases=kinases,again=kinases)
      
      # convert IDs
      selectedkinasesforstroke = convertID (tempdf,df,inputtype=input$NodeStrokeSelectIDtype)
      
      if (nrow(selectedkinasesforstroke) > 0)
      {
       # set colors based on selected ids 
       tempdf$node.strokecol =  color.by.selected(df = tempdf, sel = selectedkinasesforstroke[,1], bg.col  = input$NodeStrokeSelect_BG,  sel.col = input$NodeStrokeSelect_FG)
      }
     }

    }
    # View(svginfo$dataframe)
    
    return(list(tempdf,legend))
  }) # end reactive
  
  # ----------------- PLOTS ---------------- #
  
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
    
    # Render SVG
    svgPanZoom(svgoutfile,viewBox = F,controlIconsEnabled=F)
  })
  
  
  #output to the graph div
  output$circlelayout <- reactive({
   # recolor the official matrix
   dfandlegend = newdf()
   svginfo$dataframe = dfandlegend[[1]]
   
   # replace none color for D3 plots
   allnodescoloreddf =  svginfo$dataframe
   allnodescoloreddf$node.col[which(allnodescoloreddf$node.col == "none")] = BG_col1
   
   # modify color subnodes based on coloring options
   if (input$nodestrokecolselect == "Single Color")
   {
    BGstrolecol = input$nodestrokecol
   }
   if (input$nodestrokecolselect == "Selected")
   {
    BGstrolecol = input$NodeStrokeSelect_BG
   }
   if (input$nodestrokecolselect == "Same as Node")
   {
    BGstrolecol = "#ffffff"
   }
   print(BGstrolecol)
   
   # Write kinome_tree.json (based on current dataframe)
   makejson(allnodescoloreddf,tmp=subdffile,output=outputjson,BGcol=BG_col1,BGstrolecol=BGstrolecol,colsubnodes=input$colorsubnodes)
   
   # Make this reactive to any change in input paramters
   x <- reactiveValuesToList(input)
  })
  
  #output to the graph div
  output$forcelayout <- reactive({
    
    # recolor the official matrix
    dfandlegend = newdf()
    svginfo$dataframe = dfandlegend[[1]]
    
    # replace none color for D3 plots
    allnodescoloreddf =  svginfo$dataframe
    allnodescoloreddf$node.col[which(allnodescoloreddf$node.col == "none")] = BG_col1
    
    # modify color subnodes based on coloring options
    if (input$nodestrokecolselect == "Single Color")
    {
     BGstrolecol = "#ffffff"
    }
    if (input$nodestrokecolselect == "Selected")
    {
     BGstrolecol = input$NodeStrokeSelect_BG
    }
    if (input$nodestrokecolselect == "Same as Node")
    {
     BGstrolecol = "#ffffff"
    }
    
    # Write kinome_tree.json (based on current dataframe)
    makejson(allnodescoloreddf,tmp=subdffile,output=outputjson,BGcol=BG_col1,BGstrolecol=BGstrolecol,colsubnodes=input$colorsubnodes)
    
    # Make this reactive to any change in input paramters
    x <- reactiveValuesToList(input)
  })
  
  # ----------------- DATA TABLE ---------------- #
  
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
  
  # ----------------- DOWNLOAD ---------------- #
 
  # Download image
  output$downloadtree <- downloadHandler(
    
    filename <- function(file) { paste("CORAL",".","tree",".","pdf",sep="")},
    content <- function(file) {
    rsvg_pdf(svgoutfile, file)
    }
    # content <- function(file) {
    #   if (input$downloadtype == 'pdf') {
    #     rsvg_pdf(svgoutfile, file)
    #   } else if (input$downloadtype == 'svg') {
    #     rsvg_svg(svgoutfile, file)
    #   } else {
    #     showNotification('Unrecognized Output Image Type')
    #   }
    # }
  )
  
}