# encoding: utf-8

ResPublica::App.helpers do

  def url_deputado_by_nome_parlamentar(nome_parlamentar)
    deputado = Deputado.where(:nome_parlamentar => nome_parlamentar).first
    return '' if deputado.nil?
    
    url :organizacional, :deputado, :id => deputado.id
  end
  
  def link_to_deputado_by_nome_parlamentar(nome_parlamentar)
    link_to nome_parlamentar, url_deputado_by_nome_parlamentar(nome_parlamentar)
  end
  
  def generate_comissao_contacts_report(comissao)
    titulares = Deputado.where(:comissoes_titular => {:$in => [comissao.sigla]})
    suplentes = Deputado.where(:comissoes_suplente => {:$in => [comissao.sigla]})
    
    text = "CONTATOS PARA #{comissao.sigla} - #{comissao.nome}\n\n"
    text << "DEPUTADOS TITULARES\n\n"
    titulares.each do |dep|
      text << "Deputado: #{dep.nome_parlamentar}\n"
      text << "e-mail: #{dep.email}\n"
      text << "Telefone: #{dep.fone}\n\n"
    end
    
    text << "DEPUTADOS SUPLENTES\n\n"
    suplentes.each do |dep|
      text << "Deputado: #{dep.nome_parlamentar}\n"
      text << "e-mail: #{dep.email}\n"
      text << "Telefone: (61) #{dep.fone}\n\n"
    end
    
    text << "-----\n\nRelatório emitido por Res Publica http://res-publica.herokuapp.com em #{Time.now.strftime "%d/%m/%Y %H:%M:%S"}"
  end

end
