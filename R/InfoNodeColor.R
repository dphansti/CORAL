div(id="InfoNodeColorBox",
    box(width="100%",
        
        fluidRow(width=12, 
                 column(8,   
                        div(
                            h2 ("Node Color", style="color:#3889bf; font-size:145%; font-weight:500; margin-bottom: 15px"),
                            
                            "Coral allows you to choose between several methods of node color assignment, depending on 
                            the desired look of your tree and the data you intend to visualize.",
                            tags$br(),tags$br(),
                            "Additional node color options are available in Advanced Settings.",
                            
                            h4 (HTML("\u25ce&nbsp; Color intermediate nodes")),
                            "This option dictates whether the nodes for kinase families and sub-families on the Circle 
                            and Force plots should also be colored according to the chosen color scheme. If selected, Coral 
                            colors these nodes based on the most extreme value within its sub-nodes.",
                            
                            tags$blockquote(h2 ("Color Scheme"),
                            "You can either disable nodes altogether, color all nodes a single color using the Uniform setting, 
                            highlight specific kinases of interest using Manual, or color a selection of nodes according to a 
                            categorical or quantitative color palette. Categorical coloring allows you to assign kinases 
                            to categories, each of which will be assigned a unique color from either a prebuilt or user-made palette. 
                            Quantitative coloring assigns numerical data to sequential, divergent or user-made color scales. 
                            Each method automatically generates a figure legend indicating the significance of the node color scheme."
                            ),
                            
                           
                       
# NONE
                              
                            h2 (HTML("None &nbsp;&nbsp;\u25be"), style="font-weight:500"),
                            "This option will disable nodes from the tree altogether, showing only kinase identifiers at the ends of 
                            branches. This option is useful if you are presenting all of your information in branch colors 
                            and are looking to declutter the tree; it combines well with the Advanced Settings option to color 
                            kinase labels the same color as the branches.",                 
   
# UNIFORM
      
                            h2 (HTML("Uniform &nbsp;&nbsp;\u25be"), style="font-weight:500"),
                            "This option allows you to color every node as a single uniform color. It is useful when 
                            you prefer the appearance of nodes for each kinase but do not wish to present any data on 
                            the nodes themselves or when ou wish to encode information in the size of the node itself using the 
                            'Node Size' box",

                            fluidRow(width = 12,
                                column(3, tags$br(), 
                                   div(img(src="info/NC-2a.png",width="100%",align="left",
                                       tags$style("img[src='info/NC-2a.png'] {padding-top: 4px}")
                                      )
                                   )
                                ),
                                column(9,
                                    div(      
                                        h3 ("Color"),
                                        "This selector changes the color of all nodes. You can use the color picker box to find a 
                                        color or enter a hex value."      
                                    )
                                )
                            )
                        )
                 ),
        
                 column(4, 
                        div(img(src="info/NC-2b.png",width="100%",align="left",
                            tags$style("img[src='info/NC-2b.png'] {margin-top: 30px}")
                           )
                        )
                 )
        ),
        
# MANUAL   
        fluidRow(width=12,
                 column(8,     
                        div(
                            h2 (HTML("Manual &nbsp;&nbsp;\u25be"), style="font-weight:500"),
                            "This option allows you to highlight the nodes of specific kinases of interest. It is useful 
                            for finding and emphasizing a single subset of kinases.",
        
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/NC-3a.png",width="100%",align="left",
                                                    tags$style("img[src='info/NC-3a.png'] {padding-top: 4px}")                  
                                            )
                                            )
                                     ),
                                     column(9,
                                            div(  
                                             h3 ("Input Method"),
                                             "Here you can select the method you would like to use to identify kinases of interest.",
                       
                                             h4 (HTML("\u2609&nbsp; Browse")),
                                             "This method creates a scrollable and searchable list of all kinases featured on the tree. This feature is most useful 
                                             when highlighting a small number of kinases. Note, you can select between lists of several different identifiers using 
                                             the 'Identifier' selector (see below).",
                      
                                             h4 (HTML("\u2609&nbsp; Paste")),
                                             "This method creates a field into which you may type or paste a list of kinases, with each kinase on its own line. 
                                             This feature is useful when highlighting a larger number of kinases, or if you have a pre-existing list 
                                             of kinases from a spreadsheet or other document.",
                     
                                             h3 ("Kinases"),
                                             "This is the field where you may select or input your list of kinases to highlight, 
                                             depending on your chosen input method.",
                       
                                             h3 ("Identifier"),
                                             "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                                             In order to properly plot your selected nodes, you must specify the identification used in the 
                                             'Kinases' field.",
                      
                                             h3 ("Default Color & Selection Color"),
                                             "Here you can change node colors for both your selected and unselected kinases. Default Color sets 
                                             the color of kinases that were not listed, while Selection Color sets the color of the kinases you 
                                             have identified and wish to highlight. You can use the color picker box to find a color or enter 
                                             a hex value.",
                      
                                             h3 ("Default Label & Selection Label"),
                                             "A figure legend will automatically be generated indicating the colors of the selected and unselected 
                                             kinases. By default, the legend will refer to these two categories as 'selected' and 'not selected'. 
                                             These text boxes can be used to change the legend labels.",
                        
                                             h3 ("Reverse Palette"),
                                             "This button will automatically swap the BG and selected colors."
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/NC-3b.png",width="100%",align="left",
                                tags$style("img[src='info/NC-3b.png'] {padding-top: 4px}")
                        )
                        )
                 )
        ),
        
# QUALITATIVE    
        fluidRow(width=12, 
                 column(8,    
                        div(
                            h2 (HTML("Categorical &nbsp;&nbsp;\u25be"), style="font-weight:500"),
                            "This option allows you to color kinase nodes different colors according to user-defined group assignments. 
                            It is a useful option when differentiating between multiple categories, such as different 
                            kinases families.",
                            tags$br(),tags$br(),
                            "The Categorical option will automatically generate a figure legend showing the color and category name for each 
                            category listed. Categories will be listed in alphabetical order, and colors will be assigned accordingly.",
        
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/NC-4a.png",width="100%",align="left",
                                                    tags$style("img[src='info/NC-4a.png'] {padding-top: 4px}")
                                            )
                                            )
                                     ),
                                     column(9,
                                            div(  
                                                h4 (HTML("\u25ce&nbsp; Load default kinase groups")),
                                                "This button will load the default kinase groups as defined by Manning et al 2002 into the 'Kinases & Group' 
                                                field. These groups include AGC, CAMK, CK1, CMGC, RGC, STE, TK, and TKL, as well as Atypical and Others 
                                                which fall outside of those group assignments.",
                     
                                                h3 ("Kinases & Category"),
                                                "Here you can submit a two-column list of kinases and their category assignments. A space, tab, or new line 
                                                must separate each kinase from its corresponding category assignment. Every kinase listed must have a category 
                                                assignment, or plotting will fail. Including kinases with more than one category assignment will result in 
                                                that kinase being colored according to the last category listed alphabetically. Identifiers not found within 
                                                the tree will be ignored. Kinases that are not listed will be colored gray and excluded from the 
                                                figure legend.",
                         
                                                h3 ("Identifier"),
                                                "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                                                In order to properly plot your selected nodes, you must specify the identification used in the 
                                                'Kinases & Category' space.",
                                                
                                                h4 (HTML("\u25ce&nbsp; Manual category entry")),
                                                "This option brings up a text field wherein you can enter your categories in the order in which you want them 
                                                to appear in the legend, overriding the default alphabetical order. The order of the colors in the selected
                                                palette will not change.
                                                
                                                Note - This option is valuable for keeping the color/category assignments consistent between mutliple plots.",
                                                
                                                h3 ("Categories"),
                                                "This is the field in which to list categories in your preferred order. Category names must be separated by
                                                a new line.",
                         
                                                h3 ("Palette Type"),
                                                "Your categories will be colored using a prebuilt palette, or you may create your own. Each palette will  
                                                automatically expand to accommodate as many categories as you have identified in the 'Kinases & Category' field.",
                                                
                                                h4 (HTML("\u2609&nbsp; Prebuilt")),
                                                "Here you can choose between Coral's default colorblind-friendly 12-color palette and Color Brewer's eight qualitative 
                                                palettes.",
                                                
                                                h4 (HTML("\u2609&nbsp; Manual")),
                                                "Here you can create a palette with up to twelve  colors using the color picker boxes. The hex values are not shown, 
                                                but if you wish to enter a hex value you may still do so: Select a color box, double-click or press Command-A 
                                                (or Ctrl-A), and enter the value.",
                         
                                                h3 ("Color Missing Kinases"),
                                                "This option allows you to select a color for kinases that are not listed in the 'Kinases & Value' field
                                                by using the color picker box to find a color or enter a hex value. This color defaults to light gray. 
                                                This color will not be included in the figure legend."
                                                
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/NC-4b.png",width="100%",align="left",
                                tags$style("img[src='info/NC-4b.png'] {padding-top: 20px}")
                        )
                        )
                 )
        ),
        
# QUANTITATIVE
        fluidRow(width=12, 
                 column(8, 
                        div(
                            h2 (HTML("Quantitative &nbsp;&nbsp;\u25be"), style="font-weight:500"),
                            "This option allows you to color kinase nodes based on a range of quantitative values. It is useful 
                            when presenting a range of values, such as fold change or signal data.",
                            tags$br(),tags$br(),
                            "The Quantitative option will automatically generate a figure legend showing the full spectrum of possible 
                            colors and indicating the corresponding low, middle, and high values.",
        
                            fluidRow(width=12,
                                     column(3, tags$br(), 
                                            div(img(src="info/NC-5a.png",width="100%",align="left",
                                                    tags$style("img[src='info/NC-5a.png'] {padding-top: 4px}")
                                            )
                                            )
                                     ),
                                     column(9,        
                                            div(
                                                h4 (HTML("\u25ce&nbsp; Load example data")),
                                                "This button will load sample data into the 'Kinases & Value' field.",
                     
                                                h3 ("Kinases & Value"),
                                                "Here you can submit a two-column list of kinases and their associated values. A space, tab, 
                                                or new line must separate each kinase from its corresponding value. Every kinase listed must 
                                                have a value, or plotting will fail. Listing the same kinase multiple times with different values 
                                                will result in the node being colored according to the last listed value. Identifiers not found 
                                                within the tree will be ignored. Kinases that are not listed will be colored according to the 
                                                'Color Missing Kinase' settings (see below).",
                         
                                                h3 ("Identifier"),
                                                "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
                                                In order to properly plot your selected nodes, you must specify the identification used in 
                                                the 'Kinases & Category' field.",
                                                
                                                h3 ("Legend Subtitle"),
                                                "This text box allows you to provide a subtitle for the Node Color legend",
                         
                                                h3 ("Min Value & Max Value"),
                                                "This option allows you to set the values that will represent either end of the color spectrum. 
                                                All values below the assigned Min Value will be colored as though they were the set minimum value, 
                                                and all values above the assigned Max Value will be colored as though they were the set maximum value.",
                         
                                                h3 ("Palette Type"),
                                                "These options allow you to choose between several prebuilt sequential and divergent color palettes 
                                                or create your own 2- or 3-color gradient using color selectors. Sequential palettes are useful for 
                                                continuously increasing data, such as raw signal from RNA-Seq. Divergent palettes are useful for 
                                                depicting data with both positive and negative values, such as fold change. Manual 2-color gradients 
                                                require a high and low color setting, while 3-color gradients require a high, low, and middle. 
                                                Each color can be selected by using the color picker box to find a color or enter a hex value.",
                         
                                                h3 ("Reverse Palette"),
                                                "This button will automatically swap the minimum and maximum colors of any palette.",
                         
                                                h3 ("Color Missing Kinases"),
                                                "By default, kinases that were not listed in the 'Kinases & Value' field will be automatically colored 
                                                according to the lowest (in sequential or 2-color palettes) or middle value 
                                                (in divergent or 3-color palettes). You can opt to instead color these missing kinases manually, 
                                                which will bring up a 'Missing Kinase Color' selector where you can use the drop-down box to find a 
                                                color or enter a hex value.",
                                                tags$br(),
                                                tags$br(),
                                                tags$br()
                                            )
                                     )
                            )
                        )
                 ),
                 column(4, 
                        div(img(src="info/NC-5b.png",width="100%",align="left",
                                tags$style("img[src='info/NC-5b.png'] {padding-top: 4px}")
                        )
                        )
                 )
        )
        
    ) # end box
) # end div
