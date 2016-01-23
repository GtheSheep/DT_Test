# DT_Test
DT Package Testing

Shiny App for testing JS/HTML/Ajax with DT package, manipulating functions found online, or developed in order to produce experimental results.  
For now, the app will be hosted at: https://gjames.shinyapps.io/DT_Test/

## Part 1 - Expandable Rows
Initially we test child rows in Ajax to see how it behaves with a dplyr created data.frame, essentially uses callback to create a new table under each row based on the value within the first column.  
Source of base code: http://stackoverflow.com/questions/23635552/shiny-datatable-with-child-rows-using-ajax