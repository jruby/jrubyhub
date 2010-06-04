require File.expand_path('../../spec_helper', __FILE__)

describe ItemList, "instance" do
  before :each do
    ItemList.all.each {|n| n.del }
  end

  it "should raise an exception if there aren't any ItemList nodes in the DB" do
    lambda { ItemList.instance }.should raise_error
  end

  it "should raise an exception if there are more than one ItemList nodes in the DB" do
    ItemList.new.save; ItemList.new.save
    lambda { ItemList.instance }.should raise_error
  end

  it "should return the sole instance in the DB" do
    il = ItemList.new
    il.save
    ItemList.instance.should == il
  end
end

describe ItemList, "empty?" do
  before :each do
    ItemList.new.save
  end

  it "should be empty when no items have been added" do
    ItemList.should be_empty
  end

  it "should not be empty when at least one item has been added" do
    ItemList << Item.create
    ItemList.should_not be_empty
  end
end

describe ItemList, "<<" do
  before :each do
    ItemList.new.save
  end

  it "should add an item to the front of the list" do
    item = Item.create
    ItemList << item
    ItemList.head.should == item
  end

  it "should make the first item in the list the back" do
    ItemList << (first_item = Item.create)
    ItemList.tail.should == first_item
    ItemList << Item.create
    ItemList.tail.should == first_item
  end
end
