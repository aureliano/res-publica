function cleanTextField(id) {
  $("#" + id).val('');
  $("#" + id).focus();
}

function propSearchValidation() {
  return ($("#prop_tags").val() != '');
}
