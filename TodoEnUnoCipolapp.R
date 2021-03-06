library(readr)
library(dplyr)
library(purrr)
library(tidyr)
library(stringr)
library(tidytext)
library(tm)
library(colorspace)
library(plotly)
library(sqldf)
library(openxlsx)

Sys.getlocale()
Sys.setlocale("LC_ALL", "es_ES.UTF-8")
memory.limit(size = 99999999)
carpeta = "C:/Users/Aaron/Desktop/Archivos practica/ProgramasR/TodoEnUnoCipolapp"
carpeta_base = paste(carpeta,"Bases",sep="/")
nombres = dir(carpeta_base)
nombres = as.data.frame(nombres)

pat ="(RT|via)(((?:\\b\\W*|)@\\w+)+)|,|:|(https|http)://t.co/[A-Za-z\\d]+|&amp;|http\\w*|@\\w+|(\\w+\\.|)\\w+\\.\\w+(/\\w+)*"
patref ="@[A-Za-z0-9]*[^\\s:_.<]"
patref2 ="[A-Za-z0-9]+"
patHashtag="#[A-Za-z0-9áéíóú]*"
pat3 = "[A-Za-z0-9_]+"

Sys.setenv("plotly_username"="observatorio2019")
Sys.setenv("plotly_api_key"="BObHnm3fSEoIg5SCk3a2")

if(dir.exists(paste(carpeta, "Resultados_csv", sep = "/")))
{}else
{
  dir.create(paste(carpeta, "Resultados_csv", sep = "/"))
  
  if((dir.exists(paste(carpeta,"Resultados_csv","Evolucion", sep = "/")))
     &(dir.exists(paste(carpeta,"Resultados_csv","Comunidad", sep = "/")))
     &(dir.exists(paste(carpeta,"Resultados_csv","Efectos", sep = "/")))
     &(dir.exists(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas", sep = "/")))
     &(dir.exists(paste(carpeta,"Resultados_csv", "DeterminantesSemanticos", sep = "/"))))
  {}else
  {
    dir.create(paste( carpeta,"Resultados_csv", "Evolucion", sep = "/"))
    dir.create(paste( carpeta,"Resultados_csv", "Comunidad", sep = "/"))
    dir.create(paste( carpeta,"Resultados_csv", "Efectos", sep = "/"))
    dir.create(paste( carpeta,"Resultados_csv", "CaracteristicasTecnicas", sep = "/"))
    dir.create(paste( carpeta,"Resultados_csv", "DeterminantesSemanticos", sep = "/"))
    
    if((dir.exists(paste(carpeta,"Resultados_csv","Evolucion","Histograma", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","Evolucion","Grafico Torta", sep = "/"))))
    {}else
    {
      dir.create(paste(carpeta,"Resultados_csv","Evolucion","Histograma", sep = "/"))
    }
    if((dir.exists(paste( carpeta,"Resultados_csv","DeterminantesSemanticos","Nube", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","DeterminantesSemanticos","Bigrama", sep = "/"))))
    {}else
    {
      dir.create(paste( carpeta,"Resultados_csv", "DeterminantesSemanticos", "Nube", sep = "/"))
      dir.create(paste( carpeta,"Resultados_csv", "DeterminantesSemanticos", "Bigrama", sep = "/"))
    }
    if((dir.exists(paste(carpeta,"Resultados_csv","Comunidad","Referentes", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","Comunidad","Influenciadores", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","Comunidad","Movilizadores", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","Comunidad","Activistas", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","Comunidad","CategorizarSexo", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","Comunidad","Masificadores", sep = "/"))))
    {}else
    {
      dir.create(paste(carpeta,"Resultados_csv","Comunidad","Referentes", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","Comunidad","Influenciadores", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","Comunidad","Movilizadores", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","Comunidad","CategorizarSexo", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","Comunidad","Masificadores", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","Comunidad","Activistas", sep = "/"))
    }
    if((dir.exists(paste(carpeta,"Resultados_csv","Efectos","Valoracion", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","Efectos","Categorizacion", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","Efectos","Muestra", sep = "/"))))
    {}else
    {
      dir.create(paste(carpeta,"Resultados_csv","Efectos", "Valoracion", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","Efectos", "Categorizacion", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","Efectos", "Muestra", sep = "/"))
    }
    
    if((dir.exists(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Caracteres", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Multimedia", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Dispositivos", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","PorcentajeGeoreferencia", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","RankingGeoreferencia", sep = "/")))
    )
    {}else
    {
      dir.create(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Caracteres", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Multimedia", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Dispositivos", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","PorcentajeGeoreferencia", sep = "/"))
      dir.create(paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","RankingGeoreferencia", sep = "/"))
    }
  }
}

if(dir.exists(paste(carpeta, "Resultados_excel", sep = "/")))
{}else
{
  dir.create(paste(carpeta, "Resultados_excel", sep = "/"))
  
  if((dir.exists(paste(carpeta,"Resultados_excel","Evolucion", sep = "/")))
     &(dir.exists(paste(carpeta,"Resultados_excel","Comunidad", sep = "/")))
     &(dir.exists(paste(carpeta,"Resultados_excel","Efectos", sep = "/")))
     &(dir.exists(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas", sep = "/")))
     &(dir.exists(paste(carpeta,"Resultados_excel", "DeterminantesSemanticos", sep = "/"))))
  {}else
  {
    dir.create(paste( carpeta,"Resultados_excel", "Evolucion", sep = "/"))
    dir.create(paste( carpeta,"Resultados_excel", "Comunidad", sep = "/"))
    dir.create(paste( carpeta,"Resultados_excel", "Efectos", sep = "/"))
    dir.create(paste( carpeta,"Resultados_excel", "CaracteristicasTecnicas", sep = "/"))
    dir.create(paste( carpeta,"Resultados_excel", "DeterminantesSemanticos", sep = "/"))
    
    if((dir.exists(paste(carpeta,"Resultados_excel","Evolucion","Histograma", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","Evolucion","Grafico Torta", sep = "/"))))
    {}else
    {
      dir.create(paste(carpeta,"Resultados_excel","Evolucion","Histograma", sep = "/"))
    }
    if((dir.exists(paste( carpeta,"Resultados_excel","DeterminantesSemanticos","Nube", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","DeterminantesSemanticos","Bigrama", sep = "/"))))
    {}else
    {
      dir.create(paste( carpeta,"Resultados_excel", "DeterminantesSemanticos", "Nube", sep = "/"))
      dir.create(paste( carpeta,"Resultados_excel", "DeterminantesSemanticos", "Bigrama", sep = "/"))
    }
    if((dir.exists(paste(carpeta,"Resultados_excel","Comunidad","Referentes", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","Comunidad","Influenciadores", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","Comunidad","Movilizadores", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","Comunidad","Activistas", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","Comunidad","CategorizarSexo", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","Comunidad","Masificadores", sep = "/"))))
    {}else
    {
      dir.create(paste(carpeta,"Resultados_excel","Comunidad","Referentes", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","Comunidad","Influenciadores", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","Comunidad","Movilizadores", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","Comunidad","CategorizarSexo", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","Comunidad","Masificadores", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","Comunidad","Activistas", sep = "/"))
    }
    if((dir.exists(paste(carpeta,"Resultados_excel","Efectos","Valoracion", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","Efectos","Categorizacion", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","Efectos","Muestra", sep = "/"))))
    {}else
    {
      dir.create(paste(carpeta,"Resultados_excel","Efectos", "Valoracion", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","Efectos", "Categorizacion", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","Efectos", "Muestra", sep = "/"))
    }
    
    if((dir.exists(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Caracteres", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Multimedia", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Dispositivos", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","PorcentajeGeoreferencia", sep = "/")))
       & (dir.exists(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","RankingGeoreferencia", sep = "/")))
    )
    {}else
    {
      dir.create(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Caracteres", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Multimedia", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Dispositivos", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","PorcentajeGeoreferencia", sep = "/"))
      dir.create(paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","RankingGeoreferencia", sep = "/"))
    }
  }
}

i = 1
numArchivos = nrow(nombres)

while(i <= numArchivos)
{
  nombre<-substr(toString(nombres$nombres[i]),1,(str_length(nombres$nombres[i])-4))
  nombre_carpeta<-paste(carpeta,"Resultados_csv",sep = "/")
  archivo_temporal<-paste(carpeta_base,toString(nombres$nombres[i]),sep="/")
  nombreResultado<-nombres$nombres[i]
  #--- Data frame de la base ---#
  aux <- read.csv(archivo_temporal, header = TRUE, sep = ",", encoding = "UTF-8")
  aux <- as.data.frame(aux)
  
  #--- Arreglo de los tildes ---#
  aux$hashtags=gsub("\xf1",'ñ',aux$hashtags)
  aux$hashtags=gsub("\xe1","a",aux$hashtags)#a
  aux$hashtags=gsub("\xc1",'A',aux$hashtags)#A
  aux$hashtags=gsub("\xe9","e",aux$hashtags)#e
  aux$hashtags=gsub("\xc9","E",aux$hashtags)#E
  aux$hashtags=gsub("\xed","i",aux$hashtags)#i
  aux$hashtags=gsub("\xcd","I",aux$hashtags)#I
  aux$hashtags=gsub("\xf3",'o',aux$hashtags)#o
  aux$hashtags=gsub("\xd3","O",aux$hashtags)#O
  aux$hashtags=gsub("\xda","U",aux$hashtags)#U
  aux$hashtags=gsub("\xfa","u",aux$hashtags)#u
  aux$hashtags=gsub("\x40","@",aux$hashtags)#@
  aux$hashtags=gsub("c[()]"," ",aux$hashtags)
  aux$hashtags=gsub(","," ",aux$hashtags)
  aux$hashtags=gsub("[^0-9A-Za-z/// ']","",aux$hashtags)
  aux$text=gsub("[^0-9A-Za-z/// ']","",aux$text)
  
  #--- Eliminacion de tildes ---#
  aux$hashtags=gsub("á","a",aux$hashtags)
  aux$hashtags=gsub("é","e",aux$hashtags)
  aux$hashtags=gsub("í","i",aux$hashtags)
  aux$hashtags=gsub("ó","o",aux$hashtags)
  aux$hashtags=gsub("ú","u",aux$hashtags)
  # --- Eliminacion de Emojis ---#
  aux$text <-gsub("[^\x30-\x7f]"," ",aux$text)
  
  #Total de filas de la base
  try(total_filas <- sqldf("SELECT count(user_id) total_filas FROM aux"), silent = TRUE)
  
  # --- EVOLUCION Y SENTIDA --- #
  # --- HISTOGRAMA --- #
  try(histograma <- sqldf('SELECT  SUBSTR(created_at,1,10) FECHA,COUNT(SUBSTR(created_at,1,10)) CANTIDAD  
                       FROM aux 
                       GROUP BY substr(created_at,1,10) 
                       ORDER BY substr(created_at,1,10) 
                       DESC'), silent = TRUE)
  
  try(write.csv(histograma,file <- paste(carpeta,"Resultados_csv","Evolucion","Histograma","histogramax1dia.csv",sep = "/"),row.names=FALSE),silent = TRUE)
  try(write.xlsx(histograma,file <- paste(carpeta,"Resultados_excel","Evolucion","Histograma","histogramax1dia.xlsx",sep = "/"),row.names=FALSE),silent = TRUE)
  # --- REPRODUCCION, PRODUCCION, INTERACCION --- #
  # ===================================================== #
  busqueda_RT = sqldf("SELECT * FROM aux WHERE is_retweet = '1'")
  
  busqueda_RTAI = sqldf("SELECT * FROM busqueda_RT WHERE text NOT LIKE '@%' AND text NOT LIKE 'RT%'")
  
  busqueda_RTNAI = sqldf("SELECT * FROM busqueda_RT WHERE text NOT LIKE '@%' AND text NOT LIKE 'RT%' AND text NOT LIKE '%@%'")
  
  total_RT = sqldf("SELECT COUNT(user_id) Retweets FROM busqueda_RT")
  
  total_RTAI = sqldf("SELECT COUNT(user_id) RetweetsAI FROM busqueda_RTAI")
  
  total_RTNAI = sqldf( "SELECT COUNT(user_id) RetweetsNAI FROM busqueda_RTNAI")
  # ===================================================== #
  busqueda_AA = sqldf("SELECT * FROM aux WHERE text LIKE '@%'")
  
  busqueda_NART = sqldf("SELECT * FROM aux WHERE text NOT LIKE '@%' AND text NOT LIKE 'RT%'")
  
  total_AA = sqldf("SELECT COUNT(user_id) Arroba FROM busqueda_AA")
  
  total_NART = sqldf("SELECT COUNT(user_id) noArrRet FROM busqueda_NART")
  # ===================================================== #
  # Grafico Torta #
  total <- sqldf("SELECT * FROM total_AA, total_NART, total_RT, total_RTAI, total_RTNAI,total_filas")
  
  AA = total$Arroba
  NART = total$noArrRet
  RT = total$Retweets
  RTAI = total$RetweetsAI
  RTNAI = total$RetweetsNAI
  N = total_filas$total_filas
  
  RIP = matrix(c(trunc((AA/N)*100*10^2)/10^2,trunc((NART/N)*100*10^2)/10^2,trunc((RT/N)*100*10^2)/10^2,"Interaccion","Produccion","Reproduccion"),ncol = 2)
  colnames(RIP) = c("Porcentaje","Tipo")
  RIP = as.data.frame(RIP)
  
  data <- RIP[,c('Porcentaje', 'Tipo')]
  
  p <- plot_ly(data, labels = ~Tipo, values = ~Porcentaje, type = 'pie') %>%
    layout(title = 'Produccion, Interaccion y Reproduccion',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
  try(plotly_IMAGE(p, format = "png", out_file = paste(carpeta,"Resultados_csv","Evolucion","ReproduccionInteraccionProduccion.png",sep="/"),silent = TRUE))
  try(plotly_IMAGE(p, format = "png", out_file = paste(carpeta,"Resultados_excel","Evolucion","ReproduccionInteraccionProduccion.png",sep="/"),silent = TRUE))
  
  #--- DETERMINANTES SEMANTICOS--- #
  #--- NUBE ---#
  conectores<-read.csv(paste(carpeta,"conectores.csv",sep = "/"), header = FALSE)
  tempora_nube<-sqldf("SELECT text FROM aux")
  tempora_nube<-mutate(tempora_nube,text = str_replace_all(text,pat, ""))
  lis<-unnest_tokens(tempora_nube,word, text, token="ngrams",n=1 )
  nube<-count(lis,word,sort=TRUE)
  nube<-as.data.frame(nube)
  conectores<-as.data.frame(conectores)
  consulta_conectores <- paste0(paste("SELECT * FROM nube WHERE word!=",conectores$V1[1],sep = "'" ),"'")
  
  for(j in 2:length(conectores[,1]))
  {
    consulta_conectores <- paste0(paste(consulta_conectores,conectores$V1[j],sep = " and word !='"),"'")
  }
  nube <- sqldf(consulta_conectores)
  write.csv(nube, file = paste(carpeta,"Resultados_csv","DeterminantesSemanticos","Nube","nube.csv",sep = "/"),row.names=FALSE)
  write.xlsx(nube, file = paste(carpeta,"Resultados_excel","DeterminantesSemanticos","Nube","nube.xlsx",sep = "/"),row.names=FALSE)
  # --- BIGRAMA ----#
  data_bigrama=aux %>%
    mutate(text = str_replace_all(text,pat, "")) %>%
    unnest_tokens(word, text, token="ngrams",n=2 ) %>%
    count(word, sort=TRUE) %>% 
    separate(word, c("word1", "word2"), sep = " ") %>% 
    filter(!word1 %in% c(stopwords("es"),"q","d","t","cc","x","html","posted","just","online","streaming","false","na")) %>% 
    filter(!word2 %in% c(stopwords("es"),"q","d","t","cc","x","html","posted","just","online","streaming","false","na")) %>%
    filter(!str_detect(word1,"\\d+")) %>% 
    filter(!str_detect(word2,"\\d+")) %>% 
    unite(bigrama, word1, word2, sep = " ") %>%
    mutate(bigrama=reorder(bigrama,n)) %>% 
    ungroup()
  
  write.csv(data_bigrama, file = paste( carpeta,"Resultados_csv","DeterminantesSemanticos", "Bigrama","data_bigrama.csv",sep = "/"))
  write.xlsx(data_bigrama, file = paste( carpeta,"Resultados_excel","DeterminantesSemanticos", "Bigrama","data_bigrama.xlsx",sep = "/"))
  # --- COMUNIDADES --- #
  # --- REFERENTES 2.0---#
  referentes <- unlist(regmatches(aux$mentions_screen_name,gregexpr(pat3,aux$mentions_screen_name)))
  referentes <- as.data.frame(referentes)
  
  try(referentes <- sqldf("SELECT referentes Cuenta, count(referentes) Menciones 
                      FROM referentes
                      GROUP BY Cuenta
                      ORDER BY Menciones
                      DESC LIMIT 50"), silent = TRUE)
  
  try(write.csv(referentes, file = paste(carpeta,"Resultados_csv","Comunidad","Referentes","referentes.csv",sep = "/"),row.names=FALSE), silent = TRUE)
  try(write.xlsx(referentes, file = paste(carpeta,"Resultados_excel","Comunidad","Referentes","referentes.xlsx",sep = "/"),row.names=FALSE), silent = TRUE)
  
  # --- INFLUENCIADORES --- #
  try(influenciadores <- sqldf("SELECT retweet_screen_name 'Usuario_Retweeado',count(retweet_screen_name) Cantidad_Retweet 
                      FROM aux 
                      WHERE is_retweet 
                      GROUP BY retweet_screen_name 
                      ORDER BY COUNT(retweet_screen_name) DESC
                      LIMIT 20"), silent =TRUE)
  
  try(write.csv(influenciadores,file <- paste(carpeta,"Resultados_csv","Comunidad","Influenciadores","Influenciadores.csv",sep = "/"),row.names = FALSE), silent = TRUE)
  try(write.xlsx(influenciadores,file <- paste(carpeta,"Resultados_excel","Comunidad","Influenciadores","Influenciadores.xlsx",sep = "/"),row.names = FALSE), silent = TRUE)
  
  # --- MOVILIZADORES --- #
  #attempt(washrags <- str_to_lower(unlist(regmatches(aux$hashtags,gregexpr(pat3,aux$hashtags)))), msg = "Nope", verbose = TRUE)
  try(hashtags <- str_to_lower(unlist(regmatches(aux$hashtags,gregexpr(patref2,aux$hashtags)))))
  try(hashtags <- as.data.frame(hashtags))
  
  try(ranking_hashtags <- sqldf("SELECT hashtags Hashtag, count(hashtags) Cantidad 
                            FROM hashtags
                            GROUP BY Hashtag
                            ORDER BY Cantidad
                            DESC LIMIT 50"))
  
  try(cantidad_hashtag <- sqldf("SELECT count(hashtags) 'Porcentaje Hashtags'
                            FROM aux WHERE hashtags!=''"),silent = TRUE)
  try(porcentaje_hashtags <-round((cantidad_hashtag/total_filas)*100,2),silent = TRUE)
  
  tabla <- matrix(c(total_filas,cantidad_hashtag,porcentaje_hashtags,
                    'Total Filas','Total Hashtags','Porcentaje'), ncol = 2)
  colnames(tabla) <- c('Valores','Datos')
  tabla <- as.data.frame(tabla)
  
  # --- Grafico ranking Hashtag --- #
  I = try(ranking_hashtags$Hashtag, silent = TRUE)
  S = try(ranking_hashtags$Cantidad, silent = TRUE)
  
  try(imagen_hashtag <- plot_ly ( ranking_hashtags, y = c(S), x = c(I), type = "bar", name = "Ranking Hashtag")%>%
        layout(title ="Ranking de Hashtag", yaxis = list(title = 'Cantidad'), xaxis = list(title='Hashtag')), silent = TRUE)
  try(plotly_IMAGE(imagen_hashtag,format= "png",out_file= paste(carpeta,"Resultados_csv","Comunidad","Movilizadores","RankingHashtag.png",sep = "/")), silent = TRUE)
  try(plotly_IMAGE(imagen_hashtag,format= "png",out_file= paste(carpeta,"Resultados_excel","Comunidad","Movilizadores","RankingHashtag.png",sep = "/")), silent = TRUE)
  
  try(write.csv(porcentaje_hashtags, file = paste(carpeta,"Resultados_csv","Comunidad","Movilizadores","Porcentaje_ranking.csv",sep = "/"),row.names=FALSE), silent = TRUE)
  try(write.csv(ranking_hashtags, file <- paste(carpeta,"Resultados_csv","Comunidad","Movilizadores","ranking_hashtags.csv", sep = "/"), row.names = FALSE), silent = TRUE)
  try(write.xlsx(porcentaje_hashtags, file = paste(carpeta,"Resultados_excel","Comunidad","Movilizadores","Porcentaje_ranking.xlsx",sep = "/"),row.names=FALSE), silent = TRUE)
  try(write.xlsx(ranking_hashtags, file <- paste(carpeta,"Resultados_excel","Comunidad","Movilizadores","ranking_hashtags.xlsx", sep = "/"), row.names = FALSE), silent = TRUE)
  
  # --- MASIFICADORES --- #
  try(masificadores <- sqldf('SELECT distinct(screen_name) Cuenta, followers_count Cantidad_seguidores
                  FROM aux WHERE Cantidad_seguidores NOT LIKE "NA" 
                  GROUP BY Cuenta
                  ORDER BY Cantidad_seguidores DESC
                  LIMIT 20'),silent = TRUE)
  try(write.csv(masificadores,file = paste(carpeta,"Resultados_csv","Comunidad","Masificadores","Masificadores.csv",sep = "/"),row.names=FALSE), silent = TRUE)
  try(write.xlsx(masificadores,file = paste(carpeta,"Resultados_excel","Comunidad","Masificadores","Masificadores.xlsx",sep = "/"),row.names=FALSE), silent = TRUE)
  
  # --- ACTIVISTAS --- #
  try(activistas <-  sqldf('SELECT screen_name Twitero,count(screen_name) Cantidad 
                FROM aux WHERE is_retweet = 0 
                GROUP BY screen_name 
                ORDER BY count(screen_name) 
                desc'), silent = TRUE)
  try(write.csv(activistas, file = paste(carpeta,"Resultados_csv","Comunidad","Activistas","Activistas.csv",sep = "/"),row.names = FALSE),silent = TRUE)
  try(write.xlsx(activistas, file = paste(carpeta,"Resultados_excel","Comunidad","Activistas","Activistas.xlsx",sep = "/"),row.names = FALSE),silent = TRUE)
  
  # --- CONTENIDO MULTIMEDIA --- #
  try(cantidad_link <- sqldf("SELECT COUNT(urls_url) 'Porcentaje Links' FROM aux WHERE urls_url NOT LIKE ''"), silent = TRUE)
  
  try(ranking_url <- sqldf("SELECT urls_url Url, count(urls_url) Cantidad FROM aux
                  WHERE urls_url NOT LIKE ''
                  GROUP BY urls_url
                  ORDER BY cantidad DESC
                  LIMIT 5"), silent = TRUE)
  
  try(cantidad_fotos <-sqldf("SELECT count(media_type) 'Porcentaje Fotos' FROM aux WHERE  media_type != ''"), silent = TRUE)
  
  try(porcentaje_links <- round((cantidad_link/total_filas)*100,3), silent = TRUE)
  try(porcentaje_fotos <- round((cantidad_fotos/total_filas)*100,3), silent = TRUE)
  
  try(write.csv(ranking_url,file = paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Multimedia","RankingUrl.csv",sep = "/"),row.names = FALSE), silent = TRUE)
  try(write.csv(porcentaje_links, file=paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Multimedia","PorcentajeLink.csv",sep="/"),row.names = FALSE), silent = TRUE)
  try(write.csv(porcentaje_fotos, file=paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Multimedia","PorcentajeFotos.csv",sep="/"),row.names = FALSE), silent = TRUE)
  try(write.xlsx(ranking_url,file = paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Multimedia","RankingUrl.xlsx",sep = "/"),row.names = FALSE), silent = TRUE)
  try(write.xlsx(porcentaje_links, file=paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Multimedia","PorcentajeLink.xlsx",sep="/"),row.names = FALSE), silent = TRUE)
  try(write.xlsx(porcentaje_fotos, file=paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Multimedia","PorcentajeFotos.xlsx",sep="/"),row.names = FALSE), silent = TRUE)
  
  # --- Grafico Ranking URLS --- #
  ranking_url <- as.data.frame(ranking_url)
  N <- ranking_url$Url
  U <- ranking_url$Cantidad
  
  imagen_ranking <- plot_ly ( ranking_url, y = c(U),x = c(N), type = "bar", name = "Ranking URL")%>%
    layout(title ="Ranking de URL", yaxis = list(title = 'Urls'), xaxis = list(title='Cantidad'))
  
  try(plotly_IMAGE(imagen_ranking, format = "png", out_file = paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Multimedia","RankingUrl.png",sep = "/")),silent = TRUE)
  try(plotly_IMAGE(imagen_ranking, format = "png", out_file = paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Multimedia","RankingUrl.png",sep = "/")),silent = TRUE)
  
  # --- EFECTOS Y EXITOS --- #
  # --- CATEGORIZACION--- #
  # --- VALORACION --- #
  try(Valoracion <- sqldf("SELECT screen_name as Usuario,
                MAX(favorite_count) as Max_favoritos,
                MIN(favorite_count) as Min_favoritos,
                AVG(favorite_count) as Promedio FROM aux"), silent = TRUE)
  
  try(ValoracionTweet <- sqldf("SELECT  user_id as ID_usuario,
                      MAX(favorite_count) as Max_favoritos,
                      text as Tweet FROM aux"), silent = TRUE)
  
  try(ValoracionFinal <- sqldf("SELECT * FROM Valoracion, ValoracionTweet"), silent = TRUE)
  
  write.csv(ValoracionFinal, file = paste(carpeta,"Resultados_csv","Efectos","Valoracion","Valoracion.csv",sep="/" ),row.names = FALSE)
  write.xlsx(ValoracionFinal, file = paste(carpeta,"Resultados_excel","Efectos","Valoracion","Valoracion.xlsx",sep="/" ),row.names = FALSE)
  
  # --- MUESTRA ---#
  for(i in 1:length(nombres[,1])){
    
    muestra <- sqldf('SELECT "screen_name","user_id","status_id","text", "retweet_text","is_retweet"  FROM 	aux ')
    x <-sample(1:length(aux[,1]),1000, replace = TRUE)
    x <- as.data.frame(x)
    if(length(muestra[,1])>=1000)
    {
      muestra<-muestra[x[,1],]
      archivo_final_csv<- paste(carpeta,"Resultados_csv","Efectos", "Muestra", sep = "/")
      write.csv(muestra,file = paste(archivo_final_csv,nombres$nombres[i],sep = "/"),row.names = FALSE)
      archivo_final_xlsx<- paste(carpeta,"Resultados_excel","Efectos", "Muestra", sep = "/")
      write.xlsx(muestra,file = paste(archivo_final_xlsx,nombres$nombres[i],sep = "/"),row.names = FALSE)
    }else{
      muestra <- muestra[1:length(aux[,1]),]
      archivo_final_csv<- paste(carpeta,"Resultados_csv","Efectos", "Muestra", sep = "/")
      write.csv(muestra,file = paste(archivo_final_csv,nombres$nombres[i],sep = "/"),row.names = FALSE)
      archivo_final_xlsx<- paste(carpeta,"Resultados_excel","Efectos", "Muestra", sep = "/")
      write.xlsx(muestra,file = paste(archivo_final_xlsx,nombres$nombres[i],sep = "/"),row.names = FALSE)
    }
  }
  
  # --- CARACTERISTICAS TECNICAS --- #
  # ---  + - x Caracteres  --- #
  try(cantidadCaracteres <-  sqldf("SELECT max(display_text_width) as Max_caracteres,
                        min(display_text_width) as Min_caracteres, 
                        avg(display_text_width) as Promedio FROM aux"), silent = TRUE)
  
  write.csv(cantidadCaracteres, file = paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Caracteres","CantidadCaracteres.csv",sep="/"),row.names = FALSE)
  write.xlsx(cantidadCaracteres, file = paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Caracteres","CantidadCaracteres.xlsx",sep="/"),row.names = FALSE)
  
  # --- CONTENIDOS MULTIMEDIA --- #
  # --- CATEGORIZACION POR DISPOSITIVOS --- #
  consulta_dispositivos <- "SELECT COUNT(source) Total FROM aux"
  try(dispositivos <- sqldf(consulta_dispositivos), silent = TRUE)
  
  dispositivos_android <- "SELECT COUNT(source) Androids FROM aux WHERE source LIKE '%Android'"
  try(androids <- sqldf(dispositivos_android), silent = TRUE)
  
  consulta_iphone <- "SELECT COUNT(source) Iphone FROM aux WHERE source LIKE '%iPhone'"
  try(iphone <- sqldf(consulta_iphone), silent = TRUE)
  
  consulta_web <- "SELECT COUNT(source) Web FROM aux WHERE source LIKE '%Web%'"
  try(web <- sqldf(consulta_web), silent=TRUE)
  
  consulta_otros <- "SELECT COUNT(source) Otros FROM aux WHERE source NOT LIKE '%Android' AND source NOT LIKE '%iPhone' AND source NOT LIKE '%Web%'"
  try(otros <- sqldf(consulta_otros), silent = TRUE)
  
  consulta_union <- "SELECT * FROM androids, iphone, web, otros, dispositivos"
  try(consulta_union <- sqldf(consulta_union), silent = TRUE)
  try(todos <- consulta_union, silent = TRUE)
  
  try(write.csv(consulta_union, file = paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Dispositivos","ConsultaUnionDispositivos.csv",sep = "/"),row.names = FALSE), silent = TRUE)
  try(write.xlsx(consulta_union, file = paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Dispositivos","ConsultaUnionDispositivos.xlsx",sep = "/"),row.names = FALSE), silent = TRUE)
  
  A = try(todos$Androids, silent = TRUE)
  I = try(todos$Iphone, silent = TRUE)
  W = try(todos$Web, silent = TRUE)
  O = try(todos$Otros, silent = TRUE)
  TT= try(todos$Total, silent = TRUE)
  
  porcentaje = matrix(c(trunc((A/TT)*100*10^2)/10^2,trunc((I/TT)*100*10^2)/10^2,trunc((W/TT)*100*10^2)/10^2,trunc((O/TT)*100*10^2)/10^2,'Android','Iphone','Web','Otros'),ncol = 2)
  colnames(porcentaje) = c('Porcentaje','Dispositivos')
  porcentaje = as.data.frame(porcentaje)
  
  data <- porcentaje[,c('Dispositivos', 'Porcentaje')]
  
  p <- plot_ly(data, labels = ~Dispositivos, values = ~Porcentaje, type = 'pie') %>%
    layout(title = 'Porcentaje de Dispositivos',
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
  try(plotly_IMAGE(p, format = "png", out_file = paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","Dispositivos","PorcentajeDispositivos.png",sep = "/")), silent = TRUE)
  try(plotly_IMAGE(p, format = "png", out_file = paste(carpeta,"Resultados_csv","PorcentajeDispositivosA.png", sep = "/")), silent = TRUE)
  try(plotly_IMAGE(p, format = "png", out_file = paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","Dispositivos","PorcentajeDispositivos.png",sep = "/")), silent = TRUE)
  try(plotly_IMAGE(p, format = "png", out_file = paste(carpeta,"Resultados_excel","PorcentajeDispositivosA.png", sep = "/")), silent = TRUE)
  
  # --- Georeferencia --- #
  try(georeferencia <- sqldf("SELECT count(distinct(location)) 'Porcentaje georeferencia' FROM aux"),silent = TRUE)
  
  # ---  Ranking de los 5 lugares mas mencionados --- #
  #Localizacion dentro del Tweet
  try(ranking_paises <- sqldf("SELECT count(country) Cantidad, place_full_name as Lugar,
                    place_type 'Tipo de lugar', country Paises, country_code 'Codigo Pais'
                    FROM aux WHERE Paises NOT LIKE ''
                    GROUP BY Paises 
                    ORDER BY Cantidad DESC
                    LIMIT 10"))
  
  try(porcentaje_georeferencia <- round((georeferencia/total_filas)*100,2),silent = TRUE)
  
  # --- Grafico Ranking por paises --- #
  try(ranking_paises <- as.data.frame(ranking_paises), silent = TRUE)
  
  P = ranking_paises$Paises
  C = ranking_paises$Cantidad
  
  p <- plot_ly ( ranking_paises, y = c(C),x = c(P), type = "bar", name = "Ranking Paises")%>%
    layout(title ="Ranking de paises", yaxis = list(title = 'Cantidad'), xaxis = list(title='Paises'))
  
  #Ruta de salida de la imagen
  try(plotly_IMAGE(p, format = "png", out_file = paste(carpeta, "Resultados_csv","CaracteristicasTecnicas","RankingGeoreferencia","RankingPaises.png", sep = "/")), silent = TRUE)
  try(plotly_IMAGE(p, format = "png", out_file = paste(carpeta, "Resultados_excel","CaracteristicasTecnicas","RankingGeoreferencia","RankingPaises.png", sep = "/")), silent = TRUE)
  
  try(write.csv(porcentaje_georeferencia , file = paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","PorcentajeGeoreferencia","PorcentajeGeo.csv",sep = "/"),row.names = FALSE),silent = TRUE)
  try(write.csv(ranking_paises, file = paste(carpeta,"Resultados_csv","CaracteristicasTecnicas","RankingGeoreferencia","RankingPaises.csv",sep="/" ),row.names = FALSE),silent = TRUE)
  try(write.xlsx(porcentaje_georeferencia , file = paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","PorcentajeGeoreferencia","PorcentajeGeo.xlsx",sep = "/"),row.names = FALSE),silent = TRUE)
  try(write.xlsx(ranking_paises, file = paste(carpeta,"Resultados_excel","CaracteristicasTecnicas","RankingGeoreferencia","RankingPaises.xlsx",sep="/" ),row.names = FALSE),silent = TRUE)
  
  #---Categorizacion por genero---#
  try(genero <- sqldf("SELECT sexo Sexo, count (sexo) Cantidad 
            FROM aux
            WHERE sexo = 'f' OR sexo = 'm' OR sexo ='na'
            GROUP BY sexo
            ORDER BY Cantidad DESC"),silent = TRUE)
  
  
  try(na <- sqldf("SELECT count(sexo) as NA FROM aux WHERE sexo LIKE 'na'"),silent = TRUE)
  
  try(f <- sqldf("SELECT count(sexo) as F FROM aux WHERE sexo LIKE 'f' "),silent = TRUE)
  
  try(m <- sqldf("SELECT count(sexo) as M FROM aux WHERE sexo LIKE 'm' "),silent = TRUE)
  
  try(porcentaje_na <- round((na/total_filas)*100,3),silent = TRUE)
  try(porcentaje_f <- round((f/total_filas)*100,3),silent = TRUE)
  try(porcentaje_m <- round((m/total_filas)*100,3),silent = TRUE)
  
  try(union_sexo <- "SELECT * FROM porcentaje_na, porcentaje_f, porcentaje_m",silent = TRUE)
  try(union_sexo <- sqldf(union_sexo), silent = TRUE)
  
  try(write.csv(genero,file = paste(carpeta,"Resultados_csv","Comunidad","CategorizarSexo","Genero.csv",sep = "/"),row.names=FALSE), silent = TRUE)
  try(write.csv(union_sexo,file = paste(carpeta,"Resultados_csv","Comunidad","CategorizarSexo","UnionSexo.csv",sep = "/"),row.names=FALSE), silent = TRUE)
  try(write.xlsx(genero,file = paste(carpeta,"Resultados_excel","Comunidad","CategorizarSexo","Genero.xlsx",sep = "/"),row.names=FALSE), silent = TRUE)
  try(write.xlsx(union_sexo,file = paste(carpeta,"Resultados_excel","Comunidad","CategorizarSexo","UnionSexo.xlsx",sep = "/"),row.names=FALSE), silent = TRUE)
  
  i = i + 1
  
}
