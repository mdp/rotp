module ROTP
  module OptMemCaches
    module_function

    def new(opt_mem_cache = ROTP.config.opt_mem_cache)
      OptMemCaches.const_get(camelize(opt_mem_cache.to_s)).new
    end

    def camelize(str)
      return str if str !~ /_/ && str =~ /[A-Z]+.*/
      str.split('/').map do |e|
        e.split('_').map { |w| w.capitalize }.join
      end.join('::')
    end

    autoload :NullCache, 'rotp/opt_mem_caches/null_cache'
  end
end
