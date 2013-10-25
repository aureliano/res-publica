CdOrganizacional::App.controllers :organizacional do
  
  get :index do
    render 'organizacional/index'
  end
  
  get :partidos do
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
