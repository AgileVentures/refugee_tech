require 'childprocess'
require 'timeout'
require 'httparty'

# Start the app
server = ChildProcess.build('rackup', '--port', '9999')
server.start

# Wait a bit until it is has fired up...
Timeout.timeout(3) do
  loop do
    begin
      HTTParty.get('http://localhost:9999')
      break
    rescue Errno::ECONNREFUSED =>
        try_again
      sleep 0.1
    end
  end
end

# Stop the app when all the tests finish
at_exit do
  server.stop
end
