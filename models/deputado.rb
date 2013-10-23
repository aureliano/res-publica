class Deputado
  include Mongoid::Document
  
  field :ide_cadastro, :type => Integer
  field :condicao, :type => String
  field :matricula, :type => Integer
  field :id_parlamentar, :type => Integer
  field :nome, :type => String
  field :nome_parlamentar, :type => String
  field :url_foto, :type => String
  field :sexo, :type => String
  field :uf, :type => String
  field :partido, :type => String
  field :gabinete, :type => Integer
  field :anexo, :type => Integer
  field :fone, :type => String
  field :email, :type => String
  field :comissoes_titular, :type => Array
  field :comissoes_suplente, :type => Array

end
