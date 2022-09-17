class HomePagesController < ApplicationController
  def index
    render json: "Welcome to my page", status: 200
  end
end
