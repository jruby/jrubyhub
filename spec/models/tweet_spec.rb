require File.expand_path('../../spec_helper', __FILE__)

describe Tweet, "create" do
  it "should use the passed-in value for the creation timestamp" do
    time = DateTime.new(2010, 6, 8, 12, 0, 0)
    Tweet.from_data("created_at" => time).created_at.should == time
  end

  it "should be inserted to the item list in order by created_at"
end
