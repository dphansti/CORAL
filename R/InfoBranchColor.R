div(id="InfoBranchColorBox",
    box(width="100%",
        
        fluidRow(width=12, 
                 column(8,   
                        div(
                            h1 ("Branch Color Scheme"),
                            "CORAL allows you to choose between several methods of branch color assignment, 
                            depending on the desired look of your tree and the data you are trying to visualize. 
                            You can either color the entire tree a single color using the Uniform setting, 
                            highlight specific kinase branches of interest using Manual, or color several branches 
                            according to a qualitative or quantitative color palette. Qualitative coloring allows
                            you to assign kinases to groups, each of which will be assigned a unique color from 
                            either a prebuilt or user-made palette. Quantitative coloring scales assign numerical 
                            data to sequential, divergent or user-made color scales. Each method automatically 
                            creates a figure legend indicating the significance of the branch color scheme."
                        )
                 )
        ),
        
# UNIFORM
        fluidRow(width=12, 
                 column(8, 
                        div(       
                            h2 (HTML("Uniform &nbsp;&nbsp;▾")),
                            "This option allows you to color every branch as a single uniform color. 
                            It is a useful option if you do not wish to present any data on the branches 
                            themselves, such as when your data is well-represented by node size and color alone.",                       
                        
        
        
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/BC-1a.png",width="100%",align="left",
                                            tags$style("img[src='info/BC-1a.png'] {padding-top: 4px}")
                                            )
                                            )
                                     ),
                                   
                                     column(9,
                                            div(      
                                                h3 ("Branch Color"),
                                                "This will set the color of all branches. You can use the color picker
                                                to find a color or enter a hex value."
                                            )
                                     )
                            )
                        )
                 )
        ),
                 
# MANUAL    
        fluidRow(width=12,
                 column(8,     
                        div(
                            h2 (HTML("Manual &nbsp;&nbsp;▾")),
                            "This option allows you to highlight branches to specific kinases of interest. 
                            It is useful for finding and emphasizing a single group of kinases.",
                       
        
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/BC-2a.png",width="100%",align="left",
                                                    tags$style("img[src='info/BC-2a.png'] {padding-top: 4px}")                  
                                            )
                                            )
                                     ),
                                     column(9,
                                            div(  
                                             h3 ("Kinase Input Method"),
                                             "Here you can select the method you would like to use to identify kinases of interest.",
                              
                                             h4 (HTML("☉&nbsp; Select")),
                                             "Creates a scrollable and searchable list of all kinases featured on the tree. 
                                             This feature is most useful when trying to highlight a small number of kinases.",
                              
                                             h4 (HTML("☉&nbsp; Paste")),
                                             "Creates a space to copy a list of kinases to highlight, each kinase separated by a new line. 
                                             This feature is useful when trying to highlight a larger number of kinases, or if you 
                                             have a pre-existing list of kinases from a spreadsheet or other document.",
                              
                                             h3 ("Kinases"),
                                             "This is the space where you may select or input your list of kinases to highlight, 
                                             depending on your chosen input method.",
                            
                                             h3 ("Identifier Type"),
                                             "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, 
                                             or HGNC ID. In order to properly plot your selected branches, you must specify the 
                                             identification used in the 'Kinases' space.",
                            
                                             h3 ("Unselected Color & Selected Color"),
                                             "Here you can change branch colors for both your selected and unselected kinases. 
                                             Unselected Color sets the color of kinases that were not listed, while Selected Color 
                                             sets the color of the kinases you have identified and wish to highlight. 
                                             You can use the color picker box to find a color or enter a hex value.",
                              
                                             h3 ("Unselected Label & Selected Label"),
                                             "A figure legend will automatically be constructed indicating the colors of the 
                                             selected and unselected kinases. By default, the legend will refer to these two 
                                             categories as 'selected' and 'not selected'. These text boxes can be used to change the legend labels.",
                              
                                             h3 ("Reverse Palette"),
                                             "This button will automatically swap the selected and unselected colors."
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/BC-2b.png",width="100%",align="left",
                            tags$style("img[src='info/BC-2b.png'] {padding-top: 4px}")
                        )
                        )
                 )
                            
        ),
        
# QUALITATIVE    
        fluidRow(width=12, 
                 column(8,    
                        div(
                            h2 (HTML("Qualitative &nbsp;&nbsp;▾")),
                            "This option allows you to color kinase branches different colors according to user-defined 
                            group assignments. It is a useful option when trying to differentiate between multiple categories 
                            such as kinase families.",                        
                       
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/BC-3a.png",width="100%",align="left",
                                                    tags$style("img[src='info/BC-3a.png'] {padding-top: 4px}")
                                            )
                                            )
                                     ),
                                     column(9,
                                            div(  
                                             h4 (HTML("◎&nbsp; Load default kinase groups")),
                                             "This button will load the default kinase groups as defined by Manning et al 2002 into the 
                                             'Kinases & Group' tab. These groups include AGC, CAMK, CK1, CMGC, RGC, STE, TK, and TKL, 
                                             as well as Atypical and Others which fall outside of those group assignments.",
                         
                                             h3 ("Kinases & Group"),
                                             "Here you can submit a two-column list of kinases and their group assignments. A space, 
                                             tab, or new line must separate each kinase from its corresponding group assignment. 
                                             Every kinase listed must have a group assignment, or plotting will fail. Including 
                                             kinases with more than one group assignment will result in that kinase being colored 
                                             according to the last group listed alphabetically. Identifiers not found within the tree 
                                             will be ignored. Kinases that are not listed will be colored grey and excluded from the figure legend.",
                         
                                             h3 ("Identifier Type"),
                                             "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, 
                                             or HGNC ID. In order to properly plot your selected branches, you must specify the 
                                             identification used in the 'Kinases & Group' space.",
                         
                                             h3 ("Color Range Type"),
                                             "Here you can choose from several built-in palettes or create your own. Although you can 
                                             manually select up to 12 colors using the color drop-down boxes, each palette is able to 
                                             expand to cover as many groups as you have identified in the 'Kinases & Group' space.",
                         
                                             h3 ("Color Missing Kinases"),
                                             "This option allows you to select a color for kinases that were not listed in the 'Kinases & Value' 
                                             by using the drop-down box to find a color or enter a hex value. This color defaults to light grey. 
                                             This color will not be included in the figure legend.",
                                             tags$br(),tags$br(),
                                             "The 'Qualitative' option will automatically create a figure legend showing the color and group name for each 
                                             category listed. Groups will be listed in alphabetical order, and then colors will be assigned accordingly."
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/BC-3b.png",width="100%",align="left",
                                tags$style("img[src='info/BC-3b.png'] {padding-top: 4px}")
                        )
                        )
                 )
                 
        ),
        
# QUANTITATIVE 
        fluidRow(width=12, 
                 column(8, 
                        div(
                            h2 (HTML("Quantitative &nbsp;&nbsp;▾")),
                            "This option allows you to color kinase branches based on a range of qualitative values. It is 
                            a useful option when trying to visualize a range of values, such as fold change or signal data.",                       
                        
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/BC-4a.png",width="100%",align="left",
                                                    tags$style("img[src='info/BC-4a.png'] {padding-top: 4px}")
                                            )
                                            )
                                     ),
                                     column(9,        
                                            div(
                                                h4 (HTML("◎&nbsp; Load example data")),
                                                "This button will load sample data into the 'Kinases & Value' tab.",
                         
                                                h3 ("Kinases & Value"),
                                                "Here you can submit a two-column list of kinases and their associated values. A space, 
                                                tab, or new line must separate each kinase from its corresponding value. Every kinase listed 
                                                must have a value, or plotting will fail. Listing the same kinase multiple times with different 
                                                values will result in the branch being colored according to the last listed value. 
                                                Identifiers not found within the tree will be ignored. Kinases that are not listed will be 
                                                colored according to the 'Color Missing Kinase' settings (see below).",
                            
                                                h3 ("Identifier Type"),
                                                "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                                                In order to properly plot your selected branches, you must specify the identification used in the 
                                                'Kinases & Group' space.",
                         
                                                h3 ("Min & Max"),
                                                "This option allows you to set the values that will represent either end of the color spectrum. 
                                                All values below the assigned Min will be colored as though they were the set minimum value, 
                                                and all values above the assigned Max will be colored as though they were the set maximum value.",
                         
                                                h3 ("Color Range Type"),
                                                "These options allow you to choose between several pre-built sequential and divergent color palettes 
                                                or create your own 2- or 3-color gradient using color selectors. Sequential palettes are useful 
                                                for continuously increasing data, such as raw signal from RNA-Seq. Divergent palettes are useful for 
                                                depicting data with both positive and negative values, such as fold change. Manual 2-color gradients 
                                                require a high and low color setting, while 3-color gradients require a high, low, and middle. 
                                                Each color can be selected by using the drop-down box to find a color or entering a hex value.",
                            
                                                h3 ("Reverse Palette"),
                                                "This button will automatically swap the minimum and maximum colors of any palette. ",
                         
                                                h3 ("Color Missing Kinases"),
                                                "By default, kinases that were not listed in the 'Kinases & Value' tab will be automatically 
                                                colored according to the lowest (in sequential or 2-color palettes) or middle value 
                                                (in divergent or 3-color palettes). You can opt to instead color these missing kinases manually, 
                                                which will bring up a 'Missing Kinase Color' selector where you can use the drop-down box to find 
                                                a color or enter a hex value.",
                                                tags$br(),tags$br(),
                                                "The 'Quantitative' option will automatically create a figure legend showing the full spectrum of possible 
                                                colors and indicating the corresponding low, middle, and high values." 
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/BC-4b.png",width="100%",align="left",
                                tags$style("img[src='info/BC-4b.png'] {padding-top: 4px}")
                        )
                        )
                 )
        )
 
    ) # end box
) # end div
