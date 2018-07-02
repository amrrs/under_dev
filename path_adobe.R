# load the shinydashboard package
library(shiny)
require(shinydashboard)
library(ggplot2)
library(dplyr)

recommendation <- read.csv('recommendation.csv',stringsAsFactors = F,header=T)





#Multi-page pathing
library("d3Network")
library("RSiteCatalyst")

#### Authentication 
#SCAuth("name", "secret")
SCAuth('name','secret')


 
pathpattern <- c("page name","::anything::")



next_page <- QueuePathing("report suite name",
                          #"2017-03-16",
                          as.character(Sys.Date()-1),
                          #"2017-03-16",
                          as.character(Sys.Date()-1),
                          metric="pageviews",
                          element="page",
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
  #valueBoxOutput("marketShare")
  #valueBoxOutput("profAcc")
  #,valueBoxOutput("marketShare")
  #,valueBoxOutput("profitMargin")
)

frow2 <- fluidRow(
  
  # first box for sales by quarter and region bar
  box(
    title = "Page (Network) Analysis "
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

# share of sales by model
#frow3 <- fluidRow(
#  box(
#    title = "My Account Page Path Analysis"
#    ,width = NULL
    #,status = "primary"
#    ,solidHeader = TRUE 
    #,collapsible = TRUE 
    #,plotOutput("salesQuartBar", height = "300px")
#    ,htmlOutput('pathNetworkPlot2')
#  )
#)
#  
#  # first box for a line graph showing the share per model
#  box(
#    title = "Sankey"
#    ,width = NULL
#    ,status = "primary"
#    ,solidHeader = FALSE
#    #,collapsible = TRUE
#    ,htmlOutput("sankeyPathPlot")
#  )
  
  
#)

# data table to view the raw data
#frow4 <- fluidRow(
#  tabBox(
#    title = "Account Data Table"
#    ,width = 10
#    ,id = "dataTabBox"
#    ,tabPanel(
#      title = "Revenue1"
#      ,dataTableOutput("salesbymodel")
#    )
#    ,tabPanel(
#      title = "Revenue2"
#      ,dataTableOutput("salesbyquarter")
#    )
#    ,tabPanel(
#      title = "Revenue3"
#      ,dataTableOutput("prioryearsales")
#    )
#  )
#)




# combine the three fluid rows to make the body
body <- dashboardBody(# Load D3.js
  tags$head(
    tags$script(src = 'http://d3js.org/d3.v3.min.js')
  ),
  frow1,frow2)

ui <- dashboardPage(header, sidebar, body, skin='red')

# create the server functions for the dashboard  
server <- function(input, output) { 
  
  #total.revenue <- sum(recommendation$Revenue)
  #prof.account <- recommendation %>% group_by(Account) %>% summarise(value = sum(Revenue)) %>% filter(value==max(value))
  #prof.prod <- recommendation %>% group_by(Product) %>% summarise(value = sum(Revenue)) %>% filter(value==max(value))
  
 # total.revenue <- as.numeric(as.character(yesterday_orders$Orders))
#  prof.account <- as.numeric(as.character(yesterday_orders$Orders))
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
    
    
    #### Force directed network
    
    #Limit to more than 5 occurence like in simple network
    #fd_graph_links <- subset(links, count > 5)
    
    #Get unique values of page name to create nodes df
    #Create an index value, starting at 0
    #fd_nodes <- as.data.frame(unique(c(fd_graph_links$step.1, fd_graph_links$step.2)))
    #names(fd_nodes) <- "name"
    #fd_nodes$nodevalue <- as.numeric(row.names(fd_nodes)) - 1
    
    #Create groupings for node colors
    #This is user-specific in terms of how to create these groupings
    #Due to few number of pages/topics, I am manually coding this
     
    
    #Create group column
    #fd_nodes$group <- sapply(fd_nodes$name, grouping)
    
    #Append numeric nodeid to pagename
    #fd_graph_links <- merge(fd_graph_links, fd_nodes[,1:2], by.x="step.1", by.y="name")
    #names(fd_graph_links) <- c("step.1", "step.2", "value", "source")
    
    #fd_graph_links <- merge(fd_graph_links, fd_nodes[,1:2], by.x="step.2", by.y="name")
    #names(fd_graph_links) <- c("step.1", "step.2", "value", "seg1", "seg2",'source','target')
    
    #d3output = "C:/Users/rzwitc200/Desktop/fd_graph.html"
    # Create force-directed graph
    #d3ForceNetwork(Links = fd_graph_links, Nodes = fd_nodes, Source = "source",
    #               Target = "target", NodeID = "name",
    #               Group = "group", opacity = 0.8, Value = "value",
                  # file = d3output,
    #               charge = -90,
    #               fontsize=12,
    #               standAlone = FALSE,
    #               parentElement = '#pathNetworkPlot')
  })
  
  
  
  output$pathNetworkPlot2 <- renderPrint({
    
    #Optional step: Cleaning my pagename URLs to remove to domain for clarity
    next_page1$step.1 <- sub("http://www.vodafone.com/","",
                            next_page1$step.1, ignore.case = TRUE)
    next_page1$step.2 <- sub("http://www.vodafone.com/","",
                            next_page1$step.2, ignore.case = TRUE)
    
    #Filter out Entered Site and duplicate rows, >120 for chart legibility
    #links <- subset(next_page, count >= 400 & step.1 != "Entered Site" & step.1 != "Exited Site" & step.2 != "Exited Site")
    links1 <- subset(next_page1, count>=500, step.1 != "Entered Site" & step.1 != "Exited Site" & step.2 != "Exited Site")
    
    
    
    
    
    
    
    d3SimpleNetwork(#subset(links, count > 100), 
      links1,
      Source = "step.1", Target = "step.2", 
      #height = 600,
      #width = 750, 
      fontsize = 12, linkDistance = 250, charge = -100,
      linkColour = "#666", nodeColour = "#3182bd",
      nodeClickColour = "#E34A33", textColour = "#3182bd", opacity = 0.6,
      standAlone = FALSE,
      parentElement = '#pathNetworkPlot2')
    
    
    #### Force directed network
    
    #Limit to more than 5 occurence like in simple network
    #fd_graph_links <- subset(links, count > 5)
    
    #Get unique values of page name to create nodes df
    #Create an index value, starting at 0
    #fd_nodes <- as.data.frame(unique(c(fd_graph_links$step.1, fd_graph_links$step.2)))
    #names(fd_nodes) <- "name"
    #fd_nodes$nodevalue <- as.numeric(row.names(fd_nodes)) - 1
    
    #Create groupings for node colors
    #This is user-specific in terms of how to create these groupings
    #Due to few number of pages/topics, I am manually coding this
    
    
    #Create group column
    #fd_nodes$group <- sapply(fd_nodes$name, grouping)
    
    #Append numeric nodeid to pagename
    #fd_graph_links <- merge(fd_graph_links, fd_nodes[,1:2], by.x="step.1", by.y="name")
    #names(fd_graph_links) <- c("step.1", "step.2", "value", "source")
    
    #fd_graph_links <- merge(fd_graph_links, fd_nodes[,1:2], by.x="step.2", by.y="name")
    #names(fd_graph_links) <- c("step.1", "step.2", "value", "seg1", "seg2",'source','target')
    
    #d3output = "C:/Users/rzwitc200/Desktop/fd_graph.html"
    # Create force-directed graph
    #d3ForceNetwork(Links = fd_graph_links, Nodes = fd_nodes, Source = "source",
    #               Target = "target", NodeID = "name",
    #               Group = "group", opacity = 0.8, Value = "value",
    # file = d3output,
    #               charge = -90,
    #               fontsize=12,
    #               standAlone = FALSE,
    #               parentElement = '#pathNetworkPlot')
  })
  
  
  output$sankeyPathPlot <- renderPrint({
    
    
    
    
    #Get unique values of page name to create nodes df
    #Create an index value, starting at 0
    nodes1 <- as.data.frame(unique(c(next_page1$step.1, next_page1$step.2)))
    names(nodes1) <- "name"
    nodes1$nodevalue <- as.numeric(row.names(nodes1)) - 1
    
    
    next_page1 <- next_page1[,c('step.1','step.2','count')]
    
    #Filter out Entered Site and duplicate rows, >120 for chart legibility
    links1 <- subset(next_page1, count >= median(next_page1$count) & step.1 != "Entered Site" & step.1 != "Exited Site")
    
    
    #summary(next_page$count)
    
    #Convert string to numeric nodeid
    links1 <- merge(next_page1, nodes1, by.x="step.1", by.y="name")
    names(links1) <- c("step.1", "step.2", "value", "source")
    
    links1 <- merge(links1, nodes1, by.x="step.2", by.y="name")
    names(links1) <- c("step.1", "step.2", "value", "source", "target")
    
    
    d3Sankey(Links = links1, Nodes = nodes1, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             fontsize = 12, nodeWidth = 50,
             standAlone = FALSE,
             parentElement = '#sankeyPathPlot')
    
    
  })

  output$profAcc <- renderValueBox({
    valueBox(
      formatC(prof.account$value, format="d", big.mark=',')
      ,paste('Top Account:',prof.account$Account)
      ,icon = icon("stats",lib='glyphicon')
      ,color = "purple")
    
    
  })
  
  
  
  output$marketShare <- renderValueBox({
    
    valueBox(
      formatC(total.revenue, format="d", big.mark=',')
      ,'Total Expected Revenue'
      ,icon = icon("gbp",lib='glyphicon')
      ,color = "green")
  
  })
  
  
  
  output$profitMargin <- renderValueBox({
    
      valueBox(
        formatC(prof.prod$value, format="d", big.mark=',')
        ,paste('Top Product:',prof.prod$Product)
        ,icon = icon("menu-hamburger",lib='glyphicon')
        ,color = "yellow")
      
  })
  
  
  output$salesQuartBar <- renderPlot({
    ggplot(data = recommendation, 
           aes(x=Product, y=Revenue, fill=factor(Region))) + 
      geom_bar(position = "dodge", stat = "identity") + ylab("Revenue (in Euros)") + 
      xlab("Product") + theme(legend.position="bottom" 
                             ,plot.title = element_text(size=15, face="bold")) + 
      ggtitle("Revenue by Product") + labs(fill = "Region")
  })
  
  
  output$salesYearBar <- renderPlot({
    ggplot(data = recommendation, 
           aes(x=Account, y=Revenue, fill=factor(Region))) + 
      geom_bar(position = "dodge", stat = "identity") + ylab("Revenue (in Euros)") + 
      xlab("Account") + theme(legend.position="bottom" 
                             ,plot.title = element_text(size=15, face="bold")) + 
      ggtitle("Revenue by Region") + labs(fill = "Region")
  })
  
  
  
  output$shareLine <- renderPlot({
    ggplot(data = recommendation, 
           aes(x=Account, y=Revenue, fill=factor(Product))) + 
      geom_bar(position = "dodge", stat = "identity") + ylab("Revenue (in Euros)") + 
      xlab("Account") + theme(legend.position="bottom" 
                             ,plot.title = element_text(size=15, face="bold")) + 
      ggtitle("Revenue by Account") + labs(fill = "Product")
    
  })
  
  
  output$shareBar <- renderPlot({
    ggplot(data = recommendation, 
           aes(x=Region, y=Revenue, fill=factor(Product))) + 
      geom_bar(position = "dodge", stat = "identity") + ylab("Revenue (in Euros)") + 
      xlab("Region") + theme(legend.position="bottom" 
                             ,plot.title = element_text(size=15, face="bold")) + 
      ggtitle("Revenue by Region") + labs(fill = "Product")
    
  })
  
  
  output$salesbymodel <- renderDataTable(recommendation %>% group_by(Account) %>% summarize('Expected Revenue' = sum(Revenue)))
  output$salesbyquarter <- renderDataTable(recommendation %>% group_by(Region) %>% summarize('Expected Revenue' = sum(Revenue)))
  output$prioryearsales <- renderDataTable(recommendation %>% group_by(Product) %>% summarize('Expected Revenue' = sum(Revenue)))
  
  
  
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
