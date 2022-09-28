class HomePagesController < ApplicationController
  def index
    render json: "Welcome to my page edit", status: 200
  end
end
