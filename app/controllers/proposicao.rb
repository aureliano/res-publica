ResPublica::App.controllers :proposicao do

  get :index do
    render 'proposicao/index', :layout => get_layout
  end
  
  get :proposicoes_periodo, :map => '/proposicao/periodo' do
    last_days = params[:dias] ||= 10
    @proposicoes = Proposicao.most_up_to_date_proposicoes :skip => skip_value, :limit => DataPage.default_page_size, :last_days => last_days.to_i
    @total = Proposicao.count_most_up_to_date_proposicoes last_days.to_i
    
    render 'proposicao/proposicoes_periodo'
  end
  
  get :consulta do
    options = {:skip => skip_value, :limit => DataPage.default_page_size, :tags => get_tags_without_stopwords(params[:prop_tags])}
    @proposicoes, @total = Proposicao.search options
    
    render 'proposicao/consulta', :layout => get_layout
  end
  
  get :index, :with => :id do
    @proposicao = Proposicao.where(:_id => params[:id].to_i).first
    redirect '/404' unless @proposicao
    @dados_prop = proposicao_dados_complementares @proposicao.id

    render 'proposicao/dados_proposicao', :layout => get_layout
  end
  
  get :votacoes, :map => '/proposicao/:proposicao/votacoes' do
    @proposicao = Proposicao.where(:_id => params[:proposicao].to_i).first
    redirect '/404' unless @proposicao
    
    @dados_votacoes = votacoes_proposicao(@proposicao)
    
    render 'proposicao/votacoes', :layout => get_layout
  end
  
  get :relatorio_votacao, :with => [:proposicao, :votacao] do
    @proposicao = Proposicao.where(:_id => params[:proposicao].to_i).first
    redirect '/404' unless @proposicao

    @dados_votacoes = votacoes_proposicao(@proposicao)
    file = "tmp/Votacoes_Proposicao_#{@proposicao.sigla}-#{@proposicao.numero}-#{@proposicao.ano}.pdf"
    
    unless @dados_votacoes[:url]
      generate_votting_pdf file, @dados_votacoes, params[:votacao]
      send_file file, :filename => file, :type => 'Application/octet-stream'
    end
  end
end
