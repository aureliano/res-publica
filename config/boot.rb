# encoding: utf-8

# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

require 'yaml'

APP = {}
metadata = YAML.load_file 'metadata.yml'
APP[:last_extraction_date] = (PADRINO_ENV == 'test') ? Time.now.strftime('%d/%m/%Y') : metadata['LAST_EXTRACTION_DATE']
APP[:app_version] = metadata['APP_VERSION']
metadata = nil

APP[:estados] = {
  'AC' => 'Acre',
  'AL' => 'Alagoas',
  'AM' => 'Amazonas',
  'AP' => 'Amapá',
  'BA' => 'Bahia',
  'CE' => 'Ceará',
  'DF' => 'Distrito Federal',
  'ES' => 'Espírito Santo',
  'GO' => 'Goiás',
  'MA' => 'Maranhão',
  'MG' => 'Minas Gerais',
  'MS' => 'Mato Grosso do Sul',
  'MT' => 'Mato Grosso',
  'PA' => 'Pará',
  'PB' => 'Paraíba',
  'PE' => 'Pernambuco',
  'PI' => 'Piauí',
  'PR' => 'Paraná',
  'RJ' => 'Rio de Janeiro',
  'RN' => 'Rio Grande do Norte',
  'RO' => 'Rondônia',
  'RR' => 'Roraima',
  'RS' => 'Rio Grande do Sul',
  'SC' => 'Santa Catarina',
  'SE' => 'Sergipe',
  'SP' => 'São Paulo',
  'TO' => 'Tocantins'
}

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
