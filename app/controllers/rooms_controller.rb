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

  # GET /rooms/mb/:serial
  def mb_show
    @serial = params[:serial]
    render :text => '' unless valid_serial? @serial
  end

  def mb_post
    serial = params[:serial]
    unless valid_serial?(serial)
      render :text => ''
      return
    end

    event = 'comment'
    channel = params[:serial]

    comments = params[:comment].split(/\r\n|\r|\n/)

    Pusher.trigger(channel, event, {comments: comments}) if params[:comment].present?
    redirect_to :action => :mb_show, :serial => params[:serial]
  end

  private

  def valid_serial?(str)
    str =~ /[0-9a-f]{32}/ || str == 'TESTROOM'
  end

  def new_serial_string
    SecureRandom.hex
  end

end
