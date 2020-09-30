#NÃO CONCLUÍDO

library(fbRads)

token <- 'EAAH7nH6l8QoBACOTVqmUq3c196uct1LZAmBnNSNIzNNH87AQYwcizMMiuAv0mXfZBdReCsZAQj8gkDkGfwQDSfaNfyWInZBdpFhIaKZA8kZCBVdsxFIGWZBbJZBH4jnyu9lptt7lMz8VfxU6ZB1eZBZCLPZCZB7irNSJUduB5FZAljrxwFrAZDZD'
account_asian <- 691386851276955
accounts <- fbad_get_adaccount_details(account_asian,token, version = '3.1')
#Krows Token = EAAH7nH6l8QoBACOTVqmUq3c196uct1LZAmBnNSNIzNNH87AQYwcizMMiuAv0mXfZBdReCsZAQj8gkDkGfwQDSfaNfyWInZBdpFhIaKZA8kZCBVdsxFIGWZBbJZBH4jnyu9lptt7lMz8VfxU6ZB1eZBZCLPZCZB7irNSJUduB5FZAljrxwFrAZDZD
reports()
report_ads <- metrics(report='CAMPAIGN_PERFORMANCE_REPORT')
campaign_performance <-statement(select=c('CityCriteriaId',
                                          'RegionCriteriaId',
                                          'CountryCriteriaId',
                                          'Date',
                                          'CampaignName',
                                          'Cost',
                                          'Clicks',
                                          'Impressions'),
                                 report="GEO_PERFORMANCE_REPORT",
                                 start="2019-12-10",
                                 end="2019-12-10")

data <- getData(clientCustomerId='561-479-8106',
                google_auth=google_auth,
                statement=campaign_performance)

View(data)