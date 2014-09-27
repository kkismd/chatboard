class SessionsController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']
    last_serial = session[:serial]
    last_tag = session[:tag]
    reset_session
    session[:uid] = auth['uid']
    session[:access_token] = auth[:credentials][:token]
    session[:token_secret] = auth[:credentials][:secret]
    redirect_to url_for(controller: :rooms, action: :mb_show, serial: last_serial, tag: last_tag)
  end

  def destroy
    serial = session[:serial]
    tag = session[:tag]
    if serial !~ /\A[a-f0-9]+\z/
      return head :bad_request
    end
    session[:uid] = nil
    session[:access_token] = nil
    session[:token_secret] = nil
    reset_session
    redirect_to url_for(controller: :rooms, action: :mb_show, serial: serial, tag: tag)
  end
end
