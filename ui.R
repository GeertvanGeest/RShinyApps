# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("General Linear Model"),
  
  sidebarPanel(
    h4('Import file'),
    fileInput('file1', 'Choose text File',
              accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'Header', TRUE),
    selectInput('sep', 'Separator',
                 choices=c('Tab',
                           'Semicolon',
                           'Comma',
                           'Space',
                           'Any white space')),
    selectInput('dec', 'Decimal',
                 choices=c('Comma','Dot')),
    numericInput('obs', 'Number of observations to view', 10),
    tags$hr(),
    h4('Select data'),
    numericInput('colnumvar1','Columnnumber of explanatory variable', 2),
    numericInput('colnumvar2','Columnnumber of response variable', 3),
    numericInput('colnumfac','Columnnumber of factor (optional)', 0)    
    ),
  
  mainPanel(
    tabsetPanel(
    tabPanel('Input data', tableOutput('contents')),
    tabPanel('Analysis of variance',
             p('Factor is not taken into account'), 
             verbatimTextOutput('anova')),
    tabPanel('Fitted model',
             p('Factor is not taken into account'),
             h4(textOutput('param'))),
    tabPanel('Scatterplot',
             plotOutput('scatterplot'),
             sliderInput('cex', 'Size of characters', 
                         min=0.5, max=3, value=1, step=0.1),
             br(),
             selectInput('legpos',
                         'Position of legend (only for factors)', 
                         choices=c('Upper Left',
                                   'Upper Right',
                                   'Lower Left',
                                   'Lower Right')))

            ))
))
