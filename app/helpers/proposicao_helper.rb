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
  
  def votacoes_proposicao(proposicao)
    dados = {}
    dados[:proposicao] = proposicao
    url = "http://www.camara.gov.br/SitCamaraWS/Proposicoes.asmx/ObterVotacaoProposicao?tipo=#{proposicao.sigla}&numero=#{proposicao.numero}&ano=#{proposicao.ano}"

    begin
      doc = Nokogiri::XML(RestClient.get(url))
      dados[:url] = (doc.nil?) ? url : nil
    rescue Exception => ex
      dados[:url] = url
      puts " >>> Erro na recuperação das votações da proposição. #{ex}"
    end
    
    return dados if doc.nil?
    data = []
    doc.xpath('proposicao/Votacoes/Votacao').each do |votacao|
      hash = {}
      hash[:resumo] = votacao['Resumo'].sub(/[Ss]im:\s?\d+;\s?[Nn]ão:\s?\d+;\s?[Aa]bstenção:\s?\d+;\s?[Tt]otal:\s?\d+./, '').rstrip
      tokens = /[Ss]im:\s?\d+;\s?[Nn]ão:\s?\d+;\s?[Aa]bstenção:\s?\d+;\s?[Tt]otal:\s?\d+/.match(votacao['Resumo']).to_s.split ";"
      hash[:votos_sim] = tokens[0].capitalize
      hash[:votos_nao] = tokens[1].lstrip.capitalize
      hash[:votos_abstencao] = tokens[2].lstrip.capitalize
      hash[:votos_total] = tokens[3].lstrip.capitalize

      hash[:data] = votacao ['Data']
      hash[:hora] = votacao ['Hora']
      hash[:objeto_votacao] = votacao ['ObjVotacao']
      
      bancada_sim, bancada_nao, bancada_liberado = [], [], []
      votacao.at_xpath('//orientacaoBancada').children.each do |bancada|
        case bancada['orientacao'].to_s.strip
          when 'Sim'; then bancada_sim << bancada['Sigla']
          when 'Não'; then bancada_nao << bancada['Sigla']
          when 'Liberado'; then bancada_liberado << bancada['Sigla']
        end
      end
      hash[:orientacao_bancada] = {:sim => bancada_sim.join(', '), :nao => bancada_nao.join(', '), :liberado => bancada_liberado.join(', ')}
      
      votos = []
      votacao.at_xpath('//votos').children.each do |voto|
        votos << {:deputado => voto['Nome'], :ide_cadastro => voto['ideCadastro'],
                  :partido => voto['Partido'], :uf => voto['UF'], :voto => voto['Voto']} unless voto['Nome'].nil?
      end
      hash[:votos] = votos
      data << hash
    end
    
    dados[:votacoes] = data
    dados
  end
  
  def perfil_autor_proposicao(nome_parlamentar)
    deputado = Deputado.where(:nome_parlamentar => replace_special_characters(nome_parlamentar).upcase).first
    deputado.nil? ? nome_parlamentar : link_to(nome_parlamentar, url(:organizacional, :deputado, :id => deputado.id))
  end
end
