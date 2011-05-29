require 'uri'
require 'net/http'

Kernel.load('fetch_uri.rb')

class Module_Youtube
  def init_module(bot) end
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /youtube.com\/watch?/
        youtube_title = parseYoutube(word)
        bot.send_privmsg(reply_to, youtube_title)
      end
    }
  end
  def botmsg(bot,target,msg) end

  private

  def parseYoutube(url)
    if URI.parse(url).host =~ /.*youtube\.com/
      video = URI.parse(url).query.match(/v=([^ &]*)/)[0][2,15]
      api = "http://gdata.youtube.com/feeds/api/videos/" + video + "?v=2"
      print api + "\n"

      reply = fetch_uri(api)
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
    else
      ""
    end
  end
end

