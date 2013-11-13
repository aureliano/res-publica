class DeputadoSexoStat
  include Mongoid::Document
  
  field :sexo, :type => String
  field :total, :type => Integer
end
