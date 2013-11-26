ResPublica::App.controllers :proposicao do
  
  get :index do
    options = {:skip => skip_value, :limit => DataPage.default_page_size, :tags => get_tags_without_stopwords(params[:prop_tags])}
    @proposicoes, @total = Proposicao.search options
    
    render 'proposicao/index'
  end
  
  get :index, :with => :id do
    @proposicao = Proposicao.where(:_id => params[:id]).first
    redirect '/404' unless @proposicao
    @dados_prop = proposicao_dados_complementares @proposicao.id_cadastro

    render 'proposicao/dados_proposicao'
  end
  
  get :votacoes, :map => '/proposicao/:proposicao/votacoes' do
    @proposicao = Proposicao.where(:_id => params[:proposicao]).first
    redirect '/404' unless @proposicao
    
    @dados_votacoes = votacoes_proposicao(@proposicao)
    
    render 'proposicao/votacoes'
  end
  
  get :relatorio_votacao, :with => [:proposicao, :votacao] do
    @proposicao = Proposicao.where(:_id => params[:proposicao]).first
    redirect '/404' unless @proposicao

    @dados_votacoes = votacoes_proposicao(@proposicao)
    file = "tmp/Votacoes_Proposicao_#{@proposicao.sigla}-#{@proposicao.numero}-#{@proposicao.ano}.pdf"
    
    unless @dados_votacoes[:url]
      generate_votting_pdf file, @dados_votacoes, params[:votacao]
      send_file file, :filename => file, :type => 'Application/octet-stream'
    end
  end
end
