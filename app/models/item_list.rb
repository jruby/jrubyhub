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

  def self.enumerator(limit = nil)
    return Enumerator.new(limit)
  end

  def self.instance
    item_list = Neo4j.ref_node.item_list
    raise "No ItemList found!" if item_list.nil?
    item_list
  end

  def self.method_missing(meth,*args,&block)
    instance.send(meth,*args,&block)
  end

  class Enumerator
    include Enumerable
    def initialize(limit)
      @limit = limit.to_i
      @limit = nil if @limit <= 0
      @current = ItemList.head
    end

    def each
      while @current
        yield @current
        if @limit
          @limit -= 1
          return if @limit <= 0
        end
        @current = @current.next
      end
    end
  end

  private
  def after_create_add_to_ref_node
    Neo4j.ref_node.item_list = self
  end
end
