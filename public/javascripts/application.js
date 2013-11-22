function cleanTextField(id) {
  $("#" + id).val('');
  $("#" + id).focus();
}

function propSearchValidation() {
  return ($("#prop_tags").val() != '');
}

function hideApiResponse() {
  document.getElementById('div_api_response').style.display = 'none';
}
