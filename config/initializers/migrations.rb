module JRubyHub
  Migrations = []

  def self.migration(name,&block)
    Migrations << [name,block]
    Neo4j.migration(Migrations.length, name, &block)
  end

  migration "create ItemList" do
    up do
      ItemList.create!
    end
    down do
      ItemList.all.each {|il| il.destroy }
    end
  end

  migration "create TweetSpider" do
    up do
      TweetSpider.create!(:query => "jruby")
    end
    down do
      TweetSpider.all.each {|ts| ts.destroy }
    end
  end
end
