require File.expand_path('../../spec_helper', __FILE__)

describe Item, "creation" do
  it "should create a new item" do
    item = Item.new
    item.save.should be_true
    Item.find(item.id).should_not be_nil
  end

  it "should become the ItemList.front item" do
    item = Item.create!
    ItemList.head.should == item
  end

  it "should store the creation timestamp" do
    now = DateTime.now
    item = Item.create
    item.created_at.should >= now
  end

  it "should add an item to the front of the list" do
    item = Item.create
    ItemList.head.should == item
  end

  it "should make the first item in the list the back" do
    first_item = Item.create
    ItemList.tail.should == first_item
    Item.create
    ItemList.tail.should == first_item
  end
end

describe Item, "#next" do
  it "should fetch the following item in the list" do
    first_item = Item.create
    second_item = Item.create
    second_item.next.should == first_item
  end

  it "should return nil at the end of the list" do
    first_item = Item.create
    first_item.next.should be_nil
  end
end

describe Item, "#prev" do
  it "should fetch the previous item in the list" do
    first_item = Item.create
    second_item = Item.create
    first_item.prev.should == second_item
  end

  it "should return nil at the front of the list" do
    first_item = Item.create
    first_item.prev.should be_nil
  end
end
