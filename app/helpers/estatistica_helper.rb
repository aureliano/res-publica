ResPublica::App.helpers do

  def deputado_uf_chart_data
    [['UF', 'Deputados']].concat(DeputadoUfStat.all.map {|stat| [APP[:estados][stat.uf], stat.total] })
  end
  
  def deputado_sexo_chart_data
    [['Sexo', 'Deputados']].concat(DeputadoSexoStat.all.map {|stat| [stat.sexo, stat.total] })
  end
  
  def deputado_uf_sexo_chart_data
    hash = {}
    DeputadoUfSexoStat.all.each do |stat|
      s = hash[stat.uf]
      sexo = ((stat.sexo == 'masculino') ? 'M' : 'F')

      if s.nil?
        hash[stat.uf] = {sexo => stat.total}
      else
        s[sexo] = stat.total
      end
    end
    
    [['UF', 'Deputados do sexo masculino', 'Deputados do sexo feminino']]
      .concat(hash.map {|k, v| [APP[:estados][k], v['M'].to_i, v['F'].to_i] })
  end

end
