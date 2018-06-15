class JogsController < ApplicationController
  before_action :authenticate
  before_action :set_owner
  before_action :set_jog, only: %i[update destroy]

  def index
    jogs = @viewed.jogs.order(date: :desc)
    render json: jogs.paginate(params[:page_num], params[:per_page]), timeify: true
  end

  def create
    change(Jog.new(user: @owner))
  end

  def update
    change(@jog)
  end

  def destroy
    @jog.destroy
    head :ok
  end

  def week_list
    render json: @owner.week_list.paginate(params[:page_num], params[:per_page])
  end

  def jog_count
    render json: @viewed.jogs.count
  end

  private

  def set_owner
    @owner = User.find(params[:user_id])
    unless @owner && @reader.can_view_jogs?(@owner)
      head :forbidden && return
    end
  end

  def set_jog
    @jog = Jog.find(params[:id])
    head :not_found && return unless @jog
  end

  def jog_params
    params.require(:jog).permit(:date, :time, :distance)
  end

  def change(jog)
    jog.attributes = jog_params
    if jog.save
      render json: jog, timeify: true
    else
      render json: jog.errors, status: :unprocessable_entity
    end
  end

end
