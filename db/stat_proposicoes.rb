map = %Q{
  function() {
    emit({sigla:this.sigla, ano:this.ano}, 1);
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

ProposicaoStat.delete_all
collection = Proposicao.collection.map_reduce(map, reduce, :out => 'mr_proposicao_stat')
documents = collection.find.map do |c| {:sigla => c['_id']['sigla'], :ano => c['_id']['ano'], :total => c['value']} end
collection.drop

while !documents.empty? do
  data = documents.slice! 0, BUCKET_SIZE
  ProposicaoStat.collection.insert data
end

documents = nil
GC.start
