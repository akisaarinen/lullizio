require 'uri'
require 'net/http'

Kernel.load('fetch_uri.rb')

class Module_Youtube
  def init_module(bot) end
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if youtube_id = get_youtube_id(word)
        youtube_title = get_formatted_title(youtube_id)
        bot.send_privmsg(reply_to, youtube_title)
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
    print api_url + "\n"

    reply = fetch_uri(api_url)
    return "" if (reply.code != "200")

    title = "?"
    rating = "?"
    views = "?"

    title = $1 if reply.body =~ /.*<title[^>]*>(.*)<\/title>.*/


    # Prefer likes/dislikes if they exist
    if reply.body =~ /<yt:rating numDislikes='([0-9]+)' numLikes='([0-9]+)'\/>/
      numDislikes = $1.to_i
      numLikes = $2.to_i
      ratingStr = "#{numLikes} likes, #{numDislikes} dislikes"
    # Try also numeric rating
    elsif reply.body =~ /.*<gd:rating average='([0-9.]*)'.*/
      avgRating = $1
      numRaters = $1 if reply.body =~ /.*numRaters='([0-9]*)'.*/
      valueInTwoDigits = ((rating.to_f * 100).round).to_f / 100
      ratingStr = "#{valueInTwoDigits} (#{numRaters})"
    # Default to unknown
    else
      ratingStr = "unknown"
    end

    views = $1 if reply.body =~ /.*<yt:statistics favoriteCount='[0-9]*' viewCount='([0-9]*)'\/>.*/
    "#{title} (rating: #{ratingStr}, views: #{views})"
  end
end

