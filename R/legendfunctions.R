

# Define a function that makes boxes and labels for group type legends
build.group.legend.elements <- function(x=99.208,y,color,width=6.584,height=6.584,label="group",fontsize=5,fontfamily="'AvenirNext-Bold'",elementtype="Branch")
{
  # build the square
  square = paste("<rect x=\"", x,"\"",
                 " y=\"", y, "\"",
                 " fill=\"", color, "\"",
                 " width=\"", width, "\"",
                 " height=\"", height,"\"/>",
                 sep="")

  # build the circle
  circle = paste("<circle cx=\"", x + width/2,"\"",
                 " cy=\"", y+ width/2 , "\"",
                 " fill=\"", color, "\"",
                 " r=\"", width/2, "\"/>",
                 sep="")

  
  # build the text
  textx = 110.8889
  texty = y + 4.5
  text = paste("<text x=\"", textx,"\"",
                 " y=\"", texty, "\"",
                 " font-size=\"", fontsize, "\"",
                 " font-family=\"", fontfamily,"\">",
                  label,"</text>",
                 sep="")
  
  if (elementtype == "Branch")
  {
   return(c(square,text))
  }
  
  if (elementtype == "Node")
  {
    return(c(circle,text))
  }
  
}


# Define a function that builds a legend for group color
build.group.legend  <- function(yoffset=0,groupslabels,groupcolors,elementtype = "Branch")
{
  # write the header
  header = paste("<text x=\"98.8075\"",
  " y=\"", yoffset + 8.8451, "\"",
  " font-family=\"'AvenirNext-Bold'\" ",
  " font-size=\"9px\">", elementtype," Color</text>",
  sep="")
  
  # write the grey line
  greylineheight = 14 * length(groupslabels) + 14
  greyline       = paste("<rect x=\"", 89.807,"\"",
                 " y=\"", yoffset, "\"",
                 " fill=\"", "#D3D3D3", "\"",
                 " width=\"", 2.333, "\"",
                 " height=\"", greylineheight,"\"/>",
                 sep="")
  
  # add all of the labels
  legendstuff = c()
  yoffset = yoffset + 19
  for (i in 1:length(groupslabels))
  {
    legendstuff = c(legendstuff,
                    build.group.legend.elements(
                      x=99.208,
                      y=yoffset,
                      color = groupcolors[i],
                      width=6.584,
                      height=6.584,
                      label=groupslabels[i],
                      fontsize=5,
                      fontfamily="'AvenirNext-Bold'",
                      elementtype)
    )
    yoffset = yoffset + 14
  }
  
  return (list(c(header,greyline,legendstuff),yoffset))
}



# Define a function that draws a rect
drawrect <- function(x,y,fill,width=6.584,height=11.27)
{
  rectline = paste("<rect x=\"",x,"\"",
                   " y=\"",y,"\"",
                   " fill=\"",fill,"\"",
                   " width=\"",width,"\"",
                   " height=\"",height, "\"/>", 
                   sep = "")
  
  return (rectline)
}


# Define a function that builds a legend for values
build.value.legend  <- function(yoffset=0,minval,maxval, palette,elementtype = "Branch")
{
  # write the header
  header = paste("<text x=\"98.8075\"",
                 " y=\"", yoffset + 8.8451, "\"",
                 " font-family=\"'AvenirNext-Bold'\" ",
                 " font-size=\"9px\">", elementtype," Color</text>",
                 sep="")
  
  # write the grey line
  greylineheight = 41.58
  greyline       = paste("<rect x=\"", 89.807,"\"",
                         " y=\"", yoffset, "\"",
                         " fill=\"", "#D3D3D3", "\"",
                         " width=\"", 2.333, "\"",
                         " height=\"", greylineheight,"\"/>",
                         sep="")
  
  # add the gradient
  
  
  #drawrect (x,y,fill,width=6.584,height=11.27)

  
  # 
  # 
  # 
  # <rect x="99.208" y="105.635" fill="#2A97D3" width="6.584" height="11.27"/>
  #   <rect x="105.784" y="105.635" fill="#3C91C2" width="6.584" height="11.27"/>
  #   <rect x="112.361" y="105.635" fill="#4E8AB1" width="6.584" height="11.27"/>
  #   <rect x="118.937" y="105.635" fill="#61849F" width="6.584" height="11.27"/>
  #   <rect x="125.514" y="105.635" fill="#737D8E" width="6.584" height="11.27"/>
  #   <rect x="132.09" y="105.635" fill="#85777D" width="6.584" height="11.27"/>
  #   <rect x="138.667" y="105.635" fill="#97716C" width="6.584" height="11.27"/>
  #   <rect x="145.244" y="105.635" fill="#A96A5B" width="6.584" height="11.27"/>
  #   <rect x="151.82" y="105.635" fill="#BC6449" width="6.584" height="11.27"/>
  #   <rect x="158.397" y="105.635" fill="#CE5D38" width="6.584" height="11.27"/>
  #   <rect x="164.973" y="105.635" fill="#E05727" width="6.584" height="11.27"/>
  #   <text transform="matrix(1 0 0 1 98.8075 102.2501)" font-family="'AvenirNext-Bold'" font-size="5px">-5</text>
  #   <text transform="matrix(1 0 0 1 133.8944 102.2501)" font-family="'AvenirNext-Bold'" font-size="5px">0</text>
  #   <text transform="matrix(1 0 0 1 166.7776 102.2501)" font-family="'AvenirNext-Bold'" font-size="5px">5</text>
  
}




# # Set initial yoffset
# yoffset = 79.125
# 
# # build legend for Branch Color (by group)
# lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=c("group 1","group 2"),groupcolors=c("#D3D3D3","#3C91C2"),elementtype = "Branch")
# lines = lines_and_offset[[1]]
# yoffset = lines_and_offset[[2]] + 14
# 
# # build legend for Node Color (by group)
# lines_and_offset = build.group.legend(yoffset=yoffset,groupslabels=c("group 1","group 2"),groupcolors=c("#D3D3D3","#3C91C2"),elementtype = "Node")
# lines = c(lines,lines_and_offset[[1]])
# yoffset = lines_and_offset[[2]] + 14
# 
# writeLines(lines)

