class Item < Neo4j::Model
  property :content
  property :created_at, :type => DateTime

  before_create :before_create_set_timestamp
  after_create :after_create_add_to_item_list

  def before_create_set_timestamp
    self.created_at = DateTime.now
  end

  def after_create_add_to_item_list
    ItemList << self
  end
end
