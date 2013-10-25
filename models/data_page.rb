class DataPage

  def self.default_page_size
    10
  end

  def initialize(options)
    @page_size = options[:page_size] ||= DataPage.default_page_size
    @total = options[:total]
    @data = options[:data]

    @pages = @total / @page_size
    @pages = ((@total % @page_size == 0) ? @pages : (@pages + 1))

    options[:page] ||= 1
    options[:page] = @pages if options[:page] > @pages
    options[:page] = 1 if options[:page] <= 0
    
    @page_index = options[:page]
    @current_page_block = set_current_page_block
  end
  
  attr_reader :total, :page_index, :page_size, :pages, :data, :current_page_block
  attr_writer :page_index, :data
  
  def has_next_page?
    @page_index < @pages
  end
  
  def has_previous_page?
    @page_index > 1
  end
  
  def has_page_index?(index)
    ((@pages >= index) && (index > 0))
  end
  
  def next_page
    return (@page_index + 1) if has_next_page?
    @page_index
  end
  
  def previous_page
    return (@page_index - 1) if has_previous_page?
    @page_index
  end
  
  def has_previous_pagination_block?
    block = @current_page_block
    (block.begin > @page_size)
  end
  
  def has_next_pagination_block?
    block = @current_page_block
    (block.end < @pages)
  end
  
  def previous_block_page
    return (@page_index - @page_size) if has_previous_pagination_block?
    @page_index
  end
  
  def next_block_page
    if has_next_pagination_block?
      page = @page_index + @page_size
      while(!has_page_index? page) do
        page -= 1
      end
      
      return page
    end
    
    @page_index
  end
  
  private
    def set_current_page_block
      min = (@page_index / @page_size)
      if (@page_index % @page_size) > 0
        min = (min == 0) ? 1 : (min * @page_size + 1)
      else
        min = min * @page_size - (@page_size - 1)
      end
      max = (min + @page_size - 1)
      max = (max - (max - @pages)) if max > @pages

      min..max
    end
  
end
