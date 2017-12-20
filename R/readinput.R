# Define a function that reads in 2 column text area input
read.text.input <- function(text.input)
{
  # extract user info
  recolordf = data.frame(matrix(unlist(strsplit(x=text.input,split="\\s+")),ncol=2,byrow = T),stringsAsFactors = F)
  colnames(recolordf) = c("kinase","userinfo")
  return (recolordf) 
}