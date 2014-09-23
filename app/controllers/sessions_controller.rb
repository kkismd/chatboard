class SessionsController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']
    last_serial = session[:serial]
    reset_session
    session[:uid] = auth['uid']
    session[:access_token] = auth[:credentials][:token]
    session[:token_secret] = auth[:credentials][:secret]
    redirect_to "#{mb_rooms_path}/#{last_serial}"
  end

  def destroy
    serial = params[:serial]
    if serial !~ /\A[a-f0-9]+\z/
      return head :bad_request
    end
    session[:uid] = nil
    session[:access_token] = nil
    session[:token_secret] = nil
    reset_session
    redirect_to "#{mb_rooms_path}/#{serial}"
  end
end
