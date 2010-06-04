require File.expand_path('../../spec_helper', __FILE__)

describe Item, "#new" do
  it "should create a new item" do
    item = Item.new
    item.save.should be_true
    Item.find(item.id).should_not be_nil
  end
end
