class Partido
  include Mongoid::Document

  field :sigla, :type => String
  field :numero, :type => Integer
  field :nome, :type => String
  field :data_registro_tse, :type => String
  field :sitio, :type => String
  field :logo, :type => String
  field :data_extincao, :type => String
  field :tags, :type => Array

  def extinto?
    !data_extincao.nil? && !data_extincao.empty?
  end
  
  def situacao
    (data_extincao.nil? || data_extincao.empty?) ? 'Ativo' : 'Extinto'
  end
  
  def self.todos(options)
    _search options, {:sigla => {:$nin => ['S.PART.']}}
  end
  
  def self.partidos_ativos(options)
    _search options, {:data_extincao => '', :sigla => {:$nin => ['S.PART.']}}
  end
  
  def self.partidos_extintos(options)
    _search options, {:data_extincao => {:$nin => ['']}, :sigla => {:$nin => ['S.PART.']}}
  end
  
  private
  def self._search(options, criteria = {})
    options[:skip] ||= 0
    options[:limit] ||= 0
    partidos = []
    
    where(criteria)
      .skip(options[:skip])
      .limit(options[:limit])
      .asc(:sigla)
      .each {|document| partidos << document }
    
    count = where(criteria).count
    [partidos, count]
  end

end
