module Config
  def self.apiHost
    @apiHost = ENV['IP'] || 'localhost'
  end

  def self.apiPort
    @apiPort = ENV['PORT'] || '9999'
  end

  def self.apiUri
    @apiUri = "http://#{apiHost}:#{apiPort}"
  end

end