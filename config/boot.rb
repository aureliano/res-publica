# encoding: utf-8

# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

require 'yaml'
require File.expand_path '../data_loader.rb', __FILE__

include Boot

APP = {}
APP[:numero_legislatura] = ((Time.now.year - 1795) / 4).to_i
APP[:periodo_legislatura] = "#{(APP[:numero_legislatura] * 4 + 1795)} - #{(APP[:numero_legislatura] * 4 + 1795 + 3)}"

APP[:tipos_proposicoes] = { :MPV => 'Medida Provisória', :PEC => 'Proposta de Emenda à Constituição', :PL => 'Projeto de Lei', :PLP => 'Projeto de Lei Complementar' }

metadata = YAML.load_file 'metadata.yml'
APP[:last_extraction_date] = (PADRINO_ENV == 'test') ? Time.now.strftime('%d/%m/%Y') : metadata['LAST_EXTRACTION_DATE']
APP[:app_version] = metadata['APP_VERSION']
APP[:date_init_prop] = metadata['ANO_INICIAL_EXTRACAO_PROPOSICOES']
APP[:date_end_prop] = (metadata['ANO_FINAL_EXTRACAO_PROPOSICOES'].to_i == -1) ? Time.now.year : metadata['ANO_FINAL_EXTRACAO_PROPOSICOES']
metadata = nil

# load project environment variables
YAML.load_file('.env').each {|k, v| ENV[k] = v } if PADRINO_ENV != 'production' && File.exist?('.env')

APP[:stopwords] = load_stop_words
APP[:special_characters] = load_special_characters
APP[:estados] = load_states

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

##
# Add your before (RE)load hooks here
#
Padrino.before_load do
end

##
# Add your after (RE)load hooks here
#
Padrino.after_load do
end

Padrino.load!
