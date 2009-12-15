require 'uri'
require 'net/http'

def fetch_uri(uri_str, limit = 10)
  # You should choose better exception.
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

  response = Net::HTTP.get_response(URI.parse(uri_str))
  case response
  when Net::HTTPSuccess     then response
  when Net::HTTPRedirection then fetch_uri(response['location'], limit - 1)
  else
    response.error!
  end
end

def post_uri(uri_str, args = {}, limit = 10)
  # You should choose better exception.
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

  response = Net::HTTP.post_form(URI.parse(uri_str), args)
  case response
  when Net::HTTPSuccess     then response
  when Net::HTTPRedirection then post_uri(response['location'], args, limit - 1)
  else
    response.error!
  end
end
