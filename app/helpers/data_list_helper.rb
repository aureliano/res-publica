# encoding: utf-8

ResPublica::App.helpers do

  def search_data_list(options)
    options[:page] ||= pagination_page_index
    data_page = DataPage.new(options)
    return "<i>Nenhum registro encontrado.</i>" if data_page.data.empty?
    
    d = "#{data_page.total} item(s) encontrado(s).\n<hr/>"
        
    data_page.data.each do |proposicao|      
      d << "<div name=\"div_item_resultado_consulta\">"
      d << "\n  <a href=\"/proposicao/#{proposicao.id}\"> #{proposicao.nome}</a><br/>"
      d << "\n  #{APP[:tipos_proposicoes][proposicao.sigla.to_sym]}<br/>"
      d << "\n  Ano da proposição: #{proposicao.ano}<br/>"
      d << "\n  Autor: #{proposicao.autor}"
      d << "\n</div>"
      d << "\n<br/><br/>\n"
    end
    
    d << pagination_layer(data_page)
  end
end
