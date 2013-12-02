class Bancada
  include Mongoid::Document
  
  field :_id, :type => String
  field :nome, :type => String
  field :representante, :type => String
  field :lider, :type => String
  field :vice_lideres, :type => Array
  
  def self.search(options)
    options[:skip] ||= 0
    options[:limit] ||= 0
    bancadas = []
    
    all
      .skip(options[:skip])
      .limit(options[:limit])
      .asc(:_id)
      .each {|document| bancadas << document }
    
    count = all.count
    [bancadas, count]
  end
  
end
