class Partido
  include Mongoid::Document

  field :sigla, :type => String
  field :numero, :type => Integer
  field :nome, :type => String
  field :data_registro_tse, :type => String
  field :sitio, :type => String
  field :logo, :type => String
  field :data_extincao, :type => String

  def extinto?
    !data_extincao.nil? && !data_extincao.empty?
  end

end
