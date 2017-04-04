module JSONAPI
  module Rendering
    JSONAPI_RENDER_OPTS = {
      content_type: 'application/vnd.api+json',
      adapter: :json_api
    }

    def render(*args)
      if args.first.is_a?(Hash)
        args.first.reverse_merge!(JSONAPI_RENDER_OPTS)
      end
      super *args
    end
  end
end
