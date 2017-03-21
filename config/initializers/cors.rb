cors_origins = ( ENV['CORS_ORIGINS'] ?
                   Regexp.new(ENV['CORS_ORIGINS']) : '*' )

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins cors_origins
    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
