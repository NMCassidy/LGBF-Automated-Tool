shinyServer(function(input,output){
  
  data1 <- reactive({
   # dtt <- filter(dta, `Local Authority` == input$LA)
    dtt <- dta
    if(input$Serv == "Corporate"){
      dtt <- dtt[grep("CORP",dtt$Indicator, perl = TRUE),]
    } else if(input$Serv == "Childrens")
    {dtt <- dtt[grep("CHN",dtt$Indicator, perl = TRUE),]}
    else if(input$Serv == "Social Care")
    {dtt <- dtt[grep("SW",dtt$Indicator, perl = TRUE),]}
    else if(input$Serv == "Culture & Leisure")
    {dtt <- dtt[grep("C&L",dtt$Indicator, perl = TRUE),]}
    else if(input$Serv == "Environmental")
    {dtt <- dtt[grep("ENV",dtt$Indicator, perl = TRUE),]}
    else if(input$Serv == "Housing")
    {dtt <- dtt[grep("HSN",dtt$Indicator, perl = TRUE),]}
    else if(input$Serv == "Economic Development")
    {dtt <- dtt[grep("ECON",dtt$Indicator, perl = TRUE),]}
  })
  output$SelectIndicator <- renderUI({
    data <- data1()
    selectInput("Ind", "Select an Indicator", unique(data$IndName), width = "100%")
  })
  data <- reactive({
    dt <- data1()
    dt <- filter(dt, `Local Authority` %in% c(input$LA, "Family Group", "Scotland")) %>%
      rbind(., dtaFG[dtaFG$grpchldrn_2012 %in% .$grpchldrn_2012,]) %>%
      filter(., IndName == input$Ind)
  })
  
  mainp <- function(){
    dt2 <- data()
    tt <- ggplot(data = dt2) +
      geom_line(aes(y = Value, x = Year, group = `Local Authority`, colour = `Local Authority`,
                    text = paste("Area:", `Local Authority`, sep = " "))) +
      theme_hc() +
      scale_y_continuous(limits = c(min(dt2$Value)-min(dt2$Value)/5, max(dt2$Value)+max(dt2$Value)/5)) +
      xlab("Date") +
      ylab("")
    ggplotly(tt, tooltip = c("text", "y")) %>% config(displayModeBar = FALSE)
  }
  
  output$mainplot <- renderPlotly({
    mainp()
  })
  
})