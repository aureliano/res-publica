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
  
  get :bancadas do
    render 'organizacional/bancadas'
  end
  
  get :comissoes do
    render 'organizacional/comissoes'
  end
  
  get :deputados do
    render 'organizacional/deputados'
  end

end
