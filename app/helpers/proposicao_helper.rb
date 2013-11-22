# encoding: utf-8

require 'rest_client'
require 'nokogiri'

ResPublica::App.helpers do

  def tipos_proposicao
    APP[:tipos_proposicoes].map do |k, v|
      "#{k}-#{v}"
    end.join ', '
  end
  
  def proposicao_dados_complementares(proposicao_id)
    data = {}
    url = "http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ObterProposicaoPorID?IdProp=#{proposicao_id}"
    
    begin
      doc = Nokogiri::XML(RestClient.get(url))
      data[:url] = (doc.nil?) ? url : nil
    rescue Exception => ex
      data[:url] = url
      puts " >>> Erro na recuperação dos dados da proposição. #{ex}"
    end
    
    return data if doc.nil?
    data[:ementa] = doc.xpath('proposicao/Ementa').text
    data[:explicacao_ementa] = doc.xpath('proposicao/ExplicacaoEmenta').text
    data[:data_apresentacao] = doc.xpath('proposicao/DataApresentacao').text
    data[:regime_tramitacao] = doc.xpath('proposicao/RegimeTramitacao').text
    data[:data_despacho] = doc.xpath('proposicao/UltimoDespacho')[0]['Data']
    data[:despacho] = doc.xpath('proposicao/UltimoDespacho').text
    data[:apreciacao] = doc.xpath('proposicao/Apreciacao').text
    data[:situacao] = doc.xpath('proposicao/Situacao').text
    data[:link_inteiro_teor] = doc.xpath('proposicao/LinkInteiroTeor').text
    
    data
  end
  
  def perfil_autor_proposicao(nome_parlamentar)
    deputado = Deputado.where(:nome_parlamentar => replace_special_characters(nome_parlamentar).upcase).first
    deputado.nil? ? nome_parlamentar : link_to(nome_parlamentar, url(:organizacional, :deputado, :id => deputado.id))
  end
end
