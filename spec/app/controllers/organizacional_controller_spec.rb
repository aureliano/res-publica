# encoding: utf-8

require 'spec_helper'

describe "OrganizacionalController" do

  it "carrega página com lista de partido políticos" do
    get '/organizacional/partidos'
    
    last_response.body.should include '<title>Res Publica: Partidos Políticos</title>'
    last_response.body.should include '<form method="get" id="form_consulta" action="/organizacional/partidos" protect_from_csrf="true" accept-charset="UTF-8">'
  end
  
end
