# encoding: utf-8

require 'csv'

start_time = $data_preparation_start.nil? ? Time.now : $data_preparation_start
BUCKET_SIZE = 100

def elapsed_time(t1, t2)
  diff = (t2 - t1)
  s = (diff % 60).to_i
  m = (diff / 60).to_i
  h = (m / 60).to_i

  if s > 0
    "#{(h < 10) ? '0' + h.to_s : h}:#{(m < 10) ? '0' + m.to_s : m}:#{(s < 10) ? '0' + s.to_s : s}"
  else
    format("%.5f", diff) + " milisegundos."
  end
end

def load_data_from_file(file)
  data = [[]]
  File.open(file, 'r').each_line do |line|
    data << line.split(';')
  end

  data
end

def load_data_from_csv(file)
  data = Array.new
  text = File.read(file)  
  csv = CSV.parse(text, :headers => true, :force_quotes => true, :col_sep => ';')
  columns = csv.headers
  
  csv.each do |row|
    row_data = Hash.new
    columns.each do |column|
      row_data[column] = row[column]
    end
    
    data << row_data
  end
  
  data
end

def replace_special_characters(text)
  return text if text.nil?
  
  txt = text.dup
  APP[:special_characters].each {|k, v| txt.gsub! /#{k}/, v }
  txt.gsub! /[()]/, ''
  txt
end

def get_tags_without_stopwords(text)
  txt = replace_special_characters text
  return txt if txt.nil?
  
  tags = txt.downcase.split(/[\s\/]/)
  tags.delete_if {|t| APP[:stopwords].include? t }
end

def create_tags(fields)
  tags = []
  
  fields.each do |field|
    tokens = get_tags_without_stopwords(field)
    tokens.delete_if {|t| tags.include? t }
    tags.concat tokens
  end
  
  tags
end

shell.say 'Populando base de dados do projeto'
shell.say ''

shell.say "Carregando dados de 'partido' do arquivo 'db/partidos_data.xml'"
Partido.delete_all

partidos = YAML.load_file 'db/partidos.yml'
doc = Nokogiri::XML(File.open('db/partidos_data.xml'))
doc.xpath('//partidos/partido').each do |e|
  nodes = e.children
  sigla = nodes[3].content
  p = partidos[sigla]
  partido = Partido.new :_id => sigla, :nome => nodes[5].content, :data_extincao => nodes[9].content.strip
  
  unless p.nil?
    partido.numero = p['numero']
    partido.data_registro_tse = p['data_registro_tse']
    partido.sitio = p['sitio']
    partido.logo = p['logo']
  end
  
  partido.tags = create_tags [partido.numero.to_s, partido._id, partido.nome]
  partido.save
end

shell.say "Carregando dados de 'comissão' do arquivo 'db/deputados_data.xml'"
Comissao.delete_all

doc = Nokogiri::XML(File.open('db/deputados_data.xml'))
comissoes = {}
doc.xpath('//comissao').each do |e|
  comissoes[e['sigla']] = e['nome']
end

comissoes.each {|sigla, nome| Comissao.create :_id => sigla, :nome => nome, :tags => create_tags([sigla, nome]) }
comissoes = nil

shell.say "Carregando dados de 'deputado' do arquivo 'db/deputados_data.xml'"
Deputado.delete_all

detalhamento = YAML.load_file 'db/deputados_detalhamento.yml'
fields = Deputado.new.inspect.scan(/[\w\d]+:/).delete_if {|e|
  e == '_id:' || e == '_type:' || e == 'comissoes_titular:' || e == 'comissoes_suplente:' || e == 'tags:' ||
  e == 'profissao:' || e == 'data_nascimento:' || e == 'periodos_exercicio:' || e == 'filiacoes_partidarias:'
}
count = 1
doc.xpath('//deputado').each do |e|
  d = Deputado.new
  fields.each do |field|
    field.sub! /:/, ''
    tag = (field.include? '_') ? (field.sub /_[\w\d]/, field[field.index('_') + 1].upcase) : field
    d.send(field + '=', /<#{tag}>.+<\/#{tag}>/.match(e.to_s).to_s.gsub(/(<#{tag}>|<\/#{tag}>)/, ''))
  end
  
  tags = e.at_xpath("//deputado[#{count}]/comissoes/titular").to_s.scan /sigla="[\w\d]+"/
  d.comissoes_titular = []
  tags.each {|c| d.comissoes_titular << /"[\w\d]+"/.match(c).to_s.gsub(/"/, '') }

  tags = e.at_xpath("//deputado[#{count}]/comissoes/suplente").to_s.scan /sigla="[\w\d]+"/
  d.comissoes_suplente = []
  tags.each {|c| d.comissoes_suplente << /"[\w\d]+"/.match(c).to_s.gsub(/"/, '') }

  d.tags = create_tags([d.nome, d.nome_parlamentar])
  
  hash = detalhamento[d.ide_cadastro.to_s]

  d.profissao = hash[:profissao]
  d.data_nascimento = hash[:data_nascimento]
  d.periodos_exercicio = hash[:periodosExercicio]
  d.filiacoes_partidarias = hash[:filiacoesPartidarias]
  
  d.save
  count += 1
end
detalhamento = nil

shell.say "Carregando dados de 'bancada' do arquivo 'db/bancadas_data.xml'"
Bancada.delete_all

text = File.read 'db/bancadas_data.xml'
doc = Nokogiri::XML(text)
text.scan(/sigla="[\w\d]+"/).each do |b|
  b = /"[\w\d]+"/.match(b).to_s.gsub(/"/, '')
  bancada = Bancada.new
  bancada._id = b
  bancada.nome = doc.xpath("//bancada[@sigla=\"#{b}\"]")[0][:nome]
  bancada.lider = doc.xpath("//bancada[@sigla=\"#{b}\"]/lider/nome").to_s.gsub /(<nome>|<\/nome>)/, ''

  bancada.vice_lideres = []
  doc.xpath("//bancada[@sigla=\"#{b}\"]/vice_lider/nome").children.each do |e|
    bancada.vice_lideres << e.to_s
  end
  
  representante = doc.xpath("//bancada[@sigla=\"#{b}\"]/representante/nome").to_s.gsub /(<nome>|<\/nome>)/, ''
  if !representante.empty?
    bancada.representante = representante
    bancada.lider = nil
    bancada.vice_lideres.clear
  end
  
  bancada.save
end

shell.say "Carregando dados de 'proposição' do arquivo 'db/proposicoes_db.csv'"

data = load_data_from_csv 'db/proposicoes_db.csv'
data.each do |row|
  tags = get_tags_without_stopwords row['tags']
  tags.concat get_tags_without_stopwords row['autor']
  tags.concat [row['sigla'].downcase, row['numero'], row['ano']]
  
  Proposicao.create :id_cadastro => row['id'], :nome => row['nome'],
                    :sigla => row['sigla'], :numero => row['numero'], :ano => row['ano'],
                    :autor => row['autor'], :tags => tags
end

shell.say "Carregando dados de 'despesas' do arquivo 'db/despesas_ano_corrente_db.csv'"
Despesa.delete_all

['db/despesas_ano_corrente_db.csv'].each do |f|
  documents = []
  load_data_from_file(f).each do |row|
    documents << { :descricao_despesa => row[0], :nome_beneficiario => row[1],
                   :identificador_beneficiario => row[2], :data_emissao => row[3].to_s.sub(/T00:00:00/, ''),
                   :valor_documento => row[4].to_f, :valor_glosa => row[5].to_f,
                   :valor_liquido => row[6].to_f, :mes => row[7].to_i,
                   :ano => row[8].to_i, :id_deputado => row[9].to_i }
  end

  while !documents.empty? do
    data = documents.slice! 0, BUCKET_SIZE
    Despesa.collection.insert data
  end
end
Despesa.delete_all :conditions => { :id_deputado => 0 }

shell.say 'Apagando coleção de dados de Votações'
Votacoes.delete_all

shell.say ''

shell.say 'Criando dados agregados de Deputados'
load('db/stat_deputados.rb')

shell.say 'Criando dados agregados de Proposições'
load('db/stat_proposicoes.rb')

shell.say ''

shell.say 'Povoamento da base de dados concluído'

shell.say 'Tempo gasto: ' + elapsed_time(start_time, Time.now)
