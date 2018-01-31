
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

# count = 0
# for(checking in 1:length(identified_node_df$name)){
#   if(str_count(node_df$name[checking], ' ') != 0){
#     count = count+1
#     print(count)
#   }
# }
# node_df$name

aux_find_node_colors <- function(tree_df,source_target_df){
  library(stringr)
  #looping through source_target_df and returning corresponding node color (node.col)
  storing_node_col <- vector()
  for(index in 1:length(source_target_df$source)){
    if(str_count(source_target_df$source[index], ' ') == 1){
      #group
    }
    else if(str_count(source_target_df$source[index], ' ') == 2){
      #subfamily
    }
    else if(str_count(source_target_df$source[index], ' ') == 3){
      #family
    }
    else if(str_count(source_target_df$source[index], ' ') == 4){
      #kinase
    }
    
    str_count(source_target_df$source[index], ' ')
    source_target_df$source[index]
  }

}

# Define a function that creates a Radial (circular) Network of the tree
list_kinome_tree <- function(treedf, color_plan = NULL)
{
  # #speeding up this script...
  # treedf = svginfo$dataframe
  
  # reassing to new variable for absolutely no reason
  newtreedf = treedf
  
  # Making sure the ids, family, subfamily and groups are not factors before starting
  smaller_df <- select(newtreedf, c("id.kinrich","kinase.subfamily","kinase.family","kinase.group"))
  names(smaller_df) <- c("ids","subfamily","family","group")
  smaller_df$ids = as.character(smaller_df$ids)
  smaller_df$subfamily = as.character(smaller_df$subfamily)
  smaller_df$family = as.character(smaller_df$family)
  smaller_df["group_number"] <- as.numeric(smaller_df$group)
  
  #NOTE: The nodes must display colors based on which 'group_number' they belong to (by default).
  
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
  de<-data.frame("Groups","1000001")
  names(de)<-c("name","group_number")
  
  # Adding root node at the end of node_df
  node_df <- rbind(node_df, de)

  # Numbering nodes
  rownames(node_df) <- seq(1,length(node_df$name))
  
  # 0-based indexing: node_df$group_number
  node_df$group_number <- as.numeric(node_df$group_number)-1
  node_df$group_number <- as.character(node_df$group_number)
  
  # Problem: Cannot distinguish between kinases and subfamilies that share the same names...
  # Solution: Concatenating identifiers to kinases,families,subfamilies and groups ('    ' , '   ' , '  ' , ' ')
  #                                                                                (  k_   ,  f_   ,  s_  , g_)
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
  identified_node_df
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
  
  # Naming the source -> target dataframe:
  for(i in 1:length(link_df$source)){
    link_df$source[i] <- identified_node_df$name[as.numeric(link_df$source[i])+1]
    link_df$target[i] <- identified_node_df$name[as.numeric(link_df$target[i])+1]
  }
  
  # View(link_df)
  # link_df$node_color <- aux_find_node_colors(newtreedf,link_df)
  # link_df$branch_color <- 
  # link_df$text_size <- 
  # link_df$text_size <- 
  
  # sort 
  link_df = link_df[order(link_df$source,decreasing = FALSE),]
  
  # reformatting the nodes from the root down based on each source to target pair
  thetree <- FromDataFrameNetwork(link_df)

  # making JSON list from thetree: using unname = TRUE to get in the proper d3 format
  lol <- ToListExplicit(thetree, unname = TRUE)
  
  return(lol)
}

# list_kinome_tree(svginfo$dataframe)



#Writing kinome_tree.json based on current dataframe:
#sink(file = "Desktop/CLASES/UNC/Rotations/Projects/testingCoral.json")
# jsonlite::toJSON(list_kinome_tree(svginfo$dataframe), pretty = T)
#sink()
