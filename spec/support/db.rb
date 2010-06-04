module DBHelpers
  def self.included(base)
    base.before(:each) { start_transaction }
    base.after(:each) { reset_transaction }
  end

  def start_transaction
    Neo4j::Transaction.new
  end

  def reset_transaction
    Neo4j::Transaction.failure
    Neo4j::Transaction.finish
  end
end
