# encoding: utf-8

require 'spec_helper'

describe Noticia do

  let(:noticia) { Noticia.new }
  it 'pode ser criada' do
    noticia.should_not be_nil
  end
  
  it 'permite acesso a todos os atributos' do
    noticia.should respond_to :_id
    noticia.should respond_to :texto
    noticia.should respond_to :data
    noticia.should respond_to :tipo
  end
  
  it 'verifica url da notícia' do
    n = Noticia.new :tipo => 'extracao'
    n.url.should eq 'http://res-publica.herokuapp.com'
    
    n.tipo = 'versao'
    n.url.should eq 'http://res-publica.herokuapp.com/log/versao/atual'
    
    n.tipo = nil
    n.url.should eq ''
    
    n.tipo = 'qualquer'
    n.url.should eq ''
  end
  
end
