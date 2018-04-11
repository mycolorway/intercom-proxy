class BaseService
  attr_reader :id

  WIDGET_HOST = 'https://widget.intercom.io'.freeze
  CDN_HOST = 'https://js.intercomcdn.com'.freeze

  def initialize(id)
    @id = id
  end

  private

  # def redis
  #   Rails.configuration.redis
  # end

  def synchronize(scope, &block)
    Rails.cache.dalli.with do |dalli|
      RemoteLock.new(RemoteLock::Adapters::Memcached.new(dalli))\
                .synchronize(scope, &block)
    end
  end
end
