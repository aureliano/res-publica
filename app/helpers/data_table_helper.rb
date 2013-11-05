# encoding: utf-8

ResPublica::App.helpers do

  def data_table(options)
    options[:page] ||= pagination_page_index
    data_page = DataPage.new(options)
    return "<i>Nenhum registro foi encontrado.</i>" if data_page.data.empty?

    t = "<table name=\"dt_#{options[:seed]}\" class=\"table table-striped\">"
    t << "<thead>\n  <tr>"

    options[:fields].each do |f|
      t << "\n    <th>#{f[:title]}</th>"
    end

    t << "\n  </tr>"
    t << "</thead>"
    
    t << "\n<tboby>"
    data_page.data.each do |partido|
      t << "\n  <tr>"
      options[:fields].each do |f|
        t << "\n    <td>#{partido.send(f[:name])}</td>"
      end
      t << "\n    <td width=\"100\"><a href=\"#{options[:detail_path]}#{partido.send(options[:field_id])}\" class=\"btn btn-primary btn-small\">Detalhar</a></td>"
      t << "\n  </tr>"
      
    end
    
    t << "\n</tbody>"
    t << "\n</table>"
    t << pagination_layer(data_page) if options[:hide_pagination].nil? || options[:hide_pagination] == false
    
    t << "\n<hr/><div name=\"div_total_#{options[:seed]}\">Total de #{seeds[options[:seed]]}: #{data_page.total}</div>"
  end
  
  def pagination_layer(data_page)
    t = "<div class=\"pagination\">"
    t << "\n <ul>"
    
    t << "\n <li#{data_page.has_previous_pagination_block? ? '' : ' class="disabled"'}><a href=\"#{data_page.has_previous_pagination_block? ? inject_params(data_page.previous_block_page) : 'javascript: void(0)'}\">&lt;&lt;</a></li>"
    t << "\n <li#{data_page.has_previous_page? ? '' : ' class="disabled"'}><a href=\"#{data_page.has_previous_page? ? inject_params(data_page.previous_page) : 'javascript: void(0)'}\">&lt;</a></li>"
    
    data_page.current_page_block.each do |page|
      t << "\n <li#{(data_page.page_index == page) ? ' class="disabled"' : ''}><a href=\"#{(data_page.page_index == page) ? 'javascript: void(0)' : inject_params(page)}\">#{page}</a></li>"
    end
    
    t << "\n <li#{data_page.has_next_page? ? '' : ' class="disabled"'}><a href=\"#{data_page.has_next_page? ? inject_params(data_page.next_page) : 'javascript: void(0)'}\">&gt;</a></li>"
    t << "\n <li#{data_page.has_next_pagination_block? ? '' : ' class="disabled"'}><a href=\"#{data_page.has_next_pagination_block? ? inject_params(data_page.next_block_page) : 'javascript: void(0)'}\">&gt;&gt;</a></li>"
    
    t << "\n </ul>"
    t << "</div>"
    
    data_page.pages > 1 ? t : ''
  end

  private
  def inject_params(page_index=nil)
    url = '?'
    url << "page=#{page_index}"
    url << "&situacao_partido=#{params[:situacao_partido]}" if params[:situacao_partido]
    url << "&tags=#{params[:tags]}" if params[:tags]
    url << "&uf=#{params[:uf]}" if params[:uf]
    
    url
  end
  
  def seeds
    {
      'partido' => 'partidos',
      'comissao' => 'comissões',
      'deputado' => 'deputados',
      'bancada' => 'bancadas'
    }
  end

end
