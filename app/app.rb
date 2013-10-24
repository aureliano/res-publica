# encoding: utf-8

module CdOrganizacional
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Helpers

    get :index do
      render :index
    end

    get :sobre do
      render :sobre
    end
    
    get :changelog, :map => '/log/versao/todas' do
      render :changelog
    end
  
    error 404 do
      redirect '/404'
    end
    
    get '/404' do
      File.read 'app/views/404.html.erb'
    end
  
  end
end
