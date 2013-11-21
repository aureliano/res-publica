# encoding: utf-8

ResPublica::App.helpers do

  def tipos_proposicao
    APP[:tipos_proposicoes].map do |k, v|
      "#{k}-#{v}"
    end.join ', '
  end
end
