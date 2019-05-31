class VendorsController < ApplicationController

  def show
    service = VendorService.new(params[:id])
    if ENV['OSS_RAM_AK_SECRET'].present?
      redirect_to service.oss_url, status: :moved_permanently
    else
      render js: service.fetch_asset
    end
  end

end
