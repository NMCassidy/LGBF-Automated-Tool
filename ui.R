shinyUI(fluidPage(
  titlePanel("LGBF Automated Tool"),
    
    fluidRow(
      column(3, selectInput("Serv", "Select a Service Area", c("Corporate","Childrens",
                                  "Social Care", "Culture & Leisure", "Environmental",
                                  "Housing", "Economic Development"))),
      column(5, uiOutput("SelectIndicator")),
      column(4, selectInput("LA", "Select an Authority", unique(dta$`Local Authority`)[1:32]))
    ),
    hr(),
    
    plotlyOutput("mainplot")
   
  
  
)
)