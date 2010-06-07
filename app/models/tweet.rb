class Tweet < Item
  property :profile_image_url, :from_user, :to_user_id,
    :tweet_id, :from_user_id, :iso_language_code, :source
  property :metadata, :type => Hash
  property :geo, :type => Hash

  index :from_user, :content, :created_at

  def self.from_data(hash)
    attr_arr = hash.map do |k,v|
      case k
      when "id"
        [:tweet_id, v]
      when "created_at"
        [:created_at, v.to_datetime]
      when "text"
        [:content, v]
      else
        [k.to_sym, v]
      end
    end
    attrs = Hash[*attr_arr.flatten]
    create!(attrs)
  end
end
