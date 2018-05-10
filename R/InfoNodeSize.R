div(id="InfoNodeSizeBox",
    box(width="100%",
        
        fluidRow(width=12, 
                 column(8,   
                        div(
                            h2 ("Node Size", style="color:#3477b3; font-size:145%; font-weight:500; margin-bottom: 15px"),
                           
                            "Coral also allows you to change node size depending on the desired look of your tree and 
                            the data you intend to visualize.",
                            
                            tags$blockquote(h2 ("Scaling Scheme"),
                            "You can set all nodes to a single size using the Uniform 
                            setting or scale nodes according to numerical data using the Quantitative setting."),
        
# UNIFORM
                            h2 (HTML("Uniform &nbsp;&nbsp;\u25be"), style="font-weight:500"),
                            "This option allows you to set all nodes in the tree to a single size of your choosing using 
                            the slider.",        
        
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/NS-1a.png",width="100%",align="left",
                                                    tags$style("img[src='info/NS-1a.png'] {padding-top: 4px}")
                                            )
                                            )
                                     )
                            )
                        )
                ),
                column(4, 
                       div(img(src="info/NS-1b.png",width="100%",align="left",
                               tags$style("img[src='info/NS-1b.png'] {padding-top: 4px}")
                       )
                       )
                )

        ),
        
# QUANTITATIVE
        fluidRow(width=12, 
                 column(8, 
                        div(
                            h2 (HTML("Quantitative &nbsp;&nbsp;\u25be"), style="font-weight:500"),
                            "This option allows you to color kinase branches based on a range of qualitative values. It is a useful 
                            option when trying to visualize a range of values, such as fold change or signal data. Note, only the 
                            terminal nodes in the Circle and Force layouts will be resized.",
                            tags$br(),tags$br(),
                            "This option will automatically create a figure legend showing six nodes in the full range of 
                            node sizes and indicating the corresponding minimum and maximum values.",
        
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/NS-2a.png",width="100%",align="left",
                                                    tags$style("img[src='info/NS-2a.png'] {padding-top: 4px}")
                                            )
                                            )
                                     ),
                                     column(9,        
                                            div(
                                                h4 (HTML("\u25ce&nbsp; Load example data")),
                                                "This button will load sample data into the 'Kinases & Value' field",
           
                                                h3 ("Kinases & Value"),
                                                "Here you can submit a two-column list of kinases and their associated values. A space, tab, 
                                                or new line must separate each kinase from its corresponding value. Every kinase listed must 
                                                have a value, or plotting will fail. Listing the same kinase multiple times with different 
                                                values will result in the branch being sized according to the last listed value. Identifiers 
                                                not found within the tree will be ignored. Kinases that are not listed will lack a node entirely.",
                         
                                                h3 ("Identifier"),
                                                "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                                                In order to properly plot your selected branches, you must specify the identification used in the 
                                                'Kinases & Group' space.",
                                                
                                                h3 ("Legend Subtitle"),
                                                "This text box allows you to provide a subtitle for the Node Size legend",
                         
                                                h3 ("Size Range"),
                                                "This slider allows you to select a range of node sizes to plot. The values entered under 
                                                'Kinases & Group' will be scaled to these minimum and maximum sizes.",
                                                
                                                h3 ("Missing Kinases"),
                                                "Nodes for kinases that are not listed in the 'Kinases & Value' field are automatically included
                                                in the plot at the smallest size. You may also choose to hide these nodes.",
                         
                                                h3 (HTML("\u25ce&nbsp; Manually set data range")),
                                                "By default, the smallest value will be set to the smallest node size, and the largest value 
                                                will be set to the largest node size. You can opt instead to manually set Max and Min Values, 
                                                in which case all values below the assigned minimum will be the set minimum size, and all values 
                                                above the assigned maximum will be the set maximum size.",
                                                tags$br(),
                                                tags$br(),
                                                tags$br()
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/NS-2b.png",width="100%",align="left",
                                tags$style("img[src='info/NS-2b.png'] {padding-top: 4px}")
                        )
                        )
                 )
    )
        
    ) # end box
) # end div
