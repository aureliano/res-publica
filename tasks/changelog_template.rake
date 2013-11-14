# encoding: utf-8
#
# Tarefa para criação do template de log de versões do sistema.
#
# autor: Aureliano
# data: 24/12/2013

require 'yaml'

namespace :site do

  template_file = 'app/views/changelog.html.erb'
  url = 'https://github.com/aureliano/res-publica/releases/tag/'

  desc 'Atualiza template da página de log de alterações de acordo com o arquivo changelog.yml'
  task :changelog do
    log = YAML.load_file 'changelog.yml'
    text = changelog_template
    
    layers = log.map do |k, v|
      layer = "<a href=\"#{url + k}\">Versão #{k}</a>\n<ul>\n" +
      v.map {|feature| "  <li>#{feature}</li>" }.join("\n") +
      "\n</ul>"

      metadata = YAML.load_file 'metadata.yml'
      layer << "\n<% if @show_full_log %>" if k == metadata['APP_VERSION']
      layer
    end

    layers.last << ("<% else %>\n<%= link_to 'Ver log completo...', url(:changelog, :version => 'todas') %>\n<% end %>")
    text << layers.join("\n<hr/>\n")
    
    File.open(template_file, 'w') {|f| f.write text }
    
    puts "Arquivo de template '#{template_file}' atualizado"
  end
  
  private    
    def changelog_template
      %Q{<% @page_title = 'Log de versão' %>

<% @changelog_ativa = true %>

<div class="hero-unit">
  <h3>Log de versão</h3>
  <p>Acompanhe aqui as alterações realizadas no sítio.</p>
</div>\n\n}
    end

end
