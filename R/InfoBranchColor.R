div(id="InfoBranchColorBox",
    box(width="100%",
        div(
         h1 ("Color Scheme"),
         "Select a method with which to assign branch colors."
        ),
        div(
         h2 ("Uniform"),
         "This option allows you to color every branch as a single uniform color. "
        ),
        div(
         h3 ("Branch Color"),
         "A color-selector used to change the color of all branches."
        ),
        div(
         h2 ("Manual"),
         "This option allows you to highlight branches to specific kinases of interest. "
        ),
        div(
         h3 ("Kinase Input Method"),
         "Select the method you would like to use to identify kinases of interest."
        ),
        div(
         h4 ("Select"),
         "Scroll through a searchable list of all kinases available on the tree. "
        ),
        div(
         h4("Paste"),
         "Submit a list of kinases. (do names matter? Format?)"
        ),
        div(
         h3 ("Kinases"),
         "Select or input your list of kinases to highlight."
        ),
        div(
         h3 ("BG Color & Color"),
         "Select colors for your selected and unselected kinases."
        ),
        div(
         h3 ("(Other option for titles??)"),
         "Change the legend labels for selected and unselected kinases."
        ),
        div(
         "This option will automatically create a figure legend indicating the colors of selected and not selected kinases."
        ),
        div(
         h2 ("Qualitative"),
         "This option allows you to color kinase branches of different colors, to differentiate between multiple categories."
        ),
        div(
         h3 ("Load default kinase groups"),
         "Load the default kinase groups as defined by Manning et al 2002 into the 'Kinases & Group' tab."
        ),
        div(
         h3 ("Kinases & Group"),
         "Submit a two-column list of kinases and their group assignments." 
        ),
        div(
         h3 ("Identifier Type"),
         "Select the kinase identifier used to list kinases in the 'Kinases & Group' tab (coralID, uniprot, ensemble, entrez, HGNC)."
        ),
        div(
         h3 ("Color Range Type"),
         "Color groups based on pre-built color palettes, or manually assign colors."
        ),
        div(
         h3 ("Manual Group Entry"),
         "???????"
        ),
        div(
         "This option will automatically create a figure legend showing the color and group name for each category listed."
        ),
        div(
         h2 ("Quantitative"),
         "This option allows you to color kinase branches based on a range of qualitative values"
        ),
        div(
         h3 ("Load example data"),
         "Load sample data into the 'Kinases & Value' tab."
        )
    ) # end box
) # end div
















