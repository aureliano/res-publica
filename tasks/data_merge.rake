# encoding: utf-8
#
# Tarefa para automação do processo de mescla dos arquivos de dados dos deputados federais.
#
# autor: Aureliano
# data: 18/11/2013

require 'nokogiri'
require 'yaml'

namespace :data do

  desc 'Mescla arquivos de dados de deputados federais.'
  task :merge do
    data = {}
    `ls tmp`.split("\n").each do |file_name|
      doc = Nokogiri::XML(File.open('tmp/' + file_name))
      id = doc.xpath('//Deputado/ideCadastro').text
            
      data[id] = { :profissao => doc.xpath('//Deputado/nomeProfissao').text,
                   :data_nascimento => doc.xpath('//Deputado/dataNascimento').text,
                   :periodosExercicio => periodos_exercicio(doc),
                   :filiacoesPartidarias => filiacoes_partidarias(doc) }
    end
    
    file = 'db/deputados_detalhamento.yml'
    File.open(file, 'w') {|f| f.write data.to_yaml}
    puts "Arquivo com detalhamento dos deputados salvo em '#{file}'"
    
    puts 'Removendo arquivos temporários gerados na extração'
    `rm tmp/*.xml`
  end
  
  private  
  def periodos_exercicio(doc)
    doc.xpath('//Deputado/periodosExercicio/periodoExercicio').map do |e|
      { :uf => e.xpath('siglaUFRepresentacao').text, :situacao => e.xpath('situacaoExercicio').text,
        :data_inicio => e.xpath('dataInicio').text, :data_fim => e.xpath('dataFim').text.strip,
        :causa_fim_exercicio => e.xpath('descricaoCausaFimExercicio').text.strip }
    end
  end
  
  def filiacoes_partidarias(doc)
    values = doc.xpath('//Deputado/filiacoesPartidarias/filiacaoPartidaria').map do |e|
      { :partido_anterior => e.xpath('siglaPartidoAnterior').text, :partido_posterior => e.xpath('siglaPartidoPosterior').text,
        :data_filiacao_partido_posterior => e.xpath('dataFiliacaoPartidoPosterior').text }
    end
  end

end
