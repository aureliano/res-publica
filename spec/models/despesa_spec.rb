require 'spec_helper'

describe Despesa do

  let(:despesa) { Despesa.new }
  it 'pode ser criada' do
    despesa.should_not be_nil
  end
  
  it 'permite acesso a todos os atributos' do
    despesa.should respond_to :_id
    despesa.should respond_to :descricao_despesa
    despesa.should respond_to :nome_beneficiario
    despesa.should respond_to :identificador_beneficiario
    despesa.should respond_to :data_emissao
    despesa.should respond_to :valor_documento
    despesa.should respond_to :valor_glosa
    despesa.should respond_to :valor_liquido
    despesa.should respond_to :mes
    despesa.should respond_to :ano
    despesa.should respond_to :id_deputado
  end

end
