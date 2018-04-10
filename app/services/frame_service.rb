class FrameService < BaseService

  def fetch_asset
    RestClient.get("#{CDN_HOST}/frame.#{id}.js")
  end

  def oss_url
    unless redis.exists(redis_key)
      resp = fetch_asset
      ex = resp.headers[:cache_control][/(?<=max-age=)\d+(?=,)/].to_i -
           resp.headers[:age].to_i
      redis.set(redis_key, upload(resp), ex: ex)
    end
    redis.get(redis_key)
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

  def redis_key
    @redis_key ||= "frame_oss_url/#{id}"
  end

  def oss_key
    @oss_key ||= "frames/#{id}.js"
  end

end
