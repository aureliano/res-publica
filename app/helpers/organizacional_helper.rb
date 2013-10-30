ResPublica::App.helpers do

  def url_deputado_by_nome_parlamentar(nome_parlamentar)
    deputado = Deputado.where(:nome_parlamentar => nome_parlamentar).first
    return '' if deputado.nil?
    
    url :organizacional, :deputado, :id => deputado.id
  end
  
  def link_to_deputado_by_nome_parlamentar(nome_parlamentar)
    link_to nome_parlamentar, url_deputado_by_nome_parlamentar(nome_parlamentar)
  end

end
