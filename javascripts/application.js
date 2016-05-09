$(document).ready(function() {
  var submitForm = function() {
    var postcode = $('#postcode').val().trim();
    if (postcode.match(/^\d\d\d\d$/)) {
      window.location.href = "/postcodes/" + postcode + ".html"
    } else {
      window.alert("Are you sure that's a valid postcode? It should be four digits (eg: 3070).");
    }

    return false;
  };

  $('#postcode-form').on('submit', submitForm);
  $('#go').on('click', submitForm);
});
