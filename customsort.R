library(gdata)
library(rCharts)
library(knitr)
v1=as.factor(rep(c("level1","level2"),50))
v1=as.data.frame(v1)
v2=as.factor(rep(c("levelA","levelB","levelC"),100))
v2=as.data.frame(v2)             
v1v2=cbindX(v1,v2)
tab=dTable(v1v2, sPaginationType = "full_numbers")
tab$templates$script = "http://timelyportfolio.github.io/rCharts_dataTable/chart_customsort.html"
tab$params$table$aoColumns =
    list(
      list(sType = "string_ignore_null", sTitle = "v1"),
      list(sTitle = "v2")
    )
tab
