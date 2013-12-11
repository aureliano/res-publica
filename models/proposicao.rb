class Proposicao
  include Mongoid::Document

  field :_id, :type => Integer
  field :nome, :type => String
  field :sigla, :type => String
  field :numero, :type => Integer
  field :ano, :type => Integer
  field :autor, :type => String
  field :data_apresentacao, :type => Date
  field :tags, :type => Array

  def self.search(options)
    options[:skip] ||= 0
    options[:limit] ||= 0
    proposicoes = []
    criteria = _create_criteria options
    
    where(criteria)
      .asc(:data_apresentacao)
      .skip(options[:skip])
      .limit(options[:limit])
      .each {|document| proposicoes << document }
    
    count = where(criteria).count
    [proposicoes, count]
  end
  
  def self.most_up_to_date_proposicoes(options)
    day = 24 * 60 * 60
    tokens = APP[:last_extraction_date].split '/'
    end_time = Time.new(tokens[2], tokens[1], tokens[0]) + day
    start_time = end_time - (options[:last_days] * day)
    options[:skip] ||= 0
    options[:limit] ||= 0

    proposicoes = []
    where(:data_apresentacao => {'$gte' => start_time, '$lte' => end_time}).desc(:data_apresentacao).skip(options[:skip]).limit(options[:limit]).each {|document| proposicoes << document }    
    proposicoes
  end
  
  def self.count_most_up_to_date_proposicoes(last_days)
    day = 24 * 60 * 60
    tokens = APP[:last_extraction_date].split '/'
    end_time = Time.new(tokens[2], tokens[1], tokens[0]) + day
    start_time = end_time - (last_days * day)

    where(:data_apresentacao => {'$gte' => start_time, '$lte' => end_time}).count
  end

  private
  def self._create_criteria(options)
    criteria = {}
    criteria[:tags] = {:$all => options[:tags]} if (options[:tags] && !options[:tags].empty?)
    criteria
  end

end
