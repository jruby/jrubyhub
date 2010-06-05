require File.expand_path('../../spec_helper', __FILE__)

describe ItemList, "instance" do
  before :each do
    ItemList.all.each {|n| n.del }
  end

  it "should raise an exception if there isn't an ItemList node in the DB" do
    lambda { ItemList.instance }.should raise_error
  end

  it "should remove the reference node's relationship" do
    Neo4j.ref_node.item_list.should be_nil
  end

  it "should return the sole instance in the DB" do
    il = ItemList.create!
    ItemList.instance.should == il
  end
end

describe ItemList, "empty?" do
  it "should be empty when no items have been added" do
    ItemList.should be_empty
  end

  it "should not be empty when at least one item has been added" do
    Item.create
    ItemList.should_not be_empty
  end
end
