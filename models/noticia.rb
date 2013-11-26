class Noticia
  include Mongoid::Document

  field :texto, :type => String
  field :tipo, :type => String
  
  def url
    case tipo
      when 'extracao'; then 'http://res-publica.herokuapp.com'
      when 'versao'; then 'http://res-publica.herokuapp.com/log/versao/atual'
      else ''
    end    
  end

end
