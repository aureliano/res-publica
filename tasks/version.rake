# encoding: utf-8
#
# Tarefa para criação de nova tag no projeto.
#
# autor: Aureliano
# data: 24/10/2013

namespace :site do
  namespace :tag do
    namespace :new do

      desc 'Marca uma tag para uma versão do projeto com novas funcionalidades'
      task :feature do
        tag, new_tag = create_tag_number false      
        puts "Criando tag '#{new_tag}' para novas funcionalidades a partir da tag '#{tag}'"
        exec_cmd new_tag, false
      end
      
      desc 'Marca uma tag para uma versão do projeto com correção de bugs'
      task :bugfix do
        tag, new_tag = create_tag_number true      
        puts "Criando tag '#{new_tag}' para bug fix a partir da tag '#{tag}'"
        exec_cmd new_tag, true
      end
    end
    
    desc 'Remove a tag da última versão do projeto'
    task :delete do
      tag = `git tag`.split("\n").last
      puts "Removendo tag '#{tag}' do repositório local"
      puts `git tag -d #{tag}`
      
      puts "\nRemovendo tag '#{tag}' do repositório remoto"
      puts `git push origin :#{tag}`
    end

  end
  
  private
    def create_tag_number(bug)
      tag = `git tag`.split("\n").last
      new_tag = tag.dup
      
      lindex = (bug) ? 2 : 1
      rindex = (bug) ? -1 : -3
      
      up = new_tag.split('.')[lindex].to_i + 1
      new_tag[rindex] = up.to_s
      
      new_tag[-1] = '0' unless bug
      
      [tag, new_tag]
    end
  
    def exec_cmd(tag, bug)
      message = "Release da versão #{tag}: #{(bug) ? 'bug fix' : 'novas funcionalidades'}"
      puts "Criando tag '#{tag}' no repositório local"
      puts `git tag -a #{tag} -m '#{message}'`
      
      puts "Criando tag '#{tag}' no repositório remoto"
      puts `git push --tags`
    end

end
