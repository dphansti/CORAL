div(id="InfoAdvancedOptionsBox",
    box(width="100%",
        
        fluidRow(width=12, 
                 column(8,   
                        div(
                            h2 ("Advanced Settings", style="color:#425e8c; font-size:145%; font-weight:500; margin-bottom: 15px"),
                            "To further illuminate your data and personalize your tree, Coral allows you to
                            add a title, change the font, color, and size of kinase labels, refine the appearance of nodes
                            with transparency and strokes, and outline specific nodes of interest."
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
                            h2 (HTML("Labels &nbsp;\u2609")),
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
                                             h3 ("Label Identifier"),
                                             "This option allows users to speciff if Kinases are labeled by coralID, uniprot, ensemble, entrez, 
                                             or HGNC ID.",
                                             
                                             h3 ("Font"),
                                             "Sets the font for all kinase labels, family labels, and titles in the Tree plot. ",
                         
                                             h3 ("Label Font Size"),
                                             "Sets the font size for all kinase labels, family labels, and titles. 
                                             This setting will apply to all plots.",
                         
                                             h3 ("Label Color Scheme"),
                                             "This option allows you to change the kinase label colors either uniformly or based on branch color.",
                         
                                             h4 (HTML("\u25be&nbsp;&nbsp; Single Color")),
                                             "The default option is to use the same color (black) for all kinase labels. 
                                             You can change the color of all labels by using the color picker box 
                                             to find a color or enter a hex value.",
                         
                                             h4 (HTML("\u25be&nbsp;&nbsp; Same as Branch")),
                                             "This option colors the kinase labels the same as their branches. 
                                             This can work especially well when nodes are disabled and you are highlighting
                                             kinases in specific qualitative groups or quantitative extremes.",
                                             
                                             h3 ("Group Color"),
                                             "This option allows you to change colors of the group labels."
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/AS-1b.png",width="100%",align="left",
                                tags$style("img[src='info/AS-1b.png'] {padding-top: 4px}")
                        )
                        )
                 )
        ),
        
# NODE   
        fluidRow(width=12, 
                 column(8,    
                        div(
                         h2 (HTML("Node &nbsp;\u2609")),
                         "This tab provides additional options for the appearance of nodes. You can make the nodes
                         transparent with the Node Opacity slider and outline the nodes with the Node Stroke Color Scheme menu.
                         These settings will affect the Tree, Circle, and Force plots.",
                    
                         fluidRow(width=12,
                                  column(3, tags$br(), 
                                         div(img(src="info/AS-3a.png",width="100%",align="left",
                                                 tags$style("img[src='info/AS-3a.png'] {padding-top: 4px}")
                                         )
                                         )
                                  ),
                                  column(9,
                                         div(  
                                          h3 (HTML("Node Opacity")),
                                          "This sets the opacity of all nodes. Transparency allows the branches to be seen more
                                          clearly and is useful for discerning nodes in dense clusters.",
                                          tags$br(),
                                          "This setting will also apply to the node strokes."
                                         )
                                  )
                         )
                        ),
                        div(
                         h2 (HTML("Node Stroke Color Scheme")),
                         "This setting allows you to change the color of node outlines depending on the desired look of your 
                         tree and the data you intend to visualize. You can keep the strokes the same color as the nodes
                         themselves, assign a single stroke color to all nodes, or manually color the strokes of specific 
                         nodes of interest",
                         
                         
                         
                         fluidRow(width=12,
                                  column(3, tags$br(), 
                                         div(img(src="info/AS-3a.png",width="100%",align="left",
                                                 tags$style("img[src='info/AS-3a.png'] {padding-top: 4px}")
                                         )
                                         )
                                  ),
                                  column(9,
                                         div(  
                                          h3 (HTML("Same as Node &nbsp;&nbsp;\u25be")),
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
                         h3 (HTML("Uniform &nbsp;&nbsp;\u25be")),
                         "This option allows you to color all node strokes in the tree a single uniform color. This is useful 
                         for enhancing the appearance of your tree nodes.",
                         
                         h4 ("Node Stroke Color"),
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
                            h3 (HTML("Selected &nbsp;&nbsp;\u25be")),
                            "This option allows you to color the strokes of specific nodes of interest. This is useful for 
                            highlighting specific kinases when node and branch colors are already conveying important information.",
                      
                            h4 ("Kinases"),
                            "In this field you can list kinases you wish to highlight with node strokes. Each kinase must be separated by a new line.",
                         
                            h4 ("Identifier"),
                            "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                            In order to properly plot your selected branches, you must specify the identification used in the 
                            'Kinases' field",
                         
                            h4 ("Selected Color & Not Selected Color"),
                            "Here you can change the node stroke colors for both your selected and unselected kinases. Selected Color sets the stroke color  
                            of the kinases you have identified in the above field; Not Selected Color sets the stroke color for all other nodes.
                            You can use the color picker box to find a color or enter a hex value.",
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

