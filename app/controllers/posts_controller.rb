class PostsController < ApplicationController
  def index
    render json: { data: "List Post" }, status: 200
  end
end
