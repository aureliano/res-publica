xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   "Res Publica"
  xml.link    "rel" => "self", "href" => 'http://res-publica.herokuapp.com'
  xml.id      url(:feed)
  xml.updated @noticias.last.data.strftime "%Y-%m-%dT%H:%M:%SZ" if @noticias.any?
  xml.author  { xml.name "Res Publica" }

  @noticias.each do |noticia|
    xml.entry do
      xml.title   noticia.texto
      xml.link    "rel" => "alternate", "href" => noticia.url
      xml.id      noticia.url
      xml.author  { xml.name 'Res Publica' }
    end
  end
end
