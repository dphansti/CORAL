div(id="InfoBranchColorBox",
    box(width="100%",

    fluidRow(width=12, column(8,   
        div(
         h1 ("Branch Color"),
         "Select a method with which to assign branch colors."
    ))),
    
    fluidRow(width=12, column(8, 
        div(       
         h2 (HTML("Uniform &nbsp;&nbsp;▾")),
         "This option allows you to color every branch as a single uniform color."
         ))),
         
         fluidRow(width=12,
                  column(2, tags$br(), div(img(src="info/BC-Uniform.png",width="100%",align="left",
                            tags$style("img[src='info/BC-Uniform.png'] {padding-top: 4px}")
                            ))),
                  column(6,
         div(       
         h3 ("Branch Color"),
         "A color-selector used to change the color of all branches."))),
    
    fluidRow(width=12, column(8,     
        div(
         h2 (HTML("Manual &nbsp;&nbsp;▾")),
         "This option allows you to highlight branches to specific kinases of interest. "
        ))),
        
         fluidRow(width=12,
                  column(2, tags$br(), div(img(src="info/BC-Manual.png",width="100%",align="left",
                            tags$style("img[src='info/BC-Manual.png'] {padding-top: 4px}")                  
                            ))),
                  column(6,
     
        div(
         h3 ("Kinase Input Method"),
         "Select the method you would like to use to identify kinases of interest.",
         
         h4 (HTML("☉&nbsp; Select")),
         "Scroll through a searchable list of all kinases available on the tree. ",
         
         h4 (HTML("☉&nbsp; Paste")),
         "Submit a list of kinases. (do names matter? Format?)",
         
         h3 ("Kinases"),
         "Select or input your list of kinases to highlight.",
         
         h3 ("BG Color & Color"),
         "Select colors for your selected and unselected kinases.",
         
         h3 ("(Other option for titles??)"),
         "Change the legend labels for selected and unselected kinases.",
         tags$br(),tags$br(),
         "This option will automatically create a figure legend indicating the colors of selected and not selected kinases."
        ))),

    fluidRow(width=12, column(8,    
        div(
         h2 (HTML("Qualitative &nbsp;&nbsp;▾")),
         "This option allows you to color kinase branches of different colors, to differentiate between multiple categories."
        ))),
        
        fluidRow(width=12,
                 column(2, tags$br(), div(img(src="info/BC-Qualitative.png",width="100%",align="left",
                           tags$style("img[src='info/BC-Uniform.png'] {padding-top: 4px}")
                 ))),
                 column(6,
     
        div(
         h4 (HTML("◎&nbsp; Load default kinase groups")),
         "Load the default kinase groups as defined by Manning et al 2002 into the 'Kinases & Group' tab.",
         
         h3 ("Kinases & Group"),
         "Submit a two-column list of kinases and their group assignments.",
         
         h3 ("Identifier Type"),
         "Select the kinase identifier used to list kinases in the 'Kinases & Group' tab (coralID, uniprot, ensemble, entrez, HGNC).",
         
         h3 ("Color Range Type"),
         "Color groups based on pre-built color palettes, or manually assign colors.",
         
         h3 ("Manual Group Entry"),
         "???????",
         tags$br(),tags$br(),
         "This option will automatically create a figure legend showing the color and group name for each category listed."
        ))),
    
    fluidRow(width=12, column(8, 
        div(
         h2 (HTML("Quantitative &nbsp;&nbsp;▾")),
         "This option allows you to color kinase branches based on a range of qualitative values"
        ))),
        
        fluidRow(width=12,
                 column(2, tags$br(), div(img(src="info/BC-Quantitative.png",width="100%",align="left",
                           tags$style("img[src='info/BC-Uniform.png'] {padding-top: 4px}")
                 ))),
                 
                 column(6,        
        
        div(
         h4 (HTML("◎&nbsp; Load example data")),
         "Load sample data into the 'Kinases & Value' tab.",
         
         h3 ("Kinases & Value"),
         "Submit a two-column list of kinases and their associated values.",
         
         h3 ("Identifier Type"),
         "Select the kinase identifier used to list kinases in the 'Kinases & Group' tab (coralID, uniprot, ensemble, entrez, HGNC).",
         
         h3 ("Min & Max"),
         "Indicate the values that will represent either end of the color spectrum. All values below the assigned min will be colored the same, as will all values above the assigned max.",
         
         h3 ("Color Range Type"),
         "Choose between pre-built sequential and divergent color palettes or create your own 2- or 3-color gradient using color selectors.",
         tags$br(),tags$br(),
         "This option will automatically create a figure legend showing the full spectrum of possible colors and indicating the low, middle, and high values."
        ))),
    
        
        div(
         h1 ("H1"),
         "abcdefg hij klmno pqrstu vwxyz"
        ),
        div(
         h2 ("H2"),
         "abcdefg hij klmno pqrstu vwxyz"
        ),
        div(
         h3 ("H3"),
         "abcdefg hij klmno pqrstu vwxyz"
        ),
        div(
         h4 ("H4"),
         "abcdefg hij klmno pqrstu vwxyz"
        ),
        div(
         h5 ("H5"),
         "abcdefg hij klmno pqrstu vwxyz"
        ),
        div(
         h6 ("H6"),
         "abcdefg hij klmno pqrstu vwxyz"
        )
    ) # end box
) # end div



















