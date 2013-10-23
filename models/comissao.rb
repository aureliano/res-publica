class Comissao
  include Mongoid::Document
  
  field :sigla, :type => String
  field :nome, :type => String
  
  def self.by_sigla(s)
    where(:sigla => s).first
  end
  
end
