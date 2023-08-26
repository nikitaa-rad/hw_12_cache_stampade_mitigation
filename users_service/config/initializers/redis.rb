module RedisConnection
  def self.master
    @master ||= Redis.new(url: ENV['REDIS_MASTER_URL'])
  end

  def self.slave
    @slave ||= Redis.new(url: ENV['REDIS_SLAVE_URL'])
  end
end
