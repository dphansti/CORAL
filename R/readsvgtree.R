# Define a function that collects full lines from svg files
cleansvg <- function(filename)
{
  # read in all lines
  svgdata = readLines(filename)
  svgdataclean = list()
  curline = c()
  
  nlines = length(svgdata)
  i = 1
  j = 0
  for (i  in 1:nlines)
  {
    # get line and strip tabs
    line = svgdata[i]
    line = gsub("\t","",line)
    
    # add to curent list
    curline = paste(curline,line,sep="")
    
    if (endsWith(line,">") == TRUE || i == nlines)
    {
      j = j + 1
      svgdataclean[[j]] = curline
      curline = c()
    }
  }
  return(svgdataclean)
}

#Define a function that extracts info from svg lines
extractsvgline <- function(line,type="path")
{
  listofstuff = c()
  if (type == "path")
  {
    trimline = gsub(c("<path |/>"),"",line)
  }
  
  if (type == "circle")
  {
    trimline = gsub(c("<circle |/>"),"",line)
  }
  
  if (type == "text")
  {
    firsttrimline  = gsub(c("<text |</text>"),"",line)
    twopartsofline = strsplit(firsttrimline,split = ">")[[1]]
    trimline = twopartsofline[[1]]
    
    # get the text.label
    listofstuff = c(listofstuff,twopartsofline[[2]])
    names(listofstuff)[length(listofstuff)] = "text.label"
    
    quotesplit = unlist(strsplit(trimline,split = "\""))
    
    # get the x and y coords
    transform = gsub(c("matrix\\(|)"),"",quotesplit[4])
    x = unlist(strsplit(transform," "))[5]
    y = unlist(strsplit(transform," "))[6]
    
    listofstuff = c(listofstuff,x)
    names(listofstuff)[length(listofstuff)] = "x"
    
    listofstuff = c(listofstuff,y)
    names(listofstuff)[length(listofstuff)] = "y"
    
    # # get the name
    listofstuff = c(listofstuff,quotesplit[2])
    names(listofstuff)[length(listofstuff)] = "id"
    
    
    
    # uniprotinfo = strsplit(line,split = ">")[[1]][1]
    # uniprotinfo = strsplit(uniprotinfo,split = "://www.uniprot.org/uniprot/")[[1]][2]
    # uniprotinfo = gsub("\"","",uniprotinfo)
    # listofstuff = c(listofstuff,uniprotinfo)
    # names(listofstuff)[length(listofstuff)] = "uniprot"
    # 
    # trimline = strsplit(line,split = ">")[[1]][2]
    # trimline = gsub(c("<text "),"",trimline)
    # text.label = strsplit(strsplit(line,split = ">")[[1]][3],"<")[[1]][1]
    # listofstuff = c(listofstuff,text.label)
    # names(listofstuff)[length(listofstuff)] = "text.label"
  }  
  
  if (type != "text")
  {
    subline = unlist(strsplit(trimline," "))
    
    for (subin in subline)
    {
      items = unlist(strsplit(subin,"="))
      value = items[2]
      value =gsub("\"","",value)
      listofstuff = c(listofstuff,value)
      names(listofstuff)[length(listofstuff)] = items[1]
    }
  }
  
  return(listofstuff)
}

# Define a function that extracts svg info
extractinfo <- function(cleansvgdata)
{
  svginfo = list()
  svginfo$header = c()
  section = "header"

  # determine which items to read in  
  id.coral.branch = c()
  branch.coords = c()
  
  id.coral.text = c()
  text.x = c()
  text.y = c()
  text.label = c()
  uniprot = c()
  
  id.coral.node= c()
  node.x = c()
  node.y = c()
  
  # determine section
  for (i in 1:length(cleansvgdata))
  {
    line = cleansvgdata[[i]]
    
    if (line == "<g id=\"LEGEND\">")
    {
      section = "legend"
      next
    }
    
    if (line == "<g id=\"BRANCHES\">" |   line == "<g id=\"ATYPICAL_BRANCHES\">")
    {
      section = "branches"
      next
    }
    if (line == "<g id=\"LABELS\">" | line == "<g id=\"ATYPICAL_LABELS\">")
    {
      section = "labels"
      next
    }
    if (line == "<g id=\"CIRCLES\">" | line == "<g id=\"ATYPICAL_CIRCLES\">")
    {
      section = "nodes"
      next
    }
    if (line == "<g id=\"GROUPS\">" | line == "<g id=\"ATYPICAL_GROUPS\">")
    {
      section = "groups"
      next
    }   
    
    if (line  ==  "</g>" || line  ==  "</svg>")
    {
      next
    }
    
    # add header lines to print out later
    if (section == "header")
    {
      svginfo$header = c(svginfo$header,line)
    }
    
    # parse branches
    if (section == "branches")
    {
      lineitems = extractsvgline(line,type="path")
      
      longidsplit = unlist(strsplit(lineitems["id"],"_"))
      id= paste(longidsplit[3:length(longidsplit)],collapse="_")
      id = gsub("\"","",id)
      id.coral.branch = c(id.coral.branch,id)
     
      branch.coords = c(branch.coords,lineitems["d"])
    }
    
    # parse labels
    if (section == "labels")
    {
      lineitems = extractsvgline(line,type="text")
      
      longidsplit = unlist(strsplit(lineitems["id"],"_"))
      id= paste(longidsplit[3:length(longidsplit)],collapse="_")
      id = gsub("\"","",id)
      id.coral.text = c(id.coral.text,id)

      text.x = c(text.x,lineitems["x"])
      text.y = c(text.y,lineitems["y"])
      text.label = c(text.label,lineitems["text.label"])
      uniprot = c(uniprot,lineitems["uniprot"])
    }
      
    # parse labels
    if (section == "nodes")
    {
      lineitems = extractsvgline(line,type="circle")
      
      longidsplit = unlist(strsplit(lineitems["id"],"_"))
      id= paste(longidsplit[3:length(longidsplit)],collapse="_")
      id = gsub("\"","",id)
      id.coral.node = c(id.coral.node,id)
    
      node.x = c(node.x,lineitems["cx"])
      node.y = c(node.y,lineitems["cy"])
    }
    
    # add header lines to print out later
    if (section == "groups")
    {
      svginfo$groups = c(svginfo$groups,line)
    }
  }
  
  # build data frames
  branches = data.frame(id.coral=id.coral.branch, branch.coords=branch.coords,stringsAsFactors = FALSE)
  branches = branches[order(branches$id.coral),]
  
  labels   = data.frame(id.coral=id.coral.text,
                        uniprot=uniprot,
                        text.x=text.x,
                        text.y=text.y,
                        text.label=text.label,stringsAsFactors = FALSE)
  labels = labels[order(labels$id.coral),]
  
  nodes   = data.frame(id.coral=id.coral.text,
                        node.x=node.x,
                        node.y=node.y,stringsAsFactors = FALSE)
  nodes = nodes[order(nodes$id.coral),]
  
  # merge data frames
  both = merge(branches,labels,by = "id.coral")
  all = merge(both,nodes,by = "id.coral")
  
  # perform sanity check
  nrow(labels)
  nrow(nodes)
  nrow(branches)

  # setdiff(branches$ids,labels$ids)
  # setdiff(labels$ids,branches$ids)

  svginfo$dataframe = all
  
  return(svginfo)
}


# Define a function to add conversion columns
conversioncolumn <- function(df,convtable,colname)
{
  # add conversions
  converter = read.table(convtable,header = F, sep = "\t")
  colnames(converter) = c("uniprot","other")
  newids = converter$other
  names(newids) = converter$uniprot
  
  df$other = ""
  df$other = as.character(newids[as.character(df$uniprot)])
  df$other = as.character(df$other)
  
  colnames(df)[which(colnames(df) == "other")] = colname
  
  return (df)
}


# Define a function that build a clean data frame from the kinase tree svg
readsvgtree <- function(svgtree,kinmapfile,ensemblfile,entrezfile)
{
  
  # read in and organize lines
  cleansvgdata = cleansvg(svgtree)
  
  # extract the relevant info
  svginfo = extractinfo(cleansvgdata)
  
  # fix header
  svginfo$header =  "<svg xmlns=\"http://www.w3.org/2000/svg\"
  xmlns:xlink=\"http://www.w3.org/1999/xlink\" >
  <defs>
    <style type=\"text/css\">
    @import url('https://fonts.googleapis.com/css?family=Roboto-Bold');
  text {font-family: \"Roboto-Bold\";
  }
  </style>
    </defs>"
  
  # read in kinmap file
  kinmap = read.table(kinmapfile,header=F,sep="\t",quote="")
  colnames(kinmap) = kinmap[1,]
  kinmap = kinmap[2:nrow(kinmap),]

  colnames(kinmap) = c("label","ids","HGNC","name","group","family","subfamily","uniprot")
  #kinmap = kinmap[which(kinmap$group != "Atypical"),]
  
  # check for similarities with kinmap
  setdiff(svginfo$dataframe$id.coral,kinmap$ids)
  setdiff(kinmap$ids,svginfo$dataframe$id.coral)
  
  # kinmap = kinmap[which(kinmap$ids != "PAN3"),]
  
  # merge with kinmap info
  svginfo$dataframe = merge(svginfo$dataframe,kinmap[,2:ncol(kinmap)],by.x = "id.coral" ,by.y = "ids")

  # fix uniprot name after merge  
  svginfo$dataframe$uniprot.x = svginfo$dataframe$uniprot.y
  svginfo$dataframe = svginfo$dataframe[,names(svginfo$dataframe) !="uniprot.y"]
  names(svginfo$dataframe)[names(svginfo$dataframe) == "uniprot.x"] = "uniprot"

  # add new conversion columns
  svginfo$dataframe = conversioncolumn(df=svginfo$dataframe,convtable=ensemblfile,colname="ensembl")
  svginfo$dataframe = conversioncolumn(df=svginfo$dataframe,convtable=entrezfile,colname="entrez")
  
  svgallinfoDF = data.frame(
    
    # identifiers
    id.coral  = svginfo$dataframe$id.coral,
    id.uniprot  = svginfo$dataframe$uniprot,
    id.ensembl  = svginfo$dataframe$ensembl,
    id.entrez   = svginfo$dataframe$entrez,
    id.HGNC     = svginfo$dataframe$HGNC,
    id.longname = svginfo$dataframe$name,
    
    # phylogeny
    kinase.group     = svginfo$dataframe$group,
    kinase.family    = svginfo$dataframe$family,
    kinase.subfamily = svginfo$dataframe$subfamily,
    
    # branch info
    branch.coords    = svginfo$dataframe$branch.coords,
    branch.val       = 0,
    branch.group     = "none",
    branch.col       = "#D3D3D3",
    
    # node info
    node.x = svginfo$dataframe$node.x,
    node.y = svginfo$dataframe$node.y,
    node.group.col = "none",
    node.val.col = 0,
    node.val.radius = 0,
    node.radius = 5,
    node.col = "#D3D3D3",
    node.strokewidth = 1,
    node.strokecol = "black",
    
    # text info
    text.x = svginfo$dataframe$text.x,
    text.y = svginfo$dataframe$text.y,
    text.col = "black",
    text.font = "\'Roboto-Bold\'",
    text.size = 3.25,
    text.label = svginfo$dataframe$text.label
    
  )

  # set the good df to the main one
  svginfo$dataframe = svgallinfoDF
  
  # write new tree
  writekinasetree(svginfo)
  
  # # write RDS file
  saveRDS(svginfo,"Data/kintree.RDS")
  
}

# ensemblfile  = "~/Dropbox/Work/Projects/Ongoing/CORAL/Rpackage/CORAL/Data/uniprot2ensembl.txt"
# entrezfile  = "~/Dropbox/Work/Projects/Ongoing/CORAL/Rpackage/CORAL/Data/uniprot2entrez.txt"
# kinmapfile = "~/Dropbox/Work/Projects/Ongoing/CORAL/Rpackage/CORAL/Data/kinmaplabels.txt"
# svgtree    = "~/Dropbox/Work/Projects/Ongoing/CORAL/Rpackage/CORAL/Data/basetree.svg"
# readsvgtree(svgtree,kinmapfile,ensemblfile,entrezfile)

