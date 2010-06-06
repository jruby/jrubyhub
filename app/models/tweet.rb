class Tweet < Item
  include Twitter::Autolink

  property :profile_image_url, :from_user, :text, :to_user_id,
    :tweet_id, :from_user_id, :iso_language_code, :source
  property :metadata, :type => Hash
  property :geo, :type => Hash

  def content
    auto_link(text).html_safe
  end

  def self.from_data(hash)
    hash['tweet_id'] = hash['id']
    hash['created_at'] = hash['created_at'].to_datetime
    hash.delete('id')
    Tweet.create!(hash)
  end
end
