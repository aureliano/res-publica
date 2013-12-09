# encoding: utf-8

desc 'Temporário: altera tipo do campo id da coleção proposicaos'
task :def_prop do
  Proposicao.all.each do |p|
    p.id = p.id_cadastro.to_i
    p.id_cadastro = nil
    p.save
  end
end
