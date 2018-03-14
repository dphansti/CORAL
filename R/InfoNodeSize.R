div(id="InfoNodeSizeBox",
    box(width="100%",
        div(
         h1 ("Size Scheme"),
         "CORAL also allows you to change node size depending on the desired look of your tree and 
         the data you are trying to visualize. You can set all nodes to a single size using the Uniform 
         setting or scale nodes according to numerical data using the Quantitative setting."
        ),
        div(
         h2 ("Uniform"),
         "This option allows you to set all nodes in the tree to a single size of your choosing using 
         the 'Node Size' slider."
        ),
        div(
         h2 ("Quantitative"),
         "This option allows you to color kinase branches based on a range of qualitative values. 
         It is a useful option when trying emphasize kinases with larger values, for example the 
         kinases with the highest expression levels in a dataset."
        ),
        div(
         h3 ("Load example data"),
         "This button will load sample data into the 'Kinases & Value' tab."
        ),
        div(
         h3 ("Kinases & Value"),
         "Here you can submit a two-column list of kinases and their associated values. A space, tab, 
         or new line must separate each kinase from its corresponding value. Every kinase listed must 
         have a value, or plotting will fail. Listing the same kinase multiple times with different 
         values will result in the branch being sized according to the last listed value. Identifiers 
         not found within the tree will be ignored. Kinases that are not listed will lack a node entirely."
        ),
        div(
         h3 ("Identifier Type"),
         "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
         In order to properly plot your selected branches, you must specify the identification used in the 
         'Kinases & Group' space."
        ),
        div(
         h3 ("Size Range"),
         "This slider allows you to select a range of node sizes to plot. The values entered under 
         'Kinases & Group' will be scaled to these minimum and maximum sizes."
        ),
        div(
         h3 ("Manually set data range"),
         "By default, the smallest value will be set to the smallest node size, and the largest value 
         will be set to the largest node size. You can opt instead to manually set Max and Min Values, 
         in which case all values below the assigned minimum will be the set minimum size, and all values 
         above the assigned maximum will be the set maximum size."
        ),
        div(
         "This option will automatically create a figure legend showing six nodes in the full range of 
         node sizes and indicating the corresponding minimum and maximum values."
        )
    ) # end box
) # end div