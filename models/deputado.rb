class Deputado
  include Mongoid::Document
  
  field :ide_cadastro, :type => Integer
  field :condicao, :type => String
  field :matricula, :type => Integer
  field :id_parlamentar, :type => Integer
  field :nome, :type => String
  field :nome_parlamentar, :type => String
  field :url_foto, :type => String
  field :sexo, :type => String
  field :uf, :type => String
  field :partido, :type => String
  field :gabinete, :type => Integer
  field :anexo, :type => Integer
  field :fone, :type => String
  field :email, :type => String
  field :comissoes_titular, :type => Array
  field :comissoes_suplente, :type => Array

  def self.search(options)
    options[:skip] ||= 0
    options[:limit] ||= 0
    deputados = []
    criteria = _create_criteria options
    
    where(criteria)
      .skip(options[:skip])
      .limit(options[:limit])
      .each {|document| deputados << document }
    
    count = where(criteria).count
    [deputados, count]
  end
  
  private
  def self._create_criteria(options)
    criteria = {}
    criteria[:partido] = options[:partido] if options[:partido] && !options[:partido].empty?
    criteria
  end
  
end
