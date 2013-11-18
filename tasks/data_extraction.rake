# encoding: utf-8
#
# Tarefa para automação do processo de rastreamento e extração de dados.
#
# autor: Aureliano
# data: 22/10/2013

require 'rest_client'
require 'nokogiri'

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
    
    numero_legislatura = ((Time.now.year - 1795) / 4).to_i
    url = "http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDetalhesDeputado?ideCadastro=<ide_cadastro>&numLegislatura=#{numero_legislatura}"
    ids_deputados.each do |id|
      download_data_files("deputado_#{id}", url.sub(/<ide_cadastro>/, id), true)
    end
  end
  
  def download_data_files(name, url, temp = false)
    object_path = ((temp) ? ('tmp/' + name) : ('db/' + name))
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
  
  def ids_deputados
    doc = Nokogiri::XML(File.open('db/deputados_data.xml'))
    doc.xpath('//deputado/ideCadastro').map do |e|
      e.to_s.gsub(/<\/?ideCadastro>/, '')
    end
  end
  
end
