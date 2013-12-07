# encoding: utf-8

require 'spec_helper'

describe "OrganizacionalController" do

  it 'carrega página inicial do módulo organizacional' do
    get '/organizacional'
    
    last_response.body.should include '<h2>Res Publica</h2>'
    last_response.body.should include '<h3>Dados organizacionais</h3>'
    last_response.body.should include '<p class="lead">'
    last_response.body.should include 'Conheça a estrutura organizacional da Câmara e seus agentes.'
    last_response.body.should include '<h4>Partidos Políticos</h4>'
    last_response.body.should include '<h4>Bancadas</h4>'
    last_response.body.should include '<h4>Comissões</h4>'
    last_response.body.should include '<h4>Deputados</h4>'
  end
  
  it 'carrega página de detalhamento de partido' do
    Partido.delete_all
    Partido.create :numero => 171, :_id => 'PCREU', :nome => 'Partido Créu'
    
    get '/organizacional/partido/PCREU'
    
    last_response.body.should include '<title>Res Publica: Partido Político</title>'
    last_response.body.should include '<h3>PCREU - Partido Créu</h3>'
    last_response.body.should include '<span><strong>Número: </strong></span><span>171</span>'
    last_response.body.should include '<span><strong>Legenda: </strong></span><span>PCREU</span>'
    last_response.body.should include '<span><strong>Nome: </strong></span><span>Partido Créu</span>'
  end

  it "carrega página com lista de partido políticos" do
    get '/organizacional/partidos'
    
    last_response.body.should include '<title>Res Publica: Partidos Políticos</title>'
    last_response.body.should include '<form method="get" id="form_consulta" action="/organizacional/partidos" protect_from_csrf="true" accept-charset="UTF-8">'
  end
  
  it 'carrega página com lista de bancadas' do
    get '/organizacional/bancadas'

    last_response.body.should include '<title>Res Publica: Bancadas Parlamentares</title>'
    last_response.body.should include '<h3>Bancadas Parlamentares</h3>'
  end
  
  it 'carrega página de detalhamento de bancada' do
    Bancada.delete_all
    bancada = Bancada.create(:_id => 'CREU', :nome => 'C R E U', :vice_lideres => [])

    get "/organizacional/bancada/#{bancada.id}"
    
    last_response.body.should include '<title>Res Publica: Bancada Parlamentar</title>'
    last_response.body.should include '<h3>Bancada Parlamentar - CREU</h3>'
    last_response.body.should include '<span><strong>Sigla: </strong></span><span>CREU</span>'
    last_response.body.should include '<span><strong>Nome: </strong></span><span>C R E U</span>'
  end
  
  it 'carrega página com lista de comissões' do
    get '/organizacional/comissoes'

    last_response.body.should include '<title>Res Publica: Comissões Parlamentares</title>'
    last_response.body.should include '<h3>Comissões Parlamentares</h3>'
  end
  
  it 'carrega página de detalhamento de comissão' do
    Comissao.delete_all
    comissao = Comissao.create(:_id => 'CREU', :nome => 'C R E U')

    get "/organizacional/comissao/#{comissao.id}"
    
    last_response.body.should include '<title>Res Publica: Comissão Parlamentar</title>'
    last_response.body.should include '<h3>Comissão Parlamentar - CREU</h3>'
    last_response.body.should include '<span><strong>Sigla: </strong></span><span>CREU</span>'
    last_response.body.should include '<span><strong>Nome: </strong></span><span>C R E U</span>'
  end
  
  it 'carrega página com lista de deputados' do
    get '/organizacional/deputados'

    last_response.body.should include '<title>Res Publica: Deputados Federais</title>'
    last_response.body.should include '<h3>Deputados Federais </h3>'
  end
  
  it 'carrega página de detalhamento de deputado' do
    Partido.delete_all
    partido = Partido.create(:numero => 171, :_id => 'PCREU', :nome => 'Partido Créu')
    
    Deputado.delete_all
    deputado = Deputado.create(:_id => 12345, :partido => partido.nome, :nome => 'Carloz Ray Norris',
                :nome_parlamentar => 'Brother', :periodos_exercicio => [],
                :filiacoes_partidarias => [], :sexo => 'masculino')

    get "/organizacional/deputado/#{deputado.id}"
    
    last_response.body.should include '<title>Res Publica: Deputado Federal</title>'
    last_response.body.should include '<h3>Deputado Federal - Brother</h3>'
    last_response.body.should include '<span><strong>Nome parlamentar: </strong></span><span>Brother</span>'
    last_response.body.should include '<span><strong>Nome completo: </strong></span><span>Carloz Ray Norris</span>'
  end
  
end
