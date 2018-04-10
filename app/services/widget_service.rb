class WidgetService < BaseService

  def shim_path
    redis.set(redis_key, build_path, ex: 10.minute) \
      unless redis.exists(redis_key)
    redis.get(redis_key)
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

  def redis_key
    @redis_key ||= "shim_path/#{id}"
  end

  class MissingRedirectError < IntercomResponseError; end
  class MissingLocationError < IntercomResponseError; end

end
