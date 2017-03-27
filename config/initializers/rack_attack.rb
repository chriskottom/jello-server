# Throttle 10 requests/ip/second
Rack::Attack.throttle("req/ip", :limit => 10, :period => 1.second) do |req|
  req.ip
end
