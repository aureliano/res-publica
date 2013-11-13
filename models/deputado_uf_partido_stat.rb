class DeputadoUfPartidoStat
  include Mongoid::Document
  
  field :uf, :type => String
  field :partido, :type => String
  field :total, :type => Integer
end
