library(shiny)
library(dplyr)

# To Change for New Data:
# --Top level Table
# --Drill down Table
# --Filtering column in ajax_url
# --renderDataTable data as usual

shinyServer(function(input, output, session) {
  # extra plus dummy column
  dat <- data.frame(sex = c(rep(1, 1), rep(2, 1)),
                     treatment = rep(c(1, 2), 1),
                     response1 = rnorm(2, 0, 1),
                     response2 = rnorm(2, 0, 1))
  dat$sex <- ifelse(dat$sex == 1, "Male", "Female")
  
  tst <- cbind(' ' = '+', plyr::ddply(dat, "sex", summarise, sum=response1+response2))  # Top level table
  tst.detail <- dplyr::select(dat, sex, response1, response2)  # Drill down table
  
  
  draw.callback <- "
  function(settings) {
    var api = this.api();
    var callback = (function($api) {
    return function() {
    var tr = $(this).parent();
    var row = $api.row(tr);
    if (row.child.isShown()) {
      row.child.hide();
      tr.removeClass('shown');
      }
    else {
      // we can use the unique ajax request URL to get the extra information.
      $.ajax(_ajax_url, {
      data: {name: row.data()[1]},
      success: function(res) { 
      row.child(format(res)).show(); 
      tr.addClass('shown');
      }
      });
      }
      }
    })(api);
  
  $(this).on('click', 'td.details-control', callback);
  }"

    ajax_url <- session$registerDataObj(
      name = "detail_ajax_handler", # an arbitrary name for the AJAX request handler
      data = tst.detail,  # binds your data
      filter = function(data, req) {
        query <- parseQueryString(req$QUERY_STRING)
        name <- query$name

        # pack data into JSON and send.
        shiny:::httpResponse(
          200, "application/json", 
          # use as.list to convert a single row into a JSON Plain Object, easier to parse at client side
          RJSONIO:::toJSON(as.list(data[data[,"sex"] == name, ]))  # Change filtering column
        )        
      }
    )

    # send this UNIQUE ajax request URL to client
    session$sendInputMessage("ajax_req_url", list(value=ajax_url))

    output$dt <- renderDataTable(tst,  # Change for new data source
        options=list(
            searching=F,
            columnDefs=list(
                            list(targets=0,
                                 title="", class="details-control")
                         ),
            drawCallback=I(draw.callback)
    ))
})