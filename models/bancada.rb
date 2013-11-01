class Bancada
  include Mongoid::Document
  
  field :sigla, :type => String
  field :nome, :type => String
  field :representante, :type => String
  field :lider, :type => String
  field :vice_lideres, :type => Array
  field :tags, :type => Array
  
  def self.search(options)
    options[:skip] ||= 0
    options[:limit] ||= 0
    bancadas = []
    
    all
      .skip(options[:skip])
      .limit(options[:limit])
      .asc(:sigla)
      .each {|document| bancadas << document }
    
    count = all.count
    [bancadas, count]
  end
  
end
