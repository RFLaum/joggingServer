class UsersController < ApplicationController
  def test
    # test_data = User.find_by_username("russell").week_list
    # render json: test_data, except: :id
    # render json: User.find_by_username("russell").jogs, clean: true
    render json: User.all
  end

  def login
    head :bad_request
  end
end
