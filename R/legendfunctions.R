

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
  heatrange = seq(minval,maxval,length.out = 11)
  legcols = map2color(x=heatrange,pal=palette,limits=NULL)
  
  # Draw the rectangle
  rects = c()
  for (i in 1:11)
  {
    rects = c(rects, drawrect (x=92.632 + (6.576 * i), y=yoffset + 26.51 ,fill=legcols[i],width=6.584,height=11.27))
  }

  text.min = paste("<text x=\"", 98.8075,"\"",
               " y=\"", yoffset + 23.1251, "\"",
               " font-size=\"", "5px", "\"",
               " font-family=\"", "'AvenirNext-Bold'","\">",
               minval,"</text>",
               sep="")
  
  text.mid = paste("<text x=\"", 133.8944,"\"",
               " y=\"", yoffset + 23.1251, "\"",
               " font-size=\"", "5px", "\"",
               " font-family=\"", "'AvenirNext-Bold'","\">",
               mean(c(minval , maxval)),"</text>",
               sep="")
  
  text.max = paste("<text x=\"", 166.7776,"\"",
               " y=\"", yoffset + 23.1251, "\"",
               " font-size=\"", "5px", "\"",
               " font-family=\"", "'AvenirNext-Bold'","\">",
               maxval,"</text>",
               sep="")
  
  output = c(header, greyline, rects, text.min, text.mid, text.max)
  yoffset = yoffset + 41.58
  
  return(list(output,yoffset))
}


# build.value.legend(yoffset=79,minval=-5,maxval=5, palette=colorRampPalette(c("blue","red")),elementtype = "Branch")


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

