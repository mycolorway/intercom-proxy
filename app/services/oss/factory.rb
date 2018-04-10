require 'aliyun/oss'

module Oss
  class Factory

    def client(endpoint = ENV['OSS_ENDPOINT'])
      Aliyun::OSS::Client.new(
        endpoint: endpoint,
        access_key_id: ENV['OSS_RAM_AK_ID'],
        access_key_secret: ENV['OSS_RAM_AK_SECRET']
      )
    end

    def default_bucket
      client.get_bucket(ENV['OSS_DEFAULT_BUCKET'])
    end

  end
end
