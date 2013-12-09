# encoding: utf-8

require 'spec_helper'

describe "ProposicaoController" do

  it 'carrega página inicial do módulo proposições' do
    get '/proposicao'
    
    last_response.body.should include '<h2>Res Publica</h2>'
    last_response.body.should include '<h3>Consulta de Proposições</h3>'
    last_response.body.should include '<input type="text" id="prop_tags" name="prop_tags" value="" style="height: 28px; width: 500px;" autofocus/>'
    last_response.body.should include '<button type="submit" class="btn" style="width: 90px;" onclick="return propSearchValidation();">Consultar</button>'
    last_response.body.should include '<button type="button" class="btn" style="width: 90px;" onclick="cleanTextField(\'prop_tags\');">Limpar</button>'
  end
  
  it 'carrega página de detalhamento de proposição' do
    Proposicao.delete_all
    proposicao = Proposicao.create(:_id => 123, :nome => 'PL 123/2013', :sigla => 'PL', :numero => 123, :autor => 'Brother')
    
    get "/proposicao/#{proposicao.id}"
    
    last_response.body.should include '<h3>Proposição - PL 123/2013</h3>'
    last_response.body.should include '<h4>Dados da Proposição</h4>'
    last_response.body.should include '<span><strong>Nome: </strong></span><span>PL 123/2013</span>'
    last_response.body.should include '<span><strong>Tipo: </strong></span><span>PL - Projeto de Lei</span>'
    last_response.body.should include '<span><strong>Número: </strong></span><span>123</span>'
  end
  
end
