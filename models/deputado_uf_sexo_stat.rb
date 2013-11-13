class DeputadoUfSexoStat
  include Mongoid::Document
  
  field :uf, :type => String
  field :sexo, :type => String
  field :total, :type => Integer
end
