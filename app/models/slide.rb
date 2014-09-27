require 'open-uri'

class Slide
  def initialize(url)
    @url = url
  end

  def serial
    Digest::MD5.hexdigest(@url)[0, Const::SERIAL_LENGTH]
  end

  def embed_url
    if slideshare?
      slideshare_embed_url
    elsif googledocs?
      googledocs_embed_url
    elsif ustream?
      ustream_embed_url
    else
      raise 'url is not valid'
    end
  end

  def ustream_embed_url
    "http://www.ustream.tv/embed/#{channel_id}?v=3&amp;wmode=direct"
  end

  def channel_id
    USTREAM_PATTERN.match(@url).to_a[0]
  end

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

  def googledocs_embed_url
    @url.gsub(%r|(https://.*/)edit(#.*)?|) { $1 + 'embed?start=false&loop=false&delayms=60000' }
  end

  SLIDESHARE_PATTERN = %r|\Ahttp://www\.slideshare\.net/|
  GOOGLEDOCS_PATTERN = %r|\Ahttps://docs\.google\.com/presentation/|
  USTREAM_PATTERN    = %r|\Ahttp://www\.ustream\.tv/channel/(.+)|

  def valid?
    # URLとして正当かチェック
    URI.parse(@url)
    # パターンマッチ
    @url =~ Regexp.union(SLIDESHARE_PATTERN, GOOGLEDOCS_PATTERN, USTREAM_PATTERN)
  rescue
    false
  end

  def slideshare?
    @url =~ SLIDESHARE_PATTERN
  end

  def googledocs?
    @url =~ GOOGLEDOCS_PATTERN
  end

  def ustream?
    @url =~ USTREAM_PATTERN
  end
end