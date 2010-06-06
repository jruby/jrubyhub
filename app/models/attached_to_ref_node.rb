module AttachedToRefNode
  def self.included(klass)
    ::Neo4j::ReferenceNode.has_one(klass.name.underscore.to_sym).to(klass)
    klass.after_create :after_create_add_to_ref_node
    klass.instance_eval do
      def instance
        obj = Neo4j.ref_node.send(name.underscore.to_sym)
        raise "No #{name} found!" if obj.nil?
        obj
      end
    end
  end

  private
  def after_create_add_to_ref_node
    Neo4j.ref_node.send("#{self.class.name.underscore}=".to_sym, self)
  end
end
