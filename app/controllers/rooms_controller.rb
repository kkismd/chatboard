class RoomsController < ApplicationController
  def top

  end

  # GET /rooms
  def index
    @serial = new_serial_string
    url = url_for(:action => :mb_show, :serial => @serial)
    @qr = RQRCode::QRCode.new(url, size:8)

    render :action => 'show'
  end

  # GET /rooms/:serial
  def show
    @serial = params[:id]
    unless valid_serial? @serial
      return render text: ''
    end

    url = url_for(:action => :mb_show, :serial => @serial)
    @qr = RQRCode::QRCode.new(url, size:8)
  end

  def slide
    @slide = Slide.new(params[:url])
    return redirect_to root_path unless @slide.valid?

    @serial = @slide.serial
    url = url_for(:action => :mb_show, :serial => @serial)
    @qr = RQRCode::QRCode.new(url, size:8)

    render action: :show
  end

  # GET /rooms/mb/:serial
  def mb_show
    @serial = params[:serial]
    session[:serial] = @serial
    render :text => 'hmhm' unless valid_serial? @serial
  end

  def mb_post
    serial = params[:serial]
    unless valid_serial?(serial)
      return render :text => ''
    end

    event = 'comment'
    channel = params[:serial]
    comments = params[:comment].split(/\r\n|\r|\n/)
    color = params[:color]
    data = {comments: comments, color: color}

    if params[:comment].present?
      Pusher.trigger(channel, event, data)
      twitter_client.update(params[:comment]) if session[:access_token]
    end
    redirect_to :action => :mb_show, :serial => params[:serial]
  end

  private

  def valid_serial?(str)
    str =~ /[0-9a-f]{32}/ || str == 'TESTROOM'
  end

  def new_serial_string
    SecureRandom.hex
  end

  def twitter_client
    Twitter::Client.new(
        oauth_token: session[:access_token],
        oauth_token_secret: session[:token_secret]
    )
  end
end
