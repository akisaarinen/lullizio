require 'htmlentities'
require 'json'

Kernel.load("fetch_uri.rb")

class Module_Spotify
  def init_module(bot) end
  
  def privmsg(bot, from, reply_to, msg)
    msg.split(" ").each { |word|
      if word =~ /^http[s]?:\/\/open.spotify.com\/track\/(.+)/
        reply = requestTrack($1)
        trackName = reply["track"]["name"]
        artists = reply["track"]["artists"]
        artist = artists.map { |a| a["name"] }.join(", ")
        length = reply["track"]["length"]
        mins = (length / 60).to_i
        secs = (length - mins*60).to_i
        album = reply["track"]["album"]["name"]
        year = reply["track"]["album"]["released"]
        reply_str = "Spotify: #{artist} - #{trackName} [#{mins}:#{secs}] (#{year} album #{album})"
        bot.send_privmsg(reply_to, reply_str)
      elsif word =~ /^http[s]?:\/\/open.spotify.com\/artist\/(.+)/
        reply = requestArtist($1)
        artist = reply["artist"]["name"]
        reply_str = "Spotify artist: #{artist}"
        bot.send_privmsg(reply_to, reply_str)
      end
    }
  end

  def botmsg(bot,target,msg) end

  private

  def requestTrack(id) 
      requestSpotifyUri("spotify:track:#{id}")
  end

  def requestArtist(id) 
      requestSpotifyUri("spotify:artist:#{id}")
  end

  def requestSpotifyUri(spotifyUri) 
    uri = "http://ws.spotify.com/lookup/1/.json?uri=#{spotifyUri}"
    puts "Requesting #{uri} from spotify"
    reply = fetch_uri(uri)
    JSON.parse(reply.body)
  end
end

