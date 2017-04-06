require_relative '../json_service.rb'

module Serialization
  module JSONAPI
    module Helpers
      def serialized_data(model, serializer_klass = nil)
        if !serializer_klass
          serializer_klass = ActiveModel::Serializer.serializer_for(model)
        end

        serializer = serializer_klass.new(model)
        adapter = ActiveModelSerializers::Adapter::JsonApi.new(serializer)
        adapter.as_json
      end

      def jsonapi_attributes(data)
        data.dig(:data, :attributes)
      end

      def jsonapi_links(data)
        data.dig(:data, :links)
      end

      def jsonapi_relationships(data)
        data.dig(:data, :relationships)
      end
    end

    module Assertions
      def assert_ids(ids, json_array, id_key = :id)
        actual_ids = json_array.map { |rec| rec.fetch(id_key).to_s }
        assert_equal ids.map(&:to_s).sort, actual_ids.sort
      end
    end
  end
end
