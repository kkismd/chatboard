class Slide
  def initialize(url)
    @url = url
  end

  def serial
    Digest::MD5.hexdigest(@url)
  end

  def embed_url
    if slideshare?
      slideshare_embed_url
    elsif googledocs?
      googledocs_embet_url
    else
      raise 'url is not valid'
    end
  end

  require 'open-uri'
  def slideshare_embed_url
    'http://www.slideshare.net/slideshow/embed_code/' + slide_id.to_s
  end

  def slide_id
    query_url = "http://www.slideshare.net/api/oembed/2?url=#{@url}&format=json"
    data = nil
    open(query_url) do |f|
      json = f.read
      data = JSON.parse(json)
    end

    data['slideshow_id'].to_s
  end

  def googledocs_embet_url
    @url.gsub(%r|(https://.*/)edit(#.*)?|) { $1 + 'embed?start=false&loop=false&delayms=60000' }
  end

  SLIDESHARE_PATTERN = %r|\Ahttp://www.slideshare.net/|
  GOOGLEDOCS_PATTERN = %r|\Ahttps://docs.google.com/presentation/|

  def valid?
    # URLとして正当かチェック
    URI.parse(@url)
    @url =~ SLIDESHARE_PATTERN || @url =~ GOOGLEDOCS_PATTERN
  rescue
    false
  end

  def slideshare?
    @url =~ SLIDESHARE_PATTERN
  end

  def googledocs?
    @url =~ GOOGLEDOCS_PATTERN
  end
end