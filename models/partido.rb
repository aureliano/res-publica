class Partido
  include Mongoid::Document

  field :_id, :type => String
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
    _search options, {:_id => {:$nin => ['S.PART.']}}
  end
  
  def self.partidos_ativos(options)
    _search options, {:data_extincao => '', :_id => {:$nin => ['S.PART.']}}
  end
  
  def self.partidos_extintos(options)
    _search options, {:data_extincao => {:$nin => ['']}, :_id => {:$nin => ['S.PART.']}}
  end
  
  private
  def self._search(options, criteria = {})
    options[:skip] ||= 0
    options[:limit] ||= 0
    partidos = []
    criteria[:tags] = {:$all => options[:tags]} if (options[:tags] && !options[:tags].empty?)
    
    where(criteria)
      .skip(options[:skip])
      .limit(options[:limit])
      .asc(:_id)
      .each {|document| partidos << document }
    
    count = where(criteria).count
    [partidos, count]
  end

end
