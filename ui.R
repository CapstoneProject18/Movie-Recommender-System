#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)
# Home Page For Movie Recommender

shinyServer(dashboardPage(skin="blue",
                          dashboardHeader(title = "Movie Recommenders"),
                          dashboardSidebar(
                            sidebarMenu(
                              menuItem("Home",tabName = "home", icon = icon("home")),
                              menuItem("Recommendations", tabName = "recommend", icon = icon("film")),
                              menuItem("About", tabName = "about", icon = icon("question-circle")),
                              menuItem("Source Code", icon = icon("file-code-o"),href = "https://github.com/CapstoneProject18/Movie-Recommender-System"),
                              menuItem("Trending",tabName = "trending", icon = icon("fire")),
                              menuItem(
                                list(
                                  
                                  selectInput("select", label = h5("Select Movies That You want to watch right-now"),
                                              choices = as.character(movies$title[1:length(unique(movies$movieId))]),
                                              selectize = FALSE,
                                              selected = "Shawshank Redemption, The (1994)"),
                                  selectInput("select2", label = NA,
                                              choices = as.character(movies$title[1:length(unique(movies$movieId))]),
                                              selectize = FALSE,
                                              selected = "Forrest Gump (1994)"),
                                  selectInput("select3", label = NA,
                                              choices = as.character(movies$title[1:length(unique(movies$movieId))]),
                                              selectize = FALSE,
                                              selected = "Silence of the Lambs, The (1991)"),
                                  submitButton("Submit")
                                )
                              ),
                              menuItem(
                                list(
                                  selectInput("input_genre", label = "Select the Genre to Get the list", 
                                             choices = as.character(genre_list),
                                              selected = "Comedy"),
                                  submitButton("Submit")
                                )
                              )
                            )
                          ),
                          dashboardBody(
                            tags$head(
                              tags$style(type="text/css", "select { max-width: 360px; }"),
                              tags$style(type="text/css", ".span4 { max-width: 360px; }"),
                              tags$style(type="text/css",  ".well { max-width: 360px; }")
                            ),
                            
                            tabItems(
                              tabItem(tabName = "about", h2("About this app")),
                              tabItem(tabName = "home",
                                      fluidRow(
                                        box(DT::dataTableOutput("genreTable"),title="List Of Movies According To Genres", width = 6, collapsible = TRUE),
                                          valueBoxOutput("tableRatings1"),
                                          valueBoxOutput("tableRatings2"),
                                          valueBoxOutput("tableRatings3"),
                                          HTML("<br/>"),
                                        box(DT::dataTableOutput("movieTable"), title="List of All Movies",width=12,collapsible= TRUE)
                                      )),
                              tabItem(tabName = "recommend",
                                      box(width = 12, collapsible =  FALSE, title = h1("Recommendations From Movies Already In DataBase"),
                                      tableOutput("recommend_table")
                                      ),
                                      box(width = 12, collapsible = TRUE, title = h2("Use To Add Movie Not Available in Database"),collapsed = TRUE,
                                         fluidRow(column(2,textInput("v1","Movie-Name(Year)")),
                                                  column(6,textInput("v2","Genres(Sepeated by |)")),
                                                  column(4, sliderInput("decimal","Ratings",min=1,max = 5,step = 0.1,value = 2.5)),
                                                  column(4, actionButton("add","Add the above movie") )
                                                  )
                                          ),
                                    dataTableOutput("displayUpdate")
                                      
                          ),
                          tabItem(tabName = "trending", h2("Trending Movies"),dataTableOutput("trendingTable"))
                          ))
            )
)