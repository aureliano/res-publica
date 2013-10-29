class Comissao
  include Mongoid::Document
  
  field :sigla, :type => String
  field :nome, :type => String
  
  def self.by_sigla(s)
    where(:sigla => s).first
  end
  
  def self.search(options)
    options[:skip] ||= 0
    options[:limit] ||= 0
    comissoes = []
    
    all
      .skip(options[:skip])
      .limit(options[:limit])
      .asc(:sigla)
      .each {|document| comissoes << document }
    
    count = all.count
    [comissoes, count]
  end
  
end
