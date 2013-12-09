# encoding: utf-8

desc 'Temporário: altera tipo do campo id da coleção proposicaos'
task :def_prop do
  puts 'Lendo todas as proposições'
  proposicoes = []
  
  Proposicao.all.each do |p|
    proposicoes << {
      :_id => p.id_cadastro, :nome => p.nome, :sigla => p.sigla,
      :numero => p.numero, :ano => p.ano, :autor => p.autor, :tags => p.tags
    }
  end
  
  puts "Total de proposições carregadas: #{proposicoes.size}"
  puts "Exclui todas as proposições da coleção"
  Proposicao.delete_all
  
  puts 'Recria todas as proposições'
  proposicoes.each do |p|
    Proposicao.create p
  end
  
  puts "Total de proposições encontradas no banco de dados: #{Proposicao.all.size}"
end
