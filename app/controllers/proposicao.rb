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
  
  get :proposicao_votacoes, :with => :id do
    @proposicao = Proposicao.where(:_id => params[:id]).first
    redirect '/404' unless @proposicao

    @dados_votacoes = votacoes_proposicao(@proposicao)
    file = "tmp/Votacoes_Proposicao_#{@proposicao.sigla}-#{@proposicao.numero}-#{@proposicao.ano}.pdf"
    
    if @dados_votacoes[:url]
      redirect url(:proposicao, :index, :id => @proposicao.id, :url_votacoes => @dados_votacoes[:url])
    else
      generate_votting_pdf file, @dados_votacoes
      send_file file, :filename => file, :type => 'Application/octet-stream'
    end
  end
end
