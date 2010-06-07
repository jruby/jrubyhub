module ItemsHelper
  include Twitter::Autolink

  def item_classes(item)
    if item.class == Item
      "item"
    else
      "item #{item.class.css_name}"
    end
  end

  def render_item(item)
    partial = item.class.css_name
    partial = "items/#{partial}" unless controller_name == "items"
    render :partial => partial, :locals => { :item => item }
  end

  def tweet_author(tweet)
    auto_link("@#{tweet.from_user}").html_safe
  end

  def tweet_text(tweet)
    auto_link(tweet.content).html_safe
  end

  def tweet_icon(tweet)
    image_tag(tweet.profile_image_url, :size => '48x48', :alt => tweet.from_user)
  end
end
