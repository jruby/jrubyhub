class ItemList < Neo4j::Model
  has_list :items, :counter => true
  has_one :tail
  ::Neo4j::ReferenceNode.has_one(:item_list).to(self)

  after_create :after_create_add_to_ref_node

  def <<(item)
    items << item
    self.tail = item if tail.nil?
    self
  end

  def head
    items.first
  end

  def method_missing(meth,*args,&block)
    return items.send(meth,*args,&block) if items.respond_to?(meth)
    super
  end

  def self.instance
    item_list = Neo4j.ref_node.item_list
    raise "No ItemList found!" if item_list.nil?
    item_list
  end

  def self.method_missing(meth,*args,&block)
    instance.send(meth,*args,&block)
  end

  private
  def after_create_add_to_ref_node
    Neo4j.ref_node.item_list = self
  end
end
