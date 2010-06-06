require 'uri'
require 'rest_client'

class TweetSpider < Neo4j::Model
  include AttachedToRefNode
  PROPERTIES = [:query, :refresh_url, :since_id, :max_id]
  PAGES_IN_BATCH = 10
  property *PROPERTIES
  attr_writer :fetcher

  def fetch_query
    if refresh_url
      refresh_url
    elsif query
      "?q=#{URI.escape query}"
    end
  end

  def fetcher
    @fetcher ||= TwitterFetcher.new(fetch_query)
  end

  def fetch_tweet_data
    ActiveSupport::JSON.decode(fetcher.read).tap do |result|
      if Array === result["results"]
        result["results"].each do |tweet|
          tweet["created_at"] = Time.rfc2822(tweet["created_at"])
        end
      end
    end
  rescue => e
    Rails.logger.warn "Unable to fetch tweets: #{e.inspect}"
    Rails.logger.debug("  " + e.backtrace.join("\n  "))
    props.dup
  end

  def load_next_page(pages_to_load, data)
    @fetcher = TwitterFetcher.new(data["next_page"]) if data["next_page"]
    if pages_to_load > 1
      next_page_data = fetch_tweet_data
      if next_page_data["results"] && !next_page_data["results"].empty?
        data["results"]  += next_page_data["results"]
        data["next_page"] = next_page_data["next_page"]
        data["page"]      = next_page_data["page"]
        load_next_page(pages_to_load - 1, data)
      end
    end
  end

  def load_tweets(pages_to_load = PAGES_IN_BATCH)
    pages_to_load = PAGES_IN_BATCH if pages_to_load > PAGES_IN_BATCH || pages_to_load < 0
    data = fetch_tweet_data
    load_next_page(pages_to_load - 1, data)
    if data["results"] && !data["results"].empty?
      data["results"].sort_by {|hash| hash["created_at"]}.each {|hash| Tweet.from_data(hash) }
    end
    PROPERTIES.each {|p| self[p] = data[p.to_s]}
    save!
  end

  class FileFetcher
    def initialize(file)
      @file = file
    end

    def read
      File.read(@file)
    end
  end

  class TwitterFetcher
    attr_reader :uri

    def initialize(uri)
      @uri = uri
    end

    def read
      ::RestClient.get("http://search.twitter.com/search.json#{@uri}")
    end
  end
end
