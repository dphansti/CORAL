# library(networkD3)
# library(tidyverse)
# library(data.tree)
# library(dplyr)
# library(magrittr)
# library(radialNetworkR)
# library('data.tree')
# library(jsonlite)

# NOTE: THIS IS JUST A VARIATION OF force_kinome_tree FUNCTION IN forceNetwork_KinomeTree.R FILE.

#Auxilary function to produce a data frame that holds the unique names for nodes
auxfun_unique_names_by_group_number <- function(input_df){
  unique_names <- unique(input_df$name)
  corresponding_group_number <- vector("character",length = length(unique_names))
  i = 1
  for(node in unique_names){
    index = match(x = node,table = input_df$name)
    corresponding_group_number[i] <- input_df$group_number[index]
    i <- i+1
  }
  newdf <- data.frame(unique_names,corresponding_group_number)
  names(newdf)<-c("name","group_number")
  return(newdf)
}

auxfunc_default_group_coloring <- function(treedf)
{
  two_column_df <- select(treedf, c("col_line","group"))
  
  allgroups <- droplevels(unique(treedf$group))
  groupnames <- c("Other", "TK", "TKL", "AGC", "CAMK", "RGC", "CMGC", "CK1", "STE")
  
  allcolors <- unique(as.character(treedf$col_line))
  print(allcolors)
  default_colors <- c("#DBD3A8","#F9800D","#EE2C2C","#228B22","#9983EE","#FAD615","#05A9EE","#198AEE","#FFB800")
  
  colorVector <- c("black", "red", "blue", "green", "orange",
                   rep("red", 4), rep("blue", 5), rep("green", 5), rep("orange", 5),
                   rep("red", 14), rep("blue", 14), rep("green", 14), rep("orange", 14))
  return(colorVector)
}


# Define a function that creates a forceNetwork of the tree
list_kinome_tree <- function(treedf, color_plan = NULL)
{
  #treedf = svginfo$dataframe
  # reassing to new variable for absolutely no reason
  newtreedf = treedf
  
  # Making sure the groups, family, subfamily and ids are not factors before starting
  smaller_df <- select(newtreedf, c("ids","subfamily","family","group"))
  smaller_df$ids = as.character(smaller_df$ids)
  smaller_df$subfamily = as.character(smaller_df$subfamily)
  smaller_df$family = as.character(smaller_df$family)
  smaller_df["group_number"] <- as.numeric(smaller_df$group)
  
  #NOTE: The nodes will display colors based on which 'group_number' they belong to.
  
  ##############
  ##### 1. #####
  ##############
  
  # First, separating columns into smaller data frames based on 'group_number'
  family_by_group_number <- select(smaller_df,c("family"))
  family_by_group_number["group_number"] <- as.numeric(smaller_df$group_number)
  colnames(family_by_group_number)[1]<-"name"
  
  subfamily_by_group_number <- select(smaller_df,c("subfamily"))
  subfamily_by_group_number["group_number"] <- as.numeric(smaller_df$group_number)
  colnames(subfamily_by_group_number)[1]<-"name"
  
  kinase_by_group_number <- select(smaller_df,c("ids"))
  kinase_by_group_number["group_number"] <- as.numeric(smaller_df$group_number)
  colnames(kinase_by_group_number)[1]<-"name"
  
  group <- select(smaller_df,c("group"))
  group["group_number"] <- as.numeric(smaller_df$group_number)
  colnames(group)[1]<-"name"
  
  # Problem: Not all kinases belong to a subfamily: in some cases, subfamily == "".  
  # Solution: Modify the dataframe that contains the subfamily nodes to consider the cases that are not empty:
  
  #Changing empty subfamilies to NA
  subfamily_by_group_number[subfamily_by_group_number==""]  <- NA 
  #Removing empty (now <NA>) subfamilies
  subfamily_by_group_number<-subfamily_by_group_number[complete.cases(subfamily_by_group_number), ]
  
  # Making the node dataframe of 'ids', 'subfamily', 'family' and 'group' names and their respective color (represented by group number)
  node_df <- rbind(kinase_by_group_number,
                   auxfun_unique_names_by_group_number(subfamily_by_group_number),
                   auxfun_unique_names_by_group_number(family_by_group_number),
                   auxfun_unique_names_by_group_number(group))
  
  # Creating root node
  de<-data.frame("Root","1000001")
  names(de)<-c("name","group_number")
  
  # Adding root node at the end of node_df
  node_df <- rbind(node_df, de)
  
  # Numbering nodes
  rownames(node_df) <- seq(1,length(node_df$name))
  
  # 0-based indexing: node_df$group_number
  node_df$group_number <- as.numeric(node_df$group_number)-1
  node_df$group_number <- as.character(node_df$group_number)
  
  # Problem: Cannot distinguish between kinases and subfamilies that share the same names...
  # Solution: Concatenating identifiers to kinases,families,subfamilies and groups ('    ','   ','  ',' ')
  #                                                                                ('k_','f_','s_','g_')
  kinase_by_group_number$name <- paste0('    ',kinase_by_group_number$name)
  subfamily_by_group_number$name <- paste0('   ',subfamily_by_group_number$name)
  family_by_group_number$name <- paste0('  ',family_by_group_number$name)
  group$name <- paste0(' ',group$name)
  
  # Using identified_node_df data frame to create the edges in the link_df dataframe.
  identified_node_df <- rbind(kinase_by_group_number,
                              auxfun_unique_names_by_group_number(subfamily_by_group_number),
                              auxfun_unique_names_by_group_number(family_by_group_number),
                              auxfun_unique_names_by_group_number(group))
  
  # # Adding root node at the end of node_df
  identified_node_df <- rbind(identified_node_df, de)
  
  #Numbering nodes
  rownames(identified_node_df) <- seq(1,length(identified_node_df$name))
  
  # 0-based indexing: identified_node_df$group_number
  identified_node_df$group_number <- as.numeric(identified_node_df$group_number)-1
  identified_node_df$group_number <- as.character(identified_node_df$group_number)
  
  ##############
  ##### 2. #####
  ##############
  
  # Making the link_df dataframe of 'ids' -> 'subfamily', 'subfamily' -> 'family', 'family' -> 'group' and 'group' -> root
  source <- c()
  target <- c()
  # Finding edges for nodes to nodes
  for(i in 1:dim(smaller_df)[1]){
    if(smaller_df$subfamily[i] == ""){
      #ids -> family
      source <- append(source, which(identified_node_df$name %in% paste0('    ',smaller_df$ids[i])) - 1)
      target <- append(target, which(identified_node_df$name %in% paste0('  ',smaller_df$family[i])) - 1)
    }else{
      #ids -> subfamily
      source <- append(source, which(identified_node_df$name %in% paste0('    ',smaller_df$ids[i])) - 1)
      target <- append(target, which(identified_node_df$name %in% paste0('   ',smaller_df$subfamily[i])) - 1)
      #subfamily -> family
      source <- append(source, which(identified_node_df$name %in% paste0('   ',smaller_df$subfamily[i])) - 1)
      target <- append(target, which(identified_node_df$name %in% paste0('  ',smaller_df$family[i])) - 1)
    }
    #family -> group
    source <- append(source, which(identified_node_df$name %in% paste0('  ',smaller_df$family[i])) - 1)
    target <- append(target, which(identified_node_df$name %in% paste0(' ',smaller_df$group[i])) - 1)
  }
  # Finding edges for group nodes to root
  for(i in 1:dim(auxfun_unique_names_by_group_number(group))[1]){
    #groups -> root
    source <- append(source, which(identified_node_df$name %in% levels(droplevels(auxfun_unique_names_by_group_number(group)[i,1]))) - 1)
    target <- append(target, dim(identified_node_df)[1]-1)
  }
  link_df <- data.frame(source,target)
  
  # Confirmation: check if there are any nodes without edges
  node_wo_edge <- c()
  for(i in 0:(length(node_df$name)-1)){
    if(!(i %in% link_df$source) & !(i %in% link_df$target)){
      node_wo_edge <- append(node_wo_edge,i+1)
    }
  }
  
  #For radialNetwork: 
  # Naming the source -> target dataframe:
  for(i in 1:length(link_df$source)){
    link_df$source[i] <- identified_node_df$name[as.numeric(link_df$source[i])+1]
    link_df$target[i] <- identified_node_df$name[as.numeric(link_df$target[i])+1]
  }
  
  # sort 
  link_df = link_df[order(link_df$source,decreasing = FALSE),]
  
  thetree <- FromDataFrameNetwork(link_df)
  # devtools::install_github("timelyportfolio/radialNetworkR")
  
  # devtools::install_github( "gluc/data.tree" )
  # unname = TRUE to get in the proper d3 format
  
  lol <- ToListExplicit(thetree, unname = TRUE)

  #get group colors function: coloring by group (by default)
  # if(is.null(color_plan)){
  #   auxfunc_default_group_coloring(svginfo$dataframe)
  # }
  return(lol)
  
  #jsarray <- paste0('["', paste(colorVector, collapse = '", "'), '"]')
  #nodeStrokeJS <- JS(paste0('function(d, i) { return ', jsarray, '[i]; }'))
  #networkD3::radialNetwork(lol, width = "3000px",height = "2000px",opacity = 0.9, nodeStroke = nodeStrokeJS)
  #return(networkD3::radialNetwork(lol, width = "3000px",height = "2000px",opacity = 0.9, nodeStroke = nodeStrokeJS))
  #return(tree)
  #return(radialNetworkR::radialNetwork(lol, width = "3000px",height = "2000px"))
}


# list_kinome_tree(svginfo$dataframe)

# colorVector <- c("black", "red", "blue", "green", "orange",
#                  rep("red", 4), rep("blue", 5), rep("green", 5), rep("orange", 5),
#                  rep("red", 14), rep("blue", 14), rep("green", 14), rep("orange", 14))


#View(svginfo$dataframe)
# diagonalNetwork(lol,width = "1100px",height = "7000px")
# #Saving the forceNetwork of the Kinome Tree as an HTML file:
# setwd("../Data/")
# force_kinome_tree(svginfo$dataframe) %>% saveNetwork(file = 'Net1.html')













######
######
######


# 
# 
# ## Data
# input <- list(number=50)
# input$number
# Data_tree <- data.frame(Start="Class",
#                         Asset = sample(c("FI","Equity","Currency","Commodities"),input$number,replace = TRUE),
#                         Sub_Asset = sample(c("Asia","Europe","USA","Africa","ME"),input$number,replace = TRUE),
#                         Ticker = replicate(input$number,paste0(sample(LETTERS,3),collapse=""))) %>% unite(col="pathString",Start,Asset,Sub_Asset,Ticker,sep="-",remove=FALSE) %>% select(-Start) %>% as.Node(pathDelimiter = "-")
# View(Data_tree)
# View(ToListExplicit(Data_tree, unname = TRUE ))
# 
# ###Assigning colors
# colorVector <- c("black", "red", "blue", "green", "orange", 
#                  rep("red", 4), rep("blue", 5), rep("green", 5), rep("orange", 5),
#                  rep("red", 14), rep("blue", 14), rep("green", 14), rep("orange", 14))
# 
# jsarray <- paste0('["', paste(colorVector, collapse = '", "'), '"]')
# nodeStrokeJS <- JS(paste0('function(d, i) { return ', jsarray, '[i]; }'))
# ###
# 
# #Plotting radialNetwork
# radialNetwork(ToListExplicit(Data_tree, unname = TRUE ), 
#               linkColour = "#ccc",
#               nodeColour = "#fff",
#               nodeStroke = nodeStrokeJS,
#               textColour = "#000001")
# 
# ?radialNetwork()
# 
# library('networkD3')
# Relationships<- data.frame(Parent=c("earth","earth","forest","forest","ocean","ocean","ocean","ocean"),
#                            Child=c("ocean","forest","tree","sasquatch","fish","seaweed","mantis shrimp","sea monster"))
# 
# View(Relationships)
# Relationships
# library('data.tree')
# tree <- FromDataFrameNetwork(Relationships)
# tree
# lol <- ToListExplicit(tree, unname = TRUE)
# diagonalNetwork(lol)
# 
# ?ToListExplicit()



# sink("/Users/phanstiel2/Research/Ivan/Kinrich/Data/Tree.json")
# jsonlite::toJSON(lol, pretty = TRUE)
# sink()
# 

#default json file in index.html: https://gist.githubusercontent.com/deenar/c16ac22e53165aad50d5/raw/7f5f4cb610ee3f299018c2058362603bb3519d0f/flare.json
#d3.select(self.frameElement).style("height", radius * 2 + "px");

# d3.select("#generate")
# .on("click", writeDownloadLink);
# 
# function writeDownloadLink(){
#   try {
#     var isFileSaverSupported = !new Blob();
#   } catch (e) {
#     alert("blob not supported");
#   }
#   
#   var html = d3.select("svg")
#   .attr("title", "test2")
#   .attr("version", 1.1)
#   .attr("xmlns", "http://www.w3.org/2000/svg")
#   .node().parentNode.innerHTML;
#   
#   var blob = new Blob([html], {type: "image/svg+xml"});
#   saveAs(blob, "myProfile.svg");
# };
  
#<script src="http://eligrey.com/demos/FileSaver.js/Blob.js"></script>
#<script src="http://eligrey.com/demos/FileSaver.js/FileSaver.js"></script>

