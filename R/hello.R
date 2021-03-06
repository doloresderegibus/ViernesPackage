# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

hello <- function() {
  print("Hello, world!")
}
# Function definitions

#' Calculates the Shannon Diversity Index using ln base e
#'
#' @param species vector of abundances of species
#'
#' @return the Shannon Diversity Index
#'
#' @export
#'
#' @examples
#' p <- c(100,1000,2000)
#' shannon(p)
#'
shannon <- function(species)
{
  species <- species[species>0]
  species <- species/sum(species)
  H <- -sum(species* log(species))
  return(H)
}


#' Fix the problems of chlorophyll-a data set
#'
#' @param chla data.frame with original data
#'
#' @return data.frame with fixed data
#' @export
#'
#' @examples
fixClorophylData <- function(chla)
{
  actual_year <- chla$year[1]
  chla$Date <- as.Date("1900-01-01")

  for(i in 1:nrow(chla))
  {
    if( is.na(chla$Year[i]))
      chla$Year[i] <- actual_year
    else
      actual_year <- chla$Year[i]

    fecha <- ymd(paste(chla$Year[i],chla$Month[i], 1))
    if( is.na(fecha)){
      if(chla$Month[i]=="Mar")
        fecha <- ymd(paste(chla$Year[i],3, 1))
      else {
        fecha <- dmy(chla$Month[i])

        if(is.na(fecha)) {
          fecha <- mdy(chla$Month[i])

          if(is.na(fecha)) {
            temp <- strsplit(chla$Month[i]," ")[[1]][3]
            fecha <- dmy(temp)
          }
        }
      }
    }
    chla$Date[i] <- fecha

  }

  chla$IntegE1 <- abs(chla$IntegE1)
  chla$IntegE2 <- abs(as.numeric(chla$IntegE2))

  return(chla)
}


#' Read ecological networks in CSV format as edge list or adyacency matrix
#'
#' @param fileName Filename of the csv formated network
#'
#' @return an igraph object
#' @export
#'
#' @examples readEcoNetwork("econetwork.csv")
readEcoNetwork <- function(fileName){

  g <- lapply(fileName, function(fname){

    web <- read.csv(fname,  header = T,check.names = F)

    if( ncol(web)==2 ){
      web <- web[,c(2,1)]

      g <- graph_from_data_frame(web)

    } else {
      if( (ncol(web)-1) == nrow(web)  ) {                   # The adjacency matrix must be square
        g <- graph_from_adjacency_matrix(as.matrix(web[,2:ncol(web)]))

      } else {
        g <- NULL
        warning("Invalid file format: ",fileName)
      }
    }

  })
  return(g)
}

require(devtools)
install_github("doloresderegibus/ViernesPackage")
