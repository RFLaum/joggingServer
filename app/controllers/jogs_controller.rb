class JogsController < ApplicationController
  before_action :authenticate
  before_action :set_owner
  before_action :set_jog, only: %i[update destroy]

  def index
    begin
      jogs = @owner.all_jogs(params[:start_date], params[:end_date])
    rescue ArgumentError
      render json: "invalid date", status: :bad_request && return
    end
    render json: jogs.paginate(params[:page_num], params[:per_page])
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

  def week_count
    render json: @owner.week_count
  end

  # normally returns number of pages, not number of jogs
  # if we want number of jogs, pass per_page = 0
  def jog_count
    begin
      jogs = @owner.jogs_range(params[:start_date], params[:end_date])
    rescue ArgumentError
      render json: "invalid date", status: :bad_request && return
    end
    num_jogs = jogs.count
    per_page = (params[:per_page] || 20).to_f
    render json: per_page == 0 ? num_jogs : (num_jogs / per_page).ceil
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
    params.require(:jog).permit(:date, :time, :distance, :pretty_time,
                                :pretty_distance)
  end

  def change(jog)
    jog.attributes = jog_params
    if jog.save
      render json: jog, timeify: true, methods: :speed
    else
      render json: jog.errors, status: :unprocessable_entity
    end
  end

end
