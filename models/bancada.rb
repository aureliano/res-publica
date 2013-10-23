class Bancada
  include Mongoid::Document
  
  field :nome, :type => String
  field :representante, :type => String
  field :lider, :type => String
  field :vice_lideres, :type => Array
  
end
