# encoding: utf-8

require 'prawn'

ResPublica::App.helpers do

  def generate_committee_pdf(file, data)
    Prawn::Document.generate(file, :info => committee_metadata(data[:comissao])) do
      repeat :all do
        stroke { horizontal_line 0, 540, :at => 715 }
        txt = "Lista de Contatos da #{data[:comissao]._id} - #{data[:comissao].nome}"
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

end
