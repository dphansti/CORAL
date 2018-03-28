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
        
# TITLE
        fluidRow(width=12, 
                 column(8,   
                        div(
                            h2 (HTML("Title &nbsp;\u2609")),
                            "This tab allows you to input a title for the plot. This option will only affect the Tree plot.",
                         
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/AS-1a.png",width="100%",align="left",
                                                tags$style("img[src='info/AS-1a.png'] {padding-top: 4px}")
                                            )
                                            )
                                     )
                            )
                        ),
                
        
# FONT    
                        div(
                            h2 (HTML("Font &nbsp;\u2609")),
                            "This tab allows you to change global font settings as well as kinase label colors. Font style 
                            and color changes will only affect the Tree plot.",
                     
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/AS-2a.png",width="100%",align="left",
                                                    tags$style("img[src='info/AS-2a.png'] {padding-top: 4px}")                  
                                            )
                                            )
                                     ),
                                     column(9,
                                            div(  
                                             h3 ("Choose Font"),
                                             "Selects the font to use for all kinase labels, family labels, and titles in the Tree plot.",
                         
                                             h3 ("Label Font Size"),
                                             "Sets the font size for all kinase labels, family labels, and titles. 
                                             This setting will apply to all plots.",
                         
                                             h3 ("Label Color"),
                                             "This option allows you to change the kinase label colors either uniformly or based on branch color.",
                         
                                             h4 (HTML("\u25be&nbsp;&nbsp; Single Color")),
                                             "The default option is to use the same color font (black) for all kinase labels. 
                                             You can change the color of all labels by using the color picker box 
                                             to find a color or enter a hex value.",
                         
                                             h4 (HTML("\u25be&nbsp;&nbsp; Same as Branch")),
                                             "This option colors the kinase labels the same color as their branches. 
                                             This can work especially well when nodes are disabled and you are highlighting
                                             kinases in specific qualitative groups or quantitative extremes."
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/AS-2b.png",width="100%",align="left",
                                tags$style("img[src='info/AS-2b.png'] {padding-top: 4px}")
                        )
                        )
                 )
        ),
        
# NODE   
        fluidRow(width=12, 
                 column(8,    
                        div(
                            h2 (HTML("Node &nbsp;\u2609")),
                            "This tab allows you to change the color of node outlines depending on the desired look of your 
                            tree and the data you intend to visualize. Using the 'Node Stroke Color Scheme' menu, you can 
                            keep the strokes the same color as the nodes themselves, assign a single stroke color to all nodes, 
                            or manually color the strokes of specific nodes of interest",
        
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/AS-3a.png",width="100%",align="left",
                                                    tags$style("img[src='info/AS-3a.png'] {padding-top: 4px}")
                                            )
                                            )
                                     ),
                                     column(9,
                                            div(  
                                             h2 (HTML("Same as Node &nbsp;&nbsp;\u25be")),
                                             "This default option matches the node stroke color to the color of the node itself, as determined 
                                             by the Node Color settings."
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/AS-3b.png",width="100%",align="left",
                                tags$style("img[src='info/AS-3b.png'] {padding-top: 4px}")
                        )
                        )
                 )
        ),
        
        fluidRow(width=12,
                 column(2, tags$br(), 
                        div(img(src="info/AS-4a.png",width="100%",align="left",
                                tags$style("img[src='info/AS-4a.png'] {padding-top: 4px}")
                        )
                        )
                 ),
                 column(6,        
                        div(
                         h2 (HTML("Uniform &nbsp;&nbsp;\u25be")),
                         "This option allows you to color all node strokes in the tree a single uniform color. This is useful 
                         for enhancing the appearance of your tree nodes.",
                         
                         h3 ("Node Stroke Color"),
                         "This selection determines the stroke color of all selected and unselected nodes. By default, node strokes are uniformly 
                         colored white. You can use the color picker box to find a new color or enter a hex value."
                     
                        )
                        ), 
                 column(4, 
                        div(img(src="info/AS-4b.png",width="100%",align="left",
                                tags$style("img[src='AS-4b.png'] {padding-top: 4px}")
                        )
                        )
                 )
        ),
        
        fluidRow(width=12,
                 column(2, tags$br(), 
                        div(img(src="info/AS-5a.png",width="100%",align="left",
                                tags$style("img[src='info/AS-5a.png'] {padding-top: 4px}")
                        )
                        )
                 ),
                 column(6,        
                        div(
                            h2 (HTML("Manual &nbsp;&nbsp;\u25be")),
                            "This option allows you to color the strokes of specific nodes of interest. This is useful for 
                            highlighting specific kinases when node and branch colors are already conveying important information.",
                      
                            h3 ("Kinase Input Method"),
                            "Here you can select the method you would like to use to identify kinases of interest.",
                         
                            h4 (HTML("\u2609&nbsp; Select")),
                            "This method reates a scrollable and searchable list of all kinases featured on the tree. This feature is most useful 
                            when highlighting a small number of kinases",
                         
                            h4 (HTML("\u2609&nbsp; Paste")),
                            "This method creates a field into which you may type or paste a list of kinases, with each kinase on its own line. This feature 
                            is useful when trying to highlight a larger number of kinases, or if you have a pre-existing list of kinases 
                            from a spreadsheet or other document.",
                         
                            h3 ("Kinases"),
                            "This is the field where you may select or input your list of kinases to highlight, depending on your 
                            chosen input method.",
                         
                            h3 ("Identifier Type"),
                            "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                            In order to properly plot your selected branches, you must specify the identification used in the 
                            'Kinases' field",
                         
                            h3 ("BG Color & Selected Color"),
                            "Here you can change node colors for both your selected and unselected kinases. The BG Color sets 
                            the color of kinases that are not listed in the above field, while Selected Color sets the color  
                            of the kinases you have identified. You can use the color picker box to find a color or enter a 
                            hex value.",
                            tags$br(),
                            tags$br(),
                            tags$br()
                        )
                 ), 
                 column(4, 
                        div(img(src="info/AS-5b.png",width="100%",align="left",
                                tags$style("img[src='info/AS-5b.png'] {padding-top: 4px}")
                        )
                        )
                 )
        )
        
    ) # end box
) # end div

