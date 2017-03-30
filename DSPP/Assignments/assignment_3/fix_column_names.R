#fix_column_names Function

fix_column_names <- function(x){
  s <- gsub("properties\\.\\$", "", x) # remove the 'properties.$' from beginning of colname
  s <- gsub("\\<properties\\>(.)", "", s) # remove properies(.) jargon where
  s <- gsub("\\.", "_", s) # replace '.' with '_'
  s <- gsub("(.)([A-Z][a-z]+)", "\\1_\\2", s) # separate with underscores on capitalization
  s <- tolower(gsub("([a-z0-9])([A-Z])", "\\1_\\2", s)) # lowercase
  s <- gsub("__", "_", s) # double underscore to single underscore
  s <- gsub("^[_, .]", "", s) # delete first char underscore "_" or period "."
  s <- gsub(' ', '', s) # remove spaces
}