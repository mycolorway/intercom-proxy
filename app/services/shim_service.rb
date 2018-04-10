class ShimService < BaseService

  def modified_asset
    modify(fetch_asset)
  end

  def oss_url
    unless redis.exists(redis_key)
      resp = modified_asset
      ex = resp.headers[:cache_control][/(?<=max-age=)\d+(?=,)/].to_i -
           resp.headers[:age].to_i
      redis.set(redis_key, upload(resp), ex: ex)
    end
    redis.get(redis_key)
  end

  private

  def fetch_asset
    resp = RestClient.get("#{CDN_HOST}/shim.#{id}.js")
    raise MissingCdnError, resp unless resp.include?(%("#{CDN_HOST}/"))
    raise ContentTypeError, resp \
      unless 'application/javascript' == resp.headers[:content_type]
    resp
  end

  def modify(resp)
    resp[%("#{CDN_HOST}/")] = %("#{ENV['APP_HOST']}/")
    resp

    # frame_id = resp[/(?<=\+"frame\.)\w+(?=\.js")/]
    # raise 'missing frame_id' if frame_id.blank?
    # resp[%(+"frame.#{frame_id}.js")] = %(+"#{frame_path(frame_id, format: :js)}")
  end

  def upload(resp)
    opts = { headers: resp.headers.slice(:content_type,
                                         :last_modified,
                                         :etag) }
    bucket.put_object(oss_key, opts) { |stream| stream << resp }
    bucket.object_url(oss_key, false)
  end

  def bucket
    @bucket ||= Oss::Factory.new.default_bucket
  end

  def redis_key
    @redis_key ||= "shim_oss_url/#{id}"
  end

  def oss_key
    @oss_key ||= "shims/#{id}.js"
  end

  class MissingCdnError < IntercomResponseError; end
  class ContentTypeError < IntercomResponseError; end

end
