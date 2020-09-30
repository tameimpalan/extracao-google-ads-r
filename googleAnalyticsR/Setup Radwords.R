####Dados de Conexão do Google - RASCUNHO
####Client ID - REGISTRE AQUI SEU CLIENT ID
####Client Secret - REGISTRE AQUI SEU CLIENT SECRET
####Dev Token - REGISTRE AQUI SEU DEV TOKEN


#Declara variável com a data de ontem e aumenta o limite de memória do Java.
yesterday <- format(Sys.Date()-1,"%Y-%m-%d")
options(java.parameters="-XX:-UseGCOverheadLimit")



#Gera a autenticação do Google
library(RAdwords)
google_auth <- doAuth()


#Gera o Report do Adwords na estrutura atual
report_ads <- metrics(report='CAMPAIGN_PERFORMANCE_REPORT')
campaign_performance <-statement(select=c(
  'CityCriteriaId',
  'RegionCriteriaId',
  'CountryCriteriaId',
  'Date',
  'CampaignName',
  'Cost',
  'Clicks',
  'Impressions'),
  report="GEO_PERFORMANCE_REPORT",
  start="2019-12-10",
  end=yesterday
)
ga_data <- getData(clientCustomerId='CODIGO_DA_CONTA_ADS',google_auth=google_auth,statement=campaign_performance)


#Renomeia as colunas do Report
colnames(ga_data)[1] <- "CD_CIDADE"
colnames(ga_data)[2] <- "CD_ESTADO"
colnames(ga_data)[3] <- "CD_PAIS"
colnames(ga_data)[4] <- "DT_DATA"
colnames(ga_data)[5] <- "NM_CAMPANHA"
colnames(ga_data)[6] <- "VL_VALOR"
colnames(ga_data)[7] <- "QT_CLIQUES"
colnames(ga_data)[8] <- "QT_IMPRESSOES"


#Lê a base de geotargets
library(XLConnect)
wb <- loadWorkbook("geotargets-2020-09-08.xlsx")
geotargets <- readWorksheet(wb, sheet = "Main", header = TRUE)


#Left join para trazer o nome da cidade
library(dplyr)
geotargets <- select(geotargets, CD_CODIGO, NM_NOME)
geotargets[1] <- lapply(geotargets[1], as.character)
ga_data <- left_join(ga_data, geotargets, by = c("CD_CIDADE" = "CD_CODIGO"))
colnames(ga_data)[ncol(ga_data)] <- "NM_CIDADE"
ga_data <- left_join(ga_data, geotargets, by = c("CD_ESTADO" = "CD_CODIGO"))
colnames(ga_data)[ncol(ga_data)] <- "NM_ESTADO"
ga_data <- left_join(ga_data, geotargets, by = c("CD_PAIS" = "CD_CODIGO"))
colnames(ga_data)[ncol(ga_data)] <- "NM_PAIS"
ga_data <- ga_data[, c(1, 9, 2, 10, 3, 11, 4, 5, 6, 7, 8)]

ga_data[1] <- lapply(ga_data[1], as.numeric)
ga_data[3] <- lapply(ga_data[3], as.numeric)
ga_data[5] <- lapply(ga_data[5], as.numeric)

#Gera a conexão com o banco p/ INSERT.
library(RODBC)
connection <- odbcConnect(dsn='lyceum_H1',uid='USUARIO_DO_BANCO',pwd='SENHA_DO_BD')
sqlSave(connection, ga_data, tablename = 'NOME_TABELA_BANCO', rownames = F, append = T, fast = T, varTypes = c(
    CD_CIDADE="int null",
    NM_CIDADE="varchar (255) null",
    CD_ESTADO="int",
    NM_ESTADO="varchar (255) null",
    CD_PAIS="int",
    NM_PAIS="varchar (255) null",
    DT_DATA="date",
    NM_CAMPANHA="varchar (255)",
    VL_VALOR="numeric(14, 2)",
    QT_CLIQUES="int",
    QT_IMPRESSOES="int"
  )
)
