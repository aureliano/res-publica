class Partido
  include Mongoid::Document

  field :sigla, :type => String
  field :nome, :type => String
  field :data_extincao, :type => String

  def extinto?
    !data_extincao.nil? && !data_extincao.empty?
  end

end
