class TestsController < ApplicationController
  before_action :set_user

  def test1
    render json: @user.all_jogs
  end

  def test2
    render json: @user.jogs.first, timeify: true

    # render json: @user.all_jogs
    # logger.debug jogs.keys
    # render json: jogs
    # answer = @user.all_jogs
    # # logger.debug answer
    # answer.each do |jog|
    #   logger.debug jog.to_s
    # end
    # render json: answer
    # render json: @user.jogs
  end

  def test3
    render json: @user.week_count
    # @weeks = @user.week_list
  end

  def post_test
    logger.debug "post test"
    logger.debug params
    render json: 0
  end

  private

  def set_user
    @user = User.find_by_username("russell")
  end
end
