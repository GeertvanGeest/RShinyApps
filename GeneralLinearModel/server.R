library(shiny)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  sepInput <- reactive({
    switch(input$sep,
           'Comma'=',',
           'Semincolon'=';',
           'Tab'='\t',
           'Space'=' ',
           'Any white space'='')
  })
  decInput <- reactive({
    switch(input$dec,
           'Comma'=',',
           'Dot'='.')
  })
  output$contents <- renderTable({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    data<-read.csv(inFile$datapath, 
                   header=input$header, 
                   sep=sepInput(), 
                   dec=decInput())
    head(data, n=input$obs)
    
  })
  legposInput<- reactive({
    switch(input$legpos,
           'Upper Left' = 'topleft',
           'Upper Right' = 'topright',
           'Lower Left' = 'bottomleft',
           'Lower Right' = 'bottomright')
  })
  output$scatterplot <- renderPlot({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    data <- read.csv(inFile$datapath, 
                     header=input$header, 
                     sep=sepInput(), 
                     dec=decInput())
    V1<-data[,input$colnumvar1]
    V2<-data[,input$colnumvar2]
    F1<-data[,input$colnumfac]

    #plot(f)
    lev<-levels(F1)
    cols<-brewer.pal(12,'Paired')
    if(input$colnumfac!=0){
      plot(0, 
           xlim=c(0, max(V1)),
           ylim=c(0, max(V2)), 
           ylab='response', 
           xlab='explanatory',
           cex.lab=input$cex,
           cex.axis=input$cex)
      for (i in c(1:length(lev))){
        f<-V2[F1==lev[i]]~V1[F1==lev[i]]
        model<-lm(f)
        points(f, col=cols[i], pch=19, cex.lab=input$cex, cex.axis=input$cex)
        abline(model)
    }

    legend(legposInput(), lev, col=cols[1:length(lev)], bty='n', cex=input$cex, pch=19)
    }
    else{plot(V2~V1, 
              ylab='response', 
              xlab='explanatory', 
              pch=19, 
              col=cols[2],
              cex.lab=input$cex,
              cex.axis=input$cex)
         f<-V2~V1
         model<-lm(f)
         abline(model)
    }
  })
  output$anova <- renderPrint({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    data <- read.csv(inFile$datapath, 
                     header=input$header, 
                     sep=sepInput(), 
                     dec=decInput())
    x<-data[,input$colnumvar1]
    y<-data[,input$colnumvar2]
    F1<-data[,input$colnumfac]
    f<-y~x
    summary(lm(f))
  })
  paramText <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    data <- read.csv(inFile$datapath, 
                     header=input$header, 
                     sep=sepInput(), 
                     dec=decInput())
    slope<-data[,input$colnumvar1]
    y<-data[,input$colnumvar2]
    F1<-data[,input$colnumfac]
    f<-y~slope
    model<-lm(f)
    paste('y=',as.character(round(model$coefficients[2], digits=3)),
          'x + ',
          as.character(round(model$coefficients[1], digits=3)))
  })
  output$param<-renderText({paramText()})
})
