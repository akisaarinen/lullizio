require 'uri'
require 'net/http'

def fetch(uri_str, limit = 10)
  # You should choose better exception.
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

  response = Net::HTTP.get_response(URI.parse(uri_str))
  case response
  when Net::HTTPSuccess     then response
  when Net::HTTPRedirection then fetch(response['location'], limit - 1)
  else
    response.error!
  end
end

def parseYoutube(url)
  if URI.parse(url).host =~ /.*youtube\.com/
    video = URI.parse(url).query.match(/v=([a-z0-9]*)/)[0][2,15]
    api = "http://gdata.youtube.com/feeds/api/videos/" + video
    print api + "\n"

  reply = fetch(api)
    return "" if (reply.code != "200") 
    
    title = "?"
    rating = "?"
    views = "?"

    title = $1 if reply.body =~ /.*<title type='text'>(.*)<\/title>.*/
    rating = $1 if reply.body =~ /.*<gd:rating average='([0-9.]*)'.*/
    ratingcount = $1 if reply.body =~ /.*numRaters='([0-9]*)'.*/
    views = $1 if reply.body =~ /.*<yt:statistics favoriteCount='[0-9]*' viewCount='([0-9]*)'\/>.*/
    average = ((rating.to_f * 100).round).to_f / 100

    "#{title} (rating: #{average} (#{ratingcount}), views: #{views})"
  else
    ""
  end
end

