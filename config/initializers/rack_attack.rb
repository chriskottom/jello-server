# Throttle 10 requests/ip/second
Rack::Attack.throttle("req/ip", :limit => 10, :period => 1.second) do |req|
  req.ip
end

# Whitelist localhost for any number of requests.
Rack::Attack.safelist 'allow localhost' do |req|
  '127.0.0.1' == req.ip || '::1' == req.ip
end

# Customize the response delivered to rate limited clients.
Rack::Attack.throttled_response = ->(env) {
  status_code = 429
  now = Time.now
  match_data = env['rack.attack.match_data'] || {}
  retry_after = match_data[:period] - now.to_i % match_data[:period]

  headers = {
    'Content-Type' => 'application/json',
    'Retry-After' => retry_after.to_s,
    'X-RateLimit-Limit' => match_data[:limit].to_s,
    'X-RateLimit-Remaining' => '0',
    'X-RateLimit-Reset' => (now + retry_after).to_s
  }

  body = {
    error: {
      status: status_code,
      name: "Too Many Requests",
      message: "Throttle limit reached. Retry later."
    }
  }

  [ status_code, headers, [body.to_json] ]
}
