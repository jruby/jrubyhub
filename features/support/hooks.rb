Before do
  ::Neo4j.all_nodes{|node| node.del } if Neo4j.running?
end
