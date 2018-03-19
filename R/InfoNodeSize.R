div(id="InfoNodeSizeBox",
    box(width="100%",
        
        fluidRow(width=12, 
                 column(8,   
                        div(
                            h1 ("Size Scheme"),
                            "CORAL also allows you to change node size depending on the desired look of your tree and 
                            the data you are trying to visualize. You can set all nodes to a single size using the Uniform 
                            setting or scale nodes according to numerical data using the Quantitative setting."
                        )
                 )
         ),
        
###
        fluidRow(width=12, 
                 column(8, 
                        div(       
                            h2 (HTML("Uniform &nbsp;&nbsp;▾")),
                            "This option allows you to set all nodes in the tree to a single size of your choosing using 
                            the slider."              
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
                            h2 (HTML("Quantitative &nbsp;&nbsp;▾")),
                            "This option allows you to color kinase branches based on a range of qualitative values. It is a useful 
                            option when trying to visualize a range of values, such as fold change or signal data."   
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
                            h4 (HTML("◎&nbsp; Load example data")),
                            "This button will load sample data into the 'Kinases & Value' tab.",
           
                            h3 ("Kinases & Value"),
                            "Here you can submit a two-column list of kinases and their associated values. A space, tab, 
                            or new line must separate each kinase from its corresponding value. Every kinase listed must 
                            have a value, or plotting will fail. Listing the same kinase multiple times with different 
                            values will result in the branch being sized according to the last listed value. Identifiers 
                            not found within the tree will be ignored. Kinases that are not listed will lack a node entirely.",
                         
                            h3 ("Identifier Type"),
                            "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                            In order to properly plot your selected branches, you must specify the identification used in the 
                            'Kinases & Group' space.",
                         
                            h3 ("Size Range"),
                            "This slider allows you to select a range of node sizes to plot. The values entered under 
                            'Kinases & Group' will be scaled to these minimum and maximum sizes.",
                         
                            h3 (HTML("◎&nbsp; Manually set data range")),
                            "By default, the smallest value will be set to the smallest node size, and the largest value 
                            will be set to the largest node size. You can opt instead to manually set Max and Min Values, 
                            in which case all values below the assigned minimum will be the set minimum size, and all values 
                            above the assigned maximum will be the set maximum size.",
                            tags$br(),tags$br(),
                            "This option will automatically create a figure legend showing six nodes in the full range of 
                            node sizes and indicating the corresponding minimum and maximum values."
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
