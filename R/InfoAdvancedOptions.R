div(id="InfoAdvancedOptionsBox",
    
    box(width="100%",
        div(
         h1 ("Title"),
         "This tab allows you to input a title for the plot. This option will only affect the Tree plot."
        ),
        div(
         h1 ("Font"),
         "This tab allows you to change global font settings as well as kinase label colors. Font style 
         and color changes will on affect the Tree plot."
        ),
        div(
         h2 ("Choose Font"),
         "You can change the font to use for all kinase labels, family labels, and titles in the Tree plot."
        ),
        div(
         h2 ("Label Font Size"),
         "You can also change the font size for all kinase labels, family labels, and titles. 
         This setting will apply to all plots."
        ),
        div(
         h2 ("Label Color"),
         "This option allows you to change the kinase label colors either uniformly or based on branch color."
        ),
        div(
         h3 ("Single Color"),
         "The default option is to use the same color font (black) for all kinase labels. 
         You can alternatively change the color of all labels by using the 'Label Color' drop-down box 
         to find a color or enter a hex value."
        ),
        div(
         h3 ("Same as Branch"),
         "Another option is to color the kinase labels the same color as their branches. 
         This can work especially well when nodes are disabled and you are trying to highlight the names 
         of kinases in specific qualitative groups or quantitative extremes."
        ),
        div(
         h1 ("Node"),
         "This tab allows you to change the color of node outlines depending on the desired look of your 
         tree and the data you are trying to visualize. Using the 'Node Stroke Color Scheme' menu, you can 
         assign all strokes to a single color using the Uniform setting, color strokes the same as the nodes 
         themselves using Same as Node, or highlight specific kinase nodes of interest with unique stroke 
         colors using Manual."
        ),
        div(
         h2 ("Uniform"),
         "This option allows you to color all node strokes in the tree a single uniform color. This is a useful 
         option for personalizing your tree nodes."
        ),
        div(
         h3 ("Node Stroke Color"),
         "A color-selector used to change the color of all node strokes. By default, node strokes are uniformly 
         colored white. You can change this color by using the drop-down box to find a color or entering a hex value. "
        ),
        div(
         h2 ("Same as Node"),
         "This option automatically sets the node stroke color to the color of the node itself, as determined 
         by the 'Node Color' settings."
        ),
        div(
         h2 ("Manual"),
         "This option allows you to color strokes of specific nodes of interest. This can be useful for 
         highlighting specific kinases when node and branch colors are already conveying important information. "
        ),
        div(
         h3 ("Kinase Input Method"),
         "Here you can select the method you would like to use to identify kinases of interest. "
        ),
        div(
         h4 ("Select"),
         "Creates a scrollable and searchable list of all kinases featured on the tree. This feature is most useful 
         when trying to highlight a small number of kinases"
        ),
        div(
         h4 ("Paste"),
         "Creates a space to copy a list of kinases to highlight, each kinase separated by a new line. This feature 
         is useful when trying to highlight a larger number of kinases, or if you have a pre-existing list of kinases 
         from a spreadsheet or other document."
        ),
        div(
         h3 ("Kinases"),
         "This is the space where you may select or input your list of kinases to highlight, depending on your 
         preferred input method."
        ),
        div(
         h3 ("Identifier Type"),
         "Kinases can be listed or selected by either their coralID, uniprot, ensemble, entrez, or HGNC ID. 
         In order to properly plot your selected branches, you must specify the identification used in the 
         'Kinases' space."
        ),
        div(
         h3 ("BG Color & Selected Color"),
         "Here you can change branch colors for both your selected and unselected kinases. The BG Color sets 
         the color of kinases that were not listed, while Selected Color sets the color of the kinases you have 
         identified and are trying to highlight. You can use the drop-down box to find a color or enter a hex value."
        ),
        div(
         h3 ("Reverse Palette"),
         "This button will automatically swap the BG and selected colors."
        )
    ) # end box
) # end div