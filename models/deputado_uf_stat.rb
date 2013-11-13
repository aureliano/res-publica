class DeputadoUfStat
  include Mongoid::Document
  
  field :uf, :type => String
  field :total, :type => Integer
end
