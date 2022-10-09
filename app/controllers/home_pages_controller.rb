class HomePagesController < ApplicationController
  def index
    render json: "Welcome to my page edit at #{Time.current}", status: 200
  end
end
