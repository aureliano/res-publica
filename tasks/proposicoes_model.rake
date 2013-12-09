# encoding: utf-8

desc 'Temporário: altera tipo do campo id da coleção proposicaos'
task :def_prop do
  proposicoes = []
  Proposicao.all.each do |p|
    proposicoes << {
      :_id => p.id_cadastro, :nome => p.nome, :sigla => p.sigla,
      :numero => p.numero, :ano => p.ano, :autor => p.autor, :tags => p.tags
    }
  end
  
  Proposicao.delete_all
  
  proposicoes.each do |p|
    Proposicao.create p
  end
end
