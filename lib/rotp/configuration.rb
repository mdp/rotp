module ROTP
  class Configuration
    attr_accessor :opt_mem_cache, :opt_mem_cache_conf

    def initialize
      @opt_mem_cache = :null_cache
      @opt_mem_cache_conf = {}
    end
  end
end
