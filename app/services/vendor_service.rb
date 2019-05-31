class VendorService < BaseService

  def fetch_asset
    RestClient.get("#{CDN_HOST}/vendor.#{id}.js")
  end

  def oss_url
    synchronize("vendor_oss_url/#{id}/lock") do
      value = Rails.cache.read(cache_key)
      unless value
        resp = fetch_asset
        value = upload(resp)
        Rails.cache.write(cache_key, value, expires_in: ttl_from(resp))
      end
      value
    end
  end

  private

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
    @cache_key ||= "vendor_oss_url/#{id}"
  end

  def oss_key
    @oss_key ||= "vendors/#{id}.js"
  end

  def ttl_from(resp)
    resp.headers[:cache_control][/(?<=max-age=)\d+(?=,)/].to_i -
      resp.headers[:age].to_i
  end

end
