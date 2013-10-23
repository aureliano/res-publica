require 'spec_helper'

describe Partido do

  let(:partido) { Partido.new }
  it 'pode ser criado' do
    partido.should_not be_nil
  end
  
  it 'permite acesso a todos os atributos' do
    partido.should respond_to :_id
    partido.should respond_to :sigla
    partido.should respond_to :nome
    partido.should respond_to :data_extincao
  end
  
  it 'verifica se partido foi extinto' do
    Partido.new.extinto?.should eq false
    Partido.new(:data_extincao => '').extinto?.should eq false
    Partido.new(:data_extincao => Time.now.to_s).extinto?.should eq true
  end
  
end
