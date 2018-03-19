div(id="InfoNodeColorBox",
    box(width="100%",
        
        fluidRow(width=12, 
                 column(8,   
                        div(
                            h1 ("Color Scheme"),
                            "CORAL allows you to choose between several methods of node color assignment, depending on 
                            the desired look of your tree and the data you are trying to visualize. You can either 
                            disable nodes altogether using None, color all nodes a single color using the Uniform setting, 
                            highlight specific kinases of interest using Manual, or color several nodes according to a 
                            qualitative or quantitative color palette. Qualitative coloring allows you to assign kinases 
                            to groups, each of which will be assigned a unique color from either a prebuilt or user-made palette. 
                            Quantitative coloring scales assigns numerical data to sequential, divergent or user-made color scales. 
                            Each method automatically creates a figure legend indicating the significance of the node color scheme.",
                            
                            h4 (HTML("◎&nbsp; Color Intermediate Nodes")),
                            "This option dictates whether or not the nodes for kinase families and sub-families on the Circle 
                            and Force plots should also be colored according to the chosen color scheme. If selected, CORAL 
                            colors these nodes based on the most extreme value within its sub-nodes."
                        )
                 )
        ),

###
        fluidRow(width=12, 
                 column(8, 
                        div(       
                            h2 (HTML("None &nbsp;&nbsp;▾")),
                            "This option will disable nodes from the tree altogether, showing only kinase identifiers at the ends of 
                            branches. This option may be useful if you are presenting all of your information in branch colors 
                            and are looking to declutter the tree and can combine well with the Advanced Settings option to color 
                            kinase labels the same color as the branches."                  
                        )
                 )
        ),        
###
        fluidRow(width=12, 
                 column(8, 
                        div(       
                            h2 (HTML("Uniform &nbsp;&nbsp;▾")),
                            "This option allows you to color every node as a single uniform color. It is a useful option for when 
                            you do not wish to present any data on the nodes themselves but prefer the look of having nodes for 
                            each kinase."                  
                        )
                 )
        ),
        
        fluidRow(width=12,
                 column(2, tags$br(), 
                        div(img(src="info/BC-Uniform.png",width="100%",align="left",
                                tags$style("img[src='info/BC-Uniform.png'] {padding-top: 4px}")
                        )
                        )
                 ),
                 column(6,
                        div(      
                            h3 ("Node Color"),
                            "A color-selector used to change the color of all branches. You can use the drop-down box to find a 
                            color or enter a hex value."      
                        )
                 )
        ),
        
###    
        fluidRow(width=12,
                 column(8,     
                        div(
                            h2 (HTML("Manual &nbsp;&nbsp;▾")),
                            "This option allows you to highlight the nodes of specific kinases of interest. It is a useful option 
                            for finding and emphasizing a single group of kinases. "
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
                            h3 ("Kinase Input Method"),
                            "Here you can select the method you would like to use to identify kinases of interest.",
                       
                            h4 (HTML("☉&nbsp; Select")),
                            "Creates a scrollable and searchable list of all kinases featured on the tree. This feature is most useful 
                            when trying to highlight a small number of kinases.",
                      
                            h4 (HTML("☉&nbsp; Paste")),
                            "Creates a space to copy a list of kinases to highlight, each kinase separated by a new line. This feature is 
                            useful when trying to highlight a larger number of kinases, or if you have a pre-existing list of kinases 
                            from a spreadsheet or other document.",
                     
                            h3 ("Kinases"),
                            "This is the space where you may select or input your list of kinases to highlight, 
                            depending on your preferred input method.",
                       
                            h3 ("Identifier Type"),
                            "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                            In order to properly plot your selected branches, you must specify the identification used in the 
                            'Kinases' space.",
                      
                            h3 ("BG Color & Selected Color"),
                            "Here you can change branch colors for both your selected and unselected kinases. The BG Color sets 
                            the color of kinases that were not listed, while Selected Color sets the color of the kinases you 
                            have identified and are trying to highlight. You can use the drop-down box to find a color or enter 
                            a hex value.",
                      
                            h3 ("BG Label & Selected Label"),
                            "A figure legend will automatically be constructed indicating the colors of the selected and unselected 
                            kinases. By default, the legend will refer to these two categories as 'selected' and 'not selected'. 
                            These text boxes can be used to change the legend labels.",
                        
                            h3 ("Reverse Palette"),
                            "This button will automatically swap the BG and selected colors."
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
                            h2 (HTML("Qualitative &nbsp;&nbsp;▾")),
                            "This option allows you to color kinase nodes different colors according to user-defined group assignments. 
                            It is a useful option when trying to differentiate between multiple categories, for example different 
                            kinases families."              
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
                            h4 (HTML("◎&nbsp; Load default kinase groups")),
                            "This button will load the default kinase groups as defined by Manning et al 2002 into the 'Kinases & Group' 
                            tab. These groups include AGC, CAMK, CK1, CMGC, RGC, STE, TK, and TKL, as well as Atypical and Others 
                            which fall outside of those group assignments.",
                     
                            h3 ("Kinases & Group"),
                            "Here you can submit a two-column list of kinases and their group assignments. A space, tab, or new line 
                            must separate each kinase from its corresponding group assignment. Every kinase listed must have a group 
                            assignment, or plotting will fail. Including kinases with more than one group assignment will result in 
                            that kinase being colored according to the last group listed alphabetically. Identifiers not found within 
                            the tree will be ignored. Kinases that are not listed will be colored grey and excluded from the 
                            figure legend.",
                         
                            h3 ("Identifier Type"),
                            "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                            In order to properly plot your selected branches, you must specify the identification used in the 
                            'Kinases & Group' space.",
                         
                            h3 ("Color Range Type"),
                            "Here you can choose from several built-in palettes or create your own. Although you can manually 
                            select up to 12 colors using the color drop-down boxes, each palette is able to expand to cover 
                            as many groups as you have identified in the 'Kinases & Group' space.",
                         
                            h3 ("Color Missing Kinases"),
                            "This option allows you to select a color for kinases that were not listed in the 'Kinases & Value' 
                            by using the drop-down box to find a color or enter a hex value. This color defaults to light gray. 
                            This color will not be included in the figure legend.",
                            tags$br(),tags$br(),
                            "This option will automatically create a figure legend showing the color and group name for each 
                            category listed. Groups will be listed in alphabetical order, and then colors will be assigned accordingly."
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
                            have a value, or plotting will fail. Listing the same kinase multiple times with different values 
                            will result in the branch being colored according to the last listed value. Identifiers not found 
                            within the tree will be ignored. Kinases that are not listed will be colored according to the 
                            'Color Missing Kinase' settings (see below).",
                         
                            h3 ("Identifier Type"),
                            "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                            In order to properly plot your selected branches, you must specify the identification used in 
                            the 'Kinases & Group' space.",
                         
                            h3 ("Min & Max"),
                            "This option allows you to set the values that will represent either end of the color spectrum. 
                            All values below the assigned Min will be colored as though they were the set minimum value, 
                            and all values above the assigned Max will be colored as though they were the set maximum value.",
                         
                            h3 ("Color Range Type"),
                            "These options allow you to choose between several pre-built sequential and divergent color palettes 
                            or create your own 2- or 3-color gradient using color selectors. Sequential palettes are useful for 
                            continuously increasing data, such as raw signal from RNA-Seq. Divergent palettes are useful for 
                            depicting data with both positive and negative values, such as fold change. Manual 2-color gradients 
                            require a high and low color setting, while 3-color gradients require a high, low, and middle. 
                            Each color can be selected by using the drop-down box to find a color or entering a hex value.",
                         
                            h3 ("Reverse Palette"),
                            "This button will automatically swap the minimum and maximum colors of any palette.",
                         
                            h3 ("Color Missing Kinases"),
                            "By default, kinases that were not listed in the 'Kinases & Value' tab will be automatically colored 
                            according to the lowest (in sequential or 2-color palettes) or middle value 
                            (in divergent or 3-color palettes). You can opt to instead color these missing kinases manually, 
                            which will bring up a 'Missing Kinase Color' selector where you can use the drop-down box to find a 
                            color or enter a hex value.",
                            tags$br(),tags$br(),
                            "This option will automatically create a figure legend showing the full spectrum of possible colors and 
                            indicating the corresponding low, middle, and high values."
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
