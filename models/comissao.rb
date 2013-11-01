class Comissao
  include Mongoid::Document
  
  field :sigla, :type => String
  field :nome, :type => String
  field :tags, :type => Array
  
  def self.by_sigla(s)
    where(:sigla => s).first
  end
  
  def self.search(options)
    options[:skip] ||= 0
    options[:limit] ||= 0
    comissoes = []
    criteria = (options[:comissoes]) ? where(:sigla => {:$in => options[:comissoes]}) : all
    
    criteria
      .skip(options[:skip])
      .limit(options[:limit])
      .asc(:sigla)
      .each {|document| comissoes << document }
    
    count = criteria.count
    [comissoes, count]
  end
  
end
