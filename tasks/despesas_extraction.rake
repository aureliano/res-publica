# encoding: utf-8
#
# Tarefa para automação do processo de extração e preparação de arquivo de dados de despesas.
#
# autor: Aureliano
# data: 02/12/2013

require 'nokogiri'
require 'open-uri'
require 'iconv'

namespace :data do

  namespace :extraction do

    namespace :despesas do

      desc 'Extrai arquivo de despesas do ano corrente e atualiza arquivo de despesas do ano atual'
      task :ano_corrente do
        url = 'http://www.camara.gov.br/cotas/AnoAtual.zip'
        puts 'Extraindo arquivo de despesas de ' + url
        
        Dir.mkdir 'tmp' unless File.exist? 'tmp'
        
        file = 'despesas_ano_atual.zip'
        download url, "tmp/#{file}"
        `unzip tmp/#{file} -d tmp`
        
        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
        s = ic.iconv(File.read 'tmp/AnoAtual.xml')[0..-2]

        doc = Nokogiri::XML(s)
        data = [['descricao_despesa', 'nome_beneficiario', 'identificador_beneficiario', 'data_emissao', 'valor_documento', 'valor_glosa', 'valor_liquido', 'mes', 'ano', 'id_deputado']]
        
        puts 'Preparando arquivo de dados.'
        
        data.concat(doc.xpath('orgao/DESPESAS/DESPESA').map do |despesa|
          nodes = despesa.children
          [7, 10, 11, 14, 15, 16, 17, 18, 19, 23].map {|i| nodes[i] }
        end)
        
        file = 'db/despesas_ano_corrente_db.csv'
        text = ''
        data.each {|line| text << line.join(';') + "\n" }
        
        puts 'Escrevendo arquivo de dados ' + file
        File.open(file, 'w') {|file| file.write text }
        
        File.delete 'tmp/AnoAtual.xml'
        File.delete 'tmp/despesas_ano_atual.zip'
      end
      
      desc 'Extrai arquivo de despesas do ano anterior e atualiza arquivo de despesas do ano anterior'
      task :ano_anterior do
        url = 'http://www.camara.gov.br/cotas/AnoAnterior.zip'
        puts 'Extraindo arquivo de despesas de ' + url
        
        Dir.mkdir 'tmp' unless File.exist? 'tmp'
        
        file = 'despesas_ano_anterior.zip'
        download url, "tmp/#{file}"
        `unzip tmp/#{file} -d tmp`
        
        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
        s = ic.iconv(File.read 'tmp/AnoAnterior.xml')[0..-2]

        doc = Nokogiri::XML(s)
        data = [['descricao_despesa', 'nome_beneficiario', 'identificador_beneficiario', 'data_emissao', 'valor_documento', 'valor_glosa', 'valor_liquido', 'mes', 'ano', 'id_deputado']]
        
        puts 'Preparando arquivo de dados.'
        
        data.concat(doc.xpath('orgao/DESPESAS/DESPESA').map do |despesa|
          nodes = despesa.children
          [7, 10, 11, 14, 15, 16, 17, 18, 19, 23].map {|i| nodes[i] }
        end)
        
        file = 'db/despesas_ano_anterior_db.csv'
        text = ''
        data.each {|line| text << line.join(';') + "\n" }
        
        puts 'Escrevendo arquivo de dados ' + file
        File.open(file, 'w') {|file| file.write text }
        
        File.delete 'tmp/AnoAnterior.xml'
        File.delete 'tmp/despesas_ano_anterior.zip'
      end
      
      private
      def download(resource, output)
        File.open(output, "wb") do |saved_file|
          open(resource, 'rb') do |read_file|
            saved_file.write(read_file.read)
          end
        end
      end
    
    end
 
  end
  
  namespace :clean do
    
    desc 'Exclui despesas de dois anos atrás da base de dados.'
    task :despesas do
      year = Time.now.year - 2
      puts "Excluindo despesas do ano #{year} e mais antigas."
      
      Despesa.delete_all :conditions => {:ano => {:$lte => year}}
    end
  end
end
