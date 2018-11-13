library(shiny)
library(leaflet)
library(DT)
library(readxl)

dt = read_excel("2g3g-f.xlsx")

map = leaflet()
map = addTiles(map)

df = read.csv("data.csv",fileEncoding = "UTF-8")
df = df[2:length(df)]


ui = navbarPage("Qos 2G/3G",
              tabPanel("Carte",
                       sidebarLayout(
                         sidebarPanel(
                           selectInput("op","Sélectionner un opérateur téléphonique",
                                       choices = unique(df$opérateur)
                           )  
                         ),
                         mainPanel(
                           leafletOutput("map")
                         )
                       )
              ),
              tabPanel("Data",
                  dataTableOutput("dataset")
                
              ),
              tabPanel("Explication des variables",
                       h3("Indicateur clé de performance"),
                       br(),
                       h4("Définition"),
                       hr(),
                       p("Un indicateur clé de performance (ICP), ou en anglais Key performance indication (KPI) est indicateur mesurable d’aide à la décision. 
                            Les indicateurs retenus dans le cadre de ce projet sont définis comme suit :"),
                       hr(),
                       h4("Service voix"),
                       hr(),
                       h5("   Taux de blocage (Tb,%)"),
                       p("Rapport entre le nombre de tentatives d'appel bloquées et le nombre total de tentatives de communication émises. Une tentative est considérée bloquée si le retour de sonnerie n'est pas reçu au bout de 20 secondes. Les tentatives d'appel sont espacées d'un intervalle de temps variable égal au minimum à 30 secondes."),
                       hr(),
                       h5("Taux de coupure (Tc, %)"),
                       p("Rapport le nombre de communications de 2 minutes coupées avant l'écoulement de cette durée et le nombre total des communications non bloquées. - Note d'opinion moyenne (MOS) : Note affectée à une communication suite à une évaluation de sa qualité auditive moyennant un algorithme de scoring sur la base d’appels dont la durée moyenne est de 2 minutes."),
                       hr(),
                       h4("Service data"),
                       hr(),
                       h5("Taux de réussite de l’accès (Tra, %)"),
                       p("Rapport entre le nombre de tentatives d'accès à un ensemble de sites Web ou à un ensemble de vidéos en streaming HTTP non bloquées et le nombre total de tentatives d'accès. "),
                       hr(),
                       h5("Débit moyen de navigation 2G/3G (Dmn , kbps)"),
                       p("Rapport entre la somme des bits reçus pendant une session de navigation HTTP et la durée de cette session. "),
                       hr(),
                       h5("Taux de téléchargement/envoi de fichiers réussis (Trdl/Trup,%)"),
                       p("Rapport entre le nombre de téléchargements/envois réussis et le nombre total de téléchargements/envois. "),
                       hr(),
                       h5("Débit moyen de téléchargement/envoi de fichiers (Dsl/Dup, Mbps)"),
                       p("Rapport entre la somme des bits reçus/envoyés pendant une session FTP (File Transfert Protocol) et la durée de cette session."),
                       hr()
              ))

server = function(input, output) {
   
  output$map = renderLeaflet({
    
    df_op = df[which(df$opérateur == input$op), ]
    for(i in 1:nrow(df_op)){
      long = df_op$Longitude[i]
      lat = df_op$Latitude[i]
      content = paste(sep = "<br/>",
                      paste("Gouvernorat:",df_op$gouvernorat[i],sep = " "),
                      paste("Service Voix _ Blocage 2G:",df_op$service.voix..voix.2G..blocage[i],sep = " "),
                      paste("Service Voix _ Coupure 2G:",df_op$service.voix..voix.2G..coupure[i],sep = " "),
                      paste("Service Voix _ Blocage 3G:",df_op$service.voix..voix.3G..blocage[i],sep = " "),
                      paste("Service Voix _ Coupure 3G:",df_op$service.voix..voix.3G..coupure[i],sep = " "),
                      paste("Service Web _ Réussite de navigation 2G:",df_op$service.web..2G..reussite.de.navigation[i],sep = " "),
                      paste("Service Web _ Débit moyen de navigation 2G:",df_op$service.web..2G..debit.moyen.de.navigation[i],sep = " "),
                      paste("Service Web _ Réussite de navigation 3G:",df_op$service.web..3G..reussite.de.navigation[i],sep = " "),
                      paste("Service Web _ Débit moyen de navigation 3G:",df_op$service.web..3G..debit.moyen.de.navigation[i],sep = " "),
                      paste("Service FTP _ Réussite de téléchargement:",df_op$service.FTP..reussite.de.telechargement[i],sep = " "),
                      paste("Service FTP _ Réussite d'envoi:",df_op$service.FTP..reussite.d.envoi[i],sep = " "),
                      paste("Service FTP _ Débit moyen de téléchargement:",df_op$service.FTP..debit.moyen.de.telechargement[i],sep = " "),
                      paste("Service FTP _ Débit moyen d'envoi:",df_op$service.FTP..debit.moyen.d.envoi[i],sep = " "),
                      paste("Service Streaming _ Réussite d'accès:",df_op$service.streaming..réussite.d.accès.au.service.de.streaming[i],sep = " ")
      )
      if(input$op == "Tunisie Télécom") url = "icons/telecom.png"
      if(input$op == "Orange Tunisie") url = "icons/orange.png"
      if(input$op == "Ooredoo") url = "icons/ooredoo.png"
      
      Op_Icon = makeIcon(
        iconUrl = url,
        iconWidth = 25, iconHeight = 25
      )
      map = addMarkers(map, lng=long, lat=lat, popup=content , icon = Op_Icon)
    }
    map
  })
  
  
  output$dataset = DT::renderDataTable({
    dt
  })
}

shinyApp(ui = ui, server = server)

