require File.expand_path('../../spec_helper', __FILE__)

describe ItemsHelper do
  before :each do
    @tweet = Tweet.new :from_user => "nicksieger",
      :content => "Hello &lt;script&gt;alert(@nicksieger)&lt;/script&gt;",
      :profile_image_url => "http://a3.twimg.com/profile_images/409585603/charles_normal.jpg"
  end

  describe "#tweet_text" do
    it "should auto-link tweet content" do
      tweet_text(@tweet).should =~ /@<a/
    end

    it "should not escape tweet content before auto-linking" do
      tweet_text(@tweet).should =~ /Hello &lt;script&gt;/
    end
  end

  describe "#tweet_author" do
    it "should auto-link the author name" do
      tweet_author(@tweet).should =~ /^@<a/
    end
  end

  describe "#tweet_icon" do
    it "should create an image tag to the profile image" do
      tweet_icon(@tweet).should have_xpath("//img[@src='#{@tweet.profile_image_url}']")
    end
  end

  describe "#item_classes" do
    it "should include the item class" do
      item_classes(Item.new).should == "item"
    end

    it "should include more than one class for subclasses of Item" do
      item_classes(Tweet.new).should == "item tweet"
    end
  end

  describe "#render_item" do
    it "should call render :partial with the css name of the model class" do
      stub!(:controller_name).and_return "items"
      should_receive(:render).and_return do |args|
        args[:partial].should == "tweet"
      end
      render_item(@tweet)
    end

    it "should call include the item prefix if not running under the items controller" do
      stub!(:controller_name).and_return "home"
      should_receive(:render).and_return do |args|
        args[:partial].should == "items/tweet"
      end
      render_item(@tweet)
    end
  end
end


