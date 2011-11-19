require 'dalli'
require 'cache'
$memcached = ::Cache.wrap ::Dalli::Client.new
require 'cache_method'
::CacheMethod.config.storage = $memcached
$memcached.get 'hello' # force it to authenticate
