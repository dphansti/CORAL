
# make a well formatted svg data frame
a = orig_svginfo$dataframe

xs = c()
ys = c()
for (i in 1:nrow(a))
{
  splitline = unlist(strsplit(as.character(a[i,4]),split=" "))
  x = splitline[length(splitline)-1]
  y = gsub(pattern = ")\"",replacement = "",x = splitline[length(splitline)])
  xs = c(xs,x)
  ys = c(ys,y)
}

# Define a function that build a clean data frame from the kinase tree svg
readsvgtree <- function(svgtree="~/Dropbox/Work/Projects/Ongoing/CORAL/Rpackage/CORAL/Data/basetree.svg")
{
  
  
  
  
  
  
  
  
}

gooddataframe = data.frame(
  
  # identifiers
  id.kinrich  = a$ids,
  id.uniprot  = a$uniprot,
  id.ensembl  = a$ensembl,
  id.entrez   = a$entrez,
  id.HGNC     = a$HGNC,
  id.longname = a$name,
  
  # phylogeny
  kinase.group = a$group,
  kinase.family = a$family,
  kinase.subfamily = a$subfamily,
  
  # branch info
  branch.coords = a$d_line,
  branch.val = a$values,
  branch.group = "none",
  branch.col = a$col_line,
  
  # node info
  node.x = xs,
  node.y = ys,
  node.group.col = "none",
  node.val.col = 0,
  node.val.radius = 0,
  node.radius = 5,
  node.col = "#D3D3D3",
  node.strokewidth = 1,
  node.strokecol = "black",
  
  # text info
  text.x = xs,
  text.y = ys,
  text.col = "black",
  text.font = "\'AvenirNext-Bold\'",
  text.size = 3.25,
  text.label = a$label_text
)
