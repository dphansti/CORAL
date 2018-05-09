div(id="InfoAboutBox",
    box(width="100%", style = "background-image: url('logos/about-bg.png'); 
                               background-size: cover; background-repeat: no-repeat",
        
        fluidRow(width=12, 
                 column(5,
                        
                        div(img(src="logos/coral-logo-gray-crop.png",width="100%",align="left"),
                                tags$style("img[src='logos/coral-logo-gray-crop.png'] 
                                           {padding-top: 55px; padding-bottom: 5%}"
                                )
                        )
                 )
        ),
        
        fluidRow(width=12, 
                 column(9,
                        div(
                            h2 ("Interactive, customizable, high-resolution visualization of the human kinome", 
                                style="color:#eceff3; font-weight: 500; font-size: 150%; letter-spacing:.4px"),
                            tags$br(),
                           
                            h6 ("The human kinome comprises over 500 protein kinases which regulate a wide array of cellular 
                                processes; they have become attractive drug targets and are increasingly studied using genomic,
                                proteomic, and kinase profiling approaches. CORAL is an open source web application that facilitates
                                interactive, customizable visualization of kinase attributes and experimental data. Qualitative and 
                                quantitative kinase attributes are encoded in edge colors, node colors, and node sizes of the human 
                                kinome network, which can be represented in a tree format, a circular radial network, and a dynamic 
                                force-directed network. Due to its ease of use, interactivity, and broad selection of features, we envision 
                                that CORAL plots will become a staple of publications describing high-throughput studies of the human kinome.",
                            style="color:#eceff3; font-weight:300; font-size: 110%; line-height: 150%; letter-spacing:.4px")
                        )
                 )
        ),
                            
                           
        fluidRow(width=12, style="padding-top:5%",
                 column(1, style="width:10%",
                            h4 ("Code")
                 ),
                 column(10,
                            h6 ("The code is available at ", tags$a(href="https://github.com/dphansti/CORAL", "Github."))
                 )
        ),
        tags$br(),
        fluidRow(width=12, 
                 column(1, style="width:10%",
                            h4 ("Credit")
                 ),
                 column(10,
                            h6 ("CORAL was developed in the ", tags$a(href="http://phanstiel-lab.med.unc.edu/", "Phanstiel Lab"),
                            " at UNC by Katie Metz, Erika Deoudes, Matt Berginski, Ivan Ruiz Jimenez, and Doug Phanstiel."),
                            h6 ("CORAL is written in R and relies on the following packages: shiny, shinydashboard, shinyBS, readr, rsvg, shinyWidgets, RColorBrewer."), 
                            h6 ("Circle and Force Layouts are written in javascript using the amazing ",
                            tags$a(href="https://d3js.org/", "D3 library."))
                 )
        ),
        tags$br(),
        fluidRow(width=12, 
                 column(1, style="width:10%",
                            h4 ("Contact")
                 ),
                 column(10,
                            h6 ("To report issues or make requests, please post an issue on our ", tags$a(href="https://github.com/dphansti/CORAL", "Github repo"),
                            " or ", tags$a(href="mailto:douglas_phanstiel@med.unc.edu", "email us directly."))
                 )
        ),
        tags$br(),
        fluidRow(width=12, 
                 column(1,  style="width:10%",
                            h4 ("Citation")
                 ),
                 column(10, 
                            h6 ("CORAL was initially described in by Metz et al, 2018."),
                            h6 ("CORAL makes use of phylogenetic information derived from Manning et al, Science, 2002."),
                            h6 ("The Tree plots made by CORAL were modified from those created by Cell Signaling Technology: ",
                            tags$a(href="https://www.cellsignal.com/", "www.cellsignal.com")),
                            tags$br(), tags$br(), tags$br()
                        
                 )
        )
    )
)