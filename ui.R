#--------------------------------------------------------------------------#
#                    TABA Assignment question 1                            #
# Bhargavi M - 11810074, Sonam Sharma - 11810047, Srinivas Kumar -11810025 #
#--------------------------------------------------------------------------#

#windowsFonts(devanew=windowsFont("Devanagari new normal"))
shinyUI(
  fluidPage(
    theme = shinytheme("sandstone"), #used a theme to enhance basic UI
    titlePanel("UDPipe"),
  
    sidebarLayout( 
      
      sidebarPanel(  
        #upload the input text file
              fileInput("file1", "Upload data (text file)"), 
         #upload the udpipe model
              fileInput("file_trained","Upload trained udpipe model for the language which is same as the loaded data"),
             #check boxes
          checkboxGroupInput("checkGroup", 
                                 h3("Select POS tags"), 
                                 choices = list("Adjective (JJ)" = "JJ", 
                                                "Noun (NN)" = "NN", 
                                                "Proper Noun (NNP)" = "NNP",
                                                "Adverb (RB)"="RB",
                                                "Verb(VB)"="VB"),
                                 selected = list("JJ","NN","NNP"))
                 ),   # end of sidebar panel
    
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                 #this tab will give the overview of the app and how to use it. 
                      tabPanel("Overview",
                               h4(p("Introduction")),
                               p("This application simplifies the process to tokenize, tag, lemmatize or perform dependency parsing on text in any language using trained UDPIPE models of R software.  Also steamlines the process of building co-occurrence plots , get top POStags and produces visualization of co-occurrences within three words distance in the form of wordcloud."),

 

span(strong("About UDPIPE")),

p("UDPIPE is a R package available and is an open source project. It is freely available for non-commercial purposes.  More details can be found in the below link."),

 

a(href="https://cran.r-project.org/web/packages/udpipe/index.html","About udpipe",align="justify"),
                               h4(p("Data input")),
                               p("This app supports only text input file.",align="justify"),
                               p("Please refer to the link below for sample text file."),
                               a(href="https://github.com/Csrinivaskumar/sample-data"
                                 ,"Sample data input file"),   
                               br(),
                               h4('How to use this App'),
                               p('To use this app, click on', 
                                 span(strong("Browse under Upload data (text file)")),
                                 'and upload the text data file. Then upload the UD pipe model as per the Language of uploaded data.
                                 Also, select the part of speach (POS) Tags , as per which the co-occurrences graph and word clouds will be plotted.',br(),
                                 'By default Adjective, Noun and Proper Noun will be selected in the check box, thereby rendering all the output tabs taking these three XPOS into consideration.
                                 You can choose the XPOS of our choice by selecting relevant option(s) the checkbox.' )),
                  
                  tabPanel("Filtered annotated dataset",
                          dataTableOutput('df')), 
                  tabPanel("Top 10 POS",
                           h4("Top 10 Adjectives"),
                           tableOutput('out_adj'),
                           br(),
                           h4("Top 10 Nouns"),
                           tableOutput('out_noun'),
                           br(),
                           h4("Top 10 Proper Nouns"),
                           tableOutput('out_prop'),
                           br(),
                           h4("Top 10 Adverbs"),
                           tableOutput('out_advb'),
                           br(),
                           h4("Top 10 Verbs"),
                           tableOutput('out_verb')),
                  tabPanel("Co-occurrence Table",
                           dataTableOutput('cooc_table')),
                   tabPanel("Co-occurrence plot", 
                                   plotOutput('plot_cooc')),
                   
                      
                      
                    
                    tabPanel("Wordcloud",
                             h4("Wordcloud for Adjectives"),  
                           plotOutput('cloud_adj'),
                          br(),
                     h4("Wordcloud for Nouns"),
                    plotOutput('cloud_noun'),
                     br(),
                  h4("Wordcloud for Proper Nouns"),
                  plotOutput('cloud_prop'),
                  br(),
                  h4("Wordcloud for Adverbs"),
                  plotOutput('cloud_advb'),
                  br(),
                  h4("Wordcloud for Verbs"),
                  plotOutput('cloud_verb')
      )
        
      ) # end of tabsetPanel
          )# end of main panel
            ) # end of sidebarLayout
              )  # end if fluidPage
               )  # end of UI



