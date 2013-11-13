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

end
