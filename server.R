#--------------------------------------------------------------------------#
#                    TABA Assignment question 1                            #
# Bhargavi M - 11810074, Sonam Sharma - 11810047, Srinivas Kumar -11810025 #
#--------------------------------------------------------------------------#

options(shiny.maxRequestSize=30*1024^2)


shinyServer(function(input, output) {

  #Taking input from checklist and storing the selected inputs (xpos) in a list 'list1'  
  list1<-reactive({
    
    y<-input$checkGroup
    return(y)
  })

#Creating dataset from the input text file and taking udpipe input
  #We are then filterning the anotated dataset basis the selected xpos
  Dataset <- reactive({
    
    if (is.null(input$file1)) {   # locate 'file1' from ui.R
      
                  return(NULL) } else{
      
      Doc <- readLines(input$file1$datapath)
      #return(as.data.frame(Doc))
    
       udpipe_model<-udpipe_load_model(input$file_trained$datapath)
      x <- udpipe_annotate(udpipe_model, x = Doc)
      x <- as.data.frame(x)
      y<- x %>% subset(., xpos %in% list1())
      return(y)
    }
  })
#rendering the filtered anotated dataset  
  output$df=renderDataTable({
  Dataset()
    
  })
  
 
 #To display the top xpos in the document  
  top_nouns<-reactive({
    all_nouns = Dataset() %>% subset(., xpos %in% "NN")
    top_nouns1 = txt_freq(all_nouns$lemma)
    return(top_nouns1)
  })

  top_adj<-reactive({
    all_adj = Dataset() %>% subset(., xpos %in% "JJ")
    top_adj1 = txt_freq(all_adj$lemma)
    return(top_adj1)
  })


  top_advb<-reactive({
    all_advb = Dataset() %>% subset(., xpos %in% "RB")
    top_advb1 = txt_freq(all_advb$lemma)
    return(top_advb1)
  })


  top_prop<-reactive({
    all_prop = Dataset() %>% subset(., xpos %in% "NNP")
    top_prop1 = txt_freq(all_prop$lemma)
    return(top_prop1)
  })
  
  
  top_verb<-reactive({
    all_verb = Dataset() %>% subset(., xpos %in% "VB")
    top_verb1 = txt_freq(all_verb$lemma)
    return(top_verb1)
  })

  #Rendering the tables created above.
output$out_adj <-  renderTable({

  head(top_adj(), 10)
})

output$out_noun <-  renderTable({
  
  head(top_nouns(), 10)
})  

output$out_prop <-  renderTable({
  
  head(top_prop(), 10)
})  

output$out_advb <-  renderTable({
  
  head(top_advb(), 10)
}) 

output$out_verb <-  renderTable({
  
  head(top_verb(), 10)
}) 
#Creating collocation table
  output$colloc_table = renderTable({
    keywords_collocation(x = Dataset(), 
                                 term = "token", 
                                 group = c("doc_id", "paragraph_id", "sentence_id"),
                                 ngram_max = 4)  
  
  colloc
})
 
  
  
  cooc1 <- reactive({
    a=cooccurrence( 
    x = subset(Dataset(), xpos %in% list1()), 
    term = "lemma", 
    group = c("doc_id", "paragraph_id", "sentence_id"))
    return(a)
  }) 
  
  output$cooc_table = renderDataTable({ 
    cooc1()
  })    

  #Renderinf cooccurrence graph  
# Calc and render plot    
output$plot_cooc = renderPlot({ 
  
  wordnetwork <- head(cooc1(), 50)
  wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
  
  ggraph(wordnetwork, layout = "fr") +  
    
    geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
    geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
    
    theme_graph(base_family = "Arial Narrow") +  
    theme(legend.position = "none") +
    
    labs(title = "Cooccurrences within 3 words distance")
  
  
       })
#Creating and rendering wordclouds for the 5 xpos
output$cloud_adj= renderPlot({
         
         wordcloud(words = top_adj()$key,
          freq = top_adj()$freq,
          min.freq = 2,
          max.words = 100,
          random.order = FALSE, 
          colors = brewer.pal(6, "Dark2"))
})

output$cloud_noun= renderPlot({
  
  wordcloud(words = top_nouns()$key,
            freq = top_nouns()$freq,
            min.freq = 2,
            max.words = 100,
            random.order = FALSE, 
            colors = brewer.pal(6, "Dark2"))
})

output$cloud_prop= renderPlot({
  
  wordcloud(words = top_prop()$key,
            freq = top_prop()$freq,
            min.freq = 2,
            max.words = 100,
            random.order = FALSE, 
            colors = brewer.pal(6, "Dark2"))
})

output$cloud_advb= renderPlot({
  
  wordcloud(words = top_advb()$key,
            freq = top_advb()$freq,
            min.freq = 2,
            max.words = 100,
            random.order = FALSE, 
            colors = brewer.pal(6, "Dark2"))
})

output$cloud_verb= renderPlot({
  
  wordcloud(words = top_verb()$key,
            freq = top_verb()$freq,
            min.freq = 2,
            max.words = 100,
            random.order = FALSE, 
            colors = brewer.pal(6, "Dark2"))
})

  
})
