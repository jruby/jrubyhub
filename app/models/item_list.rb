class ItemList < Neo4j::Model
  has_list :items, :counter => true
  has_one :tail
  include AttachedToRefNode

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

  def self.method_missing(meth,*args,&block)
    instance.send(meth,*args,&block)
  end

  def self.enumerator(limit = nil)
    return Enumerator.new(limit)
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
end
