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

end
