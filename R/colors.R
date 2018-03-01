

# Define a function that prints color palettes 
drawpalettes <- function(palette="RdBu",outdir="images")
{
 # open png
 pngname = paste(outdir,"/",palette,".png",sep="")
 png(filename = pngname,width = 5*15,height=15)
 
 # make plotting area
 par(oma=c(0,0,0,0),mar=c(0,0,0,0))
 plot(1,type="n",xlim = c(0,5*15),ylim=c(0,15),xaxs="i",yaxs="i",bty="n",xaxt="n",yaxt="n")
 
 # add squares
 cols = brewer.pal(5,palette)
 for (i in 1:5)
 {
  rect(xleft = (i-1) * 15,xright = i*15,ybottom = 0 , ytop = 15,border = NA,col = cols[i])
 }
 
 dev.off()
}


# Define a function that prints color palettes 
drawmypalettes <- function(paletteName="RdBu",palette=c("white","blue"),outdir="~/Desktop")
{
 # open png
 pngname = paste(outdir,"/",paletteName,".png",sep="")
 png(filename = pngname,width = 5*15,height=15)
 
 # make plotting area
 par(oma=c(0,0,0,0),mar=c(0,0,0,0))
 plot(1,type="n",xlim = c(0,5*15),ylim=c(0,15),xaxs="i",yaxs="i",bty="n",xaxt="n",yaxt="n")
 
 # add squares
 cols = colorRampPalette(palette)(5)
 for (i in 1:5)
 {
  rect(xleft = (i-1) * 15,xright = i*15,ybottom = 0 , ytop = 15,border = NA,col = cols[i])
 }
 
 dev.off()
}


