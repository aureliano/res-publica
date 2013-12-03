# encoding: utf-8

ResPublica::App.helpers do

  def format_get_params(params)
    params.sub /\s/, '+'
  end
  
  def pagination_page_index
    value = params[:page] ||= 1
    page = value.to_i
    page = 1 if page < 1
    
    page
  end
  
  def skip_value(limit=nil)
    limit ||= DataPage.default_page_size
    ((pagination_page_index - 1) * limit)
  end
  
  def time_to_date_s(time)
    return '-' if time.nil?
    time.strftime '%d/%m/%Y'
  end
  
  def bool_to_s(bool)
    (bool) ? 'Sim' : 'Não'
  end
  
  def get_tags_without_stopwords(text)
    return [] if text.nil?
    text = replace_special_characters text
    tags = text.split(/\s/)
    tags.each {|tag| tag.downcase! }
    tags.delete_if {|t| APP[:stopwords].include? t }
  end
  
  def replace_special_characters(text)
    return text if text.nil?
    
    txt = text.dup
    APP[:special_characters].each {|k, v| txt.gsub! /#{k}/, v }
    txt.gsub! /[()]/, ''
    txt
  end
  
  def send_email
    @message = Message.new :name => params[:name], :email => params[:email],
      :subject => params[:subject], :body => params[:message]
    
    unless recaptcha_valid?
      @message.errors << 'Caracteres da imagem digitados incorretamente!'
    end
    
    if @message.valid? && PADRINO_ENV != 'test'
      deliver :contato, :email, @message
    end
    
    @message.valid?
  end

end
