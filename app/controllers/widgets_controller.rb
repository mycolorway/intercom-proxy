class WidgetsController < ApplicationController

  def show
    RestClient::Request.execute(method: :get,
                                url: "https://widget.intercom.io/widget/#{params[:id]}",
                                max_redirects: 0)
    raise 'no redirect detected'
  rescue RestClient::ExceptionWithResponse => err
    resp = err.response
    raise 'missing location' unless (location = resp.headers[:location]).present?
    shim_id = location[%r{(?<=https://js.intercomcdn.com/shim\.)\w+(?=\.js)}]
    redirect_to shim_path(shim_id, format: :js)
  end

end
