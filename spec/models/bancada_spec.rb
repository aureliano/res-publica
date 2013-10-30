require 'spec_helper'

describe Bancada do

  let(:bancada) { Bancada.new }
  it 'pode ser criada' do
    bancada.should_not be_nil
  end
  
  it 'permite acesso a todos os atributos' do
    bancada.should respond_to :_id
    bancada.should respond_to :sigla
    bancada.should respond_to :nome
    bancada.should respond_to :representante
    bancada.should respond_to :lider
    bancada.should respond_to :vice_lideres
  end

end
