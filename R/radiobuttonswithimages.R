
# Define functions that allow for radio buttons with images
radioButtons_withHTML <- function (inputId, label, choices, selected = NULL, inline = FALSE, 
                                   width = NULL) 
{
 choices <- shiny:::choicesWithNames(choices)
 selected <- if (is.null(selected)) 
  choices[[1]]
 else {
  shiny:::validateSelected(selected, choices, inputId)
 }
 if (length(selected) > 1) 
  stop("The 'selected' argument must be of length 1")
 options <- generateOptions_withHTML(inputId, choices, selected, inline, 
                                     type = "radio")
 divClass <- "form-group shiny-input-radiogroup shiny-input-container"
 if (inline) 
  divClass <- paste(divClass, "shiny-input-container-inline")
 tags$div(id = inputId, style = if (!is.null(width)) 
  paste0("width: ", validateCssUnit(width), ";"), class = divClass, 
  ifelse(utils::compareVersion(as.character(packageVersion("shiny")), "1.2.0"), 
    shiny:::shinyInputLabel(inputId, label), 
    shiny:::controlLabel(inputId, label))
  , options)
}

generateOptions_withHTML <- function (inputId, choices, selected, inline, type = "checkbox") 
{
 options <- mapply(choices, names(choices), FUN = function(value, 
                                                           name) {
  inputTag <- tags$input(type = type, name = inputId, value = value)
  if (value %in% selected) 
   inputTag$attribs$checked <- "checked"
  if (inline) {
   tags$label(class = paste0(type, "-inline"), inputTag, 
              tags$span(HTML(name)))
  }
  else {
   tags$div(class = type, tags$label(inputTag, tags$span(HTML(name))))
  }
 }, SIMPLIFY = FALSE, USE.NAMES = FALSE)
 div(class = "shiny-options-group", options)
}

