class Despesa
  include Mongoid::Document
  
  field :descricao_despesa, :type => String
  field :nome_beneficiario, :type => String
  field :identificador_beneficiario, :type => String
  field :data_emissao, :type => String
  field :valor_documento, :type => Float
  field :valor_glosa, :type => Float
  field :valor_liquido, :type => Float
  field :mes, :type => Integer
  field :ano, :type => Integer
  field :id_deputado, :type => Integer
  index :id_deputado
end
