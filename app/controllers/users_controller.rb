class UsersController < ApplicationController
  before_action :authenticate, except: %i[login create]
  before_action :set_viewed, except: %i[index login create]

  def index
    render json: @reader.viewable_users, clean: true
  end

  def login
    user = User.find_by_username(params[:username])
    if !user || !user.authenticate(params[:password])
      head :unauthorized
    else
      render json: user, clean: true
    end
  end

  def create
    user = User.new(params.require(:user)
                          .permit(:username, :password, :password_confirmation))
    change(user)
  end

  def update
    new_vals = params.require(:user).permit(:username, :role, :password,
                                            :password_confirmation)
    if User.roles[new_vals[:role]] > User.roles[@reader.role]
      head :forbidden && return
    end
    @viewed.attributes = new_vals
    change(@viewed)
  end

  def destroy
    @viewed.destroy
    head :ok
  end

  private

  def set_viewed
    @viewed = User.find(params[:id])
    unless @viewed && @reader.can_view_userdata?(@viewed)
      head :forbidden && return
    end
  end

  def change(user)
    if user.save
      render json: user, clean: true
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

end
