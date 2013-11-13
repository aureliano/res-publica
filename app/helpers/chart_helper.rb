ResPublica::App.helpers do

  def draw_chart(options)
    options[:chart_container] ||= 'chart_div'
    options[:chart_class] ||= 'PieChart'
    options[:package] = options[:chart_class] == 'GeoChart' ? 'geochart' : 'corechart'
    options[:chart_options] = create_chart_options_var_declaration(:width => options[:width], :height => options[:height], :displayMode => options[:displayMode], :resolution => options[:resolution])
    options[:listeners] = create_add_listeners_call(options[:listeners]) if options[:listeners]

    chart_template(options)
  end
  
  private
    def chart_template(options)
      <<-eos
  <!--Load the AJAX API-->
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
  <script type="text/javascript">

    // Load the Visualization API and the piechart package.
    google.load('visualization', '1.0', {'packages':['#{options[:package]}']});

    // Set a callback to run when the Google Visualization API is loaded.
    google.setOnLoadCallback(drawChart);

    // Callback that creates and populates a data table,
    // instantiates the chart, passes in the data and
    // draws it.
    function drawChart() {

      // Create the data table.
      #{create_data_table options}

      // Instantiate and draw the chart, passing in some options.
      var chart = new google.visualization.#{options[:chart_class]}(document.getElementById('#{options[:chart_container]}'));
      chart.draw(data, #{options[:chart_options]});
      #{options[:listeners]}
    }
  </script>
      eos
    end
    
    def create_chart_options_var_declaration(options)
      options[:width] ||= 400
      options[:height] ||= 300
      options[:region] ||= 'BR'
      text = "{ "
      
      props = options.map do |k, v|
        "#{k}: '#{v}'"
      end
      
      text << "#{props.join(', ')} }"
    end
    
    def create_add_listeners_call(listeners)
      listeners.map do |listener|
        %Q{google.visualization.events.addListener(chart, '#{listener[:event]}', #{listener[:handler]});}
      end.join "\n"
    end
    
    def create_data_table(options)
      if options[:columns]
        columns = options[:columns].map {|col| "data.addColumn('#{col[0]}',  '#{col[1]}', '#{col[2]}');" }.join("\n")
        %Q{
          var data = new google.visualization.DataTable();
          #{columns}
          data.addRows(#{options[:data]});
        }
      else
        "var data = google.visualization.arrayToDataTable(#{options[:data]});"
      end
    end

end
