# encoding: utf-8

require 'spec_helper'

describe Proposicao do

  let(:proposicao) { Proposicao.new }
  it 'pode ser criada' do
    proposicao.should_not be_nil
  end
  
  it 'permite acesso a todos os atributos' do
    proposicao.should respond_to :_id
    proposicao.should respond_to :id_cadastro
    proposicao.should respond_to :nome
    proposicao.should respond_to :sigla
    proposicao.should respond_to :numero
    proposicao.should respond_to :ano
    proposicao.should respond_to :autor
    proposicao.should respond_to :tags
  end
end
