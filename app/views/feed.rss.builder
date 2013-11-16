xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do
    xml.title "Res Publica"
    xml.description "Sistema de consulta dos dados abertos da Câmara dos Deputados do Brasil."
    xml.link "http://res-publica.herokuapp.com/#{url(:feed)}"

    for noticia in @noticias
      xml.item do
        xml.title noticia.texto
        xml.description noticia.texto
        xml.pubDate time_to_date_s noticia.data
        xml.link noticia.url
      end
    end
  end
end
