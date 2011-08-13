require 'uri'
require 'net/http'

Kernel.load('fetch_uri.rb')

class Module_Youtube
  def init_module(bot) end
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if youtube_id = get_youtube_id(word)
        youtube_title = get_formatted_title(youtube_id)
        bot.send_privmsg(reply_to, youtube_title) if youtube_title
      end
    }
  end
  def botmsg(bot,target,msg) end

  private

  def get_youtube_id(word)
    if word =~ /youtube.com\/watch?/
      uri = URI.parse(word)
      if uri.host =~ /.*youtube\.com/
        uri.query.match(/v=([^ &]*)/)[0][2,15]
      else
        nil
      end
    elsif word =~ /http:\/\/youtu.be\/(.*)/
      URI.parse(word).path.match(/\/([a-zA-Z0-9]+)/)[1]
    else
      nil
    end
  end

  def get_formatted_title(video_id)
    api_url = "http://gdata.youtube.com/feeds/api/videos/" + video_id + "?v=2"
    print "Fetching " + api_url + "\n"
    begin
      reply = fetch_uri(api_url)
      reply.code == "200" ? format_title(reply.body) : nil
    rescue => e
      p "Error fetching: #{e.to_s}"
      nil
    end
  end

  def format_title(content)
    title = get_title(content)
    rating_str = get_preferred_rating_string(content)
    views = get_views(content)
    "#{title} (rating: #{rating_str}, views: #{views})"
  end

  def get_preferred_rating_string(content)
    likes_and_dislikes = get_likes_and_dislikes(content)
    likes_and_dislikes ? likes_and_dislikes : get_numeric_rating(content)
  end

  def get_likes_and_dislikes(content)
    if content =~ /<yt:rating numDislikes='([0-9]+)' numLikes='([0-9]+)'\/>/
      num_dislikes = $1.to_i
      num_likes = $2.to_i
      "#{num_likes} likes, #{num_dislikes} dislikes"
    else
      nil
    end
  end
  def get_numeric_rating(content)
    if content =~ /.*<gd:rating average='([0-9.]*)'.*/
      num_raters = $1 if reply.body =~ /.*numRaters='([0-9]*)'.*/
      value_in_two_digits = ((rating.to_f * 100).round).to_f / 100
      "#{value_in_two_digits} (#{num_raters})"
    else
      nil
    end
  end

  def get_title(content)
    content =~ /.*<title[^>]*>(.*)<\/title>.*/ ? $1 : "?"
  end
  def get_views(content)
    content =~ /.*<yt:statistics favoriteCount='[0-9]*' viewCount='([0-9]*)'\/>.*/ ? $1 : "?"
  end
end

