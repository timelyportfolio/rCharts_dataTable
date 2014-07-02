---
title: Test iframe Sizing ( rCharts Issue #464 )
author:  TimelyPortfolio
framework: bootstrap
---

# Example 1 with iframe Sizing but Potentially Bad Behavior

Notice that iframe sizes properly according to the `height` and `width` from `dt`.  However, since scrolling behavior is not turned on with `datatables` if we toggle `Show`, we might experience some bad behavior.


```r
require(rCharts);require(knitr)

iris_sc <- iris
#randomly make these numbers exponentially large to be able to visually verify result
iris_sc[,-5] <- format(iris_sc[,-5]*10^runif(nrow(iris),1,10),scientific=T)

dt <- dTable(
  iris_sc[sample(1:nrow(iris_sc),50),]
)
#add the scientific sort from http://next.datatables.net/plug-ins/sorting/scientific
#easier to add in script than to add to jshead
dt$setTemplate(chartDiv = sprintf('%s
<script>
  %s
</script>
',
dt$templates$chartDiv,
'jQuery.extend( jQuery.fn.dataTableExt.oSort, {
  "scientific-pre": function ( a ) {
    return parseFloat(a);
  },

  "scientific-asc": function ( a, b ) {
    return ((a < b) ? -1 : ((a > b) ? 1 : 0));
  },

  "scientific-desc": function ( a, b ) {
    return ((a < b) ? 1 : ((a > b) ? -1 : 0));
}
} );
'
))
#hack with lapply; I think there is a better way to do
#but this sets type to scientific for all columns
#except the last which is species
dt$params$table$aoColumns[-ncol(iris_sc)] <- lapply(
  dt$params$table$aoColumns[-ncol(iris_sc)],
  function(x){
    x$sType = "scientific"
    return(x)
  }
)
```

---

```r
dt$show("iframe")
```

<iframe src='assets/fig/unnamed-chunk-2.html' scrolling='no' frameBorder='0' seamless class='rChart datatables ' id='iframe-chart5043fc21e33' height=450 width=850></iframe>

---
# Using Datatables scrolling for a Better Result

Fortunately, `datatables` provides us very nice scrolling behavior builtin.  I was glad to find [this old example](http://rcharts.io/viewer/?6033232).  I also provided links in the code comments to the `datatables` documentation.



```r
dt$addParams(
  height = 200,
  table = list(
    bScrollInfinite = T,  #http://datatables.net/examples/basic_init/scroll_y_infinite.html
    bScrollCollapse = T,  #http://datatables.net/reference/option/scrollCollapse
	  sScrollY = "190px" #http://datatables.net/reference/option/scrollY
  )
)
dt$show("iframe")
```

<iframe src='assets/fig/unnamed-chunk-3.html' scrolling='no' frameBorder='0' seamless class='rChart datatables ' id='iframe-chart5043fc21e33' height=250 width=850></iframe>

---


```r
dt$addParams(
  width = 400,
  table = list(
    sScrollX = "390px"
  )
)
dt$show("iframe")
```

<iframe src='assets/fig/unnamed-chunk-4.html' scrolling='no' frameBorder='0' seamless class='rChart datatables ' id='iframe-chart5043fc21e33' height=250 width=450></iframe>
