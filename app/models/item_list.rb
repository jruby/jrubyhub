class ItemList < Neo4j::Model
  has_list :items, :counter => true
  has_one :tail

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
    item_list_nodes = all
    raise "No ItemList found!" if item_list_nodes.empty?
    first_node = nil
    item_list_nodes.each do |node|
      raise "Too many ItemList nodes found!" if first_node
      first_node = node
    end
    first_node
  end

  def self.method_missing(meth,*args,&block)
    instance.send(meth,*args,&block)
  end
end
