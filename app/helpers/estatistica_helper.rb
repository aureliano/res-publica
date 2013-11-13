ResPublica::App.helpers do

  def deputado_uf_chart_data
    [['UF', 'Deputados']].concat(DeputadoUfStat.all.map {|stat| [APP[:estados][stat.uf], stat.total] })
  end
  
  def deputado_sexo_chart_data
    [['Sexo', 'Deputados']].concat(DeputadoSexoStat.all.map {|stat| [stat.sexo, stat.total] })
  end

end
