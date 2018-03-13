div(id="InfoNodeSizeBox",
    box(width="100%",
        div(
         h1 ("Sizing Scheme (???)"),
         "Select a method with which to assign node sizes"
        ),
        div(
         h2 ("Uniform"),
         "This option allows you to change the size of all nodes in the tree."
        ),
        div(
         h3 ("Node Size"),
         "Use the slider to select a size for all nodes."
        ),
        div(
         h2 ("Quantitative"),
         "This option allows you to scale nodes according to a list of quantitative values."
        ),
        div(
         h3 ("Load example data"),
         "Load sample data into the 'Kinases & Value' tab."
        ),
        div(
         h3 ("Kinases & Value(s ?)"),
         "Submit a two-column list of kinases and their associated values."
        ),
        div(
         h3 ("Identifier Type"),
         "Select the kinase identifier used to list kinases in the 'Kinases & Group' tab (coralID, uniprot, ensemble, entrez, HGNC)."
        ),
        div(
         h3 ("Size Range"),
         "Use the slider to select a range of node sizes to plot. The values entered under 'Kinases & Group' will be scaled to those minimum and maximum sizes."
        ),
        div(
         h3 ("Manually set data range"),
         "An option to set the range of data to scale to the size range. If selected, input a minimum and maximum value to assign to the minimum and maximum sizes selected under 'Size Range'. All values below the minimum value will be scaled to the minimum size, and all values above the maximum value will be scaled to the maximum size."
        )
    ) # end box
) # end div