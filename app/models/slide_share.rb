class SlideShare
  def initialize(url)
    @url = url
  end

  def slide_id

  end

  def valid?
    @url =~ %r|\Ahttp://www.slideshare.net/|
  end
end