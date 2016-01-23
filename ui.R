library(shiny)

# To Change for New Data:
# --Formatting in table
# --Column calls in table

format.func <- "
<script type='text/javascript'>
var _ajax_url = null;

function format ( d ) {
  // `d` is the original data object for the row
  return '<table cellpadding=\"5\" cellspacing=\"0\" border=\"0\" style=\"padding-left:50px;\">'+
    '<tr>'+
    '<td>Sex:</td>'+
    '<td>'+d.sex+'</td>'+
    '</tr>'+
    '<tr>'+
    '<td>Response 1:</td>'+
    '<td>'+d.response1+'</td>'+
    '</tr>'+
    '<tr>'+
    '<td>Response 2:</td>'+
    '<td>'+d.response2+'</td>'+
    '</tr>'+
  '</table>';
}

$(document).ready(function() {
  $('#ajax_req_url').on('change', function() { _ajax_url = $(this).val()});
})
</script>
"

shinyUI(
    fluidPage(
        # create a hidden input element to receive AJAX request URL
        tags$input(id="ajax_req_url", type="text", value="", class="shiny-bound-input", style="display:none;"),  # Probably need one for each table

        h5("Data table"),
        dataTableOutput("dt"),
        tags$head(HTML(format.func))
    ) 
)