ResPublica::App.controllers :organizacional do
  
  get :index do
    render 'organizacional/index', :layout => get_layout
  end
  
  get :partidos do
    options = {:skip => skip_value, :limit => DataPage.default_page_size, :tags => get_tags_without_stopwords(params[:tags])}
    @partidos, @total = case params[:situacao_partido]
      when 'Todos' then Partido.todos options
      when 'Extintos' then Partido.partidos_extintos options
      else Partido.partidos_ativos options
    end
    
    render 'organizacional/partidos', :layout => get_layout
  end
  
  get :partido, :with => :sigla do
    @partido = Partido.where(:_id => params[:sigla]).first
    redirect '/404' unless @partido

    render 'organizacional/dados_partido', :layout => get_layout
  end
  
  get :bancadas do
    options = {:skip => skip_value, :limit => DataPage.default_page_size}
    @bancadas, @total = Bancada.search options
    
    render 'organizacional/bancadas', :layout => get_layout
  end
  
  get :bancada, :with => :id do
    @bancada = Bancada.where(:_id => params[:id]).first
    redirect '/404' unless @bancada
    
    @vice_lideres = Deputado
      .where(:nome_parlamentar => {:$in => @bancada.vice_lideres})
      .only(:id, :nome_parlamentar)
    
    render 'organizacional/dados_bancada', :layout => get_layout
  end
  
  get :comissoes do
    options = {:skip => skip_value, :limit => DataPage.default_page_size, :tags => get_tags_without_stopwords(params[:tags])}
    @comissoes, @total = Comissao.search options
    
    render 'organizacional/comissoes', :layout => get_layout
  end
  
  get :comissoes, :with => [:deputado, :condicao] do
    deputado = Deputado.where(:_id => params[:deputado]).first
    redirect '/404' unless deputado
    
    @comissoes = (params[:condicao] == 'suplente') ? deputado.comissoes_suplente : deputado.comissoes_titular
    @comissoes, @total = Comissao.search({:skip => skip_value, :limit => DataPage.default_page_size, :comissoes => @comissoes, :tags => get_tags_without_stopwords(params[:tags])})
    
    render 'organizacional/comissoes', :layout => get_layout
  end
  
  get :comissao, :with => :id do
    @comissao = Comissao.where(:_id => params[:id]).first
    redirect '/404' unless @comissao

    options = {:skip => 0, :limit => Deputado.all.size}
    options[:comissoes_titular] = @comissao._id
    @deputados_titulares, @total_titulares = Deputado.search options
    options[:comissoes_titular] = nil
    options[:comissoes_suplente] = @comissao._id
    @deputados_suplentes, @total_suplentes = Deputado.search options

    render 'organizacional/dados_comissao', :layout => get_layout
  end
  
  get :comissao_contatos, :with => :id do
    @comissao = Comissao.where(:_id => params[:id]).first
    redirect '/404' unless @comissao
    
    data = generate_committee_contacts_report(@comissao)
    file = "tmp/Comissao_#{@comissao._id}_Contatos.pdf"
    generate_committee_pdf file, data
    
    send_file file, :filename => file, :type => 'Application/octet-stream'
  end
  
  get :deputados do
    options = {:skip => skip_value, :limit => DataPage.default_page_size, :tags => get_tags_without_stopwords(params[:tags]), :uf => params[:uf]}
    @deputados, @total = Deputado.search options
    
    render 'organizacional/deputados', :layout => get_layout
  end
  
  get :deputados, :with => :partido do
    options = {:skip => skip_value, :limit => DataPage.default_page_size, :partido => params[:partido], :tags => get_tags_without_stopwords(params[:tags]), :uf => params[:uf]}
    @deputados, @total = Deputado.search options
    
    render 'organizacional/deputados', :layout => get_layout
  end
  
  get :deputado, :with => :id do
    @deputado = Deputado.where(:_id => params[:id]).first
    redirect '/404' unless @deputado

    render 'organizacional/dados_deputado', :layout => get_layout
  end
  
  get :despesas, :map => '/organizacional/deputado/:deputado/despesas' do
    @deputado = Deputado.where(:_id => params[:deputado]).first
    redirect '/404' unless @deputado

    render 'organizacional/despesas', :layout => get_layout
  end
  
  get :despesas_service, :map => '/organizacional/deputado/:deputado/despesas/:ano/:mes', :provides => [:json] do
    @despesas_mes = Despesa.where(:id_deputado => params[:deputado].to_i, :ano => params[:ano].to_i, :mes => params[:mes].to_i)
    
    render 'organizacional/despesas_service', :layout => get_layout
  end

end
