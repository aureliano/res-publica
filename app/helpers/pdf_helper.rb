# encoding: utf-8

require 'prawn'

ResPublica::App.helpers do

  def generate_committee_pdf(file, data)
    Prawn::Document.generate(file, :info => committee_metadata(data[:comissao])) do
      repeat :all do
        stroke { horizontal_line 0, 540, :at => 715 }
        draw_text "CONTATOS PARA #{data[:comissao].sigla} - #{data[:comissao].nome}", :at => [100, 700], :size => 15
        stroke { horizontal_line 0, 540, :at => 695 }
      end
        
      draw_text "DEPUTADOS TITULARES", :at => [200, 650], :style => :bold
      block_width = 5
      move_cursor_to 630
      
      data[:titulares].each do |dep|
        str = "Deputado: #{dep.nome_parlamentar}\n"
        str << "e-mail: #{dep.email}\n"
        str << "Telefone: #{dep.fone}\n\n"
        
        if cursor < 40
          start_new_page
          move_cursor_to 650
        end
        
        span(400) { text str }        
        move_down block_width
      end
      
      start_new_page
      
      draw_text "DEPUTADOS SUPLENTES", :at => [200, 650], :style => :bold
      move_cursor_to 630
      
      data[:suplentes].each do |dep|
        str = "Deputado: #{dep.nome_parlamentar}\n"
        str << "e-mail: #{dep.email}\n"
        str << "Telefone: #{dep.fone}\n\n"
        
        if cursor < 40
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

  def generate_votting_pdf(file, data)
    
  end
  
  private
  def committee_metadata(committee)
    {
      :Title => "Lista de contatos para a comissão #{committee.sigla}",
      :Author => 'Res Publica',
      :Subject => "Lista de contatos para a comissão #{committee.sigla}",
      :CreationDate => Time.now
    }
  end

end
