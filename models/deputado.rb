class Deputado
  include Mongoid::Document
  
  field :ide_cadastro, :type => Integer
  field :condicao, :type => String
  field :matricula, :type => Integer
  field :id_parlamentar, :type => Integer
  field :nome, :type => String
  field :nome_parlamentar, :type => String
  field :profissao, :type => String
  field :data_nascimento, :type => String
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
  field :periodos_exercicio, :type => Array
  field :filiacoes_partidarias, :type => Array
  field :tags, :type => Array

  def self.search(options)
    options[:skip] ||= 0
    options[:limit] ||= 0
    deputados = []
    criteria = _create_criteria options
    
    where(criteria)
      .skip(options[:skip])
      .limit(options[:limit])
      .asc(:nome_parlamentar)
      .each {|document| deputados << document }
    
    count = where(criteria).count
    [deputados, count]
  end
  
  private
  def self._create_criteria(options)
    criteria = {}
    criteria[:partido] = options[:partido] if options[:partido] && !options[:partido].empty?
    criteria[:comissoes_titular] = {:$in => [options[:comissoes_titular]]} if options[:comissoes_titular] && !options[:comissoes_titular].empty?
    criteria[:comissoes_suplente] = {:$in => [options[:comissoes_suplente]]} if options[:comissoes_suplente] && !options[:comissoes_suplente].empty?
    criteria[:tags] = {:$all => options[:tags]} if (options[:tags] && !options[:tags].empty?)
    criteria[:uf] = options[:uf] if options[:uf] && !options[:uf].empty?
    criteria
  end
  
end
