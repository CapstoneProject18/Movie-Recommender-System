#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

library(DT)
library(dplyr)
library(reshape2)

Logged <- FALSE

movies <- read.csv("movies.csv", header = TRUE, stringsAsFactors=FALSE)
formatInput <- function(v,a,d){
  ## This function formats the user's input of Valence-Arousal-Dominance
  ## and outputs them as a vector
  
  c(v,a,d)
}

shinyServer(function(input, output) {
  
  
  
  
  source(file = "ui.R")#Main Dashboard
  source(file = "Login.R") #Login Page
  
  
  #Checking if the movie select has a good rating or not 
  
  movie.ratings <- merge(ratings, movies)
  output$tableRatings1 <- renderValueBox({
    movie.avg1 <- summarise(subset(movie.ratings, title==input$select),
                            Average_Rating1 = mean(rating, na.rm = TRUE))
    valueBox(
      value = format(movie.avg1, digits = 3),
      subtitle = input$select,
      icon = if (movie.avg1 >= 3) icon("thumbs-up") else icon("thumbs-down"),
      color = if (movie.avg1 >= 3) "aqua" else "red"
    )
    
  })
  
  movie.ratings <- merge(ratings, movies)
  output$tableRatings2 <- renderValueBox({
    movie.avg2 <- summarise(subset(movie.ratings, title==input$select2),
                            Average_Rating = mean(rating, na.rm = TRUE))
    valueBox(
      value = format(movie.avg2, digits = 3),
      subtitle = input$select2,
      icon = if (movie.avg2 >= 3) icon("thumbs-up") else icon("thumbs-down"),
      color = if (movie.avg2 >= 3) "aqua" else "red"
    )
  })
  
  movie.ratings <- merge(ratings, movies)
  output$tableRatings3 <- renderValueBox({
    movie.avg3 <- summarise(subset(movie.ratings, title==input$select3),
                            Average_Rating = mean(rating, na.rm = TRUE))
    valueBox(
      value = format(movie.avg3, digits = 3),
      subtitle = input$select3,
      icon = if (movie.avg3 >= 3) icon("thumbs-up") else icon("thumbs-down"),
      color = if (movie.avg3 >= 3) "aqua" else "red"
    )
  }) 
  

  #filtering the search_matrix table according to genre selected
        
  data <- reactive({
    req(input$input_genre)
    if(input$input_genre == "Comedy")
    {
      search_matrix %>% filter(Comedy==1) %>% select(title)
    }
    
    else if(input$input_genre == "Action")
    {
      search_matrix %>% filter(Action==1) %>% select(title)
    }
   else if(input$input_genre == "Crime")
    {
      search_matrix %>% filter(Crime==1) %>% select(title)
    }
   else if(input$input_genre == "Adventure")
    {
      search_matrix %>% filter(Adventure==1) %>% select(title)
    }
    else if(input$input_genre == "Animation")
    {
      search_matrix %>% filter(Animation==1) %>% select(title)
    }
    else if(input$input_genre == "Children")
    {
      search_matrix %>% filter(Children==1) %>% select(title)
    }
    else if(input$input_genre == "Documentary")
    {
      search_matrix %>% filter(Documentary==1) %>% select(title)
    }
    else if(input$input_genre == "Drama")
    {
      search_matrix %>% filter(Drama==1) %>% select(title)
    }
    else if(input$input_genre == "Fantasy")
    {
      search_matrix %>% filter(Fantasy==1) %>% select(title)
    }
    else if(input$input_genre == "Film-Noir")
    {
      search_matrix %>% filter(`Film-Noir`==1) %>% select(title)
    }
    else if(input$input_genre == "Musical")
    {
      search_matrix %>% filter(Musical==1) %>% select(title)
    }
    else if(input$input_genre == "Horror")
    {
      search_matrix %>% filter(Horror==1) %>% select(title)
    }
    else if(input$input_genre == "Mystery")
    {
      search_matrix %>% filter(Mystery==1) %>% select(title)
    }
    else if(input$input_genre == "Romance")
    {
      search_matrix %>% filter(Romance==1) %>% select(title)
    }
    else if(input$input_genre == "Sci-Fi")
    {
      search_matrix %>% filter(Sci-Fi==1) %>% select(title)
    }
    else if(input$input_genre == "Thriller")
    {
      search_matrix %>% filter(Thriller==1) %>% select(title)
    }
    else if(input$input_genre == "War")
    {
      search_matrix %>% filter(War==1) %>% select(title)
    }
    else if(input$input_genre == "Western")
    {
      search_matrix %>% filter(Western==1) %>% select(title)
    }
  })
  
  #List of selected genres
  output$genreTable <- renderDataTable({
    
    data()
  })
  
  
   #List of all movies
output$movieTable <- renderDataTable({
  movies[c("title","genres")] 
})


output$recommend_table <- renderTable({
  # Filter for based on genre of selected movies to enhance recommendations
  cat1 <- subset(movies, title==input$select)
  cat2 <- subset(movies, title==input$select2)
  cat3 <- subset(movies, title==input$select3)
  
  
  
  # # If genre contains 'Sci-Fi' then  return sci-fi movies 
  # # If genre contains 'Children' then  return children movies
   if (grepl("Sci-Fi", cat1$genres) | grepl("Sci-Fi", cat2$genres) | grepl("Sci-Fi", cat3$genres)) {
     movies2 <- (movies[grepl("Sci-Fi", movies$genres) , ])
   } else if (grepl("Children", cat1$genres) | grepl("Children", cat2$genres) | grepl("Children", cat3$genres)) {
     movies2 <- movies[grepl("Children", movies$genres), ]
   } else {
     movies2 <- movies[grepl(cat1$genre1, movies$genres) 
                       | grepl(cat2$genre1, movies$genres)
                       | grepl(cat3$genre1, movies$genres), ]
   }
   
  movie_recommendation <- function(input,input2,input3){
    row_num <- which(movies2[,3] == input)
    row_num2 <- which(movies2[,3] == input2)
    row_num3 <- which(movies2[,3] == input3)
    userSelect <- matrix(NA,length(unique(ratings$movieId)))
    userSelect[row_num] <- 5 #hard code first selection to rating 5
    userSelect[row_num2] <- 4 #hard code second selection to rating 4
    userSelect[row_num3] <- 4 #hard code third selection to rating 4
    userSelect <- t(userSelect)
    
    ratingmat <- dcast(ratings, userId~movieId, value.var = "rating", na.rm=FALSE)
    ratingmat <- ratingmat[,-1]
    colnames(userSelect) <- colnames(ratingmat)
    ratingmat2 <- rbind(userSelect,ratingmat)
    ratingmat2 <- as.matrix(ratingmat2)
    
    #Convert rating matrix into a sparse matrix
    ratingmat2 <- as(ratingmat2, "realRatingMatrix")
    
    #Create Recommender Model
    recommender_model <- Recommender(ratingmat2, method = "UBCF",param=list(method="Cosine",nn=30))
    recom <- predict(recommender_model, ratingmat2[1], n=30)
    recom_list <- as(recom, "list")
    recom_result <- data.frame(matrix(NA,30))
    recom_result[1:30,1] <- movies2[as.integer(recom_list[[1]][1:30]),3]
    recom_result <- data.frame(na.omit(recom_result[order(order(recom_result)),]))
    recom_result <- data.frame(recom_result[1:10,])
    colnames(recom_result) <- "User-Based Collaborative Filtering Recommended Titles"
    return(recom_result)
  }
  
  movie_recommendation(input$select, input$select2, input$select3)
})

# if a user adds a movie, update the dataframe and write it to csv file

movies_new <- data.frame(movieID=integer(),title=character(),genres=character())
adding_data <- reactive({
  movies_new <- data.frame(movieID=rep(last(movies$movieId)+1),title=rep(input$v1),genres=input$v2)
  #return(movies_new)
})
  
  

FinalData <- eventReactive(input$add,{
  cbind.data.frame(adding_data(),movies_new)
  
  write.csv(movies_new,file = "C:\\Users\\Mukul-Gupta\\Desktop\\Capstone\\movies.csv",row.names=FALSE,append = TRUE)
  
  
  })

 output$displayUpdate = renderDataTable(FinalData())
 
 
 output$trendingTable = renderDataTable({
   title.views<- merge(movies,table_views)
   title.views<-title.views[order(title.views$views, decreasing = TRUE),]
   title.views<-title.views[1:50,]
   title.views[c("title","views")]
 })

})
  
  

