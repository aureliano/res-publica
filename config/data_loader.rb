# encoding: utf-8

module Boot

  def load_stop_words
    File.read('stopwords').split "\n"
  end
  
  def load_special_characters
    {
      'á' => 'a', 'Á' => 'A',
      'é' => 'e', 'É' => 'E',
      'í' => 'i', 'Í' => 'I',
      'ó' => 'o', 'Ó' => 'O',
      'ú' => 'u', 'Ú' => 'U',
      'ã' => 'a', 'Ã' => 'A',
      'õ' => 'o', 'Õ' => 'O',
      'â' => 'a', 'Â' => 'A',
      'ê' => 'e', 'Ê' => 'E',
      'ô' => 'o', 'Ô' => 'O',
      'ü' => 'u', 'Ü' => 'U',
      'ç' => 'c', 'Ç' => 'C',
      'à' => 'a', 'À' => 'A'
    }
  end
  
  def load_states
    {
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
  end
  
end
