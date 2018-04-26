

# Define a function that makes boxes and labels for group type legends
build.group.legend.elements <- function(x=99.208,y,color,width=6.584,height=6.584,label="group",fontsize=5,elementtype="Branch",fontfamily="'AvenirNext-Bold'")
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
                 " font-weight=\"700\" ",
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
build.group.legend  <- function(yoffset=0,groupslabels,groupcolors,elementtype = "Branch",fontfamily="'AvenirNext-Bold'")
{
  # write the header
  header = paste("<text x=\"98.8075\"",
  " y=\"", yoffset + 8.8451, "\"",
  " font-family=\"", fontfamily, "\" ",
  " font-weight=\"700\" ",
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
                      fontfamily=fontfamily,
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
build.value.legend  <- function(yoffset=0,minval,maxval, palette,elementtype = "Branch",fontfamily="'AvenirNext-Bold'",subtitle="test")
{
  # write the header
  header = paste("<text x=\"98.8075\"",
                 " y=\"", yoffset + 8.8451, "\"",
                 " font-family=\"", fontfamily, "\" ",
                 " font-weight=\"700\" ",
                 " font-size=\"9px\">", elementtype," Color</text>",
                 sep="")
  
  subtitle.height = 0
  if (subtitle != ""){subtitle.height = 8.8451}
  
  # write the grey line
  greylineheight = 41.58 + subtitle.height
  greyline       = paste("<rect x=\"", 89.807,"\"",
                         " y=\"", yoffset, "\"",
                         " fill=\"", "#D3D3D3", "\"",
                         " width=\"", 2.333, "\"",
                         " height=\"", greylineheight,"\"/>",
                         sep="")
  
  # add the subtitle
  if (subtitle != ""){
   
   yoffset = yoffset + 8.8451
   
   subtitleline = paste("<text x=\"98.8075\"",
         " y=\"", yoffset + 8.8451*1.5, "\"",
         " font-family=\"", fontfamily, "\" ",
         " font-weight=\"700\" ",
         " font-size=\"7px\">", subtitle,"</text>",
         sep="")
   }
  
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
               " font-weight=\"700\" ",
               " font-family=\"", fontfamily, "\">",
               minval,"</text>",
               sep="")
  
  text.mid = paste("<text x=\"", 133.8944,"\"",
               " y=\"", yoffset + 23.1251, "\"",
               " font-size=\"", "5px", "\"",
               " font-weight=\"700\" ",
               " font-family=\"", fontfamily, "\">",
               mean(c(minval , maxval)),"</text>",
               sep="")
  
  text.max = paste("<text x=\"", 166.7776,"\"",
               " y=\"", yoffset + 23.1251, "\"",
               " font-size=\"", "5px", "\"",
               " font-weight=\"700\" ",
               " font-family=\"", fontfamily,"\">",
               maxval,"</text>",
               sep="")
  
  # assemble output
  output = c(header, greyline, rects, text.min, text.mid, text.max)
  if (subtitle != "")
  {
    output = c(header, subtitleline, greyline, rects, text.min, text.mid, text.max)
  }
  
  yoffset = yoffset + 41.58
  return(list(output,yoffset))
}





# Define a function that builds a legend for values
build.nodesize.legend  <- function(yoffset=0,minval,maxval,minsize ,maxsize,fontfamily="'AvenirNext-Bold'",subtitle="test")
{
  extrayoff = 0
 
  if (maxsize > 6)
  {
   extrayoff = maxsize - 6
  }
 
  # write the header
  header = paste("<text x=\"98.8075\"",
                 " y=\"", yoffset + 8.8451, "\"",
                 " font-weight=\"700\" ",
                 " font-family=\"", fontfamily, "\" ",
                 " font-size=\"9px\">","Node Size</text>",
                 sep="")

  subtitle.height = 0
  if (subtitle != ""){subtitle.height = 8.8451}
  
  # write the grey line
  greylineheight = 41.58 + 2 * extrayoff + subtitle.height
  greyline       = paste("<rect x=\"", 89.807,"\"",
                         " y=\"", yoffset, "\"",
                         " fill=\"", "#D3D3D3", "\"",
                         " width=\"", 2.333, "\"",
                         " height=\"", greylineheight,"\"/>",
                         sep="")
  
  # add the subtitle
  if (subtitle != ""){
   
   yoffset = yoffset + 8.8451
   
   subtitleline = paste("<text x=\"98.8075\"",
                    " y=\"", yoffset + 8.8451*1.5, "\"",
                    " font-family=\"", fontfamily, "\" ",
                    " font-weight=\"700\" ",
                    " font-size=\"7px\">", subtitle,"</text>",
                    sep="")
  }
  
  # Make circles
  circles = c()
  
  xs = c(100.266,109.45,120.846,134.454,150.273,168.303)
  
  sizes = seq(minsize,maxsize,length.out = length(xs))
  
  for (i in 1:length(xs))
  {
    circle = paste("<circle cx=\"", xs[i] ,"\"",
                   " cy=\"", yoffset + 33.932 + extrayoff, "\"",
                   " fill=\"", "#D3D3D3", "\"",
                   " stroke=\"white\"",
                   " r=\"", sizes[i], "\"/>",
                   sep="")
    circles = c(circles,circle)
  }
  
  # add text labels
  text.min = paste("<text x=\"",  min(xs),"\"",
                   " y=\"", yoffset + 23.1251, "\"",
                   " font-size=\"", "5px", "\"",
                   " text-anchor=\"middle\"",
                   " font-weight=\"700\" ",
                   " font-family=\"", fontfamily, "\">",
                   minval,"</text>",
                   sep="")
  text.max = paste("<text x=\"",  max(xs),"\"",
                   " y=\"", yoffset + 23.1251, "\"",
                   " font-size=\"", "5px", "\"",
                   " text-anchor=\"middle\"",
                   " font-weight=\"700\" ",
                   " font-family=\"", fontfamily, "\">",
                   maxval,"</text>",
                   sep="")
  
  # asssemble output
  output = c(header, greyline, circles, text.min, text.max)
  if (subtitle != "")
  {
   output = c(header, greyline,subtitleline,  circles, text.min, text.max)
  }
  yoffset = yoffset + 41.58 + extrayoff
  return(list(output,yoffset))
}

