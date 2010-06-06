require File.expand_path('../../spec_helper', __FILE__)

describe Tweet, "create" do
  it "should be inserted to the item list in order by created_at"
end

describe Tweet, "content" do
  it "should auto-link text"
  it "should escape tweet text"
end
