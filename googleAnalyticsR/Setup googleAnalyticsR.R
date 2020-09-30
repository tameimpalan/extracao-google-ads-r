#NÃO CONCLUÍDO

library(googleAnalyticsR)

ga_auth()

my_accounts <- ga_account_list()
View(my_accounts)

ga_id <- CODIGO_DA_CONTA_GA

start_date <- "today"
end_date <- "today"

report_ga <- google_analytics(ga_id,
                                 date_range = c(start_date, end_date),
                                 metrics = sum(c("adCost")),
                                 dimensions = c("region","campaign"))

View(report_ga)