# load the shinydashboard package
library(shiny)
require(shinydashboard)
#library(ggplot2)
library(dplyr)
library("d3Network")
library("RSiteCatalyst")

#### Authentication 
#SCAuth("name", "secret")

pathpattern <- c("**page name**","::anything::")

#Get your orders count with this

yesterday_orders <- 343434

total_traffic <- 123456

some_number <- 466777

next_page <- QueuePathing("**report suite name **",
                          #"2017-03-16",
                          as.character(Sys.Date()-1),
                          #"2017-03-16",
                          as.character(Sys.Date()-1),
                          metric="pageviews",
                          element="page",
                         # segment.id = '537d0bdfe4b0e6728d7ab500',
                          pathpattern,
                          top = 500)

 

header <- dashboardHeader(title = "Path Analysis") 

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Visit-us", icon = icon("send",lib='glyphicon'))
  )
)

frow1 <- fluidRow(
   valueBoxOutput("marketShare")
  ,valueBoxOutput("profAcc")
  
)

frow2 <- fluidRow(
  
  # first box for sales by quarter and region bar
  box(
    title = "Page (Network) Analysis - Big Prize Grab"
    ,width = NULL
    ,status = "primary"
    ,solidHeader = TRUE 
    #,collapsible = TRUE 
    #,plotOutput("salesQuartBar", height = "300px")
    ,htmlOutput('pathNetworkPlot')
  )
  
  # second box for sales by year and region bar
  #,box(
  #  title = "Revenue per Product"
  #  ,status = "primary"
  #  ,solidHeader = TRUE 
  #  ,collapsible = TRUE 
  #  ,plotOutput("salesYearBar", height = "300px")
  #) 
  
)
 

# combine the three fluid rows to make the body
body <- dashboardBody(# Load D3.js
  tags$head(
    tags$script(src = 'http://d3js.org/d3.v3.min.js')
  ),
  frow1,frow2)

ui <- dashboardPage(header, sidebar, body, skin='red')

# create the server functions for the dashboard  
server <- function(input, output) { 
  
  total.orders <- as.numeric(as.character(yesterday_orders))
  prof.account <- as.numeric(as.character(total_traffic))
 # prof.prod <-  as.numeric(as.character(yesterday_orders$Orders))
  
  
  output$pathNetworkPlot <- renderPrint({
    
    #Optional step: Cleaning my pagename URLs to remove to domain for clarity
    next_page$step.1 <- sub("http://www.vodafone.com/","",
                            next_page$step.1, ignore.case = TRUE)
    next_page$step.2 <- sub("http://www.vodafone.com/","",
                            next_page$step.2, ignore.case = TRUE)
    
    #Filter out Entered Site and duplicate rows, >120 for chart legibility
    #links <- subset(next_page, count >= 400 & step.1 != "Entered Site" & step.1 != "Exited Site" & step.2 != "Exited Site")
    links <- subset(next_page, count>=50, step.1 != "Entered Site" & step.1 != "Exited Site" & step.2 != "Exited Site")
    
   
    
     d3SimpleNetwork(#subset(links, count > 100), 
                     links,
                     Source = "step.1", Target = "step.2", 
                     #height = 600,
                     #width = 750, 
                     fontsize = 12, linkDistance = 350, charge = -150,
                     linkColour = "#666", nodeColour = "#3182bd",
                     nodeClickColour = "#E34A33", textColour = "#3182bd", opacity = 0.6,
                     standAlone = FALSE,
                     parentElement = '#pathNetworkPlot')
    
     
  
  
})
  output$profAcc <- renderValueBox({
    valueBox(
      formatC(total_traffic, format="d", big.mark=',')
      ,paste('Top Account:',prof.account$Account)
      ,icon = icon("stats",lib='glyphicon')
      ,color = "purple")
    
    
  })
  
  
  
  output$marketShare <- renderValueBox({
    
    valueBox(
      formatC(total.orders, format="d", big.mark=',')
      ,'Total Expected Revenue'
      ,icon = icon("gbp",lib='glyphicon')
      ,color = "green")
  
  })
  
  
  
  output$profitMargin <- renderValueBox({
    
      valueBox(
        formatC(some_number, format="d", big.mark=',')
        ,paste('Top Product:',prof.prod$Product)
        ,icon = icon("menu-hamburger",lib='glyphicon')
        ,color = "yellow")
      
  })
  
  #sample table  
  output$salesbymodel <- renderDataTable(recommendation %>% group_by(Account) %>% summarize('Expected Revenue' = sum(Revenue)))
   
  
  
  output$NameBox <- renderInfoBox({
    infoBox(
      title = "Date"
      ,value = Sys.Date()
      ,color = "purple"
      ,icon = icon("tachometer")
    )
  })
  
  
  output$NameBox <- renderInfoBox({
    infoBox(
      title = "Date"
      ,value = Sys.Date()
      ,color = "purple"
      ,icon = icon("tachometer")
    )
  })
  
}


shinyApp(ui, server)
