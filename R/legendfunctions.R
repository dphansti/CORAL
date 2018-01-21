

# Define a function that makes boxes and labels for groupt type legends
build.group.legend.elements <- function(x=99.208,y,color,width=6.584,height=6.584,label="group",fontsize=5,fontfamily="'AvenirNext-Bold'")
{
  # build the square
  square = paste("<rect x=\"", x,"\"",
                 " y=\"", y, "\"",
                 "fill=\"", color, "\"",
                 "width=\"", width, "\"",
                 "height=\"", height,"\"/>",
                 sep="")

  
  # build the text
  textx = 110.8889
  texty = y - 8.6224
  text = paste("<text x=\"", textx,"\"",
                 " y=\"", y, "\"",
                 "font-size=\"", fontsize, "\"",
                 "font-family=\"", fontfamily,"\">",
                  label,"</text>",
                 sep="")
  
  
  return(c(square,text))
}



build.group.legend  <- function(yoffset=0,groupslabels,groupcolors)
{
  # write the header
  header = paste("<text x=\"98.8075\"",
  "y=\"", 87.9701, "\"",
  " font-family=\"'AvenirNext-Bold'\" ",
  "font-size=\"9px\">Branch Color</text>",
  sep="")
  
  # write the grey line
  greylineheight = 14 * length(groupslabels) + 20 + 7
  greyline       = paste("<rect x=\"", 89.807,"\"",
                 " y=\"", 79.125, "\"",
                 "fill=\"", "#D3D3D3", "\"",
                 "width=\"", 2.333, "\"",
                 "height=\"", greylineheight,"\"/>",
                 sep="")
  
  # add all of the labels
  legendstuff = c()
  y = yoffset + 33
  for (i in 1:length(groupslabels))
  {
    legendstuff = c(legendstuff,
                    build.group.legend.elements(
                      x=99.208,
                      y=y,
                      color = groupcolors[i],
                      width=6.584,
                      height=6.584,
                      label=groupslabels[i],
                      fontsize=5,
                      fontfamily="'AvenirNext-Bold'")
    )
    y = y + 14
  }
  
  return (c(header,greyline,legendstuff))
}



lines = build.group.legend(yoffset=0,groupslabels=c("",""),groupcolors=c("#2A97D3","#3C91C2"))
writeLines(lines)

