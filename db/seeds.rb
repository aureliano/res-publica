# encoding: utf-8

start_time = Time.now
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

shell.say 'Populando base de dados do projeto'
shell.say ''

shell.say "Carregando dados de 'partido' do arquivo 'db/partidos_data.xml'"
Partido.delete_all

doc = Nokogiri::XML(File.open('db/partidos_data.xml'))
doc.xpath('//partidos/partido').each do |e|
  nodes = e.children
  Partido.create :sigla => nodes[3].content, :nome => nodes[5].content, :data_extincao => nodes[9].content.strip
end

shell.say "Carregando dados de 'comissão' do arquivo 'db/deputados_data.xml'"
Comissao.delete_all

doc = Nokogiri::XML(File.open('db/deputados_data.xml'))
comissoes = {}
doc.xpath('//comissao').each do |e|
  comissoes[e['sigla']] = e['nome']
end

comissoes.each {|sigla, nome| Comissao.create :sigla => sigla, :nome => nome }
comissoes = nil

shell.say "Carregando dados de 'deputado' do arquivo 'db/deputados_data.xml'"
Deputado.delete_all

doc = Nokogiri::XML(File.open('db/deputados_data.xml'))
fields = Deputado.new.inspect.scan(/[\w\d]+:/).delete_if {|e| e == '_id:' || e == '_type:' || e == 'comissoes_titular:' || e == 'comissoes_suplente:' }
doc.xpath('//deputado').each do |e|
  d = Deputado.new
  fields.each do |field|
    field.sub! /:/, ''
    tag = (field.include? '_') ? (field.sub /_[\w\d]/, field[field.index('_') + 1].upcase) : field
    d.send(field + '=', /<#{tag}>.+<\/#{tag}>/.match(e.to_s).to_s.gsub(/(<#{tag}>|<\/#{tag}>)/, ''))
  end
  
  tags = e.at_xpath('//comissoes/titular').to_s.scan /sigla="[\w\d]+"/
  d.comissoes_titular = []
  tags.each {|c| d.comissoes_titular << /"[\w\d]+"/.match(c).to_s.gsub(/"/, '') }
  
  tags = e.at_xpath('//comissoes/suplente').to_s.scan /sigla="[\w\d]+"/
  d.comissoes_suplente = []
  tags.each {|c| d.comissoes_suplente << /"[\w\d]+"/.match(c).to_s.gsub(/"/, '') }
  
  d.save
end

shell.say "Carregando dados de 'bancada' do arquivo 'db/bancadas_data.xml'"
Bancada.delete_all

text = File.read 'db/bancadas_data.xml'
doc = Nokogiri::XML(text)
text.scan(/sigla="[\w\d]+"/).each do |b|
  b = /"[\w\d]+"/.match(b).to_s.gsub(/"/, '')
  bancada = Bancada.new
  bancada.nome = b
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

shell.say ''

shell.say 'Povoamento da base de dados concluído'

shell.say 'Tempo gasto: ' + elapsed_time(start_time, Time.now)
