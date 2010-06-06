class Tweet < Item
  property :profile_image_url, :from_user, :text, :to_user_id,
    :tweet_id, :geo, :from_user_id, :iso_language_code, :source
  property :metadata, :type => Hash

  def self.from_data(hash)
    hash['tweet_id'] = hash['id']
    hash['created_at'] = hash['created_at'].to_datetime
    hash.delete('id')
    Tweet.create!(hash)
  end
end
