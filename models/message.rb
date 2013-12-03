# encoding: utf-8

class Message

  attr_accessor :name, :email, :subject, :body
  attr_reader :errors
  
  def initialize(properties = nil)
    @errors = []
    return if properties.nil?
    @name     = properties[:name]
    @email    = properties[:email]
    @subject  = properties[:subject]
    @body     = properties[:body]
  end
  
  def validation
    @errors = []
    @errors << "O 'Nome' deve ter pelo menos 2 caracteres." if (@name.nil? || @name.size < 2)
    @errors << "O 'e-mail' deve ser válido." unless (@email =~ /[\w\d\.]+@\w+\.\w+/)
    @errors << "O 'Assunto' deve ter pelo menos 3 caracteres." if (@subject.nil? || @subject.size < 3)
    @errors << "O 'Texto' deve ter pelo menos 5 caracteres." if (@body.nil? || @body.size < 5)
    
    @errors
  end
  
  def valid?
    validation if @errors.nil?
    @errors.empty?
  end
  
  def format_message
    text = 'Res Publica'
    text << "\n\nRemetente: #{@name}\ne-mail: #{@email}\n"
    text << "Assunto: #{@subject}\nMensagem: #{@body}"
  end
  
end
