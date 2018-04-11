class ShimService < BaseService

  def modified_asset
    modify(fetch_asset)
  end

  def oss_url
    synchronize("shim_oss_url/#{id}/lock") do
      value = Rails.cache.read(cache_key)
      unless value
        resp = modified_asset
        value = upload(resp)
        Rails.cache.write(cache_key, value, expires_in: ttl_from(resp))
      end
      value
    end
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

  def cache_key
    @cache_key ||= "shim_oss_url/#{id}"
  end

  def oss_key
    @oss_key ||= "shims/#{id}.js"
  end

  def ttl_from(resp)
    resp.headers[:cache_control][/(?<=max-age=)\d+(?=,)/].to_i -
      resp.headers[:age].to_i
  end

  class MissingCdnError < IntercomResponseError; end
  class ContentTypeError < IntercomResponseError; end

end
