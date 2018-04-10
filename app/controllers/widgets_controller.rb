class WidgetsController < ApplicationController

  def show
    redirect_to WidgetService.new(params[:id]).shim_path
  end

end
