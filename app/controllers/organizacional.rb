ResPublica::App.controllers :organizacional do
  
  get :index do
    render 'organizacional/index'
  end
  
  get :partidos do
    options = {:skip => skip_value, :limit => DataPage.default_page_size}
    @partidos, @total = case params[:situacao_partido]
      when 'Todos' then Partido.todos options
      when 'Extintos' then Partido.partidos_extintos options
      else Partido.partidos_ativos options
    end
    
    render 'organizacional/partidos'
  end
  
  get :partido, :with => :sigla do
    @partido = Partido.where(:sigla => params[:sigla]).first
    redirect '/404' unless @partido

    render 'organizacional/dados_partido'
  end
  
  get :bancadas do
    render 'organizacional/bancadas'
  end
  
  get :comissoes do
    options = {:skip => skip_value, :limit => DataPage.default_page_size}
    @comissoes, @total = Comissao.search options
    
    render 'organizacional/comissoes'
  end
  
  get :comissao, :with => :id do
    @comissao = Comissao.where(:_id => params[:id]).first
    redirect '/404' unless @comissao

    options = {:skip => skip_value, :limit => DataPage.default_page_size}
    options[:comissoes_titular] = @comissao.sigla
    @deputados_titulares, @total_titulares = Deputado.search options
    options[:comissoes_titular] = nil
    options[:comissoes_suplente] = @comissao.sigla
    @deputados_suplentes, @total_suplentes = Deputado.search options

    render 'organizacional/dados_comissao'
  end
  
  get :deputados do
    options = {:skip => skip_value, :limit => DataPage.default_page_size}
    @deputados, @total = Deputado.search options
    
    render 'organizacional/deputados'
  end
  
  get :deputados, :with => :partido do
    options = {:skip => skip_value, :limit => DataPage.default_page_size, :partido => params[:partido]}
    @deputados, @total = Deputado.search options
    
    render 'organizacional/deputados_partidos'
  end
  
  get :deputado, :with => :id do
    @deputado = Deputado.where(:_id => params[:id]).first
    redirect '/404' unless @deputado

    render 'organizacional/dados_deputado'
  end

end
