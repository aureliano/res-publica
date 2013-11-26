class Votacoes
  include Mongoid::Document

  field :_id, :type => Hash
  field :xml, :type => String
  
end
