# encoding: utf-8

require 'spec_helper'

describe "AppController" do

  it 'carrega página inicial' do
    get '/'
    
    last_response.body.should include '<title>Res Publica: Início</title>'
    last_response.body.should include '<div class="pagination-centered">'
    last_response.body.should include '<h2>Res Publica</h2>'
    last_response.body.should include '<h3>Portal para livre consulta de dados da Câmara dos Deputados.</h3>'
  end
  
  it 'carrega página com informações sobre o portal' do
    get '/sobre'
    
    last_response.body.should include '<title>Res Publica: Sobre o sítio</title>'
    last_response.body.should include '<h4>Missão</h4>'
    last_response.body.should include '<h4>A Câmara</h4>'
  end
  
  it 'carrega página com o mapa do sítio' do
    get '/mapa'
    
    last_response.body.should include '<title>Res Publica: Mapa do sítio</title>'
    last_response.body.should include '<h3>Mapa do sítio</h3>'
  end
  
  it 'carrega página RSS Feed' do
    get '/feed'
    
    last_response.body.should include '<title>Res Publica</title>'
    last_response.body.should include '<description>Sistema de consulta dos dados abertos da Câmara dos Deputados do Brasil.</description>'
    last_response.body.should include '<link>http://res-publica.herokuapp.com//feed</link>'
  end
  
  it 'carrega página com o log da versão atual' do
    get '/log/versao/atual'
    
    last_response.body.should include '<title>Res Publica: Log de versão</title>'
    last_response.body.should include '<a href="/log/versao/todas">Ver log completo...</a>'
  end
  
  it 'carrega página com o log de todas as versões' do
    get '/log/versao/todas'
    
    last_response.body.should include '<title>Res Publica: Log de versão</title>'
    last_response.body.should_not include '<a href="/log/versao/todas">Ver log completo...</a>'
  end
  
  it 'carrega página de erro' do
    get '/404'
    
    last_response.body.should include '<title>Página não encontrada</title>'
    last_response.body.should include '<img src="images/chuck-norris.jpg" alt="Chuck Norris"/>'
    last_response.body.should include '<b>Chuck Norris disse que a página que você procura não existe. E se ele disse é melhor você acreditar!</b>'
  end

end
