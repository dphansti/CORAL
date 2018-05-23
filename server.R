
# server business
server <- function(input, output,session) {
 
 # ----------------- MAKE DIVS & USER FILES FOR TREE, CIRCLE, AND FORCE ---------------- #
 
 # set all of the temp files
 outputjson      = tempfile(pattern="kinome_tree",tmpdir="www/json",fileext = ".json") # session specific json file describing network
 outputjsonshort = paste("json/",strsplit(outputjson,split = "/")[[1]][3],sep="") # used to communicate to js
 subdffile       = tempfile(pattern="subdf",tmpdir="tempfiles",fileext = ".txt") # temp file used to make json file
 svgoutfile      = tempfile(pattern="kintreeout",tmpdir="tempfiles",fileext = ".svg") # session specific tree svg file
 
 # these plots need to be created here (in server) rather that in UI so that they are unique to each session.  Otherwise there will
 # be cross talk between multiple people using the web server at once
 insertUI(selector = "#treediv",where = "afterEnd",ui = source("R/renderTree.R",local=TRUE)$value)
 insertUI(selector = "#circlediv",where = "afterEnd",ui = div(id="circlelayout", class="circleNetwork",jsonfilename=outputjsonshort))
 insertUI(selector = "#forcediv",where = "afterEnd",ui = div(id="forcelayout", class="collapsableForceNetwork",jsonfilename=outputjsonshort))
 
 # ----------------- CREATE DOWNLOAD BUTTONS ---------------- #
 
 insertUI(selector = "#downloadtreediv",where = "afterEnd",ui =
           downloadButton(outputId = "downloadtree",label= "Download"))
 insertUI(selector = "#downloadcirclediv",where = "afterEnd",ui =
           tags$a(id="downloadcircle", class="btn btn-default", "Download"))
 insertUI(selector = "#downloadforcediv",where = "afterEnd",ui =
           tags$a(id="downloadforce", class="btn btn-default", "Download"))
 
 # ----------------- UPDATE MANUAL KINASE SELECTION ---------------- #
 
 # branch color
 observe({
  idtype = paste("id.",input$branchManualIDtype,sep="")
  if (idtype == "id.coralID"){idtype = "id.coral"}
  idstodisplay = svginfo$dataframe[,which(names(svginfo$dataframe) == idtype)] 
  idstodisplay = idstodisplay[unique(idstodisplay)]
  idstodisplay = idstodisplay[which(idstodisplay != "NA")]
  updateSelectInput(session,inputId = "KinasesManual",choices = idstodisplay)
 })
 
 # node color
 observe({
  idtype = paste("id.",input$NodeManualIDtype,sep="")
  if (idtype == "id.coralID"){idtype = "id.coral"}
  idstodisplay = svginfo$dataframe[,which(names(svginfo$dataframe) == idtype)] 
  idstodisplay = idstodisplay[unique(idstodisplay)]
  idstodisplay = idstodisplay[which(idstodisplay != "NA")]
  updateSelectInput(session,inputId = "KinasesManualNode",choices = idstodisplay)
 })
 
 # ----------------- PALETTE REVERSALS ---------------- #
 
 observeEvent(input$KinasesManualBranchRevPalette,{
   orig_col_select_bg = input$col_select_bg
   orig_col_select = input$col_select
   updateColourInput(session,"col_select_bg",value = orig_col_select)
   updateColourInput(session,"col_select",value = orig_col_select_bg)
  })
 
 observeEvent(input$KinasesBranchValue2RevPalette,{
  orig_branch2col_low = input$branch2col_low
  orig_branch2col_hi = input$branch2col_hi
  updateColourInput(session,"branch2col_low",value = orig_branch2col_hi)
  updateColourInput(session,"branch2col_hi",value = orig_branch2col_low)
 })
 
 observeEvent(input$KinasesBranchValue3RevPalette,{
  orig_branch3col_low = input$branch3col_low
  orig_branch3col_hi = input$branch3col_hi
  updateColourInput(session,"branch3col_low",value = orig_branch3col_hi)
  updateColourInput(session,"branch3col_hi",value = orig_branch3col_low)
 })
 
 observeEvent(input$KinasesManualNodeRevPalette,{
  orig_col_node_bg = input$col_node_bg
  orig_col_sel_node = input$col_sel_node
  updateColourInput(session,"col_node_bg",value = orig_col_sel_node)
  updateColourInput(session,"col_sel_node",value = orig_col_node_bg)
 })
 
 observeEvent(input$KinasesNodeValue2RevPalette,{
  orig_node2col_low = input$node2col_low
  orig_node2col_hi = input$node2col_hi
  updateColourInput(session,"node2col_low",value = orig_node2col_hi)
  updateColourInput(session,"node2col_hi",value = orig_node2col_low)
 })
 
 observeEvent(input$KinasesNodeValue3RevPalette,{
  orig_node3col_low = input$node3col_low
  orig_node3col_hi = input$node3col_hi
  updateColourInput(session,"node3col_low",value = orig_node3col_hi)
  updateColourInput(session,"node3col_hi",value = orig_node3col_low)
 })
 
 # ----------------- INFO PAGES ---------------- #
 
 # Define a function to remove and replace info boxes
 replaceinfobox = function(infoboxcode)
 {
  # remove any existing info boxes
  removeUI(selector = "#InfoBranchColorBox")
  removeUI(selector = "#InfoNodeColorBox")
  removeUI(selector = "#InfoNodeSizeBox")
  removeUI(selector = "#InfoAdvancedOptionsBox")
  removeUI(selector = "#InfoAboutBox")
  # load code to insert selected info box
  insertUI(selector = "#InfoBox",where = "afterEnd",ui = source(infoboxcode,local=TRUE)$value)
 } 

 
 # Make the about page the default page
 replaceinfobox("R/InfoAbout.R")
 
 # Load info box according to button click
 observeEvent(input$InfoBranchColorButton,{replaceinfobox("R/InfoBranchColor.R")})
 observeEvent(input$InfoNodeColorButton,{replaceinfobox("R/InfoNodeColor.R")})
 observeEvent(input$InfoNodeSizeButton,{replaceinfobox("R/InfoNodeSize.R")})
 observeEvent(input$InfoAdvancedSettingsButton,{replaceinfobox("R/InfoAdvancedOptions.R")})
 observeEvent(input$InfoAboutButton,{replaceinfobox("R/InfoAbout.R")})
 
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
   kinasegroupinfobr = paste(apply(data.frame(svginfo$dataframe$id.coral,svginfo$dataframe$kinase.group),1,paste,collapse="\t"),collapse="\n")
   updateTextInput(session, "branchGroupIDtype", value = "coralID")
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
   kinasegroupinfono = paste(apply(data.frame(svginfo$dataframe$id.coral,svginfo$dataframe$kinase.group),1,paste,collapse="\t"),collapse="\n")
   updateTextInput(session, "nodeGroupIDtype", value = "coralID")
  }
  updateTextInput(session, "nodeGroupBox", value = kinasegroupinfono)
 })
 
 # Load example data for branches color Quantitative
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
  updateRadioButtons(session,"branchcolorpalettetype", selected="divergent")
  updateTextInput(session, "branchValueBox", value = examplebranchvaluedata)
 })
 
 # Load example data for nodes color Quantitative
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
  updateRadioButtons(session,"nodecolorpalettetype",selected="divergent")
  updateTextInput(session, "nodeValueBox", value = examplenodevaluedata)
 })
 
 # Load example data for nodes size Quantitative
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
    
    # refresh when refresh button is clicked
    input$refreshForcePlot
    
    # get current values
    tempdf = svginfo$dataframe
    
    # set font family
    tempdf$text.font = paste("'",input$fontfamilyselect,"'",sep="")

    # establish legend
    legend = c()
    # Set initial yoffset
    yoffset = 79.125
    
    # get current values
    tempdf$text.size = input$fontsize
    
    # Single branch color
    if (input$branchcolortype == "Uniform")
    {
      tempdf$branch.col = input$col_branch_single
    }
    
    # Manually select branches to color
    if (input$branchcolortype == "Manual")
    {
     # set colors based on selected ids
     selkinases = ""
     if (input$branchmanuallyinputmethod == "browse")
     {
      selkinases = input$KinasesManual
     }
     if (input$branchmanuallyinputmethod == "paste")
     {
      selkinases = unlist(strsplit(split = "\n",x=input$KinasesManualBranchText))
     }
     
     selkinasescoral = ""
     if (length(selkinases) > 0)
     {
      # convert selected to coral ids
      kinasestoconvert = data.frame(kin1=selkinases,kin2=selkinases)
      selkinasesconverted = convertID (tempdf,kinasestoconvert,inputtype=input$branchManualIDtype)
      if (nrow(selkinasesconverted) > 0)
      {
       selkinasescoral = selkinasesconverted[,1]
      }
     }
     
     # recolor based on selection
     tempdf$branch.col =  color.by.selected(df = tempdf, sel = selkinasescoral, bg.col  = input$col_select_bg,  sel.col = input$col_select)
     
     # reorder based on selected ids
     tempdf = tempdf[order(tempdf$id.coral %in% selkinasescoral, decreasing = FALSE),]
      
      # build legend for Branch Color (manual selection)
      lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=c(input$branch_select_label,input$branch_nonselect_label),groupcolors=c(input$col_select,input$col_select_bg),elementtype = "Branch",fontfamily = input$fontfamilyselect)
      lines = lines_and_offset[[1]]
      yoffset = lines_and_offset[[2]] + 14
      legend = c(legend,lines)
    }
    
    # color branches by group
    if (input$branchcolortype == "Categorical")
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
        # check for user supplied groups
        categories=NULL 
        if (input$manualgroupcols_branch == TRUE)
        {
         categories = unlist(strsplit(input$ManualBranchCategories,split="\n"))
         if (length(categories) == 0){categories=NULL }
        }
       
        # set colors based on group
        newcolors_and_colormapping = color.by.group(df = tempdf, recolordf = recolordf, bg.col=input$defaultbranchcolor_categorical, colors  = branchgroupcolpalette,categories=categories)
        tempdf$branch.col = newcolors_and_colormapping[[1]]
        tempdf$branch.group = newcolors_and_colormapping[[2]]
        branch.group.colormapping = newcolors_and_colormapping[[3]]
        
        # reorder based on branch color 
        tempdf = tempdf[order(tempdf$branch.group),]
        
        # reorder based in whether kinase was in text box
        tempdf = tempdf[order(tempdf$id.coral %in% recolordf[,1], decreasing = FALSE),]

        # build legend for Branch Color (by group)
        lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=names(branch.group.colormapping),groupcolors=branch.group.colormapping,elementtype = "Branch",fontfamily = input$fontfamilyselect)
        lines = lines_and_offset[[1]]
        yoffset = lines_and_offset[[2]] + 14
        legend = c(legend,lines)
      }
    }
    
    # color branches Quantitative
    if (input$branchcolortype == "Quantitative")
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
         palettecolors = unlist(seqpalettes[input$branchcolorpalette_seq])
         if(input$reversebranchpalettesequential == TRUE)
         {
          palettecolors = rev(palettecolors)
         }
         branchcolpalette = colorRampPalette(palettecolors)(11)
          bg.col = unlist(seqpalettes[input$branchcolorpalette_seq])[1]
         }
        if (input$branchcolorpalettetype == "divergent") 
         {

         palettecolors = unlist(divpalettes[input$branchcolorpalette_div])
         if(input$reversebranchpalettedivergent == TRUE)
         {
          palettecolors = rev(palettecolors)
         }
         branchcolpalette = colorRampPalette(palettecolors)(11)
         
         bg.col = unlist(divpalettes[input$branchcolorpalette_div])[2]
         }
        if (input$branchcolorpalettetype == "manual 2-color")
         {
         branchcolpalette = colorRampPalette(c(input$branch2col_low,input$branch2col_hi))(11)
         bg.col = input$branch2col_low
         }
        if (input$branchcolorpalettetype == "manual 3-color") 
        {
         branchcolpalette = colorRampPalette(c(input$branch3col_low,input$branch3col_med,input$branch3col_hi))(11)
         bg.col = input$branch3col_med
         }
       
       # recolor missing kinases accordingly
       if (input$BranchValueMissingKinase == "manually")
       {
        print ("asdfdas")
        bg.col = input$BranchValueMissingKinaseColor
        print (bg.col)
       }
       
        # set colors based on group
        newcolors_and_colormapping = color.by.value(df = tempdf, recolordf = recolordf, colors  = branchcolpalette, heatrange = c(input$minheat,input$maxheat),bg.col = bg.col)
        tempdf$branch.col = newcolors_and_colormapping[[1]]
        tempdf$branch.val = newcolors_and_colormapping[[2]]
        
        # reorder based on branch color
        tempdf = tempdf[order(abs(tempdf$branch.val), decreasing = FALSE,na.last = FALSE),]
        
        # add legend info
        lines_and_offset = build.value.legend(yoffset=yoffset,minval=input$minheat,maxval=input$maxheat, palette=branchcolpalette,elementtype = "Branch",fontfamily = input$fontfamilyselect,subtitle = input$quantvaluenamebranchcolor)
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
    if (input$nodecolortype == "Uniform")
    {
      tempdf$node.col = input$col_node_single
    }
    
    if (input$nodecolortype == "Same as branches")
    {
      tempdf$node.col = tempdf$branch.col
    }
    
    # Manually select nodes to color
    if (input$nodecolortype == "Manual")
    {
     # set colors based on selected ids
     selkinases = ""
     if (input$nodemanuallyinputmethod == "browse")
     {
      selkinases = input$KinasesManualNode
     }
     if (input$nodemanuallyinputmethod == "paste")
     {
      selkinases = unlist(strsplit(split = "\n",x=input$KinasesManualNodeText))
     }
     
     selkinasescoral = ""
     tempdf$node.selected = -1
     if (length(selkinases) > 0)
     {
      # convert selected to coral ids
      kinasestoconvert = data.frame(kin1=selkinases,kin2=selkinases)
      selkinasesconverted = convertID (tempdf,kinasestoconvert,inputtype=input$NodeManualIDtype)
      if (nrow(selkinasesconverted) > 0)
      {
       selkinasescoral = selkinasesconverted[,1]
      }
      
      # note them as selected so we can add them to the top of the plot later
      tempdf$node.selected[which(tempdf$id.coral %in% selkinasescoral)] = 1
     }
     
     # recolor based on selection
     tempdf$node.col =  color.by.selected(df = tempdf, sel = selkinasescoral, bg.col  = input$col_node_bg,  sel.col = input$col_sel_node)

      # # build legend for Node Color (Manual Selection)
      lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=c(input$node_select_label,input$node_nonselect_label),groupcolors=c(input$col_sel_node,input$col_node_bg),elementtype = "Node",fontfamily = input$fontfamilyselect)
      lines = lines_and_offset[[1]]
      yoffset = lines_and_offset[[2]] + 14
      legend = c(legend,lines)
    }
    
    # color nodes by group
    if (input$nodecolortype == "Categorical")
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
        # check for user supplied groups
        categories=NULL 
        if (input$manualgroupcols_node == TRUE)
        {
         categories = unlist(strsplit(input$ManualNodeCategories,split="\n"))
         if (length(categories) == 0){categories=NULL }
        } 
       
        # set colors based on group
        newcolors_and_colormapping = color.by.group(df = tempdf, recolordf = recolordf, bg.col = input$defaultnodecolor_categorical, colors  = nodegroupcolpalette,categories=categories)
        tempdf$node.col = newcolors_and_colormapping[[1]]
        tempdf$node.group = newcolors_and_colormapping[[2]]
        node.group.colormapping = newcolors_and_colormapping[[3]]
        
        # build legend for Branch Color (by group)
        lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=names(node.group.colormapping),groupcolors=node.group.colormapping,elementtype = "Node",fontfamily = input$fontfamilyselect)
        lines = lines_and_offset[[1]]
        yoffset = lines_and_offset[[2]] + 14
        legend = c(legend,lines)
      }
    }
    
    # color nodes Quantitative
    if (input$nodecolortype == "Quantitative")
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
        palettecolors = unlist(seqpalettes[input$nodecolorpalette_seq])
        if(input$reversenodepalettesequential == TRUE)
        {
         palettecolors = rev(palettecolors)
        }
        nodecolpalette = colorRampPalette(palettecolors)(11)

        bg.col = unlist(seqpalettes[input$nodecolorpalette_seq])[1]
        }
       if (input$nodecolorpalettetype == "divergent") 
       {
        palettecolors = unlist(divpalettes[input$nodecolorpalette_div])
        if(input$reversenodepalettedivergent == TRUE)
        {
         palettecolors = rev(palettecolors)
        }
        nodecolpalette = colorRampPalette(palettecolors)(11)
        bg.col = unlist(divpalettes[input$nodecolorpalette_div])[2]
        }
       if (input$nodecolorpalettetype == "manual 2-color") 
       {
        nodecolpalette = colorRampPalette(c(input$node2col_low,input$node2col_hi))(11)
        bg.col = input$node2col_low
        }
       if (input$nodecolorpalettetype == "manual 3-color") 
        {
        nodecolpalette = colorRampPalette(c(input$node3col_low,input$node3col_med,input$node3col_hi))(11)
        bg.col = input$node3col_med
       }
       
       # recolor missing kinases accordingly
       if (input$NodeValueMissingKinase == "manually")
       {
        bg.col = input$NodeValueMissingKinaseColor
       }
        
        # set colors based on group
        newcolors_and_colormapping = color.by.value(df = tempdf, recolordf = recolordf, colors  = nodecolpalette, heatrange = c(input$nodeminheat,input$nodemaxheat),bg.col = bg.col)
        tempdf$node.col = newcolors_and_colormapping[[1]]
        tempdf$node.val = newcolors_and_colormapping[[2]]
        
        # reorder based on branch color
        tempdf = tempdf[order(abs(tempdf$node.val), decreasing = FALSE,na.last = FALSE),]
        
        # add legend info
        lines_and_offset = build.value.legend(yoffset=yoffset,minval=input$nodeminheat,maxval=input$nodemaxheat, palette=nodecolpalette,elementtype = "Node",fontfamily = input$fontfamilyselect,subtitle = input$quantvaluenamenodecolor)
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
    if (input$nodesizetype == "Quantitative")
    {
      # read in text area input
      resizedf = read.text.input(input$nodesizeValueBox)
      
      # convert to coral id
      resizedf = convertID (tempdf,resizedf,inputtype=input$nodesizeValueIDtype)
      
      if (nrow(resizedf)>0)
      {
        radii_and_mapping = resizes.by.value(df = tempdf, resizedf = resizedf, sizerange = input$nodesizeValueslider,
                                             controlledrange = input$Manuallysetdatarange, minvalue=input$nodesizevaluemin, maxvalue = input$nodesizevaluemax,showall=input$nodesizefornotprovidedquantitative)
       
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
        lines_and_offset = build.nodesize.legend (yoffset=yoffset,minval=minvalforlegend,maxval=maxvalforlegend,minsize = input$nodesizeValueslider[1] ,maxsize = input$nodesizeValueslider[2],fontfamily = input$fontfamilyselect, subtitle= input$quantvaluenamenodesize)
        lines = lines_and_offset[[1]]
        yoffset = lines_and_offset[[2]] + 14
        legend = c(legend,lines)
      }
    }
    
    # ------------------ ADVANCED OPTIONS ------------------ #
    
    tempdf$node.opacity = input$Node_Opacity
    
    # text color
    if (input$fontcolorselect == "Same as Branch")
    {
      tempdf$text.col = tempdf$branch.col
    }
    
    if (input$fontcolorselect == "Single Color")
    {
      tempdf$text.col = input$fontcolorchoose
    }
    
    # Node stroke color
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
    
    if (! dir.exists(dirname(svgoutfile))) {
     dir.create(dirname(svgoutfile),showWarnings = F);  
    }
    
    # Write SVG file
    writekinasetree(svginfo,destination=svgoutfile,font=input$fontfamilyselect,labelselect=input$kinaselabelselect,groupcolor = input$groupcolorchoose)
    
    # Render SVG
    svgPanZoom(svgoutfile,viewBox = F,controlIconsEnabled=F)
  })
  
  #output to the graph div
  output$circlelayout <- reactive({
   # recolor the official matrix
   dfandlegend = newdf()
   svginfo$dataframe = dfandlegend[[1]]
   svginfo$legend = dfandlegend[[2]]
   
   # replace none color for D3 plots
   allnodescoloreddf =  svginfo$dataframe
   # allnodescoloreddf$node.col[which(allnodescoloreddf$node.col == "none")] = BG_col1
   
   # color nodes by single color
   if (input$nodecolortype == "None")
   {
    allnodescoloreddf$node.col = input$col_node_single
   }
   
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
    allnodescoloreddf$node.strokecol = allnodescoloreddf$node.col
    BGstrolecol = "#ffffff"
   }
   
   # Write kinome_tree.json (based on current dataframe)
   if (! dir.exists('www/json')) {
     dir.create('www/json')
   }
   makejson(allnodescoloreddf,tmp=subdffile,output=outputjson,BGcol=BG_col1,BGstrolecol=BGstrolecol,colsubnodes=input$colorsubnodes,
            labelselect=input$kinaselabelselect,defaultnoderadius=input$size_node_single,legend=svginfo$legend,
            xshift=80,yshift=50)
   
   # Make this reactive to any change in input paramters
   x <- reactiveValuesToList(input)
  })
  
  #output to the graph div
  output$forcelayout <- reactive({
    
    # recolor the official matrix
    dfandlegend = newdf()
    svginfo$dataframe = dfandlegend[[1]]
    svginfo$legend = dfandlegend[[2]]
    
    # replace none color for D3 plots
    allnodescoloreddf =  svginfo$dataframe
    allnodescoloreddf$node.col[which(allnodescoloreddf$node.col == "none")] = BG_col1
    
    # color nodes by single color
    if (input$nodecolortype == "None")
    {
     allnodescoloreddf$node.col = input$col_node_single
    }
    
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
     allnodescoloreddf$node.strokecol = allnodescoloreddf$node.col
     BGstrolecol = "#ffffff"
    }
    
    # Write kinome_tree.json (based on current dataframe)
    makejson(allnodescoloreddf,tmp=subdffile,output=outputjson,BGcol=BG_col1,BGstrolecol=BGstrolecol,
             colsubnodes=input$colorsubnodes,labelselect=input$kinaselabelselect,
             defaultnoderadius=input$size_node_single,legend=svginfo$legend,
             xshift=85,yshift=25,noderadiusexpansion=1.5)
    
    # Make this reactive to any change in input paramters
    x <- reactiveValuesToList(input)
  })
  
  # ----------------- DATA TABLE ---------------- #
  
  # build the table
  output$KinaseTable <- DT::renderDataTable({
    
    dfandlegend = newdf()
    simpldf = dfandlegend[[1]][,c("id.coral","id.longname","kinase.family","kinase.group","branch.val","branch.col","node.col","node.radius")] 
    
    # reverse the data frame so that colored kinases appear first
    simpldf<-simpldf[dim(simpldf)[1]:1,]
    
    # convert branch colors to rgb
    mycolors <- simpldf$branch.col
    rgbcolors <- apply(grDevices::col2rgb(mycolors), 2, 
                       function(rgb) sprintf("rgb(%s)", paste(rgb, collapse=",")))
    tgtbranch <- sprintf('<span style="color:%s">&#9608;</span>', rgbcolors)
    
    newdf = data.frame(kinase=simpldf$id.coral,
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
 
  output$downloadtree <- downloadHandler(
   
   filename <- function(file) { paste("CORAL",".","tree",".","svg",sep="")},
   content <- function(file) {
    file.copy(svgoutfile, file)
   }

   # content = function(file) {
   # file.copy(svgoutfile, file)
   # content <- function(file) {
   #  rsvg_svg(svgoutfile, file)
   #}
    
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
  
  # ----------------- DELETE TEMP FILES WHEN SESSION ENDS ---------------- #
  
  session$onSessionEnded(function() {
   if (file.exists(outputjson)){file.remove(outputjson)}
   if (file.exists(subdffile)){file.remove(subdffile)}
   if (file.exists(svgoutfile)){file.remove(svgoutfile)}
  })
  
  # ----------------- ADD FORCE NETWORK DISCLAIMER ---------------- #
  
  # ----------------- ADD CIRCLE NETWORK DISCLAIMER ---------------- #
  
  insertUI(selector = "#treedisclaimer",where = "afterEnd",
           ui = box(width=12,
                    
                    "The kinome tree plots generated by CORAL make use the data generated by",
                    tags$a("Manning et al., Science, 2002",href="http://science.sciencemag.org/content/298/5600/1912.long", target="_blank"),
                    " and are based on a figure generated by ",
                    tags$a("Cell Signaling Technology",href="https://www.cellsignal.com/contents/science/protein-kinases-introduction/kinases", target="_blank"),
                    "."

           )) # end tree disclaimer
  
  insertUI(selector = "#circledisclaimer",where = "afterEnd",
           ui = box(width=12,
                    
                    "The circle network plots generated by CORAL make use the ",
                    
                    tags$a("D3.js",href="https://d3js.org", target="_blank"),
                    "javascript library. The code to generate the visualization above was",
                    "modified from ",
                    tags$a("code",href="https://bl.ocks.org/mbostock/4339607",target="_blank"),
                    "written by Mike Bostock."
                   
           )) # end circle disclaimer
  
  
  insertUI(selector = "#forcedisclaimer",where = "afterEnd",
           ui = box(width=12,
                    
                     "The force network plots generated by CORAL make use the ",
                    
                    tags$a("D3.js",href="https://d3js.org", target="_blank"),
                    "javascript library. The code to generate the visualization above was",
                    "modified from ",
                    tags$a("code",href="https://bl.ocks.org/mbostock/4062045",target="_blank"),
                    "written by Mike Bostock.",
                    
                    tags$br(),
                    tags$br(),
                    
                    actionButton(inputId = "refreshForcePlot",label = "Refresh Plot")
                    )) # end force disclaimer

}
