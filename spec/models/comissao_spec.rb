# encoding: utf-8

require 'spec_helper'

describe Comissao do

  let(:comissao) { Comissao.new }
  it 'pode ser criada' do
    comissao.should_not be_nil
  end
  
  it 'permite acesso a todos os atributos' do
    comissao.should respond_to :_id
    comissao.should respond_to :sigla
    comissao.should respond_to :nome
    comissao.should respond_to :tags
  end
  
  it 'encontra Comissão pela sigla' do
    Comissao.create :sigla => 'TESTE'
    Comissao.create :sigla => 'OK'
    
    Comissao.by_sigla('ABC').should be nil
    Comissao.by_sigla('TESTE').sigla.should eq 'TESTE'
    Comissao.by_sigla('OK').sigla.should eq 'OK'
  end
  
end
