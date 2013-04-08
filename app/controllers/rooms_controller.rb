class RoomsController < ApplicationController
  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rooms }
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @room = Room.find(params[:id])
    url = url_for(:action => :mb_show, :serial => @room.serial)
    @qr = RQRCode::QRCode.new(url, size:8)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/mb/:serial
  def mb_show
    @room = Room.where(:serial => params[:serial])
    unless @room
      render :text => ''
      return
    end
  end

  # GET /rooms/new
  # GET /rooms/new.json
  def new
    @room = Room.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/1/edit
  def edit
    @room = Room.find(params[:id])
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(params[:room])
    @room.serial ||= new_serial_string

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render json: @room, status: :created, location: @room }
      else
        format.html { render action: "new" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rooms/1
  # PUT /rooms/1.json
  def update
    @room = Room.find(params[:id])

    respond_to do |format|
      if @room.update_attributes(params[:room])
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room = Room.find(params[:id])
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { head :no_content }
    end
  end

  def mb_post
    serial = params[:serial]
    unless valid_serial?(serial)
      render :text => ''
      return
    end

    Pusher.app_id = Settings.pusher.app_id
    Pusher.key = Settings.pusher.key
    Pusher.secret = Settings.pusher.secret
    event = 'comment'
    channel = params[:serial]

    comments = params[:comment].split(/\r\n|\r|\n/)

    Pusher.trigger(channel, event, {comments: comments}) if params[:comment].present?
    redirect_to :action => :mb_show, :serial => params[:serial]
  end

  private

  def valid_serial?(str)
    str =~ /[0-9a-f]{32}/
  end

  def new_serial_string
    Digest::MD5.hexdigest(SecureRandom.random_bytes)
  end
end
