require File.expand_path('../../spec_helper', __FILE__)

describe TweetSpider, "instance" do
  it "should return the instance" do
    TweetSpider.instance.should be_instance_of(TweetSpider)
  end
end

describe TweetSpider, "#fetcher" do
  it "should return a TwitterFetcher by default" do
    TweetSpider.new.fetcher.should be_instance_of(TweetSpider::TwitterFetcher)
  end

  it "should put query in the URI by default" do
    TweetSpider.new(:query => "jruby").fetcher.uri.should == "?q=jruby"
  end

  it "should put refresh_url in the URI if it's present" do
    refresh_url = "?since_id=15501743592&q=jruby"
    TweetSpider.new(:query => "jruby", :refresh_url => refresh_url).fetcher.uri.should == refresh_url
  end
end

describe TweetSpider, "#fetch_tweet_data" do
  before :each do
    @ts = TweetSpider.new
  end
  it "should load tweets and return a converted JSON tweet structure" do
    @ts.fetcher = TweetSpider::FileFetcher.new(File.expand_path('../../fixtures/tweets.json', __FILE__))
    results = @ts.fetch_tweet_data
    results["query"].should == "jruby"
    results["results"].should be_instance_of(Array)
    results["results"].length.should == 15
  end

  it "should convert created_at times into Time objects" do
    @ts.fetcher = TweetSpider::FileFetcher.new(File.expand_path('../../fixtures/tweets.json', __FILE__))
    results = @ts.fetch_tweet_data
    results["results"].each {|h| h["created_at"].should be_instance_of(Time) }
  end

  it "should return a copy of its own properties when an exception is raised" do
    @ts = TweetSpider.create :query => "jruby", :since_id => 0, :max_id => 10000000000
    @ts.fetcher = mock "fetcher"
    @ts.fetcher.stub!(:read).and_raise "error"
    results = @ts.fetch_tweet_data
    results["query"].should == @ts.query
    results["since_id"].should == @ts.since_id
    results["max_id"].should == @ts.max_id
  end
end

describe TweetSpider, "#load_tweets" do
  before :each do
    @ts = TweetSpider.create :query => "jruby"
  end

  it "should create a Tweet for each tweet in the result" do
    @ts.fetcher = TweetSpider::FileFetcher.new(File.expand_path('../../fixtures/tweets.json', __FILE__))
    @ts.load_tweets
    Tweet.all.to_a.length.should == 15
  end

  it "should set up a fetcher for the next page" do
    hash = {"query" => "jruby", "max_id" => 10, "since_id" => 0,
      "next_page" => "?hello", "page" => 1, "refresh_url" => "?since_id=15501743592&q=jruby"}
    @ts.fetcher = mock "fetcher"
    @ts.fetcher.stub!(:read).and_return hash.to_json
    @ts.load_tweets(1)
    @ts.fetcher.uri.should == hash["next_page"]
    @ts.refresh_url.should == hash["refresh_url"]
    @ts.max_id.should == hash["max_id"]
    @ts.since_id.should == hash["since_id"]
  end
end
