ResPublica::App.controllers :estatistica do
  
  get :index do
    render 'estatistica/index'
  end
  
  get :deputado_uf, :map => '/estatistica/deputados/uf' do
    @chart_data = deputado_uf_chart_data
    render 'estatistica/deputado_uf'
  end
  
  get :deputado_sexo, :map => '/estatistica/deputados/sexo' do
    @chart_data = deputado_sexo_chart_data
    render 'estatistica/deputado_sexo'
  end
  
  get :deputado_uf_sexo, :map => '/estatistica/deputados/uf-sexo' do
    @chart_data = deputado_uf_sexo_chart_data
    render 'estatistica/deputado_uf_sexo'
  end
  
  get :deputado_partido_uf, :map => '/estatistica/deputados/partido-uf' do
    @chart_data = deputado_uf_partido_chart_data params[:partido]
    render 'estatistica/deputado_partido_uf'
  end
  
  get :proposicoes_projecao, :map => '/estatistica/proposicoes' do
    render 'estatistica/proposicoes_projecao'
  end
  
  get :proposicoes_ano, :map => '/estatistica/proposicoes/ano' do
    render 'estatistica/proposicoes_ano'
  end

end
