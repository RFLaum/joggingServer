class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  def authenticate
    reader = authenticate_with_http_basic do |name, pass|
      user = User.find_by_username(name)
      user && user.authenticate(pass)
    end
    if reader
      @reader = reader
    else
      request_http_basic_authentication
    end
  end
end
