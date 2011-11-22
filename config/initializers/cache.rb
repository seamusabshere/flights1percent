if Rails.env.production?
  require 'dalli'
  require 'cache'
  $memcached = ::Cache.wrap ::Dalli::Client.new
  require 'cache_method'
  ::CacheMethod.config.storage = $memcached
end
::CacheMethod.config.generational = false
