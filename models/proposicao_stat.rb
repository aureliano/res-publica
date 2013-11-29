class ProposicaoStat
  include Mongoid::Document
  
  field :sigla, :type => String
  field :ano, :type => String
  field :total, :type => Integer
end
