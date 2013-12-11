# encoding: utf-8

ResPublica::App.helpers do

  def get_layout
    case request.env['X_MOBILE_DEVICE']
      when /iPhone|iPod|Android/ then 'mobile.html'
      else 'application.html'
    end
  end

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
  
  def css_inline(resource)
    path = 'public/stylesheets/'
    css_file = Dir.entries(path).select {|f| /#{resource}\.css/.match(f) }.first
    "<style>#{File.read(path + css_file).gsub("\n", '').gsub(/\s/, '')}</style>".html_safe
  end
  
  def javascript_inline(resource)
    path = 'public/javascripts/'
    js_file = Dir.entries(path).select {|f| /#{resource}\.js/.match(f) }.first
    "<script>#{File.read(path + js_file).gsub("\n", '')}</script>".html_safe
  end
  
  def format_date(date)
    return '' if date.nil? || date.empty?
    tokens = date.sub(/T\d{2}:\d{2}:\d{2}(.\d{3})?/, '').split '-'
    "#{tokens[2]}/#{tokens[1]}/#{tokens[0]}"
  end
  
  def format_identifier(identifier)
    case identifier.size
      when 11; then format_cpf identifier
      when 14; then format_cnpj identifier
      else identifier
    end
  end
  
  def format_cpf(v)
    "#{v[0, 3]}.#{v[3, 3]}.#{v[6, 3]}-#{v[9, 2]}"
  end
  
  def format_cnpj(v)
    "#{v[0, 2]}.#{v[2, 3]}.#{v[5, 3]}/#{v[8, 4]}-#{v[12, 2]}"
  end
  
  def format_money(value)
    tokens = value.to_s.split '.'
    seed = tokens[0].size / 3
    l = []
    
    count = 0
    tokens[0].reverse.chars.each do |c|
      if (count > 0) && (count % 3 == 0)
        l << '.'
      end
      
      l << c
      count += 1
    end
    
    tokens[1] = '0' if tokens[1].nil?
    r = if tokens[1].size == 1
      "#{tokens[1]}0"
    elsif tokens[1].size > 2
      tokens[1][0, 2]
    else
      tokens[1]
    end
    
    "R$ #{l.reverse.join},#{r}"
  end
  
  def format_date(date)
    return '-' if date.nil?
    date.strftime('%d/%m/%Y')
  end

end
