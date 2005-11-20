# never expire cache, based on http://typo.leetsoft.com/trac.cgi/file/trunk/app/models/simple_cache.rb

class NeverExpireCache < Hash  
  class Item
    attr_reader :value
    def initialize(value)
      @value = value
    end
  end
      
  def [](key)
    item = super(key)
    if item.nil?
      logger.info(" NeverExpireCache: miss on #{key}")
      nil
    else
      logger.debug("  NeverExpireCache: hit on #{key}")
      item.value
    end
  end

  def []=(key, value)
    logger.info("  NeverExpireCache: store on #{key}")
    super(key, Item.new(value))
    value
  end
  
  def logger
    @logger ||= RAILS_DEFAULT_LOGGER || Logger.new(STDOUT)
  end
end
