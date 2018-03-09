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
        )
    ) # end box
) # end div