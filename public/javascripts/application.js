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

function loadDespesas(deputado, year, month) {
  var field_id = "input#mes_" + month + "_carregado";
  var loaded = $(field_id).val();
  
  if (loaded == 'false') {
    $('#loading').show();
    var url = 'http://' + location.host + '/organizacional/deputado/' + deputado + '/despesas/' + year + '/' + month;
    $.getJSON(url, function(data) {
      $('#sumario_despesas_' + month).append('<span><strong>Documentos emitidos: </strong></span>' + data['total_documentos'] + '<span></span><br/>');
      $('#sumario_despesas_' + month).append('<span><strong>Total glosa: </strong></span><span>' + data['total_glosa'] + '</span><br/>');
      $('#sumario_despesas_' + month).append('<span><strong>Total líquido: </strong></span><span>' + data['total_liquido'] + '</span><br/>');
      $('#sumario_despesas_' + month).append('<span><strong>Total bruto: </strong></span><span>' + data['total_bruto'] + '</span><br/>');
      
      for (i = 0; i < data['despesas'].length; i++) {
        var row = data['despesas'][i];
        var html = '<div>';
        
        html += '<span><strong>Descrição do documento: </strong></span><span>' + row['descricao'] + '</span><br/>';
        html += '<span><strong>Beneficiário: </strong></span><span>' + row['beneficiario'] + '</span><br/>';
        html += '<span><strong>Identificação: </strong></span><span>' + row['identificacao'] + '</span><br/>';
        html += '<span><strong>Data da emissão: </strong></span><span>' + row['data_emissao'] + '</span><br/>';
        html += '<span><strong>Valor da glosa: </strong></span><span>' + row['valor_glosa'] + '</span><br/>';
        html += '<span><strong>Valor líquido: </strong></span><span>' + row['valor_liquido'] + '</span><br/>';
        html += '<span><strong>Valor bruto: </strong></span><span>' + row['valor_bruto'] + '</span><br/>';
        html += '</div><br/>';
        
        $('div#extrato_' + month).append(html);
      }
      
      $(field_id).val('true');
    }).done(function() { $('#loading').hide(); }).error(function(jqXHR, textStatus, errorThrown) { alert('Não foi possível carregar as despesas. Tente acessar esta página novamente mais tarde. ' + errorThrown) });
  }
}
