module DBHelpers
  def txn
    Neo4j::Transaction.new
    yield
  ensure
    Neo4j::Transaction.finish if Neo4j::Transaction.running?
  end

  def reset_db!
    begin
      ::Neo4j::Transaction.run do
        ::Neo4j.all_nodes do |node|
          node.del unless node == Neo4j.ref_node || Neo4j::IndexNode === node
        end
        ::Neo4j.ref_node[:db_version] = 0
      end
      ::Neo4j::Transaction.run do
        ::Neo4j.migrate!
      end
    rescue Exception => e
      puts "Exception resetting DB: #{e.inspect}"
      puts "  " + e.backtrace.join("\n  ")
    end
  end
end

World(DBHelpers)
