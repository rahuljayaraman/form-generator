// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-datepicker
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap
//= require jquery.ui.all
//= require ui.multiselect.js
//= require jquery_nested_form
//= require_tree .

$(document).ready(function(){
  $(".multiselect").multiselect();
  $(".range").hide();

  //Toggle Show validations for sources/edit
  $("#show_validation").live("click", function() {
    var element = $(this).parent('div').find('#validation_fieldset:first')
    element.toggle();
    var val = element.find("select.v_dropdown").val();
    if(val == "Length") {
      element.find('.range').show();
    }
  });

  //Toggle show validation options
  $("select.v_dropdown").live("click", function() {
    $(".range").hide();
    var value = $(this).val();
    switch(value) {
      case "Length":
        $(this).parent("div").find('.range').show();
        break;
    }
  });
  $('#datatables').dataTable({
    "sDom": "<'row-fluid'<'span6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap",
    "aaSorting": [[ 1, "desc" ]]
  });
});
