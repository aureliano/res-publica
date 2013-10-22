# encoding: utf-8
#
# Tarefa para automação do processo de rastreamento e extração de dados.
#
# autor: Aureliano
# data: 22/10/2013

require 'rest_client'

namespace :data do

  resources = {
    :partidos => 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterPartidosCD',
    :deputados => 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados',
    :bancadas => 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterLideresBancadas'
  }
  
  desc 'Web crawler para extração dos dados da api de dados da Câmara dos Deputados'
  task :extraction do
    resources.each do |name, url|
      puts "Carregando arquivos de dados de '#{name}'"
      download_data_files(name.to_s, url)
    end
  end
  
  def download_data_files(name, url)
    object_path = 'db/' + name   
    res = download_data_file(url, object_path)
    
    if res != 0
      raise "Encerrando download de arquivos porque o serviço parece estar indisponível no momento."
    end    
  end
  
  def download_data_file(url, object_path)
    count = 0
    
    while true do
      return -1 if count > 5
      
      begin
        puts "Baixando recurso #{url}"
        response = RestClient.get url
        File.open("#{object_path}_data.xml", 'w') {|f| f.write response}
        break
      rescue Exception => ex
        sleep 3
        count += 1
        puts "Erro: #{ex}\nNova tentativa..."
      end
    end
    
    0
  end
  
end
