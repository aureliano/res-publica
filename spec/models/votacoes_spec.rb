# encoding: utf-8

require 'spec_helper'

describe Votacoes do

  let(:votacao) { Votacoes.new }
  it 'pode ser criada' do
    votacao.should_not be_nil
  end
  
  it 'permite acesso a todos os atributos' do
    votacao.should respond_to :_id
    votacao.should respond_to :xml
  end
end
