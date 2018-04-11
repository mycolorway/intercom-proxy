class WidgetService < BaseService

  def shim_path
    synchronize("shim_path/#{id}/lock") do
      Rails.cache.fetch("shim_path/#{id}", expires_in: 10.minutes) do
        build_path
      end
    end
  end

  private

  def build_path
    Rails.application.routes.url_helpers.shim_path(fetch_shim_id, format: :js)
  end

  def fetch_shim_id
    resp = RestClient::Request.execute(method: :get,
                                       url: "#{WIDGET_HOST}/widget/#{id}",
                                       max_redirects: 0)
    raise MissingRedirectError, resp
  rescue RestClient::ExceptionWithResponse => err
    resp = err.response
    location = resp.headers[:location]
    raise MissingLocationError, resp if location.blank?
    location[%r{(?<=https://js.intercomcdn.com/shim\.)\w+(?=\.js)}]
  end

  class MissingRedirectError < IntercomResponseError; end
  class MissingLocationError < IntercomResponseError; end

end
