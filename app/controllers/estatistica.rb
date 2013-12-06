ResPublica::App.controllers :estatistica do
  
  get :index do
    render 'estatistica/index', :layout => get_layout
  end
  
  get :deputado_uf, :map => '/estatistica/deputados/uf' do
    @chart_data = deputado_uf_chart_data
    render 'estatistica/deputado_uf', :layout => get_layout
  end
  
  get :deputado_sexo, :map => '/estatistica/deputados/sexo' do
    @chart_data = deputado_sexo_chart_data
    render 'estatistica/deputado_sexo', :layout => get_layout
  end
  
  get :deputado_uf_sexo, :map => '/estatistica/deputados/uf-sexo' do
    @chart_data = deputado_uf_sexo_chart_data
    render 'estatistica/deputado_uf_sexo', :layout => get_layout
  end
  
  get :deputado_partido_uf, :map => '/estatistica/deputados/partido-uf' do
    @chart_data = deputado_uf_partido_chart_data params[:partido]
    render 'estatistica/deputado_partido_uf', :layout => get_layout
  end
  
  get :proposicoes, :with => :sigla do
    @chart_data = proposicoes_chart_data params[:sigla]
    redirect '/404' if @chart_data.nil?
    
    render 'estatistica/proposicoes', :layout => get_layout
  end

end
