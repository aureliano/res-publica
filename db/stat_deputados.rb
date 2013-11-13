map = %Q{
  function() {
    emit({uf:this.uf}, 1);
  }
}

reduce = %Q{
  function (key, values) {
    var sum = 0;
    values.forEach(function (v) {
      sum += v;
    });
    
    return sum;
  }
}

DeputadoUfStat.delete_all
collection = Deputado.collection.map_reduce(map, reduce, :out => 'mr_uf_stat')
documents = collection.find.map do |c| {:uf => c['_id']['uf'], :total => c['value']} end
collection.drop

while !documents.empty? do
  data = documents.slice! 0, BUCKET_SIZE
  DeputadoUfStat.collection.insert data
end

documents = nil
GC.start

########################################

map = %Q{
  function() {
    emit({sexo:this.sexo}, 1);
  }
}

DeputadoSexoStat.delete_all
collection = Deputado.collection.map_reduce(map, reduce, :out => 'mr_sexo_stat')
documents = collection.find.map do |c| {:sexo => c['_id']['sexo'], :total => c['value']} end
collection.drop

while !documents.empty? do
  data = documents.slice! 0, BUCKET_SIZE
  DeputadoSexoStat.collection.insert data
end

documents = nil
GC.start

########################################

map = %Q{
  function() {
    emit({uf:this.uf, sexo:this.sexo}, 1);
  }
}

DeputadoUfSexoStat.delete_all
collection = Deputado.collection.map_reduce(map, reduce, :out => 'mr_uf_sexo_stat')
documents = collection.find.map do |c| {:uf => c['_id']['uf'], :sexo => c['_id']['sexo'], :total => c['value']} end
collection.drop

while !documents.empty? do
  data = documents.slice! 0, BUCKET_SIZE
  DeputadoUfSexoStat.collection.insert data
end

documents = nil
GC.start

########################################

map = %Q{
  function() {
    emit({uf:this.uf, partido:this.partido}, 1);
  }
}

DeputadoUfPartidoStat.delete_all
collection = Deputado.collection.map_reduce(map, reduce, :out => 'mr_uf_partido_stat')
documents = collection.find.map do |c| {:uf => c['_id']['uf'], :partido => c['_id']['partido'], :total => c['value']} end
collection.drop

while !documents.empty? do
  data = documents.slice! 0, BUCKET_SIZE
  DeputadoUfPartidoStat.collection.insert data
end

documents = nil
GC.start
