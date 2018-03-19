div(id="InfoAdvancedOptionsBox",
    box(width="100%",
        
        fluidRow(width=12, 
                 column(8,   
                        div(
                            h1 ("Advanced Settings"),
                            "."
                        )
                 )
        ),
        
###
        fluidRow(width=12, 
                 column(8, 
                        div(       
                            h2 (HTML("Title &nbsp;☉")),
                            "This tab allows you to input a title for the plot. This option will only affect the Tree plot."
                         
                        )
                 )
        ),
        
        fluidRow(width=12,
                 column(2, tags$br(), 
                        div(img(src="info/BC-Uniform.png",width="100%",align="left",
                                tags$style("img[src='info/BC-Uniform.png'] {padding-top: 4px}")
                        )
                        )
                 )
        ),
        
###    
        fluidRow(width=12,
                 column(8,     
                        div(
                            h2 (HTML("Font &nbsp;☉")),
                            "This tab allows you to change global font settings as well as kinase label colors. Font style 
                            and color changes will on affect the Tree plot."
                        )
                 )
        ),
        fluidRow(width=12,
                 column(2, tags$br(), 
                        div(img(src="info/BC-Manual.png",width="100%",align="left",
                                tags$style("img[src='info/BC-Manual.png'] {padding-top: 4px}")                  
                        )
                        )
                 ),
                 column(6,
                        div(  
                            h3 ("Choose Font"),
                            "You can change the font to use for all kinase labels, family labels, and titles in the Tree plot.",
                         
                            h3 ("Label Font Size"),
                            "You can also change the font size for all kinase labels, family labels, and titles. 
                            This setting will apply to all plots.",
                         
                            h3 ("Label Color"),
                            "This option allows you to change the kinase label colors either uniformly or based on branch color.",
                         
                            h4 (HTML("▾&nbsp;&nbsp; Single Color")),
                            "The default option is to use the same color font (black) for all kinase labels. 
                            You can alternatively change the color of all labels by using the 'Label Color' drop-down box 
                            to find a color or enter a hex value.",
                         
                            h4 (HTML("▾&nbsp;&nbsp; Same as Branch")),
                            "Another option is to color the kinase labels the same color as their branches. 
                            This can work especially well when nodes are disabled and you are trying to highlight the names 
                            of kinases in specific qualitative groups or quantitative extremes."
                        )
                 ),
                 column(4, 
                        div(img(src="info/Tree-BC-Quan2.png",width="100%",align="left",
                                tags$style("img[src='info/Tree-BC-Quan2.png'] {padding-top: 4px}")
                        )
                        )
                 )
        ),
        
###    
        fluidRow(width=12, 
                 column(8,    
                        div(
                            h2 (HTML("Node &nbsp;☉")),
                            "This tab allows you to change the color of node outlines depending on the desired look of your 
                            tree and the data you are trying to visualize. Using the 'Node Stroke Color Scheme' menu, you can 
                            assign all strokes to a single color using the Uniform setting, color strokes the same as the nodes 
                            themselves using Same as Node, or highlight specific kinase nodes of interest with unique stroke 
                            colors using Manual."                  
                        )
                 )
        ),
        
        fluidRow(width=12,
                 column(2, tags$br(), 
                        div(img(src="info/BC-Qualitative.png",width="100%",align="left",
                                tags$style("img[src='info/BC-Qualitative.png'] {padding-top: 4px}")
                        )
                        )
                 ),
                 column(6,
                        div(  
                            h2 (HTML("Uniform &nbsp;&nbsp;▾")),
                            "This option allows you to color all node strokes in the tree a single uniform color. This is a useful 
                            option for personalizing your tree nodes.",
                         
                            h3 ("Node Stroke Color"),
                            "A color-selector used to change the color of all node strokes. By default, node strokes are uniformly 
                            colored white. You can change this color by using the drop-down box to find a color or entering a hex value."
                        )
                        ),
                 column(4, 
                        div(img(src="info/Tree-BC-Quan2.png",width="100%",align="left",
                                tags$style("img[src='info/Tree-BC-Quan2.png'] {padding-top: 4px}")
                        )
                        )
                 )
        ),
        
        fluidRow(width=12,
                 column(2, tags$br(), 
                        div(img(src="info/BC-Quantitative.png",width="100%",align="left",
                                tags$style("img[src='info/BC-Quantitative.png'] {padding-top: 4px}")
                        )
                        )
                 ),
                 column(6,        
                        div(
                            h2 (HTML("Same as Node &nbsp;&nbsp;▾")),
                            "This option automatically sets the node stroke color to the color of the node itself, as determined 
                            by the 'Node Color' settings."
                        )
                        ), 
                 column(4, 
                        div(img(src="info/Tree-BC-Quan2.png",width="100%",align="left",
                                tags$style("img[src='info/Tree-BC-Quan2.png'] {padding-top: 4px}")
                        )
                        )
                 )
        ),
        
        fluidRow(width=12,
                 column(2, tags$br(), 
                        div(img(src="info/BC-Quantitative.png",width="100%",align="left",
                                tags$style("img[src='info/BC-Quantitative.png'] {padding-top: 4px}")
                        )
                        )
                 ),
                 column(6,        
                        div(
                            h2 (HTML("Manual &nbsp;&nbsp;▾")),
                            "This option allows you to color strokes of specific nodes of interest. This can be useful for 
                            highlighting specific kinases when node and branch colors are already conveying important information. ",
                      
                            h3 ("Kinase Input Method"),
                            "Here you can select the method you would like to use to identify kinases of interest. ",
                         
                            h4 (HTML("☉&nbsp; Select")),
                            "Creates a scrollable and searchable list of all kinases featured on the tree. This feature is most useful 
                            when trying to highlight a small number of kinases",
                         
                            h4 (HTML("☉&nbsp; Paste")),
                            "Creates a space to copy a list of kinases to highlight, each kinase separated by a new line. This feature 
                            is useful when trying to highlight a larger number of kinases, or if you have a pre-existing list of kinases 
                            from a spreadsheet or other document.",
                         
                            h3 ("Kinases"),
                            "This is the space where you may select or input your list of kinases to highlight, depending on your 
                            preferred input method.",
                         
                            h3 ("Identifier Type"),
                            "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                            In order to properly plot your selected branches, you must specify the identification used in the 
                            'Kinases' space.",
                         
                            h3 ("BG Color & Selected Color"),
                            "Here you can change node colors for both your selected and unselected kinases. The BG Color sets 
                            the color of kinases that were not listed, while Selected Color sets the color of the kinases you have 
                            identified and are trying to highlight. You can use the drop-down box to find a color or enter a hex value."
                        )
                 ), 
                 column(4, 
                        div(img(src="info/Tree-BC-Quan2.png",width="100%",align="left",
                                tags$style("img[src='info/Tree-BC-Quan2.png'] {padding-top: 4px}")
                        )
                        )
                 )
        )
        
    ) # end box
) # end div

