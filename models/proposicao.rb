class Proposicao
  include Mongoid::Document

  field :_id, :type => Integer
  field :nome, :type => String
  field :sigla, :type => String
  field :numero, :type => Integer
  field :ano, :type => Integer
  field :autor, :type => String
  field :tags, :type => Array

  def self.search(options)
    options[:skip] ||= 0
    options[:limit] ||= 0
    proposicoes = []
    criteria = _create_criteria options
    
    where(criteria)
      .skip(options[:skip])
      .limit(options[:limit])
      .each {|document| proposicoes << document }
    
    count = where(criteria).count
    [proposicoes, count]
  end

  private
  def self._create_criteria(options)
    criteria = {}
    criteria[:tags] = {:$all => options[:tags]} if (options[:tags] && !options[:tags].empty?)
    criteria
  end

end
