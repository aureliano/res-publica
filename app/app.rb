# encoding: utf-8

require 'rack/mobile-detect'

module ResPublica
  class App < Padrino::Application
    register Padrino::Rendering
    register Padrino::Helpers
    register Padrino::Mailer

    use Rack::MobileDetect
    use Rack::Recaptcha, :public_key => '6Lf9NOsSAAAAAJH9B_TD12QhRGjid-wr2FvXMgFu', :private_key => '6Lf9NOsSAAAAALhnWec6fBpumnxK2UKWSV13DSuF'
    helpers Rack::Recaptcha::Helpers
    
    # Configure SMTP mailer
    set :delivery_method, :smtp => { 
      :address              => ENV['EMAIL_SMTP_ADDRESS'],
      :port                 => 587,
      :user_name            => ENV['EMAIL_USER_NAME'],
      :password             => ENV['EMAIL_PASSWORD'],
      :authentication       => :plain,
      :enable_starttls_auto => true
    }

    get :index do
      render :index, :layout => get_layout
    end

    get :sobre do
      render :sobre, :layout => get_layout
    end
    
    get :mapa do
      render :mapa, :layout => get_layout
    end
  
    get :contato do
      render :contato, :layout => get_layout
    end
    
    post '/send_email' do
      if send_email
        redirect '/contato?msg_sent=true'
      else
        render :contato, :layout => get_layout
      end
    end
  
    get :changelog, :map => '/log/versao/:version' do
      @show_full_log = case params[:version]
        when 'atual' then false
        when 'todas' then 'true'
        else redirect '/404'
      end
      
      render :changelog, :layout => get_layout
    end
    
    get :changelog, :map => '/log/versao/todas' do
      render :changelog, :layout => get_layout
    end
    
    get :feed, :provides => [:rss, :atom] do
      @noticias = Noticia.all.desc(:_id)
      render 'feed'
    end
  
    error 404 do
      redirect '/404'
    end
    
    get '/404' do
      File.read 'app/views/404.html.erb'
    end
  
  end
end
