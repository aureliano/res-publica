# encoding: utf-8
#
# Tarefa para publicação de novidades do sítio.
#
# autor: Aureliano
# data: 26/11/2013

namespace :issue do

  PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
  PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)
  Bundler.require(:default, PADRINO_ENV)
  Padrino.load!
  metadata = YAML.load_file 'metadata.yml'
  
  namespace :news do
  
    desc 'Publica nova extração de dados na base para alimentação do RSS e Twitter'
    task :extraction do    
      puts 'Salva nota de extração na base de dados'   
      msg = "#{metadata['LAST_EXTRACTION_DATE']} - Nova extração de dados."     
      save_note_in_database msg, 'extracao'
      
      if PADRINO_ENV == 'production'
        puts 'Publicando notícia no Twitter'
        msg = "Extração de dados abertos da Câmara dos Deputados do Brasil realizada em #{metadata['LAST_EXTRACTION_DATE']}. http://res-publica.herokuapp.com"
        issue_on_twitter msg
        puts "\nPublicação no Twitter concluída\n"
      end
    end
    
    desc 'Publica nova versão do sistema na base para alimentação do RSS e Twitter'
    task :version do
      puts 'Salva nota de nova versão do sistema na base de dados'   
      msg = "#{Time.now.strftime('%d/%m/%Y')} - Nova versão do sistema disponibilizada."     
      save_note_in_database msg, 'versao'
      
      if PADRINO_ENV == 'production'
        puts 'Publicando notícia no Twitter'
        msg = "Nova versão do sistema disponibilizada. http://res-publica.herokuapp.com/log/versao/atual"
        issue_on_twitter msg
        puts "\nPublicação no Twitter concluída\n"
      end
    end
    
    private
    def save_note_in_database(msg, type)
      Noticia.create :texto => msg, :data => Time.now, :tipo => type
      puts 'Remove notícias antigas.'
      Noticia.all.sort {|x, y| x <=> y}.drop(20).each {|doc| doc.delete }
    end
    
    def issue_on_twitter(msg)
      # https://github.com/sferik/twitter
      Twitter.configure do |config|
        config.consumer_key = ENV['CONSUMER_KEY']
        config.consumer_secret = ENV['CONSUMER_SECRET']
        config.oauth_token = ENV['OAUTH_TOKEN']
        config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
      end

      Twitter.update msg
    end
    
  end
  
end
