module DBHelpers
  def txn
    Neo4j::Transaction.new
    yield
  ensure
    Neo4j::Transaction.finish if Neo4j::Transaction.running?
  end
end

World(DBHelpers)
