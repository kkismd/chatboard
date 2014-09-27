class RoomsController < ApplicationController
  def top

  end

  # GET /rooms
  def index
    @serial = new_serial_string
    @mb_url = url_for(action: :mb_show, serial: @serial)
    @qr = RQRCode::QRCode.new(@mb_url, size: Const::QR_SIZE)

    render :action => 'show'
  end

  # GET /rooms/:serial
  def show
    @serial = params[:id]
    unless valid_serial? @serial
      return render text: ''
    end

    @mb_url = url_for(action: :mb_show, serial: @serial, tag: '')
    @qr = RQRCode::QRCode.new(@mb_url, size: Const::QR_SIZE)
  end

  def slide
    @slide = Slide.new(params[:url])
    return redirect_to root_path unless @slide.valid?

    @serial = @slide.serial
    @tag = with_sharp(params[:tag])
    @mb_url = url_for(action: :mb_show, serial: @serial, tag: @tag)
    @qr = RQRCode::QRCode.new(@mb_url, size: Const::QR_SIZE)
    render action: :show
  end

  # GET /rooms/mb/:serial/:tag
  def mb_show
    return render :text => 'hmhm' unless valid_serial? params[:serial]

    session[:serial] = @serial = params[:serial]
    session[:tag]    = @tag    = with_sharp(params[:tag])
  end

  def mb_post
    serial = params[:serial]
    unless valid_serial?(serial)
      return render :text => ''
    end

    event = 'comment'
    comment = params[:comment]
    color = params[:color]
    tag = params[:tag].presence || ''
    comments = comment.split(/\r\n|\r|\n/)
    data = {comments: comments, color: color}

    if comment.present?
      Pusher.trigger(serial, event, data)
      twitter_client.update("#{comment} #{tag}") if session[:access_token]
    end
    redirect_to url_for(action: :mb_show, serial: serial, tag: tag)
  end

  private

  def valid_serial?(str)
    str =~ /[0-9a-f]{#{Const::SERIAL_LENGTH}}/ || str == 'TESTROOM'
  end

  def new_serial_string
    SecureRandom.hex(Const::SERIAL_BYTES)
  end

  def twitter_client
    Twitter::Client.new(
        oauth_token: session[:access_token],
        oauth_token_secret: session[:token_secret]
    )
  end

  def with_sharp(hash_tag)
    return '' if hash_tag.blank?

    result = hash_tag.strip
    if result.start_with?('#')
      result
    else
      '#' + result
    end
  end
end
