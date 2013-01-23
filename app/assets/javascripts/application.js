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
//= require jquery.ui.sortable
//= require jquery_nested_form
//= require_tree .


$(document).ready(function(){
  $(".datepicker").datepicker({
    format: 'yyyy-mm-dd',
    autoclose: true
  });
  $("a.show_example").click(function(){
   $("p.example").fadeToggle("fast"); 
   var text = $(this).text();
   if(text == "Show Example"){
     $(this).text("Hide Example");
   }
   else {
     $(this).text("Show Example");
   }
  });

  $("#selected_items").sortable({
    axis: 'y',
    stop: function(event, ui) {
      var sorting = $(this).sortable("toArray");
      setPosition(sorting);
    }
  });
  var setPosition = function(sorting) {
    $(".checkboxes").each(function(index) {
       var position = index + 1;
       $(this).append("<input class='hidden' id='form_priority' name='[form][form_attributes_attributes][" + sorting[index] + "][priority]' type='hidden' value='" + position + "'>");
    });
  };

  $("body").on("click",".unselected", listenUnselected);

  function listenUnselected(e) {
    e.preventDefault();
    $(this).fadeOut("slow").remove();
    addElement($(this));
  };

  $("body").on("click", ".remove", listenSelected)

  function listenSelected(e) {
    e.preventDefault();
    var element = $(this).parent("div");
    element.fadeOut("slow").remove();
    removeElement(element);
  };

  // Do not allow multiple associated products to be added
  function linksLogic() {
    $("#unselected_items").find("a").each(function(){
      var source = $(this).attr('data_source');
      var query = "[data_source='" + source + "']";
      var count = $("body").find(query).length;
      var innercount = $("#unselected_items").find(query).length;
      var data_type = $(this).attr('data_type');

      if(innercount < count && data_type != "normal") {
        //Disable this
        $(this).hide();
      }
      else if(innercount == count && data_type != "normal") {
        //Enable this
        $(this).show();
      }
    });
  };
  linksLogic();


  var removeElement = function(element) {
    var newElement = "<a href='#' class='icon-arrow-left unselected' data_type='" + element.attr('data_type') + "' id='" + element.attr('id') + "' data_source='" + element.attr('data_source') + "'> " + element.find('a:first').text().trim() +"</a>";
    if(element.attr('data_type').trim() == "normal") {
      $(".normal").append(newElement);
    }
    else if(element.attr('data_type').trim() == "many") {
      $(".many").append(newElement);
    }
    else {
      $(".embedded").append(newElement);
    }
    linksLogic();
  };

  var addElement = function(element) {
    var position = fetchPosition() + 1;
    var value = "<small class='muted'><b>[drag]</b></small><a href='#' class='' id='" + element.text().trim() + "'>  " + element.text().trim() +"&nbsp;&nbsp;</a>" + "<a href='#' class='icon-remove muted remove'><small> remove </small></a>";
    var hiddenPosition = "<input class='hidden' id='form_priority' name='[form][form_attributes_attributes][" + element.attr("id") + "][priority]' type='hidden' value='" + position + "'>";
    var hiddenSource = "<input class='hidden' id='form_source' name='[form][form_attributes_attributes][" + element.attr("id") + "][source_attribute_id]' type='hidden' value='" + element.attr("id") + "'>";
    var hiddenRelationship = "<input class='hidden' id='form_source' name='[form][form_attributes_attributes][" + element.attr("id") + "][relationship]' type='hidden' value='" + element.attr("data_type") + "'>";
    var openTag = "<div class='checkboxes' id='" + element.attr("id") + "' data_type='" + element.attr('data_type') + "' data_source='" + element.attr('data_source') + "'>";
    var closeTag = "</div>";
    var newElement = openTag + value + hiddenPosition + hiddenSource + hiddenRelationship + closeTag;
    $("#selected_items").append(newElement);
    linksLogic();
  };

  var fetchPosition = function() {
    var length = $("#selected_items").find("li.checkboxes").length;
    return length;
  };
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
