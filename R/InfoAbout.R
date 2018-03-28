div(id="InfoAboutBox",
    box(width="100%", style = "background-image: url('logos/bgtest2.png'); 
                               background-size: cover; background-repeat: no-repeat",
        
        fluidRow(width=12, 
                 column(5,
                        
                        div(img(src="logos/coral-logo-gray-crop.png",width="100%",align="left"),
                                tags$style("img[src='logos/coral-logo-gray-crop.png'] 
                                           {padding-top: 100px; padding-bottom: 5%}"
                                )
                        )
                 )
        ),
        
        fluidRow(width=12, 
                 column(8,
                        div(
                        
                            h2 ("Highly-customizable visualizations of qualitative and quantitative kinase attributes", 
                                style="color:#eceff3; font-weight: 500; font-size: 150%; letter-spacing:.4px"),
                            tags$br(),
                            h6 ("CORAL is an R Shiny app that allows flexible and highly customizable visualization of kinase attributes.",
                                style="color:#eceff3; font-weight:400; font-size: 110%; letter-spacing:.4px"),
                            h6 ("At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque
                            corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt 
                            in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum 
                            facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque 
                            nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis
                            dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe 
                            eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur
                            a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus
                            asperiores repellat.",
                            style="color:#eceff3; font-weight:300; font-size: 110%; line-height: 150%; letter-spacing:.4px"),
                            
                            tags$br(), tags$br(), tags$br(),
                            
                            h4 ("Citation",
                                style="font-weight: 400"),
                            "CORAL was initially described in the following publication:",
                            tags$br(),
                            "asdfsaf et al, 2018",
                            tags$br(),
                            "CORAL makes use of phyolgenetic information derived from Manning et al, Science, 2002", style="color:#abbed1; font-weight:300; letter-spacing:.4px",
                            
                            tags$br(), tags$br(), tags$br()
                        )
                 )
        )
    )
)