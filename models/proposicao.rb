class Proposicao
  include Mongoid::Document

  field :id_cadastro, :type => Integer
  field :nome, :type => String
  field :sigla, :type => String
  field :numero, :type => Integer
  field :ano, :type => Integer
  field :autor, :type => String
  field :tags, :type => Array

end
