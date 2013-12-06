# encoding: utf-8
#
# Tarefa para automação do processo de preparação dos dados de despesas.
#
# autor: Aureliano
# data: 06/12/2013

require 'csv'

namespace :db do

  namespace :despesas do
  
    desc 'Povo a base de dados com as despesas dos deputados.'
    task :seed do
      puts "Carregando dados de 'despesas' do arquivo 'db/despesas_ano_corrente_db.csv'"
      Despesa.delete_all

      ['db/despesas_ano_corrente_db.csv'].each do |f|
        documents = []
        data = load_data_from_file(f)
        
        data.each do |row|
          if row && row.size > 0
          documents << { :descricao_despesa => row[0], :nome_beneficiario => row[1],
                         :identificador_beneficiario => row[2], :data_emissao => row[3].sub(/T00:00:00/, ''),
                         :valor_documento => row[4].to_f, :valor_glosa => row[5].to_f,
                         :valor_liquido => row[6].to_f, :mes => row[7].to_i,
                         :ano => row[8].to_i, :id_deputado => row[9].to_i }
          end
        end

        while !documents.empty? do
          data = documents.slice! 0, 100
          Despesa.collection.insert data
        end
      end
      Despesa.delete_all :conditions => { :id_deputado => 0 }
    end
  
    desc 'Exclui despesas de dois anos atrás da base de dados.'
    task :clean do
      year = Time.now.year - 2
      puts "Excluindo despesas do ano #{year} e mais antigas."
      
      Despesa.delete_all :conditions => {:ano => {:$lte => year}}
    end
    
    private
    def load_data_from_file(file)
      data = [[]]
      File.open(file, 'r').each_line do |line|
        data << line.split(';')
      end

      data
    end
  
  end

end
