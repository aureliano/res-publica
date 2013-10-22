# Connection.new takes host, port
host = 'localhost'
port = Mongo::Connection::DEFAULT_PORT

database_name = case Padrino.env
  when :development then 'programas_siconv_development'
  when :production  then 'heroku_app9631427'
  when :test        then 'programas_siconv_test'
end

Mongoid.database = if Padrino.env == :production
  Mongo::Connection.from_uri(ENV['MONGOLAB_URI']).db(database_name)
else
  Mongo::Connection.new(host, port).db(database_name)
end
