# encoding: utf-8

require 'prawn'

ResPublica::App.helpers do

  def generate_committee_pdf(file, data)
    Prawn::Document.generate(file, :info => committee_metadata(data[:comissao])) do
      repeat :all do
        stroke { horizontal_line 0, 540, :at => 715 }
        name = (data[:comissao].nome.length > 100) ? "#{data[:comissao].nome[0, 100]}..." : data[:comissao].nome
        txt = "Lista de Contatos da #{data[:comissao]._id} - #{name}"
        text_box txt, :at => [0, 700], :size => 15, :align => :center
        stroke { horizontal_line 0, 540, :at => (txt.size <= 77) ? 680 : 665 }
      end
        
      draw_text "Deputados Titulares", :at => [200, 640], :style => :bold
      block_width = 5
      move_cursor_to 620
      
      data[:titulares].each do |dep|
        str = "Deputado: #{dep.nome_parlamentar}\n"
        str << "e-mail: #{dep.email}\n"
        str << "Telefone: (61) #{dep.fone}\n\n"
        
        if cursor < 40
          start_new_page
          move_cursor_to 640
        end
        
        span(400) { text str }        
        move_down block_width
      end
      
      start_new_page
      
      draw_text "Deputados Suplentes", :at => [200, 640], :style => :bold
      move_cursor_to 620
      
      data[:suplentes].each do |dep|
        str = "Deputado: #{dep.nome_parlamentar}\n"
        str << "e-mail: #{dep.email}\n"
        str << "Telefone: (61) #{dep.fone}\n\n"
        
        if cursor < 40
          start_new_page
          move_cursor_to 640
        end
        
        span(400) { text str }        
        move_down block_width
      end
      
      str = "Relatório extraído de http://res-publica.herokuapp.com em #{Time.now.strftime "%d/%m/%Y %H:%M:%S"}\nPágina <page> de <total>"
      number_pages str, :at => [bounds.right - 500, 0], :align => :right, :start_count_at => 1
    end
  end

  def generate_votting_pdf(file, data, votacao_index)
    index = votacao_index.to_i - 1
    if index < 0 || index >= data[:votacoes].size
      index = 0
    end

    Prawn::Document.generate(file, :info => votting_metadata(data[:proposicao])) do
      hash = data[:votacoes][index]
      stroke { horizontal_line 0, 540, :at => 715 }
      text_box "Lista de Votações do(a) #{data[:proposicao].nome}", :at => [0, 700], :size => 15, :align => :center
      stroke { horizontal_line 0, 540, :at => 680 }
      
      draw_text "Sumário da Votação", :at => [200, 640], :style => :bold
      text_box "Resumo: #{hash[:resumo]}", :at => [0, 620]
      less = (hash[:resumo].size <= 85) ? 0 : 15
      draw_text 'Votos', :at => [0, 595 - less]
      draw_text hash[:votos_sim].capitalize, :at => [0, 580 - less]
      draw_text hash[:votos_nao].capitalize, :at => [0, 565 - less]
      draw_text hash[:votos_abstencao].capitalize, :at => [0, 550 - less]
      draw_text hash[:votos_total].capitalize, :at => [0, 535 - less]
      draw_text "Data: #{hash[:data]} #{hash[:hora]}", :at => [0, 520 - less]
      draw_text "Objeto: #{hash[:objeto_votacao]}", :at => [0, 505 - less]
      
      draw_text 'Orientação das Bancadas', :at => [180, 460], :style => :bold
      move_cursor_to 440
      text "Sim: #{hash[:orientacao_bancada][:sim]}"
      text "Não: #{hash[:orientacao_bancada][:nao]}"
      text "Liberado: #{hash[:orientacao_bancada][:liberado]}"
      
      draw_text 'Votação', :at => [250, 360], :style => :bold
      move_cursor_to 340
      dt = [['Deputado', 'Partido', 'Voto']]
      hash[:votos].each {|voto| dt << [voto[:deputado], voto[:partido], voto[:voto]] }
      table(dt, :header => true, :column_widths => [370, 80, 80]) do
        row(0).font_style = :bold; row(0).align = :center
      end
      
      str = "Relatório extraído de http://res-publica.herokuapp.com em #{Time.now.strftime "%d/%m/%Y %H:%M:%S"}\nPágina <page> de <total>"
      number_pages str, :at => [bounds.right - 500, 0], :align => :right, :start_count_at => 1
    end
  end
  
  def generate_charges_pdf(file, data)    
    Prawn::Document.generate(file, :info => charges_metadata(data[:deputado], data[:ano], data[:mes])) do
      repeat :all do
        stroke { horizontal_line 0, 540, :at => 715 }
        text_box "Despesas de #{data[:deputado].nome_parlamentar} em #{data[:mes]}/#{data[:ano]}", :at => [0, 700], :size => 15, :align => :center
        stroke { horizontal_line 0, 540, :at => 680 }
      end
      
      require File.expand_path '../../app.rb', __FILE__
      helper = Object.const_get('ResPublica').const_get('App').new.helpers
        
      draw_text "Sumário das despesas", :at => [200, 640], :style => :bold
      block_width = 5
      despesas = data[:despesas]
      
      text_box "Documentos emitidos: #{despesas.size}", :at => [0, 620]
      text_box "Total glosa: #{helper.format_money helper.total_glosa_despesas despesas}", :at => [0, 605]
      text_box "Total líquido: #{helper.format_money helper.total_liquido_despesas despesas}", :at => [0, 590]
      text_box "Total bruto: #{helper.format_money helper.total_bruto_despesas despesas}", :at => [0, 575]
      
      draw_text "Extrato", :at => [250, 540], :style => :bold
      move_cursor_to 520
      
      despesas.each do |d|
        str = "Descrição do documento: #{d.descricao_despesa}\n"
        str << "Beneficiário: #{d.nome_beneficiario}\n"
        str << "Identificação: #{helper.format_identifier d.identificador_beneficiario}\n"
        str << "Data de emissão: #{helper.format_date_s d.data_emissao}\n"
        str << "Valor da glosa: #{helper.format_money d.valor_glosa}\n"
        str << "Valor líquido: #{helper.format_money d.valor_liquido}\n"
        str << "Valor bruto: #{helper.format_money d.valor_documento}\n\n"
        
        if cursor < 100
          start_new_page
          move_cursor_to 650
        end
        
        span(400) { text str }        
        move_down block_width
      end
      
      str = "Relatório extraído de http://res-publica.herokuapp.com em #{Time.now.strftime "%d/%m/%Y %H:%M:%S"}\nPágina <page> de <total>"
      number_pages str, :at => [bounds.right - 500, 0], :align => :right, :start_count_at => 1
    end
  end
  
  private
  def committee_metadata(committee)
    {
      :Title => "Lista de contatos da comissão #{committee._id}",
      :Author => 'Res Publica',
      :Subject => "Lista de contatos da comissão #{committee._id}",
      :CreationDate => Time.now
    }
  end
  
  def votting_metadata(proposicao)
    {
      :Title => "Lista de votações da proposição #{proposicao.sigla}",
      :Author => 'Res Publica',
      :Subject => "Lista de votações da proposição #{proposicao.sigla}",
      :CreationDate => Time.now
    }
  end
  
  def charges_metadata(deputado, ano, mes)
    {
      :Title => "Lista de despesas do deputado #{deputado.nome_parlamentar} em #{ano}/#{mes}",
      :Author => 'Res Publica',
      :Subject => "Lista de despesas do deputado #{deputado.nome_parlamentar} em #{ano}/#{mes}",
      :CreationDate => Time.now
    }
  end

end
