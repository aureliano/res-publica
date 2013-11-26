# encoding: utf-8
#
# Tarefa para automação do processo de rastreamento e extração de dados.
#
# autor: Aureliano
# data: 22/10/2013

require 'rest_client'
require 'nokogiri'
require 'yaml'

namespace :data do

  resources = {
    :geral => {
      :partidos => 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterPartidosCD',
      :deputados => 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDeputados',
      :bancadas => 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterLideresBancadas',
      :deputados_detail => 'http://www.camara.gov.br/SitCamaraWS/Deputados.asmx/ObterDetalhesDeputado?ideCadastro=<ide_cadastro>&numLegislatura=<numero_legislatura>',
      :proposicoes_intervalo => 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ListarProposicoes?sigla=<sigla>&numero=&ano=<ano>&datApresentacaoIni=<data_inicial>&datApresentacaoFim=&IdTipoAutor=&autor=&parteNomeAutor=&siglaPartidoAutor=&siglaUFAutor=&generoAutor=&codEstado=&codOrgaoEstado=&emTramitacao=',
      :proposicoes_intervalo_detail => 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ObterProposicaoPorID?IdProp=<id>'
    }, :prop => {
      :proposicoes => 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ListarProposicoes?sigla=<sigla>&numero=&ano=<ano>&datApresentacaoIni=&datApresentacaoFim=&autor=&parteNomeAutor=&siglaPartidoAutor=&siglaUFAutor=&generoAutor=&codEstado=&codOrgaoEstado=&emTramitacao=',
      :proposicoes_detail => 'http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ObterProposicaoPorID?IdProp=<id>'
    }
  }
  
  namespace :extraction do
  
    desc 'Web crawler para extração dos dados de partidos, deputados, bancadas e as últimas proposições criadas da API de Dados Abertos da Câmara dos Deputados'
    task :geral do
      resources[:geral].each do |name, url|
        puts "Carregando arquivos de dados de '#{name}'"
        extract_data(name.to_s, url)
      end

      metadata = YAML.load_file 'metadata.yml'
      metadata['LAST_EXTRACTION_DATE'] = Time.now.strftime('%d/%m/%Y')
      File.open('metadata.yml', 'w') {|file| file.write metadata.to_yaml }
    end
    
    desc 'Web crawler para extração dos dados de proposições criadas a partir do ano 2000 da API de Dados Abertos da Câmara dos Deputados'
    task :prop do
      resources[:prop].each do |name, url|
        puts "Carregando arquivos de dados de '#{name}'"
        extract_data(name.to_s, url)
      end
    end
    
  end
  
  private
  def extract_data(resource, url)
    case resource
      when 'proposicoes'; then download_proposicoes url
      when 'deputados_detail'; then download_deputados_detail url
      when 'proposicoes_detail'; then download_proposicoes_detail url
      when 'proposicoes_intervalo'; then download_proposicoes_intervalo url
      when 'proposicoes_intervalo_detail'; then download_proposicoes_detail url
      else download_data_files resource, url
    end
  end
  
  def download_deputados_detail(url)
    numero_legislatura = ((Time.now.year - 1795) / 4).to_i
    ids_deputados.each do |id|
      download_data_files("deputado_#{id}", url.sub(/<ide_cadastro>/, id).sub(/<numero_legislatura>/, numero_legislatura.to_s), true)
    end
  end
  
  def download_proposicoes_detail(url)
    failures = []
    
    ids_proposicoes.each do |id|
      res = download_data_files("proposicao_#{id}", url.sub(/<id>/, id), true, false, 1)
      failures << "proposicao_#{id}" if res != 0
    end
    
    puts "Proposições cujo download de detalhamento falhou: #{failures.join ', '}"
  end
  
  def download_proposicoes(url)
    metadata = YAML.load_file 'metadata.yml'
    lyear = metadata['ANO_FINAL_EXTRACAO_PROPOSICOES'].to_i
    
    from_year = metadata['ANO_INICIAL_EXTRACAO_PROPOSICOES'].to_i
    to_year = (lyear < 0) ? Time.now.year : lyear
    failures = []
    
    (from_year..to_year).each do |year|
      %w(MPV PEC PL PLP).each do |type|
        resource_url = url.sub(/<sigla>/, type).sub(/<ano>/, year.to_s)
        res = download_data_files("proposicoes_#{type}_#{year}", resource_url, true, false, 1)
        failures << "proposicoes_#{type}_#{year}" if res != 0
      end
    end
    
    puts "Pacote de Proposições cujo download falhou: #{failures.join ', '}"
  end
  
  def download_proposicoes_intervalo(url)
    metadata = YAML.load_file 'metadata.yml'
    tokens = metadata['LAST_EXTRACTION_DATE'].split('/').map {|e| e.to_i}
    date_init = (Time.new(tokens[2], tokens[1], tokens[0]) + (60 * 60 * 24)).strftime '%d/%m/%Y'
    
    %w(MPV PEC PL PLP).each do |type|
      year = Time.now.year.to_s
      resource_url = url.sub(/<sigla>/, type).sub(/<ano>/, year).sub(/<data_inicial>/, date_init)
      download_data_files("proposicoes_#{type}_#{year}", resource_url, true, false, 1)
    end
  end
  
  def download_data_files(name, url, temp = false, break_fail = true, attempts = 5)
    object_path = ((temp) ? ('tmp/' + name) : ('db/' + name))
    res = download_data_file(url, object_path, attempts)
    
    if res != 0
      raise "Encerrando download de arquivos porque o serviço parece estar indisponível no momento." if break_fail
    end
    
    res
  end
  
  def download_data_file(url, object_path, attempts = 5)
    count = 1
    
    while true do
      begin
        puts "Baixando recurso #{url}"
        response = RestClient.get url
        File.open("#{object_path}_data.xml", 'w:UTF-8') {|f| f.write response.encode("UTF-8", "ISO-8859-15")}
        break
      rescue Exception => ex
        sleep 3
        count += 1
        puts "Erro: #{ex}\nNova tentativa..."
      end
      
      return -1 if count > attempts
    end
    
    0
  end
  
  def ids_deputados
    doc = Nokogiri::XML(File.open('db/deputados_data.xml'))
    doc.xpath('//deputado/ideCadastro').map do |e|
      e.to_s.gsub(/<\/?ideCadastro>/, '')
    end
  end
  
  def ids_proposicoes
    ids = []
    `ls tmp | grep proposicoes_`.split("\n").each do |f|
      doc = Nokogiri::XML(File.open("tmp/#{f}"))
      ids << doc.xpath('//proposicao/id').map do |e|
        e.to_s.gsub(/<\/?id>/, '')
      end
    end
    
    ids.flatten
  end
  
end
