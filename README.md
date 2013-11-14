res-publica
=================

Apresenta estrutura organizacional da Câmara de Deputados do Brasil: deputados, partidos etc.

Sítio da web: http://res-publica.herokuapp.com/

Instalação
----------
Para orientações detalhadas da configuração do ambiente de desenvolvimento visite a página [Preparação do ambiente de desenvolvimento](https://github.com/aureliano/res-publica/wiki/Prepara%C3%A7%C3%A3o-do-ambiente-de-desenvolvimento).

Pré-requisitos:
- [Ruby] (http://www.ruby-lang.org)
- [Bundler] (http://gembundler.com)
- [MongoDB] (http://www.mongodb.org/)

Baixar gems necessárias:
```
bundle install
```

Para orientações detalhadas para execução da aplicação visite a página [Execução da aplicação](https://github.com/aureliano/res-publica/wiki/Execu%C3%A7%C3%A3o-da-aplica%C3%A7%C3%A3o).

Preparar ambiente de trabalho:
```
padrino rake data:fill
```

Iniciar aplicação:
```
padrino start
```
Por favor, visite o site do [Padrino] (http://www.padrinorb.com) para obter mais instruções.
