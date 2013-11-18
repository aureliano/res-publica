require 'spec_helper'

describe Deputado do

  let(:deputado) { Deputado.new }
  it 'pode ser criado' do
    deputado.should_not be_nil
  end
  
  it 'permite acesso a todos os atributos' do
    deputado.should respond_to :_id
    deputado.should respond_to :ide_cadastro
    deputado.should respond_to :condicao
    deputado.should respond_to :matricula
    deputado.should respond_to :id_parlamentar
    deputado.should respond_to :nome
    deputado.should respond_to :nome_parlamentar
    deputado.should respond_to :profissao
    deputado.should respond_to :data_nascimento
    deputado.should respond_to :url_foto
    deputado.should respond_to :sexo
    deputado.should respond_to :uf
    deputado.should respond_to :partido
    deputado.should respond_to :gabinete
    deputado.should respond_to :anexo
    deputado.should respond_to :fone
    deputado.should respond_to :email
    deputado.should respond_to :comissoes_titular
    deputado.should respond_to :comissoes_suplente
    deputado.should respond_to :periodos_exercicio
    deputado.should respond_to :filiacoes_partidarias
    deputado.should respond_to :tags
  end

end
