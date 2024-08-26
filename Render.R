#### Install all required packages and download icon updates as needed ####
if(!require(tidyverse)) install.packages('tidyverse')
if(!require(sf)) install.packages('sf')
if(!require(mapview)) install.packages('mapview')
if(!require(ggpubr)) install.packages('ggpubr')
if(!require(png)) install.packages('png')
if(!require(remotes)) install.packages('remotes')
if(!require(icons)) remotes::install_github('mitchelloharawild/icons')
if(!require(timevis)) install.packages('timevis')
if(!require(leafpop)) install.packages('leafpop')
if(!require(odbc)) install.packages('odbc')
if(!require(DBI)) install.packages('DBI')
if(!require(dbplyr)) install.packages('dbplyr')
if(!require(ggimage)) install.packages('ggimage')
if(!require(quarto)) install.packages('quarto')

# There's a weird behavior in the icons package when downloading from font-awesome. Leaving the default "dev" version pulls from an archive that doesn't contain the right files. We read the latest version from the font-awesome github site, and use that for the version number in the download
icons_version <- jsonlite::read_json("https://api.github.com/repos/FortAwesome/Font-Awesome/releases/latest")$tag_name
icons::download_fontawesome(version = icons_version)

quarto::quarto_render()