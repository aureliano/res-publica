# encoding: utf-8

require 'spec_helper'

describe Comissao do

  let(:comissao) { Comissao.new }
  it 'pode ser criada' do
    comissao.should_not be_nil
  end
  
  it 'permite acesso a todos os atributos' do
    comissao.should respond_to :_id
    comissao.should respond_to :nome
    comissao.should respond_to :tags
  end
  
  it 'encontra Comissão pela sigla' do
    Comissao.create :_id => 'TESTE'
    Comissao.create :_id => 'OK'
    
    Comissao.by_id('ABC').should be nil
    Comissao.by_id('TESTE')._id.should eq 'TESTE'
    Comissao.by_id('OK')._id.should eq 'OK'
  end
  
end
