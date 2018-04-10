class FramesController < ApplicationController

  def show
    render js: RestClient.get("https://js.intercomcdn.com/frame.#{params[:id]}.js")
  end

end
