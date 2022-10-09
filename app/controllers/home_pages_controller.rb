class HomePagesController < ApplicationController
  def index
    render json: "Update code #{Time.current}", status: 200
  end
end
