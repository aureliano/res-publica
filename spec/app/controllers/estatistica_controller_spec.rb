# encoding: utf-8

require 'spec_helper'

describe "EstatisticaController" do

  it 'carrega página inicial do módulo estatística' do
    get '/estatistica'
    
    last_response.body.should include '<h2>Res Publica</h2>'
    last_response.body.should include '<h3>Estatísticas</h3>'
    last_response.body.should include '<p class="lead">'
    last_response.body.should include 'Dados estatísticos da Câmara e seus agentes.'
    last_response.body.should include '<h4>Deputados/UF</h4>'
    last_response.body.should include '<h4>Deputados/Sexo</h4>'
    last_response.body.should include '<h4>Deputados/UF/Sexo</h4>'
    last_response.body.should include '<h4>Deputados/Partido/UF</h4>'
    last_response.body.should include '<h4>Proposições/MPV</h4>'
    last_response.body.should include '<h4>Proposições/PEC</h4>'
    last_response.body.should include '<h4>Proposições/PL</h4>'
    last_response.body.should include '<h4>Proposições/PLP</h4>'
  end
  
  it 'carrega página com dados estatísticos de deputados por UF' do
    get '/estatistica/deputados/uf'
    
    last_response.body.should include 'Deputados/UF'
    last_response.body.should include 'Deputados Federais por Unidade Federativa.'
  end
  
  it 'carrega página com dados estatísticos de deputados por sexo' do
    get '/estatistica/deputados/sexo'
    
    last_response.body.should include 'Deputados/Sexo'
    last_response.body.should include 'Deputados Federais por sexo.'
  end
  
  it 'carrega página com dados estatísticos de deputados por uf e sexo' do
    get '/estatistica/deputados/uf-sexo'
    
    last_response.body.should include 'Deputados/UF/Sexo'
    last_response.body.should include 'Deputados Federais por Unidade Federativa e sexo.'
  end
  
  it 'carrega página com dados estatísticos de deputados por partido e uf' do
    get '/estatistica/deputados/partido-uf'
    
    last_response.body.should include 'Deputados/Partido/UF'
    last_response.body.should include 'Deputados Federais por Partido e Unidade Federativa.'
  end
  
  it 'carrega página com projeção de proposições do tipo MPV' do
    get '/estatistica/proposicoes/MPV'
    
    last_response.body.should include 'Proposições/Medida Provisória'
    last_response.body.should include 'Projeção das proposições do tipo Medida Provisória por ano.'
  end
  
  it 'carrega página com projeção de proposições do tipo PEC' do
    get '/estatistica/proposicoes/PEC'
    
    last_response.body.should include 'Proposições/Proposta de Emenda à Constituição'
    last_response.body.should include 'Projeção das proposições do tipo Proposta de Emenda à Constituição por ano.'
  end
  
  it 'carrega página com projeção de proposições do tipo PL' do
    get '/estatistica/proposicoes/PL'
    
    last_response.body.should include 'Proposições/Projeto de Lei'
    last_response.body.should include 'Projeção das proposições do tipo Projeto de Lei por ano.'
  end
  
  it 'carrega página com projeção de proposições do tipo PLP' do
    get '/estatistica/proposicoes/PLP'
    
    last_response.body.should include 'Proposições/Projeto de Lei Complementar'
    last_response.body.should include 'Projeção das proposições do tipo Projeto de Lei Complementar por ano.'
  end

end
