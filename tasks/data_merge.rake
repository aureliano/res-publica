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
    save_file 'db/deputados_detalhamento.yml', "Arquivo com detalhamento dos deputados salvo em '<file_name>'", merge_deputados.to_yaml
    save_file 'db/proposicoes_db.csv', "Arquivo com proposições salvo em '<file_name>'", merge_proposicoes
    
    puts 'Removendo arquivos temporários gerados na extração'
    `rm tmp/*`
  end
  
  private
  def merge_deputados
    data = {}
    `ls tmp | grep deputado_`.split("\n").each do |file_name|
      doc = Nokogiri::XML(File.open('tmp/' + file_name))
      id = doc.xpath('//Deputado/ideCadastro').text
            
      data[id] = { :profissao => doc.xpath('//Deputado/nomeProfissao').text,
                   :data_nascimento => doc.xpath('//Deputado/dataNascimento').text,
                   :periodosExercicio => periodos_exercicio(doc),
                   :filiacoesPartidarias => filiacoes_partidarias(doc) }
    end
    
    data
  end
  
  def merge_proposicoes
    (1..9).each do |num|
      data = []
      Dir.foreach('tmp').select {|f| /proposicao_#{num}[\d]+_data.xml/.match(f) }.each do |file_name|
        doc = Nokogiri::XML(File.open('tmp/' + file_name))
        id = doc.xpath('//proposicao/idProposicao').text
        e = doc.xpath('proposicao')[0]
        dt = /<DataApresentacao>[\d\/-]*<\/DataApresentacao>/.match(e.to_s).to_s.gsub /<\/?DataApresentacao>/, ''

        data << [
          id, doc.xpath('proposicao/nomeProposicao').text,
          e['tipo'].rstrip, e['numero'], e['ano'], dt,
          "\"#{doc.xpath('//proposicao/Autor').text.gsub(/"/, '""')}\"",
          "\"#{doc.xpath('//proposicao/Indexacao').text.gsub("\n", '').gsub(/[,.]/, '').gsub(/"/, '""')}\""
        ]
      end
      
      file = "tmp/proposicoes_#{num}_db.csv"
      text = ''
      data.each {|line| text << line.join(';') + "\n" }
      
      save_file file, nil, text
    end
    
    text = "id;nome;sigla;numero;ano;data_apresentacao;autor;tags\n"
    (1..9).each {|num| text << File.read("tmp/proposicoes_#{num}_db.csv") }
    text
  end
  
  def save_file(file, message, content)
    File.open(file, 'w') {|f| f.write content}
    puts message.sub(/<file_name>/, file) if message
  end
  
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
