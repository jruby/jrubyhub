class Tweet < Item
  property :profile_image_url, :from_user, :to_user_id,
    :tweet_id, :from_user_id, :iso_language_code, :source
  property :metadata, :type => Hash
  property :geo, :type => Hash

  index :from_user, :content, :created_at

  def self.from_data(hash)
    hash['tweet_id'] = hash['id']
    hash['created_at'] = hash['created_at'].to_datetime
    hash['content'] = hash['text']
    hash.delete('id')
    hash.delete('text')
    Tweet.create!(hash)
  end
end
