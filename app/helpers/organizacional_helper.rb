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
  
  def generate_committee_contacts_report(comissao)
    titulares = Deputado.where(:comissoes_titular => {:$in => [comissao._id]})
    suplentes = Deputado.where(:comissoes_suplente => {:$in => [comissao._id]})
    
    { :comissao => comissao, :titulares => titulares, :suplentes => suplentes }
  end
  
  def generate_charges_report(deputado, ano, mes)
    despesas = Despesa.where(:id_deputado => deputado.id, :ano => ano, :mes => mes)
    { :deputado => deputado, :ano => ano, :mes => mes, :despesas => despesas }
  end
  
  def partido_img(partido)
    path = 'public/images/partidos/'
    img_file = Dir.entries(path).select {|f| /#{partido.id.downcase}\./.match(f) }.first
    "<img src=\"/images/partidos/#{img_file}\" alt=\"Logo do Partido\" class=\"party-logo\">".html_safe
  end
  
  def mes_local(mes)
    case mes
      when 1; then 'janeiro'
      when 2; then 'fevereiro'
      when 3; then 'março'
      when 4; then 'abril'
      when 5; then 'maio'
      when 6; then 'junho'
      when 7; then 'julho'
      when 8; then 'agosto'
      when 9; then 'setembro'
      when 10; then 'outubro'
      when 11; then 'novembro'
      when 12; then 'dezembro'
    end
  end
  
  def total_liquido_despesas(despesas)
    despesas.reduce(0) do |sum, despesa|
      sum + despesa.valor_liquido
    end
  end
  
  def total_bruto_despesas(despesas)
    despesas.reduce(0) do |sum, despesa|
      sum + despesa.valor_documento
    end
  end
  
  def total_glosa_despesas(despesas)
    despesas.reduce(0) do |sum, despesa|
      sum + despesa.valor_glosa
    end
  end

end
